// Function to retrieve the shift index
let
    fxGetIndex = (char as text, shift as number) =>
        let
            upperAlphas = {"A".."Z"},
            shiftedIdx =
                if Text.Length(Text.Select(Text.Upper(char), upperAlphas)) > 0 then
                    if List.PositionOf(upperAlphas, Text.Upper(char)) + shift >= 26 then
                        Number.Mod(List.PositionOf(upperAlphas, Text.Upper(char)) + shift, 26)
                    else
                        List.PositionOf(upperAlphas, Text.Upper(char)) + shift
                else
                    0
        in
            shiftedIdx,
    // Function to encode characters by a given shift
    fxEncodedText = (string as text, shift as number) =>
        let
            upperAlphas = {"A".."Z"},
            lowerAlphas = {"a".."z"},
            stringList = Text.ToList(string),
            shiftedIndex = List.Transform(stringList, each @fxGetIndex(_, shift)),
            encodedList = List.Transform(
                List.Zip({stringList, shiftedIndex}),
                each
                    if Text.Length(Text.Select(_{0}, upperAlphas)) > 0 then
                        upperAlphas{_{1}}
                    else if Text.Length(Text.Select(_{0}, lowerAlphas)) > 0 then
                        lowerAlphas{_{1}}
                    else
                        _{0}
            ),
            encodedText = Text.Combine(encodedList)
        in
            encodedText,
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2022\Q3\ch2022_03_04.csv"),
        [
            Delimiter = ",",
            Columns = 2,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"Text", type text}, {"Shift", Int64.Type}}),
    // Leverage function to create solution column
    addedColumn = Table.AddColumn(datatypeChanged, "Encoded Text", each @fxEncodedText([Text], [Shift]), type text)
in
    addedColumn
