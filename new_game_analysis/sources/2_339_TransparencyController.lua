-- Decompiled with Potassium's decompiler.

local VRService = game:GetService("VRService");
local u1 = { "BasePart", "Decal", "Beam", "ParticleEmitter", "Trail", "Fire", "Smoke", "Sparkles", "Explosion" };
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 29
    -- upvalues: u2 (copy)
    local v3 = setmetatable({}, u2);
    v3.transparencyDirty = false;
    v3.enabled = false;
    v3.lastTransparency = nil;
    v3.descendantAddedConn = nil;
    v3.descendantRemovingConn = nil;
    v3.toolDescendantAddedConns = {};
    v3.toolDescendantRemovingConns = {};
    v3.cachedParts = {};

    return v3;
end;

function u2.HasToolAncestor(p4: table, p5: userdata) -- Line: 45
    if p5.Parent == nil then
        return false;
    end;

    assert(p5.Parent, "");

    return p5.Parent:IsA("Tool") or p4:HasToolAncestor(p5.Parent);
end;

function u2.IsValidPartToModify(p6: table, p7: userdata) -- Line: 51
    -- upvalues: u1 (copy)
    for _, v in u1 do
        if p7:IsA(v) then
            return not p6:HasToolAncestor(p7);
        end;
    end;

    return false;
end;

function u2.CachePartsRecursive(p8, p9) -- Line: 61
    if p9 then
        if p8:IsValidPartToModify(p9) then
            p8.cachedParts[p9] = true;
            p8.transparencyDirty = true;
        end;

        for _, child in pairs(p9:GetChildren()) do
            p8:CachePartsRecursive(child);
        end;
    end;
end;

function u2.TeardownTransparency(p10) -- Line: 73
    for i, _ in pairs(p10.cachedParts) do
        i.LocalTransparencyModifier = 0;
    end;

    p10.cachedParts = {};
    p10.transparencyDirty = true;
    p10.lastTransparency = nil;

    if p10.descendantAddedConn then
        p10.descendantAddedConn:disconnect();
        p10.descendantAddedConn = nil;
    end;

    if p10.descendantRemovingConn then
        p10.descendantRemovingConn:disconnect();
        p10.descendantRemovingConn = nil;
    end;

    for i, v in pairs(p10.toolDescendantAddedConns) do
        v:Disconnect();
        p10.toolDescendantAddedConns[i] = nil;
    end;

    for i, v in pairs(p10.toolDescendantRemovingConns) do
        v:Disconnect();
        p10.toolDescendantRemovingConns[i] = nil;
    end;
end;

function u2.SetupTransparency(u11, u12) -- Line: 99
    u11:TeardownTransparency();

    if u11.descendantAddedConn then
        u11.descendantAddedConn:disconnect();
    end;

    u11.descendantAddedConn = u12.DescendantAdded:Connect(function(p13) -- Line: 103
        -- upvalues: u11 (copy), u12 (copy)
        if not u11:IsValidPartToModify(p13) then
            if p13:IsA("Tool") then
                if u11.toolDescendantAddedConns[p13] then
                    u11.toolDescendantAddedConns[p13]:Disconnect();
                end;

                u11.toolDescendantAddedConns[p13] = p13.DescendantAdded:Connect(function(p14) -- Line: 111
                    -- upvalues: u11 (ref)
                    u11.cachedParts[p14] = nil;

                    if p14:IsA("BasePart") or p14:IsA("Decal") then
                        p14.LocalTransparencyModifier = 0;
                    end;
                end);

                if u11.toolDescendantRemovingConns[p13] then
                    u11.toolDescendantRemovingConns[p13]:disconnect();
                end;

                u11.toolDescendantRemovingConns[p13] = p13.DescendantRemoving:Connect(function(p15) -- Line: 119
                    -- upvalues: u12 (ref), u11 (ref)
                    wait();

                    if u12 and (p15 and (p15:IsDescendantOf(u12) and u11:IsValidPartToModify(p15))) then
                        u11.cachedParts[p15] = true;
                        u11.transparencyDirty = true;
                    end;
                end);
            end;

            return;
        end;

        u11.cachedParts[p13] = true;
        u11.transparencyDirty = true;
    end);

    if u11.descendantRemovingConn then
        u11.descendantRemovingConn:disconnect();
    end;

    u11.descendantRemovingConn = u12.DescendantRemoving:connect(function(p16) -- Line: 131
        -- upvalues: u11 (copy)
        if u11.cachedParts[p16] then
            u11.cachedParts[p16] = nil;
            p16.LocalTransparencyModifier = 0;
        end;
    end);
    u11:CachePartsRecursive(u12);
end;

function u2.Enable(p17: table, p18: boolean) -- Line: 142
    if p17.enabled ~= p18 then
        p17.enabled = p18;
    end;
end;

function u2.SetSubject(p19, p20) -- Line: 148
    local v21;

    if p20 and p20:IsA("Humanoid") then
        v21 = p20.Parent;
    else
        v21 = nil;
    end;

    if p20 and (p20:IsA("VehicleSeat") and p20.Occupant) then
        v21 = p20.Occupant.Parent;
    end;

    if v21 then
        p19:SetupTransparency(v21);

        return;
    end;

    p19:TeardownTransparency();
end;

function u2.Update(p22, p23) -- Line: 163
    -- upvalues: CameraUtils (copy), VRService (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera and p22.enabled then
        local magnitude = (workspace_CurrentCamera.Focus.Position - workspace_CurrentCamera.CoordinateFrame.Position).magnitude;
        local v24 = magnitude < 2 and 1 - (magnitude - 0.5) / 1.5 or 0;
        local v25 = v24 < 0.5 and 0 or v24;

        if p22.lastTransparency and (v25 < 1 and p22.lastTransparency < 0.95) then
            local v26 = 2.8 * p23;
            local math_clamp_ret = math.clamp(v25 - p22.lastTransparency, -v26, v26);
            v25 = p22.lastTransparency + math_clamp_ret;
        else
            p22.transparencyDirty = true;
        end;

        local v27 = CameraUtils.Round(v25, 2);
        local math_clamp_ret = math.clamp(v27, 0, 1);

        if p22.transparencyDirty or p22.lastTransparency ~= math_clamp_ret then
            for i, _ in pairs(p22.cachedParts) do
                if VRService.VREnabled and VRService.AvatarGestures then
                    local v28 = {
                        [Enum.AccessoryType.Hat] = true,
                        [Enum.AccessoryType.Hair] = true,
                        [Enum.AccessoryType.Face] = true,
                        [Enum.AccessoryType.Eyebrow] = true,
                        [Enum.AccessoryType.Eyelash] = true
                    };

                    if i.Parent:IsA("Accessory") and v28[i.Parent.AccessoryType] or i.Name == "Head" then
                        i.LocalTransparencyModifier = math_clamp_ret;
                    else
                        i.LocalTransparencyModifier = 0;
                    end;
                else
                    i.LocalTransparencyModifier = math_clamp_ret;
                end;
            end;

            p22.transparencyDirty = false;
            p22.lastTransparency = math_clamp_ret;
        end;
    end;
end;

return u2;