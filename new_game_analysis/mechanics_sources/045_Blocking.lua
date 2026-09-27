-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local u1 = faye.Info(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u2 = faye.Info(0.4);
local u3 = faye.Info(0.2);
local u4 = faye.Info(0.5, Enum.EasingStyle.Back);
local u5 = faye.Info(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local u6 = faye.Info(0.1);
local u7 = faye.Info(0.2);
local Color3_fromRGB_ret = Color3.fromRGB(90, 255, 68);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);

return function(u8: userdata, u9: userdata, p10: userdata, p11: userdata, u12: any) -- Line: 20
    -- upvalues: faye (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u5 (copy), u6 (copy), u2 (copy), u7 (copy), u1 (copy), u3 (copy), u4 (copy), Players (copy), Utility (copy)
    local u13 = nil;
    local u14 = false;
    local u15 = nil;

    local function onBlocking(p16) -- Line: 25
        -- upvalues: u13 (ref), faye (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), u8 (copy), u5 (ref), u6 (ref), u2 (ref), u7 (ref), u1 (ref), u3 (ref), u4 (ref)
        if u13 then
            u13:Destroy();
            u13 = nil;
        end;

        local Blocking = p16:FindFirstChild("Blocking");

        if not Blocking then
            return;
        end;

        u13 = faye.new();
        local u17 = u13:Value(UDim2.fromScale(1, 1));
        local u18 = u13:Value(0.7);
        local u19 = u13:Value(Color3.new(0.678431, 0.678431, 0.678431));
        local u20 = u13:Value(Color3.new(1, 1, 1));
        local u21 = u13:Value(Color3.new(1, 1, 1));
        local u22 = u13:Value(UDim2.fromScale(1.1, 1.1));
        local u23 = u13:Value(0.3);
        local u24 = nil;

        local function updatePercent() -- Line: 53
            -- upvalues: Blocking (copy), u24 (ref), u20 (copy), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), u22 (copy), u17 (copy), u18 (copy), u19 (copy), u21 (copy), u23 (copy)
            local v25 = Blocking.Value - (Blocking:GetAttribute("D") or 0);

            if u24 ~= nil then
                if u24 < v25 then
                    u20:Set(Color3_fromRGB_ret);
                elseif v25 < u24 then
                    u20:Set(Color3_fromRGB_ret2);
                    u22:Refresh();
                end;
            end;

            u17:Refresh();
            u18:Refresh();
            u19:Refresh();
            u21:Refresh();
            u24 = v25;
            u23:Set(1 - v25 / Blocking.MaxValue);
        end;

        u13:Connect(Blocking:GetPropertyChangedSignal("Value"), updatePercent);
        u13:Connect(Blocking:GetAttributeChangedSignal("D"), updatePercent);
        u13:Connect(Blocking:GetPropertyChangedSignal("MaxValue"), updatePercent);
        updatePercent();
        local Attribute = Blocking:GetAttribute("BlockRegen");
        local Attribute2 = Blocking:GetAttribute("AddedBlockPoints");
        local u26 = nil;
        local v27;

        if Attribute then
            v27 = Attribute > 0;
        else
            v27 = Attribute;
        end;

        local v28;

        if Attribute2 then
            v28 = Attribute2 > 0;
        else
            v28 = Attribute2;
        end;

        if v27 or v28 then
            u26 = {};

            if v28 then
                local v29 = {
                    Prefix = "+",
                    Size = 0.6,
                    Value = string.format("%g", Attribute2)
                };
                table.insert(u26, v29);
            end;

            if v27 then
                local v30 = {
                    Prefix = "x",
                    Size = 0.3,
                    Transparency = 0.5,
                    Value = string.format("%.2f", 1 + Attribute)
                };
                table.insert(u26, v30);
            end;
        end;

        local v31 = u13:Create("Frame");
        local v32 = {
            Parent = u8,
            u13:Create("UIAspectRatioConstraint")({
                AspectRatio = 1.65
            }),
            Size = UDim2.fromScale(0.5, 1),
            BackgroundTransparency = 1
        };
        local v33;

        if u26 then
            v33 = u13:SpecialThread(function(u34: any, p35: userdata) -- Line: 117
                -- upvalues: u5 (ref), u26 (ref), u6 (ref), u2 (ref), u7 (ref)
                task.wait(0.25);

                return u34:Create("Frame")({
                    Name = "Added",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.45),
                    Size = UDim2.fromScale(0.5454545454545455, 0.9),
                    ZIndex = 9,
                    CleanDelay = 0.5,
                    BackgroundTransparency = 1,
                    u34:Create("Frame")({
                        Name = "holder",
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = u34:Animation(UDim2.fromScale(1, 1), u5, {
                            From = UDim2.fromScale(2, 2)
                        }),
                        u34:Create("UIListLayout")({
                            FillDirection = Enum.FillDirection.Vertical,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            Padding = UDim.new(-0.125, 0)
                        }),
                        BackgroundTransparency = 1,
                        u34:Iterate(u26, function(p36: any, p37: any, p38: any, p39: userdata?) -- Line: 139
                            -- upvalues: u34 (copy), u6 (ref), u2 (ref), u7 (ref)
                            return u34:Create("TextLabel")({
                                Size = UDim2.fromScale(1, p37.Size),
                                BackgroundTransparency = 1,
                                Text = `{p37.Prefix}{p37.Value}`,
                                TextScaled = true,
                                TextTransparency = u34:Animation(p37.Transparency or 0, u6, {
                                    From = 1
                                }),
                                u34:Create("UIStroke")({
                                    Thickness = u34:Animation(0, u2, {
                                        From = 2
                                    }),
                                    Transparency = u34:Animation(0, u6, {
                                        From = 1
                                    })
                                }),

                                OnClean = function(p40) -- Line: 151, Name: OnClean
                                    -- upvalues: u7 (ref)
                                    return {
                                        TextTransparency = p40:Animation(1, u7)
                                    };
                                end,

                                TextColor3 = u34:Animation(Color3.new(0, 0, 0), u2, {
                                    From = Color3.new(1, 1, 1)
                                }),
                                Font = Enum.Font.SourceSansBold
                            });
                        end)
                    })
                });
            end, {
                Lifetime = 1.25,
                YieldSafe = true
            });
        else
            v33 = nil;
        end;

        v32[2], v32[3] = v33, u13:Create("Frame")({
    Name = "Center",
    Size = UDim2.fromScale(0.6060606060606061, 1),
    Position = UDim2.fromScale(0.5, 1),
    AnchorPoint = Vector2.new(0.5, 1),
    BackgroundTransparency = 1,
    u13:Create("ImageLabel")({
        Name = "Bg",
        ZIndex = -1,
        Image = "rbxassetid://95215444880583",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = u13:Animation(u17, u1, {
            AlwaysFrom = UDim2.fromScale(1.75, 1.75)
        }),
        ImageTransparency = u13:Animation(u18, u2, {
            AlwaysFrom = 0.3
        }),
        ImageColor3 = u13:Animation(u19, u2, {
            AlwaysFrom = u20
        })
    }),
    u13:Create("ImageLabel")({
        Name = "Img",
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://85221511423087",
        ImageColor3 = u13:Animation(u21, u3, {
            AlwaysFrom = u20
        }),
        u13:Create("UIGradient")({
            Rotation = -90,
            Offset = u13:Do(function(p41: function, p42: any, p43: userdata?) -- Line: 191
                -- upvalues: u23 (copy)
                return Vector2.new(0, p41(u23) - 0.5);
            end),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.499, 0),
                NumberSequenceKeypoint.new(0.501, 1),
                NumberSequenceKeypoint.new(1, 1)
            })
        })
    }),
    u13:Create("Frame")({
        Name = "OutlineHolder",
        Size = u13:Animation(u22, u4, {
            AlwaysFrom = UDim2.fromScale(1.5, 1.5)
        }),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        u13:Create("Frame")({
            Name = "Left",
            Size = UDim2.fromScale(0.5, 1),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            u13:Create("ImageLabel")({
                Name = "Img",
                Size = UDim2.fromScale(2, 1),
                ImageColor3 = u13:Animation(u21, u3, {
                    AlwaysFrom = u20
                }),
                BackgroundTransparency = 1,
                Image = "rbxassetid://82904759785021",
                u13:Create("UIGradient")({
                    Rotation = u13:Do(function(p44) -- Line: 221
                        -- upvalues: u23 (copy)
                        local v45 = p44(u23) * 360 - 180;

                        return math.clamp(v45, 0, 180);
                    end),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0.499, 0),
                        NumberSequenceKeypoint.new(0.501, 1),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                })
            })
        }),
        u13:Create("Frame")({
            Name = "Right",
            Size = UDim2.fromScale(0.5, 1),
            Position = UDim2.fromScale(0.5, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            u13:Create("ImageLabel")({
                Name = "Img",
                Size = UDim2.fromScale(2, 1),
                Position = UDim2.fromScale(-1, 0),
                BackgroundTransparency = 1,
                ImageColor3 = u13:Animation(u21, u3, {
                    AlwaysFrom = u20
                }),
                Image = "rbxassetid://82904759785021",
                u13:Create("UIGradient")({
                    Rotation = u13:Do(function(p46) -- Line: 247
                        -- upvalues: u23 (copy)
                        local v47 = p46(u23) * 360;

                        return math.clamp(v47, 0, 180);
                    end),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.499, 1),
                        NumberSequenceKeypoint.new(0.501, 0),
                        NumberSequenceKeypoint.new(1, 0)
                    })
                })
            })
        })
    })
});
        v31(v32);
    end;

    local function bind(u48) -- Line: 264
        -- upvalues: u14 (ref), onBlocking (copy), u12 (copy), u15 (ref), u13 (ref)
        if u48 == nil or u14 then
            return;
        end;

        if u48:FindFirstChild("Blocking") then
            onBlocking(u48);
        end;

        if u12 then
            u15 = u12:Extend();
            u15:Connect(u48.ChildAdded, function(p49) -- Line: 281
                -- upvalues: onBlocking (ref), u48 (copy)
                if p49.Name == "Blocking" then
                    onBlocking(u48);
                end;
            end);
            u15:Connect(u48.ChildRemoved, function(p50) -- Line: 286
                -- upvalues: u48 (copy), onBlocking (ref), u13 (ref)
                if p50.Name == "Blocking" then
                    if u48:FindFirstChild("Blocking") then
                        onBlocking(u48);

                        return;
                    end;

                    if u13 then
                        u13:Destroy();
                        u13 = nil;
                    end;
                end;
            end);
        end;
    end;

    if Players:GetPlayerFromCharacter(u9) then
        task.spawn(function() -- Line: 309
            -- upvalues: bind (copy), Utility (ref), u9 (copy)
            bind(Utility.getvaluesfolder(u9, true));
        end);
    else
        bind(Utility.getvaluesfolder(u9));
    end;

    return function() -- Line: 316
        -- upvalues: u14 (ref), u13 (ref), u15 (ref), u12 (copy)
        u14 = true;

        if u13 then
            u13:Destroy();
        end;

        if u15 then
            u15:Destroy();

            if u12 then
                u12:Remove(u15);
            end;

            u15 = nil;
        end;
    end;
end;