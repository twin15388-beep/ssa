-- Decompiled with Potassium's decompiler.

local v1 = {};
local RemotePlus = game.ReplicatedStorage:FindFirstChild("RemotePlus");
local Utility = require(RemotePlus.Handlers.Utility);
local u2 = typeof;

function v1.Connect(p3: userdata, p4: function) -- Line: 8
    -- upvalues: Utility (copy)
    return Utility.Connect(p3, p4);
end;

function v1.ToAll(p5: userdata, p6: function, ...) -- Line: 11
    -- upvalues: Utility (copy)
    local v7 = nil;

    for _, v in ipairs(Utility.Players) do
        local v8 = p6(p5, v, ...);

        if v8 ~= nil then
            v7 = v7 == nil and {} or v7;
            v7[v.Name] = v8;
        end;
    end;

    return v7;
end;

function v1.To(p9: userdata, p10: function, p11: userdata, ...) -- Line: 22
    -- upvalues: Utility (copy)
    if not ((not p11 or p11.Parent ~= game.Players) and Utility.IsServer) then
        return p10(p9, p11, ...);
    end;
end;

function v1.ToAllExcept(p12: userdata, p13: function, p14: userdata, ...) -- Line: 26
    -- upvalues: Utility (copy)
    if Utility.IsServer then
        local v15 = nil;

        for _, v in ipairs(Utility.Players) do
            if v ~= p14 then
                local v16 = p13(p12, v, ...);

                if v16 ~= nil then
                    v15 = v15 == nil and {} or v15;
                    v15[v.Name] = v16;
                end;
            end;
        end;

        return v15;
    end;
end;

function v1.ToAllInRange(p17: userdata, p18: function, p19: any, p20: number, ...) -- Line: 40
    -- upvalues: Utility (copy), u2 (copy)
    if Utility.IsServer then
        local v21 = nil;

        if p19 ~= nil then
            local v22 = u2(p19);

            if v22 == "Instance" then
                if p19.ClassName == "Model" then
                    if p19.PrimaryPart ~= nil then
                        v21 = p19.PrimaryPart.Position;
                    end;
                elseif p19.Parent == game.Players then
                    if p19.Character ~= nil and p19.Character.PrimaryPart ~= nil then
                        v21 = p19.Character.PrimaryPart.Position;
                    end;
                else
                    v21 = p19.Position;
                end;
            elseif v22 == "Vector3" then
                v21 = p19;
            elseif v22 == "CFrame" then
                v21 = p19.Position;
            end;
        end;

        assert(v21 ~= nil, "From character must be valid");
        local v23 = nil;

        for _, v in ipairs(Utility.Players) do
            if v.Character ~= nil and (v.Character.PrimaryPart ~= nil and vector.magnitude(v.Character.PrimaryPart.Position - v21) <= p20) then
                local v24 = p18(p17, v, ...);

                if v24 ~= nil then
                    v23 = v23 == nil and {} or v23;
                    v23[v.Name] = v24;
                end;
            end;
        end;

        return v23;
    end;
end;

function v1.ToOthersInRange(p25: userdata, p26: function, p27: any, p28: number, ...) -- Line: 76
    -- upvalues: Utility (copy), u2 (copy)
    if Utility.IsServer then
        local v29 = nil;

        if p27 ~= nil then
            local v30 = u2(p27);

            if v30 == "Instance" then
                if p27.ClassName == "Model" then
                    if p27.PrimaryPart ~= nil then
                        v29 = p27.PrimaryPart.Position;
                    end;
                elseif p27.Parent == game.Players then
                    if p27.Character ~= nil and p27.Character.PrimaryPart ~= nil then
                        v29 = p27.Character.PrimaryPart.Position;
                    end;
                else
                    v29 = p27.Position;
                end;
            elseif v30 == "Vector3" then
                v29 = p27;
            elseif v30 == "CFrame" then
                v29 = p27.Position;
            end;
        end;

        assert(v29 ~= nil, "From character must be valid");
        local v31 = nil;

        for _, v in ipairs(Utility.Players) do
            if v ~= p27 and (v.Character ~= nil and (v.Character.PrimaryPart ~= nil and vector.magnitude(v.Character.PrimaryPart.Position - v29) <= p28)) then
                local v32 = p26(p25, v, ...);

                if v32 ~= nil then
                    v31 = v31 == nil and {} or v31;
                    v31[v.Name] = v32;
                end;
            end;
        end;

        return v31;
    end;
end;

return v1;