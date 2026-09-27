-- Decompiled with Potassium's decompiler.

local LocalPlayer = game.Players.LocalPlayer;
local Skill_Controller = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Skill_Controller"));
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local UserInputService = game:GetService("UserInputService");
local InputHandler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Components"):WaitForChild("Client"):WaitForChild("InputHandler"));
local Dash_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Dash_Handler"));
local cleanit = require(game.ReplicatedStorage.Packages.cleanit);
local DataValue = require(game.ReplicatedStorage.CAM.Client.Modules.DataValue);
local SettingsKeys = require(game.ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local Run_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Run_Handler"));

if Dash_Handler.LifeCleaner ~= nil then
    Dash_Handler.LifeCleaner:Clean();
end;

local v1 = cleanit.new();
Dash_Handler.LifeCleaner = v1;
local Humanoid = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid");
local Skill_Info = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("PlayerProfile"):WaitForChild("Skill_Info"));
local Stats = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("SkillService"):WaitForChild("Stats"));
local u2 = false;
local u3 = Skill_Info["Double Jump"];
local SkillTreeUnlockedList = Utility.GetData(LocalPlayer, true):WaitForChild("SkillTreeUnlockedList");

local function refresh() -- Line: 40
    -- upvalues: u2 (ref), Stats (copy), LocalPlayer (copy)
    u2 = Stats.IsSkillUnlocked(LocalPlayer, "Double Jump");
end;

local v4 = SkillTreeUnlockedList:FindFirstChild(u3.Category);

if v4 then
    v4.Changed:Connect(refresh);
else
    SkillTreeUnlockedList.ChildAdded:Connect(function(p5) -- Line: 47
        -- upvalues: u3 (copy), refresh (copy), u2 (ref), Stats (copy), LocalPlayer (copy)
        if p5.Name == u3.Category then
            p5.Changed:Connect(refresh);
            u2 = Stats.IsSkillUnlocked(LocalPlayer, "Double Jump");
        end;
    end);
end;

u2 = Stats.IsSkillUnlocked(LocalPlayer, "Double Jump");
local u6 = tick;
local u7 = 0;
local u8 = false;
Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function() -- Line: 66
    -- upvalues: Humanoid (copy), u8 (ref)
    if Humanoid.FloorMaterial ~= Enum.Material.Air then
        u8 = false;
    end;
end);
v1:Add(InputHandler.ListenTo("Jump", function(p9, p10) -- Line: 77
    -- upvalues: u6 (copy), u7 (ref), Humanoid (copy), u8 (ref)
    if p9 ~= "Down" or p10 then
        return;
    end;

    if u6() - u7 < 1 and (u6() - u7 > 0.1 and (Humanoid.FloorMaterial == nil or Humanoid.FloorMaterial == Enum.Material.Air)) and u8 == false then
        doDoubleJump();

        return;
    end;

    u7 = u6();
end));
local table_find = table.find;
local u11 = {
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D
};

function doDoubleJump()
    -- upvalues: u2 (ref), Skill_Controller (copy), Dash_Handler (copy), u6 (copy), u8 (ref)
    if not u2 then
        return;
    end;

    if Skill_Controller.Attempt_Hold("Double Jump", "Space") == true then
        Skill_Controller.StopHold("Double Jump");
    end;

    Dash_Handler.LastDid = u6();
    u8 = true;
end;

UserInputService.InputBegan:Connect(function(p12, p13) -- Line: 103
    -- upvalues: InputHandler (copy), UserInputService (copy), table_find (copy), u11 (copy), Dash_Handler (copy)
    if p13 == false then
        if InputHandler.IsBlocked() then
            return;
        end;

        if UserInputService:IsKeyDown(Enum.KeyCode.Q) and table_find(u11, p12.KeyCode) or p12.KeyCode == Enum.KeyCode.Q then
            local v14 = UserInputService:IsKeyDown(Enum.KeyCode.A) and "A" or (UserInputService:IsKeyDown(Enum.KeyCode.S) and "S" or (UserInputService:IsKeyDown(Enum.KeyCode.D) and "D" or (UserInputService:IsKeyDown(Enum.KeyCode.W) and "W" or nil)));

            if v14 ~= nil then
                Dash_Handler.Perform(v14);
            end;
        end;
    end;
end);

function cancel_dash()
    -- upvalues: u6 (copy), Dash_Handler (copy), LocalPlayer (copy)
    if u6() - Dash_Handler.LastDid > 0.5 then
        return;
    end;

    if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
        if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("dash_thang_123asd") ~= nil then
            for _, child in pairs(LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                if child.Name == "dash_thang_123asd" then
                    child:Destroy();
                end;
            end;
        end;

        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new();
    end;
end;

local v15 = game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(LocalPlayer.Name);
local Utility2 = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
v15.ChildAdded:Connect(function(p16) -- Line: 148
    -- upvalues: Utility2 (copy), u6 (copy), Combat_presets (copy)
    if Utility2.Cancel_Values[p16.Name] ~= nil then
        cancel_dash();
    end;

    if p16.Name == "DMG" then
        cancel_dash();
        p16:GetAttributeChangedSignal("LastEngaged"):Connect(function() -- Line: 154
            -- upvalues: u6 (ref), Combat_presets (ref)
            if u6() - Combat_presets.Last_Punched <= Combat_presets.slow_walk_duration then
                cancel_dash();
            end;
        end);
    end;
end);
local u17 = v1:Add(DataValue.new(SettingsKeys.PadDirectionalDash.Path, SettingsKeys.PadDirectionalDash.Default, SettingsKeys.Scope));

local function directional() -- Line: 193
    -- upvalues: u17 (copy)
    return u17:Get() == true;
end;

local u18 = false;
local u19 = 0;
local u20 = nil;

local function disarm() -- Line: 203
    -- upvalues: u18 (ref), Run_Handler (copy), u20 (ref)
    u18 = false;
    Run_Handler.DashArmed = false;

    if u20 ~= nil then
        u20:Disconnect();
        u20 = nil;
    end;
end;

v1:Add(disarm);
u17.Changed:Connect(disarm);
v1:Add(InputHandler.ListenTo("Dash", function(p21, p22) -- Line: 216
    -- upvalues: u17 (copy), Dash_Handler (copy), u18 (ref), UserInputService (copy), Run_Handler (copy), u20 (ref), u19 (ref)
    if u17:Get() ~= true then
        if p21 ~= "Down" or p22 then
            return;
        end;

        Dash_Handler.Perform(Dash_Handler.MovementLetter());

        return;
    end;

    if p21 == "Up" then
        if not u18 then
            return;
        end;

        local v23 = "W";

        for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
            if v.KeyCode == Enum.KeyCode.Thumbstick1 then
                local Vector2_new_ret = Vector2.new(v.Position.X, -v.Position.Y);

                if Vector2_new_ret.Magnitude >= 0.5 then
                    v23 = Dash_Handler.Letter(Vector2_new_ret);
                end;
            end;
        end;

        u18 = false;
        Run_Handler.DashArmed = false;

        if u20 ~= nil then
            u20:Disconnect();
            u20 = nil;
        end;

        Dash_Handler.Perform(v23);

        return;
    end;

    if p21 ~= "Down" or (p22 or u18) then
        return;
    end;

    u18 = true;
    u19 = u19 + 1;
    local u24 = u19;
    local u25 = nil;

    for _, v in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
        if v.KeyCode == Enum.KeyCode.Thumbstick1 then
            local Vector2_new_ret = Vector2.new(v.Position.X, -v.Position.Y);

            if Vector2_new_ret.Magnitude >= 0.5 then
                u25 = Dash_Handler.Letter(Vector2_new_ret);
            end;
        end;
    end;

    Run_Handler.DashArmed = true;
    task.delay(0.3, function() -- Line: 256
        -- upvalues: u18 (ref), u24 (copy), u19 (ref), Run_Handler (ref), u20 (ref), Dash_Handler (ref), u25 (ref)
        if not u18 or u24 ~= u19 then
            return;
        end;

        u18 = false;
        Run_Handler.DashArmed = false;

        if u20 ~= nil then
            u20:Disconnect();
            u20 = nil;
        end;

        Dash_Handler.Perform(u25 or "W");
    end);
    u20 = UserInputService.InputChanged:Connect(function(p26: userdata) -- Line: 261
        -- upvalues: Dash_Handler (ref), u25 (ref), u18 (ref), Run_Handler (ref), u20 (ref)
        if p26.KeyCode ~= Enum.KeyCode.Thumbstick1 then
            return;
        end;

        local Vector2_new_ret = Vector2.new(p26.Position.X, -p26.Position.Y);

        if Vector2_new_ret.Magnitude < 0.5 then
            return;
        end;

        local v27 = Dash_Handler.Letter(Vector2_new_ret);

        if v27 == u25 then
            return;
        end;

        u18 = false;
        Run_Handler.DashArmed = false;

        if u20 ~= nil then
            u20:Disconnect();
            u20 = nil;
        end;

        Dash_Handler.Perform(v27);
    end);
end));