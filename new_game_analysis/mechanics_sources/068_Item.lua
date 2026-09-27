-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = game:GetService("Players").LocalPlayer;
local faye = require(ReplicatedStorage.Packages.faye);
local Data = Utility.GetData(LocalPlayer, true);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local ItemIcon = require(ReplicatedStorage.CAM.Global.Collectibles.ItemIcon);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Collectibles.FightingStyles);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
require(ReplicatedStorage.CAM.Client.Components.Layout.NoneResetting.Menu.Pages.Inventory.SelectModeHandler);
local Adders = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.Adders);
local MenuConfig = require(ReplicatedStorage.CAM.Client.Components.Layout.NoneResetting.Menu.MenuConfig);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);

local function cellSize() -- Line: 25
    -- upvalues: Platform_Handler (copy)
    local v1 = Platform_Handler.Platform.Value == "Mobile" and 0.12366199999999998 or 0.08832999999999999;

    return UDim2.fromScale(v1, v1);
end;

local u2 = faye.Info(0.2);
local UDim2_fromScale_ret = UDim2.fromScale(0.27999999999999997, 1.4);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.63, 1.4);
local u3 = {
    Vanity = "rbxassetid://81079881410330",
    Stats = "rbxassetid://130994003654653"
};

return function(u4: any, u5: table, u6: any, u7: userdata, u8: userdata, u9: any, p10: any) -- Line: 55
    -- upvalues: Items (copy), Rarities (copy), ItemIcon (copy), LocalPlayer (copy), FightingStyles (copy), Data (copy), MenuConfig (copy), Character_info_provider (copy), ScreenEffects (copy), Platform_Handler (copy), u2 (copy), UDim2_fromScale_ret2 (copy), Adders (copy), UDim2_fromScale_ret (copy), u3 (copy), BunchaIcons (copy), gameSettings (copy)
    local u11 = Items[u5.Name];
    local v12 = u4:Value(1);
    local v13 = u4:Value(0.5);
    local v14 = u4:Value(0.3);
    local v15 = u4:Value(Color3.new(1, 1, 1));
    local v16 = u4:Value(0);
    local v17 = u4:Value(0);
    local u18 = u4:Value(false);
    local u19 = u4:Value();
    local u20 = u4:Value(false);
    local Item = u9.Selected:GetItem(u5.Name);
    local u21 = u4:Value((math.clamp(Item == nil and 1 or (Item[u5.Id or u5.ItemId] or 1), 1, u5.Amount)));
    local u22 = {
        In = nil,
        LastState = nil,
        RarityColor = u11 ~= nil and Rarities.Colors[u11.Rarity or 1] or Color3.new()
    };
    local u23 = p10:Add({
        u22,
        u5,
        u20,
        v13,
        v14,
        v12,
        v15,
        v16,
        v17,
        u18,
        u19,
        u21
    }, u4):Call();
    local u24 = u4:Value(ItemIcon.For(LocalPlayer, u5.Name));

    if u5.Name == FightingStyles.TOOL_NAME then
        u4:Connect(Data.Powers.FightingStyle.Changed, function() -- Line: 93
            -- upvalues: u24 (copy), ItemIcon (ref), LocalPlayer (ref), u5 (copy)
            u24:Set(ItemIcon.For(LocalPlayer, u5.Name));
        end);
        u4:Connect(Data.Race.Changed, function() -- Line: 96
            -- upvalues: u24 (copy), ItemIcon (ref), LocalPlayer (ref), u5 (copy)
            u24:Set(ItemIcon.For(LocalPlayer, u5.Name));
        end);
    end;

    local u25 = MenuConfig.inventoryRepsExceeds(Data.Inventory.Inventory, u5.Name);
    local v26;

    if u5.Id ~= nil and true or u5.DestinctAmount <= 1 then
        v26 = Character_info_provider.GetItemFromId(LocalPlayer, u5.Id or u5.ItemId) or nil;
    else
        v26 = nil;
    end;

    local u27;

    if v26 == nil then
        u27 = false;
    else
        u27 = v26:FindFirstChild("NoSave") ~= nil;
    end;

    local v28 = u4:Create("Frame");
    local v31 = {
        u4:Create("TextButton")({
            BackgroundTransparency = 1,
            Name = "Clickbox",
            Size = UDim2.fromScale(1, 1),

            MouseEnter = function() -- Line: 116, Name: MouseEnter
                -- upvalues: u22 (copy), u23 (copy)
                u22.In = true;
                u23:Call();
            end,

            MouseLeave = function() -- Line: 120, Name: MouseLeave
                -- upvalues: u22 (copy), u23 (copy)
                u22.In = false;
                u23:Call();
            end,

            MouseButton1Click = function() -- Line: 124, Name: MouseButton1Click
                -- upvalues: ScreenEffects (ref), u9 (copy), u5 (copy), u25 (copy), u11 (copy), u23 (copy), u6 (copy), u7 (copy), u8 (copy)
                ScreenEffects.CircleClick();

                if not (u9.Enabled:Compare(true) and (u5.Id ~= nil or not u25)) then
                    if u6:Compare(true) then
                        if u5.Id ~= nil then
                            if u7.Value == u5.Id then
                                u7.Value = 0;
                                u7.ItemName.Value = "";

                                return;
                            end;

                            u7.ItemName.Value = u5.Name;
                            u7.Value = u5.Id;

                            return;
                        end;
                    else
                        if u5.Name ~= u7.ItemName.Value then
                            u7.ItemName.Value = "";
                            u7.Value = 0;
                        end;

                        if u8.Value == u5.Name then
                            u8.Value = "";

                            return;
                        end;

                        u8.Value = u5.Name;
                    end;

                    return;
                end;

                if u11 ~= nil and u11.NoDelete == true then
                    return;
                end;

                local Item2 = u9.Selected:GetItem(u5.Name);
                local v29 = u5.Id or u5.ItemId;

                if Item2 == nil then
                    u9.Selected:Add(u5.Name, {
                        [v29] = 1,
                        Count = 1
                    });

                    return;
                end;

                if Item2[v29] == nil then
                    Item2.Count = Item2.Count + 1;
                    Item2[v29] = 1;
                    u23:Call();

                    return;
                end;

                if Item2.Count <= 1 then
                    local v30 = u9;
                    v30.Selected = v30.Selected - u5.Name;

                    return;
                end;

                Item2[v29] = nil;
                Item2.Count = Item2.Count - 1;
                u23:Call();
            end
        }),
        Name = u5.Name or u5.Id,
        LayoutOrder = u5.Order or 0
    };
    local v32 = Platform_Handler.Platform.Value == "Mobile" and 0.12366199999999998 or 0.08832999999999999;
    v31.Size = UDim2.fromScale(v32, v32);
    v31[2], v31[3] = u4:Create("UIAspectRatioConstraint")({
    AspectRatio = 1
}), u4:Create("UICorner")({
    CornerRadius = UDim.new(0.1)
});
    v31.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15);
    v31.BackgroundTransparency = v17;
    v31[4], v31[5], v31[6], v31[7], v31[8], v31[9], v31[10], v31[11], v31[12] = u4:Create("Frame")({
    Name = "Fg",
    Size = UDim2.fromScale(1, 1),
    u4:Create("UICorner")({
        CornerRadius = UDim.new(0.1)
    }),
    BackgroundTransparency = v13,
    BackgroundColor3 = v15,
    u4:Create("UIGradient")({
        Rotation = -90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.6, 0.9),
            NumberSequenceKeypoint.new(0.8, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
}), u4:Create("ImageLabel")({
    Name = "Img",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(1, 1),
    Image = u24,
    ImageTransparency = v16
}), u4:Create("Frame")({
    ZIndex = 2,
    Name = "EqFg",
    Size = UDim2.new(1, -5, 1, -5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    u4:Create("UIStroke")({
        Thickness = 1,
        Color = Color3.new(1, 1, 1),
        Transparency = u4:Animation(v12, u2)
    }),
    u4:Create("UICorner")({
        CornerRadius = UDim.new(0.1)
    }),
    BackgroundTransparency = 1
}), u4:Create("UIStroke")({
    Thickness = 1,
    Color = v15,
    Transparency = v14
}), u4:State(function(p33, p34) -- Line: 251
    -- upvalues: u18 (copy), u9 (copy), u5 (copy), u21 (copy), u2 (ref), UDim2_fromScale_ret2 (ref), Adders (ref), UDim2_fromScale_ret (ref)
    if p33(u18) then
        local u35 = 1;

        local function add(p36) -- Line: 254
            -- upvalues: u35 (ref), u9 (ref), u5 (ref), u21 (ref)
            u35 = p36;
            local Item2 = u9.Selected:GetItem(u5.Name);

            if Item2 ~= nil and Item2[u5.Id or u5.ItemId] ~= nil then
                local math_clamp_ret = math.clamp(u21.Value + p36, 1, u5.Amount);
                u21:Set(math_clamp_ret);
                Item2[u5.Id or u5.ItemId] = math_clamp_ret;

                if u9.Update ~= nil then
                    u9.Update:Fire();
                end;
            end;
        end;

        local u37 = nil;

        return p34:Create("Frame")({
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -5),
            Size = UDim2.fromScale(0.9, 0.25),
            BackgroundTransparency = p34:Animation(0.2, u2, {
                From = 1
            }),
            BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
            p34:Create("UIGradient")({
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.25, 0),
                    NumberSequenceKeypoint.new(0.75, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
            }),
            p34:Create("Frame")({
                Name = "TxtHolder",
                Size = UDim2_fromScale_ret2,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                p34:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                ClipsDescendants = true,
                BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
                BackgroundTransparency = 0.5,
                p34:State(function(p38, p39) -- Line: 296
                    -- upvalues: u21 (ref), u37 (ref), u2 (ref), u35 (ref)
                    local v40 = p38(u21);

                    if u37 == nil or v40 ~= u37 then
                        if u37 == nil then
                            u37 = v40;

                            return p39:Create("TextLabel")({
                                BackgroundTransparency = 1,
                                TextScaled = true,
                                Size = UDim2.fromScale(1, 0.95),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),

                                OnClean = function(p41, p42) -- Line: 324, Name: OnClean
                                    -- upvalues: u35 (ref), u2 (ref)
                                    p41:Configure(p42)({
                                        Position = p41:Animation(UDim2.fromScale(0.5, u35 * 1 * -1), u2)
                                    });
                                end,

                                Font = Enum.Font.SourceSansBold,
                                Text = v40,
                                TextColor3 = Color3.new(1, 1, 1)
                            });
                        end;

                        u37 = v40;

                        return p39:Create("TextLabel")({
                            BackgroundTransparency = 1,
                            CleanDelay = 0.2,
                            TextScaled = true,
                            Size = UDim2.fromScale(1, 0.95),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = p39:Animation(UDim2.fromScale(0.5, 0.5), u2, {
                                From = UDim2.fromScale(0.5, u35 * 1)
                            }),
                            Font = Enum.Font.SourceSansBold,
                            Text = v40,
                            TextColor3 = Color3.new(1, 1, 1),

                            OnClean = function(p43, p44) -- Line: 311, Name: OnClean
                                -- upvalues: u35 (ref), u2 (ref)
                                p43:Configure(p44)({
                                    Position = p43:Animation(UDim2.fromScale(0.5, u35 * 1 * -1), u2)
                                });
                            end
                        });
                    end;
                end)
            }),
            Adders(p34, {
                Size = UDim2_fromScale_ret
            }, nil, function() -- Line: 339
                -- upvalues: add (copy)
                add(1);
            end),
            Adders(p34, {
                Size = UDim2_fromScale_ret,
                Position = UDim2.fromScale(1, 0.5),
                AnchorPoint = Vector2.new(1, 0.5)
            }, 90, function() -- Line: 342
                -- upvalues: add (copy)
                add(-1);
            end)
        });
    end;
end), u4:State(function(p45, u46) -- Line: 350
    -- upvalues: u19 (copy), u3 (ref)
    local u47 = p45(u19);

    if u47 ~= nil then
        return u46:Create("Frame")({
            Size = UDim2.fromScale(0.295, 0.325),
            Position = UDim2.new(0, 2, 1, -2),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 1),
            Name = "SelectFrame",
            ZIndex = 99,
            u46:Create("ImageLabel")({
                BackgroundTransparency = 1,
                Image = "rbxassetid://116594504938394",
                ImageTransparency = 0.5,
                Name = "Square",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.8)
            }),
            u46:Create("ImageLabel")({
                ZIndex = 2,
                BackgroundTransparency = 1,
                Image = "rbxassetid://115228880374136",
                Name = "Checkmark",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1)
            }),
            u46:Create("Frame")({
                ZIndex = -1,
                Name = "TxtGradient",
                BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
                BackgroundTransparency = 0.1,
                Position = UDim2.fromScale(0.835, 0.5),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.fromScale(2, 0.6),
                u46:Create("UIGradient")({
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
                }),

                function() -- Line: 393
                    -- upvalues: u47 (copy), u46 (copy), u19 (ref), u3 (ref)
                    return typeof(u47) ~= "string" and { u46:Create("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Left,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            Padding = UDim.new(-0.085, 0)
                        }), u46:Iterate(u47, function(p48, p49, p50) -- Line: 410
                            -- upvalues: u3 (ref)
                            if p49 then
                                return p50:Create("ImageLabel")({
                                    Size = UDim2.fromScale(1.5, 1.5),
                                    BackgroundTransparency = 1,
                                    Image = u3[p48],
                                    Instance.new("UIAspectRatioConstraint")
                                });
                            end;
                        end) } or u46:Create("TextLabel")({
                        Name = "Text",
                        BackgroundTransparency = 1,
                        TextScaled = true,
                        Size = UDim2.fromScale(2, 1.2),
                        Position = UDim2.fromScale(0.115, 0.5),
                        Text = u19,
                        AnchorPoint = Vector2.new(0, 0.5),
                        TextColor3 = Color3.new(1, 1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Font = Enum.Font.SourceSansSemibold
                    });
                end
            })
        });
    end;
end), function() -- Line: 429
    -- upvalues: u27 (copy), u4 (copy), BunchaIcons (ref), gameSettings (ref)
    if u27 then
        return u4:Create("ImageLabel")({
            Name = "NoSave",
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = BunchaIcons.NoSave,
            ImageTransparency = gameSettings.noSaveOverlayTransparency,
            u4:Create("UIShadow")({
                Color = gameSettings.noSaveOverlayShadowColor,
                Transparency = gameSettings.noSaveOverlayShadowTransparency,
                BlurRadius = gameSettings.noSaveOverlayShadowBlur
            })
        });
    end;
end, function(p51) -- Line: 452
    -- upvalues: u5 (copy), gameSettings (ref), u4 (copy), u20 (copy)
    if (u5.RefineLevel or 0) > 0 and (u5.Id ~= nil or u5.DestinctAmount <= 1) then
        local preferedFont = gameSettings.preferedFont;

        return u4:Create("TextLabel")({
            ZIndex = 3,
            Visible = u20,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.new(0, 4, 0, 1),
            Size = UDim2.fromScale(0.42, 0.34),
            BackgroundTransparency = 1,
            Text = `+{u5.RefineLevel}`,
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = Font.new(preferedFont.Family, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
            TextScaled = true,
            TextColor3 = Color3.new(1, 1, 1),
            u4:Create("UIStroke")({
                Thickness = 1,
                Color = Color3.fromRGB(85, 170, 255),
                u4:Create("UIGradient")({
                    Rotation = 90,
                    Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 220, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 95, 200)) }),
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.3), NumberSequenceKeypoint.new(1, 0.85) })
                })
            })
        });
    end;
end, function(p52) -- Line: 498
    -- upvalues: u5 (copy), u4 (copy), u20 (copy)
    if u5.Amount > 1 then
        return u4:Create("Frame")({
            ZIndex = 2,
            Visible = u20,
            Size = UDim2.fromScale(0.5175, 0.2875),
            Position = UDim2.new(1, -5, 0, 5),
            AnchorPoint = Vector2.new(1, 0),
            u4:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),
            u4:Create("TextLabel")({
                BackgroundTransparency = 1,
                TextScaled = true,
                Size = UDim2.fromScale(1, 0.85),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Text = `x{u5.Amount}`,
                Font = Enum.Font.SourceSansBold
            })
        });
    end;
end;

    return v28(v31);
end;