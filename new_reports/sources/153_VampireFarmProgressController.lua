-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 0;
local u7 = 0;

local function update() -- Line: 15
    -- upvalues: u1 (ref), u2 (ref), u3 (ref), LocalPlayer (copy), Workspace (copy), u6 (ref), u4 (ref), u5 (ref), TweenService (copy)
    if not (u1 and (u2 and (u3 and (u1.Parent and u2.Parent)))) then
        return;
    end;

    local v8 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v8);
    local math_max_ret = math.max(0, math_floor_ret);
    local v9 = tonumber(LocalPlayer:GetAttribute("VampireFarmXP")) or 0;
    local math_floor_ret2 = math.floor(v9);
    local math_max_ret2 = math.max(0, math_floor_ret2);
    local v10 = tonumber(LocalPlayer:GetAttribute("VampireFarmRequired")) or 4;
    local math_floor_ret3 = math.floor(v10);
    local math_max_ret3 = math.max(1, math_floor_ret3);
    local v11 = LocalPlayer.Team and LocalPlayer.Team.Name;
    local v12 = (v11 == "Vampires" or (v11 == "Cannibal Raised" or v11 == "Humans")) and true or v11 == "Witches";
    local math_clamp_ret = math.clamp(math_max_ret2 / math_max_ret3, 0, 1);
    local v13 = tonumber(LocalPlayer:GetAttribute("VampireFarmLastGain"));
    local v14;

    if v13 == nil then
        v14 = false;
    else
        v14 = Workspace:GetServerTimeNow() - v13 < 6;
    end;

    if v12 then
        if math_max_ret < 10000 then
            v12 = os.clock() < u6 and true or v14;
        else
            v12 = false;
        end;
    end;

    u2.Visible = v12;

    if u4 and u4.Parent then
        u4.Visible = u2.Visible;
        u4.Text = string.format("XP %d/%d (%d%%)", math_max_ret2, math_max_ret3, (math.floor(math_clamp_ret * 100 + 0.5)));
    end;

    if u5 then
        u5:Cancel();
    end;

    u5 = TweenService:Create(u3, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
        Size = UDim2.fromScale(1, math_clamp_ret)
    });
    u5:Play();
end;

local function revealForGain() -- Line: 49
    -- upvalues: u6 (ref), u7 (ref), update (copy)
    u6 = os.clock() + 6;
    u7 = u7 + 1;
    local u15 = u7;
    update();
    task.delay(6, function() -- Line: 54
        -- upvalues: u7 (ref), u15 (copy), update (ref)
        if u7 == u15 then
            update();
        end;
    end);
end;

local function attach(p16) -- Line: 61
    -- upvalues: u1 (ref), u4 (ref), u2 (ref), u3 (ref), update (copy)
    local VampireXPViewer = p16:FindFirstChild("VampireXPViewer");

    if VampireXPViewer then
        VampireXPViewer:Destroy();
    end;

    u1 = p16:WaitForChild("StaminaViewer", 10);

    if not u1 then
        return;
    end;

    u1.Size = UDim2.fromOffset(26, 96);
    u4 = nil;
    local XPBackground = u1:FindFirstChild("XPBackground");

    if XPBackground then
        XPBackground:Destroy();
    end;

    u2 = Instance.new("Frame");
    u2.Name = "XPBackground";
    u2.AnchorPoint = Vector2.new(0.5, 0.5);
    u2.Position = UDim2.fromOffset(21, 48);
    u2.Size = UDim2.fromOffset(4, 88);
    u2.BackgroundColor3 = Color3.fromRGB(0, 25, 8);
    u2.BackgroundTransparency = 0.35;
    u2.BorderSizePixel = 0;
    u2.ClipsDescendants = true;
    u2.Visible = false;
    u2.Parent = u1;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 2);
    UICorner.Parent = u2;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(45, 255, 105);
    UIStroke.Transparency = 0.05;
    UIStroke.Thickness = 1;
    UIStroke.LineJoinMode = Enum.LineJoinMode.Miter;
    UIStroke.Parent = u2;
    u3 = Instance.new("Frame");
    u3.Name = "XPFill";
    u3.AnchorPoint = Vector2.new(0.5, 1);
    u3.Position = UDim2.fromScale(0.5, 1);
    u3.Size = UDim2.fromScale(1, 0);
    u3.BackgroundColor3 = Color3.fromRGB(25, 210, 80);
    u3.BorderSizePixel = 0;
    u3.Parent = u2;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 2);
    UICorner2.Parent = u3;
    update();
end;

LocalPlayer:GetAttributeChangedSignal("Years"):Connect(update);
LocalPlayer:GetAttributeChangedSignal("VampireFarmXP"):Connect(update);
LocalPlayer:GetAttributeChangedSignal("VampireFarmLastGain"):Connect(revealForGain);
LocalPlayer:GetAttributeChangedSignal("VampireFarmRequired"):Connect(update);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(update);
LocalPlayer.CharacterAdded:Connect(attach);

if LocalPlayer.Character then
    task.defer(attach, LocalPlayer.Character);
end;