-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Crafting = require(ReplicatedStorage.CAM.Global.Crafting);
local Series = require(ReplicatedStorage.CAM.Global.Series);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local TransferPair = require(ReplicatedStorage.CAM.Client.Components.Misc.TransferPair);
local Footer = require(script.Parent.Footer);
local Header = require(script.Parent.Header);
local MaterialTile = require(script.Parent.MaterialTile);
local u1 = faye.Info(0.25, Enum.EasingStyle.Back);
local UDim2_fromScale_ret = UDim2.fromScale(0.9, 0.9);
local Color3_new_ret = Color3.new(1, 0.803922, 0.305882);
local v11 = {
    Offered = function(p2: string?) -- Line: 38, Name: Offered
        -- upvalues: Crafting (copy)
        for _, v in Crafting.ForStation(p2) do
            if v.requiredTier ~= nil then
                return true;
            end;
        end;

        return false;
    end,

    new = function(u3: any, p4: string?) -- Line: 46, Name: new
        -- upvalues: Utility (copy), Players (copy), Crafting (copy), Series (copy)
        local Data = Utility.GetData(Players.LocalPlayer);
        local Inventory = Data.Inventory.Inventory;
        local u5 = u3:Value(0);

        local function bump() -- Line: 50
            -- upvalues: u5 (copy)
            u5:Set(u5.Value + 1);
        end;

        local function watch(p6: userdata) -- Line: 53
            -- upvalues: u3 (copy), bump (copy)
            if p6:IsA("ValueBase") and (p6.Name == "Amount" or p6.Name == "Tier") then
                u3:Connect(p6.Changed, bump);
            end;
        end;

        for _, v in { "#Amount", "#Tier" } do
            for _, v2 in Inventory:QueryDescendants(v) do
                if v2:IsA("ValueBase") and (v2.Name == "Amount" or v2.Name == "Tier") then
                    u3:Connect(v2.Changed, bump);
                end;
            end;
        end;

        u3:Connect(Inventory.DescendantAdded, function(p7: userdata) -- Line: 63
            -- upvalues: u3 (copy), bump (copy), u5 (copy)
            if p7:IsA("ValueBase") and (p7.Name == "Amount" or p7.Name == "Tier") then
                u3:Connect(p7.Changed, bump);
            end;

            u5:Set(u5.Value + 1);
        end);
        u3:Connect(Inventory.ChildRemoved, bump);
        u3:Connect(Data.Wen.Changed, bump);

        for _, v in { Data.Inventory.Toolbar, Data.Inventory.Accessories.Stats, Data.Inventory.Accessories.Vanity } do
            for _, child in v:GetChildren() do
                if child:IsA("ValueBase") then
                    u3:Connect(child.Changed, bump);
                end;
            end;
        end;

        local v8 = 1;
        local v9 = 0;

        for _, child in Inventory:GetChildren() do
            local Id = child:FindFirstChild("Id");

            if Id ~= nil and (Crafting.Spendable(child, child.Name) and v8 < Series.TierOf(child)) then
                v9 = Id.Value;
                v8 = Series.TierOf(child);
            end;
        end;

        local u10 = {
            Data = Data,
            Station = p4,
            From = u3:Value(v9),
            To = u3:Value(0),
            Step = u3:Value(v9 == 0 and "From" or "To"),
            Busy = u3:Value(false),
            Tick = u5
        };
        u3:Connect(u10.From.Changed, function() -- Line: 91
            -- upvalues: u10 (copy)
            u10.To:Set(0);

            if u10.From:Get() ~= 0 then
                u10.Step:Set("To");
            end;
        end);

        return u10;
    end
};

local function read(p12: table, p13: any) -- Line: 99
    -- upvalues: Crafting (copy), Series (copy)
    p13(p12.Tick);
    local Inventory = p12.Data.Inventory.Inventory;
    local v14 = {};

    for _, v in { p12.Data.Inventory.Toolbar, p12.Data.Inventory.Accessories.Stats, p12.Data.Inventory.Accessories.Vanity } do
        for _, child in v:GetChildren() do
            if child:IsA("ValueBase") and child.Value ~= 0 then
                v14[child.Value] = true;
            end;
        end;
    end;

    local v15 = {};

    for _, child in Inventory:GetChildren() do
        local Id = child:FindFirstChild("Id");

        if Id ~= nil and (Crafting.Spendable(child, child.Name) and Series.SetOf(child.Name) ~= nil) then
            local v16 = {
                Name = child.Name,
                Id = Id.Value,
                Tier = Series.TierOf(child),
                Equipped = v14[Id.Value] == true
            };
            table.insert(v15, v16);
        end;
    end;

    table.sort(v15, function(p17, p18) -- Line: 116
        if p17.Tier ~= p18.Tier then
            return p17.Tier > p18.Tier;
        end;

        if p17.Name == p18.Name then
            return p17.Id < p18.Id;
        end;

        return p17.Name < p18.Name;
    end);
    local v19 = p13(p12.From);
    local v20 = p13(p12.To);
    local v21 = {
        FromRows = {},
        ToRows = {}
    };

    for _, v in v15 do
        if v.Tier >= 2 then
            local FromRows = v21.FromRows;
            local v22 = {
                result = v.Name,
                tier = v.Tier,
                id = tostring(v.Id)
            };
            table.insert(FromRows, v22);

            if v.Id == v19 then
                v21.From = v;
            end;
        end;
    end;

    local From = v21.From;

    if From ~= nil then
        for _, v in v15 do
            if v.Tier < From.Tier then
                local v23 = Crafting.TierUp(v.Name, From.Tier);

                if v23 ~= nil and (p12.Station == nil or v23.station == p12.Station) then
                    local v24 = Crafting.TierTransferFee(From.Name, v.Name, v.Tier, From.Tier);

                    if v24 ~= nil then
                        local ToRows = v21.ToRows;
                        local v25 = {
                            result = v.Name,
                            tier = v.Tier,
                            id = tostring(v.Id)
                        };
                        table.insert(ToRows, v25);

                        if v.Id == v20 then
                            v21.To = v;
                            v21.Fee = v24;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v21;
end;

function v11.Pick(p26: table, p27: any) -- Line: 147
    -- upvalues: read (copy)
    local v28 = read(p26, p27);
    local v29 = p27(p26.Step) == "To" and v28.From ~= nil and "To" or "From";
    local v30;

    if v29 == "To" then
        v30 = v28.To;
    else
        v30 = v28.From;
    end;

    local v31 = {
        Step = v29
    };
    local v32;

    if v29 == "To" then
        v32 = v28.ToRows;
    else
        v32 = v28.FromRows;
    end;

    v31.Rows = v32;
    v31.Picked = v30 == nil and "" or tostring(v30.Id);

    return v31;
end;

function v11.View(p33: any, u34: table) -- Line: 159
    -- upvalues: Crafting (copy), u1 (copy), UDim2_fromScale_ret (copy), Header (copy), Color3_new_ret (copy), read (copy), Shop (copy), TransferPair (copy), MaterialTile (copy), Footer (copy), PopUpCreator (copy), SignalFunction (copy), ReplicatedStorage (copy), DebrisModule (copy)
    local Data = u34.Data;

    local function owned(p35: any, p36: string) -- Line: 161
        -- upvalues: Crafting (ref), Data (copy)
        return Crafting.Held(Data.Inventory.Inventory, p36);
    end;

    return p33:Create("Frame")({
        Name = "TierTransfer",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -6, 0.5, 0),
        Size = UDim2.new(0.65, -18, 1, -12),
        BackgroundTransparency = 1,
        p33:Create("Frame")({
            Name = "Holder",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = p33:Animation(UDim2.fromScale(1, 1), u1, {
                From = UDim2_fromScale_ret
            }),
            BackgroundTransparency = 1,
            Header(p33, "Tier Transfer", "The two pieces swap tiers", Color3_new_ret),
            p33:State(function(p37, p38) -- Line: 177
                -- upvalues: read (ref), u34 (copy), Shop (ref), Data (copy), Crafting (ref), TransferPair (ref), MaterialTile (ref), owned (copy), Footer (ref), PopUpCreator (ref), SignalFunction (ref), ReplicatedStorage (ref), DebrisModule (ref)
                local v39 = read(u34, p37);
                local From = v39.From;
                local To = v39.To;
                local v40 = {};
                local v41 = false;
                local v42 = {};

                for i, v in v39.Fee or {} do
                    if i == "Wen" then
                        table.insert(v42, {
                            Currency = "Wen",
                            Amount = v
                        });
                        v41 = v41 or not Shop.cashiers.Wen.CanBuy(Data, v);
                    else
                        table.insert(v40, {
                            name = i,
                            amount = v
                        });
                        v41 = v41 or Crafting.Held(Data.Inventory.Inventory, i) < v;
                    end;
                end;

                table.sort(v40, function(p43, p44) -- Line: 190
                    return p43.name < p44.name;
                end);
                local u45 = From == nil and "Pick a piece" or (To == nil and "Pick a Target" or ((From.Equipped or To.Equipped) and "Unequip first" or (v41 and "Can\'t afford" or nil)));
                local v46 = p38:Create("Frame");
                local v47 = {
                    Name = "Body",
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1
                };
                local v48;

                if From == nil then
                    v48 = nil;
                else
                    v48 = p38:Create("Frame")({
                        Name = "Pair",
                        Position = UDim2.fromScale(0, 0.155),
                        Size = UDim2.fromScale(1, 0.42),
                        BackgroundTransparency = 1,
                        TransferPair(p38, {
                            Gains = false,
                            Name = From.Name,
                            Now = `Tier {From.Tier}`,
                            After = To == nil and "?" or `Tier {To.Tier}`
                        }, To ~= nil and {
                            Gains = true,
                            Name = To.Name,
                            Now = `Tier {To.Tier}`,
                            After = `Tier {From.Tier}`
                        } or nil, "Pick a Target")
                    });
                end;

                local v49;

                if #v40 > 0 then
                    v49 = p38:Create("Frame")({
                        Name = "Additional",
                        Position = UDim2.fromScale(0, 0.6),
                        Size = UDim2.fromScale(1, 0.26),
                        BackgroundTransparency = 1,
                        p38:Create("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            Text = "Additional Materials",
                            TextTransparency = 0.25,
                            TextScaled = true,
                            Size = UDim2.fromScale(1, 0.19),
                            Font = Enum.Font.SourceSansSemibold,
                            TextColor3 = Color3.new(1, 1, 1),
                            TextXAlignment = Enum.TextXAlignment.Left
                        }),
                        p38:Create("Frame")({
                            Name = "Strip",
                            AnchorPoint = Vector2.new(0, 1),
                            Position = UDim2.fromScale(0, 1),
                            Size = UDim2.fromScale(1, 0.76),
                            BackgroundTransparency = 1,
                            p38:Create("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                Padding = UDim.new(0, 4)
                            }),
                            p38:Iterate(v40, function(p50, p51, p52) -- Line: 247
                                -- upvalues: MaterialTile (ref), owned (ref)
                                return MaterialTile(p52, p51, owned);
                            end)
                        })
                    });
                else
                    v49 = nil;
                end;

                v47[1], v47[2], v47[3] = v48, v49, Footer(p38, {
    Label = "Cost",
    PriceLines = v42,

    CanPay = function(p53, p54, p55) -- Line: 254, Name: CanPay
        -- upvalues: Shop (ref), Data (ref)
        return Shop.cashiers.Wen.CanBuy(Data, p55);
    end,

    Ready = function() -- Line: 257, Name: Ready
        -- upvalues: u45 (copy)
        return u45 == nil;
    end,

    Text = u45 or "Transfer",

    Clicked = function() -- Line: 262, Name: Clicked
        -- upvalues: u45 (copy), u34 (ref), PopUpCreator (ref), SignalFunction (ref), From (copy), To (copy), ReplicatedStorage (ref), DebrisModule (ref)
        if u45 ~= nil or u34.Busy:Get() then
            return;
        end;

        u34.Busy:Set(true);
        local v56 = PopUpCreator.new({
            Type = "LoadingFull"
        });
        local success, result = pcall(SignalFunction.ToServer, "TierTransfer", {
            From = From.Id,
            To = To.Id
        });
        v56:Destroy();
        u34.Busy:Set(false);

        if success then
            if typeof(result) == "table" then
                success = result.Ok == true;
            else
                success = false;
            end;
        end;

        local v57 = ReplicatedStorage.Assets.Sounds.Misc[success and "Money_Kaching" or "denied_old"]:Clone();
        v57.Parent = script;
        v57:Play();
        DebrisModule:AddItem(v57, v57.TimeLength);

        if success then
            u34.From:Set(To.Id);
        end;
    end
});

                return v46(v47);
            end)
        })
    });
end;

return v11;