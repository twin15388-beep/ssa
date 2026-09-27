-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = {
    Toolbar_1st = { Enum.KeyCode.One },
    Toolbar_2nd = { Enum.KeyCode.Two },
    Toolbar_3rd = { Enum.KeyCode.Three },
    Toolbar_4th = { Enum.KeyCode.Four },
    Toolbar_5th = { Enum.KeyCode.Five },
    Skills_1st = { Enum.KeyCode.F, Enum.KeyCode.ButtonX },
    Skills_2nd = { Enum.KeyCode.Z, Enum.KeyCode.ButtonY },
    Skills_3rd = { Enum.KeyCode.X, Enum.KeyCode.ButtonB },
    Skills_4th = {
        Enum.KeyCode.C,
        {
            Input = Enum.KeyCode.ButtonX,
            Modifier = Enum.KeyCode.ButtonL1
        }
    },
    Skills_5th = {
        Enum.KeyCode.V,
        {
            Input = Enum.KeyCode.ButtonY,
            Modifier = Enum.KeyCode.ButtonL1
        }
    },
    Skills_6th = {
        Enum.KeyCode.B,
        {
            Input = Enum.KeyCode.ButtonB,
            Modifier = Enum.KeyCode.ButtonL1
        }
    },
    Skills_7th = { Enum.KeyCode.N, Enum.KeyCode.DPadRight },
    Skills_8th = { Enum.KeyCode.K, Enum.KeyCode.DPadDown },
    Skills_9th = { Enum.KeyCode.L, Enum.KeyCode.DPadLeft },
    Skills_10th = {
        Enum.KeyCode.J,
        {
            Input = Enum.KeyCode.DPadUp,
            Modifier = Enum.KeyCode.ButtonL1
        }
    },
    Menu = { Enum.KeyCode.M, Enum.KeyCode.DPadUp },
    Menu_Close = { Enum.KeyCode.ButtonB },
    Dash = { Enum.KeyCode.ButtonL3 },
    Screen = { Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.KeyCode.ButtonR2 },
    Combat = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 },
    Slot_Drag = { Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.KeyCode.ButtonA },
    Jump = { Enum.KeyCode.Space, Enum.KeyCode.ButtonA },
    Run = { Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonL2 },
    Shiftlock = { Enum.KeyCode.LeftAlt },
    Toolbar_Prev = {
        {
            Window = 0.08,
            Input = Enum.KeyCode.ButtonR1,
            Modifier = Enum.KeyCode.ButtonL1
        }
    },
    Toolbar_Next = { Enum.KeyCode.ButtonR1 },
    Map = { Enum.KeyCode.DPadDown },
    Map_Close = { Enum.KeyCode.ButtonB },
    Zoom_In = { Enum.KeyCode.ButtonL2 },
    Zoom_Out = { Enum.KeyCode.ButtonR2 },
    Tab_Next = { Enum.KeyCode.ButtonR1 },
    Tab_Prev = {
        {
            Alone = true,
            Input = Enum.KeyCode.ButtonL1
        }
    },
    Category_Next = { Enum.KeyCode.ButtonR2 },
    Category_Prev = { Enum.KeyCode.ButtonL2 },
    Spectate_Prev = { Enum.KeyCode.Q, Enum.KeyCode.DPadLeft },
    Spectate_Next = { Enum.KeyCode.E, Enum.KeyCode.DPadRight },
    Emotes = { Enum.KeyCode.E, Enum.KeyCode.DPadLeft },
    Emotes_Prev = {
        Enum.KeyCode.Q,
        {
            Alone = true,
            Input = Enum.KeyCode.ButtonL1
        }
    },
    Emotes_Next = { Enum.KeyCode.R, Enum.KeyCode.ButtonR1 }
};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};

local function getSignal(p9: string) -- Line: 193
    -- upvalues: u3 (copy), simplesignal (copy)
    local v10 = u3[p9];

    if v10 == nil then
        v10 = simplesignal.new();
        u3[p9] = v10;
    end;

    return v10;
end;

local function rebuildLookup() -- Line: 202
    -- upvalues: u5 (copy), u2 (copy)
    table.clear(u5);

    for i, v in u2 do
        local v11 = i;

        for _, v2 in v do
            local v12, v13;

            if typeof(v2) == "table" then
                v12 = v2.Input;
                v13 = v2.Modifier;
            else
                v12 = v2;
                v13 = nil;
            end;

            local v14 = u5[v12];

            if v14 == nil then
                v14 = {};
                u5[v12] = v14;
            end;

            local v15 = {
                Keybind = v11,
                Modifier = v13
            };
            local v16;

            if typeof(v2) == "table" then
                v16 = v2.Window;
            else
                v16 = nil;
            end;

            v15.Window = v16;
            local v17;

            if typeof(v2) == "table" then
                v17 = v2.Alone;
            else
                v17 = nil;
            end;

            v15.Alone = v17;
            table.insert(v14, v15);
        end;
    end;
end;

local function dispatch(p18: string, p19: string, p20: boolean, ...) -- Line: 220
    -- upvalues: u3 (copy)
    local v21 = u3[p18];

    if v21 == nil then
        return;
    end;

    v21:Fire(p19, p20, ...);
end;

local function identity(p22: userdata) -- Line: 228
    if p22.KeyCode == Enum.KeyCode.Unknown then
        return p22.UserInputType;
    end;

    return p22.KeyCode;
end;

local u23 = { "DynamicThumbstickFrame", "ClassicThumbstickFrame", "ThumbstickFrame" };
local u24 = nil;
local u25 = setmetatable({}, {
    __mode = "k"
});
local u26 = 0;
u1.Moving = simplesignal.new();

function u1.IsMoving() -- Line: 270
    -- upvalues: u26 (ref)
    return u26 > 0;
end;

local function findMoveFrame() -- Line: 274
    -- upvalues: u24 (ref), LocalPlayer (copy), u23 (copy)
    if u24 ~= nil and (u24.Parent ~= nil and u24.Visible) then
        return u24;
    end;

    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");
    local v27;

    if PlayerGui == nil then
        v27 = nil;
    else
        v27 = PlayerGui:FindFirstChild("TouchGui");
    end;

    local v28;

    if v27 == nil then
        v28 = nil;
    else
        v28 = v27:FindFirstChild("TouchControlFrame");
    end;

    u24 = nil;

    if v28 ~= nil then
        for _, v in u23 do
            local v29 = v28:FindFirstChild(v);

            if v29 ~= nil and v29.Visible then
                u24 = v29;
                break;
            end;
        end;
    end;

    return u24;
end;

local function isMovementTouch(p30: userdata) -- Line: 303
    -- upvalues: findMoveFrame (copy)
    if p30.UserInputType ~= Enum.UserInputType.Touch then
        return false;
    end;

    local v31 = findMoveFrame();

    if v31 == nil or not v31.Visible then
        return false;
    end;

    local AbsolutePosition = v31.AbsolutePosition;
    local v32 = AbsolutePosition + v31.AbsoluteSize;
    local Position = p30.Position;
    local v33;

    if Position.X >= AbsolutePosition.X and (Position.Y >= AbsolutePosition.Y and Position.X <= v32.X) then
        v33 = Position.Y <= v32.Y;
    else
        v33 = false;
    end;

    return v33;
end;

local u34 = {
    Screen = true
};

local function touchPosition(p35: userdata) -- Line: 335
    return Vector2.new(p35.Position.X, p35.Position.Y);
end;

local function tapGated(p36: string, p37: userdata, p38: boolean) -- Line: 338
    -- upvalues: u34 (copy)
    local v39;

    if u34[p36] == true and p37.UserInputType == Enum.UserInputType.Touch then
        v39 = not p38;
    else
        v39 = false;
    end;

    return v39;
end;

local function ownsHold(p40: table, p41: userdata) -- Line: 348
    return (p40.Object == nil or p40.Object.UserInputType ~= Enum.UserInputType.Touch) and true or p40.Object == p41;
end;

local function release(p42: string, ...) -- Line: 355
    -- upvalues: u4 (copy), dispatch (copy)
    local v43 = u4[p42];

    if v43 == nil then
        return;
    end;

    u4[p42] = nil;
    dispatch(p42, "Up", v43.Processed, ...);
end;

function u1.MouseActive() -- Line: 372
    -- upvalues: UserInputService (copy)
    local Name = UserInputService:GetLastInputType().Name;

    return (Name:match("^Mouse") ~= nil or Name == "Keyboard") and true or Name == "TextInput";
end;

function u1.IsDown(p44: string) -- Line: 378
    -- upvalues: u4 (copy)
    local v45 = u4[p44];
    local v46;

    if v45 == nil then
        v46 = false;
    else
        v46 = v45.Processed ~= true;
    end;

    return v46;
end;

function u1.HeldInput(p47: string) -- Line: 383
    -- upvalues: u4 (copy)
    local v48 = u4[p47];

    if v48 then
        v48 = v48.Input;
    end;

    return v48;
end;

function u1.HeldObject(p49: string) -- Line: 389
    -- upvalues: u4 (copy)
    local v50 = u4[p49];

    if v50 == nil then
        return nil;
    end;

    return v50.Object;
end;

function u1.VirtualPress(p51: string, p52: userdata?) -- Line: 407
    -- upvalues: u4 (copy), dispatch (copy)
    if u4[p51] ~= nil then
        return;
    end;

    u4[p51] = {
        Processed = false,
        Input = p52 or Enum.UserInputType.Touch
    };
    dispatch(p51, "Down", false);
end;

function u1.VirtualRelease(p53: string) -- Line: 414
    -- upvalues: u4 (copy), release (copy)
    local v54 = u4[p53];

    if v54 == nil or v54.Object ~= nil then
        return;
    end;

    release(p53);
end;

function u1.ListenTo(p55: string, p56: function) -- Line: 419
    -- upvalues: u3 (copy), simplesignal (copy)
    local v57 = u3[p55];

    if v57 == nil then
        v57 = simplesignal.new();
        u3[p55] = v57;
    end;

    return v57:Connect(p56);
end;

function u1.ScreenClicked(p58: function) -- Line: 422
    -- upvalues: u1 (copy)
    return u1.ListenTo("Screen", p58);
end;

u1.Pinch = simplesignal.new();

function u1.Pinched(p59: function) -- Line: 445
    -- upvalues: u1 (copy)
    return u1.Pinch:Connect(p59);
end;

local u60 = {};
local u61 = setmetatable({}, {
    __mode = "k"
});
local u62 = nil;

local function pinchEnd() -- Line: 453
    -- upvalues: u62 (ref), u1 (copy), u60 (copy)
    if u62 == nil then
        return;
    end;

    u62 = nil;
    u1.Pinch:Fire("Ended", 1, Vector2.zero, #u60);
end;

local function pinchUpdate() -- Line: 459
    -- upvalues: u60 (copy), u62 (ref), u1 (copy), u61 (copy)
    local v63 = u60[1];
    local v64 = u60[2];

    if v63 == nil or v64 == nil then
        if u62 == nil then
            return;
        end;

        u62 = nil;
        u1.Pinch:Fire("Ended", 1, Vector2.zero, #u60);

        return;
    end;

    local v65 = u61[v63];
    local v66 = u61[v64];

    if v65 == nil or v66 == nil then
        return;
    end;

    local Magnitude = (v65 - v66).Magnitude;
    local v67 = (v65 + v66) / 2;

    if u62 == nil then
        u62 = Magnitude;
        u1.Pinch:Fire("Began", 1, v67);

        return;
    end;

    if u62 <= 0 then
        u62 = Magnitude;

        return;
    end;

    local v68 = Magnitude / u62;
    u62 = Magnitude;
    u1.Pinch:Fire("Changed", v68, v67);
end;

UserInputService.TouchStarted:Connect(function(p69: userdata) -- Line: 483
    -- upvalues: u61 (copy), u60 (copy), pinchUpdate (copy)
    if u61[p69] ~= nil then
        return;
    end;

    u61[p69] = Vector2.new(p69.Position.X, p69.Position.Y);
    table.insert(u60, p69);
    pinchUpdate();
end);
UserInputService.TouchMoved:Connect(function(p70: userdata) -- Line: 489
    -- upvalues: u61 (copy), pinchUpdate (copy)
    if u61[p70] == nil then
        return;
    end;

    u61[p70] = Vector2.new(p70.Position.X, p70.Position.Y);
    pinchUpdate();
end);
UserInputService.TouchEnded:Connect(function(p71: userdata) -- Line: 494
    -- upvalues: u61 (copy), u60 (copy), u62 (ref), u1 (copy)
    if u61[p71] == nil then
        return;
    end;

    u61[p71] = nil;
    local table_find_ret = table.find(u60, p71);

    if table_find_ret ~= nil then
        table.remove(u60, table_find_ret);
    end;

    if u62 == nil then
        return;
    end;

    u62 = nil;
    u1.Pinch:Fire("Ended", 1, Vector2.zero, #u60);
end);
u1.Rebound = simplesignal.new();

function u1.Rebind(p72: string, p73: table) -- Line: 511
    -- upvalues: release (copy), u2 (copy), rebuildLookup (copy), u1 (copy)
    release(p72);
    u2[p72] = p73;
    rebuildLookup();
    u1.Rebound:Fire(p72);
end;

function u1.PrettyInput(p74: string) -- Line: 519
    return string.gsub(p74, "(%l)(%u)", "%1 %2");
end;

function u1.KeyLabel(p75: string) -- Line: 525
    -- upvalues: u2 (copy), u1 (copy)
    local v76 = u2[p75];

    if v76 == nil then
        return nil;
    end;

    for _, v in v76 do
        if typeof(v) ~= "table" and v.EnumType == Enum.KeyCode then
            local Name = v.Name;

            if not (string.match(Name, "^Button") or (string.match(Name, "^DPad") or string.match(Name, "^Thumbstick"))) then
                return u1.PrettyInput(Name);
            end;
        end;
    end;

    return nil;
end;

function u1.GetMapping(p77: string) -- Line: 541
    -- upvalues: u2 (copy)
    return u2[p77];
end;

local function isPadInput(p78) -- Line: 555
    if typeof(p78) ~= "EnumItem" or p78.EnumType ~= Enum.KeyCode then
        return false;
    end;

    local Name = p78.Name;

    return (string.match(Name, "^Button") ~= nil or string.match(Name, "^DPad") ~= nil) and true or string.match(Name, "^Thumbstick") ~= nil;
end;

local u79 = {};

for i, v in u2 do
    local v80 = i;

    for _, v2 in v do
        if typeof(v2) ~= "table" and not isPadInput(v2) then
            u79[v80] = v2;
            break;
        end;
    end;
end;

function u1.DefaultKey(p81: string) -- Line: 574
    -- upvalues: u79 (copy)
    return u79[p81];
end;

function u1.BoundKey(p82: string) -- Line: 579
    -- upvalues: u1 (copy)
    return u1.KeyBinding(p82);
end;

function u1.KeyBinding(p83: string) -- Line: 585
    -- upvalues: u2 (copy), isPadInput (copy)
    local v84 = u2[p83];

    if v84 == nil then
        return nil, nil;
    end;

    local v85 = nil;

    for _, v in v84 do
        if typeof(v) == "table" then
            if v.Modifier ~= nil and not isPadInput(v.Input) then
                return v.Input, v.Modifier;
            end;
        elseif not isPadInput(v) and v85 == nil then
            v85 = v;
        end;
    end;

    return v85, nil;
end;

function u1.RebindKey(p86: string, p87: userdata?, p88: userdata?) -- Line: 604
    -- upvalues: u2 (copy), isPadInput (copy), u1 (copy)
    local v89 = u2[p86];

    if v89 == nil then
        return;
    end;

    local v90 = {};

    if p87 ~= nil then
        if p88 == nil then
            table.insert(v90, p87);
        else
            table.insert(v90, {
                Input = p87,
                Modifier = p88
            });
        end;
    end;

    for _, v in v89 do
        if typeof(v) == "table" then
            if isPadInput(v.Input) then
                table.insert(v90, v);
            end;
        elseif isPadInput(v) then
            table.insert(v90, v);
        end;
    end;

    u1.Rebind(p86, v90);
end;

function u1.PadBinding(p91: string) -- Line: 636
    -- upvalues: u2 (copy), isPadInput (copy)
    local v92 = u2[p91];

    if v92 == nil then
        return nil, nil;
    end;

    local v93 = nil;

    for _, v in v92 do
        if typeof(v) == "table" then
            if v.Modifier ~= nil then
                return v.Input, v.Modifier;
            end;

            if v93 == nil and isPadInput(v.Input) then
                v93 = v.Input;
            end;
        elseif isPadInput(v) and v93 == nil then
            v93 = v;
        end;
    end;

    return v93, nil;
end;

local u94 = {};

for i in u2 do
    local v95, v96 = u1.PadBinding(i);

    if v95 ~= nil then
        u94[i] = {
            Input = v95,
            Modifier = v96
        };
    end;
end;

function u1.PadDefault(p97: string) -- Line: 666
    -- upvalues: u94 (copy)
    local v98 = u94[p97];

    if v98 == nil then
        return nil, nil;
    end;

    return v98.Input, v98.Modifier;
end;

function u1.RebindPad(p99: string, p100: userdata?, p101: userdata?) -- Line: 672
    -- upvalues: u2 (copy), isPadInput (copy), u1 (copy)
    local v102 = u2[p99];

    if v102 == nil then
        return;
    end;

    local v103 = {};

    for _, v in v102 do
        if typeof(v) ~= "table" and not isPadInput(v) then
            table.insert(v103, v);
        end;
    end;

    if p100 ~= nil then
        if p101 == nil then
            table.insert(v103, p100);
        else
            table.insert(v103, {
                Input = p100,
                Modifier = p101
            });
        end;
    end;

    u1.Rebind(p99, v103);
end;

function u1.KeybindOnPad(p104: userdata, p105: userdata?) -- Line: 693
    -- upvalues: u2 (copy), u1 (copy)
    for i in u2 do
        local v106, v107 = u1.PadBinding(i);

        if v106 == p104 and v107 == p105 then
            return i;
        end;
    end;

    return nil;
end;

function u1.KeybindOn(p108: userdata, p109: userdata?) -- Line: 707
    -- upvalues: u2 (copy), u1 (copy)
    for i in u2 do
        local v110, v111 = u1.KeyBinding(i);

        if v110 == p108 and v111 == p109 then
            return i;
        end;
    end;

    return nil;
end;

local u112 = nil;
local u113 = nil;
local u114 = {};
local u115 = {};

function u1.Capture(u116: function, p117: function?) -- Line: 766
    -- upvalues: u113 (ref), u112 (ref), u114 (copy)
    local v118 = u113;
    u112 = u116;
    u113 = p117;
    table.clear(u114);

    if v118 ~= nil then
        v118();
    end;

    return function() -- Line: 774
        -- upvalues: u112 (ref), u116 (copy), u113 (ref), u114 (ref)
        if u112 == u116 then
            u112 = nil;
            u113 = nil;
            table.clear(u114);
        end;
    end;
end;

function u1.IsCapturing() -- Line: 782
    -- upvalues: u112 (ref)
    return u112 ~= nil;
end;

rebuildLookup();
local u119 = nil;
local u120 = nil;
local u121 = {};
local u122 = {};
local u123 = nil;

function u1.CapturePad(u124: function, p125: function?, p126: table?) -- Line: 838
    -- upvalues: u120 (ref), u119 (ref), u123 (ref), u121 (copy)
    local v127 = u120;
    u119 = u124;
    u120 = p125;
    u123 = p126;
    table.clear(u121);

    if v127 ~= nil then
        v127();
    end;

    return function() -- Line: 847
        -- upvalues: u119 (ref), u124 (copy), u120 (ref), u123 (ref), u121 (ref)
        if u119 == u124 then
            u119 = nil;
            u120 = nil;
            u123 = nil;
            table.clear(u121);
        end;
    end;
end;

function u1.IsCapturingPad() -- Line: 856
    -- upvalues: u119 (ref)
    return u119 ~= nil;
end;

function u1.IsRecording() -- Line: 862
    -- upvalues: u112 (ref), u119 (ref)
    return u112 ~= nil and true or u119 ~= nil;
end;

local u128 = { "Skills_", "Toolbar_" };
local u129 = 0;

local function blocked(p130: string) -- Line: 882
    -- upvalues: u129 (ref), u128 (copy)
    if u129 <= 0 then
        return false;
    end;

    for _, v in u128 do
        if string.sub(p130, 1, #v) == v then
            return true;
        end;
    end;

    return false;
end;

function u1.IsBlocked() -- Line: 891
    -- upvalues: u129 (ref)
    return u129 > 0;
end;

function u1.Block() -- Line: 894
    -- upvalues: u129 (ref)
    u129 = u129 + 1;
    local u131 = false;

    return function() -- Line: 897
        -- upvalues: u131 (ref), u129 (ref)
        if u131 then
            return;
        end;

        u131 = true;
        u129 = math.max(0, u129 - 1);
    end;
end;

local function firePress(p132: userdata, p133: userdata, p134: boolean, p135: boolean) -- Line: 905
    -- upvalues: u5 (copy), u7 (copy), u129 (ref), u128 (copy), u34 (copy), u4 (copy), u8 (copy), dispatch (copy)
    local v136 = u5[p132];

    if v136 == nil then
        return;
    end;

    for _, v in v136 do
        if not v.Alone then
            local v137;

            if p135 then
                if v.Modifier == nil then
                    v137 = false;
                else
                    v137 = u7[v.Modifier] == true;
                end;
            else
                v137 = v.Modifier == nil;
            end;

            local Keybind = v.Keybind;
            local v138, v139;

            if v137 then
                local v140;

                if u129 <= 0 then
                    v138 = v;
                    v140 = false;
                else
                    v138 = v;
                    v140 = false;

                    for _, v2 in u128 do
                        if string.sub(Keybind, 1, #v2) == v2 then
                            v140 = true;
                            break;
                        end;
                    end;
                end;

                if not v140 then
                    if v137 then
                        if u34[Keybind] == true and p133.UserInputType == Enum.UserInputType.Touch then
                            v139 = not p134;
                        else
                            v139 = false;
                        end;

                        if not v139 then
                            if v137 and u4[Keybind] == nil then
                                if p135 then
                                    u8[v138.Modifier] = true;
                                end;

                                u4[Keybind] = {
                                    Input = p132,
                                    Processed = p134,
                                    Object = p133
                                };
                                dispatch(Keybind, "Down", p134, p133);
                            end;
                        end;
                    elseif v137 and u4[Keybind] == nil then
                        if p135 then
                            u8[v138.Modifier] = true;
                        end;

                        u4[Keybind] = {
                            Input = p132,
                            Processed = p134,
                            Object = p133
                        };
                        dispatch(Keybind, "Down", p134, p133);
                    end;
                end;
            else
                v138 = v;

                if v137 then
                    if u34[Keybind] == true and p133.UserInputType == Enum.UserInputType.Touch then
                        v139 = not p134;
                    else
                        v139 = false;
                    end;

                    if not v139 then
                        if v137 and u4[Keybind] == nil then
                            if p135 then
                                u8[v138.Modifier] = true;
                            end;

                            u4[Keybind] = {
                                Input = p132,
                                Processed = p134,
                                Object = p133
                            };
                            dispatch(Keybind, "Down", p134, p133);
                        end;
                    end;
                elseif v137 and u4[Keybind] == nil then
                    if p135 then
                        u8[v138.Modifier] = true;
                    end;

                    u4[Keybind] = {
                        Input = p132,
                        Processed = p134,
                        Object = p133
                    };
                    dispatch(Keybind, "Down", p134, p133);
                end;
            end;
        end;
    end;
end;

UserInputService.InputBegan:Connect(function(u141: userdata, u142: boolean) -- Line: 930
    -- upvalues: isMovementTouch (copy), u25 (copy), u26 (ref), u1 (copy), u112 (ref), u115 (copy), u114 (copy), u119 (ref), isPadInput (copy), u123 (ref), u122 (copy), u121 (copy), u7 (copy), u6 (copy), u5 (copy), firePress (copy)
    if isMovementTouch(u141) then
        u25[u141] = true;
        u26 = u26 + 1;

        if u26 == 1 then
            u1.Moving:Fire(true);
        end;

        return;
    end;

    if u112 ~= nil and (not u142 and u141.UserInputType == Enum.UserInputType.Keyboard) then
        u115[u141.KeyCode] = true;

        if table.find(u114, u141.KeyCode) == nil then
            table.insert(u114, u141.KeyCode);
            u112(table.clone(u114));
        end;

        return;
    end;

    if u119 ~= nil and (isPadInput(u141.KeyCode) and (u123 == nil or not u123[u141.KeyCode])) then
        u122[u141.KeyCode] = true;

        if table.find(u121, u141.KeyCode) == nil then
            table.insert(u121, u141.KeyCode);
            u119(table.clone(u121));
        end;

        return;
    end;

    local u143;

    if u141.KeyCode == Enum.KeyCode.Unknown then
        u143 = u141.UserInputType;
    else
        u143 = u141.KeyCode;
    end;

    u7[u143] = true;

    for i, v in u6 do
        local v144 = i;
        local v145 = v;
        local v146 = false;

        for _, v2 in u5[i] do
            if v2.Modifier == u143 then
                v146 = true;
                break;
            end;
        end;

        if v146 then
            task.cancel(v145.Timer);
            u6[v144] = nil;
            firePress(v144, v145.Object, v145.Processed, true);
        end;
    end;

    local v147 = u5[u143];

    if v147 == nil then
        return;
    end;

    local v148 = 0;
    local v149 = false;

    for _, v in v147 do
        if v.Modifier ~= nil then
            if u7[v.Modifier] then
                v149 = true;
                break;
            end;

            if v.Window ~= nil then
                v148 = math.max(v148, v.Window);
            end;
        end;
    end;

    if v149 or v148 <= 0 then
        firePress(u143, u141, u142, v149);

        return;
    end;

    u6[u143] = {
        Object = u141,
        Processed = u142,
        Timer = task.delay(v148, function() -- Line: 1016
            -- upvalues: u6 (ref), u143 (copy), firePress (ref), u141 (copy), u142 (copy)
            u6[u143] = nil;
            firePress(u143, u141, u142, false);
        end)
    };
end);
UserInputService.InputEnded:Connect(function(p150: userdata) -- Line: 1025
    -- upvalues: isPadInput (copy), u122 (copy), u121 (copy), u119 (ref), u115 (copy), u114 (copy), u25 (copy), u26 (ref), u1 (copy), u7 (copy), u6 (copy), firePress (copy), u5 (copy), u4 (copy), release (copy), u8 (copy), dispatch (copy)
    if isPadInput(p150.KeyCode) and u122[p150.KeyCode] then
        u122[p150.KeyCode] = nil;

        if table.find(u121, p150.KeyCode) ~= nil then
            local table_clone_ret = table.clone(u121);
            table.clear(u121);

            if u119 ~= nil then
                u119(table_clone_ret, true);
            end;
        end;

        return;
    end;

    if p150.UserInputType == Enum.UserInputType.Keyboard and u115[p150.KeyCode] then
        u115[p150.KeyCode] = nil;

        if table.find(u114, p150.KeyCode) ~= nil then
            table.clear(u114);
        end;

        return;
    end;

    if u25[p150] then
        u25[p150] = nil;
        u26 = math.max(0, u26 - 1);

        if u26 == 0 then
            u1.Moving:Fire(false);
        end;

        return;
    end;

    local v151;

    if p150.KeyCode == Enum.KeyCode.Unknown then
        v151 = p150.UserInputType;
    else
        v151 = p150.KeyCode;
    end;

    u7[v151] = nil;
    local v152 = u6[v151];

    if v152 ~= nil and v152.Object == p150 then
        task.cancel(v152.Timer);
        u6[v151] = nil;
        firePress(v151, p150, v152.Processed, false);
    end;

    local v153 = u5[v151];

    if v153 == nil then
        return;
    end;

    for _, v in v153 do
        local Keybind = v.Keybind;
        local v154 = u4[Keybind];

        if v154 ~= nil and v154.Input == v151 and (v154.Object == nil or v154.Object.UserInputType ~= Enum.UserInputType.Touch or v154.Object == p150) then
            release(Keybind, p150);
        end;
    end;

    local v155 = u8[v151];
    u8[v151] = nil;

    if not v155 then
        for _, v in v153 do
            local Keybind = v.Keybind;

            if v.Alone and u4[Keybind] == nil then
                u4[Keybind] = {
                    Processed = false,
                    Input = v151,
                    Object = p150
                };
                dispatch(Keybind, "Down", false, p150);
                release(Keybind, p150);
            end;
        end;
    end;
end);
UserInputService.WindowFocusReleased:Connect(function() -- Line: 1117
    -- upvalues: u7 (copy), u8 (copy), u6 (copy), u4 (copy), release (copy)
    table.clear(u7);
    table.clear(u8);

    for _, v in u6 do
        task.cancel(v.Timer);
    end;

    table.clear(u6);

    for i in u4 do
        release(i);
    end;
end);
u1.Available = simplesignal.new();
local u156 = {
    pause_gameplay = true,
    Swapping = true,
    Using_Skill_Switch = true,
    Blocking = true
};

for i in Utility.Cancel_Values do
    u156[i] = true;
end;

local u157 = false;
local u158 = false;
local u159 = false;
local u160 = nil;

local function computeAvailable() -- Line: 1147
    -- upvalues: LocalPlayer (copy), u160 (ref), u156 (copy)
    local Character = LocalPlayer.Character;

    if Character == nil or Character.Parent == nil then
        return false;
    end;

    local v161 = Character:FindFirstChildOfClass("Humanoid");

    if v161 == nil or v161.Health <= 0 then
        return false;
    end;

    if u160 ~= nil then
        for i in u156 do
            if u160:FindFirstChild(i) ~= nil then
                return false;
            end;
        end;
    end;

    local SHC = Character:FindFirstChild("SHC");

    return SHC == nil or SHC.Value == "" and SHC:GetAttribute("en") ~= true;
end;

local function evaluate(p162: boolean?) -- Line: 1164
    -- upvalues: u159 (ref), u158 (ref), computeAvailable (copy), u157 (ref), u1 (copy)
    if p162 == true then
        u159 = true;
    end;

    if u158 then
        return;
    end;

    u158 = true;
    task.defer(function() -- Line: 1170
        -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
        u158 = false;
        local v163 = u159;
        u159 = false;
        local v164 = computeAvailable();

        if v164 ~= u157 or v164 and v163 then
            u157 = v164;
            u1.Available:Fire(v164);
        end;
    end);
end;

local function renotify() -- Line: 1181
    -- upvalues: u159 (ref), u158 (ref), computeAvailable (copy), u157 (ref), u1 (copy)
    u159 = true;

    if u158 then
        return;
    end;

    u158 = true;
    task.defer(function() -- Line: 1170
        -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
        u158 = false;
        local v165 = u159;
        u159 = false;
        local v166 = computeAvailable();

        if v166 ~= u157 or v166 and v165 then
            u157 = v166;
            u1.Available:Fire(v166);
        end;
    end);
end;

function u1.IsAvailable() -- Line: 1184
    -- upvalues: u157 (ref)
    return u157;
end;

u1.Dragging = simplesignal.new();
local u167 = false;

function u1.IsDragging() -- Line: 1196
    -- upvalues: u167 (ref)
    return u167;
end;

function u1.SetDragging(p168: boolean) -- Line: 1200
    -- upvalues: u167 (ref), u1 (copy)
    local v169 = p168 == true;

    if v169 == u167 then
        return;
    end;

    u167 = v169;
    u1.Dragging:Fire(v169);
end;

local function onValue(p170: userdata) -- Line: 1208
    -- upvalues: u156 (copy), u158 (ref), u159 (ref), computeAvailable (copy), u157 (ref), u1 (copy)
    if u156[p170.Name] then
        if u158 then
            return;
        end;

        u158 = true;
        task.defer(function() -- Line: 1170
            -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
            u158 = false;
            local v171 = u159;
            u159 = false;
            local v172 = computeAvailable();

            if v172 ~= u157 or v172 and v171 then
                u157 = v172;
                u1.Available:Fire(v172);
            end;
        end);
    end;
end;

local function hookSHC(p173: userdata) -- Line: 1213
    -- upvalues: evaluate (copy), renotify (copy), u158 (ref), u159 (ref), computeAvailable (copy), u157 (ref), u1 (copy)
    p173.Changed:Connect(evaluate);
    p173:GetAttributeChangedSignal("en"):Connect(evaluate);
    p173.ChildRemoved:Connect(renotify);

    if u158 then
        return;
    end;

    u158 = true;
    task.defer(function() -- Line: 1170
        -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
        u158 = false;
        local v174 = u159;
        u159 = false;
        local v175 = computeAvailable();

        if v175 ~= u157 or v175 and v174 then
            u157 = v175;
            u1.Available:Fire(v175);
        end;
    end);
end;

local function hookCharacter(p176: userdata) -- Line: 1223
    -- upvalues: evaluate (copy), renotify (copy), u158 (ref), u159 (ref), computeAvailable (copy), u157 (ref), u1 (copy)
    p176.ChildAdded:Connect(function(p177) -- Line: 1224
        -- upvalues: evaluate (ref), renotify (ref), u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
        if p177.Name ~= "SHC" then
            if p177:IsA("Humanoid") then
                p177.Died:Connect(evaluate);

                if u158 then
                    return;
                end;

                u158 = true;
                task.defer(function() -- Line: 1170
                    -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
                    u158 = false;
                    local v178 = u159;
                    u159 = false;
                    local v179 = computeAvailable();

                    if v179 ~= u157 or v179 and v178 then
                        u157 = v179;
                        u1.Available:Fire(v179);
                    end;
                end);
            end;

            return;
        end;

        p177.Changed:Connect(evaluate);
        p177:GetAttributeChangedSignal("en"):Connect(evaluate);
        p177.ChildRemoved:Connect(renotify);

        if u158 then
            return;
        end;

        u158 = true;
        task.defer(function() -- Line: 1170
            -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
            u158 = false;
            local v180 = u159;
            u159 = false;
            local v181 = computeAvailable();

            if v181 ~= u157 or v181 and v180 then
                u157 = v181;
                u1.Available:Fire(v181);
            end;
        end);
    end);
    local SHC = p176:FindFirstChild("SHC");

    if SHC ~= nil then
        SHC.Changed:Connect(evaluate);
        SHC:GetAttributeChangedSignal("en"):Connect(evaluate);
        SHC.ChildRemoved:Connect(renotify);

        if not u158 then
            u158 = true;
            task.defer(function() -- Line: 1170
                -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
                u158 = false;
                local v182 = u159;
                u159 = false;
                local v183 = computeAvailable();

                if v183 ~= u157 or v183 and v182 then
                    u157 = v183;
                    u1.Available:Fire(v183);
                end;
            end);
        end;
    end;

    local v184 = p176:FindFirstChildOfClass("Humanoid");

    if v184 ~= nil then
        v184.Died:Connect(evaluate);
    end;

    if u158 then
        return;
    end;

    u158 = true;
    task.defer(function() -- Line: 1170
        -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
        u158 = false;
        local v185 = u159;
        u159 = false;
        local v186 = computeAvailable();

        if v186 ~= u157 or v186 and v185 then
            u157 = v186;
            u1.Available:Fire(v186);
        end;
    end);
end;

if RunService:IsRunning() then
    task.spawn(function() -- Line: 1243
        -- upvalues: u160 (ref), Utility (copy), LocalPlayer (copy), onValue (copy), u1 (copy), hookCharacter (copy), u158 (ref), u159 (ref), computeAvailable (copy), u157 (ref)
        u160 = Utility.getvaluesfolder(LocalPlayer, true);
        u160.ChildAdded:Connect(onValue);
        u160.ChildRemoved:Connect(onValue);
        LocalPlayer.CharacterAdded:Connect(function(p187: userdata) -- Line: 1249
            -- upvalues: u1 (ref), hookCharacter (ref)
            u1.SetDragging(false);
            hookCharacter(p187);
        end);
        LocalPlayer.CharacterRemoving:Connect(function() -- Line: 1253
            -- upvalues: u1 (ref), u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref)
            u1.SetDragging(false);

            if u158 then
                return;
            end;

            u158 = true;
            task.defer(function() -- Line: 1170
                -- upvalues: u158 (ref), u159 (ref), computeAvailable (ref), u157 (ref), u1 (ref)
                u158 = false;
                local v188 = u159;
                u159 = false;
                local v189 = computeAvailable();

                if v189 ~= u157 or v189 and v188 then
                    u157 = v189;
                    u1.Available:Fire(v189);
                end;
            end);
        end);

        if LocalPlayer.Character ~= nil then
            hookCharacter(LocalPlayer.Character);
        end;
    end);
end;

return u1;