let
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2022\Q3\ch2022_03_01.csv"),
        [
            Delimiter = ",",
            Columns = 2,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"Data", type text}, {"Number", Int64.Type}}),
    // Filter the table and generate the required list
    filteredList = Table.SelectRows(datatypeChanged, each ([Number] = 2))[Data],
    // Filter the list for alphabet contents only & extract the fifth item
    alphasList = List.Select(filteredList, each List.Contains({"a".."z"}, _, Comparer.OrdinalIgnoreCase)),
    fifthIndex = alphasList{4}
in
    fifthIndex
