-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local u1 = {};
u1.__index = u1;

function u1.new(p2: userdata) -- Line: 35
    -- upvalues: u1 (copy)
    return setmetatable({
        _root = p2
    }, u1);
end;

function u1.HasHit(p3: table, p4: string, p5: userdata) -- Line: 39
    local v6 = p3._root:FindFirstChild(p4);

    if v6 == nil then
        return false;
    end;

    for _, child in v6:GetChildren() do
        if child:IsA("ObjectValue") and child.Value == p5 then
            return true;
        end;
    end;

    return false;
end;

function u1.MarkHit(p7: table, p8: string, p9: userdata, p10: number?) -- Line: 48
    -- upvalues: DebrisModule (copy)
    if p7:HasHit(p8, p9) then
        return;
    end;

    local v11 = p7._root:FindFirstChild(p8);

    if v11 == nil then
        v11 = Instance.new("Folder");
        v11.Name = p8;
        v11.Parent = p7._root;
    end;

    local ObjectValue = Instance.new("ObjectValue");
    ObjectValue.Name = p9.Name;
    ObjectValue.Value = p9;
    ObjectValue.Parent = v11;

    if p10 ~= nil then
        DebrisModule:AddItem(ObjectValue, p10);
    end;
end;

return u1;