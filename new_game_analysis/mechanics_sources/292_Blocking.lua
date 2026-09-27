-- Decompiled with Potassium's decompiler.

local u1 = {
    Id = 0
};
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local u2 = nil;

function u1.Hold(p3) -- Line: 4
    -- upvalues: Character_info_provider (copy), u2 (ref)
    local v4 = p3.Character or p3;

    if v4 == nil then
        return;
    end;

    local Humanoid = v4:FindFirstChild("Humanoid");

    if Humanoid ~= nil then
        local _core_anim = Character_info_provider.get_core_anim(p3, "block");

        if _core_anim == nil then
            _core_anim = script.block;
        end;

        if u2 then
            u2:Stop();
            u2 = nil;
        end;

        u2 = Humanoid.Animator:LoadAnimation(_core_anim);
        u2:Play();
    end;
end;

function u1.UnHold(p5) -- Line: 22
    -- upvalues: u1 (copy)
    u1.Cancel(p5);
end;

function u1.Cancel(p6) -- Line: 25
    -- upvalues: u2 (ref)
    if (p6.Character or p6) == nil then
        return;
    end;

    if u2 then
        u2:Stop();
        u2 = nil;
    end;
end;

return u1;