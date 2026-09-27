-- Decompiled with Potassium's decompiler.

local getLastWordFromPascalCase = require(script.Parent:WaitForChild("getLastWordFromPascalCase"));
local u1 = {
    Hand = "Arm",
    Foot = "Leg"
};

function getLimbType(p2)
    -- upvalues: getLastWordFromPascalCase (copy), u1 (copy)
    local v3 = getLastWordFromPascalCase(p2);

    return u1[v3] or v3;
end;

function getLimbs(p4, u5)
    local u6 = {};
    local u7 = {};
    local u8 = {};

    local function parsePart(p9, p10) -- Line: 77
        -- upvalues: u6 (copy), u8 (copy), u7 (copy), u5 (copy), parsePart (copy)
        local v11;

        if p9.Name == "HumanoidRootPart" then
            v11 = p10;
        else
            v11 = getLimbType(p9.Name);
            u6[v11] = u6[v11] or {};
            table.insert(u6[v11], p9);
            local _ = u6[v11];

            if v11 == p10 then
                v11 = p10;
            else
                u8[v11] = u8[v11] or {};

                if p10 then
                    u8[v11][p10] = true;
                end;

                table.insert(u7, {
                    Part = p9,
                    Type = v11
                });
            end;
        end;

        for _, child in pairs(p9:GetChildren()) do
            if child:isA("Attachment") and u5[child.Name] then
                local Parent = u5[child.Name].Attachment1.Parent;

                if Parent and Parent ~= p9 then
                    parsePart(Parent, v11);
                end;
            end;
        end;
    end;

    parsePart(p4);

    return u6, u7, u8;
end;

function createNoCollision(p12, p13)
    local NoCollisionConstraint = Instance.new("NoCollisionConstraint");
    NoCollisionConstraint.Name = p12.Name .. "<->" .. p13.Name;
    NoCollisionConstraint.Part0 = p12;
    NoCollisionConstraint.Part1 = p13;

    return NoCollisionConstraint;
end;

return function(p14, p15) -- Line: 119
    local Folder = Instance.new("Folder");
    Folder.Name = "NoCollisionConstraints";
    local v16, v17, v18 = getLimbs(p15, p14);

    for i = 1, #v17 do
        local v19 = i;

        for i2 = i + 1, #v17 do
            local Type = v17[v19].Type;
            local Type2 = v17[i2].Type;
            local v20;

            if v18[Type][Type2] or v18[Type2][Type] then
                v20 = i2;
            else
                createNoCollision(v17[v19].Part, v17[i2].Part).Parent = Folder;
                v20 = i2;
            end;
        end;
    end;

    for i, v in pairs(v16) do
        local v21 = v;

        for i2, _ in pairs(v18[i]) do
            for _, v2 in pairs(v16[i2]) do
                local v22 = v2;

                for _, v3 in pairs(v21) do
                    createNoCollision(v3, v22).Parent = Folder;
                end;
            end;
        end;
    end;

    return Folder;
end;