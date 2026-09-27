-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TeamGuiLayout = require(ReplicatedStorage:WaitForChild("TeamGuiLayout"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local MobileLockOnToggle = script:FindFirstChild("MobileLockOnToggle");

if not MobileLockOnToggle then
    MobileLockOnToggle = Instance.new("BindableEvent");
    MobileLockOnToggle.Name = "MobileLockOnToggle";
    MobileLockOnToggle.Parent = script;
end;

local Color3_fromRGB_ret = Color3.fromRGB(125, 255, 150);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 95, 95);
local u1 = "MobileLockOnCamera_" .. tostring(LocalPlayer.UserId);
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = nil;

local function trackHumanoid(p10) -- Line: 47
    -- upvalues: u2 (copy)
    if p10:IsA("Humanoid") then
        local Parent = p10.Parent;

        if Parent and Parent:IsA("Model") then
            u2[Parent] = true;
        end;
    end;
end;

local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = {};
local u18 = {};
local u19 = {};

for _, descendant in ipairs(Workspace:GetDescendants()) do
    if descendant:IsA("Humanoid") then
        local Parent = descendant.Parent;

        if Parent and Parent:IsA("Model") then
            u2[Parent] = true;
        end;
    end;
end;

Workspace.DescendantAdded:Connect(trackHumanoid);
Workspace.DescendantRemoving:Connect(function(p20) -- Line: 60
    -- upvalues: u2 (copy)
    if p20:IsA("Humanoid") then
        local Parent = p20.Parent;

        if Parent and Parent:IsA("Model") then
            u2[Parent] = nil;
        end;
    end;
end);

local function isMobile() -- Line: 67
    -- upvalues: UserInputService (copy), TeamGuiLayout (copy)
    local v21 = UserInputService.TouchEnabled and TeamGuiLayout.GetMode() == "MOBILE";

    return v21;
end;

local function disconnectButtons() -- Line: 71
    -- upvalues: u17 (copy), u18 (copy), u19 (copy)
    for _, v in ipairs(u17) do
        v:Disconnect();
    end;

    table.clear(u17);
    table.clear(u18);
    table.clear(u19);
end;

local function findTargetModel(p22) -- Line: 80
    -- upvalues: Workspace (copy)
    while p22 and p22 ~= Workspace do
        if p22:IsA("Model") then
            local v23 = p22:FindFirstChildOfClass("Humanoid");
            local v24 = p22:FindFirstChild("HumanoidRootPart") or p22.PrimaryPart or (p22:FindFirstChild("Torso") or p22:FindFirstChild("UpperTorso"));

            if v23 and (v24 and v24:IsA("BasePart")) then
                return p22, v23, v24;
            end;
        end;

        p22 = p22.Parent;
    end;

    return nil, nil, nil;
end;

local function validTarget(p25) -- Line: 98
    -- upvalues: u14 (ref), u15 (ref), findTargetModel (copy)
    if not (p25 and (p25:IsA("BasePart") and p25.Parent)) then
        return false;
    end;

    if not (u14 and (u15 and not p25:IsDescendantOf(u14))) then
        return false;
    end;

    local v26, v27, v28 = findTargetModel(p25);

    if not (v26 and (v28 == p25 and v26 ~= u14)) then
        return false;
    end;

    if v27.Health <= 0 then
        return false;
    end;

    if v26:GetAttribute("WitchInvisibleActive") == true then
        return false;
    end;

    return (u15.Position - p25.Position).Magnitude <= 160;
end;

local function refreshButtonVisuals() -- Line: 108
    -- upvalues: u18 (copy), u8 (ref), Color3_fromRGB_ret (copy), u19 (copy)
    for _, v in ipairs(u18) do
        if v.Parent then
            v:SetAttribute("LockOnEnabled", u8);
            v.ImageColor3 = u8 and Color3_fromRGB_ret or (u19[v] or Color3.new(1, 1, 1));
        end;
    end;
end;

local function clearVisuals() -- Line: 117
    -- upvalues: u9 (ref), u16 (ref)
    if u9 then
        u9:Destroy();
    end;

    if u16 then
        u16:Destroy();
    end;

    u9 = nil;
    u16 = nil;
end;

local function unlock() -- Line: 124
    -- upvalues: u8 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), RunService (copy), u1 (copy), u9 (ref), u16 (ref), u7 (ref), Workspace (copy), u11 (ref), u12 (ref), u13 (ref), refreshButtonVisuals (copy), LocalPlayer (copy)
    u8 = false;
    u3 = nil;
    u4 = nil;
    u5 = nil;
    u6 = nil;
    RunService:UnbindFromRenderStep(u1);

    if u9 then
        u9:Destroy();
    end;

    if u16 then
        u16:Destroy();
    end;

    u9 = nil;
    u16 = nil;

    if u7 and u7.Parent then
        u7.AutoRotate = true;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        if u11 then
            CurrentCamera.FieldOfView = u11;
        end;

        if u12 then
            CurrentCamera.CameraType = u12;
        end;

        if u13 and u13.Parent then
            CurrentCamera.CameraSubject = u13;
        end;
    end;

    u11 = nil;
    u12 = nil;
    u13 = nil;
    refreshButtonVisuals();
    LocalPlayer:SetAttribute("MobileLockOnActive", false);
    LocalPlayer:SetAttribute("MobileLockOnTarget", nil);
end;

local function createVisuals(p29, p30) -- Line: 151
    -- upvalues: u9 (ref), u16 (ref)
    if u9 then
        u9:Destroy();
    end;

    if u16 then
        u16:Destroy();
    end;

    u9 = nil;
    u16 = nil;
    u16 = Instance.new("Highlight");
    u16.Name = "MobileLockOnHighlight";
    u16.Adornee = p30;
    u16.DepthMode = Enum.HighlightDepthMode.Occluded;
    u16.FillTransparency = 1;
    u16.OutlineColor = Color3.new(1, 1, 1);
    u16.OutlineTransparency = 0;
    u16.Parent = p30;
end;

local function gatherClosestTarget() -- Line: 165
    -- upvalues: u15 (ref), Workspace (copy), u2 (copy), u14 (ref), validTarget (copy)
    if not u15 then
        return nil, nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return nil, nil;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;
    local v31 = ViewportSize * 0.5;
    local math_max_ret = math.max(ViewportSize.X, ViewportSize.Y, 1);
    local v32 = (1 / 0);
    local v33 = nil;
    local v34 = nil;

    for i in pairs(u2) do
        if i.Parent then
            if i ~= u14 then
                local v35 = i:FindFirstChildOfClass("Humanoid");
                local v36 = i:FindFirstChild("HumanoidRootPart") or i.PrimaryPart or (i:FindFirstChild("Torso") or i:FindFirstChild("UpperTorso"));

                if v35 and (v35.Health > 0 and (v36 and (v36:IsA("BasePart") and validTarget(v36)))) then
                    local Magnitude = (u15.Position - v36.Position).Magnitude;
                    local v37, v38 = CurrentCamera:WorldToViewportPoint(v36.Position + Vector3.new(0, 1.5, 0));

                    if v38 and v37.Z > 0 then
                        local v39 = (Vector2.new(v37.X, v37.Y) - v31).Magnitude / math_max_ret * 3 + Magnitude / 160;

                        if v39 < v32 then
                            v34 = i;
                            v33 = v36;
                            v32 = v39;
                        end;
                    end;
                end;
            end;
        else
            u2[i] = nil;
        end;
    end;

    return v33, v34;
end;

local function updateCamera(p40) -- Line: 204
    -- upvalues: u8 (ref), UserInputService (copy), TeamGuiLayout (copy), unlock (copy), u3 (ref), validTarget (copy), Workspace (copy), u15 (ref), u5 (ref), u6 (ref)
    if u8 then
        local v41 = UserInputService.TouchEnabled and TeamGuiLayout.GetMode() == "MOBILE";

        if v41 then
            if not (u3 and validTarget(u3)) then
                unlock();

                return;
            end;

            local CurrentCamera = Workspace.CurrentCamera;

            if not (CurrentCamera and u15) then
                return;
            end;

            CurrentCamera.CameraType = Enum.CameraType.Scriptable;
            local Position = u15.Position;
            local Position2 = u3.Position;
            local Vector3_new_ret = Vector3.new(Position2.X - Position.X, 0, Position2.Z - Position.Z);

            if Vector3_new_ret.Magnitude <= 0.001 then
                return;
            end;

            local Unit = Vector3_new_ret.Unit;
            local v42 = Unit:Cross(Vector3.new(0, 1, 0));
            local v43 = Position - Unit * 13 + (v42.Magnitude <= 0.001 and Vector3.new(1, 0, 0) or v42.Unit) * 7 + Vector3.new(0, 3, 0);
            local v44 = 1 - math.exp(-9.6 * p40);

            if u5 then
                v43 = u5:Lerp(v43, v44) or v43;
            end;

            u5 = v43;

            if u6 then
                Position2 = u6:Lerp(Position2, v44) or Position2;
            end;

            u6 = Position2;
            CurrentCamera.CFrame = CFrame.lookAt(u5, u6);
            CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (76 - CurrentCamera.FieldOfView) * 0.08;

            if u15.Parent and Unit.Magnitude > 0 then
                u15.CFrame = CFrame.lookAt(Position, Position + Unit);
            end;

            return;
        end;
    end;

    unlock();
end;

local function lockNearest() -- Line: 257
    -- upvalues: UserInputService (copy), TeamGuiLayout (copy), u14 (ref), u7 (ref), gatherClosestTarget (copy), u18 (copy), u19 (copy), Color3_fromRGB_ret2 (copy), u8 (ref), Workspace (copy), u11 (ref), u12 (ref), u13 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (ref), u16 (ref), refreshButtonVisuals (copy), LocalPlayer (copy), RunService (copy), u1 (copy), updateCamera (copy)
    local v45 = UserInputService.TouchEnabled and TeamGuiLayout.GetMode() == "MOBILE";

    if not (v45 and (u14 and (u7 and u7.Health > 0))) then
        return;
    end;

    local v46, v47 = gatherClosestTarget();

    if not (v46 and v47) then
        for _, v in ipairs(u18) do
            if v.Parent and v.Visible then
                local u48 = u19[v] or Color3.new(1, 1, 1);
                v.ImageColor3 = Color3_fromRGB_ret2;
                task.delay(0.3, function() -- Line: 265
                    -- upvalues: v (copy), u8 (ref), u48 (copy)
                    if v.Parent and not u8 then
                        v.ImageColor3 = u48;
                    end;
                end);
            end;
        end;

        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;
    u11 = CurrentCamera and (CurrentCamera.FieldOfView or 70) or 70;
    u12 = CurrentCamera and CurrentCamera.CameraType or Enum.CameraType.Custom;
    u13 = CurrentCamera and CurrentCamera.CameraSubject or u7;

    if CurrentCamera then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    end;

    if u7 then
        u7.AutoRotate = false;
    end;

    u8 = true;
    u3 = v46;
    u4 = v47;
    u5 = nil;
    u6 = nil;

    if u9 then
        u9:Destroy();
    end;

    if u16 then
        u16:Destroy();
    end;

    u9 = nil;
    u16 = nil;
    u16 = Instance.new("Highlight");
    u16.Name = "MobileLockOnHighlight";
    u16.Adornee = v47;
    u16.DepthMode = Enum.HighlightDepthMode.Occluded;
    u16.FillTransparency = 1;
    u16.OutlineColor = Color3.new(1, 1, 1);
    u16.OutlineTransparency = 0;
    u16.Parent = v47;
    refreshButtonVisuals();
    LocalPlayer:SetAttribute("MobileLockOnActive", true);
    LocalPlayer:SetAttribute("MobileLockOnTarget", v47.Name);
    RunService:BindToRenderStep(u1, Enum.RenderPriority.Last.Value, updateCamera);
end;

MobileLockOnToggle.Event:Connect(function() -- Line: 291, Name: toggleLock
    -- upvalues: LocalPlayer (copy), u8 (ref), unlock (copy), lockNearest (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") == true then
        return;
    end;

    if u8 then
        unlock();

        return;
    end;

    lockNearest();
end);

local function bindButton(p49) -- Line: 302
    -- upvalues: u18 (copy), u19 (copy), u17 (copy), MobileLockOnToggle (ref)
    if not (p49 and p49:IsA("ImageButton")) then
        return;
    end;

    for _, v in ipairs(u18) do
        if v == p49 then
            return;
        end;
    end;

    u18[#u18 + 1] = p49;
    u19[p49] = p49.ImageColor3;
    p49.Active = true;
    p49.Interactable = true;
    p49:SetAttribute("LockOnEnabled", false);
    u17[#u17 + 1] = p49.Activated:Connect(function() -- Line: 312
        -- upvalues: MobileLockOnToggle (ref)
        MobileLockOnToggle:Fire();
    end);
end;

local function bindButtons() -- Line: 317
    -- upvalues: disconnectButtons (copy), PlayerGui (copy), bindButton (copy), refreshButtonVisuals (copy)
    disconnectButtons();
    local TEAMS = PlayerGui:WaitForChild("TEAMS");
    local VampireMOBILE = TEAMS:FindFirstChild("VampireMOBILE");
    local WitchesMOBILE = TEAMS:FindFirstChild("WitchesMOBILE");
    local HumansMOBILE = TEAMS:FindFirstChild("HumansMOBILE");
    local v50 = VampireMOBILE and VampireMOBILE:FindFirstChild("Powers") and VampireMOBILE.Powers:FindFirstChild("LockOn");
    bindButton(v50);
    local v51 = WitchesMOBILE and WitchesMOBILE:FindFirstChild("Powers") and WitchesMOBILE.Powers:FindFirstChild("LockOn");
    bindButton(v51);

    if HumansMOBILE then
        HumansMOBILE = HumansMOBILE:FindFirstChild("LockOn");
    end;

    bindButton(HumansMOBILE);
    refreshButtonVisuals();
end;

local function setupCharacter(p52) -- Line: 329
    -- upvalues: unlock (copy), u14 (ref), u7 (ref), u15 (ref)
    unlock();
    u14 = p52;
    u7 = p52:WaitForChild("Humanoid");
    u15 = p52:WaitForChild("HumanoidRootPart");
    u7.Died:Connect(unlock);
end;

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(unlock);
LocalPlayer:GetAttributeChangedSignal("MobileHudEditMode"):Connect(function() -- Line: 338
    -- upvalues: LocalPlayer (copy), unlock (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") == true then
        unlock();
    end;
end);
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 341
    -- upvalues: u8 (ref), u5 (ref), u6 (ref)
    if u8 then
        u5 = nil;
        u6 = nil;
    end;
end);
bindButtons();
PlayerGui.ChildAdded:Connect(function(p53) -- Line: 349
    -- upvalues: bindButtons (copy)
    if p53.Name == "TEAMS" then
        task.defer(bindButtons);
    end;
end);

if LocalPlayer.Character then
    local Character = LocalPlayer.Character;
    unlock();
    u14 = Character;
    u7 = Character:WaitForChild("Humanoid");
    u15 = Character:WaitForChild("HumanoidRootPart");
    u7.Died:Connect(unlock);
end;

LocalPlayer.CharacterAdded:Connect(setupCharacter);
local v54 = UserInputService.TouchEnabled and TeamGuiLayout.GetMode() == "MOBILE";

if not v54 then
    unlock();
end;