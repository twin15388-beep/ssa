-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local Client = CAM:WaitForChild("Client");
local Global = CAM:WaitForChild("Global");
local Platform_Handler = require(Client:WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Utility = require(Global:WaitForChild("Utility"));
local u1 = require(game:GetService("ReplicatedStorage").Packages.cleanit).new();
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
local ServerClientPortal = require(Global.ServerClientPortal);
local Combat_presets = require(Global:WaitForChild("Combat_presets"));
local valuesfolder = Utility.getvaluesfolder(game.Players.LocalPlayer, true);
require(Global:FindFirstChild("Subsets"):FindFirstChild("Gameplay"):FindFirstChild("ManuelCancel"));
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local Vector3_new = Vector3.new;
local u3 = nil;
local u4 = script.Parent.Name .. "Hold";

function u2.Hold(p5) -- Line: 28
    -- upvalues: u3 (ref), u2 (copy), u1 (copy), ServerClientPortal (copy), u4 (copy), valuesfolder (copy), DebrisModule (copy), Utility (copy), Combat_presets (copy), Config (copy), Platform_Handler (copy), Vector3_new (copy)
    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
    end;

    if not p5 then
        return;
    end;

    local Character = p5.Character;

    if not Character then
        return;
    end;

    local u6 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local Animator = Humanoid:FindFirstChild("Animator");
    local Id = u2.Id;

    if not (u6 and (Humanoid and Animator)) then
        return;
    end;

    local v7 = u1:Add(ServerClientPortal.Link(u4));
    u3 = Instance.new("BoolValue");
    u3.Name = "NOMouvementlines";
    u3.Parent = valuesfolder;
    DebrisModule:AddItem(u3, 0.5);
    v7:Connect(function(p8) -- Line: 50
        -- upvalues: u1 (ref), Id (ref), Animator (copy), Utility (ref), Character (copy), Combat_presets (ref), Humanoid (copy), DebrisModule (ref), u6 (copy), Config (ref), Platform_Handler (ref), Vector3_new (ref), u2 (ref)
        if p8 == 2 then
            u1:Clean();
            Id = -1;

            return;
        end;

        u1:Add(Animator:LoadAnimation(script["Miss Loop"])):Play();
        local valuesfolder2 = Utility.getvaluesfolder(Character);
        Combat_presets.stop_extra_anims(Humanoid);
        local v9 = u1:Add(Instance.new("BoolValue"));
        v9.Name = "NOMouvementlines";
        v9.Parent = valuesfolder2;
        DebrisModule:AddItem(v9, 5);
        local u10 = u1:Add(Instance.new("Attachment", u6));
        u10.Name = "skill_stand_still";
        local u11 = u1:Add(Instance.new("LinearVelocity"));
        u11.Attachment0 = u10;
        u11.Name = "bp";
        u11.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
        u11.MaxAxesForce = Vector3.new(Config.DASH_MAX_FORCE, 0, Config.DASH_MAX_FORCE);
        u11.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
        local u12 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u11.VectorVelocity = (Vector3_new(u12.X, u6.Position.Y, u12.Z) - u6.Position).Unit * 0;
        u11.Parent = u10;
        local u13, u14 = Utility.CreateAlignOrientationWithAttachment(u6, "skill_look_at", {
            Responsiveness = 45,
            MaxTorque = 1000,
            AlignType = Enum.AlignType.PrimaryAxisParallel,
            CFrame = Utility.SafeLookAt(u6.Position, u12, u6.CFrame)
        });
        u1:Add(u13);
        u1:Add(u14);
        task.spawn(function() -- Line: 91
            -- upvalues: Id (ref), u2 (ref), u10 (copy), u6 (ref), u11 (copy), u14 (copy), u12 (ref), Platform_Handler (ref), Config (ref), u13 (copy), Utility (ref)
            while Id == u2.Id and (u10 ~= nil and (u6 and (u11 ~= nil and (u10.Parent == u6 and (u11.Parent == u10 and (u10.Name == "skill_stand_still" and (u14:FindFirstChild("Cancel") == nil and u11:FindFirstChild("Cancel") == nil))))))) do
                u12 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
                u11.VectorVelocity = CFrame.new(u6.Position, (Vector3.new(u12.X, u6.Position.Y, u12.Z))).LookVector * Config.DASH_SPEED;
                u13.CFrame = Utility.SafeLookAt(u6.Position, Vector3.new(u12.X, u6.Position.Y, u12.Z), u13.CFrame);
                task.wait();
            end;
        end);
    end);
    task.wait(0.5);
end;

function u2.UnHold(p15: userdata) -- Line: 111
    -- upvalues: u3 (ref), u1 (copy)
    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
    end;

    u1:Clean();
end;

function u2.Cancel(p16) -- Line: 121
    -- upvalues: u1 (copy), u3 (ref)
    u1:Clean();

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
    end;
end;

return u2;