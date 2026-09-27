-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

local function listingNames() -- Line: 28
    -- upvalues: Shop (copy), Menum (copy)
    local v1 = {};

    for i, v in Shop.itemsforsale do
        if v ~= nil and v.Type ~= Menum.ShopItemType.Gamepass then
            table.insert(v1, i);
        end;
    end;

    table.sort(v1);

    return v1;
end;

return {
    Clearance = 7,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Listing",
            Name = "Listing",
            Required = true,

            Suggester = function() -- Line: 50, Name: Suggester
                -- upvalues: listingNames (copy)
                return listingNames();
            end,

            Completer = function(p2: string) -- Line: 55, Name: Completer
                -- upvalues: listingNames (copy)
                if p2 == nil or p2 == "" then
                    return nil;
                end;

                local v3 = p2:lower();

                for _, v in listingNames() do
                    if v:lower() == v3 then
                        return v;
                    end;
                end;

                return nil;
            end
        }
    },

    Server = function(p4: userdata, p5: table, p6: string) -- Line: 65, Name: Server
        -- upvalues: Shop (copy), Menum (copy), Utility (copy)
        if #p5 == 0 then
            error("Grant: no players targeted (use `me`)");
        end;

        local v7 = Shop.itemsforsale[p6];

        if v7 == nil then
            error((`Grant: no shop listing named "{p6}"`));
        end;

        if v7.Type == Menum.ShopItemType.Gamepass then
            error((`Grant: "{p6}" is a gamepass -- owning it on Roblox IS the grant, so it cannot be handed out here`));
        end;

        local v8 = Shop.OrderProcessers[v7.Type];

        if v8 == nil then
            error((`Grant: "{p6}" has no order processor for type "{tostring(v7.Type)}"`));
        end;

        local v9 = {};
        local v10 = {};

        for _, v in p5 do
            local Data = Utility.GetData(v);

            if Data == nil then
                local v11 = `{v.Name} (data not loaded)`;
                table.insert(v10, v11);
            else
                local v12, v13, v13 = pcall(v8, v, Data, p6, 1, v7);

                if v12 and v13 then
                    table.insert(v9, v.Name);
                else
                    local v14 = `{v.Name} ({tostring(v13)})`;
                    table.insert(v10, v14);
                end;
            end;
        end;

        if #v9 == 0 then
            error((`Grant: nothing granted -- {table.concat(v10, ", ")}`));
        end;

        warn((`[Grant] {p4.Name} granted "{p6}" to {table.concat(v9, ", ")}`));

        return {
            Content = `Granted "{p6}" to {table.concat(v9, ", ")}` .. (#v10 <= 0 and "" or ` (failed: {table.concat(v10, ", ")})`),
            BgColor = Color3.fromRGB(32, 143, 70),
            FgColor = Color3.new(1, 1, 1)
        };
    end
};