-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local QuestStates = ReplicatedStorage:WaitForChild("QuestStates");
local cleanit = require(ReplicatedStorage.Packages.cleanit);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};

local function getState(p2: string) -- Line: 56
    -- upvalues: u1 (copy), QuestStates (copy)
    local v3 = u1[p2];

    if v3 ~= nil then
        return v3;
    end;

    local v4 = QuestStates:FindFirstChild(p2);

    if v4 == nil or not v4:IsA("ModuleScript") then
        return nil;
    end;

    local success, result = pcall(require, v4);

    if success and typeof(result) == "table" then
        u1[p2] = result;

        return result;
    end;

    warn(`[QuestStates] Failed to load state module '{p2}':`, result);

    return nil;
end;

local u5 = {};

local function asFunction(p6) -- Line: 83
    if typeof(p6) == "function" then
        return p6;
    end;

    return nil;
end;

local function callDo(p7: function?, u8: userdata, u9: any) -- Line: 87
    -- upvalues: LocalPlayer (copy)
    local u10 = p7;

    if typeof(u10) ~= "function" then
        u10 = nil;
    end;

    if u10 == nil then
        return;
    end;

    task.spawn(function() -- Line: 90
        -- upvalues: u10 (ref), LocalPlayer (ref), u8 (copy), u9 (copy)
        local success, result = pcall(u10, LocalPlayer, u8, u9);

        if not success then
            warn(`[QuestStates] Do error ({u8.Name}):`, result);
        end;
    end);
end;

local function stopTask(p11: table, u12: userdata) -- Line: 98
    -- upvalues: LocalPlayer (copy)
    local u13 = p11.tasks[u12];

    if u13 == nil then
        return;
    end;

    p11.tasks[u12] = nil;
    task.spawn(function() -- Line: 102
        -- upvalues: u13 (copy), LocalPlayer (ref), u12 (copy)
        if u13.stop ~= nil then
            local success, result = pcall(u13.stop, LocalPlayer, u12, u13.clean);

            if not success then
                warn(`[QuestStates] task Stop error ({u12.Name}):`, result);
            end;
        end;

        u13.clean:Destroy();
    end);
end;

local Holder = Utility.GetData(LocalPlayer, true):WaitForChild("Quests"):WaitForChild("Holder");

local function questAdded(u14: userdata) -- Line: 113
    -- upvalues: getState (copy), u5 (copy), cleanit (copy), LocalPlayer (copy), Quests (copy)
    local v15 = getState(u14.Name);

    if v15 == nil then
        return;
    end;

    if u5[u14] ~= nil then
        return;
    end;

    local Tasks = u14:WaitForChild("Tasks", 5);

    if Tasks == nil or u14.Parent == nil then
        return;
    end;

    if u5[u14] ~= nil then
        return;
    end;

    local u16 = {
        clean = cleanit.new()
    };
    local Stop = v15.Stop;

    if typeof(Stop) ~= "function" then
        Stop = nil;
    end;

    u16.questStop = Stop;
    u16.tasks = {};
    u16.watch = cleanit.new();
    u5[u14] = u16;
    local clean = u16.clean;
    local Do = v15.Do;

    if typeof(Do) ~= "function" then
        Do = nil;
    end;

    if Do ~= nil then
        task.spawn(function() -- Line: 90
            -- upvalues: Do (ref), LocalPlayer (ref), u14 (copy), clean (copy)
            local success, result = pcall(Do, LocalPlayer, u14, clean);

            if not success then
                warn(`[QuestStates] Do error ({u14.Name}):`, result);
            end;
        end);
    end;

    local Tasks2 = v15.Tasks;

    if typeof(Tasks2) == "table" then
        for _, child in ipairs(Tasks:GetChildren()) do
            local u17 = Tasks2[child.Name];

            if typeof(u17) == "table" then
                local Value = child:FindFirstChild("Value");
                local Max = child:FindFirstChild("Max");

                if Value ~= nil and Max ~= nil then
                    local function activate() -- Line: 141
                        -- upvalues: u5 (ref), u14 (copy), u16 (copy), child (copy), Value (copy), Max (copy), Quests (ref), cleanit (ref), u17 (copy), LocalPlayer (ref)
                        if u5[u14] ~= u16 then
                            return;
                        end;

                        if u16.tasks[child] ~= nil then
                            return;
                        end;

                        if Value.Value >= Max.Value then
                            return;
                        end;

                        if not Quests.TaskNeedMet(child) then
                            return;
                        end;

                        local v18 = {
                            clean = cleanit.new()
                        };
                        local Stop2 = u17.Stop;

                        if typeof(Stop2) ~= "function" then
                            Stop2 = nil;
                        end;

                        v18.stop = Stop2;
                        u16.tasks[child] = v18;
                        local u19 = child;
                        local clean2 = v18.clean;
                        local Do2 = u17.Do;

                        if typeof(Do2) ~= "function" then
                            Do2 = nil;
                        end;

                        if Do2 == nil then
                            return;
                        end;

                        task.spawn(function() -- Line: 90
                            -- upvalues: Do2 (ref), LocalPlayer (ref), u19 (copy), clean2 (copy)
                            local success, result = pcall(Do2, LocalPlayer, u19, clean2);

                            if not success then
                                warn(`[QuestStates] Do error ({u19.Name}):`, result);
                            end;
                        end);
                    end;

                    activate();
                    u16.watch:Connect(Value.Changed, function() -- Line: 153
                        -- upvalues: Value (copy), Max (copy), u16 (copy), child (copy), LocalPlayer (ref), activate (copy)
                        if Value.Value < Max.Value then
                            if u16.tasks[child] == nil then
                                task.defer(activate);
                            end;

                            return;
                        end;

                        local v20 = u16;
                        local u21 = child;
                        local u22 = v20.tasks[u21];

                        if u22 == nil then
                            return;
                        end;

                        v20.tasks[u21] = nil;
                        task.spawn(function() -- Line: 102
                            -- upvalues: u22 (copy), LocalPlayer (ref), u21 (copy)
                            if u22.stop ~= nil then
                                local success, result = pcall(u22.stop, LocalPlayer, u21, u22.clean);

                                if not success then
                                    warn(`[QuestStates] task Stop error ({u21.Name}):`, result);
                                end;
                            end;

                            u22.clean:Destroy();
                        end);
                    end);
                    local Need = child:FindFirstChild("Need");
                    local v23;

                    if Need == nil or Need.Value == "" then
                        v23 = nil;
                    else
                        v23 = Tasks:FindFirstChild(Need.Value) or nil;
                    end;

                    local v24;

                    if v23 == nil then
                        v24 = nil;
                    else
                        v24 = v23:FindFirstChild("Value") or nil;
                    end;

                    if v24 ~= nil then
                        u16.watch:Connect(v24.Changed, function() -- Line: 171
                            -- upvalues: activate (copy)
                            task.defer(activate);
                        end);
                    end;
                end;
            end;
        end;
    end;
end;

local function questRemoved(u25: userdata) -- Line: 181
    -- upvalues: u5 (copy), LocalPlayer (copy)
    local u26 = u5[u25];

    if u26 == nil then
        return;
    end;

    u5[u25] = nil;
    u26.watch:Destroy();

    for i in pairs(u26.tasks) do
        local u27 = u26.tasks[i];

        if u27 ~= nil then
            u26.tasks[i] = nil;
            task.spawn(function() -- Line: 102
                -- upvalues: u27 (copy), LocalPlayer (ref), i (copy)
                if u27.stop ~= nil then
                    local success, result = pcall(u27.stop, LocalPlayer, i, u27.clean);

                    if not success then
                        warn(`[QuestStates] task Stop error ({i.Name}):`, result);
                    end;
                end;

                u27.clean:Destroy();
            end);
        end;
    end;

    task.spawn(function() -- Line: 189
        -- upvalues: u26 (copy), LocalPlayer (ref), u25 (copy)
        if u26.questStop ~= nil then
            local success, result = pcall(u26.questStop, LocalPlayer, u25, u26.clean);

            if not success then
                warn(`[QuestStates] quest Stop error ({u25.Name}):`, result);
            end;
        end;

        u26.clean:Destroy();
    end);
end;

for _, child in ipairs(Holder:GetChildren()) do
    task.spawn(questAdded, child);
end;

Holder.ChildAdded:Connect(questAdded);
Holder.ChildRemoved:Connect(questRemoved);