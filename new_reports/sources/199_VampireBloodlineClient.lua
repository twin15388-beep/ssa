-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local LocalPlayer = Players.LocalPlayer;
local VampireBloodlineMessage = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("VampireBloodlineMessage");
local u1 = {};
local u2 = {};
local u3 = nil;

local function isVampire(p4) -- Line: 10
    local v5 = p4.Team and p4.Team.Name;

    return v5 == "Vampires" and true or v5 == "Cannibal Raised";
end;

local function removeMarker(p6) -- Line: 15
    -- upvalues: u1 (copy)
    local v7 = u1[p6];

    if v7 then
        v7:Destroy();
    end;

    u1[p6] = nil;
end;

local function refreshMarker(p8) -- Line: 21
    -- upvalues: LocalPlayer (copy), u1 (copy)
    if p8 == LocalPlayer then
        return;
    end;

    local v9 = tonumber(p8:GetAttribute("BloodlineMasterUserId")) or 0;
    local Character = p8.Character;
    local v10 = p8.Team and p8.Team.Name;

    if not ((v10 == "Vampires" or v10 == "Cannibal Raised") and (v9 == LocalPlayer.UserId and ((tonumber(p8:GetAttribute("Years")) or 0) < 300 and Character))) then
        local v11 = u1[p8];

        if v11 then
            v11:Destroy();
        end;

        u1[p8] = nil;

        return;
    end;

    if u1[p8] and u1[p8].Parent == Character then
        return;
    end;

    local v12 = u1[p8];

    if v12 then
        v12:Destroy();
    end;

    u1[p8] = nil;
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "BloodlineMasterOnlyMarker";
    Highlight.Adornee = Character;
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.fromRGB(230, 25, 35);
    Highlight.OutlineTransparency = 0;
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.Parent = Character;
    u1[p8] = Highlight;
end;

local u13 = {
    Joined = "Your creation joined",
    Left = "Your creation left",
    Died = "Your creation died"
};

local function showMessage(p14, p15) -- Line: 52
    -- upvalues: u13 (copy), u3 (ref), LocalPlayer (copy), TweenService (copy)
    local v16 = u13[p14];

    if not v16 then
        return;
    end;

    if u3 then
        u3:Destroy();
    end;

    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "VampireBloodlineMessageGui";
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.IgnoreGuiInset = false;
    ScreenGui.DisplayOrder = 80;
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
    u3 = ScreenGui;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Text";
    TextLabel.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel.Position = UDim2.new(0.5, 0, 0, 8);
    TextLabel.Size = UDim2.new(0.8, 0, 0, 30);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.TextColor3 = Color3.fromRGB(255, 70, 75);
    TextLabel.TextStrokeColor3 = Color3.fromRGB(55, 0, 0);
    TextLabel.TextStrokeTransparency = 0.35;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal);
    TextLabel.TextScaled = true;
    TextLabel.TextWrapped = false;
    TextLabel.Text = v16 .. ": " .. tostring(p15 or "");
    TextLabel.Parent = ScreenGui;
    local UISizeConstraint = Instance.new("UISizeConstraint");
    UISizeConstraint.MinSize = Vector2.new(180, 26);
    UISizeConstraint.MaxSize = Vector2.new(560, 32);
    UISizeConstraint.Parent = TextLabel;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MinTextSize = 11;
    UITextSizeConstraint.MaxTextSize = 18;
    UITextSizeConstraint.Parent = TextLabel;
    task.delay(1.35, function() -- Line: 89
        -- upvalues: u3 (ref), ScreenGui (copy), TweenService (ref), TextLabel (copy)
        if u3 ~= ScreenGui then
            return;
        end;

        TweenService:Create(TextLabel, TweenInfo.new(0.25), {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }):Play();
        task.wait(0.3);

        if u3 == ScreenGui then
            u3 = nil;
        end;

        ScreenGui:Destroy();
    end);
end;

local function watchPlayer(u17) -- Line: 101
    -- upvalues: LocalPlayer (copy), u2 (copy), refreshMarker (copy)
    if u17 == LocalPlayer or u2[u17] then
        return;
    end;

    local v18 = {};
    table.insert(v18, u17.CharacterAdded:Connect(function(u19) -- Line: 104, Name: hookCharacter
        -- upvalues: refreshMarker (ref), u17 (copy)
        task.spawn(function() -- Line: 105
            -- upvalues: u19 (copy), refreshMarker (ref), u17 (ref)
            u19:WaitForChild("Head", 10);
            refreshMarker(u17);
        end);
    end));
    local AttributeChangedSignal = u17:GetAttributeChangedSignal("BloodlineMasterUserId");
    table.insert(v18, AttributeChangedSignal:Connect(function() -- Line: 111
        -- upvalues: refreshMarker (ref), u17 (copy)
        refreshMarker(u17);
    end));
    local AttributeChangedSignal2 = u17:GetAttributeChangedSignal("Years");
    table.insert(v18, AttributeChangedSignal2:Connect(function() -- Line: 112
        -- upvalues: refreshMarker (ref), u17 (copy)
        refreshMarker(u17);
    end));
    local PropertyChangedSignal = u17:GetPropertyChangedSignal("Team");
    table.insert(v18, PropertyChangedSignal:Connect(function() -- Line: 113
        -- upvalues: refreshMarker (ref), u17 (copy)
        refreshMarker(u17);
    end));
    u2[u17] = v18;

    if u17.Character then
        local Character = u17.Character;
        task.spawn(function() -- Line: 105
            -- upvalues: Character (copy), refreshMarker (ref), u17 (copy)
            Character:WaitForChild("Head", 10);
            refreshMarker(u17);
        end);
    end;
end;

Players.PlayerAdded:Connect(watchPlayer);
Players.PlayerRemoving:Connect(function(p20) -- Line: 119
    -- upvalues: u1 (copy), u2 (copy)
    local v21 = u1[p20];

    if v21 then
        v21:Destroy();
    end;

    u1[p20] = nil;
    local v22 = u2[p20];

    if v22 then
        for _, v in ipairs(v22) do
            v:Disconnect();
        end;
    end;

    u2[p20] = nil;
end);

for _, v in ipairs(Players:GetPlayers()) do
    watchPlayer(v);
end;

VampireBloodlineMessage.OnClientEvent:Connect(showMessage);