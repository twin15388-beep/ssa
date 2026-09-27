-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};
local u2 = {};
local Effects = game.ReplicatedStorage:WaitForChild("Effects");
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);

function do_tang(p3, ...)
    -- upvalues: u1 (copy), u2 (copy), Effects (copy)
    if p3 == nil then
        return;
    end;

    if typeof(p3) ~= "string" then
        return;
    end;

    local v4 = script:FindFirstChild(p3);

    if v4 ~= nil and v4:FindFirstChild("Perform") ~= nil then
        v4.Perform:Fire(...);
    end;

    if v4 == nil then
        if u1[p3] == nil then
            local v5 = u2[p3];

            if v5 ~= nil and os.clock() - v5 < 10 then
                return;
            end;

            local v6 = Effects:FindFirstChild(p3, true);

            if v6 == nil then
                u2[p3] = os.clock();
            else
                u1[p3] = require(v6);
            end;
        end;

        if u1[p3] ~= nil then
            return u1[p3](...);
        end;
    end;
end;

EffectsEvent:Connect(do_tang);
game.ReplicatedStorage:WaitForChild("Communication"):WaitForChild("CnC"):WaitForChild("ClientEffects").Event:Connect(do_tang);