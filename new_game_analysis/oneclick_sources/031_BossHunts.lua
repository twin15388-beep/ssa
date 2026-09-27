-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local script_Parent = require(script.Parent);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Crow = require(ReplicatedStorage.Items.Misc.Crow);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = {};
local u2 = {
 Common = 0.25,
 UnCommon = 0.3,
 Rare = 0.35,
 Epic = 0.45,
 Legendary = 0.55,
 Mythic = 0.7
};
u1.BandLevel = 125;
u1.Bands = { "High", "Low" };
u1.MaxOpen = 5;
local u3 = { 0.5, 0.75 };

local function isPrivateServer() -- Line: 76
 -- upvalues: RunService (copy), ReplicatedStorage (copy)
 if RunService:IsServer() then
 return game.PrivateServerId ~= "";
 end;

 local BossHunts = ReplicatedStorage:FindFirstChild("BossHunts");
 local v4;

 if BossHunts == nil then
 v4 = false;
 else
 v4 = BossHunts:GetAttribute("PrivateServer") == true;
 end;

 return v4;
end;

u1.Sides = {
 Muzan = {
 Completion = "Good. One less of them.",
 Race = { "Demon", "Hybrid" },
 Voice = {
 Icon = BunchaIcons.MuzanIcon
 }
 },
 Crow = {
 Completion = "The Corps has its answer.",
 Race = { "Slayer", "Hybrid" },
 Voice = {
 Sound = "PS2crowquestUIcaw",
 Icon = Crow.Icon
 }
 }
};
local u5 = {
 Slayer = "mission"
};
local u6 = {
 Slayer = "Defeat"
};

function u1.Title(p7: string, p8: string?) -- Line: 118
 -- upvalues: u6 (copy)
 return `{u6[p8] or "Eliminate"} {p7}`;
end;

function u1.Noun(p9: string?, p10: boolean?) -- Line: 121
 -- upvalues: u5 (copy)
 local v11 = u5[p9] or "hunt";

 if p10 then
 return string.upper((string.sub(v11, 1, 1))) .. string.sub(v11, 2);
 end;

 return v11;
end;

u1.Hunts = {
 {
 Code = "Saneri",
 Side = "Muzan",
 Tier = "Mythic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Shinora",
 Side = "Muzan",
 Tier = "Mythic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Rengu",
 Side = "Muzan",
 Tier = "Mythic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Giyen",
 Side = "Muzan",
 Tier = "Legendary",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Gyorei",
 Side = "Muzan",
 Tier = "Legendary",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Zentaro",
 Side = "Muzan",
 Tier = "Legendary",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Obari",
 Side = "Muzan",
 Tier = "Epic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Tengai",
 Side = "Muzan",
 Tier = "Epic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Gyutai",
 Side = "Crow",
 Tier = "Mythic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Akazo",
 Side = "Crow",
 Tier = "Mythic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Reaper",
 Side = "Crow",
 Tier = "Mythic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Enru",
 Side = "Crow",
 Tier = "Legendary",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Nezura",
 Side = "Crow",
 Tier = "Legendary",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Sumari",
 Side = "Crow",
 Tier = "Epic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Yahari",
 Side = "Crow",
 Tier = "Epic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Datai",
 Side = "Crow",
 Tier = "Epic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "Domae",
 Side = "Crow",
 Tier = "Epic",
 Level = 200,
 MinLevel = 125
 },
 {
 Code = "FlameTrainee",
 Npc = "Flame Trainee",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "ThunderTrainee",
 Npc = "Thunder Trainee",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "WaterTrainee",
 Npc = "Water Trainee Sabito",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "WindTrainee",
 Npc = "Wind Trainee",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "StoneTrainee",
 Npc = "Stone Trainee",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "SerpentTrainee",
 Npc = "Serpent Trainee",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "InsectTrainee",
 Npc = "Insect Trainee",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "SoundTrainee",
 Npc = "Sound Trainee",
 Side = "Muzan",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "TaiChiTrainee",
 Npc = "Tai Chi Trainee Suzume",
 Side = "Muzan",
 Tier = "UnCommon",
 Level = 85,
 MinLevel = 65,
 MaxLevel = 125
 },
 {
 Code = "MotherBear",
 Npc = "Mother Bear",
 Side = "Crow",
 Tier = "Common",
 Level = 85,
 MinLevel = 45,
 MaxLevel = 125
 },
 {
 Code = "Hoyuzo",
 Side = "Crow",
 Tier = "Rare",
 Level = 85,
 MinLevel = 50,
 MaxLevel = 125
 },
 {
 Code = "SoryuTrainee",
 Npc = "Soryu Trainee Goki",
 Side = "Crow",
 Tier = "UnCommon",
 Level = 85,
 MinLevel = 62,
 MaxLevel = 125
 },
 {
 Code = "ReaperTrainee",
 Npc = "Reaper Trainee Kuzan",
 Side = "Crow",
 Tier = "Rare",
 Level = 85,
 MinLevel = 100,
 MaxLevel = 125
 }
};

function u1.Npc(p12: table) -- Line: 172
 return p12.Npc or p12.Code;
end;

function u1.Entry(p13: string) -- Line: 187
 -- upvalues: u1 (copy)
 for _, v in u1.Hunts do
 if u1.Npc(v) == p13 then
 return v;
 end;
 end;

 return nil;
end;

function u1.Band(p14: table) -- Line: 197
 return p14.MaxLevel == nil and "High" or "Low";
end;

function u1.Rewards(p15: table) -- Line: 201
 -- upvalues: u2 (copy), gameSettings (copy)
 local v16 = u2[p15.Tier];

 if v16 == nil then
 return {
 Exp = 0,
 Wen = 0
 };
 end;

 local math_round_ret = math.round(v16 * gameSettings.expPerLevel * p15.Level);

 return {
 Exp = math_round_ret,
 Wen = math.round(math_round_ret * gameSettings.wenPerExp)
 };
end;

function u1.MaxLevelMastery(p17: table) -- Line: 224
 -- upvalues: u1 (copy), gameSettings (copy)
 local v18 = u1.Rewards(p17).Exp * gameSettings.expPerMasteryDefault / gameSettings.expPerLevel;

 return math.round(v18);
end;

function u1.Factor(p19: table) -- Line: 232
 -- upvalues: u1 (copy), RunService (copy), ReplicatedStorage (copy), Players (copy), u3 (copy)
 if u1.Sides[p19.Side] == nil then
 return 1;
 end;

 local v20;

 if RunService:IsServer() then
 v20 = game.PrivateServerId ~= "";
 else
 local BossHunts = ReplicatedStorage:FindFirstChild("BossHunts");

 if BossHunts == nil then
 v20 = false;
 else
 v20 = BossHunts:GetAttribute("PrivateServer") == true;
 end;
 end;

 if v20 then
 return 0.5;
 end;

 local v21 = 0;

 for _, v in Players:GetPlayers() do
 if u1.Eligible(p19, v) then
 v21 = v21 + 1;
 end;
 end;

 return u3[v21] or 1;
end;

function u1.Eligible(p22: table, p23: userdata) -- Line: 251
 -- upvalues: u1 (copy), Utility (copy), gameSettings (copy)
 local v24 = u1.Sides[p22.Side];

 if v24 == nil then
 return false;
 end;

 local Data = Utility.GetData(p23);

 if Data == nil or table.find(v24.Race, Data.Race.Value) == nil then
 return false;
 end;

 local v25 = Data.Exp.Goal.Value / gameSettings.expPerLevel;
 local v26;

 if p22.MinLevel <= v25 then
 v26 = p22.MaxLevel == nil and true or v25 <= p22.MaxLevel;
 else
 v26 = false;
 end;

 return v26;
end;

function u1.QuestName(p27: string) -- Line: 265
 return `Eliminate {p27}`;
end;

function u1.Definitions() -- Line: 269
 -- upvalues: u1 (copy), script_Parent (copy)
 local v28 = {};

 for _, v in u1.Hunts do
 local v29 = u1.Sides[v.Side];
 local v30 = u1.Npc(v);
 local v31 = `Defeat {v30}`;
 v28[u1.QuestName(v30)] = {
 OfferNpc = false,
 KillCreditShare = 0.1,
 Timer = 1800,
 NoCancel = true,
 Category = "BossHunt",
 QuestInstance = script_Parent.Quest(u1.QuestName(v30), script_Parent.QuestTask(v31, 1, v.Code)),
 Rewards = u1.Rewards(v),
 MaxLevelMastery = u1.MaxLevelMastery(v),
 Requirements = {
 Race = v29.Race,
 Level = v.MinLevel,
 MaxLevel = v.MaxLevel
 },
 Markers = {
 [v31] = {
 Npc = v30
 }
 },
 CompletionNotify = {
 Icon = v29.Voice.Icon,
 Sound = v29.Voice.Sound,
 Text = v29.Completion
 }
 };
 end;

 return v28;
end;

return u1;