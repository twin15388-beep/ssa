-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Debris = game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local TweenService = game:GetService("TweenService");
local Item = require(ServerStorage.SAM.Services.Adders.Item);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local AnalyticsService = require(ServerStorage.SAM.Services.AnalyticsService);
local DataPathService = require(ServerStorage.SAM.Services.DataPathService);
local DrownedLine = require(ServerStorage.SAM.WorldEvents.DrownedLine);
local FishingHandler = require(ServerStorage.SAM.Services.FishingHandler);
local ItemModels = require(ReplicatedStorage.CAM.Global.Collectibles.ItemModels);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Item2 = require(ServerStorage.SAM.Services.Removers.Item);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local Refinement = require(ReplicatedStorage.CAM.Global.Refinement);
local TitleService = require(ServerStorage.SAM.Services.TitleService);
local ServerClientPortal = require(ReplicatedStorage.CAM.Global.ServerClientPortal);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1 = {
    Common = "fish_common",
    Rare = "fish_rare",
    Legendary = "fish_legendary",
    Items = "fish_items"
};
local Cast = script:FindFirstChild("Cast");
local UnCast = script:FindFirstChild("UnCast");
local Struggle = script:FindFirstChild("Struggle");

local function playRodSound(p2: userdata, p3: string) -- Line: 93
    local v4;

    if p2 == nil then
        v4 = nil;
    else
        v4 = p2:FindFirstChild("HumanoidRootPart") or nil;
    end;

    local v5 = script:FindFirstChild(p3);

    if v4 == nil or (v5 == nil or not v5:IsA("Sound")) then
        return nil;
    end;

    local u6 = v5:Clone();
    u6.Parent = v4;
    u6:Play();

    if not u6.Looped then
        u6.Ended:Once(function() -- Line: 101
            -- upvalues: u6 (copy)
            u6:Destroy();
        end);
    end;

    return u6;
end;

local Random_new_ret = Random.new();

local function generate_id() -- Line: 109
    -- upvalues: Random_new_ret (copy)
    return Random_new_ret:NextNumber();
end;

local u7 = 0;
local u8 = {
    Id = {}
};

local function getAnimator(p9: userdata) -- Line: 128
    if p9 then
        p9 = p9:FindFirstChildOfClass("Humanoid");
    end;

    if p9 then
        p9 = p9:FindFirstChildOfClass("Animator");
    end;

    return p9;
end;

local function stopStruggle(p10: table) -- Line: 136
    if p10.StruggleTrack ~= nil then
        p10.StruggleTrack:Stop();
        p10.StruggleTrack = nil;
    end;

    if p10.StruggleSound ~= nil then
        p10.StruggleSound:Stop();
        p10.StruggleSound:Destroy();
        p10.StruggleSound = nil;
    end;
end;

local u11 = { "skill_stand_still", "pause_gameplay", "NR" };
local u12 = { "pause_gameplay" };

local function setFreeze(p13: table, p14: userdata, p15: table?) -- Line: 158
    -- upvalues: Utility (copy)
    local valuesfolder = Utility.getvaluesfolder(p14);

    if valuesfolder == nil then
        return;
    end;

    local Freeze = p13.Freeze;
    p13.Freeze = nil;

    if p15 ~= nil then
        local v16 = {};

        for _, v in p15 do
            table.insert(v16, Utility.AddValue(valuesfolder, v));
        end;

        p13.Freeze = v16;
    end;

    if Freeze ~= nil then
        for _, v in Freeze do
            v:Destroy();
        end;
    end;
end;

local function resolveCastPosition(p17: userdata, p18: vector?, p19: number) -- Line: 180
    if p17 then
        p17 = p17:FindFirstChild("HumanoidRootPart");
    end;

    if p17 == nil then
        return nil;
    end;

    local Position = p17.Position;

    if p18 == nil then
        return Position + p17.CFrame.LookVector * p19;
    end;

    local v20 = p18 - Position;
    local Vector3_new_ret = Vector3.new(v20.X, 0, v20.Z);

    if p19 < Vector3_new_ret.Magnitude then
        local v21 = Vector3_new_ret.Unit * p19;
        v20 = Vector3.new(v21.X, v20.Y, v21.Z);
    end;

    return Position + v20;
end;

local function findWater(p22: vector, p23: userdata) -- Line: 207
    -- upvalues: CollectionService (copy)
    local v24 = {};

    for _, v in CollectionService:GetTagged("SwimParts") do
        table.insert(v24, v.Parent or v);
    end;

    if #v24 == 0 then
        return nil, nil;
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.FilterDescendantsInstances = v24;
    RaycastParams_new_ret.BruteForceAllSlow = true;
    local v25;

    if p23 then
        v25 = p23:FindFirstChild("HumanoidRootPart");
    else
        v25 = p23;
    end;

    local v26 = math.max(p22.Y, v25 ~= nil and v25.Position.Y or p22.Y) + 50;
    local Vector3_new_ret = Vector3.new(p22.X, v26, p22.Z);
    local Vector3_new_ret2 = Vector3.new(0, -(v26 - p22.Y + 25), 0);
    local v27 = workspace:Raycast(Vector3_new_ret, Vector3_new_ret2, RaycastParams_new_ret);
    local v28;

    if v27 == nil then
        v28 = nil;
    else
        v28 = v27.Instance or nil;
    end;

    local v29 = nil;

    if v28 ~= nil then
        if v28.Name == "TouchPart" then
            v29 = v28;
        elseif v28.Name == "Texture" then
            if v28.Parent == nil then
                v29 = nil;
            else
                v29 = v28.Parent:FindFirstChild("TouchPart");
            end;
        end;
    end;

    if v29 ~= nil and not CollectionService:HasTag(v29, "SwimParts") then
        v29 = nil;
    end;

    if v29 ~= nil and v27 ~= nil then
        local RaycastParams_new_ret2 = RaycastParams.new();
        RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Exclude;
        RaycastParams_new_ret2.FilterDescendantsInstances = { workspace.Debree, p23 };
        local v30 = workspace:Raycast(Vector3_new_ret, Vector3_new_ret2, RaycastParams_new_ret2);

        if v30 ~= nil and v30.Position.Y > v27.Position.Y then
            v29 = nil;
        end;
    end;

    if v27 == nil then
        return v29, nil;
    end;

    return v29, v27.Position;
end;

local function findRodTip(p31: userdata) -- Line: 256
    if p31 then
        p31 = p31:FindFirstChild("Tool_Accessories");
    end;

    local v32 = p31 ~= nil and p31:FindFirstChild("Tip", true) or nil;

    if v32 == nil or not v32:IsA("Attachment") then
        return nil;
    end;

    return v32;
end;

local function prepCatchPieces(p33: userdata, p34: userdata) -- Line: 266
    local Descendants = p33:GetDescendants();

    if p33:IsA("BasePart") then
        table.insert(Descendants, p33);
    end;

    for _, v in Descendants do
        if v:IsA("BasePart") then
            v.Anchored = false;
            v.CanCollide = false;
            v.CanTouch = false;
            v.CanQuery = false;
            v.Massless = true;

            if v ~= p34 then
                local WeldConstraint = Instance.new("WeldConstraint");
                WeldConstraint.Part0 = p34;
                WeldConstraint.Part1 = v;
                WeldConstraint.Parent = v;
            end;
        end;
    end;
end;

local function resolveBait(p35: userdata, p36: string) -- Line: 291
    -- upvalues: DataPathService (copy), Utility (copy), Items (copy)
    local v37 = DataPathService.Get(p35, "Slot", "Misc/EquippedBaitId");

    if type(v37) ~= "number" or v37 == 0 then
        return nil;
    end;

    local Data = Utility.GetData(p35);
    local v38;

    if Data == nil then
        v38 = nil;
    else
        v38 = Data:FindFirstChild("Inventory") or nil;
    end;

    local v39;

    if v38 == nil then
        v39 = nil;
    else
        v39 = v38:FindFirstChild("Inventory") or nil;
    end;

    if v39 == nil then
        return nil;
    end;

    for _, child in ipairs(v39:GetChildren()) do
        local Id = child:FindFirstChild("Id");

        if Id ~= nil and Id.Value == v37 then
            local v40 = Items[child.Name];
            local v41;

            if v40 == nil then
                v41 = nil;
            else
                v41 = v40.BaitTier or nil;
            end;

            if v41 == nil then
                return nil;
            end;

            return child.Name, v41;
        end;
    end;

    local v42 = DataPathService.Get(p35, "Slot", "Misc/EquippedBait");

    if type(v42) ~= "string" or v42 == "" then
        return nil;
    end;

    local v43 = Items[v42];
    local v44;

    if v43 == nil then
        v44 = nil;
    else
        v44 = v43.BaitTier or nil;
    end;

    if v44 == nil then
        return nil;
    end;

    local v45 = v39:FindFirstChild(v42);
    local v46;

    if v45 == nil then
        v46 = nil;
    else
        v46 = v45:FindFirstChild("Id") or nil;
    end;

    if v46 == nil then
        return nil;
    end;

    DataPathService.Set(p35, "Slot", "Misc/EquippedBaitId", v46.Value);

    return v42, v44;
end;

local function cloneBaitRig(p47: string) -- Line: 327
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v48;

    if Assets == nil then
        v48 = nil;
    else
        v48 = Assets:FindFirstChild("Fishing Models") or nil;
    end;

    local v49;

    if v48 == nil then
        v49 = nil;
    else
        v49 = v48:FindFirstChild("Bait Models") or nil;
    end;

    local v50 = v49 ~= nil and v49:FindFirstChild(p47) or nil;

    if v50 == nil then
        return nil;
    end;

    local v51 = v50:Clone();
    local v52;

    if v51:IsA("BasePart") then
        v52 = v51;
    else
        v52 = v51:FindFirstChild("Root");
    end;

    if v52 == nil or not v52:IsA("BasePart") then
        v51:Destroy();

        return nil;
    end;

    local Tip = v52:FindFirstChild("Tip");

    if Tip == nil or not Tip:IsA("Attachment") then
        Tip = Instance.new("Attachment");
        Tip.Name = "Tip";
        Tip.Parent = v52;
    end;

    return v51, v52, Tip;
end;

local function destroyIdleBait(p53: table) -- Line: 353
    if p53.IdleBaitModel ~= nil then
        p53.IdleBaitModel:Destroy();
        p53.IdleBaitModel = nil;
    end;
end;

local function showIdleBait(p54: userdata, p55: userdata, p56: table, p57: string) -- Line: 360
    -- upvalues: resolveBait (copy), cloneBaitRig (copy), prepCatchPieces (copy)
    if p56.Casting or (p56.Casted or (p56.Uncasting or p56.CatchModel ~= nil)) then
        if p56.IdleBaitModel ~= nil then
            p56.IdleBaitModel:Destroy();
            p56.IdleBaitModel = nil;
        end;

        return;
    end;

    local v58 = resolveBait(p54, p57);

    if v58 == nil then
        if p56.IdleBaitModel ~= nil then
            p56.IdleBaitModel:Destroy();
            p56.IdleBaitModel = nil;
        end;

        return;
    end;

    if p56.IdleBaitModel ~= nil and (p56.IdleBaitModel.Parent ~= nil and p56.IdleBaitModel.Name == v58) then
        return;
    end;

    if p56.IdleBaitModel ~= nil then
        p56.IdleBaitModel:Destroy();
        p56.IdleBaitModel = nil;
    end;

    if p55 then
        p55 = p55:FindFirstChild("Tool_Accessories");
    end;

    local v59;

    if p55 == nil then
        v59 = nil;
    else
        v59 = p55:FindFirstChild("Tip", true) or nil;
    end;

    if v59 == nil or not v59:IsA("Attachment") then
        v59 = nil;
    end;

    if v59 == nil then
        return;
    end;

    local v60, v61, v62 = cloneBaitRig(v58);

    if v60 == nil or (v61 == nil or v62 == nil) then
        return;
    end;

    v60:PivotTo(CFrame.new(v59.WorldPosition - Vector3.new(0, 0.3, 0)) * v62.CFrame:Inverse() * v61.CFrame:Inverse() * v60:GetPivot());
    prepCatchPieces(v60, v61);
    v61.Massless = false;
    v61.CustomPhysicalProperties = PhysicalProperties.new(0.1, 0.3, 0.5);
    v61.CollisionGroup = "HumanoidsCollide";
    local RopeConstraint = Instance.new("RopeConstraint");
    RopeConstraint.Name = "FishingLine";
    RopeConstraint.Attachment0 = v59;
    RopeConstraint.Attachment1 = v62;
    RopeConstraint.Length = 0.3;
    RopeConstraint.Visible = true;
    RopeConstraint.Thickness = 0.05;
    RopeConstraint.Color = BrickColor.new("Institutional white");
    RopeConstraint.Parent = v61;
    v60.Parent = workspace.Debree;
    v61:SetNetworkOwner(p54);
    p56.IdleBaitModel = v60;
end;

local function launchBobber(p63: userdata, p64: userdata, u65: table) -- Line: 411
    -- upvalues: Utility (copy), cloneBaitRig (copy), prepCatchPieces (copy), u7 (ref), TweenService (copy), EffectsEvent (copy)
    local v66;

    if p64 then
        v66 = p64:FindFirstChild("HumanoidRootPart");
    else
        v66 = p64;
    end;

    local CastPosition = u65.CastPosition;

    if v66 == nil or CastPosition == nil then
        return;
    end;

    if p64 then
        p64 = p64:FindFirstChild("Tool_Accessories");
    end;

    local v67;

    if p64 == nil then
        v67 = nil;
    else
        v67 = p64:FindFirstChild("Tip", true) or nil;
    end;

    if v67 == nil or not v67:IsA("Attachment") then
        v67 = nil;
    end;

    u65.RodTip = v67;

    if v67 == nil then
        return;
    end;

    local WorldPosition = v67.WorldPosition;
    local math_max_ret = math.max((CastPosition - WorldPosition).Magnitude / 45, 0.1);
    local Vector3_new_ret = Vector3.new(0, -workspace.Gravity, 0);
    local v68 = Utility.calcvel(CastPosition, WorldPosition, Vector3_new_ret, math_max_ret);
    local v69 = 0;

    for i = 1, 10 do
        local v70 = math_max_ret * (i / 10);
        local Magnitude = (v68 * v70 + Vector3_new_ret * 0.5 * v70 * v70).Magnitude;
        local v71;

        if v69 < Magnitude then
            v69 = Magnitude;
            v71 = i;
        else
            v71 = i;
        end;
    end;

    if u65.IdleBaitModel ~= nil then
        u65.IdleBaitModel:Destroy();
        u65.IdleBaitModel = nil;
    end;

    local v72 = nil;
    local v73 = nil;
    local v74 = nil;
    local u75, u76, u77;

    if u65.BaitName == nil then
        u75 = v74;
        u76 = v73;
        u77 = v72;
    else
        u75, u77, u76 = cloneBaitRig(u65.BaitName);

        if u75 == nil or (u77 == nil or u76 == nil) then
            u75 = v74;
            u76 = v73;
            u77 = v72;
        else
            u75:PivotTo(CFrame.new(WorldPosition) * u76.CFrame:Inverse() * u77.CFrame:Inverse() * u75:GetPivot());
            prepCatchPieces(u75, u77);
        end;
    end;

    if u77 == nil then
        u77 = Instance.new("Part");
        u77.Name = "FishingBobber";
        u77.Shape = Enum.PartType.Ball;
        u77.Size = Vector3.new(0.35, 0.35, 0.35);
        u77.Material = Enum.Material.SmoothPlastic;
        u77.Transparency = 1;
        u77.CanTouch = false;
        u77.CanQuery = false;
        u77.CFrame = CFrame.new(WorldPosition);
        u76 = Instance.new("Attachment");
        u76.Name = "LineAttachment";
        u76.Parent = u77;
        u75 = u77;
    end;

    local v78;

    if u77 == nil or u76 == nil then
        v78 = false;
    else
        v78 = u75 ~= nil;
    end;

    assert(v78);
    u77.CanCollide = false;
    u77.CollisionGroup = "HumanoidsCollide";
    u77.Massless = false;
    u77.CustomPhysicalProperties = PhysicalProperties.new(0.1, 0.3, 0.5);
    u77.AssemblyLinearVelocity = v68;
    local RopeConstraint = Instance.new("RopeConstraint");
    RopeConstraint.Name = "FishingLine";
    RopeConstraint.Attachment0 = v67;
    RopeConstraint.Attachment1 = u76;
    RopeConstraint.Length = v69 * 0.35;
    RopeConstraint.Visible = true;
    RopeConstraint.Thickness = 0.05;
    RopeConstraint.Color = BrickColor.new("Institutional white");
    RopeConstraint.Parent = u77;
    u7 = u7 + 1;
    u75.Name = `FishingLine_{u7}`;
    u75.Parent = workspace.Debree;
    u77:SetNetworkOwner(p63);
    u65.Bobber = u77;
    u65.BobberModel = u75;
    u65.BobberName = u75.Name;
    TweenService:Create(RopeConstraint, TweenInfo.new(math_max_ret * 0.5, Enum.EasingStyle.Linear), {
        Length = v69 * 1.05
    }):Play();
    task.delay(math_max_ret, function() -- Line: 528
        -- upvalues: u77 (ref), u65 (copy), u75 (ref), CastPosition (copy), u76 (ref), EffectsEvent (ref)
        if u77.Parent == nil or (u65.Bobber ~= u77 or u65.Uncasting) then
            return;
        end;

        u77.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u77.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        local Pivot = u75:GetPivot();
        u75:PivotTo(Pivot.Rotation + (CastPosition + Vector3.new(0, 0.13, 0)) + (Pivot.Position - u77.Position));
        u77.CanCollide = true;
        local AlignPosition = Instance.new("AlignPosition");
        AlignPosition.Name = "FloatAlign";
        AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
        AlignPosition.Attachment0 = u76;
        AlignPosition.Position = CastPosition + Vector3.new(0, 0.13, 0);
        AlignPosition.ForceRelativeTo = Enum.ActuatorRelativeTo.World;
        AlignPosition.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
        AlignPosition.MaxAxesForce = Vector3.new(0, 10000, 0);
        AlignPosition.Parent = u77;
        u77.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        u77.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

        if u65.WaterPart ~= nil then
            EffectsEvent.ToAllInRange(u77, "FishingCatchFX", "Splash", u75.Name, true);
        end;
    end);
end;

local function destroyBobber(p79: table) -- Line: 566
    if p79.BobberModel ~= nil then
        p79.BobberModel:Destroy();
        p79.BobberModel = nil;
    end;

    p79.BobberName = nil;

    if p79.Bobber ~= nil then
        if p79.Bobber.Parent ~= nil then
            p79.Bobber:Destroy();
        end;

        p79.Bobber = nil;
    end;

    if p79.CatchModel ~= nil then
        p79.CatchModel:Destroy();
        p79.CatchModel = nil;
    end;

    p79.CatchRoot = nil;
    p79.HangPoint = nil;
    p79.CatchClickAt = nil;

    if p79.ReelPin ~= nil then
        p79.ReelPin:Destroy();
        p79.ReelPin = nil;
    end;
end;

local function dropCatch(p80: table) -- Line: 600
    -- upvalues: EffectsEvent (copy), Debris (copy)
    local CatchModel = p80.CatchModel;
    local CatchRoot = p80.CatchRoot;
    p80.CatchModel = nil;
    p80.CatchRoot = nil;
    p80.HangPoint = nil;
    p80.CatchClickAt = nil;

    if CatchModel == nil or CatchModel.Parent == nil then
        return;
    end;

    local FishingLine = CatchModel:FindFirstChild("FishingLine", true);

    if FishingLine ~= nil then
        FishingLine:Destroy();
    end;

    local CatchPull = CatchModel:FindFirstChild("CatchPull", true);

    if CatchPull ~= nil then
        CatchPull:Destroy();
    end;

    CatchModel.Parent = workspace.Debree;
    local Descendants = CatchModel:GetDescendants();

    if CatchModel:IsA("BasePart") then
        table.insert(Descendants, CatchModel);
    end;

    for _, v in Descendants do
        if v:IsA("BasePart") then
            v.CanCollide = true;
            v.CollisionGroup = "HumanoidsCollide";
        end;
    end;

    if CatchRoot ~= nil and CatchRoot.Parent ~= nil then
        EffectsEvent.ToAllInRange(CatchRoot, "FishingCatchFX", "Drop", CatchModel.Name, 20);
    end;

    Debris:AddItem(CatchModel, 20);
end;

local function isSwimming(p81: userdata?) -- Line: 640
    local v82;

    if p81 == nil then
        v82 = false;
    else
        v82 = (p81:GetAttribute("SwimState") or 0) > 0;
    end;

    return v82;
end;

local function isGrounded(p83: userdata?) -- Line: 647
    local v84 = p83 ~= nil and p83:FindFirstChildOfClass("Humanoid") or nil;
    local v85;

    if v84 == nil then
        v85 = false;
    else
        v85 = v84.FloorMaterial ~= Enum.Material.Air;
    end;

    return v85;
end;

local function pinCharacter(p86: userdata, p87: table) -- Line: 655
    if p87.ReelPin ~= nil then
        p87.ReelPin:Destroy();
        p87.ReelPin = nil;
    end;

    if p86 then
        p86 = p86:FindFirstChild("HumanoidRootPart");
    end;

    if p86 == nil then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Name = "FishingReelPin";
    Part.Size = Vector3.new(0, 0, 0);
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CFrame = p86.CFrame;
    local Weld = Instance.new("Weld");
    Weld.Part0 = Part;
    Weld.Part1 = p86;
    Weld.Parent = Part;
    Part.Parent = workspace.Debree;
    p87.ReelPin = Part;
end;

local function attachCatchModel(p88: userdata, u89: table, u90: string) -- Line: 694
    -- upvalues: ReplicatedStorage (copy), ItemModels (copy), prepCatchPieces (copy), u7 (ref), Utility (copy), EffectsEvent (copy), Item (copy)
    local FishingLine = p88:FindFirstChild("FishingLine");

    if FishingLine == nil or not FishingLine:IsA("RopeConstraint") then
        return false;
    end;

    local Attachment1 = FishingLine.Attachment1;

    if Attachment1 == nil then
        return false;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v91;

    if Assets == nil then
        v91 = nil;
    else
        v91 = Assets:FindFirstChild("Fishing Models") or nil;
    end;

    local v92;

    if v91 == nil then
        v92 = nil;
    else
        v92 = v91:FindFirstChild("Fish Models") or nil;
    end;

    local v93;

    if v92 == nil then
        v93 = nil;
    else
        v93 = v92:FindFirstChild(u90) or nil;
    end;

    local u94, u95, v96;

    if v93 == nil then
        local v97 = ItemModels.Get(u90, "UnEquipped");

        if v97 == nil or not v97:IsA("Model") then
            return false;
        end;

        u94 = v97:Clone();
        u94:ScaleTo(0.5);
        local v98 = u94:FindFirstChildWhichIsA("BasePart", true);

        if v98 == nil then
            u94:Destroy();

            return false;
        end;

        u95 = v98;
        local BoundingBox, v99 = u94:GetBoundingBox();
        u94.PrimaryPart = nil;
        u94.WorldPivot = BoundingBox;
        u94:PivotTo(CFrame.new(Attachment1.WorldPosition - Vector3.new(0, v99.Y * 0.5 + 0.1, 0)) * BoundingBox.Rotation);
        v96 = Instance.new("Attachment");
        v96.Name = "Tip";
        v96.Parent = u95;
        v96.WorldPosition = Attachment1.WorldPosition;
    else
        u94 = v93:Clone();

        if u94:IsA("BasePart") then
            u95 = u94;
        else
            u95 = u94:FindFirstChild("Root");
        end;

        if u95 == nil or not u95:IsA("BasePart") then
            u94:Destroy();

            return false;
        end;

        v96 = u95:FindFirstChild("Tip");

        if v96 == nil or not v96:IsA("Attachment") then
            v96 = Instance.new("Attachment");
            v96.Name = "Tip";
            v96.Parent = u95;
        end;

        u94:PivotTo(Attachment1.WorldCFrame * v96.CFrame:Inverse() * u95.CFrame:Inverse() * u94:GetPivot());
    end;

    prepCatchPieces(u94, u95);
    u95.Massless = false;
    u95.CustomPhysicalProperties = PhysicalProperties.new(0.1, 0.3, 0.5);
    u7 = u7 + 1;
    u94.Name = `FishingCatch_{u7}`;
    u94:SetAttribute("CatchItem", u90);
    FishingLine.Attachment1 = v96;
    FishingLine.Parent = u95;
    local v100 = Utility.CreatePrompt({
        ActionText = "Collect",
        HoldDuration = 2,
        ObjectText = u90,
        Parent = u95
    });
    local u101 = false;
    v100.Triggered:Connect(function(p102: userdata) -- Line: 774
        -- upvalues: u101 (ref), u94 (ref), u95 (ref), EffectsEvent (ref), Item (ref), u90 (copy), u89 (copy)
        if u101 or u94.Parent == nil then
            return;
        end;

        u101 = true;
        local Position = u95.Position;
        EffectsEvent.ToAllInRange(Position, "QuestPickup", Position);
        Item(p102, u90, 1, nil, nil, nil, "Fishing");

        if u89.CatchModel == u94 then
            u89.CatchModel = nil;
            u89.CatchRoot = nil;
        end;

        u94:Destroy();
    end);
    u94.Parent = workspace.Debree;
    u89.CatchModel = u94;
    u89.CatchRoot = u95;
    local v103 = u89.BobberModel or p88;
    u89.BobberModel = nil;
    u89.Bobber = nil;
    v103:Destroy();

    return true;
end;

local function hangPointOf(p104: userdata) -- Line: 805
    local Parent = p104.Parent;

    if Parent == nil then
        return nil;
    end;

    local FishingHangPoint = Parent:FindFirstChild("FishingHangPoint");

    if FishingHangPoint == nil or not FishingHangPoint:IsA("Attachment") then
        FishingHangPoint = Instance.new("Attachment");
        FishingHangPoint.Name = "FishingHangPoint";
        FishingHangPoint.Parent = Parent;
        FishingHangPoint.WorldPosition = p104.WorldPosition - Vector3.new(0, 0.3, 0);
    end;

    return FishingHangPoint;
end;

local function catchDistance(p105: table) -- Line: 819
    local CatchRoot = p105.CatchRoot;
    local HangPoint = p105.HangPoint;
    local v106;

    if CatchRoot == nil or CatchRoot.Parent == nil then
        v106 = nil;
    else
        v106 = CatchRoot:FindFirstChild("Tip") or nil;
    end;

    if v106 == nil or (HangPoint == nil or HangPoint.Parent == nil) then
        return nil;
    end;

    return (v106.WorldPosition - HangPoint.WorldPosition).Magnitude;
end;

local function pullCatch(u107: table) -- Line: 826
    -- upvalues: hangPointOf (copy)
    local CatchRoot = u107.CatchRoot;
    local RodTip = u107.RodTip;
    local v108;

    if CatchRoot == nil then
        v108 = nil;
    else
        v108 = CatchRoot:FindFirstChild("Tip") or nil;
    end;

    local v109;

    if RodTip == nil then
        v109 = nil;
    else
        v109 = hangPointOf(RodTip) or nil;
    end;

    if CatchRoot == nil or (v108 == nil or v109 == nil) then
        return;
    end;

    u107.HangPoint = v109;
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Name = "CatchPull";
    AlignPosition.Mode = Enum.PositionAlignmentMode.TwoAttachment;
    AlignPosition.Attachment0 = v108;
    AlignPosition.Attachment1 = v109;
    AlignPosition.MaxVelocity = 150;
    AlignPosition.MaxForce = 10000;
    AlignPosition.Responsiveness = 35;
    AlignPosition.Parent = CatchRoot;
    local FishingLine = CatchRoot:FindFirstChild("FishingLine");

    if FishingLine ~= nil and FishingLine:IsA("RopeConstraint") then
        local Part = Instance.new("Part");
        Part.Name = "CatchLineAnchor";
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.Transparency = 1;
        Part.Size = Vector3.new(0.1, 0.1, 0.1);
        Part.CFrame = CFrame.new(RodTip.WorldPosition);
        local Attachment = Instance.new("Attachment");
        Attachment.Parent = Part;
        Part.Parent = workspace.Debree;
        FishingLine.Attachment0 = Attachment;
        task.spawn(function() -- Line: 860
            -- upvalues: u107 (copy), CatchRoot (copy), FishingLine (copy), Part (copy), RodTip (copy)
            while u107.CatchRoot == CatchRoot and FishingLine.Parent == CatchRoot do
                Part.CFrame = CFrame.new(RodTip.WorldPosition);
                local v110 = u107;
                local CatchRoot2 = v110.CatchRoot;
                local HangPoint = v110.HangPoint;
                local v111;

                if CatchRoot2 == nil or CatchRoot2.Parent == nil then
                    v111 = nil;
                else
                    v111 = CatchRoot2:FindFirstChild("Tip") or nil;
                end;

                local v112;

                if v111 == nil or (HangPoint == nil or HangPoint.Parent == nil) then
                    v112 = nil;
                else
                    v112 = (v111.WorldPosition - HangPoint.WorldPosition).Magnitude;
                end;

                if v112 == nil then
                    break;
                end;

                FishingLine.Length = math.max(v112 * 1.2 + 0.5, 0.3);
                task.wait();
            end;

            Part:Destroy();
        end);
    end;
end;

local function finishCatchPull(p113: table, p114: userdata, p115: userdata) -- Line: 877
    local v116 = os.clock() + 4;

    while p113.CatchModel == p114 and os.clock() < v116 do
        local CatchRoot = p113.CatchRoot;
        local HangPoint = p113.HangPoint;
        local v117;

        if CatchRoot == nil or CatchRoot.Parent == nil then
            v117 = nil;
        else
            v117 = CatchRoot:FindFirstChild("Tip") or nil;
        end;

        local v118;

        if v117 == nil or (HangPoint == nil or HangPoint.Parent == nil) then
            v118 = nil;
        else
            v118 = (v117.WorldPosition - HangPoint.WorldPosition).Magnitude;
        end;

        if v118 == nil or v118 <= 0.5 then
            break;
        end;

        task.wait(0.05);
    end;

    local CatchRoot = p113.CatchRoot;
    local HangPoint = p113.HangPoint;

    if p113.CatchModel ~= p114 or (p114.Parent == nil or (CatchRoot == nil or (CatchRoot.Parent == nil or HangPoint == nil))) then
        return;
    end;

    local CatchRoot2 = p113.CatchRoot;
    local HangPoint2 = p113.HangPoint;
    local v119;

    if CatchRoot2 == nil or CatchRoot2.Parent == nil then
        v119 = nil;
    else
        v119 = CatchRoot2:FindFirstChild("Tip") or nil;
    end;

    local v120;

    if v119 == nil or (HangPoint2 == nil or HangPoint2.Parent == nil) then
        v120 = nil;
    else
        v120 = (v119.WorldPosition - HangPoint2.WorldPosition).Magnitude;
    end;

    local Tip = CatchRoot:FindFirstChild("Tip");

    if v120 ~= nil and (v120 > 0.5 and Tip ~= nil) then
        p114:PivotTo(CFrame.new(HangPoint.WorldPosition) * Tip.CFrame:Inverse() * CatchRoot.CFrame:Inverse() * p114:GetPivot());
        CatchRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        CatchRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;

    local FishingLine = CatchRoot:FindFirstChild("FishingLine");

    if FishingLine ~= nil then
        FishingLine:Destroy();
    end;

    local RopeConstraint = Instance.new("RopeConstraint");
    RopeConstraint.Name = "FishingLine";
    RopeConstraint.Attachment0 = p115;
    RopeConstraint.Attachment1 = HangPoint;
    RopeConstraint.Length = 0.3;
    RopeConstraint.Visible = true;
    RopeConstraint.Thickness = 0.05;
    RopeConstraint.Color = BrickColor.new("Institutional white");
    RopeConstraint.Parent = CatchRoot;
    p113.CatchClickAt = os.clock() + 0.6;
end;

local function cast(u121: userdata, u122: userdata, p123: table, p124: string, p125: vector?) -- Line: 909
    -- upvalues: dropCatch (copy), destroyBobber (copy), resolveBait (copy), FishingHandler (copy), resolveCastPosition (copy), findWater (copy), setFreeze (copy), u11 (copy), pinCharacter (copy), u8 (copy), Cast (copy), playRodSound (copy), launchBobber (copy), u12 (copy)
    p123.Casting = true;
    dropCatch(p123);
    destroyBobber(p123);
    local v126, v127 = resolveBait(u121, p124);
    p123.BaitName = v126;
    p123.BaitTier = v127;
    p123.CastPosition = resolveCastPosition(u122, p125, FishingHandler.GetCombinedStats(p124, p123.BaitName).CastRadius);

    if p123.CastPosition ~= nil then
        local v128, v129 = findWater(p123.CastPosition, u122);
        p123.WaterPart = v128;

        if v128 ~= nil and v129 ~= nil then
            p123.CastPosition = v129;
        end;
    end;

    setFreeze(p123, u122, u11);
    pinCharacter(u122, p123);
    local u130 = u8.Id[u121.UserId];
    local v131;

    if u122 then
        v131 = u122:FindFirstChildOfClass("Humanoid");
    else
        v131 = u122;
    end;

    if v131 then
        v131 = v131:FindFirstChildOfClass("Animator");
    end;

    if v131 ~= nil and Cast ~= nil then
        local v132 = v131:LoadAnimation(Cast);
        v132:Play();
        p123.CastTrack = v132;
    end;

    local v133;

    if u122 then
        v133 = u122:FindFirstChild("Tool_Accessories");
    else
        v133 = u122;
    end;

    local v134;

    if v133 == nil then
        v134 = nil;
    else
        v134 = v133:FindFirstChild("Tip", true) or nil;
    end;

    if v134 == nil or not v134:IsA("Attachment") then
        v134 = nil;
    end;

    local HumanoidRootPart = u122:FindFirstChild("HumanoidRootPart");
    local v135 = v134 ~= nil and v134.WorldPosition or (HumanoidRootPart ~= nil and HumanoidRootPart.Position or nil);
    local CastPosition = p123.CastPosition;
    local u136 = (v135 == nil or (CastPosition == nil or (CastPosition - v135).Magnitude >= 20)) and "PS2fishingCASTlong" or "PS2fishingCASTfast";
    task.delay(0, function() -- Line: 952
        -- upvalues: u8 (ref), u121 (copy), u130 (copy), playRodSound (ref), u122 (copy), u136 (copy)
        if u8.Id[u121.UserId] ~= u130 then
            return;
        end;

        playRodSound(u122, u136);
    end);
    task.wait(0.3);

    if u8.Id[u121.UserId] ~= u130 then
        return;
    end;

    p123.Casted = true;
    launchBobber(u121, u122, p123);
    task.wait(0.7);

    if u8.Id[u121.UserId] ~= u130 then
        return;
    end;

    if p123.ReelPin ~= nil then
        p123.ReelPin:Destroy();
        p123.ReelPin = nil;
    end;

    setFreeze(p123, u122, u12);
end;

local function cancelCast(p137: userdata, p138: userdata, p139: table) -- Line: 977
    -- upvalues: Utility (copy)
    if p139.CastTrack then
        p139.CastTrack:Stop();
        p139.CastTrack = nil;
    end;

    if p139.ReelPin ~= nil then
        p139.ReelPin:Destroy();
        p139.ReelPin = nil;
    end;

    if Utility.getvaluesfolder(p138) ~= nil then
        local Freeze = p139.Freeze;
        p139.Freeze = nil;

        if Freeze ~= nil then
            for _, v in Freeze do
                v:Destroy();
            end;
        end;
    end;

    p139.Casting = nil;
    p139.CastPosition = nil;
    p139.WaterPart = nil;
end;

local function uncast(u140: userdata, p141: userdata, u142: table, p143: string) -- Line: 996
    -- upvalues: setFreeze (copy), u11 (copy), UnCast (copy), playRodSound (copy), EffectsEvent (copy), attachCatchModel (copy), Items (copy), Item (copy), pinCharacter (copy), pullCatch (copy), TweenService (copy), u8 (copy), finishCatchPull (copy), destroyBobber (copy), Utility (copy), showIdleBait (copy)
    if u142.Uncasting then
        while u142.Uncasting do
            task.wait();
        end;

        return;
    end;

    if not u142.Casted then
        return;
    end;

    u142.Uncasting = true;
    setFreeze(u142, p141, u11);

    if u142.StruggleTrack ~= nil then
        u142.StruggleTrack:Stop();
        u142.StruggleTrack = nil;
    end;

    if u142.StruggleSound ~= nil then
        u142.StruggleSound:Stop();
        u142.StruggleSound:Destroy();
        u142.StruggleSound = nil;
    end;

    if u142.CastTrack then
        u142.CastTrack:Stop();
        u142.CastTrack = nil;
    end;

    local v144;

    if p141 then
        v144 = p141:FindFirstChildOfClass("Humanoid");
    else
        v144 = p141;
    end;

    if v144 then
        v144 = v144:FindFirstChildOfClass("Animator");
    end;

    if v144 ~= nil and UnCast ~= nil then
        v144:LoadAnimation(UnCast):Play();
    end;

    playRodSound(p141, "PS2fishingRECALL");

    if u142.WaterPart ~= nil and (u142.BobberName ~= nil and u142.Bobber ~= nil) then
        EffectsEvent.ToAllInRange(u142.Bobber, "FishingCatchFX", "Splash", u142.BobberName, false);
    end;

    if u142.BiteToken ~= nil then
        u142.BiteToken = nil;
        u142.BiteVerdict = nil;

        if u142.Portal ~= nil then
            u142.Portal:ToClient("BiteCancel");
        end;
    end;

    local Bobber = u142.Bobber;
    local PendingCatch = u142.PendingCatch;
    u142.PendingCatch = nil;

    if PendingCatch ~= nil and Bobber ~= nil then
        if u142.ReelPin ~= nil then
            u142.ReelPin:Destroy();
            u142.ReelPin = nil;
        end;

        if attachCatchModel(Bobber, u142, PendingCatch) then
            local CatchRoot = u142.CatchRoot;

            if CatchRoot ~= nil then
                CatchRoot:SetNetworkOwner(nil);
                CatchRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                CatchRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                EffectsEvent.ToAllInRange(CatchRoot, "FishingCatchFX", "Ring", u142.CatchModel.Name, Items[PendingCatch] == nil and 1 or (Items[PendingCatch].Rarity or 1));
            end;
        else
            Item(u140, PendingCatch, 1, nil, nil, nil, "Fishing");
        end;
    end;

    if u142.CatchModel == nil then
        pinCharacter(p141, u142);
    end;

    local u145 = u142.Bobber or u142.CatchRoot;

    if u145 ~= nil then
        task.delay(0.3, function() -- Line: 1080
            -- upvalues: u145 (copy), u142 (copy), u140 (copy), pullCatch (ref), TweenService (ref)
            if u145.Parent == nil then
                return;
            end;

            local v146;

            if u142.CatchModel == nil then
                v146 = u140;
            else
                v146 = nil;
            end;

            pcall(u145.SetNetworkOwner, u145, v146);
            local FloatAlign = u145:FindFirstChild("FloatAlign");

            if FloatAlign ~= nil then
                FloatAlign:Destroy();
            end;

            local FishingLine = u145:FindFirstChild("FishingLine");

            if FishingLine ~= nil then
                if u142.CatchModel ~= nil then
                    pullCatch(u142);

                    return;
                end;

                TweenService:Create(FishingLine, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
                    Length = 0
                }):Play();
            end;
        end);
    end;

    local v147 = u8.Id[u140.UserId];
    task.wait(1.4);

    if u8.Id[u140.UserId] ~= v147 then
        return;
    end;

    if u142.CatchModel == nil or u142.CatchModel.Parent == nil then
        destroyBobber(u142);
    else
        if u142.ReelPin ~= nil then
            u142.ReelPin:Destroy();
            u142.ReelPin = nil;
        end;

        if u142.RodTip ~= nil then
            task.spawn(finishCatchPull, u142, u142.CatchModel, u142.RodTip);
        end;
    end;

    if Utility.getvaluesfolder(p141) ~= nil then
        local Freeze = u142.Freeze;
        u142.Freeze = nil;

        if Freeze ~= nil then
            for _, v in Freeze do
                v:Destroy();
            end;
        end;
    end;

    u142.Casted = nil;
    u142.Casting = nil;
    u142.Uncasting = nil;
    u142.CastPosition = nil;
    u142.WaterPart = nil;
    u142.RodTip = nil;

    if u142.CatchModel == nil then
        showIdleBait(u140, p141, u142, p143);
    end;
end;

local function startBiteLoop(u148: userdata, u149: userdata, u150: table, u151: string) -- Line: 1142
    -- upvalues: u8 (copy), FishingHandler (copy), PlayerStatResolver (copy), Random_new_ret (copy), setFreeze (copy), u11 (copy), pinCharacter (copy), Struggle (copy), playRodSound (copy), Item2 (copy), Refinement (copy), AnalyticsService (copy), u1 (copy), TitleService (copy), DrownedLine (copy), uncast (copy)
    local u152 = u8.Id[u148.UserId];
    task.spawn(function() -- Line: 1144
        -- upvalues: FishingHandler (ref), u151 (copy), u150 (copy), PlayerStatResolver (ref), u148 (copy), Random_new_ret (ref), u8 (ref), u152 (copy), setFreeze (ref), u149 (copy), u11 (ref), pinCharacter (ref), Struggle (ref), playRodSound (ref), Item2 (ref), Refinement (ref), AnalyticsService (ref), u1 (ref), TitleService (ref), DrownedLine (ref), uncast (ref)
        local CombinedStats = FishingHandler.GetCombinedStats(u151, u150.BaitName);
        local v153 = PlayerStatResolver.GetStat(u148, "Bite Speed Factor") or 0;
        local math_max_ret = math.max(CombinedStats.BiteSpeedMultiplier * (1 + v153), 0.05);
        task.wait(Random_new_ret:NextNumber(4, 9) / math_max_ret);

        if u8.Id[u148.UserId] ~= u152 or (not u150.Casted or u150.Uncasting) then
            return;
        end;

        if u150.Portal == nil then
            return;
        end;

        local v154 = Random_new_ret:NextNumber();
        u150.BiteToken = v154;
        u150.BiteVerdict = nil;
        u150.Portal:ToClient("Bite", v154);
        setFreeze(u150, u149, u11);
        pinCharacter(u149, u150);
        local v155 = u149;

        if v155 then
            v155 = v155:FindFirstChildOfClass("Humanoid");
        end;

        if v155 then
            v155 = v155:FindFirstChildOfClass("Animator");
        end;

        if v155 ~= nil and Struggle ~= nil then
            local v156 = v155:LoadAnimation(Struggle);
            v156:Play();
            u150.StruggleTrack = v156;
        end;

        u150.StruggleSound = playRodSound(u149, "PS2fishingSTRUGGLEloop");

        while u8.Id[u148.UserId] == u152 and (u150.Casted and (not u150.Uncasting and u150.Portal ~= nil)) do
            local BiteVerdict = u150.BiteVerdict;

            if BiteVerdict ~= nil then
                u150.BiteToken = nil;
                u150.BiteVerdict = nil;
                local v157 = u150;

                if v157.StruggleTrack ~= nil then
                    v157.StruggleTrack:Stop();
                    v157.StruggleTrack = nil;
                end;

                if v157.StruggleSound ~= nil then
                    v157.StruggleSound:Stop();
                    v157.StruggleSound:Destroy();
                    v157.StruggleSound = nil;
                end;

                if u8.Id[u148.UserId] ~= u152 or (not u150.Casted or u150.Uncasting) then
                    return;
                end;

                if u150.BaitName ~= nil then
                    Item2(u148, u150.BaitName, 1);
                end;

                local v158;

                if BiteVerdict == true then
                    v158 = Random_new_ret:NextNumber() < CombinedStats.CatchChance;
                else
                    v158 = false;
                end;

                if v158 then
                    local v159 = PlayerStatResolver.GetStat(u148, "Fishing Luck Factor") or 0;
                    local HeldMultiplier = Refinement.GetHeldMultiplier(u148, u151);
                    u150.PendingCatch = FishingHandler.Roll(u151, u150.BaitTier or 0, v159, u150.BaitName, HeldMultiplier);
                elseif u150.Portal ~= nil then
                    u150.Portal:ToClient("BiteMissed");
                end;

                local v160 = u150.PendingCatch == nil and (v158 and "Empty" or (BiteVerdict == true and "Slipped" or "Lost")) or "Caught";
                AnalyticsService.Track(u148, "FishingBite", {
                    Bait = u150.BaitName or "None",
                    Outcome = v160
                });
                local v161;

                if u150.PendingCatch == nil then
                    v161 = nil;
                else
                    v161 = FishingHandler.CategoryOf(u150.PendingCatch);
                end;

                local v162;

                if v161 == nil then
                    v162 = nil;
                else
                    v162 = u1[v161];
                end;

                if v162 ~= nil then
                    TitleService.AddProgress(u148, v162);
                end;

                DrownedLine.ReportBite(u148, v160, u150.BaitName);
                u8.Id[u148.UserId] = Random_new_ret:NextNumber();
                uncast(u148, u149, u150, u151);

                return;
            end;

            task.wait(0.1);
        end;
    end);
end;

local function forceCleanup(p163: userdata, p164: userdata, p165: table) -- Line: 1230
    -- upvalues: u8 (copy), Random_new_ret (copy), dropCatch (copy), destroyBobber (copy), Utility (copy)
    u8.Id[p163.UserId] = Random_new_ret:NextNumber();

    if p165.BiteToken ~= nil and p165.Portal ~= nil then
        p165.Portal:ToClient("BiteCancel");
    end;

    p165.BiteToken = nil;
    p165.BiteVerdict = nil;
    p165.PendingCatch = nil;

    if p165.StruggleTrack ~= nil then
        p165.StruggleTrack:Stop();
        p165.StruggleTrack = nil;
    end;

    if p165.StruggleSound ~= nil then
        p165.StruggleSound:Stop();
        p165.StruggleSound:Destroy();
        p165.StruggleSound = nil;
    end;

    if p165.CastTrack then
        p165.CastTrack:Stop();
        p165.CastTrack = nil;
    end;

    dropCatch(p165);

    if p165.IdleBaitModel ~= nil then
        p165.IdleBaitModel:Destroy();
        p165.IdleBaitModel = nil;
    end;

    destroyBobber(p165);

    if p165.SwimWatch ~= nil then
        p165.SwimWatch:Disconnect();
        p165.SwimWatch = nil;
    end;

    if Utility.getvaluesfolder(p164) ~= nil then
        local Freeze = p165.Freeze;
        p165.Freeze = nil;

        if Freeze ~= nil then
            for _, v in Freeze do
                v:Destroy();
            end;
        end;
    end;

    p165.Casted = nil;
    p165.Casting = nil;
    p165.Uncasting = nil;
    p165.CastPosition = nil;
    p165.WaterPart = nil;
    p165.RodTip = nil;
end;

function u8.check(p166: userdata, p167: userdata, p168: table, p169: string) -- Line: 1268
    -- upvalues: Checker (copy)
    if p168.Uncasting then
        return false;
    end;

    return Checker.check(p166) and true or false;
end;

function u8.Equipped(u170: userdata, u171: userdata, u172: table, u173: string) -- Line: 1282
    -- upvalues: ServerClientPortal (copy), ManuelCancel (copy), u8 (copy), Random_new_ret (copy), Utility (copy), uncast (copy), forceCleanup (copy), SignalEvent (copy), showIdleBait (copy)
    if u172.Portal ~= nil then
        u172.Portal:Destroy();
        u172.Portal = nil;
    end;

    local v174 = ServerClientPortal.Create(u170, "FishingRod", -1);
    u172.Portal = v174;
    v174:Connect(function(p175, p176) -- Line: 1291
        -- upvalues: u172 (copy)
        if p175 == nil or u172.BiteToken ~= p175 then
            return;
        end;

        u172.BiteVerdict = p176 == true;
    end);

    if u172.CancelDestroy then
        u172.CancelDestroy();
        u172.CancelDestroy = nil;
    end;

    local v177, v178 = ManuelCancel.new(u170, -1);
    u172.CancelDestroy = v178;

    if u172.SwimWatch ~= nil then
        u172.SwimWatch:Disconnect();
        u172.SwimWatch = nil;
    end;

    u172.SwimWatch = u171:GetAttributeChangedSignal("SwimState"):Connect(function() -- Line: 1311
        -- upvalues: u171 (copy), u172 (copy), u8 (ref), u170 (copy), Random_new_ret (ref), Utility (ref), uncast (ref), u173 (copy)
        local v179 = u171;
        local v180;

        if v179 == nil then
            v180 = false;
        else
            v180 = (v179:GetAttribute("SwimState") or 0) > 0;
        end;

        if not v180 then
            return;
        end;

        if not (u172.Casted or u172.Casting) then
            return;
        end;

        if u172.Uncasting then
            return;
        end;

        u8.Id[u170.UserId] = Random_new_ret:NextNumber();

        if not u172.Casting or u172.Casted then
            uncast(u170, u171, u172, u173);

            return;
        end;

        local v181 = u172;

        if v181.CastTrack then
            v181.CastTrack:Stop();
            v181.CastTrack = nil;
        end;

        if v181.ReelPin ~= nil then
            v181.ReelPin:Destroy();
            v181.ReelPin = nil;
        end;

        if Utility.getvaluesfolder(u171) ~= nil then
            local Freeze = v181.Freeze;
            v181.Freeze = nil;

            if Freeze ~= nil then
                for _, v in Freeze do
                    v:Destroy();
                end;
            end;
        end;

        v181.Casting = nil;
        v181.CastPosition = nil;
        v181.WaterPart = nil;
    end);

    if v177 then
        v177:Connect(function() -- Line: 1323
            -- upvalues: u172 (copy), forceCleanup (ref), u170 (copy), u171 (copy), SignalEvent (ref)
            if u172.CancelDestroy then
                u172.CancelDestroy();
                u172.CancelDestroy = nil;
            end;

            forceCleanup(u170, u171, u172);
            local v182 = u171 and u171:FindFirstChildOfClass("Humanoid");

            if v182 ~= nil and v182.Health <= 0 then
                return;
            end;

            SignalEvent.ToClient(u170, "ForceEquip", 0);
        end);
    end;

    local u183 = {};
    u172.BaitWatch = u183;

    local function refresh() -- Line: 1343
        -- upvalues: u172 (copy), u183 (copy), showIdleBait (ref), u170 (copy), u171 (copy), u173 (copy)
        if u172.BaitWatch ~= u183 then
            return;
        end;

        showIdleBait(u170, u171, u172, u173);
    end;

    local Data = Utility.GetData(u170);
    local v184;

    if Data == nil then
        v184 = nil;
    else
        v184 = Data:FindFirstChild("Misc") or nil;
    end;

    local u185 = nil;

    local function hookPref(p186: userdata?) -- Line: 1350
        -- upvalues: u185 (ref), refresh (copy), u183 (copy)
        if u185 ~= nil then
            u185:Disconnect();
            u185 = nil;
        end;

        if p186 ~= nil and p186:IsA("ValueBase") then
            u185 = p186.Changed:Connect(refresh);
            table.insert(u183, u185);
        end;
    end;

    if v184 ~= nil then
        local EquippedBaitId = v184:FindFirstChild("EquippedBaitId");

        if u185 ~= nil then
            u185:Disconnect();
            u185 = nil;
        end;

        if EquippedBaitId ~= nil and EquippedBaitId:IsA("ValueBase") then
            u185 = EquippedBaitId.Changed:Connect(refresh);
            table.insert(u183, u185);
        end;

        table.insert(u183, v184.ChildAdded:Connect(function(p187) -- Line: 1362
            -- upvalues: u185 (ref), refresh (copy), u183 (copy)
            if p187.Name == "EquippedBaitId" then
                if u185 ~= nil then
                    u185:Disconnect();
                    u185 = nil;
                end;

                if p187 ~= nil and p187:IsA("ValueBase") then
                    u185 = p187.Changed:Connect(refresh);
                    table.insert(u183, u185);
                end;

                task.defer(refresh);
            end;
        end));
        table.insert(u183, v184.ChildRemoved:Connect(function(p188) -- Line: 1368
            -- upvalues: u185 (ref), u172 (copy), u183 (copy), showIdleBait (ref), u170 (copy), u171 (copy), u173 (copy)
            if p188.Name == "EquippedBaitId" then
                if u185 ~= nil then
                    u185:Disconnect();
                    u185 = nil;
                end;

                if u172.BaitWatch ~= u183 then
                    return;
                end;

                showIdleBait(u170, u171, u172, u173);
            end;
        end));
    end;

    local v189;

    if Data == nil then
        v189 = nil;
    else
        v189 = Data:FindFirstChild("Inventory") or nil;
    end;

    local v190;

    if v189 == nil then
        v190 = nil;
    else
        v190 = v189:FindFirstChild("Inventory") or nil;
    end;

    if v190 ~= nil then
        local function onEntry() -- Line: 1382
            -- upvalues: refresh (copy)
            task.defer(refresh);
        end;

        table.insert(u183, v190.ChildAdded:Connect(onEntry));
        table.insert(u183, v190.ChildRemoved:Connect(onEntry));
    end;

    task.defer(function() -- Line: 1392
        -- upvalues: u172 (copy), u183 (copy), showIdleBait (ref), u170 (copy), u171 (copy), u173 (copy)
        if u172.BaitWatch ~= u183 then
            return;
        end;

        showIdleBait(u170, u171, u172, u173);
    end);
end;

function u8.UnEquipped(p191: userdata, p192: userdata, p193: table, p194: string) -- Line: 1398
    -- upvalues: u8 (copy), Random_new_ret (copy), uncast (copy), Utility (copy), dropCatch (copy), destroyBobber (copy)
    if not p193.Uncasting then
        u8.Id[p191.UserId] = Random_new_ret:NextNumber();
    end;

    if p193.Casted or p193.Uncasting then
        uncast(p191, p192, p193, p194);
    elseif p193.Casting then
        if p193.CastTrack then
            p193.CastTrack:Stop();
            p193.CastTrack = nil;
        end;

        if p193.ReelPin ~= nil then
            p193.ReelPin:Destroy();
            p193.ReelPin = nil;
        end;

        if Utility.getvaluesfolder(p192) ~= nil then
            local Freeze = p193.Freeze;
            p193.Freeze = nil;

            if Freeze ~= nil then
                for _, v in Freeze do
                    v:Destroy();
                end;
            end;
        end;

        p193.Casting = nil;
        p193.CastPosition = nil;
        p193.WaterPart = nil;
    end;

    dropCatch(p193);

    if p193.IdleBaitModel ~= nil then
        p193.IdleBaitModel:Destroy();
        p193.IdleBaitModel = nil;
    end;

    destroyBobber(p193);

    if p193.BaitWatch ~= nil then
        for _, v in p193.BaitWatch do
            v:Disconnect();
        end;

        p193.BaitWatch = nil;
    end;

    if p193.SwimWatch ~= nil then
        p193.SwimWatch:Disconnect();
        p193.SwimWatch = nil;
    end;

    if p193.CancelDestroy then
        p193.CancelDestroy();
        p193.CancelDestroy = nil;
    end;

    p193.BiteToken = nil;
    p193.BiteVerdict = nil;
    p193.PendingCatch = nil;

    if p193.Portal ~= nil then
        p193.Portal:Destroy();
        p193.Portal = nil;
    end;
end;

function u8.MouseUp(u195: userdata, u196: userdata, u197: table, u198: string, p199: vector?) -- Line: 1442
    -- upvalues: u8 (copy), Random_new_ret (copy), uncast (copy), Utility (copy), dropCatch (copy), destroyBobber (copy), showIdleBait (copy), cast (copy), FishingHandler (copy), PlayerStatResolver (copy), setFreeze (copy), u11 (copy), pinCharacter (copy), Struggle (copy), playRodSound (copy), Item2 (copy), Refinement (copy), AnalyticsService (copy), u1 (copy), TitleService (copy), DrownedLine (copy)
    if u197.Uncasting then
        return;
    end;

    if u197.BiteToken ~= nil then
        return;
    end;

    if not (u197.Casted or u197.Casting) then
        local v200;

        if u196 == nil then
            v200 = false;
        else
            v200 = (u196:GetAttribute("SwimState") or 0) > 0;
        end;

        if v200 then
            return;
        end;
    end;

    if not (u197.Casted or u197.Casting) then
        local v201;

        if u196 == nil then
            v201 = nil;
        else
            v201 = u196:FindFirstChildOfClass("Humanoid") or nil;
        end;

        local v202;

        if v201 == nil then
            v202 = false;
        else
            v202 = v201.FloorMaterial ~= Enum.Material.Air;
        end;

        if not v202 then
            return;
        end;
    end;

    u8.Id[u195.UserId] = Random_new_ret:NextNumber();

    if u197.Casted then
        uncast(u195, u196, u197, u198);

        return;
    end;

    if not u197.Casting then
        if u197.CatchModel == nil then
            cast(u195, u196, u197, u198, p199);

            if u197.Casted and (u197.WaterPart == nil or u197.RodTip == nil) then
                uncast(u195, u196, u197, u198);

                return;
            end;

            if u197.Casted then
                local u203 = u8.Id[u195.UserId];
                task.spawn(function() -- Line: 1144
                    -- upvalues: FishingHandler (ref), u198 (copy), u197 (copy), PlayerStatResolver (ref), u195 (copy), Random_new_ret (ref), u8 (ref), u203 (copy), setFreeze (ref), u196 (copy), u11 (ref), pinCharacter (ref), Struggle (ref), playRodSound (ref), Item2 (ref), Refinement (ref), AnalyticsService (ref), u1 (ref), TitleService (ref), DrownedLine (ref), uncast (ref)
                    local CombinedStats = FishingHandler.GetCombinedStats(u198, u197.BaitName);
                    local v204 = PlayerStatResolver.GetStat(u195, "Bite Speed Factor") or 0;
                    local math_max_ret = math.max(CombinedStats.BiteSpeedMultiplier * (1 + v204), 0.05);
                    task.wait(Random_new_ret:NextNumber(4, 9) / math_max_ret);

                    if u8.Id[u195.UserId] ~= u203 or (not u197.Casted or u197.Uncasting) then
                        return;
                    end;

                    if u197.Portal == nil then
                        return;
                    end;

                    local v205 = Random_new_ret:NextNumber();
                    u197.BiteToken = v205;
                    u197.BiteVerdict = nil;
                    u197.Portal:ToClient("Bite", v205);
                    setFreeze(u197, u196, u11);
                    pinCharacter(u196, u197);
                    local v206 = u196;

                    if v206 then
                        v206 = v206:FindFirstChildOfClass("Humanoid");
                    end;

                    if v206 then
                        v206 = v206:FindFirstChildOfClass("Animator");
                    end;

                    if v206 ~= nil and Struggle ~= nil then
                        local v207 = v206:LoadAnimation(Struggle);
                        v207:Play();
                        u197.StruggleTrack = v207;
                    end;

                    u197.StruggleSound = playRodSound(u196, "PS2fishingSTRUGGLEloop");

                    while u8.Id[u195.UserId] == u203 and (u197.Casted and (not u197.Uncasting and u197.Portal ~= nil)) do
                        local BiteVerdict = u197.BiteVerdict;

                        if BiteVerdict ~= nil then
                            u197.BiteToken = nil;
                            u197.BiteVerdict = nil;
                            local v208 = u197;

                            if v208.StruggleTrack ~= nil then
                                v208.StruggleTrack:Stop();
                                v208.StruggleTrack = nil;
                            end;

                            if v208.StruggleSound ~= nil then
                                v208.StruggleSound:Stop();
                                v208.StruggleSound:Destroy();
                                v208.StruggleSound = nil;
                            end;

                            if u8.Id[u195.UserId] ~= u203 or (not u197.Casted or u197.Uncasting) then
                                return;
                            end;

                            if u197.BaitName ~= nil then
                                Item2(u195, u197.BaitName, 1);
                            end;

                            local v209;

                            if BiteVerdict == true then
                                v209 = Random_new_ret:NextNumber() < CombinedStats.CatchChance;
                            else
                                v209 = false;
                            end;

                            if v209 then
                                local v210 = PlayerStatResolver.GetStat(u195, "Fishing Luck Factor") or 0;
                                local HeldMultiplier = Refinement.GetHeldMultiplier(u195, u198);
                                u197.PendingCatch = FishingHandler.Roll(u198, u197.BaitTier or 0, v210, u197.BaitName, HeldMultiplier);
                            elseif u197.Portal ~= nil then
                                u197.Portal:ToClient("BiteMissed");
                            end;

                            local v211 = u197.PendingCatch == nil and (v209 and "Empty" or (BiteVerdict == true and "Slipped" or "Lost")) or "Caught";
                            AnalyticsService.Track(u195, "FishingBite", {
                                Bait = u197.BaitName or "None",
                                Outcome = v211
                            });
                            local v212;

                            if u197.PendingCatch == nil then
                                v212 = nil;
                            else
                                v212 = FishingHandler.CategoryOf(u197.PendingCatch);
                            end;

                            local v213;

                            if v212 == nil then
                                v213 = nil;
                            else
                                v213 = u1[v212];
                            end;

                            if v213 ~= nil then
                                TitleService.AddProgress(u195, v213);
                            end;

                            DrownedLine.ReportBite(u195, v211, u197.BaitName);
                            u8.Id[u195.UserId] = Random_new_ret:NextNumber();
                            uncast(u195, u196, u197, u198);

                            return;
                        end;

                        task.wait(0.1);
                    end;
                end);
            end;

            return;
        end;

        if os.clock() < (u197.CatchClickAt or (1 / 0)) then
            return;
        end;

        dropCatch(u197);
        destroyBobber(u197);
        showIdleBait(u195, u196, u197, u198);

        return;
    end;

    if u197.CastTrack then
        u197.CastTrack:Stop();
        u197.CastTrack = nil;
    end;

    if u197.ReelPin ~= nil then
        u197.ReelPin:Destroy();
        u197.ReelPin = nil;
    end;

    if Utility.getvaluesfolder(u196) ~= nil then
        local Freeze = u197.Freeze;
        u197.Freeze = nil;

        if Freeze ~= nil then
            for _, v in Freeze do
                v:Destroy();
            end;
        end;
    end;

    u197.Casting = nil;
    u197.CastPosition = nil;
    u197.WaterPart = nil;
end;

return u8;