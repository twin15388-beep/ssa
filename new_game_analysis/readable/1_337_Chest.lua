-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = RunService:IsServer();
local u2 = u1 and game:GetService("ServerStorage") or nil;
local u3 = nil;
local u4 = false;
local u5 = nil;

local function ensureServerDeps() -- Line: 28
    -- upvalues: u5 (ref), u1 (copy), u2 (copy)
    if u5 or not u1 then
        return;
    end;

    local v6 = u2 and u2:FindFirstChild("SAM") or nil;
    local v7 = v6 and v6:FindFirstChild("Services") or nil;
    local v8 = v7 and v7:FindFirstChild("ChestService") or nil;

    if v8 == nil then
        return;
    end;

    u5 = require(v8);
end;

local function resolveCharacterFrame(p9: userdata) -- Line: 41
    local Character = p9.Character;

    if Character == nil then
        return nil, nil;
    end;

    local Pivot = Character:GetPivot();

    return Pivot.Position, Pivot;
end;

local function collectClientIds() -- Line: 50
    -- upvalues: u4 (ref), ReplicatedStorage (copy), u3 (ref)
    if not u4 then
        u4 = true;
        local success, result = pcall(require, ReplicatedStorage.CAM.Client.Controllers.ChestController);

        if success then
            u3 = result;
        end;
    end;

    if u3 and u3.getChestIds then
        local ChestIds = u3.getChestIds();

        if typeof(ChestIds) == "table" and #ChestIds > 0 then
            return ChestIds;
        end;
    end;

    return {};
end;

local function collectServerIds() -- Line: 67
    -- upvalues: u5 (ref)
    if u5 and u5.GetAllConfigs then
        local success, result = pcall(u5.GetAllConfigs);

        if success and typeof(result) == "table" then
            local v10 = {};

            for i in result do
                v10[#v10 + 1] = i;
            end;

            table.sort(v10);

            return v10;
        end;
    end;

    return {};
end;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Player",
            Name = "Player",
            Required = true
        },
        {
            Type = "String",
            Name = "ChestId",
            Required = true,

            Suggester = function() -- Line: 84, Name: chestIdSuggester
                -- upvalues: u1 (copy), collectServerIds (copy), collectClientIds (copy)
                local v11;

                if u1 then
                    v11 = collectServerIds();
                else
                    v11 = collectClientIds();
                end;

                if #v11 == 0 then
                    return { "Common Chest" }, true;
                end;

                return v11, true;
            end,

            Completer = function(p12: string) -- Line: 109, Name: Completer
                -- upvalues: u1 (copy), collectServerIds (copy), collectClientIds (copy)
                if p12 == nil or p12 == "" then
                    return nil;
                end;

                local v13 = p12:lower();
                local v14;

                if u1 then
                    v14 = collectServerIds();
                else
                    v14 = collectClientIds();
                end;

                local v15, v16;

                if #v14 == 0 then
                    v14 = { "Common Chest" };
                    v15 = true;
                    v16 = nil;
                else
                    v15 = true;
                    v16 = nil;
                end;

                for _, v in v14, v15, v16 do
                    if v:lower() == v13 then
                        return v;
                    end;
                end;

                return p12;
            end
        }
    },

    Server = function(p17: userdata, p18: userdata, p19: string) -- Line: 123, Name: Server
        -- upvalues: ensureServerDeps (copy), u5 (ref)
        ensureServerDeps();

        if u5 == nil then
            error("ChestService unavailable on server");
        end;

        if not (p18 and (p19 and p19 ~= "")) then
            error("Player and chest id are required");
        end;

        local Character = p18.Character;
        local v20, v21;

        if Character == nil then
            v20 = nil;
            v21 = nil;
        else
            v21 = Character:GetPivot();
            v20 = v21.Position;
        end;

        if not (v20 and v21) then
            error("Player has no valid character position");
        end;

        local Position = (v21 * CFrame.new(0, 0, -5)).Position;

        if u5.GetChestConfig and not u5.GetChestConfig(p19) then
            error((`Chest config '{p19}' not found`));
        end;

        local v22 = u5.Spawn(p19, Position, {
            snapToGround = true,
            despawnAfter = 60,
            distributionMode = "FreeLoot",
            maxWinners = nil,
            range = nil,
            holdDuration = nil,
            promptText = nil,
            pivotOrientation = v21
        });

        if not v22 then
            error("Chest failed to spawn");
        end;

        return {
            Content = `Spawned chest '{p19}' at {p18.Name}'s position (guid: {v22})`,
            BgColor = Color3.fromRGB(32, 143, 70),
            FgColor = Color3.new(1, 1, 1)
        };
    end
};