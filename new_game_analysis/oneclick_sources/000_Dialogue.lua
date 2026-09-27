-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = game:GetService("RunService"):IsClient();
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local v2;

if v1 then
 v2 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Amount);
else
 v2 = nil;
end;

local u3;

if v1 then
 u3 = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
else
 u3 = nil;
end;

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local AcceptCost = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.AcceptCost);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ItemRequirements = require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local textplus = require(game.ReplicatedStorage.Packages.textplus);

for i, v in pairs(require(script.TextPlusIDs)) do
 textplus.RegisterId(i, v);
end;

local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u54 = {
 AttemptDialogue = simplesignal.new(),
 OpenDialogue = simplesignal.new(),
 Storage = {},
 CurrentDialogue = {
 Current = nil,
 Cancel = simplesignal.new()
 },
 Functions = {
 ["Success-sound"] = function() -- Line: 70
 -- upvalues: DebrisModule (copy)
 local v9 = game.ReplicatedStorage.Assets.Sounds.Misc.success:Clone();
 v9.Parent = script;
 v9:Play();
 DebrisModule:AddItem(v9, v9.TimeLength);
 end,

 AddQuest = function(p10) -- Line: 77, Name: AddQuest
 -- upvalues: Quests (copy), Utility (copy), Players (copy), ItemRequirements (copy), u7 (ref), u5 (ref), AcceptCost (copy), u6 (ref), u4 (ref), SignalEvent (copy)
 local v11 = Quests.Holder[p10];
 local Data = Utility.GetData(Players.LocalPlayer);

 if v11 ~= nil and (v11.Requirements and not ItemRequirements.Passes(Data, v11.Requirements)) then
 u7 = ItemRequirements.Describe(v11.Requirements);

 return "RequirementNotMet";
 end;

 if v11 ~= nil and (v11.WenCostOnAccept and (Data ~= nil and Data.Wen.Value < v11.WenCostOnAccept)) then
 u5 = v11.WenCostOnAccept;

 return "NotEnoughWen";
 end;

 if v11 ~= nil and v11.ItemCostOnAccept then
 local v12, v13, v14 = AcceptCost.Check(Data, v11.ItemCostOnAccept);

 if Data ~= nil and not v12 then
 u6 = {
 Name = v13,
 Count = v14
 };

 return "NotEnoughItems";
 end;
 end;

 local v15, v16, v17 = Quests.CanAddQuest(p10);

 if not v15 then
 u4 = v17;

 return v16 == 2 and "QuestAlreadyCompleted" or (v16 == 1 and "AlreadyDoingQuest" or (v16 and "NoQuest" or "NoQuestMaximumReached"));
 end;

 SignalEvent.ToServer("AddQuest", p10);
 end,

 ProceedWithPurchase = function(p18, p19) -- Line: 118, Name: ProceedWithPurchase
 -- upvalues: Shop (copy), Players (copy), DebrisModule (copy), SignalEvent (copy)
 local ShopPrompt = p19.ShopPrompt;
 local BuyItemName = p19.BuyItemName;

 if not BuyItemName then
 if ShopPrompt == nil then
 BuyItemName = nil;
 else
 BuyItemName = ShopPrompt.ObjectText or nil;
 end;
 end;

 if BuyItemName == nil then
 return "PurchaseFail";
 end;

 local v20 = Shop.SanitizeAmount(p19.Amount);
 local v21, v22 = Shop.CanBuy(Players.LocalPlayer, BuyItemName, nil, v20);

 if v21 then
 local v23 = game.ReplicatedStorage.Assets.Sounds.Misc.Money_Kaching:Clone();
 v23.Parent = script;
 v23:Play();
 DebrisModule:AddItem(v23, v23.TimeLength);
 SignalEvent.ToServer("PurchaseFromShop", BuyItemName, v20);

 return ShopPrompt:GetAttribute("SuccessDialogue") or "PurchaseSuccess";
 end;

 p19.PurchaseReason = v22;
 local v24 = game.ReplicatedStorage.Assets.Sounds.Misc.denied_old:Clone();
 v24.Parent = script;
 v24:Play();
 DebrisModule:AddItem(v24, v24.TimeLength);

 return ShopPrompt:GetAttribute("FailDialogue") or "PurchaseFail";
 end,

 BackToShop = function(p25, p26) -- Line: 146, Name: BackToShop
 return p26.CartShopNode or "";
 end,

 ReviewCartPurchase = function(p27, p28) -- Line: 153, Name: ReviewCartPurchase
 -- upvalues: Shop (copy), Players (copy), DebrisModule (copy)
 local _, v29 = Shop.GetCartTotals(p28.BuySelection);

 if v29 < 1 and #Shop.GetCartDeferred(p28.BuySelection) < 1 then
 return "CartNothing";
 end;

 local v30, v31 = Shop.CanBuyCart(Players.LocalPlayer, p28.BuySelection);

 if v30 then
 return "CartConfirm";
 end;

 p28.PurchaseReason = v31;
 local v32 = game.ReplicatedStorage.Assets.Sounds.Misc.denied_old:Clone();
 v32.Parent = script;
 v32:Play();
 DebrisModule:AddItem(v32, v32.TimeLength);

 return "PurchaseFail";
 end,

 ProceedWithCartPurchase = function(p33, p34) -- Line: 169, Name: ProceedWithCartPurchase
 -- upvalues: u8 (ref), Shop (copy), u3 (copy), SignalFunction (copy), DebrisModule (copy)
 if u8 then
 return "CartConfirm";
 end;

 local _, v35 = Shop.GetCartTotals(p34.BuySelection);

 if v35 < 1 and #Shop.GetCartDeferred(p34.BuySelection) < 1 then
 return "CartNothing";
 end;

 u8 = true;
 local v36;

 if u3 == nil then
 v36 = nil;
 else
 v36 = u3.new({
 Type = "LoadingFull"
 }) or nil;
 end;

 local v37 = SignalFunction.ToServer("PurchaseSelection", p34.BuySelection);

 if v36 ~= nil then
 v36:Destroy();
 end;

 u8 = false;
 p34.BuySelection = nil;
 local v38 = game.ReplicatedStorage.Assets.Sounds.Misc[v37 and "Money_Kaching" or "denied_old"]:Clone();
 v38.Parent = script;
 v38:Play();
 DebrisModule:AddItem(v38, v38.TimeLength);

 return v37 and "CartPurchaseSuccess" or "CartPurchaseFail";
 end
 },
 Diagloues = {
 ShopDialogue = {
 Text = "[Invalid Item!]<Color=rgb(255,0,0)>",
 Answers = true,

 BeforeRun = function(p39: userdata) -- Line: 199, Name: BeforeRun
 -- upvalues: Shop (copy)
 if Shop.itemsforsale[p39.ObjectText] ~= nil then
 return "BuyItem";
 end;
 end
 },
 BuyItem = {
 Text = function(p40: userdata, p41: table) -- Line: 209, Name: Text
 -- upvalues: Shop (copy), gameSettings (copy)
 p41.ShopPrompt = p40;
 local v42 = p41.BuyItemName or p40.ObjectText;
 local Price = Shop.GetPrice(v42, true);

 return `Would you like to purchase ['{v42}']<{gameSettings.RichTextPopularConfigs.SoroundColor}> for [{Price}]<style=Rainbow,color=(1,1,1)> each?`;
 end,

 Content = v2,
 Answers = {
 Buy = "ProceedWithPurchase",
 Cancel = false
 }
 },
 PurchaseSuccess = {
 Text = "[Thanks for the business!]<Style=Rainbow,Color=(1,1,1)>",
 Answers = 1
 },
 CartConfirm = {
 Text = function(p43: userdata, p44: table) -- Line: 228, Name: Text
 -- upvalues: Shop (copy)
 local CartTotals, v45 = Shop.GetCartTotals(p44.BuySelection);
 local v46 = #Shop.GetCartDeferred(p44.BuySelection);

 if v45 < 1 then
 return `{v46} Robux item(s) then. Roblox will ask you to confirm each one. Deal?`;
 end;

 if v46 > 0 then
 return `{v45} piece(s) then. That will be {Shop.FormatTotalsTextPlus(CartTotals)} for the lot, and Roblox will ask you about {v46} Robux item(s) on top. Deal?`;
 end;

 return `{v45} piece(s) then. That will be {Shop.FormatTotalsTextPlus(CartTotals)} for the lot. Deal?`;
 end,

 Answers = {
 Deal = "ProceedWithCartPurchase",
 ["Let me look again"] = "BackToShop"
 }
 },
 CartNothing = {
 Text = "You have not picked anything out yet.",
 Answers = true,

 IfTrue = function(p47: userdata, p48: table) -- Line: 247, Name: IfTrue
 return p48.CartShopNode;
 end
 },
 CartPurchaseSuccess = {
 Text = "[Thanks for the business!]<Style=Rainbow,Color=(1,1,1)>",
 Answers = {
 ["Buy more"] = "BackToShop",
 Close = ""
 }
 },
 CartPurchaseFail = {
 Text = "[The purchase fell through. Check your coin and try again.]<Color=(1,.3,.3)>",
 Answers = true,

 IfTrue = function(p49: userdata, p50: table) -- Line: 261, Name: IfTrue
 return p50.CartShopNode;
 end
 },
 PurchaseFail = {
 Answers = 1,

 Text = function(p51: userdata, p52: table) -- Line: 266, Name: Text
 return `[Purchase failed due not having {p52.PurchaseReason}]<Color=(1,.3,.3)>`;
 end
 },
 NoQuest = {
 Text = "[Unable to accept this quest at the moment, wait [[#timeforquest]s]<Color=rgb(255,255,255)> then try again!]<Color=rgb(255,0,0)>",
 Answers = true
 },
 NoQuestMaximumReached = {
 Answers = true,

 Text = function() -- Line: 277, Name: Text
 -- upvalues: u4 (ref), gameSettings (copy)
 return u4 == nil and "[You are already doing a quest of this category, cancel it and retry.]<Color=rgb(255,0,0)>" or `[Abandon Quest ['{u4}']<{gameSettings.RichTextPopularConfigs.SoroundColor}> first!]<Color=rgb(255,0,0)>`;
 end
 },
 AlreadyDoingQuest = {
 Text = "[You are already doing this quest!]<Color=rgb(255,150,75)>",
 Answers = true
 },
 QuestAlreadyCompleted = {
 Text = "[You have already completed this quest!]<Color=rgb(255,150,75)>",
 Answers = true
 },
 NotEnoughWen = {
 Answers = true,

 Text = function() -- Line: 294, Name: Text
 -- upvalues: Utility (copy), u5 (ref)
 return `[You need [{Utility.addCommasToNumber(u5 or 0)} Wen]<Color=(1,1,1)> for this Quest!]<Color=(1,.3,.3)>`;
 end
 },
 RequirementNotMet = {
 Answers = true,

 Text = function() -- Line: 301, Name: Text
 -- upvalues: u7 (ref)
 return `[You need to be [{u7 or "?"}]<Color=rgb(161,199,230)> for this Quest!]<Color=(1,.3,.3)>`;
 end
 },
 NotEnoughItems = {
 Answers = true,

 Text = function() -- Line: 308, Name: Text
 -- upvalues: u6 (ref), Utility (copy)
 local v53 = u6 or {
 Name = "?",
 Count = 0
 };

 return `[You need [{Utility.addCommasToNumber(v53.Count)} {v53.Name}]<Color=(1,.85,.3)> for this Quest!]<Color=(1,.3,.3)>`;
 end
 }
 }
};

for _, child in script:GetChildren() do
 if child:IsA("ModuleScript") and child.Name ~= "TextPlusIDs" then
 local success, result = pcall(require, child);

 if success and type(result) == "table" then
 for i, v in result do
 u54.Diagloues[i] = v;
 end;
 else
 warn((`Dialogue: sibling module "{child.Name}" did not load, its nodes are missing: {result}`));
 end;
 end;
end;

function u54.ResetStorage() -- Line: 382
 -- upvalues: u54 (copy)
 table.clear(u54.Storage);

 return u54.Storage;
end;

return u54;