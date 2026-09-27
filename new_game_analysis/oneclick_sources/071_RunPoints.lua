-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

local function owner(p1: userdata) -- Line: 12
 -- upvalues: Players (copy)
 local Parent = p1.Parent;
 local v2;

 if Parent == nil then
 v2 = nil;
 else
 v2 = Parent.Parent;
 end;

 if v2 == nil then
 return nil;
 end;

 return Players:FindFirstChild(v2.Name);
end;

local v3 = {};

local function towerScore() -- Line: 21
 -- upvalues: ReplicatedStorage (copy)
 local v4 = ReplicatedStorage:FindFirstChild("Minigames Place");
 local v5 = v4 ~= nil and v4:FindFirstChild("Minigames") or nil;
 local v6 = v5 ~= nil and v5:FindFirstChild("Ouwigahara") or nil;

 if v6 == nil then
 return nil;
 end;

 return require(v6.Score);
end;

function v3.FormulateTextPlusText(p7: number) -- Line: 28
 -- upvalues: Utility (copy), BunchaIcons (copy)
 return `{Utility.addCommasToNumber(p7)} [#]<img={BunchaIcons.OuwigaharaPointsRaw}>`;
end;

function v3.FormulateRichText(p8: number) -- Line: 32
 -- upvalues: Utility (copy)
 return `<font color="rgb(255,217,77)">{Utility.addCommasToNumber(p8)} points</font>`;
end;

function v3.GetContent(p9: number) -- Line: 36
 -- upvalues: BunchaIcons (copy)
 return {
 Icon = BunchaIcons.OuwigaharaPoints,
 Price = p9
 };
end;

function v3.CanBuy(p10: userdata, p11: number) -- Line: 40
 -- upvalues: Players (copy)
 local Parent = p10.Parent;
 local v12;

 if Parent == nil then
 v12 = nil;
 else
 v12 = Parent.Parent;
 end;

 local v13;

 if v12 == nil then
 v13 = nil;
 else
 v13 = Players:FindFirstChild(v12.Name);
 end;

 if v13 == nil or (v13:GetAttribute("SaveDisabled") == true or v13:GetAttribute("SaveDisabledSlot") == true) then
 return false;
 end;

 return p11 <= (tonumber(v13:GetAttribute("RunPoints")) or 0);
end;

function v3.Buy(p14: userdata, p15: number, p16: userdata?, p17: string?) -- Line: 46
 -- upvalues: Players (copy), towerScore (copy)
 if not p16 then
 local Parent = p14.Parent;
 local v18;

 if Parent == nil then
 v18 = nil;
 else
 v18 = Parent.Parent;
 end;

 if v18 == nil then
 p16 = nil;
 else
 p16 = Players:FindFirstChild(v18.Name);
 end;
 end;

 if p16 == nil then
 return;
 end;

 require(game:GetService("ServerStorage").SAM.Services.AnalyticsService).Track(p16, "ItemSpent", {
 Item = "RunPoints",
 Sink = "ShopPurchase"
 }, p15);
 local v19 = towerScore();

 if v19 == nil then
 p16:SetAttribute("RunPoints", (tonumber(p16:GetAttribute("RunPoints")) or 0) - p15);

 return;
 end;

 v19.Spend(p16, p15);
end;

return v3;