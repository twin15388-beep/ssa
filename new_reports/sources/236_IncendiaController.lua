-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Parent = script_Parent.Parent;
local incendia = script_Parent:WaitForChild("incendia");
local v1 = ReplicatedStorage:WaitForChild("Funções");
local IncendiaRemote = v1:WaitForChild("Eventos"):WaitForChild("IncendiaRemote");
local Event = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry")).GetEvent("Combat", "IncendiaRequest");
local Incendia = require(v1:WaitForChild("WitchSpellsConfig")).Incendia;
local Mouse = LocalPlayer:GetMouse();
local ImageColor3 = incendia.ImageColor3;
local ImageTransparency = incendia.ImageTransparency;
local BackgroundColor3 = incendia.BackgroundColor3;
local BackgroundTransparency = incendia.BackgroundTransparency;
local u2 = false;
local u3 = 0;
local u4 = false;
local u5 = 0;
local u6 = nil;
local u7 = nil;
local CooldownText = incendia:FindFirstChild("CooldownText");

if not CooldownText then
    CooldownText = Instance.new("TextLabel");
    CooldownText.Name = "CooldownText";
    CooldownText.AnchorPoint = Vector2.new(0.5, 0.5);
    CooldownText.Position = UDim2.fromScale(0.5, 0.5);
    CooldownText.Size = UDim2.fromScale(0.55, 0.55);
    CooldownText.BackgroundTransparency = 1;
    CooldownText.Font = Enum.Font.JosefinSans;
    CooldownText.TextColor3 = Color3.new(1, 1, 1);
    CooldownText.TextScaled = true;
    CooldownText.TextStrokeTransparency = 0.2;
    CooldownText.ZIndex = incendia.ZIndex + 2;
    CooldownText.Parent = incendia;
end;

local function isWitch() -- Line: 49
    -- upvalues: LocalPlayer (copy)
    local v8;

    if LocalPlayer.Team == nil then
        v8 = false;
    else
        v8 = LocalPlayer.Team.Name == "Witches";
    end;

    return v8;
end;

local function getCharacterParts() -- Line: 53
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v9;

    if Character then
        v9 = Character:FindFirstChildOfClass("Humanoid");
    else
        v9 = Character;
    end;

    local v10;

    if Character then
        v10 = Character:FindFirstChild("HumanoidRootPart");
    else
        v10 = Character;
    end;

    if not (Character and (v9 and (v9.Health > 0 and v10))) then
        return nil;
    end;

    if Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("Hibernating") == true or Character:GetAttribute("Ragdolled") == true) then
        return nil;
    end;

    return Character, v9, v10;
end;

local function setButtonState() -- Line: 69
    -- upvalues: u5 (ref), CooldownText (ref), incendia (copy), u4 (ref), u2 (ref), ImageColor3 (copy), ImageTransparency (copy), BackgroundColor3 (copy), BackgroundTransparency (copy)
    local v11 = u5 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v11);
    CooldownText.Visible = math_max_ret > 0;
    local v12;

    if math_max_ret > 0 then
        local math_ceil_ret = math.ceil(math_max_ret);
        v12 = tostring(math_ceil_ret) or "";
    else
        v12 = "";
    end;

    CooldownText.Text = v12;
    local v13;

    if math_max_ret <= 0 then
        v13 = not u4;
    else
        v13 = false;
    end;

    incendia.Active = v13;
    incendia.AutoButtonColor = incendia.Active;

    if u2 or (math_max_ret > 0 or u4) then
        incendia.ImageColor3 = ImageColor3:Lerp(Color3.new(0, 0, 0), 0.6);
        incendia.ImageTransparency = math.min(0.88, ImageTransparency + 0.08);
        incendia.BackgroundColor3 = BackgroundColor3;
        incendia.BackgroundTransparency = BackgroundTransparency;

        return;
    end;

    incendia.ImageColor3 = ImageColor3;
    incendia.ImageTransparency = ImageTransparency;
    incendia.BackgroundColor3 = BackgroundColor3;
    incendia.BackgroundTransparency = BackgroundTransparency;
end;

local function stopAiming() -- Line: 90
    -- upvalues: u2 (ref), u6 (ref), LocalPlayer (copy), u7 (ref), setButtonState (copy)
    u2 = false;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character and u7 ~= nil then
        Character.AutoRotate = u7;
    end;

    u7 = nil;
    setButtonState();
end;

local function beginAiming() -- Line: 107
    -- upvalues: Parent (copy), script_Parent (copy), TeamGuiLayout (copy), u2 (ref), u6 (ref), LocalPlayer (copy), u7 (ref), setButtonState (copy), u4 (ref), u5 (ref), getCharacterParts (copy), u3 (ref), RunService (copy), Mouse (copy), Incendia (copy)
    if not Parent.Visible then
        return;
    end;

    if script_Parent:GetAttribute("IsDragging") == true then
        return;
    end;

    if TeamGuiLayout.GetMode() ~= "MOBILE" then
        return;
    end;

    if not u2 then
        if not u4 and workspace:GetServerTimeNow() >= u5 then
            local v14;

            if LocalPlayer.Team == nil then
                v14 = false;
            else
                v14 = LocalPlayer.Team.Name == "Witches";
            end;

            if v14 then
                local u15, v16, _ = getCharacterParts();

                if not u15 then
                    return;
                end;

                u2 = true;
                u3 = os.clock();
                u7 = v16.AutoRotate;
                v16.AutoRotate = false;
                u6 = RunService.RenderStepped:Connect(function() -- Line: 128
                    -- upvalues: u2 (ref), LocalPlayer (ref), u6 (ref), u7 (ref), setButtonState (ref), getCharacterParts (ref), u15 (copy), Mouse (ref)
                    if u2 then
                        local v17;

                        if LocalPlayer.Team == nil then
                            v17 = false;
                        else
                            v17 = LocalPlayer.Team.Name == "Witches";
                        end;

                        if v17 then
                            local v18, _, v19 = getCharacterParts();

                            if v18 == u15 then
                                local Position = Mouse.Hit.Position;
                                local Vector3_new_ret = Vector3.new(Position.X, v19.Position.Y, Position.Z);

                                if (Vector3_new_ret - v19.Position).Magnitude > 0.1 then
                                    v19.CFrame = CFrame.lookAt(v19.Position, Vector3_new_ret);
                                end;

                                return;
                            end;

                            u2 = false;

                            if u6 then
                                u6:Disconnect();
                                u6 = nil;
                            end;

                            local Character = LocalPlayer.Character;

                            if Character then
                                Character = Character:FindFirstChildOfClass("Humanoid");
                            end;

                            if Character and u7 ~= nil then
                                Character.AutoRotate = u7;
                            end;

                            u7 = nil;
                            setButtonState();

                            return;
                        end;
                    end;

                    u2 = false;

                    if u6 then
                        u6:Disconnect();
                        u6 = nil;
                    end;

                    local Character = LocalPlayer.Character;

                    if Character then
                        Character = Character:FindFirstChildOfClass("Humanoid");
                    end;

                    if Character and u7 ~= nil then
                        Character.AutoRotate = u7;
                    end;

                    u7 = nil;
                    setButtonState();
                end);
                setButtonState();
                task.delay(Incendia.AimTimeout, function() -- Line: 146
                    -- upvalues: u2 (ref), u3 (ref), Incendia (ref), u6 (ref), LocalPlayer (ref), u7 (ref), setButtonState (ref)
                    if u2 and os.clock() - u3 >= Incendia.AimTimeout - 0.1 then
                        u2 = false;

                        if u6 then
                            u6:Disconnect();
                            u6 = nil;
                        end;

                        local Character = LocalPlayer.Character;

                        if Character then
                            Character = Character:FindFirstChildOfClass("Humanoid");
                        end;

                        if Character and u7 ~= nil then
                            Character.AutoRotate = u7;
                        end;

                        u7 = nil;
                        setButtonState();
                    end;
                end);

                return;
            end;
        end;

        return;
    end;

    u2 = false;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character and u7 ~= nil then
        Character.AutoRotate = u7;
    end;

    u7 = nil;
    setButtonState();
end;

local function findHumanoidModel(p20) -- Line: 153
    while p20 and p20 ~= workspace do
        if p20:IsA("Model") and p20:FindFirstChildOfClass("Humanoid") then
            return p20;
        end;

        p20 = p20.Parent;
    end;

    return nil;
end;

local function castAtMouse() -- Line: 164
    -- upvalues: script_Parent (copy), u2 (ref), u4 (ref), u3 (ref), Mouse (copy), u6 (ref), LocalPlayer (copy), u7 (ref), setButtonState (copy), findHumanoidModel (copy), Event (copy)
    if script_Parent:GetAttribute("IsDragging") == true then
        return;
    end;

    if not (u2 and (not u4 and os.clock() - u3 >= 0.15)) then
        return;
    end;

    local Hit = Mouse.Hit;
    local Target = Mouse.Target;

    if not (Target and Hit) then
        u2 = false;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character and u7 ~= nil then
            Character.AutoRotate = u7;
        end;

        u7 = nil;
        setButtonState();

        return;
    end;

    local v21 = findHumanoidModel(Target);
    u4 = true;
    u2 = false;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character and u7 ~= nil then
        Character.AutoRotate = u7;
    end;

    u7 = nil;
    setButtonState();
    setButtonState();
    Event:FireServer("Cast", Hit.Position, v21);
    task.delay(2, function() -- Line: 180
        -- upvalues: u4 (ref), setButtonState (ref)
        if u4 then
            u4 = false;
            setButtonState();
        end;
    end);
end;

incendia.Activated:Connect(beginAiming);
UserInputService.InputBegan:Connect(function(p22, p23) -- Line: 190
    -- upvalues: UserInputService (copy), beginAiming (copy), u2 (ref), castAtMouse (copy)
    if UserInputService:GetFocusedTextBox() then
        return;
    end;

    if p22.KeyCode == Enum.KeyCode.F and not p23 then
        beginAiming();

        return;
    end;

    if u2 and not (p23 or p22.UserInputType ~= Enum.UserInputType.MouseButton1 and p22.UserInputType ~= Enum.UserInputType.Touch) then
        castAtMouse();
    end;
end);
IncendiaRemote.OnClientEvent:Connect(function(p24, p25, p26) -- Line: 205
    -- upvalues: u2 (ref), u6 (ref), LocalPlayer (copy), u7 (ref), setButtonState (copy), u4 (ref), u5 (ref), Incendia (copy)
    if p24 == "CastAccepted" then
        u2 = false;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character and u7 ~= nil then
            Character.AutoRotate = u7;
        end;

        u7 = nil;
        setButtonState();
        u4 = false;
        u5 = tonumber(p25) or workspace:GetServerTimeNow() + Incendia.Cooldown;
    elseif p24 == "Rejected" then
        u2 = false;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character and u7 ~= nil then
            Character.AutoRotate = u7;
        end;

        u7 = nil;
        setButtonState();
        u4 = false;

        if tonumber(p26) then
            u5 = tonumber(p26);
        end;
    end;

    setButtonState();
end);
local u27 = 0;
RunService.RenderStepped:Connect(function(p28) -- Line: 221
    -- upvalues: u27 (ref), LocalPlayer (copy), u2 (ref), u6 (ref), u7 (ref), setButtonState (copy)
    u27 = u27 + p28;

    if u27 < 0.05 then
        return;
    end;

    u27 = 0;
    local v29;

    if LocalPlayer.Team == nil then
        v29 = false;
    else
        v29 = LocalPlayer.Team.Name == "Witches";
    end;

    if not v29 and u2 then
        u2 = false;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character and u7 ~= nil then
            Character.AutoRotate = u7;
        end;

        u7 = nil;
        setButtonState();
    end;

    setButtonState();
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 233
    -- upvalues: LocalPlayer (copy), u2 (ref), u6 (ref), u7 (ref), setButtonState (copy)
    local v30;

    if LocalPlayer.Team == nil then
        v30 = false;
    else
        v30 = LocalPlayer.Team.Name == "Witches";
    end;

    if not v30 then
        u2 = false;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChildOfClass("Humanoid");
        end;

        if Character and u7 ~= nil then
            Character.AutoRotate = u7;
        end;

        u7 = nil;
        setButtonState();
    end;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 240
    -- upvalues: u2 (ref), u6 (ref), LocalPlayer (copy), u7 (ref), setButtonState (copy)
    u2 = false;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if Character and u7 ~= nil then
        Character.AutoRotate = u7;
    end;

    u7 = nil;
    setButtonState();
end);
setButtonState();