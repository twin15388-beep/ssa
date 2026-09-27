-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MinigameSettings = require(ReplicatedStorage.CAM.Global.MinigameSettings);
local ServerClientPortal = require(ReplicatedStorage.CAM.Global.ServerClientPortal);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local LocalPlayer = Players.LocalPlayer;
local Notification = ReplicatedStorage.Communication.CnC.Notifications.Notification;
local v1 = {};
local u2 = 0;

local function equipCooldownLeft() -- Line: 49
    -- upvalues: u2 (ref)
    local v3 = u2 - os.clock();

    return math.max(v3, 0);
end;

local u4 = false;
local u5 = false;
local u6 = false;

local function Dialogues() -- Line: 62
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue);
end;

local function setBoardOpen(p7: boolean) -- Line: 68
    -- upvalues: MinigameSettings (copy), u6 (ref), ReplicatedStorage (copy)
    if p7 and MinigameSettings.Get("NoCrowBoard") == true then
        return;
    end;

    if p7 == u6 then
        return;
    end;

    u6 = p7;

    if p7 then
        require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue).OpenDialogue:Fire("CrowTasks");

        return;
    end;

    require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue).CurrentDialogue.Cancel:Fire();
end;

local function crowModelName() -- Line: 85
    -- upvalues: LocalPlayer (copy)
    return `{LocalPlayer.Name}'s Crow Model`;
end;

local function startFollowing() -- Line: 89
    -- upvalues: u4 (ref), RunService (copy), LocalPlayer (copy), u6 (ref), ReplicatedStorage (copy), ServerClientPortal (copy), setBoardOpen (copy), u5 (ref)
    if u4 then
        return;
    end;

    u4 = true;
    local u8 = nil;
    local u9 = nil;
    local u10 = 0;
    local u11 = false;
    RunService.PostSimulation:Connect(function(p12: number) -- Line: 109
        -- upvalues: LocalPlayer (ref), u11 (ref), u8 (ref), u9 (ref), u6 (ref), ReplicatedStorage (ref), u10 (ref), ServerClientPortal (ref), setBoardOpen (ref), u5 (ref)
        local Debree = workspace:FindFirstChild("Debree");

        if Debree then
            Debree = Debree:FindFirstChild((`{LocalPlayer.Name}'s Crow Model`));
        end;

        if Debree == nil then
            u11 = false;
            u8 = nil;
            u9 = nil;

            if u6 == false then
                return;
            end;

            u6 = false;
            require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue).CurrentDialogue.Cancel:Fire();

            return;
        end;

        if Debree ~= u9 then
            u9 = Debree;
            u8 = nil;
        end;

        local Root = Debree:FindFirstChild("Root");

        if Root == nil then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v13;

        if Character then
            v13 = Character:FindFirstChild("UpperTorso");
        else
            v13 = Character;
        end;

        if v13 then
            v13 = v13:FindFirstChild("Crow-Shoulder-Attachment");
        end;

        if v13 == nil then
            return;
        end;

        local MainAt = Root.MainAt;
        local CrowVelocity = Root.CrowVelocity;
        local CrowOrientation = Root.CrowOrientation;
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        local v14 = v13.WorldPosition - MainAt.WorldPosition;
        local Magnitude = v14.Magnitude;
        local v15;

        if u11 then
            v15 = Magnitude <= 3;
        else
            v15 = Magnitude <= 1.5;
        end;

        u11 = v15;
        local v16 = v14 * 2.0833333333333335;

        if v16.Magnitude > 25 then
            v16 = v16.Unit * 25;
        end;

        if not u11 then
            v16 = v14.Unit * math.max(v16.Magnitude, 8);
        end;

        local v17 = 1 - math.exp(p12 * -15);
        CrowVelocity.VectorVelocity = CrowVelocity.VectorVelocity:Lerp(v16, v17);

        if u11 then
            if HumanoidRootPart then
                CrowOrientation.CFrame = HumanoidRootPart.CFrame;
            end;
        else
            local Position = Root.Position;
            local v18 = 1 - math.exp(p12 * -6);
            CrowOrientation.CFrame = CrowOrientation.CFrame:Lerp(CFrame.lookAt(Position, Position + v14), v18);
        end;

        local v19 = u11 and "idle" or "fly";
        local v20 = v19 ~= u8;
        local os_clock_ret = os.clock();

        if v20 or os_clock_ret - u10 >= 2 then
            ServerClientPortal.Server("CrowAnim", v19);
            u8 = v19;
            u10 = os_clock_ret;
        end;

        if v20 then
            setBoardOpen(u11 and u5);
        end;
    end);
end;

function v1.check(p21: userdata, p22: string) -- Line: 200
    -- upvalues: Checker (copy), LocalPlayer (copy), Utility (copy), Notification (copy), u2 (ref)
    if not Checker.check(LocalPlayer) then
        return false;
    end;

    local Data = Utility.GetData(LocalPlayer);

    if Data then
        Data = Data:FindFirstChild("Race");
    end;

    if Data then
        Data = Data.Value;
    end;

    if Data ~= "Slayer" and Data ~= "Hybrid" then
        Notification:Fire("Notify", {
            Text = "Only Slayers can call a Kasugai crow",
            Type = "Denied"
        });

        return false;
    end;

    local v23 = u2 - os.clock();
    local math_max_ret = math.max(v23, 0);

    if math_max_ret <= 0 then
        return true;
    end;

    Notification:Fire("Notify", {
        Type = "Denied",
        Text = `Wait {math.ceil(math_max_ret)} seconds`
    });

    return false;
end;

function v1.Equipped(p24: userdata, p25: string) -- Line: 227
    -- upvalues: u5 (ref), u4 (ref), RunService (copy), LocalPlayer (copy), u6 (ref), ReplicatedStorage (copy), ServerClientPortal (copy), setBoardOpen (copy)
    u5 = true;

    if u4 then
        return;
    end;

    u4 = true;
    local u26 = nil;
    local u27 = nil;
    local u28 = 0;
    local u29 = false;
    RunService.PostSimulation:Connect(function(p30: number) -- Line: 109
        -- upvalues: LocalPlayer (ref), u29 (ref), u26 (ref), u27 (ref), u6 (ref), ReplicatedStorage (ref), u28 (ref), ServerClientPortal (ref), setBoardOpen (ref), u5 (ref)
        local Debree = workspace:FindFirstChild("Debree");

        if Debree then
            Debree = Debree:FindFirstChild((`{LocalPlayer.Name}'s Crow Model`));
        end;

        if Debree == nil then
            u29 = false;
            u26 = nil;
            u27 = nil;

            if u6 == false then
                return;
            end;

            u6 = false;
            require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue).CurrentDialogue.Cancel:Fire();

            return;
        end;

        if Debree ~= u27 then
            u27 = Debree;
            u26 = nil;
        end;

        local Root = Debree:FindFirstChild("Root");

        if Root == nil then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v31;

        if Character then
            v31 = Character:FindFirstChild("UpperTorso");
        else
            v31 = Character;
        end;

        if v31 then
            v31 = v31:FindFirstChild("Crow-Shoulder-Attachment");
        end;

        if v31 == nil then
            return;
        end;

        local MainAt = Root.MainAt;
        local CrowVelocity = Root.CrowVelocity;
        local CrowOrientation = Root.CrowOrientation;
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        local v32 = v31.WorldPosition - MainAt.WorldPosition;
        local Magnitude = v32.Magnitude;
        local v33;

        if u29 then
            v33 = Magnitude <= 3;
        else
            v33 = Magnitude <= 1.5;
        end;

        u29 = v33;
        local v34 = v32 * 2.0833333333333335;

        if v34.Magnitude > 25 then
            v34 = v34.Unit * 25;
        end;

        if not u29 then
            v34 = v32.Unit * math.max(v34.Magnitude, 8);
        end;

        local v35 = 1 - math.exp(p30 * -15);
        CrowVelocity.VectorVelocity = CrowVelocity.VectorVelocity:Lerp(v34, v35);

        if u29 then
            if HumanoidRootPart then
                CrowOrientation.CFrame = HumanoidRootPart.CFrame;
            end;
        else
            local Position = Root.Position;
            local v36 = 1 - math.exp(p30 * -6);
            CrowOrientation.CFrame = CrowOrientation.CFrame:Lerp(CFrame.lookAt(Position, Position + v32), v36);
        end;

        local v37 = u29 and "idle" or "fly";
        local v38 = v37 ~= u26;
        local os_clock_ret = os.clock();

        if v38 or os_clock_ret - u28 >= 2 then
            ServerClientPortal.Server("CrowAnim", v37);
            u26 = v37;
            u28 = os_clock_ret;
        end;

        if v38 then
            setBoardOpen(u29 and u5);
        end;
    end);
end;

function v1.UnEquipped(p39: userdata, p40: string) -- Line: 234
    -- upvalues: u5 (ref), u6 (ref), ReplicatedStorage (copy), u2 (ref), gameSettings (copy)
    u5 = false;

    if u6 ~= false then
        u6 = false;
        require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue).CurrentDialogue.Cancel:Fire();
    end;

    u2 = os.clock() + gameSettings.crowEquipCooldown;
end;

function v1.MouseDown(p41: userdata, p42: string) -- Line: 243
end;

function v1.MouseUp(p43: userdata, p44: string) -- Line: 248
end;

return v1;