-- Decompiled with Potassium's decompiler.

local u1 = {
    InCombatTime = 30
};
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local u2 = game:GetService("RunService"):IsStudio();

function u1.RegularIncludeAI(p3, p4) -- Line: 6
    -- upvalues: Utility (copy), u1 (copy)
    if p3 ~= nil then
        local valuesfolder = Utility.getvaluesfolder(p3);

        if valuesfolder ~= nil then
            local DMG = valuesfolder:FindFirstChild("DMG");

            if DMG ~= nil then
                if Utility.Tick() - (DMG:GetAttribute("LastAttacked") or 0) <= u1.InCombatTime - (p4 or 0) then
                    return true;
                end;

                if Utility.Tick() - (DMG:GetAttribute("LastEngaged") or 0) <= u1.InCombatTime - (p4 or 0) then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

function u1.Regular(p5, p6) -- Line: 28
    -- upvalues: Utility (copy), u1 (copy)
    if p5 ~= nil then
        local valuesfolder = Utility.getvaluesfolder(p5);

        if valuesfolder ~= nil then
            local DMG = valuesfolder:FindFirstChild("DMG");

            if DMG ~= nil then
                if Utility.Tick() - (DMG:GetAttribute("LastAttackedByPlayer") or 0) <= u1.InCombatTime - (p6 or 0) then
                    return true;
                end;

                if Utility.Tick() - (DMG:GetAttribute("LastEngagedPlayer") or 0) <= u1.InCombatTime - (p6 or 0) then
                    return true;
                end;
            end;
        end;
    end;

    return false;
end;

function u1.biasedCheck(p7, p8) -- Line: 47
    -- upvalues: u2 (copy), u1 (copy)
    if u2 then
        return u1.RegularIncludeAI(p7, p8);
    end;

    return u1.Regular(p7, p8);
end;

function u1.biasedTimeLeft(p9, p10) -- Line: 55
    -- upvalues: Utility (copy), u2 (copy), u1 (copy)
    if p9 == nil then
        return 0;
    end;

    local valuesfolder = Utility.getvaluesfolder(p9);

    if valuesfolder == nil then
        return 0;
    end;

    local DMG = valuesfolder:FindFirstChild("DMG");

    if DMG == nil then
        return 0;
    end;

    local v11 = u1.InCombatTime - (p10 or 0);
    local v12 = Utility.Tick();
    local v13 = v11 - (v12 - (DMG:GetAttribute(u2 and "LastAttacked" or "LastAttackedByPlayer") or 0));
    local v14 = v11 - (v12 - (DMG:GetAttribute(u2 and "LastEngaged" or "LastEngagedPlayer") or 0));

    return math.max(0, v13, v14);
end;

return u1;