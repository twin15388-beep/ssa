-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local script_Parent = script.Parent;
local u1 = true;

local function createShowTween() -- Line: 6
    -- upvalues: TweenService (copy), script_Parent (copy)
    return TweenService:Create(script_Parent, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    });
end;

local function createHideTween() -- Line: 17
    -- upvalues: TweenService (copy), script_Parent (copy)
    return TweenService:Create(script_Parent, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, -0.5, 0)
    });
end;

script_Parent:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 28
    -- upvalues: u1 (ref), script_Parent (copy), createShowTween (copy), createHideTween (copy)
    if not u1 then
        return;
    end;

    u1 = false;

    if script_Parent.Visible then
        script_Parent.Position = UDim2.new(0.5, 0, -0.5, 0);
        script_Parent.Visible = true;
        local v2 = createShowTween();
        v2:Play();
        v2.Completed:Connect(function() -- Line: 40
            -- upvalues: u1 (ref)
            u1 = true;
        end);

        return;
    end;

    if script_Parent.Position.Y.Scale ~= 0.5 then
        script_Parent.Visible = false;
        task.wait(0.5);
        u1 = true;

        return;
    end;

    script_Parent.Visible = true;
    local v3 = createHideTween();
    v3:Play();
    v3.Completed:Connect(function() -- Line: 49
        -- upvalues: u1 (ref), script_Parent (ref)
        u1 = true;
        script_Parent.Visible = false;
    end);
end);