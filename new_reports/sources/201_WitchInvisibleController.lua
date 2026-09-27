-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local Invisible = require(v1:WaitForChild("WitchSpellsConfig")).Invisible;
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "WitchInvisibleRequest");
local WitchInvisibleRemote = NetworkRegistry.Legacy.Events:WaitForChild("WitchInvisibleRemote");
local TeamGuiLayout = require(ReplicatedStorage:WaitForChild("TeamGuiLayout"));
local u2 = {};
local u3 = setmetatable({}, {
    __mode = "k"
});
local u4 = tonumber(LocalPlayer:GetAttribute("WitchInvisibleCooldownEnd")) or 0;
local u5 = false;

local function isWitch() -- Line: 19
    -- upvalues: LocalPlayer (copy)
    local v6;

    if LocalPlayer.Team == nil then
        v6 = false;
    else
        v6 = LocalPlayer.Team.Name == "Witches";
    end;

    return v6;
end;

local function isUnlocked() -- Line: 23
    -- upvalues: LocalPlayer (copy), Invisible (copy)
    return (tonumber(LocalPlayer:GetAttribute("Years")) or 0) >= (tonumber(Invisible.UnlockYears) or 25);
end;

local function findLabel(p7, ...) -- Line: 27
    for i = 1, select("#", ...) do
        local v8 = p7:FindFirstChild((select(i, ...)));

        if v8 and v8:IsA("TextLabel") then
            return v8;
        end;

        local _ = i;
    end;

    return nil;
end;

local function canActivate(p9) -- Line: 38
    -- upvalues: LocalPlayer (copy), TeamGuiLayout (copy), Invisible (copy), u5 (ref), u4 (ref)
    local Character = LocalPlayer.Character;
    local v10;

    if Character then
        v10 = Character:FindFirstChildOfClass("Humanoid");
    else
        v10 = Character;
    end;

    local v11;

    if p9 then
        v11 = p9.Parent;
    else
        v11 = p9;
    end;

    local v12;

    if p9 == nil then
        v12 = false;
    else
        v12 = TeamGuiLayout.IsVisible(p9);

        if v12 then
            local v13;

            if LocalPlayer.Team == nil then
                v13 = false;
            else
                v13 = LocalPlayer.Team.Name == "Witches";
            end;

            v12 = v13 and ((tonumber(LocalPlayer:GetAttribute("Years")) or 0) >= (tonumber(Invisible.UnlockYears) or 25) and not u5);

            if v12 then
                if u4 <= workspace:GetServerTimeNow() and (LocalPlayer:GetAttribute("WitchInvisibleActive") ~= true and (v10 ~= nil and (v10.Health > 0 and (Character:GetAttribute("ActionLocked") ~= true and (Character:GetAttribute("Hibernating") ~= true and Character:GetAttribute("Ragdolled") ~= true))))) then
                    v12 = not v11 or v11:GetAttribute("IsDragging") ~= true;
                else
                    v12 = false;
                end;
            end;
        end;
    end;

    return v12;
end;

local function activate(p14) -- Line: 57
    -- upvalues: canActivate (copy), u5 (ref), Event (copy)
    if not canActivate(p14) then
        return;
    end;

    u5 = true;
    Event:FireServer("Activate");
    task.delay(1.5, function() -- Line: 61
        -- upvalues: u5 (ref)
        if u5 then
            u5 = false;
        end;
    end);
end;

local function bindButton(u15) -- Line: 68
    -- upvalues: u2 (copy), u3 (copy), activate (copy)
    if u2[u15] then
        return;
    end;

    u2[u15] = true;
    local v16 = {};
    local v17;

    if u15:IsA("ImageButton") then
        v17 = u15.ImageColor3 or nil;
    else
        v17 = nil;
    end;

    v16.imageColor = v17;
    local v18;

    if u15:IsA("ImageButton") then
        v18 = u15.ImageTransparency or nil;
    else
        v18 = nil;
    end;

    v16.imageTransparency = v18;
    local v19;

    if u15:IsA("GuiButton") then
        v19 = u15.AutoButtonColor or nil;
    else
        v19 = nil;
    end;

    v16.autoButtonColor = v19;
    u3[u15] = v16;
    u15.Active = true;

    if u15:IsA("GuiButton") then
        u15.Activated:Connect(function() -- Line: 78
            -- upvalues: activate (ref), u15 (copy)
            activate(u15);
        end);
    end;
end;

local function discoverButtons() -- Line: 84
    -- upvalues: LocalPlayer (copy), bindButton (copy)
    local v20 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v20 then
        v20 = v20:FindFirstChild("TEAMS");
    end;

    if not v20 then
        return;
    end;

    for _, v in ipairs({ "WitchesPC", "WitchesMOBILE", "WitchesCONSOLE" }) do
        local v21 = v20:FindFirstChild(v);

        if v21 then
            v21 = v21:FindFirstChild("Powers") or v21:FindFirstChild("Powers1");
        end;

        if v21 then
            v21 = v21:FindFirstChild("Invisible");
        end;

        if v21 and v21:IsA("GuiButton") then
            bindButton(v21);
        end;
    end;
end;

local function updateButton(p22, p23) -- Line: 98
    -- upvalues: u3 (copy), u4 (ref), LocalPlayer (copy), Invisible (copy), canActivate (copy), findLabel (copy), u5 (ref)
    local v24 = u3[p22];

    if not (v24 and p22.Parent) then
        return;
    end;

    local math_max_ret = math.max(0, u4 - p23);
    local v25 = (tonumber(LocalPlayer:GetAttribute("Years")) or 0) >= (tonumber(Invisible.UnlockYears) or 25);
    local v26 = canActivate(p22);
    local v27 = findLabel(p22, "COLDOWN", "Coldown");
    local v28 = findLabel(p22, "UNLOCKLV", "UnlockRequirement", "UnlockRequirement1");
    p22:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));
    p22:SetAttribute("UnlockYears", tonumber(Invisible.UnlockYears) or 25);
    p22.Active = v26;
    p22.Interactable = v26;

    if v26 then
        v26 = v24.autoButtonColor == true;
    end;

    p22.AutoButtonColor = v26;

    if v27 then
        v27.Visible = math_max_ret > 0;
        local v29;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v29 = tostring(math_ceil_ret) or "";
        else
            v29 = "";
        end;

        v27.Text = v29;
    end;

    if v28 then
        local v30 = tonumber(Invisible.UnlockYears) or 25;
        v28.Text = "LV " .. tostring(v30);
        v28.Visible = not v25;
    end;

    if p22:IsA("ImageButton") and v24.imageColor then
        local v31 = not v25 or (math_max_ret > 0 and true or u5);
        p22.ImageColor3 = v31 and v24.imageColor:Lerp(Color3.new(0, 0, 0), 0.62) or v24.imageColor;
        p22.ImageTransparency = v31 and math.min(0.86, (v24.imageTransparency or 0) + 0.08) or (v24.imageTransparency or 0);
    end;
end;

WitchInvisibleRemote.OnClientEvent:Connect(function(p32, p33, p34) -- Line: 133
    -- upvalues: u5 (ref), u4 (ref), Invisible (copy)
    u5 = false;

    if p32 == "Activated" then
        u4 = tonumber(p34) or workspace:GetServerTimeNow() + (Invisible.Cooldown or 25);

        return;
    end;

    if p32 == "Ended" then
        u4 = tonumber(p33) or u4;

        return;
    end;

    if p32 == "Rejected" and p33 == "Cooldown" then
        u4 = tonumber(p34) or u4;
    end;
end);
UserInputService.InputBegan:Connect(function(p35, p36) -- Line: 144
    -- upvalues: UserInputService (copy), discoverButtons (copy), TeamGuiLayout (copy), u2 (copy), LocalPlayer (copy), activate (copy)
    if p36 or UserInputService:GetFocusedTextBox() then
        return;
    end;

    discoverButtons();
    local Mode = TeamGuiLayout.GetMode();

    if Mode == "PC" and p35.KeyCode == Enum.KeyCode.C then
        for i in pairs(u2) do
            if i:IsDescendantOf(LocalPlayer.PlayerGui.TEAMS.WitchesPC) then
                activate(i);

                return;
            end;
        end;

        return;
    end;

    if Mode == "CONSOLE" and p35.KeyCode == Enum.KeyCode.ButtonX then
        for i in pairs(u2) do
            if i:IsDescendantOf(LocalPlayer.PlayerGui.TEAMS.WitchesCONSOLE) then
                activate(i);

                return;
            end;
        end;
    end;
end);
LocalPlayer:GetAttributeChangedSignal("WitchInvisibleCooldownEnd"):Connect(function() -- Line: 159
    -- upvalues: u4 (ref), LocalPlayer (copy)
    u4 = tonumber(LocalPlayer:GetAttribute("WitchInvisibleCooldownEnd")) or u4;
end);
local u37 = 0;
RunService.RenderStepped:Connect(function(p38) -- Line: 164
    -- upvalues: u37 (ref), discoverButtons (copy), u2 (copy), updateButton (copy)
    u37 = u37 + p38;

    if u37 < 0.05 then
        return;
    end;

    u37 = 0;
    discoverButtons();
    local ServerTimeNow = workspace:GetServerTimeNow();

    for i in pairs(u2) do
        updateButton(i, ServerTimeNow);
    end;
end);
discoverButtons();