-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Lighting = game:GetService("Lighting");
local v1 = {};
local LocalPlayer = Players.LocalPlayer;
local v2 = ReplicatedStorage:WaitForChild("Funções");
local VampiricTrackerConfig = require(v2:WaitForChild("VampiricTrackerConfig"));
local VampiricTrackerRemote = v2:WaitForChild("Eventos"):WaitForChild("VampiricTrackerRemote");
local Color3_fromRGB_ret = Color3.fromRGB(255, 0, 32);
local u3 = false;
local u4 = {};
local u5 = 0;

local function getTargetRoot(p6) -- Line: 23
    return p6:FindFirstChild("HumanoidRootPart") or (p6:FindFirstChild("Torso") or p6:FindFirstChild("UpperTorso"));
end;

local function removeEffect(p7) -- Line: 29
    -- upvalues: u4 (copy)
    local v8 = u4[p7];

    if not v8 then
        return;
    end;

    if v8.originalModifiers then
        for i, v in pairs(v8.originalModifiers) do
            if i.Parent then
                i.Transparency = v;
            end;
        end;
    end;

    for _, v in v8.instances do
        if v.Parent then
            v:Destroy();
        end;
    end;

    u4[p7] = nil;
end;

local function clearEffects() -- Line: 49
    -- upvalues: u4 (copy), removeEffect (copy), LocalPlayer (copy)
    for i in u4 do
        removeEffect(i);
    end;

    LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", 0);
end;

local u9 = nil;

local function applyDarkness() -- Line: 59
    -- upvalues: u9 (ref), Lighting (copy), TweenService (copy)
    if not u9 then
        u9 = Instance.new("ColorCorrectionEffect");
        u9.Name = "VampiricTrackerDarkness";
        u9.Brightness = 0;
        u9.Contrast = 0;
        u9.TintColor = Color3.new(1, 1, 1);
        u9.Parent = Lighting;
    end;

    TweenService:Create(u9, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Brightness = -0.1,
        Contrast = 0.1,
        TintColor = Color3.fromRGB(180, 150, 160)
    }):Play();
end;

local function removeDarkness() -- Line: 75
    -- upvalues: u9 (ref), TweenService (copy)
    if u9 then
        local v10 = TweenService:Create(u9, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Brightness = 0,
            Contrast = 0,
            TintColor = Color3.new(1, 1, 1)
        });
        v10:Play();
        v10.Completed:Connect(function() -- Line: 83
            -- upvalues: u9 (ref)
            if u9 and u9.Brightness >= -0.01 then
                u9:Destroy();
                u9 = nil;
            end;
        end);
    end;
end;

local function stopTracking() -- Line: 92
    -- upvalues: u5 (ref), u4 (copy), removeEffect (copy), LocalPlayer (copy), removeDarkness (copy)
    u5 = u5 + 1;

    for i in u4 do
        removeEffect(i);
    end;

    LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", 0);
    removeDarkness();
    LocalPlayer:SetAttribute("VampiricTrackingActive", false);
end;

local function isTrackable(p11) -- Line: 99
    -- upvalues: LocalPlayer (copy), Workspace (copy), Players (copy)
    if p11 == LocalPlayer.Character or not p11:IsDescendantOf(Workspace) then
        return false;
    end;

    local v12 = p11:FindFirstChildOfClass("Humanoid");
    local v13 = p11:FindFirstChild("HumanoidRootPart") or (p11:FindFirstChild("Torso") or p11:FindFirstChild("UpperTorso"));

    if not (v12 and (v12.Health > 0 and v13)) then
        return false;
    end;

    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p11);

    if PlayerFromCharacter then
        local v14;

        if PlayerFromCharacter == LocalPlayer or PlayerFromCharacter.Team == nil then
            v14 = false;
        else
            v14 = PlayerFromCharacter.Team.Name == "Humans" and true or PlayerFromCharacter.Team.Name == "VampireHunter";
        end;

        return v14;
    end;

    local v15;

    if p11:GetAttribute("IsVampire") == true or p11:GetAttribute("Team") == "Vampires" then
        v15 = false;
    else
        v15 = p11:GetAttribute("Team") ~= "Cannibal Raised";
    end;

    return v15;
end;

local function getTargetChest(p16) -- Line: 121
    return p16:FindFirstChild("Torso") or p16:FindFirstChild("UpperTorso") or (p16:FindFirstChild("LowerTorso") or p16:FindFirstChild("HumanoidRootPart") or (p16:FindFirstChild("Torso") or p16:FindFirstChild("UpperTorso")));
end;

local function createEffect(p17) -- Line: 128
    -- upvalues: Color3_fromRGB_ret (copy), TweenService (copy), u4 (copy)
    local v18 = p17:FindFirstChild("HumanoidRootPart") or (p17:FindFirstChild("Torso") or p17:FindFirstChild("UpperTorso"));
    local v19 = p17:FindFirstChild("Torso") or p17:FindFirstChild("UpperTorso") or (p17:FindFirstChild("LowerTorso") or p17:FindFirstChild("HumanoidRootPart") or (p17:FindFirstChild("Torso") or p17:FindFirstChild("UpperTorso")));

    if not (v18 and (v19 and v19:IsA("BasePart"))) then
        return;
    end;

    local v20 = {};

    for _, descendant in ipairs(p17:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            v20[descendant] = descendant.Transparency;

            if descendant.Name == "HumanoidRootPart" then
                descendant.Transparency = 1;
            else
                descendant.Transparency = 0.999;
            end;
        end;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "VampiricTrackerHighlight";
    Highlight.Adornee = p17;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillColor = Color3_fromRGB_ret;
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.fromRGB(255, 0, 40);
    Highlight.OutlineTransparency = 0;
    Highlight.Parent = p17;
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "VampiricTrackerHeartAttachment";
    Attachment.Position = Vector3.new(-v19.Size.X * 0.22, v19.Size.Y * 0.12, -v19.Size.Z * 0.5 - 0.035);
    Attachment.Parent = v19;
    local v21 = math.min(v19.Size.X, v19.Size.Y) * 0.34;
    local math_clamp_ret = math.clamp(v21, 0.42, 0.72);
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "VampiricTrackerHeart";
    BillboardGui.Adornee = Attachment;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.MaxDistance = 100000;
    BillboardGui.Size = UDim2.fromScale(math_clamp_ret, math_clamp_ret);
    BillboardGui.Parent = Attachment;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Heart";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(0.78, 0.78);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Image = "rbxassetid://137989211628267";
    ImageLabel.ImageColor3 = Color3.new(1, 1, 1);
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Parent = BillboardGui;
    TweenService:Create(ImageLabel, TweenInfo.new(0.42, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Size = UDim2.fromScale(1, 1)
    }):Play();
    local Sound = Instance.new("Sound");
    Sound.Name = "VampiricTrackerHeartbeat";
    Sound.SoundId = "rbxassetid://139481207162657";
    Sound.Looped = true;
    Sound.Volume = 0.55;
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered;
    Sound.RollOffMinDistance = 5;
    Sound.RollOffMaxDistance = 65;
    Sound.Parent = Attachment;
    Sound:Play();
    u4[p17] = {
        originalModifiers = v20,
        instances = {
            Highlight,
            Attachment,
            BillboardGui,
            Sound
        }
    };
end;

local function collectTargets() -- Line: 217
    -- upvalues: Players (copy), isTrackable (copy), Workspace (copy)
    local v22 = {};

    for _, v in Players:GetPlayers() do
        local Character = v.Character;

        if Character and isTrackable(Character) then
            v22[Character] = true;
        end;
    end;

    for _, descendant in Workspace:GetDescendants() do
        if descendant:IsA("Model") and (Players:GetPlayerFromCharacter(descendant) == nil and (descendant:FindFirstChildOfClass("Humanoid") and isTrackable(descendant))) then
            v22[descendant] = true;
        end;
    end;

    return v22;
end;

local function updateEffects() -- Line: 240
    -- upvalues: LocalPlayer (copy), u4 (copy), removeEffect (copy), collectTargets (copy), createEffect (copy)
    local Character = LocalPlayer.Character;
    local v23;

    if Character then
        v23 = Character:FindFirstChildOfClass("Humanoid");
    else
        v23 = Character;
    end;

    if not (Character and (v23 and v23.Health > 0)) then
        for i in u4 do
            removeEffect(i);
        end;

        LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", 0);

        return false;
    end;

    local v24 = collectTargets();

    for i in v24 do
        local v25 = u4[i];

        if not (v25 and ((i:FindFirstChild("HumanoidRootPart") or (i:FindFirstChild("Torso") or i:FindFirstChild("UpperTorso"))) and (v25.instances[1] and v25.instances[1].Parent == i))) then
            removeEffect(i);
            createEffect(i);
        end;
    end;

    for i in u4 do
        if not v24[i] then
            removeEffect(i);
        end;
    end;

    local v26 = 0;

    for _ in u4 do
        v26 = v26 + 1;
    end;

    LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", v26);

    return true;
end;

local function startTracking(p27) -- Line: 276
    -- upvalues: u5 (ref), u4 (copy), removeEffect (copy), LocalPlayer (copy), applyDarkness (copy), updateEffects (copy), VampiricTrackerConfig (copy), removeDarkness (copy)
    u5 = u5 + 1;
    local u28 = u5;
    local u29 = os.clock() + p27;

    for i in u4 do
        removeEffect(i);
    end;

    LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", 0);
    applyDarkness();
    LocalPlayer:SetAttribute("VampiricTrackingActive", true);
    LocalPlayer:SetAttribute("VampiricTrackerActivationCount", (LocalPlayer:GetAttribute("VampiricTrackerActivationCount") or 0) + 1);
    task.spawn(function() -- Line: 289
        -- upvalues: u5 (ref), u28 (copy), u29 (copy), LocalPlayer (ref), updateEffects (ref), VampiricTrackerConfig (ref), u4 (ref), removeEffect (ref), removeDarkness (ref)
        while u5 == u28 and os.clock() < u29 do
            if not (LocalPlayer.Team and (LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised") and updateEffects()) then
                break;
            end;

            task.wait(VampiricTrackerConfig.TargetRefreshInterval);
        end;

        if u5 == u28 then
            u5 = u5 + 1;

            for i in u4 do
                removeEffect(i);
            end;

            LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", 0);
            removeDarkness();
            LocalPlayer:SetAttribute("VampiricTrackingActive", false);
        end;
    end);
end;

function v1.Start() -- Line: 305
    -- upvalues: u3 (ref), LocalPlayer (copy), VampiricTrackerRemote (copy), startTracking (copy), u5 (ref), u4 (copy), removeEffect (copy), removeDarkness (copy)
    if u3 then
        return;
    end;

    u3 = true;
    LocalPlayer:SetAttribute("VampiricTrackingActive", false);
    LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", 0);
    VampiricTrackerRemote.OnClientEvent:Connect(function(p30, p31) -- Line: 314
        -- upvalues: startTracking (ref)
        if p30 == "Activated" then
            startTracking(p31);
        end;
    end);
    LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 320
        -- upvalues: LocalPlayer (ref), u5 (ref), u4 (ref), removeEffect (ref), removeDarkness (ref)
        if not (LocalPlayer.Team and (LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised")) then
            u5 = u5 + 1;

            for i in u4 do
                removeEffect(i);
            end;

            LocalPlayer:SetAttribute("VampiricTrackerHighlightCount", 0);
            removeDarkness();
            LocalPlayer:SetAttribute("VampiricTrackingActive", false);
        end;
    end);
end;

return v1;