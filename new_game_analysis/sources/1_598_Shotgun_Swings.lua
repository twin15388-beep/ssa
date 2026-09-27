-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local CAM = ReplicatedStorage.CAM;
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local Cam_Shaker = require(CAM.Client.Modules.Effects.Cam_Shaker);
local Combat_Swings = require(script.Parent.Combat_Swings);
local WeaponAuras = require(script.Parent.WeaponAuras);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local u1 = {
    skipTrails = true,
    skipSound = true,
    anchorParts = {
        ["Circle.003"] = true
    }
};
local CFrame_new_ret = CFrame.new(
    -0.02876091,
    0.123809814,
    -1.52137148,
    0.999527872,
    -0.0271155462,
    -0.0147776194,
    0.0236407239,
    0.979749262,
    -0.198837101,
    0.0198708829,
    0.198392391,
    0.979925871
);
local u5 = {
    Flash = function(p2: userdata) -- Line: 40, Name: Flash
        -- upvalues: CFrame_new_ret (copy), Ouwmit (copy), DebrisModule (copy)
        if p2 == nil then
            return nil;
        end;

        local ShotgunModel = p2:FindFirstChild("ShotgunModel", true);

        if ShotgunModel == nil then
            return nil;
        end;

        local RightHandle = ShotgunModel:FindFirstChild("RightHandle");

        if RightHandle == nil then
            return nil;
        end;

        local Attribute = ShotgunModel:GetAttribute("MuzzleVFX");
        local v3 = (typeof(Attribute) ~= "string" or script:FindFirstChild(Attribute) == nil) and "MuzzleShotVFX" or Attribute;
        local v4 = script[v3]:Clone();
        v4.Parent = workspace.Debree;
        v4:PivotTo(RightHandle.CFrame * CFrame_new_ret);
        Ouwmit.Emit(v4);
        DebrisModule:AddItem(v4, 2);

        return RightHandle;
    end
};

return setmetatable(u5, {
    __call = function(p6: any, p7: userdata, p8: number, p9: boolean) -- Line: 64, Name: __call
        -- upvalues: WeaponAuras (copy), u1 (copy), Combat_Swings (copy), vfxUtility (copy), u5 (copy), Cam_Shaker (copy)
        if p7 == nil then
            return;
        end;

        WeaponAuras(p7, p8, p9, u1);

        if p8 == 6 or p8 == 7 then
            return Combat_Swings(p7, p8, p9);
        end;

        local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart ~= nil then
            vfxUtility.PlaySound(script.Swing_Sounds, "PS2shotgunM1sSWING" .. p8, HumanoidRootPart, true);
        end;

        task.wait(0.1);
        local v10 = u5.Flash(p7);

        if v10 ~= nil then
            vfxUtility.PlaySound(script.Explosion_Sounds, "PS2shotgunM1sSWINGexplo" .. p8, v10, true);
            Cam_Shaker(v10.Position, "tinyshake_less_aggresive_preset");
        end;
    end
});