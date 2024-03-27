let
    fxCustomSplitter = (string as text, splitsAt as number) =>
        let
            textLength = Text.Length(string),
            splitPositions = List.Generate(
                () => 0,
                each _ < textLength,
                each _+splitsAt
            ),
            splittedStringList = Splitter.SplitTextByPositions(splitPositions)(string),
            textTypeSplittedList = List.Transform(splittedStringList, each Text.From(_))
        in
            textTypeSplittedList,

    fxListMapper = (mainList as list, refList as list) =>
        let
            lastCode = List.Last(mainList),
            subList = List.RemoveLastN(mainList, 1),
            mappedList = List.Transform(subList, each Text.From(List.PositionOf(refList, _))),
            mappedLastCode = Text.Repeat("0", List.PositionOf(refList, lastCode)),
            completeMappedList = List.Combine({mappedList, {mappedLastCode}}),
            MappedText = Text.Combine(completeMappedList)
        in
            MappedText,

    Source = ch2024_01_60,
    colorCodes = Source[Code],
    colorBands = List.RemoveItems(Source[Color Bands], {"", null}),
    colorBandCodes = List.Transform(colorBands, each @fxCustomSplitter(_, 2)),
    colorBandIndexCodes = List.Transform(colorBandCodes, each @fxListMapper(_, colorCodes))
in
    colorBandIndexCodes