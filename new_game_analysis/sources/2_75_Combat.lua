-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local os_clock = os.clock;
local u1 = game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(game.Players.LocalPlayer.Name);
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local CurPower = game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Skills_Provider"):WaitForChild("CurPower");

function get_equipped_Combat()
    -- upvalues: Character_info_provider (copy), Items (copy), CurPower (copy)
    if game.Players.LocalPlayer.Character == nil then
        return;
    end;

    local _equipped_tool = Character_info_provider.Get_equipped_tool(game.Players.LocalPlayer);
    local v2;

    if _equipped_tool == nil then
        v2 = nil;
    else
        v2 = Items[_equipped_tool.Name] or nil;
    end;

    if v2 ~= nil and (v2.CombatPreset ~= nil and v2.CombatPreset ~= "Combat") then
        return _equipped_tool.Name;
    end;

    for _, v in ipairs(string.split(CurPower.Value, ",")) do
        if game.ReplicatedStorage.Assets.Animations:FindFirstChild(v .. "_Combat_Anims") then
            return v;
        end;
    end;

    if _equipped_tool ~= nil and (Items[_equipped_tool.Name] ~= nil and Items[_equipped_tool.Name].HasCombat or game.ReplicatedStorage.Assets.Animations:FindFirstChild(_equipped_tool.Name .. "_Combat_Anims")) then
        return _equipped_tool.Name;
    end;
end;

local Main_Combat_Script_Client = require(script:WaitForChild("Main_Combat_Script_Client"));
local IntValue = Instance.new("IntValue", script);
IntValue.Value = 1;
IntValue.Name = "ComboValue";
local u3 = 1;
IntValue.Changed:Connect(function() -- Line: 46
    -- upvalues: u3 (ref), Combat_presets (copy), Main_Combat_Script_Client (copy), IntValue (copy)
    local math_random_ret = math.random(1, 99999);
    u3 = math_random_ret;
    task.wait(Combat_presets.combo_duration);

    if math_random_ret == u3 then
        Main_Combat_Script_Client.CanAirCombo = true;
        IntValue.Value = 1;
        Main_Combat_Script_Client.UpdraftRequested = false;
    end;
end);
local u4 = 0;
local u5 = 5;

function punch()
    -- upvalues: Combat_presets (copy), Items (copy), IntValue (copy), u5 (ref), os_clock (copy), u4 (ref), Checker (copy), Main_Combat_Script_Client (copy), u1 (copy)
    local v6 = get_equipped_Combat();
    local v7 = nil;

    if v6 == nil then
        return;
    end;

    local v8 = Combat_presets.Presets[v6];
    local v9;

    if v8 == nil then
        if Items[v6] == nil or Items[v6].Breathing == nil and (not Items[v6].HasCombat and Items[v6].CombatPreset == nil) then
            v9 = v6;
            v6 = v7;
        else
            v9 = Items[v6].CombatPreset or "Regular Katana";
        end;

        v8 = Combat_presets.Presets[v9];
    else
        v9 = v6;
        v6 = v7;
    end;

    if v8 ~= nil then
        local _ = IntValue.Value;
        local v10 = v8.default or 0.25;

        if u5 >= (v8.Max or 5) and IntValue.Value < (v8.Max or 5) then
            v10 = v8.final or v10;
        end;

        if v10 >= os_clock() - u4 then
            return v10 - (os_clock() - u4);
        end;

        if Checker.check(game.Players.LocalPlayer, "combat") ~= true then
            return nil;
        end;

        if v9 == nil then
            return nil;
        end;

        local v11 = Main_Combat_Script_Client.Do(IntValue, v8, v9, v6);

        if u1:FindFirstChild("ComboTrackerClient") == nil then
            local IntValue2 = Instance.new("IntValue");
            IntValue2.Name = "ComboTrackerClient";
            IntValue2.Value = IntValue.Value;
            local NumberValue = Instance.new("NumberValue", IntValue2);
            NumberValue.Name = "Time";
            NumberValue.Value = os.clock();
            IntValue2.Parent = u1;
        else
            u1.ComboTrackerClient.Value = IntValue.Value;
            u1.ComboTrackerClient.Time.Value = os.clock();
        end;

        Combat_presets.Last_Combo = IntValue.Value;

        if IntValue.Value == (v8.Max or 5) or IntValue.Value == 7 then
            IntValue.Value = 1;
        else
            local v12 = IntValue;
            v12.Value = v12.Value + 1;
        end;

        u4 = os_clock();
        u5 = v11.combovalue or (v8.Max or 5);
        local v13 = v8.default or 0.25;

        if u5 >= (v8.Max or 5) and IntValue.Value < (v8.Max or 5) then
            v13 = v8.final or v13;
        end;

        return v13;
    end;

    warn("[Combat] No combat preset found for \"" .. tostring(v9) .. "\"; add it to Combat_presets or set a valid CombatPreset on the item");
end;

local LocalPlayer = game.Players.LocalPlayer;
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local Mouse = LocalPlayer:GetMouse();

function hovering_click_detector()
    -- upvalues: Mouse (copy), LocalPlayer (copy)
    local v14 = false;
    local Target = Mouse.Target;

    if Target ~= nil and (LocalPlayer ~= nil and (LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil)) then
        local v15 = Target:FindFirstChildOfClass("ClickDetector");
        v14 = v15 ~= nil and v15.MaxActivationDistance >= (LocalPlayer.Character.HumanoidRootPart.Position - Target.Position).Magnitude and true or v14;
    end;

    return v14;
end;

local u16 = 0;

local function holdChain(p17: number) -- Line: 162
    -- upvalues: u16 (ref), InputHandler (copy), holdChain (copy)
    if p17 ~= u16 or not InputHandler.IsDown("Combat") then
        return;
    end;

    local v18 = punch();

    if v18 == nil then
        return;
    end;

    task.delay(v18, holdChain, p17);
end;

local function startHold() -- Line: 172
    -- upvalues: u16 (ref), InputHandler (copy), holdChain (copy)
    u16 = u16 + 1;
    local v19 = u16;

    if v19 == u16 then
        if not InputHandler.IsDown("Combat") then
            return;
        end;

        local v20 = punch();

        if v20 == nil then
            return;
        end;

        task.delay(v20, holdChain, v19);
    end;
end;

InputHandler.ListenTo("Combat", function(p21, p22) -- Line: 176
    -- upvalues: Platform_Handler (copy), IntValue (copy), Main_Combat_Script_Client (copy), u16 (ref), InputHandler (copy), holdChain (copy)
    if p21 == "Down" then
        if p22 == false and hovering_click_detector() == false then
            if Platform_Handler.Platform.Value == "Mobile" and IntValue.Value > 1 then
                Main_Combat_Script_Client.UpdraftRequested = true;
            end;

            u16 = u16 + 1;
            local v23 = u16;

            if v23 == u16 then
                if not InputHandler.IsDown("Combat") then
                    return;
                end;

                local v24 = punch();

                if v24 == nil then
                    return;
                end;

                task.delay(v24, holdChain, v23);
            end;
        end;
    elseif p21 == "Up" then
        u16 = u16 + 1;
    end;
end);
InputHandler.Available:Connect(function(p25: boolean) -- Line: 191
    -- upvalues: InputHandler (copy), u16 (ref), holdChain (copy)
    if p25 and InputHandler.IsDown("Combat") then
        u16 = u16 + 1;
        local v26 = u16;

        if v26 == u16 then
            if not InputHandler.IsDown("Combat") then
                return;
            end;

            local v27 = punch();

            if v27 == nil then
                return;
            end;

            task.delay(v27, holdChain, v26);
        end;
    end;
end);