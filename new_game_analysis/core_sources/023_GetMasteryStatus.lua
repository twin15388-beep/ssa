-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local MovesetsIcons = require(script.Parent.MovesetsIcons);
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local CurPower = game.ReplicatedStorage.CAM.Client.Controllers.Skills_Provider:FindFirstChild("CurPower");
local u1 = {
    Changed = simplesignal.new()
};

local function getIcon(p2, p3) -- Line: 15
    -- upvalues: MovesetsIcons (copy)
    return MovesetsIcons[p2] or p3 and p3.Icon or nil;
end;

local function getMasteryName(p4, p5) -- Line: 19
    if type(p5) == "string" then
        return p5;
    end;

    if type(p5) == "table" then
        return p5.Value or p4;
    end;

    return p4;
end;

function u1.GetMasteries() -- Line: 28
    -- upvalues: CurPower (copy), Breathings (copy), DemonArts (copy), FightingStyles (copy), MovesetsIcons (copy), Items (copy)
    local Value = CurPower.Value;

    if #Value <= 0 then
        return nil;
    end;

    local string_split_ret = string.split(Value, ",");
    local v6 = {};

    for _, v in ipairs(string_split_ret) do
        local v7 = Breathings[v] or (DemonArts[v] or FightingStyles[v]);

        if v7 then
            local Mastery = v7.Mastery;

            if Mastery ~= false then
                local v8;

                if type(Mastery) == "string" then
                    v8 = Mastery;
                elseif type(Mastery) == "table" then
                    v8 = Mastery.Value or v;
                else
                    v8 = v;
                end;

                table.insert(v6, {
                    Name = v8,
                    Icon = MovesetsIcons[v8] or (v7 and v7.Icon or nil),
                    Mastery = Mastery or nil
                });
            end;
        else
            local v9 = Items[v];

            if v9 then
                local Mastery = v9.Mastery;

                if Mastery ~= false then
                    local v10;

                    if type(Mastery) == "string" then
                        v10 = Mastery;
                    elseif type(Mastery) == "table" then
                        v10 = Mastery.Value or v;
                    else
                        v10 = v;
                    end;

                    table.insert(v6, {
                        Name = v10,
                        Icon = MovesetsIcons[v10] or (v9 and v9.Icon or nil),
                        Mastery = Mastery or nil
                    });
                end;
            end;
        end;
    end;

    return v6;
end;

function updateMasteries()
    -- upvalues: u1 (copy)
    u1.Changed:Fire(u1.GetMasteries());
end;

CurPower.Changed:Connect(updateMasteries);

return u1;