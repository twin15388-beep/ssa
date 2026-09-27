-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local GuiService = game:GetService("GuiService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local UpgradesGui = PlayerGui:WaitForChild("UpgradesGui");
local u1 = {
    Vampire = UpgradesGui:WaitForChild("Vampire"),
    Humans = UpgradesGui:WaitForChild("Humans"),
    Witches = UpgradesGui:WaitForChild("Witches")
};
local u2 = {};
local u3 = nil;
UpgradesGui.DisplayOrder = 40;
UpgradesGui.Enabled = false;
UpgradesGui.ScreenInsets = Enum.ScreenInsets.None;
UpgradesGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None;

local function upgradesEnabledForCurrentTeam() -- Line: 21
    -- upvalues: LocalPlayer (copy)
    local v4 = LocalPlayer.Team and LocalPlayer.Team.Name or "";

    return (v4 == "Vampires" or (v4 == "Cannibal Vampire" or v4 == "Cannibal Raised")) and true or v4 == "Original Vampire";
end;

local function panelForTeam() -- Line: 29
    -- upvalues: u1 (copy)
    return u1.Vampire;
end;

local function updatePoints() -- Line: 33
    -- upvalues: LocalPlayer (copy), u1 (copy)
    local v5 = tonumber(LocalPlayer:GetAttribute("SkillPoints")) or 0;
    local math_floor_ret = math.floor(v5);
    local v6 = ("%d POINTS"):format((math.max(0, math_floor_ret)));

    for _, v in pairs(u1) do
        local Points = v:FindFirstChild("Points");

        if Points and Points:IsA("TextLabel") then
            Points.Text = v6;
        end;
    end;
end;

local function layoutPanel(p7) -- Line: 41
    -- upvalues: GuiService (copy)
    if not p7 then
        return;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if ViewportSize.X < 200 or ViewportSize.Y < 160 then
        return;
    end;

    p7.AnchorPoint = Vector2.new(0.5, 0.5);
    p7.Position = UDim2.fromScale(0.5, 0.5);
    p7.Size = UDim2.fromScale(1, 1);
    local Y = GuiService:GetGuiInset().Y;
    local Points = p7:FindFirstChild("Points");

    if Points and Points:IsA("TextLabel") then
        Points.AnchorPoint = Vector2.new(0.5, 0);
        Points.Position = UDim2.new(0.5, 0, 0, Y + 12);
        Points.Size = UDim2.fromOffset(math.min(260, ViewportSize.X - 24), 34);
        Points.Font = Enum.Font.JosefinSans;
        Points.TextSize = 26;
        Points.TextScaled = false;
        Points.TextColor3 = Color3.new(1, 1, 1);
        Points.ZIndex = 100;
    end;

    local Close = p7:FindFirstChild("Close");

    if Close and Close:IsA("GuiButton") then
        Close.AnchorPoint = Vector2.new(0.5, 0);
        Close.Position = UDim2.new(0.5, 0, 0, Y + 50);
        Close.Size = UDim2.fromOffset(120, 30);
        Close.Text = "Close";
        Close.Font = Enum.Font.JosefinSans;
        Close.TextSize = 16;
        Close.TextColor3 = Color3.new(1, 1, 1);
        Close.BackgroundTransparency = 1;
        Close.ZIndex = 100;
    end;
end;

local function selectPanel() -- Line: 76
    -- upvalues: u3 (ref), u1 (copy), layoutPanel (copy), updatePoints (copy)
    u3 = u1.Vampire;

    for _, v in pairs(u1) do
        v.Visible = v == u3;
    end;

    layoutPanel(u3);
    updatePoints();
end;

local function open() -- Line: 90
    -- upvalues: LocalPlayer (copy), UpgradesGui (copy), GuiService (copy), u3 (ref), u1 (copy), layoutPanel (copy), updatePoints (copy)
    local v8 = LocalPlayer.Team and LocalPlayer.Team.Name or "";

    if v8 ~= "Vampires" and (v8 ~= "Cannibal Vampire" and v8 ~= "Cannibal Raised") and v8 ~= "Original Vampire" then
        UpgradesGui.Enabled = false;
        GuiService.SelectedObject = nil;

        return;
    end;

    u3 = u1.Vampire;

    for _, v in pairs(u1) do
        v.Visible = v == u3;
    end;

    layoutPanel(u3);
    updatePoints();
    UpgradesGui.Enabled = true;
    local Close = u3:FindFirstChild("Close");

    if Close and Close:IsA("GuiButton") then
        GuiService.SelectedObject = Close;
    end;
end;

local function close() -- Line: 85
    -- upvalues: UpgradesGui (copy), GuiService (copy)
    UpgradesGui.Enabled = false;
    GuiService.SelectedObject = nil;
end;

local u9 = nil;

for _, v in pairs(u1) do
    v:WaitForChild("Close").Activated:Connect(close);
end;

local function refreshAccess() -- Line: 108
    -- upvalues: u3 (ref), u1 (copy), layoutPanel (copy), updatePoints (copy), u2 (copy), LocalPlayer (copy)
    u3 = u1.Vampire;

    for _, v in pairs(u1) do
        v.Visible = v == u3;
    end;

    layoutPanel(u3);
    updatePoints();

    for i in pairs(u2) do
        if i.Parent then
            local MakeParty = i.Parent:FindFirstChild("MakeParty");
            local v10 = LocalPlayer.Team and LocalPlayer.Team.Name or "";
            local v11 = (v10 == "Vampires" or (v10 == "Cannibal Vampire" or v10 == "Cannibal Raised")) and true or v10 == "Original Vampire";

            if v11 then
                if MakeParty == nil then
                    v11 = false;
                else
                    v11 = MakeParty.Visible;
                end;
            end;

            i.Visible = v11;
        end;
    end;
end;

local function bindCamera() -- Line: 137
    -- upvalues: u9 (ref), layoutPanel (copy), u3 (ref)
    if u9 then
        u9:Disconnect();
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u9 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 140
            -- upvalues: layoutPanel (ref), u3 (ref)
            layoutPanel(u3);
        end);
    end;

    layoutPanel(u3);
end;

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 146
    -- upvalues: LocalPlayer (copy), UpgradesGui (copy), GuiService (copy), u3 (ref), u1 (copy), layoutPanel (copy), updatePoints (copy), refreshAccess (copy)
    local v12 = LocalPlayer.Team and LocalPlayer.Team.Name or "";

    if v12 ~= "Vampires" and (v12 ~= "Cannibal Vampire" and v12 ~= "Cannibal Raised") and v12 ~= "Original Vampire" then
        UpgradesGui.Enabled = false;
        GuiService.SelectedObject = nil;
    end;

    if not UpgradesGui.Enabled then
        refreshAccess();

        return;
    end;

    u3 = u1.Vampire;

    for _, v in pairs(u1) do
        v.Visible = v == u3;
    end;

    layoutPanel(u3);
    updatePoints();
end);
LocalPlayer:GetAttributeChangedSignal("SkillPoints"):Connect(updatePoints);
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera);
PlayerGui.ChildAdded:Connect(function(u13) -- Line: 120, Name: bindPartyGui
    -- upvalues: u2 (copy), refreshAccess (copy), open (copy)
    if not u13 or u13.Name ~= "PARTYUI" then
        return;
    end;

    task.spawn(function() -- Line: 122
        -- upvalues: u13 (copy), u2 (ref), refreshAccess (ref), open (ref)
        local BASE = u13:WaitForChild("BASE", 10);
        local u14;

        if BASE then
            u14 = BASE:WaitForChild("Achivmentes", 10);
        else
            u14 = BASE;
        end;

        if not u14 or u2[u14] then
            return;
        end;

        u2[u14] = true;
        u14.Destroying:Connect(function() -- Line: 127
            -- upvalues: u2 (ref), u14 (copy)
            u2[u14] = nil;
        end);
        local MakeParty = BASE:WaitForChild("MakeParty", 10);

        if MakeParty then
            MakeParty:GetPropertyChangedSignal("Visible"):Connect(refreshAccess);
        end;

        u14.Activated:Connect(open);
        refreshAccess();
    end);
end);
u3 = u1.Vampire;

for _, v in pairs(u1) do
    v.Visible = v == u3;
end;

layoutPanel(u3);
updatePoints();
bindCamera();
local PARTYUI = PlayerGui:FindFirstChild("PARTYUI");

if PARTYUI and PARTYUI.Name == "PARTYUI" then
    task.spawn(function() -- Line: 122
        -- upvalues: PARTYUI (copy), u2 (copy), refreshAccess (copy), open (copy)
        local BASE = PARTYUI:WaitForChild("BASE", 10);
        local u15;

        if BASE then
            u15 = BASE:WaitForChild("Achivmentes", 10);
        else
            u15 = BASE;
        end;

        if not u15 or u2[u15] then
            return;
        end;

        u2[u15] = true;
        u15.Destroying:Connect(function() -- Line: 127
            -- upvalues: u2 (ref), u15 (copy)
            u2[u15] = nil;
        end);
        local MakeParty = BASE:WaitForChild("MakeParty", 10);

        if MakeParty then
            MakeParty:GetPropertyChangedSignal("Visible"):Connect(refreshAccess);
        end;

        u15.Activated:Connect(open);
        refreshAccess();
    end);
end;