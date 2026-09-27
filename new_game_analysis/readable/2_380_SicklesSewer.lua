-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local lever = require(ReplicatedStorage.CAM.Global.Training["Parkour Dungeon"].lever);
local CFrame_new_ret = CFrame.new(-1024.848, 825.807, 599.323);
local u1 = CFrame.new(-1024.848, 834.371, 582.002) * CFrame.Angles(0.7853981633974483, 0, 0);
local LocalPlayer = Players.LocalPlayer;
local u2 = cleanit.new();
local u3 = {};
local u4 = {};
local u5 = CFrame_new_ret;
local u6 = false;
local u7 = false;

local function placePart(p8: userdata) -- Line: 44
    -- upvalues: u4 (copy), u1 (copy), u5 (ref)
    local v9 = u4[p8];

    if v9 == nil then
        v9 = u1:Inverse() * p8.CFrame;
        u4[p8] = v9;
    end;

    p8.CFrame = u5 * v9;
end;

local function lock(p10: userdata) -- Line: 53
    -- upvalues: u6 (ref)
    if p10:GetAttribute("Item") ~= "Nightfall Sickles" then
        return;
    end;

    p10:SetAttribute("Locked", not u6 and true or nil);
end;

local function unlock() -- Line: 58
    -- upvalues: u6 (ref), CollectionService (copy)
    u6 = true;

    for _, v in CollectionService:GetTagged("StudyProp") do
        if v:GetAttribute("Item") == "Nightfall Sickles" then
            v:SetAttribute("Locked", not u6 and true or nil);
        end;
    end;
end;

local function animate(p11: userdata) -- Line: 65
    -- upvalues: u7 (ref), CFrame_new_ret (copy), u5 (ref), u4 (copy), u1 (copy), TweenService (copy)
    if u7 then
        return;
    end;

    u7 = true;
    local CFrameValue = Instance.new("CFrameValue");
    CFrameValue.Value = CFrame_new_ret;
    CFrameValue.Changed:Connect(function(p12) -- Line: 70
        -- upvalues: u5 (ref), u4 (ref), u1 (ref)
        u5 = p12;

        for i in u4 do
            local v13 = u4[i];

            if v13 == nil then
                v13 = u1:Inverse() * i.CFrame;
                u4[i] = v13;
            end;

            i.CFrame = u5 * v13;
        end;
    end);
    CFrameValue.Parent = p11;
    local v14 = TweenService:Create(CFrameValue, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Value = u1
    });
    v14.Completed:Once(function() -- Line: 78
        -- upvalues: CFrameValue (copy)
        CFrameValue:Destroy();
    end);
    v14:Play();
end;

local function update() -- Line: 84
    -- upvalues: LocalPlayer (copy), u6 (ref), CollectionService (copy), animate (copy)
    if not LocalPlayer:GetAttribute("SicklesSewerOpen") then
        return;
    end;

    u6 = true;

    for _, v in CollectionService:GetTagged("StudyProp") do
        if v:GetAttribute("Item") == "Nightfall Sickles" then
            v:SetAttribute("Locked", not u6 and true or nil);
        end;
    end;

    local v15 = CollectionService:GetTagged("SicklesSewerHole")[1];

    if v15 ~= nil then
        animate(v15);
    end;
end;

local function complete(p16: userdata) -- Line: 92
    local A_ = p16:FindFirstChild("A_");
    local color = p16:FindFirstChild("color");
    local v17;

    if A_ == nil or (A_:FindFirstChild("LeverMain") == nil or (A_:FindFirstChild("color") == nil or color == nil)) then
        v17 = false;
    else
        v17 = color:FindFirstChild("PointLight") ~= nil;
    end;

    return v17;
end;

local function keyOf(p18: userdata) -- Line: 101
    local Position = p18.Position;

    return `{math.round(Position.X * 10)},{math.round(Position.Y * 10)},{math.round(Position.Z * 10)}`;
end;

local function wire(u19: userdata) -- Line: 106
    -- upvalues: complete (copy), wire (copy), u3 (copy), lever (copy), u2 (copy)
    if not complete(u19) then
        local u20 = nil;
        u20 = u19.DescendantAdded:Connect(function() -- Line: 109
            -- upvalues: complete (ref), u19 (copy), u20 (ref), wire (ref)
            if complete(u19) then
                u20:Disconnect();
                wire(u19);
            end;
        end);

        return;
    end;

    local A_ = u19:FindFirstChild("A_");
    local Position = A_:FindFirstChild("LeverMain").Position;
    local u21 = `{math.round(Position.X * 10)},{math.round(Position.Y * 10)},{math.round(Position.Z * 10)}`;

    if u3[u21] then
        A_:SetAttribute("On", true);
    end;

    local Configuration = Instance.new("Configuration");
    Configuration:SetAttribute("Level", 0);
    lever(u19, nil, u2, Configuration, 0, 1);
    A_:GetAttributeChangedSignal("On"):Connect(function() -- Line: 125
        -- upvalues: A_ (copy), u3 (ref), u21 (copy)
        if A_:GetAttribute("On") then
            u3[u21] = true;
        end;
    end);
end;

local function place(p22: userdata) -- Line: 132
    -- upvalues: u4 (copy), u1 (copy), u5 (ref), LocalPlayer (copy), u6 (ref), CollectionService (copy), animate (copy)
    for _, descendant in p22:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v23 = u4[descendant];

            if v23 == nil then
                v23 = u1:Inverse() * descendant.CFrame;
                u4[descendant] = v23;
            end;

            descendant.CFrame = u5 * v23;
        end;
    end;

    p22.DescendantAdded:Connect(function(p24) -- Line: 136
        -- upvalues: u4 (ref), u1 (ref), u5 (ref)
        if p24:IsA("BasePart") then
            local v25 = u4[p24];

            if v25 == nil then
                v25 = u1:Inverse() * p24.CFrame;
                u4[p24] = v25;
            end;

            p24.CFrame = u5 * v25;
        end;
    end);
    p22.DescendantRemoving:Connect(function(p26) -- Line: 139
        -- upvalues: u4 (ref)
        u4[p26] = nil;
    end);

    if not LocalPlayer:GetAttribute("SicklesSewerOpen") then
        return;
    end;

    u6 = true;

    for _, v in CollectionService:GetTagged("StudyProp") do
        if v:GetAttribute("Item") == "Nightfall Sickles" then
            v:SetAttribute("Locked", not u6 and true or nil);
        end;
    end;

    local v27 = CollectionService:GetTagged("SicklesSewerHole")[1];

    if v27 ~= nil then
        animate(v27);
    end;
end;

for _, v in CollectionService:GetTagged("SicklesLever") do
    wire(v);
end;

CollectionService:GetInstanceAddedSignal("SicklesLever"):Connect(wire);

for _, v in CollectionService:GetTagged("SicklesSewerHole") do
    place(v);
end;

CollectionService:GetInstanceAddedSignal("SicklesSewerHole"):Connect(place);

for _, v in CollectionService:GetTagged("StudyProp") do
    if v:GetAttribute("Item") == "Nightfall Sickles" then
        v:SetAttribute("Locked", not u6 and true or nil);
    end;
end;

CollectionService:GetInstanceAddedSignal("StudyProp"):Connect(lock);
LocalPlayer:GetAttributeChangedSignal("SicklesSewerOpen"):Connect(update);

if LocalPlayer:GetAttribute("SicklesSewerOpen") then
    u6 = true;

    for _, v in CollectionService:GetTagged("StudyProp") do
        if v:GetAttribute("Item") == "Nightfall Sickles" then
            v:SetAttribute("Locked", not u6 and true or nil);
        end;
    end;

    local v28 = CollectionService:GetTagged("SicklesSewerHole")[1];

    if v28 ~= nil then
        animate(v28);
    end;
end;