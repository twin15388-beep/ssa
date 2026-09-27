-- Decompiled with Potassium's decompiler.

require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local Soul = script.Parent:WaitForChild("Soul");
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "WitchLifeDrainRequest");
local WitchLifeDrainRemote = NetworkRegistry.Legacy.Events:WaitForChild("WitchLifeDrainRemote");
local u1 = false;
local u2 = 0;
local ImageColor3 = Soul.ImageColor3;
local ImageTransparency = Soul.ImageTransparency;
local BackgroundColor3 = Soul.BackgroundColor3;
local BackgroundTransparency = Soul.BackgroundTransparency;
local AutoButtonColor = Soul.AutoButtonColor;
local CooldownText = Soul:FindFirstChild("CooldownText");

if not CooldownText then
    CooldownText = Instance.new("TextLabel");
    CooldownText.Name = "CooldownText";
    CooldownText.AnchorPoint = Vector2.new(0.5, 0.5);
    CooldownText.Position = UDim2.fromScale(0.5, 0.5);
    CooldownText.Size = UDim2.fromScale(0.55, 0.55);
    CooldownText.BackgroundTransparency = 1;
    CooldownText.TextColor3 = Color3.new(1, 1, 1);
    CooldownText.TextStrokeTransparency = 0.2;
    CooldownText.Font = Enum.Font.JosefinSans;
    CooldownText.TextScaled = true;
    CooldownText.ZIndex = Soul.ZIndex + 4;
    CooldownText.Parent = Soul;
end;

local function isWitch() -- Line: 38
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
end;

local function updateButtonState() -- Line: 42
    -- upvalues: UserInputService (copy), LocalPlayer (copy), u2 (ref), u1 (ref), Soul (copy), AutoButtonColor (copy), BackgroundColor3 (copy), BackgroundTransparency (copy), ImageColor3 (copy), ImageTransparency (copy), CooldownText (ref)
    local v3 = UserInputService.TouchEnabled and LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    local v4 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v4);
    local v5 = v3 and not u1 and math_max_ret <= 0;
    Soul.Visible = v3;
    Soul.Active = v5;
    Soul.AutoButtonColor = v5 and AutoButtonColor or false;
    Soul.BackgroundColor3 = BackgroundColor3;
    Soul.BackgroundTransparency = BackgroundTransparency;

    if math_max_ret > 0 or u1 then
        Soul.ImageColor3 = ImageColor3:Lerp(Color3.new(0, 0, 0), 0.6);
        Soul.ImageTransparency = math.min(0.88, ImageTransparency + 0.08);
    else
        Soul.ImageColor3 = ImageColor3;
        Soul.ImageTransparency = ImageTransparency;
    end;

    if v3 then
        v3 = math_max_ret > 0;
    end;

    CooldownText.Visible = v3;
    local v6;

    if math_max_ret > 0 then
        local math_ceil_ret = math.ceil(math_max_ret);
        v6 = tostring(math_ceil_ret) or "";
    else
        v6 = "";
    end;

    CooldownText.Text = v6;
    Soul:SetAttribute("CooldownRemaining", (math.ceil(math_max_ret)));
end;

Soul.Activated:Connect(function() -- Line: 64, Name: requestDrain
    -- upvalues: UserInputService (copy), LocalPlayer (copy), u1 (ref), u2 (ref), updateButtonState (copy), Event (copy)
    if script.Parent:GetAttribute("IsDragging") == true then
        return;
    end;

    if UserInputService.TouchEnabled then
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" and (not u1 and workspace:GetServerTimeNow() >= u2) then
            u1 = true;
            updateButtonState();
            Event:FireServer();
            task.delay(1.5, function() -- Line: 81
                -- upvalues: u1 (ref), updateButtonState (ref)
                if u1 then
                    u1 = false;
                    updateButtonState();
                end;
            end);

            return;
        end;
    end;

    updateButtonState();
end);
WitchLifeDrainRemote.OnClientEvent:Connect(function(p7, p8, p9) -- Line: 91
    -- upvalues: u2 (ref), u1 (ref), updateButtonState (copy)
    if p7 == "Started" then
        u2 = tonumber(p8) or workspace:GetServerTimeNow() + 38;
        u1 = false;
    elseif p7 == "Rejected" then
        u2 = tonumber(p9) or u2;
        u1 = false;
    elseif p7 == "Stopped" then
        u1 = false;
    end;

    updateButtonState();
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 104
    -- upvalues: LocalPlayer (copy), u1 (ref), updateButtonState (copy)
    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u1 = false;
    end;

    updateButtonState();
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 111
    -- upvalues: u1 (ref), updateButtonState (copy)
    u1 = false;
    task.defer(updateButtonState);
end);
local u10 = 0;
RunService.RenderStepped:Connect(function(p11) -- Line: 117
    -- upvalues: u10 (ref), updateButtonState (copy)
    u10 = u10 + p11;

    if u10 < 0.1 then
        return;
    end;

    u10 = 0;
    updateButtonState();
end);
updateButtonState();