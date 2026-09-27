-- Decompiled with Potassium's decompiler.

require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Parent = script_Parent.Parent;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local Eventos = v1:WaitForChild("Eventos");
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));

local function isMobileInterface() -- Line: 16
    -- upvalues: Parent (copy)
    return Parent.Visible;
end;

local function findButton(p2) -- Line: 25
    -- upvalues: script_Parent (copy)
    local v3 = script_Parent:FindFirstChild(p2);

    if v3 and v3:IsA("GuiObject") then
        return v3;
    end;

    for _, child in script_Parent:GetChildren() do
        if child:IsA("GuiObject") and string.lower(child.Name) == string.lower(p2) then
            return child;
        end;
    end;

    return nil;
end;

local u4 = {
    BreakNeck = {
        action = "Break",
        targetMode = true,
        button = findButton("BreakNeck"),
        key = Enum.KeyCode.Q,
        gamepadKey = Enum.KeyCode.ButtonX,
        remote = Eventos:WaitForChild("BreakNeckRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "BreakNeckRequest"),
        config = require(v1:WaitForChild("BreakNeckConfig"))
    },
    BloodDrink = {
        action = "Bite",
        targetMode = true,
        button = findButton("DrinkBlood"),
        key = Enum.KeyCode.E,
        gamepadKey = Enum.KeyCode.ButtonY,
        remote = Eventos:WaitForChild("BloodDrinkRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "BloodDrinkRequest"),
        config = require(v1:WaitForChild("BloodDrinkConfig"))
    },
    HeartRipping = {
        action = "Attack",
        targetMode = true,
        button = findButton("Heart-Ripping"),
        key = Enum.KeyCode.X,
        gamepadKey = Enum.KeyCode.DPadDown,
        remote = Eventos:WaitForChild("HeartRippingRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "HeartRippingRequest"),
        config = require(v1:WaitForChild("HeartRippingConfig"))
    },
    Infect = {
        action = "Infect",
        targetMode = true,
        button = findButton("Infect"),
        key = Enum.KeyCode.R,
        gamepadKey = Enum.KeyCode.DPadRight,
        remote = Eventos:WaitForChild("InfectRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "InfectRequest"),
        config = require(v1:WaitForChild("InfectConfig"))
    },
    Track = {
        targetMode = false,
        button = findButton("Track"),
        key = Enum.KeyCode.F,
        gamepadKey = Enum.KeyCode.DPadLeft,
        remote = Eventos:WaitForChild("VampiricTrackerRemote"),
        config = require(v1:WaitForChild("VampiricTrackerConfig"))
    },
    Hypnosis = {
        action = "Select",
        targetMode = true,
        commandMode = true,
        button = findButton("Hipnose"),
        key = Enum.KeyCode.C,
        gamepadKey = Enum.KeyCode.DPadUp,
        remote = Eventos:WaitForChild("HypnosisRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "HypnosisRequest"),
        config = require(v1:WaitForChild("HypnosisConfig"))
    },
    BatForm = {
        targetMode = false,
        button = findButton("BatForm"),
        key = Enum.KeyCode.Z,
        remote = Eventos:WaitForChild("BatFormRemote"),
        config = require(v1:WaitForChild("BatFormConfig"))
    }
};
local u5 = {};

local function ensureStatusLabel(p6, p7, p8, p9, p10) -- Line: 119
    local v11 = p6:FindFirstChild(p7);

    if not (v11 and v11:IsA("TextLabel")) then
        v11 = Instance.new("TextLabel");
        v11.Name = p7;
        v11.Parent = p6;
    end;

    v11.AnchorPoint = Vector2.new(0.5, 0.5);
    v11.Position = p8;
    v11.Size = p9;
    v11.BackgroundTransparency = 1;
    v11.BorderSizePixel = 0;
    v11.TextColor3 = Color3.new(1, 1, 1);
    v11.TextStrokeTransparency = 1;
    v11.Font = Enum.Font.Ubuntu;
    v11.TextScaled = true;
    v11.TextWrapped = false;
    v11.Active = false;
    v11.Selectable = false;
    v11.ZIndex = p6.ZIndex + 20;
    local v12 = v11:FindFirstChildOfClass("UITextSizeConstraint");

    if not v12 then
        v12 = Instance.new("UITextSizeConstraint");
        v12.Parent = v11;
    end;

    v12.MinTextSize = 8;
    v12.MaxTextSize = p10;

    return v11;
end;

local function getEquippedEmptyBloodContainer() -- Line: 107
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Tool") and (child.Name == "Cup" or (child.Name == "CUP" or child.Name == "Dish")) then
            return child;
        end;
    end;

    return nil;
end;

for _, v in pairs(u4) do
    if v.button then
        local button = v.button;
        button.Active = true;
        local v13 = {};
        local v14;

        if button:IsA("TextLabel") then
            v14 = button.TextColor3 or nil;
        else
            v14 = nil;
        end;

        v13.textColor = v14;
        local v15;

        if button:IsA("TextLabel") then
            v15 = button.TextTransparency or nil;
        else
            v15 = nil;
        end;

        v13.textTransparency = v15;
        local v16;

        if button:IsA("ImageButton") then
            v16 = button.ImageColor3 or nil;
        else
            v16 = nil;
        end;

        v13.imageColor = v16;
        local v17;

        if button:IsA("ImageButton") then
            v17 = button.ImageTransparency or nil;
        else
            v17 = nil;
        end;

        v13.imageTransparency = v17;
        v13.backgroundColor = button.BackgroundColor3;
        v13.backgroundTransparency = button.BackgroundTransparency;
        local v18;

        if button:IsA("GuiButton") then
            v18 = button.AutoButtonColor or nil;
        else
            v18 = nil;
        end;

        v13.autoButtonColor = v18;
        u5[button] = v13;
        local v19 = button:FindFirstChild("Coldown") or button:FindFirstChild("COLDOWN");

        if v19 and v19:IsA("TextLabel") then
            v19.ZIndex = button.ZIndex + 20;
        else
            v19 = ensureStatusLabel(button, "Coldown", UDim2.fromScale(0.5, 0.5), UDim2.fromScale(0.9, 0.72), 24);
        end;

        v19.Active = false;
        v19.Visible = false;
        v19.Text = "";
        local v20 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

        if v20 and v20:IsA("TextLabel") then
            v20.ZIndex = button.ZIndex + 21;
        else
            v20 = ensureStatusLabel(button, "UnlockRequirement", UDim2.fromScale(0.5, 0.82), UDim2.fromScale(1.15, 0.32), 14);
        end;

        v20.Visible = false;
    end;
end;

local Name = Parent.Name;
local u21 = nil;
local u22 = nil;
local u23 = 0;

for _, child in ipairs(workspace:GetChildren()) do
    if child:IsA("Highlight") and (child.Name == "PowerTargetHighlight" and child:GetAttribute("PowerTargetOwner") == Name) then
        child:Destroy();
    end;
end;

local Highlight = Instance.new("Highlight");
Highlight.Name = "PowerTargetHighlight";
Highlight:SetAttribute("PowerTargetOwner", Name);
Highlight.FillColor = Color3.fromRGB(155, 0, 0);
Highlight.FillTransparency = 0.72;
Highlight.OutlineColor = Color3.fromRGB(255, 70, 70);
Highlight.OutlineTransparency = 0;
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
Highlight.Enabled = false;
Highlight.Parent = workspace;
script.Destroying:Connect(function() -- Line: 217
    -- upvalues: Highlight (copy)
    if Highlight.Parent then
        Highlight:Destroy();
    end;
end);

local function isVampire() -- Line: 223
    -- upvalues: LocalPlayer (copy)
    local v24;

    if LocalPlayer.Team == nil then
        v24 = false;
    else
        v24 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    return v24;
end;

local function isInfected() -- Line: 227
    -- upvalues: LocalPlayer (copy)
    local v25;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v25 = false;
    else
        local v26;

        if LocalPlayer.Team == nil then
            v26 = false;
        else
            v26 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v25 = not v26;
    end;

    return v25;
end;

local function isAbilityUnlocked(p27) -- Line: 233
    -- upvalues: LocalPlayer (copy)
    if p27 and (p27.config and p27.config.Enabled == false) then
        return false;
    end;

    local v28 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_max_ret = math.max(0, v28);
    local v29 = tonumber(p27 and p27.config and p27.config.UnlockYears);

    return v29 == nil and true or v29 <= math_max_ret;
end;

local function now() -- Line: 242
    return workspace:GetServerTimeNow();
end;

local function isUsableCharacter() -- Line: 246
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v30;

    if Character then
        v30 = Character:FindFirstChildOfClass("Humanoid");
    else
        v30 = Character;
    end;

    local v31;

    if LocalPlayer.Team == nil then
        v31 = false;
    else
        v31 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    local v32, v33;

    if v31 then
        if Character == nil or (v30 == nil or (v30.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true))))) then
            v32 = false;
        elseif LocalPlayer:GetAttribute("BloodThirst") == nil or LocalPlayer:GetAttribute("BloodThirst") > 0 then
            v32 = true;
        elseif LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
            v32 = false;
        else
            if LocalPlayer.Team == nil then
                v33 = false;
            else
                v33 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
            end;

            v32 = not v33;
        end;
    else
        if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
            v32 = false;
        else
            local v34;

            if LocalPlayer.Team == nil then
                v34 = false;
            else
                v34 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
            end;

            v32 = not v34;
        end;

        if v32 then
            if Character == nil or (v30 == nil or (v30.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true))))) then
                v32 = false;
            elseif LocalPlayer:GetAttribute("BloodThirst") == nil or LocalPlayer:GetAttribute("BloodThirst") > 0 then
                v32 = true;
            elseif LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v32 = false;
            else
                if LocalPlayer.Team == nil then
                    v33 = false;
                else
                    v33 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v32 = not v33;
            end;
        end;
    end;

    return v32;
end;

local function restoreButton(p35) -- Line: 262
    -- upvalues: u5 (copy)
    local button = p35.button;
    local v36;

    if button then
        v36 = u5[button];
    else
        v36 = button;
    end;

    if not (button and v36) then
        return;
    end;

    button.Active = true;

    if button:IsA("GuiButton") then
        button.AutoButtonColor = v36.autoButtonColor == true;
    end;

    if button:IsA("TextLabel") and v36.textColor then
        button.TextColor3 = v36.textColor;
        button.TextTransparency = v36.textTransparency or 0;
    elseif button:IsA("ImageButton") and v36.imageColor then
        button.ImageColor3 = v36.imageColor;
        button.ImageTransparency = v36.imageTransparency or 0;
    end;

    button.BackgroundColor3 = v36.backgroundColor;
    button.BackgroundTransparency = v36.backgroundTransparency;
    button:SetAttribute("PowerCooldown", 0);
end;

local function darkenButton(p37, p38) -- Line: 284
    -- upvalues: u5 (copy)
    local button = p37.button;
    local v39;

    if button then
        v39 = u5[button];
    else
        v39 = button;
    end;

    if not (button and v39) then
        return;
    end;

    button.Active = false;

    if button:IsA("GuiButton") then
        button.AutoButtonColor = false;
    end;

    if button:IsA("TextLabel") and v39.textColor then
        button.TextColor3 = v39.textColor:Lerp(Color3.new(0, 0, 0), 0.62);
        button.TextTransparency = math.min(0.82, (v39.textTransparency or 0) + 0.25);
    elseif button:IsA("ImageButton") and v39.imageColor then
        button.ImageColor3 = v39.imageColor:Lerp(Color3.new(0, 0, 0), 0.58);
        button.ImageTransparency = math.min(0.85, (v39.imageTransparency or 0) + 0.08);
    end;

    button.BackgroundColor3 = v39.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.58);
    button.BackgroundTransparency = v39.backgroundTransparency;
    local v40 = p38 - workspace:GetServerTimeNow();
    button:SetAttribute("PowerCooldown", (math.max(0, v40)));
end;

local function clearHighlight() -- Line: 393
    -- upvalues: Highlight (copy), u21 (ref)
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u21 = nil;
end;

local function findCharacterModel(p41) -- Line: 399
    while p41 and p41 ~= workspace do
        if p41:IsA("Model") and p41:FindFirstChildOfClass("Humanoid") then
            return p41;
        end;

        p41 = p41.Parent;
    end;

    return nil;
end;

local function isTargetEligible(p42, p43) -- Line: 410
    -- upvalues: LocalPlayer (copy), Players (copy), u4 (copy)
    if not p43 or p43 == LocalPlayer.Character then
        return false;
    end;

    if p43:GetAttribute("Invulnerable") == true or p43:GetAttribute("QuestNPC") == true then
        return false;
    end;

    local v44 = p43:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p43:FindFirstChild("HumanoidRootPart");
    local v45 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not (v44 and (v44.Health > 0 and (HumanoidRootPart and v45))) then
        return false;
    end;

    if p43:GetAttribute("ActionLocked") or (p43:GetAttribute("Hibernating") or p43:GetAttribute("BreakNeckRecovering")) then
        return false;
    end;

    if (HumanoidRootPart.Position - v45.Position).Magnitude > p42.config.MaximumDistance + 2 then
        return false;
    end;

    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p43);
    local v46 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_max_ret = math.max(0, v46);

    if PlayerFromCharacter then
        local v47 = PlayerFromCharacter.Team and PlayerFromCharacter.Team.Name;
        local v48 = tonumber(PlayerFromCharacter:GetAttribute("Years")) or 0;
        local math_max_ret2 = math.max(0, v48);
        local v49 = v47 == "Humans" and true or v47 == "Witches";

        if p42 == u4.HeartRipping then
            return (v49 or ((v47 == "VampireHunter" or v47 == "Vampires") and true or v47 == "Cannibal Raised")) and math_max_ret2 < math_max_ret;
        end;

        if p42 == u4.BloodDrink then
            if v49 then
                return true;
            end;

            local v50;

            if (v47 == "Vampires" or v47 == "Cannibal Raised") and p42.config.VampireTargetMinimumYears <= math_max_ret then
                v50 = math_max_ret2 < math_max_ret;
            else
                v50 = false;
            end;

            return v50;
        end;

        if p42 == u4.Infect or p42 == u4.Hypnosis then
            return v49;
        end;

        if p42 == u4.BreakNeck and (v47 == "Vampires" or v47 == "Cannibal Raised") then
            return math_max_ret2 <= math_max_ret;
        end;

        return v49 or ((v47 == "Vampires" or v47 == "Cannibal Raised") and true or v47 == "Werewolfs");
    end;

    local v51 = (p43:GetAttribute("IsVampire") == true or p43:GetAttribute("Team") == "Vampires") and true or p43:GetAttribute("Team") == "Cannibal Raised";
    local v52 = tonumber(p43:GetAttribute("Years")) or 0;
    local math_max_ret2 = math.max(0, v52);

    if p42 == u4.HeartRipping then
        local v53;

        if p43:GetAttribute("Team") == "Werewolfs" then
            v53 = false;
        else
            v53 = math_max_ret2 < math_max_ret;
        end;

        return v53;
    end;

    if p42 == u4.BloodDrink then
        if not v51 then
            return p43:GetAttribute("Team") ~= "Werewolfs";
        end;

        local v54;

        if p42.config.VampireTargetMinimumYears <= math_max_ret then
            v54 = math_max_ret2 < math_max_ret;
        else
            v54 = false;
        end;

        return v54;
    end;

    if p42 == u4.BreakNeck and v51 then
        return math_max_ret2 <= math_max_ret;
    end;

    if p42 == u4.Hypnosis then
        local v55;

        if p43:GetAttribute("IsVampire") == true or (p43:GetAttribute("Team") == "Vampires" or p43:GetAttribute("Team") == "Cannibal Raised") then
            v55 = false;
        else
            v55 = p43:GetAttribute("Team") ~= "Werewolfs";
        end;

        return v55;
    end;

    if p42 == u4.Infect then
        local v56;

        if p43:GetAttribute("VampireInfected") == true or (p43:GetAttribute("IsVampire") == true or p43:GetAttribute("Team") == "Vampires") then
            v56 = false;
        else
            v56 = p43:GetAttribute("Team") ~= "Cannibal Raised";
        end;

        return v56;
    end;

    if p42 ~= u4.BloodDrink then
        return true;
    end;

    local v57;

    if p43:GetAttribute("IsVampire") == true or p43:GetAttribute("Team") == "Vampires" then
        v57 = false;
    else
        v57 = p43:GetAttribute("Team") ~= "Cannibal Raised";
    end;

    return v57;
end;

local function findClosestTargetInFront(p58) -- Line: 496
    -- upvalues: LocalPlayer (copy), isTargetEligible (copy)
    local Character = LocalPlayer.Character;
    local v59;

    if Character then
        v59 = Character:FindFirstChild("HumanoidRootPart");
    else
        v59 = Character;
    end;

    if not v59 then
        return nil;
    end;

    local v60 = tonumber(p58.config.MaximumDistance) or 10;
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = { Character };
    RaycastParams_new_ret.IgnoreWater = true;
    local v61 = (1 / 0);
    local v62 = nil;

    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("Humanoid") then
            local Parent2 = descendant.Parent;
            local v63;

            if Parent2 then
                v63 = Parent2:FindFirstChild("HumanoidRootPart");
            else
                v63 = Parent2;
            end;

            if Parent2 and (v63 and isTargetEligible(p58, Parent2)) then
                local v64 = v63.Position - v59.Position;
                local Vector3_new_ret = Vector3.new(v64.X, 0, v64.Z);
                local Magnitude = v64.Magnitude;

                if Magnitude > 0.05 and (Magnitude <= v60 + 2 and (Vector3_new_ret.Magnitude > 0.05 and (v59.CFrame.LookVector:Dot(Vector3_new_ret.Unit) >= 0 and Magnitude < v61))) then
                    local v65 = v59.Position + Vector3.new(0, 1.25, 0);
                    local v66 = workspace:Raycast(v65, v63.Position + Vector3.new(0, 1, 0) - v65, RaycastParams_new_ret);

                    if not v66 or v66.Instance:IsDescendantOf(Parent2) then
                        v62 = Parent2;
                        v61 = Magnitude;
                    end;
                end;
            end;
        end;
    end;

    return v62;
end;

local function updateHighlight() -- Line: 538
    -- upvalues: u22 (ref), Highlight (copy), u21 (ref), findCharacterModel (copy), LocalPlayer (copy), isTargetEligible (copy)
    if not (u22 and u22.ability) then
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u21 = nil;

        return;
    end;

    if workspace:GetServerTimeNow() >= u22.endTime then
        u22 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u21 = nil;

        return;
    end;

    local v67 = findCharacterModel(LocalPlayer:GetMouse().Target);

    if isTargetEligible(u22.ability, v67) then
        u21 = v67;
        Highlight.Adornee = v67;
        Highlight.Enabled = true;

        return;
    end;

    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u21 = nil;
end;

local function resetSelection() -- Line: 559
    -- upvalues: u23 (ref), u22 (ref), Highlight (copy), u21 (ref), u4 (copy), restoreButton (copy)
    u23 = u23 + 1;
    u22 = nil;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u21 = nil;

    for _, v in pairs(u4) do
        if v.button then
            restoreButton(v);
        end;

        v.cooldownEnd = 0;
        v.awaitingSelection = false;
        v.awaitingActivation = false;
        v.pendingAutoTarget = nil;
    end;
end;

local function activateTrack(u68) -- Line: 574
    -- upvalues: isUsableCharacter (copy), darkenButton (copy), restoreButton (copy)
    if not isUsableCharacter() or workspace:GetServerTimeNow() < (u68.cooldownEnd or 0) then
        return;
    end;

    local u69 = workspace:GetServerTimeNow() + u68.config.HighlightDuration + u68.config.Cooldown;
    u68.cooldownEnd = u69;
    darkenButton(u68, u69);
    u68.awaitingActivation = true;
    u68.remote:FireServer("UI");
    task.delay(1.5, function() -- Line: 583
        -- upvalues: u68 (copy), u69 (copy), restoreButton (ref)
        if u68.awaitingActivation and workspace:GetServerTimeNow() < u69 then
            u68.awaitingActivation = false;
            u68.cooldownEnd = 0;
            restoreButton(u68);
        end;
    end);
end;

local function beginTargetAbility(u70) -- Line: 592
    -- upvalues: isUsableCharacter (copy), u22 (ref), u4 (copy), getEquippedEmptyBloodContainer (copy), findClosestTargetInFront (copy), darkenButton (copy)
    if not isUsableCharacter() or workspace:GetServerTimeNow() < (u70.cooldownEnd or 0) then
        return;
    end;

    if u22 then
        return;
    end;

    local v71 = u70 == u4.BloodDrink and getEquippedEmptyBloodContainer();

    if v71 then
        (u70.requestRemote or u70.remote):FireServer("FillContainer", v71);

        return;
    end;

    local v72 = findClosestTargetInFront(u70);

    if not v72 then
        if u70.action == "Attack" then
            print("[HeartRipping Client] Nenhum alvo automático encontrado na frente.");
        end;

        return;
    end;

    if u70.action == "Attack" then
        print("[HeartRipping Client] Alvo encontrado:", v72.Name);
    end;

    local Cooldown = u70.config.Cooldown;

    if u70.commandMode then
        Cooldown = Cooldown + u70.config.CommandTime;
    end;

    u70.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
    u70.awaitingSelection = false;
    u70.pendingAutoTarget = nil;
    u70.directActivation = true;
    darkenButton(u70, u70.cooldownEnd);
    local v73 = u70.requestRemote or u70.remote;
    v73:FireServer("Begin", "UI");
    v73:FireServer(u70.action, v72, "UI");
    task.delay(2, function() -- Line: 639
        -- upvalues: u70 (copy)
        u70.directActivation = false;
    end);
end;

local function activate(p74) -- Line: 644
    -- upvalues: Parent (copy), LocalPlayer (copy), u4 (copy), beginTargetAbility (copy), activateTrack (copy)
    if not (p74 and (p74.button and Parent.Visible)) then
        return;
    end;

    local v75;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v75 = false;
    else
        local v76;

        if LocalPlayer.Team == nil then
            v76 = false;
        else
            v76 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v75 = not v76;
    end;

    if v75 then
        if p74 ~= u4.BloodDrink then
            return;
        end;
    else
        local v77;

        if LocalPlayer.Team == nil then
            v77 = false;
        else
            v77 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if not v77 then
            return;
        end;

        local v78;

        if p74 and (p74.config and p74.config.Enabled == false) then
            v78 = false;
        else
            local v79 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
            local math_max_ret = math.max(0, v79);
            local v80 = tonumber(p74 and p74.config and p74.config.UnlockYears);
            v78 = v80 == nil and true or v80 <= math_max_ret;
        end;

        if not v78 then
            return;
        end;
    end;

    if p74.targetMode then
        beginTargetAbility(p74);

        return;
    end;

    activateTrack(p74);
end;

local function updateInfectLockDisplay(p81) -- Line: 323
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.Infect.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v82 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v82 and v82:IsA("TextLabel") then
        v82.Text = "LV " .. tostring(u4.Infect.config and u4.Infect.config.UnlockYears or 150);
        v82.Visible = not p81;
    end;

    if not p81 then
        darkenButton(u4.Infect, now());
    end;
end;

local function updateBreakNeckLockDisplay(p83) -- Line: 306
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.BreakNeck.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v84 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v84 and v84:IsA("TextLabel") then
        v84.Text = "LV " .. tostring(u4.BreakNeck.config and u4.BreakNeck.config.UnlockYears or 5);
        v84.Visible = not p83;
    end;

    if not p83 then
        darkenButton(u4.BreakNeck, now());
    end;
end;

local function updateHypnosisLockDisplay(p85) -- Line: 357
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.Hypnosis.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v86 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v86 and v86:IsA("TextLabel") then
        v86.Text = "LV " .. tostring(u4.Hypnosis.config and u4.Hypnosis.config.UnlockYears or 20);
        v86.Visible = not p85;
    end;

    if not p85 then
        darkenButton(u4.Hypnosis, now());
    end;
end;

local function updateHeartRippingLockDisplay(p87) -- Line: 340
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.HeartRipping.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v88 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v88 and v88:IsA("TextLabel") then
        v88.Text = "LV " .. tostring(u4.HeartRipping.config and u4.HeartRipping.config.UnlockYears or 150);
        v88.Visible = not p87;
    end;

    if not p87 then
        darkenButton(u4.HeartRipping, now());
    end;
end;

local function updateBatFormLockDisplay(p89) -- Line: 374
    -- upvalues: u4 (copy), LocalPlayer (copy), darkenButton (copy), now (copy)
    local button = u4.BatForm.button;

    if not button then
        return;
    end;

    local v90;

    if u4.BatForm.config.Enabled == false then
        v90 = false;
    else
        if LocalPlayer.Team == nil then
            v90 = false;
        else
            v90 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if v90 then
            local v91;

            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v91 = false;
            else
                local v92;

                if LocalPlayer.Team == nil then
                    v92 = false;
                else
                    v92 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v91 = not v92;
            end;

            v90 = not v91;
        end;
    end;

    button.Visible = v90;
    local v93 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v93 and v93:IsA("TextLabel") then
        v93.Text = "LV " .. tostring(u4.BatForm.config and u4.BatForm.config.UnlockYears or 300);
        v93.Visible = not p89;
    end;

    if not p89 then
        darkenButton(u4.BatForm, now());
    end;
end;

for _, v in pairs(u4) do
    if v.button then
        local button = v.button;
        button.Active = true;

        if button:IsA("GuiButton") then
            button.Activated:Connect(function() -- Line: 674
                -- upvalues: activate (copy), v (copy)
                activate(v);
            end);
        else
            button.InputBegan:Connect(function(p94) -- Line: 678
                -- upvalues: activate (copy), v (copy)
                if p94.UserInputType == Enum.UserInputType.MouseButton1 or p94.UserInputType == Enum.UserInputType.Touch then
                    activate(v);
                end;
            end);
        end;
    end;

    if v.targetMode then
        v.remote.OnClientEvent:Connect(function(p95, p96) -- Line: 689
            -- upvalues: u22 (ref), Highlight (copy), u21 (ref), v (copy), darkenButton (copy), restoreButton (copy), u23 (ref), isTargetEligible (copy), findClosestTargetInFront (copy), updateHighlight (copy)
            if p95 == "ContainerStarted" then
                u22 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u21 = nil;
                v.cooldownEnd = tonumber(p96) or workspace:GetServerTimeNow() + 6;
                darkenButton(v, v.cooldownEnd);

                return;
            end;

            if p95 == "ContainerEnded" then
                u22 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u21 = nil;
                v.cooldownEnd = 0;
                restoreButton(v);

                return;
            end;

            if p95 ~= "SelectionStarted" then
                if p95 == "SelectionEnded" then
                    if v.commandMode and tonumber(p96) then
                        v.cooldownEnd = tonumber(p96);
                        darkenButton(v, v.cooldownEnd);
                    end;

                    if u22 and u22.ability == v then
                        u22 = nil;
                        Highlight.Adornee = nil;
                        Highlight.Enabled = false;
                        u21 = nil;
                    end;

                    if workspace:GetServerTimeNow() >= (v.cooldownEnd or 0) then
                        restoreButton(v);

                        return;
                    end;
                else
                    if p95 == "InvalidTarget" then
                        if u22 and u22.ability == v then
                            updateHighlight();
                        end;

                        v.cooldownEnd = 0;
                        restoreButton(v);

                        return;
                    end;

                    if p95 == "CooldownUpdated" and tonumber(p96) then
                        v.cooldownEnd = tonumber(p96);
                        darkenButton(v, v.cooldownEnd);
                    end;
                end;

                return;
            end;

            if v.directActivation then
                v.directActivation = false;

                return;
            end;

            v.awaitingSelection = false;
            u22 = {
                ability = v,
                endTime = tonumber(p96) or workspace:GetServerTimeNow() + v.config.SelectionTime,
                token = u23
            };
            local pendingAutoTarget = v.pendingAutoTarget;
            v.pendingAutoTarget = nil;

            if not isTargetEligible(v, pendingAutoTarget) then
                pendingAutoTarget = findClosestTargetInFront(v);
            end;

            if not pendingAutoTarget then
                u22 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u21 = nil;
                restoreButton(v);

                return;
            end;

            u22 = nil;
            Highlight.Adornee = nil;
            Highlight.Enabled = false;
            u21 = nil;
            local Cooldown = v.config.Cooldown;

            if v.commandMode then
                Cooldown = Cooldown + v.config.CommandTime;
            end;

            v.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
            darkenButton(v, v.cooldownEnd);
            (v.requestRemote or v.remote):FireServer(v.action, pendingAutoTarget, "UI");
        end);
    else
        v.remote.OnClientEvent:Connect(function(p97, p98, p99) -- Line: 758
            -- upvalues: v (copy), darkenButton (copy)
            if p97 == "Activated" then
                v.awaitingActivation = false;
                local v100 = tonumber(p99) or tonumber(p98);

                if v100 then
                    v.cooldownEnd = v100;
                end;

                darkenButton(v, v.cooldownEnd);
            end;
        end);
    end;
end;

UserInputService.InputBegan:Connect(function(p101, p102) -- Line: 771
    -- upvalues: UserInputService (copy), u4 (copy), activate (copy)
    if p102 or UserInputService:GetFocusedTextBox() then
        return;
    end;

    for _, v in pairs(u4) do
        if p101.KeyCode == v.key or p101.KeyCode == v.gamepadKey then
            activate(v);

            return;
        end;
    end;
end);
UserInputService.InputBegan:Connect(function(p103, p104) -- Line: 783
    -- upvalues: u22 (ref), u21 (ref), isTargetEligible (copy), Highlight (copy), darkenButton (copy)
    if p104 or p103.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return;
    end;

    if not (u22 and (u22.ability and workspace:GetServerTimeNow() <= u22.endTime)) then
        return;
    end;

    local ability = u22.ability;
    local v105 = u21;

    if not (v105 and isTargetEligible(ability, v105)) then
        return;
    end;

    u22 = nil;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u21 = nil;
    ability.awaitingSelection = false;
    local Cooldown = ability.config.Cooldown;

    if ability.commandMode then
        Cooldown = Cooldown + ability.config.CommandTime;
    end;

    ability.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
    darkenButton(ability, ability.cooldownEnd);
    (ability.requestRemote or ability.remote):FireServer(ability.action, v105, "UI");
end);
local u106 = 0;
RunService.RenderStepped:Connect(function(p107) -- Line: 809
    -- upvalues: u106 (ref), Parent (copy), LocalPlayer (copy), resetSelection (copy), u4 (copy), u22 (ref), Highlight (copy), u21 (ref), restoreButton (copy), updateHighlight (copy), darkenButton (copy), updateBreakNeckLockDisplay (copy), updateInfectLockDisplay (copy), updateHypnosisLockDisplay (copy), updateHeartRippingLockDisplay (copy), updateBatFormLockDisplay (copy)
    u106 = u106 + p107;

    if u106 < 0.05 then
        return;
    end;

    u106 = 0;
    local Visible = Parent.Visible;

    if Visible then
        if LocalPlayer.Team == nil then
            Visible = false;
        else
            Visible = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if not Visible then
            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                Visible = false;
            else
                local v108;

                if LocalPlayer.Team == nil then
                    v108 = false;
                else
                    v108 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                Visible = not v108;
            end;
        end;
    end;

    if not Visible then
        resetSelection();

        return;
    end;

    local BreakNeck = u4.BreakNeck;
    local v109;

    if BreakNeck and (BreakNeck.config and BreakNeck.config.Enabled == false) then
        v109 = false;
    else
        local v110 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v110);
        local v111 = tonumber(BreakNeck and BreakNeck.config and BreakNeck.config.UnlockYears);
        v109 = v111 == nil and true or v111 <= math_max_ret;
    end;

    if u4.BreakNeck.button then
        u4.BreakNeck.button.Visible = true;
    end;

    if not (v109 or (not u22 or u22.ability ~= u4.BreakNeck)) then
        u22 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u21 = nil;
        u4.BreakNeck.awaitingSelection = false;
        restoreButton(u4.BreakNeck);
    end;

    local Infect = u4.Infect;
    local v112;

    if Infect and (Infect.config and Infect.config.Enabled == false) then
        v112 = false;
    else
        local v113 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v113);
        local v114 = tonumber(Infect and Infect.config and Infect.config.UnlockYears);
        v112 = v114 == nil and true or v114 <= math_max_ret;
    end;

    if u4.Infect.button then
        u4.Infect.button.Visible = true;
    end;

    if not (v112 or (not u22 or u22.ability ~= u4.Infect)) then
        u22 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u21 = nil;
        u4.Infect.awaitingSelection = false;
        restoreButton(u4.Infect);
    end;

    local Hypnosis = u4.Hypnosis;
    local v115;

    if Hypnosis and (Hypnosis.config and Hypnosis.config.Enabled == false) then
        v115 = false;
    else
        local v116 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v116);
        local v117 = tonumber(Hypnosis and Hypnosis.config and Hypnosis.config.UnlockYears);
        v115 = v117 == nil and true or v117 <= math_max_ret;
    end;

    if u4.Hypnosis.button then
        u4.Hypnosis.button.Visible = true;
    end;

    if not (v115 or (not u22 or u22.ability ~= u4.Hypnosis)) then
        u22 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u21 = nil;
        u4.Hypnosis.awaitingSelection = false;
        restoreButton(u4.Hypnosis);
    end;

    local BatForm = u4.BatForm;
    local v118;

    if BatForm and (BatForm.config and BatForm.config.Enabled == false) then
        v118 = false;
    else
        local v119 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v119);
        local v120 = tonumber(BatForm and BatForm.config and BatForm.config.UnlockYears);
        v118 = v120 == nil and true or v120 <= math_max_ret;
    end;

    if u4.BatForm.button then
        local button = u4.BatForm.button;
        local v121;

        if LocalPlayer.Team == nil then
            v121 = false;
        else
            v121 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if v121 then
            local v122;

            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v122 = false;
            else
                local v123;

                if LocalPlayer.Team == nil then
                    v123 = false;
                else
                    v123 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v122 = not v123;
            end;

            v121 = not v122;
        end;

        button.Visible = v121;
    end;

    local HeartRipping = u4.HeartRipping;
    local v124;

    if HeartRipping and (HeartRipping.config and HeartRipping.config.Enabled == false) then
        v124 = false;
    else
        local v125 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v125);
        local v126 = tonumber(HeartRipping and HeartRipping.config and HeartRipping.config.UnlockYears);
        v124 = v126 == nil and true or v126 <= math_max_ret;
    end;

    if u4.HeartRipping.button then
        u4.HeartRipping.button.Visible = true;
    end;

    if not (v124 or (not u22 or u22.ability ~= u4.HeartRipping)) then
        u22 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u21 = nil;
        u4.HeartRipping.awaitingSelection = false;
        restoreButton(u4.HeartRipping);
    end;

    updateHighlight();
    local ServerTimeNow = workspace:GetServerTimeNow();

    for _, v in pairs(u4) do
        if v.button then
            local v127 = v.button:FindFirstChild("Coldown") or v.button:FindFirstChild("COLDOWN");

            if v.cooldownEnd and (v.cooldownEnd > 0 and ServerTimeNow < v.cooldownEnd) then
                local math_ceil_ret = math.ceil(v.cooldownEnd - ServerTimeNow);
                v.button:SetAttribute("PowerCooldown", math_ceil_ret);

                if v127 and v127:IsA("TextLabel") then
                    v127.Text = tostring(math_ceil_ret);
                    v127.Visible = true;
                end;

                darkenButton(v, v.cooldownEnd);
            else
                if v127 and v127:IsA("TextLabel") then
                    v127.Text = "";
                    v127.Visible = false;
                end;

                if not (v.awaitingSelection or (v.awaitingActivation or u22 and u22.ability == v)) then
                    v.cooldownEnd = 0;
                    restoreButton(v);
                end;
            end;
        end;
    end;

    updateBreakNeckLockDisplay(v109);
    updateInfectLockDisplay(v112);
    updateHypnosisLockDisplay(v115);
    updateHeartRippingLockDisplay(v124);
    updateBatFormLockDisplay(v118);
    local v128;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v128 = false;
    else
        local v129;

        if LocalPlayer.Team == nil then
            v129 = false;
        else
            v129 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v128 = not v129;
    end;

    for _, v in pairs(u4) do
        if v.button then
            v.button.Visible = not v128 or v == u4.BloodDrink;
        end;
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 913
    -- upvalues: LocalPlayer (copy), resetSelection (copy)
    local v130;

    if LocalPlayer.Team == nil then
        v130 = false;
    else
        v130 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    if not v130 then
        resetSelection();
    end;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 920
    -- upvalues: resetSelection (copy)
    resetSelection();
    task.defer(function() -- Line: 922
    end);
end);