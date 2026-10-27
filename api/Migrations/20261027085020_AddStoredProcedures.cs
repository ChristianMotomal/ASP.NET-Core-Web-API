using api.Data;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api.Migrations
{
    /// <inheritdoc />
    public partial class AddStoredProcedures : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            foreach (var statement in StoredProcedureScripts.LoadStatements())
            {
                migrationBuilder.Sql(statement);
            }
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            foreach (var procedureName in StoredProcedureScripts.LoadProcedureNames())
            {
                migrationBuilder.Sql($"DROP PROCEDURE IF EXISTS {procedureName};");
            }
        }
    }
}
