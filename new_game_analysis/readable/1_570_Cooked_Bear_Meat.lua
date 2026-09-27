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

local function releaseRefs() -- Line: 17
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u6 (ref)
    u2 = nil;

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
        u4:Destroy();
        u4 = nil;
    end;

    u6 = nil;
end;

local function cancelCleanup() -- Line: 28
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), u6 (ref)
    if u2 ~= nil then
        u2:Stop();
    end;

    u2 = nil;

    if u3 ~= nil then
        u3:Destroy();
        u3 = nil;
        u4:Destroy();
        u4 = nil;
    end;

    u6 = nil;
end;

function v1.MouseDown(p7: userdata, p8: string) -- Line: 35
    -- upvalues: Checker (copy), LocalPlayer (copy), valuesfolder (copy), Data (copy), u5 (ref), ManuelCancel (copy), u6 (ref), u2 (ref), u3 (ref), u4 (ref), Utility (copy)
    if p7 == nil then
        return;
    end;

    local u9 = p7:FindFirstChildOfClass("Humanoid");

    if u9 == nil or u9.Health <= 0 then
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

    if Data.Inventory.Inventory:FindFirstChild(p8) == nil then
        return;
    end;

    u5 = os.clock();
    local v10, u11 = ManuelCancel.new(LocalPlayer, 5);
    v10:Connect(function() -- Line: 47
        -- upvalues: u6 (ref), u2 (ref), u3 (ref), u4 (ref)
        if u6 then
            task.cancel(u6);
        end;

        if u2 ~= nil then
            u2:Stop();
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
            u4:Destroy();
            u4 = nil;
        end;

        u6 = nil;
    end);
    u3 = Utility.AddValue(valuesfolder, "pause_gameplay", 1.5);
    u4 = Utility.AddValue(valuesfolder, "JumpingDisabled", 1.5);
    local EatAnimation = script:FindFirstChild("EatAnimation");

    if EatAnimation ~= nil then
        u2 = u9.Animator:LoadAnimation(EatAnimation);
        u2:Play();
    end;

    u6 = task.spawn(function() -- Line: 62
        -- upvalues: u9 (copy), u11 (copy), u2 (ref), u3 (ref), u4 (ref), u6 (ref)
        task.wait(1);

        if u9.Health > 0 then
            u11();
            u2 = nil;

            if u3 ~= nil then
                u3:Destroy();
                u3 = nil;
                u4:Destroy();
                u4 = nil;
            end;

            u6 = nil;

            return;
        end;

        u11();

        if u2 ~= nil then
            u2:Stop();
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
            u4:Destroy();
            u4 = nil;
        end;

        u6 = nil;
    end);
end;

function v1.MouseUp(p12: userdata) -- Line: 74
    -- upvalues: u6 (ref), u5 (ref), u2 (ref), u3 (ref), u4 (ref)
    if u6 and os.clock() - u5 < 0.27 then
        task.cancel(u6);

        if u2 ~= nil then
            u2:Stop();
        end;

        u2 = nil;

        if u3 ~= nil then
            u3:Destroy();
            u3 = nil;
            u4:Destroy();
            u4 = nil;
        end;

        u6 = nil;
    end;
end;

return v1;