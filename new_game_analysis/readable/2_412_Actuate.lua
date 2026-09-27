-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local cleanit = require(ReplicatedStorage.Packages.cleanit);
require(ReplicatedStorage.CAM.Global.Types.ScenariosType);
local table_insert = table.insert;
local table_find = table.find;
local table_remove = table.remove;
local u1 = {};

for _, v in ipairs(script.Scenarios:QueryDescendants("ModuleScript:not([$ignore])")) do
    table_insert(u1, require(v));
end;

local u2 = cleanit.new();
local u3 = {};
local u4 = nil;

function updCharacter(u5: userdata)
    -- upvalues: u2 (copy), u4 (ref), u1 (copy), table_insert (copy), LocalPlayer (copy), u3 (ref), table_find (copy), table_remove (copy)
    u2:Clean();

    if u4 ~= nil then
        u4:Disconnect();
        u4 = nil;
    end;

    local function IsReady(u6: userdata) -- Line: 26
        -- upvalues: u1 (ref), table_insert (ref), LocalPlayer (ref), u5 (copy), u3 (ref), table_find (ref), table_remove (ref), u2 (ref)
        local function updateScenarios() -- Line: 27
            -- upvalues: u1 (ref), u6 (copy), table_insert (ref), LocalPlayer (ref), u5 (ref), u3 (ref), table_find (ref), table_remove (ref)
            local v7 = {};

            for _, v in ipairs(u1) do
                if (v.Activators == nil or v.Activators.EquippedAccessory == nil) and true or u6:FindFirstChild(v.Activators.EquippedAccessory) ~= nil then
                    table_insert(v7, v);
                    v.Do(LocalPlayer, u5);
                end;
            end;

            for _, v in ipairs(u3) do
                local v8 = table_find(v7, v);

                if v8 == nil then
                    v.Stop(LocalPlayer, u5);
                    table_remove(v7, v8);
                end;
            end;

            u3 = v7;
        end;

        u2:Connect(u6.ChildAdded, updateScenarios);
        u2:Connect(u6.ChildRemoved, updateScenarios);
        updateScenarios();
    end;

    local Tool_Accessories = u5:FindFirstChild("Tool_Accessories");

    if Tool_Accessories == nil then
        local u9 = nil;
        u9 = u5.ChildAdded:Connect(function(u10) -- Line: 56
            -- upvalues: u1 (ref), table_insert (ref), LocalPlayer (ref), u5 (copy), u3 (ref), table_find (ref), table_remove (ref), u2 (ref), u9 (ref)
            if u10.Name == "Tool_Accessories" then
                local function v13() -- Line: 27
                    -- upvalues: u1 (ref), u10 (copy), table_insert (ref), LocalPlayer (ref), u5 (ref), u3 (ref), table_find (ref), table_remove (ref)
                    local v11 = {};

                    for _, v in ipairs(u1) do
                        if (v.Activators == nil or v.Activators.EquippedAccessory == nil) and true or u10:FindFirstChild(v.Activators.EquippedAccessory) ~= nil then
                            table_insert(v11, v);
                            v.Do(LocalPlayer, u5);
                        end;
                    end;

                    for _, v in ipairs(u3) do
                        local v12 = table_find(v11, v);

                        if v12 == nil then
                            v.Stop(LocalPlayer, u5);
                            table_remove(v11, v12);
                        end;
                    end;

                    u3 = v11;
                end;

                u2:Connect(u10.ChildAdded, v13);
                u2:Connect(u10.ChildRemoved, v13);
                v13();
                u2:Remove(u9);
                u9:Disconnect();
                u9 = nil;
            end;
        end);
        u2:Add(u9);
    else
        local function v16() -- Line: 27
            -- upvalues: u1 (ref), Tool_Accessories (copy), table_insert (ref), LocalPlayer (ref), u5 (copy), u3 (ref), table_find (ref), table_remove (ref)
            local v14 = {};

            for _, v in ipairs(u1) do
                if (v.Activators == nil or v.Activators.EquippedAccessory == nil) and true or Tool_Accessories:FindFirstChild(v.Activators.EquippedAccessory) ~= nil then
                    table_insert(v14, v);
                    v.Do(LocalPlayer, u5);
                end;
            end;

            for _, v in ipairs(u3) do
                local v15 = table_find(v14, v);

                if v15 == nil then
                    v.Stop(LocalPlayer, u5);
                    table_remove(v14, v15);
                end;
            end;

            u3 = v14;
        end;

        u2:Connect(Tool_Accessories.ChildAdded, v16);
        u2:Connect(Tool_Accessories.ChildRemoved, v16);
        v16();
    end;

    local function updHumanoid(p17: userdata) -- Line: 67
        -- upvalues: u4 (ref), u3 (ref), LocalPlayer (ref), u5 (copy), u2 (ref)
        if u4 ~= nil then
            u4:Disconnect();
            u4 = nil;
        end;

        u4 = p17.Died:Connect(function() -- Line: 72
            -- upvalues: u3 (ref), LocalPlayer (ref), u5 (ref), u2 (ref)
            for _, v in ipairs(u3) do
                v.Stop(LocalPlayer, u5);
            end;

            u2:Clean();
        end);
    end;

    if not u5:FindFirstChild("Humanoid") then
        u4 = u5.ChildAdded:Connect(function(p18) -- Line: 82
            -- upvalues: u4 (ref), u3 (ref), LocalPlayer (ref), u5 (copy), u2 (ref)
            if p18.Name == "Humanoid" then
                if u4 ~= nil then
                    u4:Disconnect();
                    u4 = nil;
                end;

                u4 = p18.Died:Connect(function() -- Line: 72
                    -- upvalues: u3 (ref), LocalPlayer (ref), u5 (ref), u2 (ref)
                    for _, v in ipairs(u3) do
                        v.Stop(LocalPlayer, u5);
                    end;

                    u2:Clean();
                end);
            end;
        end);

        return;
    end;

    local Humanoid = u5.Humanoid;

    if u4 ~= nil then
        u4:Disconnect();
        u4 = nil;
    end;

    u4 = Humanoid.Died:Connect(function() -- Line: 72
        -- upvalues: u3 (ref), LocalPlayer (ref), u5 (copy), u2 (ref)
        for _, v in ipairs(u3) do
            v.Stop(LocalPlayer, u5);
        end;

        u2:Clean();
    end);
end;

if LocalPlayer.Character ~= nil then
    updCharacter(LocalPlayer.Character);
end;

LocalPlayer.CharacterAdded:Connect(updCharacter);