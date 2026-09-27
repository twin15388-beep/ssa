-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local script_ListRecipe = require(script.ListRecipe);
local script_Recipe = require(script.Recipe);
local faye = require(ReplicatedStorage.Packages.faye);
local Crafting = require(ReplicatedStorage.CAM.Global.Crafting);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Searchbar = require(ReplicatedStorage.CAM.Client.Components.Misc.Utilities.Searchbar);
local u1 = faye.Info(0.45);
local UDim2_fromScale_ret = UDim2.fromScale(0, 0.04);

local function Panel(p2: string?, p3: any, u4: userdata, p5: userdata, p6: any) -- Line: 28
    -- upvalues: Crafting (copy), Utility (copy), Players (copy), u1 (copy), UDim2_fromScale_ret (copy), Searchbar (copy), script_ListRecipe (copy), script_Recipe (copy)
    local u7 = Crafting.ForStation(p2);
    local Data = Utility.GetData(Players.LocalPlayer);
    local v8;

    if Data == nil then
        v8 = nil;
    else
        v8 = Data:FindFirstChild("Inventory") or nil;
    end;

    local v9;

    if v8 == nil then
        v9 = nil;
    else
        v9 = v8:FindFirstChild("Inventory") or nil;
    end;

    local u10 = v9;
    local u11 = {};
    local u12 = p3:Value("");
    local StringValue = Instance.new("StringValue");
    local u13 = {};
    local u14 = p3:Value(u13);

    local function updateShown() -- Line: 42
        -- upvalues: u13 (copy), u11 (copy), StringValue (copy), u7 (copy), u10 (ref), Crafting (ref), Players (ref), u14 (copy)
        table.clear(u13);
        table.clear(u11);
        local string_lower_ret = string.lower(StringValue.Value);

        for i, v in u7 do
            local v15 = i;
            local v16 = v;
            local v17 = false;

            for _, v2 in v.keep or {} do
                if u10 == nil or u10:FindFirstChild(v2) == nil then
                    v17 = true;
                end;
            end;

            if not (v17 or v16.listedWhenHeld and Crafting.SpentCopy(Players.LocalPlayer, v16.required[1].name, v16.requiredTier) == nil) then
                if table.find(u11, v16.result) == nil then
                    table.insert(u11, v16.result);
                end;

                if string_lower_ret == "" then
                    u13[v15] = v16;
                else
                    local string_lower_ret2 = string.lower(v16.result);

                    if string.sub(string_lower_ret2, 1, #string_lower_ret) == string_lower_ret then
                        u13[v15] = v16;
                    end;
                end;
            end;
        end;

        u14:Refresh();
    end;

    updateShown();
    p3:Connect(StringValue:GetPropertyChangedSignal("Value"), updateShown);

    if u10 ~= nil then
        p3:Connect(u10.ChildAdded, updateShown);
        p3:Connect(u10.ChildRemoved, updateShown);
    end;

    local u18 = p3:Value(UDim2.new(1, 0, 0, 20));
    local u19 = p3:Value(UDim2.new());
    local u22 = p3:Space(function(p20) -- Line: 80
        -- upvalues: u12 (copy)
        local v21 = u12:Compare(p20.Id) and 2 or (p20.In:Compare(true) and 1 or 0);

        if p20.State == v21 then
            return;
        end;

        if v21 == 2 then
            p20.BgColor:Set(Color3.new(0.3, 0.3, 0.3));
            p20.BgTransparency:Set(0.3);
            p20.StrokeTransparency:Set(0.2);
            p20.StrokeThickness:Set(2);
            p20.NameGlowTransparency:Set(0.4);
            p20.TextPosition:Set(UDim2.fromScale(0.54, 0.5));
            p20.IconSize:Set(UDim2.fromScale(1.35, 1.35));
            p20.IconBgRotation:Set(225);
        elseif v21 == 1 then
            p20.BgColor:Set(Color3.new(0.18, 0.18, 0.18));
            p20.BgTransparency:Set(0.5);
            p20.StrokeTransparency:Set(0.6);
            p20.StrokeThickness:Set(1.5);
            p20.NameGlowTransparency:Set(0.6);
            p20.TextPosition:Set(UDim2.fromScale(0.52, 0.5));
            p20.IconSize:Set(UDim2.fromScale(1.3, 1.3));
            p20.IconBgRotation:Reset();
        else
            p20.BgColor:Reset();
            p20.BgTransparency:Reset();
            p20.StrokeTransparency:Reset();
            p20.StrokeThickness:Reset();
            p20.NameGlowTransparency:Reset();
            p20.TextPosition:Reset();
            p20.IconSize:Reset();
            p20.IconBgRotation:Reset();
        end;

        p20.State = v21;
    end);
    u22:Connect(u12.Changed);

    return p3:Create("CanvasGroup")({
        Parent = u4,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        GroupTransparency = p3:Animation(0, u1, {
            From = 1
        }),
        Position = p3:Animation(UDim2.fromScale(0, 0), u1, {
            From = UDim2_fromScale_ret
        }),

        OnClean = function(p23) -- Line: 125, Name: OnClean
            -- upvalues: u1 (ref), UDim2_fromScale_ret (ref)
            return {
                GroupTransparency = p23:Animation(1, u1),
                Position = p23:Animation(UDim2_fromScale_ret, u1)
            };
        end,

        p3:Create("Frame")({
            Name = "BlacksmithFrame",
            CleanDelay = u1.Time,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromScale(0.4, 0.5),
            p3:Create("UICorner")({
                CornerRadius = UDim.new(0.025)
            }),
            BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
            p3:Create("UIGradient")({
                Rotation = 90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.4) })
            }),
            p3:Create("Frame")({
                Name = "ActualHolder",
                p3:Create("UIShadow")({
                    BlurRadius = UDim.new(1),
                    Color = Color3.new(0.15, 0.15, 0.15),
                    Spread = UDim2.fromScale(-0.5, -0.5)
                }),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 6, 0.5),
                Size = UDim2.new(0.35, 0, 1, -12),
                p3:Create("UICorner")({
                    CornerRadius = UDim.new(0.025)
                }),
                p3:Create("UIGradient")({
                    Rotation = 90,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 0.9) })
                }),
                BackgroundColor3 = Color3.new(0.4, 0.4, 0.4),
                p3:Create("Frame")({
                    Name = "SearchbarHolder",
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 4),
                    Size = UDim2.new(1, -8, 0.07),
                    BackgroundTransparency = 1,
                    (Searchbar(p3, u11, StringValue, "Search recipes", true))
                }),
                p3:Create("CanvasGroup")({
                    Name = "ListMask",
                    Size = UDim2.new(1, 0, 0.9299999999999999, -8),
                    Position = UDim2.new(0, 0, 0.07, 8),
                    BackgroundTransparency = 1,
                    p3:Create("UIGradient")({
                        Rotation = 90,
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 1),
                            NumberSequenceKeypoint.new(0.03, 0),
                            NumberSequenceKeypoint.new(0.84, 0),
                            NumberSequenceKeypoint.new(1, 1)
                        })
                    }),
                    p3:Create("ScrollingFrame")({
                        Name = "recipesList",
                        Size = UDim2.fromScale(1, 1),
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        ScrollBarThickness = 0,
                        BackgroundTransparency = 1,
                        CanvasSize = u19,

                        AbsoluteSizeOnChangedInit = function(p24: userdata, p25) -- Line: 205, Name: AbsoluteSizeOnChangedInit
                            -- upvalues: u18 (copy), u4 (copy)
                            if p25.X <= 0 then
                                return;
                            end;

                            local UDim2_new = UDim2.new;
                            local v26 = p25.X * 0.22;
                            local v27 = u4:FindFirstChildOfClass("UIScale");
                            u18:Set(UDim2_new(1, 0, 0, v26 / ((v27 == nil or v27.Scale <= 0) and 1 or v27.Scale)));
                        end,

                        p3:Create("Frame")({
                            Name = "Holder",
                            Size = UDim2.new(1, -4, 1, -4),
                            Position = UDim2.fromScale(0.5, 0.5),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            p3:Create("UIListLayout")({
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                VerticalAlignment = Enum.VerticalAlignment.Top,
                                Padding = UDim.new(0, 3),

                                AbsoluteContentSizeOnChangedInit = function(p28: userdata, p29) -- Line: 220, Name: AbsoluteContentSizeOnChangedInit
                                    -- upvalues: u19 (copy), u4 (copy)
                                    local UDim2_new = UDim2.new;
                                    local v30 = p29.Y * 1.2;
                                    local v31 = u4:FindFirstChildOfClass("UIScale");
                                    u19:Set(UDim2_new(0, 0, 0, v30 / ((v31 == nil or v31.Scale <= 0) and 1 or v31.Scale)));
                                end
                            }),
                            p3:Iterate(u14, function(p32: any, p33: any, p34: any, p35: userdata?) -- Line: 224
                                -- upvalues: script_ListRecipe (ref), u22 (copy), u12 (copy), u18 (copy)
                                return script_ListRecipe(p34, u22, u12, p32, p33, u18);
                            end)
                        })
                    })
                })
            }),
            script_Recipe(p3, u12, function() -- Line: 72, Name: uiScale
                -- upvalues: u4 (copy)
                local v36 = u4:FindFirstChildOfClass("UIScale");

                return (v36 == nil or v36.Scale <= 0) and 1 or v36.Scale;
            end)
        })
    });
end;

return function(p37: table?) -- Line: 239
    -- upvalues: Panel (copy)
    local u38;

    if p37 == nil then
        u38 = nil;
    else
        u38 = p37.Station;
    end;

    return function(p39: any, p40: userdata, p41: userdata, p42: any) -- Line: 241
        -- upvalues: Panel (ref), u38 (copy)
        return Panel(u38, p39, p40, p41, p42);
    end;
end;