-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local LocalPlayer = game.Players.LocalPlayer;
local u1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local HumanoidRootPart = u1:WaitForChild("HumanoidRootPart");
local Humanoid = u1:WaitForChild("Humanoid");
local u2 = game.ReplicatedStorage.Player_Service:WaitForChild("Values"):WaitForChild(LocalPlayer.Name);
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local os_clock = os.clock;
local Run_Handler = require(game.ReplicatedStorage.CAM:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Run_Handler"));
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
local v3 = false;
Humanoid:WaitForChild("Animator");
local cleanit = require(game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("cleanit"));
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local PlayerProfile = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("PlayerProfile"));
local manage_cd = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("manage_cd"));
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local Dialogue = ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Components"):WaitForChild("Layout"):WaitForChild("Visibility"):WaitForChild("Dialogue");

local function menuOpened() -- Line: 37
    -- upvalues: LocalPlayer (copy)
    local MenuDestination = LocalPlayer:FindFirstChild("MenuDestination");
    local v4;

    if MenuDestination == nil then
        v4 = false;
    else
        v4 = MenuDestination.Value ~= "";
    end;

    return v4;
end;

local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local TweenInfo_new_ret = TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true, 0);
local Color3_fromRGB_ret = Color3.fromRGB(200, 120, 120);
local TweenInfo_new_ret2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u5 = nil;
local u6 = nil;

local function lowHealthCorrection() -- Line: 59
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local LowHealthColorCorrection = workspace_CurrentCamera:FindFirstChild("LowHealthColorCorrection");

    if LowHealthColorCorrection == nil or not LowHealthColorCorrection:IsA("ColorCorrectionEffect") then
        LowHealthColorCorrection = Instance.new("ColorCorrectionEffect");
        LowHealthColorCorrection.Name = "LowHealthColorCorrection";
        LowHealthColorCorrection.TintColor = Color3.new(1, 1, 1);
        LowHealthColorCorrection.Parent = workspace_CurrentCamera;
    end;

    return LowHealthColorCorrection;
end;

local LowHealthColorCorrection = workspace.CurrentCamera:FindFirstChild("LowHealthColorCorrection");

if LowHealthColorCorrection ~= nil then
    LowHealthColorCorrection:Destroy();
end;

local u7 = false;
local u8 = nil;
local u9 = nil;

local function setLowHealth(p10: boolean) -- Line: 83
    -- upvalues: u7 (ref), lowHealthCorrection (copy), u8 (ref), TweenService (copy), TweenInfo_new_ret (copy), Color3_fromRGB_ret (copy), u5 (ref), u6 (ref), TweenInfo_new_ret2 (copy), Character_info_provider (copy), LocalPlayer (copy), Humanoid (copy), u9 (ref)
    if u7 == p10 then
        return;
    end;

    u7 = p10;
    local v11 = lowHealthCorrection();
    local HeartBeat = script:FindFirstChild("HeartBeat");

    if p10 then
        u8 = TweenService:Create(v11, TweenInfo_new_ret, {
            TintColor = Color3_fromRGB_ret
        });
        u8:Play();

        if HeartBeat ~= nil and HeartBeat:IsA("Sound") then
            if u5 == nil then
                u5 = HeartBeat.Volume * 0.5;
            end;

            if u6 ~= nil then
                u6:Cancel();
            end;

            if not HeartBeat.IsPlaying then
                HeartBeat.Volume = 0;
                HeartBeat:Play();
            end;

            u6 = TweenService:Create(HeartBeat, TweenInfo_new_ret2, {
                Volume = u5
            });
            u6:Play();
        end;

        local _core_anim = Character_info_provider.get_core_anim(LocalPlayer, "Low_Hp");
        local v12 = Humanoid:FindFirstChildOfClass("Animator");

        if _core_anim ~= nil and v12 ~= nil then
            u9 = v12:LoadAnimation(_core_anim);
            u9:Play();
        end;
    else
        if u8 ~= nil then
            u8:Cancel();
            u8 = nil;
        end;

        v11.TintColor = Color3.new(1, 1, 1);

        if HeartBeat ~= nil and HeartBeat:IsA("Sound") then
            if u6 ~= nil then
                u6:Cancel();
            end;

            u6 = TweenService:Create(HeartBeat, TweenInfo_new_ret2, {
                Volume = 0
            });
            u6.Completed:Once(function(p13) -- Line: 116
                -- upvalues: u7 (ref), HeartBeat (copy), u5 (ref)
                if p13 == Enum.PlaybackState.Completed and not u7 then
                    HeartBeat:Stop();

                    if u5 ~= nil then
                        HeartBeat.Volume = u5;
                    end;
                end;
            end);
            u6:Play();
        end;

        if u9 ~= nil then
            u9:Stop();
            u9 = nil;
        end;
    end;
end;

script.Destroying:Once(function() -- Line: 133
    -- upvalues: u8 (ref)
    if u8 ~= nil then
        u8:Cancel();
    end;
end);
local CollectionService = game:GetService("CollectionService");

local function isInWater() -- Line: 145
    -- upvalues: LocalPlayer (copy), u1 (copy), CollectionService (copy)
    local v14 = LocalPlayer.Character or u1;
    local v15;

    if v14 then
        v15 = v14:FindFirstChild("HumanoidRootPart");
    else
        v15 = v14;
    end;

    if v14 then
        local Attribute = v14:GetAttribute("SwimState");

        if typeof(Attribute) == "number" and Attribute > 0 then
            return true;
        end;
    end;

    if v15 == nil then
        return false;
    end;

    local Position = v15.Position;

    for _, v in CollectionService:GetTagged("SwimParts") do
        if v:IsA("BasePart") then
            local v16 = v.CFrame:PointToObjectSpace(Position);
            local v17 = v.Size / 2;

            if math.abs(v16.X) <= v17.X and (math.abs(v16.Z) <= v17.Z and v16.Y <= v17.Y) then
                return true;
            end;
        end;
    end;

    return false;
end;

local u18 = 0;
local u19 = 0;
Humanoid.Jumping:Connect(function() -- Line: 182
    -- upvalues: u19 (ref), os_clock (copy)
    u19 = os_clock();
end);
Humanoid.StateChanged:Connect(function(p20) -- Line: 185
    -- upvalues: HumanoidRootPart (copy), Humanoid (copy), isInWater (copy), os_clock (copy), u18 (ref), u19 (ref), manage_cd (copy), LocalPlayer (copy), Combat_presets (copy), PlayerProfile (copy), Character_info_provider (copy), RaycastHelper (copy), vfxUtility (copy), DebrisModule (copy), Cam_Shaker (copy)
    if p20 == Enum.HumanoidStateType.Landed and (HumanoidRootPart ~= nil and Humanoid ~= nil) then
        if isInWater() or os_clock() - u18 < 0.2 then
            u19 = os_clock();

            return;
        end;

        local _, v21 = manage_cd.skillStatus(LocalPlayer);
        local v22 = not HumanoidRootPart:FindFirstChild("ClimbAttachment") and os_clock() - Combat_presets.Last_Climb >= 0.15 and true or false;

        if PlayerProfile.lastperformedaskill and os.clock() - PlayerProfile.lastperformedaskill <= 0.8 then
            v22 = false;
        end;

        if v21 == true then
            v22 = false;
        end;

        local _core_anim = Character_info_provider.get_core_anim(LocalPlayer, "land");

        if os_clock() - u19 > 1 and v22 then
            if HumanoidRootPart then
                local v23 = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 3, 0), Vector3.new(0, -10, 0), RaycastHelper.Crater);

                if v23 and v23.Instance then
                    local v24 = script.Part:Clone();
                    v24.CFrame = CFrame.new(v23.Position, v23.Position - v23.Normal) * CFrame.Angles(1.5707963267948966, 0, 0);
                    v24.Parent = workspace.Debree;
                    vfxUtility.EmitAll(v24, v23.Instance.Color);
                    DebrisModule:AddItem(v24, 2.5);
                end;
            end;

            Cam_Shaker(HumanoidRootPart.Position, {
                FadeInTime = 0,
                Frequency = 0.1,
                Amplitude = 0.12,
                SustainTime = 0.12,
                FadeOutTime = 0.15,
                RotationInfluence = Vector3.new(0.1, 0.1, 0.1),
                PositionInfluence = Vector3.new(0.4, 0.4, 0.4)
            });
        end;

        u19 = os_clock();
        Humanoid.Animator:LoadAnimation(_core_anim):Play();
    end;
end);
local table_find = table.find;
local u25 = { "gamatunda_hip_height", "hip_height" };
local u26 = false;
local HipHeight = Humanoid.HipHeight;

function upd_Hip()
    -- upvalues: u2 (copy), table_find (copy), u25 (copy), u26 (ref), HipHeight (ref), Humanoid (copy)
    local v27 = 0;
    local v28 = false;

    for _, child in pairs(u2:GetChildren()) do
        if table_find(u25, child.Name) ~= nil then
            v28 = true;

            if v27 < child.Value then
                v27 = child.Value;
            end;
        end;
    end;

    if u26 ~= v28 then
        if v28 == true then
            HipHeight = Humanoid.HipHeight;
        end;

        u26 = v28;
    end;

    if v28 == true then
        Humanoid.HipHeight = v27;

        return;
    end;

    Humanoid.HipHeight = HipHeight;
end;

upd_Hip();
u2.ChildAdded:Connect(function(p29) -- Line: 281
    -- upvalues: table_find (copy), u25 (copy)
    if table_find(u25, p29.Name) ~= nil then
        upd_Hip();
    end;
end);
u2.ChildRemoved:Connect(function(p30) -- Line: 286
    -- upvalues: table_find (copy), u25 (copy)
    if table_find(u25, p30.Name) ~= nil then
        upd_Hip();
    end;
end);
local workspace_CurrentCamera = workspace.CurrentCamera;
local IntValue = Instance.new("IntValue");
IntValue.Name = "Field_of_View";
IntValue.Parent = script;
IntValue.Value = 70;
IntValue.Changed:Connect(function() -- Line: 310
    -- upvalues: IntValue (copy), workspace_CurrentCamera (copy)
    if IntValue ~= nil then
        workspace_CurrentCamera.FieldOfView = IntValue.Value;
    end;
end);
local u31 = cleanit.new();
local u32 = nil;

local function isFovValue(p33) -- Line: 320
    -- upvalues: CollectionService (copy)
    return p33.Name == "FOV" and true or CollectionService:HasTag(p33, "FOV");
end;

function updFOV()
    -- upvalues: u2 (copy), CollectionService (copy), u32 (ref), u31 (copy), IntValue (copy)
    local u34 = nil;
    local v35 = -99;

    for _, child in pairs(u2:GetChildren()) do
        if child.Name == "FOV" and true or CollectionService:HasTag(child, "FOV") then
            if u34 == nil then
                u34 = child;
            end;

            local Attribute = child:GetAttribute("Priority");

            if Attribute ~= nil and v35 < Attribute then
                v35 = Attribute;
                u34 = child;
            end;
        end;
    end;

    if u34 == nil then
        u31:Clean();
        IntValue.Value = 70;
    elseif u34 ~= u32 then
        u31:Clean();

        local function updVALUE() -- Line: 341
            -- upvalues: u34 (ref), IntValue (ref)
            if u34 ~= nil then
                IntValue.Value = u34.Value;
            end;
        end;

        if u34 ~= nil then
            IntValue.Value = u34.Value;
        end;

        u31:Connect(u34:GetPropertyChangedSignal("Value"), updVALUE);
    end;

    u32 = u34;
end;

u2.ChildAdded:Connect(function(p36) -- Line: 355
    -- upvalues: CollectionService (copy)
    task.wait();

    if p36.Name == "FOV" and true or CollectionService:HasTag(p36, "FOV") then
        updFOV();
    end;
end);
u2.ChildRemoved:Connect(function(p37) -- Line: 361
    -- upvalues: CollectionService (copy)
    task.wait();

    if p37.Name == "FOV" and true or CollectionService:HasTag(p37, "FOV") then
        updFOV();
    end;
end);
updFOV();
workspace_CurrentCamera.FieldOfView = IntValue.Value;
local Allegiance = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Allegiance"));
local TweenInfo_new_ret3 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u38 = {};

local function clearOtherHighlights() -- Line: 385
    -- upvalues: u38 (copy), TweenService (copy), TweenInfo_new_ret3 (copy)
    for _, v in u38 do
        local v39 = TweenService:Create(v, TweenInfo_new_ret3, {
            FillTransparency = 1,
            OutlineTransparency = 1
        });
        v39.Completed:Once(function() -- Line: 388
            -- upvalues: v (copy)
            v:Destroy();
        end);
        v39:Play();
    end;

    table.clear(u38);
end;

local function highlightOthers() -- Line: 395
    -- upvalues: clearOtherHighlights (copy), LocalPlayer (copy), Allegiance (copy), TweenService (copy), TweenInfo_new_ret3 (copy), u38 (copy)
    clearOtherHighlights();
    local Humanoids = workspace:FindFirstChild("Humanoids");

    if Humanoids == nil then
        return;
    end;

    local Character = LocalPlayer.Character;

    for _, child in Humanoids:GetChildren() do
        if child ~= Character and (child:IsA("Model") and (Character == nil or not (Allegiance.Protected(Character, child) or Allegiance.SameOwner(Character, child)))) then
            local Highlight = Instance.new("Highlight");
            Highlight.Name = "HighlightOthers";
            Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
            Highlight.FillTransparency = 1;
            Highlight.OutlineTransparency = 1;
            Highlight.Parent = child;
            TweenService:Create(Highlight, TweenInfo_new_ret3, {
                FillTransparency = 0.5,
                OutlineTransparency = 0
            }):Play();
            table.insert(u38, Highlight);
        end;
    end;
end;

u2.ChildAdded:Connect(function(p40) -- Line: 413
    -- upvalues: highlightOthers (copy)
    if p40.Name == "HighlightOthers" then
        highlightOthers();
    end;
end);
u2.ChildRemoved:Connect(function(p41) -- Line: 418
    -- upvalues: u2 (copy), clearOtherHighlights (copy)
    if p41.Name == "HighlightOthers" and u2:FindFirstChild("HighlightOthers") == nil then
        clearOtherHighlights();
    end;
end);

if u2:FindFirstChild("HighlightOthers") ~= nil then
    highlightOthers();
end;

local v42 = gameSettings.defaultMaxZoom or LocalPlayer.CameraMaxZoomDistance;
local CameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance;

local function getZoomOverride(p43: string) -- Line: 435
    -- upvalues: u2 (copy)
    local v44 = (-1 / 0);
    local v45 = nil;

    for _, child in u2:GetChildren() do
        if child.Name == p43 then
            local v46 = child:GetAttribute("Priority") or 0;

            if v44 < v46 then
                v45 = child;
                v44 = v46;
            end;
        end;
    end;

    if v45 == nil then
        return nil;
    end;

    return v45.Value;
end;

local v47 = nil;
local v48 = 0;
local u49 = nil;

function updSHC(p50)
    -- upvalues: u49 (ref), Run_Handler (copy)
    if u49 ~= nil then
        u49:Disconnect();
        u49 = nil;
    end;

    u49 = p50.Changed:Connect(function(p51) -- Line: 465
        -- upvalues: Run_Handler (ref)
        if p51 == "" then
            Run_Handler.SkillBeingPerformed = false;

            return;
        end;

        Run_Handler.SkillBeingPerformed = true;
    end);
end;

u1.ChildAdded:Connect(function(p52) -- Line: 473
    if p52.Name == "SHC" then
        updSHC(p52);
    end;
end);
local v53 = nil;

local function getWalkSpeedOverride() -- Line: 482
    -- upvalues: u2 (copy)
    local v54 = (-1 / 0);
    local v55 = nil;

    for _, child in u2:GetChildren() do
        if child.Name == "WalkSpeed" then
            local v56 = child:GetAttribute("Priority") or 0;

            if v54 < v56 then
                v55 = child;
                v54 = v56;
            end;
        end;
    end;

    if v55 == nil then
        return nil;
    end;

    return v55.Value;
end;

while HumanoidRootPart ~= nil and Humanoid ~= nil do
    local v57 = 16;
    local v58 = true;
    local State = Humanoid:GetState();
    local Attribute = (LocalPlayer.Character or u1):GetAttribute("SwimState");

    if typeof(Attribute) == "number" and Attribute > 0 then
        u18 = os_clock();
    end;

    setLowHealth(PlayerStatResolver.GetStat(LocalPlayer, "Low Health") == true and true or PlayerStatResolver.GetStat(LocalPlayer, "Fear") == true);
    local v59 = u2:FindFirstChild("Strict_Stun") ~= nil;
    local v60 = u2:FindFirstChild("Stun") ~= nil and true or (u2:FindFirstChild("CombatStun") or v59);

    if v3 ~= v60 then
        if v53 ~= nil then
            v53:Stop();
            v53 = nil;
        end;

        if v60 == true then
            v53 = Humanoid.Animator:LoadAnimation(Character_info_provider.get_core_anim(LocalPlayer, "Stun_Idle_Animation"));
            v53:Play();
            v3 = v60;
        else
            v3 = v60;
        end;
    end;

    local v61 = Humanoid.Health > 0 and (State ~= Enum.HumanoidStateType.Dead and workspace.Debree:FindFirstChild(LocalPlayer.Name .. LocalPlayer.UserId .. "\'s gamatundeasd12-12")) and true or false;
    local v62 = HumanoidRootPart:FindFirstChild("skill_stand_still") or u2:FindFirstChild("skill_stand_still");
    local v63;

    if v60 == true or (u2:FindFirstChild("RagDoll") ~= nil or v62) then
        v63 = 0;
    else
        Run_Handler.IsWalking = os_clock() - Combat_presets.Last_Punched < Combat_presets.slow_walk_duration;

        if Run_Handler.IsWalking or HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil then
            v57 = Combat_presets.slow_walk_speed;
        elseif Run_Handler.Is_Running == true then
            if Checker.ShallowWater then
                v57 = Run_Handler.shallow_water_run_speed;
            else
                v57 = Run_Handler.run_speed;
            end;

            local Stat = PlayerStatResolver.GetStat(LocalPlayer, "Run Speed Factor");

            if typeof(Stat) == "number" and Stat ~= 0 then
                v57 = v57 * (1 + Stat);
            end;
        end;

        local v64 = v57 * PlayerStatResolver.GetMovementMultiplier(LocalPlayer);
        v63 = (u2:FindFirstChild("Blocking") ~= nil or HumanoidRootPart:FindFirstChild("skill_slow")) and 4 or v64;
        local v65 = getWalkSpeedOverride();

        if v65 ~= nil then
            v63 = v65;
        end;
    end;

    local v66 = (LocalPlayer.Character or u1):GetAttribute("SwimDrowning") == true;
    local v67 = (v60 == true or (u2:FindFirstChild("RagDoll") ~= nil or (u2:FindFirstChild("Blocking") ~= nil or (v62 or (v66 or u2:FindFirstChild("JumpingDisabled") ~= nil))))) and 0 or ((os_clock() - Combat_presets.Last_Punched_Jump <= Combat_presets.No_Jump_Duration or HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil) and 0 or 50);

    if v67 > 0 then
        v67 = v67 * (1 + (PlayerStatResolver.GetStat(LocalPlayer, "Jump Power Factor") or 0));
    end;

    if u2:FindFirstChild("RagDoll") ~= nil or (HumanoidRootPart:FindFirstChild("ClimbAttachment") or (u2:FindFirstChild("NR") ~= nil or Humanoid:GetState() == Enum.HumanoidStateType.Dead)) then
        v58 = false;
    end;

    local camsubject = u2:FindFirstChild("camsubject");
    local v68;

    if camsubject == nil or (camsubject.Value == nil or not camsubject.Value:IsDescendantOf(workspace)) then
        v68 = Humanoid;
    else
        v68 = camsubject.Value;
    end;

    if v68 and v68 ~= workspace_CurrentCamera.CameraSubject then
        workspace_CurrentCamera.CameraSubject = v68;
    end;

    local v69 = getZoomOverride("MaxZoom");
    local v70 = getZoomOverride("MinZoom");
    local v71 = v69 ~= nil and true or v70 ~= nil;

    if v71 and v47 == nil then
        v47 = (workspace_CurrentCamera.CFrame.Position - workspace_CurrentCamera.Focus.Position).Magnitude;
        v48 = 0;
    elseif not (v71 or (v47 == nil or v48 ~= 0)) then
        v48 = os_clock() + 0.1;
    end;

    local v72 = v69 or v42;
    local v73 = v70 or CameraMinZoomDistance;

    if not v71 and v47 ~= nil then
        if os_clock() < v48 then
            v73 = math.clamp(v47, v73, v72);
            v72 = v73;
        else
            v47 = nil;
        end;
    end;

    if LocalPlayer.CameraMaxZoomDistance ~= v72 then
        LocalPlayer.CameraMaxZoomDistance = v72;
    end;

    if LocalPlayer.CameraMinZoomDistance ~= v73 then
        LocalPlayer.CameraMinZoomDistance = v73;
    end;

    Humanoid.WalkSpeed = v63;
    Humanoid.JumpPower = v67;
    Humanoid.AutoRotate = v58;

    if Platform_Handler.IsGamepad() or Platform_Handler.Platform.Value == "Mobile" then
        Humanoid.CameraOffset = Run_Handler.Shift_lock == 1 and Vector3.new(0, 1.35, 0) or Vector3.new(0, 0, 0);
    end;

    Humanoid.PlatformStand = v61;
    local v74;

    if Dialogue.Value == true or (Camera_Traffic_Handler.Equipped_Hirearchy == "Cutscene" or LocalPlayer:GetAttribute("MapOpened") == true) then
        v74 = false;
    else
        local MenuDestination = LocalPlayer:FindFirstChild("MenuDestination");
        local v75;

        if MenuDestination == nil then
            v75 = false;
        else
            v75 = MenuDestination.Value ~= "";
        end;

        v74 = not v75;
    end;

    if GuiService.TouchControlsEnabled ~= v74 then
        GuiService.TouchControlsEnabled = v74;
    end;

    task.wait(0.075);
end;