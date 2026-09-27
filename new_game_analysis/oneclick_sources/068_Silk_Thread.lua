-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local v7 = {
 FormulateTextPlusText = function(p1: number) -- Line: 13, Name: FormulateTextPlusText
 -- upvalues: Utility (copy)
 return `{Utility.addCommasToNumber(p1)} [#]<img={86755077727133}>`;
 end,

 FormulateRichText = function(p2: number) -- Line: 18, Name: FormulateRichText
 -- upvalues: Utility (copy)
 return `<font color="rgb(223,230,204)">{Utility.addCommasToNumber(p2)} Silk Thread</font>`;
 end,

 GetContent = function(p3: number) -- Line: 23, Name: GetContent
 return {
 Icon = "rbxassetid://86755077727133",
 Price = p3
 };
 end,

 CanBuy = function(p4: userdata, p5: number) -- Line: 27, Name: CanBuy
 local v6 = p4.Inventory.Inventory:FindFirstChild("Silk Thread");

 if v6 == nil then
 return false;
 end;

 local Amount = v6:FindFirstChild("Amount");

 return p5 <= (Amount == nil and 1 or (Amount.Value or 1));
 end
};
local u8 = nil;

function v7.Buy(p9: userdata, p10: number, p11: userdata?, p12: string?) -- Line: 36
 -- upvalues: u8 (ref)
 if p11 == nil then
 return;
 end;

 u8 = u8 or require(game:GetService("ServerStorage").SAM.Services.Removers.Item);
 u8(p11, "Silk Thread", p10, nil, "ShopPurchase");
end;

return v7;