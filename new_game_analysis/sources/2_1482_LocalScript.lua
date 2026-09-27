-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local CollectionService = game:GetService("CollectionService");

function Individual(p1: userdata)
    -- upvalues: script_Parent (copy)
    local Enabled = p1:FindFirstChild("Enabled");

    if Enabled == nil then
        p1.Enabled = script_Parent.Value;

        return;
    end;

    Enabled.Value = script_Parent.Value;
end;

function upd()
    -- upvalues: CollectionService (copy)
    for _, v in pairs(CollectionService:GetTagged("Billboards")) do
        Individual(v);
    end;
end;

upd();
script_Parent.Changed:Connect(upd);
CollectionService:GetInstanceAddedSignal("Billboards"):Connect(Individual);