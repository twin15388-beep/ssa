-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local MainFrame = script.Parent:WaitForChild("MainFrame");
local ScrollingFrame = MainFrame:WaitForChild("ScrollFrame"):WaitForChild("ScrollingFrame");
local CloseButton = MainFrame:WaitForChild("ShopLabel"):WaitForChild("CloseButton");
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local ShopRemote = Eventos:WaitForChild("ShopRemote");
local BroomRemote = Eventos:WaitForChild("BroomRemote");
local DarkHazardShopPreviews = ReplicatedStorage:WaitForChild("DarkHazardShopPreviews");
local CIDADE = workspace:WaitForChild("Mapa"):WaitForChild("CIDADE");
local v1 = {
    General = CIDADE:WaitForChild("ShopKeeper1"),
    Vampire = CIDADE:WaitForChild("ShopKeeper2"),
    Witch = CIDADE:WaitForChild("ShopKeeper3")
};
local v2 = {
    General = v1.General:WaitForChild("Head"):WaitForChild("ShopPrompt"),
    Vampire = v1.Vampire:WaitForChild("Head"):WaitForChild("ShopPrompt"),
    Witch = v1.Witch:WaitForChild("Head"):WaitForChild("ShopPrompt")
};
local u3 = {
    Humans = {
        Stake = 50,
        ["High Stake"] = 300,
        ["Human Potion"] = 50,
        ["Human Blood"] = 50
    }
};
local u4 = false;
local u5 = "General";
local u6 = {
    ["Vampire Blood"] = true,
    ["Vampire Hat"] = true,
    ["Vampire Cape"] = true
};
local u7 = {
    Broom = true
};

local function isVampireTeamName(p8) -- Line: 52
    return (p8 == "Vampires" or (p8 == "Cannibal Raised" or p8 == "Vampire Cannibal")) and true or p8 == "Original Vampire";
end;

local function belongsToCategory(p9, p10) -- Line: 59
    -- upvalues: u6 (copy), u7 (copy)
    if p10 == "Vampire" then
        return u6[p9] == true;
    end;

    if p10 == "Witch" then
        return u7[p9] == true;
    end;

    return not u6[p9] and not u7[p9];
end;

local function setupPreview(p11) -- Line: 68
    -- upvalues: DarkHazardShopPreviews (copy)
    local Attribute = p11:GetAttribute("ShopItemName");
    local ItemViewport = p11:FindFirstChild("ItemViewport");
    local v12;

    if typeof(Attribute) == "string" then
        v12 = DarkHazardShopPreviews:FindFirstChild(Attribute);
    else
        v12 = false;
    end;

    if not (ItemViewport and (ItemViewport:IsA("ViewportFrame") and v12)) then
        return;
    end;

    local World = ItemViewport:FindFirstChild("World");

    if not (World and World:IsA("WorldModel")) then
        return;
    end;

    local PreviewCamera = ItemViewport:FindFirstChild("PreviewCamera");

    if not PreviewCamera then
        PreviewCamera = Instance.new("Camera");
        PreviewCamera.Name = "PreviewCamera";
        PreviewCamera.FieldOfView = 28;
        PreviewCamera.Parent = ItemViewport;
    end;

    if not PreviewCamera:IsA("Camera") then
        return;
    end;

    ItemViewport.CurrentCamera = PreviewCamera;

    if World:FindFirstChild("PreviewObject") then
        return;
    end;

    local Model = Instance.new("Model");
    Model.Name = "PreviewObject";
    v12:Clone().Parent = Model;
    Model.Parent = World;

    for _, descendant in ipairs(Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
        elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
            descendant.Disabled = true;
        end;
    end;

    local BoundingBox, _ = Model:GetBoundingBox();

    for _, descendant in ipairs(Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CFrame = CFrame.new(-BoundingBox.Position) * descendant.CFrame;
        end;
    end;

    local _, v13 = Model:GetBoundingBox();
    local math_max_ret = math.max(v13.X, v13.Y);
    local math_max_ret2 = math.max(v13.Z, 0.1);
    local math_rad_ret = math.rad(PreviewCamera.FieldOfView);
    local v14 = math_max_ret * 0.5 / math.tan(math_rad_ret * 0.5) + math_max_ret2 * 0.55;
    local v15 = math.max(v14, 1.2) * 1.08;
    PreviewCamera.CFrame = CFrame.lookAt(Vector3.new(0.44649398, 0.309017, 0.83973306) * v15, Vector3.new(0, 0, 0));
    ItemViewport.CurrentCamera = PreviewCamera;
end;

local function getPrice(p16) -- Line: 126
    -- upvalues: LocalPlayer (copy), u3 (copy)
    local v17 = tonumber(p16:GetAttribute("BasePrice")) or 0;
    local v18 = LocalPlayer.Team and LocalPlayer.Team.Name;

    if v18 then
        v18 = u3[v18];
    end;

    local Attribute = p16:GetAttribute("ShopItemName");

    if v18 then
        v17 = v18[Attribute] or v17;
    end;

    return v17;
end;

local function refreshCard(p19) -- Line: 134
    -- upvalues: LocalPlayer (copy), u3 (copy)
    local Attribute = p19:GetAttribute("ShopItemName");
    p19:GetAttribute("ShopKind");

    if typeof(Attribute) ~= "string" then
        return;
    end;

    local BuyButton = p19:FindFirstChild("BuyButton");
    local v20;

    if BuyButton then
        v20 = BuyButton:FindFirstChild("BuyText");
    else
        v20 = BuyButton;
    end;

    if not (BuyButton and v20) then
        return;
    end;

    local v21 = true;
    local v22 = nil;
    local v23 = LocalPlayer.Team and LocalPlayer.Team.Name;
    local v24 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;

    if Attribute == "Broom" and v23 ~= "Witches" then
        v21 = false;
        v22 = "WITCHES ONLY";
    elseif Attribute == "Vampire Blood" and (v23 ~= "Vampires" and (v23 ~= "Cannibal Raised" and v23 ~= "Vampire Cannibal") and v23 ~= "Original Vampire") or (Attribute == "Vampire Hat" and (v23 ~= "Vampires" and (v23 ~= "Cannibal Raised" and v23 ~= "Vampire Cannibal") and v23 ~= "Original Vampire") or Attribute == "Vampire Cape" and (v23 ~= "Vampires" and (v23 ~= "Cannibal Raised" and v23 ~= "Vampire Cannibal") and v23 ~= "Original Vampire")) then
        v21 = false;
        v22 = "VAMPIRES ONLY";
    elseif Attribute == "High Stake" and v24 < 90 then
        v21 = false;
        v22 = "LEVEL 90";
    elseif Attribute == "Vampire Cape" and v24 < 100 then
        v21 = false;
        v22 = "LEVEL 100";
    elseif Attribute == "Night Vision" then
        if (v23 == "Vampires" or (v23 == "Cannibal Raised" or v23 == "Vampire Cannibal")) and true or v23 == "Original Vampire" then
            v21 = false;
            v22 = "UNAVAILABLE";
        end;
    end;

    BuyButton.Active = v21;
    BuyButton.AutoButtonColor = v21;
    BuyButton:SetAttribute("ShopAvailable", v21);

    if v21 then
        local v25 = tonumber(p19:GetAttribute("BasePrice")) or 0;
        local v26 = LocalPlayer.Team and LocalPlayer.Team.Name;

        if v26 then
            v26 = u3[v26];
        end;

        local Attribute2 = p19:GetAttribute("ShopItemName");

        if v26 then
            v25 = v26[Attribute2] or v25;
        end;

        v22 = "BUY  $" .. tostring(v25) or v22;
    end;

    v20.Text = v22;
end;

local function refreshAll() -- Line: 170
    -- upvalues: ScrollingFrame (copy), u5 (ref), u6 (copy), u7 (copy), setupPreview (copy), refreshCard (copy)
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        local Attribute = child:GetAttribute("ShopItemName");

        if Attribute then
            local v27 = u5;
            local v28;

            if v27 == "Vampire" then
                v28 = u6[Attribute] == true;
            elseif v27 == "Witch" then
                v28 = u7[Attribute] == true;
            else
                v28 = not u6[Attribute] and not u7[Attribute];
            end;

            child.Visible = v28;

            if v28 then
                setupPreview(child);
                refreshCard(child);
            end;
        end;
    end;
end;

local function setOpen(p29) -- Line: 184
    -- upvalues: u4 (ref), refreshAll (copy), MainFrame (copy), TweenService (copy), ScrollingFrame (copy), CloseButton (copy), UserInputService (copy), GuiService (copy)
    u4 = p29;

    if p29 then
        refreshAll();
        MainFrame.GroupTransparency = 1;
        MainFrame.Visible = true;
        TweenService:Create(MainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            GroupTransparency = 0
        }):Play();
        local v30 = nil;

        for _, child in ipairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and (child.Visible and child:GetAttribute("ShopItemName")) then
                local BuyButton = child:FindFirstChild("BuyButton");

                if BuyButton and BuyButton:IsA("GuiButton") then
                    BuyButton.Selectable = true;
                    v30 = v30 or BuyButton;
                end;
            end;
        end;

        CloseButton.Selectable = true;

        if UserInputService.GamepadEnabled and v30 then
            GuiService.SelectedObject = v30;
        end;
    else
        local v31 = TweenService:Create(MainFrame, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            GroupTransparency = 1
        });
        v31:Play();
        GuiService.SelectedObject = nil;
        v31.Completed:Once(function() -- Line: 210
            -- upvalues: u4 (ref), MainFrame (ref)
            if not u4 then
                MainFrame.Visible = false;
            end;
        end);
    end;
end;

for i, v in pairs(v2) do
    v.Triggered:Connect(function() -- Line: 217
        -- upvalues: u5 (ref), i (copy), setOpen (copy)
        u5 = i;
        setOpen(true);
    end);
end;

CloseButton.Activated:Connect(function() -- Line: 223
    -- upvalues: u4 (ref), TweenService (copy), MainFrame (copy), GuiService (copy)
    u4 = false;
    local v32 = TweenService:Create(MainFrame, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        GroupTransparency = 1
    });
    v32:Play();
    GuiService.SelectedObject = nil;
    v32.Completed:Once(function() -- Line: 210
        -- upvalues: u4 (ref), MainFrame (ref)
        if not u4 then
            MainFrame.Visible = false;
        end;
    end);
end);
UserInputService.InputBegan:Connect(function(p33, p34) -- Line: 227
    -- upvalues: u4 (ref), TweenService (copy), MainFrame (copy), GuiService (copy)
    if p34 or not u4 then
        return;
    end;

    if p33.KeyCode == Enum.KeyCode.ButtonB or p33.KeyCode == Enum.KeyCode.Escape then
        u4 = false;
        local v35 = TweenService:Create(MainFrame, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            GroupTransparency = 1
        });
        v35:Play();
        GuiService.SelectedObject = nil;
        v35.Completed:Once(function() -- Line: 210
            -- upvalues: u4 (ref), MainFrame (ref)
            if not u4 then
                MainFrame.Visible = false;
            end;
        end);
    end;
end);

for _, child in ipairs(ScrollingFrame:GetChildren()) do
    local Attribute = child:GetAttribute("ShopItemName");

    if Attribute then
        local BuyButton = child:FindFirstChild("BuyButton");

        if BuyButton and BuyButton:IsA("TextButton") then
            BuyButton.Activated:Connect(function() -- Line: 239
                -- upvalues: BuyButton (copy), child (copy), BroomRemote (copy), ShopRemote (copy), Attribute (copy)
                if BuyButton:GetAttribute("ShopAvailable") ~= true then
                    return;
                end;

                local Attribute2 = child:GetAttribute("ShopKind");

                if Attribute2 == "Broom" then
                    BroomRemote:FireServer("Purchase");

                    return;
                end;

                if Attribute2 == "Hat" then
                    ShopRemote:FireServer("PurchaseHat");

                    return;
                end;

                if Attribute2 == "Cape" then
                    ShopRemote:FireServer("PurchaseCape");

                    return;
                end;

                ShopRemote:FireServer("Purchase", Attribute);
            end);
        end;
    end;
end;

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshAll);
LocalPlayer:GetAttributeChangedSignal("Years"):Connect(refreshAll);
MainFrame.Visible = false;
MainFrame.GroupTransparency = 0;
refreshAll();