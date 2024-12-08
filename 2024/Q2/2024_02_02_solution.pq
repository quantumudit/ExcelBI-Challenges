let
    fxHexCode = (color1 as text, color2 as text) =>
        let
            // Create constants
            hexNumbers = {"0".."9"} & {"A".."F"},
            // Logic to retrieve blended RGB Value
            color1List = List.Transform(Text.Split(color1, ","), each Number.From(Text.Trim(_))),
            color2List = List.Transform(Text.Split(color2, ","), each Number.From(Text.Trim(_))),
            rgbAvgValue = List.Transform(List.Zip({color1List, color2List}), each Number.RoundUp((_{0} + _{1}) / 2, 0)),
            // Logic to convert RGB value into its HEX equivalent
            hexIndexValues = List.Transform(rgbAvgValue, each {Number.IntegerDivide(_, 16), Number.Mod(_, 16)}),
            hexCode = "#" & Text.Combine(List.Transform(hexIndexValues, each hexNumbers{_{0}} & hexNumbers{_{1}}))
        in
            hexCode,
    // Read the CSV data file & perform basic transformation
    source = Csv.Document(
        File.Contents("D:\ExcelBI-Challenges\data\2024\Q2\ch2024_02_02.csv"),
        [
            Delimiter = ",",
            Columns = 2,
            Encoding = 65001,
            QuoteStyle = QuoteStyle.None
        ]
    ),
    promotedHeaders = Table.PromoteHeaders(source, [PromoteAllScalars = true]),
    datatypeChanged = Table.TransformColumnTypes(promotedHeaders, {{"Color1", type text}, {"Color2", type text}}),
    // Leverage function to create solution column
    addedColumn = Table.AddColumn(datatypeChanged, "Hex Code", each @fxHexCode([Color1], [Color2]), type text)
in
    addedColumn
