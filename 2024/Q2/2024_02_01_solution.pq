let
    fxTransformNumber = (num as number) =>
        let
            // Create short-hands for commonly used functions
            TF = Text.From,
            NF = Number.From,
            // Logic to retrieve codes from string
            numStr = TF(num),
            numLen = Text.Length(numStr),
            numList = Text.ToList(numStr),
            numFormat = List.Transform(
                List.Numbers(0, numLen - 1), each TF(NF(numList{_}) * NF(numList{_ + 1})) & numList{_ + 1}
            ),
            transformedNum = numList{0} & Text.Combine(numFormat)
        in
            transformedNum,
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2024\Q2\ch2024_02_01.csv"),
        [
            Delimiter = ",",
            Columns = 1,
            Encoding = 65001,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"Words", Int64.Type}}),
    // Leverage function to create solution column
    addedColumn = Table.AddColumn(datatypeChanged, "Codes", each @fxTransformNumber([Words]), type text)
in
    addedColumn
