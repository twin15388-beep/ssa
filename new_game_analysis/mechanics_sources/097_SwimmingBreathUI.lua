-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local u1 = faye.Info(0.2);
local spritesheetplayer = require(ReplicatedStorage.Packages.spritesheetplayer);
local u2 = { 5, 2 };
local u3 = u2[1] * u2[2];

return function(p4: any, p5: table?) -- Line: 11
    -- upvalues: faye (copy), u1 (copy), spritesheetplayer (copy), u2 (copy), u3 (copy)
    local u6 = faye.new();
    local v7 = p5 and (p5.ratio or 1) or 1;
    local v8 = p5 and p5.bubbles or { true, true, true, true, true };
    local u9 = u6:Value(v7);
    local v10 = u6:Value(1 - v7);
    local v11 = u6:Value(UDim2.fromScale(v7, 2));
    local u12 = u6:Value(0);
    local v13 = {
        u6:Value(v8[1] ~= false),
        u6:Value(v8[2] ~= false),
        u6:Value(v8[3] ~= false),
        u6:Value(v8[4] ~= false),
        u6:Value(v8[5] ~= false)
    };
    u6:Create("Frame")({
        Parent = p4,
        Name = "BreathBar",
        Size = UDim2.fromScale(0.25, 0.225),
        BackgroundTransparency = 1,
        CleanDelay = u1.Time,
        u6:Create("Frame")({
            Size = UDim2.fromScale(0.7, 0.1),
            AnchorPoint = Vector2.new(0.5, 1),
            Name = "Bg",
            BackgroundColor3 = Color3.new(1, 1, 1),
            Position = u6:Do(function(p14) -- Line: 38
                -- upvalues: u9 (copy), u12 (copy)
                local v15 = p14(u9);

                if p14(u12) ~= 1 or v15 >= 0.35 then
                    return UDim2.fromScale(0.5, 1);
                end;

                local v16 = 1 - v15 / 0.35;

                return UDim2.fromScale(0.5, 1) + UDim2.fromOffset(math.random(-6, 6) * v16, math.random(-3, 3) * v16);
            end),
            u6:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),
            BackgroundTransparency = u6:Animation(0.35, u1, {
                From = 1
            }),

            OnClean = function() -- Line: 51, Name: OnClean
                -- upvalues: u6 (copy), u1 (ref)
                return {
                    BackgroundTransparency = u6:Animation(1, u1)
                };
            end,

            u6:Create("UIStroke")({
                Thickness = 2,
                Color = Color3.new(1, 1, 1),
                Transparency = u6:Animation(0.8, u1, {
                    From = 1
                }),

                OnClean = function() -- Line: 60, Name: OnClean
                    -- upvalues: u6 (copy), u1 (ref)
                    return {
                        Transparency = u6:Animation(1, u1)
                    };
                end
            }),
            u6:Create("Frame")({
                Size = u6:Animation(v11, u1),
                Name = "Bar",
                u6:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                BackgroundColor3 = Color3.new(0.305882, 0.745098, 1),
                BackgroundTransparency = u6:Animation(0, u1, {
                    From = 1
                }),

                OnClean = function() -- Line: 76, Name: OnClean
                    -- upvalues: u6 (copy), u1 (ref)
                    return {
                        BackgroundTransparency = u6:Animation(1, u1)
                    };
                end
            }),
            u6:Create("Frame")({
                Size = UDim2.fromScale(0.5, 10),
                Instance.new("UIAspectRatioConstraint"),
                Position = UDim2.fromScale(0.5, -4.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Name = "Bubble",
                u6:Create("UIListLayout")({
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(-0.4, 0)
                }),
                u6:Iterate(v13, function(p17: any, u18: any, p19: any, p20: userdata?) -- Line: 96
                    -- upvalues: spritesheetplayer (ref), u2 (ref), u6 (copy), u1 (ref), u3 (ref)
                    local u21 = spritesheetplayer.new(u2, "rbxassetid://96728660702021", p20);

                    local function refresh() -- Line: 98
                        -- upvalues: u18 (copy), u21 (copy)
                        if u18.Value then
                            u21:PlayBackwards();

                            return;
                        end;

                        u21:Play(-1);
                    end;

                    u6:Configure((u21:GetUI():FindFirstChild("Image")))({
                        ImageTransparency = u6:Animation(0, u1, {
                            From = 1
                        }),

                        OnClean = function() -- Line: 115, Name: OnClean
                            -- upvalues: u6 (ref), u1 (ref)
                            return {
                                ImageTransparency = u6:Animation(1, u1)
                            };
                        end
                    });

                    if u18.Value then
                        u21:To(1);
                    else
                        u21:To(u3 + 1);
                    end;

                    p19:Connect(u18.Changed, refresh);
                end)
            })
        })
    });

    return function() -- Line: 137
        -- upvalues: u6 (copy)
        u6:Destroy();
    end, u9, v10, v11, u12, v13;
end;