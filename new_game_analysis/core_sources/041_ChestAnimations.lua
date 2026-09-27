-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local Presets = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker.Presets);
local ChestAssets = require(script.Parent.ChestAssets);
local u1 = {};
local u2 = {};

local function freezeAtEnd(p3: userdata) -- Line: 38
    p3:Stop(0);
    p3:Play(0);
    p3.TimePosition = math.max(p3.Length - 0.016666666666666666, 0);
    p3:AdjustSpeed(0);
    p3:AdjustWeight(1, 0);
end;

local function playOpen(u4: userdata) -- Line: 48
    u4:Stop(0);
    u4:Play(0);
    u4:AdjustSpeed(1);
    local u5 = false;

    local function hold() -- Line: 53
        -- upvalues: u5 (ref), u4 (copy)
        if u5 then
            return;
        end;

        u5 = true;
        local v6 = u4;
        v6:Stop(0);
        v6:Play(0);
        v6.TimePosition = math.max(v6.Length - 0.016666666666666666, 0);
        v6:AdjustSpeed(0);
        v6:AdjustWeight(1, 0);
    end;

    u4.Stopped:Once(hold);
    task.delay(math.max(u4.Length, 0.05), hold);
end;

local function playFlash(u7: userdata, u8: table, u9: number, u10: number, u11: number) -- Line: 65
    -- upvalues: ChestAssets (copy), TweenService (copy)
    task.delay(u10, function() -- Line: 66
        -- upvalues: u8 (copy), u9 (copy), u7 (copy), ChestAssets (ref), u11 (copy), u10 (copy), TweenService (ref)
        if u8.gen ~= u9 or u7.Parent == nil then
            return;
        end;

        local flash = u8.flash;

        if flash == nil or flash.Parent == nil then
            flash = ChestAssets.flash(u7);
            u8.flash = flash;
        end;

        if flash == nil then
            return;
        end;

        flash.FillTransparency = 0;
        flash.OutlineTransparency = 0;
        flash.Enabled = true;
        local v12 = u11 - u10;
        TweenService:Create(flash, TweenInfo.new(v12, Enum.EasingStyle.Linear), {
            FillTransparency = 1,
            OutlineTransparency = 1
        }):Play();
        task.delay(v12, function() -- Line: 86
            -- upvalues: u8 (ref), u9 (ref), flash (ref)
            if u8.gen == u9 and flash.Parent ~= nil then
                flash.Enabled = false;
            end;
        end);
    end);
end;

local function cueImpact(u13: userdata, u14: table, u15: number, u16: string, u17: any) -- Line: 95
    -- upvalues: ChestAssets (copy), Cam_Shaker (copy)
    task.delay(0.18333333333333332, function() -- Line: 96
        -- upvalues: u14 (copy), u15 (copy), u13 (copy), ChestAssets (ref), u16 (copy), Cam_Shaker (ref), u17 (copy)
        if u14.gen ~= u15 or u13.Parent == nil then
            return;
        end;

        ChestAssets.burst(u13, u16);
        Cam_Shaker(u13:GetPivot().Position, u17);
    end);
end;

local function syncState(u18: userdata, u19: table, p20: boolean?) -- Line: 105
    -- upvalues: playOpen (copy), ChestAssets (copy), Presets (copy), Cam_Shaker (copy), TweenService (copy)
    u19.gen = u19.gen + 1;
    local gen = u19.gen;

    if u18:GetAttribute("IsOpen") == true then
        if u19.spawn then
            u19.spawn:Stop(0);
        end;

        if p20 then
            if u19.open then
                playOpen(u19.open);
            end;

            ChestAssets.play(u19.openSound);
            local tinyshake_preset = Presets.tinyshake_preset;
            local u21 = "OpenEffect";
            task.delay(0.18333333333333332, function() -- Line: 96
                -- upvalues: u19 (copy), gen (copy), u18 (copy), ChestAssets (ref), u21 (copy), Cam_Shaker (ref), tinyshake_preset (copy)
                if u19.gen ~= gen or u18.Parent == nil then
                    return;
                end;

                ChestAssets.burst(u18, u21);
                Cam_Shaker(u18:GetPivot().Position, tinyshake_preset);
            end);
            local u22 = 0.7666666666666667;
            local u23 = 0.18333333333333332;
            task.delay(0.18333333333333332, function() -- Line: 66
                -- upvalues: u19 (copy), gen (copy), u18 (copy), ChestAssets (ref), u22 (copy), u23 (copy), TweenService (ref)
                if u19.gen ~= gen or u18.Parent == nil then
                    return;
                end;

                local flash = u19.flash;

                if flash == nil or flash.Parent == nil then
                    flash = ChestAssets.flash(u18);
                    u19.flash = flash;
                end;

                if flash == nil then
                    return;
                end;

                flash.FillTransparency = 0;
                flash.OutlineTransparency = 0;
                flash.Enabled = true;
                local v24 = u22 - u23;
                TweenService:Create(flash, TweenInfo.new(v24, Enum.EasingStyle.Linear), {
                    FillTransparency = 1,
                    OutlineTransparency = 1
                }):Play();
                task.delay(v24, function() -- Line: 86
                    -- upvalues: u19 (ref), gen (ref), flash (ref)
                    if u19.gen == gen and flash.Parent ~= nil then
                        flash.Enabled = false;
                    end;
                end);
            end);

            return;
        end;

        if u19.open then
            local open = u19.open;
            open:Stop(0);
            open:Play(0);
            open.TimePosition = math.max(open.Length - 0.016666666666666666, 0);
            open:AdjustSpeed(0);
            open:AdjustWeight(1, 0);
        end;
    else
        if u19.open then
            u19.open:Stop(0);
        end;

        if u18:GetAttribute("NoSpawnShow") == true then
            if u19.spawn then
                local spawn = u19.spawn;
                spawn:Stop(0);
                spawn:Play(0);
                spawn.TimePosition = math.max(spawn.Length - 0.016666666666666666, 0);
                spawn:AdjustSpeed(0);
                spawn:AdjustWeight(1, 0);
            end;

            return;
        end;

        if u19.spawn then
            u19.spawn:Play(0);
        end;

        ChestAssets.play(u19.spawnSound);
        local activate_shake = Presets.activate_shake;
        local u25 = "SpawnEffect";
        task.delay(0.18333333333333332, function() -- Line: 96
            -- upvalues: u19 (copy), gen (copy), u18 (copy), ChestAssets (ref), u25 (copy), Cam_Shaker (ref), activate_shake (copy)
            if u19.gen ~= gen or u18.Parent == nil then
                return;
            end;

            ChestAssets.burst(u18, u25);
            Cam_Shaker(u18:GetPivot().Position, activate_shake);
        end);
        local u26 = 0.5833333333333334;
        local u27 = 0.016666666666666666;
        task.delay(0.016666666666666666, function() -- Line: 66
            -- upvalues: u19 (copy), gen (copy), u18 (copy), ChestAssets (ref), u26 (copy), u27 (copy), TweenService (ref)
            if u19.gen ~= gen or u18.Parent == nil then
                return;
            end;

            local flash = u19.flash;

            if flash == nil or flash.Parent == nil then
                flash = ChestAssets.flash(u18);
                u19.flash = flash;
            end;

            if flash == nil then
                return;
            end;

            flash.FillTransparency = 0;
            flash.OutlineTransparency = 0;
            flash.Enabled = true;
            local v28 = u26 - u27;
            TweenService:Create(flash, TweenInfo.new(v28, Enum.EasingStyle.Linear), {
                FillTransparency = 1,
                OutlineTransparency = 1
            }):Play();
            task.delay(v28, function() -- Line: 86
                -- upvalues: u19 (ref), gen (ref), flash (ref)
                if u19.gen == gen and flash.Parent ~= nil then
                    flash.Enabled = false;
                end;
            end);
        end);
    end;
end;

function u1.track(u29: userdata) -- Line: 145
    -- upvalues: u2 (copy), u1 (copy), ChestAssets (copy), syncState (copy)
    local v30 = u2[u29];

    if v30 then
        if u29:GetAttribute("IsOpen") == true and v30.open then
            local open = v30.open;
            open:Stop(0);
            open:Play(0);
            open.TimePosition = math.max(open.Length - 0.016666666666666666, 0);
            open:AdjustSpeed(0);
            open:AdjustWeight(1, 0);
        end;

        return;
    end;

    local u31 = {
        open = nil,
        spawn = nil,
        openSound = nil,
        spawnSound = nil,
        flash = nil,
        gen = 0,
        conns = {}
    };
    u2[u29] = u31;
    table.insert(u31.conns, u29.Destroying:Connect(function() -- Line: 168
        -- upvalues: u1 (ref), u29 (copy)
        u1.untrack(u29);
    end));
    local v32 = u29:GetAttribute("IsOpen") == true;
    local v33 = ChestAssets.animator(u29);

    if not v33 then
        warn((`Chest '{ChestAssets.key(u29)}' has no Animator — it cannot animate`));
    end;

    u31.open = ChestAssets.track(u29, v33, "OpenAnimation");
    u31.spawn = ChestAssets.track(u29, v33, "SpawnAnimation");
    u31.openSound = ChestAssets.sound(u29, "OpenSound");
    u31.spawnSound = ChestAssets.sound(u29, "SpawnSound");

    if u2[u29] ~= u31 then
        if u31.openSound then
            u31.openSound:Destroy();
        end;

        if u31.spawnSound then
            u31.spawnSound:Destroy();
        end;

        return;
    end;

    local v34 = not v32 and u29:GetAttribute("IsOpen") == true;
    syncState(u29, u31, v34);
    local conns = u31.conns;
    local AttributeChangedSignal = u29:GetAttributeChangedSignal("IsOpen");
    table.insert(conns, AttributeChangedSignal:Connect(function() -- Line: 191
        -- upvalues: syncState (ref), u29 (copy), u31 (copy)
        syncState(u29, u31, true);
    end));
end;

function u1.untrack(p35: userdata) -- Line: 196
    -- upvalues: u2 (copy)
    local v36 = u2[p35];

    if not v36 then
        return;
    end;

    for _, v in v36.conns do
        v:Disconnect();
    end;

    if v36.open then
        v36.open:Stop(0);
    end;

    if v36.spawn then
        v36.spawn:Stop(0);
    end;

    if v36.openSound then
        v36.openSound:Destroy();
    end;

    if v36.spawnSound then
        v36.spawnSound:Destroy();
    end;

    if v36.flash then
        v36.flash:Destroy();
    end;

    v36.gen = v36.gen + 1;
    u2[p35] = nil;
end;

function u1.teardown() -- Line: 223
    -- upvalues: u2 (copy), u1 (copy)
    for i in u2 do
        u1.untrack(i);
    end;
end;

return u1;