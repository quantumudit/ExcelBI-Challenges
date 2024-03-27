let
    fxShiftNums = (num as number, shift as number) =>
        let
            // Create short-hands for commonly used functions
            NF = Number.From,
            TF = Text.From,
            NM = Number.Mod,
            // Logic to encrypt data with Ceaser cipher
            shiftedNums = NF(
                Text.Combine(
                    List.Transform(
                        Text.ToList(TF(num)), each if NF(_) + shift > 9 then TF(NM(NF(_) + shift, 10)) else TF(NF(_) + shift)
                    )
                )
            )
        in
            shiftedNums,
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2022\Q3\ch2022_03_03.csv"),
        [
            Delimiter = ",",
            Columns = 2,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"Text", Int64.Type}, {"Shift", Int64.Type}}),
    // Leverage function to create solution column
    shiftNums = Table.AddColumn(datatypeChanged, "Shifted Numbers", each @fxShiftNums([Text], [Shift]), Int64.Type)
in
    shiftNums
