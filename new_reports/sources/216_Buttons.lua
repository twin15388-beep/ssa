-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Container = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UpgradesGui"):WaitForChild("Vampire"):WaitForChild("Container");

local function playTween(p1, p2) -- Line: 19
    -- upvalues: TweenService (copy)
    TweenService:Create(p1, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = p2
    }):Play();
end;

local function setupButton(p3) -- Line: 27
    -- upvalues: playTween (copy)
    if not (p3:IsA("ImageButton") or p3:IsA("TextButton")) then
        return;
    end;

    p3.AnchorPoint = Vector2.new(0.5, 0.5);
    local u4 = p3:FindFirstChildOfClass("UIScale");

    if not u4 then
        u4 = Instance.new("UIScale");
        u4.Scale = 1;
        u4.Parent = p3;
    end;

    p3.MouseEnter:Connect(function() -- Line: 43
        -- upvalues: playTween (ref), u4 (ref)
        playTween(u4, 1.1);
    end);
    p3.MouseLeave:Connect(function() -- Line: 47
        -- upvalues: playTween (ref), u4 (ref)
        playTween(u4, 1);
    end);
    p3.MouseButton1Down:Connect(function() -- Line: 51
        -- upvalues: playTween (ref), u4 (ref)
        playTween(u4, 0.9);
    end);
    p3.MouseButton1Up:Connect(function() -- Line: 55
        -- upvalues: playTween (ref), u4 (ref)
        playTween(u4, 1.1);
    end);
end;

for _, child in ipairs(Container:GetChildren()) do
    setupButton(child);
end;

Container.ChildAdded:Connect(function(p5) -- Line: 67
    -- upvalues: setupButton (copy)
    setupButton(p5);
end);