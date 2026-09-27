-- Decompiled with Potassium's decompiler.

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui");
local ProximityPromptChooser = require(game.ReplicatedStorage.CAM.Client.Components.ProximityPrompt.ProximityPromptChooser);
local ProximityPromptService = game:GetService("ProximityPromptService");
local u1 = {
    Prompts = {
        Available = {},
        States = {}
    },
    Indicators = {
        Available = {},
        States = {}
    }
};
local ScreenGui = Instance.new("ScreenGui", PlayerGui);
ScreenGui.ResetOnSpawn = false;
ScreenGui.Name = "PromptsHolder";
local Prompts = game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.Prompts;

function updateIndividualPrompt(p2: userdata, p3: boolean, p4: any)
    -- upvalues: u1 (copy), ProximityPromptChooser (copy), ScreenGui (copy)
    if u1.Prompts.States[p2] then
        task.spawn(u1.Prompts.States[p2]);
        u1.Prompts.States[p2] = nil;
    end;

    if p3 then
        u1.Prompts.States[p2] = ProximityPromptChooser(ScreenGui, p2, 1, p4);
    end;
end;

function updateIndividualIndicator(p5: userdata, p6: boolean, p7: any)
    -- upvalues: u1 (copy), ProximityPromptChooser (copy), ScreenGui (copy)
    if u1.Indicators.States[p5] then
        task.spawn(u1.Indicators.States[p5]);
        u1.Indicators.States[p5] = nil;
    end;

    if p6 then
        u1.Indicators.States[p5] = ProximityPromptChooser(ScreenGui, p5, 2, p7);
    end;
end;

local u8 = nil;

local function updateVisibility() -- Line: 54
    -- upvalues: u8 (ref), Prompts (copy), u1 (copy)
    u8 = Prompts.Value;

    for i, v in u1.Prompts.Available do
        updateIndividualPrompt(i, u8, v);
    end;

    for i in u1.Indicators.Available do
        updateIndividualIndicator(i, u8, nil);
    end;
end;

Prompts.Changed:Connect(updateVisibility);
updateVisibility();
ProximityPromptService.PromptShown:Connect(function(p9: userdata, p10: any) -- Line: 69
    -- upvalues: u1 (copy), u8 (ref)
    if p9.Style ~= Enum.ProximityPromptStyle.Custom then
        return;
    end;

    u1.Prompts.Available[p9] = p10;
    updateIndividualPrompt(p9, u8, p10);
end);
ProximityPromptService.PromptHidden:Connect(function(p11: userdata) -- Line: 75
    -- upvalues: u1 (copy)
    if p11.Style ~= Enum.ProximityPromptStyle.Custom then
        return;
    end;

    u1.Prompts.Available[p11] = nil;
    updateIndividualPrompt(p11, false);
end);
ProximityPromptService.IndicatorShown:Connect(function(p12: userdata, p13: any) -- Line: 82
    -- upvalues: u1 (copy), u8 (ref)
    if p12.Style == Enum.ProximityPromptStyle.Custom then
        u1.Indicators.Available[p12] = true;
        updateIndividualIndicator(p12, u8, p13);
    end;
end);
ProximityPromptService.IndicatorHidden:Connect(function(p14: userdata) -- Line: 89
    -- upvalues: u1 (copy)
    if u1.Indicators.Available[p14] ~= nil then
        u1.Indicators.Available[p14] = nil;
    end;

    updateIndividualIndicator(p14, nil);
end);