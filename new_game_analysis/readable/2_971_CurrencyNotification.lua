-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = nil;
local u2 = nil;

return function(p3) -- Line: 16
    -- upvalues: u1 (ref), u2 (ref), ReplicatedStorage (copy)
    if typeof(p3) ~= "table" or typeof(p3.Content) ~= "table" then
        return;
    end;

    if u1 ~= nil then
        for _, v in ipairs(p3.Content) do
            table.insert(u1, v);
        end;

        if typeof(p3.Time) == "number" then
            u2 = math.max(u2 or 0, p3.Time);
        end;

        return;
    end;

    u1 = table.clone(p3.Content);
    local v4;

    if typeof(p3.Time) == "number" then
        v4 = p3.Time;
    else
        v4 = nil;
    end;

    u2 = v4;
    task.delay(0.15, function() -- Line: 30
        -- upvalues: u1 (ref), u2 (ref), ReplicatedStorage (ref)
        local v5 = u1;
        local v6 = u2;
        u1 = nil;
        u2 = nil;
        ReplicatedStorage.Communication.CnC.Notifications.Notification:Fire("Currency", {
            Time = v6,
            Content = v5
        });
    end);
end;