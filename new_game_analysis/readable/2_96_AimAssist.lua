-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local CollectionService = game:GetService("CollectionService");
local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Allegiance = require(ReplicatedStorage.CAM.Global.Allegiance);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local SequenceTeleport = require(ReplicatedStorage.CAM.Client.Modules.SequenceTeleport);
local PlayerProfile = require(ReplicatedStorage.CAM.Global.PlayerProfile);
local CameraInput = require(script.Parent.Parent.PlayerModule.CameraModule.CameraInput);

if type(CameraInput.addRotation) ~= "function" then
    warn("[AimAssist] the running PlayerModule is not the game\'s own (no CameraInput.addRotation): aim assist off. Is PlayerModule under StarterPlayerScripts in this place?");

    return;
end;

local HUD = ReplicatedStorage.CAM.Client.Components.Layout.Visibility.HUD;
local Humanoids = workspace:FindFirstChild("Humanoids");
local LocalPlayer = Players.LocalPlayer;

local function config() -- Line: 77
    -- upvalues: gameSettings (copy)
    return gameSettings.AimAssist;
end;

local u1 = DataValue.new(SettingsKeys.AimAssist.Path, SettingsKeys.AimAssist.Default, SettingsKeys.Scope);
local u2 = DataValue.new(SettingsKeys.AimAssistCombat.Path, SettingsKeys.AimAssistCombat.Default, SettingsKeys.Scope);

local function platformStrength() -- Line: 95
    -- upvalues: gameSettings (copy), Platform_Handler (copy)
    local PlatformStrength = gameSettings.AimAssist.PlatformStrength;
    local v3 = Platform_Handler.IsGamepad() and "Console" or Platform_Handler.Platform.Value;
    local v4;

    if PlatformStrength == nil then
        v4 = nil;
    else
        v4 = tonumber(PlatformStrength[v3]);
    end;

    return v4 == nil and 1 or math.max(v4, 0);
end;

local function platformRadius() -- Line: 107
    -- upvalues: gameSettings (copy), Platform_Handler (copy)
    local PlatformRadius = gameSettings.AimAssist.PlatformRadius;
    local v5 = Platform_Handler.IsGamepad() and "Console" or Platform_Handler.Platform.Value;
    local v6;

    if PlatformRadius == nil then
        v6 = nil;
    else
        v6 = tonumber(PlatformRadius[v5]);
    end;

    return v6 == nil and 1 or math.max(v6, 0);
end;

local function userStrength() -- Line: 124
    -- upvalues: InCombat (copy), LocalPlayer (copy), u2 (copy), u1 (copy), SettingsKeys (copy), gameSettings (copy), Platform_Handler (copy)
    local v7 = InCombat.RegularIncludeAI(LocalPlayer.Character);
    local v8;

    if v7 then
        v8 = u2;
    else
        v8 = u1;
    end;

    local v9;

    if v7 then
        v9 = SettingsKeys.AimAssistCombat.Default;
    else
        v9 = SettingsKeys.AimAssist.Default;
    end;

    local v10 = tonumber(v8:Get());

    if v10 ~= nil then
        v9 = math.clamp(v10, 0, 1);
    end;

    local PlatformStrength = gameSettings.AimAssist.PlatformStrength;
    local v11 = Platform_Handler.IsGamepad() and "Console" or Platform_Handler.Platform.Value;
    local v12;

    if PlatformStrength == nil then
        v12 = nil;
    else
        v12 = tonumber(PlatformStrength[v11]);
    end;

    return v9 * (v12 == nil and 1 or math.max(v12, 0));
end;

local u13 = {};
local u14 = nil;

local function Removed(p15: userdata) -- Line: 143
    -- upvalues: u13 (copy), u14 (ref)
    u13[p15] = nil;

    if u14 == p15 then
        u14 = nil;
    end;
end;

local function Added(p16: userdata) -- Line: 138
    -- upvalues: u13 (copy)
    if p16:IsA("Model") then
        u13[p16] = true;
    end;
end;

for _, v in CollectionService:GetTagged("Humanoids") do
    if v:IsA("Model") then
        u13[v] = true;
    end;
end;

local u17 = CollectionService:GetInstanceAddedSignal("Humanoids"):Connect(Added);
local u18 = CollectionService:GetInstanceRemovedSignal("Humanoids"):Connect(Removed);
local u19 = nil;
local u20 = true;

local function shutdown(p21: string) -- Line: 164
    -- upvalues: u20 (ref), u14 (ref), Platform_Handler (copy), u19 (ref), RunService (copy), u17 (copy), u18 (copy)
    if not u20 then
        return;
    end;

    u20 = false;
    u14 = nil;
    Platform_Handler.SetAimLock(false);

    if u19 ~= nil then
        u19:Disconnect();
    end;

    RunService:UnbindFromRenderStep("AimAssist");
    u17:Disconnect();
    u18:Disconnect();
    warn((`[AimAssist] {p21} errored (the error above); the aim assist is off until the next join`));
end;

local u22 = false;

local function refreshPlatform() -- Line: 180
    -- upvalues: u22 (ref), Platform_Handler (copy)
    u22 = Platform_Handler.Platform.Value == "Mobile" and true or Platform_Handler.IsGamepad();
end;

u22 = Platform_Handler.Platform.Value == "Mobile" and true or Platform_Handler.IsGamepad();
Platform_Handler.Platform.Changed.Event:Connect(refreshPlatform);
local u23 = false;

local function refreshTool() -- Line: 197
    -- upvalues: Character_info_provider (copy), LocalPlayer (copy), u23 (ref), gameSettings (copy)
    local _equipped_tool = Character_info_provider.Get_equipped_tool(LocalPlayer);
    local v24;

    if _equipped_tool == nil then
        v24 = false;
    else
        v24 = gameSettings.AimAssist.DisabledForTools[_equipped_tool.Name] == true;
    end;

    u23 = v24;
end;

task.spawn(function() -- Line: 201
    -- upvalues: LocalPlayer (copy), refreshTool (copy), Character_info_provider (copy), u23 (ref), gameSettings (copy)
    local Items_Config = LocalPlayer:WaitForChild("Items_Config", 60);
    local v25;

    if Items_Config == nil then
        v25 = nil;
    else
        v25 = Items_Config:WaitForChild("Equipped", 60);
    end;

    if v25 == nil then
        return;
    end;

    v25.Changed:Connect(refreshTool);
    local _equipped_tool = Character_info_provider.Get_equipped_tool(LocalPlayer);
    local v26;

    if _equipped_tool == nil then
        v26 = false;
    else
        v26 = gameSettings.AimAssist.DisabledForTools[_equipped_tool.Name] == true;
    end;

    u23 = v26;
end);

local function assistAllowed() -- Line: 212
    -- upvalues: gameSettings (copy), u22 (ref), userStrength (copy), Camera_Traffic_Handler (copy), HUD (copy), LocalPlayer (copy), SequenceTeleport (copy), u23 (ref)
    if gameSettings.AimAssist.Enabled ~= true or (not u22 or userStrength() <= 0) then
        return nil;
    end;

    if Camera_Traffic_Handler.Equipped_Hirearchy ~= "" then
        return nil;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera == nil or workspace_CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        return nil;
    end;

    if HUD.Value ~= true then
        return nil;
    end;

    if LocalPlayer:GetAttribute("Spectating") == true then
        return nil;
    end;

    if SequenceTeleport.IsActive() then
        return nil;
    end;

    if LocalPlayer:GetAttribute("LoadingScreen") == true then
        return nil;
    end;

    if u23 then
        return nil;
    end;

    local Character = LocalPlayer.Character;

    if Character == nil or Character.Parent == nil then
        return nil;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v27 = Character:FindFirstChildOfClass("Humanoid");

    if HumanoidRootPart == nil or (v27 == nil or v27.Health <= 0) then
        return nil;
    end;

    return Character, HumanoidRootPart, v27;
end;

local function toScreen(p28: userdata, p29: vector) -- Line: 237
    -- upvalues: GuiService (copy)
    local v30, v31 = p28:WorldToViewportPoint(p29);
    local GuiInset = GuiService:GetGuiInset();
    local Vector2_new_ret = Vector2.new(v30.X - GuiInset.X, v30.Y - GuiInset.Y);

    if v31 then
        v31 = v30.Z > 0;
    end;

    return Vector2_new_ret, v31;
end;

local function attackerOf(p32: userdata) -- Line: 250
    -- upvalues: gameSettings (copy), Utility (copy), u13 (copy), Humanoids (ref)
    local AimAssist = gameSettings.AimAssist;
    local valuesfolder = Utility.getvaluesfolder(p32);
    local v33;

    if valuesfolder == nil then
        v33 = nil;
    else
        v33 = valuesfolder:FindFirstChild("DMG");
    end;

    if v33 == nil then
        return nil;
    end;

    local v34 = tonumber(v33:GetAttribute("LastAttacked")) or 0;

    if v34 <= (tonumber(v33:GetAttribute("LastEngaged")) or 0) then
        return nil;
    end;

    if Utility.Tick() - v34 > AimAssist.AttackedMemory then
        return nil;
    end;

    local Attribute = v33:GetAttribute("LastAttacker");

    if type(Attribute) ~= "string" or (Attribute == "" or Attribute == p32.Name) then
        return nil;
    end;

    for i in u13 do
        if i.Name == Attribute and (i ~= p32 and (i.Parent ~= nil and (Humanoids ~= nil and i:IsDescendantOf(Humanoids)))) then
            local HumanoidRootPart = i:FindFirstChild("HumanoidRootPart");
            local v35 = i:FindFirstChildOfClass("Humanoid");

            if HumanoidRootPart ~= nil and (v35 ~= nil and v35.Health > 0) then
                return i;
            end;
        end;
    end;

    return nil;
end;

local function scan() -- Line: 275
    -- upvalues: assistAllowed (copy), u14 (ref), Humanoids (ref), attackerOf (copy), Platform_Handler (copy), CameraInput (copy), gameSettings (copy), GuiService (copy), Utility (copy), u13 (copy), Players (copy), LocalPlayer (copy), Checker (copy), Allegiance (copy)
    local v36, v37 = assistAllowed();

    if v36 == nil or v37 == nil then
        u14 = nil;

        return;
    end;

    if Humanoids == nil or Humanoids.Parent == nil then
        Humanoids = workspace:FindFirstChild("Humanoids");
    end;

    local v38 = attackerOf(v36);

    if v38 ~= nil then
        u14 = v38;

        return;
    end;

    if not Platform_Handler.HoldingSkill() and CameraInput.getRotationActivated() then
        u14 = nil;

        return;
    end;

    local AimAssist = gameSettings.AimAssist;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame = workspace_CurrentCamera.CFrame;
    local v39 = workspace_CurrentCamera.ViewportSize.Y - GuiService:GetGuiInset().Y;
    local PlatformRadius = gameSettings.AimAssist.PlatformRadius;
    local v40 = Platform_Handler.IsGamepad() and "Console" or Platform_Handler.Platform.Value;
    local v41;

    if PlatformRadius == nil then
        v41 = nil;
    else
        v41 = tonumber(PlatformRadius[v40]);
    end;

    local v42 = v41 == nil and 1 or math.max(v41, 0);
    local v43 = Platform_Handler.AimPoint();
    local v44 = Utility.Tick();
    local v45 = (1 / 0);
    local v46 = (1 / 0);
    local v47 = nil;
    local v48 = nil;
    local v49 = nil;
    local v50 = false;

    for i in u13 do
        if i ~= v36 and (i.Parent ~= nil and (Humanoids ~= nil and (i:IsDescendantOf(Humanoids) and Players:GetPlayerFromCharacter(i) ~= LocalPlayer))) then
            local Attribute = v36:GetAttribute("partyId");

            if Attribute == nil or (Attribute == "" or i:GetAttribute("partyId") ~= Attribute) then
                local HumanoidRootPart = i:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                    local v51 = i:FindFirstChildOfClass("Humanoid");

                    if v51 ~= nil and (v51.Health > 0 and vector.magnitude(HumanoidRootPart.Position - v37.Position) <= AimAssist.Range) then
                        local v52 = HumanoidRootPart.Position - CFrame.Position;

                        if vector.magnitude(v52) >= 0.05 then
                            local LookVector = CFrame.LookVector;
                            local vector_normalize_ret = vector.normalize(v52);

                            if vector.dot(LookVector, vector_normalize_ret) >= AimAssist.MinFacingDot then
                                local v53, v54 = workspace_CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position);
                                local GuiInset = GuiService:GetGuiInset();
                                local Vector2_new_ret = Vector2.new(v53.X - GuiInset.X, v53.Y - GuiInset.Y);

                                if v54 then
                                    v54 = v53.Z > 0;
                                end;

                                if v54 then
                                    local Magnitude = (Vector2_new_ret - v43).Magnitude;
                                    local v55;

                                    if i == u14 then
                                        v55 = AimAssist.HoldRadius;
                                    else
                                        v55 = AimAssist.CaptureRadius;
                                    end;

                                    if v55 * v39 * v42 >= Magnitude and (Checker.check_can_select(script, v36, i) == true and not Allegiance.SameOwner(v36, i)) then
                                        local valuesfolder = Utility.getvaluesfolder(i);

                                        if not (AimAssist.SkipRagdolled and (valuesfolder ~= nil and valuesfolder:FindFirstChild("RagDoll") ~= nil)) then
                                            local v56;

                                            if valuesfolder == nil then
                                                v56 = nil;
                                            else
                                                v56 = valuesfolder:FindFirstChild("DMG");
                                            end;

                                            if v56 ~= nil and (v56:GetAttribute("LastAttacker") == LocalPlayer.Name and v44 - (tonumber(v56:GetAttribute("LastAttacked")) or 0) <= AimAssist.ComboMemory) then
                                                v50 = i == u14 and true or v50;

                                                if Magnitude < v45 then
                                                    v47 = i;
                                                    v45 = Magnitude;
                                                end;
                                            end;

                                            if i == u14 then
                                                v48 = Magnitude;
                                            end;

                                            if Magnitude < v46 then
                                                v49 = i;
                                                v46 = Magnitude;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    if v47 ~= nil then
        if not v50 or v48 == nil then
            u14 = v47;
        end;

        return;
    end;

    if v48 ~= nil and (v49 == u14 or v48 * AimAssist.SwitchRatio < v46) then
        return;
    end;

    u14 = v49;
end;

local u57 = 0;
local u58 = true;
u19 = RunService.Heartbeat:Connect(function(p59: number) -- Line: 373
    -- upvalues: u58 (ref), shutdown (copy), u57 (ref), gameSettings (copy), scan (copy)
    if not u58 then
        shutdown("the target scan");

        return;
    end;

    u57 = u57 + p59;

    if u57 < gameSettings.AimAssist.Refresh then
        return;
    end;

    u57 = 0;
    u58 = false;
    scan();
    u58 = true;
end);

local function skillFollowUp(p60: userdata) -- Line: 391
    -- upvalues: gameSettings (copy), PlayerProfile (copy), Utility (copy), LocalPlayer (copy)
    local AimAssist = gameSettings.AimAssist;

    if os.clock() - (PlayerProfile.lastperformedaskill or 0) > AimAssist.SkillHitMemory then
        return false;
    end;

    local valuesfolder = Utility.getvaluesfolder(p60);
    local v61;

    if valuesfolder == nil then
        v61 = nil;
    else
        v61 = valuesfolder:FindFirstChild("DMG");
    end;

    local v62;

    if v61 == nil or v61:GetAttribute("LastAttacker") ~= LocalPlayer.Name then
        v62 = false;
    else
        v62 = Utility.Tick() - (tonumber(v61:GetAttribute("LastAttacked")) or 0) <= AimAssist.SkillHitMemory;
    end;

    return v62;
end;

local function step(p63: number) -- Line: 400
    -- upvalues: u14 (ref), gameSettings (copy), Platform_Handler (copy), assistAllowed (copy), attackerOf (copy), skillFollowUp (copy), CameraInput (copy), userStrength (copy), Humanoids (ref), GuiService (copy)
    local v64 = u14;
    local AimAssist = gameSettings.AimAssist;
    local v65 = p63 * 60;
    local v66 = Platform_Handler.IsGamepad();
    local v67 = assistAllowed();
    local v68;

    if v64 == nil or v67 == nil then
        v68 = false;
    else
        v68 = attackerOf(v67) == v64;
    end;

    if v64 ~= nil and not (v68 or (Platform_Handler.HoldingSkill() or (skillFollowUp(v64) or not CameraInput.getRotationActivated()))) then
        u14 = nil;
        v64 = nil;
    end;

    if v64 == nil then
        Platform_Handler.SetAimLock(false);

        if v66 then
            local v69 = Platform_Handler.AimCentre() - Platform_Handler.AimPoint();

            if v69.Magnitude > AimAssist.CursorDeadZone then
                local v70 = AimAssist.CursorStrength * userStrength();
                local math_min_ret = math.min(v70, AimAssist.MaxStrength);
                Platform_Handler.NudgeAim(v69 * (1 - (1 - math_min_ret) ^ v65));
            end;
        end;

        return;
    end;

    local v71 = assistAllowed();

    if v71 == nil then
        u14 = nil;

        return;
    end;

    if Humanoids == nil or not v64:IsDescendantOf(Humanoids) then
        u14 = nil;

        return;
    end;

    local HumanoidRootPart = v64:FindFirstChild("HumanoidRootPart");
    local v72 = v64:FindFirstChildOfClass("Humanoid");

    if v64.Parent == nil or (HumanoidRootPart == nil or not (HumanoidRootPart:IsA("BasePart") and (v72 ~= nil and v72.Health > 0))) then
        u14 = nil;

        return;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame = workspace_CurrentCamera.CFrame;
    local v73 = HumanoidRootPart.Position - CFrame.Position;

    if vector.magnitude(v73) < 0.05 then
        return;
    end;

    local vector_normalize_ret = vector.normalize(v73);
    local LookVector = CFrame.LookVector;

    if not v68 and vector.dot(LookVector, vector_normalize_ret) < AimAssist.MinFacingDot then
        u14 = nil;

        return;
    end;

    local v74, v75 = workspace_CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position);
    local GuiInset = GuiService:GetGuiInset();
    local Vector2_new_ret = Vector2.new(v74.X - GuiInset.X, v74.Y - GuiInset.Y);

    if v75 then
        v75 = v74.Z > 0;
    end;

    if not (v68 or v75) then
        u14 = nil;

        return;
    end;

    local v76 = Platform_Handler.HoldingSkill() or (v68 or skillFollowUp(v64));
    local HumanoidRootPart2 = v71:FindFirstChild("HumanoidRootPart");
    local v77 = (HumanoidRootPart2 == nil or not HumanoidRootPart2:IsA("BasePart")) and (1 / 0) or vector.magnitude(HumanoidRootPart.Position - HumanoidRootPart2.Position);
    local u78 = v77 >= (1 / 0) and 0 or 1 - math.clamp(v77 / AimAssist.Range, 0, 1);

    local function scaled(p79: number) -- Line: 476
        -- upvalues: AimAssist (copy), u78 (copy)
        return math.min(p79 + (AimAssist.MaxStrength - p79) * u78, AimAssist.MaxStrength);
    end;

    local v80 = userStrength();
    local v81;

    if v76 then
        local HoldingStrength = AimAssist.HoldingStrength;
        v81 = math.min(HoldingStrength + (AimAssist.MaxStrength - HoldingStrength) * u78, AimAssist.MaxStrength);
    else
        local CameraStrength = AimAssist.CameraStrength;
        v81 = math.min(CameraStrength + (AimAssist.MaxStrength - CameraStrength) * u78, AimAssist.MaxStrength) * v80;
    end;

    local math_min_ret = math.min(v81, AimAssist.MaxStrength);

    if not v76 and CameraInput.getRotationActivated() then
        math_min_ret = math_min_ret * AimAssist.SteeringFactor;
    end;

    local u82 = 1 - (1 - math_min_ret) ^ v65;
    local v83;

    if v76 then
        v83 = AimAssist.HoldingMaxYawPerFrame;
    else
        v83 = AimAssist.MaxYawPerFrame;
    end;

    local v84;

    if v76 then
        v84 = AimAssist.HoldingMaxPitchPerFrame;
    else
        v84 = AimAssist.MaxPitchPerFrame;
    end;

    local RightVector = CFrame.RightVector;
    local vector_create_ret = vector.create(LookVector.X, 0, LookVector.Z);
    local vector_create_ret2 = vector.create(RightVector.X, 0, RightVector.Z);
    local vector_create_ret3 = vector.create(vector_normalize_ret.X, 0, vector_normalize_ret.Z);
    local v85;

    if vector.magnitude(vector_create_ret) > 0.001 and vector.magnitude(vector_create_ret3) > 0.001 then
        local vector_normalize_ret2 = vector.normalize(vector_create_ret2);
        local vector_dot_ret = vector.dot(vector_create_ret3, vector_normalize_ret2);
        local vector_normalize_ret3 = vector.normalize(vector_create_ret);
        local vector_dot_ret2 = vector.dot(vector_create_ret3, vector_normalize_ret3);
        v85 = math.atan2(vector_dot_ret, vector_dot_ret2);
    else
        v85 = 0;
    end;

    local math_clamp_ret = math.clamp(LookVector.Y, -1, 1);
    local math_asin_ret = math.asin(math_clamp_ret);
    local math_clamp_ret2 = math.clamp(vector_normalize_ret.Y, -1, 1);
    local v86 = math_asin_ret - math.asin(math_clamp_ret2);

    local function shape(p87: number, p88: number) -- Line: 503
        -- upvalues: AimAssist (copy), u82 (copy)
        return math.abs(p87) < AimAssist.AngleDeadZone and 0 or math.clamp(p87 * u82, -p88, p88);
    end;

    local Vector2_new_ret2 = Vector2.new(math.abs(v85) < AimAssist.AngleDeadZone and 0 or math.clamp(v85 * u82, -v83, v83), math.abs(v86) < AimAssist.AngleDeadZone and 0 or math.clamp(v86 * u82, -v84, v84));

    if Vector2_new_ret2 ~= Vector2.zero then
        CameraInput.addRotation(Vector2_new_ret2);
    end;

    if v66 then
        Platform_Handler.SetAimLock(true);
    end;

    if v66 or Platform_Handler.AimActive() then
        local v89 = Vector2_new_ret - Platform_Handler.AimPoint();

        if v89.Magnitude > AimAssist.CursorDeadZone then
            local v90;

            if v76 then
                local HoldingStrength = AimAssist.HoldingStrength;
                v90 = math.min(HoldingStrength + (AimAssist.MaxStrength - HoldingStrength) * u78, AimAssist.MaxStrength);
            else
                local CursorStrength = AimAssist.CursorStrength;
                v90 = math.min(CursorStrength + (AimAssist.MaxStrength - CursorStrength) * u78, AimAssist.MaxStrength) * v80;
            end;

            local v91 = v89 * (1 - (1 - math.min(v90, AimAssist.MaxStrength)) ^ v65);

            if v91.Magnitude > AimAssist.MaxCursorPerFrame then
                v91 = v91.Unit * AimAssist.MaxCursorPerFrame;
            end;

            Platform_Handler.NudgeAim(v91);
        end;
    end;
end;

local u92 = true;
RunService:BindToRenderStep("AimAssist", Enum.RenderPriority.Camera.Value - 1, function(p93: number) -- Line: 536
    -- upvalues: u92 (ref), shutdown (copy), step (copy)
    if not u92 then
        shutdown("the per frame step");

        return;
    end;

    u92 = false;
    step(p93);
    u92 = true;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 548
    -- upvalues: u14 (ref)
    u14 = nil;
end);
LocalPlayer.CharacterRemoving:Connect(function() -- Line: 551
    -- upvalues: u14 (ref)
    u14 = nil;
end);