-- Replaces CommentRepository.DeleteAsync.
-- Returns the deleted comment, or no rows when it does not exist.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Comment_Delete$$

CREATE PROCEDURE sp_Comment_Delete(
    IN p_Id INT
)
BEGIN
    DECLARE v_Title LONGTEXT;
    DECLARE v_Content LONGTEXT;
    DECLARE v_CreatedOn DATETIME(6);
    DECLARE v_StockId INT;
    DECLARE v_AppUserId VARCHAR(255);

    DECLARE CONTINUE HANDLER FOR NOT FOUND BEGIN END;

    SELECT c.Title, c.Content, c.CreatedOn, c.StockId, c.AppUserId
    INTO v_Title, v_Content, v_CreatedOn, v_StockId, v_AppUserId
    FROM Comments AS c
    WHERE c.Id = p_Id;

    DELETE FROM Comments WHERE Id = p_Id;

    IF ROW_COUNT() > 0 THEN
        SELECT p_Id AS Id, v_Title AS Title, v_Content AS Content, v_CreatedOn AS CreatedOn,
               v_StockId AS StockId, v_AppUserId AS AppUserId;
    END IF;
END$$

DELIMITER ;
