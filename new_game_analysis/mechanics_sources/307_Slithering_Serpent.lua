-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = 0
};
local _ = Vector3.new;
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local u2 = {};
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local Config = require(script.Parent.Config);
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
local u3 = nil;
local _ = table.find;
local _ = table.remove;
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0);
local TweenInfo_new_ret2 = TweenInfo.new(Config.DASH_DECAY_DUR, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

function u1.Hold(p4) -- Line: 14
    -- upvalues: u2 (copy), u1 (copy), u3 (ref), Utility (copy), gameSettings (copy), TweenService (copy), TweenInfo_new_ret (copy), DebrisModule (copy), Config (copy), Platform_Handler (copy)
    for _, v in pairs(u2) do
        v:Destroy();
    end;

    local Id = u1.Id;
    local Character = p4.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "skill_stand_still";
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.Name = "bv";
    LinearVelocity.MaxForce = gameSettings.skillStandStillForce;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    LinearVelocity.Parent = Attachment;
    local v5 = game.ReplicatedStorage.Assets:WaitForChild("Dash_Aim_Part"):Clone();
    local Weld = Instance.new("Weld");
    Weld.Part0 = HumanoidRootPart;
    Weld.Part1 = v5;
    Weld.C0 = CFrame.new(0, -2.6, -3);
    Weld.Parent = v5;
    v5.Parent = workspace.Debree;
    TweenService:Create(v5.SurfaceGui.Frame, TweenInfo_new_ret, {
        Size = UDim2.new(45, 0, 1, 0)
    }):Play();
    DebrisModule:AddItem(v5, Config.HOLD_SAFETY_DUR);
    table.insert(u2, v5);
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NR";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, Config.HOLD_SAFETY_DUR);
    table.insert(u2, BoolValue);
    local u6 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u7, u8 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 45,
        MaxTorque = 3000,
        AlignType = Enum.AlignType.AllAxes,
        CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u6, HumanoidRootPart.CFrame)
    });
    u7.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u6, u7.CFrame);
    task.spawn(function() -- Line: 64
        -- upvalues: Attachment (copy), HumanoidRootPart (copy), LinearVelocity (copy), u8 (copy), u6 (ref), Platform_Handler (ref), Config (ref), u7 (copy), Utility (ref)
        while Attachment ~= nil and (HumanoidRootPart and (LinearVelocity ~= nil and (Attachment.Parent == HumanoidRootPart and (LinearVelocity.Parent == Attachment and (Attachment.Name == "skill_stand_still" and (u8:FindFirstChild("Cancel") == nil and LinearVelocity:FindFirstChild("Cancel") == nil)))))) do
            u6 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
            u7.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u6, u7.CFrame);
            task.wait();
        end;
    end);
    u3 = Humanoid.Animator:LoadAnimation(script.SlitheringSerpent_Startup);
    u3:Play();
    u3:AdjustSpeed(1);
    task.wait(Config.HOLD_FREEZE_AT);

    if Id == u1.Id then
        u3:AdjustSpeed(0);
    end;
end;

function u1.UnHold(p9, p10) -- Line: 82
    -- upvalues: u3 (ref), u1 (copy), u2 (copy), DebrisModule (copy), Config (copy), Utility (copy), TweenService (copy), TweenInfo_new_ret2 (copy)
    if u3 then
        u3:AdjustSpeed(1);
    end;

    local _ = u1.Id;
    local Character = p9.Character;

    for _, v in pairs(u2) do
        if v.Name == "NR" then
            DebrisModule:AddItem(v, Config.UNHOLD_NR_LINGER);
        else
            v:Destroy();
        end;
    end;

    if Character ~= nil then
        local valuesfolder = Utility.getvaluesfolder(Character);
        local BoolValue = Instance.new("BoolValue");
        BoolValue.Name = "NOMouvementlines";
        BoolValue.Parent = valuesfolder;
        DebrisModule:AddItem(BoolValue, Config.DASH_WINDOW);
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        Character:FindFirstChild("Humanoid");

        if HumanoidRootPart ~= nil and (HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart.Name == "skill_look_at") then
            for _, child in pairs(HumanoidRootPart:GetChildren()) do
                if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                    local BoolValue2 = Instance.new("BoolValue");

                    if child.Name == "skill_stand_still" then
                        local Unit = (p10 - HumanoidRootPart.Position).Unit;
                        local Vector3_new_ret = Vector3.new(Unit.X, Unit.Y, Unit.Z);
                        child.bv.VectorVelocity = CFrame.lookAlong(HumanoidRootPart.Position, Vector3_new_ret).lookVector * Config.DASH_SPEED;
                        TweenService:Create(child.bv, TweenInfo_new_ret2, {
                            VectorVelocity = Vector3.new()
                        }):Play();
                    end;

                    BoolValue2.Name = "Cancel";
                    BoolValue2.Parent = child;
                    DebrisModule:AddItem(child, Config.DASH_WINDOW);
                end;
            end;
        end;
    end;

    wait(Config.DASH_WINDOW);
end;

function u1.Cancel(p11) -- Line: 126
    -- upvalues: u3 (ref), u2 (copy), u1 (copy)
    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    for _, v in pairs(u2) do
        v:Destroy();
    end;

    local _ = u1.Id;
    local Character = p11.Character;

    if Character ~= nil then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        Character:FindFirstChild("Humanoid");

        if HumanoidRootPart ~= nil and (HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart.Name == "skill_look_at") then
            for _, child in pairs(HumanoidRootPart:GetChildren()) do
                if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                    child:Destroy();
                end;
            end;
        end;
    end;
end;

return u1;