-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;

local function createDurabilityBar(p1, u2) -- Line: 4
    local Handle = p1:WaitForChild("Handle", 5);

    if not Handle then
        return;
    end;

    local CapeDurabilityGui = Handle:FindFirstChild("CapeDurabilityGui");

    if CapeDurabilityGui then
        CapeDurabilityGui:Destroy();
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "CapeDurabilityGui";
    BillboardGui.Adornee = Handle;
    BillboardGui.Size = UDim2.fromOffset(40, 4);
    BillboardGui.StudsOffset = Vector3.new(0, 1.15, 0);
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
    BillboardGui.Parent = Handle;

    local function updateBar() -- Line: 43
        -- upvalues: u2 (copy), Frame2 (copy), BillboardGui (copy)
        local v3 = tonumber(u2:GetAttribute("CapeDurability")) or 100;
        local math_clamp_ret = math.clamp(v3 / 100, 0, 1);
        Frame2.Size = UDim2.fromScale(math_clamp_ret, 1);
        local v4;

        if v3 < 100 then
            v4 = v3 > 0;
        else
            v4 = false;
        end;

        BillboardGui.Enabled = v4;
    end;

    local v5 = tonumber(u2:GetAttribute("CapeDurability")) or 100;
    local math_clamp_ret = math.clamp(v5 / 100, 0, 1);
    Frame2.Size = UDim2.fromScale(math_clamp_ret, 1);
    local v6;

    if v5 < 100 then
        v6 = v5 > 0;
    else
        v6 = false;
    end;

    BillboardGui.Enabled = v6;
    local u7 = u2:GetAttributeChangedSignal("CapeDurability"):Connect(updateBar);
    BillboardGui.Destroying:Connect(function() -- Line: 52
        -- upvalues: u7 (copy)
        u7:Disconnect();
    end);
end;

local function hookCharacter(u8, p9) -- Line: 57
    -- upvalues: createDurabilityBar (copy)
    p9.ChildAdded:Connect(function(p10) -- Line: 58
        -- upvalues: createDurabilityBar (ref), u8 (copy)
        if p10.Name == "VampireCape" and p10:IsA("Accessory") then
            createDurabilityBar(p10, u8);
        end;
    end);
    local VampireCape = p9:FindFirstChild("VampireCape");

    if VampireCape and VampireCape:IsA("Accessory") then
        createDurabilityBar(VampireCape, u8);
    end;
end;

LocalPlayer.CharacterAdded:Connect(function(p11) -- Line: 70
    -- upvalues: hookCharacter (copy), LocalPlayer (copy)
    hookCharacter(LocalPlayer, p11);
end);

if LocalPlayer.Character then
    hookCharacter(LocalPlayer, LocalPlayer.Character);
end;