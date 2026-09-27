-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local string_match_ret = string.match(SettingsKeys.KeybindRoot, "[^/]+$");
local string_match_ret2 = string.match(SettingsKeys.PadKeybindRoot, "[^/]+$");
local u1 = {};
local u2 = {};

local function codeOf(u3) -- Line: 38
    if type(u3) ~= "string" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 40
        -- upvalues: u3 (copy)
        return Enum.KeyCode[u3];
    end);

    if success then
        return result;
    end;

    return nil;
end;

local function keyOf(p4: userdata) -- Line: 49
    -- upvalues: SettingsKeys (copy)
    if not p4:IsA("ValueBase") then
        return nil, nil;
    end;

    local Value = p4.Value;

    if typeof(Value) ~= "string" then
        return nil, nil;
    end;

    local string_match_ret3, u5 = string.match(Value, "^(.-)%" .. SettingsKeys.PadChordSeparator .. "(.+)$");

    if string_match_ret3 ~= nil then
        Value = string_match_ret3;
    end;

    local v6;

    if type(Value) == "string" then
        local v7;
        v7, v6 = pcall(function() -- Line: 40
            -- upvalues: Value (copy)
            return Enum.KeyCode[Value];
        end);

        if not v7 then
            v6 = nil;
        end;
    else
        v6 = nil;
    end;

    local v8;

    if u5 == nil or type(u5) ~= "string" then
        v8 = nil;
    else
        local v9;
        v9, v8 = pcall(function() -- Line: 40
            -- upvalues: u5 (copy)
            return Enum.KeyCode[u5];
        end);

        if not v9 then
            v8 = nil;
        end;
    end;

    if v6 == nil then
        return nil, nil;
    end;

    if u5 ~= nil and v8 == nil then
        return nil, nil;
    end;

    if SettingsKeys.IsBindable(v6, v8) then
        return v6, v8;
    end;

    return nil, nil;
end;

local function apply(p10: userdata?) -- Line: 65
    -- upvalues: SettingsKeys (copy), keyOf (copy), InputHandler (copy), u1 (ref)
    local v11 = {};

    if p10 ~= nil then
        for _, child in p10:GetChildren() do
            local Name = child.Name;

            if SettingsKeys.IsEditable(Name) then
                local v12, v13 = keyOf(child);

                if v12 ~= nil then
                    v11[Name] = true;
                    InputHandler.RebindKey(Name, v12, v13);
                end;
            end;
        end;
    end;

    for i in u1 do
        if v11[i] ~= true then
            InputHandler.RebindKey(i, InputHandler.DefaultKey(i));
        end;
    end;

    u1 = v11;
end;

local function padKeyOf(u14: string) -- Line: 91
    local success, result = pcall(function() -- Line: 92
        -- upvalues: u14 (copy)
        return Enum.KeyCode[u14];
    end);

    if success then
        return result;
    end;

    return nil;
end;

local function padBindingOf(p15: userdata) -- Line: 97
    -- upvalues: SettingsKeys (copy)
    if not p15:IsA("ValueBase") then
        return nil, nil;
    end;

    local Value = p15.Value;

    if typeof(Value) ~= "string" then
        return nil, nil;
    end;

    local string_match_ret3, u16 = string.match(Value, "^(.-)%" .. SettingsKeys.PadChordSeparator .. "(.+)$");

    if string_match_ret3 ~= nil then
        Value = string_match_ret3;
    end;

    local success, result = pcall(function() -- Line: 92
        -- upvalues: Value (copy)
        return Enum.KeyCode[Value];
    end);

    if not success then
        result = nil;
    end;

    local v17;

    if u16 == nil then
        v17 = nil;
    else
        local v18;
        v18, v17 = pcall(function() -- Line: 92
            -- upvalues: u16 (copy)
            return Enum.KeyCode[u16];
        end);

        if not v18 then
            v17 = nil;
        end;
    end;

    if result == nil then
        return nil, nil;
    end;

    if u16 ~= nil and v17 == nil then
        return nil, nil;
    end;

    if SettingsKeys.IsPadBindable(result, v17) then
        return result, v17;
    end;

    return nil, nil;
end;

local function applyPad(p19: userdata?) -- Line: 113
    -- upvalues: SettingsKeys (copy), padBindingOf (copy), InputHandler (copy), u2 (ref)
    local v20 = {};

    if p19 ~= nil then
        for _, child in p19:GetChildren() do
            local Name = child.Name;

            if SettingsKeys.IsEditable(Name) then
                local v21, v22 = padBindingOf(child);

                if v21 ~= nil then
                    v20[Name] = true;
                    InputHandler.RebindPad(Name, v21, v22);
                end;
            end;
        end;
    end;

    for i in u2 do
        if v20[i] ~= true then
            InputHandler.RebindPad(i, InputHandler.PadDefault(i));
        end;
    end;

    u2 = v20;
end;

local _, v23 = Utility.GetData(Players.LocalPlayer, true);

if v23 == nil then
    return;
end;

local Settings = v23:WaitForChild("Settings", 30);

if Settings == nil then
    return;
end;

local function watch(u24: userdata, u25: function) -- Line: 142
    local function reread() -- Line: 143
        -- upvalues: u25 (copy), u24 (copy)
        local v26;

        if u24.Parent == nil then
            v26 = nil;
        else
            v26 = u24;
        end;

        u25(v26);
    end;

    u24.ChildAdded:Connect(function(p27: userdata) -- Line: 146
        -- upvalues: u25 (copy), u24 (copy), reread (copy)
        local v28;

        if u24.Parent == nil then
            v28 = nil;
        else
            v28 = u24;
        end;

        u25(v28);

        if p27:IsA("ValueBase") then
            p27:GetPropertyChangedSignal("Value"):Connect(reread);
        end;
    end);
    u24.ChildRemoved:Connect(reread);
    u24.Destroying:Connect(function() -- Line: 153
        -- upvalues: u25 (copy)
        u25(nil);
    end);

    for _, child in u24:GetChildren() do
        if child:IsA("ValueBase") then
            child:GetPropertyChangedSignal("Value"):Connect(reread);
        end;
    end;

    u25(u24);
end;

local u29 = {
    [string_match_ret] = apply,
    [string_match_ret2] = applyPad
};
Settings.ChildAdded:Connect(function(p30: userdata) -- Line: 170
    -- upvalues: u29 (copy), watch (copy)
    local v31 = u29[p30.Name];

    if v31 ~= nil then
        watch(p30, v31);
    end;
end);

for i, v in u29 do
    local v32 = Settings:FindFirstChild(i);

    if v32 ~= nil then
        watch(v32, v);
    end;
end;