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
    MobVsMobAttribute = "CanHitMobs"
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

local function playDodge(p6: userdata) -- Line: 30
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

function u1.MinigameSidelined(p11: userdata) -- Line: 46
    if workspace:GetAttribute("MinigameKey") == nil then
        return false;
    end;

    return (workspace:GetAttribute("MinigameState") == "Lobby" or p11:GetAttribute("Spectating") == true) and true or p11:GetAttribute("MinigameLobby") ~= nil;
end;

function u1.DenyLoadoutChange(p12: userdata) -- Line: 54
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

function u1.check(p15, p16, p17, p18) -- Line: 70
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
                        elseif valuesfolder:FindFirstChild("Blocking") == nil then
                            if valuesfolder:FindFirstChild("Swapping") == nil then
                                v27 = (valuesfolder:FindFirstChild("Training") == nil or (v19 == "Dash" or (v19 == "Run" or v19 == "Double Jump"))) and true or p17 == "Training";
                            else
                                v27 = false;
                            end;
                        elseif v23 == nil then
                            v27 = false;
                        else
                            v27 = StatsFetch.CanPlayOver(v22, v19, v23.Value);

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

function u1.check_can_select(p31, p32, p33) -- Line: 142
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

function u1.check_victim(p44: userdata, p45: userdata, p46: userdata, p47: any) -- Line: 192
    -- upvalues: Players (copy), MuzanSettings (copy), u1 (copy), MinigameSettings (copy), Allegiance (copy), Utility (copy), u3 (copy), u43 (ref), StatsFetch (copy), u4 (copy), EffectsEvent (copy), playDodge (copy), Menum (copy)
    local v48 = nil;

    if p46 == nil then
        return;
    end;

    local Attribute = p45:GetAttribute("IsMob");
    local Attribute2 = p46:GetAttribute("IsMob");
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p45);

    if PlayerFromCharacter == nil then
        local Clone_Owner = p45:FindFirstChild("Clone_Owner");

        if Clone_Owner ~= nil and Clone_Owner:IsA("StringValue") then
            PlayerFromCharacter = Players:FindFirstChild(Clone_Owner.Value);
        end;
    end;

    if p45 ~= p46 and (PlayerFromCharacter ~= nil and not Attribute2) then
        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p46);

        if PlayerFromCharacter2 ~= nil and PlayerFromCharacter2:GetAttribute("Situation") == "Safezone" then
            return;
        end;

        if PlayerFromCharacter:GetAttribute("Situation") == "Safezone" then
            return;
        end;
    end;

    if p45 ~= p46 then
        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p46);

        if PlayerFromCharacter2 ~= nil and PlayerFromCharacter2:GetAttribute(MuzanSettings.LairAttribute) == true then
            return;
        end;
    end;

    if p45 ~= p46 and (Attribute and (Attribute2 and (p45:GetAttribute(u1.MobVsMobAttribute) ~= true and p46:GetAttribute(u1.MobVsMobAttribute) ~= true))) then
        return;
    end;

    if p45 ~= p46 and workspace:GetAttribute("MinigameKey") ~= nil then
        local PlayerFromCharacter2 = Players:GetPlayerFromCharacter(p46);

        if PlayerFromCharacter2 ~= nil and u1.MinigameSidelined(PlayerFromCharacter2) then
            return;
        end;
    end;

    if p45 ~= p46 and (MinigameSettings.Get("NoPlayerVersusPlayer") == true and Players:GetPlayerFromCharacter(p46) ~= nil) then
        if Players:GetPlayerFromCharacter(p45) ~= nil then
            return;
        end;

        local Clone_Owner = p45:FindFirstChild("Clone_Owner");

        if Clone_Owner ~= nil and (Clone_Owner:IsA("StringValue") and Players:FindFirstChild(Clone_Owner.Value) ~= nil) then
            return;
        end;
    end;

    if not Allegiance.Protected(p45, p46) then
        local Humanoid = p46:FindFirstChild("Humanoid");

        if Humanoid ~= nil and not Humanoid:IsA("Humanoid") then
            Humanoid = nil;
        end;

        local valuesfolder = Utility.getvaluesfolder(p46);

        if Humanoid ~= nil and (p44 ~= nil and (p45 ~= nil and (p46 ~= nil and (p46.Parent ~= nil and (Humanoid.Health > 0 and (valuesfolder:FindFirstChild("Swapping") == nil and (valuesfolder:FindFirstChild("Training") == nil and (check_iframe(p44, p45, p46) == false or p47 and p47.iframe ~= nil)))))))) then
            local v49;

            if typeof(p47) == "table" then
                v49 = p47.NoReactions == true;
            else
                v49 = false;
            end;

            if p45 ~= p46 and not (v49 or p47 ~= nil and (not p47 or p47.iframe ~= nil)) then
                if p45 ~= p46 and (u3 and Players:GetPlayerFromCharacter(p46) == nil) then
                    local Attribute3 = p46:GetAttribute("NpcCounter");

                    if Attribute3 ~= nil then
                        local v50;

                        if u43 == nil then
                            v50 = false;
                        else
                            v50 = p44:IsDescendantOf(u43);
                        end;

                        if Attribute3 == 1 and v50 and true or (Attribute3 == 3 and v50 == false and true or (Attribute3 == 2 and true or false)) then
                            p46:SetAttribute("NpcCounter", nil);
                            local ObjectValue = Instance.new("ObjectValue");
                            ObjectValue.Name = "NpcCounterTriggered";
                            ObjectValue.Value = p45;
                            ObjectValue.Parent = p46;
                            task.delay(1, function() -- Line: 302
                                -- upvalues: ObjectValue (copy)
                                if ObjectValue.Parent ~= nil then
                                    ObjectValue:Destroy();
                                end;
                            end);

                            return;
                        end;
                    end;
                end;

                local Counter, v51, v52 = StatsFetch.GetCounter(p46, valuesfolder);
                local v53;

                if u43 == nil then
                    v53 = false;
                else
                    v53 = p44:IsDescendantOf(u43);
                end;

                if Counter and Counter > 0 then
                    local v54 = (Counter == 1 and v53 or Counter == 3 and v53 == false) and true or (Counter == 2 and true or false);

                    if v54 and (v52 ~= nil and v52:GetAttribute("Record") == true) then
                        v54 = false;

                        if v53 == false and p44.Parent ~= nil then
                            local Name = p44.Parent.Name;
                            local Attribute3 = v52:GetAttribute("Recorded");

                            if Attribute3 == nil then
                                v52:SetAttribute("Recorded", Name);
                            elseif Attribute3 == Name then
                                v52:SetAttribute("Recorded", nil);
                                v54 = true;
                            end;
                        end;
                    end;

                    if v54 then
                        local PlayerFromCharacter2 = game.Players:GetPlayerFromCharacter(p46);

                        if u4 ~= nil and PlayerFromCharacter2 ~= nil then
                            u4.GetID(PlayerFromCharacter2, v51).CounterTarget = p45;
                        end;

                        EffectsEvent.ToClient(PlayerFromCharacter2, "force_skill_actions_server", v51, "Counter", nil, true, p45);

                        return;
                    end;
                end;

                local v55 = valuesfolder:FindFirstChild(Utility.DODGE_VALUE);

                if v55 ~= nil and (v55:IsA("IntValue") and (v55.Value > 0 and (v55:GetAttribute("Mode") ~= "Combat" or v53))) then
                    if u3 then
                        v55.Value = v55.Value - 1;

                        if v55.Value <= 0 then
                            v55:Destroy();
                        end;

                        playDodge(p46);
                    end;

                    return;
                end;

                local v56 = false;
                local v57 = {};

                if valuesfolder:FindFirstChild("SkillToggle") then
                    for _, child in pairs(valuesfolder:GetChildren()) do
                        if child.Name == "SkillToggle" and (child.Value ~= "" and table.find(v57, child.Value) == nil) then
                            local Attribute3 = child:GetAttribute("OnlySkill");

                            if (Attribute3 == nil or not (v53 or (p44.Parent == nil or p44.Parent.Name ~= Attribute3))) and (child and child:FindFirstChild("Mode")) then
                                if ((child.Mode.Value == Menum.toggleSkillMode.combat and v53 == true or child.Mode.Value == Menum.toggleSkillMode.skill and v53 == false) and true or (child.Mode.Value == Menum.toggleSkillMode.all and true or false)) == true then
                                    local Value = child.Value;

                                    if u3 then
                                        game.ServerStorage.SAM.Services.Skill_Controller_S.Function:Invoke(game.Players:GetPlayerFromCharacter(p46), Value, p45, child.Remaining.Value - 1);
                                    end;

                                    EffectsEvent.ToClient(game.Players:GetPlayerFromCharacter(p46), "force_skill_actions_server", Value, "Toggle", nil, false, p45, child.Remaining.Value - 1);
                                    v56 = child.Type.Value == Menum.toggleSkillType.iframe and true or v56;
                                end;

                                table.insert(v57, child.Value);

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

                if v56 then
                    return;
                end;
            end;

            if valuesfolder:FindFirstChild("Blocking") == nil or valuesfolder:FindFirstChild("PierceBlock") ~= nil then
                v48 = true;
            else
                local v58 = false;
                v48 = valuesfolder:FindFirstChild("Blocking") ~= nil and (v58 == false and v58 == false) and (valuesfolder.Blocking:FindFirstChild("Perfect") == nil and (not Attribute or valuesfolder.Blocking:FindFirstChild("PerfectNpc") == nil) and "Blocking" or "Perfect") or v48;
            end;
        end;

        return v48;
    end;
end;

return u1;