-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Layout = game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Components"):WaitForChild("Layout");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "Misc";
ScreenGui.Parent = PlayerGui;
ScreenGui.ResetOnSpawn = false;
ScreenGui.ScreenInsets = Enum.ScreenInsets.None;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
local ScreenGui2 = Instance.new("ScreenGui");
ScreenGui2.Name = "ComponentsHolder";
ScreenGui2.Parent = PlayerGui;
ScreenGui2.ResetOnSpawn = false;
ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local DialogueComponent = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent);
local Dialogue = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue);
local u1 = {};
local u2 = nil;
local u3 = nil;

local function add(p4) -- Line: 27
    -- upvalues: u2 (ref), ScreenGui2 (copy)
    if u2 == nil then
        return;
    end;

    u2:Add(p4(ScreenGui2));
end;

local function update(p5) -- Line: 31
    -- upvalues: u3 (ref), Dialogue (copy), u2 (ref), cleanit (copy), u1 (copy), ScreenGui2 (copy)
    if u3 ~= nil then
        local Current = Dialogue.CurrentDialogue.Current;
        local v6 = Current ~= nil and Dialogue.Diagloues[Current] or nil;

        if v6 == nil or v6.SurviveRespawn ~= true then
            game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.Dialogue.Value = false;
            u3();
            u3 = nil;
        end;
    end;

    if u2 ~= nil then
        u2:Destroy();
        u2 = nil;
    end;

    u2 = cleanit.new();

    for _, v in u1 do
        u2:Add(v(ScreenGui2));
    end;
end;

for _, child in Layout.ResetOnSpawn:GetChildren() do
    if child:IsA("ModuleScript") then
        table.insert(u1, require(child));
    end;
end;

Layout.ResetOnSpawn.ChildAdded:Connect(function(p7) -- Line: 57
    -- upvalues: u2 (ref), ScreenGui2 (copy), u1 (copy)
    if not p7:IsA("ModuleScript") then
        return;
    end;

    local v8 = require(p7);

    if u2 ~= nil then
        u2:Add(v8(ScreenGui2));
    end;

    table.insert(u1, v8);
end);

if LocalPlayer.Character ~= nil then
    update();
end;

LocalPlayer.CharacterAdded:Connect(update);
game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.Dialogue.Value = false;

local function openDialogue(p9: string?, p10: userdata?) -- Line: 87
    -- upvalues: u3 (ref), Dialogue (copy), DialogueComponent (copy), ScreenGui2 (copy)
    if p9 == nil then
        return;
    end;

    if u3 == nil then
        Dialogue.CurrentDialogue.Current = p9;
        u3 = DialogueComponent(ScreenGui2, p9, p10);

        if u3 ~= nil then
            game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.Dialogue.Value = true;
        end;
    else
        Dialogue.AttemptDialogue:Fire(p9);
    end;
end;

game:GetService("ProximityPromptService").PromptTriggered:Connect(function(p11: userdata, p12: userdata) -- Line: 99
    -- upvalues: openDialogue (copy)
    if not game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.Prompts.Value then
        return;
    end;

    if p11:HasTag("Dialogue") then
        openDialogue(p11:GetAttribute("DialogueName") or p11.ObjectText, p11);
    end;
end);
Dialogue.OpenDialogue:Connect(openDialogue);
local u13 = nil;

local function checkPendingDialogue() -- Line: 111
    -- upvalues: LocalPlayer (copy), u13 (ref), openDialogue (copy)
    local Attribute = LocalPlayer:GetAttribute("PendingDialogue");

    if Attribute == nil or (Attribute == "" or Attribute == u13) then
        return;
    end;

    u13 = Attribute;
    openDialogue(Attribute);
end;

LocalPlayer:GetAttributeChangedSignal("PendingDialogue"):Connect(checkPendingDialogue);
local Attribute = LocalPlayer:GetAttribute("PendingDialogue");

if Attribute ~= nil and (Attribute ~= "" and Attribute ~= u13) then
    u13 = Attribute;
    openDialogue(Attribute);
end;

Dialogue.CurrentDialogue.Cancel:Connect(function() -- Line: 119
    -- upvalues: u3 (ref)
    game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.Dialogue.Value = false;

    if u3 ~= nil then
        u3();
        u3 = nil;
    end;
end);

for _, child in Layout.NoneResetting:GetChildren() do
    if child:IsA("ModuleScript") then
        require(child)(ScreenGui2);
    end;
end;

Layout.NoneResetting.ChildAdded:Connect(function(p14) -- Line: 139
    -- upvalues: ScreenGui2 (copy)
    if not p14:IsA("ModuleScript") then
        return;
    end;

    require(p14)(ScreenGui2);
end);