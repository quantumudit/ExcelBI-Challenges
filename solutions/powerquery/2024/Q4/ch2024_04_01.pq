let
    Source = Csv.Document(
        File.Contents(
            "D:\ExcelBI-Challenges\data\2024\Q4\ch2024_04_01.csv"
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
    #"Grouped Rows1" = Table.Group(
        #"Changed Type",
        {"Hall"},
        {
            {
                "RowGroup",
                each _,
                type table [
                    Hall = nullable text,
                    Date = nullable date,
                    Guest1 = nullable text,
                    Guest2 = nullable text,
                    Guest3 = nullable text,
                    Guest4 = nullable text,
                    Index = number
                ]
            }
        }
    ),
    #"Added Custom" = Table.AddColumn(
        #"Grouped Rows1",
        "UnpivotedRowGroup",
        each Table.RemoveColumns(Table.UnpivotOtherColumns([RowGroup], {"Hall"}, "Column1", "Column2"), "Hall")
    ),
    #"Added Custom1" = Table.AddColumn(
        #"Added Custom",
        "TransformedTables",
        each Table.InsertRows([UnpivotedRowGroup], 0, {[Column1 = "Hall", Column2 = [Hall]]})
    ),
    #"Removed Other Columns1" = Table.SelectColumns(#"Added Custom1", {"TransformedTables"}),
    #"Expanded TransformedTables" = Table.ExpandTableColumn(
        #"Removed Other Columns1", "TransformedTables", {"Column1", "Column2"}, {"Column1", "Column2"}
    ),
    #"Filtered Rows" = Table.SelectRows(#"Expanded TransformedTables", each [Column2] <> null and [Column2] <> ""),
    #"Changed Type1" = Table.TransformColumnTypes(#"Filtered Rows", {{"Column1", type text}, {"Column2", type text}})
in
    #"Changed Type1"
