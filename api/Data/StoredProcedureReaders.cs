using System.Data.Common;
using api.Models;

namespace api.Data
{
    public static class StoredProcedureReaders
    {
        public static async Task<List<T>> ReadAllAsync<T>(this DbDataReader reader, Func<DbDataReader, T> map)
        {
            var rows = new List<T>();
            while (await reader.ReadAsync())
            {
                rows.Add(map(reader));
            }
            return rows;
        }

        public static async Task<T?> ReadFirstOrDefaultAsync<T>(this DbDataReader reader, Func<DbDataReader, T> map)
            where T : class
        {
            return await reader.ReadAsync() ? map(reader) : null;
        }

        public static Stock ReadStock(DbDataReader reader)
        {
            return new Stock
            {
                Id = reader.GetInt32(reader.GetOrdinal("Id")),
                Symbol = reader.GetString(reader.GetOrdinal("Symbol")),
                CompanyName = reader.GetString(reader.GetOrdinal("CompanyName")),
                Purchase = reader.GetDecimal(reader.GetOrdinal("Purchase")),
                LastDiv = reader.GetDecimal(reader.GetOrdinal("LastDiv")),
                Industry = reader.GetString(reader.GetOrdinal("Industry")),
                MarketCap = reader.GetInt64(reader.GetOrdinal("MarketCap"))
            };
        }

        public static Comment ReadComment(DbDataReader reader)
        {
            var stockIdOrdinal = reader.GetOrdinal("StockId");
            return new Comment
            {
                Id = reader.GetInt32(reader.GetOrdinal("Id")),
                Title = reader.GetString(reader.GetOrdinal("Title")),
                Content = reader.GetString(reader.GetOrdinal("Content")),
                CreatedOn = reader.GetDateTime(reader.GetOrdinal("CreatedOn")),
                StockId = reader.IsDBNull(stockIdOrdinal) ? null : reader.GetInt32(stockIdOrdinal),
                AppUserId = reader.GetString(reader.GetOrdinal("AppUserId"))
            };
        }

        public static Comment ReadCommentWithAuthor(DbDataReader reader)
        {
            var comment = ReadComment(reader);
            var userNameOrdinal = reader.GetOrdinal("UserName");
            comment.AppUser = new AppUser
            {
                Id = comment.AppUserId,
                UserName = reader.IsDBNull(userNameOrdinal) ? null : reader.GetString(userNameOrdinal)
            };
            return comment;
        }

        public static Portfolio ReadPortfolio(DbDataReader reader)
        {
            return new Portfolio
            {
                AppUserId = reader.GetString(reader.GetOrdinal("AppUserId")),
                StockId = reader.GetInt32(reader.GetOrdinal("StockId"))
            };
        }
    }
}
