-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local BloodDrinkRemote = Eventos:WaitForChild("BloodDrinkRemote");
local PraesidiumDrinkRemote = Eventos:WaitForChild("PraesidiumDrinkRemote");
local DropToolRemote = Eventos:WaitForChild("DropToolRemote");
local u1 = {
    Cup = true,
    CUP = true,
    Dish = true
};
local u2 = {
    PraesidiumCup = true,
    PraesidiumDish = true
};
local u3 = {
    heart = true,
    Heart = true,
    HEART = true
};
local u4 = {
    Cup = true,
    CUP = true,
    Dish = true,
    BloodCup = true,
    BloodDish = true,
    PraesidiumCup = true,
    PraesidiumDish = true,
    heart = true,
    Heart = true,
    HEART = true
};

local function equippedContainer() -- Line: 22
    -- upvalues: LocalPlayer (copy), u4 (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Tool") and u4[child.Name] then
            return child;
        end;
    end;

    return nil;
end;

local function uiHasFocus() -- Line: 33
    -- upvalues: UserInputService (copy)
    return UserInputService:GetFocusedTextBox() ~= nil;
end;

ContextActionService:BindActionAtPriority("UseBloodContainerGamepad", function(p5, p6) -- Line: 37, Name: onUseContainer
    -- upvalues: equippedContainer (copy), UserInputService (copy), u3 (copy), u2 (copy), PraesidiumDrinkRemote (copy), u1 (copy), LocalPlayer (copy), BloodDrinkRemote (copy)
    local v7 = equippedContainer();

    if not v7 or UserInputService:GetFocusedTextBox() ~= nil then
        return Enum.ContextActionResult.Pass;
    end;

    if u3[v7.Name] then
        if p6 == Enum.UserInputState.Begin then
            v7:Activate();
        end;

        return Enum.ContextActionResult.Sink;
    end;

    if u2[v7.Name] then
        if p6 == Enum.UserInputState.Begin then
            PraesidiumDrinkRemote:FireServer(v7);
        end;

        return Enum.ContextActionResult.Sink;
    end;

    if not u1[v7.Name] then
        return Enum.ContextActionResult.Pass;
    end;

    local Team = LocalPlayer.Team;

    if Team then
        Team = (Team.Name == "Vampires" or Team.Name == "Cannibal Raised") and true or Team.Name == "Cannibal Vampire";
    end;

    if not Team or (tonumber(LocalPlayer:GetAttribute("Years")) or 0) < 100 then
        return Enum.ContextActionResult.Pass;
    end;

    if p6 == Enum.UserInputState.Begin then
        BloodDrinkRemote:FireServer("FillContainer", v7);
    end;

    return Enum.ContextActionResult.Sink;
end, false, 6500, Enum.KeyCode.ButtonR2);
ContextActionService:BindActionAtPriority("DropBloodContainerGamepad", function(p8, p9, p10) -- Line: 69, Name: onDropContainer
    -- upvalues: equippedContainer (copy), UserInputService (copy), DropToolRemote (copy)
    local v11 = equippedContainer();

    if not v11 or UserInputService:GetFocusedTextBox() ~= nil then
        return Enum.ContextActionResult.Pass;
    end;

    if not (p10 and UserInputService:IsGamepadButtonDown(p10.UserInputType, Enum.KeyCode.ButtonL2)) then
        return Enum.ContextActionResult.Pass;
    end;

    if p9 == Enum.UserInputState.Begin then
        DropToolRemote:FireServer(v11);
    end;

    return Enum.ContextActionResult.Sink;
end, false, 6500, Enum.KeyCode.ButtonX);