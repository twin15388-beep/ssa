-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local TeamGuiLayout = require(game.ReplicatedStorage:WaitForChild("TeamGuiLayout"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u1 = {};
local u2 = nil;
local u3 = nil;
local u4 = {
    VampireCONSOLE = { { "Sleep", "SLEEP  L1/LB" }, { "Heart-Ripping", "HEART RIPPING  ↓" }, { "Hipnose", "HYPNOSIS  ↑" }, { "Infect", "INFECT  →" }, { "Track", "HUNTER EYES  ←" }, { "BreakNeck", "BREAK NECK  ○/B" }, { "DrinkBlood", "DRINK BLOOD  △/Y" } },
    WitchesCONSOLE = { { "PainInfliction", "PAIN INFLICTION  ↑" }, { "Heart-Ripping", "HEART RIPPING  ↓" }, { "Drain", "LIFE DRAIN  L1/LB" }, { "Petrification", "PETRIFICATION  △/Y" }, { "BreakNeck", "BREAK NECK  ○/B" }, { "Incendia", "INCENDIA  ←" }, { "Invisible", "INVISIBLE  X" } }
};

local function styleConsolePanel(p5, p6, p7) -- Line: 33
    local v8 = p5:FindFirstChild("Powers") or p5:FindFirstChild("Powers1");

    if not v8 then
        return;
    end;

    local math_min_ret = math.min(p7.X / 1920, p7.Y / 1080);
    local math_clamp_ret = math.clamp(math_min_ret, 0.72, 1.05);
    local math_floor_ret = math.floor(math_clamp_ret * 248 + 0.5);
    local math_floor_ret2 = math.floor((p5.Name == "WitchesCONSOLE" and 48 or 38) * math_clamp_ret + 0.5);
    local v9 = math_floor_ret2 * #p6 + math.floor(math_clamp_ret * 20 + 0.5);
    p5.AnchorPoint = Vector2.zero;
    p5.Position = UDim2.fromScale(0, 0);
    p5.Size = UDim2.fromScale(1, 1);
    p5.BackgroundTransparency = 1;
    p5.Active = false;
    p5.ClipsDescendants = false;
    v8.AnchorPoint = Vector2.new(0, 1);
    v8.Position = UDim2.new(0, math.floor(math_clamp_ret * 20), 1, -math.floor(math_clamp_ret * 24));
    v8.Size = UDim2.fromOffset(math_floor_ret, v9);
    v8.BackgroundColor3 = Color3.fromRGB(12, 13, 18);
    v8.BackgroundTransparency = 0.24;
    v8.BorderSizePixel = 0;
    v8.Active = false;
    v8.ClipsDescendants = false;
    v8.ZIndex = 5;
    local v10 = v8:FindFirstChildOfClass("UIAspectRatioConstraint");

    if v10 then
        v10.DominantAxis = Enum.DominantAxis.Height;
        v10.AspectRatio = math_floor_ret / v9;
    end;

    local ResponsiveConsoleCorner = v8:FindFirstChild("ResponsiveConsoleCorner");

    if not ResponsiveConsoleCorner then
        ResponsiveConsoleCorner = Instance.new("UICorner");
        ResponsiveConsoleCorner.Name = "ResponsiveConsoleCorner";
        ResponsiveConsoleCorner.Parent = v8;
    end;

    ResponsiveConsoleCorner.CornerRadius = UDim.new(0, (math.floor(math_clamp_ret * 8)));
    local ResponsiveConsoleStroke = v8:FindFirstChild("ResponsiveConsoleStroke");

    if not ResponsiveConsoleStroke then
        ResponsiveConsoleStroke = Instance.new("UIStroke");
        ResponsiveConsoleStroke.Name = "ResponsiveConsoleStroke";
        ResponsiveConsoleStroke.Parent = v8;
    end;

    ResponsiveConsoleStroke.Color = Color3.fromRGB(95, 96, 105);
    ResponsiveConsoleStroke.Thickness = 1;
    ResponsiveConsoleStroke.Transparency = 0.42;

    for i, v in ipairs(p6) do
        local v11 = v8:FindFirstChild(v[1]);

        if v11 and v11:IsA("GuiObject") then
            v11.AnchorPoint = Vector2.zero;
            v11.Position = UDim2.fromOffset(math.floor(math_clamp_ret * 10), math.floor(math_clamp_ret * 10) + (i - 1) * math_floor_ret2);
            v11.ZIndex = math.max(v11.ZIndex, 6);

            if p5.Name == "WitchesCONSOLE" then
                local math_floor_ret3 = math.floor(math_clamp_ret * 40 + 0.5);
                v11.Size = UDim2.fromOffset(math_floor_ret3, math_floor_ret3);
                local v12 = v11:FindFirstChildOfClass("UIAspectRatioConstraint");

                if v12 then
                    v12.AspectRatio = 1;
                end;

                local KEY = v11:FindFirstChild("KEY");

                if KEY and KEY:IsA("TextLabel") then
                    KEY.Text = v[2];
                    KEY.AnchorPoint = Vector2.zero;
                    KEY.Position = UDim2.fromOffset(math_floor_ret3 + math.floor(math_clamp_ret * 8), 0);
                    KEY.Size = UDim2.fromOffset(math_floor_ret - math_floor_ret3 - math.floor(math_clamp_ret * 28), math_floor_ret3);
                    KEY.BackgroundTransparency = 1;
                    KEY.Font = Enum.Font.JosefinSans;
                    KEY.TextColor3 = Color3.new(1, 1, 1);
                    KEY.TextScaled = false;
                    local math_floor_ret4 = math.floor(math_clamp_ret * 15);
                    KEY.TextSize = math.max(11, math_floor_ret4);
                    KEY.TextXAlignment = Enum.TextXAlignment.Left;
                    KEY.TextTruncate = Enum.TextTruncate.AtEnd;
                    KEY.ZIndex = v11.ZIndex + 1;
                    KEY.Visible = true;
                end;
            else
                v11.Size = UDim2.fromOffset(math_floor_ret - math.floor(math_clamp_ret * 20), math_floor_ret2 - math.floor(math_clamp_ret * 3));
                v11.Text = v[2];
                v11.Font = Enum.Font.JosefinSans;
                v11.TextColor3 = Color3.new(1, 1, 1);
                v11.TextScaled = false;
                local math_floor_ret3 = math.floor(math_clamp_ret * 15);
                v11.TextSize = math.max(11, math_floor_ret3);
                v11.TextXAlignment = Enum.TextXAlignment.Left;
                v11.TextTruncate = Enum.TextTruncate.AtEnd;
                v11.BackgroundTransparency = 1;
            end;
        end;
    end;
end;

local function layoutConsolePanels() -- Line: 121
    -- upvalues: PlayerGui (copy), u4 (copy), styleConsolePanel (copy)
    local TEAMS = PlayerGui:FindFirstChild("TEAMS");

    if not TEAMS then
        return;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v13 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(1920, 1080);

    for i, v in pairs(u4) do
        local v14 = TEAMS:FindFirstChild(i);

        if v14 then
            styleConsolePanel(v14, v, v13);
        end;
    end;
end;

local function refresh() -- Line: 132
    -- upvalues: PlayerGui (copy), TeamGuiLayout (copy), LocalPlayer (copy)
    local TEAMS = PlayerGui:FindFirstChild("TEAMS");

    if not TEAMS then
        return;
    end;

    local Mode = TeamGuiLayout.GetMode();
    local v15 = LocalPlayer.Team and LocalPlayer.Team.Name or "";
    local Character = LocalPlayer.Character;
    local PanelNames = TeamGuiLayout.PanelNames;

    if Character then
        Character = Character:GetAttribute("VampireInfected") == true;
    end;

    local v16 = PanelNames(v15, Mode, Character);
    local v17 = TEAMS:GetAttribute("HiddenByHypnosis") == true;

    for _, child in ipairs(TEAMS:GetChildren()) do
        if child:IsA("GuiObject") then
            local v18;

            if v16[child.Name] == true then
                local v19;

                if v17 then
                    v19 = child.Name:match("^Vampire");
                else
                    v19 = v17;
                end;

                v18 = not v19;
            else
                v18 = false;
            end;

            if child.Visible ~= v18 then
                child.Visible = v18;
            end;
        end;
    end;

    TEAMS:SetAttribute("ActiveDevice", Mode);
    TEAMS:SetAttribute("ActiveTeam", v15);
end;

local function watchTeams(p20) -- Line: 151
    -- upvalues: u1 (copy), refresh (copy), layoutConsolePanels (copy)
    for _, v in ipairs(u1) do
        v:Disconnect();
    end;

    table.clear(u1);
    local AttributeChangedSignal = p20:GetAttributeChangedSignal("HiddenByHypnosis");
    table.insert(u1, AttributeChangedSignal:Connect(refresh));
    table.insert(u1, p20.ChildAdded:Connect(function() -- Line: 155
        -- upvalues: layoutConsolePanels (ref), refresh (ref)
        layoutConsolePanels();
        refresh();
    end));
    layoutConsolePanels();
    refresh();
end;

local function watchCharacter(p21) -- Line: 163
    -- upvalues: u2 (ref), refresh (copy)
    if u2 then
        u2:Disconnect();
    end;

    u2 = p21:GetAttributeChangedSignal("VampireInfected"):Connect(refresh);
    refresh();
end;

local function bindCamera() -- Line: 169
    -- upvalues: u3 (ref), layoutConsolePanels (copy), refresh (copy)
    if u3 then
        u3:Disconnect();
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u3 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 172
            -- upvalues: layoutConsolePanels (ref), refresh (ref)
            layoutConsolePanels();
            refresh();
            task.defer(refresh);
        end);
    end;

    layoutConsolePanels();
    refresh();
end;

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refresh);
UserInputService.LastInputTypeChanged:Connect(refresh);
LocalPlayer.CharacterAdded:Connect(watchCharacter);
LocalPlayer.CharacterRemoving:Connect(refresh);
PlayerGui.ChildAdded:Connect(function(p22) -- Line: 185
    -- upvalues: watchTeams (copy)
    if p22.Name == "TEAMS" then
        watchTeams(p22);
    end;
end);
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera);

if LocalPlayer.Character then
    local Character = LocalPlayer.Character;

    if u2 then
        u2:Disconnect();
    end;

    u2 = Character:GetAttributeChangedSignal("VampireInfected"):Connect(refresh);
    refresh();
end;

local TEAMS = PlayerGui:FindFirstChild("TEAMS");

if TEAMS then
    watchTeams(TEAMS);
end;

bindCamera();
refresh();
task.spawn(function() -- Line: 196
    -- upvalues: PlayerGui (copy), TeamGuiLayout (copy), refresh (copy)
    while script.Parent do
        local TEAMS2 = PlayerGui:FindFirstChild("TEAMS");

        if TEAMS2 and TEAMS2:GetAttribute("ActiveDevice") ~= TeamGuiLayout.GetMode() then
            refresh();
        end;

        task.wait(0.25);
    end;
end);