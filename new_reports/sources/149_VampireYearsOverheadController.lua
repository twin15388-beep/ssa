-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = {};
local u2 = {};
local u13 = {
    Vampires = {
        Color = Color3.fromRGB(245, 55, 60),
        Stroke = Color3.fromRGB(25, 0, 0),

        GetText = function(p3) -- Line: 13, Name: GetText
            local v4 = tonumber(p3:GetAttribute("Years")) or 0;
            local math_floor_ret = math.floor(v4);
            local math_max_ret = math.max(0, math_floor_ret);

            if p3:GetAttribute("CannibalRaised") == true then
                return "Cannibal Raised Lv " .. tostring(math_max_ret);
            end;

            if p3:GetAttribute("CannibalVampire") == true then
                return "Cannibal Vampire Lv " .. tostring(math_max_ret);
            end;

            return "Vampire Lv " .. tostring(math_max_ret);
        end
    },
    Humans = {
        Color = Color3.fromRGB(120, 200, 255),
        Stroke = Color3.fromRGB(0, 20, 35),

        GetText = function(p5) -- Line: 26, Name: GetText
            local v6 = tonumber(p5:GetAttribute("Years")) or 0;
            local math_floor_ret = math.floor(v6);
            local math_max_ret = math.max(0, math_floor_ret);

            return "Human Lv " .. tostring(math_max_ret);
        end
    },
    Werewolfs = {
        Color = Color3.fromRGB(225, 145, 60),
        Stroke = Color3.fromRGB(30, 15, 0),

        GetText = function(p7) -- Line: 34, Name: GetText
            local v8 = tonumber(p7:GetAttribute("Years")) or 0;
            local math_floor_ret = math.floor(v8);
            local math_max_ret = math.max(0, math_floor_ret);

            return "Werewolf Lv " .. tostring(math_max_ret);
        end
    },
    VampireHunter = {
        Color = Color3.fromRGB(232, 196, 92),
        Stroke = Color3.fromRGB(35, 24, 0),

        GetText = function(p9) -- Line: 42, Name: GetText
            local v10 = tonumber(p9:GetAttribute("Years")) or 0;
            local math_floor_ret = math.floor(v10);
            local math_max_ret = math.max(0, math_floor_ret);

            return "Vampire Hunter Lv " .. tostring(math_max_ret);
        end
    },
    Witches = {
        Color = Color3.fromRGB(181, 95, 255),
        Stroke = Color3.fromRGB(38, 0, 68),

        GetText = function(p11) -- Line: 50, Name: GetText
            local v12 = tonumber(p11:GetAttribute("Years")) or 0;
            local math_floor_ret = math.floor(v12);
            local math_max_ret = math.max(0, math_floor_ret);

            return "Witch Lv " .. tostring(math_max_ret);
        end
    }
};
u13["Cannibal Raised"] = u13.Vampires;
local u15 = {
    Color = Color3.fromRGB(225, 225, 225),
    Stroke = Color3.fromRGB(15, 15, 15),

    GetText = function(p14) -- Line: 62, Name: GetText
        local Team = p14.Team;

        return Team and Team.Name or "Neutral";
    end
};
local u16 = {
    Color = Color3.new(1, 1, 1),
    Stroke = Color3.fromRGB(15, 15, 15)
};
local u17 = {
    SpecialTitle = true,
    RingOriginalTag = true
};

local function escapeRichText(p18) -- Line: 78
    return tostring(p18 or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("\'", "&apos;");
end;

local function setSupplementalIdentityHidden(p19, p20) -- Line: 87
    -- upvalues: u17 (copy)
    if not p19 then
        return;
    end;

    for _, descendant in ipairs(p19:GetDescendants()) do
        if descendant:IsA("BillboardGui") and u17[descendant.Name] then
            descendant.Enabled = not p20;
        end;
    end;
end;

local function getTeamConfig(p21) -- Line: 96
    -- upvalues: u13 (copy), u15 (copy)
    local Team = p21.Team;

    if Team and u13[Team.Name] then
        return u13[Team.Name];
    end;

    return u15;
end;

local function disconnectPlayer(p22) -- Line: 104
    -- upvalues: u2 (copy), u1 (copy)
    local v23 = u2[p22];

    if v23 then
        for _, v in ipairs(v23) do
            v:Disconnect();
        end;
    end;

    u2[p22] = nil;
    local v24 = u1[p22];

    if v24 and v24.Parent then
        v24:Destroy();
    end;

    u1[p22] = nil;
end;

local function updateDisplay(p25) -- Line: 121
    -- upvalues: u1 (copy), setSupplementalIdentityHidden (copy), u16 (copy), u13 (copy), u15 (copy), escapeRichText (copy)
    local Character = p25.Character;
    local v26;

    if Character then
        v26 = Character:FindFirstChild("Head");
    else
        v26 = Character;
    end;

    local v27;

    if Character then
        v27 = Character:FindFirstChildOfClass("Humanoid");
    else
        v27 = Character;
    end;

    local v28 = u1[p25];

    if not (v26 and v26:IsA("BasePart")) then
        if v28 and v28.Parent then
            v28:Destroy();
        end;

        u1[p25] = nil;

        return;
    end;

    if v27 and v27.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
        v27.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
    end;

    if p25:GetAttribute("WitchInvisibleActive") == true then
        if v28 and v28.Parent then
            v28.Enabled = false;
        end;

        setSupplementalIdentityHidden(Character, true);

        return;
    end;

    if v28 and v28.Parent then
        v28.Enabled = true;
    end;

    local v29 = p25:GetAttribute("HideIdentityActive") == true;
    local v30 = p25:GetAttribute("CustomTagActive") == true;
    local v31 = p25:GetAttribute("CustomTagText") or "Tag";
    local v32 = p25:GetAttribute("CustomTagColor") or Color3.fromRGB(255, 255, 255);
    local v33, v34;

    if v29 then
        v33 = u16;
        v34 = p25.Name;
    else
        local Team = p25.Team;

        if Team and u13[Team.Name] then
            v33 = u13[Team.Name];
        else
            v33 = u15;
        end;

        v34 = v33.GetText(p25);
        local v35 = p25:GetAttribute("BloodlineName") or "";
        local v36 = tostring(v35);

        if v36 ~= "" then
            v34 = v36 .. " " .. v34;
        end;
    end;

    local v37 = p25.Team and p25.Team.Name;
    local v38 = v37 == "Vampires" and true or v37 == "Cannibal Raised";
    local v39 = v37 == "Witches";
    local v40 = tonumber(p25:GetAttribute("ExtraHearts")) or 0;
    local math_floor_ret = math.floor(v40);
    local math_clamp_ret = math.clamp(math_floor_ret, 0, 3);
    local v41 = not v29;

    if v41 then
        if v38 then
            v41 = math_clamp_ret > 0;
        else
            v41 = v38;
        end;
    end;

    setSupplementalIdentityHidden(Character, false);
    local v42 = {};
    local v43 = nil;

    if v30 then
        local math_floor_ret2 = math.floor(v32.R * 255 + 0.5);
        local math_clamp_ret2 = math.clamp(math_floor_ret2, 0, 255);
        local math_floor_ret3 = math.floor(v32.G * 255 + 0.5);
        local math_clamp_ret3 = math.clamp(math_floor_ret3, 0, 255);
        local math_floor_ret4 = math.floor(v32.B * 255 + 0.5);
        local math_clamp_ret4 = math.clamp(math_floor_ret4, 0, 255);
        local string_format_ret = string.format("#%02X%02X%02X", math_clamp_ret2, math_clamp_ret3, math_clamp_ret4);
        v43 = string.format("<font size=\"16\" color=\"%s\">%s</font>", string_format_ret, escapeRichText(v31));
    elseif not v29 then
        local v44 = tonumber(p25:GetAttribute("ClashesWon")) or 0;
        local v45 = tonumber(p25:GetAttribute("GuardKills")) or 0;
        local v46 = tonumber(p25:GetAttribute("WitchKills")) or 0;
        local v47 = tonumber(p25:GetAttribute("VampireKills")) or 0;

        if v39 and p25:GetAttribute("SupremeWitch") == true then
            v43 = "<font size=\"7\" color=\"#FFD700\">SUPREME WITCH</font>";
        elseif v44 >= 50 then
            v43 = "<font size=\"7\" color=\"#00FFFF\">SPEEDSTER</font>";
        elseif v45 >= 400 then
            v43 = "<font size=\"7\" color=\"#C8C8C8\">GUARD ASSASSIN</font>";
        elseif v38 and v46 >= 100 then
            v43 = "<font size=\"7\" color=\"#9600FF\">WITCH HUNTER</font>";
        elseif (v37 == "Humans" or (v39 or (v37 == "VampireHunter" or v37 == "Werewolfs"))) and v47 >= 200 then
            v43 = "<font size=\"7\" color=\"#FF6400\">VAMPIRE HUNTER</font>";
        elseif v39 then
            local v48 = tonumber(p25:GetAttribute("Years")) or 0;
            local math_floor_ret2 = math.floor(v48);
            local math_max_ret = math.max(0, math_floor_ret2);
            v43 = math_max_ret <= 24 and "<font size=\"7\" color=\"#D8B4FE\">NOVICE WITCH</font>" or (math_max_ret <= 49 and "<font size=\"7\" color=\"#C084FC\">ADEPT WITCH</font>" or (math_max_ret <= 74 and "<font size=\"7\" color=\"#A855F7\">GIFTED WITCH</font>" or (math_max_ret <= 99 and "<font size=\"7\" color=\"#8B5CF6\">POWERFUL WITCH</font>" or (math_max_ret <= 399 and "<font size=\"7\" color=\"#7E22CE\">ELDER WITCH</font>" or (math_max_ret <= 799 and "<font size=\"7\" color=\"#581C87\">ANCIENT WITCH</font>" or "<font size=\"7\" color=\"#F8E16C\">SACRED WITCH</font>")))));
        elseif v38 then
            local v49 = tonumber(p25:GetAttribute("Years")) or 0;
            v43 = v49 <= 50 and "<font size=\"7\" color=\"#FF9696\">ROOKIE VAMPIRE</font>" or (v49 <= 200 and "<font size=\"7\" color=\"#FF3232\">BLOODTHIRSTY VAMPIRE</font>" or (v49 <= 400 and "<font size=\"7\" color=\"#C80000\">EXPERIENCED VAMPIRE</font>" or "<font size=\"7\" color=\"#780000\">ANCIENT VAMPIRE</font>"));
        end;
    end;

    if v43 then
        table.insert(v42, v43);
    end;

    if #v42 > 0 then
        v34 = table.concat(v42, "\n") .. "\n" .. v34;
    end;

    local math_max_ret = math.max(18, 14 + #v42 * (v30 and 19 or 9));
    local v50;

    if v41 then
        v50 = math_max_ret + 16 or math_max_ret;
    else
        v50 = math_max_ret;
    end;

    local v51 = v30 and 320 or 220;
    local v52 = (Character:FindFirstChild("VampireHatAccessory") ~= nil and v26.Size.Y * 0.5 + 0.82 or v26.Size.Y * 0.5 + 0.35) + (#v42 + 1) * 0.11;

    if v28 and v28.Parent == v26 then
        v28.StudsOffsetWorldSpace = Vector3.new(0, v52, 0);
        v28.Size = UDim2.fromOffset(v51, v50);
        local TagLabel = v28:FindFirstChild("TagLabel");

        if TagLabel then
            TagLabel.Size = v41 and UDim2.new(1, 0, math_max_ret / v50, 0) or UDim2.fromScale(1, 1);
            TagLabel.Text = v34;
            TagLabel.TextColor3 = v33.Color;
            TagLabel.TextStrokeColor3 = v33.Stroke;
            TagLabel.TextStrokeTransparency = 1;
        end;

        local HeartsLabel = v28:FindFirstChild("HeartsLabel");

        if HeartsLabel and HeartsLabel:IsA("TextLabel") then
            HeartsLabel.Position = UDim2.fromScale(0.5, math_max_ret / v50);
            HeartsLabel.Size = UDim2.new(1, 0, 16 / v50, 0);
            HeartsLabel.Text = "Hearts x" .. tostring(math_clamp_ret);
            HeartsLabel.TextStrokeTransparency = 1;
            HeartsLabel.Visible = v41;
        end;

        return;
    end;

    if v28 and v28.Parent then
        v28:Destroy();
    end;

    local v53 = v26:FindFirstChild("TeamLevelOverheadDisplay") or (v26:FindFirstChild("PlayerOverheadDisplay") or v26:FindFirstChild("VampireYearsDisplay"));

    if v53 then
        v53:Destroy();
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "TeamLevelOverheadDisplay";
    BillboardGui.Adornee = v26;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.MaxDistance = 85;
    BillboardGui.Size = UDim2.fromOffset(v51, v50);
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, v52, 0);
    BillboardGui.Parent = v26;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TagLabel";
    TextLabel.Size = v41 and UDim2.new(1, 0, math_max_ret / v50, 0) or UDim2.fromScale(1, 1);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.BorderSizePixel = 0;
    TextLabel.Font = Enum.Font.Ubuntu;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    TextLabel.RichText = true;
    TextLabel.TextScaled = false;
    TextLabel.TextSize = 15;
    TextLabel.TextWrapped = false;
    TextLabel.Text = v34;
    TextLabel.TextColor3 = v33.Color;
    TextLabel.TextStrokeColor3 = v33.Stroke;
    TextLabel.TextStrokeTransparency = 1;
    TextLabel.Parent = BillboardGui;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "HeartsLabel";
    TextLabel2.AnchorPoint = Vector2.new(0.5, 0);
    TextLabel2.Position = UDim2.fromScale(0.5, math_max_ret / v50);
    TextLabel2.Size = UDim2.new(1, 0, 16 / v50, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.BorderSizePixel = 0;
    TextLabel2.Font = Enum.Font.Ubuntu;
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
    TextLabel2.TextScaled = false;
    TextLabel2.TextSize = 12;
    TextLabel2.TextWrapped = false;
    TextLabel2.Text = "Hearts x" .. tostring(math_clamp_ret);
    TextLabel2.TextColor3 = Color3.fromRGB(235, 45, 55);
    TextLabel2.TextStrokeColor3 = Color3.fromRGB(40, 0, 0);
    TextLabel2.TextStrokeTransparency = 1;
    TextLabel2.Visible = v41;
    TextLabel2.Parent = BillboardGui;
    u1[p25] = BillboardGui;
end;

local function waitForHead(p54, p55) -- Line: 342
    for i = 1, p55 or 12 do
        if not (p54 and p54.Parent) then
            return nil;
        end;

        local Head = p54:FindFirstChild("Head");

        if Head and Head:IsA("BasePart") then
            return Head;
        end;

        task.wait(0.2);
        local _ = i;
    end;

    return p54 and p54:FindFirstChild("Head") or nil;
end;

local function setupPlayer(u56) -- Line: 357
    -- upvalues: disconnectPlayer (copy), u2 (copy), waitForHead (copy), updateDisplay (copy)
    disconnectPlayer(u56);
    u2[u56] = {
        u56.CharacterAdded:Connect(function(u57) -- Line: 360
            -- upvalues: waitForHead (ref), updateDisplay (ref), u56 (copy)
            task.spawn(function() -- Line: 361
                -- upvalues: waitForHead (ref), u57 (copy), updateDisplay (ref), u56 (ref)
                waitForHead(u57, 25);
                updateDisplay(u56);
                task.wait(0.6);
                updateDisplay(u56);
            end);
            u57.ChildAdded:Connect(function(p58) -- Line: 369
                -- upvalues: updateDisplay (ref), u56 (ref)
                if p58.Name == "VampireHatAccessory" then
                    task.wait(0.05);
                    updateDisplay(u56);
                end;
            end);
            u57.ChildRemoved:Connect(function(p59) -- Line: 375
                -- upvalues: updateDisplay (ref), u56 (ref)
                if p59.Name == "VampireHatAccessory" then
                    task.wait(0.05);
                    updateDisplay(u56);
                end;
            end);
        end),
        u56:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 382
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("Years"):Connect(function() -- Line: 385
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("CannibalVampire"):Connect(function() -- Line: 388
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("CannibalRaised"):Connect(function() -- Line: 391
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("BloodlineName"):Connect(function() -- Line: 394
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("ExtraHearts"):Connect(function() -- Line: 397
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("SupremeWitch"):Connect(function() -- Line: 400
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("HideIdentityActive"):Connect(function() -- Line: 403
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("WitchInvisibleActive"):Connect(function() -- Line: 406
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("CustomTagActive"):Connect(function() -- Line: 409
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("CustomTagText"):Connect(function() -- Line: 412
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end),
        u56:GetAttributeChangedSignal("CustomTagColor"):Connect(function() -- Line: 415
            -- upvalues: updateDisplay (ref), u56 (copy)
            updateDisplay(u56);
        end)
    };

    if u56.Character then
        task.spawn(function() -- Line: 421
            -- upvalues: waitForHead (ref), u56 (copy), updateDisplay (ref)
            waitForHead(u56.Character, 25);
            updateDisplay(u56);
        end);
    end;
end;

task.spawn(function() -- Line: 430
    -- upvalues: u2 (copy), Players (copy), updateDisplay (copy)
    while true do
        task.wait(1.5);

        for i in pairs(u2) do
            if i.Parent == Players then
                local Character = i.Character;

                if Character then
                    Character = Character:FindFirstChild("Head");
                end;

                if Character and Character:IsA("BasePart") then
                    updateDisplay(i);
                end;
            end;
        end;
    end;
end);
Players.PlayerAdded:Connect(setupPlayer);
Players.PlayerRemoving:Connect(disconnectPlayer);

for _, v in ipairs(Players:GetPlayers()) do
    setupPlayer(v);
end;