-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u2 = {
    Normalize = function(p1) -- Line: 27, Name: Normalize
        return type(p1) == "string" and {
            [p1] = 1
        } or (type(p1) ~= "table" and {} or p1);
    end
};

local function held(p3: userdata, p4: string) -- Line: 33
    local v5 = p3.Inventory.Inventory:FindFirstChild(p4);

    if v5 == nil then
        return 0;
    end;

    local Amount = v5:FindFirstChild("Amount");

    return Amount ~= nil and Amount.Value or 1;
end;

function u2.Check(p6: userdata?, p7: any) -- Line: 42
    -- upvalues: u2 (copy), Shop (copy)
    if p6 == nil then
        return false;
    end;

    for i, v in u2.Normalize(p7) do
        local v8 = Shop.cashiers[i];
        local v9;

        if v8 == nil then
            local v10 = p6.Inventory.Inventory:FindFirstChild(i);
            local v11;

            if v10 == nil then
                v11 = 0;
            else
                local Amount = v10:FindFirstChild("Amount");
                v11 = Amount ~= nil and Amount.Value or 1;
            end;

            v9 = v <= v11;
        else
            v9 = v8.CanBuy(p6, v);
        end;

        if not v9 then
            return false, i, v;
        end;
    end;

    return true;
end;

function u2.Charge(p12: userdata, p13: userdata, p14: any, p15: string?) -- Line: 54
    -- upvalues: RunService (copy), u2 (copy), Shop (copy)
    if not RunService:IsServer() then
        return;
    end;

    local Item = require(game:GetService("ServerStorage").SAM.Services.Removers.Item);

    for i, v in u2.Normalize(p14) do
        local v16 = Shop.cashiers[i];

        if v16 == nil then
            Item(p12, i, v, nil, "QuestFee");
        else
            v16.Buy(p13, v, p12, p15);
        end;
    end;
end;

function u2.FormatText(p17) -- Line: 68
    -- upvalues: u2 (copy), Shop (copy), Utility (copy)
    local v18 = {};

    for i, v in u2.Normalize(p17) do
        local v19 = Shop.cashiers[i];
        local v20;

        if v19 == nil then
            v20 = `{Utility.addCommasToNumber(v)} {i}`;
        else
            v20 = v19.FormulateTextPlusText(v);
        end;

        table.insert(v18, v20);
    end;

    return table.concat(v18, ", ");
end;

return u2;