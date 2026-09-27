-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local v1 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local UserFlag = v1.getUserFlag("UserPlayerScriptsCCLIntegrationD");
local UserFlag2 = v1.getUserFlag("UserPlayerScriptsPlayerControlState2");

if not UserFlag then
    local Players2 = game:GetService("Players");
    local v2 = {};
    local u3 = nil;
    local u4 = nil;
    local BindableEvent = Instance.new("BindableEvent");
    local u5 = nil;
    local u6 = false;

    local function characterAdded(p7) -- Line: 302
        -- upvalues: u3 (ref), u4 (ref), u5 (ref), BindableEvent (copy)
        u3 = nil;
        u4 = nil;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        if p7 then
            u3 = p7:FindFirstChild("AbilityManagerActor");
            u4 = p7:FindFirstChildOfClass("Humanoid");

            while not u4 do
                p7.ChildAdded:wait();
                u4 = p7:FindFirstChildOfClass("Humanoid");
            end;

            BindableEvent:Fire();
            u5 = u4:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- Line: 319
                -- upvalues: BindableEvent (ref)
                BindableEvent:Fire();
            end);
        end;
    end;

    local function lazyInit() -- Line: 325
        -- upvalues: u6 (ref), Players2 (copy), characterAdded (copy)
        if u6 then
            return;
        end;

        u6 = true;
        local LocalPlayer = Players2.LocalPlayer;

        if LocalPlayer then
            LocalPlayer.characterAdded:Connect(characterAdded);

            if LocalPlayer.Character then
                characterAdded(LocalPlayer.Character);
            end;
        end;
    end;

    function v2.isEnabled() -- Line: 340
        -- upvalues: u6 (ref), Players2 (copy), characterAdded (copy), u3 (ref), u4 (ref)
        if not u6 then
            u6 = true;
            local LocalPlayer = Players2.LocalPlayer;

            if LocalPlayer then
                LocalPlayer.characterAdded:Connect(characterAdded);

                if LocalPlayer.Character then
                    characterAdded(LocalPlayer.Character);
                end;
            end;
        end;

        local v8;

        if u3 == nil then
            v8 = false;
        else
            v8 = u4 and not u4.EvaluateStateMachine;
        end;

        return v8;
    end;

    function v2.GetEnabledChangedSignal() -- Line: 345
        -- upvalues: u6 (ref), Players2 (copy), characterAdded (copy), BindableEvent (copy)
        if not u6 then
            u6 = true;
            local LocalPlayer = Players2.LocalPlayer;

            if LocalPlayer then
                LocalPlayer.characterAdded:Connect(characterAdded);

                if LocalPlayer.Character then
                    characterAdded(LocalPlayer.Character);
                end;
            end;
        end;

        return BindableEvent.Event;
    end;

    return v2;
end;

local u9 = {};
u9.__index = u9;
local u10 = {};
Players.PlayerRemoving:Connect(function(p11) -- Line: 13
    -- upvalues: u10 (copy)
    wait(1);
    local v12 = u10[p11.UserId];

    if v12 then
        v12:destroy();
        u10[p11.UserId] = nil;
    end;
end);

function u9._new(u13) -- Line: 23
    -- upvalues: u9 (copy), UserFlag2 (copy)
    local u14 = setmetatable({}, u9);
    u14._player = u13;
    u14._data = {};
    u14._abilityManagerActor = nil;
    u14._inputMap = {};
    u14._character = nil;
    u14._humanoid = nil;
    u14._enabledChangedEvent = Instance.new("BindableEvent");
    u14._abilitiesChangedEvent = Instance.new("BindableEvent");
    u14._evaluateStateMachineChangedConnection = nil;
    u14._abilityChangedEvents = {};
    u14._abilityChangedConnections = {};

    if UserFlag2 then
        task.spawn(function() -- Line: 39
            -- upvalues: u14 (copy), u13 (copy)
            u14._characterAddedConnection = u13.CharacterAdded:Connect(function(p15) -- Line: 40
                -- upvalues: u14 (ref)
                u14:_onCharacterAdded(p15);
            end);
        end);
    else
        u14._characterAddedConnection = u13.CharacterAdded:Connect(function(p16) -- Line: 45
            -- upvalues: u14 (copy)
            u14:_onCharacterAdded(p16);
        end);
    end;

    if u13.Character then
        u14:_onCharacterAdded(u13.Character);
    end;

    return u14;
end;

local u17 = nil;

function u9._avatarAbilities() -- Line: 59
    -- upvalues: u17 (ref)
    if not u17 then
        local Packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages");
        local v18;

        if Packages then
            v18 = Packages:FindFirstChild("AvatarAbilities");
        else
            v18 = nil;
        end;

        local v19;

        if v18 then
            v19 = require(v18);
        else
            v19 = nil;
        end;

        u17 = v19 or require("@rbx/AvatarAbilities");
    end;

    return u17;
end;

function u9.get(p20) -- Line: 72
    -- upvalues: u10 (copy), u9 (copy)
    if not p20 or p20.UserId == 0 then
        return nil;
    end;

    local v21 = u10[p20.UserId];

    if not v21 then
        v21 = u9._new(p20);
        u10[p20.UserId] = v21;
    end;

    return v21;
end;

function u9._hookUpAbilityChangedEvent(u22, u23, u24) -- Line: 82
    local v25 = u22._inputMap[u23];

    if #v25 < 1 then
        return;
    end;

    local v26 = v25[1];

    if not v26 then
        return;
    end;

    local SyncedState = v26:FindFirstChild("SyncedState");

    if not SyncedState then
        return;
    end;

    if not u22._abilityChangedConnections[u24] then
        u22._abilityChangedConnections[u24] = {};
    end;

    if u22._abilityChangedConnections[u24][u23] then
        u22._abilityChangedConnections[u24][u23]:Disconnect();
        u22._abilityChangedConnections[u24][u23] = nil;
    end;

    u22._abilityChangedConnections[u24][u23] = SyncedState:GetAttributeChangedSignal(u24):Connect(function() -- Line: 98
        -- upvalues: u22 (copy), u24 (copy), u23 (copy)
        u22._abilityChangedEvents[u24][u23]:Fire();
    end);
end;

function u9._onCharacterAdded(u27, p28) -- Line: 103
    u27._abilityManagerActor = nil;
    u27._humanoid = nil;
    u27._character = p28;

    if u27._evaluateStateMachineChangedConnection then
        u27._evaluateStateMachineChangedConnection:Disconnect();
        u27._evaluateStateMachineChangedConnection = nil;
    end;

    if u27._character then
        task.spawn(function() -- Line: 113
            -- upvalues: u27 (copy)
            u27._abilityManagerActor = u27._character:WaitForChild("AbilityManagerActor", 5);

            if u27._abilityManagerActor then
                u27._data = {};
                u27._humanoid = u27._character:FindFirstChildOfClass("Humanoid");

                while not u27._humanoid do
                    u27._character.ChildAdded:Wait();
                    u27._humanoid = u27._character:FindFirstChildOfClass("Humanoid");
                end;

                if u27._evaluateStateMachineChangedConnection then
                    u27._evaluateStateMachineChangedConnection:Disconnect();
                    u27._evaluateStateMachineChangedConnection = nil;
                end;

                local function enabledChanged() -- Line: 127
                    -- upvalues: u27 (ref)
                    if u27:isEnabled() then
                        local v29, v30, v31 = u27._avatarAbilities().createMaintainedInputMap(u27._character);
                        u27._inputMap = v29;
                        u27._inputMapCleanup = v30;

                        if u27._inputMapChangedConnection then
                            u27._inputMapChangedConnection:Disconnect();
                            u27._inputMapChangedConnection = nil;
                        end;

                        u27._inputMapChangedConnection = v31:Connect(function(p32) -- Line: 136
                            -- upvalues: u27 (ref)
                            u27._abilitiesChangedEvent:Fire();
                        end);
                        u27._abilitiesChangedEvent:Fire();

                        for i, v in u27._abilityChangedEvents do
                            local v33 = i;

                            for i2, v2 in v do
                                v2:Fire();
                                u27:_hookUpAbilityChangedEvent(i2, v33);
                            end;
                        end;
                    end;

                    u27._enabledChangedEvent:Fire();
                end;

                u27._evaluateStateMachineChangedConnection = u27._humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- Line: 150
                    -- upvalues: enabledChanged (copy)
                    enabledChanged();
                end);
                enabledChanged();
            end;
        end);
    end;
end;

function u9.isEnabled(p34) -- Line: 159
    local v35;

    if p34._abilityManagerActor == nil then
        v35 = false;
    else
        v35 = p34._humanoid and not p34._humanoid.EvaluateStateMachine;
    end;

    return v35;
end;

function u9.GetEnabledChangedSignal(p36) -- Line: 163
    return p36._enabledChangedEvent.Event;
end;

function u9.SendInput(p37, p38, p39) -- Line: 167
    if not p37:isEnabled() then
        return;
    end;

    if p39 ~= p37._data[p38] then
        p37._data[p38] = p39;
        p37._avatarAbilities().setAbilityManagerCommand(p37._character, p38, p39);
    end;
end;

function u9.GetAbilityAttribute(p40, p41, p42, p43) -- Line: 176
    local v44 = p40._inputMap[p41];

    if #v44 < 1 then
        return p43;
    end;

    local v45 = v44[1];

    if not v45 then
        return p43;
    end;

    local SyncedState = v45:FindFirstChild("SyncedState");

    if not SyncedState then
        return p43;
    end;

    local Attribute = SyncedState:GetAttribute(p42);

    if Attribute == nil then
        return p43;
    end;

    return Attribute;
end;

function u9.GetAbilityAttributeChangedSignal(p46, p47, p48) -- Line: 188
    if not p46._abilityChangedEvents[p48] then
        p46._abilityChangedEvents[p48] = {};
    end;

    if p46._abilityChangedEvents[p48][p47] then
        return p46._abilityChangedEvents[p48][p47].Event;
    end;

    local BindableEvent = Instance.new("BindableEvent");
    p46._abilityChangedEvents[p48][p47] = BindableEvent;
    p46:_hookUpAbilityChangedEvent(p47, p48);

    return BindableEvent.Event;
end;

function u9.GetAbilityEnabled(p49, p50) -- Line: 204
    return p49:GetAbilityAttribute(p50, "Enabled", false);
end;

function u9.GetAbilityEnabledChangedSignal(p51, p52) -- Line: 208
    return p51:GetAbilityAttributeChangedSignal(p52, "Enabled");
end;

function u9.GetAbilitySuspended(p53, p54) -- Line: 212
    return p53:GetAbilityAttribute(p54, "Suspended", false);
end;

function u9.GetAbilitySuspendedChangedSignal(p55, p56) -- Line: 216
    return p55:GetAbilityAttributeChangedSignal(p56, "Suspended");
end;

function u9.GetAbilityActive(p57, p58) -- Line: 220
    return p57:GetAbilityAttribute(p58, "Active", false);
end;

function u9.GetAbilityActiveChangedSignal(p59, p60) -- Line: 224
    return p59:GetAbilityAttributeChangedSignal(p60, "Active");
end;

function u9.GetAbilityValid(p61, p62) -- Line: 228
    return p61:GetAbilityAttribute(p62, "IsValid", true);
end;

function u9.GetAbilityValidChangedSignal(p63, p64) -- Line: 232
    return p63:GetAbilityAttributeChangedSignal(p64, "IsValid");
end;

function u9.GetAbilities(p65) -- Line: 236
    local v66 = {};

    for i, _ in p65._inputMap do
        table.insert(v66, i);
    end;

    return v66;
end;

function u9.GetAbilitiesChangedSignal(p67) -- Line: 244
    return p67._abilitiesChangedEvent.Event;
end;

function u9.GetAbilityConfig(p68, p69) -- Line: 248
    local v70 = {
        Slot = -1
    };
    local v71 = p68._inputMap[p69];

    if #v71 < 1 then
        return v70;
    end;

    local v72 = v71[1];

    if not v72 then
        return v70;
    end;

    local Attribute = v72:GetAttribute("ActionSlot");

    return Attribute and {
        Slot = tonumber(Attribute),
        ButtonAssetId = v72:GetAttribute("CustomIcon"),
        ButtonPressedAssetId = v72:GetAttribute("CustomIconActive"),
        ButtonInvalidAssetId = v72:GetAttribute("CustomIconInvalid")
    } or v70;
end;

function u9.destroy(p73) -- Line: 272
    if p73._characterAddedConnection then
        p73._characterAddedConnection:Disconnect();
        p73._characterAddedConnection = nil;
    end;

    if p73._evaluateStateMachineChangedConnection then
        p73._evaluateStateMachineChangedConnection:Disconnect();
        p73._evaluateStateMachineChangedConnection = nil;
    end;

    for _, v in p73._abilityChangedConnections do
        for _, v2 in v do
            v2:Disconnect();
        end;
    end;

    p73._abilityChangedConnections = {};
end;

return u9;