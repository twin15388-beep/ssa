-- Decompiled with Potassium's decompiler.

return function(p1: userdata) -- Line: 1
    if p1 == nil or not p1:IsDescendantOf(workspace.Humanoids) then
        return;
    end;

    local Parent = p1.Parent;

    for i = 1, 5 do
        if Parent ~= nil and Parent:FindFirstChild("Humanoid") then
            break;
        end;

        local v2;

        if Parent.Parent == nil then
            v2 = i;
        else
            Parent = Parent.Parent;
            v2 = i;
        end;
    end;

    if Parent ~= nil and Parent:FindFirstChild("Humanoid") == nil then
        Parent = nil;
    end;

    return Parent;
end;