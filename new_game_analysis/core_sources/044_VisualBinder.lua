-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local TweenInfo_new_ret = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local ItemModels = require(ReplicatedStorage.CAM.Global.Collectibles.ItemModels);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local ClientEffects = ReplicatedStorage.Communication.CnC.ClientEffects;

local function resolveItemModel(p1: string) -- Line: 44
    -- upvalues: ItemModels (copy)
    local v2 = ItemModels.Get(p1, "UnEquipped");

    if v2 == nil or not v2:IsA("Model") then
        return nil;
    end;

    return v2;
end;

local Drops_VFX = ReplicatedStorage.Assets.Drops_VFX;

local function snapshotAppearance(p3: userdata) -- Line: 59
    local v4 = {};

    for _, v in p3:QueryDescendants("BasePart") do
        v4[v] = {
            transparency = v.Transparency,
            color = v.Color
        };
    end;

    return v4;
end;

local function applyGreyscale(p5: userdata) -- Line: 67
    for _, v in p5:QueryDescendants("BasePart") do
        v.Transparency = math.clamp(v.Transparency + 0.35, 0, 1);
        v.Color = Color3.fromRGB(140, 140, 140);
    end;
end;

local function restoreAppearance(p6: table) -- Line: 74
    for i, v in p6 do
        if i.Parent then
            i.Transparency = v.transparency;
            i.Color = v.color;
        end;
    end;
end;

local function isHiddenFromLocal(p7: userdata) -- Line: 86
    -- upvalues: LocalPlayer (copy)
    if p7:GetAttribute("DropPrivate") ~= true then
        return false;
    end;

    local Attribute = p7:GetAttribute("DropOwnerUserId");
    local v8;

    if typeof(Attribute) == "number" then
        v8 = Attribute ~= LocalPlayer.UserId;
    else
        v8 = false;
    end;

    return v8;
end;

local function isEligible(p9: userdata) -- Line: 94
    -- upvalues: LocalPlayer (copy)
    local Attribute = p9:GetAttribute("DropOwnerUserId");

    if typeof(Attribute) == "number" and Attribute ~= LocalPlayer.UserId then
        return false;
    end;

    local Attribute2 = p9:GetAttribute("DropReservedFor");

    return (typeof(Attribute2) ~= "string" or string.find(Attribute2, "," .. LocalPlayer.UserId .. ",", 1, true)) and true or false;
end;

local u10 = {};
local u11 = nil;

local function step(p12: number) -- Line: 134
    -- upvalues: LocalPlayer (copy), u10 (copy), Workspace (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:GetPivot().Position;
    end;

    for i, v in u10 do
        if v.phase == "flight" then
            v.elapsed = math.min(v.elapsed + p12, v.duration);
            v.spin = v.spin + p12 * 4;
            local v13 = v.startPosition:Lerp(v.restPosition, v.elapsed / v.duration);
            local v14 = v.startPosition.Y + v.verticalVelocity * v.elapsed - Workspace.Gravity * v.elapsed * v.elapsed * 0.5;

            if v.model then
                v.model:PivotTo(CFrame.new(v13.X, v14, v13.Z) * CFrame.Angles(0, v.spin, 0) * v.baseRotation);
            end;

            if v.elapsed >= v.duration then
                v.phase = "idle";

                if v.vfx then
                    v.vfx.Parent = i;
                end;

                if v.prompt then
                    v.prompt.Enabled = v.canClaim;
                end;
            end;
        elseif v.model ~= nil and (not Character or (Character - v.restPosition).Magnitude <= 150) then
            v.spin = v.spin + p12 * 2.5;
            v.model:PivotTo(CFrame.new(v.restPosition) * CFrame.Angles(0, v.spin, 0) * v.baseRotation);
        end;
    end;
end;

local function syncEligibility(p15: table, p16: userdata) -- Line: 176
    -- upvalues: isEligible (copy), applyGreyscale (copy), vfxUtility (copy)
    local v17 = isEligible(p16);

    if v17 == p15.canClaim then
        return;
    end;

    p15.canClaim = v17;

    if v17 then
        for i, v in p15.appearance do
            if i.Parent then
                i.Transparency = v.transparency;
                i.Color = v.color;
            end;
        end;
    elseif p15.model then
        applyGreyscale(p15.model);
    end;

    if p15.vfx then
        vfxUtility.EnableAll(p15.vfx, v17);
    end;

    if p15.prompt and p15.phase == "idle" then
        p15.prompt.Enabled = v17;
    end;
end;

local function retire(p18: userdata, p19: number?) -- Line: 198
    -- upvalues: u10 (copy), u11 (ref), Workspace (copy), vfxUtility (copy), DebrisModule (copy), TweenService (copy), TweenInfo_new_ret (copy), LocalPlayer (copy), ClientEffects (copy)
    local v20 = u10[p18];

    if not v20 then
        return;
    end;

    if v20.attrConn then
        v20.attrConn:Disconnect();
    end;

    u10[p18] = nil;

    if u11 and next(u10) == nil then
        u11:Disconnect();
        u11 = nil;
    end;

    if v20.vfx then
        if v20.vfx.Parent == nil then
            v20.vfx:Destroy();
        else
            v20.vfx.Parent = Workspace.Debree;
            vfxUtility.EnableAll(v20.vfx, false);
            DebrisModule:AddItem(v20.vfx, 1.3);
        end;
    end;

    if v20.model then
        v20.model.Parent = Workspace.Debree;

        for _, v in v20.model:QueryDescendants("BasePart") do
            TweenService:Create(v, TweenInfo_new_ret, {
                Transparency = 1
            }):Play();
        end;

        DebrisModule:AddItem(v20.model, 0.35);
    end;

    if p19 == LocalPlayer.UserId then
        ClientEffects:Fire("QuestPickup", v20.restPosition);
    end;
end;

local u44 = {
    cleanup = function(p21: userdata) -- Line: 241, Name: cleanup
        -- upvalues: retire (copy)
        retire(p21, nil);
    end,

    attach = function(u22: userdata) -- Line: 245, Name: attach
        -- upvalues: u10 (copy), LocalPlayer (copy), Items (copy), Rarities (copy), Drops_VFX (copy), ItemModels (copy), isEligible (copy), vfxUtility (copy), snapshotAppearance (copy), Workspace (copy), applyGreyscale (copy), retire (copy), syncEligibility (copy), u11 (ref), RunService (copy), step (copy)
        if u10[u22] then
            return;
        end;

        local v23;

        if u22:GetAttribute("DropPrivate") == true then
            local Attribute = u22:GetAttribute("DropOwnerUserId");

            if typeof(Attribute) == "number" then
                v23 = Attribute ~= LocalPlayer.UserId;
            else
                v23 = false;
            end;
        else
            v23 = false;
        end;

        if v23 then
            local v24 = u22:FindFirstChildWhichIsA("ProximityPrompt");

            if v24 then
                v24.Enabled = false;
            end;

            return;
        end;

        local v25 = u22:GetAttribute("DropItemId") or "Loot";
        local v26 = tostring(v25);
        local v27 = u22:GetAttribute("DropStart") or u22.Position;
        local v28 = u22:GetAttribute("DropTarget") or u22.Position;
        local v29 = u22:GetAttribute("DropFlightTime") or 1;
        local math_max_ret = math.max(v29, 0.1);
        local v30 = v28.Y - u22.Size.Y * 0.5;
        local v31 = Items[v26];
        local v32 = Rarities.Order[v31 and v31.Rarity or 1];
        local v33 = Drops_VFX:FindFirstChild(v32);
        local v34 = nil;

        if v33 and v33:IsA("BasePart") then
            v34 = v33:Clone();
            v34.Anchored = true;
            v34.CanCollide = false;
            v34.CanTouch = false;
            v34.CanQuery = false;
            v34.Massless = true;
            v34.CFrame = CFrame.new(v28.X, v30 + v34.Size.Y * 0.5, v28.Z);
        else
            warn((`Loot drop rarity VFX '{v32}' missing from Assets.Drops_VFX`));
        end;

        local v35 = ItemModels.Get(v26, "UnEquipped");

        if v35 == nil or not v35:IsA("Model") then
            v35 = nil;
        end;

        local CFrame_identity = CFrame.identity;
        local Vector3_new_ret = Vector3.new(v28.X, v30, v28.Z);
        local v36;

        if v35 then
            v36 = v35:Clone();
            local _, v37 = v36:GetBoundingBox();
            local math_max_ret2 = math.max(v37.X, v37.Y, v37.Z);

            if math_max_ret2 > 0 then
                v36:ScaleTo(v36:GetScale() * 2 / math_max_ret2);
            end;

            for _, v in v36:QueryDescendants("BasePart") do
                v.Anchored = true;
                v.CanCollide = false;
                v.CanTouch = false;
                v.CanQuery = false;
            end;

            local BoundingBox, v38 = v36:GetBoundingBox();
            v36.PrimaryPart = nil;
            v36.WorldPivot = BoundingBox;
            CFrame_identity = BoundingBox.Rotation;
            local v39 = (math.abs(CFrame_identity.XVector.Y) * v38.X + math.abs(CFrame_identity.YVector.Y) * v38.Y + math.abs(CFrame_identity.ZVector.Y) * v38.Z) * 0.5;
            Vector3_new_ret = Vector3.new(v28.X, v30 + v39, v28.Z);
            v36:PivotTo(CFrame.new(v27) * CFrame_identity);
            v36.Parent = u22;
        else
            v36 = nil;
        end;

        local v40 = isEligible(u22);

        if not v40 and v34 then
            vfxUtility.EnableAll(v34, false);
        end;

        local v41 = u22:FindFirstChildWhichIsA("ProximityPrompt");

        if v41 then
            v41.Enabled = false;
        end;

        local u42 = {
            elapsed = 0,
            phase = "flight",
            attrConn = nil,
            model = v36,
            vfx = v34,
            prompt = v41,
            appearance = not v36 and {} or snapshotAppearance(v36),
            canClaim = v40,
            baseRotation = CFrame_identity,
            startPosition = v27,
            restPosition = Vector3_new_ret,
            verticalVelocity = (Vector3_new_ret.Y - v27.Y) / math_max_ret + Workspace.Gravity * math_max_ret * 0.5,
            duration = math_max_ret,
            spin = math.random() * 3.141592653589793 * 2
        };
        u10[u22] = u42;

        if not v40 and v36 then
            applyGreyscale(v36);
        end;

        u42.attrConn = u22.AttributeChanged:Connect(function(p43: string) -- Line: 377
            -- upvalues: retire (ref), u22 (copy), syncEligibility (ref), u42 (copy)
            if p43 == "DropClaimedBy" then
                retire(u22, (u22:GetAttribute("DropClaimedBy")));

                return;
            end;

            if p43 == "DropOwnerUserId" or p43 == "DropReservedFor" then
                syncEligibility(u42, u22);
            end;
        end);

        if not u11 then
            u11 = RunService.Heartbeat:Connect(step);
        end;
    end
};

function u44.teardown() -- Line: 390
    -- upvalues: u10 (copy), u44 (copy)
    for i in u10 do
        u44.cleanup(i);
    end;
end;

return u44;