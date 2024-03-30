let
    fxCodeExtractor = (string as text) =>
        let
            // Create short-hands for commonly used functions
            TL = Text.Length,
            TF = Text.From,
            TT = Text.Trim,
            TS = Text.Select,
            TA = Text.At,
            // Create constants
            capAlphas = {"A".."Z"},
            numStrs = {"0".."9"},
            blanks = {""},
            delims = {" ", ","},
            // Logic to retrieve codes from string
            reqChars = List.Combine({capAlphas, numStrs}),
            splitTexts = List.RemoveItems(Splitter.SplitTextByAnyDelimiter(delims)(string), blanks),
            codesList = List.Transform(
                splitTexts,
                each
                    if
                        TL(TS(TT(_), capAlphas)) > 0
                        and TL(TS(TT(_), numStrs)) > 0
                        and TL(TS(TT(_), reqChars)) = TL(TT(_))
                        and TL(TS(TA(TT(_), 0), capAlphas)) > 0
                    then
                        TT(_)
                    else
                        ""
            ),
            codesString = Text.Combine(List.RemoveItems(codesList, blanks), ", ")
        in
            codesString,
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2024\Q1\ch2024_01_05.csv"),
        [
            Delimiter = ",",
            Columns = 1,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"String", type text}}),
    // Leverage function to create solution column
    addedCodesColumn = Table.AddColumn(datatypeChanged, "Codes", each @fxCodeExtractor([String]), type text)
in
    addedCodesColumn
