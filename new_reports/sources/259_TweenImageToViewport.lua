-- Decompiled with Potassium's decompiler.

local ViewportFrame = script.Parent.Parent:FindFirstChild("ViewportFrame");
local ItemImage = script.Parent.Parent:FindFirstChild("ItemImage");
game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u1 = TweenService:Create(ItemImage, TweenInfo_new_ret, {
    ImageTransparency = 0
});
local u2 = TweenService:Create(ItemImage, TweenInfo_new_ret, {
    ImageTransparency = 1
});
local u3 = TweenService:Create(ViewportFrame, TweenInfo_new_ret, {
    ImageTransparency = 0
});
local u4 = TweenService:Create(ViewportFrame, TweenInfo_new_ret, {
    ImageTransparency = 1
});
ViewportFrame.MouseEnter:Connect(function() -- Line: 15
    -- upvalues: u2 (copy), u3 (copy)
    u2:Play();
    u3:Play();
end);
ViewportFrame.MouseLeave:Connect(function() -- Line: 20
    -- upvalues: u1 (copy), u4 (copy)
    u1:Play();
    u4:Play();
end);