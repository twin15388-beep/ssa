-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local HttpService = game:GetService("HttpService");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local script_Parent = script.Parent;
local u1 = HttpService:GenerateGUID(false);
PlayerGui:SetAttribute("BoosterTopbarControllerToken", u1);
local TextLabel = script_Parent:WaitForChild("BASE"):WaitForChild("TextLabel");
script_Parent.ResetOnSpawn = false;
script_Parent.IgnoreGuiInset = false;
script_Parent.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets;
TextLabel.AnchorPoint = Vector2.new(0.5, 0);
TextLabel.Position = UDim2.new(0.5, 0, 0, 4);
TextLabel.Size = UDim2.fromOffset(190, 42);
task.wait(1);

if PlayerGui:GetAttribute("BoosterTopbarControllerToken") ~= u1 then
    PlayerGui:SetAttribute("BoosterTopbarControllerToken", u1);
end;

local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local RingGiftRemote = Eventos:WaitForChild("RingGiftRemote");
local BoosterGiftRemote = Eventos:WaitForChild("BoosterGiftRemote");
local OriginalRingPurchaseGui = PlayerGui:FindFirstChild("OriginalRingPurchaseGui");

if OriginalRingPurchaseGui then
    OriginalRingPurchaseGui:Destroy();
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "OriginalRingPurchaseGui";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = false;
ScreenGui.ScreenInsets = Enum.ScreenInsets.None;
ScreenGui.DisplayOrder = 40;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.Enabled = true;
ScreenGui.Parent = PlayerGui;
local Frame = Instance.new("Frame");
Frame.Name = "OriginalRingPurchasePanel";
Frame.AnchorPoint = Vector2.new(0.5, 0.5);
Frame.Position = UDim2.fromScale(0.5, 0.5);
Frame.Size = UDim2.new(0.86, 0, 0, 232);
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18);
Frame.BackgroundTransparency = 0.08;
Frame.BorderSizePixel = 0;
Frame.Visible = false;
Frame.ZIndex = 50;
Frame.Parent = ScreenGui;

local function updateRingPanelCenter() -- Line: 75
    -- upvalues: GuiService (copy), Frame (copy)
    local GuiInset = GuiService:GetGuiInset();
    Frame.Position = UDim2.new(0.5, 0, 0.5, GuiInset.Y);
end;

local GuiInset = GuiService:GetGuiInset();
Frame.Position = UDim2.new(0.5, 0, 0.5, GuiInset.Y);
GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(updateRingPanelCenter);
task.delay(1, updateRingPanelCenter);
local UISizeConstraint = Instance.new("UISizeConstraint");
UISizeConstraint.MinSize = Vector2.new(260, 220);
UISizeConstraint.MaxSize = Vector2.new(340, 232);
UISizeConstraint.Parent = Frame;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 10);
UICorner.Parent = Frame;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3.fromRGB(150, 35, 35);
UIStroke.Transparency = 0.2;
UIStroke.Thickness = 1;
UIStroke.Parent = Frame;

local function makeText(p2, p3, p4, p5, p6) -- Line: 98
    -- upvalues: Frame (copy)
    local Instance_new_ret = Instance.new(p2);
    Instance_new_ret.Name = p3;
    Instance_new_ret.Text = p4;
    Instance_new_ret.Font = Enum.Font.JosefinSans;
    Instance_new_ret.TextColor3 = Color3.new(1, 1, 1);
    Instance_new_ret.TextScaled = true;
    Instance_new_ret.BackgroundTransparency = 1;
    Instance_new_ret.BorderSizePixel = 0;
    Instance_new_ret.Position = p5;
    Instance_new_ret.Size = p6;
    Instance_new_ret.ZIndex = 51;
    Instance_new_ret.Parent = Frame;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MinTextSize = 10;
    UITextSizeConstraint.MaxTextSize = 18;
    UITextSizeConstraint.Parent = Instance_new_ret;

    return Instance_new_ret;
end;

local u7 = makeText("TextLabel", "Title", "ORIGINAL RING", UDim2.fromOffset(18, 12), UDim2.new(1, -62, 0, 27));
u7.TextXAlignment = Enum.TextXAlignment.Left;
local v8 = makeText("TextButton", "Close", "×", UDim2.new(1, -42, 0, 8), UDim2.fromOffset(34, 34));
v8.BackgroundColor3 = Color3.fromRGB(42, 42, 48);
v8.BackgroundTransparency = 0.15;
Instance.new("UICorner", v8).CornerRadius = UDim.new(0, 8);
local u9 = makeText("TextButton", "BuyForMyself", "BUY FOR MYSELF", UDim2.fromOffset(18, 48), UDim2.new(1, -36, 0, 38));
u9.BackgroundColor3 = Color3.fromRGB(115, 23, 23);
u9.BackgroundTransparency = 0;
Instance.new("UICorner", u9).CornerRadius = UDim.new(0, 7);
local v10 = makeText("TextLabel", "GiftHeader", "GIFT TO A FRIEND", UDim2.fromOffset(18, 91), UDim2.new(1, -36, 0, 20));
v10.TextColor3 = Color3.fromRGB(210, 210, 215);
v10.TextXAlignment = Enum.TextXAlignment.Left;
local u11 = makeText("TextBox", "Username", "", UDim2.fromOffset(18, 116), UDim2.new(1, -36, 0, 36));
u11.PlaceholderText = "Exact Roblox username";
u11.PlaceholderColor3 = Color3.fromRGB(145, 145, 152);
u11.BackgroundColor3 = Color3.fromRGB(31, 31, 36);
u11.BackgroundTransparency = 0;
u11.ClearTextOnFocus = false;
u11.TextXAlignment = Enum.TextXAlignment.Left;
local UIPadding = Instance.new("UIPadding");
UIPadding.PaddingLeft = UDim.new(0, 10);
UIPadding.PaddingRight = UDim.new(0, 10);
UIPadding.Parent = u11;
Instance.new("UICorner", u11).CornerRadius = UDim.new(0, 7);
local u12 = makeText("TextButton", "GiftButton", "CHECK FRIEND", UDim2.fromOffset(18, 158), UDim2.new(1, -36, 0, 36));
u12.BackgroundColor3 = Color3.fromRGB(115, 23, 23);
u12.BackgroundTransparency = 0;
Instance.new("UICorner", u12).CornerRadius = UDim.new(0, 7);
local u13 = makeText("TextLabel", "Status", "", UDim2.fromOffset(18, 198), UDim2.new(1, -36, 0, 25));
u13.TextColor3 = Color3.fromRGB(225, 190, 190);
u13.TextWrapped = true;
u13.TextXAlignment = Enum.TextXAlignment.Left;
local u14 = nil;
local u15 = false;
local u16 = nil;

local function setStatus(p17, p18) -- Line: 162
    -- upvalues: u13 (copy)
    u13.Text = tostring(p17 or "");
    u13.TextColor3 = p18 and Color3.fromRGB(255, 125, 125) or Color3.fromRGB(210, 225, 210);
end;

local function cancelDraft() -- Line: 168
    -- upvalues: u14 (ref), u12 (copy), u16 (ref), RingGiftRemote (copy), BoosterGiftRemote (copy)
    local u19 = u14;
    u14 = nil;
    u12.Text = "CHECK FRIEND";

    if u19 and u16 then
        pcall(function() -- Line: 173
            -- upvalues: u16 (ref), RingGiftRemote (ref), u19 (copy), BoosterGiftRemote (ref)
            if u16.kind == "GamePass" then
                RingGiftRemote:InvokeServer("Cancel", u19.targetUserId);

                return;
            end;

            BoosterGiftRemote:InvokeServer("Cancel", {
                productId = u16.productId,
                targetUserId = u19.targetUserId
            });
        end);
    end;
end;

local u20 = {
    [3714181173] = { "DoubleXPExpiresAt", "DoubleXPPurchases" },
    [3714180671] = { "TripleXPExpiresAt", "TripleXPPurchases" },
    [3714180933] = { "QuadXPExpiresAt", "QuadXPPurchases" }
};

local function getBoosterPurchaseCount(p21) -- Line: 193
    -- upvalues: LocalPlayer (copy), u20 (copy)
    if p21 == 3711619873 then
        local v22 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterPurchases")) or 0;

        return math.floor(v22);
    end;

    if not u20[p21] then
        return 0;
    end;

    local v23 = tonumber(LocalPlayer:GetAttribute(u20[p21][2])) or 0;

    return math.floor(v23);
end;

local function isBoosterAtLimit(p24) -- Line: 202
    -- upvalues: LocalPlayer (copy), Workspace (copy), u20 (copy)
    if p24 == 3711619873 then
        local v25;

        if (tonumber(LocalPlayer:GetAttribute("MoneyBoosterExpiresAt")) or 0) > Workspace:GetServerTimeNow() then
            local v26;

            if p24 == 3711619873 then
                local v27 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterPurchases")) or 0;
                v26 = math.floor(v27);
            elseif u20[p24] then
                local v28 = tonumber(LocalPlayer:GetAttribute(u20[p24][2])) or 0;
                v26 = math.floor(v28);
            else
                v26 = 0;
            end;

            v25 = v26 >= 3;
        else
            v25 = false;
        end;

        return v25;
    end;

    if not u20[p24] then
        return false;
    end;

    local v29;

    if (tonumber(LocalPlayer:GetAttribute(u20[p24][1])) or 0) > Workspace:GetServerTimeNow() then
        local v30;

        if p24 == 3711619873 then
            local v31 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterPurchases")) or 0;
            v30 = math.floor(v31);
        elseif u20[p24] then
            local v32 = tonumber(LocalPlayer:GetAttribute(u20[p24][2])) or 0;
            v30 = math.floor(v32);
        else
            v30 = 0;
        end;

        v29 = v30 >= 3;
    else
        v29 = false;
    end;

    return v29;
end;

local function setRingPanelVisible(p33, p34, p35) -- Line: 215
    -- upvalues: u16 (ref), u14 (ref), u12 (copy), RingGiftRemote (copy), BoosterGiftRemote (copy), Frame (copy), u7 (copy), LocalPlayer (copy), u20 (copy), u9 (copy), u13 (copy), isBoosterAtLimit (copy)
    if p35 and u16 ~= p35 then
        local u36 = u14;
        u14 = nil;
        u12.Text = "CHECK FRIEND";

        if u36 and u16 then
            pcall(function() -- Line: 173
                -- upvalues: u16 (ref), RingGiftRemote (ref), u36 (copy), BoosterGiftRemote (ref)
                if u16.kind == "GamePass" then
                    RingGiftRemote:InvokeServer("Cancel", u36.targetUserId);

                    return;
                end;

                BoosterGiftRemote:InvokeServer("Cancel", {
                    productId = u16.productId,
                    targetUserId = u36.targetUserId
                });
            end);
        end;

        u16 = p35;
    end;

    if not (p33 or p34) then
        local u37 = u14;
        u14 = nil;
        u12.Text = "CHECK FRIEND";

        if u37 and u16 then
            pcall(function() -- Line: 173
                -- upvalues: u16 (ref), RingGiftRemote (ref), u37 (copy), BoosterGiftRemote (ref)
                if u16.kind == "GamePass" then
                    RingGiftRemote:InvokeServer("Cancel", u37.targetUserId);

                    return;
                end;

                BoosterGiftRemote:InvokeServer("Cancel", {
                    productId = u16.productId,
                    targetUserId = u37.targetUserId
                });
            end);
        end;
    end;

    Frame.Visible = p33;

    if p33 and u16 then
        u7.Text = string.upper(u16.caption);
        local productId = u16.productId;
        local v38;

        if productId == 3711619873 then
            local v39 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterPurchases")) or 0;
            v38 = math.floor(v39);
        elseif u20[productId] then
            local v40 = tonumber(LocalPlayer:GetAttribute(u20[productId][2])) or 0;
            v38 = math.floor(v40);
        else
            v38 = 0;
        end;

        if u16.productId == 3714005256 and LocalPlayer:GetAttribute("OwnsHideIdentity") == true then
            u9.Text = "OWNED";
            u9.BackgroundColor3 = Color3.fromRGB(60, 60, 66);
            u13.Text = tostring("This permanent benefit is already owned. You can still gift it to a friend.");
            u13.TextColor3 = Color3.fromRGB(210, 225, 210);

            return;
        end;

        if u16.productId == 3711619873 or u20[u16.productId] then
            if isBoosterAtLimit(u16.productId) then
                u9.Text = "LIMIT REACHED (3/3)";
                u9.BackgroundColor3 = Color3.fromRGB(60, 60, 66);
                u13.Text = tostring("You already bought this booster 3 times during the current active period.");
                u13.TextColor3 = Color3.fromRGB(255, 125, 125) or Color3.fromRGB(210, 225, 210);

                return;
            end;

            u9.Text = string.format("BUY FOR MYSELF (%d/3)", v38);
            u9.BackgroundColor3 = Color3.fromRGB(115, 23, 23);
            u13.Text = tostring("");
            u13.TextColor3 = Color3.fromRGB(210, 225, 210);

            return;
        end;

        u9.Text = "BUY FOR MYSELF";
        u9.BackgroundColor3 = Color3.fromRGB(115, 23, 23);
        u13.Text = tostring("");
        u13.TextColor3 = Color3.fromRGB(210, 225, 210);
    end;
end;

u11:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 253
    -- upvalues: u14 (ref), u15 (ref), u12 (copy), u16 (ref), RingGiftRemote (copy), BoosterGiftRemote (copy), u13 (copy)
    if u14 and not u15 then
        local u41 = u14;
        u14 = nil;
        u12.Text = "CHECK FRIEND";

        if u41 and u16 then
            pcall(function() -- Line: 173
                -- upvalues: u16 (ref), RingGiftRemote (ref), u41 (copy), BoosterGiftRemote (ref)
                if u16.kind == "GamePass" then
                    RingGiftRemote:InvokeServer("Cancel", u41.targetUserId);

                    return;
                end;

                BoosterGiftRemote:InvokeServer("Cancel", {
                    productId = u16.productId,
                    targetUserId = u41.targetUserId
                });
            end);
        end;

        u13.Text = tostring("Username changed. Check the friend again.");
        u13.TextColor3 = Color3.fromRGB(210, 225, 210);
    end;
end);
v8.Activated:Connect(function() -- Line: 260
    -- upvalues: u14 (ref), u12 (copy), u16 (ref), RingGiftRemote (copy), BoosterGiftRemote (copy), Frame (copy)
    local u42 = u14;
    u14 = nil;
    u12.Text = "CHECK FRIEND";

    if u42 and u16 then
        pcall(function() -- Line: 173
            -- upvalues: u16 (ref), RingGiftRemote (ref), u42 (copy), BoosterGiftRemote (ref)
            if u16.kind == "GamePass" then
                RingGiftRemote:InvokeServer("Cancel", u42.targetUserId);

                return;
            end;

            BoosterGiftRemote:InvokeServer("Cancel", {
                productId = u16.productId,
                targetUserId = u42.targetUserId
            });
        end);
    end;

    Frame.Visible = false;
end);
u9.Activated:Connect(function() -- Line: 264
    -- upvalues: u16 (ref), u14 (ref), u12 (copy), RingGiftRemote (copy), BoosterGiftRemote (copy), Frame (copy), LocalPlayer (copy), u13 (copy), isBoosterAtLimit (copy), MarketplaceService (copy)
    local u43 = u16;

    if not u43 then
        local u44 = u14;
        u14 = nil;
        u12.Text = "CHECK FRIEND";

        if u44 and u16 then
            pcall(function() -- Line: 173
                -- upvalues: u16 (ref), RingGiftRemote (ref), u44 (copy), BoosterGiftRemote (ref)
                if u16.kind == "GamePass" then
                    RingGiftRemote:InvokeServer("Cancel", u44.targetUserId);

                    return;
                end;

                BoosterGiftRemote:InvokeServer("Cancel", {
                    productId = u16.productId,
                    targetUserId = u44.targetUserId
                });
            end);
        end;

        Frame.Visible = false;

        return;
    end;

    if u43.productId == 3714005256 and LocalPlayer:GetAttribute("OwnsHideIdentity") == true then
        u13.Text = tostring("This permanent benefit is already owned.");
        u13.TextColor3 = Color3.fromRGB(255, 125, 125) or Color3.fromRGB(210, 225, 210);

        return;
    end;

    if isBoosterAtLimit(u43.productId) then
        u13.Text = tostring("Purchase limit reached (3/3).");
        u13.TextColor3 = Color3.fromRGB(255, 125, 125) or Color3.fromRGB(210, 225, 210);

        return;
    end;

    if u43.kind ~= "GamePass" and u43.productId ~= 3714005256 then
        local success, result = pcall(function() -- Line: 281
            -- upvalues: BoosterGiftRemote (ref), u43 (copy)
            return BoosterGiftRemote:InvokeServer("Self", {
                productId = u43.productId
            });
        end);

        if not (success and (typeof(result) == "table" and result.ok == true)) then
            u13.Text = tostring(success and (result and result.message) or "Could not prepare the purchase." or "");
            u13.TextColor3 = Color3.fromRGB(255, 125, 125) or Color3.fromRGB(210, 225, 210);

            return;
        end;
    end;

    local u45 = u14;
    u14 = nil;
    u12.Text = "CHECK FRIEND";

    if u45 and u16 then
        pcall(function() -- Line: 173
            -- upvalues: u16 (ref), RingGiftRemote (ref), u45 (copy), BoosterGiftRemote (ref)
            if u16.kind == "GamePass" then
                RingGiftRemote:InvokeServer("Cancel", u45.targetUserId);

                return;
            end;

            BoosterGiftRemote:InvokeServer("Cancel", {
                productId = u16.productId,
                targetUserId = u45.targetUserId
            });
        end);
    end;

    Frame.Visible = false;
    local success, result = pcall(function() -- Line: 290
        -- upvalues: u43 (copy), MarketplaceService (ref), LocalPlayer (ref)
        if u43.productId == 3714005256 then
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, 1986249572);

            return;
        end;

        if u43.kind == "GamePass" then
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, u43.productId);

            return;
        end;

        MarketplaceService:PromptProductPurchase(LocalPlayer, u43.productId);
    end);

    if not success then
        warn("[BoosterTopbar] Could not open purchase prompt: " .. tostring(result));
    end;
end);
u12.Activated:Connect(function() -- Line: 304
    -- upvalues: u15 (ref), u12 (copy), u14 (ref), u13 (copy), u16 (ref), RingGiftRemote (copy), u11 (copy), BoosterGiftRemote (copy), Frame (copy)
    if u15 then
        return;
    end;

    u15 = true;
    u12.Interactable = false;

    if u14 then
        u13.Text = tostring("Opening secure purchase...");
        u13.TextColor3 = Color3.fromRGB(210, 225, 210);
        local success, result = pcall(function() -- Line: 333
            -- upvalues: u16 (ref), RingGiftRemote (ref), u14 (ref), BoosterGiftRemote (ref)
            if not u16 then
                return {
                    ok = false,
                    message = "Select an item first."
                };
            end;

            if u16.kind == "GamePass" then
                return RingGiftRemote:InvokeServer("Confirm", u14.targetUserId);
            end;

            return BoosterGiftRemote:InvokeServer("Confirm", {
                productId = u16.productId,
                targetUserId = u14.targetUserId
            });
        end);

        if success and (typeof(result) == "table" and result.ok == true) then
            u14 = nil;
            u12.Text = "CHECK FRIEND";
            Frame.Visible = false;
        else
            u13.Text = tostring(success and (result and result.message) or "Could not open the purchase." or "");
            u13.TextColor3 = Color3.fromRGB(255, 125, 125) or Color3.fromRGB(210, 225, 210);
        end;
    else
        u13.Text = tostring("Checking account...");
        u13.TextColor3 = Color3.fromRGB(210, 225, 210);
        local success, result = pcall(function() -- Line: 313
            -- upvalues: u16 (ref), RingGiftRemote (ref), u11 (ref), BoosterGiftRemote (ref)
            if not u16 then
                return {
                    ok = false,
                    message = "Select an item first."
                };
            end;

            if u16.kind == "GamePass" then
                return RingGiftRemote:InvokeServer("Prepare", u11.Text);
            end;

            return BoosterGiftRemote:InvokeServer("Prepare", {
                productId = u16.productId,
                username = u11.Text
            });
        end);

        if success and (typeof(result) == "table" and result.ok == true) then
            u14 = result;
            u12.Text = "CONFIRM GIFT TO @" .. tostring(result.targetName);
            u13.Text = tostring("Confirm the username before opening the Robux purchase.");
            u13.TextColor3 = Color3.fromRGB(210, 225, 210);
        else
            u13.Text = tostring(success and (result and result.message) or "Could not verify the account." or "");
            u13.TextColor3 = Color3.fromRGB(255, 125, 125) or Color3.fromRGB(210, 225, 210);
        end;
    end;

    u15 = false;
    u12.Interactable = true;
end);

for _, v in ipairs({ "DoubleMoneyProduct", "DoubleXPProduct", "TripleXPProduct", "QuadXPProduct", "Money100KProduct", "Money50KProduct", "Money10KProduct", "OriginalRingGamePass", "CustomGamePass1", "HideIdentityProduct", "CustomTagGamePass" }) do
    local v46 = v;

    while true do
        local Icon2 = Icon.getIcon(v46);

        if not Icon2 then
            break;
        end;

        Icon2:destroy();
    end;
end;

local function createProductIcon(p47, p48, p49, p50, p51) -- Line: 380
    -- upvalues: Icon (copy), PlayerGui (copy), u1 (copy), setRingPanelVisible (copy), Frame (copy)
    local u52 = {
        kind = "Product",
        productId = p51,
        caption = p49
    };
    local u53 = false;
    local v54 = Icon.new():setName(p47):setImage(p48):setImageScale(0.58):setLabel(p49):setOrder(p50):align("Left"):oneClick();

    local function openPurchasePanel() -- Line: 392
        -- upvalues: u53 (ref), PlayerGui (ref), u1 (ref), setRingPanelVisible (ref), u52 (copy)
        if u53 and PlayerGui:GetAttribute("BoosterTopbarControllerToken") == u1 then
            setRingPanelVisible(true, false, u52);
        end;
    end;

    v54.selected:Connect(openPurchasePanel);
    local Instance2 = v54:getInstance("ClickRegion");

    if Instance2 and Instance2:IsA("GuiButton") then
        Instance2.Activated:Connect(openPurchasePanel);
    end;

    task.delay(0.35, function() -- Line: 402
        -- upvalues: PlayerGui (ref), u1 (ref), Frame (ref), u53 (ref)
        if PlayerGui:GetAttribute("BoosterTopbarControllerToken") == u1 then
            Frame.Visible = false;
            u53 = true;
        end;
    end);

    return v54;
end;

local u55 = createProductIcon("DoubleMoneyProduct", 74246831175275, "Double Money", 20, 3711619873);
local u56 = createProductIcon("DoubleXPProduct", 90694059911139, "2x XP (30 min)", 21, 3714181173);
local u57 = createProductIcon("TripleXPProduct", 90694059911139, "3x XP (30 min)", 22, 3714180671);
local u58 = createProductIcon("QuadXPProduct", 90694059911139, "4x XP (30 min)", 23, 3714180933);
local u59 = createProductIcon("Money100KProduct", 74246831175275, "100K Money", 22, 3713033659);
local u60 = createProductIcon("Money50KProduct", 74246831175275, "50K Money", 23, 3713033614);
local u61 = createProductIcon("Money10KProduct", 74246831175275, "10K Money", 24, 3713033454);
local u71 = (function(p62, p63, p64, p65, p66) -- Line: 411, Name: createGamePassIcon
    -- upvalues: Icon (copy), PlayerGui (copy), u1 (copy), setRingPanelVisible (copy), Frame (copy)
    local u67 = {
        kind = "GamePass",
        productId = p66,
        caption = p64
    };
    local u68 = false;
    local v69 = Icon.new():setName(p62):setImage(p63):setImageScale(0.58):setLabel(p64):setOrder(p65):align("Left"):oneClick();

    local function v70() -- Line: 423
        -- upvalues: u68 (ref), PlayerGui (ref), u1 (ref), setRingPanelVisible (ref), u67 (copy)
        if u68 and PlayerGui:GetAttribute("BoosterTopbarControllerToken") == u1 then
            setRingPanelVisible(true, false, u67);
        end;
    end;

    v69.selected:Connect(v70);
    local Instance2 = v69:getInstance("ClickRegion");

    if Instance2 and Instance2:IsA("GuiButton") then
        Instance2.Activated:Connect(v70);
    end;

    task.delay(0.35, function() -- Line: 433
        -- upvalues: PlayerGui (ref), u1 (ref), Frame (ref), u68 (ref)
        if PlayerGui:GetAttribute("BoosterTopbarControllerToken") == u1 then
            Frame.Visible = false;
            u68 = true;
        end;
    end);

    return v69;
end)("OriginalRingGamePass", 102828425199513, "Sun Ring", 25, 1970284947);

local function createSimpleGamePassIcon(p72, p73, p74, p75, u76) -- Line: 498
    -- upvalues: Icon (copy), PlayerGui (copy), u1 (copy), MarketplaceService (copy), LocalPlayer (copy)
    local u77 = false;
    local v78 = Icon.new():setName(p72):setImage(p73):setImageScale(0.58):setLabel(p74):setOrder(p75):align("Left"):oneClick();

    local function openPurchasePrompt() -- Line: 509
        -- upvalues: u77 (ref), PlayerGui (ref), u1 (ref), MarketplaceService (ref), LocalPlayer (ref), u76 (copy)
        if u77 and PlayerGui:GetAttribute("BoosterTopbarControllerToken") == u1 then
            pcall(function() -- Line: 511
                -- upvalues: MarketplaceService (ref), LocalPlayer (ref), u76 (ref)
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, u76);
            end);
        end;
    end;

    v78.selected:Connect(openPurchasePrompt);
    local Instance2 = v78:getInstance("ClickRegion");

    if Instance2 and Instance2:IsA("GuiButton") then
        Instance2.Activated:Connect(openPurchasePrompt);
    end;

    task.delay(0.35, function() -- Line: 522
        -- upvalues: PlayerGui (ref), u1 (ref), u77 (ref)
        if PlayerGui:GetAttribute("BoosterTopbarControllerToken") == u1 then
            u77 = true;
        end;
    end);

    return v78;
end;

local u79 = createSimpleGamePassIcon("CustomGamePass1", 99196505830154, "Save Slot", 26, 1966203510);
local u80 = createProductIcon("HideIdentityProduct", 99196505830154, "Hide Identity", 27, 3714005256);
local u81 = createSimpleGamePassIcon("CustomTagGamePass", 99196505830154, "Custom Tag", 28, 1988012540);
local u82 = Icon.new():setName("MoneyMenu"):setLabel("Money"):setOrder(19):align("Left"):setDropdown({
    u55,
    u56,
    u57,
    u58,
    u59,
    u60,
    u61
});
local u83 = Icon.new():setName("GamepassMenu"):setLabel("Gamepass"):setOrder(20):align("Left"):setDropdown({
    u71,
    u79,
    u80,
    u81
});

local function getRemainingSeconds(p84) -- Line: 580
    -- upvalues: LocalPlayer (copy), Workspace (copy)
    local v85 = tonumber(LocalPlayer:GetAttribute(p84)) or 0;
    local math_floor_ret = math.floor(v85);
    local ServerTimeNow = Workspace:GetServerTimeNow();
    local v86 = math_floor_ret - math.floor(ServerTimeNow);

    return math.max(0, v86);
end;

local function formatTime(p87) -- Line: 585
    local math_floor_ret = math.floor(p87);
    local math_max_ret = math.max(0, math_floor_ret);
    local math_floor_ret2 = math.floor(math_max_ret / 3600);
    local math_floor_ret3 = math.floor(math_max_ret % 3600 / 60);

    return string.format("%02d:%02d:%02d", math_floor_ret2, math_floor_ret3, math_max_ret % 60);
end;

local function updateTimers() -- Line: 593
    -- upvalues: LocalPlayer (copy), Workspace (copy), u20 (copy), TextLabel (copy)
    local v88 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterExpiresAt")) or 0;
    local math_floor_ret = math.floor(v88);
    local v89 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterExpiresAt")) or 0;
    local math_floor_ret2 = math.floor(v89);
    local ServerTimeNow = Workspace:GetServerTimeNow();
    local v90 = math_floor_ret2 - math.floor(ServerTimeNow);
    local math_max_ret = math.max(0, v90);
    local v91 = math_max_ret > 0;
    local v92 = 1;
    local v93 = nil;
    local v94 = 0;

    for _, v in ipairs({ { 4, "QuadXPExpiresAt", 3714180933 }, { 3, "TripleXPExpiresAt", 3714180671 }, { 2, "DoubleXPExpiresAt", 3714181173 } }) do
        local v95 = tonumber(LocalPlayer:GetAttribute(v[2])) or 0;
        local math_floor_ret3 = math.floor(v95);
        local ServerTimeNow2 = Workspace:GetServerTimeNow();
        local v96 = math_floor_ret3 - math.floor(ServerTimeNow2);
        local math_max_ret2 = math.max(0, v96);

        if math_max_ret2 > 0 then
            v92 = v[1];
            v93 = v[3];
            v94 = math_max_ret2;
            break;
        end;
    end;

    local v97 = v92 > 1;
    local v98;

    if v91 then
        local v99 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterPurchases")) or 0;
        v98 = math.floor(v99) >= 3;
    else
        v98 = v91;
    end;

    local v100;

    if v97 then
        local v101;

        if v93 == 3711619873 then
            local v102 = tonumber(LocalPlayer:GetAttribute("MoneyBoosterPurchases")) or 0;
            v101 = math.floor(v102);
        elseif u20[v93] then
            local v103 = tonumber(LocalPlayer:GetAttribute(u20[v93][2])) or 0;
            v101 = math.floor(v103);
        else
            v101 = 0;
        end;

        v100 = v101 >= 3;
    else
        v100 = v97;
    end;

    local v104;

    if v98 then
        v91 = true;
        v104 = "Double Money MAX";
    elseif math_floor_ret >= 4000000000 then
        v104 = "Double Money Active";
    else
        local math_floor_ret3 = math.floor(math_max_ret);
        local math_max_ret2 = math.max(0, math_floor_ret3);
        local math_floor_ret4 = math.floor(math_max_ret2 / 3600);
        local math_floor_ret5 = math.floor(math_max_ret2 % 3600 / 60);
        v104 = "Double Money " .. string.format("%02d:%02d:%02d", math_floor_ret4, math_floor_ret5, math_max_ret2 % 60);
    end;

    local v105;

    if v97 then
        local v106 = tonumber(LocalPlayer:GetAttribute(u20[v93][1])) or 0;

        if v100 then
            v105 = v92 .. "x XP MAX";
        elseif v106 >= 4000000000 then
            v105 = v92 .. "x XP Active";
        else
            local math_floor_ret3 = math.floor(v94);
            local math_max_ret2 = math.max(0, math_floor_ret3);
            local math_floor_ret4 = math.floor(math_max_ret2 / 3600);
            local math_floor_ret5 = math.floor(math_max_ret2 % 3600 / 60);
            v105 = v92 .. "x XP " .. string.format("%02d:%02d:%02d", math_floor_ret4, math_floor_ret5, math_max_ret2 % 60);
        end;
    else
        v105 = "";
    end;

    TextLabel.Visible = v91 or v97;

    if v91 and v97 then
        TextLabel.Text = v104 .. "\n" .. v105;

        return;
    end;

    if v91 then
        TextLabel.Text = v104;

        return;
    end;

    if v97 then
        TextLabel.Text = v105;

        return;
    end;

    TextLabel.Text = "";
end;

LocalPlayer:GetAttributeChangedSignal("MoneyBoosterExpiresAt"):Connect(updateTimers);
LocalPlayer:GetAttributeChangedSignal("DoubleXPExpiresAt"):Connect(updateTimers);
LocalPlayer:GetAttributeChangedSignal("TripleXPExpiresAt"):Connect(updateTimers);
LocalPlayer:GetAttributeChangedSignal("QuadXPExpiresAt"):Connect(updateTimers);
local u107 = false;

local function cleanupIcons() -- Line: 657
    -- upvalues: u107 (ref), u82 (copy), u83 (copy), u55 (copy), u56 (copy), u57 (copy), u58 (copy), u59 (copy), u60 (copy), u61 (copy), u71 (copy), u79 (copy), u80 (copy), u81 (copy), ScreenGui (copy)
    if u107 then
        return;
    end;

    u107 = true;
    pcall(function() -- Line: 662
        -- upvalues: u82 (ref), u83 (ref), u55 (ref)
        u82:destroy();
        u83:destroy();
        u55:destroy();
    end);
    pcall(function() -- Line: 667
        -- upvalues: u56 (ref)
        u56:destroy();
    end);
    pcall(function() -- Line: 670
        -- upvalues: u57 (ref), u58 (ref)
        u57:destroy();
        u58:destroy();
    end);
    pcall(function() -- Line: 674
        -- upvalues: u59 (ref)
        u59:destroy();
    end);
    pcall(function() -- Line: 677
        -- upvalues: u60 (ref)
        u60:destroy();
    end);
    pcall(function() -- Line: 680
        -- upvalues: u61 (ref)
        u61:destroy();
    end);
    pcall(function() -- Line: 683
        -- upvalues: u71 (ref)
        u71:destroy();
    end);
    pcall(function() -- Line: 686
        -- upvalues: u79 (ref)
        if u79 then
            u79:destroy();
        end;
    end);
    pcall(function() -- Line: 689
        -- upvalues: u80 (ref)
        if u80 then
            u80:destroy();
        end;
    end);
    pcall(function() -- Line: 692
        -- upvalues: u81 (ref)
        if u81 then
            u81:destroy();
        end;
    end);

    if ScreenGui.Parent then
        ScreenGui:Destroy();
    end;
end;

script.Destroying:Connect(cleanupIcons);
updateTimers();

while script.Parent and PlayerGui:GetAttribute("BoosterTopbarControllerToken") == u1 do
    task.wait(0.25);
    updateTimers();
end;

cleanupIcons();