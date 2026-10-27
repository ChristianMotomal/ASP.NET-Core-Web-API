-- Replaces CommentRepository.UpdateAsync (only Title and Content change).
-- Returns the updated comment without author data (the original query did not load AppUser),
-- or no rows when it does not exist.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Comment_Update$$

CREATE PROCEDURE sp_Comment_Update(
    IN p_Id INT,
    IN p_Title TEXT,
    IN p_Content TEXT
)
BEGIN
    UPDATE Comments
    SET Title = p_Title,
        Content = p_Content
    WHERE Id = p_Id;

    SELECT c.Id, c.Title, c.Content, c.CreatedOn, c.StockId, c.AppUserId
    FROM Comments AS c
    WHERE c.Id = p_Id;
END$$

DELIMITER ;
