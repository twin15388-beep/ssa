-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
game:GetService("Workspace");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local Client = CAM:WaitForChild("Client");
local Global = CAM:WaitForChild("Global");
local Platform_Handler = require(Client:WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Utility = require(Global:WaitForChild("Utility"));
local u1 = require(game:GetService("ReplicatedStorage").Packages.cleanit).new();
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 0;

function u2.Hold(p7) -- Line: 29
    -- upvalues: u6 (ref), u2 (copy), u1 (copy), Platform_Handler (copy), Config (copy), u3 (ref), u4 (ref), Utility (copy), DebrisModule (copy), RunService (copy), u5 (ref)
    if not p7 then
        return;
    end;

    u6 = os.clock();
    local Character = p7.Character;
    local Id = u2.Id;

    if not Character then
        return;
    end;

    local u8 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
    local Humanoid = Character:FindFirstChild("Humanoid");

    if not (u8 and Humanoid) then
        return;
    end;

    local Animator = Humanoid:FindFirstChild("Animator");
    u1:Add(script.Parent.Parent.Parent.holder.skill_stand_still:Clone()).Parent = u8;
    local u9 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local v10, v11 = Utility.CreateAlignOrientationWithAttachment(u8, "skill_look_at", {
        Responsiveness = 80,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.AllAxes,
        CFrame = Utility.SafeLookAt(u8.Position, u9, u8.CFrame)
    });
    u3 = v10;
    u4 = v11;
    DebrisModule:AddItem(u4, 6);
    u1:Connect(RunService.Heartbeat, function(p12: number) -- Line: 58
        -- upvalues: u9 (ref), Platform_Handler (ref), Config (ref), u3 (ref), Utility (ref), u8 (copy)
        u9 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u3.CFrame = Utility.SafeLookAt(u8.Position, u9, u3.CFrame);
    end);
    u5 = Animator:LoadAnimation(script["Out of Range"]);
    u5:Play();
    task.delay(Config.HOLD_FREEZE_AT, function() -- Line: 67
        -- upvalues: Id (copy), u2 (ref), u5 (ref)
        if Id ~= u2.Id then
            return;
        end;

        u5:AdjustSpeed(0);
    end);
end;

local ServerClientPortal = require(ReplicatedStorage2.CAM.Global.ServerClientPortal);
local valuesfolder = Utility.getvaluesfolder(game.Players.LocalPlayer, true);
local RaycastHelper = require(ReplicatedStorage2.CAM.Global.RaycastHelper);

function u2.UnHold(p13: userdata, u14: any) -- Line: 77
    -- upvalues: Config (copy), u6 (ref), u5 (ref), u1 (copy), ServerClientPortal (copy), u4 (ref), RaycastHelper (copy), DebrisModule (copy), Utility (copy), valuesfolder (copy)
    local v15 = Config.WINDUP - (os.clock() - u6);

    if v15 > 0 then
        if u5 ~= nil and u5.TimePosition < Config.HOLD_FREEZE_AT then
            u5:AdjustSpeed((Config.HOLD_FREEZE_AT - u5.TimePosition) / v15);
        end;

        task.wait(v15);
    end;

    u1:Clean();

    if not p13 then
        return;
    end;

    local Character = p13.Character;

    if not Character then
        return;
    end;

    local u16 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;

    if not (u16 and Character:FindFirstChild("Humanoid")) then
        return;
    end;

    if u5.TimePosition < Config.HOLD_FREEZE_AT then
        u5.TimePosition = Config.HOLD_FREEZE_AT;
    end;

    u5:AdjustSpeed(1);
    ServerClientPortal.Link(script.Parent.Name, 1):Once(function(p17) -- Line: 105
        -- upvalues: u4 (ref), u5 (ref), u16 (copy), u14 (copy), Config (ref), RaycastHelper (ref), DebrisModule (ref), Utility (ref), valuesfolder (ref)
        if p17 then
            if u4 ~= nil then
                u4:Destroy();
            end;

            if u5 ~= nil then
                u5:Stop();
                u5 = nil;
            end;
        else
            local CFrame = u16.CFrame;
            local vector_normalize_ret = vector.normalize(u14 - CFrame.Position);
            local v18 = CFrame.Position + vector_normalize_ret * Config.MAX_DASH_DISTANCE;
            local v19 = workspace:Raycast(CFrame.Position, vector_normalize_ret * Config.MAX_DASH_DISTANCE, RaycastHelper.Crater);

            if u4 ~= nil then
                DebrisModule:AddItem(u4, Config.MISS_ENDLAG);
                u4 = nil;
            end;

            if v19 then
                v18 = v19.Position + v19.Normal * 2.5;
            end;

            Utility.AddValue(valuesfolder, "pause_gameplay", Config.MISS_ENDLAG);
            Utility.AddValue(valuesfolder, "NR", Config.MISS_ENDLAG);
            local Attachment = Instance.new("Attachment");
            Attachment.Parent = u16;
            DebrisModule:AddItem(Attachment, Config.MISS_ENDLAG);

            if u4 ~= nil then
                DebrisModule:AddItem(u4, Config.MISS_ENDLAG);
                u4 = nil;
            end;

            local AlignPosition = Instance.new("AlignPosition");
            AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
            AlignPosition.Attachment0 = Attachment;
            AlignPosition.Responsiveness = Config.DASH_RESPONSIVENESS;
            AlignPosition.Position = v18;
            AlignPosition.MaxForce = Config.DASH_MAX_FORCE;
            AlignPosition.Parent = Attachment;
        end;
    end);
end;

function u2.Cancel(p20) -- Line: 152
    -- upvalues: u1 (copy), u5 (ref), u3 (ref), u4 (ref)
    u1:Clean();

    if u5 then
        u5:Stop();
        u5 = nil;
    end;

    if not p20 then
        return;
    end;

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
    end;

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    local Character = p20.Character;

    if not Character then
        return;
    end;

    local v21 = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart;
    v21.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    v21.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
end;

return u2;