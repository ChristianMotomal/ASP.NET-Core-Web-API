-- Replaces CommentRepository.GetByIdAsync. Returns the comment with its author's UserName.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Comment_GetById$$

CREATE PROCEDURE sp_Comment_GetById(
    IN p_Id INT
)
BEGIN
    SELECT c.Id, c.Title, c.Content, c.CreatedOn, c.StockId, c.AppUserId, u.UserName
    FROM Comments AS c
    INNER JOIN AspNetUsers AS u ON u.Id = c.AppUserId
    WHERE c.Id = p_Id
    LIMIT 1;
END$$

DELIMITER ;
