-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = 0
};
local _ = Vector3.new;
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local u2 = {};
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local ManuelCancel = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("ManuelCancel"));
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local _ = table.find;
local _ = table.remove;
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local ArcLanding = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ArcLanding);
local Config = require(script.Parent.Config);
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));

function u1.Hold(p7) -- Line: 24
    -- upvalues: u1 (copy), Utility (copy), gameSettings (copy), DebrisModule (copy), Config (copy), u2 (copy), RaycastHelper (copy), Platform_Handler (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref)
    local Id = u1.Id;
    local Character = p7.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if anim then
        anim:Stop();
        anim = nil;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "skill_stand_still";
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.MaxForce = gameSettings.skillStandStillForce;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    LinearVelocity.Parent = Attachment;
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NR";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, Config.HOLD_NR_DURATION);
    table.insert(u2, BoolValue);
    local v8 = script.ground_ef:Clone();
    v8.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0);
    v8.Parent = workspace.Debree;
    v8.base_ef123asd:Emit(1);
    table.insert(u2, v8);
    local u9, u10 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 45,
        MaxTorque = 3000,
        AlignType = Enum.AlignType.PrimaryAxisParallel
    });
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.fromRGB(243, 111, 255);
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.OutlineColor = Color3.fromRGB(255, 0, 255);
    DebrisModule:AddItem(Highlight, 15);
    table.insert(u2, Highlight);
    local Attachment2 = Instance.new("Attachment");
    local Attachment3 = Instance.new("Attachment");
    Attachment2.Parent = HumanoidRootPart;
    Attachment3.Parent = HumanoidRootPart;
    local u11 = script.Beam:Clone();
    u11.Parent = HumanoidRootPart;
    u11.Attachment0 = Attachment2;
    u11.Attachment1 = Attachment3;
    u11.FaceCamera = true;
    table.insert(u2, u11);
    DebrisModule:AddItem(Attachment2, 6);
    DebrisModule:AddItem(Attachment3, 6);
    DebrisModule:AddItem(u11, 6);
    table.insert(u2, Attachment2);
    table.insert(u2, Attachment3);
    local CFrame_Angles_ret = CFrame.Angles(0, 1.5707963267948966, 0);
    task.spawn(function() -- Line: 84
        -- upvalues: Attachment (copy), HumanoidRootPart (copy), LinearVelocity (copy), u10 (copy), RaycastHelper (ref), Platform_Handler (ref), Config (ref), Highlight (copy), u11 (copy), Attachment3 (copy), Attachment2 (copy), Utility (ref), CFrame_Angles_ret (copy), u3 (ref), u4 (ref), u5 (ref), u6 (ref), u9 (copy)
        while Attachment ~= nil and (HumanoidRootPart and (LinearVelocity ~= nil and (Attachment.Parent == HumanoidRootPart and (LinearVelocity.Parent == Attachment and (Attachment.Name == "skill_stand_still" and (u10:FindFirstChild("Cancel") == nil and LinearVelocity:FindFirstChild("Cancel") == nil)))))) do
            local v12, _, _, v13 = RaycastHelper.MaximizeRayClient(HumanoidRootPart.Position, Platform_Handler.mousepos(), Config.RANGE, true, 5, 15, 3);
            local v14 = nil;

            if v13 == nil then
                if Highlight then
                    Highlight.Parent = workspace.Debree;
                end;
            elseif Highlight then
                v14 = v13:FindFirstChild("HumanoidRootPart");

                if v14 then
                    Highlight.Parent = v13;
                end;
            end;

            local Position = HumanoidRootPart.Position;

            if u11 ~= nil and (HumanoidRootPart ~= nil and (v13 ~= nil and (Attachment3 and Attachment2))) then
                v12 = v13.HumanoidRootPart.Position;
            end;

            if u11 and (Attachment3 and (Attachment2 and (Attachment2.Parent ~= nil and Attachment3 ~= nil))) then
                local v15, v16 = Utility.Bezier_Curve_beam_curve_calc(Position, v12, Config.BEAM_ARC_HEIGHT);
                u11.CurveSize0 = (v15 - Position).Magnitude;
                u11.CurveSize1 = (v16 - v12).Magnitude;
                Attachment2.WorldCFrame = CFrame.new(Position, v15) * CFrame_Angles_ret;
                Attachment3.WorldCFrame = CFrame.new(v12, v16) * CFrame_Angles_ret:Inverse();
                u3 = Attachment2.WorldPosition;
                u4 = (Attachment2.WorldCFrame * CFrame.new(u11.CurveSize0, 0, 0)).p;
                u5 = (Attachment3.WorldCFrame * CFrame.new(-u11.CurveSize1, 0, 0)).p;
                u6 = v14 or Attachment3.WorldPosition;
            end;

            u9.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, v12, u9.CFrame);
            task.wait();
        end;
    end);
    anim = Humanoid.Animator:LoadAnimation(script.Start);
    anim:Play();
    anim:AdjustSpeed(1);
    task.wait(Config.HOLD_FREEZE_AT);

    if Id == u1.Id then
        anim:AdjustSpeed(0);
    end;
end;

function u1.UnHold(u17) -- Line: 135
    -- upvalues: u1 (copy), ManuelCancel (copy), Config (copy), u2 (copy), DebrisModule (copy), Utility (copy), u5 (ref), u6 (ref), u4 (ref), u3 (ref), ArcLanding (copy)
    if anim then
        anim:AdjustSpeed(1);
        anim = nil;
    end;

    local Id = u1.Id;
    local v18, v19 = ManuelCancel.new(u17, Config.UNHOLD_CANCEL_WINDOW);
    v18:Connect(function() -- Line: 144
        -- upvalues: Id (ref), u1 (ref), u17 (copy)
        Id = -1;
        u1.Cancel(u17);
    end);
    local Character = u17.Character;

    for _, v in pairs(u2) do
        if v.Name == "NR" then
            DebrisModule:AddItem(v, Config.UNHOLD_NR_DURATION);
        else
            v:Destroy();
        end;
    end;

    if Character ~= nil then
        local valuesfolder = Utility.getvaluesfolder(Character);
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        Character:FindFirstChild("Humanoid");

        if HumanoidRootPart ~= nil then
            local v20 = {};

            if HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart.Name == "skill_look_at" then
                for _, child in pairs(HumanoidRootPart:GetChildren()) do
                    if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                        if child.Name == "skill_look_at" then
                            local BoolValue = Instance.new("BoolValue");
                            BoolValue.Name = "Cancel";
                            BoolValue.Parent = child;
                            DebrisModule:AddItem(child, 1);
                            table.insert(v20, child);
                        else
                            child:Destroy();
                        end;
                    end;
                end;
            end;

            if u5 ~= nil and (u6 ~= nil and (u4 ~= nil and u3 ~= nil)) then
                if HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil then
                    HumanoidRootPart.air_combo_bp:Destroy();
                end;

                local CFrame2 = HumanoidRootPart.CFrame;
                local Attachment = Instance.new("Attachment", HumanoidRootPart);
                DebrisModule:AddItem(Attachment, 3);
                local AlignPosition = Instance.new("AlignPosition");
                AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
                AlignPosition.Attachment0 = Attachment;
                AlignPosition.Responsiveness = Config.TRAVEL_RESPONSIVENESS;
                AlignPosition.MaxForce = Config.TRAVEL_MAX_FORCE;
                AlignPosition.Position = CFrame2.Position;
                AlignPosition.Parent = Attachment;
                local BoolValue = Instance.new("BoolValue");
                BoolValue.Name = "pause_gameplay";
                BoolValue.Parent = valuesfolder;
                game.Debris:AddItem(BoolValue, Config.TRAVEL_LOCK_DURATION);
                local BoolValue2 = Instance.new("BoolValue");
                BoolValue2.Name = "NOMouvementlines";
                BoolValue2.Parent = valuesfolder;
                local v21 = typeof(u6);
                local v22 = u6;

                if v21 == "Instance" then
                    v22 = u6.Position;
                end;

                local v23 = (CFrame2.Position - v22).Magnitude / 10 * 0.3;

                for i = 1, Config.TRAVEL_SEGMENTS do
                    local os_clock_ret = os.clock();

                    if u1.Id ~= Id then
                        Attachment:Destroy();
                        BoolValue:Destroy();
                        BoolValue2:Destroy();

                        return;
                    end;

                    local v24;

                    if v21 == "Instance" and (u6 ~= nil and u6.Parent ~= nil) then
                        v24 = u6.Position;
                    else
                        v24 = false;
                    end;

                    if v24 then
                        v22 = v24;
                    elseif v21 ~= "Instance" then
                        v22 = u6 or v22;
                    end;

                    local Resolve = ArcLanding.Resolve;
                    local v25 = {
                        Character = Character,
                        From = CFrame2.Position,
                        Goal = v22
                    };
                    local v26;

                    if v24 then
                        v26 = u6.Parent;
                    else
                        v26 = nil;
                    end;

                    v25.Target = v26;
                    v25.Range = Config.RANGE;
                    v22 = Resolve(v25) or v22;
                    local PosInBeam = Utility.GetPosInBeam(i / Config.TRAVEL_SEGMENTS, u3, u4, u5, v22);
                    AlignPosition.Position = PosInBeam;
                    local _ = i;

                    repeat
                        task.wait();
                    until u1.Id ~= Id or (HumanoidRootPart == nil or ((HumanoidRootPart.Position - PosInBeam).Magnitude <= math.min(v23, 1.15) or os.clock() - os_clock_ret > Config.MAX_TRAVEL_TIME / Config.TRAVEL_SEGMENTS));
                end;

                AlignPosition.Position = v22;
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

                if BoolValue2 then
                    DebrisModule:AddItem(BoolValue2, 0.35);
                end;

                if Attachment ~= nil and Attachment.Parent ~= nil then
                    DebrisModule:AddItem(Attachment, 0.35);
                end;

                for _, v in ipairs(v20) do
                    DebrisModule:AddItem(v, 0.35);
                end;

                if BoolValue ~= nil then
                    BoolValue:Destroy();
                end;
            end;
        end;
    end;

    v19();

    if Id == u1.Id then
        return Character.PrimaryPart.CFrame;
    end;
end;

function u1.Cancel(p27) -- Line: 253
    -- upvalues: u2 (copy), u1 (copy)
    if anim then
        anim:Stop();
        anim = nil;
    end;

    for _, v in pairs(u2) do
        v:Destroy();
    end;

    local _ = u1.Id;
    local Character = p27.Character;

    if Character ~= nil then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        Character:FindFirstChild("Humanoid");

        if HumanoidRootPart ~= nil then
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

            if HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart.Name == "skill_look_at" then
                for _, child in pairs(HumanoidRootPart:GetChildren()) do
                    if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                        child:Destroy();
                    end;
                end;
            end;
        end;
    end;
end;

return u1;