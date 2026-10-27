-- Replaces StockRepository.CreateAsync. Returns the new AUTO_INCREMENT id through p_Id.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Stock_Create$$

CREATE PROCEDURE sp_Stock_Create(
    IN p_Symbol TEXT,
    IN p_CompanyName TEXT,
    IN p_Purchase DECIMAL(18,2),
    IN p_LastDiv DECIMAL(18,2),
    IN p_Industry TEXT,
    IN p_MarketCap BIGINT,
    OUT p_Id INT
)
BEGIN
    INSERT INTO Stocks (Symbol, CompanyName, Purchase, LastDiv, Industry, MarketCap)
    VALUES (p_Symbol, p_CompanyName, p_Purchase, p_LastDiv, p_Industry, p_MarketCap);

    SET p_Id = LAST_INSERT_ID();
END$$

DELIMITER ;
