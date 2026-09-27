-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = game:GetService("Players").LocalPlayer;
Utility.GetData(LocalPlayer, true);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);

return function(u1: any, u2: table, u3: any, u4: userdata, u5: userdata) -- Line: 18
    -- upvalues: Items (copy), Rarities (copy), ScreenEffects (copy)
    local v6 = Items[u2.Name];
    local v7 = u1.Info(0.2);
    local u8 = u1:Value(1);
    local u9 = u1:Value(0.5);
    local u10 = u1:Value(0.3);
    local u11 = false;
    local u12 = nil;

    local function Update() -- Line: 30
        -- upvalues: u3 (copy), u4 (copy), u2 (copy), u5 (copy), u11 (ref), u12 (ref), u9 (copy), u10 (copy), u8 (copy)
        local v13 = u3:Compare(true) and u4.Value == u2.Id and 1 or (u3:Compare(false) and (u5.Value == u2.Name or u2.Name == u4.ItemName.Value) and 1 or (u11 == true and 2 or 3));

        if v13 ~= u12 then
            if v13 == 1 then
                u9:Set(0.25);
                u10:Set(0.1);
                u8:Set(0.1);
            elseif v13 == 2 then
                u9:Set(0.25);
                u10:Set(0.185);
                u8:Reset();
            else
                u8:Reset();
                u9:Reset();
                u10:Reset();
            end;

            u12 = v13;
        end;
    end;

    Update();
    u1:Connect(u3.Changed, Update);
    u1:Connect(u5:GetPropertyChangedSignal("Value"), Update);
    u1:Connect(u4:GetPropertyChangedSignal("Value"), Update);
    local v14 = v6.Icon or "";
    local v15 = v6 ~= nil and Rarities.Colors[v6.Rarity or 1] or Color3.new();

    return u1:Create("Frame")({
        u1:Create("TextButton")({
            BackgroundTransparency = 1,
            Name = "Clickbox",
            Size = UDim2.fromScale(1, 1),

            MouseEnter = function() -- Line: 71, Name: MouseEnter
                -- upvalues: u11 (ref), Update (copy)
                u11 = true;
                Update();
            end,

            MouseLeave = function() -- Line: 75, Name: MouseLeave
                -- upvalues: u11 (ref), Update (copy)
                u11 = false;
                Update();
            end,

            MouseButton1Click = function() -- Line: 79, Name: MouseButton1Click
                -- upvalues: ScreenEffects (ref), u3 (copy), u2 (copy), u4 (copy), u5 (copy)
                ScreenEffects.CircleClick();

                if u3:Compare(true) then
                    if u2.Id ~= nil then
                        if u4.Value == u2.Id then
                            u4.Value = 0;
                            u4.ItemName.Value = "";

                            return;
                        end;

                        u4.ItemName.Value = u2.Name;
                        u4.Value = u2.Id;
                    end;
                else
                    if u2.Name ~= u4.ItemName.Value then
                        u4.ItemName.Value = "";
                        u4.Value = 0;
                    end;

                    if u5.Value == u2.Name then
                        u5.Value = "";

                        return;
                    end;

                    u5.Value = u2.Name;
                end;
            end
        }),
        Name = u2.Name or u2.Id,
        Size = UDim2.fromScale(0.08832999999999999, 0.08832999999999999),
        u1:Create("UICorner")({
            CornerRadius = UDim.new(0.1)
        }),
        BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
        u1:Create("Frame")({
            Name = "Fg",
            Size = UDim2.fromScale(1, 1),
            u1:Create("UICorner")({
                CornerRadius = UDim.new(0.1)
            }),
            BackgroundTransparency = u1:Animation(u9, v7),
            BackgroundColor3 = v15,
            u1:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.2),
                    NumberSequenceKeypoint.new(0.6, 0.9),
                    NumberSequenceKeypoint.new(0.8, 1),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
        }),
        u1:Create("ImageLabel")({
            Name = "Img",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            Image = v14
        }),
        u1:Create("Frame")({
            ZIndex = 2,
            Name = "EqFg",
            Size = UDim2.new(1, -5, 1, -5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            u1:Create("UIStroke")({
                Thickness = 1,
                Color = Color3.new(1, 1, 1),
                Transparency = u1:Animation(u8, v7)
            }),
            u1:Create("UICorner")({
                CornerRadius = UDim.new(0.1)
            }),
            BackgroundTransparency = 1
        }),
        u1:Create("UIStroke")({
            Thickness = 1,
            Color = v15,
            Transparency = u1:Animation(u10, v7)
        }),

        function(p16) -- Line: 163
            -- upvalues: u2 (copy), u1 (copy)
            if u2.Amount > 1 then
                return u1:Create("Frame")({
                    ZIndex = 2,
                    Size = UDim2.fromScale(0.45, 0.25),
                    Position = UDim2.new(1, -5, 0, 5),
                    AnchorPoint = Vector2.new(1, 0),
                    u1:Create("UICorner")({
                        CornerRadius = UDim.new(1)
                    }),
                    u1:Create("TextLabel")({
                        BackgroundTransparency = 1,
                        TextScaled = true,
                        Size = UDim2.fromScale(1, 0.85),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Text = `x{u2.Amount}`,
                        Font = Enum.Font.SourceSansBold
                    })
                });
            end;
        end
    });
end;