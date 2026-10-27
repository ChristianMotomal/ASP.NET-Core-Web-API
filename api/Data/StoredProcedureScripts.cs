using System.Reflection;
using System.Text.RegularExpressions;

namespace api.Data
{
    // Splits the StoredProcedure/*.sql scripts (embedded resources) into statements EF Core migrations can run.
    // The scripts use the Workbench/mysql CLI "DELIMITER $$" convention, which is a client command, not SQL.
    public static class StoredProcedureScripts
    {
        private const string ResourcePrefix = "StoredProcedure.";
        private const string StatementDelimiter = "$$";

        public static IReadOnlyList<string> LoadStatements()
        {
            var assembly = typeof(StoredProcedureScripts).Assembly;

            return assembly.GetManifestResourceNames()
                .Where(name => name.StartsWith(ResourcePrefix, StringComparison.Ordinal)
                    && name.EndsWith(".sql", StringComparison.OrdinalIgnoreCase))
                .Order(StringComparer.Ordinal)
                .SelectMany(name => SplitStatements(ReadResource(assembly, name)))
                .ToList();
        }

        public static IReadOnlyList<string> LoadProcedureNames()
        {
            return LoadStatements()
                .Select(statement => Regex.Match(statement, @"^CREATE\s+PROCEDURE\s+`?(\w+)`?", RegexOptions.IgnoreCase))
                .Where(match => match.Success)
                .Select(match => match.Groups[1].Value)
                .ToList();
        }

        private static string ReadResource(Assembly assembly, string name)
        {
            using var stream = assembly.GetManifestResourceStream(name)
                ?? throw new InvalidOperationException($"Embedded stored procedure script '{name}' was not found.");
            using var reader = new StreamReader(stream);
            return reader.ReadToEnd();
        }

        private static IEnumerable<string> SplitStatements(string script)
        {
            var lines = script
                .Replace("\r\n", "\n")
                .Split('\n')
                .Where(line =>
                {
                    var trimmed = line.TrimStart();
                    return !trimmed.StartsWith("DELIMITER", StringComparison.OrdinalIgnoreCase)
                        && !trimmed.StartsWith("--", StringComparison.Ordinal);
                });

            return string.Join('\n', lines)
                .Split(StatementDelimiter)
                .Select(statement => statement.Trim())
                .Where(statement => statement.Length > 0);
        }
    }
}
