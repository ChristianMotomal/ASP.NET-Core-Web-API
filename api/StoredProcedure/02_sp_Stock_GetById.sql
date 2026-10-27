-- Replaces StockRepository.GetByIdAsync.
-- Returns two result sets:
--   1. the stock (no rows when it does not exist)
--   2. its comments, without author data (the original query did not load AppUser)

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Stock_GetById$$

CREATE PROCEDURE sp_Stock_GetById(
    IN p_Id INT
)
BEGIN
    SELECT s.Id, s.Symbol, s.CompanyName, s.Purchase, s.LastDiv, s.Industry, s.MarketCap
    FROM Stocks AS s
    WHERE s.Id = p_Id
    LIMIT 1;

    SELECT c.Id, c.Title, c.Content, c.CreatedOn, c.StockId, c.AppUserId
    FROM Comments AS c
    WHERE c.StockId = p_Id
    ORDER BY c.Id;
END$$

DELIMITER ;
