-- Replaces StockRepository.UpdateAsync.
-- Returns the updated stock, or no rows when it does not exist.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Stock_Update$$

CREATE PROCEDURE sp_Stock_Update(
    IN p_Id INT,
    IN p_Symbol TEXT,
    IN p_CompanyName TEXT,
    IN p_Purchase DECIMAL(18,2),
    IN p_LastDiv DECIMAL(18,2),
    IN p_Industry TEXT,
    IN p_MarketCap BIGINT
)
BEGIN
    UPDATE Stocks
    SET Symbol = p_Symbol,
        CompanyName = p_CompanyName,
        Purchase = p_Purchase,
        LastDiv = p_LastDiv,
        Industry = p_Industry,
        MarketCap = p_MarketCap
    WHERE Id = p_Id;

    SELECT s.Id, s.Symbol, s.CompanyName, s.Purchase, s.LastDiv, s.Industry, s.MarketCap
    FROM Stocks AS s
    WHERE s.Id = p_Id;
END$$

DELIMITER ;
