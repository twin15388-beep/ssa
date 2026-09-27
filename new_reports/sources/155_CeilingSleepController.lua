-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local StarterGui = game:GetService("StarterGui");
local LocalPlayer = Players.LocalPlayer;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local CeilingSleepConfig = require(v1:WaitForChild("CeilingSleepConfig"));
local CeilingSleepRemote = v1:WaitForChild("Eventos"):WaitForChild("CeilingSleepRemote");
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = {};

local function isVampire() -- Line: 18
    -- upvalues: LocalPlayer (copy)
    local v4;

    if LocalPlayer.Team == nil then
        v4 = false;
    else
        v4 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    return v4;
end;

local function isUnlocked() -- Line: 22
    -- upvalues: LocalPlayer (copy), CeilingSleepConfig (copy)
    local v5;

    if LocalPlayer.Team == nil then
        v5 = false;
    else
        v5 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    if v5 then
        local v6 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        v5 = math.floor(v6) >= CeilingSleepConfig.MinimumYears;
    end;

    return v5;
end;

local function getUsableCharacter() -- Line: 27
    -- upvalues: LocalPlayer (copy), CeilingSleepConfig (copy)
    local Character = LocalPlayer.Character;
    local v7;

    if Character then
        v7 = Character:FindFirstChildOfClass("Humanoid");
    else
        v7 = Character;
    end;

    local v8;

    if Character then
        v8 = Character:FindFirstChild("HumanoidRootPart");
    else
        v8 = Character;
    end;

    if not (Character and (v7 and (v8 and v7.Health > 0))) then
        return nil;
    end;

    if Character:GetAttribute("CeilingSleeping") == true then
        return Character, v7, v8;
    end;

    local v9;

    if LocalPlayer.Team == nil then
        v9 = false;
    else
        v9 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    if v9 then
        local v10 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        v9 = math.floor(v10) >= CeilingSleepConfig.MinimumYears;
    end;

    if v9 and (Character:GetAttribute("ActionLocked") ~= true and (Character:GetAttribute("Hibernating") ~= true and (Character:GetAttribute("Ragdolled") ~= true and Character:GetAttribute("BeingCarried") ~= true))) then
        return Character, v7, v8;
    end;

    return nil;
end;

local function toggleCeilingSleep() -- Line: 53
    -- upvalues: getUsableCharacter (copy), CeilingSleepRemote (copy)
    local v11, _, v12 = getUsableCharacter();

    if not (v11 and v12) then
        return false;
    end;

    CeilingSleepRemote:FireServer("Toggle", v12.Position);

    return true;
end;

local function refreshButton(u13) -- Line: 62
    -- upvalues: u2 (copy), LocalPlayer (copy), CeilingSleepConfig (copy), UserInputService (copy)
    local v14 = u2[u13];

    if not (v14 and u13.Parent) then
        return;
    end;

    local v15;

    if LocalPlayer.Team == nil then
        v15 = false;
    else
        v15 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    local u16;

    if LocalPlayer.Team == nil then
        u16 = false;
    else
        u16 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    if u16 then
        local v17 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        u16 = math.floor(v17) >= CeilingSleepConfig.MinimumYears;
    end;

    local v18 = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("CeilingSleeping") == true;

    if v14.desktop then
        u13.Visible = v15;
    else
        u13.Visible = UserInputService.TouchEnabled and v15;
    end;

    u13.Active = u16;

    if u13:IsA("GuiButton") then
        local v19;

        if u16 then
            v19 = not v18;
        else
            v19 = u16;
        end;

        u13.AutoButtonColor = v19;
    end;

    pcall(function() -- Line: 82
        -- upvalues: u13 (copy), u16 (copy)
        u13.Interactable = u16;
    end);

    if u13:IsA("TextLabel") then
        if v18 or not u16 then
            u13.TextColor3 = v14.textColor:Lerp(Color3.new(0, 0, 0), v18 and 0.58 or 0.62);
            u13.TextTransparency = math.min(0.82, v14.textTransparency + 0.25);
        else
            u13.TextColor3 = v14.textColor;
            u13.TextTransparency = v14.textTransparency;
        end;

        u13.BackgroundColor3 = v14.backgroundColor;
        u13.BackgroundTransparency = v14.backgroundTransparency;
        local v20 = u13:FindFirstChild("Coldown") or u13:FindFirstChild("COLDOWN");

        if v20 and v20:IsA("TextLabel") then
            v20.Text = "";
            v20.Visible = false;
        end;
    elseif v18 then
        u13.ImageColor3 = v14.imageColor:Lerp(Color3.new(0, 0, 0), 0.58);
        u13.ImageTransparency = math.min(0.85, v14.imageTransparency + 0.08);
        u13.BackgroundColor3 = v14.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.58);
        u13.BackgroundTransparency = v14.backgroundTransparency;
    elseif u16 then
        u13.ImageColor3 = v14.imageColor;
        u13.ImageTransparency = v14.imageTransparency;
        u13.BackgroundColor3 = v14.backgroundColor;
        u13.BackgroundTransparency = v14.backgroundTransparency;
    else
        u13.ImageColor3 = v14.imageColor:Lerp(Color3.new(0, 0, 0), 0.62);
        u13.ImageTransparency = math.min(0.85, v14.imageTransparency + 0.08);
        u13.BackgroundColor3 = v14.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.62);
        u13.BackgroundTransparency = v14.backgroundTransparency;
    end;

    local v21 = u13:FindFirstChild("UnlockRequirement") or u13:FindFirstChild("UNLOCKLV");

    if v21 and v21:IsA("GuiObject") then
        if v21:IsA("TextLabel") then
            v21.Text = "LV 100";
        end;

        v21.Visible = not u16;
    end;
end;

local function refreshButtons() -- Line: 129
    -- upvalues: u2 (copy), refreshButton (copy)
    for i in pairs(u2) do
        refreshButton(i);
    end;
end;

local function bindButton(u22, p23) -- Line: 135
    -- upvalues: u2 (copy), StarterGui (copy), TeamGuiLayout (copy), getUsableCharacter (copy), CeilingSleepRemote (copy), refreshButton (copy)
    if u2[u22] or not u22:IsA("GuiObject") then
        return;
    end;

    local v24 = nil;
    local v25 = u22.Parent and u22.Parent.Parent;

    if v25 and (v25.Name == "VampirePC" or v25.Name == "VampireCONSOLE") then
        v24 = StarterGui:FindFirstChild("TEAMS");

        if v24 then
            v24 = v24:FindFirstChild(v25.Name);
        end;

        if v24 then
            v24 = v24:FindFirstChild("Powers");
        end;

        if v24 then
            v24 = v24:FindFirstChild("Sleep");
        end;
    end;

    u22.Active = true;
    u2[u22] = {
        desktop = p23 == true,
        textColor = v24 and v24:IsA("TextLabel") and v24.TextColor3 or (u22:IsA("TextLabel") and u22.TextColor3 or Color3.new(1, 1, 1)),
        textTransparency = v24 and v24:IsA("TextLabel") and v24.TextTransparency or (u22:IsA("TextLabel") and (u22.TextTransparency or 0) or 0),
        imageColor = v24 and v24:IsA("ImageButton") and v24.ImageColor3 or (u22:IsA("ImageButton") and u22.ImageColor3 or Color3.new(1, 1, 1)),
        imageTransparency = v24 and v24:IsA("ImageButton") and v24.ImageTransparency or (u22:IsA("ImageButton") and (u22.ImageTransparency or 0) or 0),
        backgroundColor = v24 and v24.BackgroundColor3 or u22.BackgroundColor3,
        backgroundTransparency = v24 and v24.BackgroundTransparency or u22.BackgroundTransparency
    };

    local function requestToggle() -- Line: 164
        -- upvalues: u22 (copy), TeamGuiLayout (ref), getUsableCharacter (ref), CeilingSleepRemote (ref)
        local Parent = u22.Parent;

        if not TeamGuiLayout.IsVisible(u22) or Parent and Parent:GetAttribute("IsDragging") then
            return;
        end;

        local v26, _, v27 = getUsableCharacter();

        if v26 then
            if not v27 then
                return;
            end;

            CeilingSleepRemote:FireServer("Toggle", v27.Position);
        end;
    end;

    if u22:IsA("GuiButton") then
        u22.Activated:Connect(requestToggle);
    else
        u22.InputBegan:Connect(function(p28) -- Line: 177
            -- upvalues: u22 (copy), TeamGuiLayout (ref), getUsableCharacter (ref), CeilingSleepRemote (ref)
            if p28.UserInputType == Enum.UserInputType.MouseButton1 or p28.UserInputType == Enum.UserInputType.Touch then
                local Parent = u22.Parent;

                if TeamGuiLayout.IsVisible(u22) then
                    if Parent and Parent:GetAttribute("IsDragging") then
                        return;
                    end;

                    local v29, _, v30 = getUsableCharacter();

                    if v29 then
                        if not v30 then
                            return;
                        end;

                        CeilingSleepRemote:FireServer("Toggle", v30.Position);
                    end;
                end;
            end;
        end);
    end;

    refreshButton(u22);
end;

local function findAndBindButtons() -- Line: 188
    -- upvalues: LocalPlayer (copy), TeamGuiLayout (copy), bindButton (copy)
    local v31 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v31 then
        return;
    end;

    local v32 = TeamGuiLayout.FindPanel(v31, "VampiresMOBILE");

    if v32 then
        v32 = TeamGuiLayout.GetMenu(v32);
    end;

    if v32 then
        v32 = v32:FindFirstChild("Dormir");
    end;

    if v32 then
        bindButton(v32, false);
    end;

    local Mode = TeamGuiLayout.GetMode();
    local v33 = TeamGuiLayout.FindPanel(v31, "Vampire" .. (Mode == "CONSOLE" and "CONSOLE" or "PC"));

    if v33 then
        v33 = TeamGuiLayout.GetMenu(v33);
    end;

    if Mode == "PC" or Mode == "CONSOLE" then
        if v33 then
            v33 = v33:FindFirstChild("Powers");
        end;

        if v33 then
            v33 = v33:FindFirstChild("Sleep");
        end;
    else
        if v33 then
            v33 = v33:FindFirstChild("passivas");
        end;

        if v33 then
            v33 = v33:FindFirstChild("Dormir");
        end;
    end;

    if v33 then
        bindButton(v33, true);
    end;
end;

local function bindCharacter(p34) -- Line: 215
    -- upvalues: u3 (copy), refreshButtons (copy), u2 (copy), refreshButton (copy)
    for _, v in ipairs(u3) do
        v:Disconnect();
    end;

    table.clear(u3);
    local AttributeChangedSignal = p34:GetAttributeChangedSignal("CeilingSleeping");
    table.insert(u3, AttributeChangedSignal:Connect(refreshButtons));
    table.insert(u3, p34.AncestryChanged:Connect(refreshButtons));

    for i in pairs(u2) do
        refreshButton(i);
    end;
end;

ContextActionService:BindActionAtPriority("ToggleVampireCeilingSleep", function(p35, p36) -- Line: 225, Name: handleCeilingSleepAction
    -- upvalues: UserInputService (copy), getUsableCharacter (copy), CeilingSleepRemote (copy)
    if p36 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass;
    end;

    if UserInputService:GetFocusedTextBox() then
        return Enum.ContextActionResult.Pass;
    end;

    local v37, _, v38 = getUsableCharacter();
    local v39;

    if v37 and v38 then
        CeilingSleepRemote:FireServer("Toggle", v38.Position);
        v39 = true;
    else
        v39 = false;
    end;

    if v39 then
        return Enum.ContextActionResult.Sink;
    end;

    return Enum.ContextActionResult.Pass;
end, false, 3500, Enum.KeyCode.B, Enum.KeyCode.ButtonL1);
UserInputService.JumpRequest:Connect(function() -- Line: 250
    -- upvalues: LocalPlayer (copy), CeilingSleepRemote (copy)
    local Character = LocalPlayer.Character;

    if Character and Character:GetAttribute("CeilingSleeping") == true then
        CeilingSleepRemote:FireServer("Detach");
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshButtons);
LocalPlayer:GetAttributeChangedSignal("Years"):Connect(refreshButtons);
LocalPlayer.CharacterAdded:Connect(bindCharacter);

if LocalPlayer.Character then
    bindCharacter(LocalPlayer.Character);
end;

LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(p40) -- Line: 267
    -- upvalues: bindButton (copy)
    if p40:IsA("GuiObject") then
        if p40.Name == "Sleep" and (p40.Parent and p40.Parent.Name == "Powers") then
            task.defer(bindButton, p40, true);

            return;
        end;

        if p40:IsA("GuiButton") and p40.Name == "VampireSleep" then
            task.defer(bindButton, p40, false);

            return;
        end;

        if p40:IsA("GuiButton") and p40.Name == "Dormir" then
            local Parent = p40.Parent;
            local v41 = p40:FindFirstAncestorOfClass("ScreenGui");

            if v41 and (v41.Name == "TEAMS" and (Parent and Parent.Name == "VampireMOBILE")) then
                task.defer(bindButton, p40, false);

                return;
            end;

            if Parent and Parent.Name == "passivas" then
                task.defer(bindButton, p40, true);
            end;
        end;
    end;
end);
findAndBindButtons();