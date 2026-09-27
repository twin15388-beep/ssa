-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local TweenService = game:GetService("TweenService");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Combat_Util = require(ServerStorage.SAM.Services.Combat_Util);
local CharGrabPosCorrector = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.CharGrabPosCorrector);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Wen = require(ReplicatedStorage.CAM.Global.Shop.Cashiers.Wen);
local Item = require(ServerStorage.SAM.Services.Adders.Item);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
Shop.RegisterItem("Horse", {
    Type = Menum.ShopItemType.IngameItem
});
local v1 = {};

local function fireTamingVFX(p2: userdata?, p3: userdata?, p4: string, p5: boolean?) -- Line: 43
    -- upvalues: EffectsEvent (copy)
    if p3 == nil then
        return;
    end;

    local v6 = p3:FindFirstChild("HumanoidRootPart") or p3.PrimaryPart;
    EffectsEvent.ToAllInRange(v6 or p3, "HorseTamingVFX", p2, p3, p3:GetAttribute("UniqueName"), p4, p5);
end;

local function playRideAnim(p7: userdata?, p8: userdata) -- Line: 51
    if p7 == nil then
        return nil;
    end;

    local v9 = p7:FindFirstChildOfClass("Animator");

    if v9 == nil then
        v9 = Instance.new("Animator");
        v9.Parent = p7;
    end;

    local v10 = v9:LoadAnimation(p8);
    v10:Play();

    return v10;
end;

local function restorePlayerNetwork(p11: userdata, p12: userdata?) -- Line: 65
    if p12 then
        p12 = p12:FindFirstChild("HumanoidRootPart");
    end;

    if p12 and (p11.Parent ~= nil and (not p12.Anchored and p12:CanSetNetworkOwnership())) then
        p12:SetNetworkOwner(p11);
    end;
end;

function v1.Do(p13: userdata, p14: userdata, p15: table, p16: userdata, p17: userdata?) -- Line: 72
    -- upvalues: Utility (copy), gameSettings (copy), EffectsEvent (copy)
    local v18 = p17 and p17.Parent and p17.Parent.Parent;

    if v18 then
        p15.Horse = v18;
        p15.Prompt = p17;
        p15.HorsePause = Utility.AddValue(v18, "pause_gameplay");
        local ClientAnimatorServer = v18:FindFirstChild("ClientAnimatorServer");

        if ClientAnimatorServer then
            ClientAnimatorServer = ClientAnimatorServer:FindFirstChild("CurrentAnim");
        end;

        if ClientAnimatorServer then
            p15.HorseAnim = ClientAnimatorServer;
            p15.HorseAnimPrev = ClientAnimatorServer.Value;
            ClientAnimatorServer.Value = "idle";
        end;

        local HumanoidRootPart = v18:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            p15.HorseRoot = HumanoidRootPart;
            p15.HorseRootAnchored = HumanoidRootPart.Anchored;
            HumanoidRootPart.Anchored = true;
            local HumanoidRootPart2 = p14:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart2 then
                local Weld = Instance.new("Weld");
                Weld.Part0 = HumanoidRootPart;
                Weld.Part1 = HumanoidRootPart2;
                Weld.C0 = gameSettings.horseRidingPlayerOffset;
                Weld.Parent = HumanoidRootPart;
                HumanoidRootPart2.CFrame = HumanoidRootPart.CFrame * Weld.C0;
                p15.HorseWeld = Weld;
            end;
        end;

        local Humanoid = v18:FindFirstChild("Humanoid");
        local script_HorseResiting = script.HorseResiting;
        local v19;

        if Humanoid == nil then
            v19 = nil;
        else
            local v20 = Humanoid:FindFirstChildOfClass("Animator");

            if v20 == nil then
                v20 = Instance.new("Animator");
                v20.Parent = Humanoid;
            end;

            v19 = v20:LoadAnimation(script_HorseResiting);
            v19:Play();
        end;

        p15.HorseRideTrack = v19;
        local Humanoid2 = p14:FindFirstChild("Humanoid");
        local script_PlayerResiting = script.PlayerResiting;
        local v21;

        if Humanoid2 == nil then
            v21 = nil;
        else
            local v22 = Humanoid2:FindFirstChildOfClass("Animator");

            if v22 == nil then
                v22 = Instance.new("Animator");
                v22.Parent = Humanoid2;
            end;

            v21 = v22:LoadAnimation(script_PlayerResiting);
            v21:Play();
        end;

        p15.PlayerRideTrack = v21;

        if v18 ~= nil then
            local v23 = v18:FindFirstChild("HumanoidRootPart") or v18.PrimaryPart;
            EffectsEvent.ToAllInRange(v23 or v18, "HorseTamingVFX", p14, v18, v18:GetAttribute("UniqueName"), "Taming", true);
        end;

        local valuesfolder = Utility.getvaluesfolder(p14);
        local Head = p14:FindFirstChild("Head");

        if valuesfolder and Head then
            p15.CamSubject = Utility.AddValue(valuesfolder, "camsubject", nil, "ObjectValue", Head);
        end;
    end;

    return true, true;
end;

function v1.Destroying(p24: userdata, p25: userdata, p26: table, p27: userdata) -- Line: 143
    -- upvalues: EffectsEvent (copy)
    local Horse = p26.Horse;

    if Horse ~= nil then
        local v28 = Horse:FindFirstChild("HumanoidRootPart") or Horse.PrimaryPart;
        EffectsEvent.ToAllInRange(v28 or Horse, "HorseTamingVFX", p25, Horse, Horse:GetAttribute("UniqueName"), "Taming", false);
    end;

    if p26.HorseRideTrack ~= nil then
        p26.HorseRideTrack:Stop();
        p26.HorseRideTrack = nil;
    end;

    if p26.PlayerRideTrack ~= nil then
        p26.PlayerRideTrack:Stop();
        p26.PlayerRideTrack = nil;
    end;

    if p26.HorseThrowTrack ~= nil then
        p26.HorseThrowTrack:Stop();
        p26.HorseThrowTrack = nil;
    end;

    if p26.PlayerThrowTrack ~= nil then
        p26.PlayerThrowTrack:Stop();
        p26.PlayerThrowTrack = nil;
    end;

    if p26.HorseWeld ~= nil then
        p26.HorseWeld:Destroy();
        p26.HorseWeld = nil;
    end;

    if p25 then
        p25 = p25:FindFirstChild("HumanoidRootPart");
    end;

    if p25 and (p24.Parent ~= nil and (not p25.Anchored and p25:CanSetNetworkOwnership())) then
        p25:SetNetworkOwner(p24);
    end;

    if p26.CamSubject ~= nil then
        p26.CamSubject:Destroy();
        p26.CamSubject = nil;
    end;

    if not p26.Tamed then
        if p26.HorsePause ~= nil then
            p26.HorsePause:Destroy();
            p26.HorsePause = nil;
        end;

        if p26.HorseAnim ~= nil then
            if p26.HorseAnim.Parent ~= nil then
                p26.HorseAnim.Value = p26.HorseAnimPrev;
            end;

            p26.HorseAnim = nil;
            p26.HorseAnimPrev = nil;
        end;

        if p26.HorseRoot ~= nil then
            if p26.HorseRoot.Parent ~= nil then
                p26.HorseRoot.Anchored = p26.HorseRootAnchored == true;

                if p26.HorseRoot:CanSetNetworkOwnership() then
                    p26.HorseRoot:SetNetworkOwner(nil);
                end;
            end;

            p26.HorseRoot = nil;
            p26.HorseRootAnchored = nil;
        end;
    end;
end;

local function throwOff(p29: userdata, p30: userdata, p31: table) -- Line: 211
    -- upvalues: EffectsEvent (copy), Utility (copy), Combat_Util (copy)
    local Horse = p31.Horse;
    local v32;

    if p30 then
        v32 = p30:FindFirstChild("HumanoidRootPart");
    else
        v32 = p30;
    end;

    if p31.HorseRideTrack then
        p31.HorseRideTrack:Stop();
        p31.HorseRideTrack = nil;
    end;

    if p31.PlayerRideTrack then
        p31.PlayerRideTrack:Stop();
        p31.PlayerRideTrack = nil;
    end;

    if Horse then
        local Humanoid = Horse:FindFirstChild("Humanoid");
        local script_HorseThrowOff = script.HorseThrowOff;
        local v33;

        if Humanoid == nil then
            v33 = nil;
        else
            local v34 = Humanoid:FindFirstChildOfClass("Animator");

            if v34 == nil then
                v34 = Instance.new("Animator");
                v34.Parent = Humanoid;
            end;

            v33 = v34:LoadAnimation(script_HorseThrowOff);
            v33:Play();
        end;

        p31.HorseThrowTrack = v33;
    end;

    local v35;

    if p30 then
        v35 = p30:FindFirstChild("Humanoid");
    else
        v35 = p30;
    end;

    local script_PlayerThrowOff = script.PlayerThrowOff;
    local v36;

    if v35 == nil then
        v36 = nil;
    else
        local v37 = v35:FindFirstChildOfClass("Animator");

        if v37 == nil then
            v37 = Instance.new("Animator");
            v37.Parent = v35;
        end;

        v36 = v37:LoadAnimation(script_PlayerThrowOff);
        v36:Play();
    end;

    p31.PlayerThrowTrack = v36;
    task.wait(0.75);

    if p31.PlayerThrowTrack then
        p31.PlayerThrowTrack:Stop();
        p31.PlayerThrowTrack = nil;
    end;

    if p31.HorseWeld then
        p31.HorseWeld:Destroy();
        p31.HorseWeld = nil;
    end;

    local v38;

    if p30 then
        v38 = p30:FindFirstChild("HumanoidRootPart");
    else
        v38 = p30;
    end;

    if v38 and (p29.Parent ~= nil and (not v38.Anchored and v38:CanSetNetworkOwnership())) then
        v38:SetNetworkOwner(p29);
    end;

    if Horse ~= nil then
        local v39 = Horse:FindFirstChild("HumanoidRootPart") or Horse.PrimaryPart;
        EffectsEvent.ToAllInRange(v39 or Horse, "HorseTamingVFX", p30, Horse, Horse:GetAttribute("UniqueName"), "ThrowOff", nil);
    end;

    if v32 and (v32.Parent ~= nil and Horse) then
        local valuesfolder = Utility.getvaluesfolder(p30);
        local v40 = p31.HorseRoot or Horse:FindFirstChild("HumanoidRootPart");
        local ThrowPart = Horse:FindFirstChild("ThrowPart", true);
        local v41 = nil;

        if ThrowPart then
            v41 = ThrowPart.Position;
        elseif v40 then
            v41 = (v40.CFrame * CFrame.new(0, 0, 12)).Position;
        end;

        if v41 then
            local v42 = v41 - v32.Position;
            local v43 = (v42.Magnitude > 0 and v42.Unit or (v40 and -v40.CFrame.LookVector or Vector3.new(0, 0, 1))) * 25 + Vector3.new(0, -2, 0);

            if valuesfolder then
                Combat_Util.RagDoll(script, p30, valuesfolder, 1);
                Combat_Util.AddStun(script, p30, valuesfolder, 1);
            end;

            Combat_Util.Knockback(script, p30, v32, v43, 0.25);
        end;
    end;

    task.wait(1);
end;

local function tameHorse(u44: userdata, p45: table) -- Line: 278
    -- upvalues: EffectsEvent (copy), TweenService (copy)
    local Horse = p45.Horse;

    if Horse == nil then
        return;
    end;

    p45.Tamed = true;

    if p45.Prompt then
        p45.Prompt:Destroy();
        p45.Prompt = nil;
    end;

    local Parent = Horse.Parent;

    if Parent then
        Parent = Parent:FindFirstChild("AiSignal");
    end;

    Horse.Parent = workspace.Debree;
    task.spawn(function() -- Line: 302
        -- upvalues: u44 (copy), Horse (copy), EffectsEvent (ref), TweenService (ref), Parent (copy)
        local Character = u44.Character;
        local v46 = Horse;

        if v46 ~= nil then
            local v47 = v46:FindFirstChild("HumanoidRootPart") or v46.PrimaryPart;
            EffectsEvent.ToAllInRange(v47 or v46, "HorseTamingVFX", Character, v46, v46:GetAttribute("UniqueName"), "Tamed", nil);
        end;

        local TweenInfo_new_ret = TweenInfo.new(0.35);

        for _, descendant in Horse:GetDescendants() do
            if (descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture"))) and descendant.Transparency < 1 then
                TweenService:Create(descendant, TweenInfo_new_ret, {
                    Transparency = 1
                }):Play();
            end;
        end;

        task.wait(0.35);

        if Parent then
            Parent:Fire("Died", u44);
        end;

        if Horse.Parent ~= nil then
            Horse:Destroy();
        end;
    end);
end;

local function getOff(p48: userdata, p49: userdata, p50: table, p51: boolean?) -- Line: 332
    -- upvalues: CharGrabPosCorrector (copy), tameHorse (copy)
    if p50.HorseRideTrack then
        p50.HorseRideTrack:Stop();
        p50.HorseRideTrack = nil;
    end;

    if p50.PlayerRideTrack then
        p50.PlayerRideTrack:Stop();
        p50.PlayerRideTrack = nil;
    end;

    local v52;

    if p49 then
        v52 = p49:FindFirstChild("Humanoid");
    else
        v52 = p49;
    end;

    local script_PlayerGetOff = script.PlayerGetOff;
    local v53;

    if v52 == nil then
        v53 = nil;
    else
        local v54 = v52:FindFirstChildOfClass("Animator");

        if v54 == nil then
            v54 = Instance.new("Animator");
            v54.Parent = v52;
        end;

        v53 = v54:LoadAnimation(script_PlayerGetOff);
        v53:Play();
    end;

    p50.PlayerThrowTrack = v53;

    if v53 and p49 then
        CharGrabPosCorrector.Do(p49, v53, 1.333, p49);
    end;

    task.wait(1.2329999999999999);

    if p50.HorseWeld then
        p50.HorseWeld:Destroy();
        p50.HorseWeld = nil;
    end;

    task.wait(0.10000000000000009);

    if p51 then
        tameHorse(p48, p50);
    end;
end;

local function offerHorsePurchase(u55: userdata) -- Line: 368
    -- upvalues: Utility (copy), Shop (copy), SignalEvent (copy), Wen (copy), SignalFunction (copy), Item (copy)
    local Data = Utility.GetData(u55);

    if Data == nil then
        return false;
    end;

    if not Shop.CanBuy(u55, "Horse", Data) then
        local Price = Shop.GetPrice("Horse");
        local math_max_ret = math.max(0, (Price and Price.Wen or 0) - Data.Wen.Value);
        SignalEvent.ToClient(u55, "Notify", {
            Type = "Warn",
            Text = `Not enough wen to afford {Utility.NameTag("Horse")}, you need {Wen.FormulateTextPlusText(math_max_ret)} more`
        });

        return false;
    end;

    local u56 = `Would you like to purchase {Utility.NameTag("Horse", true)} for {Shop.GetPriceRichText("Horse")}?`;
    local success, result = pcall(function() -- Line: 386
        -- upvalues: SignalFunction (ref), u55 (copy), u56 (copy)
        return SignalFunction.ToClient(u55, "InferPopup", {
            Type = "Question",
            Timout = 15,
            Content = u56
        });
    end);

    if not success or result ~= "Yes" then
        return false;
    end;

    if not Shop.CanBuy(u55, "Horse", Data) then
        return false;
    end;

    local v57, v58 = Item(u55, "Horse", nil, false, true, nil, "Shop");

    if v57 then
        for i, v in Shop.GetPrice("Horse") do
            Shop.cashiers[i].Buy(Data, v, u55, "Horse");
        end;

        return true;
    end;

    if v58 == "Already exists" then
        SignalEvent.ToClient(u55, "Notify", {
            Type = "Denied",
            Text = `You already own a {Utility.NameTag("Horse")}`
        });
    end;

    return false;
end;

function v1.Stop(p59: userdata, p60: userdata, p61: table, p62: boolean?, ...) -- Line: 420
    -- upvalues: EffectsEvent (copy), throwOff (copy), offerHorsePurchase (copy), getOff (copy)
    local Horse = p61.Horse;

    if Horse ~= nil then
        local v63 = Horse:FindFirstChild("HumanoidRootPart") or Horse.PrimaryPart;
        EffectsEvent.ToAllInRange(v63 or Horse, "HorseTamingVFX", p60, Horse, Horse:GetAttribute("UniqueName"), "Taming", false);
    end;

    if p61.CamSubject then
        p61.CamSubject:Destroy();
        p61.CamSubject = nil;
    end;

    if p60 ~= nil then
        if p62 == false then
            throwOff(p59, p60, p61);
        elseif p62 == true then
            getOff(p59, p60, p61, (offerHorsePurchase(p59)));
        end;
    end;

    return true;
end;

return v1;