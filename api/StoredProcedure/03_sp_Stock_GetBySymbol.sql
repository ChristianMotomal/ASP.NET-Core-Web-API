-- Replaces StockRepository.GetBySymbolAsync.
-- Matching follows the column collation (utf8mb4_0900_ai_ci: case-insensitive).

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Stock_GetBySymbol$$

CREATE PROCEDURE sp_Stock_GetBySymbol(
    IN p_Symbol TEXT
)
BEGIN
    SELECT s.Id, s.Symbol, s.CompanyName, s.Purchase, s.LastDiv, s.Industry, s.MarketCap
    FROM Stocks AS s
    WHERE s.Symbol = p_Symbol
    LIMIT 1;
END$$

DELIMITER ;
