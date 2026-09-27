-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Combat_Package"):WaitForChild("Normal"):WaitForChild("Swing_Sounds");
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local Run_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Run_Handler"));
local os_clock = os.clock;
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local u1 = nil;
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local Swings = game.ReplicatedStorage:WaitForChild("Effects"):WaitForChild("Swings");
local u2 = {
    CanAirCombo = true,
    UpdraftRequested = false
};
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);

function u2.Do(p3: number, p4: any, u5: string, u6: string) -- Line: 28
    -- upvalues: u1 (ref), Combat_presets (copy), Run_Handler (copy), Checker (copy), u2 (copy), InputHandler (copy), ManuelCancel (copy), Swings (copy), SignalEvent (copy), Cam_Shaker (copy), os_clock (copy)
    local v7 = {};
    local v8 = p4.Max or 5;
    local Animations = game.ReplicatedStorage:FindFirstChild("Assets"):FindFirstChild("Animations");
    local u9 = Animations:FindFirstChild(u5 .. "_Combat_Anims") or Animations:FindFirstChild("Combat_Combat_Anims");
    local u10;

    if u6 == nil then
        u10 = u9;
    else
        u10 = Animations:FindFirstChild(u6 .. "_Combat_Anims") or u9;
    end;

    local function findRunHit(p11: boolean) -- Line: 40
        -- upvalues: u10 (copy), u9 (copy), Animations (copy)
        local v12;

        if p11 then
            v12 = nil;
        else
            v12 = u10:FindFirstChild("Run_Hit") or (u9 ~= nil and u9:FindFirstChild("Run_Hit") or nil);
        end;

        if v12 == nil then
            local Combat_Combat_Anims = Animations:FindFirstChild("Combat_Combat_Anims");
            v12 = Combat_Combat_Anims ~= nil and Combat_Combat_Anims:FindFirstChild("Run_Hit") or nil;
        end;

        return v12;
    end;

    if u1 ~= nil then
        u1:Stop();
        u1 = nil;
    end;

    local Value = p3.Value;
    local Character = game.Players.LocalPlayer.Character;
    local Humanoid = Character.Humanoid;
    local HumanoidRootPart = Character.HumanoidRootPart;
    Combat_presets.stop_extra_anims(Humanoid, { "Swing_6", "Swing_7" });
    local v13 = (HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil or Humanoid.FloorMaterial == Enum.Material.Air) and true or Humanoid.FloorMaterial == nil;

    if v13 == true and (HumanoidRootPart:FindFirstChild("air_combo_bp") == nil and (Humanoid.Jump and HumanoidRootPart.AssemblyLinearVelocity.Y > 0.25)) then
        v13 = false;
    end;

    local u14;

    if Run_Handler.Is_Running or Checker.Dashing == true then
        u14 = Value == 1;
    else
        u14 = false;
    end;

    local u15;

    if u2.CanAirCombo then
        u15 = InputHandler.IsDown("Jump") or u2.UpdraftRequested == true;
    elseif v13 then
        if p3.Value == 5 then
            u15 = InputHandler.IsDown("Jump") or u2.UpdraftRequested == true;
        else
            u15 = false;
        end;
    else
        u15 = v13;
    end;

    local v16 = Value;
    local v17 = not (v13 or (u15 ~= true or (v16 >= v8 or v16 < 1))) and 6 or v16;
    local u18 = v13 == true and (u15 == false and v17 == v8) and 7 or v17;
    local v19;

    if u14 then
        v19 = u18 == 1;
    end;

    local u20 = Combat_presets.runHitPreset(p4, v19);
    local u21 = u20 ~= p4;
    local u22 = (u14 ~= true or u20.run_swing_remove_on_first == nil) and 0 or u20.run_swing_remove_on_first;

    if u15 then
        u2.CanAirCombo = false;
        u2.UpdraftRequested = false;
    end;

    local delay_before_swing = u20.delay_before_swing;
    local u23 = delay_before_swing ~= nil and delay_before_swing[u18] or u20.default_before_swing or (Combat_presets.Default_Swing_Wait or 0);
    local u24 = false;
    ManuelCancel.new(Character, u23):Connect(function() -- Line: 104
        -- upvalues: u24 (ref)
        u24 = true;
    end);
    task.delay(u23, function() -- Line: 107
        -- upvalues: u24 (ref), u6 (copy), Swings (ref), u21 (copy), u5 (copy), Character (copy), u18 (ref), u14 (copy), u20 (copy), Combat_presets (ref), u23 (copy), u22 (ref), SignalEvent (ref), Value (copy), u15 (copy), Checker (ref), Cam_Shaker (ref), HumanoidRootPart (copy)
        if u24 then
            return;
        end;

        local v25;

        if u6 == nil or not Swings:FindFirstChild(u6 .. "_Swings") then
            v25 = nil;
        else
            v25 = u6;
        end;

        game.ReplicatedStorage.Communication.CnC.ClientEffects:Fire((u21 and "Combat" or (v25 or u5)) .. "_Swings", Character, u18, u14);
        local delay_before_hit = u20.delay_before_hit;
        local v26 = Combat_presets.attackSpeedMult(game.Players.LocalPlayer);
        local v27 = ((delay_before_hit ~= nil and delay_before_hit[u18] or (u20.default_before_hit or u23)) - u22 - u23) / v26;
        SignalEvent.ToServer("Combat_Service", u5, Value, u14, v27, u15, v25);
        task.wait(v27);

        if Checker.check(game.Players.LocalPlayer, "combat") == true then
            Cam_Shaker(HumanoidRootPart.Position, "punch_shake");
        end;
    end);

    if u14 == true then
        Combat_presets.lastRunHit = os_clock();
    else
        Combat_presets.Last_Punched = os_clock();
    end;

    Combat_presets.Last_Punched_Jump = os_clock();
    local v28 = u18 < 6 and u14 == true and findRunHit(u21) or u10:FindFirstChild("Swing_" .. u18);
    local v29 = nil;

    if Character and (Character:FindFirstChild("Accessories") and Character.Accessories:FindFirstChild("CustomRig")) then
        local AnimController = Character.Accessories.CustomRig:FindFirstChild("AnimController");

        if AnimController then
            v29 = AnimController.Animator:LoadAnimation(v28);
        end;
    else
        v29 = Humanoid.Animator:LoadAnimation(v28);
    end;

    if u18 == v8 then
        u1 = v29;
    end;

    v29:Play();
    local AnimSpeed = u20.AnimSpeed;

    if AnimSpeed then
        local v30 = u14 and -1 or u18;
        local v31 = (u6 ~= nil and AnimSpeed[u6 .. tostring(v30)] or AnimSpeed[v30] or (AnimSpeed.Default or 1)) * Combat_presets.attackSpeedMult(game.Players.LocalPlayer);

        if v31 then
            v29:AdjustSpeed(v31);
        end;
    end;

    v7.combovalue = Value;

    return v7;
end;

return u2;