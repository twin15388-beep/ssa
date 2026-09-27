-- Decompiled with Potassium's decompiler.

local getLastWordFromPascalCase = require(script.Parent:WaitForChild("getLastWordFromPascalCase"));
local u1 = {};

for _, child in pairs(script:GetChildren()) do
    u1[child.Name] = child;
end;

function getConstraintTemplate(p2)
    -- upvalues: getLastWordFromPascalCase (copy), u1 (copy)
    return u1[getLastWordFromPascalCase(p2)] or u1.Default;
end;

function createConstraint(p3)
    local Name = p3.Joint.Name;
    local v4 = getConstraintTemplate(Name):Clone();
    v4.Attachment0 = p3.Attachment0;
    v4.Attachment1 = p3.Attachment1;
    v4.Name = Name .. "RagdollConstraint";
    local ObjectValue = Instance.new("ObjectValue", v4);
    ObjectValue.Name = "RigidJoint";
    ObjectValue.Value = p3.Joint;

    return v4;
end;

return function(p5) -- Line: 68
    local Folder = Instance.new("Folder");
    Folder.Name = "RagdollConstraints";
    local v6 = {
        Root = true,
        Neck = true
    };

    for _, v in pairs(p5) do
        if not v6[v.Joint.Name] then
            createConstraint(v).Parent = Folder;
        end;
    end;

    return Folder;
end;