-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = typeof;

function v1.Get(p3, p4, p5) -- Line: 5
    if p4 and p5 then
        local NpcMimicFolder = p3:GetFolder(p4):FindFirstChild("NpcMimicFolder");
        local v6 = NpcMimicFolder and NpcMimicFolder:FindFirstChild(p5);

        if v6 then
            return v6.Value;
        end;
    end;
end;

function v1.GetFolder(p7, p8) -- Line: 17
    if p8 ~= nil then
        if p8:FindFirstChild("AiPrerequistes") then
            return p8.AiPrerequistes;
        end;

        local Folder = Instance.new("Folder");
        Folder.Name = "AiPrerequistes";
        Instance.new("IntValue", Folder).Name = "PathState";
        Instance.new("IntValue", Folder).Name = "StateId";
        Folder.Parent = p8;

        return Folder;
    end;
end;

function v1.Set(p9, p10, p11) -- Line: 29
    -- upvalues: u2 (copy)
    if p10:FindFirstChild("NpcMimicFolder") == nil then
        local Folder = p9:GetFolder(p10);

        if Folder:FindFirstChild("NpcMimicFolder") == nil then
            local Folder2 = Instance.new("Folder");
            Folder2.Name = "NpcMimicFolder";
            Folder2.Parent = Folder;

            if p11 then
                for i, v in pairs(p11) do
                    local v12 = u2(v) == "number" and "NumberValue" or (u2(v) == "boolean" and "BoolValue" or "StringValue");
                    local Instance_new_ret = Instance.new(v12);
                    Instance_new_ret.Name = i;
                    Instance_new_ret.Value = v;
                    Instance_new_ret.Parent = Folder2;
                end;
            end;
        end;
    end;
end;

return v1;