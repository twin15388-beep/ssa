-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);

local function drawsOn(p1: userdata, p2: string) -- Line: 24
    local Attribute = p1:GetAttribute("OnlyOn");

    return Attribute == nil and true or string.find(tostring(Attribute), p2, 1, true) ~= nil;
end;

local Gamepad = require(script.Platforms.Gamepad);
local u3 = {
    PC = require(script.Platforms.PC),
    Xbox = Gamepad,
    Playstation = Gamepad
};

function doKey(p4)
    -- upvalues: Platform_Handler (copy), u3 (copy)
    if p4 == nil then
        return;
    end;

    local Value = Platform_Handler.Platform.Value;
    local KeyLabel = p4:FindFirstChild("KeyLabel");

    if KeyLabel ~= nil then
        if KeyLabel:GetAttribute("Platform") == Value then
            return;
        end;

        KeyLabel:Destroy();
    end;

    local Attribute = p4:GetAttribute("OnlyOn");

    if Attribute ~= nil and string.find(tostring(Attribute), Value, 1, true) == nil then
        return;
    end;

    local v5 = u3[Value];

    if v5 == nil then
        return;
    end;

    local v6 = v5(p4);

    if typeof(v6) == "Instance" then
        v6.Name = "KeyLabel";
        v6:SetAttribute("Platform", Value);
    end;
end;

function updatePlatform()
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("UIkey")) do
        doKey(v);
    end;
end;

updatePlatform();
Platform_Handler.Platform.Changed.Event:Connect(updatePlatform);
InputHandler.Rebound:Connect(function() -- Line: 67, Name: relabel
    -- upvalues: CollectionService (copy)
    for _, v in ipairs(CollectionService:GetTagged("UIkey")) do
        local KeyLabel = v:FindFirstChild("KeyLabel");

        if KeyLabel ~= nil then
            KeyLabel:Destroy();
        end;

        doKey(v);
    end;
end);
CollectionService:GetInstanceAddedSignal("UIkey"):Connect(doKey);