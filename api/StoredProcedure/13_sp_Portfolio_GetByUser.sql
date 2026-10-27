-- Replaces PortfolioRepository.GetUserPortfolio. Returns the stocks in the user's portfolio.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Portfolio_GetByUser$$

CREATE PROCEDURE sp_Portfolio_GetByUser(
    IN p_AppUserId VARCHAR(255)
)
BEGIN
    SELECT s.Id, s.Symbol, s.CompanyName, s.Purchase, s.LastDiv, s.Industry, s.MarketCap
    FROM Portfolios AS p
    INNER JOIN Stocks AS s ON s.Id = p.StockId
    WHERE p.AppUserId = p_AppUserId;
END$$

DELIMITER ;
