-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local u2 = { "Idle", "Walk", "Gallop", "Sprint", "Fall" };

function u1.new(p3) -- Line: 21
    -- upvalues: u1 (copy), u2 (copy)
    local v4 = setmetatable({
        moving = false,
        moveAnim = "Walk",
        airborne = false,
        action = nil,
        rigs = {}
    }, u1);

    for _, v in p3 do
        if v.animator and v.folder then
            local v5 = v;
            local v6 = {};

            for _, v2 in u2 do
                local v7 = v5.folder:FindFirstChild(v2);

                if v7 and v7:IsA("Animation") then
                    local v8 = v5.animator:LoadAnimation(v7);
                    v8.Looped = true;
                    local v9;

                    if v2 == "Idle" then
                        v9 = Enum.AnimationPriority.Idle;
                    else
                        v9 = Enum.AnimationPriority.Action;
                    end;

                    v8.Priority = v9;
                    v6[v2] = v8;
                end;
            end;

            if v6.Idle then
                v6.Idle:Play();
            end;

            table.insert(v4.rigs, {
                tracks = v6
            });
        end;
    end;

    return v4;
end;

function u1._setAction(p10, p11) -- Line: 50
    if p11 == p10.action then
        return;
    end;

    local action = p10.action;
    p10.action = p11;

    for _, v in p10.rigs do
        if action and v.tracks[action] then
            v.tracks[action]:Stop(0.15);
        end;

        if p11 and v.tracks[p11] then
            v.tracks[p11]:Play(0.15);
        end;
    end;
end;

function u1._refresh(p12) -- Line: 61
    if p12.airborne then
        p12:_setAction("Fall");

        return;
    end;

    if p12.moving then
        p12:_setAction(p12.moveAnim);

        return;
    end;

    p12:_setAction(nil);
end;

function u1.Update(p13, p14, p15) -- Line: 72
    p13.moving = p14;
    p13.moveAnim = p15 or p13.moveAnim;
    p13:_refresh();
end;

function u1.SetFalling(p16, p17) -- Line: 79
    p16.airborne = p17;
    p16:_refresh();
end;

function u1.Destroy(p18) -- Line: 84
    for _, v in p18.rigs do
        for _, v2 in v.tracks do
            v2:Stop(0.15);
        end;
    end;

    p18.rigs = {};
end;

return u1;