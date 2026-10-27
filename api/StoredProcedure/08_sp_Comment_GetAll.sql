-- Replaces CommentRepository.GetAllAsync.
-- p_Symbol NULL = all comments; otherwise only comments whose stock has that symbol.
-- p_IsDescending = 1 sorts newest first; 0 leaves the order unspecified, as before.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_Comment_GetAll$$

CREATE PROCEDURE sp_Comment_GetAll(
    IN p_Symbol TEXT,
    IN p_IsDescending TINYINT(1)
)
BEGIN
    SELECT c.Id, c.Title, c.Content, c.CreatedOn, c.StockId, c.AppUserId, u.UserName
    FROM Comments AS c
    INNER JOIN AspNetUsers AS u ON u.Id = c.AppUserId
    LEFT JOIN Stocks AS s ON s.Id = c.StockId
    WHERE p_Symbol IS NULL OR s.Symbol = p_Symbol
    ORDER BY CASE WHEN p_IsDescending = 1 THEN c.CreatedOn END DESC;
END$$

DELIMITER ;
