-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local Item = require(ServerStorage.SAM.Services.Removers.Item);
local v1 = {};

local function giveReward(p2: userdata, p3: userdata) -- Line: 26
    if p3.Health <= p3.MaxHealth then
        p3.Health = math.clamp(p3.Health + 50, 0, p3.MaxHealth);
    end;
end;

function v1.MouseDown(u4: userdata, u5: userdata, u6: table, u7: string) -- Line: 35
    -- upvalues: Checker (copy), Utility (copy), ManuelCancel (copy), Item (copy)
    if not Checker.check(u4) then
        return;
    end;

    if u6.Thread ~= nil then
        return;
    end;

    local Data = Utility.GetData(u4);

    if Data == nil then
        return;
    end;

    if Data.Inventory.Inventory:FindFirstChild(u7) == nil then
        return;
    end;

    local v8, u9 = ManuelCancel.new(u4, 3.416666666666667);
    v8:Connect(function() -- Line: 45
        -- upvalues: u6 (copy)
        if u6.Thread then
            task.cancel(u6.Thread);
            u6.Thread = nil;
        end;
    end);
    u6.WrapStarted = os.clock();
    u6.Thread = task.spawn(function() -- Line: 53
        -- upvalues: Checker (ref), u5 (copy), u9 (copy), u6 (copy), Item (ref), u4 (copy), u7 (copy)
        task.wait(0.7083333333333334);

        if Checker.check_victim(script, u5, u5) == nil then
            u9();
            u6.Thread = nil;

            return;
        end;

        task.wait(0.7083333333333334);

        if not Item(u4, u7) then
            u9();
            u6.Thread = nil;

            return;
        end;

        local v10 = u5:FindFirstChildOfClass("Humanoid");

        if v10 ~= nil and (v10.Health > 0 and v10.Health <= v10.MaxHealth) then
            v10.Health = math.clamp(v10.Health + 50, 0, v10.MaxHealth);
        end;

        u9();
        u6.Thread = nil;
    end);
end;

function v1.MouseUp(p11: userdata, p12: userdata, p13: table) -- Line: 80
    if p13.Thread == nil then
        return;
    end;

    local WrapStarted = p13.WrapStarted;

    if WrapStarted ~= nil and os.clock() - WrapStarted >= 1.2666666666666668 then
        return;
    end;

    task.cancel(p13.Thread);
    p13.Thread = nil;
end;

return v1;