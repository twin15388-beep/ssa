-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = Players.LocalPlayer;
Utility.GetData(LocalPlayer, true);
local valuesfolder = Utility.getvaluesfolder(LocalPlayer, true);
local u1 = {};

for _, v in ipairs(script:QueryDescendants("ModuleScript")) do
    u1[v.Name] = require(v);
end;

local function GetInstanceChain(p2: string, p3: table?) -- Line: 12
    -- upvalues: u1 (copy), GetInstanceChain (copy)
    local v4 = p3 or {};

    if v4[p2] then
        return {};
    end;

    v4[p2] = true;
    local v5 = u1[p2];

    if not v5 then
        return {};
    end;

    local v6 = {};

    if v5.ContinueInstance then
        for _, v in ipairs(GetInstanceChain(v5.ContinueInstance, v4)) do
            table.insert(v6, v);
        end;
    end;

    table.insert(v6, p2);

    return v6;
end;

local function ResolveProperties(p7: string, p8: table?) -- Line: 29
    -- upvalues: u1 (copy), ResolveProperties (copy)
    local v9 = p8 or {};

    if v9[p7] then
        return {};
    end;

    v9[p7] = true;
    local v10 = u1[p7];

    if not v10 then
        return {};
    end;

    local v11 = {};

    if v10.ContinueProperties then
        for i, v in pairs(ResolveProperties(v10.ContinueProperties, v9)) do
            v11[i] = v;
        end;
    end;

    if v10.Properties then
        for i, v in pairs(v10.Properties) do
            v11[i] = v;
        end;
    end;

    return v11;
end;

local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);

local function ResolveMinigameBiome() -- Line: 61
    -- upvalues: u1 (copy)
    local Attribute = workspace:GetAttribute("MinigameKey");
    local Attribute2 = workspace:GetAttribute("MinigameState");
    local Attribute3 = workspace:GetAttribute("MinigameMap");
    local v12 = {};

    if Attribute ~= nil then
        if Attribute2 ~= nil then
            if Attribute3 ~= nil then
                local v13 = `Minigame_{Attribute}_{Attribute2}_{Attribute3}`;
                table.insert(v12, v13);
            end;

            local v14 = `Minigame_{Attribute}_{Attribute2}`;
            table.insert(v12, v14);
        end;

        local v15 = `Minigame_{Attribute}`;
        table.insert(v12, v15);
    end;

    table.insert(v12, "Minigame");

    for _, v in v12 do
        if u1[v] ~= nil then
            return v;
        end;
    end;

    return "Default";
end;

local u16 = nil;
local u17 = {};

function UpdateBiome()
    -- upvalues: gameSettings (copy), ResolveMinigameBiome (copy), LocalPlayer (copy), u1 (copy), valuesfolder (copy), u16 (ref), GetInstanceChain (copy), u17 (copy), ResolveProperties (copy)
    local v18 = not gameSettings.IsMinigame and "Default" or ResolveMinigameBiome();
    local Character = LocalPlayer.Character;
    local v19 = Character ~= nil and (Character:GetAttribute("InMuzanLair") == true and u1.MuzanLair ~= nil) and "MuzanLair" or v18;
    local Training = valuesfolder:FindFirstChild("Training");
    local v20;

    if Training == nil then
        v20 = v19;
    else
        v20 = Training:GetAttribute("Type");

        if not u1[v20] then
            v20 = v19;
        end;
    end;

    if u16 ~= v20 then
        local v21 = u16;
        u16 = v20;

        if v21 and (u1[v21] and u1[v21].Stop) then
            u1[v21].Stop();
        end;

        local v22 = GetInstanceChain(v20);
        local v23 = {};

        for _, v in ipairs(v22) do
            v23[v] = true;
        end;

        if v21 == nil then
            for _, v in ipairs(game.Lighting:QueryDescendants("BloomEffect,ColorCorrectionEffect,SunRaysEffect,Atmosphere,Sky,DepthOfFieldEffect")) do
                v:Destroy();
            end;
        end;

        for i, v in pairs(u17) do
            if not v23[i] then
                for _, v2 in ipairs(v) do
                    v2:Destroy();
                end;

                u17[i] = nil;
            end;
        end;

        for _, v in ipairs(v22) do
            if not u17[v] then
                local v24 = u1[v];
                local v25 = {};
                local v26;

                if v24.Instances then
                    v26 = v;

                    for _, v2 in ipairs(v24.Instances) do
                        local v27 = v2:Clone();
                        v27.Parent = game.Lighting;
                        table.insert(v25, v27);
                    end;
                else
                    v26 = v;
                end;

                u17[v26] = v25;
            end;
        end;

        local v28 = ResolveProperties(v20);

        for i, v in pairs(v28) do
            game.Lighting[i] = v;
        end;

        local v29 = u1[v20];

        if v29.Do then
            v29.Do(v21);
        end;
    end;
end;

UpdateBiome();
local u30 = {
    Training = true
};
valuesfolder.ChildAdded:Connect(function(p31: userdata) -- Line: 165
    -- upvalues: u30 (copy)
    if u30[p31.Name] then
        UpdateBiome();
    end;
end);
valuesfolder.ChildRemoved:Connect(function(p32: userdata) -- Line: 170
    -- upvalues: u30 (copy)
    if u30[p32.Name] then
        UpdateBiome();
    end;
end);

if gameSettings.IsMinigame then
    for _, v in { "MinigameKey", "MinigameState", "MinigameMap" } do
        workspace:GetAttributeChangedSignal(v):Connect(UpdateBiome);
    end;
end;

local function hookCharacter(p33: userdata) -- Line: 187
    p33:GetAttributeChangedSignal("InMuzanLair"):Connect(UpdateBiome);
    UpdateBiome();
end;

if LocalPlayer.Character ~= nil then
    LocalPlayer.Character:GetAttributeChangedSignal("InMuzanLair"):Connect(UpdateBiome);
    UpdateBiome();
end;

LocalPlayer.CharacterAdded:Connect(hookCharacter);