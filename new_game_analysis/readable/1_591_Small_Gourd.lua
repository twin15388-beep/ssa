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
local u6 = 0.4166666666666667;
local u7 = nil;
local u8 = nil;
local u9 = nil;

local function settle() -- Line: 40
    -- upvalues: u8 (ref)
    if u8 ~= nil and u8.Parent ~= nil then
        u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;
end;

local function disarm() -- Line: 47
    -- upvalues: u9 (ref)
    if u9 ~= nil then
        u9();
        u9 = nil;
    end;
end;

local function releaseRefs() -- Line: 54
    -- upvalues: u9 (ref), u8 (ref), u2 (ref), u3 (ref), u4 (ref), u7 (ref)
    if u9 ~= nil then
        u9();
        u9 = nil;
    end;

    if u8 ~= nil and u8.Parent ~= nil then
        u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    u2 = nil;

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
        u4:Destroy();
        u4 = nil;
    end;

    u7 = nil;
end;

local function cancelCleanup() -- Line: 67
    -- upvalues: u2 (ref), u9 (ref), u8 (ref), u3 (ref), u4 (ref), u7 (ref)
    if u2 ~= nil then
        u2:Stop();
    end;

    if u9 ~= nil then
        u9();
        u9 = nil;
    end;

    if u8 ~= nil and u8.Parent ~= nil then
        u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    u2 = nil;

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
        u4:Destroy();
        u4 = nil;
    end;

    u7 = nil;
end;

function v1.Equipped(p10: userdata, p11: string) -- Line: 74
end;

function v1.UnEquipped(p12: userdata, p13: string) -- Line: 78
end;

function v1.MouseDown(p14: userdata, p15: string) -- Line: 82
    -- upvalues: Checker (copy), LocalPlayer (copy), valuesfolder (copy), Data (copy), u6 (ref), u5 (ref), u8 (ref), ManuelCancel (copy), u9 (ref), u7 (ref), u2 (ref), u3 (ref), u4 (ref), Utility (copy)
    if p14 == nil then
        return;
    end;

    local u16 = p14:FindFirstChildOfClass("Humanoid");

    if u16 == nil or u16.Health <= 0 then
        return;
    end;

    if not Checker.check(LocalPlayer) then
        return;
    end;

    if valuesfolder == nil then
        return;
    end;

    if Data == nil then
        return;
    end;

    local v17 = Data.Inventory.Inventory:FindFirstChild(p15);

    if v17 == nil then
        return;
    end;

    local v18, u19;

    if v17:FindFirstChild("Amount") == nil and true or v17.Amount.Value <= 1 then
        v18 = "FinaBlow";
        u19 = 1.6666666666666667;
        u6 = 1.26;
    else
        v18 = "RegularBlow";
        u19 = 1;
        u6 = 0.4166666666666667;
    end;

    u5 = os.clock();
    u8 = p14:FindFirstChild("HumanoidRootPart");

    if u8 ~= nil and u8.Parent ~= nil then
        u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    local v20, v21 = ManuelCancel.new(LocalPlayer, 5);
    u9 = v21;
    v20:Connect(function() -- Line: 107
        -- upvalues: u7 (ref), u2 (ref), u9 (ref), u8 (ref), u3 (ref), u4 (ref)
        if u7 then
            task.cancel(u7);
        end;

        if u2 ~= nil then
            u2:Stop();
        end;

        if u9 ~= nil then
            u9();
            u9 = nil;
        end;

        if u8 ~= nil and u8.Parent ~= nil then
            u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
            u4:Destroy();
            u4 = nil;
        end;

        u7 = nil;
    end);
    u3 = Utility.AddValue(valuesfolder, "pause_gameplay", u19);
    u4 = Utility.AddValue(valuesfolder, "JumpingDisabled", u19);
    local v22 = script:FindFirstChild(v18);

    if v22 ~= nil then
        u2 = u16.Animator:LoadAnimation(v22);
        u2:Play();
    end;

    u7 = task.spawn(function() -- Line: 122
        -- upvalues: u6 (ref), u9 (ref), u19 (ref), u16 (copy), u2 (ref), u8 (ref), u3 (ref), u4 (ref), u7 (ref)
        task.wait(u6 - 0.05);

        if u9 ~= nil then
            u9();
            u9 = nil;
        end;

        task.wait(u19 - (u6 - 0.05));

        if u16.Health > 0 then
            if u9 ~= nil then
                u9();
                u9 = nil;
            end;

            if u8 ~= nil and u8.Parent ~= nil then
                u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
            end;

            u2 = nil;

            if u3 ~= nil then
                u3:Destroy();
                u3 = nil;
                u4:Destroy();
                u4 = nil;
            end;

            u7 = nil;

            return;
        end;

        if u2 ~= nil then
            u2:Stop();
        end;

        if u9 ~= nil then
            u9();
            u9 = nil;
        end;

        if u8 ~= nil and u8.Parent ~= nil then
            u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
            u4:Destroy();
            u4 = nil;
        end;

        u7 = nil;
    end);
end;

function v1.MouseUp(p23: userdata, p24: string) -- Line: 136
    -- upvalues: u5 (ref), u7 (ref), u6 (ref), u2 (ref), u9 (ref), u8 (ref), u3 (ref), u4 (ref)
    local v25 = 0.3 - (os.clock() - u5);

    if v25 > 0 then
        task.wait(v25);
    end;

    if u7 and os.clock() - u5 < u6 - 0.05 then
        task.cancel(u7);

        if u2 ~= nil then
            u2:Stop();
        end;

        if u9 ~= nil then
            u9();
            u9 = nil;
        end;

        if u8 ~= nil and u8.Parent ~= nil then
            u8.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            u8.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
            u4:Destroy();
            u4 = nil;
        end;

        u7 = nil;
    end;
end;

return v1;