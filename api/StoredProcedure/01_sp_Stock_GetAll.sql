-- Replaces StockRepository.GetAllAsync.
-- Optional CompanyName/Symbol "contains" filters (NULL = no filter), optional sort by Symbol,
-- then OFFSET/LIMIT paging. Returns two result sets:
--   1. the page of stocks, in page order
--   2. the comments of those stocks, with the author's UserName
-- Requires the CREATE TEMPORARY TABLES privilege.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Stock_GetAll$$

CREATE PROCEDURE sp_Stock_GetAll(
    IN p_CompanyName TEXT,
    IN p_Symbol TEXT,
    IN p_SortBy VARCHAR(50),
    IN p_IsDescending TINYINT(1),
    IN p_PageNumber INT,
    IN p_PageSize INT
)
BEGIN
    DECLARE v_Skip INT;
    DECLARE v_SortBySymbol TINYINT(1);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        DROP TEMPORARY TABLE IF EXISTS tmp_StockPage;
        RESIGNAL;
    END;

    SET v_Skip = (p_PageNumber - 1) * p_PageSize;

    IF v_Skip < 0 OR p_PageSize < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'PageNumber must be at least 1 and PageSize cannot be negative.';
    END IF;

    SET v_SortBySymbol = IFNULL(CAST(LOWER(p_SortBy) AS BINARY) = CAST('symbol' AS BINARY), 0);

    DROP TEMPORARY TABLE IF EXISTS tmp_StockPage;
    CREATE TEMPORARY TABLE tmp_StockPage (
        RowNum INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        StockId INT NOT NULL
    );

    INSERT INTO tmp_StockPage (StockId)
    SELECT s.Id
    FROM Stocks AS s
    WHERE (p_CompanyName IS NULL OR LOCATE(p_CompanyName, s.CompanyName) > 0)
      AND (p_Symbol IS NULL OR LOCATE(p_Symbol, s.Symbol) > 0)
    ORDER BY
        CASE WHEN v_SortBySymbol = 1 AND p_IsDescending = 0 THEN s.Symbol END ASC,
        CASE WHEN v_SortBySymbol = 1 AND p_IsDescending = 1 THEN s.Symbol END DESC
    LIMIT v_Skip, p_PageSize;

    SELECT s.Id, s.Symbol, s.CompanyName, s.Purchase, s.LastDiv, s.Industry, s.MarketCap
    FROM tmp_StockPage AS p
    INNER JOIN Stocks AS s ON s.Id = p.StockId
    ORDER BY p.RowNum;

    SELECT c.Id, c.Title, c.Content, c.CreatedOn, c.StockId, c.AppUserId, u.UserName
    FROM tmp_StockPage AS p
    INNER JOIN Comments AS c ON c.StockId = p.StockId
    INNER JOIN AspNetUsers AS u ON u.Id = c.AppUserId
    ORDER BY p.RowNum, c.Id;

    DROP TEMPORARY TABLE IF EXISTS tmp_StockPage;
END$$

DELIMITER ;
