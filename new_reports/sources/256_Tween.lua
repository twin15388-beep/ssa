-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Color3_fromRGB_ret = Color3.fromRGB(23, 61, 42);
local Color3_fromRGB_ret2 = Color3.fromRGB(22, 22, 22);
local TweenInfo_new_ret = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

local function tweenColor(p1) -- Line: 9
    -- upvalues: TweenService (copy), script_Parent (copy), TweenInfo_new_ret (copy)
    TweenService:Create(script_Parent, TweenInfo_new_ret, {
        BackgroundColor3 = p1
    }):Play();
end;

script_Parent.MouseEnter:Connect(function() -- Line: 14
    -- upvalues: Color3_fromRGB_ret (copy), TweenService (copy), script_Parent (copy), TweenInfo_new_ret (copy)
    TweenService:Create(script_Parent, TweenInfo_new_ret, {
        BackgroundColor3 = Color3_fromRGB_ret
    }):Play();
end);
script_Parent.MouseLeave:Connect(function() -- Line: 18
    -- upvalues: Color3_fromRGB_ret2 (copy), TweenService (copy), script_Parent (copy), TweenInfo_new_ret (copy)
    TweenService:Create(script_Parent, TweenInfo_new_ret, {
        BackgroundColor3 = Color3_fromRGB_ret2
    }):Play();
end);