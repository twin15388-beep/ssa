-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Archives = require(ReplicatedStorage.CAM.Client.Modules.Archives);
local ShrineUnlock = require(ReplicatedStorage.CAM.Client.Modules.ShrineUnlock);
Archives.WaitLoaded();

local function watch(u1: userdata) -- Line: 22
    -- upvalues: Archives (copy), ShrineUnlock (copy)
    if not u1:IsA("ProximityPrompt") then
        return;
    end;

    local ObjectText = u1.ObjectText;

    local function refresh() -- Line: 25
        -- upvalues: u1 (copy), Archives (ref), ObjectText (copy)
        u1.Enabled = not Archives.IsUnlocked("Shrines", ObjectText);
    end;

    u1.Enabled = not Archives.IsUnlocked("Shrines", ObjectText);
    local u3 = Archives.Connect("Shrines", function(p2: table) -- Line: 29
        -- upvalues: ObjectText (copy), u1 (copy), Archives (ref)
        if table.find(p2, ObjectText) ~= nil then
            u1.Enabled = not Archives.IsUnlocked("Shrines", ObjectText);
        end;
    end);
    u1.Triggered:Connect(function() -- Line: 34
        -- upvalues: ShrineUnlock (ref), ObjectText (copy)
        ShrineUnlock.Ask(ObjectText);
    end);
    u1.Destroying:Connect(function() -- Line: 37
        -- upvalues: u3 (copy)
        u3:Disconnect();
    end);
end;

for _, v in CollectionService:GetTagged("ShrineProximityPrompt") do
    watch(v);
end;

CollectionService:GetInstanceAddedSignal("ShrineProximityPrompt"):Connect(watch);