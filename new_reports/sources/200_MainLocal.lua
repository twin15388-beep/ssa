-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local UpgradesModule = require(ReplicatedStorage:WaitForChild("UpgradesModule"));
local SyncUIEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SyncUIEvent");
local UpgradesGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UpgradesGui");
local Vampire = UpgradesGui:WaitForChild("Vampire");
local Container = Vampire:WaitForChild("Container");
local Points = Vampire:WaitForChild("Points");
local u1 = {};
local u2 = {
    Sleep = 0,
    VampireSpeed = 0,
    VampireRegem = 0,
    VampiricReflexes = 0
};
local u3 = {
    [1] = "Sleep",
    [3] = "VampireSpeed",
    [4] = "VampireRegem",
    [5] = "VampiricReflexes"
};
local u4 = 0;

local function skillId(p5) -- Line: 16
    return ({
        Sleep = 1,
        BloodLine = 2,
        VampireSpeed = 3,
        VampireRegem = 4,
        VampiricReflexes = 5
    })[p5.Name] or tonumber(p5.Name);
end;

local Information = Container:WaitForChild("Information");
local Name = Information:WaitForChild("Name");
local About = Information:WaitForChild("About");
local u6 = nil;
local u7 = setmetatable({}, {
    __mode = "k"
});
Information.Visible = false;
Information.Parent = Vampire;
Information.AnchorPoint = Vector2.zero;
Information.ZIndex = 20;
local v8 = Information:FindFirstChildOfClass("UIAspectRatioConstraint");

if v8 then
    v8:Destroy();
end;

Name.ZIndex = 21;
Name.TextScaled = false;
Name.TextSize = 19;
Name.TextWrapped = true;
local v9 = Name:FindFirstChildOfClass("UIAspectRatioConstraint");

if v9 then
    v9:Destroy();
end;

Name.Position = UDim2.fromScale(0.06, 0.06);
Name.Size = UDim2.fromScale(0.88, 0.2);
About.ZIndex = 21;
About.TextWrapped = true;
About.TextScaled = false;
About.TextSize = 17;
About.TextYAlignment = Enum.TextYAlignment.Top;
local v10 = About:FindFirstChildOfClass("UIAspectRatioConstraint");

if v10 then
    v10:Destroy();
end;

About.Position = UDim2.fromScale(0.06, 0.3);
About.Size = UDim2.fromScale(0.88, 0.64);
local u11 = nil;

local function positionInformation() -- Line: 51
    -- upvalues: u11 (ref), Vampire (copy), Container (copy), UpgradesModule (copy), Information (copy)
    if not (u11 and u11.Parent) then
        return;
    end;

    local AbsolutePosition = Vampire.AbsolutePosition;
    local AbsoluteSize = Vampire.AbsoluteSize;

    if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
        return;
    end;

    local math_max_ret = math.max(170, AbsoluteSize.X - 24);
    local math_min_ret = math.min(280, math_max_ret);
    local math_max_ret2 = math.max(160, AbsoluteSize.Y - 100);
    local math_min_ret2 = math.min(230, math_max_ret2);
    local v12 = u11.AbsolutePosition - AbsolutePosition;
    local AbsoluteSize2 = u11.AbsoluteSize;
    local v13 = v12.Y + AbsoluteSize2.Y / 2 - math_min_ret2 / 2;
    local math_max_ret3 = math.max(64, AbsoluteSize.Y - math_min_ret2 - 12);
    local math_clamp_ret = math.clamp(v13, 64, math_max_ret3);
    local v14 = v12.X + AbsoluteSize2.X + 16;
    local v15 = v12.X - math_min_ret - 16;

    if v14 + math_min_ret <= AbsoluteSize.X - 12 and (not (function(p16) -- Line: 64, Name: overlapsAnotherButton
        -- upvalues: Container (ref), u11 (ref), UpgradesModule (ref), AbsolutePosition (copy), math_min_ret (copy), math_clamp_ret (copy), math_min_ret2 (copy)
        for _, child in ipairs(Container:GetChildren()) do
            if child ~= u11 and child:IsA("GuiButton") and UpgradesModule[({
                Sleep = 1,
                BloodLine = 2,
                VampireSpeed = 3,
                VampireRegem = 4,
                VampiricReflexes = 5
            })[child.Name] or tonumber(child.Name)] then
                local v17 = child.AbsolutePosition - AbsolutePosition;
                local AbsoluteSize3 = child.AbsoluteSize;

                if p16 < v17.X + AbsoluteSize3.X and (p16 + math_min_ret > v17.X and (math_clamp_ret < v17.Y + AbsoluteSize3.Y and math_clamp_ret + math_min_ret2 > v17.Y)) then
                    return true;
                end;
            end;
        end;

        return false;
    end)(v14) or v15 < 12) then
        v15 = v14;
    end;

    local math_max_ret4 = math.max(12, AbsoluteSize.X - math_min_ret - 12);
    local math_clamp_ret2 = math.clamp(v15, 12, math_max_ret4);
    Information.Size = UDim2.fromScale(math_min_ret / AbsoluteSize.X, math_min_ret2 / AbsoluteSize.Y);
    Information.Position = UDim2.fromScale(math_clamp_ret2 / AbsoluteSize.X, math_clamp_ret / AbsoluteSize.Y);
end;

game:GetService("RunService").RenderStepped:Connect(function() -- Line: 85
    -- upvalues: Information (copy), positionInformation (copy)
    if Information.Visible then
        positionInformation();
    end;
end);

local function updateInformation() -- Line: 89
    -- upvalues: u6 (ref), UpgradesModule (copy), Information (copy), Name (copy), u1 (ref), u3 (copy), u2 (copy), About (copy)
    local v18 = u6 and UpgradesModule[u6];

    if not v18 then
        Information.Visible = false;

        return;
    end;

    Name.Text = v18.name;
    local v19 = u1[u6] and "UNLOCKED" or "LOCKED";
    local v20 = u3[u6];

    if v20 and u1[u6] then
        v19 = ("Upgrade LV %d/%d | Cost: %d points"):format(u2[v20] or 0, v18.maxUpgradeLevel or 0, v18.upgradeCost or 0);
    end;

    About.Text = tostring(v18.description or "") .. "\n\nRequired level: " .. tostring(v18.level) .. "\n" .. v19;
end;

local function prepareUpgradeButton(u21) -- Line: 107
    -- upvalues: UpgradesModule (copy), u3 (copy), UpgradesGui (copy), u1 (ref), u4 (ref), u2 (copy), SyncUIEvent (copy)
    local UPGRADE = u21:FindFirstChild("UPGRADE");

    if UPGRADE and UPGRADE:IsA("TextLabel") then
        local UpgradeButton = u21:FindFirstChild("UpgradeButton");

        if not UpgradeButton then
            UpgradeButton = Instance.new("TextButton");
            UpgradeButton.Name = "UpgradeButton";
            UpgradeButton.AnchorPoint = UPGRADE.AnchorPoint;
            UpgradeButton.Position = UPGRADE.Position;
            UpgradeButton.Size = UPGRADE.Size;
            UpgradeButton.Font = UPGRADE.Font;
            UpgradeButton.TextSize = UPGRADE.TextSize;
            UpgradeButton.TextScaled = UPGRADE.TextScaled;
            UpgradeButton.TextColor3 = UPGRADE.TextColor3;
            UpgradeButton.TextStrokeTransparency = UPGRADE.TextStrokeTransparency;
            UpgradeButton.BackgroundTransparency = 1;
            UpgradeButton.ZIndex = math.max(UPGRADE.ZIndex + 1, u21.ZIndex + 1);
            UpgradeButton.Selectable = true;
            UpgradeButton.Parent = u21;
            UpgradeButton.Activated:Connect(function() -- Line: 126
                -- upvalues: u21 (copy), UpgradesModule (ref), u3 (ref), UpgradesGui (ref), u1 (ref), u4 (ref), u2 (ref), SyncUIEvent (ref)
                local v22 = u21;
                local v23 = ({
                    Sleep = 1,
                    BloodLine = 2,
                    VampireSpeed = 3,
                    VampireRegem = 4,
                    VampiricReflexes = 5
                })[v22.Name] or tonumber(v22.Name);
                local v24;

                if v23 then
                    v24 = UpgradesModule[v23];
                else
                    v24 = v23;
                end;

                local v25 = u3[v23];

                if UpgradesGui.Enabled and (v25 and (v24 and (u1[v23] and (u4 >= v24.upgradeCost and (u2[v25] or 0) < v24.maxUpgradeLevel)))) then
                    SyncUIEvent:FireServer("Upgrade", v25);
                end;
            end);
        end;

        UPGRADE.Visible = false;

        return UpgradeButton;
    end;
end;

local function bindAchievement(u26, u27) -- Line: 141
    -- upvalues: u7 (copy), UpgradesGui (copy), u6 (ref), u11 (ref), updateInformation (copy), positionInformation (copy), Information (copy)
    if u7[u26] then
        return;
    end;

    u7[u26] = true;
    u26.Selectable = true;
    u26.Activated:Connect(function() -- Line: 145
        -- upvalues: UpgradesGui (ref), u6 (ref), u27 (copy), u11 (ref), u26 (copy), updateInformation (ref), positionInformation (ref), Information (ref)
        if not UpgradesGui.Enabled then
            return;
        end;

        u6 = u27;
        u11 = u26;
        updateInformation();
        positionInformation();
        Information.Visible = true;
    end);
end;

UpgradesGui:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 155
    -- upvalues: UpgradesGui (copy), u6 (ref), u11 (ref), Information (copy)
    if not UpgradesGui.Enabled then
        u6 = nil;
        u11 = nil;
        Information.Visible = false;
    end;
end);

local function refresh() -- Line: 163
    -- upvalues: Container (copy), UpgradesModule (copy), u7 (copy), UpgradesGui (copy), u6 (ref), u11 (ref), updateInformation (copy), positionInformation (copy), Information (copy), u1 (ref), u3 (copy), u2 (copy), prepareUpgradeButton (copy), u4 (ref)
    local v28 = 0;
    local v29 = 0;

    for _, child in ipairs(Container:GetChildren()) do
        local u30 = ({
            Sleep = 1,
            BloodLine = 2,
            VampireSpeed = 3,
            VampireRegem = 4,
            VampiricReflexes = 5
        })[child.Name] or tonumber(child.Name);
        local v31;

        if u30 then
            v31 = UpgradesModule[u30];
        else
            v31 = u30;
        end;

        if v31 and child:IsA("GuiButton") then
            if not u7[child] then
                u7[child] = true;
                child.Selectable = true;
                child.Activated:Connect(function() -- Line: 145
                    -- upvalues: UpgradesGui (ref), u6 (ref), u30 (copy), u11 (ref), child (copy), updateInformation (ref), positionInformation (ref), Information (ref)
                    if not UpgradesGui.Enabled then
                        return;
                    end;

                    u6 = u30;
                    u11 = child;
                    updateInformation();
                    positionInformation();
                    Information.Visible = true;
                end);
            end;

            v28 = v28 + 1;
            local v32 = u1[u30] == true;

            if v32 then
                v29 = v29 + 1;
            end;

            child:SetAttribute("AchievementUnlocked", v32);
            local Name2 = child:FindFirstChild("Name");
            local Unlock = child:FindFirstChild("Unlock");

            if Name2 and Name2:IsA("TextLabel") then
                Name2.Text = v31.name;
                Name2.Font = Enum.Font.Ubuntu;
            end;

            if Unlock and Unlock:IsA("TextLabel") then
                local v33 = u3[u30];
                local v34;

                if v32 then
                    v34 = v33 and "LV " .. (u2[v33] or 0) or "UNLOCKED";
                else
                    v34 = "LV " .. v31.level;
                end;

                Unlock.Text = v34;
                Unlock.TextColor3 = v32 and Color3.fromRGB(100, 255, 115) or Color3.fromRGB(255, 255, 255);
                Unlock.Font = Enum.Font.Ubuntu;
            end;

            if u3[u30] then
                local v35 = u2[u3[u30]] or 0;
                local v36 = prepareUpgradeButton(child);

                if v36 then
                    v36.Visible = v32;
                    v36.Text = (v31.maxUpgradeLevel or 0) <= v35 and "MAX LEVEL" or "UPGRADE";
                    v36.TextColor3 = u4 >= (v31.upgradeCost or 0) and Color3.new(1, 1, 1) or Color3.fromRGB(160, 160, 160);
                end;

                local Price = child:FindFirstChild("Price");

                if Price and Price:IsA("TextLabel") then
                    Price.Visible = true;
                    Price.Text = (v31.maxUpgradeLevel or 0) <= v35 and "MAX LEVEL" or "Cost " .. (v31.upgradeCost or 0) .. " Points";
                    Price.TextColor3 = u4 >= (v31.upgradeCost or 0) and Color3.new(1, 1, 1) or Color3.fromRGB(160, 160, 160);
                end;
            end;
        end;
    end;

    updateInformation();
end;

local function updatePoints() -- Line: 211
    -- upvalues: u4 (ref), LocalPlayer (copy), Points (copy)
    local v37 = tonumber(LocalPlayer:GetAttribute("SkillPoints")) or 0;
    local math_floor_ret = math.floor(v37);
    u4 = math.max(0, math_floor_ret);
    Points.Text = ("%d POINTS"):format(u4);
end;

SyncUIEvent.OnClientEvent:Connect(function(p38, p39, p40) -- Line: 215
    -- upvalues: u1 (ref), UpgradesModule (copy), u3 (copy), u2 (copy), u4 (ref), Points (copy), refresh (copy)
    if typeof(p38) ~= "table" then
        return;
    end;

    u1 = {};

    for _, v in ipairs(p38) do
        local v41 = tonumber(v);

        if v41 and UpgradesModule[v41] then
            u1[v41] = true;
        end;
    end;

    for i, v in pairs(u3) do
        local v42 = typeof(p39) == "table" and p39[v] or (i == 1 and p39 and p39 or 0);
        local v43 = tonumber(v42) or 0;
        local math_floor_ret = math.floor(v43);
        u2[v] = math.clamp(math_floor_ret, 0, UpgradesModule[i].maxUpgradeLevel);
    end;

    local v44 = tonumber(p40) or 0;
    local math_floor_ret = math.floor(v44);
    u4 = math.max(0, math_floor_ret);
    Points.Text = ("%d POINTS"):format(u4);
    refresh();
end);
Container.ChildAdded:Connect(refresh);
LocalPlayer:GetAttributeChangedSignal("SkillPoints"):Connect(function() -- Line: 231
    -- upvalues: u4 (ref), LocalPlayer (copy), Points (copy), refresh (copy)
    local v45 = tonumber(LocalPlayer:GetAttribute("SkillPoints")) or 0;
    local math_floor_ret = math.floor(v45);
    u4 = math.max(0, math_floor_ret);
    Points.Text = ("%d POINTS"):format(u4);
    refresh();
end);
local v46 = tonumber(LocalPlayer:GetAttribute("SkillPoints")) or 0;
local math_floor_ret = math.floor(v46);
u4 = math.max(0, math_floor_ret);
Points.Text = ("%d POINTS"):format(u4);
refresh();
SyncUIEvent:FireServer("Request");