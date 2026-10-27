# Stored procedures (MySQL 8.0)

Every repository query in `api/Repository` calls one of these procedures. Each file drops and re-creates one procedure, so re-running a file is safe.

## Dependencies and order

1. Tables first: migration `InitialCreateMySql` (or `database/motomal_mysql_schema.sql`).
2. Then the procedure files in file-name order (`01_` … `15_`). Procedures depend only on the tables, not on each other.

The database must use `utf8mb4` / `utf8mb4_0900_ai_ci` (the MySQL 8.0 default). The procedures compare their text parameters with the table columns, and a different database collation causes "Illegal mix of collations" errors.

The application user needs `EXECUTE`, `CREATE TEMPORARY TABLES` (used by `sp_Stock_GetAll`) and table read/write privileges; `GRANT ALL PRIVILEGES ON motomal.*` covers them.

## Deploying

- **EF Core:** `dotnet ef database update` runs migration `AddStoredProcedures`, which executes these files (embedded in the assembly) in order.
- **MySQL Workbench:** open each file and execute it against the `motomal` schema. The files use `DELIMITER $$`, which Workbench and the `mysql` client understand.

After changing a file, add a new migration whose `Up` runs `StoredProcedureScripts.LoadStatements()` (see `AddStoredProcedures`) so existing databases receive the new version, or re-run the changed file in Workbench.

Do not deploy with `dotnet ef migrations script`: its output contains the procedure bodies without `DELIMITER`, which Workbench cannot execute.

| File | Procedure | Replaces |
|---|---|---|
| 01 | `sp_Stock_GetAll` | `StockRepository.GetAllAsync` |
| 02 | `sp_Stock_GetById` | `StockRepository.GetByIdAsync` |
| 03 | `sp_Stock_GetBySymbol` | `StockRepository.GetBySymbolAsync` |
| 04 | `sp_Stock_Create` | `StockRepository.CreateAsync` |
| 05 | `sp_Stock_Update` | `StockRepository.UpdateAsync` |
| 06 | `sp_Stock_Delete` | `StockRepository.DeleteAsync` |
| 07 | `sp_Stock_Exists` | `StockRepository.StockExists` |
| 08 | `sp_Comment_GetAll` | `CommentRepository.GetAllAsync` |
| 09 | `sp_Comment_GetById` | `CommentRepository.GetByIdAsync` |
| 10 | `sp_Comment_Create` | `CommentRepository.CreateAsync` |
| 11 | `sp_Comment_Update` | `CommentRepository.UpdateAsync` |
| 12 | `sp_Comment_Delete` | `CommentRepository.DeleteAsync` |
| 13 | `sp_Portfolio_GetByUser` | `PortfolioRepository.GetUserPortfolio` |
| 14 | `sp_Portfolio_Create` | `PortfolioRepository.CreateAsync` |
| 15 | `sp_Portfolio_Delete` | `PortfolioRepository.DeletePortfolio` |
