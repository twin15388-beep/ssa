-- Decompiled with Potassium's decompiler.

local v1 = {
    DASH_SPEED = 70,
    DASH_FORCE_DURATION = 0.165,
    DASH_DURATION = 0.48,
    DASH_FACTOR_SCALE = 0.5,
    AIR_DASH_FLAG_DURATION = 0.55,
    BLOCK_ESCAPE_IFRAME_DURATION = 0.125,
    AcceptedDashes = { "Sleepless Knight Mode", "Reaper" }
};
local u2 = {};

for _, v in v1.AcceptedDashes do
    u2[v] = true;
end;

local Character_info_provider = require(game.ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(game.ReplicatedStorage.CAM.Global.Utility);

function v1.ResolveCustomDash(p3: userdata, p4: string?) -- Line: 52
    -- upvalues: Utility (copy), u2 (copy), Character_info_provider (copy)
    local valuesfolder = Utility.getvaluesfolder(p3);

    if valuesfolder ~= nil then
        for _, child in valuesfolder:GetChildren() do
            if u2[child.Name] and child:GetAttribute("_ClanAura") == true then
                return child.Name;
            end;
        end;
    end;

    if p3:IsA("Player") then
        for _, v in Character_info_provider.GetEquippedPowers(p3) do
            if u2[v] then
                return v;
            end;
        end;

        p3 = p3.Character;
    end;

    local v5;

    if p3 == nil then
        v5 = nil;
    else
        v5 = p3:GetAttribute("Clan") or nil;
    end;

    if v5 ~= nil and u2[v5] then
        return v5;
    end;

    if p4 == nil or not u2[p4] then
        return nil;
    end;

    return p4;
end;

return v1;