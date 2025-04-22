function RageUI.Info(Title, RightText, LeftText)
    local CurrentMenu = RageUI.CurrentMenu;
    local LineCount = (RightText and #RightText or 0) >= (LeftText and #LeftText or 0) and
        (RightText and #RightText or 0) or (LeftText and #LeftText or 0);

    if Title ~= nil then
        RenderText("~g~<C>" .. Title .. "</C>~s~", 310 + 20 + 100, 7 + CurrentMenu.Y, 0, 0.34, 255, 255, 255, 255, 0)
    end

    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 310 + 20 + 100,
            Title ~= nil and 37 + CurrentMenu.Y or 7 + CurrentMenu.Y, 0, 0.28, 255, 255, 255, 255, 0)
    end

    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 310 + 432 + 100,
            Title ~= nil and 37 + CurrentMenu.Y or 7 + CurrentMenu.Y, 0, 0.28, 255, 255, 255, 255, 2)
    end

    RenderRectangle(310 + 10 + 100, CurrentMenu.Y, 500, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20),
        16, 16, 16, 125)
end
