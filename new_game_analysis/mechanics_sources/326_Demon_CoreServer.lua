-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local Server_Mouse_Pos = require(SAM.Services.Server_Mouse_Pos);
local Combat_Util = require(SAM.Services.Combat_Util);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local Combat_presets = require(CAM.Global.Combat_presets);
local ProjectileModeler = require(CAM.Global.ProjectileModeler);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local cleanit = require(game.ReplicatedStorage.Packages.cleanit);
local DebrisModule = require(CAM.DebrisModule);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};
local script_DemonCorep2 = script.DemonCorep2;

local function spawnCloseWave(u3: userdata, u4: userdata, u5: vector, p6: vector) -- Line: 32
    -- upvalues: Utility (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), EffectsEvent (copy), Combat_presets (copy)
    local u7 = {};
    local v8 = CFrame.lookAt(p6, p6 + u5) * CFrame.new(0, 0, -5);
    Utility.CreateHitbox({
        caster = u3,
        hitboxCFrame = v8,
        hitboxSize = Config.BARRAGE_CLOSE_WAVE_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p9: userdata, p10: userdata, p11: any) -- Line: 43, Name: hitDetected
            -- upvalues: u7 (copy), Combat_Util (ref), u3 (copy), EffectsEvent (ref), u4 (copy), Config (ref), u5 (copy), Combat_presets (ref)
            if u7[p9] then
                return;
            end;

            u7[p9] = true;
            local Humanoid = p9:FindFirstChild("Humanoid");
            local v12;

            if Humanoid then
                v12 = Humanoid.RootPart;
            else
                v12 = Humanoid;
            end;

            if p11 == "Perfect" then
                Combat_Util.Perfect(script, u3, p9);

                return;
            end;

            if p11 == "Blocking" then
                Combat_Util.Block(script, u3, p9, 0.25);

                return;
            end;

            if p11 == true then
                EffectsEvent.ToAllInRange(u4, "Normal_Punch_Effect", v12, -1);
                Combat_Util.Damage(script, u3, p9, {
                    Base = Config.BARRAGE_CLOSE_WAVE_DAMAGE,
                    Skill = script.Parent.Name
                });
                Combat_Util.AddStun(script, u3, p10, 0.4);
                Combat_Util.Knockback(script, u3, v12, u5 * Config.BARRAGE_CLOSE_WAVE_KNOCKBACK + Vector3.new(0, 0.1, 0), 0.5);
                Combat_presets.PlayReactAnim(Humanoid);
            end;
        end
    });
end;

local function spawnFinisherWave(u13: userdata, u14: userdata, u15: table, u16) -- Line: 65
    -- upvalues: Utility (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), EffectsEvent (copy)
    Utility.CreateHitbox({
        caster = u13,
        hitboxCFrame = u16,
        hitboxSize = Config.BARRAGE_CLOSE_WAVE_FINISH_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p17: userdata, p18: userdata, p19: any) -- Line: 72, Name: hitDetected
            -- upvalues: u15 (copy), Combat_Util (ref), u13 (copy), EffectsEvent (ref), u14 (copy), Config (ref), u16 (copy)
            if u15[p17] then
                return;
            end;

            u15[p17] = true;
            local Humanoid = p17:FindFirstChild("Humanoid");

            if Humanoid then
                Humanoid = Humanoid.RootPart;
            end;

            if p19 == "Perfect" then
                Combat_Util.Perfect(script, u13, p17);

                return;
            end;

            if p19 == "Blocking" then
                Combat_Util.Block(script, u13, p17, 1);

                return;
            end;

            if p19 == true then
                EffectsEvent.ToAllInRange(u14, "Normal_Punch_Effect", Humanoid, -1);
                Combat_Util.Damage(script, u13, p17, {
                    Base = Config.BARRAGE_CLOSE_WAVE_DAMAGE,
                    Skill = script.Parent.Name
                });
                Combat_Util.AddStun(script, u13, p18, 0.4);
                Combat_Util.Knockback(script, u13, Humanoid, u16.LookVector * Config.BARRAGE_CLOSE_WAVE_FINISH_KNOCKBACK, 0.15);
                Combat_Util.RagDoll(script, u13, p18, 1.5);
            end;
        end
    });
end;

local function startBarrage(p20: userdata, p21: userdata, p22: vector, p23: table, p24: number) -- Line: 94
    -- upvalues: Utility (copy), Config (copy), script_DemonCorep2 (copy), DebrisModule (copy), Server_Mouse_Pos (copy), EffectsEvent (copy), u2 (copy), spawnCloseWave (copy), spawnFinisherWave (copy)
    local Character = p20.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local CleanIt = p23.CleanIt;

    if not CleanIt then
        return;
    end;

    if p23.barrageTrack then
        p23.barrageTrack:Stop();
        p23.barrageTrack:Destroy();
        p23.barrageTrack = nil;
    end;

    local v25 = 0.25 / Config.BARRAGE_ANIM_SPEED;
    local v26 = 1.7 / Config.BARRAGE_ANIM_SPEED;
    local v27 = 2.12 / Config.BARRAGE_ANIM_SPEED;
    local v28 = 2.57 / Config.BARRAGE_ANIM_SPEED;
    CleanIt:Add(Utility.AddValue(valuesfolder, "Transparency", 0.3));
    CleanIt:Add(Utility.AddValue(valuesfolder, "pause_gameplay", v28));
    CleanIt:Add(Utility.AddValue(valuesfolder, "NR", v28 + 0.1));
    local Animator = Humanoid:FindFirstChild("Animator");

    if Animator and script_DemonCorep2 then
        p23.barrageTrack = Animator:LoadAnimation(script_DemonCorep2);
        p23.barrageTrack:Play();
        p23.barrageTrack:AdjustSpeed(Config.BARRAGE_ANIM_SPEED);
        CleanIt:Add(p23.barrageTrack);
        DebrisModule:AddItem(p23.barrageTrack, v28 + 1);
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "air_combo_bp";
    CleanIt:Add(Attachment);
    DebrisModule:AddItem(Attachment, v28 + 1);
    local Unit = ((p21.Position - RootPart.Position) * Vector3.new(1, 0, 1)).Unit;
    RootPart.CFrame = Utility.SafeLookAt(RootPart.Position, RootPart.Position + Unit, RootPart.CFrame);
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
    AlignPosition.MaxAxesForce = Vector3.new(20000, 20000, 20000);
    AlignPosition.Responsiveness = 45;
    AlignPosition.Attachment0 = Attachment;
    AlignPosition.Parent = Attachment;
    AlignPosition.Position = p21.Position - Unit * 4;
    CleanIt:Add(AlignPosition);
    DebrisModule:AddItem(AlignPosition, v28 + 1);
    Attachment.Parent = RootPart;
    CleanIt:Add(function() -- Line: 151
        -- upvalues: RootPart (copy)
        if RootPart then
            RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end);
    local Position = AlignPosition.Position;

    local function currentDirection() -- Line: 166
        -- upvalues: Server_Mouse_Pos (ref), Character (copy), Config (ref), Position (copy), Unit (copy)
        local v29 = Server_Mouse_Pos.Aim(Character, script.Parent.Name, Config.MOUSE_RANGE);

        if v29 ~= nil then
            local v30 = (v29 - Position) * Vector3.new(1, 0, 1);

            if v30.Magnitude >= 0.01 then
                return v30.Unit;
            end;
        end;

        return Unit;
    end;

    EffectsEvent.ToAllInRange(RootPart, "Demon Core VFX", Character, "Finish", p22, true, p21, Unit);
    local v31 = (v26 - v25) / Config.BARRAGE_HIT_COUNT;
    task.wait(v25);

    if u2.Id[p20.UserId] ~= p24 then
        return;
    end;

    for i = 1, Config.BARRAGE_HIT_COUNT do
        if u2.Id[p20.UserId] ~= p24 then
            return;
        end;

        local v32 = Server_Mouse_Pos.Aim(Character, script.Parent.Name, Config.MOUSE_RANGE);
        local v33;

        if v32 == nil then
            v33 = Unit;
        else
            local v34 = (v32 - Position) * Vector3.new(1, 0, 1);

            if v34.Magnitude >= 0.01 then
                v33 = v34.Unit;
            else
                v33 = Unit;
            end;
        end;

        spawnCloseWave(Character, RootPart, v33, Position);
        local v35;

        if i < Config.BARRAGE_HIT_COUNT then
            task.wait(v31);

            if u2.Id[p20.UserId] ~= p24 then
                return;
            end;

            v35 = i;
        else
            v35 = i;
        end;
    end;

    task.wait(v27 - v26);

    if u2.Id[p20.UserId] ~= p24 then
        return;
    end;

    local v36 = {};
    local v37 = (v28 - v27) / 2;
    local CFrame_lookAt = CFrame.lookAt;
    local v38 = Server_Mouse_Pos.Aim(Character, script.Parent.Name, Config.MOUSE_RANGE);

    if v38 ~= nil then
        local v39 = (v38 - Position) * Vector3.new(1, 0, 1);

        if v39.Magnitude >= 0.01 then
            Unit = v39.Unit;
        end;
    end;

    local v40 = CFrame_lookAt(Position, Position + Unit);
    local Z = Config.BARRAGE_CLOSE_WAVE_FINISH_SIZE.Z;

    for i = 0, 2 do
        if u2.Id[p20.UserId] ~= p24 then
            return;
        end;

        spawnFinisherWave(Character, RootPart, v36, v40 * CFrame.new(0, 0, -Z * i - 5));
        task.wait(v37);
        local _ = i;
    end;

    if u2.Id[p20.UserId] ~= p24 then
        return;
    end;

    CleanIt:Clean();
end;

function u2.Hold(p41: userdata, p42: vector, p43: table) -- Line: 211
    -- upvalues: cleanit (copy), Server_Mouse_Pos (copy), Combat_Util (copy), Config (copy), EffectsEvent (copy)
    if p43.CleanIt then
        p43.CleanIt:Destroy();
    end;

    local v44 = cleanit.new();
    p43.CleanIt = v44;
    local Character = p41.Character;
    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    Server_Mouse_Pos.Create_Pos_Part(Character, script.Parent.Name, 6);
    v44:Add(function() -- Line: 223
        -- upvalues: Server_Mouse_Pos (ref), Character (copy)
        Server_Mouse_Pos.Delete_Pos_Part(Character, script.Parent.Name);
    end);
    p43.airHold = Combat_Util.Add_air_combo_bp(RootPart, nil, Config.UPDRAFT_HEIGHT, nil, Config.UPDRAFT_DURATION);
    v44:Add(p43.airHold);
    EffectsEvent.ToAllInRange(RootPart, "Demon Core VFX", Character, "Start", RootPart.CFrame);
end;

function u2.UnHold(u45: userdata, u46: vector, u47: table) -- Line: 231
    -- upvalues: u2 (copy), Config (copy), Utility (copy), ManuelCancel (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy), startBarrage (copy), Server_Mouse_Pos (copy), ProjectileModeler (copy), RaycastHelper (copy)
    local CleanIt = u47.CleanIt;

    if not CleanIt then
        return;
    end;

    local u48 = u2.Id[u45.UserId];
    local Character = u45.Character;
    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    local v49 = (1.35 - Config.FREEZE_MARK) / Config.RELEASE_SPEED;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local v50, v51 = ManuelCancel.new(u45, 3);
    v50:Connect(function() -- Line: 243
        -- upvalues: u2 (ref), u45 (copy), u46 (copy), u47 (copy)
        u2.Id[u45.UserId] = -1;
        u2.Cancel(u45, u46, u47);
    end);
    CleanIt:Add(v51);
    local u52 = Utility.AddValue(valuesfolder, "skillsdisabled", 7, "StringValue", "all");
    CleanIt:Add(u52);
    task.wait(v49);

    if u2.Id[u45.UserId] ~= u48 then
        return;
    end;

    if u47.airHold then
        CleanIt:Remove(u47.airHold);
        u47.airHold:Destroy();
        u47.airHold = nil;
    end;

    local u53 = false;

    local function projectileOnHit(u54: vector?, p55: vector?, p56: userdata?) -- Line: 264
        -- upvalues: u48 (copy), u2 (ref), u45 (copy), u53 (ref), CleanIt (copy), u52 (copy), Utility (ref), EffectsEvent (ref), RootPart (copy), Character (copy), Config (ref), Checker (ref), u1 (ref), Combat_Util (ref), startBarrage (ref), u47 (copy)
        if u48 ~= u2.Id[u45.UserId] then
            return true;
        end;

        if u53 then
            return true;
        end;

        u53 = true;
        CleanIt:Remove(u52);
        u52:Destroy();
        local v57 = nil;
        local v58;

        if p56 then
            v58 = Utility.find_character_from_descendant(p56);

            if v58 then
                v57 = v58:FindFirstChild("HumanoidRootPart");
            end;
        else
            v58 = nil;
        end;

        if v57 then
            u54 = v57.Position;
        end;

        if v57 then
            p55 = nil;
        end;

        EffectsEvent.ToAllInRange(RootPart, "Demon Core VFX", Character, "Impact", u54, p55);
        local u59 = nil;
        local u60 = (1 / 0);
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = CFrame.new(u54),
            hitboxSize = Config.PROJECTILE_AOE_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            targets = v58 and { v58 } or nil,

            hitDetected = function(p61: userdata, p62: userdata, p63: any) -- Line: 293, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (ref), u54 (copy), u60 (ref), u59 (ref), Config (ref)
                local RootPart2 = p61:FindFirstChild("Humanoid").RootPart;

                if p63 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p61);

                    return;
                end;

                if p63 == true or p63 == "Blocking" then
                    local Magnitude = (RootPart2.Position - u54).Magnitude;

                    if Magnitude < u60 then
                        u60 = Magnitude;
                        u59 = RootPart2;
                    end;

                    if p63 == "Blocking" then
                        Combat_Util.Block(script, Character, p61, 1);

                        return;
                    end;

                    Combat_Util.Damage(script, Character, p61, {
                        Base = Config.PROJECTILE_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Add_Strict_Stun(script, Character, p62, Config.PROJECTILE_STUN, true);
                end;
            end
        });

        if u59 then
            startBarrage(u45, u59, u54, u47, u48);
        else
            CleanIt:Destroy();
            u47.CleanIt = nil;
        end;

        return true;
    end;

    local v64 = Server_Mouse_Pos.Aim(Character, script.Parent.Name, Config.MOUSE_RANGE, u46) or RootPart.Position + RootPart.CFrame.LookVector;
    local Position = RootPart.Position;
    local v65;

    if (v64 - Position).Magnitude <= 0.01 then
        v65 = RootPart.CFrame.LookVector;
    else
        v65 = (v64 - Position).Unit;
    end;

    local v66 = CFrame.lookAt(Position, Position + v65) * CFrame.new(0, 0, -4);
    local v67 = `{u45.Name} Demon Core Projectile`;
    local u68 = ProjectileModeler.new({
        Name = v67,
        Size = Config.PROJECTILE_SIZE,
        CFrame = v66,
        Mover = {
            MaxForce = 1000000000,
            VectorVelocity = v65 * Config.PROJECTILE_SPEED
        },
        Rotator = {
            Responsiveness = 75,
            CFrame = CFrame.lookAt(v66.Position, v66.Position + v65)
        }
    }, projectileOnHit, Config.PROJECTILE_DURATION, ProjectileModeler.WhitelistType.HumanoidsAndMap, Character, RaycastHelper.Crater);
    u68.Instance:SetNetworkOwner(u45);
    v51();
    u47.projectile = u68;
    EffectsEvent.ToAllInRange(RootPart, "Demon Core VFX", Character, "WaveLong", v64, v67, u68.Instance, v65, u68.Instance);
    task.delay(Config.PROJECTILE_DURATION, function() -- Line: 364
        -- upvalues: u53 (ref), u68 (copy), u2 (ref), u45 (copy), u46 (copy), u47 (copy)
        if not u53 then
            if u68.IsActive then
                u68:Destroy();
            end;

            u2.Cancel(u45, u46, u47);
        end;
    end);
end;

function u2.Cancel(p69: userdata, p70: vector?, p71: table) -- Line: 374
    -- upvalues: EffectsEvent (copy)
    local CleanIt = p71.CleanIt;
    EffectsEvent.ToAllInRange(p69, "Demon Core VFX", p69.Character, "Cancel");

    if CleanIt ~= nil then
        CleanIt:Destroy();
        p71.CleanIt = nil;
    end;
end;

return u2;