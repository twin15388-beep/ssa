-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Item = require(ServerStorage.SAM.Services.Adders.Item);
local Item2 = require(ServerStorage.SAM.Services.Removers.Item);
local TitleService = require(ServerStorage.SAM.Services.TitleService);
local v1 = {};
local Color3_fromRGB_ret = Color3.fromRGB(165, 0, 0);
local u2 = ReplicatedStorage.ToolScripts["Health Potion"]["Health PotionServer"];

local function playPotionSound(p3: userdata, p4: string) -- Line: 62
    -- upvalues: u2 (copy), DebrisModule (copy)
    local v5 = script:FindFirstChild(p4) or u2:FindFirstChild(p4);

    if v5 == nil then
        return;
    end;

    local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    local v6 = v5:Clone();
    v6.Parent = HumanoidRootPart;
    v6:Play();
    DebrisModule:AddItem(v6, 0);
end;

local function convert(p7: userdata, p8: userdata) -- Line: 81
    -- upvalues: Item2 (copy), Item (copy), TitleService (copy)
    if p8.Inventory.Inventory:FindFirstChild("Biwa Bell") ~= nil then
        Item2(p7, "Biwa Bell");
    end;

    p8.Race.Value = "Demon";
    Item(p7, "Biwa Bell", 1, true, true, nil, "DemonConversion");
    TitleService.AddProgress(p7, "demon_conversions");
end;

local function throwBottle(p9: userdata, p10: userdata, p11: userdata) -- Line: 94
    -- upvalues: DebrisModule (copy)
    if p11 == nil or p11.Parent == nil then
        return;
    end;

    local PrimaryPart = p10.PrimaryPart;

    if PrimaryPart == nil then
        return;
    end;

    local Weld = p11:FindFirstChild("Weld");

    if Weld == nil then
        return;
    end;

    local Part1 = Weld.Part1;

    if Part1 == nil then
        return;
    end;

    local CFrame = PrimaryPart.CFrame;

    for _, child in ipairs(p11:GetChildren()) do
        if child:IsA("BasePart") then
            child:SetNetworkOwner(p9);
        end;
    end;

    Weld:Destroy();
    local Attachment = Instance.new("Attachment", Part1);
    local LinearVelocity = Instance.new("LinearVelocity", Attachment);
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.VectorVelocity = CFrame.LookVector * -20 + CFrame.UpVector * 5;
    DebrisModule:AddItem(p11, 2);
    task.delay(0.3, function() -- Line: 115
        -- upvalues: Attachment (copy), Part1 (copy)
        Attachment:Destroy();
        Part1.CanCollide = true;
    end);
end;

function v1.MouseDown(u12: userdata, u13: userdata, u14: table, u15: string) -- Line: 121
    -- upvalues: Checker (copy), Utility (copy), InCombat (copy), SignalEvent (copy), MuzanSettings (copy), playPotionSound (copy), Item2 (copy), EffectsEvent (copy), Color3_fromRGB_ret (copy), throwBottle (copy), convert (copy)
    if not Checker.check(u12, nil, "MuzansBlood") then
        return;
    end;

    local Data = Utility.GetData(u12);

    if Data == nil then
        return;
    end;

    if Data.Inventory.Inventory:FindFirstChild(u15) == nil then
        return;
    end;

    if Data.Race.Value ~= "Human" then
        return;
    end;

    if u14.TransformThread ~= nil then
        return;
    end;

    if u14.LastDrink ~= nil and os.clock() - u14.LastDrink < 1 then
        return;
    end;

    u14.LastDrink = os.clock();

    if InCombat.biasedCheck(u12) then
        SignalEvent.ToClient(u12, "Notify", {
            Type = "Denied",
            Text = `Can't transform while in combat ({Utility.formatTime(InCombat.biasedTimeLeft(u12))} left)`
        });

        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(u13);

    if valuesfolder == nil then
        return;
    end;

    local HumanoidRootPart = u13:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    u14.TransformPause = Utility.AddValue(valuesfolder, "pause_gameplay", MuzanSettings.TransformCutsceneAt + MuzanSettings.TransformLength + 0.5);

    local function release() -- Line: 151
        -- upvalues: u14 (copy)
        if u14.TransformPause ~= nil then
            u14.TransformPause:Destroy();
            u14.TransformPause = nil;
        end;

        u14.TransformThread = nil;
    end;

    u14.TransformThread = task.spawn(function() -- Line: 158
        -- upvalues: u13 (copy), Checker (ref), release (copy), playPotionSound (ref), MuzanSettings (ref), Data (copy), Item2 (ref), u12 (copy), u15 (copy), EffectsEvent (ref), Color3_fromRGB_ret (ref), throwBottle (ref), HumanoidRootPart (copy), convert (ref), u14 (copy)
        local CapWeld = u13:FindFirstChild("CapWeld", true);
        local v16;

        if CapWeld == nil then
            v16 = nil;
        else
            v16 = CapWeld.Parent or nil;
        end;

        task.wait(0.3);

        if Checker.check_victim(script, u13, u13) == nil then
            return release();
        end;

        if CapWeld ~= nil and (v16 ~= nil and v16:FindFirstChild("Cap") ~= nil) then
            CapWeld.Part1 = nil;
            v16.Cap.CanCollide = true;
            playPotionSound(u13, "PS2potionOPEN");
        end;

        task.wait(0.9500000000000001);

        if Checker.check_victim(script, u13, u13) == nil then
            return release();
        end;

        playPotionSound(u13, "PS2potionDRINK");
        task.wait(MuzanSettings.TransformSipAt - 1.3);
        local v17 = u13:FindFirstChildOfClass("Humanoid");

        if u13.Parent == nil or (v17 == nil or (v17.Health <= 0 or (Data.Race.Value ~= "Human" or not Item2(u12, u15, nil, nil, "Consumed")))) then
            return release();
        end;

        playPotionSound(u13, "PS2potionADMINISTER");
        EffectsEvent.ToAllInRange(u13, "GeneralActivated", u13, Color3_fromRGB_ret);

        if v16 ~= nil and v16.Parent ~= nil then
            v16.Parent = workspace.Debree;
        end;

        task.wait(MuzanSettings.TransformDrinkLead - MuzanSettings.TransformSipAt);
        throwBottle(u12, u13, v16);
        playPotionSound(u13, "PS2potionTHROW");
        task.wait(MuzanSettings.TransformCutsceneAt - MuzanSettings.TransformDrinkLead);
        EffectsEvent.ToAllInRange(HumanoidRootPart, "MuzanTransformEffects", u13);
        task.wait(MuzanSettings.TransformConvertAt);

        if u13.Parent ~= nil and (v17.Health > 0 and Data.Race.Value == "Human") then
            convert(u12, Data);
        end;

        task.wait(MuzanSettings.TransformLength - MuzanSettings.TransformConvertAt);

        if u14.TransformPause ~= nil then
            u14.TransformPause:Destroy();
            u14.TransformPause = nil;
        end;

        u14.TransformThread = nil;
    end);
end;

return v1;