-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local CollectionService = game:GetService("CollectionService");
local ScrollingFrame = script.Parent:FindFirstChild("ScrollingFrame");

if not ScrollingFrame then
    warn("ScrollingFrame not found!");

    return;
end;

local TouchEnabled = UserInputService.TouchEnabled;

if not TouchEnabled then
    local _ = UserInputService.KeyboardEnabled;
end;

local function adjustFrameSize(p1, p2) -- Line: 17
    -- upvalues: TouchEnabled (copy)
    if TouchEnabled then
        if p2 == "ItemFrame" then
            p1.Size = UDim2.new(0, 200, 0, 190);

            return;
        end;

        if p2 == "OfferFrame" then
            p1.Size = UDim2.new(0, 200, 0, 190);

            return;
        end;

        if p2 == "Separator" then
            p1.Size = UDim2.new(0, 20, 0, 120);
        end;
    end;
end;

local function printTaggedFrames(p3) -- Line: 29
    -- upvalues: CollectionService (copy), ScrollingFrame (copy), adjustFrameSize (copy)
    local Tagged = CollectionService:GetTagged(p3);

    for _, v in ipairs(Tagged) do
        if v:IsDescendantOf(ScrollingFrame) then
            adjustFrameSize(v, p3);
        end;
    end;
end;

printTaggedFrames("ItemFrame");
printTaggedFrames("OfferFrame");
printTaggedFrames("Separator");