-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Lighting = game:GetService("Lighting");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10);

if not PlayerGui then
    return;
end;

local InteractionBillboardUI = PlayerGui:WaitForChild("InteractionBillboardUI", 10);

if not InteractionBillboardUI then
    return;
end;

local Panel = InteractionBillboardUI:WaitForChild("Panel", 5);
local u1;

if Panel then
    u1 = Panel:WaitForChild("Title", 5);
else
    u1 = Panel;
end;

local u2;

if Panel then
    u2 = Panel:WaitForChild("ActionButton", 5);
else
    u2 = Panel;
end;

local u3;

if Panel then
    u3 = Panel:FindFirstChild("DayNightStatus");
else
    u3 = Panel;
end;

if not (Panel and (u1 and u2)) then
    return;
end;

local v4 = ReplicatedStorage:WaitForChild("Funções", 10);
local u5;

if v4 then
    u5 = require(v4:WaitForChild("DayNightConfig", 10));
else
    u5 = v4;
end;

local Eventos = v4:WaitForChild("Eventos", 10);
local InteractionRemote = Eventos:WaitForChild("InteractionRemote", 10);
local BroomRemote = Eventos:WaitForChild("BroomRemote", 10);

if not (InteractionRemote and BroomRemote) then
    return;
end;

local u6 = {};
local u7 = setmetatable({}, {
    __mode = "k"
});

local function findInteractionIndex(p8) -- Line: 33
    -- upvalues: u6 (copy)
    for i = #u6, 1, -1 do
        if u6[i] == p8 then
            return i;
        end;

        local _ = i;
    end;

    return nil;
end;

local function registerInteraction(u9) -- Line: 43
    -- upvalues: u6 (copy), u7 (copy)
    if not u9:IsA("BasePart") or u9:GetAttribute("InteractionEnabled") == nil then
        return;
    end;

    if not u9:IsA("BasePart") then
        return;
    end;

    local v10 = nil;

    for i = #u6, 1, -1 do
        if u6[i] == u9 then
            v10 = i;
            break;
        end;

        local _ = i;
    end;

    if u9:GetAttribute("InteractionEnabled") == true and not v10 then
        table.insert(u6, u9);
    end;

    if u7[u9] then
        return;
    end;

    u7[u9] = true;
    u9:GetAttributeChangedSignal("InteractionEnabled"):Connect(function() -- Line: 60
        -- upvalues: u9 (copy), u6 (ref)
        local v11 = u9:GetAttribute("InteractionEnabled") == true;
        local v12 = u9;
        local v13 = nil;

        for i = #u6, 1, -1 do
            if u6[i] == v12 then
                v13 = i;
                break;
            end;

            local _ = i;
        end;

        if v11 and (u9:IsDescendantOf(workspace) and not v13) then
            table.insert(u6, u9);

            return;
        end;

        if not (v11 and u9:IsDescendantOf(workspace)) and v13 then
            table.remove(u6, v13);
        end;
    end);
end;

local u14 = 0;
local u15 = nil;
local u16 = false;

for _, descendant in ipairs(workspace:GetDescendants()) do
    registerInteraction(descendant);
end;

workspace.DescendantAdded:Connect(registerInteraction);

local function hide() -- Line: 77
    -- upvalues: u15 (ref), InteractionBillboardUI (copy), LocalPlayer (copy)
    u15 = nil;
    InteractionBillboardUI.Adornee = nil;
    InteractionBillboardUI.Enabled = false;
    LocalPlayer:SetAttribute("InteractionUIOpen", false);
end;

local function getRoot() -- Line: 84
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    return Character;
end;

local function canUse(p17) -- Line: 89
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("SpiritWorldActive") == true then
        return false;
    end;

    if p17:GetAttribute("InteractionEnabled") ~= true then
        return false;
    end;

    local v18 = tonumber(p17:GetAttribute("InteractionOwnerUserId"));

    return not (v18 and (v18 > 0 and v18 ~= LocalPlayer.UserId));
end;

local function nearestInteraction() -- Line: 101
    -- upvalues: LocalPlayer (copy), u6 (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        return nil;
    end;

    local v19 = (1 / 0);
    local v20 = nil;

    for i = #u6, 1, -1 do
        local v21 = u6[i];
        local v22;

        if v21.Parent then
            local v23;

            if LocalPlayer:GetAttribute("SpiritWorldActive") == true or v21:GetAttribute("InteractionEnabled") ~= true then
                v23 = false;
            else
                local v24 = tonumber(v21:GetAttribute("InteractionOwnerUserId"));
                v23 = not (v24 and (v24 > 0 and v24 ~= LocalPlayer.UserId));
            end;

            if v23 then
                local v25 = tonumber(v21:GetAttribute("InteractionRange")) or 10;
                local math_max_ret = math.max(1, v25);
                local Magnitude = (Character.Position - v21.Position).Magnitude;

                if Magnitude <= math_max_ret and Magnitude < v19 then
                    v20 = v21;
                    v19 = Magnitude;
                    v22 = i;
                else
                    v22 = i;
                end;
            else
                v22 = i;
            end;
        else
            table.remove(u6, i);
            v22 = i;
        end;
    end;

    return v20;
end;

local function refresh(p26) -- Line: 123
    -- upvalues: u15 (ref), InteractionBillboardUI (copy), LocalPlayer (copy), u1 (copy), u3 (copy), u5 (copy), Lighting (copy), u2 (copy)
    u15 = p26;
    InteractionBillboardUI.Adornee = p26;
    InteractionBillboardUI.Enabled = true;
    LocalPlayer:SetAttribute("InteractionUIOpen", true);
    local v27 = p26:GetAttribute("InteractionTitle") or "INTERACTION";
    u1.Text = tostring(v27);

    if u3 then
        local v28 = p26:GetAttribute("InteractionShowDayNight") == true;
        u3.Visible = v28;

        if v28 and u5 then
            u3.Text = u5.IsDay(Lighting.ClockTime) and "DAY" or "NIGHT";
        end;
    end;

    local v29 = p26:GetAttribute("InteractionAction") or "USE";
    local v30 = tostring(v29);
    local v31 = p26:GetAttribute("InteractionBlocked") == true;
    local Attribute = p26:GetAttribute("InteractionTeamRequired");
    local v32;

    if typeof(Attribute) == "string" and Attribute ~= "" then
        v32 = not LocalPlayer.Team;

        if not v32 then
            if LocalPlayer.Team.Name == Attribute then
                v32 = false;
            else
                local v33;

                if Attribute == "Vampires" then
                    v33 = LocalPlayer.Team.Name == "Cannibal Raised";
                else
                    v33 = false;
                end;

                v32 = not v33;
            end;
        end;
    else
        v32 = false;
    end;

    if v32 then
        u2.Text = string.upper(Attribute) .. " ONLY";
        u2.Active = false;
        u2.Interactable = false;
        u2.AutoButtonColor = false;

        return;
    end;

    u2.Text = v30;
    u2.Active = not v31;
    u2.Interactable = not v31;
    u2.AutoButtonColor = not v31;
end;

u2.Activated:Connect(function() -- Line: 158
    -- upvalues: LocalPlayer (copy), u15 (ref), InteractionBillboardUI (copy), u16 (ref), BroomRemote (copy), InteractionRemote (copy)
    if LocalPlayer:GetAttribute("SpiritWorldActive") == true then
        u15 = nil;
        InteractionBillboardUI.Adornee = nil;
        InteractionBillboardUI.Enabled = false;
        LocalPlayer:SetAttribute("InteractionUIOpen", false);

        return;
    end;

    if u16 or not (u15 and u15.Parent) then
        return;
    end;

    if u15:GetAttribute("InteractionBlocked") == true then
        return;
    end;

    local Attribute = u15:GetAttribute("InteractionTeamRequired");

    if typeof(Attribute) == "string" and (Attribute ~= "" and not (LocalPlayer.Team and (LocalPlayer.Team.Name == Attribute or Attribute == "Vampires" and LocalPlayer.Team.Name == "Cannibal Raised"))) then
        return;
    end;

    u16 = true;
    local Attribute2 = u15:GetAttribute("InteractionKind");

    if Attribute2 == "BroomRide" then
        BroomRemote:FireServer("RideToggle");
    elseif Attribute2 == "DungeonDoor" then
        InteractionRemote:FireServer("Use", u15);
    end;

    task.delay(0.3, function() -- Line: 178
        -- upvalues: u16 (ref)
        u16 = false;
    end);
end);
LocalPlayer.CharacterRemoving:Connect(hide);
RunService.RenderStepped:Connect(function(p34) -- Line: 185
    -- upvalues: u14 (ref), LocalPlayer (copy), u15 (ref), InteractionBillboardUI (copy), nearestInteraction (copy), refresh (copy)
    u14 = u14 + p34;

    if u14 < 0.08 then
        return;
    end;

    u14 = 0;

    if LocalPlayer:GetAttribute("SpiritWorldActive") == true then
        u15 = nil;
        InteractionBillboardUI.Adornee = nil;
        InteractionBillboardUI.Enabled = false;
        LocalPlayer:SetAttribute("InteractionUIOpen", false);

        return;
    end;

    local v35 = nearestInteraction();

    if v35 then
        refresh(v35);

        return;
    end;

    u15 = nil;
    InteractionBillboardUI.Adornee = nil;
    InteractionBillboardUI.Enabled = false;
    LocalPlayer:SetAttribute("InteractionUIOpen", false);
end);
LocalPlayer:SetAttribute("InteractionUIOpen", false);
InteractionBillboardUI.Adornee = nil;
InteractionBillboardUI.Enabled = false;