-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = 1;
local u5 = {};

local function setup() -- Line: 25
    -- upvalues: PlayerGui (copy), u3 (ref), u1 (ref), u2 (ref), u4 (ref)
    return pcall(function() -- Line: 26
        -- upvalues: PlayerGui (ref), u3 (ref), u1 (ref), u2 (ref), u4 (ref)
        local UpgradesGui = PlayerGui:WaitForChild("UpgradesGui", 10);
        u3 = UpgradesGui;
        u1 = UpgradesGui:WaitForChild("Vampire"):WaitForChild("Container");
        u1.Active = true;
        u1.AnchorPoint = Vector2.new(0.5, 0.5);
        u2 = u1:FindFirstChildOfClass("UIScale");

        if not u2 then
            u2 = Instance.new("UIScale");
            u2.Parent = u1;
        end;

        u4 = u2.Scale;
    end);
end;

if not pcall(function() -- Line: 26
    -- upvalues: PlayerGui (copy), u3 (ref), u1 (ref), u2 (ref), u4 (ref)
    local UpgradesGui = PlayerGui:WaitForChild("UpgradesGui", 10);
    u3 = UpgradesGui;
    u1 = UpgradesGui:WaitForChild("Vampire"):WaitForChild("Container");
    u1.Active = true;
    u1.AnchorPoint = Vector2.new(0.5, 0.5);
    u2 = u1:FindFirstChildOfClass("UIScale");

    if not u2 then
        u2 = Instance.new("UIScale");
        u2.Parent = u1;
    end;

    u4 = u2.Scale;
end) then
    return;
end;

local function smoothZoom(p6) -- Line: 51
    -- upvalues: u4 (ref), TweenService (copy), u2 (ref)
    u4 = math.clamp(p6, 0.6, 3);
    TweenService:Create(u2, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Scale = u4
    }):Play();
end;

local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;

local function isOnControl(u11) -- Line: 62
    -- upvalues: u3 (ref), u1 (ref)
    local Vampire = u3:FindFirstChild("Vampire");
    local v12;

    if Vampire then
        v12 = Vampire:FindFirstChild("Information");
    else
        v12 = Vampire;
    end;

    local function contains(p13) -- Line: 65
        -- upvalues: u11 (copy)
        if not (p13 and p13.Visible) then
            return false;
        end;

        local AbsolutePosition = p13.AbsolutePosition;
        local AbsoluteSize = p13.AbsoluteSize;
        local v14;

        if u11.X >= AbsolutePosition.X and (u11.X <= AbsolutePosition.X + AbsoluteSize.X and u11.Y >= AbsolutePosition.Y) then
            v14 = u11.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v14 = false;
        end;

        return v14;
    end;

    local v15;

    if v12 and v12.Visible then
        local AbsolutePosition = v12.AbsolutePosition;
        local AbsoluteSize = v12.AbsoluteSize;

        if u11.X >= AbsolutePosition.X and (u11.X <= AbsolutePosition.X + AbsoluteSize.X and u11.Y >= AbsolutePosition.Y) then
            v15 = u11.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
        else
            v15 = false;
        end;
    else
        v15 = false;
    end;

    if not v15 then
        if Vampire then
            Vampire = Vampire:FindFirstChild("Close");
        end;

        local v16;

        if Vampire and Vampire.Visible then
            local AbsolutePosition = Vampire.AbsolutePosition;
            local AbsoluteSize = Vampire.AbsoluteSize;

            if u11.X >= AbsolutePosition.X and (u11.X <= AbsolutePosition.X + AbsoluteSize.X and u11.Y >= AbsolutePosition.Y) then
                v16 = u11.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v16 = false;
            end;
        else
            v16 = false;
        end;

        if not v16 then
            for _, child in ipairs(u1:GetChildren()) do
                if child:IsA("GuiButton") then
                    local v17;

                    if child and child.Visible then
                        local AbsolutePosition = child.AbsolutePosition;
                        local AbsoluteSize = child.AbsoluteSize;

                        if u11.X >= AbsolutePosition.X and (u11.X <= AbsolutePosition.X + AbsoluteSize.X and u11.Y >= AbsolutePosition.Y) then
                            v17 = u11.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
                        else
                            v17 = false;
                        end;
                    else
                        v17 = false;
                    end;

                    if v17 then
                        return true;
                    end;
                end;
            end;

            return false;
        end;
    end;

    return true;
end;

UserInputService.InputBegan:Connect(function(p18) -- Line: 80
    -- upvalues: u3 (ref), u5 (copy), u7 (ref), isOnControl (copy), u8 (ref), u1 (ref), u9 (ref), u10 (ref), u4 (ref)
    if p18.UserInputType ~= Enum.UserInputType.Touch or not u3.Enabled then
        return;
    end;

    u5[p18] = p18.Position;
    local v19 = 0;

    for _ in pairs(u5) do
        v19 = v19 + 1;
    end;

    if v19 ~= 1 then
        if v19 == 2 then
            u7 = nil;
            local v20 = {};

            for _, v in pairs(u5) do
                table.insert(v20, v);
            end;

            u9 = (v20[1] - v20[2]).Magnitude;
            u10 = u4;
        end;

        return;
    end;

    u7 = not isOnControl(p18.Position) and p18.Position or nil;
    u8 = u1.Position;
end);
UserInputService.InputChanged:Connect(function(p21) -- Line: 104
    -- upvalues: u3 (ref), smoothZoom (copy), u4 (ref), u5 (copy), u7 (ref), u8 (ref), u1 (ref), u9 (ref), u10 (ref)
    if not u3.Enabled then
        return;
    end;

    if p21.UserInputType ~= Enum.UserInputType.Touch then
        if p21.UserInputType == Enum.UserInputType.MouseWheel then
            smoothZoom(u4 + p21.Position.Z * 0.2);
        end;

        return;
    end;

    u5[p21] = p21.Position;
    local v22 = 0;

    for _ in pairs(u5) do
        v22 = v22 + 1;
    end;

    if v22 ~= 1 or not u7 then
        if v22 == 2 and u9 then
            local v23 = {};

            for _, v in pairs(u5) do
                table.insert(v23, v);
            end;

            smoothZoom(u10 * ((v23[1] - v23[2]).Magnitude / u9));
        end;

        return;
    end;

    local v24 = p21.Position - u7;
    local ViewportSize = workspace.CurrentCamera.ViewportSize;
    local math_clamp_ret = math.clamp(u8.X.Offset + v24.X, -ViewportSize.X / 2 - 300, ViewportSize.X / 2 + 300);
    local math_clamp_ret2 = math.clamp(u8.Y.Offset + v24.Y, -ViewportSize.Y / 2 - 300, ViewportSize.Y / 2 + 300);
    u1.Position = UDim2.new(u8.X.Scale, math_clamp_ret, u8.Y.Scale, math_clamp_ret2);
end);
UserInputService.InputEnded:Connect(function(p25) -- Line: 140
    -- upvalues: u5 (copy), u9 (ref), u10 (ref), u7 (ref), u8 (ref), u1 (ref)
    if p25.UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    u5[p25] = nil;
    local v26 = 0;

    for _ in pairs(u5) do
        v26 = v26 + 1;
    end;

    u9 = nil;
    u10 = nil;

    if v26 == 1 then
        for _, v in pairs(u5) do
            u7 = v;
            u8 = u1.Position;
        end;

        return;
    end;

    if v26 == 0 then
        u7 = nil;
    end;
end);
local u27 = false;
local u28 = nil;
local u29 = nil;
UserInputService.InputBegan:Connect(function(p30) -- Line: 166
    -- upvalues: u3 (ref), u27 (ref), isOnControl (copy), u28 (ref), u29 (ref), u1 (ref)
    if p30.UserInputType == Enum.UserInputType.MouseButton1 and u3.Enabled then
        u27 = not isOnControl(p30.Position);
        u28 = p30.Position;
        u29 = u1.Position;
    end;
end);
UserInputService.InputEnded:Connect(function(p31) -- Line: 174
    -- upvalues: u27 (ref)
    if p31.UserInputType == Enum.UserInputType.MouseButton1 then
        u27 = false;
    end;
end);
UserInputService.InputChanged:Connect(function(p32) -- Line: 181
    -- upvalues: u27 (ref), u3 (ref), u28 (ref), u29 (ref), u1 (ref)
    if u27 and (u3.Enabled and p32.UserInputType == Enum.UserInputType.MouseMovement) then
        local v33 = p32.Position - u28;
        local ViewportSize = workspace.CurrentCamera.ViewportSize;
        local math_clamp_ret = math.clamp(u29.X.Offset + v33.X, -ViewportSize.X / 2 - 300, ViewportSize.X / 2 + 300);
        local math_clamp_ret2 = math.clamp(u29.Y.Offset + v33.Y, -ViewportSize.Y / 2 - 300, ViewportSize.Y / 2 + 300);
        u1.Position = UDim2.new(u29.X.Scale, math_clamp_ret, u29.Y.Scale, math_clamp_ret2);
    end;
end);