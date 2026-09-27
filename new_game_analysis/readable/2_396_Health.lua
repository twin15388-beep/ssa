-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local Color3_new_ret = Color3.new(0.031373, 0.352941, 0.156863);
local Color3_new_ret2 = Color3.new(0.333333, 1, 0.333333);
local Color3_new_ret3 = Color3.new(0.639216, 1, 0.639216);
local Color3_new_ret4 = Color3.new(0.580392, 0.039216, 0);
local Color3_new_ret5 = Color3.new(1, 0, 0);
local Color3_new_ret6 = Color3.new(1, 0.192157, 0.192157);
local UDim_new_ret = UDim.new(0.25);
local u1 = faye.Info(0.2);
local u2 = faye.Info(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

return function(u3: userdata, p4: userdata, p5: userdata, p6: userdata) -- Line: 18
    -- upvalues: faye (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), Color3_new_ret3 (copy), Utility (copy), Color3_new_ret4 (copy), Color3_new_ret5 (copy), Color3_new_ret6 (copy), UDim_new_ret (copy), u1 (copy), u2 (copy)
    local u7 = faye.new();
    local u8 = p5 or script.Humanoid;
    local u9 = nil;

    local function show() -- Line: 24
        -- upvalues: u9 (ref), faye (ref), Color3_new_ret (ref), Color3_new_ret2 (ref), Color3_new_ret3 (ref), u8 (ref), Utility (ref), Color3_new_ret4 (ref), Color3_new_ret5 (ref), Color3_new_ret6 (ref), u3 (copy), UDim_new_ret (ref), u1 (ref), u2 (ref)
        if u9 then
            return;
        end;

        u9 = faye.new();
        local u10 = u9:Value(Color3_new_ret);
        local u11 = u9:Value(Color3_new_ret2);
        local u12 = u9:Value(Color3_new_ret3);
        local u13 = u9:Value(UDim2.fromScale(1, 1));

        local function v15() -- Line: 32
            -- upvalues: u8 (ref), u10 (copy), Utility (ref), Color3_new_ret4 (ref), Color3_new_ret (ref), u11 (copy), Color3_new_ret5 (ref), Color3_new_ret2 (ref), u12 (copy), Color3_new_ret6 (ref), Color3_new_ret3 (ref), u13 (copy)
            if u8 == nil or u8.Parent == nil then
                return;
            end;

            local v14 = u8.Health / u8.MaxHealth;
            u10:Set(Utility.Lerp_Color2(Color3_new_ret4, Color3_new_ret, v14));
            u11:Set(Utility.Lerp_Color2(Color3_new_ret5, Color3_new_ret2, v14));
            u12:Set(Utility.Lerp_Color2(Color3_new_ret6, Color3_new_ret3, v14));
            u13:Set(UDim2.fromScale(v14, 1));
        end;

        u9:Connect(u8:GetPropertyChangedSignal("Health"), v15);
        v15();
        u9:Create("Frame")({
            Size = UDim2.fromScale(1, 0.175),
            Name = "ZHealth",
            Parent = u3,
            BackgroundTransparency = 1,
            u9:Create("Frame")({
                Size = UDim2.new(0.7, -2, 0.7, -2),
                Name = "Actual",
                u9:Create("UICorner")({
                    CornerRadius = UDim_new_ret
                }),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = u10,
                u9:Create("UIStroke")({
                    Thickness = 3,
                    Transparency = 0.75,
                    Color = u11
                }),
                u9:Create("Frame")({
                    Size = u9:Animation(u13, u1),
                    Name = "Bar",
                    ZIndex = 2,
                    BackgroundColor3 = u12,
                    u9:Create("UICorner")({
                        CornerRadius = UDim_new_ret
                    })
                }),
                u9:Create("Frame")({
                    Size = u9:Animation(u13, u2),
                    Name = "BarRed",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    u9:Create("UICorner")({
                        CornerRadius = UDim_new_ret
                    })
                })
            })
        });
    end;

    local function hide() -- Line: 84
        -- upvalues: u9 (ref)
        if u9 then
            u9:Destroy();
            u9 = nil;
        end;
    end;

    local function onHealth() -- Line: 91
        -- upvalues: u8 (ref), show (copy), u9 (ref)
        if u8 == nil or u8.Parent == nil then
            return;
        end;

        if u8.Health < u8.MaxHealth then
            show();

            return;
        end;

        if u9 then
            u9:Destroy();
            u9 = nil;
        end;
    end;

    u7:Connect(u8:GetPropertyChangedSignal("Health"), onHealth);

    if u8 ~= nil and u8.Parent ~= nil then
        if u8.Health < u8.MaxHealth then
            show();
        elseif u9 then
            u9:Destroy();
            u9 = nil;
        end;
    end;

    return function() -- Line: 102
        -- upvalues: u9 (ref), u7 (copy)
        if u9 then
            u9:Destroy();
            u9 = nil;
        end;

        u7:Destroy();
    end;
end;