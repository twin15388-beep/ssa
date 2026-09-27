-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
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

local function isDesktopInterface() -- Line: 16
    -- upvalues: TeamGuiLayout (copy)
    return TeamGuiLayout.GetMode() == "PC";
end;

local function findButton(p2) -- Line: 20
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

local function getEquippedEmptyBloodContainer() -- Line: 102
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
        local v6 = {};
        local v7;

        if button:IsA("TextLabel") then
            v7 = button.TextColor3 or nil;
        else
            v7 = nil;
        end;

        v6.textColor = v7;
        local v8;

        if button:IsA("TextLabel") then
            v8 = button.TextTransparency or nil;
        else
            v8 = nil;
        end;

        v6.textTransparency = v8;
        local v9;

        if button:IsA("ImageButton") then
            v9 = button.ImageColor3 or nil;
        else
            v9 = nil;
        end;

        v6.imageColor = v9;
        local v10;

        if button:IsA("ImageButton") then
            v10 = button.ImageTransparency or nil;
        else
            v10 = nil;
        end;

        v6.imageTransparency = v10;
        v6.backgroundColor = button.BackgroundColor3;
        v6.backgroundTransparency = button.BackgroundTransparency;
        local v11;

        if button:IsA("GuiButton") then
            v11 = button.AutoButtonColor or nil;
        else
            v11 = nil;
        end;

        v6.autoButtonColor = v11;
        u5[button] = v6;
        local v12 = button:FindFirstChild("Coldown") or button:FindFirstChild("COLDOWN");

        if v12 and v12:IsA("TextLabel") then
            v12.Active = false;
            v12.Visible = false;
            v12.Text = "";
        end;

        local UNLOCKLV = button:FindFirstChild("UNLOCKLV");

        if UNLOCKLV and UNLOCKLV:IsA("TextLabel") then
            UNLOCKLV.Visible = false;
        end;
    end;
end;

local Name = Parent.Name;
local u13 = nil;
local u14 = nil;
local u15 = 0;

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
script.Destroying:Connect(function() -- Line: 162
    -- upvalues: Highlight (copy)
    if Highlight.Parent then
        Highlight:Destroy();
    end;
end);

local function isVampire() -- Line: 168
    -- upvalues: LocalPlayer (copy)
    local v16;

    if LocalPlayer.Team == nil then
        v16 = false;
    else
        v16 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    return v16;
end;

local function isInfected() -- Line: 172
    -- upvalues: LocalPlayer (copy)
    local v17;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v17 = false;
    else
        local v18;

        if LocalPlayer.Team == nil then
            v18 = false;
        else
            v18 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v17 = not v18;
    end;

    return v17;
end;

local function isAbilityUnlocked(p19) -- Line: 178
    -- upvalues: LocalPlayer (copy)
    if p19 and (p19.config and p19.config.Enabled == false) then
        return false;
    end;

    local v20 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_max_ret = math.max(0, v20);
    local v21 = tonumber(p19 and p19.config and p19.config.UnlockYears);

    return v21 == nil and true or v21 <= math_max_ret;
end;

local function now() -- Line: 187
    return workspace:GetServerTimeNow();
end;

local function isUsableCharacter() -- Line: 191
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v22;

    if Character then
        v22 = Character:FindFirstChildOfClass("Humanoid");
    else
        v22 = Character;
    end;

    local v23;

    if LocalPlayer.Team == nil then
        v23 = false;
    else
        v23 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    local v24, v25;

    if v23 then
        if Character == nil or (v22 == nil or (v22.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true))))) then
            v24 = false;
        elseif LocalPlayer:GetAttribute("BloodThirst") == nil or LocalPlayer:GetAttribute("BloodThirst") > 0 then
            v24 = true;
        elseif LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
            v24 = false;
        else
            if LocalPlayer.Team == nil then
                v25 = false;
            else
                v25 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
            end;

            v24 = not v25;
        end;
    else
        if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
            v24 = false;
        else
            local v26;

            if LocalPlayer.Team == nil then
                v26 = false;
            else
                v26 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
            end;

            v24 = not v26;
        end;

        if v24 then
            if Character == nil or (v22 == nil or (v22.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true))))) then
                v24 = false;
            elseif LocalPlayer:GetAttribute("BloodThirst") == nil or LocalPlayer:GetAttribute("BloodThirst") > 0 then
                v24 = true;
            elseif LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v24 = false;
            else
                if LocalPlayer.Team == nil then
                    v25 = false;
                else
                    v25 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v24 = not v25;
            end;
        end;
    end;

    return v24;
end;

local function restoreButton(p27) -- Line: 207
    -- upvalues: u5 (copy)
    local button = p27.button;
    local v28;

    if button then
        v28 = u5[button];
    else
        v28 = button;
    end;

    if not (button and v28) then
        return;
    end;

    button.Active = true;

    if button:IsA("GuiButton") then
        button.AutoButtonColor = v28.autoButtonColor == true;
    end;

    if button:IsA("TextLabel") and v28.textColor then
        button.TextColor3 = v28.textColor;
        button.TextTransparency = v28.textTransparency or 0;
    elseif button:IsA("ImageButton") and v28.imageColor then
        button.ImageColor3 = v28.imageColor;
        button.ImageTransparency = v28.imageTransparency or 0;
    end;

    button.BackgroundColor3 = v28.backgroundColor;
    button.BackgroundTransparency = v28.backgroundTransparency;
    button:SetAttribute("PowerCooldown", 0);
end;

local function darkenButton(p29, p30) -- Line: 229
    -- upvalues: u5 (copy)
    local button = p29.button;
    local v31;

    if button then
        v31 = u5[button];
    else
        v31 = button;
    end;

    if not (button and v31) then
        return;
    end;

    button.Active = false;

    if button:IsA("GuiButton") then
        button.AutoButtonColor = false;
    end;

    if button:IsA("TextLabel") and v31.textColor then
        button.TextColor3 = v31.textColor:Lerp(Color3.new(0, 0, 0), 0.62);
        button.TextTransparency = math.min(0.82, (v31.textTransparency or 0) + 0.25);
    elseif button:IsA("ImageButton") and v31.imageColor then
        button.ImageColor3 = v31.imageColor:Lerp(Color3.new(0, 0, 0), 0.58);
        button.ImageTransparency = math.min(0.85, (v31.imageTransparency or 0) + 0.08);
    end;

    button.BackgroundColor3 = v31.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.58);
    button.BackgroundTransparency = v31.backgroundTransparency;
    local v32 = p30 - workspace:GetServerTimeNow();
    button:SetAttribute("PowerCooldown", (math.max(0, v32)));
end;

local function clearHighlight() -- Line: 338
    -- upvalues: Highlight (copy), u13 (ref)
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u13 = nil;
end;

local function findCharacterModel(p33) -- Line: 344
    while p33 and p33 ~= workspace do
        if p33:IsA("Model") and p33:FindFirstChildOfClass("Humanoid") then
            return p33;
        end;

        p33 = p33.Parent;
    end;

    return nil;
end;

local function isTargetEligible(p34, p35) -- Line: 355
    -- upvalues: LocalPlayer (copy), Players (copy), u4 (copy)
    if not p35 or p35 == LocalPlayer.Character then
        return false;
    end;

    if p35:GetAttribute("Invulnerable") == true or p35:GetAttribute("QuestNPC") == true then
        return false;
    end;

    local v36 = p35:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p35:FindFirstChild("HumanoidRootPart");
    local v37 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not (v36 and (v36.Health > 0 and (HumanoidRootPart and v37))) then
        return false;
    end;

    if p35:GetAttribute("ActionLocked") or (p35:GetAttribute("Hibernating") or p35:GetAttribute("BreakNeckRecovering")) then
        return false;
    end;

    if (HumanoidRootPart.Position - v37.Position).Magnitude > p34.config.MaximumDistance + 2 then
        return false;
    end;

    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p35);
    local v38 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_max_ret = math.max(0, v38);

    if PlayerFromCharacter then
        local v39 = PlayerFromCharacter.Team and PlayerFromCharacter.Team.Name;
        local v40 = tonumber(PlayerFromCharacter:GetAttribute("Years")) or 0;
        local math_max_ret2 = math.max(0, v40);
        local v41 = v39 == "Humans" and true or v39 == "Witches";

        if p34 == u4.HeartRipping then
            return (v41 or ((v39 == "VampireHunter" or v39 == "Vampires") and true or v39 == "Cannibal Raised")) and math_max_ret2 < math_max_ret;
        end;

        if p34 == u4.BloodDrink then
            if v41 then
                return true;
            end;

            local v42;

            if (v39 == "Vampires" or v39 == "Cannibal Raised") and p34.config.VampireTargetMinimumYears <= math_max_ret then
                v42 = math_max_ret2 < math_max_ret;
            else
                v42 = false;
            end;

            return v42;
        end;

        if p34 == u4.Infect or p34 == u4.Hypnosis then
            return v41;
        end;

        if p34 == u4.BreakNeck and (v39 == "Vampires" or v39 == "Cannibal Raised") then
            return math_max_ret2 <= math_max_ret;
        end;

        return v41 or ((v39 == "Vampires" or v39 == "Cannibal Raised") and true or v39 == "Werewolfs");
    end;

    local v43 = (p35:GetAttribute("IsVampire") == true or p35:GetAttribute("Team") == "Vampires") and true or p35:GetAttribute("Team") == "Cannibal Raised";
    local v44 = tonumber(p35:GetAttribute("Years")) or 0;
    local math_max_ret2 = math.max(0, v44);

    if p34 == u4.HeartRipping then
        local v45;

        if p35:GetAttribute("Team") == "Werewolfs" then
            v45 = false;
        else
            v45 = math_max_ret2 < math_max_ret;
        end;

        return v45;
    end;

    if p34 == u4.BloodDrink then
        if not v43 then
            return p35:GetAttribute("Team") ~= "Werewolfs";
        end;

        local v46;

        if p34.config.VampireTargetMinimumYears <= math_max_ret then
            v46 = math_max_ret2 < math_max_ret;
        else
            v46 = false;
        end;

        return v46;
    end;

    if p34 == u4.BreakNeck and v43 then
        return math_max_ret2 <= math_max_ret;
    end;

    if p34 == u4.Hypnosis then
        local v47;

        if p35:GetAttribute("IsVampire") == true or (p35:GetAttribute("Team") == "Vampires" or p35:GetAttribute("Team") == "Cannibal Raised") then
            v47 = false;
        else
            v47 = p35:GetAttribute("Team") ~= "Werewolfs";
        end;

        return v47;
    end;

    if p34 == u4.Infect then
        local v48;

        if p35:GetAttribute("VampireInfected") == true or (p35:GetAttribute("IsVampire") == true or p35:GetAttribute("Team") == "Vampires") then
            v48 = false;
        else
            v48 = p35:GetAttribute("Team") ~= "Cannibal Raised";
        end;

        return v48;
    end;

    if p34 ~= u4.BloodDrink then
        return true;
    end;

    local v49;

    if p35:GetAttribute("IsVampire") == true or p35:GetAttribute("Team") == "Vampires" then
        v49 = false;
    else
        v49 = p35:GetAttribute("Team") ~= "Cannibal Raised";
    end;

    return v49;
end;

local function findClosestTargetInFront(p50) -- Line: 441
    -- upvalues: LocalPlayer (copy), isTargetEligible (copy)
    local Character = LocalPlayer.Character;
    local v51;

    if Character then
        v51 = Character:FindFirstChild("HumanoidRootPart");
    else
        v51 = Character;
    end;

    if not v51 then
        return nil;
    end;

    local v52 = tonumber(p50.config.MaximumDistance) or 10;
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = { Character };
    RaycastParams_new_ret.IgnoreWater = true;
    local v53 = (1 / 0);
    local v54 = nil;

    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("Humanoid") then
            local Parent2 = descendant.Parent;
            local v55;

            if Parent2 then
                v55 = Parent2:FindFirstChild("HumanoidRootPart");
            else
                v55 = Parent2;
            end;

            if Parent2 and (v55 and isTargetEligible(p50, Parent2)) then
                local v56 = v55.Position - v51.Position;
                local Vector3_new_ret = Vector3.new(v56.X, 0, v56.Z);
                local Magnitude = v56.Magnitude;

                if Magnitude > 0.05 and (Magnitude <= v52 + 2 and (Vector3_new_ret.Magnitude > 0.05 and (v51.CFrame.LookVector:Dot(Vector3_new_ret.Unit) >= 0 and Magnitude < v53))) then
                    local v57 = v51.Position + Vector3.new(0, 1.25, 0);
                    local v58 = workspace:Raycast(v57, v55.Position + Vector3.new(0, 1, 0) - v57, RaycastParams_new_ret);

                    if not v58 or v58.Instance:IsDescendantOf(Parent2) then
                        v54 = Parent2;
                        v53 = Magnitude;
                    end;
                end;
            end;
        end;
    end;

    return v54;
end;

local function updateHighlight() -- Line: 483
    -- upvalues: u14 (ref), Highlight (copy), u13 (ref), findCharacterModel (copy), LocalPlayer (copy), isTargetEligible (copy)
    if not (u14 and u14.ability) then
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u13 = nil;

        return;
    end;

    if workspace:GetServerTimeNow() >= u14.endTime then
        u14 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u13 = nil;

        return;
    end;

    local v59 = findCharacterModel(LocalPlayer:GetMouse().Target);

    if isTargetEligible(u14.ability, v59) then
        u13 = v59;
        Highlight.Adornee = v59;
        Highlight.Enabled = true;

        return;
    end;

    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u13 = nil;
end;

local function resetSelection() -- Line: 504
    -- upvalues: u15 (ref), u14 (ref), Highlight (copy), u13 (ref), u4 (copy), restoreButton (copy)
    u15 = u15 + 1;
    u14 = nil;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u13 = nil;

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

local function activateTrack(u60) -- Line: 519
    -- upvalues: isUsableCharacter (copy), darkenButton (copy), restoreButton (copy)
    if not isUsableCharacter() or workspace:GetServerTimeNow() < (u60.cooldownEnd or 0) then
        return;
    end;

    local u61 = workspace:GetServerTimeNow() + u60.config.HighlightDuration + u60.config.Cooldown;
    u60.cooldownEnd = u61;
    darkenButton(u60, u61);
    u60.awaitingActivation = true;
    u60.remote:FireServer("UI");
    task.delay(1.5, function() -- Line: 528
        -- upvalues: u60 (copy), u61 (copy), restoreButton (ref)
        if u60.awaitingActivation and workspace:GetServerTimeNow() < u61 then
            u60.awaitingActivation = false;
            u60.cooldownEnd = 0;
            restoreButton(u60);
        end;
    end);
end;

local function beginTargetAbility(u62) -- Line: 537
    -- upvalues: isUsableCharacter (copy), u14 (ref), u4 (copy), getEquippedEmptyBloodContainer (copy), findClosestTargetInFront (copy), darkenButton (copy)
    if not isUsableCharacter() or workspace:GetServerTimeNow() < (u62.cooldownEnd or 0) then
        return;
    end;

    if u14 then
        return;
    end;

    local v63 = u62 == u4.BloodDrink and getEquippedEmptyBloodContainer();

    if v63 then
        (u62.requestRemote or u62.remote):FireServer("FillContainer", v63);

        return;
    end;

    local v64 = findClosestTargetInFront(u62);

    if not v64 then
        if u62.action == "Attack" then
            print("[HeartRipping Client] Nenhum alvo automático encontrado na frente.");
        end;

        return;
    end;

    if u62.action == "Attack" then
        print("[HeartRipping Client] Alvo encontrado:", v64.Name);
    end;

    local Cooldown = u62.config.Cooldown;

    if u62.commandMode then
        Cooldown = Cooldown + u62.config.CommandTime;
    end;

    u62.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
    u62.awaitingSelection = false;
    u62.pendingAutoTarget = nil;
    u62.directActivation = true;
    darkenButton(u62, u62.cooldownEnd);
    local v65 = u62.requestRemote or u62.remote;
    v65:FireServer("Begin", "UI");
    v65:FireServer(u62.action, v64, "UI");
    task.delay(2, function() -- Line: 584
        -- upvalues: u62 (copy)
        u62.directActivation = false;
    end);
end;

local function activate(p66) -- Line: 589
    -- upvalues: Parent (copy), LocalPlayer (copy), u4 (copy), beginTargetAbility (copy), activateTrack (copy)
    if not (p66 and (p66.button and Parent.Visible)) then
        return;
    end;

    local v67;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v67 = false;
    else
        local v68;

        if LocalPlayer.Team == nil then
            v68 = false;
        else
            v68 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v67 = not v68;
    end;

    if v67 then
        if p66 ~= u4.BloodDrink then
            return;
        end;
    else
        local v69;

        if LocalPlayer.Team == nil then
            v69 = false;
        else
            v69 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if not v69 then
            return;
        end;

        local v70;

        if p66 and (p66.config and p66.config.Enabled == false) then
            v70 = false;
        else
            local v71 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
            local math_max_ret = math.max(0, v71);
            local v72 = tonumber(p66 and p66.config and p66.config.UnlockYears);
            v70 = v72 == nil and true or v72 <= math_max_ret;
        end;

        if not v70 then
            return;
        end;
    end;

    if p66.targetMode then
        beginTargetAbility(p66);

        return;
    end;

    activateTrack(p66);
end;

local function updateInfectLockDisplay(p73) -- Line: 268
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.Infect.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v74 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v74 and v74:IsA("TextLabel") then
        v74.Text = "LV " .. tostring(u4.Infect.config and u4.Infect.config.UnlockYears or 150);
        v74.Visible = not p73;
    end;

    if not p73 then
        darkenButton(u4.Infect, now());
    end;
end;

local function updateHypnosisLockDisplay(p75) -- Line: 302
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.Hypnosis.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v76 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v76 and v76:IsA("TextLabel") then
        v76.Text = "LV " .. tostring(u4.Hypnosis.config and u4.Hypnosis.config.UnlockYears or 20);
        v76.Visible = not p75;
    end;

    if not p75 then
        darkenButton(u4.Hypnosis, now());
    end;
end;

local function updateHeartRippingLockDisplay(p77) -- Line: 285
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.HeartRipping.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v78 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v78 and v78:IsA("TextLabel") then
        v78.Text = "LV " .. tostring(u4.HeartRipping.config and u4.HeartRipping.config.UnlockYears or 150);
        v78.Visible = not p77;
    end;

    if not p77 then
        darkenButton(u4.HeartRipping, now());
    end;
end;

local function updateBatFormLockDisplay(p79) -- Line: 319
    -- upvalues: u4 (copy), LocalPlayer (copy), darkenButton (copy), now (copy)
    local button = u4.BatForm.button;

    if not button then
        return;
    end;

    local v80;

    if u4.BatForm.config.Enabled == false then
        v80 = false;
    else
        if LocalPlayer.Team == nil then
            v80 = false;
        else
            v80 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if v80 then
            local v81;

            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v81 = false;
            else
                local v82;

                if LocalPlayer.Team == nil then
                    v82 = false;
                else
                    v82 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v81 = not v82;
            end;

            v80 = not v81;
        end;
    end;

    button.Visible = v80;
    local v83 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v83 and v83:IsA("TextLabel") then
        v83.Text = "LV " .. tostring(u4.BatForm.config and u4.BatForm.config.UnlockYears or 300);
        v83.Visible = not p79;
    end;

    if not p79 then
        darkenButton(u4.BatForm, now());
    end;
end;

local function updateBreakNeckLockDisplay(p84) -- Line: 251
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.BreakNeck.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local v85 = button:FindFirstChild("UnlockRequirement") or button:FindFirstChild("UNLOCKLV");

    if v85 and v85:IsA("TextLabel") then
        v85.Text = "LV " .. tostring(u4.BreakNeck.config and u4.BreakNeck.config.UnlockYears or 5);
        v85.Visible = not p84;
    end;

    if not p84 then
        darkenButton(u4.BreakNeck, now());
    end;
end;

for _, v in pairs(u4) do
    if v.button then
        local button = v.button;
        button.Active = true;

        if button:IsA("GuiButton") then
            button.Activated:Connect(function() -- Line: 619
                -- upvalues: activate (copy), v (copy)
                activate(v);
            end);
        else
            button.InputBegan:Connect(function(p86) -- Line: 623
                -- upvalues: activate (copy), v (copy)
                if p86.UserInputType == Enum.UserInputType.MouseButton1 or p86.UserInputType == Enum.UserInputType.Touch then
                    activate(v);
                end;
            end);
        end;
    end;

    if v.targetMode then
        v.remote.OnClientEvent:Connect(function(p87, p88) -- Line: 634
            -- upvalues: u14 (ref), Highlight (copy), u13 (ref), v (copy), darkenButton (copy), restoreButton (copy), u15 (ref), isTargetEligible (copy), findClosestTargetInFront (copy), updateHighlight (copy)
            if p87 == "ContainerStarted" then
                u14 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u13 = nil;
                v.cooldownEnd = tonumber(p88) or workspace:GetServerTimeNow() + 6;
                darkenButton(v, v.cooldownEnd);

                return;
            end;

            if p87 == "ContainerEnded" then
                u14 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u13 = nil;
                v.cooldownEnd = 0;
                restoreButton(v);

                return;
            end;

            if p87 ~= "SelectionStarted" then
                if p87 == "SelectionEnded" then
                    if v.commandMode and tonumber(p88) then
                        v.cooldownEnd = tonumber(p88);
                        darkenButton(v, v.cooldownEnd);
                    end;

                    if u14 and u14.ability == v then
                        u14 = nil;
                        Highlight.Adornee = nil;
                        Highlight.Enabled = false;
                        u13 = nil;
                    end;

                    if workspace:GetServerTimeNow() >= (v.cooldownEnd or 0) then
                        restoreButton(v);

                        return;
                    end;
                else
                    if p87 == "InvalidTarget" then
                        if u14 and u14.ability == v then
                            updateHighlight();
                        end;

                        v.cooldownEnd = 0;
                        restoreButton(v);

                        return;
                    end;

                    if p87 == "CooldownUpdated" and tonumber(p88) then
                        v.cooldownEnd = tonumber(p88);
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
            u14 = {
                ability = v,
                endTime = tonumber(p88) or workspace:GetServerTimeNow() + v.config.SelectionTime,
                token = u15
            };
            local pendingAutoTarget = v.pendingAutoTarget;
            v.pendingAutoTarget = nil;

            if not isTargetEligible(v, pendingAutoTarget) then
                pendingAutoTarget = findClosestTargetInFront(v);
            end;

            if not pendingAutoTarget then
                u14 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u13 = nil;
                restoreButton(v);

                return;
            end;

            u14 = nil;
            Highlight.Adornee = nil;
            Highlight.Enabled = false;
            u13 = nil;
            local Cooldown = v.config.Cooldown;

            if v.commandMode then
                Cooldown = Cooldown + v.config.CommandTime;
            end;

            v.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
            darkenButton(v, v.cooldownEnd);
            (v.requestRemote or v.remote):FireServer(v.action, pendingAutoTarget, "UI");
        end);
    else
        v.remote.OnClientEvent:Connect(function(p89, p90, p91) -- Line: 703
            -- upvalues: v (copy), darkenButton (copy)
            if p89 == "Activated" then
                v.awaitingActivation = false;
                local v92 = tonumber(p91) or tonumber(p90);

                if v92 then
                    v.cooldownEnd = v92;
                end;

                darkenButton(v, v.cooldownEnd);
            end;
        end);
    end;
end;

UserInputService.InputBegan:Connect(function(p93, p94) -- Line: 716
    -- upvalues: UserInputService (copy), u4 (copy), activate (copy)
    if p94 or UserInputService:GetFocusedTextBox() then
        return;
    end;

    for _, v in pairs(u4) do
        if p93.KeyCode == v.key or p93.KeyCode == v.gamepadKey then
            activate(v);

            return;
        end;
    end;
end);
UserInputService.InputBegan:Connect(function(p95, p96) -- Line: 728
    -- upvalues: u14 (ref), u13 (ref), isTargetEligible (copy), Highlight (copy), darkenButton (copy)
    if p96 or p95.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return;
    end;

    if not (u14 and (u14.ability and workspace:GetServerTimeNow() <= u14.endTime)) then
        return;
    end;

    local ability = u14.ability;
    local v97 = u13;

    if not (v97 and isTargetEligible(ability, v97)) then
        return;
    end;

    u14 = nil;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u13 = nil;
    ability.awaitingSelection = false;
    local Cooldown = ability.config.Cooldown;

    if ability.commandMode then
        Cooldown = Cooldown + ability.config.CommandTime;
    end;

    ability.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
    darkenButton(ability, ability.cooldownEnd);
    (ability.requestRemote or ability.remote):FireServer(ability.action, v97, "UI");
end);
local u98 = 0;
RunService.RenderStepped:Connect(function(p99) -- Line: 754
    -- upvalues: u98 (ref), TeamGuiLayout (copy), LocalPlayer (copy), resetSelection (copy), u4 (copy), u14 (ref), Highlight (copy), u13 (ref), restoreButton (copy), updateHighlight (copy), darkenButton (copy), updateBreakNeckLockDisplay (copy), updateInfectLockDisplay (copy), updateHypnosisLockDisplay (copy), updateHeartRippingLockDisplay (copy), updateBatFormLockDisplay (copy)
    u98 = u98 + p99;

    if u98 < 0.05 then
        return;
    end;

    u98 = 0;
    local v100 = TeamGuiLayout.GetMode() == "PC";

    if v100 then
        if LocalPlayer.Team == nil then
            v100 = false;
        else
            v100 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if not v100 then
            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v100 = false;
            else
                local v101;

                if LocalPlayer.Team == nil then
                    v101 = false;
                else
                    v101 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v100 = not v101;
            end;
        end;
    end;

    if not v100 then
        resetSelection();

        return;
    end;

    local BreakNeck = u4.BreakNeck;
    local v102;

    if BreakNeck and (BreakNeck.config and BreakNeck.config.Enabled == false) then
        v102 = false;
    else
        local v103 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v103);
        local v104 = tonumber(BreakNeck and BreakNeck.config and BreakNeck.config.UnlockYears);
        v102 = v104 == nil and true or v104 <= math_max_ret;
    end;

    if u4.BreakNeck.button then
        u4.BreakNeck.button.Visible = true;
    end;

    if not (v102 or (not u14 or u14.ability ~= u4.BreakNeck)) then
        u14 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u13 = nil;
        u4.BreakNeck.awaitingSelection = false;
        restoreButton(u4.BreakNeck);
    end;

    local Infect = u4.Infect;
    local v105;

    if Infect and (Infect.config and Infect.config.Enabled == false) then
        v105 = false;
    else
        local v106 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v106);
        local v107 = tonumber(Infect and Infect.config and Infect.config.UnlockYears);
        v105 = v107 == nil and true or v107 <= math_max_ret;
    end;

    if u4.Infect.button then
        u4.Infect.button.Visible = true;
    end;

    if not (v105 or (not u14 or u14.ability ~= u4.Infect)) then
        u14 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u13 = nil;
        u4.Infect.awaitingSelection = false;
        restoreButton(u4.Infect);
    end;

    local Hypnosis = u4.Hypnosis;
    local v108;

    if Hypnosis and (Hypnosis.config and Hypnosis.config.Enabled == false) then
        v108 = false;
    else
        local v109 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v109);
        local v110 = tonumber(Hypnosis and Hypnosis.config and Hypnosis.config.UnlockYears);
        v108 = v110 == nil and true or v110 <= math_max_ret;
    end;

    if u4.Hypnosis.button then
        u4.Hypnosis.button.Visible = true;
    end;

    if not (v108 or (not u14 or u14.ability ~= u4.Hypnosis)) then
        u14 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u13 = nil;
        u4.Hypnosis.awaitingSelection = false;
        restoreButton(u4.Hypnosis);
    end;

    local BatForm = u4.BatForm;
    local v111;

    if BatForm and (BatForm.config and BatForm.config.Enabled == false) then
        v111 = false;
    else
        local v112 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v112);
        local v113 = tonumber(BatForm and BatForm.config and BatForm.config.UnlockYears);
        v111 = v113 == nil and true or v113 <= math_max_ret;
    end;

    if u4.BatForm.button then
        local button = u4.BatForm.button;
        local v114;

        if LocalPlayer.Team == nil then
            v114 = false;
        else
            v114 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if v114 then
            local v115;

            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v115 = false;
            else
                local v116;

                if LocalPlayer.Team == nil then
                    v116 = false;
                else
                    v116 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v115 = not v116;
            end;

            v114 = not v115;
        end;

        button.Visible = v114;
    end;

    local HeartRipping = u4.HeartRipping;
    local v117;

    if HeartRipping and (HeartRipping.config and HeartRipping.config.Enabled == false) then
        v117 = false;
    else
        local v118 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v118);
        local v119 = tonumber(HeartRipping and HeartRipping.config and HeartRipping.config.UnlockYears);
        v117 = v119 == nil and true or v119 <= math_max_ret;
    end;

    if u4.HeartRipping.button then
        u4.HeartRipping.button.Visible = true;
    end;

    if not (v117 or (not u14 or u14.ability ~= u4.HeartRipping)) then
        u14 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u13 = nil;
        u4.HeartRipping.awaitingSelection = false;
        restoreButton(u4.HeartRipping);
    end;

    updateHighlight();
    local ServerTimeNow = workspace:GetServerTimeNow();

    for _, v in pairs(u4) do
        if v.button then
            local v120 = v.button:FindFirstChild("Coldown") or v.button:FindFirstChild("COLDOWN");

            if v.cooldownEnd and (v.cooldownEnd > 0 and ServerTimeNow < v.cooldownEnd) then
                local math_ceil_ret = math.ceil(v.cooldownEnd - ServerTimeNow);
                v.button:SetAttribute("PowerCooldown", math_ceil_ret);

                if v120 and v120:IsA("TextLabel") then
                    v120.Text = tostring(math_ceil_ret);
                    v120.Visible = true;
                end;

                darkenButton(v, v.cooldownEnd);
            else
                if v120 and v120:IsA("TextLabel") then
                    v120.Text = "";
                    v120.Visible = false;
                end;

                if not (v.awaitingSelection or (v.awaitingActivation or u14 and u14.ability == v)) then
                    v.cooldownEnd = 0;
                    restoreButton(v);
                end;
            end;
        end;
    end;

    updateBreakNeckLockDisplay(v102);
    updateInfectLockDisplay(v105);
    updateHypnosisLockDisplay(v108);
    updateHeartRippingLockDisplay(v117);
    updateBatFormLockDisplay(v111);
    local v121;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v121 = false;
    else
        local v122;

        if LocalPlayer.Team == nil then
            v122 = false;
        else
            v122 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v121 = not v122;
    end;

    for _, v in pairs(u4) do
        if v.button then
            v.button.Visible = not v121 or v == u4.BloodDrink;
        end;
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 858
    -- upvalues: LocalPlayer (copy), resetSelection (copy)
    local v123;

    if LocalPlayer.Team == nil then
        v123 = false;
    else
        v123 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    if not v123 then
        resetSelection();
    end;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 865
    -- upvalues: resetSelection (copy)
    resetSelection();
    task.defer(function() -- Line: 867
    end);
end);