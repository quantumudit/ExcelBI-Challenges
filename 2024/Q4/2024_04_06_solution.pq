let
    // Function: Remove Columns with Only Null Values
    NotNullCols = (tbl as table) =>
        Table.SelectRows(
            Table.SelectColumns(Table.Profile(tbl), {"Column", "Count", "NullCount"}), each [Count] <> [NullCount]
        )[Column],
    // Main data transformation steps
    source = Csv.Document(
        File.Contents(
            "D:\Works\ExcelBI-Challenges\2024\Q4\2024_04_06_data.csv"
        ),
        [
            Delimiter = ",",
            Columns = 2,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    detectDatatype = Table.TransformColumnTypes(promotedHeaders, {{"Emp ID", Int64.Type}, {"Group", type text}}),
    // Group rows based on Employee ID
    groupedRows = Table.Group(
        detectDatatype, {"Emp ID"}, {
            {"RowGroup", each _, type table [Emp ID = nullable number, Group = nullable text]}
        }
    ),
    // Split each table by comma with maximum 3 columns
    splitTableColumnsByComma = Table.AddColumn(
        groupedRows,
        "SplitColsRowGroup",
        each Table.SplitColumn([RowGroup], "Group", Splitter.SplitTextByDelimiter(",", QuoteStyle.Csv), 3)
    ),
    // Selecting Columns with no null values from the splitted columns table and then transpose data by removing "Emp ID" column
    transposeCols = Table.AddColumn(
        splitTableColumnsByComma,
        "TransposedColsGroup",
        each
            Table.Transpose(
                Table.RemoveColumns(
                    Table.SelectColumns([SplitColsRowGroup], NotNullCols([SplitColsRowGroup])), "Emp ID"
                )
            )
    ),
    // Remove unnecessary columns
    removeColumns = Table.RemoveColumns(transposeCols, {"RowGroup", "SplitColsRowGroup"}),
    // Expand the tables columns and performing basic data cleaning
    explandColumns = Table.ExpandTableColumn(
        removeColumns, "TransposedColsGroup", {"Column1", "Column2", "Column3"}, {"Group1", "Group2", "Group3"}
    ),
    replaceNullsWithBlanks = Table.ReplaceValue(
        explandColumns, null, "", Replacer.ReplaceValue, {"Group1", "Group2", "Group3"}
    ),
    trimmedText = Table.TransformColumns(
        replaceNullsWithBlanks,
        {{"Group1", Text.Trim, type text}, {"Group2", Text.Trim, type text}, {"Group3", Text.Trim, type text}}
    )
in
    trimmedText
