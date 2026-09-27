-- Decompiled with Potassium's decompiler.

script:WaitForChild("Sounds"):WaitForChild("Basalt");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local LocalPlayer = game.Players.LocalPlayer;
local u1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local u2 = nil;
local HumanoidRootPart = u1:WaitForChild("HumanoidRootPart");
local Running = HumanoidRootPart:WaitForChild("Running");
local Humanoid = u1:WaitForChild("Humanoid");
HumanoidRootPart:WaitForChild("Jumping").SoundId = "";

function water_ef()
    -- upvalues: u1 (copy), u2 (ref), DebrisModule (copy), vfxUtility (copy)
    if u1 == nil then
        return;
    end;

    local RightFoot = u1:FindFirstChild("RightFoot");
    local LeftFoot = u1:FindFirstChild("LeftFoot");

    if RightFoot and (LeftFoot and u2 == Enum.Material.Water) then
        local v3 = math.random(1, 2) == 1 and RightFoot and RightFoot or LeftFoot;
        local v4 = script.Water_Step:Clone();
        v4.Position = v3.Position;
        v4.Parent = workspace.Debree;
        DebrisModule:AddItem(v4, 1.75);
        vfxUtility.EmitAll(v4.Attachment);
    end;
end;

script.Sounds.Basalt.Played:Connect(water_ef);
Running.DidLoop:Connect(water_ef);
local u5 = "";
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Terrain, workspace.Map };
RaycastParams_new_ret.IgnoreWater = false;
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local valuesfolder = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility")).getvaluesfolder(LocalPlayer, true);

function upd_running()
    -- upvalues: Character_info_provider (copy), LocalPlayer (copy), Humanoid (copy), HumanoidRootPart (copy), RaycastParams_new_ret (copy), u1 (copy), u2 (ref), valuesfolder (copy), Running (copy), u5 (ref)
    local _core_anim = Character_info_provider.get_core_anim(LocalPlayer, "walk", true);
    local _core_anim2 = Character_info_provider.get_core_anim(LocalPlayer, "run", true);
    local v6 = "";
    local FloorMaterial = Humanoid.FloorMaterial;

    if HumanoidRootPart ~= nil and (FloorMaterial ~= nil and FloorMaterial ~= Enum.Material.Air) then
        local v7 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -45, 0), RaycastParams_new_ret);

        if v7 ~= nil and v7.Material == Enum.Material.Water then
            FloorMaterial = Enum.Material.Water;
        end;
    end;

    local Attribute = u1:GetAttribute("SwimState");

    if Attribute == 2 and (FloorMaterial ~= nil and FloorMaterial ~= Enum.Material.Air) then
        FloorMaterial = Enum.Material.Water;
    end;

    u2 = FloorMaterial;
    local v8;

    if FloorMaterial == nil then
        v8 = false;
    else
        v8 = script.Sounds:FindFirstChild(FloorMaterial.Name) or script.Sounds.Plastic;
    end;

    if v8 ~= nil then
        v6 = v8.SoundId;
    end;

    if Humanoid ~= nil and Humanoid.HipHeight > 2.2 then
        v8 = nil;
        v6 = "";
    end;

    if typeof(Attribute) == "number" and (Attribute > 0 and Attribute ~= 2) then
        v8 = nil;
        v6 = "";
    end;

    if valuesfolder ~= nil and valuesfolder:FindFirstChild("boulder_push") ~= nil then
        v8 = nil;
        v6 = "";
    end;

    if u1:GetAttribute("OnHorse") then
        v8 = nil;
        v6 = "";
    end;

    if valuesfolder ~= nil and valuesfolder:FindFirstChild("NoFootStep") ~= nil then
        v8 = nil;
        v6 = "";
    end;

    local v9 = (v8 == nil or v8:FindFirstChild("SpeedInfluence") == nil) and 1 or (v8.SpeedInfluence.Value or 1);
    local v10 = 0.05 * ((v8 == nil or v8:FindFirstChild("VolumeInfluence") == nil) and 1 or (v8.VolumeInfluence.Value or 1));
    local v11 = v9 * (math.clamp(1 - 16 / Humanoid.WalkSpeed, -0.3, 9999) * 1.8 + 1);
    Running.SoundId = v6;
    local v12 = 1;
    local Attribute2 = _core_anim2:GetAttribute("SI");
    local Attribute3 = _core_anim:GetAttribute("SI");
    local v13;

    if v11 > 1 then
        v13 = Attribute2 or v12;
    else
        v13 = Attribute3 or v12;
    end;

    Running.PlaybackSpeed = v11 * v13;
    Running.Volume = v10;

    if v6 ~= u5 then
        Running.TimePosition = 0;
    end;

    u5 = v6;
end;

Humanoid:GetPropertyChangedSignal("HipHeight"):Connect(upd_running);
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(upd_running);
Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(upd_running);
u1:GetAttributeChangedSignal("SwimState"):Connect(upd_running);
u1:GetAttributeChangedSignal("OnHorse"):Connect(upd_running);

if valuesfolder ~= nil then
    valuesfolder.ChildAdded:Connect(function(p14) -- Line: 129
        if p14.Name == "boulder_push" or p14.Name == "NoFootStep" then
            upd_running();
        end;
    end);
    valuesfolder.ChildRemoved:Connect(function(p15) -- Line: 132
        if p15.Name == "boulder_push" or p15.Name == "NoFootStep" then
            upd_running();
        end;
    end);
end;

upd_running();