-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local lever = require(script.Parent.lever);
local dropper = require(script.Parent.dropper);
local checkpoint = require(script.Parent.checkpoint);
local WipeTransition = require(ReplicatedStorage.CAM.Client.Components.Misc.Transitions.WipeTransition);
local ParkourTrainingUI = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Training.ParkourTrainingUI);
local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local LoopsHandler = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.LoopsHandler);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local MarkerHandler = require(ReplicatedStorage.CAM.Client.Modules.MarkerHandler);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local valuesfolder = Utility.getvaluesfolder(game.Players.LocalPlayer, true);
local ParkourTraining = workspace:WaitForChild("Map"):WaitForChild("DetachedMaps"):WaitForChild("ParkourTraining");
local u1 = {
    CameraKey = "ParkourTraining",
    TransitionWait = 0.35,
    FinishSettle = 1,
    DroppersFolderName = "Dropdown",
    MapRoot = ParkourTraining,
    Icons = {
        Lever = "rbxassetid://85853569463281",
        Checkpoint = "rbxassetid://135018602259567"
    },
    Teleport = {
        LerpTime = 1,
        BufferTime = 0.25
    },
    InitialTpLocation = CFrame.new(-68, 890.25, 4076.099),
    SpawnLocations = { CFrame.new(-80.4131851, 890.25, 3942.9076), CFrame.new(-102.877495, 885.23407, 3386.349), CFrame.new(406.698975, 905.248795, 3273.9809) },
    Levers = { {
            Lever = "Switch_1",
            Gate = "Gate1"
        }, {
            Lever = "Switch_2",
            Gate = "Gate2"
        }, {
            Gate = "Gate3",
            Lever = { "Switch_3", "Switch_4", "Switch_5" }
        }, {
            Gate = "Gate4",
            Lever = { "Switch_6", "Switch_7" }
        } },
    MarkerPositions = { {
            Lever = Vector3.new(-120.476, 898.435, 3853.299)
        }, {
            Lever = Vector3.new(-212.057, 934.025, 3575.058),
            Checkpoint = Vector3.new(-104.662, 892.359, 3388.326)
        }, {
            Checkpoint = Vector3.new(409.666, 910.798, 3275.404),
            Lever = { Vector3.new(-123.536, 952.635, 3278.08), Vector3.new(-34.632, 952.011, 3296.739), Vector3.new(-235.124, 971.707, 3426.915) }
        }, {
            Lever = { Vector3.new(491.013, 951.202, 3239.977), Vector3.new(207.213, 1026.862, 2954.956) }
        } }
};

local function resolveLevers(p2: number?) -- Line: 103
    -- upvalues: u1 (copy), ParkourTraining (copy)
    local v3 = p2 ~= nil and u1.Levers[p2] or nil;

    if v3 == nil then
        return nil;
    end;

    local Switchs = ParkourTraining:FindFirstChild("Switchs");

    if Switchs == nil then
        return nil;
    end;

    local v4;

    if typeof(v3.Lever) == "table" then
        v4 = v3.Lever;
    else
        v4 = { v3.Lever };
    end;

    local v5 = {};

    for i, v in v4 do
        local v6 = Switchs:FindFirstChild(v);

        if v6 == nil then
            return nil;
        end;

        v5[i] = v6;
    end;

    local v7;

    if v3.Gate == nil then
        v7 = nil;
    else
        v7 = ParkourTraining:FindFirstChild("Gates");

        if v7 then
            v7 = v7:FindFirstChild(v3.Gate);
        end;

        if v7 == nil then
            return nil;
        end;
    end;

    local v8 = {};

    if typeof(v3.Lever) ~= "table" then
        v5 = v5[1];
    end;

    v8.Lever = v5;
    v8.Gate = v7;

    return v8;
end;

local u9 = {
    id = 0,
    cleaner = nil,
    currentThread = nil,
    currentSetupLevel = nil,
    currentCheckpoint = nil,
    preTrainingCFrame = nil,
    debounce = false,
    currentLevers = {},
    lastLevers = {},
    droppers = {},
    activeMarkers = {}
};

local function asArray(p10) -- Line: 153
    return typeof(p10) == "Instance" and { p10 } or p10;
end;

local function forEachSwitch(p11: table, p12: function) -- Line: 157
    local Lever = p11.Lever;

    for i, v in typeof(Lever) == "Instance" and { Lever } or Lever do
        p12(v, i);
    end;
end;

local function destroyAll(p13: table, p14: boolean?) -- Line: 165
    for _, v in p13 do
        v:Destroy(p14);
    end;

    table.clear(p13);
end;

local function computeMarkers(p15: number, p16: number) -- Line: 177
    -- upvalues: resolveLevers (copy), u1 (copy), MarkerHandler (copy)
    local v17 = {};

    if typeof(p15) ~= "number" then
        return v17;
    end;

    local math_floor_ret = math.floor(p15);
    local v18 = resolveLevers(math_floor_ret);
    local v19 = u1.MarkerPositions[math_floor_ret];

    if not (v18 and v19) then
        return v17;
    end;

    local Lever = v18.Lever;
    local v20 = typeof(Lever) == "Instance" and { Lever } or Lever;
    local v21;

    if typeof(v19.Lever) == "table" then
        v21 = v19.Lever;
    else
        v21 = { v19.Lever };
    end;

    for i, v in v20 do
        local A_ = v:FindFirstChild("A_");

        if A_ and not A_:GetAttribute("On") then
            v17[`parkour_lever_{math_floor_ret}_{i}`] = {
                style = "Simple",
                tag = "ParkourMarkers",
                minDistance = 20,
                margin = 10,
                displayDistance = true,
                markerType = MarkerHandler.markerType.Regular,
                img = u1.Icons.Lever,
                position = v21[i]
            };
            break;
        end;
    end;

    local v22 = math_floor_ret - 1;
    local v23 = u1.MarkerPositions[v22];

    if p15 % 1 == 0 and (v23 and (v23.Checkpoint and (p16 or 0) < v22)) then
        v17[`parkour_checkpoint_{v22}`] = {
            style = "Simple",
            tag = "ParkourMarkers",
            minDistance = 15,
            margin = 10,
            displayDistance = true,
            markerType = MarkerHandler.markerType.Regular,
            img = u1.Icons.Checkpoint,
            position = v23.Checkpoint
        };
    end;

    return v17;
end;

local function syncMarkers(p24: table) -- Line: 224
    -- upvalues: u9 (copy), MarkerHandler (copy)
    for i in u9.activeMarkers do
        if not p24[i] then
            MarkerHandler.removeMarker(i);
            u9.activeMarkers[i] = nil;
        end;
    end;

    for i, v in p24 do
        if not u9.activeMarkers[i] then
            MarkerHandler.addMarker(i, v);
            u9.activeMarkers[i] = true;
        end;
    end;
end;

local function clearAllMarkers() -- Line: 239
    -- upvalues: u9 (copy), MarkerHandler (copy)
    for i in u9.activeMarkers do
        MarkerHandler.removeMarker(i);
    end;

    table.clear(u9.activeMarkers);
end;

local function teleportBack(p25: userdata, p26: number) -- Line: 250
    -- upvalues: Camera_Traffic_Handler (copy), u1 (copy), Utility (copy), valuesfolder (copy), LoopsHandler (copy)
    Camera_Traffic_Handler[u1.CameraKey] = true;
    task.wait();
    local Pivot = p25:GetPivot();
    local v27 = u1.SpawnLocations[p26];
    local CFrame2 = workspace.CurrentCamera.CFrame;
    game.ReplicatedStorage.Communication.CnC.ClientEffects:Fire("DeathEffect", Pivot);
    local v28 = Pivot:Inverse() * CFrame2;
    p25:PivotTo(v27);
    local u29 = v27 * v28;
    local os_clock_ret = os.clock();
    local LerpTime = u1.Teleport.LerpTime;
    local BufferTime = u1.Teleport.BufferTime;
    local u30 = BufferTime / LerpTime;
    Utility.AddValue(valuesfolder, "skill_stand_still", LerpTime + 0.15, "BoolValue");
    Utility.AddValue(valuesfolder, "pause_gameplay", LerpTime + 0.15, "BoolValue");
    Utility.AddValue(valuesfolder, "Invisible", LerpTime + 0.15, "BoolValue");
    LoopsHandler.Add("ParkourHandlerTeleportLoop", function() -- Line: 272
        -- upvalues: Camera_Traffic_Handler (ref), u1 (ref), os_clock_ret (copy), LerpTime (copy), BufferTime (copy), u30 (copy), CFrame2 (copy), u29 (copy)
        if Camera_Traffic_Handler.Equipped_Hirearchy ~= u1.CameraKey then
            return true;
        end;

        local v31 = os.clock() - os_clock_ret;

        if LerpTime < v31 then
            return true;
        end;

        if BufferTime < v31 then
            local v32 = v31 / LerpTime - u30;
            workspace.CurrentCamera.CFrame = CFrame2:Lerp(u29, v32 * v32 * v32 * v32 * (v32 * (v32 * (v32 * -20 + 70) - 84) + 35));
        else
            workspace.CurrentCamera.CFrame = CFrame2;
        end;

        return nil;
    end);
    task.wait(LerpTime);
    game.ReplicatedStorage.Communication.CnC.ClientEffects:Fire("Appear_Effect", p25:GetPivot());
    Camera_Traffic_Handler[u1.CameraKey] = false;
end;

local function resetGate(p33: userdata) -- Line: 298
    if p33:GetAttribute("IsCF") then
        for _, child in p33:GetChildren() do
            local Attribute = child:GetAttribute("StartCF");

            if Attribute then
                child.CFrame = Attribute;
            end;
        end;

        return;
    end;

    local Attribute = p33:GetAttribute("GateStart");
    local Top = p33:FindFirstChild("Top");

    if Attribute and Top then
        Top.CFrame = Attribute;
    end;
end;

local function resetWorld() -- Line: 319
    -- upvalues: u1 (copy), resolveLevers (copy), resetGate (copy)
    for i in u1.Levers do
        local v34 = resolveLevers(i);

        if v34 ~= nil then
            local function _(p35) -- Line: 323
                local A_ = p35:FindFirstChild("A_");

                if not A_ then
                    return;
                end;

                A_:SetAttribute("On", false);
                local Attribute = A_:GetAttribute("StartPivot");

                if Attribute then
                    A_:PivotTo(Attribute);
                end;
            end;

            local Lever = v34.Lever;

            for _, v in typeof(Lever) == "Instance" and { Lever } or Lever do
                local A_ = v:FindFirstChild("A_");

                if A_ then
                    A_:SetAttribute("On", false);
                    local Attribute = A_:GetAttribute("StartPivot");

                    if Attribute then
                        A_:PivotTo(Attribute);
                    end;
                end;
            end;

            if v34.Gate then
                resetGate(v34.Gate);
            end;
        end;
    end;
end;

local function setupLevelObserver(u36: userdata) -- Line: 350
    -- upvalues: syncMarkers (copy), computeMarkers (copy), u9 (copy), resolveLevers (copy), u1 (copy), lever (copy), ParkourTraining (copy)
    local function onLevelChanged() -- Line: 351
        -- upvalues: syncMarkers (ref), computeMarkers (ref), u36 (copy), u9 (ref), resolveLevers (ref), u1 (ref), lever (ref)
        syncMarkers((computeMarkers(u36:GetAttribute("Level"), u36:GetAttribute("Checkpoint"))));
        local Attribute = u36:GetAttribute("Level");

        if not Attribute or Attribute % 1 ~= 0 then
            return;
        end;

        local v37 = Attribute - 2;

        if u36:GetAttribute("Checkpoint") < v37 then
            u36:SetAttribute("Checkpoint", v37);
        end;

        if Attribute == u9.currentSetupLevel then
            return;
        end;

        local v38 = resolveLevers(Attribute);

        if v38 == nil and u1.Levers[Attribute] ~= nil then
            u9.currentSetupLevel = nil;

            return;
        end;

        u9.currentSetupLevel = Attribute;
        local lastLevers = u9.lastLevers;

        for _, v in lastLevers do
            v:Destroy(true);
        end;

        table.clear(lastLevers);
        u9.lastLevers = u9.currentLevers;
        u9.currentLevers = {};

        if v38 == nil then
            return;
        end;

        local Lever = v38.Lever;
        local v39 = typeof(Lever) == "Instance" and { Lever } or Lever;
        local v40 = 1 / #v39;

        for i, v in v39 do
            local v41;

            if i == 1 then
                v41 = v38.Gate;
            else
                v41 = nil;
            end;

            table.insert(u9.currentLevers, lever(v, v41, u9.cleaner, u36, Attribute, v40));
        end;
    end;

    onLevelChanged();
    u9.cleaner:Connect(u36:GetAttributeChangedSignal("Level"), onLevelChanged);
    local Switchs = ParkourTraining:FindFirstChild("Switchs");

    if Switchs then
        u9.cleaner:Connect(Switchs.ChildAdded, onLevelChanged);
    end;

    local Gates = ParkourTraining:FindFirstChild("Gates");

    if Gates then
        u9.cleaner:Connect(Gates.ChildAdded, onLevelChanged);
    end;
end;

local function setupCheckpointObserver(u42: userdata) -- Line: 405
    -- upvalues: syncMarkers (copy), computeMarkers (copy), u9 (copy), u1 (copy), checkpoint (copy)
    local function onCheckpointChanged() -- Line: 406
        -- upvalues: syncMarkers (ref), computeMarkers (ref), u42 (copy), u9 (ref), u1 (ref), checkpoint (ref)
        syncMarkers((computeMarkers(u42:GetAttribute("Level"), u42:GetAttribute("Checkpoint"))));
        local Attribute = u42:GetAttribute("Checkpoint");

        if not Attribute then
            return;
        end;

        if u9.currentCheckpoint ~= nil then
            u9.currentCheckpoint:Destroy();
            u9.currentCheckpoint = nil;
        end;

        u9.currentCheckpoint = checkpoint(u1.MapRoot.Checkpoints:FindFirstChild("Checkpoint" .. Attribute), u42, u9.cleaner);
    end;

    onCheckpointChanged();
    u9.cleaner:Connect(u42:GetAttributeChangedSignal("Checkpoint"), onCheckpointChanged);
end;

local function setupKillBricks(u43: userdata, u44: userdata, u45: table, u46: table, u47: function) -- Line: 424
    -- upvalues: u1 (copy), u9 (copy), teleportBack (copy)
    local KillBricks = u1.MapRoot.KillBricks;

    local function handleBrick(p48) -- Line: 426
        -- upvalues: u9 (ref), u43 (copy), u45 (copy), u46 (copy), teleportBack (ref), u44 (copy), u47 (copy)
        p48.Transparency = 1;
        u9.cleaner:Connect(p48.Touched, function(p49) -- Line: 428
            -- upvalues: u43 (ref), u9 (ref), u45 (ref), u46 (ref), teleportBack (ref), u44 (ref), u47 (ref)
            if p49 == nil or not p49:IsDescendantOf(u43) then
                return;
            end;

            if u9.debounce then
                return;
            end;

            u9.debounce = true;
            u45[u46.value]:Set(false);
            local v50 = u46;
            v50.value = v50.value - 1;
            teleportBack(u43, u44:GetAttribute("Checkpoint"));

            if u46.value == 0 then
                u47();

                return;
            end;

            u9.debounce = false;
        end);
    end;

    for _, child in KillBricks:GetChildren() do
        child.Transparency = 1;
        u9.cleaner:Connect(child.Touched, function(p51) -- Line: 428
            -- upvalues: u43 (copy), u9 (ref), u45 (copy), u46 (copy), teleportBack (ref), u44 (copy), u47 (copy)
            if p51 == nil or not p51:IsDescendantOf(u43) then
                return;
            end;

            if u9.debounce then
                return;
            end;

            u9.debounce = true;
            u45[u46.value]:Set(false);
            local v52 = u46;
            v52.value = v52.value - 1;
            teleportBack(u43, u44:GetAttribute("Checkpoint"));

            if u46.value == 0 then
                u47();

                return;
            end;

            u9.debounce = false;
        end);
    end;

    u9.cleaner:Add(KillBricks.ChildAdded:Connect(handleBrick));
end;

local function setupDroppers(u53: userdata) -- Line: 453
    -- upvalues: ParkourTraining (copy), u1 (copy), dropper (copy), u9 (copy)
    local v54 = ParkourTraining:FindFirstChild(u1.DroppersFolderName);

    if v54 == nil then
        return;
    end;

    local function handleDropper(p55) -- Line: 456
        -- upvalues: dropper (ref), u9 (ref), u53 (copy)
        if not p55:IsA("Model") then
            return;
        end;

        local v56 = dropper(p55, u9.cleaner, u53);

        if v56 then
            table.insert(u9.droppers, v56);
        end;
    end;

    for _, child in v54:GetChildren() do
        if child:IsA("Model") then
            local v57 = dropper(child, u9.cleaner, u53);

            if v57 then
                table.insert(u9.droppers, v57);
            end;
        end;
    end;

    u9.cleaner:Add(v54.ChildAdded:Connect(handleDropper));
end;

local function setupFinal(u58: userdata, u59: function) -- Line: 471
    -- upvalues: u9 (copy), u1 (copy)
    local function bind(p60: userdata) -- Line: 472
        -- upvalues: u9 (ref), u58 (copy), u1 (ref), u59 (copy)
        if not p60:IsA("BasePart") then
            return;
        end;

        u9.cleaner:Connect(p60.Touched, function(p61) -- Line: 474
            -- upvalues: u58 (ref), u9 (ref), u1 (ref), u59 (ref)
            if p61 == nil or not p61:IsDescendantOf(u58) then
                return;
            end;

            if u9.debounce then
                return;
            end;

            u9.debounce = true;
            task.delay(u1.FinishSettle, u59);
        end);
    end;

    local Final = u1.MapRoot:FindFirstChild("Final");

    if Final and Final:IsA("BasePart") then
        u9.cleaner:Connect(Final.Touched, function(p62) -- Line: 474
            -- upvalues: u58 (copy), u9 (ref), u1 (ref), u59 (copy)
            if p62 == nil or not p62:IsDescendantOf(u58) then
                return;
            end;

            if u9.debounce then
                return;
            end;

            u9.debounce = true;
            task.delay(u1.FinishSettle, u59);
        end);
    end;

    u9.cleaner:Connect(u1.MapRoot.ChildAdded, function(p63) -- Line: 485
        -- upvalues: u9 (ref), u58 (copy), u1 (ref), u59 (copy)
        if p63.Name == "Final" then
            if not p63:IsA("BasePart") then
                return;
            end;

            u9.cleaner:Connect(p63.Touched, function(p64) -- Line: 474
                -- upvalues: u58 (ref), u9 (ref), u1 (ref), u59 (ref)
                if p64 == nil or not p64:IsDescendantOf(u58) then
                    return;
                end;

                if u9.debounce then
                    return;
                end;

                u9.debounce = true;
                task.delay(u1.FinishSettle, u59);
            end);
        end;
    end);
end;

return {
    Do = function(p65: userdata, p66: userdata, u67: userdata) -- Line: 500, Name: Do
        -- upvalues: u9 (copy), WipeTransition (copy), cleanit (copy), setupLevelObserver (copy), syncMarkers (copy), computeMarkers (copy), u1 (copy), checkpoint (copy), SignalEvent (copy), ParkourTrainingUI (copy), Utility (copy), setupKillBricks (copy), setupDroppers (copy), setupFinal (copy)
        local math_random_ret = math.random();
        u9.id = math_random_ret;

        if p66 then
            u9.preTrainingCFrame = p66:GetPivot();
        end;

        local v68 = {
            Switch = false
        };
        WipeTransition(v68);
        u67:SetAttribute("Level", 1);
        u67:SetAttribute("Checkpoint", 1);
        u9.cleaner = cleanit.new();
        setupLevelObserver(u67);

        local function v69() -- Line: 406
            -- upvalues: syncMarkers (ref), computeMarkers (ref), u67 (copy), u9 (ref), u1 (ref), checkpoint (ref)
            syncMarkers((computeMarkers(u67:GetAttribute("Level"), u67:GetAttribute("Checkpoint"))));
            local Attribute = u67:GetAttribute("Checkpoint");

            if not Attribute then
                return;
            end;

            if u9.currentCheckpoint ~= nil then
                u9.currentCheckpoint:Destroy();
                u9.currentCheckpoint = nil;
            end;

            u9.currentCheckpoint = checkpoint(u1.MapRoot.Checkpoints:FindFirstChild("Checkpoint" .. Attribute), u67, u9.cleaner);
        end;

        v69();
        u9.cleaner:Connect(u67:GetAttributeChangedSignal("Checkpoint"), v69);
        task.wait(u1.TransitionWait);

        if u9.id ~= math_random_ret then
            return;
        end;

        local function Leave() -- Line: 524
            -- upvalues: u9 (ref), math_random_ret (copy), SignalEvent (ref)
            if u9.id ~= math_random_ret then
                return;
            end;

            SignalEvent.ToServer("training_signaler", "Stop");
        end;

        local v70, v71, v72 = ParkourTrainingUI(p65.PlayerGui.ComponentsHolder, Leave);
        u9.currentThread = v70;
        local v73 = {
            value = v72
        };

        if not Utility.StreamingEnabledTeleport(u1.InitialTpLocation) then
            if u9.id ~= math_random_ret then
                return;
            end;

            SignalEvent.ToServer("training_signaler", "Stop");

            return;
        end;

        if u9.id ~= math_random_ret then
            return;
        end;

        v68.Switch = true;
        task.wait(0.25);

        if u9.id ~= math_random_ret then
            return;
        end;

        setupKillBricks(p66, u67, v71, v73, Leave);
        setupDroppers(p66);
        setupFinal(p66, Leave);
    end,

    Stop = function(p74: userdata, p75: userdata, p76: userdata) -- Line: 552, Name: Stop
        -- upvalues: u9 (copy), WipeTransition (copy), u1 (copy), resetWorld (copy), MarkerHandler (copy), Camera_Traffic_Handler (copy), Utility (copy)
        u9.id = 0;
        u9.debounce = false;
        local v77 = {
            Switch = false
        };
        WipeTransition(v77);

        if u9.currentThread ~= nil then
            u9.currentThread();
            u9.currentThread = nil;
        end;

        task.wait(u1.TransitionWait);
        local currentLevers = u9.currentLevers;

        for _, v in currentLevers do
            v:Destroy(nil);
        end;

        table.clear(currentLevers);
        local lastLevers = u9.lastLevers;

        for _, v in lastLevers do
            v:Destroy(nil);
        end;

        table.clear(lastLevers);
        local droppers = u9.droppers;

        for _, v in droppers do
            v:Destroy(nil);
        end;

        table.clear(droppers);
        u9.currentSetupLevel = nil;
        resetWorld();

        for i in u9.activeMarkers do
            MarkerHandler.removeMarker(i);
        end;

        table.clear(u9.activeMarkers);

        if u9.currentCheckpoint ~= nil then
            u9.currentCheckpoint:Destroy();
            u9.currentCheckpoint = nil;
        end;

        if u9.cleaner ~= nil then
            u9.cleaner:Destroy();
            u9.cleaner = nil;
        end;

        Camera_Traffic_Handler[u1.CameraKey] = false;

        if u9.preTrainingCFrame and p75 then
            Utility.StreamingEnabledTeleport(u9.preTrainingCFrame);
        end;

        u9.preTrainingCFrame = nil;
        v77.Switch = true;
    end
};