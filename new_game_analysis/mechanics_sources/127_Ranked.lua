-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local HudGrid = require(ReplicatedStorage.CAM.HudGrid);
local MinigameSettings = require(ReplicatedStorage.CAM.Global.MinigameSettings);
local SettingsLive = require(ReplicatedStorage.CAM.Global.SettingsLive);
local script_Rating = require(script.Rating);
local script_Rules = require(script.Rules);
local Ranked = MinigameSettings.Settings.PvP.Ranked;
local u1 = {
    Rating = script_Rating,
    Rules = script_Rules,
    TOURNEY = "Tourney",
    MINIGAME = "PvP",
    VERIFIED = "RankedVerified",
    Live = SettingsLive.new("Ranked", Ranked, SettingsLive.surface(Ranked))
};

function u1.KeyFor(p2: string, p3: string?) -- Line: 49
    -- upvalues: u1 (copy)
    if p2 == u1.TOURNEY then
        return `{u1.TOURNEY}:{p3 or ""}`;
    end;

    return p2;
end;

function u1.BucketOfKey(p4: string) -- Line: 56
    -- upvalues: u1 (copy)
    return string.match(p4, (`^{u1.TOURNEY}:(.+)$`));
end;

local function isBreathing(p5: string) -- Line: 61
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.CAM.Global.Powers.Breathings)[p5] ~= nil;
end;

local function isDemonArt(p6: string) -- Line: 64
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.CAM.Global.Powers.DemonArts)[p6] ~= nil;
end;

function u1.PowersOf(p7: userdata?) -- Line: 69
    -- upvalues: ReplicatedStorage (copy)
    local v8 = {};

    if p7 == nil then
        return v8;
    end;

    local Powers = p7:FindFirstChild("Powers");

    if Powers == nil then
        return v8;
    end;

    local Value = p7.Race.Value;
    local Breathing = Powers:FindFirstChild("Breathing");

    if Value ~= "Demon" and (Breathing ~= nil and Breathing.Value ~= "") then
        local Value2 = Breathing.Value;

        if require(ReplicatedStorage.CAM.Global.Powers.Breathings)[Value2] ~= nil then
            v8.Breathing = Breathing.Value;
        end;
    end;

    local DemonArt = Powers:FindFirstChild("DemonArt");

    if not (Value ~= "Demon" and Value ~= "Hybrid" or (DemonArt == nil or DemonArt.Value == "")) then
        local Value2 = DemonArt.Value;

        if require(ReplicatedStorage.CAM.Global.Powers.DemonArts)[Value2] ~= nil then
            v8.DemonArt = DemonArt.Value;
        end;
    end;

    return v8;
end;

function u1.BucketOf(p9: userdata?) -- Line: 86
    -- upvalues: u1 (copy)
    local v10 = u1.PowersOf(p9);

    return v10.Breathing or v10.DemonArt;
end;

function u1.MatchKeys() -- Line: 92
    -- upvalues: HudGrid (copy), u1 (copy)
    local v11 = {};

    for i, v in HudGrid.Grid do
        if v.Ranked == true and (v.Minigame == u1.MINIGAME and i ~= u1.TOURNEY) then
            table.insert(v11, i);
        end;
    end;

    table.sort(v11);

    return v11;
end;

function u1.Keys() -- Line: 104
    -- upvalues: u1 (copy), ReplicatedStorage (copy)
    local v12 = u1.MatchKeys();

    for _, v in { require(ReplicatedStorage.CAM.Global.Powers.Breathings), require(ReplicatedStorage.CAM.Global.Powers.DemonArts) } do
        for i in v do
            table.insert(v12, u1.KeyFor(u1.TOURNEY, i));
        end;
    end;

    table.sort(v12);

    return v12;
end;

function u1.IsKey(p13: string) -- Line: 115
    -- upvalues: u1 (copy), ReplicatedStorage (copy), HudGrid (copy)
    local v14 = u1.BucketOfKey(p13);

    if v14 ~= nil then
        return require(ReplicatedStorage.CAM.Global.Powers.Breathings)[v14] ~= nil or require(ReplicatedStorage.CAM.Global.Powers.DemonArts)[v14] ~= nil;
    end;

    if p13 == u1.TOURNEY then
        return false;
    end;

    local v15 = HudGrid.ByName[p13];
    local v16;

    if v15 == nil or v15.Ranked ~= true then
        v16 = false;
    else
        v16 = v15.Minigame == u1.MINIGAME;
    end;

    return v16;
end;

function u1.Verified(p17: userdata, p18: string) -- Line: 132
    -- upvalues: RunService (copy), u1 (copy), MinigameSettings (copy)
    if RunService:IsStudio() then
        return true;
    end;

    if not RunService:IsServer() then
        return p17:GetAttribute(u1.VERIFIED);
    end;

    local v19 = MinigameSettings.Settings[p18];
    local v20;

    if v19 == nil or v19.Ranked == nil then
        v20 = nil;
    else
        v20 = v19.Ranked.VerifiedLevel;
    end;

    if v20 == nil then
        return false;
    end;

    local success, result = pcall(p17.IsVerified, p17, v20);

    if success then
        return result == true;
    end;

    warn((`[Ranked] IsVerified failed for {p17.Name}: {result}`));

    return nil;
end;

function u1.LockedUntil(p21: userdata?) -- Line: 155
    local v22;

    if p21 == nil then
        v22 = nil;
    else
        v22 = p21:FindFirstChild("Ranked");
    end;

    local v23;

    if v22 == nil then
        v23 = nil;
    else
        v23 = v22:FindFirstChild("LockedUntil");
    end;

    return v23 == nil and 0 or v23.Value;
end;

function u1.Reason(p24: boolean?, p25: string?, p26: number?) -- Line: 163
    if p24 == nil then
        return p25 == nil and "Ranked data isn\'t ready, try again" or `{p25}'s ranked data isn't ready, try again`;
    end;

    if p24 ~= true then
        return p25 == nil and "Verify your Roblox account to play ranked" or `{p25} must verify their Roblox account for ranked`;
    end;

    local v27 = (p26 or 0) - os.time();

    if v27 <= 0 then
        return nil;
    end;

    local math_ceil_ret = math.ceil(v27 / 60);

    if p25 == nil then
        return `You left a ranked match: locked for {math_ceil_ret}m`;
    end;

    return `{p25} left a ranked match: locked for {math_ceil_ret}m`;
end;

function u1.Season(p28: number?) -- Line: 181
    -- upvalues: script_Rules (copy)
    return script_Rules.Season(p28);
end;

function u1.Previous(p29: string) -- Line: 184
    -- upvalues: script_Rules (copy)
    return script_Rules.Previous(p29);
end;

function u1.SeasonLabel(p30: string?) -- Line: 187
    -- upvalues: script_Rules (copy)
    return script_Rules.SeasonLabel(p30 or script_Rules.Season());
end;

function u1.SeasonEnds(p31: number?) -- Line: 190
    -- upvalues: script_Rules (copy)
    return script_Rules.SeasonEnds(p31);
end;

function u1.Display(p32: number) -- Line: 197
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.Display(Ranked, p32);
end;

function u1.TierOf(p33: number) -- Line: 200
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.TierOf(Ranked, p33);
end;

function u1.IconOf(p34: number) -- Line: 204
    -- upvalues: script_Rules (copy), Ranked (copy), BunchaIcons (copy)
    local _, v35 = script_Rules.TierOf(Ranked, p34);
    local v36 = BunchaIcons.Ranks[v35.Name];

    if v36 == nil or v36 == "" then
        return nil;
    end;

    return v36;
end;

function u1.Placed(p37) -- Line: 209
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.Placed(Ranked, p37);
end;

function u1.Apply(p38: any, p39: any, p40: number, p41: number, p42: number) -- Line: 212
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.Apply(Ranked, p38, p39, p40, p41, p42);
end;

function u1.Margin(p43: number, p44: number) -- Line: 215
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.Margin(Ranked, p43, p44);
end;

function u1.PruneRecent(p45: any, p46: number) -- Line: 218
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.PruneRecent(Ranked, p45, p46);
end;

function u1.Dampened(p47: any, p48: table, p49: number) -- Line: 221
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.Dampened(Ranked, p47, p48, p49);
end;

function u1.BandsFor(p50: string) -- Line: 226
    -- upvalues: u1 (copy), Ranked (copy), ReplicatedStorage (copy)
    local v51 = u1.BucketOfKey(p50);

    if v51 == nil then
        return Ranked.Rewards.Modes;
    end;

    if require(ReplicatedStorage.CAM.Global.Powers.DemonArts)[v51] ~= nil then
        return Ranked.Rewards.TourneyDemon;
    end;

    return Ranked.Rewards.TourneySlayer;
end;

function u1.BandFor(p52: string, p53: number, p54: table) -- Line: 233
    -- upvalues: script_Rules (copy), u1 (copy)
    return script_Rules.BandFor(u1.BandsFor(p52), p53, p54);
end;

function u1.Bucket(p55: number) -- Line: 236
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.Bucket(Ranked, p55);
end;

function u1.ShareAbove(p56: any, p57: number) -- Line: 239
    -- upvalues: script_Rules (copy), Ranked (copy)
    return script_Rules.ShareAbove(Ranked, p56, p57);
end;

function u1.CutoffsFrom(p58: string, p59: any) -- Line: 243
    -- upvalues: u1 (copy), script_Rules (copy), Ranked (copy)
    local v60 = {};

    for _, v in u1.BandsFor(p58) do
        local v61 = script_Rules.CutoffFrom(Ranked, p59, v.Percent);

        if v61 ~= nil then
            v60[v.Band] = v61;
        end;
    end;

    return v60;
end;

return u1;