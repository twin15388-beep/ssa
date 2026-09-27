-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local DamagePopupRemote = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("DamagePopupRemote");
local Random_new_ret = Random.new();

local function formatDamage(p1) -- Line: 15
    local v2 = tonumber(p1) or 0;
    local math_max_ret = math.max(0, v2);
    local math_floor_ret = math.floor(math_max_ret + 0.5);

    if math.abs(math_max_ret - math_floor_ret) < 0.05 then
        return "-" .. tostring(math_floor_ret);
    end;

    return string.format("-%.1f", math_max_ret);
end;

local function findAdornee(p3) -- Line: 24
    if typeof(p3) == "Instance" and p3:IsA("Model") then
        return p3:FindFirstChild("Head") or (p3:FindFirstChild("HumanoidRootPart") or p3.PrimaryPart);
    end;

    return nil;
end;

DamagePopupRemote.OnClientEvent:Connect(function(p4, p5) -- Line: 33, Name: showDamage
    -- upvalues: Random_new_ret (copy), PlayerGui (copy), TweenService (copy), Debris (copy)
    local v6 = tonumber(p5);

    if not v6 or v6 <= 0 then
        return;
    end;

    local v7;

    if typeof(p4) == "Instance" and p4:IsA("Model") then
        v7 = p4:FindFirstChild("Head") or (p4:FindFirstChild("HumanoidRootPart") or p4.PrimaryPart);
    else
        v7 = nil;
    end;

    if not (v7 and v7:IsA("BasePart")) then
        return;
    end;

    local v8 = Random_new_ret:NextNumber(-0.65, 0.65);
    local v9 = 2.15 + Random_new_ret:NextNumber(-0.1, 0.15);
    local Vector3_new_ret = Vector3.new(v8, v9, 0);
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "DamagePopup";
    BillboardGui.Adornee = v7;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.MaxDistance = 120;
    BillboardGui.Size = UDim2.fromOffset(50, 20);
    BillboardGui.StudsOffsetWorldSpace = Vector3_new_ret;
    BillboardGui.Parent = PlayerGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Amount";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.fromScale(1, 1);
    TextLabel.Font = Enum.Font.JosefinSans;
    local v10 = tonumber(v6) or 0;
    local math_max_ret = math.max(0, v10);
    local math_floor_ret = math.floor(math_max_ret + 0.5);
    local v11;

    if math.abs(math_max_ret - math_floor_ret) < 0.05 then
        v11 = "-" .. tostring(math_floor_ret);
    else
        v11 = string.format("-%.1f", math_max_ret);
    end;

    TextLabel.Text = v11;
    TextLabel.TextColor3 = Color3.fromRGB(255, 92, 92);
    TextLabel.TextSize = 13;
    TextLabel.TextScaled = false;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(35, 0, 0);
    TextLabel.TextStrokeTransparency = 0.25;
    TextLabel.Parent = BillboardGui;
    local TweenInfo_new_ret = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    TweenService:Create(BillboardGui, TweenInfo_new_ret, {
        StudsOffsetWorldSpace = Vector3_new_ret + Vector3.new(0, 1.15, 0)
    }):Play();
    TweenService:Create(TextLabel, TweenInfo_new_ret, {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }):Play();
    Debris:AddItem(BillboardGui, 0.85);
end);