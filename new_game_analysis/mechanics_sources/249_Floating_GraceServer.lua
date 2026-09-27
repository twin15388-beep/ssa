-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Players = game:GetService("Players");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local Combat_Util = require(SAM.Services.Combat_Util);
local Combat_presets = require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local DebrisModule = require(CAM.DebrisModule);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};
local Name = script.Parent.Name;

local function showUmbrella(p3: table) -- Line: 37
    if p3.hideItem then
        p3.hideItem:Destroy();
        p3.hideItem = nil;
    end;
end;

local function barragePulse(u4: userdata, u5: userdata, u6, u7: table) -- Line: 49
    -- upvalues: Utility (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), Name (copy), Combat_presets (copy), EffectsEvent (copy)
    Utility.CreateHitbox({
        caster = u4,
        hitboxCFrame = u6 * Config.DEPLOY_HITBOX_OFFSET,
        hitboxSize = Config.DEPLOY_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p8: userdata, p9: userdata, p10: any) -- Line: 56, Name: hitDetected
            -- upvalues: Combat_Util (ref), u4 (copy), Config (ref), Name (ref), u6 (copy), Combat_presets (ref), u7 (copy), EffectsEvent (ref), u5 (copy)
            local Humanoid = p8:FindFirstChild("Humanoid");
            local HumanoidRootPart = p8:FindFirstChild("HumanoidRootPart");

            if Humanoid == nil or HumanoidRootPart == nil then
                return;
            end;

            if p10 == "Perfect" then
                Combat_Util.Perfect(script, u4, p8);
            elseif p10 == "Blocking" then
                Combat_Util.Block(script, u4, p8, Config.DEPLOY_BLOCK_BREAK);
            elseif p10 == true then
                Combat_Util.Damage(script, u4, p8, {
                    Base = Config.DEPLOY_DAMAGE,
                    Skill = Name
                });
                Combat_Util.Add_Strict_Stun(script, u4, p9, Config.DEPLOY_STRICT_STUN);
                local v11 = (HumanoidRootPart.Position - u6.Position) * Vector3.new(1, 0, 1);
                local v12;

                if v11.Magnitude > 0.001 then
                    v12 = v11.Unit;
                else
                    v12 = u6.LookVector;
                end;

                Combat_Util.Knockback(script, u4, HumanoidRootPart, v12 * Config.DEPLOY_KNOCKBACK, Config.DEPLOY_KNOCKBACK_DURATION, "remove_airbp");
                Combat_presets.PlayReactAnim(Humanoid);
                table.insert(u7, p8);
            end;

            EffectsEvent.ToAllInRange(u5, "Normal_Sword_Slash_Effect", HumanoidRootPart, -1);
        end
    });
end;

local function pullVictimTo(p13: userdata, p14: userdata, p15: userdata, p16: vector, p17: number) -- Line: 89
    -- upvalues: Players (copy), Utility (copy), Combat_Util (copy), EffectsEvent (copy), DebrisModule (copy)
    local v18 = Players:FindFirstChild(p13.Name);

    if v18 and (p14.Name ~= v18.Name and (p14:GetAttribute("IsMob") == nil and (Players:FindFirstChild(p14.Name) == nil and p15:CanSetNetworkOwnership()))) then
        p15:SetNetworkOwner(v18);
    end;

    local valuesfolder = Utility.getvaluesfolder(p14);

    if valuesfolder then
        Combat_Util.Add_No_GP(script, p13, valuesfolder, p17);
    end;

    Utility.ClearMovers(p15);

    if v18 then
        local v19 = Players:FindFirstChild(p14.Name);
        EffectsEvent.ToClient(v19 or v18, "Add_Velocity", p15, Vector3.new(0, 0, 0), 0, "delete");
    end;

    local Attachment = Instance.new("Attachment");
    Attachment.Name = "air_combo_bp";
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Name = "bpv";
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
    AlignPosition.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
    AlignPosition.MaxAxesForce = Vector3.new(1000000, 1000000, 1000000);
    AlignPosition.Attachment0 = Attachment;
    AlignPosition.Responsiveness = 60;
    AlignPosition.Position = p16;
    AlignPosition.Parent = Attachment;
    Attachment.Parent = p15;
    DebrisModule:AddItem(Attachment, p17);
end;

function u2.Hold(p20: userdata, p21: vector?, p22: table) -- Line: 131
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), Config (copy), EffectsEvent (copy), barragePulse (copy)
    local v23 = p22.CleanIt or cleanit.new();
    p22.CleanIt = v23;
    v23:Clean();
    local v24 = u2.Id[p20.UserId];
    local Character = p20.Character;
    local v25;

    if Character then
        v25 = Character:FindFirstChild("HumanoidRootPart");
    else
        v25 = Character;
    end;

    if v25 == nil then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    p22.deployRootCF = nil;
    p22.captured = {};
    v23:Add(Utility.AddValue(valuesfolder, "pause_gameplay", Config.MAX_DURATION));
    v23:Add(Utility.AddValue(valuesfolder, "NR", Config.MAX_DURATION));
    task.wait(Config.DEPLOY_DELAY);

    if u2.Id[p20.UserId] ~= v24 or v25.Parent == nil then
        return;
    end;

    local CFrame2 = v25.CFrame;
    p22.deployRootCF = CFrame2;

    if p22.hideItem then
        p22.hideItem:Destroy();
        p22.hideItem = nil;
    end;

    p22.hideItem = Utility.AddValue(valuesfolder, "InvisibleItem", Config.MAX_DURATION + Config.RELEASE_DURATION, "StringValue", "Bladed Wagasa");
    EffectsEvent.ToAllInRange(v25, "Floating Grace VFX", Character, "Start", CFrame2 * CFrame.new(0, Config.UMBRELLA_HEIGHT, -Config.UMBRELLA_FORWARD));

    while u2.Id[p20.UserId] == v24 and v25.Parent ~= nil do
        local v26 = {};
        barragePulse(Character, v25, v25.CFrame, v26);
        p22.captured = v26;
        task.wait(Config.BARRAGE_INTERVAL);
    end;
end;

function u2.UnHold(u27: userdata, p28: vector?, u29: table) -- Line: 174
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), EffectsEvent (copy), ManuelCancel (copy), Config (copy), Checker (copy), pullVictimTo (copy)
    local v30 = u29.CleanIt or cleanit.new();
    u29.CleanIt = v30;
    v30:Clean();
    local v31 = u2.Id[u27.UserId];
    local Character = u27.Character;
    local v32;

    if Character then
        v32 = Character:FindFirstChild("HumanoidRootPart");
    else
        v32 = Character;
    end;

    if v32 == nil then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);

    if u29.deployRootCF == nil then
        if u29.hideItem then
            u29.hideItem:Destroy();
            u29.hideItem = nil;
        end;

        EffectsEvent.ToAllInRange(v32, "Floating Grace VFX", Character, "Cancel");

        return;
    end;

    local v33, v34 = ManuelCancel.new(u27, Config.RETURN_TIME + 0.5);
    v33:Connect(function() -- Line: 196
        -- upvalues: u2 (ref), u27 (copy), u29 (copy)
        u2.Id[u27.UserId] = -1;
        u2.Cancel(u27, nil, u29);
    end);
    v30:Add(v34);
    v30:Add(Utility.AddValue(valuesfolder, "pause_gameplay", Config.RETURN_TIME));
    v30:Add(Utility.AddValue(valuesfolder, "skill_stand_still", Config.RETURN_TIME));
    v30:Add(Utility.AddValue(valuesfolder, "NR", Config.RETURN_TIME));
    EffectsEvent.ToAllInRange(v32, "Floating Grace VFX", Character, "Pull", v32.CFrame);
    local Position = (v32.CFrame * CFrame.new(0, 0, -Config.PULL_FRONT_DIST)).Position;

    for _, v in u29.captured or {} do
        if v.Parent ~= nil then
            local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart ~= nil and Checker.check_victim(script, Character, v) == true then
                pullVictimTo(Character, v, HumanoidRootPart, Position, Config.RETURN_TIME);
            end;
        end;
    end;

    task.wait(Config.RETURN_TIME);

    if u29.hideItem then
        u29.hideItem:Destroy();
        u29.hideItem = nil;
    end;

    task.wait((math.max(0, Config.RELEASE_DURATION - Config.RETURN_TIME)));

    if u2.Id[u27.UserId] ~= v31 or v32.Parent == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(v32, "Floating Grace VFX", Character, "Cancel");
    v30:Clean();
end;

function u2.Cancel(p35: userdata, p36: vector?, p37: table) -- Line: 231
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v38 = p37.CleanIt or cleanit.new();
    p37.CleanIt = v38;
    local Character = p35.Character;
    local v39;

    if Character then
        v39 = Character:FindFirstChild("HumanoidRootPart");
    else
        v39 = Character;
    end;

    if v39 and Character then
        EffectsEvent.ToAllInRange(v39, "Floating Grace VFX", Character, "Cancel");
    end;

    if p37.hideItem then
        p37.hideItem:Destroy();
        p37.hideItem = nil;
    end;

    v38:Clean();
end;

return u2;