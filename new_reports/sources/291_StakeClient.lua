-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local StakeConfig = require(v1:WaitForChild("StakeConfig"));
local StakeRemote = v1:WaitForChild("Eventos"):WaitForChild("StakeRemote");
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = false;
local Highlight = Instance.new("Highlight");
Highlight.Name = "StakeTargetHighlight";
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
Highlight.FillColor = StakeConfig.HighlightFillColor;
Highlight.FillTransparency = 0.65;
Highlight.OutlineColor = StakeConfig.HighlightOutlineColor;
Highlight.OutlineTransparency = 0;
Highlight.Enabled = false;
Highlight.Parent = script_Parent;

local function getYears(p6) -- Line: 26
    -- upvalues: Players (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p6);

    if PlayerFromCharacter then
        local v7 = tonumber(PlayerFromCharacter:GetAttribute("Years")) or 0;

        return math.max(0, v7);
    end;

    local v8 = tonumber(p6:GetAttribute("Years")) or 0;

    return math.max(0, v8);
end;

local function isVampire(p9) -- Line: 34
    -- upvalues: Players (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p9);

    if not PlayerFromCharacter then
        return (p9:GetAttribute("IsVampire") == true or p9:GetAttribute("Team") == "Vampires") and true or p9:GetAttribute("Team") == "Cannibal Raised";
    end;

    local v10;

    if PlayerFromCharacter.Team == nil then
        v10 = false;
    else
        v10 = PlayerFromCharacter.Team.Name == "Vampires" and true or PlayerFromCharacter.Team.Name == "Cannibal Raised";
    end;

    return v10;
end;

local function getEligibleTarget(p11) -- Line: 43
    -- upvalues: LocalPlayer (copy), isVampire (copy)
    if p11 then
        p11 = p11:FindFirstAncestorOfClass("Model");
    end;

    local v12;

    if p11 then
        v12 = p11:FindFirstChildOfClass("Humanoid");
    else
        v12 = p11;
    end;

    if p11 and (p11 ~= LocalPlayer.Character and (v12 and (v12.Health > 0 and isVampire(p11)))) then
        return p11;
    end;

    return nil;
end;

local function refreshTarget() -- Line: 57
    -- upvalues: u4 (ref), getEligibleTarget (copy), u2 (ref), Highlight (copy)
    u4 = getEligibleTarget(u2 and u2.Target);
    Highlight.Adornee = u4;
    Highlight.Enabled = u4 ~= nil;
end;

script_Parent.Equipped:Connect(function(p13) -- Line: 63
    -- upvalues: u2 (ref), u3 (ref), refreshTarget (copy), u4 (ref), getEligibleTarget (copy), Highlight (copy)
    u2 = p13;

    if u3 then
        u3:Disconnect();
    end;

    u3 = u2.Move:Connect(refreshTarget);
    u4 = getEligibleTarget(u2 and u2.Target);
    Highlight.Adornee = u4;
    Highlight.Enabled = u4 ~= nil;
end);
script_Parent.Unequipped:Connect(function() -- Line: 72
    -- upvalues: u3 (ref), u2 (ref), u4 (ref), Highlight (copy)
    if u3 then
        u3:Disconnect();
        u3 = nil;
    end;

    u2 = nil;
    u4 = nil;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
end);

local function activateStake() -- Line: 83
    -- upvalues: u5 (ref), u4 (ref), getEligibleTarget (copy), u2 (ref), Highlight (copy), StakeRemote (copy), script_Parent (copy)
    if u5 then
        return;
    end;

    u4 = getEligibleTarget(u2 and u2.Target);
    Highlight.Adornee = u4;
    Highlight.Enabled = u4 ~= nil;

    if not u4 then
        return;
    end;

    u5 = true;
    StakeRemote:FireServer(script_Parent, u4);
    task.delay(0.3, function() -- Line: 90
        -- upvalues: u5 (ref)
        u5 = false;
    end);
end;

script_Parent.Activated:Connect(activateStake);
local u14 = "StakeGamepadAttack_" .. script_Parent.Name;
ContextActionService:BindActionAtPriority(u14, function(p15, p16) -- Line: 98, Name: handleGamepadAttack
    -- upvalues: script_Parent (copy), LocalPlayer (copy), activateStake (copy)
    if script_Parent.Parent ~= LocalPlayer.Character then
        return Enum.ContextActionResult.Pass;
    end;

    if p16 == Enum.UserInputState.Begin then
        activateStake();
    end;

    return Enum.ContextActionResult.Sink;
end, false, 6000, Enum.KeyCode.ButtonR2);
script_Parent.Destroying:Connect(function() -- Line: 116
    -- upvalues: ContextActionService (copy), u14 (copy), Highlight (copy)
    ContextActionService:UnbindAction(u14);
    Highlight:Destroy();
end);