-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local Parent = script_Parent.Parent.Parent;
script_Parent.Activated:Connect(function() -- Line: 4
    -- upvalues: Parent (copy)
    Parent.Visible = false;
end);