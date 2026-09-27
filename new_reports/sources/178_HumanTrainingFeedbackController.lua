-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local HumanTrainingFeedback = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("HumanTrainingFeedback");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "HumanTrainingFeedbackGui";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = false;
ScreenGui.DisplayOrder = 35;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
local u1 = {};
local u2 = false;
local u3 = {
    Agility = Color3.fromRGB(130, 230, 170),
    Durability = Color3.fromRGB(235, 205, 125)
};

local function showNext() -- Line: 26
    -- upvalues: u2 (ref), u1 (copy), UserInputService (copy), u3 (copy), ScreenGui (copy), TweenService (copy), showNext (copy)
    if u2 or #u1 == 0 then
        return;
    end;

    u2 = true;
    local table_remove_ret = table.remove(u1, 1);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TrainingGain";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Position = UDim2.fromScale(0.5, UserInputService.TouchEnabled and 0.58 or 0.64);
    TextLabel.Size = UDim2.fromOffset(UserInputService.TouchEnabled and 145 or 170, 20);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Font = Enum.Font.JosefinSans;
    TextLabel.Text = ("+%d %s"):format(table_remove_ret.amount, table_remove_ret.stat);
    TextLabel.TextColor3 = u3[table_remove_ret.stat] or Color3.new(1, 1, 1);
    TextLabel.TextSize = 15;
    TextLabel.TextScaled = false;
    TextLabel.TextStrokeTransparency = 1;
    TextLabel.TextTransparency = 0;
    TextLabel.ZIndex = 2;
    TextLabel.Parent = ScreenGui;
    local v4 = TweenService:Create(TextLabel, TweenInfo.new(1.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1,
        Position = TextLabel.Position - UDim2.fromOffset(0, 24)
    });
    v4:Play();
    v4.Completed:Wait();
    TextLabel:Destroy();
    u2 = false;
    showNext();
end;

HumanTrainingFeedback.OnClientEvent:Connect(function(p5, p6) -- Line: 63
    -- upvalues: u1 (copy), showNext (copy)
    if p5 ~= "Agility" and p5 ~= "Durability" then
        return;
    end;

    local v7 = tonumber(p6) or 0;
    local math_floor_ret = math.floor(v7);
    local math_clamp_ret = math.clamp(math_floor_ret, 1, 100);

    if #u1 >= 4 then
        table.remove(u1, 1);
    end;

    table.insert(u1, {
        stat = p5,
        amount = math_clamp_ret
    });
    showNext();
end);