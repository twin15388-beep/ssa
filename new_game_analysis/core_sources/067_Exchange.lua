-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local Crafting = require(ReplicatedStorage.CAM.Global.Crafting);
local Series = require(ReplicatedStorage.CAM.Global.Series);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local script_Row = require(script.Row);
local u1 = faye.Info(0.45);
local UDim2_fromScale_ret = UDim2.fromScale(0, 0.04);

return function() -- Line: 17
    -- upvalues: Series (copy), Utility (copy), Players (copy), Crafting (copy), u1 (copy), UDim2_fromScale_ret (copy), Platform_Handler (copy), script_Row (copy)
    return function(p2: any, p3: userdata, p4: userdata, p5: any) -- Line: 18
        -- upvalues: Series (ref), Utility (ref), Players (ref), Crafting (ref), u1 (ref), UDim2_fromScale_ret (ref), Platform_Handler (ref), script_Row (ref)
        local v6 = Series.Materials();
        local u7 = {};
        local Data = Utility.GetData(Players.LocalPlayer);

        if Data ~= nil then
            for _, child in Data.Inventory.Inventory:GetChildren() do
                if table.find(v6, child.Name) ~= nil and Crafting.Spendable(child, child.Name) then
                    local Amount = child:FindFirstChild("Amount");
                    u7[child.Name] = (u7[child.Name] or 0) + (Amount == nil and 1 or Amount.Value);
                end;
            end;
        end;

        local u8 = typeof(p5.Exchange) ~= "table" and {} or p5.Exchange;
        p5.Exchange = u8;

        if u8.Give ~= nil and u7[u8.Give] == nil then
            u8.Give = nil;
        end;

        if u8.Take ~= nil and table.find(v6, u8.Take) == nil then
            u8.Take = nil;
        end;

        local v9;

        if u8.Give == nil then
            v9 = nil;
        else
            v9 = math.clamp(u8.Amount or 1, 1, u7[u8.Give]);
        end;

        u8.Amount = v9;
        local u10 = p2:Value(u8.Give);
        local u11 = p2:Value(u8.Take);
        local u12 = p2:Value(u8.Amount or 1);
        local v17 = {
            Picked = u10,
            Owned = u7,

            Pick = function(p13) -- Line: 44, Name: Pick
                -- upvalues: u8 (copy), u11 (copy), u12 (copy), u7 (copy), u10 (copy)
                if u8.Take == p13 then
                    u8.Take = nil;
                    u11:Set(nil);
                end;

                local v14;

                if u8.Give == p13 then
                    v14 = nil;
                else
                    v14 = p13;
                end;

                u8.Give = v14;
                local v15;

                if u8.Give == nil then
                    v15 = nil;
                else
                    v15 = math.min(u12.Value, u7[p13]);
                end;

                u8.Amount = v15;
                u10:Set(u8.Give);
                u12:Set(u8.Amount or 1);
            end,

            Editor = {
                Amount = u12,

                Step = function(p16) -- Line: 56, Name: Step
                    -- upvalues: u8 (copy), u7 (copy), u12 (copy)
                    if u8.Give == nil then
                        return;
                    end;

                    u8.Amount = math.clamp(u8.Amount + p16, 1, u7[u8.Give]);
                    u12:Set(u8.Amount);
                end
            }
        };
        local v19 = {
            Picked = u11,

            Pick = function(p18) -- Line: 65, Name: Pick
                -- upvalues: u8 (copy), u10 (copy), u11 (copy)
                if u8.Give == p18 then
                    u8.Give = nil;
                    u8.Amount = nil;
                    u10:Set(nil);
                end;

                if u8.Take == p18 then
                    p18 = nil;
                end;

                u8.Take = p18;
                u11:Set(u8.Take);
            end
        };
        local v20 = p2:Create("CanvasGroup");
        local v22 = {
            Parent = p3,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            GroupTransparency = p2:Animation(0, u1, {
                From = 1
            }),
            Position = p2:Animation(UDim2.fromScale(0, 0), u1, {
                From = UDim2_fromScale_ret
            }),

            OnClean = function(p21) -- Line: 81, Name: OnClean
                -- upvalues: u1 (ref), UDim2_fromScale_ret (ref)
                return {
                    GroupTransparency = p21:Animation(1, u1),
                    Position = p21:Animation(UDim2_fromScale_ret, u1)
                };
            end
        };
        local v23 = p2:Create("Frame");
        local v24 = {
            Name = "ExchangeFrame",
            CleanDelay = u1.Time,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.96)
        };
        local v25;

        if Platform_Handler.Platform.Value == "Mobile" then
            v25 = UDim2.fromScale(0.5, 0.31);
        else
            v25 = UDim2.fromScale(0.6, 0.5);
        end;

        v24.Size = v25;
        v24[1], v24[2] = p2:Create("UIAspectRatioConstraint")({
    AspectRatio = 2.5
}), p2:Create("UICorner")({
    CornerRadius = UDim.new(0.025)
});
        v24.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05);
        v24[3], v24[4] = p2:Create("UIGradient")({
    Rotation = 90,
    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.4) })
}), p2:Create("Frame")({
    Name = "Holder",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.96, 0.92),
    BackgroundTransparency = 1,
    p2:Create("UIListLayout")({
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0.04)
    }),
    script_Row(p2, 1, "Give", v6, v17),
    script_Row(p2, 2, "Receive", v6, v19)
});
        v22[1] = v23(v24);

        return v20(v22);
    end;
end;