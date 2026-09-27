-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local script_VisualBinder = require(script.VisualBinder);
local u1 = gameSettings.Tags.LootDrop or "LootDrop";
local v2 = {};
local u3 = {};

function v2.start() -- Line: 17
    -- upvalues: CollectionService (copy), u1 (copy), script_VisualBinder (copy), u3 (copy)
    for _, v in CollectionService:GetTagged(u1) do
        if v:IsA("BasePart") then
            script_VisualBinder.attach(v);
        end;
    end;

    u3[#u3 + 1] = CollectionService:GetInstanceAddedSignal(u1):Connect(function(p4) -- Line: 23
        -- upvalues: script_VisualBinder (ref)
        if p4:IsA("BasePart") then
            script_VisualBinder.attach(p4);
        end;
    end);
    u3[#u3 + 1] = CollectionService:GetInstanceRemovedSignal(u1):Connect(function(p5) -- Line: 28
        -- upvalues: script_VisualBinder (ref)
        if p5:IsA("BasePart") then
            script_VisualBinder.cleanup(p5);
        end;
    end);
end;

function v2.teardown() -- Line: 35
    -- upvalues: u3 (copy), script_VisualBinder (copy)
    for _, v in u3 do
        v:Disconnect();
    end;

    table.clear(u3);
    script_VisualBinder.teardown();
end;

return v2;