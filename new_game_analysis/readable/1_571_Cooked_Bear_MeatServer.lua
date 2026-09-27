-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local Item = require(ServerStorage.SAM.Services.Removers.Item);

return {
    MouseDown = function(u1: userdata, u2: userdata, u3: table, u4: string) -- Line: 17, Name: MouseDown
        -- upvalues: Checker (copy), Utility (copy), ManuelCancel (copy), Item (copy), PlayerStatResolver (copy)
        if not Checker.check(u1) then
            return;
        end;

        if u3.Thread ~= nil then
            return;
        end;

        local Data = Utility.GetData(u1);

        if Data == nil then
            return;
        end;

        if Data.Inventory.Inventory:FindFirstChild(u4) == nil then
            return;
        end;

        local v5, u6 = ManuelCancel.new(u1, 5);
        v5:Connect(function() -- Line: 25
            -- upvalues: u3 (copy)
            if u3.Thread then
                task.cancel(u3.Thread);
                u3.Thread = nil;
            end;
        end);
        u3.Thread = task.spawn(function() -- Line: 32
            -- upvalues: u3 (copy), u2 (copy), Checker (ref), u6 (copy), Item (ref), u1 (copy), u4 (copy), Utility (ref), PlayerStatResolver (ref)
            task.wait(0.27);
            u3.Thread = nil;
            local v7 = u2:FindFirstChildOfClass("Humanoid");

            if Checker.check_victim(script, u2, u2) == nil or (v7 == nil or v7.Health <= 0) then
                u6();

                return;
            end;

            if not Item(u1, u4, nil, nil, "Consumed") then
                u6();

                return;
            end;

            v7.Health = math.clamp(v7.Health + 50, 0, v7.MaxHealth);
            local valuesfolder = Utility.getvaluesfolder(u1);

            if valuesfolder ~= nil then
                PlayerStatResolver.Invalidate(u1, "Health Regen Speed");
                Utility.AddTimedValue(valuesfolder, "Health Regen Speed", 5, "NumberValue", 3);
            end;

            u6();
        end);
    end,

    MouseUp = function(p8: userdata, p9: userdata, p10: table) -- Line: 57, Name: MouseUp
        if p10.Thread then
            task.cancel(p10.Thread);
            p10.Thread = nil;
        end;
    end
};