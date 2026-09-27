-- Decompiled with Potassium's decompiler.

if game:GetService("RunService"):IsStudio() then
    return;
end;

for i = 1, 7 do
    local v1 = i;

    for i2 = 1, 10 do
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Size = UDim2.fromScale(0.15, 0.1);
        TextLabel.Position = UDim2.fromScale((v1 - 1) * 0.15, (i2 - 1) * 0.1);
        TextLabel.Parent = script.Parent;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.TextScaled = true;
        TextLabel.Text = game.Players.LocalPlayer.Name;
        TextLabel.Rotation = 5;
        TextLabel.TextColor3 = Color3.new(1, 1, 1);
        TextLabel.TextTransparency = 0.95;
        TextLabel.TextStrokeTransparency = 0.98;
        local _ = i2;
    end;
end;