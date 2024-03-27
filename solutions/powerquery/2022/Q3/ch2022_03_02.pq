let
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2022\Q3\ch2022_03_02.csv"),
        [
            Delimiter = ",",
            Columns = 1,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"Words", type text}}),

    // Get the "Words" column as a list
    words = datatypeChanged[Words],

    // Filter the list to get words containing all vowels
    allVowelWords = List.Select(
        words, each List.ContainsAll(Text.ToList(_), {"a", "e", "i", "o", "u"}, Comparer.OrdinalIgnoreCase)
    )
in
    allVowelWords
