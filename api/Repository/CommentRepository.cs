using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using api.Data;
using api.Helpers;
using api.Interfaces;
using api.Models;
using MySql.Data.MySqlClient;

namespace api.Repository
{
    public class CommentRepository : ICommentRepository
    {
        private readonly ApplicationDBContext _context;
        public CommentRepository(ApplicationDBContext context)
        {
            _context = context;
        }

        public async Task<Comment> CreateAsync(Comment commentModel)
        {
            var id = StoredProcedures.Out("p_Id", MySqlDbType.Int32);

            await _context.Database.ExecuteStoredProcedureAsync("sp_Comment_Create",
                StoredProcedures.In("p_Title", commentModel.Title),
                StoredProcedures.In("p_Content", commentModel.Content),
                StoredProcedures.In("p_CreatedOn", commentModel.CreatedOn),
                StoredProcedures.In("p_StockId", commentModel.StockId),
                StoredProcedures.In("p_AppUserId", commentModel.AppUserId),
                id);

            commentModel.Id = Convert.ToInt32(id.Value);
            return commentModel;
        }

        public Task<Comment?> DeleteAsync(int id)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Comment_Delete",
                reader => reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadComment),
                StoredProcedures.In("p_Id", id));
        }

        public Task<List<Comment>> GetAllAsync(CommentQueryObject queryObject)
        {
            var symbol = string.IsNullOrWhiteSpace(queryObject.Symbol) ? null : queryObject.Symbol;

            return _context.Database.QueryStoredProcedureAsync("sp_Comment_GetAll",
                reader => reader.ReadAllAsync(StoredProcedureReaders.ReadCommentWithAuthor),
                StoredProcedures.In("p_Symbol", symbol),
                StoredProcedures.In("p_IsDescending", queryObject.IsDecsending));
        }

        public Task<Comment?> GetByIdAsync(int id)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Comment_GetById",
                reader => reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadCommentWithAuthor),
                StoredProcedures.In("p_Id", id));
        }

        public Task<Comment?> UpdateAsync(int id, Comment commentModel)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Comment_Update",
                reader => reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadComment),
                StoredProcedures.In("p_Id", id),
                StoredProcedures.In("p_Title", commentModel.Title),
                StoredProcedures.In("p_Content", commentModel.Content));
        }
    }
}
