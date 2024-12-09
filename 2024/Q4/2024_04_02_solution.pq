let
    source = Csv.Document(
        File.Contents(
            "D:\ExcelBI-Challenges\2024\Q4\2024_04_02_data.csv"
        ),
        [
            Delimiter = ",",
            Columns = 5,
            Encoding = 65001,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    detectDatatype = Table.TransformColumnTypes(
        source,
        {
            {"Column1", type text},
            {"Column2", type text},
            {"Column3", type text},
            {"Column4", type text},
            {"Column5", type text}
        }
    ),
    promotedHeaders = Table.PromoteHeaders(detectDatatype, [PromoteAllScalars = true]),
    addedIndex = Table.AddIndexColumn(promotedHeaders, "Index", 1, 1, Int64.Type),
    unpivotOtherColumns = Table.UnpivotOtherColumns(addedIndex, {"Index"}, "Attribute", "Value"),
    groupedRows = Table.Group(
        unpivotOtherColumns,
        {"Index"},
        {{"RowGroup", each _, type table [Index = number, Attribute = text, Value = text]}}
    ),
    conditionalSortRows = Table.AddColumn(
        groupedRows,
        "SortedRowGroup",
        each
            if Number.Mod([Index], 2) = 0 then
                Table.Sort([RowGroup], {"Value", Order.Descending})
            else
                Table.Sort([RowGroup], {"Value", Order.Ascending})
    ),
    trasposeRows = Table.AddColumn(
        conditionalSortRows,
        "TransformedRowGroup",
        each
            Table.Transpose(
                Table.SelectColumns(
                    Table.SelectRows([SortedRowGroup], each [Value] <> null and [Value] <> ""), "Attribute"
                )
            )
    ),
    selectColumn = Table.SelectColumns(trasposeRows, {"TransformedRowGroup"}),
    expandTable = Table.ExpandTableColumn(
        selectColumn,
        "TransformedRowGroup",
        {"Column1", "Column2", "Column3", "Column4", "Column5"},
        {"Column1", "Column2", "Column3", "Column4", "Column5"}
    ),
    changeDatatypeToText = Table.TransformColumnTypes(
        expandTable,
        {
            {"Column1", type text},
            {"Column2", type text},
            {"Column3", type text},
            {"Column4", type text},
            {"Column5", type text}
        }
    ),
    replaceNulls = Table.ReplaceValue(
        changeDatatypeToText, null, "", Replacer.ReplaceValue, {
            "Column1",
            "Column2",
            "Column3",
            "Column4",
            "Column5"
        }
    )
in
    replaceNulls
