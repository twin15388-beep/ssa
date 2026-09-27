-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsServer();
local u2 = {};
local u3 = {};

if not v1 then
    local v4 = {};

    for _, child in ReplicatedStorage.Skills:GetChildren() do
        for _, child2 in child:GetChildren() do
            if child2:IsA("Folder") then
                v4[child2.Name] = true;

                for _, child3 in child2:GetChildren() do
                    if child3:IsA("ModuleScript") and (child3.Name ~= "Config" and not child3.Name:find("Server$")) then
                        v4[child3.Name] = true;
                    end;
                end;
            end;
        end;
    end;

    for i in v4 do
        table.insert(u2, i);
    end;

    table.sort(u2);

    for _, v in u2 do
        table.insert(u3, v:lower());
    end;
end;

local u5 = v1 and require(game:GetService("ServerStorage").SAM.AiThings.NpcNetwork.Tasks.CastTelegraph) or nil;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Skill",
            Name = "Skill",
            Required = true,

            Suggester = function() -- Line: 49, Name: Suggester
                -- upvalues: u2 (copy)
                return u2, true;
            end,

            Completer = function(p6: string) -- Line: 52, Name: Completer
                -- upvalues: u3 (copy), u2 (copy)
                if p6 == nil or p6 == "" then
                    return nil;
                end;

                local table_find_ret = table.find(u3, p6:lower());

                if table_find_ret == nil then
                    return p6;
                end;

                return u2[table_find_ret];
            end
        }
    },

    Server = function(p7: userdata, p8: table, p9: string) -- Line: 59, Name: Server
        -- upvalues: u5 (copy)
        local v10 = nil;

        for _, descendant in game:GetService("ServerStorage").AiSkills.Performers:GetDescendants() do
            if descendant:IsA("ModuleScript") and descendant.Name:lower() == p9:lower() then
                v10 = descendant;
                break;
            end;
        end;

        local v11;

        if v10 == nil then
            v11 = nil;
        else
            v11 = require(v10) or nil;
        end;

        if v11 == nil or v11.Telegraph == nil then
            error((`No AI performer named "{p9}" carries a telegraph`));
        end;

        for _, v in p8 do
            local Character = v.Character;

            if Character ~= nil then
                u5.Begin({
                    UniqueName = `{v.Name}-{v10.Name}`,
                    Stats = {
                        CastTelegraph = 1
                    },
                    Spawning = {
                        Entity = Character
                    },
                    Following = {}
                }, v10.Name, {}, v11, nil);
            end;
        end;
    end
};