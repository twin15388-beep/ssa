-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Data = Utility.GetData(Players.LocalPlayer, true);
local u1 = ReplicatedStorage:WaitForChild("ToolScripts"):WaitForChild("Biwa Bell"):WaitForChild("Biwa Bell");
local u2 = nil;
local u3 = false;
local u4 = false;

local function getTemplate() -- Line: 31
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v5 = Assets ~= nil and Assets:FindFirstChild("Npcs") or nil;

    return v5 ~= nil and v5:FindFirstChild("Muzan") or nil;
end;

local function loadMuzan() -- Line: 37
    -- upvalues: u2 (ref), ReplicatedStorage (copy), u4 (ref), Data (copy), MuzanSettings (copy), u3 (ref), Utility (copy), BunchaIcons (copy), u1 (copy)
    if u2 ~= nil then
        u2:Destroy();
        u2 = nil;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");
    local v6 = Assets ~= nil and Assets:FindFirstChild("Npcs") or nil;
    local v7 = v6 ~= nil and v6:FindFirstChild("Muzan") or nil;

    if v7 == nil then
        if not u4 then
            u4 = true;
            warn("[MuzanLairModel] ReplicatedStorage/Assets/Npcs/Muzan not found — Muzan not spawned");
        end;

        return;
    end;

    local Race = Data:FindFirstChild("Race");
    local v8;

    if Race == nil then
        v8 = false;
    else
        v8 = Race.Value == "Demon" and true or Race.Value == "Hybrid";
    end;

    local v9;

    if v8 then
        v9 = MuzanSettings.muzanPositions.IsDemon;
    else
        v9 = MuzanSettings.muzanPositions.IsNotDemon;
    end;

    if v9.Position.Magnitude < 1 then
        if not u3 then
            u3 = true;
            warn("[MuzanLairModel] muzanPositions CFrame is still the origin placeholder — Muzan not spawned");
        end;

        return;
    end;

    local v10 = v7:Clone();
    v10.Name = "MuzanLairModel";
    v10:RemoveTag("Humanoids");
    v10:RemoveTag("Players");
    v10:PivotTo(v9);
    local v11 = v10.PrimaryPart or v10:FindFirstChild("HumanoidRootPart");

    if v11 ~= nil then
        v11.Anchored = true;
    end;

    local v12 = v10:FindFirstChildOfClass("Humanoid");

    if v12 ~= nil then
        v12:Destroy();
    end;

    local v13 = v10:FindFirstChildOfClass("AnimationController");

    if v13 == nil then
        v13 = Instance.new("AnimationController");
        v13.Parent = v10;
    end;

    local v14 = v13:FindFirstChildOfClass("Animator");

    if v14 == nil then
        v14 = Instance.new("Animator");
        v14.Parent = v13;
    end;

    if not v8 then
        local ItemAssets = ReplicatedStorage:FindFirstChild("ItemAssets");
        local v15;

        if ItemAssets == nil then
            v15 = nil;
        else
            v15 = ItemAssets:FindFirstChild("Muzan\'s Blood", true) or nil;
        end;

        local RightHand = v10:FindFirstChild("RightHand", true);
        local v16;

        if v15 == nil then
            v16 = nil;
        else
            v16 = v15:Clone() or nil;
        end;

        local v17;

        if v16 == nil then
            v17 = nil;
        else
            v17 = v16:FindFirstChild("Weld", true) or nil;
        end;

        if v16 == nil or (v17 == nil or RightHand == nil) then
            if v16 ~= nil then
                v16:Destroy();
            end;

            warn((`[MuzanLairModel] flask skipped — missing {v15 == nil and "ItemAssets/Muzan\'s Blood" or (v17 == nil and "its Weld" or "rig RightHand")}`));
        else
            v17.Part0 = RightHand;
            v16.Parent = v10;
        end;
    end;

    if v11 ~= nil then
        Utility.CreatePrompt({
            ActionText = "Chat",
            ObjectText = "Muzan",
            MaxActivationDistance = 10,
            Tags = { "Dialogue" },
            Attributes = {
                DialogueName = "MuzanLair",
                Name = "Muzan",
                Icon = BunchaIcons.MuzanIcon
            },
            Parent = v11
        });
    end;

    v10.Parent = workspace.Debree;
    u2 = v10;
    local v18 = u1:FindFirstChild(v8 and "MuzanIdleSeated" or "MuzanIdlePotion");

    if v18 == nil or v14 == nil then
        if v18 == nil then
            warn((`[MuzanLairModel] idle clip "{v8 and "MuzanIdleSeated" or "MuzanIdlePotion"}" missing under ToolScripts/Biwa Bell/Biwa Bell`));
        end;

        return;
    end;

    local v19 = v14:LoadAnimation(v18);
    v19.Looped = true;
    v19:Play();
end;

loadMuzan();
task.spawn(function() -- Line: 143
    -- upvalues: Data (copy), loadMuzan (copy)
    local Race = Data:WaitForChild("Race", 30);

    if Race == nil then
        return;
    end;

    Race.Changed:Connect(loadMuzan);
    loadMuzan();
end);