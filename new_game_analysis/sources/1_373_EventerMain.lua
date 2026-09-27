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
    p6(p5, ...);
end;

function v1.To(p7: userdata, p8: function, p9: userdata, ...) -- Line: 14
    -- upvalues: Utility (copy)
    if (not p9 or p9.Parent ~= game.Players) and Utility.IsServer then
        return;
    end;

    p8(p7, p9, ...);
end;

function v1.ToAllExcept(p10: userdata, p11: function, p12: userdata, ...) -- Line: 18
    -- upvalues: Utility (copy)
    if not Utility.IsServer then
        return;
    end;

    for _, v in ipairs(Utility.Players) do
        if v ~= p12 then
            p11(p10, v, ...);
        end;
    end;
end;

function v1.ToAllInRange(p13: userdata, p14: function, p15: any, p16: number, ...) -- Line: 26
    -- upvalues: Utility (copy), u2 (copy)
    if not Utility.IsServer then
        return;
    end;

    local v17 = nil;

    if p15 ~= nil then
        local v18 = u2(p15);

        if v18 == "Instance" then
            if p15.Parent == nil then
                return;
            end;

            if p15.ClassName == "Model" then
                if p15.PrimaryPart ~= nil then
                    v17 = p15.PrimaryPart.Position;
                end;
            elseif p15.Parent == game.Players then
                if p15.Character ~= nil and p15.Character.PrimaryPart ~= nil then
                    v17 = p15.Character.PrimaryPart.Position;
                end;
            else
                v17 = p15.Position;
            end;
        elseif v18 == "Vector3" then
            v17 = p15;
        elseif v18 == "CFrame" then
            v17 = p15.Position;
        end;
    end;

    assert(v17 ~= nil, "From character must be valid");

    for _, v in ipairs(Utility.Players) do
        if v.Character ~= nil and (v.Character.PrimaryPart ~= nil and vector.magnitude(v.Character.PrimaryPart.Position - v17) <= p16) then
            p14(p13, v, ...);
        end;
    end;
end;

function v1.ToOthersInRange(p19: userdata, p20: function, p21: any, p22: number, ...) -- Line: 57
    -- upvalues: Utility (copy), u2 (copy)
    if not Utility.IsServer then
        return;
    end;

    local v23 = nil;

    if p21 ~= nil then
        local v24 = u2(p21);

        if v24 == "Instance" then
            if p21.Parent == nil then
                return;
            end;

            if p21.ClassName == "Model" then
                if p21.PrimaryPart ~= nil then
                    v23 = p21.PrimaryPart.Position;
                end;
            elseif p21.Parent == game.Players then
                if p21.Character ~= nil and p21.Character.PrimaryPart ~= nil then
                    v23 = p21.Character.PrimaryPart.Position;
                end;
            else
                v23 = p21.Position;
            end;
        elseif v24 == "Vector3" then
            v23 = p21;
        elseif v24 == "CFrame" then
            v23 = p21.Position;
        end;
    end;

    assert(v23 ~= nil, "From character must be valid");

    for _, v in ipairs(Utility.Players) do
        if v ~= p21 and (v.Character ~= nil and (v.Character.PrimaryPart ~= nil and vector.magnitude(v.Character.PrimaryPart.Position - v23) <= p22)) then
            p20(p19, v, ...);
        end;
    end;
end;

return v1;