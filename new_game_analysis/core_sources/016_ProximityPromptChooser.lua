-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local faye = require(game.ReplicatedStorage.Packages.faye);
local u1 = {};
local u2 = {};

for _, v in script.Parent.CustomPrompts:QueryDescendants("ModuleScript") do
    u1[v.Name] = require(v);
end;

for _, v in script.Parent.Indicators:QueryDescendants("ModuleScript") do
    u2[v.Name] = require(v);
end;

return function(p3: userdata?, p4: userdata, p5: number, p6: any) -- Line: 13
    -- upvalues: faye (copy), RunService (copy), u1 (copy), u2 (copy)
    local u7 = faye.new();
    local v8 = p4 or workspace.Part:FindFirstChild("ProximityPrompt");
    local v9;

    if v8 == nil then
        v9 = nil;
    else
        local v10 = u7:Create("BillboardGui");
        local v11 = {
            AlwaysOnTop = true,
            Active = true,
            CleanDelay = 0.5,
            ClipsDescendants = false
        };
        local v12;

        if v8 == nil then
            v12 = false;
        else
            v12 = v8.Name;
        end;

        v11.Name = v12;
        v11.Size = UDim2.fromScale(10, 1.75);
        v11.Parent = p3;
        v11.Adornee = v8.Parent;
        v9 = v10(v11);
    end;

    if RunService:IsRunning() then
        p3 = v9.Instance;
    end;

    local u13;

    if (not RunService:IsRunning() and 1 or p5) == 1 then
        u13 = u1[v8:GetAttribute("PromptStyle") or "Default"](p3, v8, p6 or Enum.ProximityPromptInputType.Keyboard, u7);
    else
        u13 = u2[v8:GetAttribute("IndicatorStyle") or "Default"](p3, v8, u7);
    end;

    return function() -- Line: 45
        -- upvalues: u13 (ref), u7 (copy)
        if u13 ~= nil then
            u13();
            u13 = nil;
        end;

        u7:Destroy();
    end;
end;