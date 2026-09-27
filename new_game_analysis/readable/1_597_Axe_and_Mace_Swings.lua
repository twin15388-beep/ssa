-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("vfxUtility"));
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local OuwCraters = require(ReplicatedStorage.CAM.Client.Modules.Effects.Craters.OuwCraters);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local u1 = {
    [2] = 0.143,
    [3] = 0.19,
    [4] = 0.19,
    [5] = 0.119,
    [6] = 0.19,
    [7] = 0.143,
    [99] = 0.262
};
local u2 = {
    [1] = CFrame.new(
        0.000122070312,
        -2.81992388,
        0.000244140625,
        -1.00582838e-7,
        0,
        1.00000441,
        0,
        1,
        0,
        -1.00000441,
        0,
        -1.04308128e-7
    ),
    [2] = CFrame.new(
        0.000122070312,
        -2.81992388,
        0.000244140625,
        -1.00582838e-7,
        0,
        1.00000441,
        0,
        1,
        0,
        -1.00000441,
        0,
        -1.04308128e-7
    ),
    [3] = CFrame.new(
        0.000122070312,
        -2.81992388,
        0.000244140625,
        -1.00582838e-7,
        0,
        1.00000441,
        0,
        1,
        0,
        -1.00000441,
        0,
        -1.04308128e-7
    ),
    [4] = CFrame.new(
        0.000122070312,
        -2.81992388,
        0.000244140625,
        -1.00582838e-7,
        0,
        1.00000441,
        0,
        1,
        0,
        -1.00000441,
        0,
        -1.04308128e-7
    ),
    [5] = CFrame.new(
        0.000122070312,
        -2.81992388,
        0.000244140625,
        -1.00582838e-7,
        0,
        1.00000441,
        0,
        1,
        0,
        -1.00000441,
        0,
        -1.04308128e-7
    ),
    [6] = CFrame.new(
        0.000122070312,
        -2.81992388,
        0.000244140625,
        -1.00582838e-7,
        0,
        1.00000441,
        0,
        1,
        0,
        -1.00000441,
        0,
        -1.04308128e-7
    ),
    [7] = CFrame.new(
        0.0000610351562,
        -1.92927074,
        -0.0675048828,
        -1.1920929e-7,
        6.75251899e-9,
        1.00000441,
        -0.258820176,
        0.965925753,
        -2.23517418e-8,
        -0.965929985,
        -0.258819014,
        -8.94069672e-8
    ),
    [99] = CFrame.new(0.000122070312, -0.569923878, -0.36114502, 0, 0, 1, 0, 1, 0, -1, 0, 0)
};
local u3 = {};
local u4 = {
    [4] = CFrame.new(1.02490234, -2.45000029, -6, 0.040637821, 0, -0.999173939, 0, 1, 0, 0.999173939, 0, 0.040637821),
    [5] = CFrame.new(1.02490234, -1.32500041, -6, 0.999999881, 0, 0, 0, 1, 0, 0, 0, 0.999999881)
};
local u5 = {
    [7] = 0.148
};
local u6 = {
    [4] = "activate_shakelessaggresive",
    [5] = "activate_shake"
};
os.clock();

return function(p7, p8, p9, p10) -- Line: 47
    -- upvalues: Ouwmit (copy), u5 (copy), DebrisModule (copy), u1 (copy), ManuelCancel (copy), u2 (copy), RaycastHelper (copy), u6 (copy), Cam_Shaker (copy), u3 (copy), u4 (copy), OuwCraters (copy)
    if p7 == nil then
        return;
    end;

    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if vector.magnitude(HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position) >= 100 then
        return;
    end;

    local u11 = p9 and 99 or p8;

    if u11 == 4 or u11 == 5 then
        local IsAxeAndMaceWeapon = p7:FindFirstChild("IsAxeAndMaceWeapon", true);

        if IsAxeAndMaceWeapon ~= nil then
            local Ball = IsAxeAndMaceWeapon.Parent.RootPart.Ball;
            local BallThing = Ball:FindFirstChild("BallThing");

            if BallThing == nil then
                BallThing = script.Slashes.BallThing:Clone();
                BallThing.Parent = Ball;
            end;

            BallThing.Value.Value = u11;
            task.delay(1, function() -- Line: 68
                -- upvalues: BallThing (ref), u11 (ref), Ouwmit (ref)
                local Value = BallThing:FindFirstChild("Value");

                if Value ~= nil and Value.Value == u11 then
                    Ouwmit.Enable(BallThing, false);
                    task.wait(1);
                    BallThing:Destroy();
                end;
            end);
        end;
    end;

    local v12;

    if u11 == 99 then
        v12 = script.Sound:FindFirstChild("PS2stoneM1CYCLEswing1");
    elseif u11 <= 5 then
        v12 = script.Sound:FindFirstChild("PS2stoneM1CYCLEswing" .. u11);
    else
        v12 = script.Sound:FindFirstChild("PS2stoneM1CYCLEslam" .. u11 - 5);
    end;

    if v12 ~= nil then
        local u13 = v12:Clone();

        if u5[u11] then
            task.delay(u5[u11], function() -- Line: 91
                -- upvalues: u13 (ref), HumanoidRootPart (copy), DebrisModule (ref)
                u13.Parent = HumanoidRootPart;
                u13:Play();
                DebrisModule:AddItem(u13, u13.TimeLength);
            end);
        else
            u13.Parent = HumanoidRootPart;
            u13:Play();
            DebrisModule:AddItem(u13, u13.TimeLength);
        end;
    end;

    local v14 = u1[u11] or 0.286;
    ManuelCancel.new(p7, v14):Connect(function() -- Line: 105
    end);
    task.wait(v14);

    if HumanoidRootPart == nil or HumanoidRootPart.Parent == nil then
        return;
    end;

    local v15 = script.Slashes:FindFirstChild("Slash" .. u11);

    if v15 ~= nil then
        local v16 = nil;
        local v17 = v15:Clone();
        v17.Parent = workspace.Debree;
        local CFrame2 = HumanoidRootPart.CFrame;

        if u11 ~= nil and u2[u11] then
            CFrame2 = CFrame2 * u2[u11];
        end;

        local v18 = workspace:Raycast(CFrame2.Position, CFrame2.UpVector * -10, RaycastHelper.Crater);

        if v18 == nil or (v18.Position == nil or v18.Instance == nil) then
            if v17.VFX:FindFirstChild("raycastdust") ~= nil then
                v17.VFX.raycastdust:Destroy();
            end;
        else
            local _ = CFrame.new(v18.Position, v18.Position + v18.Normal) * CFrame.Angles(-1.5707963267948966, 0, 0);
            v16 = v18.Instance.Color;
        end;

        local v19 = script.Slashes:FindFirstChild("High" .. u11);

        if v19 ~= nil then
            local v20 = v19:Clone();
            v20.Parent = v17;
            v20.Adornee = p7;
        end;

        v17:PivotTo(CFrame2);
        Ouwmit.Emit(v17, v16 ~= nil and ({
            ColorWhitelist = "raycastdust",
            Color = v16,
            ColorBlacklist = { "grass_blade14", "NewAtlasgrass" }
        } or nil) or nil);
        DebrisModule:AddItem(v17, 2);
        local v21 = script.Slashes:FindFirstChild("Ground" .. u11);

        if v21 ~= nil and v16 ~= nil then
            local v22 = v21:Clone();

            if u6[u11] then
                Cam_Shaker(HumanoidRootPart.Position, u6[u11]);
            end;

            task.wait(u3[u11] or 0.095);
            local CFrame3 = HumanoidRootPart.CFrame;

            if u11 and u4[u11] then
                CFrame3 = CFrame3 * (CFrame.new(0, 0.1, 0) * u4[u11]);
            end;

            v22.Parent = workspace.Debree;
            v22:PivotTo(CFrame3);
            DebrisModule:AddItem(v22, 2);
            Ouwmit.Emit(v22, {
                Color = v16,
                ColorWhitelist = { "Dust", "raycastdust" },
                ColorBlacklist = { "grass_blade14", "NewAtlasgrass", "GroundShatter" }
            });
            OuwCraters.Scales({
                Duration = 1.5,
                Center = v22.GroundImpact.CFrame,
                ScaleMult = u11 == 4 and 0.45 or 0.75,
                Radius = u11 == 4 and 3.5 or 6
            });
        end;
    end;
end;