-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local u1 = RunService:IsServer();
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local u2;

if u1 then
    u2 = require(ServerStorage.SAM.Utility.QuestCompletion);
else
    u2 = nil;
end;

local function resolveTarget(p3: table?) -- Line: 31
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

local function findChild(p9: userdata?, p10: string) -- Line: 49
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

local function questHolder(p13: userdata?) -- Line: 60
    -- upvalues: Utility (copy)
    if p13 == nil then
        return nil;
    end;

    local Data = Utility.GetData(p13);
    local v14 = Data ~= nil and Data:FindFirstChild("Quests") or nil;

    return v14 ~= nil and v14:FindFirstChild("Holder") or nil;
end;

local function taskLabels(p15: userdata?) -- Line: 67
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
        local Tasks = child:FindFirstChild("Tasks");

        if Tasks ~= nil then
            local v19 = child;

            for _, child2 in ipairs(Tasks:GetChildren()) do
                if child2:FindFirstChild("Value") ~= nil and child2:FindFirstChild("Max") ~= nil then
                    table.insert(v16, v19.Name .. " / " .. child2.Name);
                end;
            end;
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
            Type = "Task",
            Name = "Quest / Task",
            Required = true,

            Suggester = function(p20: table) -- Line: 94, Name: Suggester
                -- upvalues: taskLabels (copy), resolveTarget (copy)
                return taskLabels((resolveTarget(p20))), true;
            end,

            Completer = function(p21: string, p22: table) -- Line: 101, Name: Completer
                -- upvalues: u1 (copy), taskLabels (copy), resolveTarget (copy)
                if p21 == nil or p21 == "" then
                    return nil;
                end;

                if u1 then
                    return p21;
                end;

                local v23 = p21:lower();
                local v24 = taskLabels((resolveTarget(p22)));

                for _, v in ipairs(v24) do
                    if v:lower() == v23 then
                        return v;
                    end;
                end;

                for _, v in ipairs(v24) do
                    if v:lower():sub(1, #v23) == v23 then
                        return v;
                    end;
                end;

                return p21;
            end
        }
    },

    Server = function(p25: userdata, p26: table, p27: string) -- Line: 116, Name: Server
        -- upvalues: findChild (copy), Utility (copy), Quests (copy), u2 (copy)
        if type(p26) ~= "table" or #p26 == 0 then
            error("CompleteTask: no valid players targeted");
        end;

        if type(p27) ~= "string" or p27 == "" then
            error("CompleteTask: pick a task as \"<Quest> / <Task>\"");
        end;

        local v28 = p27:find(" / ", 1, true);

        if v28 == nil then
            error((`CompleteTask: "{p27}" is not a "<Quest> / <Task>" label`));
        end;

        local v29 = p27:sub(1, v28 - 1);
        local v30 = p27:sub(v28 + 3);

        for _, v in ipairs(p26) do
            local v31;

            if v == nil then
                v31 = nil;
            else
                local Data = Utility.GetData(v);
                local v32 = Data ~= nil and Data:FindFirstChild("Quests") or nil;
                v31 = v32 ~= nil and v32:FindFirstChild("Holder") or nil;
            end;

            local v33 = findChild(v31, v29);
            local v34;

            if v33 == nil then
                v34 = nil;
            else
                v34 = v33:FindFirstChild("Tasks") or nil;
            end;

            local v35 = findChild(v34, v30);
            local v36;

            if v35 == nil then
                v36 = nil;
            else
                v36 = v35:FindFirstChild("Value") or nil;
            end;

            local v37;

            if v35 == nil then
                v37 = nil;
            else
                v37 = v35:FindFirstChild("Max") or nil;
            end;

            if v33 == nil or (v36 == nil or v37 == nil) then
                warn((`CompleteTask: {v.Name} has no active task "{p27}"`));
            else
                if v36.Value < v37.Value then
                    v36.Value = v37.Value;
                    local QuestString = v33:FindFirstChild("QuestString");
                    local QuestInfo = Quests.GetQuestInfo(QuestString ~= nil and QuestString.Value or v33.Name);
                    local v38;

                    if QuestInfo == nil or QuestInfo.TaskSpecs == nil then
                        v38 = nil;
                    else
                        v38 = QuestInfo.TaskSpecs[v35.Name] or nil;
                    end;

                    if v38 ~= nil then
                        u2.Notify(v, v38.CompletionNotify);
                    end;
                end;

                u2.TryComplete(v, v33);
            end;
        end;
    end
};