let
    source = Csv.Document(
        File.Contents(
            "D:\Works\05-GitHub-Projects\05_Competitive_Coding\ExcelBI-Challenges\data\2024\Q4\ch2024_04_01.csv"
        ),
        [
            Delimiter = ",",
            Columns = 6,
            Encoding = 65001,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    detectedDatatype = Table.TransformColumnTypes(
        promotedHeaders,
        {
            {"Hall", type text},
            {"Date", type date},
            {"Guest1", type text},
            {"Guest2", type text},
            {"Guest3", type text},
            {"Guest4", type text}
        }
    ),
    unpivotOtherColumns = Table.UnpivotOtherColumns(detectedDatatype, {"Hall"}, "Column1", "Column2"),
    filteredEmptyRows = Table.SelectRows(unpivotOtherColumns, each [Column2] <> null and [Column2] <> ""),
    groupAllRows = Table.Group(filteredEmptyRows, {"Hall"}, {{"RowGroup", each Table.RemoveColumns(_, "Hall")}}),
    tableTransform = Table.AddColumn(
        groupAllRows, "TransformedTables", each
            Table.InsertRows([RowGroup], 0, {[Column1 = "Hall", Column2 = [Hall]]})
    ),
    selectColumn = Table.SelectColumns(tableTransform, {"TransformedTables"}),
    expandTransformedTable = Table.ExpandTableColumn(
        selectColumn, "TransformedTables", {"Column1", "Column2"}, {"Column1", "Column2"}
    ),
    changeDatatype = Table.TransformColumnTypes(
        expandTransformedTable, {{"Column1", type text}, {"Column2", type text}}
    )
in
    changeDatatype
