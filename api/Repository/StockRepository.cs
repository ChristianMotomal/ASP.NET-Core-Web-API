using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using api.Data;
using api.Dtos.Stock;
using api.Helpers;
using api.Interfaces;
using api.Models;
using MySql.Data.MySqlClient;

namespace api.Repository
{
    public class StockRepository : IStockRepository
    {
        private readonly ApplicationDBContext _context;
        public StockRepository(ApplicationDBContext context)
        {
            _context = context;
        }

        public async Task<Stock> CreateAsync(Stock stockModel)
        {
            var id = StoredProcedures.Out("p_Id", MySqlDbType.Int32);

            await _context.Database.ExecuteStoredProcedureAsync("sp_Stock_Create",
                StoredProcedures.In("p_Symbol", stockModel.Symbol),
                StoredProcedures.In("p_CompanyName", stockModel.CompanyName),
                StoredProcedures.In("p_Purchase", stockModel.Purchase),
                StoredProcedures.In("p_LastDiv", stockModel.LastDiv),
                StoredProcedures.In("p_Industry", stockModel.Industry),
                StoredProcedures.In("p_MarketCap", stockModel.MarketCap),
                id);

            stockModel.Id = Convert.ToInt32(id.Value);
            return stockModel;
        }

        public Task<Stock?> DeleteAsync(int id)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Stock_Delete",
                reader => reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadStock),
                StoredProcedures.In("p_Id", id));
        }

        public Task<List<Stock>> GetAllAsync(QueryObject query)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Stock_GetAll", async reader =>
            {
                var stocks = await reader.ReadAllAsync(StoredProcedureReaders.ReadStock);

                await reader.NextResultAsync();
                var comments = await reader.ReadAllAsync(StoredProcedureReaders.ReadCommentWithAuthor);

                AttachComments(stocks, comments);
                return stocks;
            },
            StoredProcedures.In("p_CompanyName", NullIfWhiteSpace(query.CompanyName)),
            StoredProcedures.In("p_Symbol", NullIfWhiteSpace(query.Symbol)),
            StoredProcedures.In("p_SortBy", query.SortBy),
            StoredProcedures.In("p_IsDescending", query.IsDecsending),
            StoredProcedures.In("p_PageNumber", query.PageNumber),
            StoredProcedures.In("p_PageSize", query.PageSize));
        }

        public Task<Stock?> GetByIdAsync(int id)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Stock_GetById", async reader =>
            {
                var stock = await reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadStock);

                await reader.NextResultAsync();
                var comments = await reader.ReadAllAsync(StoredProcedureReaders.ReadComment);

                if (stock != null)
                {
                    AttachComments(new List<Stock> { stock }, comments);
                }
                return stock;
            },
            StoredProcedures.In("p_Id", id));
        }

        public Task<Stock?> GetBySymbolAsync(string symbol)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Stock_GetBySymbol",
                reader => reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadStock),
                StoredProcedures.In("p_Symbol", symbol));
        }

        public Task<bool> StockExists(int id)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Stock_Exists",
                async reader => await reader.ReadAsync() && Convert.ToBoolean(reader["StockExists"]),
                StoredProcedures.In("p_Id", id));
        }

        public Task<Stock?> UpdateAsync(int id, UpdateStockRequestDto stockDto)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Stock_Update",
                reader => reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadStock),
                StoredProcedures.In("p_Id", id),
                StoredProcedures.In("p_Symbol", stockDto.Symbol),
                StoredProcedures.In("p_CompanyName", stockDto.CompanyName),
                StoredProcedures.In("p_Purchase", stockDto.Purchase),
                StoredProcedures.In("p_LastDiv", stockDto.LastDiv),
                StoredProcedures.In("p_Industry", stockDto.Industry),
                StoredProcedures.In("p_MarketCap", stockDto.MarketCap));
        }

        private static void AttachComments(List<Stock> stocks, List<Comment> comments)
        {
            var stocksById = stocks.ToDictionary(s => s.Id);
            foreach (var comment in comments)
            {
                if (comment.StockId is int stockId && stocksById.TryGetValue(stockId, out var stock))
                {
                    comment.Stock = stock;
                    stock.Comments.Add(comment);
                }
            }
        }

        private static string? NullIfWhiteSpace(string? value)
        {
            return string.IsNullOrWhiteSpace(value) ? null : value;
        }
    }
}
