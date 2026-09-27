-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local TweenService = game:GetService("TweenService");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local DebrisModule = require(CAM.DebrisModule);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local Combat_Util = require(SAM.Services.Combat_Util);
local u1 = require(ServerStorage.SAM.Game_Play.hit_priority_handler).new(script);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};
local script_FlashingWillowAirVariantVictimStartup = script.FlashingWillowAirVariantVictimStartup;
local script_FlashingWillowAirVariantVictimLoop = script.FlashingWillowAirVariantVictimLoop;
local script_FlashingWillowAirVariantUserStartup = script.FlashingWillowAirVariantUserStartup;
local script_FlashingWillowAirVariantUserLoop = script.FlashingWillowAirVariantUserLoop;
local script_FlashingWillowAirVariantUserRelease = script.FlashingWillowAirVariantUserRelease;

function u2.Hold(p3: userdata, p4: vector?, p5: table) -- Line: 41
    -- upvalues: cleanit (copy)
    local v6 = p5.CleanIt or cleanit.new();
    p5.CleanIt = v6;
    v6:Clean();
end;

function u2.UnHold(u7: userdata, u8: vector?, u9: table) -- Line: 47
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), Config (copy), ManuelCancel (copy), script_FlashingWillowAirVariantUserStartup (copy), Checker (copy), u1 (copy), Combat_Util (copy), DebrisModule (copy), EffectsEvent (copy), script_FlashingWillowAirVariantVictimStartup (copy), RaycastHelper (copy), script_FlashingWillowAirVariantUserLoop (copy), script_FlashingWillowAirVariantVictimLoop (copy), TweenService (copy), script_FlashingWillowAirVariantUserRelease (copy)
    local v10 = u9.CleanIt or cleanit.new();
    u9.CleanIt = v10;
    local v11 = u2.Id[u7.UserId];
    local Character = u7.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    local Animator = Humanoid:FindFirstChild("Animator");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local v12 = Config.AERIAL_DROP_RAY_DISTANCE / Config.AERIAL_DROP_SPEED;
    local v13 = Config.AERIAL_STARTUP_TIME + Config.AERIAL_LOOP_BEFORE_DROP + v12;
    local v14, v15 = ManuelCancel.new(u7, v13);
    v10:Add(v14:Connect(function() -- Line: 71
        -- upvalues: u2 (ref), u7 (copy), u8 (copy), u9 (copy)
        u2.Id[u7.UserId] = -1;
        u2.Cancel(u7, u8, u9);
    end));
    local v16 = Animator:LoadAnimation(script_FlashingWillowAirVariantUserStartup);
    v10:Add(v16);
    v16:Play();
    v16.TimePosition = Config.AERIAL_FREEZE_MARK;
    local u17 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = RootPart.CFrame * Config.AERIAL_HITBOX_OFFSET,
        hitboxSize = Config.AERIAL_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p18: userdata, p19: userdata, p20: any) -- Line: 88, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u17 (copy)
            local Humanoid2 = p18:FindFirstChild("Humanoid");
            local v21;

            if Humanoid2 then
                v21 = Humanoid2.RootPart;
            else
                v21 = Humanoid2;
            end;

            if p20 == "Perfect" then
                Combat_Util.Perfect(script, Character, p18);

                return;
            end;

            if p20 == "Blocking" and not Combat_Util.Block(script, Character, p18, Config.AERIAL_BLOCK_BREAK) then
                return;
            end;

            if v21:FindFirstChild("air_combo_bp") == nil and Humanoid2.FloorMaterial ~= Enum.Material.Air and Humanoid2.FloorMaterial ~= nil then
                return;
            end;

            table.insert(u17, {
                model = p18,
                values = p19,
                root = v21,
                humanoid = Humanoid2
            });
        end
    });

    if #u17 == 0 then
        task.wait(0.15);
        u2.Cancel(u7, u8, u9);

        return;
    end;

    v15();
    v10:Add(Utility.AddValue(valuesfolder, "pause_gameplay", v13));
    v10:Add(Utility.AddValue(valuesfolder, "NR", v13));
    v10:Add(Utility.AddValue(valuesfolder, "skill_stand_still", v13));
    local Part = Instance.new("Part");
    Part.Name = `{u7.Name} Flashing Willow Anchor`;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CFrame = RootPart.CFrame;
    Part.Parent = workspace.Debree;
    v10:Add(Part);
    DebrisModule:AddItem(Part, v13);
    EffectsEvent.ToAllInRange(RootPart, "Flashing Willow Aerial VFX", Character, "AerialStart", Part.CFrame);
    v10:Add(Utility.CreateOuwWeld(Part, RootPart, nil, v13));

    for _, v in u17 do
        v10:Add(Utility.AddValue(v.values, "pause_gameplay", v13));
        v10:Add(Utility.AddValue(v.values, "NR", v13));
        v10:Add(Utility.AddValue(v.values, "skill_stand_still", v13));
        Combat_Util.Remove_air_combo_bp(v.root);
        v10:Add(Utility.CreateOuwWeld(Part, v.root, nil, v13));
        local v22 = v.humanoid:LoadAnimation(script_FlashingWillowAirVariantVictimStartup);
        v10:Add(v22);
        v22:Play();
        v22.TimePosition = Config.AERIAL_FREEZE_MARK;
    end;

    task.wait(0.35);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    local v23 = Part.Position + Vector3.new(0, 1, 0) * -Config.AERIAL_DROP_RAY_DISTANCE;
    local v24 = workspace:Raycast(Part.Position, Vector3.new(0, 1, 0) * -Config.AERIAL_DROP_RAY_DISTANCE, RaycastHelper.Crater);
    local v25;

    if v24 then
        v23 = v24.Position;
        v25 = v23 + Vector3.new(0, Humanoid.HipHeight + RootPart.Size.Y / 2, 0);
    else
        v25 = v23;
    end;

    EffectsEvent.ToAllInRange(RootPart, "Flashing Willow Aerial VFX", Character, "AerialRelease", Part.CFrame, v23);
    task.wait(0.68);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    local v26 = Animator:LoadAnimation(script_FlashingWillowAirVariantUserLoop);
    v10:Add(v26);
    v26:Play();

    for _, v in u17 do
        local v27 = v.humanoid:LoadAnimation(script_FlashingWillowAirVariantVictimLoop);
        v10:Add(v27);
        v27:Play();
    end;

    local v28 = TweenService:Create(Part, TweenInfo.new(v12, Enum.EasingStyle.Linear), {
        CFrame = CFrame.new(v25)
    });
    v10:Add(v28);
    v28:Play();
    local CFrame2 = RootPart.CFrame;
    task.wait(v12);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    v10:Clean();
    task.wait();

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    EffectsEvent.ToAllInRange(RootPart, "Flashing Willow Aerial VFX", Character, "AerialImpact", v23);
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = CFrame.new(v23),
        hitboxSize = Config.AERIAL_EXPLOSION_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p29: userdata, p30: userdata, p31: any) -- Line: 205, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), CFrame2 (copy)
            if p31 == "Perfect" then
                Combat_Util.Perfect(script, Character, p29);

                return;
            end;

            if p31 == "Blocking" and not Combat_Util.Block(script, Character, p29, Config.AERIAL_BLOCK_BREAK) then
                return;
            end;

            Combat_Util.Damage(script, Character, p29, {
                Base = Config.AERIAL_DAMAGE,
                Skill = script.Parent.Name
            });
            Combat_Util.AddStun(script, Character, p30, Config.AERIAL_STUN);
            Combat_Util.Air_combo_slam(Character, p29, CFrame2, CFrame.new(0, -Config.AERIAL_DROP_RAY_DISTANCE, 0), true);
        end
    });
    local v32 = Animator:LoadAnimation(script_FlashingWillowAirVariantUserRelease);
    v10:Add(v32);
    v32:Play();
    task.wait(0.67);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    v10:Clean();
end;

function u2.Cancel(p33: userdata, p34: vector?, p35: table) -- Line: 229
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v36 = p35.CleanIt or cleanit.new();
    p35.CleanIt = v36;
    EffectsEvent.ToAllInRange(p33, "Flashing Willow Aerial VFX", p33.Character, "Cancel");
    v36:Clean();
end;

return u2;