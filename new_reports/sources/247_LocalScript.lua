-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local ScrollingFrame = script_Parent.Parent.Parent.MainFrame.ScrollFrame.ScrollingFrame;
local BuyButton = ScrollingFrame.Item1.BuyButton;
local BuyButton2 = ScrollingFrame.Item2.BuyButton;

if script_Parent.Visible ~= true then
    if script_Parent.Visible == false then
        BuyButton.Interactable = true;
        BuyButton2.Interactable = true;
    end;

    return;
end;

BuyButton.Interactable = false;
BuyButton2.Interactable = false;