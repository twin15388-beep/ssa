-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local ChestAssets = require(script.Parent.ChestAssets);
local u1 = {};
local u2 = {};

local function place(p3: userdata, p4: table) -- Line: 26
    -- upvalues: vfxUtility (copy), ChestAssets (copy)
    local BoundingBox, v5 = p3:GetBoundingBox();
    local Attribute = p3:GetAttribute("SealEffect");
    local v6 = vfxUtility.cloneAsset(ChestAssets.EffectFolder, p3, typeof(Attribute) ~= "string" and "SealVFX" or Attribute);
    p4.seal = v6;

    if v6 == nil then
        return;
    end;

    local Pivot = v6:GetPivot();
    local Vector3_new_ret = Vector3.new(BoundingBox.Position.X, BoundingBox.Position.Y - v5.Y / 2, BoundingBox.Position.Z);
    local Attribute2 = p3:GetAttribute("SpawnOffset");

    if typeof(Attribute2) == "Vector3" then
        Vector3_new_ret = Vector3_new_ret - p3:GetPivot().Rotation * Attribute2;
    end;

    v6:PivotTo(Pivot + (Vector3_new_ret - Pivot.Position));
end;

local function sync(p7: userdata, p8: table) -- Line: 52
    -- upvalues: place (copy), vfxUtility (copy), ChestAssets (copy)
    local v9 = p7:GetAttribute("ChestState") == "Locked";
    local sealed = p8.sealed;

    if v9 and p8.seal == nil then
        place(p7, p8);
    end;

    if p8.seal then
        vfxUtility.EnableAll(p8.seal, v9);

        for _, v in p8.seal:QueryDescendants("Light") do
            v.Enabled = v9;
        end;
    end;

    p8.sealed = v9;

    if sealed == true and not v9 then
        ChestAssets.play(p8.breakSound);
        ChestAssets.burst(p7, "SealBreakEffect");
    end;
end;

function u1.track(u10: userdata) -- Line: 75
    -- upvalues: u2 (copy), sync (copy), ChestAssets (copy), u1 (copy)
    local v11 = u2[u10];

    if v11 then
        sync(u10, v11);

        return;
    end;

    local u12 = {
        seal = nil,
        sealed = nil,
        breakSound = ChestAssets.sound(u10, "SealBreakSound"),
        conns = {}
    };
    u2[u10] = u12;
    sync(u10, u12);
    local conns = u12.conns;
    local AttributeChangedSignal = u10:GetAttributeChangedSignal("ChestState");
    table.insert(conns, AttributeChangedSignal:Connect(function() -- Line: 90
        -- upvalues: sync (ref), u10 (copy), u12 (copy)
        sync(u10, u12);
    end));
    table.insert(u12.conns, u10.Destroying:Connect(function() -- Line: 94
        -- upvalues: u1 (ref), u10 (copy)
        u1.untrack(u10);
    end));
end;

function u1.untrack(p13: userdata) -- Line: 99
    -- upvalues: u2 (copy)
    local v14 = u2[p13];

    if not v14 then
        return;
    end;

    for _, v in v14.conns do
        v:Disconnect();
    end;

    if v14.breakSound then
        v14.breakSound:Destroy();
    end;

    if v14.seal then
        v14.seal:Destroy();
    end;

    u2[p13] = nil;
end;

function u1.teardown() -- Line: 116
    -- upvalues: u2 (copy), u1 (copy)
    for i in u2 do
        u1.untrack(i);
    end;
end;

return u1;