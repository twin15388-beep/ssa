-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Cutscene_camera_handler = require(ServerStorage.SAM.Game_Play.Cutscene_camera_handler);
local ItemModels = require(ReplicatedStorage.CAM.Global.Collectibles.ItemModels);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local v1 = {};

local function getAnimator(p2: userdata) -- Line: 21
    local v3 = p2:FindFirstChildOfClass("Humanoid") or p2:FindFirstChildOfClass("AnimationController");

    if v3 == nil then
        return nil;
    end;

    return v3:FindFirstChildOfClass("Animator") or Instance.new("Animator", v3);
end;

local function weldTo(p4: userdata, p5: userdata) -- Line: 29
    local Weld = Instance.new("Weld");
    Weld.Part0 = p4;
    Weld.Part1 = p5;
    Weld.Parent = p5;

    return Weld;
end;

local function playCutscene(p6: userdata, p7: userdata, p8: any) -- Line: 40
    -- upvalues: DebrisModule (copy), Utility (copy), ItemModels (copy), EffectsEvent (copy), Cutscene_camera_handler (copy)
    local CutscenePart = p8.CutscenePart;
    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

    if CutscenePart == nil or HumanoidRootPart == nil then
        return;
    end;

    if p8.Weld ~= nil then
        p8.Weld:Destroy();
        p8.Weld = nil;
    end;

    local Sword = p8.Sword;
    p8.Sword = nil;

    if Sword ~= nil then
        DebrisModule:AddItem(Sword, 12.266);
    end;

    local valuesfolder = Utility.getvaluesfolder(p7);

    if valuesfolder ~= nil then
        Utility.AddValue(valuesfolder, "pause_gameplay", 12.266);
        Utility.AddValue(valuesfolder, "skill_stand_still", 12.266);
        Utility.AddValue(valuesfolder, "iframe", 12.266);
        Utility.AddValue(valuesfolder, "noragdoll", 12.266);
        Utility.AddValue(valuesfolder, "FOV", 12.266, "NumberValue", 30);
    end;

    local Weld = Instance.new("Weld");
    Weld.Part0 = CutscenePart;
    Weld.Part1 = HumanoidRootPart;
    Weld.Parent = HumanoidRootPart;
    DebrisModule:AddItem(Weld, 12.166);
    local v9 = p7:FindFirstChildOfClass("Humanoid") or p7:FindFirstChildOfClass("AnimationController");
    local v10;

    if v9 == nil then
        v10 = nil;
    else
        v10 = v9:FindFirstChildOfClass("Animator") or Instance.new("Animator", v9);
    end;

    local v11 = v10 and v10:LoadAnimation(script.Parent.CutscenePlayer) or nil;

    if v11 then
        v11:Play();
    end;

    local v12 = script.Parent.Sabito:Clone();
    v12.Name = `{p6.Name}_BoulderSplit_Sabito`;
    v12.Parent = workspace.Debree;
    v12:PivotTo(CutscenePart.CFrame);
    DebrisModule:AddItem(v12, 12.266);
    local RightHand = v12:FindFirstChild("RightHand");

    if RightHand then
        local v13 = ItemModels.FindTool("Ocean Wave Katana").Equipped["Basic Katana"]:Clone();
        v13.Parent = v12;
        v13.Weld.Part0 = RightHand;
    end;

    local v14 = v12:FindFirstChildOfClass("Humanoid") or v12:FindFirstChildOfClass("AnimationController");
    local v15;

    if v14 == nil then
        v15 = nil;
    else
        v15 = v14:FindFirstChildOfClass("Animator") or Instance.new("Animator", v14);
    end;

    if v15 then
        v15:LoadAnimation(script.Parent.SabitoAnimation):Play();
    end;

    local Boulder = p8.Boulder;

    if Boulder then
        local v16 = Boulder:FindFirstChildOfClass("Humanoid") or Boulder:FindFirstChildOfClass("AnimationController");
        local v17;

        if v16 == nil then
            v17 = nil;
        else
            v17 = v16:FindFirstChildOfClass("Animator") or Instance.new("Animator", v16);
        end;

        if v17 then
            v17:LoadAnimation(script.Parent.CutsceneBoulder):Play();
        end;
    end;

    EffectsEvent.ToAllInRange(CutscenePart, "BoulderSlashCutscene", p7);
    local v18 = script.Parent.CameraRig:Clone();
    v18.Name = `{p6.Name}_BoulderSplit_cameraRig`;
    v18.Parent = workspace.Debree;
    v18.RootPart.CameraWeld.Part0 = CutscenePart;
    DebrisModule:AddItem(v18, 12.266);
    local v19 = v18:FindFirstChildOfClass("Humanoid") or v18:FindFirstChildOfClass("AnimationController");
    local v20;

    if v19 == nil then
        v20 = nil;
    else
        v20 = v19:FindFirstChildOfClass("Animator") or Instance.new("Animator", v19);
    end;

    if v20 then
        v20:LoadAnimation(script.Parent.CameraAnimation):Play();
    end;

    Cutscene_camera_handler.Regular(p6, v18.Bone);
end;

function v1.Do(p21: userdata, p22: userdata, p23: table, p24: userdata, p25: userdata?) -- Line: 142
    -- upvalues: ItemModels (copy)
    local Parent = p25.Parent;
    p23.CutscenePart = Parent.Parent:FindFirstChild("CutscenePart");
    p23.Boulder = Parent.Parent:FindFirstChild("Boulder");
    local Weld = Instance.new("Weld");
    Weld.Part0 = p22.HumanoidRootPart;
    Weld.Part1 = Parent;
    Weld.Parent = Parent;
    p23.Weld = Weld;
    p23.Sword = ItemModels.FindTool("Regular Katana").Equipped["Basic Katana 1"]:Clone();
    p23.Sword.Parent = p22;
    p23.Sword.Weld.Part0 = p22.RightHand;

    return true, false;
end;

function v1.StateChanged(p26: userdata, p27: userdata, p28: table, ...) -- Line: 163
    -- upvalues: EffectsEvent (copy)
    EffectsEvent.ToOthersInRange(p26, "BoulderSlashFailed", p27);
end;

function v1.Destroying(p29: userdata, p30: userdata, p31: table, p32: userdata) -- Line: 172
    if p31.Weld ~= nil then
        p31.Weld.Part0 = nil;
        p31.Weld = nil;
    end;

    if p31.Sword ~= nil then
        p31.Sword:Destroy();
        p31.Sword = nil;
    end;
end;

function v1.Stop(p33: userdata, p34: userdata, p35: table, p36: boolean?) -- Line: 182
    -- upvalues: playCutscene (copy)
    if p36 ~= true then
        return true;
    end;

    playCutscene(p33, p34, p35);

    return true, nil, 12.266;
end;

return v1;