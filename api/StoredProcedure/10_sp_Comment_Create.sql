-- Replaces CommentRepository.CreateAsync. Returns the new AUTO_INCREMENT id through p_Id.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Comment_Create$$

CREATE PROCEDURE sp_Comment_Create(
    IN p_Title TEXT,
    IN p_Content TEXT,
    IN p_CreatedOn DATETIME(6),
    IN p_StockId INT,
    IN p_AppUserId VARCHAR(255),
    OUT p_Id INT
)
BEGIN
    INSERT INTO Comments (Title, Content, CreatedOn, StockId, AppUserId)
    VALUES (p_Title, p_Content, p_CreatedOn, p_StockId, p_AppUserId);

    SET p_Id = LAST_INSERT_ID();
END$$

DELIMITER ;
