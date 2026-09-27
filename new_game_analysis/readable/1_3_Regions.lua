-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local ItemRequirements = require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements);
local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local Dialogue = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Dialogue"));
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local RotatingShop = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.RotatingShop);
local TimedVendor = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.TimedVendor);
local Locator = require(ReplicatedStorage.CAM.Global.Subsets.Areas.AreaLocator.Locator);
local DayAndNightHandler = require(ReplicatedStorage.CAM.Global.DayAndNightHandler);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local v1 = game["Run Service"]:IsServer();

local function find() -- Line: 33
    -- upvalues: ReplicatedStorage (copy)
    for _, child in ReplicatedStorage:GetChildren() do
        if child:IsA("Folder") and child:FindFirstChild("Content") then
            return child;
        end;
    end;

    return nil;
end;

local v2 = find();
local os_clock_ret = os.clock();
local v3 = nil;
local v4 = false;

while v2 == nil do
    if workspace:GetAttribute("MinigameKey") ~= nil then
        v3 = v3 or os.clock();

        if os.clock() - v3 > 3 then
            break;
        end;
    end;

    if not v4 and os.clock() - os_clock_ret > 60 then
        warn("Regions: still no place folder with a \'Content\' child under ReplicatedStorage — minigame content not staged in yet?");
        v4 = true;
    end;

    task.wait(0.5);
    v2 = find();
end;

local SoundTracks = game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaLocator"):WaitForChild("SoundTracks");
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
local u5 = {
    Regions = {},
    Spawns = {},
    Shrines = {},
    Situations = {},
    Biomes = {}
};

if v2 ~= nil then
    local DefaultCombatThemes = v2:FindFirstChild("DefaultCombatThemes");

    if DefaultCombatThemes ~= nil then
        DefaultCombatThemes.Parent = SoundTracks;
    end;

    local DefaultTracks = v2:FindFirstChild("DefaultTracks");

    if DefaultTracks ~= nil then
        DefaultTracks.Parent = SoundTracks;
    end;

    local Biomes = v2:FindFirstChild("Biomes");

    if Biomes ~= nil then
        u5.Biomes = require(Biomes);
    end;
end;

u5.NpcIcons = {};
u5.NpcRequirements = {};
u5.NpcSpawns = {};
local u6 = {};

local function CollectContent(p7: userdata) -- Line: 122
    -- upvalues: u6 (copy), CollectContent (copy)
    for _, child in ipairs(p7:GetChildren()) do
        if child:IsA("ModuleScript") then
            table.insert(u6, child);
        else
            CollectContent(child);
        end;
    end;
end;

if v2 ~= nil then
    CollectContent(v2:WaitForChild("Content"));
end;

for _, v in ipairs(u6) do
    if v:IsA("ModuleScript") then
        u5.Regions[v.Name] = require(v);
        u5.Regions[v.Name].Name = v.Name;
        local Npcs = u5.Regions[v.Name].Npcs;
        local v8;

        if Npcs == nil then
            v8 = v;
        else
            v8 = v;

            for _, v5 in ipairs(Npcs) do
                if v5.Name ~= nil and (v5.Icon ~= nil and v5.Icon ~= "") then
                    u5.NpcIcons[v5.Name] = v5.Icon;
                end;

                if v5.Name ~= nil and v5.Requirements ~= nil then
                    u5.NpcRequirements[v5.Name] = v5.Requirements;
                end;

                if v5.Name == nil or (v5.Spawns == nil or (v5.Spawns[1] == nil or v5.Type ~= Menum.npcType.Stationary and v5.Type ~= Menum.npcType.Idle)) then
                    if v5.Name ~= nil and (v5.Type == Menum.npcType.Active and (v5.SendOver ~= nil and (v5.SendOver.Spawning ~= nil and (v5.SendOver.Spawning.Locations ~= nil and v5.SendOver.Spawning.Locations[1] ~= nil)))) then
                        local v9 = v5.SendOver.Spawning.Locations[1];
                        local NpcSpawns = u5.NpcSpawns;
                        local Name = v5.Name;

                        if typeof(v9) == "CFrame" then
                            v9 = v9.Position;
                        end;

                        NpcSpawns[Name] = v9;
                    end;
                else
                    local v10 = v5.Spawns[1];
                    local NpcSpawns = u5.NpcSpawns;
                    local Name = v5.Name;

                    if typeof(v10) == "CFrame" then
                        v10 = v10.Position;
                    end;

                    NpcSpawns[Name] = v10;
                end;
            end;
        end;

        if v1 then
            if v8:FindFirstChild("SoundTracks") then
                for _, child in ipairs(v8.SoundTracks:GetChildren()) do
                    if SoundTracks:FindFirstChild(v8.Name) == nil then
                        child.Parent = SoundTracks;
                        child.Name = v8.Name;
                    end;
                end;
            end;
        else
            local Dialogues = u5.Regions[v8.Name].Dialogues;

            if Dialogues ~= nil then
                for i, v5 in pairs(Dialogues) do
                    Dialogue.Diagloues[i] = v5;
                end;
            end;

            local DialogueFunctions = u5.Regions[v8.Name].DialogueFunctions;

            if DialogueFunctions ~= nil then
                for i, v5 in pairs(DialogueFunctions) do
                    Dialogue.Functions[i] = v5;
                end;
            end;

            local Npcs2 = u5.Regions[v8.Name].Npcs;

            if Npcs2 ~= nil then
                for _, v5 in ipairs(Npcs2) do
                    local Shop2 = v5.Shop;
                    local v11;

                    if Shop2 == nil then
                        v11 = v5;
                    else
                        v11 = v5;

                        for i, v6 in Shop2 do
                            Shop.RegisterItem(i, {
                                Price = v6.Price,
                                Type = v6.Type or Menum.ShopItemType.IngameItem,
                                Grant = v6.Grant,
                                Icon = v6.Icon,
                                NoSave = v6.NoSave,
                                RequiresQuestDone = v11.RequiresQuestDone,
                                Requirements = v11.Requirements
                            });
                        end;
                    end;

                    if v11.RotatingShop ~= nil then
                        v11.RotatingShop.RequiresQuestDone = v11.RotatingShop.RequiresQuestDone or v11.RequiresQuestDone;
                        RotatingShop.BindClient(v11.RotatingShop);
                    end;

                    if v11.TimedVendor ~= nil then
                        v11.TimedVendor.RequiresQuestDone = v11.TimedVendor.RequiresQuestDone or v11.RequiresQuestDone;
                        TimedVendor.BindClient(v11.TimedVendor);
                    end;
                end;
            end;
        end;

        local Quests2 = u5.Regions[v8.Name].Quests;

        if Quests2 ~= nil then
            for i, v5 in pairs(Quests2) do
                Quests.Holder[i] = v5;
            end;
        end;
    end;
end;

function u5.GetNpcIcon(p12: string) -- Line: 240
    -- upvalues: u5 (copy)
    return u5.NpcIcons[p12];
end;

function u5.GetNpcSpawn(p13: string) -- Line: 244
    -- upvalues: u5 (copy)
    return u5.NpcSpawns[p13];
end;

if not v1 then
    return u5;
end;

for i, v in u5.Regions do
    if v.Area ~= nil then
        Locator.Areas[i] = v.Area;
    end;
end;

for i, v in u5.Biomes do
    Locator.Biomes[i] = v;
end;

Instance.new("Folder", workspace.Debree).Name = "Regions";
Instance.new("Folder", workspace.Map).Name = "Regions";
Instance.new("Folder", workspace.Humanoids).Name = "Regions";
local SpawnCrystal = game.ReplicatedStorage.Assets.SpawnCrystal;
local u14 = SpawnCrystal.Root.Size.Y / 2;
local ShrineModel = game.ReplicatedStorage.Assets:FindFirstChild("ShrineModel");

function PrepareRegion(p15: table, p16: string)
    -- upvalues: u5 (copy), ShrineModel (copy), Workspace (copy), RaycastHelper (copy), SpawnCrystal (copy), u14 (copy), gameSettings (copy), Menum (copy), ItemRequirements (copy), RaycastParams_new_ret (copy), Shop (copy), DayAndNightHandler (copy), EffectsEvent (copy)
    local Folder = Instance.new("Folder", workspace.Debree.Regions);
    Folder.Name = p15.Name;
    local Folder2 = Instance.new("Folder", workspace.Map.Regions);
    Folder2.Name = p15.Name;
    local Folder3 = Instance.new("Folder", workspace.Humanoids.Regions);
    Folder3.Name = p15.Name;

    for _, v in { Folder } do
        local Folder4 = Instance.new("Folder");
        Folder4.Name = "StationaryNpcs";
        Folder4.Parent = v;
        local Folder5 = Instance.new("Folder");
        Folder5.Name = "ActiveNpcs";
        Folder5.Parent = v;
    end;

    for _, v in { Folder3 } do
        local Folder4 = Instance.new("Folder");
        Folder4.Name = "ActiveNpcs";
        Folder4.Parent = v;
    end;

    for _, v in p15.Shrines or {} do
        local Name = v.Name;

        if typeof(Name) == "string" and (Name ~= "" and typeof(v.At) == "CFrame") then
            if u5.Shrines[Name] == nil then
                local At = v.At;
                u5.Shrines[Name] = {
                    Name = Name,
                    Region = p16,
                    At = At,
                    Price = v.Price
                };

                if ShrineModel == nil then
                    warn((`[Regions] {p16}: shrine "{Name}" registered with nothing stood for it, Assets.ShrineModel is missing`));
                else
                    if ShrineModel:IsA("Model") and ShrineModel.PrimaryPart == nil then
                        warn((`[Regions] Assets.ShrineModel has no PrimaryPart, shrine "{Name}" cannot be placed`));
                    end;

                    local v17 = ShrineModel:Clone();
                    v17.Name = `Shrine - {Name}`;
                    v17:SetAttribute("Shrine", Name);
                    local Grass = v17:FindFirstChild("Grass");

                    if Grass ~= nil and Grass:IsA("BasePart") then
                        local v18 = Workspace:Raycast(At.Position, At.UpVector * -20, RaycastHelper.Crater);
                        local v19;

                        if v18 == nil then
                            v19 = nil;
                        else
                            v19 = v18.Instance;
                        end;

                        if v19 ~= nil and v19:IsA("BasePart") then
                            Grass.Color = v19.Color;
                            Grass.Material = v19.Material;
                            Grass.MaterialVariant = v19.MaterialVariant;

                            for _, child in v19:GetChildren() do
                                if child:IsA("SurfaceAppearance") or child:IsA("Texture") then
                                    child:Clone().Parent = Grass;
                                end;
                            end;
                        end;
                    end;

                    v17.Parent = Folder2;
                    v17:PivotTo(At);
                    local Root = v17:FindFirstChild("Root");
                    local v20;

                    if Root == nil then
                        v20 = nil;
                    else
                        v20 = Root:FindFirstChild("ProxHolder");
                    end;

                    if v20 == nil then
                        warn((`[Regions] Assets.ShrineModel has no Root.ProxHolder, shrine "{Name}" gets no prompt`));
                    else
                        local ProximityPrompt = Instance.new("ProximityPrompt");
                        ProximityPrompt.ActionText = "Unlock Shrine";
                        ProximityPrompt.ObjectText = Name;
                        ProximityPrompt.HoldDuration = 1;
                        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.T;
                        ProximityPrompt.RequiresLineOfSight = false;
                        ProximityPrompt.Name = Name;
                        ProximityPrompt:AddTag("ShrineProximityPrompt");
                        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
                        ProximityPrompt.Parent = v20;
                    end;
                end;
            else
                warn((`[Regions] {p16}: shrine "{Name}" is already declared by {u5.Shrines[Name].Region}, skipped`));
            end;
        else
            warn((`[Regions] {p16}: a shrine needs a Name and an At CFrame, one was skipped`));
        end;
    end;

    local v21 = {};

    if p15.CrystalAt ~= nil then
        v21[p16] = p15;
    end;

    if p15.Area ~= nil then
        for _, v in p15.Area.Grid do
            for i, v5 in v.ChildAreas or {} do
                if v5.CrystalAt ~= nil then
                    v21[i] = v5;
                end;
            end;
        end;
    end;

    for i, v in v21 do
        local CrystalAt = v.CrystalAt;
        local v22 = Workspace:Raycast(CrystalAt.Position, CrystalAt.upVector * -20, RaycastHelper.Crater);
        local v23 = SpawnCrystal:Clone();
        local v24, v25;

        if v22 == nil or v22.Instance == nil then
            v24 = v;
            v25 = i;
        else
            v23.Root.Color = v22.Instance.Color;
            v23.Root.Material = v22.Instance.Material;
            v23.Root.MaterialVariant = v22.Instance.MaterialVariant;
            v25 = i;
            v24 = v;

            for _, child in v22.Instance:GetChildren() do
                if child.ClassName == "SurfaceAppearance" or child.ClassName == "Texture" then
                    child:Clone().Parent = v23.Root;
                end;
            end;

            CrystalAt = CFrame.new(v22.Position + vector.create(0, u14, 0)) * CrystalAt.Rotation;
        end;

        if v25 ~= p16 then
            v23.Name = `SpawnCrystal - {v25}`;
        end;

        v23:SetAttribute("SpawnArea", v25);
        v23.Parent = Folder;
        v23.Root.PS2pinkrockAMBLOOP:Play();
        v23:PivotTo(CrystalAt);

        if v24.Spawns ~= nil then
            u5.Spawns[v25] = {};

            for _, v5 in v24.Spawns do
                table.insert(u5.Spawns[v25], v5);
            end;
        end;

        local ProximityPrompt = Instance.new("ProximityPrompt");
        ProximityPrompt.ActionText = "Set Spawn";
        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.T;
        ProximityPrompt.ObjectText = v25;
        ProximityPrompt.RequiresLineOfSight = false;
        ProximityPrompt.Name = v25;
        ProximityPrompt:AddTag("SpawnCrystalProximityPrompt");
        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
        ProximityPrompt.Parent = v23.Root.At;
        ProximityPrompt.HoldDuration = 1;
        ProximityPrompt.MaxActivationDistance = 10;
        ProximityPrompt.MaxIndicatorDistance = ProximityPrompt.MaxActivationDistance + gameSettings.indicatorAdditionalDistance;
    end;

    if p15.Situations ~= nil then
        for _, v in p15.Situations do
            table.insert(u5.Situations, v);
        end;
    end;

    for _, v in ipairs(p15.Npcs) do
        local u26;

        if (v.Type == Menum.npcType.Stationary or v.Type == Menum.npcType.Idle) and gameSettings.DisableNpcSpawns ~= true then
            local u27 = v.Type == Menum.npcType.Idle;
            local u28 = (v.Appearance or game.StarterPlayer.StarterCharacter):Clone();

            if u28.Humanoid.ClassName == "Humanoid" then
                if u27 then
                    if u28.Humanoid:FindFirstChild("Animator") == nil then
                        Instance.new("Animator", u28.Humanoid).Name = "Animator";
                    end;

                    u28.Humanoid.WalkSpeed = v.WalkSpeed or 8;
                else
                    u28.Humanoid:Destroy();
                    local AnimationController = Instance.new("AnimationController");
                    AnimationController.Name = "Humanoid";
                    Instance.new("Animator", AnimationController).Name = "Animator";
                    AnimationController.Parent = u28;
                end;
            end;

            u28.HumanoidRootPart.Anchored = not u27;
            u28:RemoveTag("Humanoids");
            u28:RemoveTag("Players");
            u28.Parent = Folder.StationaryNpcs;
            u28:SetAttribute("Marker", v.Marker);
            u28:SetAttribute("Icon", v.Icon);

            if v.ModelAttributes == nil then
                u26 = v;
            else
                u26 = v;

                for i, v5 in v.ModelAttributes do
                    u28:SetAttribute(i, v5);
                end;
            end;

            if u26.NameTag ~= false then
                local BillboardGui = Instance.new("BillboardGui", u28.HumanoidRootPart);
                BillboardGui.Size = UDim2.new(3, 0, 0.6, 0);
                BillboardGui.AlwaysOnTop = false;
                BillboardGui.LightInfluence = 0;
                BillboardGui.MaxDistance = 250;
                BillboardGui.StudsOffset = Vector3.new(0, 2.8, 0);
                local TextLabel = Instance.new("TextLabel");
                TextLabel.Parent = BillboardGui;
                TextLabel.Size = UDim2.new(1, 0, 1, 0);
                TextLabel.TextScaled = true;
                TextLabel.BackgroundTransparency = 1;
                TextLabel.Font = Enum.Font.SourceSansSemibold;
                TextLabel.Text = u26.Name;
                TextLabel.TextColor3 = Color3.new(1, 1, 1);
                local UIStroke = Instance.new("UIStroke");
                UIStroke.Thickness = 2;
                UIStroke.Transparency = 0.55;
                UIStroke.Parent = TextLabel;

                if u26.Requirements ~= nil then
                    BillboardGui.Size = UDim2.new(3, 0, 1.05, 0);
                    BillboardGui.StudsOffset = Vector3.new(0, 3.025, 0);
                    TextLabel.Size = UDim2.new(1, 0, 0.5, 0);
                    TextLabel.Position = UDim2.new(0, 0, 0.5, 0);
                    local TextLabel2 = Instance.new("TextLabel");
                    TextLabel2.Name = "Requirement";
                    TextLabel2.Size = UDim2.new(1, 0, 0.5, 0);
                    TextLabel2.Position = UDim2.new(0, 0, 0, 0);
                    TextLabel2.TextScaled = true;
                    TextLabel2.BackgroundTransparency = 1;
                    TextLabel2.Font = Enum.Font.SourceSansSemibold;
                    TextLabel2.TextColor3 = Color3.new(1, 0, 0);
                    local UIStroke2 = Instance.new("UIStroke");
                    UIStroke2.Thickness = 2;
                    local UIGradient = Instance.new("UIGradient", TextLabel2);
                    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.75) });
                    UIGradient.Parent = UIStroke2;
                    UIGradient.Rotation = 90;
                    UIStroke2.Parent = TextLabel2;
                    TextLabel2.Text = ItemRequirements.Describe(u26.Requirements);
                    TextLabel2:SetAttribute("Npc", u26.Name);
                    TextLabel2:AddTag("RequirementGate");
                    TextLabel2.Parent = BillboardGui;
                end;
            end;

            if u26.Dialogue ~= false then
                local ProximityPrompt = Instance.new("ProximityPrompt");
                ProximityPrompt.ActionText = "Chat";
                ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.T;
                ProximityPrompt.ObjectText = u26.Name;
                ProximityPrompt.RequiresLineOfSight = false;
                ProximityPrompt.Name = u26.Dialogue or u26.Name;
                ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
                ProximityPrompt:AddTag("Dialogue");
                ProximityPrompt.Parent = u28.HumanoidRootPart;
                ProximityPrompt.MaxActivationDistance = 10;
                ProximityPrompt.MaxIndicatorDistance = ProximityPrompt.MaxActivationDistance + gameSettings.indicatorAdditionalDistance;

                if u26.Icon ~= nil then
                    ProximityPrompt:SetAttribute("Icon", u26.Icon);
                end;

                if u26.Requirements ~= nil then
                    ProximityPrompt:SetAttribute("Npc", u26.Name);
                    ProximityPrompt:AddTag("RequirementGate");
                end;
            end;

            local u29 = nil;
            local Spawns = u26.Spawns;

            local function PlaceAtRandomSpawn(p30: number?) -- Line: 577
                -- upvalues: u27 (copy), u26 (copy), Spawns (ref), u29 (ref), u28 (copy), RaycastParams_new_ret (ref)
                if u27 and u26.Spawns.Multiple == true then
                    Spawns = u26.Spawns[math.random(1, #u26.Spawns)];

                    if u29 ~= nil then
                        u29.SetRoute(u28, Spawns);
                    end;
                end;

                local v31 = Spawns[p30 or math.random(1, #Spawns)];
                local v32 = typeof(v31) == "CFrame" and v31 and v31 or CFrame.new(v31) * CFrame.Angles(0, math.random(-50, 50) / 50 * 3.141592653589793, 0);
                local v33 = workspace:Raycast(v32.Position + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), RaycastParams_new_ret);

                if v33 and v33.Instance then
                    v32 = CFrame.new(v33.Position) * v32.Rotation;
                end;

                u28:SetPrimaryPartCFrame(v32);
                local v34 = v32 * CFrame.new(0, v32.Position.Y - (u28.RightFoot.Position.Y - u28.RightFoot.Size.Y / 2), 0);

                if u26.SpawnOffset ~= nil then
                    v34 = v34 * u26.SpawnOffset;
                end;

                u28:SetPrimaryPartCFrame(v34);
                u28:SetAttribute("Top", u28.Head.Position + Vector3.new(0, 1, 0));
            end;

            PlaceAtRandomSpawn();
            u28.Name = u26.Name;
            local v35 = game.ReplicatedStorage.Assets.Animations.DefaultNpcAnims:Clone();
            local v36 = game.ReplicatedStorage.Assets.ClientAnimatorServer:Clone();
            v35.Parent = v36;
            v35.Name = "Anims";
            v36.Parent = u28;

            if u26.Animations ~= nil then
                for i, v5 in u26.Animations do
                    local v37 = v35:FindFirstChild(i);

                    if v37 ~= nil then
                        local v38;

                        if typeof(v5) == "table" then
                            v38 = v5[1] or v5;
                        else
                            v38 = v5;
                        end;

                        v37.AnimationId = v38;
                        v37:SetAttribute("Custom", true);
                    end;
                end;
            end;

            if u26.CustomIdle then
                local v39 = game.ReplicatedStorage.Assets.Animations.Default_Core.Default:FindFirstChild(u26.CustomIdle);

                if v39 == nil then
                    v35.idle.AnimationId = u26.CustomIdle;
                else
                    v35.idle:Destroy();
                    local v40 = v39:Clone();
                    v40.Name = "idle";
                    v40.Parent = v35;
                end;

                v35.idle:SetAttribute("Custom", true);
            end;

            if u27 then
                u28:SetAttribute("IdleNpc", true);
                pcall(function() -- Line: 639
                    -- upvalues: u28 (copy)
                    u28.HumanoidRootPart:SetNetworkOwner(nil);
                end);
                u29 = require(game.ServerStorage.SAM.Services.IdleNpcs);
                u29.Register(u28, u26, Spawns);
            end;

            local Shop2 = u26.Shop;

            if Shop2 ~= nil then
                local Folder4 = Instance.new("Folder", u28);
                Folder4.Name = u26.Name .. "\'s Shop";

                for i, v5 in Shop2 do
                    Shop.RegisterItem(i, {
                        Price = v5.Price,
                        Type = v5.Type or Menum.ShopItemType.IngameItem,
                        Seller = { u26.Name },
                        Grant = v5.Grant,
                        Icon = v5.Icon,
                        NoSave = v5.NoSave,
                        RequiresQuestDone = u26.RequiresQuestDone,
                        RequiresSide = v5.RequiresSide,
                        Requirements = u26.Requirements
                    });
                    local Model = v5.Model;

                    if Model ~= nil then
                        local v41 = Model:Clone();
                        v41.Parent = Folder4;
                        local ProximityPrompt = Instance.new("ProximityPrompt");
                        ProximityPrompt.ActionText = "Purchase";
                        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.T;
                        ProximityPrompt.ObjectText = i;
                        ProximityPrompt.RequiresLineOfSight = false;
                        ProximityPrompt.Name = i;
                        ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
                        ProximityPrompt:AddTag("Dialogue");
                        ProximityPrompt:SetAttribute("IndicatorStyle", "Blue");
                        ProximityPrompt:SetAttribute("DialogueName", "ShopDialogue");
                        ProximityPrompt:SetAttribute("Name", u26.Name);
                        ProximityPrompt.Parent = v41.PromptPart;
                        ProximityPrompt.MaxActivationDistance = 10;
                        ProximityPrompt.MaxIndicatorDistance = ProximityPrompt.MaxActivationDistance + gameSettings.indicatorAdditionalDistance;

                        if u26.Icon ~= nil then
                            ProximityPrompt:SetAttribute("Icon", u26.Icon);
                        end;

                        if v5.SuccessDialogue ~= nil then
                            ProximityPrompt:SetAttribute("SuccessDialogue", v5.SuccessDialogue);
                        end;

                        if v5.FailDialogue ~= nil then
                            ProximityPrompt:SetAttribute("FailDialogue", v5.FailDialogue);
                        end;

                        if v5.RequiresSide ~= nil then
                            ProximityPrompt:SetAttribute("Side", v5.RequiresSide);
                            ProximityPrompt:AddTag("RequirementGate");
                        end;

                        if u26.RequiresQuestDone ~= nil then
                            ProximityPrompt:AddTag("QuestGate");
                            ProximityPrompt:SetAttribute("RequiresQuestDone", u26.RequiresQuestDone);
                        end;
                    end;
                end;
            end;

            if u26.RotatingShop ~= nil then
                u26.RotatingShop.Icon = u26.RotatingShop.Icon or u26.Icon;
                u26.RotatingShop.RequiresQuestDone = u26.RotatingShop.RequiresQuestDone or u26.RequiresQuestDone;
                require(game.ServerStorage.SAM.Services.RotatingShops).Register(u26.RotatingShop, Folder);
            end;

            if u26.TimedVendor ~= nil then
                if u26.NightOnly == true then
                    warn((`Regions: {u26.Name} sets both NightOnly and TimedVendor — both own the rig's Parent and will fight over it; keep one`));
                end;

                u26.TimedVendor.RequiresQuestDone = u26.TimedVendor.RequiresQuestDone or u26.RequiresQuestDone;
                require(game.ServerStorage.SAM.Services.TimedVendors).Register(u26.TimedVendor, u28, #u26.Spawns, PlaceAtRandomSpawn, u5.Situations);
            end;

            if u26.NightOnly == true and DayAndNightHandler.IsEnabled() then
                local Parent = u28.Parent;
                local u42 = u26.DespawnAtDaytime == false;
                local u43 = u28:HasTag("HiddenNpc");

                if not DayAndNightHandler.IsNight() then
                    u28.Parent = nil;
                end;

                if not u42 or u28.Parent == nil then
                    local u44 = nil;
                    u44 = DayAndNightHandler.PhaseChanged:Connect(function(p45) -- Line: 758
                        -- upvalues: u27 (copy), PlaceAtRandomSpawn (copy), u28 (copy), Parent (copy), u43 (copy), EffectsEvent (ref), u42 (copy), u44 (ref)
                        if p45 then
                            if u27 then
                                PlaceAtRandomSpawn();
                            end;

                            u28.Parent = Parent;

                            if not u43 then
                                local HumanoidRootPart = u28:FindFirstChild("HumanoidRootPart");
                                EffectsEvent.ToAllInRange(HumanoidRootPart or u28, "Appear_Effect", HumanoidRootPart ~= nil and HumanoidRootPart.CFrame or u28:GetPivot(), HumanoidRootPart);
                            end;

                            if u42 then
                                u44:Disconnect();
                            end;
                        elseif not u42 then
                            local Pivot = u28:GetPivot();
                            u28.Parent = nil;

                            if not u43 then
                                EffectsEvent.ToAllInRange(Pivot, "DeathEffect", Pivot);
                            end;
                        end;
                    end);
                end;
            end;

            if u26.TrackedBy ~= nil then
                require(game.ServerStorage.SAM.Services.SpawnTrackers).Watch(u26.TrackedBy, u26.Name, u26.Icon, u28);
            end;
        else
            u26 = v;
        end;

        if u26.Type == Menum.npcType.Active then
            for i = 1, u26.Quantity or 1 do
                local u46 = u26.SendOver or {};
                local v47 = game.ServerStorage.SAM.NpcFile:Clone();
                v47.Name = u26.Name;
                local BindableFunction = Instance.new("BindableFunction");
                BindableFunction.Name = "GetDataBindable";
                BindableFunction.Parent = v47;

                function BindableFunction.OnInvoke() -- Line: 805
                    -- upvalues: BindableFunction (copy), u46 (copy)
                    BindableFunction.OnInvoke = nil;

                    return u46;
                end;

                v47.Parent = (u26.ParentToDebree and Folder and Folder or Folder3).ActiveNpcs;
                local _ = i;
            end;
        end;

        if u26.WorldEvent ~= nil then
            local WorldEvents = game.ServerStorage.SAM:FindFirstChild("WorldEvents");
            local v48;

            if WorldEvents == nil then
                v48 = nil;
            else
                v48 = WorldEvents:FindFirstChild(u26.WorldEvent.Name) or nil;
            end;

            if v48 == nil then
                warn((`Regions: WorldEvent "{u26.WorldEvent.Name}" not found in ServerStorage.SAM.WorldEvents`));
            else
                require(v48).Register(u26);
            end;
        end;
    end;
end;

for i, v in pairs(u5.Regions) do
    PrepareRegion(v, i);
end;

return u5;