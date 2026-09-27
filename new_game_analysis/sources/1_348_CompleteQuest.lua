-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local u1 = RunService:IsServer();
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u2;

if u1 then
    u2 = require(ServerStorage.SAM.Utility.QuestCompletion);
else
    u2 = nil;
end;

local function resolveTarget(p3: table?) -- Line: 27
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;
    local v4;

    if p3 == nil then
        v4 = nil;
    else
        v4 = p3[1] or nil;
    end;

    if v4 == nil or (v4 == "" or v4:lower() == "me") then
        return LocalPlayer;
    end;

    local v5 = v4:lower();
    local v6 = nil;

    for _, v in Players:GetPlayers() do
        local v7 = v.Name:lower();
        local v8 = v.DisplayName:lower();

        if v7 == v5 or v8 == v5 then
            return v;
        end;

        if v6 == nil and (v7:sub(1, #v5) == v5 or v8:sub(1, #v5) == v5) then
            v6 = v;
        end;
    end;

    return v6 or LocalPlayer;
end;

local function findChild(p9: userdata?, p10: string) -- Line: 43
    if p9 == nil then
        return nil;
    end;

    local v11 = p9:FindFirstChild(p10);

    if v11 ~= nil then
        return v11;
    end;

    local v12 = p10:lower();

    for _, child in ipairs(p9:GetChildren()) do
        if child.Name:lower() == v12 then
            return child;
        end;
    end;

    return nil;
end;

local function questHolder(p13: userdata?) -- Line: 54
    -- upvalues: Utility (copy)
    if p13 == nil then
        return nil;
    end;

    local Data = Utility.GetData(p13);
    local v14 = Data ~= nil and Data:FindFirstChild("Quests") or nil;

    return v14 ~= nil and v14:FindFirstChild("Holder") or nil;
end;

local function questNames(p15: userdata?) -- Line: 61
    -- upvalues: Utility (copy)
    local v16 = {};
    local v17;

    if p15 == nil then
        v17 = nil;
    else
        local Data = Utility.GetData(p15);
        local v18 = Data ~= nil and Data:FindFirstChild("Quests") or nil;
        v17 = v18 ~= nil and v18:FindFirstChild("Holder") or nil;
    end;

    if v17 == nil then
        return v16;
    end;

    for _, child in ipairs(v17:GetChildren()) do
        if child:FindFirstChild("Tasks") ~= nil then
            table.insert(v16, child.Name);
        end;
    end;

    return v16;
end;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Quest",
            Name = "Quest",
            Required = true,

            Suggester = function(p19: table) -- Line: 84, Name: Suggester
                -- upvalues: questNames (copy), resolveTarget (copy)
                return questNames((resolveTarget(p19))), true;
            end,

            Completer = function(p20: string, p21: table) -- Line: 89, Name: Completer
                -- upvalues: u1 (copy), questNames (copy), resolveTarget (copy)
                if p20 == nil or p20 == "" then
                    return nil;
                end;

                if u1 then
                    return p20;
                end;

                local v22 = p20:lower();
                local v23 = questNames((resolveTarget(p21)));

                for _, v in ipairs(v23) do
                    if v:lower() == v22 then
                        return v;
                    end;
                end;

                for _, v in ipairs(v23) do
                    if v:lower():sub(1, #v22) == v22 then
                        return v;
                    end;
                end;

                return p20;
            end
        }
    },

    Server = function(p24: userdata, p25: table, p26: string) -- Line: 104, Name: Server
        -- upvalues: findChild (copy), Utility (copy), u2 (copy)
        if type(p25) ~= "table" or #p25 == 0 then
            error("CompleteQuest: no valid players targeted");
        end;

        if type(p26) ~= "string" or p26 == "" then
            error("CompleteQuest: pick a quest");
        end;

        for _, v in ipairs(p25) do
            local v27;

            if v == nil then
                v27 = nil;
            else
                local Data = Utility.GetData(v);
                local v28 = Data ~= nil and Data:FindFirstChild("Quests") or nil;
                v27 = v28 ~= nil and v28:FindFirstChild("Holder") or nil;
            end;

            local v29 = findChild(v27, p26);
            local v30;

            if v29 == nil then
                v30 = nil;
            else
                v30 = v29:FindFirstChild("Tasks") or nil;
            end;

            if v30 == nil then
                warn((`CompleteQuest: {v.Name} has no active quest "{p26}"`));
            else
                local v31 = v;

                for _, child in ipairs(v30:GetChildren()) do
                    local Value = child:FindFirstChild("Value");
                    local Max = child:FindFirstChild("Max");

                    if Value ~= nil and (Max ~= nil and Value.Value < Max.Value) then
                        Value.Value = Max.Value;
                    end;
                end;

                if not u2.TryComplete(v31, v29) then
                    warn((`CompleteQuest: "{p26}" on {v31.Name} did not complete (no countable tasks?)`));
                end;
            end;
        end;
    end
};