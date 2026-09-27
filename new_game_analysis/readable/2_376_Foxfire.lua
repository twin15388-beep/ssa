-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local DayAndNightHandler = require(ReplicatedStorage.CAM.Global.DayAndNightHandler);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = Players.LocalPlayer;
local u1 = {
    ["Mushroom Lit Lantern"] = true
};
local u2 = nil;
local u3 = false;

local function getTemplate() -- Line: 117
    -- upvalues: u2 (ref), ReplicatedStorage (copy), u3 (ref)
    if u2 == nil then
        u2 = ReplicatedStorage.Assets:FindFirstChild("FoxfireGlow");

        if u2 == nil and not u3 then
            u3 = true;
            warn("[Foxfire] no ReplicatedStorage.Assets.FoxfireGlow; mushrooms will not glow");
        end;
    end;

    return u2;
end;

local u4 = {};
local Folder = Instance.new("Folder");
local u5 = nil;
local u6 = nil;
local u7 = false;

local function attach(p8: userdata) -- Line: 153
    -- upvalues: u4 (copy), u2 (ref), ReplicatedStorage (copy), u3 (ref)
    if u4[p8] ~= nil then
        return;
    end;

    local v9;

    if p8:IsA("BasePart") then
        v9 = p8;
    else
        v9 = p8:FindFirstChildWhichIsA("BasePart", true);
    end;

    if v9 == nil then
        return;
    end;

    if u2 == nil then
        u2 = ReplicatedStorage.Assets:FindFirstChild("FoxfireGlow");

        if u2 == nil and not u3 then
            u3 = true;
            warn("[Foxfire] no ReplicatedStorage.Assets.FoxfireGlow; mushrooms will not glow");
        end;
    end;

    local v10 = u2;

    if v10 == nil then
        return;
    end;

    local v11 = v10:Clone();
    local v12 = {};

    for _, child in v11:GetChildren() do
        if child:IsA("ParticleEmitter") then
            v12[child] = child.Rate;
            child.Rate = 0;
            child.Enabled = true;
        end;
    end;

    v11.Parent = v9;
    local math_max_ret = math.max(v9.Size.X, v9.Size.Y, v9.Size.Z);
    v11.WorldPosition = v9.Position + Vector3.new(0, math_max_ret * 0.35, 0);
    local v13 = v9:FindFirstChildOfClass("SurfaceAppearance");
    u4[p8] = {
        dimmed = false,
        burn = 0,
        attachment = v11,
        rates = v12,
        surface = v13,
        idleEmissive = v13 == nil and 0 or v13.EmissiveStrength,
        field = p8:HasTag("FoxfireField")
    };
end;

local function detach(p14: userdata) -- Line: 195
    -- upvalues: u4 (copy)
    local v15 = u4[p14];

    if v15 == nil then
        return;
    end;

    u4[p14] = nil;

    if v15.emissiveTween ~= nil then
        v15.emissiveTween:Cancel();
    end;

    if v15.surface ~= nil then
        v15.surface.EmissiveStrength = v15.idleEmissive;
    end;

    v15.attachment:Destroy();
end;

local function attachLantern(u16: userdata) -- Line: 214
    -- upvalues: u5 (ref), u6 (ref), Folder (copy), Utility (copy), u7 (ref), SignalEvent (copy)
    if u5 ~= nil then
        return;
    end;

    local v17;

    if u16:IsA("BasePart") then
        v17 = u16;
    else
        v17 = u16:FindFirstChildWhichIsA("BasePart", true);
    end;

    if v17 == nil then
        warn("[Foxfire] FoxfireLantern has no BasePart; it can never be taken");

        return;
    end;

    u5 = u16;
    u6 = u16.Parent;
    u16.Parent = Folder;
    Utility.CreatePrompt({
        ActionText = "Take it",
        ObjectText = "Lantern",
        HoldDuration = 1,
        MaxActivationDistance = 14,
        Parent = v17
    }).Triggered:Connect(function() -- Line: 234
        -- upvalues: u7 (ref), u16 (copy), Folder (ref), SignalEvent (ref)
        u7 = false;
        u16.Parent = Folder;
        SignalEvent.ToServer("FoxfireTake");
    end);
end;

local u18 = false;
local u19 = false;
task.spawn(function() -- Line: 256
    -- upvalues: PlayerStatResolver (copy), LocalPlayer (copy), u18 (ref), u19 (ref), Character_info_provider (copy), u1 (copy)
    PlayerStatResolver.Attach(LocalPlayer, "Illumination", function() -- Line: 259
        -- upvalues: u18 (ref), u19 (ref), PlayerStatResolver (ref), LocalPlayer (ref), Character_info_provider (ref), u1 (ref)
        u18 = false;
        u19 = false;

        if (PlayerStatResolver.GetStatExcept(LocalPlayer, "Illumination", "Progression") or 0) <= 0 then
            return;
        end;

        for _, v in Character_info_provider.getEquippedAccessoryStats(LocalPlayer) do
            if u1[v] then
                u19 = true;

                return;
            end;
        end;

        u18 = true;
    end);
end);

local function ownsLantern() -- Line: 277
    -- upvalues: Utility (copy), LocalPlayer (copy)
    local Data = Utility.GetData(LocalPlayer);
    local v20;

    if Data == nil then
        v20 = false;
    else
        v20 = Data.Inventory.Inventory:FindFirstChild("Mushroom Lit Lantern") ~= nil;
    end;

    return v20;
end;

local function step() -- Line: 282
    -- upvalues: u4 (copy), LocalPlayer (copy), DayAndNightHandler (copy), u18 (ref), u19 (ref), PlayerStatResolver (copy), TweenService (copy), Utility (copy), u5 (ref), u7 (ref), u6 (ref), Folder (copy)
    if next(u4) == nil then
        return;
    end;

    local os_clock_ret = os.clock();
    local Character = LocalPlayer.Character;
    local v21;

    if Character == nil then
        v21 = nil;
    else
        v21 = Character.PrimaryPart or nil;
    end;

    local v22 = not DayAndNightHandler.IsEnabled() or DayAndNightHandler.IsNight();
    local v23;

    if v21 == nil then
        v23 = false;
    else
        v23 = not u18;
    end;

    local v24;

    if v23 then
        v24 = u19 or Vector3.new(v21.AssemblyLinearVelocity.X, 0, v21.AssemblyLinearVelocity.Z).Magnitude <= 17 * PlayerStatResolver.GetMovementMultiplier(LocalPlayer);
    else
        v24 = v23;
    end;

    local v25 = 0;
    local v26 = 0;

    for i, v in u4 do
        if i.Parent == nil then
            local v27 = u4[i];

            if v27 ~= nil then
                u4[i] = nil;

                if v27.emissiveTween ~= nil then
                    v27.emissiveTween:Cancel();
                end;

                if v27.surface ~= nil then
                    v27.surface.EmissiveStrength = v27.idleEmissive;
                end;

                v27.attachment:Destroy();
            end;
        else
            local v28;

            if v21 == nil then
                v28 = false;
            else
                local v29 = v21.Position - i:GetPivot().Position;

                if math.abs(v29.Y) <= 10 then
                    v28 = Vector3.new(v29.X, 0, v29.Z).Magnitude <= 3;
                else
                    v28 = false;
                end;
            end;

            local v30;

            if v23 then
                v30 = v.field or v22;
            else
                v30 = v23;
            end;

            if v30 then
                if v.wokenAt ~= nil and os_clock_ret - v.wokenAt > (v.field and 50 or 6) then
                    v.wokenAt = nil;
                end;
            else
                v.wokenAt = nil;
                v.flickerUntil = nil;
            end;

            if v28 then
                if v30 then
                    if v24 then
                        v.wokenAt = v.wokenAt or os_clock_ret;
                        v.flickerUntil = nil;
                    else
                        v.wokenAt = nil;

                        if v.flickerUntil == nil then
                            v.flickerUntil = os_clock_ret + 0.45;
                        end;
                    end;
                elseif u18 then
                    v.dimUntil = os_clock_ret + 2.5;
                end;
            end;

            if v30 then
                v.dimUntil = nil;
            end;

            if v.flickerUntil ~= nil and v.flickerUntil < os_clock_ret then
                v.flickerUntil = nil;
            end;

            if v.dimUntil ~= nil and v.dimUntil < os_clock_ret then
                v.dimUntil = nil;
            end;

            if v.field then
                v25 = v25 + 1;

                if v.wokenAt ~= nil then
                    v26 = v26 + 1;
                end;
            end;

            local v31 = v.wokenAt == nil and (v.flickerUntil == nil and 0 or 0.35) or 1;
            local v32;

            if v.burn == v31 then
                v32 = v;
            else
                local v33 = v.burn == 1;
                v.burn = v31;
                v32 = v;

                for i2, v2 in v.rates do
                    i2.Rate = v2 * v31;
                end;

                if v31 == 1 and not v33 then
                    for i2 in v32.rates do
                        i2:Emit(15);
                    end;
                end;
            end;

            local v34 = v32.wokenAt ~= nil and true or v32.dimUntil ~= nil;

            if v32.dimmed ~= v34 and v32.surface ~= nil then
                v32.dimmed = v34;

                if v32.emissiveTween ~= nil then
                    v32.emissiveTween:Cancel();
                end;

                local v35 = TweenService:Create(v32.surface, TweenInfo.new(v34 and 0.4 or 2.5), {
                    EmissiveStrength = v34 and 3.5 or v32.idleEmissive
                });
                v32.emissiveTween = v35;
                v35:Play();
            end;
        end;
    end;

    local v36;

    if v25 > 0 and v26 == v25 then
        local Data = Utility.GetData(LocalPlayer);
        local v37;

        if Data == nil then
            v37 = false;
        else
            v37 = Data.Inventory.Inventory:FindFirstChild("Mushroom Lit Lantern") ~= nil;
        end;

        v36 = not v37;
    else
        v36 = false;
    end;

    if u5 ~= nil and v36 ~= u7 then
        u7 = v36;
        local v38;

        if v36 then
            v38 = u6;
        else
            v38 = Folder;
        end;

        u5.Parent = v38;
    end;
end;

for _, v in { "Foxfire", "FoxfireField" } do
    CollectionService:GetInstanceAddedSignal(v):Connect(attach);
    CollectionService:GetInstanceRemovedSignal(v):Connect(detach);
end;

for _, v in CollectionService:GetTagged("FoxfireLantern") do
    attachLantern(v);
end;

CollectionService:GetInstanceAddedSignal("FoxfireLantern"):Connect(attachLantern);
local v39 = false;

while true do
    task.wait(0.1);

    if not v39 then
        if u2 == nil then
            u2 = ReplicatedStorage.Assets:FindFirstChild("FoxfireGlow");

            if u2 == nil and not u3 then
                u3 = true;
                warn("[Foxfire] no ReplicatedStorage.Assets.FoxfireGlow; mushrooms will not glow");
            end;
        end;

        if u2 ~= nil then
            v39 = true;

            for _, v in { "Foxfire", "FoxfireField" } do
                for _, v2 in CollectionService:GetTagged(v) do
                    attach(v2);
                end;
            end;
        end;
    end;

    step();
end;