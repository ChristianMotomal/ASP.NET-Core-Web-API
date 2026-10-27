-- Replaces StockRepository.StockExists. Returns one row: StockExists = 1 or 0.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Stock_Exists$$

CREATE PROCEDURE sp_Stock_Exists(
    IN p_Id INT
)
BEGIN
    SELECT EXISTS (SELECT 1 FROM Stocks WHERE Id = p_Id) AS StockExists;
END$$

DELIMITER ;
