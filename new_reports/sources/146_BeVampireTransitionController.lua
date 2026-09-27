-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local BeVampireTransition = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("BeVampireTransition");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "BeVampireTransitionGui";
ScreenGui.IgnoreGuiInset = true;
ScreenGui.ResetOnSpawn = false;
ScreenGui.DisplayOrder = 10000;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
local Frame = Instance.new("Frame");
Frame.Name = "Fade";
Frame.Size = UDim2.fromScale(1, 1);
Frame.Position = UDim2.fromScale(0, 0);
Frame.BackgroundColor3 = Color3.new(0, 0, 0);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
Frame.Visible = false;
Frame.ZIndex = 100;
Frame.Parent = ScreenGui;
local u1 = nil;
local u2 = 0;

local function tweenTransparency(p3, p4) -- Line: 31
    -- upvalues: u2 (ref), u1 (ref), Frame (copy), TweenService (copy)
    u2 = u2 + 1;

    if u1 then
        u1:Cancel();
    end;

    Frame.Visible = true;
    u1 = TweenService:Create(Frame, TweenInfo.new(math.max(0, p4), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        BackgroundTransparency = p3
    });
    u1:Play();
    u1.Completed:Wait();

    if u2 == u2 and p3 >= 1 then
        Frame.Visible = false;
    end;
end;

BeVampireTransition.OnClientEvent:Connect(function(p5, p6) -- Line: 53
    -- upvalues: tweenTransparency (copy)
    local v7 = typeof(p6) == "number" and p6 and p6 or 1;

    if p5 == "FadeOut" then
        task.spawn(tweenTransparency, 0, v7);

        return;
    end;

    if p5 == "FadeIn" then
        task.spawn(tweenTransparency, 1, v7);
    end;
end);