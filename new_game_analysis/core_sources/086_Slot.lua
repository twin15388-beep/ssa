-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextService = game:GetService("TextService");
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local faye = require(ReplicatedStorage.Packages.faye);
local SourceSansBold = Enum.Font.SourceSansBold;
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(0, 0, 0);
local Color3_new_ret3 = Color3.new();
local Color3_new_ret4 = Color3.new(1, 1, 1);
local Color3_new_ret5 = Color3.new(1, 1, 1);
local Color3_new_ret6 = Color3.new(0, 0, 0);
local u1 = faye.Info(0.25);

return function(p2: any, u3: any, u4: userdata) -- Line: 25
    -- upvalues: DemonArts (copy), Color3_new_ret3 (copy), Color3_new_ret4 (copy), Color3_new_ret5 (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), Color3_new_ret6 (copy), u1 (copy), ScreenEffects (copy), TextService (copy), SourceSansBold (copy)
    local function iconOf(p5: string?) -- Line: 29
        -- upvalues: DemonArts (ref)
        local v6;

        if p5 == nil then
            v6 = nil;
        else
            v6 = DemonArts[p5];
        end;

        return v6 ~= nil and v6.Icon or "";
    end;

    local v10 = p2:Do(function(p7) -- Line: 36
        -- upvalues: u4 (copy), DemonArts (ref)
        local v8 = p7(u4) or "";
        local v9;

        if v8 == nil then
            v9 = nil;
        else
            v9 = DemonArts[v8];
        end;

        return v9 ~= nil and v9.Icon or "";
    end);
    local v11 = {
        BgColor = p2:Value(Color3_new_ret3),
        BgTransparency = p2:Value(0.6),
        TextColor3 = p2:Value(Color3_new_ret4),
        StrokeColor = p2:Value(Color3_new_ret5)
    };
    local v13 = p2:Space(function(p12) -- Line: 47
        -- upvalues: u3 (copy), u4 (copy), Color3_new_ret (ref), Color3_new_ret2 (ref), Color3_new_ret6 (ref)
        if u3:Compare(u4.Name) then
            p12.BgColor:Set(Color3_new_ret);
            p12.BgTransparency:Set(0);
            p12.TextColor3:Set(Color3_new_ret2);
            p12.StrokeColor:Set(Color3_new_ret6);

            return;
        end;

        p12.BgColor:Reset();
        p12.BgTransparency:Reset();
        p12.TextColor3:Reset();
        p12.StrokeColor:Reset();
    end);
    v13:Connect(u3.Changed);
    v13:Add(v11, p2, true):Call();
    local u14 = p2:Value(0);
    local u15 = p2:Value(UDim2.new(0, 0, 1, 0));

    return p2:Create("Frame")({
        Name = u4.Name,
        Size = u15,

        AbsoluteSizeOnChangedInit = function(p16: userdata, p17) -- Line: 74, Name: AbsoluteSizeOnChangedInit
            -- upvalues: u14 (copy)
            u14:Set(p17.Y);
        end,

        BackgroundColor3 = p2:Animation(v11.BgColor, u1),
        BackgroundTransparency = p2:Animation(v11.BgTransparency, u1),
        p2:Create("UICorner")({
            CornerRadius = UDim.new(1, 0)
        }),
        p2:Create("UIStroke")({
            Color = p2:Animation(v11.StrokeColor, u1),
            BorderOffset = UDim.new(0, -3),
            Transparency = 0.825,
            p2:Create("UIGradient")({
                Rotation = 45,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.4) })
            })
        }),
        p2:Create("TextButton")({
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1.2, 1.2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),

            MouseButton1Click = function() -- Line: 98, Name: MouseButton1Click
                -- upvalues: ScreenEffects (ref), u3 (copy), u4 (copy)
                ScreenEffects.CircleClick();
                u3:Set(u4.Name);
            end
        }),
        p2:Create("Frame")({
            Name = "Content",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            p2:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,

                AbsoluteContentSizeOnChangedInit = function(p18: userdata, p19) -- Line: 118, Name: AbsoluteContentSizeOnChangedInit
                    -- upvalues: u15 (copy)
                    u15:Set(UDim2.new(0, p19.X, 1, 0));
                end
            }),
            p2:Create("Frame")({
                Name = "LeftPad",
                LayoutOrder = 0,
                BackgroundTransparency = 1,
                Visible = p2:Do(function(p20) -- Line: 127
                    -- upvalues: u4 (copy), DemonArts (ref)
                    local v21 = p20(u4) or "";
                    local v22;

                    if v21 == "" then
                        v22 = false;
                    else
                        local v23;

                        if v21 == nil then
                            v23 = nil;
                        else
                            v23 = DemonArts[v21];
                        end;

                        v22 = (v23 ~= nil and v23.Icon or "") == "";
                    end;

                    return v22;
                end),
                Size = UDim2.fromScale(0.3, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY
            }),
            p2:Create("Frame")({
                Name = "IconSlot",
                LayoutOrder = 1,
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                BackgroundTransparency = 1,
                Visible = p2:Do(function(p24) -- Line: 145
                    -- upvalues: u4 (copy), DemonArts (ref)
                    local v25 = p24(u4) or "";
                    local v26;

                    if v25 == "" then
                        v26 = true;
                    else
                        local v27;

                        if v25 == nil then
                            v27 = nil;
                        else
                            v27 = DemonArts[v25];
                        end;

                        v26 = (v27 ~= nil and v27.Icon or "") ~= "";
                    end;

                    return v26;
                end),
                p2:Create("ImageLabel")({
                    Name = "Icon",
                    Visible = p2:Do(function(p28) -- Line: 151
                        -- upvalues: u4 (copy), DemonArts (ref)
                        local v29 = p28(u4) or "";
                        local v30;

                        if v29 == nil then
                            v30 = nil;
                        else
                            v30 = DemonArts[v29];
                        end;

                        return (v30 ~= nil and v30.Icon or "") ~= "";
                    end),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.7, 0.7),
                    BackgroundTransparency = 1,
                    Image = v10,
                    p2:Create("UIShadow")({
                        Transparency = 0.65,
                        BlurRadius = UDim.new(1, 0),
                        Offset = UDim2.fromScale(0.05, 0.05)
                    })
                })
            }),
            p2:Create("TextLabel")({
                Name = "ResultName",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                TextSize = p2:Do(function(p31) -- Line: 67, Name: textSizeOf
                    -- upvalues: u14 (copy)
                    return p31(u14) * 0.45;
                end),
                Size = p2:Do(function(p32) -- Line: 170
                    -- upvalues: u14 (copy), TextService (ref), u4 (copy), SourceSansBold (ref)
                    local v33 = p32(u14) * 0.45;
                    local X = TextService:GetTextSize(p32(u4) or "", v33, SourceSansBold, Vector2.new(100000, 100000)).X;

                    return UDim2.fromOffset(X, v33);
                end),
                Font = SourceSansBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextColor3 = p2:Animation(v11.TextColor3, u1),
                Text = p2:Do(function(p34) -- Line: 33, Name: heldOf
                    -- upvalues: u4 (copy)
                    return p34(u4) or "";
                end)
            }),
            p2:Create("Frame")({
                Name = "RightPad",
                LayoutOrder = 3,
                BackgroundTransparency = 1,
                Visible = p2:Do(function(p35) -- Line: 185
                    -- upvalues: u4 (copy)
                    return (p35(u4) or "") ~= "";
                end),
                Size = UDim2.fromScale(0.3, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY
            })
        })
    });
end;