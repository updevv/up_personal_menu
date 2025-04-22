local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 30 },
    Text = { X = 8, Y = 3, Scale = 0.30 },
}

function RageUI.Line(R, G, B, A)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderRectangle(
                    CurrentMenu.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 200) - 150 +
                    8,
                    5 + CurrentMenu.Y + RageUI.ItemOffset + 26, 300, 2, R, G, B, A)

                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUI.Options = RageUI.Options + 1
        end
    end
end
