-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = ReplicatedStorage.CAM;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local Combat_presets = require(ReplicatedStorage.CAM.Global.Combat_presets);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {
    startupTrack = nil
};
local script_FlashingWillowAirVariantUserStartup = script.FlashingWillowAirVariantUserStartup;

function u2.Hold(p4: userdata) -- Line: 23
    -- upvalues: Combat_presets (copy), u2 (copy), u3 (copy), script_FlashingWillowAirVariantUserStartup (copy), u1 (copy), Config (copy)
    local Humanoid = p4.Character:FindFirstChild("Humanoid");
    local Animator = Humanoid:FindFirstChild("Animator");
    Combat_presets.stop_extra_anims(Humanoid, { "Swing_6", "Swing_5", "Swing_7" });
    local Id = u2.Id;
    u3.startupTrack = Animator:LoadAnimation(script_FlashingWillowAirVariantUserStartup);
    u1:Add(u3.startupTrack);
    u3.startupTrack:Play();
    task.wait(Config.AERIAL_FREEZE_MARK);

    if Id ~= u2.Id then
        return;
    end;

    u3.startupTrack:AdjustSpeed(0);
end;

function u2.UnHold(p5: userdata) -- Line: 39
    -- upvalues: u2 (copy)
    u2.Cancel(p5);
end;

function u2.Cancel(p6: userdata) -- Line: 43
    -- upvalues: u1 (copy)
    u1:Clean();
end;

return u2;