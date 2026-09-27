-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
game:GetService("RunService");
game:GetService("TweenService");
game:GetService("CollectionService");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local SAM = ServerStorage:WaitForChild("SAM");
local Global = CAM:WaitForChild("Global");
local Services = SAM:WaitForChild("Services");
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local Utility = require(Global.Utility);
local Checker = require(Global.Checker);
local Combat_Util = require(Services.Combat_Util);
require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local ManuelCancel = require(Global.Subsets.Gameplay.ManuelCancel);
local StatTypes = require(CAM.Global.Types.StatTypes);
require(CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
local Cutscene_camera_handler = require(SAM:FindFirstChild("Game_Play"):FindFirstChild("Cutscene_camera_handler"));
local CharGrabPosCorrector = require(Global.Subsets.Gameplay.CharGrabPosCorrector);
local Config = require(script.Parent.Config);
local Server_Mouse_Pos = require(game:GetService("ServerStorage").SAM.Services.Server_Mouse_Pos);
local Vector3_new = Vector3.new;
local _ = tick;
local u5 = {
    Id = {},

    Hold = function(p2: userdata, p3: any, p4: any) -- Line: 43, Name: Hold
        -- upvalues: EffectsEvent (copy)
        if not p2 then
            return;
        end;

        local Character = p2.Character;

        if not Character then
            return;
        end;

        EffectsEvent.ToAllInRange(p2, "Fluterring_Sting_VFX", Character, "Hold");
    end
};

function u5.UnHoldAfterClient(u6, u7, p8, p9, u10) -- Line: 51
    -- upvalues: Server_Mouse_Pos (copy), Config (copy), EffectsEvent (copy), Utility (copy), u5 (copy), ManuelCancel (copy), Vector3_new (copy), Combat_Util (copy), DebrisModule (copy), Cutscene_camera_handler (copy), Checker (copy), StatTypes (copy), u1 (copy), CharGrabPosCorrector (copy)
    if not u6 then
        return;
    end;

    local Character = u6.Character;

    if not Character then
        return;
    end;

    if typeof(p9) ~= "CFrame" then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v11 = Server_Mouse_Pos.Clamp(Character, p9.Position, Config.RANGE + 15);

    if v11 == nil then
        return;
    end;

    local v12 = p9.Rotation + v11;
    local u13 = false;
    local Humanoid = Character:WaitForChild("Humanoid");
    u10.Value_Table = {};
    local Position = v12.Position;
    EffectsEvent.ToAllInRange(u6, "Fluterring_Sting_VFX", Character, "Landing");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local u14 = u5.Id[u6.UserId];
    local v15, u16 = ManuelCancel.new(u6);
    v15:Connect(function() -- Line: 77
        -- upvalues: u6 (copy), u5 (ref), u7 (copy), u10 (copy), u16 (copy)
        if u6 and u6.Parent == game.Players then
            u5.Id[u6.UserId] = 0;
            u5.Cancel(u6, u7, u10);
            u16();
        end;
    end);
    local u17 = CFrame.new(Position - Vector3.new(0, 0.45, 0)) * Utility.SafeLookAt(Vector3_new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z), Vector3_new(Position.X, 0, Position.Z), HumanoidRootPart.CFrame).Rotation;
    local u18 = false;
    local u19 = nil;
    local u20 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = u17,
        hitboxSize = Config.IMPACT_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(u21: userdata, u22: any, p23: any, p24: any) -- Line: 93
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), DebrisModule (ref), u10 (copy), u17 (copy), u13 (ref), u19 (ref), valuesfolder (copy), Cutscene_camera_handler (ref), u6 (copy), u20 (ref), u18 (ref), EffectsEvent (ref), u5 (ref), u14 (copy), Checker (ref), Utility (ref), StatTypes (ref)
            if u21 then
                local Humanoid2 = u21:FindFirstChild("Humanoid");
                local RootPart = Humanoid2.RootPart;

                if p23 == "Blocking" or p23 == "Perfect" then
                    Combat_Util.Block(script, Character, u21, Config.IMPACT_BLOCK_BREAK);

                    return;
                end;

                if p23 == true then
                    local v25 = script.Parent.Name .. " Skill Hitlist";

                    if Character:FindFirstChild(v25) then
                        Character:FindFirstChild(v25):Destroy();
                    end;

                    local Folder = Instance.new("Folder", Character);
                    Folder.Name = v25;
                    DebrisModule:AddItem(Folder, Config.ANIM_DURATION);
                    table.insert(u10.Value_Table, Folder);
                    local ObjectValue = Instance.new("ObjectValue");
                    ObjectValue.Name = u21.Name;
                    ObjectValue.Value = u21;
                    ObjectValue.Parent = Folder;
                    local Part = Instance.new("Part");
                    Part.Anchored = true;
                    Part.Transparency = 1;
                    Part.Massless = true;
                    Part.CFrame = u17;
                    Part.CanCollide = false;
                    Part.Parent = workspace.Debree;
                    table.insert(u10.Value_Table, Part);
                    DebrisModule:AddItem(Part, Config.ANIM_DURATION);

                    if u13 == false then
                        u13 = true;
                    end;

                    local v26 = script.Parent.Name .. Character.Name .. "Camera";

                    if u19 == nil then
                        local NumberValue = Instance.new("NumberValue");
                        NumberValue.Value = Config.CUTSCENE_FOV;
                        NumberValue.Name = "FOV";
                        NumberValue.Parent = u22;
                        DebrisModule:AddItem(NumberValue, Config.ANIM_DURATION - 0.2);
                        table.insert(u10.Value_Table, NumberValue);
                        local NumberValue2 = Instance.new("NumberValue");
                        NumberValue2.Value = Config.CUTSCENE_FOV;
                        NumberValue2.Name = "FOV";
                        NumberValue2.Parent = valuesfolder;
                        DebrisModule:AddItem(NumberValue2, Config.ANIM_DURATION - 0.2);
                        table.insert(u10.Value_Table, NumberValue2);
                        u19 = script.CameraRig:Clone();
                        u19.Name = v26;
                        u19.PrimaryPart.CFrame = Part.CFrame * CFrame.new(0, 1.75, 0) * CFrame.fromEulerAnglesYXZ(-0, -1.0639230652031983e-7, -6.088167893002899e-16);
                        u19.Parent = workspace.Debree;
                        DebrisModule:AddItem(u19, Config.ANIM_DURATION - 0.2);
                        table.insert(u10.Value_Table, u19);
                        local v27 = u19.AnimationController:LoadAnimation(script.Camera);
                        v27:Play();
                        v27:AdjustSpeed(Config.ANIM_SPEED);
                        Cutscene_camera_handler.Regular(u6, u19.Bone);
                    end;

                    local v28 = u19 ~= nil and game.Players:GetPlayerFromCharacter(u21);

                    if v28 then
                        Cutscene_camera_handler.Regular(v28, u19.Bone);
                    end;

                    local BoolValue = Instance.new("BoolValue");
                    BoolValue.Name = "pause_gameplay";
                    BoolValue.Parent = u22;
                    DebrisModule:AddItem(BoolValue, Config.ANIM_DURATION);
                    table.insert(u10.Value_Table, BoolValue);
                    local StringValue = Instance.new("StringValue");
                    StringValue.Name = "iframe";
                    StringValue.Value = valuesfolder.Name;
                    StringValue.Parent = u22;
                    DebrisModule:AddItem(StringValue, Config.ANIM_DURATION);
                    table.insert(u10.Value_Table, StringValue);
                    local BoolValue2 = Instance.new("BoolValue");
                    BoolValue2.Name = "noragdoll";
                    BoolValue2.Parent = u22;
                    DebrisModule:AddItem(BoolValue2, Config.ANIM_DURATION);
                    table.insert(u10.Value_Table, BoolValue2);

                    if game.Players:GetPlayerFromCharacter(u21) then
                        table.insert(u20, game.Players:GetPlayerFromCharacter(u21));
                    end;

                    local Weld = Instance.new("Weld");
                    Weld.Part0 = Part;
                    Weld.Part1 = RootPart;
                    Weld.Parent = Part;
                    table.insert(u10.Value_Table, Weld);
                    local v29 = Humanoid2.Animator:LoadAnimation(script.Victim);
                    v29:Play();
                    v29:AdjustSpeed(Config.ANIM_SPEED);
                    table.insert(u10.Value_Table, v29);
                    Combat_Util.AddStun(script, Character, u22, Config.IMPACT_STUN);

                    if u18 == false then
                        u18 = true;
                        EffectsEvent.ToAllInRange(u6, "Fluterring_Sting_VFX", Character, "Cutscene", { v26, Config.ANIM_DURATION, Folder });
                    end;

                    task.delay(Config.THRUST_DAMAGE_AT, function() -- Line: 205
                        -- upvalues: u5 (ref), u6 (ref), u14 (ref), Character (ref), Checker (ref), u21 (copy), Combat_Util (ref), Config (ref), u22 (copy), Utility (ref), StatTypes (ref)
                        if u5.Id[u6.UserId] ~= u14 then
                            return;
                        end;

                        if u5.Id[u6.UserId] == u14 and (Character and Checker.check_victim(script, Character, u21) ~= nil) then
                            Combat_Util.Damage(script, Character, u21, {
                                Base = Config.THRUST_DAMAGE,
                                Skill = script.Parent.Name
                            });
                        end;

                        task.wait(Config.EXPLOSION_DELAY);

                        if u5.Id[u6.UserId] == u14 and (Character and Checker.check_victim(script, Character, u21) ~= nil) then
                            Combat_Util.AddStun(script, Character, u22, Config.EXPLOSION_STUN);
                            Combat_Util.Damage(script, Character, u21, {
                                Base = Config.EXPLOSION_DAMAGE,
                                Skill = script.Parent.Name
                            });
                            local v30 = Utility.AddValue(u22, Config.SLOW_VALUE, Config.SLOW_DURATION);
                            v30:AddTag(StatTypes.ValueStatTag);
                            v30:SetAttribute(StatTypes.StatToAttribute("Movement Speed Factor"), Config.SLOW_FACTOR);
                        end;
                    end);
                    task.delay(Config.ANIM_DURATION, function() -- Line: 230
                        -- upvalues: u5 (ref), u6 (ref), u14 (ref), u10 (ref)
                        if u5.Id[u6.UserId] ~= u14 then
                            return;
                        end;

                        if u10.Value_Table then
                            for _, v in u10.Value_Table do
                                if v:IsA("AnimationTrack") then
                                    v:Stop();
                                    v:Destroy();
                                else
                                    v:Destroy();
                                end;
                            end;
                        end;
                    end);
                end;
            end;
        end
    });

    if u13 == true then
        local BoolValue = Instance.new("BoolValue");
        BoolValue.Name = "NOMouvementlines";
        BoolValue.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue, Config.ANIM_DURATION);
        table.insert(u10.Value_Table, BoolValue);
        local BoolValue2 = Instance.new("BoolValue");
        BoolValue2.Name = "pause_gameplay";
        BoolValue2.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue2, Config.ANIM_DURATION);
        table.insert(u10.Value_Table, BoolValue2);
        local BoolValue3 = Instance.new("BoolValue");
        BoolValue3.Name = "iframe";
        BoolValue3.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue3, Config.ANIM_DURATION);
        table.insert(u10.Value_Table, BoolValue3);
        local BoolValue4 = Instance.new("BoolValue");
        BoolValue4.Name = "noragdoll";
        BoolValue4.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue4, Config.ANIM_DURATION);
        table.insert(u10.Value_Table, BoolValue4);
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.Massless = true;
        Part.Transparency = 1;
        Part.CFrame = u17;
        Part.CanCollide = false;
        Part.Parent = workspace.Debree;
        table.insert(u10.Value_Table, Part);
        DebrisModule:AddItem(Part, Config.ANIM_DURATION);
        local Weld = Instance.new("Weld");
        Weld.Part0 = Part;
        Weld.Part1 = HumanoidRootPart;
        Weld.Parent = Part;
        DebrisModule:AddItem(Weld, Config.ANIM_DURATION);
        table.insert(u10.Value_Table, Weld);
        local v31 = Humanoid:LoadAnimation(script.User);
        v31:Play();
        v31:AdjustSpeed(Config.ANIM_SPEED);
        v31.Priority = Enum.AnimationPriority.Action3;
        table.insert(u10.Value_Table, v31);
        CharGrabPosCorrector.Do(Character, v31, Config.ANIM_DURATION, Character);
    else
        EffectsEvent.ToAllInRange(u6, "Fluterring_Sting_VFX", Character, "Missed");
    end;

    u20 = nil;
end;

function u5.UnHold(p32: userdata, p33: any, p34: any) -- Line: 316
    -- upvalues: EffectsEvent (copy)
    if not p32 then
        return;
    end;

    local Character = p32.Character;

    if not Character then
        return;
    end;

    if not Character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    if not Character:FindFirstChild("Animator", true) then
        return;
    end;

    EffectsEvent.ToAllInRange(p32, "Fluterring_Sting_VFX", Character, "Jump");
end;

function u5.Cancel(p35, p36, p37) -- Line: 327
    -- upvalues: EffectsEvent (copy)
    if not p35 then
        return;
    end;

    local Character = p35.Character;

    if not Character then
        return;
    end;

    if not Character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    EffectsEvent.ToAllInRange(p35, "Fluterring_Sting_VFX", Character, "Cancel");

    if p37.Value_Table then
        for _, v in p37.Value_Table do
            if v:IsA("AnimationTrack") then
                v:Stop();
                v:Destroy();
            else
                v:Destroy();
            end;
        end;
    end;
end;

return u5;