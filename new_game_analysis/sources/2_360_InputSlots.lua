-- Decompiled with Potassium's decompiler.

local v1 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
game:GetService("StarterPlayer");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
UserSettings():GetService("UserGameSettings");
local UserInputService = game:GetService("UserInputService");
local InputReplication = require(script.Parent:WaitForChild("InputReplication"));
local u2 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer);
local UserFlag = v1.getUserFlag("UserPlayerScriptsSAuthDirectAPIs2");
local UserFlag2 = v1.getUserFlag("UserPlayerScriptsFireThroughScriptableBindings");
local UserFlag3 = v1.getUserFlag("UserPlayerScriptsPlayerControlState2");
local UserFlag4 = v1.getUserFlag("UserAbilitiesUserInterfaceB");
local u3 = UserFlag4 and "ControlState" or "PlayerControlState";
local u4 = {};
u4.__index = u4;
local u5 = {};
local u6 = {};
local u7 = {};
local u8 = {};
local BindableEvent = Instance.new("BindableEvent");
local u9 = 0;
local BindableEvent2 = Instance.new("BindableEvent");

local function shallow_equal(p10, p11) -- Line: 34
    if p10 == p11 then
        return true;
    end;

    for i, v in pairs(p10) do
        if p11[i] ~= v then
            return false;
        end;
    end;

    for i, _ in pairs(p11) do
        if p10[i] == nil then
            return false;
        end;
    end;

    return true;
end;

local function findInSparseTable(p12, p13) -- Line: 41
    for i, v in pairs(p12) do
        if v == p13 then
            return i;
        end;
    end;

    return nil;
end;

function u4.GetNumOverflowSlots() -- Line: 50
    return 3;
end;

function u4.getOverflowScrollIndex() -- Line: 54
    -- upvalues: u9 (ref)
    return u9;
end;

function u4.setOverflowScrollIndex(p14) -- Line: 58
    -- upvalues: u9 (ref), u6 (ref), BindableEvent2 (copy)
    local v15 = u9;
    local math_min_ret = math.min(#u6 - 3, p14);
    u9 = math.max(0, math_min_ret);

    if u9 ~= v15 then
        BindableEvent2:Fire();
    end;
end;

function u4.getScrollIndexChangedEvent() -- Line: 66
    -- upvalues: BindableEvent2 (copy)
    return BindableEvent2.Event;
end;

function u4.setupSlotActions(u16, u17) -- Line: 70
    -- upvalues: UserFlag3 (copy), RunService (copy), u2 (copy), InputReplication (copy), u5 (copy), u6 (ref), UserInputService (copy), u4 (copy), shallow_equal (copy), BindableEvent (copy), UserFlag4 (copy), u3 (copy), u7 (copy), UserFlag (copy), UserFlag2 (copy), u8 (copy), u9 (ref)
    local function getAbilityAction(p18) -- Line: 71
        -- upvalues: UserFlag3 (ref), u17 (copy), u16 (copy)
        if not p18 then
            return nil;
        end;

        local v19;

        if UserFlag3 and not u17 then
            v19 = script.Parent.Parent:FindFirstChild("InputContexts");
        else
            v19 = u16:FindFirstChild("InputContexts");
        end;

        if not v19 then
            return nil;
        end;

        local CharacterContext = v19:FindFirstChild("CharacterContext");

        if CharacterContext then
            return CharacterContext:FindFirstChild(p18 .. "Action");
        end;

        return nil;
    end;

    if not UserFlag3 then
        RunService:BindToSimulation(function(p20) -- Line: 85
            -- upvalues: u2 (ref), InputReplication (ref), u16 (copy)
            if u2:isEnabled() then
                InputReplication.FireCustomInputs(u16);
                InputReplication.SendInputToCCLCharacter(u16);
            end;
        end, Enum.StepFrequency.Hz60);
    end;

    local u21 = {};

    local function updateSlotMap() -- Line: 95
        -- upvalues: u5 (ref), u6 (ref), u2 (ref), UserInputService (ref), u21 (copy), u4 (ref), shallow_equal (ref), BindableEvent (ref)
        local table_clone_ret = table.clone(u5);
        local table_clone_ret2 = table.clone(u6);
        local Abilities = u2:GetAbilities();
        local v22 = UserInputService.PreferredInput == Enum.PreferredInput.Touch and 7 or 11;

        for i, v in pairs(u5) do
            local v23 = i;
            local v24 = v;
            local v25 = nil;

            for i2, v2 in pairs(Abilities) do
                if v2 == v24 then
                    v25 = i2;
                    break;
                end;
            end;

            if not v25 or v22 < v23 then
                u5[v23] = nil;
            end;
        end;

        u6 = {};
        local v26 = {};

        for _, v in ipairs(Abilities) do
            local v27 = v;
            local v28 = nil;

            for i, v2 in pairs(u5) do
                if v2 == v27 then
                    v28 = i;
                    break;
                end;
            end;

            if not v28 then
                table.insert(v26, v27);
            end;
        end;

        for _, v in ipairs(v26) do
            local AbilityConfig = u2:GetAbilityConfig(v);

            if AbilityConfig then
                local v29 = tonumber(AbilityConfig.Slot);

                if v29 > 0 then
                    if u5[v29] or v29 > v22 then
                        table.insert(u6, v);
                    else
                        u5[v29] = v;
                    end;
                end;
            end;
        end;

        for _, v in ipairs(v26) do
            local AbilityConfig = u2:GetAbilityConfig(v);

            if AbilityConfig and tonumber(AbilityConfig.Slot) == 0 then
                local v30 = u21[v];

                if v30 and (v30 > 0 and (v30 <= v22 and not u5[v30])) then
                    u5[v30] = v;
                else
                    local v31 = v;
                    local v32 = -1;

                    for i = 1, v22 do
                        if not u5[i] then
                            v32 = i;
                            break;
                        end;

                        local _ = i;
                    end;

                    if v32 == -1 then
                        table.insert(u6, v31);
                    else
                        u5[v32] = v31;
                        u21[v31] = v32;
                    end;
                end;
            end;
        end;

        u4.setOverflowScrollIndex(u4.getOverflowScrollIndex());

        if not (shallow_equal(u5, table_clone_ret) and shallow_equal(u6, table_clone_ret2)) then
            BindableEvent:Fire();
        end;
    end;

    u2:GetAbilitiesChangedSignal():Connect(updateSlotMap);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(updateSlotMap);
    updateSlotMap();
    task.spawn(function() -- Line: 178
        -- upvalues: UserFlag4 (ref), u3 (ref), UserFlag3 (ref), u17 (copy), u16 (copy), u7 (ref), u5 (ref), getAbilityAction (copy), UserFlag (ref), UserFlag2 (ref), u8 (ref), u6 (ref), u9 (ref)
        local function UpdateAbilityInPCS(p33, p34, p35) -- Line: 179
            -- upvalues: UserFlag4 (ref), u3 (ref)
            local Character = p33.Character;

            if not Character then
                return;
            end;

            local v36;

            if UserFlag4 then
                v36 = Character:FindFirstChildOfClass(u3);
            else
                v36 = Character:FindFirstChild(u3);
            end;

            if not v36 then
                return;
            end;

            v36:UpdateFields({
                [p34] = p35
            });
        end;

        local v37;

        if UserFlag3 and not u17 then
            v37 = script.Parent.Parent:FindFirstChild("InputContexts");
        else
            v37 = u16:WaitForChild("InputContexts", (1 / 0));
        end;

        local CharacterContext = v37:WaitForChild("CharacterContext");

        for i = 1, 11 do
            local v38 = CharacterContext:WaitForChild("AbilityAction" .. tostring(i));
            u7[i] = v38;
            v38.StateChanged:Connect(function(u39) -- Line: 200
                -- upvalues: UserFlag3 (ref), u5 (ref), i (copy), UpdateAbilityInPCS (copy), u16 (ref), getAbilityAction (ref), UserFlag (ref), UserFlag2 (ref)
                if UserFlag3 then
                    if u5[i] ~= nil and u5[i] ~= "" then
                        UpdateAbilityInPCS(u16, u5[i], u39);
                    end;
                else
                    local v40 = getAbilityAction(u5[i]);

                    if v40 then
                        if UserFlag then
                            local ScriptableBinding = v40:FindFirstChild("ScriptableBinding");

                            if ScriptableBinding then
                                ScriptableBinding:Fire(u39);
                            end;
                        elseif UserFlag2 then
                            local ScriptableBinding = v40:FindFirstChild("ScriptableBinding");

                            if not ScriptableBinding then
                                v40:Fire(u39);

                                return;
                            end;

                            local success, _ = pcall(function() -- Line: 216
                                -- upvalues: ScriptableBinding (copy), u39 (copy)
                                ScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                                ScriptableBinding:Fire(u39);
                            end);

                            if not success then
                                v40:Fire(u39);
                            end;
                        else
                            v40:Fire(u39);
                        end;
                    end;
                end;
            end);
            local _ = i;
        end;

        if UserFlag3 then
            for i = 1, 3 do
                local v41 = CharacterContext:WaitForChild("OverflowAction" .. tostring(i));
                u8[i] = v41;
                v41.StateChanged:Connect(function(p42) -- Line: 238
                    -- upvalues: u6 (ref), i (copy), u9 (ref), UpdateAbilityInPCS (copy), u16 (ref)
                    local v43 = u6[i + u9];

                    if v43 ~= nil and v43 ~= "" then
                        UpdateAbilityInPCS(u16, v43, p42);
                    end;
                end);
                local _ = i;
            end;
        end;
    end);
end;

function u4.GetSlotMapChangedSignal() -- Line: 249
    -- upvalues: BindableEvent (copy)
    return BindableEvent.Event;
end;

function u4.GetSlotMap() -- Line: 253
    -- upvalues: u5 (copy)
    return u5;
end;

function u4.GetAbilitiesInOverflow() -- Line: 257
    -- upvalues: u6 (ref)
    return u6;
end;

function u4.GetActionInSlot(p44) -- Line: 261
    -- upvalues: u7 (copy)
    return u7[p44];
end;

function u4.GetOverflowAction(p45) -- Line: 265
    -- upvalues: u8 (copy)
    return u8[p45];
end;

return u4;