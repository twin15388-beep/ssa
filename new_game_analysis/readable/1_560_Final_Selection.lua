-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UITimedEvent = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.UITimedEvent);
local TimedEvents = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.TimedEvents);
local u1 = nil;
local u2 = 0;

return {
    Start = function(p3: userdata) -- Line: 17, Name: Start
        -- upvalues: u2 (ref), u1 (ref), UITimedEvent (copy), TimedEvents (copy)
        u2 = u2 + 1;

        if u1 ~= nil then
            u1();
            u1 = nil;
        end;

        local BillboardGui = workspace:WaitForChild("Debree"):WaitForChild("Final Selection Assets"):WaitForChild("PersistentModel"):WaitForChild("BillboardHandler"):WaitForChild("BillboardGui");

        if u2 ~= u2 then
            return;
        end;

        u1 = UITimedEvent(BillboardGui, TimedEvents.FinalSelection);
    end,

    End = function(p4: userdata) -- Line: 31, Name: End
        -- upvalues: u2 (ref), u1 (ref)
        u2 = u2 + 1;

        if u1 ~= nil then
            u1();
            u1 = nil;
        end;
    end
};