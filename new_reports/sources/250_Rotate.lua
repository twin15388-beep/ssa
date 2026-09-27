-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local script_Parent = script.Parent;
local TweenInfo_new_ret = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false);

local function rotateLabel() -- Line: 12
    -- upvalues: script_Parent (copy), TweenService (copy), TweenInfo_new_ret (copy), rotateLabel (copy)
    local v1 = TweenService:Create(script_Parent, TweenInfo_new_ret, {
        Rotation = script_Parent.Rotation + 360
    });
    v1.Completed:Connect(rotateLabel);
    v1:Play();
end;

rotateLabel();