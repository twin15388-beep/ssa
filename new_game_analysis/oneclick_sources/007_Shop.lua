-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local RunService = game:GetService("RunService");
local Utility = require(script.Parent.Utility);
local gameSettings = require(script.Parent.gameSettings);
local u1 = {
 itemsforsale = {},
 cashiers = {
 Wen = require(script.Cashiers.Wen),
 Product = require(script.Cashiers.Product),
 Gamepass = require(script.Cashiers.Gamepass),
 Spins = require(script.Cashiers.Spins),
 ["Demon Horns"] = require(script.Cashiers["Demon Horns"]),
 ["Golden Fish"] = require(script.Cashiers["Golden Fish"]),
 ["Metal Scraps"] = require(script.Cashiers["Metal Scraps"]),
 ["Silk Thread"] = require(script.Cashiers["Silk Thread"]),
 ["Refinement Ore"] = require(script.Cashiers["Refinement Ore"]),
 ["Mythic Refinement Ore"] = require(script.Cashiers["Mythic Refinement Ore"]),
 RunPoints = require(script.Cashiers.RunPoints)
 }
};
local u2 = RunService:IsServer();

if u2 then
 u1.OrderProcessers = {
 Item = require(script.OrderProcessers.Item),
 Spins = require(script.OrderProcessers.Spins),
 Product = require(script.OrderProcessers.Product),
 Clan = require(script.OrderProcessers.Clan),
 Grant = require(script.OrderProcessers.Grant)
 };
end;

for _, v in ipairs(script.Content:QueryDescendants("ModuleScript")) do
 local Name = v.Name;
 local v3 = require(v);

 if v3.Price then
 u1.itemsforsale[Name] = v3;
 else
 for i, v2 in v3 do
 u1.itemsforsale[i] = v2;
 end;
 end;
end;

u1.ProductIdToItem = {};
local u4 = nil;

local function warmProductPrice(p5: number) -- Line: 67
 -- upvalues: u1 (copy)
 task.spawn(u1.cashiers.Product.GetRobuxPrice, p5);
end;

function u1.RegisterItem(p6: string, p7: table) -- Line: 77
 -- upvalues: u1 (copy), u4 (ref)
 local v8 = u1.itemsforsale[p6];

 if v8 ~= nil and (v8.Seller ~= nil and p7.Seller ~= nil) then
 for _, v in v8.Seller do
 if table.find(p7.Seller, v) == nil then
 table.insert(p7.Seller, v);
 end;
 end;
 end;

 local Price = p7.Price;

 if Price == nil then
 u4 = u4 or require(script.Parent.Collectibles.Items);
 local v9 = u4[p6];

 if v9 == nil then
 Price = nil;
 else
 Price = v9.Price or nil;
 end;

 if Price == nil then
 warn((`Shop: "{p6}" has no price on its listing or its item module, not listed`));

 return false;
 end;

 p7.Price = Price;
 end;

 u1.itemsforsale[p6] = p7;

 if Price.Product ~= nil then
 u1.ProductIdToItem[Price.Product] = p6;
 task.spawn(u1.cashiers.Product.GetRobuxPrice, Price.Product);
 end;

 return true;
end;

local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;

for i, v in u1.itemsforsale do
 if v.Price ~= nil and v.Price.Product ~= nil then
 u1.ProductIdToItem[v.Price.Product] = i;
 task.spawn(u1.cashiers.Product.GetRobuxPrice, v.Price.Product);
 end;
end;

function u1.RegisterProductMapping(p18: number, p19: string) -- Line: 115
 -- upvalues: u1 (copy)
 u1.ProductIdToItem[p18] = p19;
 task.spawn(u1.cashiers.Product.GetRobuxPrice, p18);
end;

function u1.ListingsOfType(p20: string, u21: string?) -- Line: 129
 -- upvalues: u1 (copy)
 local v22 = {};

 for i, v in u1.itemsforsale do
 if v.Type == p20 then
 local table_clone_ret = table.clone(v);
 table_clone_ret.Name = i;

 if typeof(v.Price) == "table" and v.Price.Product ~= nil then
 table_clone_ret.Price = u1.cashiers.Product.GetRobuxPrice(v.Price.Product);
 end;

 table.insert(v22, table_clone_ret);
 end;
 end;

 table.sort(v22, function(p23, p24) -- Line: 140
 -- upvalues: u21 (copy)
 if u21 == nil or (tonumber(p23[u21]) == nil or tonumber(p24[u21]) == nil) then
 return p23.Name < p24.Name;
 end;

 return p23[u21] < p24[u21];
 end);

 for _, v in v22 do
 v.OrePrice = u1.GetOrePrice(v.Name);
 end;

 return v22;
end;

local function oreRate() -- Line: 170
 -- upvalues: gameSettings (copy)
 local SellRobuxPayout = gameSettings.SellRobuxPayout;

 if SellRobuxPayout == nil or (SellRobuxPayout.Item == nil or (SellRobuxPayout.RobuxEach or 0) <= 0) then
 return nil;
 end;

 return SellRobuxPayout;
end;

local function oreHeld(p25: userdata, p26: string) -- Line: 175
 local v27 = p25.Inventory.Inventory:FindFirstChild(p26);

 if v27 == nil then
 return 0;
 end;

 local Amount = v27:FindFirstChild("Amount");

 return Amount ~= nil and Amount.Value or 1;
end;

function u1.GetOrePrice(p28: string) -- Line: 184
 -- upvalues: u1 (copy), gameSettings (copy)
 local v29 = u1.itemsforsale[p28];

 if v29 == nil or v29.AllowOre ~= true then
 return nil;
 end;

 local v30 = typeof(v29.Price) == "table" and v29.Price.Product or nil;

 if v30 == nil then
 return nil;
 end;

 local SellRobuxPayout = gameSettings.SellRobuxPayout;

 if SellRobuxPayout == nil or (SellRobuxPayout.Item == nil or (SellRobuxPayout.RobuxEach or 0) <= 0) then
 SellRobuxPayout = nil;
 end;

 if SellRobuxPayout == nil then
 return nil;
 end;

 local BaseRobuxPrice = u1.cashiers.Product.GetBaseRobuxPrice(v30);

 if BaseRobuxPrice == nil then
 return nil;
 end;

 local math_ceil_ret = math.ceil(BaseRobuxPrice / SellRobuxPayout.RobuxEach);

 return math.max(math_ceil_ret, 1);
end;

function u1.GetOreContent(p31: userdata?, p32: string, p33: number?) -- Line: 198
 -- upvalues: u1 (copy), gameSettings (copy), u4 (ref), Utility (copy)
 local OrePrice = u1.GetOrePrice(p32);

 if OrePrice == nil then
 return nil;
 end;

 local SellRobuxPayout = gameSettings.SellRobuxPayout;

 if SellRobuxPayout == nil or (SellRobuxPayout.Item == nil or (SellRobuxPayout.RobuxEach or 0) <= 0) then
 SellRobuxPayout = nil;
 end;

 u4 = u4 or require(script.Parent.Collectibles.Items);
 local v34 = u4[SellRobuxPayout.Item];
 local v35 = OrePrice * u1.EffectiveAmount(p32, p33);
 local v36 = {
 Icon = v34 == nil and "" or (v34.Icon or ""),
 Price = v35,
 Item = SellRobuxPayout.Item
 };
 local v37;

 if p31 == nil then
 v37 = nil;
 else
 v37 = Utility.GetData(p31) or nil;
 end;

 if v37 ~= nil then
 local v38 = v37.Inventory.Inventory:FindFirstChild(SellRobuxPayout.Item);
 local v39;

 if v38 == nil then
 v39 = 0;
 else
 local Amount = v38:FindFirstChild("Amount");
 v39 = Amount ~= nil and Amount.Value or 1;
 end;

 v36.Held = v39;
 v36.CanBuy = v35 <= v36.Held;
 end;

 return v36;
end;

function u1.CanBuyWithOre(p40: userdata, p41: string, p42: userdata?, p43: number?) -- Line: 216
 -- upvalues: u1 (copy), Utility (copy), u10 (ref), gameSettings (copy)
 local OrePrice = u1.GetOrePrice(p41);

 if OrePrice == nil then
 return false, "Not sold for ore";
 end;

 local v44 = p42 or Utility.GetData(p40);

 if v44 == nil then
 return false, "Data not ready";
 end;

 local v45, v46 = u10(p40, p41);

 if v45 then
 return false, v46;
 end;

 local SellRobuxPayout = gameSettings.SellRobuxPayout;

 if SellRobuxPayout == nil or (SellRobuxPayout.Item == nil or (SellRobuxPayout.RobuxEach or 0) <= 0) then
 SellRobuxPayout = nil;
 end;

 local v47 = OrePrice * u1.EffectiveAmount(p41, p43);
 local v48 = v44.Inventory.Inventory:FindFirstChild(SellRobuxPayout.Item);
 local v49;

 if v48 == nil then
 v49 = 0;
 else
 local Amount = v48:FindFirstChild("Amount");
 v49 = Amount ~= nil and Amount.Value or 1;
 end;

 if v49 < v47 then
 return false, `Need {Utility.addCommasToNumber(v47)} {SellRobuxPayout.Item}`;
 end;

 return true;
end;

local Players = game:GetService("Players");
local u50 = setmetatable({}, {
 __mode = "k"
});
local u51 = setmetatable({}, {
 __mode = "k"
});
local u52 = setmetatable({}, {
 __mode = "k"
});

function u1.ResolveGiftRecipient(p53: userdata, p54: string, p55: any) -- Line: 286
 -- upvalues: u1 (copy), Players (copy), Utility (copy), u10 (ref)
 if typeof(p55) ~= "string" or p55 == "" then
 return nil;
 end;

 if u1.itemsforsale[p54] == nil then
 return nil;
 end;

 local v56 = Players:FindFirstChild(p55);

 if v56 == nil or not v56:IsA("Player") then
 return nil, `{p55} is not in this server`;
 end;

 if v56 == p53 then
 return nil;
 end;

 if Utility.GetData(v56) == nil then
 return nil, `{v56.DisplayName}'s data is still loading`;
 end;

 local v57, v58 = u10(v56, p54);

 if v57 then
 return nil, `{v56.DisplayName} can't receive this: {v58 or "they don\'t qualify"}`;
 end;

 return v56;
end;

local function giftFolder(p59: userdata, p60: boolean?) -- Line: 320
 -- upvalues: Utility (copy)
 local _, v61 = Utility.GetData(p59);

 if v61 == nil then
 return nil;
 end;

 local PendingGifts = v61:FindFirstChild("PendingGifts");

 if PendingGifts == nil and p60 then
 PendingGifts = Instance.new("Folder");
 PendingGifts.Name = "PendingGifts";
 PendingGifts.Parent = v61;
 end;

 return PendingGifts;
end;

function u1.SetGiftIntent(p62: userdata, p63: string, p64: userdata?) -- Line: 332
 -- upvalues: u1 (copy), u52 (copy), Utility (copy)
 local v65 = u1.itemsforsale[p63];
 local v66;

 if v65 == nil or v65.Price == nil then
 v66 = nil;
 else
 v66 = v65.Price.Product or nil;
 end;

 if v66 == nil then
 return;
 end;

 local v67 = tostring(v66);
 local v68 = u52[p62];

 if p64 == nil then
 if v68 ~= nil then
 v68[v66] = nil;
 end;

 local _, v69 = Utility.GetData(p62);
 local v70;

 if v69 == nil then
 v70 = nil;
 else
 v70 = v69:FindFirstChild("PendingGifts");
 local _ = v70 == nil;
 end;

 local v71 = v70 ~= nil and v70:FindFirstChild(v67) or nil;

 if v71 ~= nil then
 v71:Destroy();
 end;

 return;
 end;

 if v68 == nil then
 v68 = {};
 u52[p62] = v68;
 end;

 v68[v66] = p64.Name;
 local _, v72 = Utility.GetData(p62);
 local v73;

 if v72 == nil then
 v73 = nil;
 else
 v73 = v72:FindFirstChild("PendingGifts");

 if v73 == nil then
 v73 = Instance.new("Folder");
 v73.Name = "PendingGifts";
 v73.Parent = v72;
 end;
 end;

 if v73 == nil then
 return;
 end;

 local v74 = v73:FindFirstChild(v67);

 if v74 == nil then
 v74 = Instance.new("StringValue");
 v74.Name = v67;
 v74.Parent = v73;
 end;

 v74.Value = p64.Name;
end;

local function peekGiftIntent(p75: userdata, p76: number) -- Line: 365
 -- upvalues: u52 (copy), Utility (copy)
 local v77 = u52[p75];
 local v78;

 if v77 == nil then
 v78 = nil;
 else
 v78 = v77[p76] or nil;
 end;

 if v78 ~= nil then
 return v78, false;
 end;

 local _, v79 = Utility.GetData(p75);
 local v80;

 if v79 == nil then
 v80 = nil;
 else
 v80 = v79:FindFirstChild("PendingGifts");
 local _ = v80 == nil;
 end;

 local v81 = v80 ~= nil and v80:FindFirstChild((tostring(p76))) or nil;

 if v81 == nil then
 return nil, false;
 end;

 return v81.Value, true;
end;

local function clearGiftIntent(p82: userdata, p83: number) -- Line: 374
 -- upvalues: u52 (copy), Utility (copy)
 local v84 = u52[p82];

 if v84 ~= nil then
 v84[p83] = nil;
 end;

 local _, v85 = Utility.GetData(p82);
 local v86;

 if v85 == nil then
 v86 = nil;
 else
 v86 = v85:FindFirstChild("PendingGifts");
 local _ = v86 == nil;
 end;

 local v87 = v86 ~= nil and v86:FindFirstChild((tostring(p83))) or nil;

 if v87 ~= nil then
 v87:Destroy();
 end;
end;

function u1.GiftConsent(u88: userdata, u89: userdata?, u90: string, p91: any) -- Line: 393
 -- upvalues: u1 (copy), u51 (copy), u50 (copy), Utility (copy)
 local v92 = u1.itemsforsale[u90];

 if v92 == nil or v92.AskFirst ~= true then
 return true;
 end;

 if u89 == nil then
 if typeof(p91) == "string" and p91 ~= "" then
 return false, `{p91} is not available any more`;
 end;

 return true;
 end;

 local v93 = u51[u89];

 if v93 ~= nil and os.clock() - v93 < 20 then
 return false, `{u89.DisplayName} was just asked, give them a moment`;
 end;

 if u89:GetAttribute("Invites") ~= true then
 return false, `{u89.DisplayName} is not accepting requests right now`;
 end;

 if u50[u89] then
 return false, `{u89.DisplayName} is already being asked about a gift`;
 end;

 u50[u89] = true;
 local SignalFunction = require(game:GetService("ReplicatedStorage").Communication.ServerAndClient.Signals.SignalFunction);
 local success, result = pcall(function() -- Line: 421
 -- upvalues: SignalFunction (copy), u89 (copy), Utility (ref), u88 (copy), u90 (copy)
 return SignalFunction.ToClient(u89, "InferPopup", {
 Type = "CenterBottomQuestion",
 Timout = 10,
 Content = `{Utility.NameTag(u88.DisplayName, true)} wants to buy you {Utility.NameTag(u90, true)}. Accept?`
 });
 end);
 u50[u89] = nil;

 if not success or result ~= "Yes" then
 u51[u89] = os.clock();
 end;

 if not success then
 return false, `{u89.DisplayName} could not be asked`;
 end;

 if result == "Yes" then
 return true;
 end;

 return false, `{u89.DisplayName} said no`;
end;

local function giftNotify(p94: userdata, p95: userdata, p96: string) -- Line: 449
 require(game:GetService("ReplicatedStorage").Communication.ServerAndClient.Signals.SignalEvent).ToClient(p95, "Notify", {
 Type = "Success",
 Duration = 10,
 Text = `{p94.DisplayName} gifted you {p96}!`
 });
end;

if u2 then
 local u97 = nil;
 local u98 = nil;

 function u1.BuyWithOre(p99: userdata, p100: string, p101: userdata?, p102: number?) -- Line: 467
 -- upvalues: Utility (copy), u1 (copy), gameSettings (copy), u97 (ref), u98 (ref)
 local v103 = p101 or Utility.GetData(p99);

 if v103 == nil then
 return false, "Data not ready";
 end;

 local v104 = u1.EffectiveAmount(p100, p102);
 local v105, v106 = u1.CanBuyWithOre(p99, p100, v103, v104);

 if not v105 then
 return false, v106;
 end;

 local v107 = u1.itemsforsale[p100];
 local v108;

 if v107 == nil then
 v108 = nil;
 else
 v108 = u1.OrderProcessers[v107.Type] or nil;
 end;

 if v108 == nil then
 return false, "Bad listing";
 end;

 local SellRobuxPayout = gameSettings.SellRobuxPayout;

 if SellRobuxPayout == nil or (SellRobuxPayout.Item == nil or (SellRobuxPayout.RobuxEach or 0) <= 0) then
 SellRobuxPayout = nil;
 end;

 local v109 = u1.GetOrePrice(p100) * v104;
 u97 = u97 or require(game:GetService("ServerStorage").SAM.Services.Removers.Item);

 if not u97(p99, SellRobuxPayout.Item, v109) then
 return false, `Need {Utility.addCommasToNumber(v109)} {SellRobuxPayout.Item}`;
 end;

 if not v108(p99, v103, p100, v104, v107) then
 require(game:GetService("ServerStorage").SAM.Services.Adders.Item)(p99, SellRobuxPayout.Item, v109, nil, nil, nil, "ShopOreRefund");

 return false, "Something went wrong";
 end;

 u98 = u98 or require(game:GetService("ServerStorage").SAM.Services.AnalyticsService);
 u98.Economy(p99, SellRobuxPayout.Item, "Sink", v109, "ShopPurchase", p100);

 return true;
 end;
end;

local function getCashier(p110: string) -- Line: 515
 -- upvalues: u1 (copy)
 local v111 = u1.cashiers[p110];

 if v111 == nil then
 warn((`Shop: no cashier for currency "{p110}", listing refused`));
 end;

 return v111;
end;

local u112 = nil;

local function pricedFor(p113: userdata?, p114: string, p115: number, p116: number) -- Line: 536
 -- upvalues: u2 (copy), Utility (copy), u112 (ref)
 local v117 = p115 * p116;

 if p114 ~= "Wen" or v117 <= 0 then
 return v117;
 end;

 if p113 == nil and not u2 then
 p113 = game:GetService("Players").LocalPlayer;
 end;

 if p113 == nil then
 return v117;
 end;

 local Data = Utility.GetData(p113);
 local v118;

 if Data == nil then
 v118 = nil;
 else
 v118 = Data:FindFirstChild("Clan") or nil;
 end;

 if v118 == nil then
 return v117;
 end;

 u112 = u112 or require(script.Parent.Parent.Clans);

 if u112.HasPassive(v118.Value, "Serenity Discount") then
 v117 = math.ceil(v117 * 0.7);
 end;

 return v117;
end;

u1.PricedFor = pricedFor;

function u1.SanitizeAmount(p119) -- Line: 555
 local v120 = tonumber(p119);
 local math_floor_ret = math.floor((v120 == nil or (v120 ~= v120 or (v120 == (1 / 0) or v120 == (-1 / 0)))) and 1 or v120);

 return math.clamp(math_floor_ret, 1, 99);
end;

function u1.EffectiveAmount(p121: string, p122: any) -- Line: 564
 -- upvalues: u1 (copy), u4 (ref)
 local v123 = u1.SanitizeAmount(p122);

 if v123 > 1 then
 u4 = u4 or require(script.Parent.Collectibles.Items);
 local v124 = u4[p121];
 v123 = v124 ~= nil and (v124.Skills ~= nil or v124.HasCombat) and 1 or v123;
 end;

 return v123;
end;

function u1.Buy(p125: userdata, p126: string, p127: userdata?, p128: number?) -- Line: 575
 -- upvalues: u2 (copy), Utility (copy), u1 (copy), pricedFor (copy)
 if not u2 then
 return;
 end;

 if p125 == nil or p126 == nil then
 return;
 end;

 local v129 = p127 or Utility.GetData(p125);

 if v129 == nil then
 return;
 end;

 local v130 = u1.EffectiveAmount(p126, p128);
 local v131 = u1.itemsforsale[p126];

 if v131 == nil then
 return;
 end;

 local v132 = false;

 for i in v131.Price do
 local v133 = u1.cashiers[i];

 if v133 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 if v133 == nil then
 return;
 end;

 if v133.Deferred then
 v132 = true;
 end;
 end;

 if not v132 then
 if not u1.OrderProcessers[v131.Type](p125, v129, p126, v130, v131) then
 return false;
 end;

 for i, v in v131.Price do
 u1.cashiers[i].Buy(v129, pricedFor(p125, i, v, v130), p125, p126);
 end;

 return true;
 end;

 for i, v in v131.Price do
 local v134 = u1.cashiers[i];

 if v134.Deferred then
 v134.Buy(v129, v, p125, p126);
 end;
 end;
end;

function u1.BuyDeferredAndWait(u135: userdata, p136: string, p137: userdata?) -- Line: 621
 -- upvalues: u2 (copy), u1 (copy), MarketplaceService (copy)
 if not u2 then
 return false;
 end;

 local v138 = u1.itemsforsale[p136];
 local u139;

 if v138 == nil or v138.Price == nil then
 u139 = nil;
 else
 u139 = v138.Price.Product or nil;
 end;

 local u140;

 if v138 == nil or v138.Price == nil then
 u140 = nil;
 else
 u140 = v138.Price.Gamepass or nil;
 end;

 if u139 == nil and u140 == nil then
 return false;
 end;

 u1.Buy(u135, p136, p137, 1);
 local u141 = false;
 local u142 = false;
 local v143;

 if u139 == nil then
 v143 = MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p144: userdata, p145: number, p146: boolean) -- Line: 639
 -- upvalues: u135 (copy), u140 (copy), u141 (ref), u142 (ref)
 if p144 == u135 and p145 == u140 then
 u141 = true;
 u142 = p146 == true;
 end;
 end);
 else
 v143 = MarketplaceService.PromptProductPurchaseFinished:Connect(function(p147: number, p148: number, p149: boolean) -- Line: 632
 -- upvalues: u135 (copy), u139 (copy), u141 (ref), u142 (ref)
 if p147 == u135.UserId and p148 == u139 then
 u141 = true;
 u142 = p149 == true;
 end;
 end);
 end;

 local v150 = os.clock() + 120;

 while not (u141 or (os.clock() >= v150 or u135.Parent == nil)) do
 task.wait(0.25);
 end;

 v143:Disconnect();

 if u141 and not u142 then
 u1.SetGiftIntent(u135, p136, nil);
 end;

 return u141 and u142;
end;

function u1.GetPrice(p151: string, p152: boolean?, p153: userdata?) -- Line: 657
 -- upvalues: u1 (copy), pricedFor (copy)
 if p151 == nil then
 return;
 end;

 local v154 = u1.itemsforsale[p151];

 if v154 ~= nil then
 if not p152 then
 return v154.Price;
 end;

 local v155 = "";

 for i, v in v154.Price do
 local v156 = u1.cashiers[i];

 if v156 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 local v157;

 if v156 == nil then
 v157 = nil;
 else
 v157 = v156.FormulateTextPlusText((pricedFor(p153, i, v, 1))) or nil;
 end;

 if v157 ~= nil then
 v155 = v155 == "" and v157 and v157 or v155 .. " and " .. v157;
 end;
 end;

 return v155;
 end;
end;

function u1.GetContent(p158: string, p159: userdata?) -- Line: 678
 -- upvalues: u1 (copy), pricedFor (copy)
 if p158 == nil then
 return;
 end;

 local v160 = u1.itemsforsale[p158];

 if v160 ~= nil then
 local v161 = {};

 for i, v in v160.Price do
 local v162 = u1.cashiers[i];

 if v162 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 if v162 == nil then
 return nil;
 end;

 local Content = v162.GetContent(v162.Deferred and v and v or pricedFor(p159, i, v, 1));

 if Content ~= nil then
 table.insert(v161, Content);
 end;
 end;

 return v161;
 end;
end;

u10 = function(p163: userdata, p164: string) -- Line: 702, Name: listingLocked
 -- upvalues: u1 (copy), u2 (copy), u15 (ref), u16 (ref), u17 (ref), u11 (ref), u12 (ref), u13 (ref), Utility (copy), u4 (ref), u14 (ref)
 local v165 = u1.itemsforsale[p164];

 if v165 == nil then
 return false;
 end;

 if u2 and v165.Seller ~= nil then
 u15 = u15 or require(game:GetService("ServerStorage").SAM.Utility.NearNpc);
 u16 = u16 or require(game:GetService("ServerStorage").SAM.Utility.NearSellerStand);

 if not (u15(p163, v165.Seller) or u16(p163, v165.Seller, p164)) then
 return true, "Too far from the seller";
 end;
 end;

 if (p163:GetAttribute("SaveDisabled") == true or p163:GetAttribute("SaveDisabledSlot") == true) and (typeof(v165.Price) == "table" and v165.Price.Product ~= nil) then
 return true, "Not while in a run";
 end;

 if v165.RequiresVIP == true then
 u17 = u17 or require(script.Parent.VipAccess);

 if not u17.Has(p163) then
 return true, "VIP required";
 end;
 end;

 u11 = u11 or require(script.Parent.ClanEvents);

 if u11.Read(p163)[p164] ~= nil then
 return true, "Not while its event runs";
 end;

 if v165.RequiresGamepass ~= nil and not u1.OwnsGamepassListing(p163, v165.RequiresGamepass) then
 return true, `{v165.RequiresGamepass} required`;
 end;

 if v165.RequiresSide ~= nil then
 u12 = u12 or require(script.Parent.PlayerProgression);

 if table.find(u12.SidesFor(p163), v165.RequiresSide) == nil then
 return true, `{v165.RequiresSide}s only`;
 end;
 end;

 if v165.Requirements ~= nil then
 u13 = u13 or require(script.Parent.Collectibles.ItemRequirements);

 if not u13.Passes(Utility.GetData(p163), v165.Requirements) then
 return true, u13.Describe(v165.Requirements);
 end;
 end;

 if v165.Type == "Item" then
 u4 = u4 or require(script.Parent.Collectibles.Items);
 local v166 = u4[p164];
 local Data = Utility.GetData(p163);

 if v166 ~= nil and (v166.Unique == true and (Data ~= nil and Data.Inventory.Inventory:FindFirstChild(p164) ~= nil)) then
 return true, "Already owned";
 end;
 end;

 local RequiresQuestDone = v165.RequiresQuestDone;

 if RequiresQuestDone == nil then
 return false;
 end;

 u14 = u14 or require(script.Parent.Subsets.Gameplay.Quests);

 if u14.GetPlayerQuestState(p163, RequiresQuestDone) == "Done" then
 return false;
 end;

 local QuestInfo = u14.GetQuestInfo(RequiresQuestDone);

 if QuestInfo ~= nil and QuestInfo.QuestInstance ~= nil then
 RequiresQuestDone = QuestInfo.QuestInstance.Name or RequiresQuestDone;
 end;

 return true, `{Utility.NameTag(RequiresQuestDone)} completed`;
end;

function u1.CanBuyResults(p167: userdata, p168: string, p169: userdata?, p170: number?) -- Line: 780
 -- upvalues: Utility (copy), u1 (copy), pricedFor (copy)
 if p168 == nil then
 return;
 end;

 local v171 = p169 or Utility.GetData(p167);

 if v171 == nil then
 return;
 end;

 local v172 = u1.EffectiveAmount(p168, p170);
 local v173 = u1.itemsforsale[p168];

 if v173 ~= nil then
 local v174 = {};

 for i, v in v173.Price do
 local v175 = u1.cashiers[i];

 if v175 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 if v175 == nil then
 return nil;
 end;

 local Content = v175.GetContent(v175.Deferred and v and v or pricedFor(p167, i, v, 1));

 if Content ~= nil then
 Content.CanBuy = v175.CanBuy(v171, v175.Deferred and v and v or pricedFor(p167, i, v, v172));
 table.insert(v174, Content);
 end;
 end;

 return v174;
 end;
end;

function u1.GetCartTotals(p176: table?, p177: userdata?) -- Line: 805
 -- upvalues: u1 (copy), pricedFor (copy)
 local v178 = {};
 local v179 = 0;

 if typeof(p176) ~= "table" then
 return v178, 0;
 end;

 for i, v in p176 do
 if typeof(i) == "string" and typeof(v) == "number" then
 local v180 = u1.itemsforsale[i];

 if v180 ~= nil and (v180.Price ~= nil and (v180.Price.Product == nil and v180.Price.Gamepass == nil)) then
 local v181 = u1.EffectiveAmount(i, v);
 v179 = v179 + v181;

 for i2, v2 in v180.Price do
 v178[i2] = (v178[i2] or 0) + pricedFor(p177, i2, v2, v181);
 end;
 end;
 end;
 end;

 return v178, v179;
end;

function u1.GetCartDeferred(p182: table?) -- Line: 826
 -- upvalues: u1 (copy)
 local v183 = {};

 if typeof(p182) ~= "table" then
 return v183;
 end;

 for i in p182 do
 if typeof(i) == "string" then
 local v184 = u1.itemsforsale[i];

 if v184 ~= nil and (v184.Price ~= nil and (v184.Price.Product ~= nil or v184.Price.Gamepass ~= nil)) then
 table.insert(v183, i);
 end;
 end;
 end;

 return v183;
end;

function u1.CanBuyCart(p185: userdata, p186: table?, p187: userdata?) -- Line: 843
 -- upvalues: Utility (copy), u10 (ref), u1 (copy)
 local v188 = p187 or Utility.GetData(p185);

 if v188 == nil then
 return false;
 end;

 if typeof(p186) == "table" then
 for i in p186 do
 local v189, v190 = u10(p185, i);

 if v189 then
 return false, v190;
 end;
 end;
 end;

 local CartTotals, v191 = u1.GetCartTotals(p186, p185);

 if v191 < 1 then
 return #u1.GetCartDeferred(p186) > 0;
 end;

 for i, v in CartTotals do
 local v192 = u1.cashiers[i];

 if v192 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 if v192 == nil then
 return false;
 end;

 if not v192.CanBuy(v188, v) then
 return false, v192.FormulateTextPlusText(v);
 end;
 end;

 return true;
end;

function u1.FormatTotalsTextPlus(p193: table) -- Line: 866
 -- upvalues: u1 (copy)
 local v194 = "";

 for i, v in p193 do
 local v195 = u1.cashiers[i];

 if v195 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 local v196;

 if v195 == nil then
 v196 = nil;
 else
 v196 = v195.FormulateTextPlusText(v) or nil;
 end;

 if v196 ~= nil then
 v194 = v194 == "" and v196 and v196 or v194 .. " and " .. v196;
 end;
 end;

 return v194;
end;

function u1.GetPriceRichText(p197: string, p198: number?, p199: userdata?) -- Line: 880
 -- upvalues: u1 (copy), pricedFor (copy)
 if p197 == nil then
 return;
 end;

 local v200 = u1.itemsforsale[p197];

 if v200 ~= nil then
 local v201 = "";

 for i, v in v200.Price do
 local v202 = u1.cashiers[i];

 if v202 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 if v202 == nil then
 return nil;
 end;

 local v203 = v202.FormulateRichText(v202.Deferred and v and v or pricedFor(p199, i, v, p198 or 1));

 if v203 then
 v201 = v201 == "" and v203 and v203 or v201 .. " and " .. v203;
 end;
 end;

 return v201;
 end;
end;

function u1.GetSellValue(p204: string) -- Line: 903
 -- upvalues: u4 (ref), u1 (copy), gameSettings (copy)
 u4 = u4 or require(script.Parent.Collectibles.Items);
 local v205 = u4[p204];

 if v205 ~= nil and v205.NoSell then
 return nil;
 end;

 local v206 = u1.itemsforsale[p204];
 local v207 = v206 ~= nil and v206.Price or (v205 ~= nil and v205.Price or nil);

 if v207 == nil then
 return nil;
 end;

 local v208 = 0;

 for i, v in v207 do
 if i == "Wen" then
 v208 = v208 + v;
 else
 local v209 = u1.cashiers[i];
 local v210, v211;

 if v209 == nil or not v209.Deferred then
 v210 = v;
 v211 = i;
 else
 local v212 = v209.GetBaseRobuxPrice or v209.GetRobuxPrice;

 if v212 == nil then
 return nil;
 end;

 v210 = v212(v);
 v211 = "Robux";
 end;

 local v213 = gameSettings.CurrencyToWen[v211];

 if v210 == nil or v213 == nil then
 return nil;
 end;

 v208 = v208 + v210 * v213.To / v213.From;
 end;
 end;

 return math.floor(v208 * gameSettings.sellReturnFactor);
end;

function u1.GetSellPayout(p214: string) -- Line: 949
 -- upvalues: u4 (ref), u1 (copy), gameSettings (copy)
 u4 = u4 or require(script.Parent.Collectibles.Items);
 local v215 = u4[p214];

 if v215 ~= nil and v215.NoSell then
 return nil;
 end;

 local v216 = u1.itemsforsale[p214];
 local v217 = v216 ~= nil and v216.Price or (v215 ~= nil and v215.Price or nil);

 if v217 == nil then
 return nil;
 end;

 local v218 = {};
 local v219 = false;

 for i, v in v217 do
 local v220 = u1.cashiers[i];

 if v220 == nil or not v220.Deferred then
 if i ~= "Wen" and u4[i] == nil then
 return nil;
 end;

 local math_floor_ret = math.floor(v * gameSettings.sellReturnFactor);
 local v221 = math_floor_ret < 1 and v > 0 and 1 or math_floor_ret;

 if v221 >= 1 then
 v218[i] = (v218[i] or 0) + v221;
 v219 = true;
 end;
 else
 local v222 = v220.GetBaseRobuxPrice or v220.GetRobuxPrice;

 if v222 == nil then
 return nil;
 end;

 local v223 = v222(v);
 local Robux = gameSettings.CurrencyToWen.Robux;

 if v223 == nil or Robux == nil then
 return nil;
 end;

 local v224 = v223 * gameSettings.sellReturnFactor;
 local SellRobuxPayout = gameSettings.SellRobuxPayout;

 if SellRobuxPayout ~= nil and (SellRobuxPayout.Item ~= nil and (SellRobuxPayout.RobuxEach or 0) > 0) then
 local math_floor_ret = math.floor(v224 / SellRobuxPayout.RobuxEach);

 if math_floor_ret >= 1 then
 v218[SellRobuxPayout.Item] = (v218[SellRobuxPayout.Item] or 0) + math_floor_ret;
 v224 = v224 - math_floor_ret * SellRobuxPayout.RobuxEach;
 v219 = true;
 end;
 end;

 local math_floor_ret = math.floor(v224 * Robux.To / Robux.From);

 if math_floor_ret >= 1 then
 v218.Wen = (v218.Wen or 0) + math_floor_ret;
 v219 = true;
 end;
 end;
 end;

 if v219 then
 return v218;
 end;

 return nil;
end;

function u1.GetSellContent(p225: string) -- Line: 1038
 -- upvalues: u1 (copy), u4 (ref)
 local SellPayout = u1.GetSellPayout(p225);

 if SellPayout == nil then
 return nil;
 end;

 local v226 = {};

 for i, v in SellPayout do
 local v227 = u1.cashiers[i];
 local v228;

 if v227 == nil or v227.GetContent == nil then
 v228 = nil;
 else
 v228 = v227.GetContent(v) or nil;
 end;

 if v228 == nil then
 u4 = u4 or require(script.Parent.Collectibles.Items);
 local v229 = u4[i];
 v228 = {};
 local v230;

 if v229 == nil then
 v230 = nil;
 else
 v230 = v229.Icon or nil;
 end;

 v228.Icon = v230;
 v228.Price = v;
 end;

 v228.Currency = i;
 table.insert(v226, v228);
 end;

 table.sort(v226, function(p231, p232) -- Line: 1053
 if p231.Currency == "Wen" == (p232.Currency == "Wen") then
 return p231.Currency < p232.Currency;
 end;

 return p231.Currency == "Wen";
 end);

 return v226;
end;

function u1.GetSellTotals(p233: table?) -- Line: 1065
 -- upvalues: u1 (copy)
 local v234 = {};
 local v235 = 0;

 if typeof(p233) ~= "table" then
 return v234, 0;
 end;

 for i, v in p233 do
 if typeof(i) == "string" and typeof(v) == "number" then
 local math_floor_ret = math.floor(v);
 local math_clamp_ret = math.clamp(math_floor_ret, 0, 999);

 if math_clamp_ret >= 1 then
 local SellPayout = u1.GetSellPayout(i);

 if SellPayout ~= nil then
 v235 = v235 + math_clamp_ret;

 for i2, v2 in SellPayout do
 v234[i2] = (v234[i2] or 0) + v2 * math_clamp_ret;
 end;
 end;
 end;
 end;
 end;

 return v234, v235;
end;

function u1.FormatSellTotalsTextPlus(p236: table) -- Line: 1088
 -- upvalues: u1 (copy), Utility (copy)
 local v237 = {};
 local v238 = "";

 for i in p236 do
 table.insert(v237, i);
 end;

 table.sort(v237, function(p239, p240) -- Line: 1095
 if p239 == "Wen" == (p240 == "Wen") then
 return p239 < p240;
 end;

 return p239 == "Wen";
 end);

 for _, v in ipairs(v237) do
 local v241 = p236[v];

 if v241 >= 1 then
 local v242 = u1.cashiers[v];
 local v243 = v242 ~= nil and v242.FormulateTextPlusText ~= nil and v242.FormulateTextPlusText(v241) or `{Utility.addCommasToNumber(v241)} {v}`;
 v238 = v238 == "" and v243 and v243 or v238 .. " and " .. v243;
 end;
 end;

 return v238 == "" and "nothing" or v238;
end;

function u1.OwnsGamepassListing(p244: userdata, p245: string) -- Line: 1117
 -- upvalues: u1 (copy)
 local v246 = u1.itemsforsale[p245];
 local v247;

 if v246 == nil or v246.Price == nil then
 v247 = nil;
 else
 v247 = v246.Price.Gamepass or nil;
 end;

 if v247 == nil or p244 == nil then
 return false;
 end;

 return u1.cashiers.Gamepass.OwnsGamepass(p244.UserId, v247);
end;

function u1.CanBuy(p248: userdata, p249: string, p250: userdata?, p251: number?) -- Line: 1123
 -- upvalues: Utility (copy), u1 (copy), u10 (ref), pricedFor (copy)
 if p249 == nil then
 return;
 end;

 local v252 = p250 or Utility.GetData(p248);

 if v252 ~= nil then
 local v253 = u1.EffectiveAmount(p249, p251);
 local v254 = u1.itemsforsale[p249];

 if v254 == nil then
 return false;
 end;

 local v255, v256 = u10(p248, p249);

 if v255 then
 return false, v256;
 end;

 for i, v in v254.Price do
 local v257 = u1.cashiers[i];

 if v257 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 if v257 == nil then
 return false;
 end;

 local v258 = v257.Deferred and v and v or pricedFor(p248, i, v, v253);

 if not v257.CanBuy(v252, v258) then
 return false, v257.FormulateTextPlusText(v258);
 end;
 end;

 return true, nil;
 end;
end;

if u2 then
 local Players2 = game:GetService("Players");
 local DiscordLogService = require(game:GetService("ServerStorage").SAM.Services.DiscordLogService);
 local MarketIcon = require(game:GetService("ServerStorage").SAM.Services.DiscordLogService.MarketIcon);

 local function receiptLine(u259: any, u260: userdata?, u261: string, u262: string?, u263: string?) -- Line: 1152
 -- upvalues: DiscordLogService (copy), MarketIcon (copy)
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u261 (copy), u260 (copy), u259 (copy), u262 (copy), u263 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u261, {
 player = u260,
 data = {
 productId = u259.ProductId,
 item = u262,
 purchaseId = u259.PurchaseId,
 currencySpent = u259.CurrencySpent,
 placePurchased = u259.PlaceIdWherePurchased,
 userId = u259.PlayerId,
 reason = u263,
 icon = MarketIcon.Resolve(u259.ProductId, "Product")
 }
 });
 end);
 end;

 function u1.GrantProduct(p264: userdata, p265: number) -- Line: 1178
 -- upvalues: u1 (copy), Utility (copy)
 if p264 == nil or typeof(p265) ~= "number" then
 return false, "No product";
 end;

 local v266 = u1.ProductIdToItem[p265];

 if v266 == nil then
 return false, `no listing maps product {p265}`;
 end;

 local Data = Utility.GetData(p264);

 if Data == nil then
 return false, "data not loaded";
 end;

 local v267 = u1.itemsforsale[v266] or {
 Type = "Item",
 Price = {
 Product = p265
 }
 };
 local v268 = u1.OrderProcessers[v267.Type];

 if v268 == nil then
 return false, `no order processor for "{tostring(v267.Type)}"`;
 end;

 return v268(p264, Data, v266, 1, v267);
 end;

 function u1.HandleProductReceipt(u269) -- Line: 1195
 -- upvalues: u1 (copy), DiscordLogService (copy), MarketIcon (copy), Players2 (copy), Utility (copy), u17 (ref), u52 (copy), pricedFor (copy), giftNotify (copy)
 local u270 = u1.ProductIdToItem[u269.ProductId];

 if u270 == nil then
 warn((`Shop: receipt for unknown product {u269.ProductId} (no listing maps it), left for retry`));
 local u271 = "ReceiptRefused";
 local u272 = nil;
 local u273 = nil;
 local u274 = "unknown product";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u271 (copy), u272 (copy), u269 (copy), u273 (copy), u274 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u271, {
 player = u272,
 data = {
 productId = u269.ProductId,
 item = u273,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u274,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);

 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;

 local PlayerByUserId = Players2:GetPlayerByUserId(u269.PlayerId);

 if PlayerByUserId == nil then
 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;

 local Data, v275 = Utility.GetData(PlayerByUserId);

 if Data == nil then
 local u276 = "ReceiptRefused";
 local u277 = "data not loaded";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u276 (copy), PlayerByUserId (copy), u269 (copy), u270 (copy), u277 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u276, {
 player = PlayerByUserId,
 data = {
 productId = u269.ProductId,
 item = u270,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u277,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);

 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;

 local u278;

 if v275 == nil then
 u278 = nil;
 else
 u278 = v275:FindFirstChild("ConsumedReceipts") or nil;
 end;

 if u278 ~= nil and string.find(u278.Value, u269.PurchaseId, 1, true) ~= nil then
 return Enum.ProductPurchaseDecision.PurchaseGranted;
 end;

 if PlayerByUserId:GetAttribute("SaveDisabled") == true or PlayerByUserId:GetAttribute("SaveDisabledSlot") == true then
 local u279 = "ReceiptRefused";
 local u280 = "no-persist session";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u279 (copy), PlayerByUserId (copy), u269 (copy), u270 (copy), u280 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u279, {
 player = PlayerByUserId,
 data = {
 productId = u269.ProductId,
 item = u270,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u280,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);

 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;

 if u278 ~= nil then
 local string_split_ret = string.split(u278.Value, ",");
 table.insert(string_split_ret, u269.PurchaseId);

 while #string_split_ret > 50 do
 table.remove(string_split_ret, 1);
 end;

 u278.Value = table.concat(string_split_ret, ",");
 end;

 local function unreserve() -- Line: 1234
 -- upvalues: u278 (copy), u269 (copy)
 if u278 == nil then
 return;
 end;

 local string_split_ret = string.split(u278.Value, ",");
 local table_find_ret = table.find(string_split_ret, u269.PurchaseId);

 if table_find_ret ~= nil then
 table.remove(string_split_ret, table_find_ret);
 u278.Value = table.concat(string_split_ret, ",");
 end;
 end;

 local v281 = u1.itemsforsale[u270];
 local v282 = v281 == nil and {
 Type = "Item",
 Price = {
 Product = u269.ProductId
 }
 } or v281;
 u17 = u17 or require(script.Parent.VipAccess);

 if v282.RequiresVIP == true and not u17.Has(PlayerByUserId) then
 warn((`Shop: receipt for "{u270}" (product {u269.ProductId}, {PlayerByUserId.Name}) refused: VIP required`));
 local u283 = "ReceiptRefused";
 local u284 = "VIP required";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u283 (copy), PlayerByUserId (copy), u269 (copy), u270 (copy), u284 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u283, {
 player = PlayerByUserId,
 data = {
 productId = u269.ProductId,
 item = u270,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u284,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);
 unreserve();

 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;

 local ProductId = u269.ProductId;
 local v285 = u52[PlayerByUserId];
 local v286;

 if v285 == nil then
 v286 = nil;
 else
 v286 = v285[ProductId] or nil;
 end;

 local v287;

 if v286 == nil then
 local _, v288 = Utility.GetData(PlayerByUserId);
 local v289;

 if v288 == nil then
 v289 = nil;
 else
 v289 = v288:FindFirstChild("PendingGifts");
 local _ = v289 == nil;
 end;

 local v290 = v289 ~= nil and v289:FindFirstChild((tostring(ProductId))) or nil;

 if v290 == nil then
 v287 = false;
 v286 = nil;
 else
 v286 = v290.Value;
 v287 = true;
 end;
 else
 v287 = false;
 end;

 local v291, v292;

 if v286 == nil then
 v291 = Data;
 v292 = PlayerByUserId;
 else
 v292 = u1.ResolveGiftRecipient(PlayerByUserId, u270, v286);

 if v292 == nil then
 v291 = nil;
 else
 v291 = Utility.GetData(v292) or nil;
 end;

 if v292 == nil or v291 == nil then
 if v282.AskFirst == true then
 warn((`Shop: gift of "{u270}" to {v286} held, they are not in this server`));
 local u293 = `gift recipient {v286} away`;
 local u294 = "ReceiptRefused";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u294 (copy), PlayerByUserId (copy), u269 (copy), u270 (copy), u293 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u294, {
 player = PlayerByUserId,
 data = {
 productId = u269.ProductId,
 item = u270,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u293,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);
 unreserve();

 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;

 v291 = Data;
 v292 = PlayerByUserId;
 elseif v282.AskFirst == true and (v287 and not u1.GiftConsent(PlayerByUserId, v292, u270, v286)) then
 local u295 = `gift consent from {v286} expired`;
 local u296 = "ReceiptRefused";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u296 (copy), PlayerByUserId (copy), u269 (copy), u270 (copy), u295 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u296, {
 player = PlayerByUserId,
 data = {
 productId = u269.ProductId,
 item = u270,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u295,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);
 unreserve();

 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;
 end;

 local v297, v298, v298 = pcall(u1.OrderProcessers[v282.Type], v292, v291, u270, 1, v282);
 local v299;

 if v297 then
 v299 = v298;
 else
 v299 = false;
 end;

 if not v299 then
 warn((`Shop: receipt for "{u270}" (product {u269.ProductId}, {PlayerByUserId.Name}) not granted: {tostring(v298)}`));
 local u300 = `not granted: {tostring(v298)}`;
 local u301 = "ReceiptRefused";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u301 (copy), PlayerByUserId (copy), u269 (copy), u270 (copy), u300 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u301, {
 player = PlayerByUserId,
 data = {
 productId = u269.ProductId,
 item = u270,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u300,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);
 unreserve();

 return Enum.ProductPurchaseDecision.NotProcessedYet;
 end;

 for i, v in v282.Price do
 local v302 = u1.cashiers[i];

 if v302 == nil then
 warn((`Shop: no cashier for currency "{i}", listing refused`));
 end;

 if v302 ~= nil and not v302.Deferred then
 v302.Buy(Data, pricedFor(PlayerByUserId, i, v, 1), PlayerByUserId, u270);
 end;
 end;

 local ProductId2 = u269.ProductId;
 local v303 = u52[PlayerByUserId];

 if v303 ~= nil then
 v303[ProductId2] = nil;
 end;

 local _, v304 = Utility.GetData(PlayerByUserId);
 local v305;

 if v304 == nil then
 v305 = nil;
 else
 v305 = v304:FindFirstChild("PendingGifts");
 local _ = v305 == nil;
 end;

 local v306;

 if v305 == nil then
 v306 = nil;
 else
 v306 = v305:FindFirstChild((tostring(ProductId2))) or nil;
 end;

 if v306 ~= nil then
 v306:Destroy();
 end;

 if v292 ~= PlayerByUserId then
 giftNotify(PlayerByUserId, v292, u270);
 end;

 local u307;

 if v292 == PlayerByUserId then
 u307 = nil;
 else
 u307 = `gift to {v292.Name}`;
 end;

 local u308 = "ReceiptGranted";
 task.spawn(function() -- Line: 1155
 -- upvalues: DiscordLogService (ref), u308 (copy), PlayerByUserId (copy), u269 (copy), u270 (copy), u307 (copy), MarketIcon (ref)
 DiscordLogService.Send("devproducts", u308, {
 player = PlayerByUserId,
 data = {
 productId = u269.ProductId,
 item = u270,
 purchaseId = u269.PurchaseId,
 currencySpent = u269.CurrencySpent,
 placePurchased = u269.PlaceIdWherePurchased,
 userId = u269.PlayerId,
 reason = u307,
 icon = MarketIcon.Resolve(u269.ProductId, "Product")
 }
 });
 end);

 return Enum.ProductPurchaseDecision.PurchaseGranted;
 end;
end;

return u1;