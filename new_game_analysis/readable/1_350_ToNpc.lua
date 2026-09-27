-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local u1 = nil;

local function catalog() -- Line: 23
    -- upvalues: u1 (ref), ReplicatedStorage (copy), Menum (copy)
    if u1 ~= nil then
        return u1;
    end;

    local success, result = pcall(require, ReplicatedStorage:FindFirstChild("Regions"));

    if not success then
        return {};
    end;

    local v2 = {};

    for _, v in result.Regions do
        for _, v3 in v.Npcs or {} do
            local v4 = nil;

            if v3.Type == Menum.npcType.Active then
                v4 = v3.SendOver and v3.SendOver.Spawning;

                if v4 then
                    v4 = v4.Locations;
                end;
            elseif v3.Type == Menum.npcType.Stationary or v3.Type == Menum.npcType.Idle then
                v4 = v3.Spawns;

                if v4 and v4.Multiple == true then
                    v4 = v4[1];
                end;
            end;

            if v4 then
                v4 = v4[1];
            end;

            if v3.Name and (v4 and v2[v3.Name] == nil) then
                local Name = v3.Name;

                if typeof(v4) == "CFrame" then
                    v4 = v4.Position;
                end;

                v2[Name] = v4;
            end;
        end;
    end;

    u1 = v2;

    return v2;
end;

local function liveRoot(p5: string) -- Line: 53
    for _, v in { workspace.Debree, workspace.Humanoids } do
        local Regions = v:FindFirstChild("Regions");

        if Regions ~= nil then
            for _, v2 in Regions:QueryDescendants("Model") do
                if v2.Name == p5 then
                    local HumanoidRootPart = v2:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart ~= nil then
                        return HumanoidRootPart;
                    end;
                end;
            end;
        end;
    end;

    return nil;
end;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "String",
            Name = "Npc",
            Required = true,

            Suggester = function() -- Line: 78, Name: Suggester
                -- upvalues: catalog (copy)
                local v6 = {};

                for i in catalog() do
                    table.insert(v6, i);
                end;

                table.sort(v6);

                return v6, true;
            end,

            Completer = function(p7: string) -- Line: 89, Name: Completer
                -- upvalues: catalog (copy)
                if p7 == nil or p7 == "" then
                    return nil;
                end;

                local v8 = p7:lower();

                for i in catalog() do
                    if i:lower() == v8 then
                        return i;
                    end;
                end;

                return p7;
            end
        }
    },

    Server = function(p9: userdata, p10: table, p11: string) -- Line: 99, Name: Server
        -- upvalues: liveRoot (copy), catalog (copy)
        local v12 = liveRoot(p11);
        local v13 = v12 ~= nil and v12.Position or catalog()[p11];

        if v13 == nil then
            error((`ToNpc: no NPC named "{p11}" in this place`));
        end;

        local v14 = {};

        for _, v in p10 do
            local Character = v.Character;

            if Character ~= nil then
                local v15 = v13 + Vector3.new(#v14 * 4, 0, 6);
                Character:PivotTo(CFrame.lookAt(v15, v13));
                Character:MoveTo(v15);
                table.insert(v14, v.Name);
            end;
        end;

        if #v14 == 0 then
            error("ToNpc: no targeted player has a character to move");
        end;

        return {
            Content = `Sent {table.concat(v14, ", ")} to {p11} ({v12 == nil and "authored spawn, nothing up" or "live rig"})`,
            BgColor = Color3.fromRGB(32, 143, 70),
            FgColor = Color3.new(1, 1, 1)
        };
    end
};