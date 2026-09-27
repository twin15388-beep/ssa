-- Decompiled with Potassium's decompiler.

local u5 = {
    Modes = {
        Arena = {
            PvP = true
        },
        BalancerPvP = {
            PvP = true,
            Hits = true
        }
    },

    SetMode = function(p1: string?, p2: userdata?) -- Line: 24, Name: SetMode
        (p2 or workspace):SetAttribute("CombatMode", p1);
    end,

    Mode = function(p3: userdata?) -- Line: 29, Name: Mode
        local v4;

        if p3 == nil then
            v4 = nil;
        else
            v4 = p3:GetAttribute("CombatMode");
        end;

        if v4 == nil then
            v4 = workspace:GetAttribute("CombatMode");
        end;

        if typeof(v4) == "string" then
            return v4;
        end;

        return nil;
    end
};

function u5.InPvPMode(p6: userdata?) -- Line: 38
    -- upvalues: u5 (copy)
    local v7 = u5.Mode(p6);
    local v8;

    if v7 == nil then
        v8 = nil;
    else
        v8 = u5.Modes[v7];
    end;

    local v9;

    if v8 == nil then
        v9 = false;
    else
        v9 = v8.PvP == true;
    end;

    return v9;
end;

function u5.PvPHits(p10: userdata?) -- Line: 45
    -- upvalues: u5 (copy)
    local v11 = u5.Mode(p10);
    local v12;

    if v11 == nil then
        v12 = nil;
    else
        v12 = u5.Modes[v11];
    end;

    local v13;

    if v12 == nil then
        v13 = false;
    else
        v13 = v12.Hits == true;
    end;

    return v13;
end;

return u5;