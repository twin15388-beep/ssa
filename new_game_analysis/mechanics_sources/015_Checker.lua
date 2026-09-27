-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local os_clock = os.clock;
local u1 = {
    Enabled = true,
    Dashing = false,
    Climbing = false,
    Swimming = false,
    ShallowWater = false,
    MobVsMobAttribute = "CanHitMobs",
    DuelAttribute = "DuelId"
};
local u2 = { "Rasengan_Part" };
local u3 = RunService:IsServer();
local u4;

if u3 then
    u4 = require(game:GetService("ServerStorage").SAM.Utility.SkillStorage);
else
    u4 = nil;
end;

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local MuzanSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("MuzanSettings"));
local MinigameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("MinigameSettings"));
local Allegiance = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Allegiance"));
local StatsFetch = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("StatsFetch"));
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local u5 = { "dodge_left", "dodge_right" };

local function playDodge(p6: userdata) -- Line: 35
    -- upvalues: u5 (copy), Character_info_provider (copy)
    local v7 = p6:FindFirstChildOfClass("Humanoid");
    local v8;

    if v7 == nil then
        v8 = nil;
    else
        v8 = v7:FindFirstChildOfClass("Animator") or nil;
    end;

    if v8 == nil then
        return;
    end;

    local v9 = (tonumber(p6:GetAttribute("DodgeSide")) or 0) % #u5 + 1;
    p6:SetAttribute("DodgeSide", v9);
    local _core_anim = Character_info_provider.get_core_anim(p6, u5[v9]);

    if _core_anim == nil then
        return;
    end;

    v8:LoadAnimation(_core_anim):Play();
end;

local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local u10;

if u3 then
    u10 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
else
    u10 = nil;
end;

function u1.MinigameSidelined(p11: userdata) -- Line: 51
    if workspace:GetAttribute("MinigameKey") == nil then
        return false;
    end;

    return (workspace:GetAttribute("MinigameState") == "Lobby" or p11:GetAttribute("Spectating") == true) and true or p11:GetAttribute("MinigameLobby") ~= nil;
end;

function u1.DenyLoadoutChange(p12: userdata) -- Line: 59
    -- upvalues: MinigameSettings (copy), u1 (copy), u10 (copy), ReplicatedStorage (copy)
    if MinigameSettings.Get("LoadoutLockedWhileFielded") ~= true then
        return false;
    end;

    local v13 = p12.Character and p12.Character:FindFirstChildOfClass("Humanoid");

    if workspace:GetAttribute("MinigameState") ~= "Fighting" or (u1.MinigameSidelined(p12) or (v13 == nil or v13.Health <= 0)) then
        return false;
    end;

    local v14 = {
        Text = "Equipment can only be changed between lives",
        Type = "Denied"
    };

    if u10 == nil then
        ReplicatedStorage.Communication.CnC.Notifications.Notification:Fire("Notify", v14);
    else
        u10.ToClient(p12, "Notify", v14);
    end;

    return true;
end;

function u1.check(p15, p16, p17, p18) -- Line: 75
    -- upvalues: Utility (copy), u2 (copy), Players (copy), MuzanSettings (copy), u1 (copy), StatsFetch (copy), RunService (copy), os_clock (copy), Combat_presets (copy)
    local v19 = p16 ~= nil and game.ReplicatedStorage.Skills.Misc.Dashes:FindFirstChild(p16) and "Dash" or p16;
    local valuesfolder = Utility.getvaluesfolder(p15);
    local v20 = true;
    local v21 = true;
    local v22;

    if p15.Parent == game.Players then
        v22 = p15.Character;
    else
        v22 = p15;
    end;

    if v22 then
        for _, v in pairs(u2) do
            if v22:FindFirstChild(v) ~= nil then
                v21 = false;
            end;
        end;
    end;

    local v23;

    if v22 == nil then
        v23 = false;
    else
        v23 = v22:FindFirstChild("SHC") or v22:FindFirstChild("SHCS");
    end;

    local v24 = true;
    local v25;

    if p15 == nil or (p15.Parent ~= game.Players or not p15) then
        if v22 == nil then
            v25 = nil;
        else
            v25 = Players:GetPlayerFromCharacter(v22) or nil;
        end;
    else
        v25 = p15;
    end;

    if v25 ~= nil and (v25:GetAttribute(MuzanSettings.LairAttribute) == true and MuzanSettings.LairActionBypasses[p17] ~= true) then
        v24 = false;
    end;

    local v26;

    if v25 == nil then
        v26 = false;
    else
        v26 = u1.MinigameSidelined(v25);
    end;

    local v27;

    if p17 == "Riding" then
        v27 = valuesfolder:FindFirstChild("RidingHorse") ~= nil;
    else
        v27 = false;
    end;

    local v28 = v19 ~= "combat" and true or valuesfolder:FindFirstChild("combatdisabled") == nil;

    if v26 == false or (v19 == "Dash" or (v19 == "Run" or (v19 == "Double Jump" or v19 == "Climb"))) then
        if v28 then
            if v24 then
                if v22 == nil or v22:FindFirstChild("Transforming_to_mode") ~= nil then
                    v27 = false;
                elseif valuesfolder:FindFirstChild("pause_gameplay") == nil or v27 then
                    v27 = valuesfolder:FindFirstChild("Stun") == nil and valuesfolder:FindFirstChild("CombatStun") == nil or StatsFetch.HasStunBypass(v22, v19);

                    if v27 then
                        if valuesfolder:FindFirstChild("Strict_Stun") ~= nil or v21 ~= true and (v19 ~= "Dash" and (v19 ~= "Double_Jump" and v19 ~= "Run")) or (v22 == nil or (v22:FindFirstChild("Humanoid") == nil or (v22.Humanoid.Health <= 0 or v22.Humanoid:GetState() == Enum.HumanoidStateType.Dead))) then
                            v27 = false;
                        else
                            v27 = valuesfolder:FindFirstChild("Blocking") == nil or StatsFetch.CanPlayOver(v22, v19, "Blocking");

                            if v27 then
                                if valuesfolder:FindFirstChild("Swapping") == nil then
                                    v27 = (valuesfolder:FindFirstChild("Training") == nil or (v19 == "Dash" or (v19 == "Run" or v19 == "Double Jump"))) and true or p17 == "Training";
                                else
                                    v27 = false;
                                end;
                            end;
                        end;
                    end;
                end;
            else
                v27 = v24;
            end;
        else
            v27 = v28;
        end;
    else
        v27 = false;
    end;

    if RunService:IsClient() == true then
        local v29 = (p15 == nil or v22 == nil or (v23 == nil or (v23.Value == "" or StatsFetch.CanPlayOver(v22, v19, v23.Value))) and valuesfolder:FindFirstChild("Using_Skill_Switch") == nil) and true or false;

        if u1.Enabled == true and (v29 == true and (u1.Dashing == false or (v19 == "combat" or (v19 == "Dash" or v19 == "Double_Jump")))) and ((u1.Climbing == false or v19 == "Climb") and (u1.Swimming == false or (v19 == "Climb" or v19 == "Run" and u1.ShallowWater == true))) then
            v20 = os_clock() - Combat_presets.Last_Punched > Combat_presets.slow_walk_duration and true or v19 == "combat";
        else
            v20 = false;
        end;
    elseif v22 ~= nil and (v23 ~= nil and (v23.Value ~= "" and not StatsFetch.CanPlayOver(v22, v19, v23.Value))) then
        v27 = false;
    end;

    local v30;

    if v27 == true then
        v30 = v20 == true;
    else
        v30 = false;
    end;

    return v30;
end;

function u1.check_can_select(p31, p32, p33) -- Line: 147
    -- upvalues: Allegiance (copy), StatsFetch (copy)
    if p31 ~= nil and (p32 ~= nil and p33 ~= nil) then
        local v34 = true;

        if Allegiance.Protected(p32, p33) then
            return false;
        end;

        if p33 ~= nil then
            if StatsFetch.HasInvisibility(p33) then
                v34 = false;
            end;
        end;

        return v34;
    end;
end;

function check_iframe(p35, p36, p37)
    -- upvalues: StatsFetch (copy)
    local v38 = false;

    if p36:FindFirstChild("Clone_Owner") or p37:FindFirstChild("Clone_Owner") then
        local v39 = p36:FindFirstChild("Clone_Owner") and p36.Clone_Owner.Value == p37.Name;
        local v40 = p37:FindFirstChild("Clone_Owner") and p37.Clone_Owner.Value == p36.Name;
        local v41 = p37:FindFirstChild("Clone_Owner") and p36:FindFirstChild("Clone_Owner");
        local v42;

        if v41 then
            v42 = p37.Clone_Owner.Value == p36.Clone_Owner.Value;
        else
            v42 = false;
        end;

        v38 = v39 or (v40 or (v41 and v42 or v38));
    end;

    return StatsFetch.GetIFrame(p37, p36) ~= nil and true or v38;
end;

local u43;

if game:GetService("ServerStorage"):FindFirstChild("SAM") == nil then
    u43 = nil;
else
    u43 = game.ServerStorage.SAM.Game_Play.Combats;
end;

local function trainingShields(p44: userdata, p45: userdata) -- Line: 200
    local Training = p45:FindFirstChild("Training");

    if Training == nil then
        return false;
    end;

    local Attribute = Training:GetAttribute("LeashCenter");
    local Attribute2 = Training:GetAttribute("LeashRadius");

    if Attribute == nil or Attribute2 == nil then
        return true;
    end;

    local HumanoidRootPart = p44:FindFirstChild("HumanoidRootPart");
    local v46;

    if HumanoidRootPart == nil then
        v46 = false;
    else
        v46 = (HumanoidRootPart.Position - Attribute).Magnitude <= Attribute2;
    end;

    return v46;
end;

function u1.check_victim(p47: userdata, p48: userdata, p49: userdata, p50: any) -- Line: 209
    -- upvalues: Players (copy), MuzanSettings (copy), u1 (copy), MinigameSettings (copy), Allegiance (copy), Utility (copy), trainingShields (copy), u3 (copy), u43 (ref), StatsFetch (copy), u4 (copy), EffectsEvent (copy), playDodge (copy), Menum (copy)
    local v51 = nil;

    if p49 == nil then
        return;
    end;

    local Attribute = p48:GetAttribute("IsMob");
    local Attribute2 = p49:GetAttribute("IsMob");
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p48);

    if PlayerFromCharacter == nil then
        local Clone_Owner = p48:FindFirstChild("Clone_Owner");

        if Clone_Owner ~= nil and Clone_Owner:IsA("StringValue") then
            PlayerFromCharacter = Players:FindFirstChild(Clone_Owner.Value);
        end;
    end;

    if p48 ~= p49 and (PlayerFromCharacter ~= nil and not Attribute2) then
        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p49);

        if PlayerFromCharacter2 ~= nil and PlayerFromCharacter2:GetAttribute("Situation") == "Safezone" then
            return;
        end;

        if PlayerFromCharacter:GetAttribute("Situation") == "Safezone" then
            return;
        end;
    end;

    if p48 ~= p49 then
        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p49);

        if PlayerFromCharacter2 ~= nil and (PlayerFromCharacter2:GetAttribute(MuzanSettings.LairAttribute) == true and PlayerFromCharacter2:GetAttribute("SecondarySituation") == MuzanSettings.LairSituation.SecondaryName) then
            return;
        end;
    end;

    if p48 ~= p49 then
        local v52;

        if PlayerFromCharacter == nil then
            v52 = p48;
        else
            v52 = PlayerFromCharacter.Character;
        end;

        local v53;

        if v52 == nil then
            v53 = nil;
        else
            v53 = v52:GetAttribute(u1.DuelAttribute);
        end;

        if v53 ~= p49:GetAttribute(u1.DuelAttribute) then
            return;
        end;
    end;

    if p48 ~= p49 and (Attribute and (Attribute2 and (p48:GetAttribute(u1.MobVsMobAttribute) ~= true and p49:GetAttribute(u1.MobVsMobAttribute) ~= true))) then
        return;
    end;

    if p48 ~= p49 and workspace:GetAttribute("MinigameKey") ~= nil then
        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p49);

        if PlayerFromCharacter2 ~= nil and u1.MinigameSidelined(PlayerFromCharacter2) then
            return;
        end;
    end;

    if p48 ~= p49 and (MinigameSettings.Get("NoPlayerVersusPlayer") == true and Players:GetPlayerFromCharacter(p49) ~= nil) then
        if Players:GetPlayerFromCharacter(p48) ~= nil then
            return;
        end;

        local Clone_Owner = p48:FindFirstChild("Clone_Owner");

        if Clone_Owner ~= nil and (Clone_Owner:IsA("StringValue") and Players:FindFirstChild(Clone_Owner.Value) ~= nil) then
            return;
        end;
    end;

    if not Allegiance.Protected(p48, p49) then
        local Humanoid = p49:FindFirstChild("Humanoid");

        if Humanoid ~= nil and not Humanoid:IsA("Humanoid") then
            Humanoid = nil;
        end;

        local valuesfolder = Utility.getvaluesfolder(p49);

        if Humanoid ~= nil and (p47 ~= nil and (p48 ~= nil and (p49 ~= nil and (p49.Parent ~= nil and (Humanoid.Health > 0 and (valuesfolder:FindFirstChild("Swapping") == nil and not (trainingShields(p49, valuesfolder) or check_iframe(p47, p48, p49) ~= false and (not p50 or p50.iframe == nil)))))))) then
            local v54;

            if typeof(p50) == "table" then
                v54 = p50.NoReactions == true;
            else
                v54 = false;
            end;

            if p48 ~= p49 and not (v54 or p50 ~= nil and (not p50 or p50.iframe ~= nil)) then
                if p48 ~= p49 and (u3 and Players:GetPlayerFromCharacter(p49) == nil) then
                    local Attribute3 = p49:GetAttribute("NpcCounter");

                    if Attribute3 ~= nil then
                        local v55;

                        if u43 == nil then
                            v55 = false;
                        else
                            v55 = p47:IsDescendantOf(u43);
                        end;

                        if Attribute3 == 1 and v55 and true or (Attribute3 == 3 and v55 == false and true or (Attribute3 == 2 and true or false)) then
                            p49:SetAttribute("NpcCounter", nil);
                            local ObjectValue = Instance.new("ObjectValue");
                            ObjectValue.Name = "NpcCounterTriggered";
                            ObjectValue.Value = p48;
                            ObjectValue.Parent = p49;
                            task.delay(1, function() -- Line: 327
                                -- upvalues: ObjectValue (copy)
                                if ObjectValue.Parent ~= nil then
                                    ObjectValue:Destroy();
                                end;
                            end);

                            return;
                        end;
                    end;
                end;

                local Counter, v56, v57 = StatsFetch.GetCounter(p49, valuesfolder);
                local v58;

                if u43 == nil then
                    v58 = false;
                else
                    v58 = p47:IsDescendantOf(u43);
                end;

                if Counter and Counter > 0 then
                    local v59 = (Counter == 1 and v58 or Counter == 3 and v58 == false) and true or (Counter == 2 and true or false);

                    if v59 and (v57 ~= nil and v57:GetAttribute("Record") == true) then
                        v59 = false;

                        if v58 == false and p47.Parent ~= nil then
                            local Name = p47.Parent.Name;
                            local Attribute3 = v57:GetAttribute("Recorded");

                            if Attribute3 == nil then
                                v57:SetAttribute("Recorded", Name);
                            elseif Attribute3 == Name then
                                v57:SetAttribute("Recorded", nil);
                                v59 = true;
                            end;
                        end;
                    end;

                    if v59 then
                        local PlayerFromCharacter2 = game.Players:GetPlayerFromCharacter(p49);

                        if u4 ~= nil and PlayerFromCharacter2 ~= nil then
                            u4.GetID(PlayerFromCharacter2, v56).CounterTarget = p48;
                        end;

                        EffectsEvent.ToClient(PlayerFromCharacter2, "force_skill_actions_server", v56, "Counter", nil, true, p48);

                        return;
                    end;
                end;

                local v60 = valuesfolder:FindFirstChild(Utility.DODGE_VALUE);

                if v60 ~= nil and (v60:IsA("IntValue") and (v60.Value > 0 and (v60:GetAttribute("Mode") ~= "Combat" or v58))) then
                    if u3 then
                        v60.Value = v60.Value - 1;

                        if v60.Value <= 0 then
                            v60:Destroy();
                        end;

                        playDodge(p49);
                    end;

                    return;
                end;

                local v61 = false;
                local v62 = {};

                if valuesfolder:FindFirstChild("SkillToggle") then
                    for _, child in pairs(valuesfolder:GetChildren()) do
                        if child.Name == "SkillToggle" and (child.Value ~= "" and table.find(v62, child.Value) == nil) then
                            local Attribute3 = child:GetAttribute("OnlySkill");

                            if (Attribute3 == nil or not (v58 or (p47.Parent == nil or p47.Parent.Name ~= Attribute3))) and (child and child:FindFirstChild("Mode")) then
                                if ((child.Mode.Value == Menum.toggleSkillMode.combat and v58 == true or child.Mode.Value == Menum.toggleSkillMode.skill and v58 == false) and true or (child.Mode.Value == Menum.toggleSkillMode.all and true or false)) == true then
                                    local Value = child.Value;

                                    if u3 then
                                        game.ServerStorage.SAM.Services.Skill_Controller_S.Function:Invoke(game.Players:GetPlayerFromCharacter(p49), Value, p48, child.Remaining.Value - 1);
                                    end;

                                    EffectsEvent.ToClient(game.Players:GetPlayerFromCharacter(p49), "force_skill_actions_server", Value, "Toggle", nil, false, p48, child.Remaining.Value - 1);
                                    v61 = child.Type.Value == Menum.toggleSkillType.iframe and true or v61;
                                end;

                                table.insert(v62, child.Value);

                                if child.Remaining.Value > 1 then
                                    local Remaining = child.Remaining;
                                    Remaining.Value = Remaining.Value - 1;
                                else
                                    child:Destroy();
                                end;
                            end;
                        end;
                    end;
                end;

                if v61 then
                    return;
                end;
            end;

            if valuesfolder:FindFirstChild("Blocking") == nil or valuesfolder:FindFirstChild("PierceBlock") ~= nil then
                v51 = true;
            else
                local v63 = false;
                v51 = valuesfolder:FindFirstChild("Blocking") ~= nil and (v63 == false and v63 == false) and (valuesfolder.Blocking:FindFirstChild("Perfect") == nil and (not Attribute or valuesfolder.Blocking:FindFirstChild("PerfectNpc") == nil) and "Blocking" or "Perfect") or v51;
            end;
        end;

        return v51;
    end;
end;

return u1;