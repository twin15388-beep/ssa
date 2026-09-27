-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local script_Slots = require(script.Slots);
local script_Spinner = require(script.Spinner);
local PageBrowser = require(ReplicatedStorage.CAM.Client.Components.Misc.PageBrowser);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local faye = require(ReplicatedStorage.Packages.faye);
local v1 = gameSettings.SellRobuxPayout and gameSettings.SellRobuxPayout.Item or "Ore";
local u2 = {
    {
        Name = "Robux",
        Icon = BunchaIcons.Robux,
        IdleColor = Color3.new()
    },
    {
        Name = "Ore",
        Icon = Items[v1] and Items[v1].Icon or "",
        IconColor = Color3.new(1, 1, 1)
    }
};
local u3 = faye.Info(0.45);
local UDim2_fromScale_ret = UDim2.fromScale(0, 0.04);
local Attribute = workspace:GetAttribute("IsMenu");

return function(p4: any, p5: userdata, p6: userdata, p7: any) -- Line: 29
    -- upvalues: u3 (copy), UDim2_fromScale_ret (copy), PageBrowser (copy), u2 (copy), script_Spinner (copy), Attribute (copy), script_Slots (copy)
    local v8 = p4:Value("Robux");

    return p4:Create("CanvasGroup")({
        Parent = p5,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        GroupTransparency = p4:Animation(0, u3, {
            From = 1
        }),
        Position = p4:Animation(UDim2.fromScale(0, 0), u3, {
            From = UDim2_fromScale_ret
        }),

        OnClean = function(p9) -- Line: 38, Name: OnClean
            -- upvalues: u3 (ref), UDim2_fromScale_ret (ref)
            return {
                GroupTransparency = p9:Animation(1, u3),
                Position = p9:Animation(UDim2_fromScale_ret, u3)
            };
        end,

        p4:Create("Frame")({
            Name = "Holder",
            CleanDelay = u3.Time,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            p4:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            p4:Create("Frame")({
                Name = "CurrencyTabs",
                LayoutOrder = 1,
                CleanDelay = u3.Time,
                Size = UDim2.fromScale(0.05, 0.25),
                p4:Create("UIAspectRatioConstraint")({
                    AspectRatio = 0.5
                }),
                BackgroundTransparency = 1,
                PageBrowser(p4, v8, u2, {
                    IconShadow = true,
                    Backdrop = false,

                    Key = function(p10, p11) -- Line: 71, Name: Key
                        return p11.Name;
                    end,

                    Icon = function(p12, p13) -- Line: 72, Name: Icon
                        return p13.Icon;
                    end,

                    IconColor = function(p14, p15) -- Line: 73, Name: IconColor
                        return p15.IconColor;
                    end,

                    IdleColor = function(p16, p17) -- Line: 76, Name: IdleColor
                        return p17.IdleColor;
                    end,

                    FillDirection = Enum.FillDirection.Vertical,
                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.fromScale(0, 0),
                    TabSize = UDim2.fromScale(1, 0.2),
                    Padding = UDim.new(0, 6),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            }),
            p4:Create("Frame")({
                Name = "SpinningFrame",
                LayoutOrder = 2,
                CleanDelay = u3.Time,
                Size = UDim2.fromScale(0.15, 0.25),
                p4:Create("UIAspectRatioConstraint")({
                    AspectRatio = 1.5
                }),
                BackgroundTransparency = 1,
                script_Spinner(p4, Attribute, u3, v8)
            }),
            p4:Create("Frame")({
                Name = "RightFrame",
                LayoutOrder = 3,
                CleanDelay = u3.Time,
                Size = UDim2.fromScale(0.08, 0.3),
                p4:Create("UIAspectRatioConstraint")({
                    AspectRatio = 1.4
                }),
                BackgroundTransparency = 1,
                script_Slots(p4, Attribute)
            })
        })
    });
end;