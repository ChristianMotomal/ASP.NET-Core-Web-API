-- Replaces PortfolioRepository.CreateAsync.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Portfolio_Create$$

CREATE PROCEDURE sp_Portfolio_Create(
    IN p_AppUserId VARCHAR(255),
    IN p_StockId INT
)
BEGIN
    INSERT INTO Portfolios (AppUserId, StockId)
    VALUES (p_AppUserId, p_StockId);
END$$

DELIMITER ;
