let
    source = Csv.Document(
        File.Contents(
            "D:\Works\05-GitHub-Projects\05_Competitive_Coding\ExcelBI-Challenges\2024\Q4\2024_04_04_data.csv"
        ),
        [
            Delimiter = ",",
            Columns = 3,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    detectDatatype = Table.TransformColumnTypes(
        promotedHeaders, {{"N1", Int64.Type}, {"N2", Int64.Type}, {"N3", Int64.Type}}
    ),
    tableToList = Table.ToColumns(detectDatatype),
    transformList = List.Transform(
        tableToList,
        each
            [
                filteredList = List.Sort(List.RemoveNulls(_)),
                combinedList = List.Select(filteredList, Number.IsOdd) & List.Select(filteredList, Number.IsEven)
            ][combinedList]
    ),
    resultTable = Table.FromColumns(transformList, Table.ColumnNames(detectDatatype)),
    changedDatatype = Table.TransformColumnTypes(
        resultTable, {{"N1", Int64.Type}, {"N2", Int64.Type}, {"N3", Int64.Type}}
    )
in
    changedDatatype
