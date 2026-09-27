-- Decompiled with Potassium's decompiler.

local u1 = {
    DayDuration = 360,
    NightDuration = 480,
    StartClockTime = 18,
    DayStartsAt = 6,
    NightStartsAt = 18,
    SunHealthPercentPerSecond = 0.2,
    DamageInterval = 0.5,
    SunRayDistance = 1500,
    DaysPerPhase = 1,
    MoonPhases = {
        {
            Name = "Lua Nova",
            Texture = "rbxassetid://1345054856",
            NightBrightness = -0.5,
            AmbientTint = Color3.fromRGB(0, 0, 0)
        },
        {
            Name = "Crescente",
            Texture = "rbxassetid://1345054856",
            NightBrightness = -0.2,
            AmbientTint = Color3.fromRGB(20, 20, 30)
        },
        {
            Name = "Quarto Crescente",
            Texture = "rbxassetid://1345054856",
            NightBrightness = 0,
            AmbientTint = Color3.fromRGB(40, 40, 50)
        },
        {
            Name = "Gibosa Crescente",
            Texture = "rbxassetid://1345054856",
            NightBrightness = 0.2,
            AmbientTint = Color3.fromRGB(50, 50, 60)
        },
        {
            Name = "Lua Cheia",
            Texture = "rbxassetid://1345054856",
            NightBrightness = 0.5,
            AmbientTint = Color3.fromRGB(60, 60, 80)
        },
        {
            Name = "Gibosa Minguante",
            Texture = "rbxassetid://1345054856",
            NightBrightness = 0.2,
            AmbientTint = Color3.fromRGB(50, 50, 60)
        },
        {
            Name = "Quarto Minguante",
            Texture = "rbxassetid://1345054856",
            NightBrightness = 0,
            AmbientTint = Color3.fromRGB(40, 40, 50)
        },
        {
            Name = "Minguante",
            Texture = "rbxassetid://1345054856",
            NightBrightness = -0.2,
            AmbientTint = Color3.fromRGB(20, 20, 30)
        }
    }
};

function u1.IsDay(p2) -- Line: 34
    -- upvalues: u1 (copy)
    if u1.DayStartsAt >= u1.NightStartsAt then
        return u1.DayStartsAt <= p2 and true or p2 < u1.NightStartsAt;
    end;

    local v3;

    if u1.DayStartsAt <= p2 then
        v3 = p2 < u1.NightStartsAt;
    else
        v3 = false;
    end;

    return v3;
end;

return u1;