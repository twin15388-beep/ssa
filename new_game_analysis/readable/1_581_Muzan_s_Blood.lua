-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local SequenceTeleport = require(ReplicatedStorage.CAM.Client.Modules.SequenceTeleport);
local v1 = {};
local LocalPlayer = Players.LocalPlayer;
local u2 = script.Parent:WaitForChild("Muzan\'s BloodServer");

local function getDrinkClip() -- Line: 36
    -- upvalues: u2 (copy), ReplicatedStorage (copy)
    local Drink = u2:FindFirstChild("Drink");

    if Drink ~= nil then
        return Drink;
    end;

    local v3 = ReplicatedStorage.ToolScripts:FindFirstChild("Health Potion");
    local v4 = v3 ~= nil and v3:FindFirstChild("Health Potion") or nil;

    return v4 ~= nil and v4:FindFirstChild("HealthPotionThrowAway") or nil;
end;

local u5 = 0;
local u6 = nil;
local u7 = nil;
local u8 = nil;

local function setHeadCam() -- Line: 52
    -- upvalues: LocalPlayer (copy), Utility (copy), u8 (ref)
    local Character = LocalPlayer.Character;
    local v9 = Character ~= nil and Character:FindFirstChild("Head") or nil;
    local valuesfolder = Utility.getvaluesfolder(LocalPlayer);

    if v9 == nil or valuesfolder == nil then
        return;
    end;

    if u8 == nil or u8.Parent == nil then
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = "camsubject";
        ObjectValue.Parent = valuesfolder;
        u8 = ObjectValue;
    end;

    u8.Value = v9;
end;

local function clearHeadCam() -- Line: 65
    -- upvalues: u8 (ref)
    if u8 ~= nil then
        u8:Destroy();
        u8 = nil;
    end;
end;

function v1.MouseDown(p10: userdata, p11: string) -- Line: 73
    -- upvalues: Checker (copy), LocalPlayer (copy), Utility (copy), u6 (ref), u5 (ref), InCombat (copy), SequenceTeleport (copy), getDrinkClip (copy), u7 (ref), MuzanSettings (copy), setHeadCam (copy), u2 (copy), u8 (ref)
    if p10 == nil then
        return;
    end;

    local u12 = p10:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart");

    if u12 == nil or (u12.Health <= 0 or HumanoidRootPart == nil) then
        return;
    end;

    if not Checker.check(LocalPlayer, nil, "MuzansBlood") then
        return;
    end;

    local Data = Utility.GetData(LocalPlayer);

    if Data == nil then
        return;
    end;

    if Data.Inventory.Inventory:FindFirstChild(p11) == nil then
        return;
    end;

    if Data.Race.Value ~= "Human" then
        return;
    end;

    if u6 ~= nil then
        return;
    end;

    if os.clock() - u5 < 1 then
        return;
    end;

    u5 = os.clock();

    if InCombat.biasedCheck(LocalPlayer) then
        return;
    end;

    local v13 = SequenceTeleport.GroundSnap(HumanoidRootPart.CFrame);
    p10:PivotTo(v13);
    u6 = Utility.lock(HumanoidRootPart, v13, nil, (`{LocalPlayer.Name}_MuzanBloodLock`));
    local v14 = getDrinkClip();

    if v14 ~= nil then
        u7 = u12.Animator:LoadAnimation(v14);
        u7:Play();
    end;

    task.delay(MuzanSettings.TransformCutsceneAt, function() -- Line: 104
        -- upvalues: u6 (ref), u7 (ref), setHeadCam (ref), u2 (ref), u12 (copy)
        if u6 == nil then
            return;
        end;

        if u7 ~= nil then
            u7:Stop();
        end;

        setHeadCam();
        local Transformation = u2:FindFirstChild("Transformation");

        if Transformation ~= nil and u12.Parent ~= nil then
            u7 = u12.Animator:LoadAnimation(Transformation);
            u7:Play();
        end;
    end);
    task.delay(MuzanSettings.TransformCutsceneAt + MuzanSettings.TransformLength, function() -- Line: 118
        -- upvalues: u7 (ref), u6 (ref), u8 (ref)
        if u7 ~= nil then
            u7:Stop();
            u7 = nil;
        end;

        if u6 ~= nil then
            u6:Destroy();
            u6 = nil;
        end;

        if u8 ~= nil then
            u8:Destroy();
            u8 = nil;
        end;
    end);
end;

return v1;