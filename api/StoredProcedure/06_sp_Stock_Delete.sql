-- Replaces StockRepository.DeleteAsync.
-- Returns the deleted stock, or no rows when it does not exist.
-- Portfolios rows cascade; a stock that still has comments fails with error 1451
-- (FK_Comments_Stocks_StockId), the same as the original EF Core delete.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Stock_Delete$$

CREATE PROCEDURE sp_Stock_Delete(
    IN p_Id INT
)
BEGIN
    DECLARE v_Symbol LONGTEXT;
    DECLARE v_CompanyName LONGTEXT;
    DECLARE v_Purchase DECIMAL(18,2);
    DECLARE v_LastDiv DECIMAL(18,2);
    DECLARE v_Industry LONGTEXT;
    DECLARE v_MarketCap BIGINT;

    DECLARE CONTINUE HANDLER FOR NOT FOUND BEGIN END;

    SELECT s.Symbol, s.CompanyName, s.Purchase, s.LastDiv, s.Industry, s.MarketCap
    INTO v_Symbol, v_CompanyName, v_Purchase, v_LastDiv, v_Industry, v_MarketCap
    FROM Stocks AS s
    WHERE s.Id = p_Id;

    DELETE FROM Stocks WHERE Id = p_Id;

    IF ROW_COUNT() > 0 THEN
        SELECT p_Id AS Id, v_Symbol AS Symbol, v_CompanyName AS CompanyName, v_Purchase AS Purchase,
               v_LastDiv AS LastDiv, v_Industry AS Industry, v_MarketCap AS MarketCap;
    END IF;
END$$

DELIMITER ;
