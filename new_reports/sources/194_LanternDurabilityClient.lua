-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;

local function createDurabilityBar(p1) -- Line: 4
    -- upvalues: LocalPlayer (copy)
    local MainPart = p1:FindFirstChild("MainPart", true);

    if not (MainPart and MainPart:IsA("BasePart")) then
        return;
    end;

    local LanternDurabilityGui = MainPart:FindFirstChild("LanternDurabilityGui");

    if LanternDurabilityGui then
        LanternDurabilityGui:Destroy();
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "LanternDurabilityGui";
    BillboardGui.Adornee = MainPart;
    BillboardGui.Size = UDim2.fromOffset(34, 3);
    BillboardGui.StudsOffset = Vector3.new(0, 0.65, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.MaxDistance = 50;
    BillboardGui.ResetOnSpawn = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "Background";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
    Frame.BackgroundTransparency = 0.4;
    Frame.BorderSizePixel = 0;
    Frame.Parent = BillboardGui;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(0, 0, 0);
    UIStroke.Transparency = 0.35;
    UIStroke.Thickness = 1;
    UIStroke.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Fill";
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;
    BillboardGui.Parent = MainPart;

    local function updateBar() -- Line: 43
        -- upvalues: LocalPlayer (ref), Frame2 (copy), BillboardGui (copy)
        local v2 = tonumber(LocalPlayer:GetAttribute("LanternDurability")) or 100;
        local math_clamp_ret = math.clamp(v2 / 100, 0, 1);
        Frame2.Size = UDim2.fromScale(math_clamp_ret, 1);
        local v3;

        if v2 < 100 then
            v3 = v2 > 0;
        else
            v3 = false;
        end;

        BillboardGui.Enabled = v3;
    end;

    local v4 = tonumber(LocalPlayer:GetAttribute("LanternDurability")) or 100;
    local math_clamp_ret = math.clamp(v4 / 100, 0, 1);
    Frame2.Size = UDim2.fromScale(math_clamp_ret, 1);
    local v5;

    if v4 < 100 then
        v5 = v4 > 0;
    else
        v5 = false;
    end;

    BillboardGui.Enabled = v5;
    local u6 = LocalPlayer:GetAttributeChangedSignal("LanternDurability"):Connect(updateBar);
    BillboardGui.Destroying:Connect(function() -- Line: 52
        -- upvalues: u6 (copy)
        u6:Disconnect();
    end);
end;

local function hookCharacter(p7) -- Line: 57
    -- upvalues: createDurabilityBar (copy)
    p7.ChildAdded:Connect(function(p8) -- Line: 58
        -- upvalues: createDurabilityBar (ref)
        if p8.Name == "EquippedLantern" and p8:IsA("Model") then
            task.defer(createDurabilityBar, p8);
        end;
    end);
    local EquippedLantern = p7:FindFirstChild("EquippedLantern");

    if EquippedLantern and EquippedLantern:IsA("Model") then
        createDurabilityBar(EquippedLantern);
    end;
end;

LocalPlayer.CharacterAdded:Connect(hookCharacter);

if LocalPlayer.Character then
    hookCharacter(LocalPlayer.Character);
end;