-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Lighting = game:GetService("Lighting");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local workspace_Terrain = workspace.Terrain;
local LocalPlayer = Players.LocalPlayer;
local u1 = false;
local u2 = {};
local u3 = setmetatable({}, {
    __mode = "k"
});
local u4 = setmetatable({}, {
    __mode = "k"
});
local u5 = setmetatable({}, {
    __mode = "k"
});
local u6 = setmetatable({}, {
    __mode = "k"
});
local u7 = setmetatable({}, {
    __mode = "k"
});
local u8 = UserInputService.TouchEnabled or GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled;
local u9 = {};

local function isTreeObject(p10) -- Line: 24
    if not p10 then
        return false;
    end;

    if p10.Parent == workspace and (p10:IsA("Folder") and string.upper(p10.Name) == "TREE") then
        return true;
    end;

    local v11 = p10:IsA("Model") and string.lower(p10.Name) == "tree";

    return v11;
end;

local function detachTreeObject(p12) -- Line: 32
    -- upvalues: u8 (copy), u9 (copy)
    if not (u8 and (p12 and (p12.Parent and u9[p12] == nil))) then
        return;
    end;

    u9[p12] = p12.Parent;
    p12.Parent = nil;
end;

local function detachMobileTrees() -- Line: 40
    -- upvalues: u8 (copy), u9 (copy), isTreeObject (copy)
    if not u8 then
        return;
    end;

    local TREE = workspace:FindFirstChild("TREE");

    if TREE and (u8 and (TREE and (TREE.Parent and u9[TREE] == nil))) then
        u9[TREE] = TREE.Parent;
        TREE.Parent = nil;
    end;

    for _, descendant in ipairs(workspace:GetDescendants()) do
        if isTreeObject(descendant) and (u8 and (descendant and descendant.Parent)) then
            if u9[descendant] == nil then
                u9[descendant] = descendant.Parent;
                descendant.Parent = nil;
            end;
        end;
    end;
end;

local function restoreMobileTrees() -- Line: 55
    -- upvalues: u9 (copy)
    for i, v in pairs(u9) do
        if i and (v and v.Parent) then
            i.Parent = v;
        end;

        u9[i] = nil;
    end;
end;

local function capture(u13, u14, p15) -- Line: 64
    -- upvalues: u2 (copy)
    local success, result = pcall(function() -- Line: 65
        -- upvalues: u13 (copy), u14 (copy)
        return u13[u14];
    end);

    if success then
        u2[p15 or u14] = result;
    end;
end;

local function restore(u16, u17, p18) -- Line: 73
    -- upvalues: u2 (copy)
    local u19 = u2[p18 or u17];

    if u19 ~= nil then
        pcall(function() -- Line: 76
            -- upvalues: u16 (copy), u17 (copy), u19 (copy)
            u16[u17] = u19;
        end);
    end;
end;

local function captureWorldState() -- Line: 82
    -- upvalues: u2 (copy), Lighting (copy), workspace_Terrain (copy)
    table.clear(u2);
    local u20 = Lighting;
    local u21 = "GlobalShadows";
    local success, result = pcall(function() -- Line: 65
        -- upvalues: u20 (copy), u21 (copy)
        return u20[u21];
    end);

    if success then
        u2.GlobalShadows = result;
    end;

    local u22 = Lighting;
    local u23 = "ShadowSoftness";
    local success2, result2 = pcall(function() -- Line: 65
        -- upvalues: u22 (copy), u23 (copy)
        return u22[u23];
    end);

    if success2 then
        u2.ShadowSoftness = result2;
    end;

    local u24 = Lighting;
    local u25 = "EnvironmentDiffuseScale";
    local success3, result3 = pcall(function() -- Line: 65
        -- upvalues: u24 (copy), u25 (copy)
        return u24[u25];
    end);

    if success3 then
        u2.EnvironmentDiffuseScale = result3;
    end;

    local u26 = Lighting;
    local u27 = "EnvironmentSpecularScale";
    local success4, result4 = pcall(function() -- Line: 65
        -- upvalues: u26 (copy), u27 (copy)
        return u26[u27];
    end);

    if success4 then
        u2.EnvironmentSpecularScale = result4;
    end;

    local u28 = workspace_Terrain;
    local u29 = "Decoration";
    local success5, result5 = pcall(function() -- Line: 65
        -- upvalues: u28 (copy), u29 (copy)
        return u28[u29];
    end);

    if success5 then
        u2.TerrainDecoration = result5;
    end;

    local u30 = workspace_Terrain;
    local u31 = "WaterWaveSize";
    local success6, result6 = pcall(function() -- Line: 65
        -- upvalues: u30 (copy), u31 (copy)
        return u30[u31];
    end);

    if success6 then
        u2.TerrainWaterWaveSize = result6;
    end;

    local u32 = workspace_Terrain;
    local u33 = "WaterWaveSpeed";
    local success7, result7 = pcall(function() -- Line: 65
        -- upvalues: u32 (copy), u33 (copy)
        return u32[u33];
    end);

    if success7 then
        u2.TerrainWaterWaveSpeed = result7;
    end;

    local u34 = workspace_Terrain;
    local u35 = "WaterReflectance";
    local success8, result8 = pcall(function() -- Line: 65
        -- upvalues: u34 (copy), u35 (copy)
        return u34[u35];
    end);

    if success8 then
        u2.TerrainWaterReflectance = result8;
    end;

    pcall(function() -- Line: 92
        -- upvalues: u2 (ref)
        u2.QualityLevel = settings().Rendering.QualityLevel;
    end);
end;

local function reduceInstance(u36) -- Line: 97
    -- upvalues: u3 (copy), u5 (copy), u7 (copy), u4 (copy), u6 (copy)
    if u36:GetAttribute("KeepInLowGraphics") == true then
        return;
    end;

    if u36:IsA("PostEffect") or u36:IsA("Clouds") then
        if u3[u36] == nil then
            u3[u36] = u36.Enabled;
        end;

        u36.Enabled = false;

        return;
    end;

    if u36:IsA("ParticleEmitter") or (u36:IsA("Beam") or (u36:IsA("Trail") or (u36:IsA("Smoke") or (u36:IsA("Fire") or (u36:IsA("Sparkles") or (u36:IsA("PointLight") or (u36:IsA("SpotLight") or u36:IsA("SurfaceLight")))))))) then
        if u5[u36] == nil then
            u5[u36] = u36.Enabled;
        end;

        u36.Enabled = false;

        return;
    end;

    if u36:IsA("Atmosphere") then
        if u7[u36] == nil then
            u7[u36] = {
                Density = u36.Density,
                Haze = u36.Haze,
                Glare = u36.Glare
            };
        end;

        u36.Density = 0;
        u36.Haze = 0;
        u36.Glare = 0;

        return;
    end;

    if not u36:IsA("MeshPart") then
        if u36:IsA("BasePart") then
            if u4[u36] == nil then
                u4[u36] = u36.CastShadow;
            end;

            u36.CastShadow = false;
        end;

        return;
    end;

    if u4[u36] == nil then
        u4[u36] = u36.CastShadow;
    end;

    u36.CastShadow = false;

    if u6[u36] == nil then
        u6[u36] = u36.RenderFidelity;
    end;

    pcall(function() -- Line: 140
        -- upvalues: u36 (copy)
        u36.RenderFidelity = Enum.RenderFidelity.Performance;
    end);
end;

local function reduceWorld() -- Line: 151
    -- upvalues: Lighting (copy), workspace_Terrain (copy), u8 (copy), reduceInstance (copy), detachMobileTrees (copy)
    Lighting.GlobalShadows = false;
    Lighting.ShadowSoftness = 0;
    pcall(function() -- Line: 154
        -- upvalues: Lighting (ref)
        Lighting.EnvironmentDiffuseScale = 0;
        Lighting.EnvironmentSpecularScale = 0;
    end);
    pcall(function() -- Line: 158
        -- upvalues: workspace_Terrain (ref)
        workspace_Terrain.Decoration = false;
        workspace_Terrain.WaterWaveSize = 0;
        workspace_Terrain.WaterWaveSpeed = 0;
        workspace_Terrain.WaterReflectance = 0;
    end);
    pcall(function() -- Line: 164
        -- upvalues: u8 (ref)
        settings().Rendering.QualityLevel = u8 and Enum.QualityLevel.Level01 or Enum.QualityLevel.Level02;
    end);

    for _, descendant in ipairs(Lighting:GetDescendants()) do
        reduceInstance(descendant);
    end;

    for _, descendant in ipairs(workspace_Terrain:GetDescendants()) do
        reduceInstance(descendant);
    end;

    for _, descendant in ipairs(workspace:GetDescendants()) do
        reduceInstance(descendant);
    end;

    if u8 then
        detachMobileTrees();
    end;
end;

local function restoreWorld() -- Line: 189
    -- upvalues: Lighting (copy), u2 (copy), workspace_Terrain (copy), u3 (copy), u5 (copy), u7 (copy), u4 (copy), u6 (copy), u9 (copy)
    local u37 = Lighting;
    local GlobalShadows = u2.GlobalShadows;

    if GlobalShadows ~= nil then
        local u38 = "GlobalShadows";
        pcall(function() -- Line: 76
            -- upvalues: u37 (copy), u38 (copy), GlobalShadows (copy)
            u37[u38] = GlobalShadows;
        end);
    end;

    local u39 = Lighting;
    local ShadowSoftness = u2.ShadowSoftness;

    if ShadowSoftness ~= nil then
        local u40 = "ShadowSoftness";
        pcall(function() -- Line: 76
            -- upvalues: u39 (copy), u40 (copy), ShadowSoftness (copy)
            u39[u40] = ShadowSoftness;
        end);
    end;

    local u41 = Lighting;
    local EnvironmentDiffuseScale = u2.EnvironmentDiffuseScale;

    if EnvironmentDiffuseScale ~= nil then
        local u42 = "EnvironmentDiffuseScale";
        pcall(function() -- Line: 76
            -- upvalues: u41 (copy), u42 (copy), EnvironmentDiffuseScale (copy)
            u41[u42] = EnvironmentDiffuseScale;
        end);
    end;

    local u43 = Lighting;
    local EnvironmentSpecularScale = u2.EnvironmentSpecularScale;

    if EnvironmentSpecularScale ~= nil then
        local u44 = "EnvironmentSpecularScale";
        pcall(function() -- Line: 76
            -- upvalues: u43 (copy), u44 (copy), EnvironmentSpecularScale (copy)
            u43[u44] = EnvironmentSpecularScale;
        end);
    end;

    local u45 = workspace_Terrain;
    local TerrainDecoration = u2.TerrainDecoration;

    if TerrainDecoration ~= nil then
        local u46 = "Decoration";
        pcall(function() -- Line: 76
            -- upvalues: u45 (copy), u46 (copy), TerrainDecoration (copy)
            u45[u46] = TerrainDecoration;
        end);
    end;

    local u47 = workspace_Terrain;
    local TerrainWaterWaveSize = u2.TerrainWaterWaveSize;

    if TerrainWaterWaveSize ~= nil then
        local u48 = "WaterWaveSize";
        pcall(function() -- Line: 76
            -- upvalues: u47 (copy), u48 (copy), TerrainWaterWaveSize (copy)
            u47[u48] = TerrainWaterWaveSize;
        end);
    end;

    local u49 = workspace_Terrain;
    local TerrainWaterWaveSpeed = u2.TerrainWaterWaveSpeed;

    if TerrainWaterWaveSpeed ~= nil then
        local u50 = "WaterWaveSpeed";
        pcall(function() -- Line: 76
            -- upvalues: u49 (copy), u50 (copy), TerrainWaterWaveSpeed (copy)
            u49[u50] = TerrainWaterWaveSpeed;
        end);
    end;

    local u51 = workspace_Terrain;
    local TerrainWaterReflectance = u2.TerrainWaterReflectance;

    if TerrainWaterReflectance ~= nil then
        local u52 = "WaterReflectance";
        pcall(function() -- Line: 76
            -- upvalues: u51 (copy), u52 (copy), TerrainWaterReflectance (copy)
            u51[u52] = TerrainWaterReflectance;
        end);
    end;

    if u2.QualityLevel ~= nil then
        pcall(function() -- Line: 199
            -- upvalues: u2 (ref)
            settings().Rendering.QualityLevel = u2.QualityLevel;
        end);
    end;

    for i, v in pairs(u3) do
        if i and i.Parent then
            pcall(function() -- Line: 206
                -- upvalues: i (copy), v (copy)
                i.Enabled = v;
            end);
        end;
    end;

    for i, v in pairs(u5) do
        if i and i.Parent then
            pcall(function() -- Line: 213
                -- upvalues: i (copy), v (copy)
                i.Enabled = v;
            end);
        end;
    end;

    for i, v in pairs(u7) do
        if i and i.Parent then
            i.Density = v.Density;
            i.Haze = v.Haze;
            i.Glare = v.Glare;
        end;
    end;

    for i, v in pairs(u4) do
        if i and i.Parent then
            i.CastShadow = v;
        end;
    end;

    for i, v in pairs(u6) do
        if i and i.Parent then
            pcall(function() -- Line: 232
                -- upvalues: i (copy), v (copy)
                i.RenderFidelity = v;
            end);
        end;
    end;

    table.clear(u3);
    table.clear(u5);
    table.clear(u7);
    table.clear(u4);
    table.clear(u6);
    table.clear(u2);

    for i, v in pairs(u9) do
        if i and (v and v.Parent) then
            i.Parent = v;
        end;

        u9[i] = nil;
    end;
end;

local function enableLowMode() -- Line: 247
    -- upvalues: u1 (ref), captureWorldState (copy), reduceWorld (copy)
    if u1 then
        return;
    end;

    u1 = true;
    captureWorldState();
    reduceWorld();
end;

local function disableLowMode() -- Line: 256
    -- upvalues: u1 (ref), restoreWorld (copy)
    if not u1 then
        return;
    end;

    u1 = false;
    restoreWorld();
end;

local function applyLowGraphicsSetting() -- Line: 264
    -- upvalues: LocalPlayer (copy), u1 (ref), captureWorldState (copy), reduceWorld (copy), restoreWorld (copy)
    if LocalPlayer:GetAttribute("LowGraphicsEnabled") ~= true then
        if not u1 then
            return;
        end;

        u1 = false;
        restoreWorld();

        return;
    end;

    if u1 then
        return;
    end;

    u1 = true;
    captureWorldState();
    reduceWorld();
end;

workspace.DescendantAdded:Connect(function(p53) -- Line: 272
    -- upvalues: u1 (ref), reduceInstance (copy), u8 (copy), isTreeObject (copy), detachTreeObject (copy)
    if u1 then
        reduceInstance(p53);

        if u8 and isTreeObject(p53) then
            task.defer(detachTreeObject, p53);
        end;
    end;
end);
Lighting.DescendantAdded:Connect(function(p54) -- Line: 281
    -- upvalues: u1 (ref), reduceInstance (copy)
    if u1 then
        reduceInstance(p54);
    end;
end);
workspace_Terrain.DescendantAdded:Connect(function(p55) -- Line: 287
    -- upvalues: u1 (ref), reduceInstance (copy)
    if u1 then
        reduceInstance(p55);
    end;
end);

if LocalPlayer:GetAttribute("LowGraphicsEnabled") == nil then
    LocalPlayer:SetAttribute("LowGraphicsEnabled", u8);
elseif u8 then
    LocalPlayer:SetAttribute("LowGraphicsEnabled", true);
end;

LocalPlayer:GetAttributeChangedSignal("LowGraphicsEnabled"):Connect(applyLowGraphicsSetting);

if LocalPlayer:GetAttribute("LowGraphicsEnabled") == true then
    if not u1 then
        u1 = true;
        captureWorldState();
        reduceWorld();
    end;
elseif u1 then
    u1 = false;
    restoreWorld();
end;