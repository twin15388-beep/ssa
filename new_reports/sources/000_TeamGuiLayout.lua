-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local u1 = {};
local u2 = {
    Vampires = "VampirePC",
    VampiresMOBILE = "VampireMOBILE",
    VampiresCONSOLE = "VampireCONSOLE",
    Witches = "WitchesPC",
    WitchesMOBILE = "WitchesMOBILE",
    WitchesCONSOLE = "WitchesCONSOLE",
    Human = "HumanPC",
    HumanHunter = "HumanPC",
    HumansCONSOLE = "HumanCONSOLE"
};

function u1.ModeFor(p3, p4, p5, p6, p7) -- Line: 9
    local v8 = tostring(p6);

    return p5 and (v8 == "Keyboard" or v8:match("^Mouse")) and "PC" or (p3 and v8 == "Touch" and "MOBILE" or (p4 and v8:match("^Gamepad") and "CONSOLE" or (p7 and "CONSOLE" or (p3 and "MOBILE" or (p4 and not p5 and "CONSOLE" or "PC")))));
end;

function u1.GetMode() -- Line: 19
    -- upvalues: u1 (copy), UserInputService (copy), GuiService (copy)
    return u1.ModeFor(UserInputService.TouchEnabled, UserInputService.GamepadEnabled, UserInputService.KeyboardEnabled, UserInputService:GetLastInputType().Name, GuiService:IsTenFootInterface());
end;

function u1.FindPanel(p9, p10) -- Line: 23
    -- upvalues: u2 (copy)
    if not p9 then
        return nil;
    end;

    local TEAMS = p9:FindFirstChild("TEAMS");

    return TEAMS and TEAMS:FindFirstChild(u2[p10] or p10) or p9:FindFirstChild(p10);
end;

function u1.GetMenu(p11) -- Line: 28
    if p11 then
        return p11:IsA("GuiObject") and p11 and p11 or p11:FindFirstChild("Menu");
    end;

    return nil;
end;

function u1.IsVisible(p12) -- Line: 32
    if not p12 then
        return false;
    end;

    while p12 do
        if p12:IsA("GuiObject") and not p12.Visible then
            return false;
        end;

        if p12:IsA("ScreenGui") and not p12.Enabled then
            return false;
        end;

        p12 = p12.Parent;
    end;

    return true;
end;

function u1.PanelNames(p13, p14, p15) -- Line: 42
    local v16 = {};

    if p13 == "Vampires" or (p13 == "Cannibal Raised" or p15) then
        v16["Vampire" .. p14] = true;
    end;

    if p13 == "Witches" then
        v16["Witches" .. p14] = true;
    end;

    if p13 == "Humans" or p13 == "VampireHunter" then
        if p15 and p14 == "MOBILE" then
            return v16;
        end;

        if p14 == "CONSOLE" then
            v16.HumanCONSOLE = true;

            return v16;
        end;

        if p14 == "MOBILE" then
            v16.HumansMOBILE = true;

            return v16;
        end;

        v16.HumanPC = true;
    end;

    return v16;
end;

return u1;