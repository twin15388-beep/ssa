-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local StatTypes = require(ReplicatedStorage.CAM.Global.Types.StatTypes);
local StatRow = require(ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.HudBottomLeft.StatRow);
local Color3_new_ret = Color3.new(1, 0.9, 0.9);

return function(u1: userdata, p2: userdata) -- Line: 24
    -- upvalues: faye (copy), StatRow (copy), Color3_new_ret (copy), StatTypes (copy)
    local u3 = faye.new();
    local u4 = u3:Value({});
    local u5 = {};
    local u6 = 0;
    local u7 = nil;

    local function show() -- Line: 31
        -- upvalues: u7 (ref), faye (ref), u1 (copy), u4 (copy), StatRow (ref)
        if u7 ~= nil then
            return;
        end;

        u7 = faye.new();
        u7:Create("Frame")({
            Name = "HDebuffs",
            Parent = u1,
            Size = UDim2.fromScale(1, 0.4),
            BackgroundTransparency = 1,
            u7:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 2)
            }),
            u7:AdvancedIterate(u4, function(p8, p9, p10) -- Line: 48
                -- upvalues: StatRow (ref)
                return StatRow(p10, p8, p9);
            end)
        });
    end;

    local function hide() -- Line: 54
        -- upvalues: u7 (ref)
        if u7 ~= nil then
            u7:Destroy();
            u7 = nil;
        end;
    end;

    local function setOn(p11: string, p12: boolean) -- Line: 61
        -- upvalues: u5 (copy), u3 (copy), Color3_new_ret (ref), u6 (ref), show (copy), u4 (copy), u7 (ref)
        local v13 = u5[p11];

        if not p12 then
            if v13 ~= nil then
                u5[p11] = nil;
                u4:Remove(p11);
                v13.Value:Destroy();
                v13.Text:Destroy();
                v13.Dim:Destroy();
                v13.Tint:Destroy();
                u6 = u6 - 1;

                if u6 <= 0 and u7 ~= nil then
                    u7:Destroy();
                    u7 = nil;
                end;
            end;

            return;
        end;

        if v13 ~= nil then
            return;
        end;

        local v14 = {
            Value = u3:Value(true),
            Text = u3:Value(""),
            Dim = u3:Value(0),
            Tint = u3:Value(Color3_new_ret)
        };
        u5[p11] = v14;
        u6 = u6 + 1;

        if u6 == 1 then
            show();
        end;

        u4:Add(p11, v14);
    end;

    local u15 = false;

    local function bindHolder(u16: userdata) -- Line: 95
        -- upvalues: u15 (ref), StatTypes (ref), setOn (copy), u3 (copy)
        if u15 then
            return;
        end;

        u15 = true;

        for i, v in u16:GetAttributes() do
            if not StatTypes.IsMetaAttribute(i) and v == true then
                setOn(StatTypes.AttributeToStat(i), true);
            end;
        end;

        u3:Connect(u16.AttributeChanged, function(p17: string) -- Line: 106
            -- upvalues: StatTypes (ref), setOn (ref), u16 (copy)
            if StatTypes.IsMetaAttribute(p17) then
                return;
            end;

            setOn(StatTypes.AttributeToStat(p17), u16:GetAttribute(p17) == true);
        end);
    end;

    local Debuffs = p2:FindFirstChild("Debuffs");

    if Debuffs == nil then
        u3:Connect(p2.ChildAdded, function(p18) -- Line: 116
            -- upvalues: bindHolder (copy)
            if p18.Name == "Debuffs" then
                bindHolder(p18);
            end;
        end);
    else
        bindHolder(Debuffs);
    end;

    return function() -- Line: 123
        -- upvalues: u7 (ref), u3 (copy)
        if u7 ~= nil then
            u7:Destroy();
            u7 = nil;
        end;

        u3:Destroy();
    end;
end;