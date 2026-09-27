-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = {}
};
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Combat_Util = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Combat_Util"));
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local table_find = table.find;
local table_insert = table.insert;
require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Server_Mouse_Pos"));
local u2 = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("hit_priority_handler")).new(script);
local Config = require(script.Parent.Config);
local ANIM_SPEED = Config.ANIM_SPEED;
local u3 = Config.ATTACKER_ANIM_TIME / ANIM_SPEED;
local u4 = Config.VICTIM_ANIM_TIME / ANIM_SPEED;

local function timedThread(p5, p6) -- Line: 23
    local coroutine_create_ret = coroutine.create(p5);
    task.delay(p6 or 5, function() -- Line: 25
        -- upvalues: coroutine_create_ret (copy)
        if coroutine.status(coroutine_create_ret) == "running" then
            coroutine.close(coroutine_create_ret);
        end;
    end);
    local coroutine_resume_ret, v7 = coroutine.resume(coroutine_create_ret);

    if not coroutine_resume_ret then
        warn(v7);
    end;

    return coroutine_create_ret;
end;

function u1.Hold(p8, p9, p10) -- Line: 39
    -- upvalues: u1 (copy), EffectsEvent (copy)
    local Character = p8.Character;
    local _ = u1.Id[p8.UserId];

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if HumanoidRootPart == nil then
        return;
    end;

    if Humanoid == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "CoilChoke_effs", Character, "Startup");
end;

local ManuelCancel = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("ManuelCancel"));
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);

function u1.UnHold(u11, p12, p13) -- Line: 57
    -- upvalues: u1 (copy), EffectsEvent (copy), Utility (copy), Config (copy), timedThread (copy), Checker (copy), u2 (copy), Combat_Util (copy), Combat_presets (copy), Character_info_provider (copy), ManuelCancel (copy), Players (copy), ANIM_SPEED (copy), DebrisModule (copy), u4 (copy), table_find (copy), table_insert (copy), u3 (copy)
    local Character = u11.Character;
    local u14 = u1.Id[u11.UserId];

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if HumanoidRootPart == nil then
        return;
    end;

    if Humanoid == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "CoilChoke_effs", Character, "Start");
    local u15 = Utility.AddValue(Utility.getvaluesfolder(Character), "pause_gameplay", Config.CAST_LOCK_DUR);
    local u16 = {};
    task.delay(Config.PREGRAB_DELAY, function() -- Line: 69
        -- upvalues: u14 (copy), u1 (ref), u11 (copy), timedThread (ref), Config (ref), Utility (ref), Character (copy), HumanoidRootPart (copy), u16 (ref), Checker (ref), u2 (ref), Combat_Util (ref), EffectsEvent (ref), Combat_presets (ref), Character_info_provider (ref)
        if u14 ~= u1.Id[u11.UserId] then
            return;
        end;

        timedThread(function(...) -- Line: 71
            -- upvalues: u14 (ref), u1 (ref), u11 (ref), Config (ref), Utility (ref), Character (ref), HumanoidRootPart (ref), u16 (ref), Checker (ref), u2 (ref), Combat_Util (ref), EffectsEvent (ref), Combat_presets (ref), Character_info_provider (ref)
            if u14 ~= u1.Id[u11.UserId] then
                return;
            end;

            local PREGRAB_SCAN_DUR = Config.PREGRAB_SCAN_DUR;
            local valuesfolder = Utility.getvaluesfolder(Character);
            local v17 = HumanoidRootPart.CFrame * Config.PREGRAB_HITBOX_OFFSET;
            local os_clock_ret = os.clock();

            while true do
                if u14 ~= u1.Id[u11.UserId] or os_clock_ret + PREGRAB_SCAN_DUR <= os.clock() then
                    return;
                end;

                u16 = Utility.GetModelInRegion(v17, Config.PREGRAB_HITBOX_SIZE, nil, nil);

                for _, v in pairs(u16) do
                    if u14 ~= u1.Id[u11.UserId] then
                        break;
                    end;

                    if v ~= Character and v:FindFirstChild("Humanoid") ~= nil then
                        local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");
                        local Humanoid2 = v:FindFirstChild("Humanoid");
                        local v18, _ = Checker.check_victim(script, Character, v);
                        local valuesfolder2 = Utility.getvaluesfolder(v);

                        if u2.Both(valuesfolder2, {
                            name = "Choosing_1",
                            pv = valuesfolder
                        }) ~= true then
                            local HumanoidRootPart3 = Character:FindFirstChild("HumanoidRootPart");

                            if HumanoidRootPart2 ~= nil and (Humanoid2 ~= nil and HumanoidRootPart3 ~= nil) then
                                if v18 == "Perfect" then
                                    Combat_Util.Perfect(script, Character, v);
                                elseif v18 == true or v18 == "Blocking" then
                                    if v18 == "Blocking" then
                                        Combat_Util.Block(script, Character, v, Config.PREGRAB_BLOCK_BREAK);
                                    else
                                        Combat_Util.AddStun(script, Character, valuesfolder2, Config.PREGRAB_STUN);
                                        EffectsEvent.ToAllInRange(HumanoidRootPart, "Normal_Sword_Slash_Effect", HumanoidRootPart2, -1);
                                        Combat_Util.Knockback(script, Character, HumanoidRootPart2, Vector3.new(0, Config.PREGRAB_KNOCKUP, 0), Config.PREGRAB_KNOCKUP_DUR);
                                        Combat_Util.Damage(script, Character, v, {
                                            Base = Config.PREGRAB_DAMAGE,
                                            Skill = script.Parent.Name
                                        });
                                        Combat_presets.stop_extra_anims(Humanoid2);
                                        local math_random_ret = math.random(1, 5);
                                        local v19 = Humanoid2.Animator:LoadAnimation(Character_info_provider.get_core_anim(Character, "React_" .. (math_random_ret == 5 and 6 or math_random_ret)));
                                        v19:AdjustSpeed(2.25);
                                        v19:Play();
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                task.wait(Config.PREGRAB_TICK);
            end;
        end, 1.5);
    end);
    local v20, _ = ManuelCancel.new(u11, Config.GRAB_CANCEL_WINDOW);
    v20:Connect(function() -- Line: 134
        -- upvalues: u1 (ref), u11 (copy), u15 (copy), EffectsEvent (ref), HumanoidRootPart (copy), Character (copy)
        u1.Id[u11.UserId] = 0;
        u15:Destroy();
        EffectsEvent.ToAllInRange(HumanoidRootPart, "CoilChoke_effs", Character, "Cancel");
    end);
    task.delay(Config.GRAB_AT, function() -- Line: 143
        -- upvalues: u1 (ref), u11 (copy), u14 (copy), Utility (ref), Character (copy), Config (ref), u16 (ref), Checker (ref), u2 (ref), Combat_Util (ref), Players (ref), ANIM_SPEED (ref), DebrisModule (ref), u4 (ref), EffectsEvent (ref), table_find (ref), table_insert (ref), u3 (ref)
        if u1.Id[u11.UserId] ~= u14 then
            return;
        end;

        local v21 = false;
        Utility.getvaluesfolder(Character);
        local GRAB_BLOCK_BREAK = Config.GRAB_BLOCK_BREAK;
        local FINISH_DAMAGE = Config.FINISH_DAMAGE;
        local Character2 = u11.Character;

        if Character2 == nil then
            return;
        end;

        local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart");
        local valuesfolder = Utility.getvaluesfolder(Character2);
        local Humanoid2 = Character2:FindFirstChild("Humanoid");

        if Humanoid2 == nil then
            return;
        end;

        local u22 = HumanoidRootPart2.CFrame * Config.GRAB_HITBOX_OFFSET;
        local GRAB_HITBOX_SIZE = Config.GRAB_HITBOX_SIZE;
        local u23 = {};
        local u24 = {};
        local v25 = false;
        local v26 = {};
        local u27 = {};

        for _, v in pairs(u16) do
            if v25 == true then
                break;
            end;

            if v ~= Character2 and v:FindFirstChild("Humanoid") ~= nil then
                local HumanoidRootPart3 = v:FindFirstChild("HumanoidRootPart");
                local Humanoid3 = v:FindFirstChild("Humanoid");
                local v28, _ = Checker.check_victim(script, Character2, v);
                local valuesfolder2 = Utility.getvaluesfolder(v);

                if u2.Both(valuesfolder2, {
                    name = "Choosing_1",
                    pv = valuesfolder
                }) ~= true then
                    local HumanoidRootPart4 = Character2:FindFirstChild("HumanoidRootPart");

                    if HumanoidRootPart3 ~= nil and (Humanoid3 ~= nil and HumanoidRootPart4 ~= nil) then
                        if v28 == "Perfect" then
                            Combat_Util.Perfect(script, Character2, v);
                        elseif v28 == "Blocking" then
                            Combat_Util.Block(script, Character2, v, GRAB_BLOCK_BREAK);
                        elseif v28 == true then
                            if Players:GetPlayerFromCharacter(v) ~= nil then
                                Utility.AddValue(valuesfolder2, "iframe", Config.VICTIM_PVP_IFRAME_DUR, "StringValue", Character2.Name);
                            end;

                            Combat_Util.Damage(script, Character2, v, {
                                Base = Config.SLAM_DAMAGE,
                                Skill = script.Parent.Name
                            });
                            task.delay(Config.PULL_DAMAGE_AT / ANIM_SPEED, function() -- Line: 199
                                -- upvalues: Combat_Util (ref), Character2 (copy), v (copy), Config (ref)
                                Combat_Util.Damage(script, Character2, v, {
                                    Base = Config.PULL_DAMAGE,
                                    Skill = script.Parent.Name
                                });
                            end);
                            local Part = Instance.new("Part");
                            Part.Anchored = true;
                            Part.Transparency = 1;
                            Part.Massless = true;
                            Part.CFrame = u22;
                            Part.CanCollide = false;
                            Part.Parent = workspace.Debree;
                            DebrisModule:AddItem(Part, u4);
                            local BoolValue = Instance.new("BoolValue");
                            BoolValue.Name = "pause_gameplay";
                            BoolValue.Parent = valuesfolder2;
                            DebrisModule:AddItem(BoolValue, u4);
                            local BoolValue2 = Instance.new("BoolValue");
                            BoolValue2.Name = "noragdoll";
                            BoolValue2.Parent = valuesfolder2;
                            DebrisModule:AddItem(BoolValue2, u4);

                            if game.Players:GetPlayerFromCharacter(v) then
                                table.insert(v26, game.Players:GetPlayerFromCharacter(v));
                            end;

                            local Weld = Instance.new("Weld");
                            Weld.Part0 = Part;
                            Weld.Part1 = HumanoidRootPart3;
                            Weld.Parent = Part;
                            local v29 = Humanoid3.Animator:LoadAnimation(script.coilchoke_victim);
                            v29.Priority = Enum.AnimationPriority.Action4;
                            v29:Play(0, 1, ANIM_SPEED);
                            local BoolValue3 = Instance.new("BoolValue");
                            BoolValue3.Name = "noragdoll";
                            BoolValue3.Parent = valuesfolder2;
                            Combat_Util.AddStun(script, Character2, valuesfolder2, u4 + Config.GRAB_STUN_EXTRA);
                            DebrisModule:AddItem(BoolValue3, u4);
                            table.insert(u23, Weld);
                            table.insert(u23, BoolValue3);
                            table.insert(u24, v29);
                            table.insert(u27, v);
                            v25 = true;
                            v21 = true;
                        end;
                    end;
                end;
            end;
        end;

        if u1.Id[u11.UserId] ~= u14 or not v21 then
            return EffectsEvent.ToAllInRange(HumanoidRootPart2, "CoilChoke_effs", Character2, "Cancel", true);
        end;

        EffectsEvent.ToAllInRange(HumanoidRootPart2, "CoilChoke_effs", Character2, "Success");
        task.delay(Config.FINISH_AT / ANIM_SPEED, function() -- Line: 257
            -- upvalues: u23 (copy), u24 (copy), Utility (ref), u22 (copy), GRAB_HITBOX_SIZE (copy), u27 (copy), table_find (ref), table_insert (ref), Character2 (copy), Checker (ref), u2 (ref), valuesfolder (copy), Combat_Util (ref), Config (ref), FINISH_DAMAGE (copy)
            for _, v in pairs(u23) do
                if v then
                    pcall(function() -- Line: 260
                        -- upvalues: v (copy)
                        v:Destroy();
                    end);
                end;
            end;

            for _, v in pairs(u24) do
                if v ~= nil and v.IsPlaying then
                    v:Stop(0);
                end;
            end;

            local ModelInRegion = Utility.GetModelInRegion(u22, GRAB_HITBOX_SIZE, nil, nil);

            if typeof(u27) == "table" then
                for _, v in pairs(u27) do
                    if table_find(ModelInRegion, v) == nil then
                        table_insert(ModelInRegion, v);
                    end;
                end;
            end;

            for _, v in pairs(ModelInRegion) do
                if v ~= Character2 and v:FindFirstChild("Humanoid") ~= nil then
                    local HumanoidRootPart3 = v:FindFirstChild("HumanoidRootPart");
                    local Humanoid3 = v:FindFirstChild("Humanoid");
                    local v30, _ = Checker.check_victim(script, Character2, v);
                    local valuesfolder2 = Utility.getvaluesfolder(v);

                    if u2.Both(valuesfolder2, {
                        name = "Choosing_1",
                        pv = valuesfolder
                    }) ~= true then
                        local HumanoidRootPart4 = Character2:FindFirstChild("HumanoidRootPart");

                        if HumanoidRootPart3 ~= nil and (Humanoid3 ~= nil and HumanoidRootPart4 ~= nil) then
                            if v30 == "Perfect" then
                                Combat_Util.Perfect(script, Character2, v);
                            elseif v30 == "Blocking" then
                                Combat_Util.Block(script, Character2, v, Config.FINISH_BLOCK_BREAK);
                            elseif v30 == true then
                                local Unit = ((u22 * CFrame.new(0, 0, -3)).Position - HumanoidRootPart3.Position).Unit;
                                Combat_Util.Knockback(script, Character2, HumanoidRootPart3, Unit * Config.FINISH_KNOCKBACK, Config.FINISH_KNOCKBACK_DUR);
                                Combat_Util.AddStun(script, Character2, valuesfolder2, Config.FINISH_STUN);
                                Combat_Util.RagDoll(script, Character2, valuesfolder2, Config.FINISH_RAGDOLL);
                                Combat_Util.Damage(script, Character2, v, {
                                    Base = FINISH_DAMAGE,
                                    Skill = script.Parent.Name
                                });
                            end;
                        end;
                    end;
                end;
            end;
        end);
        local BoolValue = Instance.new("BoolValue");
        BoolValue.Name = "pause_gameplay";
        BoolValue.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue, u3 - 0.05);
        local BoolValue2 = Instance.new("BoolValue");
        BoolValue2.Name = "iframe";
        BoolValue2.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue2, u3 - 0.05);
        local BoolValue3 = Instance.new("BoolValue");
        BoolValue3.Name = "noragdoll";
        BoolValue3.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue3, u3 - 0.05);
        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.Massless = true;
        Part.Transparency = 1;
        Part.CFrame = u22;
        Part.CanCollide = false;
        Part.Parent = workspace.Debree;
        DebrisModule:AddItem(Part, u3 - 0.05);
        local Weld = Instance.new("Weld");
        Weld.Part0 = Part;
        Weld.Part1 = HumanoidRootPart2;
        Weld.Parent = Part;
        DebrisModule:AddItem(Weld, u3);
        Humanoid2.Animator:LoadAnimation(script.coilchoke_player):Play(0.05, 1, ANIM_SPEED);
    end);
end;

function u1.Cancel(p31) -- Line: 345
    -- upvalues: EffectsEvent (copy)
    if p31.Character then
        EffectsEvent.ToAllInRange(p31, "CoilChoke_effs", p31.Character, "Cancel");
    end;
end;

return u1;