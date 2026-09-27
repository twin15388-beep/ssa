-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local v1 = {};
local LocalPlayer = Players.LocalPlayer;
local valuesfolder = Utility.getvaluesfolder(LocalPlayer);
local Data = Utility.GetData(LocalPlayer, true);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = 0;
local u6 = nil;
local u7 = nil;

local function settle() -- Line: 37
    -- upvalues: u7 (ref)
    if u7 ~= nil and u7.Parent ~= nil then
        u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;
end;

local function releaseRefs() -- Line: 44
    -- upvalues: u7 (ref), u2 (ref), u3 (ref), u4 (ref), u6 (ref)
    if u7 ~= nil and u7.Parent ~= nil then
        u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    u2 = nil;

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
    end;

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    u6 = nil;
end;

local function cancelCleanup() -- Line: 58
    -- upvalues: u2 (ref), u7 (ref), u3 (ref), u4 (ref), u6 (ref)
    if u2 ~= nil then
        u2:Stop();
    end;

    if u7 ~= nil and u7.Parent ~= nil then
        u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    u2 = nil;

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
    end;

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    u6 = nil;
end;

function v1.MouseDown(p8: userdata, p9: string) -- Line: 65
    -- upvalues: u6 (ref), Checker (copy), LocalPlayer (copy), valuesfolder (copy), Data (copy), u5 (ref), u7 (ref), ManuelCancel (copy), u2 (ref), u3 (ref), u4 (ref), Utility (copy)
    if p8 == nil then
        return;
    end;

    if u6 ~= nil then
        return;
    end;

    local u10 = p8:FindFirstChildOfClass("Humanoid");

    if u10 == nil or u10.Health <= 0 then
        return;
    end;

    if not Checker.check(LocalPlayer) then
        return;
    end;

    if valuesfolder == nil or Data == nil then
        return;
    end;

    if Data.Inventory.Inventory:FindFirstChild(p9) == nil then
        return;
    end;

    if Data.Powers.DemonArt.Value ~= "" then
        return;
    end;

    u5 = os.clock();
    u7 = p8:FindFirstChild("HumanoidRootPart");

    if u7 ~= nil and u7.Parent ~= nil then
        u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    local v11, u12 = ManuelCancel.new(LocalPlayer, 2);
    v11:Connect(function() -- Line: 80
        -- upvalues: u6 (ref), u2 (ref), u7 (ref), u3 (ref), u4 (ref)
        if u6 ~= nil then
            task.cancel(u6);
        end;

        if u2 ~= nil then
            u2:Stop();
        end;

        if u7 ~= nil and u7.Parent ~= nil then
            u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
        end;

        if u4 ~= nil then
            u4:Destroy();
            u4 = nil;
        end;

        u6 = nil;
    end);
    u3 = Utility.AddValue(valuesfolder, "pause_gameplay", 2);
    u4 = Utility.AddValue(valuesfolder, "JumpingDisabled", 2);
    u2 = u10.Animator:LoadAnimation(script.Squeeze);
    u2:Play();
    u6 = task.spawn(function() -- Line: 92
        -- upvalues: u12 (copy), u10 (copy), u2 (ref), u7 (ref), u3 (ref), u4 (ref), u6 (ref)
        task.wait(2);
        u12();

        if u10.Health > 0 then
            if u7 ~= nil and u7.Parent ~= nil then
                u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;

            u2 = nil;

            if u3 ~= nil then
                u3:Destroy();
                u3 = nil;
            end;

            if u4 ~= nil then
                u4:Destroy();
                u4 = nil;
            end;

            u6 = nil;

            return;
        end;

        if u2 ~= nil then
            u2:Stop();
        end;

        if u7 ~= nil and u7.Parent ~= nil then
            u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
        end;

        if u4 ~= nil then
            u4:Destroy();
            u4 = nil;
        end;

        u6 = nil;
    end);
end;

function v1.MouseUp(p13: userdata) -- Line: 103
    -- upvalues: u5 (ref), u6 (ref), u2 (ref), u7 (ref), u3 (ref), u4 (ref)
    local v14 = 0.3 - (os.clock() - u5);

    if v14 > 0 then
        task.wait(v14);
    end;

    if u6 == nil then
        return;
    end;

    local success, result = pcall(function() -- Line: 108
        -- upvalues: u2 (ref)
        return u2 and u2.TimePosition;
    end);

    if success and (result ~= nil and result < 0.9333333333333333) then
        task.cancel(u6);

        if u2 ~= nil then
            u2:Stop();
        end;

        if u7 ~= nil and u7.Parent ~= nil then
            u7.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            u7.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
        end;

        if u4 ~= nil then
            u4:Destroy();
            u4 = nil;
        end;

        u6 = nil;
    end;
end;

return v1;