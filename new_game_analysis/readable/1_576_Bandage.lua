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

local function releaseRefs() -- Line: 36
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

function v1.MouseDown(p7: userdata, p8: string) -- Line: 51
    -- upvalues: Checker (copy), LocalPlayer (copy), valuesfolder (copy), Data (copy), u5 (ref), ManuelCancel (copy), u6 (ref), u2 (ref), u3 (ref), u4 (ref), Utility (copy)
    if p7 == nil then
        return;
    end;

    local v9 = p7:FindFirstChildOfClass("Humanoid");

    if v9 == nil or v9.Health <= 0 then
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
    local v10, u11 = ManuelCancel.new(LocalPlayer, 3.416666666666667);
    v10:Connect(function() -- Line: 63
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
    u3 = Utility.AddValue(valuesfolder, "pause_gameplay", 2.416666666666667);
    u4 = Utility.AddValue(valuesfolder, "JumpingDisabled", 2.416666666666667);
    local BandageWrapAnimation = script:FindFirstChild("BandageWrapAnimation");

    if BandageWrapAnimation ~= nil then
        u2 = v9.Animator:LoadAnimation(BandageWrapAnimation);
        u2.Looped = true;
        u2:Play();
    end;

    u6 = task.spawn(function() -- Line: 79
        -- upvalues: u11 (copy), u2 (ref), u3 (ref), u4 (ref), u6 (ref)
        task.wait(1.4166666666666667);
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

function v1.MouseUp(p12: userdata) -- Line: 86
    -- upvalues: u6 (ref), u5 (ref), u2 (ref), u3 (ref), u4 (ref)
    if u6 == nil then
        return;
    end;

    if os.clock() - u5 >= 1.2666666666666668 then
        return;
    end;

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

return v1;