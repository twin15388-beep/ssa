-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
workspace:SetAttribute("HasVisibilityHandler", true);
local LocalPlayer = Players.LocalPlayer;
local MenuDestination = LocalPlayer:FindFirstChild("MenuDestination");
local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local Visibility = game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility;
local u1 = game.ReplicatedStorage.Player_Service.Values:WaitForChild(LocalPlayer.Name);
local script_Sets = require(script.Sets);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local u2 = typeof;

function updateVisibility()
    -- upvalues: Camera_Traffic_Handler (copy), MenuDestination (ref), Visibility (copy), u1 (copy), LocalPlayer (copy), SettingsKeys (copy), script_Sets (copy), u2 (copy), UserInputService (copy)
    task.wait();
    local v3 = {};

    if Camera_Traffic_Handler.Equipped_Hirearchy ~= "" and Camera_Traffic_Handler.Equipped_Hirearchy then
        v3[Camera_Traffic_Handler.Equipped_Hirearchy] = true;
    end;

    if MenuDestination == nil or MenuDestination.Value == "" then
        v3.MenuClosed = true;
    else
        v3.MenuOpened = true;
        v3[MenuDestination.Value] = true;
    end;

    if Visibility.Dialogue.Value == true then
        v3.Dialogue = true;
    end;

    if u1:FindFirstChild("CameralessCutscene") then
        v3.CameralessCutscene = true;
    end;

    if LocalPlayer:GetAttribute("MapOpened") == true then
        v3.MapOpened = true;
    end;

    if LocalPlayer:GetAttribute("LoadingScreen") == true then
        v3.LoadingScreen = true;
    end;

    local Character = LocalPlayer.Character;

    if Character ~= nil and Character:GetAttribute("InMuzanLair") == true then
        v3.MuzanLair = true;
    end;

    if workspace:GetAttribute("MinigameState") == "Victory" or LocalPlayer:GetAttribute("Spectating") == true then
        v3.MinigameVictory = true;
    end;

    if LocalPlayer:GetAttribute("TrialEnding") == true then
        v3.TrialEnding = true;
    end;

    if LocalPlayer:GetAttribute(SettingsKeys.BossUIAttribute) == true then
        v3[SettingsKeys.BossUIAttribute] = true;
    end;

    if LocalPlayer:GetAttribute("FishingBite") == true then
        v3.FishingBite = true;
    end;

    if u1:FindFirstChild("Training") then
        local Attribute = u1.Training:GetAttribute("PromptsEnabled");

        if Attribute == nil or Attribute == true then
            v3.Training = true;
        else
            v3.Training = "Prompts";
        end;
    end;

    for i, v in script_Sets do
        local v4 = i.Name or i;
        local v5 = i;
        local v6 = true;

        for _, v2 in v do
            local v7 = v3[v2];

            if v7 == true or v7 ~= nil and v7 ~= v4 then
                v6 = false;
                break;
            end;
        end;

        if u2(v5) == "string" then
            local v8;

            if v5 == "PlayerList" then
                v8 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
            else
                v8 = false;
            end;

            if Enum.CoreGuiType[v5] ~= nil and (v6 or not v8) then
                game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[v5], v6);
            end;
        else
            v5.Value = v6;
        end;
    end;
end;

updateVisibility();
local u9 = {
    Training = true,
    CameralessCutscene = true
};
u1.ChildAdded:Connect(function(p10) -- Line: 120
    -- upvalues: u9 (copy)
    if u9[p10.Name] then
        updateVisibility();
    end;
end);
u1.ChildRemoved:Connect(function(p11) -- Line: 125
    -- upvalues: u9 (copy)
    if u9[p11.Name] then
        updateVisibility();
    end;
end);
Visibility.Dialogue.Changed:Connect(updateVisibility);

local function hookCharacter(p12: userdata) -- Line: 132
    p12:GetAttributeChangedSignal("InMuzanLair"):Connect(updateVisibility);
    updateVisibility();
end;

if LocalPlayer.Character ~= nil then
    LocalPlayer.Character:GetAttributeChangedSignal("InMuzanLair"):Connect(updateVisibility);
    updateVisibility();
end;

LocalPlayer.CharacterAdded:Connect(hookCharacter);
LocalPlayer:GetAttributeChangedSignal("LoadingScreen"):Connect(updateVisibility);
LocalPlayer:GetAttributeChangedSignal("MapOpened"):Connect(updateVisibility);
LocalPlayer:GetAttributeChangedSignal("FishingBite"):Connect(updateVisibility);
LocalPlayer:GetAttributeChangedSignal(SettingsKeys.BossUIAttribute):Connect(updateVisibility);
LocalPlayer:GetAttributeChangedSignal("TrialEnding"):Connect(updateVisibility);
workspace:GetAttributeChangedSignal("MinigameState"):Connect(updateVisibility);
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(updateVisibility);
task.spawn(function() -- Line: 148
    -- upvalues: MenuDestination (ref), LocalPlayer (copy)
    if MenuDestination == nil then
        MenuDestination = LocalPlayer:WaitForChild("MenuDestination", 99);

        if MenuDestination == nil then
            return;
        end;

        updateVisibility();
    end;

    MenuDestination.Changed:Connect(updateVisibility);
end);
game.ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler:FindFirstChild("Updated").Event:Connect(updateVisibility);