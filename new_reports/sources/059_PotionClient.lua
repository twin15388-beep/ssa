-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local DrinkPotionRemote = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("DrinkPotionRemote");
local u1 = false;
local u2 = false;
local u3 = nil;

local function showConfirmation(p4) -- Line: 17
    -- upvalues: LocalPlayer (copy), GuiService (copy), u1 (ref), DrinkPotionRemote (copy), script_Parent (copy)
    local v5 = p4 and "VampireBloodConfirmUI" or "HumanPotionConfirmUI";

    if LocalPlayer.PlayerGui:FindFirstChild(v5) then
        return;
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = v5;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Parent = LocalPlayer.PlayerGui;
    local Frame = Instance.new("Frame");
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame.Size = UDim2.new(0.9, 0, 0.4, 0);
    Frame.BackgroundTransparency = 1;
    Frame.Parent = ScreenGui;
    local UISizeConstraint = Instance.new("UISizeConstraint");
    UISizeConstraint.MaxSize = Vector2.new(650, 250);
    UISizeConstraint.Parent = Frame;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Size = UDim2.new(1, 0, 0.5, 0);
    TextLabel.Position = UDim2.new(0, 0, 0, 0);
    TextLabel.BackgroundTransparency = 1;

    if p4 then
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Humans" then
            TextLabel.Text = "Are you sure you want to become a Vampire?\nYou will lose your human progress.";
        else
            TextLabel.Text = "Are you sure you want to become a Vampire?\nYou will leave the Witches team.";
        end;

        TextLabel.TextColor3 = Color3.fromRGB(255, 100, 100);
    else
        TextLabel.Text = "Are you sure you want to become human again?\nYou will lose all your vampire progress.";
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    end;

    TextLabel.TextStrokeTransparency = 0;
    TextLabel.Font = Enum.Font.JosefinSans;
    TextLabel.TextScaled = true;
    TextLabel.Parent = Frame;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MaxTextSize = 36;
    UITextSizeConstraint.Parent = TextLabel;
    local TextButton = Instance.new("TextButton");
    TextButton.Size = UDim2.new(0.35, 0, 0.35, 0);
    TextButton.Position = UDim2.new(0.1, 0, 0.6, 0);
    TextButton.BackgroundTransparency = 1;
    TextButton.Text = "Yes";
    TextButton.TextColor3 = Color3.fromRGB(150, 255, 150);
    TextButton.TextStrokeTransparency = 0;
    TextButton.Font = Enum.Font.JosefinSans;
    TextButton.TextScaled = true;
    TextButton.Parent = Frame;
    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint2.MaxTextSize = 45;
    UITextSizeConstraint2.Parent = TextButton;
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Size = UDim2.new(0.35, 0, 0.35, 0);
    TextButton2.Position = UDim2.new(0.55, 0, 0.6, 0);
    TextButton2.BackgroundTransparency = 1;
    TextButton2.Text = "No";
    TextButton2.TextColor3 = Color3.fromRGB(255, 150, 150);
    TextButton2.TextStrokeTransparency = 0;
    TextButton2.Font = Enum.Font.JosefinSans;
    TextButton2.TextScaled = true;
    TextButton2.Parent = Frame;
    GuiService.SelectedObject = TextButton;
    local UITextSizeConstraint3 = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint3.MaxTextSize = 45;
    UITextSizeConstraint3.Parent = TextButton2;
    TextButton.MouseButton1Click:Connect(function() -- Line: 93
        -- upvalues: ScreenGui (copy), u1 (ref), DrinkPotionRemote (ref), script_Parent (ref)
        ScreenGui:Destroy();
        u1 = true;
        DrinkPotionRemote:FireServer(script_Parent);
        task.delay(1.5, function() -- Line: 97
            -- upvalues: u1 (ref)
            u1 = false;
        end);
    end);
    TextButton2.MouseButton1Click:Connect(function() -- Line: 100
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy();
    end);
end;

local function tryDrink() -- Line: 105
    -- upvalues: u1 (ref), u2 (ref), LocalPlayer (copy), script_Parent (copy), showConfirmation (copy), DrinkPotionRemote (copy)
    if u1 or not u2 then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character or script_Parent.Parent ~= Character then
        return;
    end;

    local v6 = Character:FindFirstChildOfClass("Humanoid");

    if not v6 or v6.Health <= 0 then
        return;
    end;

    if Character:GetAttribute("ActionLocked") and not Character:GetAttribute("DrinkingPotion") then
        return;
    end;

    if script_Parent.Name == "Human Potion" and (LocalPlayer.Team and (LocalPlayer.Team.Name == "Vampires" or LocalPlayer.Team.Name == "Cannibal Raised")) then
        showConfirmation(false);

        return;
    end;

    if script_Parent.Name == "Vampire Blood" and (LocalPlayer.Team and (LocalPlayer.Team.Name ~= "Vampires" and LocalPlayer.Team.Name ~= "Cannibal Raised")) then
        showConfirmation(true);

        return;
    end;

    u1 = true;
    DrinkPotionRemote:FireServer(script_Parent);
    task.delay(1.5, function() -- Line: 126
        -- upvalues: u1 (ref)
        u1 = false;
    end);
end;

script_Parent.Equipped:Connect(function() -- Line: 131
    -- upvalues: u2 (ref), script_Parent (copy), u3 (ref)
    u2 = true;
    local Parent = script_Parent.Parent;

    if Parent then
        Parent = Parent:FindFirstChildOfClass("Humanoid");
    end;

    if Parent then
        Parent = Parent:FindFirstChildOfClass("Animator");
    end;

    local EquipAnimation = script_Parent:FindFirstChild("EquipAnimation");

    if Parent and EquipAnimation then
        local success, result = pcall(function() -- Line: 138
            -- upvalues: Parent (copy), EquipAnimation (copy)
            return Parent:LoadAnimation(EquipAnimation);
        end);

        if success and result then
            u3 = result;
            result.Priority = Enum.AnimationPriority.Action4;
            result.Looped = false;
            result:Play(0.1);
        end;
    end;
end);
script_Parent.Unequipped:Connect(function() -- Line: 150
    -- upvalues: u2 (ref), u3 (ref), LocalPlayer (copy)
    u2 = false;

    if u3 then
        pcall(function() -- Line: 153
            -- upvalues: u3 (ref)
            u3:Stop(0.1);
            u3:Destroy();
        end);
        u3 = nil;
    end;

    if LocalPlayer and LocalPlayer.PlayerGui then
        local HumanPotionConfirmUI = LocalPlayer.PlayerGui:FindFirstChild("HumanPotionConfirmUI");
        local VampireBloodConfirmUI = LocalPlayer.PlayerGui:FindFirstChild("VampireBloodConfirmUI");

        if HumanPotionConfirmUI then
            HumanPotionConfirmUI:Destroy();
        end;

        if VampireBloodConfirmUI then
            VampireBloodConfirmUI:Destroy();
        end;
    end;
end);
script_Parent.Activated:Connect(function() -- Line: 167
    -- upvalues: tryDrink (copy)
    tryDrink();
end);
UserInputService.InputBegan:Connect(function(p7, p8) -- Line: 171
    -- upvalues: u2 (ref), tryDrink (copy)
    if not u2 or p8 then
        return;
    end;

    if p7.UserInputType == Enum.UserInputType.MouseButton1 or (p7.UserInputType == Enum.UserInputType.Touch or p7.KeyCode == Enum.KeyCode.ButtonR2) then
        tryDrink();
    end;
end);