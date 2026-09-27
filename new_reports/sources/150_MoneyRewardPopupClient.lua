-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("MoneyRewardPopupRemote").OnClientEvent:Connect(function(p1, p2, p3) -- Line: 13, Name: showRewardPopup
    -- upvalues: PlayerGui (copy), TweenService (copy), Debris (copy)
    if typeof(p1) ~= "Instance" or not p1:IsA("Model") then
        return;
    end;

    local v4 = tonumber(p2) or 0;
    local math_floor_ret = math.floor(v4);
    local math_max_ret = math.max(0, math_floor_ret);

    if math_max_ret <= 0 and not p3 then
        return;
    end;

    local v5 = p1:FindFirstChild("Head") or p1:FindFirstChild("UpperTorso") or (p1:FindFirstChild("Torso") or p1:FindFirstChild("HumanoidRootPart"));

    if not (v5 and v5:IsA("BasePart")) then
        return;
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "MoneyRewardPopup";
    BillboardGui.Adornee = v5;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.MaxDistance = 90;
    BillboardGui.Size = UDim2.fromOffset(120, p3 and 64 or 42);
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.2, 0);
    BillboardGui.Parent = PlayerGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Amount";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = p3 and UDim2.new(1, 0, 0.55, 0) or UDim2.fromScale(1, 1);
    TextLabel.Font = Enum.Font.JosefinSans;
    TextLabel.Text = "+" .. tostring(math_max_ret);
    TextLabel.TextColor3 = Color3.fromRGB(255, 225, 105);
    TextLabel.TextScaled = true;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(35, 20, 0);
    TextLabel.TextStrokeTransparency = 0.2;
    TextLabel.Parent = BillboardGui;
    local v6;

    if p3 then
        v6 = Instance.new("TextLabel");
        v6.Name = "TimeBonus";
        v6.BackgroundTransparency = 1;
        v6.Position = UDim2.new(0, 0, 0.55, 0);
        v6.Size = UDim2.new(1, 0, 0.45, 0);
        v6.Font = Enum.Font.JosefinSans;
        v6.Text = tostring(p3);
        v6.TextColor3 = Color3.fromRGB(235, 35, 45);
        v6.TextScaled = true;
        v6.TextStrokeColor3 = Color3.fromRGB(20, 0, 0);
        v6.TextStrokeTransparency = 0.2;
        v6.Parent = BillboardGui;
    else
        v6 = nil;
    end;

    local TweenInfo_new_ret = TweenInfo.new(1.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    TweenService:Create(BillboardGui, TweenInfo_new_ret, {
        StudsOffsetWorldSpace = Vector3.new(0, 4.6, 0)
    }):Play();
    TweenService:Create(TextLabel, TweenInfo_new_ret, {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }):Play();

    if v6 then
        TweenService:Create(v6, TweenInfo_new_ret, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play();
    end;

    Debris:AddItem(BillboardGui, 1.5);
end);