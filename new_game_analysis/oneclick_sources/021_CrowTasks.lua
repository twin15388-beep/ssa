-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local BossHunts = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.BossHunts);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

local function race() -- Line: 15
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 return Data ~= nil and Data.Race.Value or nil;
end;

return {
 CrowTasks = {
 Text = "Here are your current tasks",
 Name = "Kasugai Crow",
 Answers = {
 Cancel = function() -- Line: 23, Name: CancelBoard
 -- upvalues: Utility (copy), SignalEvent (copy)
 Utility.ForceUnequip();
 SignalEvent.ToServer("CrowDismiss");

 return "";
 end
 },
 Icon = BunchaIcons.CrowIcon,

 Content = function(p1, p2, p3, p4) -- Line: 39, Name: Content
 -- upvalues: ReplicatedStorage (copy)
 return require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Quests)(p1, p2, p3, p4, "CrowTasks_Denied");
 end
 },
 CrowTasks_Denied = {
 Answers = true,
 IfTrue = "CrowTasks",
 ContinueContent = true,
 ContinueIcon = true,

 Text = function(p5, p6) -- Line: 53, Name: Text
 -- upvalues: BossHunts (copy), Utility (copy), Players (copy)
 local v7 = p6 ~= nil and p6.HuntDenial or {};
 local Noun = BossHunts.Noun;
 local Data = Utility.GetData(Players.LocalPlayer);
 local v8;

 if Data == nil then
 v8 = nil;
 else
 v8 = Data.Race.Value or nil;
 end;

 local v9 = Noun(v8);

 if v7.Blocking ~= nil and v7.Reason == false then
 return `Finish {Utility.NameTag(v7.Blocking)} first. One {v9} at a time.`;
 end;

 if v7.Reason == true then
 return `Not yet. Take a breath before the next {v9}.`;
 end;

 if v7.Reason == 1 then
 return `You are already carrying that {v9}.`;
 end;

 return `That {v9} is not yours to take.`;
 end
 }
};