// Function to determine the character type (upper, lower, digit or, special)
let
    fxCharType = (char as text) =>
        let
            group =
                if Text.Length(Text.Select(char, {"a".."z"})) > 0 then
                    "lower"
                else if Text.Length(Text.Select(char, {"A".."Z"})) > 0 then
                    "upper"
                else if Text.Length(Text.Select(char, {"0".."9"})) > 0 then
                    "digits"
                else
                    "special"
        in
            group,
    // Function to transform a given text by inserting a comma between characters of different types
    fxTransformText = (string as text) =>
        let
            strList = Text.ToList(string),
            range = {0..Text.Length(string) - 1},
            transformedList = List.Transform(
                range,
                each
                    if _ > 0 then
                        if @fxCharType(strList{_}) <> @fxCharType(strList{_ - 1}) then
                            ", " & strList{_}
                        else
                            strList{_}
                    else
                        strList{_}
            ),
            transformedText = Text.Combine(transformedList)
        in
            transformedText,
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2024\Q1\ch2024_01_04.csv"),
        [
            Delimiter = ",",
            Columns = 1,
            Encoding = 1252,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"Data", type text}}),
    // Leverage function to create solution column
    transformedData = Table.AddColumn(datatypeChanged, "Transformed Text", each @fxTransformText([Data]), type text)
in
    transformedData
