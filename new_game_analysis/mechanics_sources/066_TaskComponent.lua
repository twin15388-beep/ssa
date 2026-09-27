-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Color3_new_ret = Color3.new(0.72, 0.72, 0.72);

return function(u1: any, u2: userdata, u3: function, u4: table?, u5: number?, u6: string?, p7: number) -- Line: 25
    -- upvalues: Color3_new_ret (copy), BunchaIcons (copy)
    local u8 = u1:Value(0.85);
    local u9 = u1:Value(Color3.new());
    local u10 = u1:Value(1);
    local u11 = u1:Value(Color3.new(1, 1, 1));
    local u12 = u1:Value(UDim2.fromScale(0.225, 0.225));
    local u13 = u1:Value(0.25);
    local u14 = u1:Value(Color3.new(1, 1, 1));
    local u15 = u1:Value(UDim2.fromScale(0.2, 0.6));
    local u16 = u1:Value(UDim2.fromScale(0.6, 0.55));
    local u17 = u1:Value(Color3.new(1, 1, 1));
    local u18 = u1:Value(0);
    local Value = u2:FindFirstChild("Value");
    local Max = u2:FindFirstChild("Max");
    local u19;

    if u4 == nil or u4.Icon == nil then
        u19 = false;
    else
        u19 = u4.Icon ~= "";
    end;

    local Need = u2:FindFirstChild("Need");
    local v20;

    if Need == nil or u2.Parent == nil then
        v20 = nil;
    else
        v20 = u2.Parent:FindFirstChild(Need.Value) or nil;
    end;

    local u21;

    if v20 == nil then
        u21 = nil;
    else
        u21 = v20:FindFirstChild("Value") or nil;
    end;

    local u22;

    if v20 == nil then
        u22 = nil;
    else
        u22 = v20:FindFirstChild("Max") or nil;
    end;

    local v23;

    if u21 == nil then
        v23 = false;
    else
        v23 = u22 ~= nil;
    end;

    local v24;

    if v23 then
        v24 = u21.Value < u22.Value;
    else
        v24 = v23;
    end;

    local u25 = u1:Value(v24);

    if v23 then
        u1:Reactive(function(p26: function) -- Line: 62
            -- upvalues: u25 (copy), u21 (copy), u22 (copy)
            u25:Set(p26(u21) < p26(u22));
        end);
    end;

    local u27 = u1:Value(Value.Value == Max.Value);

    local function updState() -- Line: 69
        -- upvalues: u27 (copy), u16 (copy), u15 (copy), u12 (ref), u10 (copy), u8 (copy), u18 (copy), u13 (copy), u9 (copy), u11 (copy), u17 (copy), u14 (copy), u25 (copy), Color3_new_ret (ref)
        if u27.Value == true then
            u16:Set(UDim2.fromScale(0.5, 0.55));
            u15:Set(UDim2.fromScale(0.2, 1));
            u12 = UDim2.fromScale(0.4, 0.4);
            u10:Set(0.5);
            u8:Set(0.5);
            u18:Set(0.5);
            u13:Set(0.85);
            u9:Set(Color3.new(0.4, 1, 0.4));
            u11:Set(u9.Value);
            u17:Set(u9.Value);
            u14:Set(Color3.new());

            return;
        end;

        u16:Reset();
        u15:Reset();
        u10:Reset();
        u8:Reset();
        u18:Reset();
        u13:Reset();
        u9:Reset();
        u11:Reset();
        u17:Reset();
        u14:Reset();

        if u25.Value == true then
            u18:Set(0.35);
            u11:Set(Color3_new_ret);
            u9:Set(Color3_new_ret);
        end;
    end;

    updState();
    u27.Changed:Connect(updState);
    u25.Changed:Connect(updState);
    local u28;

    if type(u6) == "string" then
        u28 = u6 ~= "";
    else
        u28 = false;
    end;

    local u29 = v23 and `Do {Need.Value} first` or nil;
    local u30 = u28 or u29 ~= nil;
    local u31 = p7 * 0.1724137931034483;
    local u32 = u31 * 0.8;

    local function hintShown(p33: function) -- Line: 130
        -- upvalues: u27 (copy), u28 (copy), u29 (copy), u25 (copy)
        if p33(u27) == true then
            return false;
        end;

        local v34 = u28;

        if not v34 then
            if u29 == nil then
                v34 = false;
            else
                v34 = p33(u25) == true;
            end;
        end;

        return v34;
    end;

    local v35 = u1:Create("Frame");
    local v40 = {
        Size = u1:Do(function(p36: function) -- Line: 135
            -- upvalues: u27 (copy), u28 (copy), u29 (copy), u25 (copy), u31 (copy), u32 (copy)
            local v37;

            if p36(u27) == true then
                v37 = false;
            else
                v37 = u28;

                if not v37 then
                    if u29 == nil then
                        v37 = false;
                    else
                        v37 = p36(u25) == true;
                    end;
                end;
            end;

            local v38;

            if v37 then
                v38 = u31 + 2 + u32;
            else
                v38 = u31;
            end;

            return UDim2.new(1, 0, 0, v38);
        end),
        BackgroundTransparency = 1,
        Name = u2.Name,
        LayoutOrder = u1:Do(function(p39: function) -- Line: 146
            -- upvalues: u27 (copy), u25 (copy), u5 (copy)
            return (u5 or 0) + (p39(u27) and -1000 or (p39(u25) and 1000 or 0));
        end)
    };
    local v41 = u1:Create("Frame")({
        Name = "Bg",
        Size = UDim2.new(1, 0, 0, u31),
        BackgroundColor3 = Color3.new(),
        BackgroundTransparency = 0.75,
        u1:Create("UIGradient")({
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 0.5), NumberSequenceKeypoint.new(1, 0.95) })
        }),
        u1:Create("UICorner")({
            CornerRadius = UDim.new(1)
        })
    });
    local v42 = u1:Create("Frame");
    local v43 = {
        Name = "Holder",
        Size = UDim2.new(1, 0, 0, u31)
    };
    local v44;

    if u19 then
        v44 = UDim2.fromOffset(3, 0);
    else
        v44 = UDim2.new();
    end;

    v43.Position = v44;
    v43.BackgroundTransparency = 1;
    v43[1], v43[2], v43[3] = u1:Create("UIListLayout")({
    Name = "List",
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    FillDirection = Enum.FillDirection.Horizontal,

    [u1:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p45) -- Line: 181
        p45.Parent.Parent.Bg.Size = UDim2.new((p45.AbsoluteContentSize.X + 15) / p45.Parent.Parent.AbsoluteSize.X, 0, 0, 25);
    end
}), u1:Create("TextLabel")({
    Name = "Txt",
    Size = UDim2.fromScale(2, 0.9),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.fromScale(0, 0.5),
    Text = u1:Do(function(p46: function, p47: any, p48: userdata?) -- Line: 191
        -- upvalues: Value (copy), u27 (copy), Max (copy), u3 (copy), u2 (copy)
        local v49 = p46(Value);
        u27:Set(v49 == Max.Value);
        u3();

        return `{u2.Name} {v49}/{Max.Value}`;
    end),
    TextScaled = true,
    Font = Enum.Font.SourceSansSemibold,
    TextColor3 = u17,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = u18,
    u1:Create("UIStroke")({
        Transparency = 0.75,
        Thickness = 2
    }),
    u1:State(function(p50: function, p51: any, p52: userdata?) -- Line: 206
        -- upvalues: u27 (copy)
        if p50(u27) then
            return p51:Create("Frame")({
                Size = UDim2.new(1, 6, 0, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.55),
                BackgroundColor3 = Color3.new(0.75, 1, 0.75)
            });
        end;
    end),

    TextBoundsOnChangedInit = function(p53: userdata) -- Line: 216, Name: TextBoundsOnChangedInit
        if p53.TextBounds.X > 0 then
            p53.Size = UDim2.fromScale(p53.TextBounds.X / p53.Parent.Parent.AbsoluteSize.X, 1);
        end;
    end
}), u1:State(function(p54: function, p55: any, p56: userdata?) -- Line: 225
    -- upvalues: u25 (copy), u27 (copy), BunchaIcons (ref), u18 (copy), u19 (copy), u4 (copy), u17 (copy), u15 (copy), u16 (copy), u12 (ref), u14 (copy), u13 (copy), u9 (copy), u8 (copy), u11 (copy), u10 (copy)
    if p54(u25) and p54(u27) ~= true then
        return p55:Create("ImageLabel")({
            Name = "Selector",
            Size = UDim2.fromScale(0.2, 0.8),
            Instance.new("UIAspectRatioConstraint"),
            ScaleType = Enum.ScaleType.Fit,
            BackgroundTransparency = 1,
            Image = BunchaIcons.Locked,
            ImageTransparency = u18,
            ImageColor3 = Color3.new(1, 1, 1)
        });
    end;

    if u19 then
        return p55:Create("ImageLabel")({
            Name = "Selector",
            Size = UDim2.fromScale(0.2, 0.8),
            Instance.new("UIAspectRatioConstraint"),
            ScaleType = Enum.ScaleType.Fit,
            BackgroundTransparency = 1,
            Image = u4.Icon,
            ImageTransparency = u18,
            ImageColor3 = u17,
            p55:State(function(p57: function, p58: any, p59: userdata?) -- Line: 251
                -- upvalues: u27 (ref)
                if p57(u27) then
                    return p58:Create("Frame")({
                        Size = UDim2.new(1, 6, 0, 1),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.55),
                        BackgroundColor3 = Color3.new(0.75, 1, 0.75)
                    });
                end;
            end)
        });
    end;

    return p55:Create("Frame")({
        Name = "Selector",
        Size = u15,
        Instance.new("UIAspectRatioConstraint"),
        BackgroundTransparency = 1,
        p55:Create("Frame")({
            Name = "Outer",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = u16,
            Size = u12,
            p55:Create("UICorner")({
                CornerRadius = UDim.new(0.2)
            }),
            Rotation = 45,
            BackgroundColor3 = u14,
            BackgroundTransparency = u13,
            p55:Create("UIStroke")({
                Color = u9,
                Transparency = u8
            }),
            p55:Create("Frame")({
                Name = "Inner",
                BackgroundColor3 = u11,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.6, 0.6),
                BackgroundTransparency = u10,
                p55:Create("UICorner")({
                    CornerRadius = UDim.new(0.2)
                })
            })
        })
    });
end);
    v40[1], v40[2], v40[3] = v41, v42(v43), function() -- Line: 299
    -- upvalues: u30 (copy), u1 (copy), u31 (copy), u32 (copy), hintShown (copy), u29 (copy), u25 (copy), u6 (copy)
    if u30 then
        return u1:Create("Frame")({
            Name = "Hint",
            Position = UDim2.new(0, 0, 0, u31 + 2),
            Size = UDim2.new(1, 0, 0, u32),
            BackgroundTransparency = 1,
            Visible = u1:Do(hintShown),
            u1:Create("Frame")({
                Name = "Bg",
                Size = UDim2.new(0, 40, 1, 0),
                BackgroundColor3 = Color3.new(),
                BackgroundTransparency = 0.65,
                u1:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                u1:Create("TextLabel")({
                    Name = "Txt",
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    TextTransparency = 0.15,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 6, 0.5, 0),
                    Size = UDim2.new(100, 0, 1, -4),
                    Text = u1:Do(function(p60: function) -- Line: 323
                        -- upvalues: u29 (ref), u25 (ref), u6 (ref)
                        return (u29 == nil or p60(u25) ~= true) and (u6 or "") or u29;
                    end),
                    Font = Enum.Font.SourceSansItalic,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left,

                    TextBoundsOnChangedInit = function(p61: userdata) -- Line: 334, Name: TextBoundsOnChangedInit
                        if p61.TextBounds.X > 0 then
                            p61.Parent.Size = UDim2.new(0, p61.TextBounds.X + 12, 1, 0);
                        end;
                    end
                })
            })
        });
    end;
end;

    return v35(v40);
end;