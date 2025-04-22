local Percentage = {
    Background = { Dictionary = "galaxia", Texture = "gradient_bgd", Y = 4, Width = 415, Height = 65 },
    Bar = { X = 30.81, Y = 60, Width = 346, 64, Height = 10 },
    Text = {
        Left = { X = 43.34, Y = 28.89, Scale = 0.23 },
        Middle = { X = 207.91, Y = 28.89, Scale = 0.23 },
        Right = { X = 370.26, Y = 28.89, Scale = 0.23 },
    },
}

---PercentagePanel
---@param Percent number
---@param HeaderText string
---@param MinText string
---@param MaxText string
---@param Callback function
---@param Index number
---@return nil
---@public

function RageUI.PercentagePanel(Percent, HeaderText, MinText, MaxText, Action, Index)
    local CurrentMenu = RageUI.CurrentMenu

    if CurrentMenu ~= nil then
        if CurrentMenu() and (Index == nil or (CurrentMenu.Index == Index)) then
            ---@type boolean
            local Hovered = RageUI.IsMouseInBounds(CurrentMenu.X + Percentage.Bar.X + CurrentMenu.SafeZoneSize.X,
                CurrentMenu.Y + Percentage.Bar.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight +
                RageUI.ItemOffset - 4, Percentage.Bar.Width + CurrentMenu.WidthOffset, Percentage.Bar.Height + 8)

            ---@type boolean
            local Selected = false

            ---@type number
            local Progress = Percentage.Bar.Width

            if Percent < 0.0 then
                Percent = 0.0
            elseif Percent > 1.0 then
                Percent = 1.0
            end

            Progress = Progress * Percent

            --RenderRectangle(28 + CurrentMenu.X, 16 + CurrentMenu.Y + Percentage.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Percentage.Background.Width + CurrentMenu.WidthOffset - 55, Percentage.Background.Height, 16, 16, 16, 255)
            -- RenderRectangle(28 + CurrentMenu.X, 16 + CurrentMenu.Y + Percentage.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 60, Percentage.Background.Width + CurrentMenu.WidthOffset - 55, Percentage.Background.Height, 18, 18, 18, 255)

            RenderSprite("commonmenu", "percentagebar",
                4 + CurrentMenu.X + Percentage.Bar.X + (CurrentMenu.WidthOffset / 2),
                CurrentMenu.Y + Percentage.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Percentage.Bar.Width,
                Percentage.Bar.Height, 0, 16, 16, 16, 125)
            RenderSprite("commonmenu", "percentagebar",
                4 + CurrentMenu.X + Percentage.Bar.X + (CurrentMenu.WidthOffset / 2),
                CurrentMenu.Y + Percentage.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Progress,
                Percentage.Bar.Height, 0, 36, 95, 203, 215)

            RenderText(HeaderText or "Opacity", CurrentMenu.X + Percentage.Text.Middle.X + (CurrentMenu.WidthOffset / 2),
                CurrentMenu.Y + Percentage.Text.Middle.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0,
                Percentage.Text.Middle.Scale, 245, 245, 245, 255, 1)
            RenderText(MinText or "0%", CurrentMenu.X + Percentage.Text.Left.X + (CurrentMenu.WidthOffset / 2),
                CurrentMenu.Y + Percentage.Text.Left.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0,
                Percentage.Text.Left.Scale, 245, 245, 245, 255, 1)
            RenderText(MaxText or "100%", CurrentMenu.X + Percentage.Text.Right.X + (CurrentMenu.WidthOffset / 2),
                CurrentMenu.Y + Percentage.Text.Right.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0,
                Percentage.Text.Right.Scale, 245, 245, 245, 255, 1)

            if Hovered then
                if IsDisabledControlPressed(0, 24) then
                    Selected = true

                    Progress = math.round(GetControlNormal(2, 239) * 1920) - CurrentMenu.SafeZoneSize.X -
                        (CurrentMenu.X + Percentage.Bar.X + (CurrentMenu.WidthOffset / 2))

                    if Progress < 0 then
                        Progress = 0
                    elseif Progress > (Percentage.Bar.Width) then
                        Progress = Percentage.Bar.Width
                    end

                    Percent = math.round(Progress / Percentage.Bar.Width, 2)
                    if (Action.onProgressChange ~= nil) then
                        Action.onProgressChange(Percent)
                    end
                end
            end

            RageUI.ItemOffset = RageUI.ItemOffset + Percentage.Background.Height + Percentage.Background.Y

            if Hovered and Selected then
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
                if (Action.onSelected ~= nil) then
                    Action.onSelected(Percent)
                end
            end
        end
    end
end
