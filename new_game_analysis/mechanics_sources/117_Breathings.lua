-- Decompiled with Potassium's decompiler.

local v1 = {};

for _, child in pairs(script:GetChildren()) do
    v1[child.Name] = require(child);
end;

return v1;