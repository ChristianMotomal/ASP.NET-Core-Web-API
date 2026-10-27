using System.Data;
using System.Data.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Storage;
using MySql.Data.MySqlClient;

namespace api.Data
{
    public static class StoredProcedures
    {
        public static MySqlParameter In(string name, object? value)
        {
            return new MySqlParameter(name, value ?? DBNull.Value)
            {
                Direction = ParameterDirection.Input
            };
        }

        public static MySqlParameter Out(string name, MySqlDbType type)
        {
            return new MySqlParameter(name, type)
            {
                Direction = ParameterDirection.Output
            };
        }

        public static Task<int> ExecuteStoredProcedureAsync(
            this DatabaseFacade database,
            string procedureName,
            params MySqlParameter[] parameters)
        {
            return ExecuteAsync(database, procedureName, parameters,
                command => command.ExecuteNonQueryAsync());
        }

        public static Task<T> QueryStoredProcedureAsync<T>(
            this DatabaseFacade database,
            string procedureName,
            Func<DbDataReader, Task<T>> read,
            params MySqlParameter[] parameters)
        {
            return ExecuteAsync(database, procedureName, parameters, async command =>
            {
                await using var reader = await command.ExecuteReaderAsync();
                var result = await read(reader);

                // MySQL reports errors raised after the last SELECT only while the remaining results are read.
                while (await reader.NextResultAsync())
                {
                }

                return result;
            });
        }

        private static async Task<T> ExecuteAsync<T>(
            DatabaseFacade database,
            string procedureName,
            MySqlParameter[] parameters,
            Func<DbCommand, Task<T>> execute)
        {
            await database.OpenConnectionAsync();
            try
            {
                await using var command = database.GetDbConnection().CreateCommand();
                command.CommandText = procedureName;
                command.CommandType = CommandType.StoredProcedure;
                command.Transaction = database.CurrentTransaction?.GetDbTransaction();
                command.Parameters.AddRange(parameters);

                return await execute(command);
            }
            finally
            {
                await database.CloseConnectionAsync();
            }
        }
    }
}
