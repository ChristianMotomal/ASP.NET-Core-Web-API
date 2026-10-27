using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using api.Data;
using api.Interfaces;
using api.Models;

namespace api.Repository
{
    public class PortfolioRepository : IPortfolioRepository
    {
        private readonly ApplicationDBContext _context;
        public PortfolioRepository(ApplicationDBContext context)
        {
            _context = context;
        }

        public async Task<Portfolio> CreateAsync(Portfolio portfolio)
        {
            await _context.Database.ExecuteStoredProcedureAsync("sp_Portfolio_Create",
                StoredProcedures.In("p_AppUserId", portfolio.AppUserId),
                StoredProcedures.In("p_StockId", portfolio.StockId));
            return portfolio;
        }

        public Task<Portfolio?> DeletePortfolio(AppUser appUser, string symbol)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Portfolio_Delete",
                reader => reader.ReadFirstOrDefaultAsync(StoredProcedureReaders.ReadPortfolio),
                StoredProcedures.In("p_AppUserId", appUser.Id),
                StoredProcedures.In("p_Symbol", symbol));
        }

        public Task<List<Stock>> GetUserPortfolio(AppUser user)
        {
            return _context.Database.QueryStoredProcedureAsync("sp_Portfolio_GetByUser",
                reader => reader.ReadAllAsync(StoredProcedureReaders.ReadStock),
                StoredProcedures.In("p_AppUserId", user.Id));
        }
    }
}
