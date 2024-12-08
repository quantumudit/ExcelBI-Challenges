let
    Source = Csv.Document(
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
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"Hall", type text},
            {"Date", type date},
            {"Guest1", type text},
            {"Guest2", type text},
            {"Guest3", type text},
            {"Guest4", type text}
        }
    ),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Changed Type", {"Hall"}, "Column1", "Column2"),
    #"Filtered Rows1" = Table.SelectRows(#"Unpivoted Other Columns", each [Column2] <> null and [Column2] <> ""),
    #"Grouped Rows1" = Table.Group(#"Filtered Rows1", {"Hall"}, {{"RowGroup", each Table.RemoveColumns(_, "Hall")}}),
    #"Added Custom1" = Table.AddColumn(
        #"Grouped Rows1",
        "TransformedTables",
        each Table.InsertRows([RowGroup], 0, {[Column1 = "Hall", Column2 = [Hall]]})
    ),
    #"Removed Other Columns1" = Table.SelectColumns(#"Added Custom1", {"TransformedTables"}),
    #"Expanded TransformedTables" = Table.ExpandTableColumn(
        #"Removed Other Columns1", "TransformedTables", {"Column1", "Column2"}, {"Column1", "Column2"}
    ),
    #"Changed Type1" = Table.TransformColumnTypes(
        #"Expanded TransformedTables", {{"Column1", type text}, {"Column2", type text}}
    )
in
    #"Changed Type1"
