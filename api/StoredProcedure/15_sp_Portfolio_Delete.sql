-- Replaces PortfolioRepository.DeletePortfolio.
-- Removes one portfolio entry of the user whose stock symbol matches case-insensitively.
-- Returns the deleted (AppUserId, StockId), or no rows when nothing matched.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Portfolio_Delete$$

CREATE PROCEDURE sp_Portfolio_Delete(
    IN p_AppUserId VARCHAR(255),
    IN p_Symbol TEXT
)
BEGIN
    DECLARE v_StockId INT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND BEGIN END;

    SELECT p.StockId
    INTO v_StockId
    FROM Portfolios AS p
    INNER JOIN Stocks AS s ON s.Id = p.StockId
    WHERE p.AppUserId = p_AppUserId
      AND LOWER(s.Symbol) = LOWER(p_Symbol)
    LIMIT 1;

    IF v_StockId IS NOT NULL THEN
        DELETE FROM Portfolios
        WHERE AppUserId = p_AppUserId AND StockId = v_StockId;

        IF ROW_COUNT() > 0 THEN
            SELECT p_AppUserId AS AppUserId, v_StockId AS StockId;
        END IF;
    END IF;
END$$

DELIMITER ;
