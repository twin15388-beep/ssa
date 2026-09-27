-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.Types.StatsFetchTypes);
local u1 = {
    SkillStats = require(script.Modules.SkillStats),
    Functions = {}
};
local v2 = script:WaitForChild("Functions"):QueryDescendants("ModuleScript");
table.sort(v2, function(p3, p4) -- Line: 43
    return p3:GetFullName() < p4:GetFullName();
end);

local function registerModule(p5: userdata) -- Line: 12
    -- upvalues: u1 (copy)
    local success, result = pcall(require, p5);

    if not success then
        warn((`StatsFetch: failed to require {p5:GetFullName()}: {result}`));

        return;
    end;

    if type(result) ~= "table" then
        warn((`StatsFetch: module {p5:GetFullName()} did not return a table`));

        return;
    end;

    local Name = p5.Name;

    if u1.Functions[Name] == nil then
        u1.Functions[Name] = result;
    else
        warn((`StatsFetch: duplicate module name {Name}`));
    end;

    for i, v in result do
        if type(v) == "function" then
            if u1[i] == nil then
                u1[i] = v;
            else
                warn((`StatsFetch: function name collision at {i} from {Name}`));
            end;
        end;
    end;
end;

for _, v in v2 do
    registerModule(v);
end;

return u1;