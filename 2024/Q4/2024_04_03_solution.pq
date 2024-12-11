let
    source = Csv.Document(
        File.Contents(
            "D:\ExcelBI-Challenges\2024\Q4\2024_04_03_data.csv"
        ),
        [
            Delimiter = ",",
            Columns = 5,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    unpivotOtherColumns = Table.UnpivotOtherColumns(promotedHeaders, {"Name"}, "Attribute", "Value"),
    filterEmptyRows = Table.SelectRows(unpivotOtherColumns, each [Value] <> null and [Value] <> ""),
    groupRows = Table.Group(
        filterEmptyRows,
        {"Name", "Attribute"},
        {{"RowGroup", each _, type table [Name = nullable text, Attribute = text, Value = text]}}
    ),
    concatSortedValues = Table.AddColumn(
        groupRows,
        "ConcatValues",
        each Text.Combine(List.Sort(Table.ToList(Table.SelectColumns([RowGroup], "Value"))), ", "),
        type text
    ),
    removeColumn = Table.RemoveColumns(concatSortedValues, {"RowGroup"}),
    pivotColumn = Table.Pivot(removeColumn, List.Distinct(removeColumn[Attribute]), "Attribute", "ConcatValues"),
    replaceNullsWithBlanks = Table.ReplaceValue(
        pivotColumn, null, "", Replacer.ReplaceValue, {"Value1", "Value2", "Value3", "Value4"}
    )
in
    replaceNullsWithBlanks
