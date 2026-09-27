-- Decompiled with Potassium's decompiler.

local AssetService = game:GetService("AssetService");
local CollectionService = game:GetService("CollectionService");
local v1 = {};
local u2 = setmetatable({}, {
    __mode = "k"
});

function v1.Build(p3) -- Line: 6
    -- upvalues: u2 (copy), AssetService (copy), CollectionService (copy)
    local v4 = game:GetService("RunService"):IsClient();
    assert(v4, "Hat skinning is client-only; preserve the original asset in Edit and Run");
    local v5 = p3:IsA("MeshPart");
    assert(v5, "Expected MeshPart");

    if u2[p3] then
        return u2[p3];
    end;

    local v6 = p3:GetAttribute("SkinningSourceMeshId") or p3.MeshId;
    local u7 = AssetService:CreateEditableMeshAsync(Content.fromUri(v6), {
        FixedSize = false
    });
    assert(u7, "Unable to allocate EditableMesh");
    local v8 = #u7:GetBones() == 0;
    assert(v8, "Source already has skinning; not overwriting");
    local Size = u7:GetSize();
    local Center = u7:GetCenter();
    local v9 = Center.Y - Size.Y / 2;
    local v10 = v9 + Size.Y * 0.065;
    local v11 = v9 + Size.Y * 0.16;
    local u12 = {};
    local u13 = {};
    local v14 = {};
    local v15 = tonumber(p3:GetAttribute("HatBrimChainCount")) or 8;
    local math_floor_ret = math.floor(v15);
    local math_clamp_ret = math.clamp(math_floor_ret, 8, 24);
    local v16 = 6.283185307179586 / math_clamp_ret;
    local v17 = p3:GetAttribute("HatAnimateCrown") == false;
    local u18 = p3:GetAttribute("HatBrimFitSurface") == true;
    local u19 = {};

    if u18 then
        for _, v in u7:GetVertices() do
            local Position = u7:GetPosition(v);

            if Position.Y <= v9 + Size.Y * 0.4 then
                table.insert(u19, Position);
            end;
        end;
    end;

    local function add(p20, p21, p22) -- Line: 44
        -- upvalues: u7 (copy), u12 (copy), u13 (copy)
        local v23 = {
            Virtual = false,
            Name = p20,
            CFrame = CFrame.new(p21)
        };

        if p22 then
            v23.ParentId = p22;
        end;

        local v24 = u7:AddBone(v23);
        local v25 = {
            id = v24,
            name = p20,
            position = p21,
            parent = p22
        };
        table.insert(u12, v25);
        u13[v24] = v25;

        return v24;
    end;

    local v26 = add("HatAnchor", (Vector3.new(Center.X, v11, Center.Z)));
    local v27 = {};

    local function surfacePoint(p28) -- Line: 30
        -- upvalues: u18 (copy), u19 (copy), Size (copy)
        if not u18 or #u19 == 0 then
            return p28;
        end;

        local v29 = {};

        for _, v in u19 do
            local v30 = (v.X - p28.X) / Size.X;
            local v31 = (v.Z - p28.Z) / Size.Z;
            table.insert(v29, {
                pos = v,
                distance = v30 * v30 + v31 * v31
            });
        end;

        table.sort(v29, function(p32, p33) -- Line: 38
            return p32.distance < p33.distance;
        end);
        local math_min_ret = math.min(4, #v29);
        local v34 = 0;

        for i = 1, math_min_ret do
            v34 = v34 + v29[i].pos.Y;
            local _ = i;
        end;

        return Vector3.new(p28.X, v34 / math_min_ret, p28.Z);
    end;

    for i, v in { { "TopRoot", 0 }, { "TopMid", 0.5 }, { "TopTip", 1 } } do
        local Vector3_new_ret = Vector3.new(Center.X, v11 + (v9 + Size.Y - v11) * v[2], Center.Z);
        v27[i] = add(v[1], Vector3_new_ret, i == 1 and v26 and v26 or v27[i - 1]);
    end;

    if not v17 then
        table.insert(v14, "TopRoot");
    end;

    local v35 = {};

    for i = 1, math_clamp_ret do
        local v36 = (i - 1) * v16;
        local v37 = i;
        local v38 = {};

        for i2, v in { { "Root", 0.52 }, { "Mid", 0.75 }, { "Tip", 0.98 } } do
            local v39 = Center.X + math.cos(v36) * Size.X / 2 * v[2];
            local v40 = Center.Z + math.sin(v36) * Size.Z / 2 * v[2];
            local Vector3_new_ret = Vector3.new(v39, v10, v40);
            v38[i2] = add("Brim" .. v[1] .. v37, surfacePoint(Vector3_new_ret), i2 == 1 and v26 and v26 or v38[i2 - 1]);
        end;

        v35[v37] = v38;
        table.insert(v14, "BrimRoot" .. v37);
    end;

    local v41 = 0;

    for _, v in u7:GetVertices() do
        local Position = u7:GetPosition(v);
        local v42 = (Position.X - Center.X) / (Size.X / 2);
        local v43 = (Position.Z - Center.Z) / (Size.Z / 2);
        local math_sqrt_ret = math.sqrt(v42 * v42 + v43 * v43);
        local v44;

        if math_sqrt_ret < 0.55 then
            v44 = true;
        else
            v44 = not u18 and Position.Y > v9 + Size.Y * 0.2;
        end;

        local v45, v46;

        if v44 then
            local v47 = math.clamp((Position.Y - v11) / (v9 + Size.Y - v11), 0, 1) * 2;
            local v48 = math.floor(v47) + 1;
            local math_min_ret = math.min(v48, 2);
            local v49 = v47 - (math_min_ret - 1);
            v45 = { v27[math_min_ret], v27[math_min_ret + 1] };
            v46 = { 1 - v49, v49 };

            if v17 then
                v46 = { 1 };
                v45 = { v26 };
            end;
        else
            local v50 = math.atan2(v43, v42) % 6.283185307179586 / v16;
            local math_floor_ret2 = math.floor(v50);
            local v51 = math_floor_ret2 + 1;
            local v52 = (math_floor_ret2 + 1) % math_clamp_ret + 1;
            local v53 = v50 - math_floor_ret2;
            local v54 = math.clamp((math_sqrt_ret - 0.52) / 0.45999999999999996, 0, 1) * 2;
            local v55 = math.floor(v54) + 1;
            local math_min_ret = math.min(v55, 2);
            local v56 = v54 - (math_min_ret - 1);
            v45 = {
                v35[v51][math_min_ret],
                v35[v51][math_min_ret + 1],
                v35[v52][math_min_ret],
                v35[v52][math_min_ret + 1]
            };
            v46 = {
                (1 - v53) * (1 - v56),
                (1 - v53) * v56,
                v53 * (1 - v56),
                v53 * v56
            };
        end;

        local v57 = v;
        local v58 = {};
        local v59 = 0;
        local v60 = {};

        for i, v2 in v46 do
            local v61 = v2 * 255;
            v58[i] = math.floor(v61);
            v59 = v59 + v58[i];
            table.insert(v60, {
                index = i,
                remainder = v61 - v58[i]
            });
        end;

        table.sort(v60, function(p62, p63) -- Line: 104
            return p62.remainder > p63.remainder;
        end);

        for i = 1, 255 - v59 do
            local index = v60[i].index;
            v58[index] = v58[index] + 1;
            local _ = i;
        end;

        for i, v2 in v58 do
            v46[i] = v2 / 255;
        end;

        u7:SetVertexBones(v57, v45);
        u7:SetVertexBoneWeights(v57, v46);
        v41 = v41 + 1;
    end;

    local v64 = AssetService:CreateMeshPartAsync(Content.fromObject(u7), {
        CollisionFidelity = p3.CollisionFidelity,
        RenderFidelity = p3.RenderFidelity
    });
    local Size2 = p3.Size;
    CollectionService:RemoveTag(p3, "SmartBone");
    p3:ApplyMesh(v64);
    p3.Size = Size2;
    v64:Destroy();
    local v65 = Size2 / Size;
    local v66 = {};

    for _, v in u12 do
        local v67 = p3:FindFirstChild(v.name, true);

        if v67 then
            local v68 = v67:IsA("Bone");
            assert(v68, "Bone name collision");
        end;

        local v69 = v67 or Instance.new("Bone");
        v69.Name = v.name;
        local v70;

        if v.parent then
            v70 = v66[v.parent] or p3;
        else
            v70 = p3;
        end;

        v69.CFrame = CFrame.new((v.position - Center) * v65 - (v.parent and ((u13[v.parent].position - Center) * v65 or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0)));
        v69.Parent = v70;
        v66[v.id] = v69;
    end;

    p3:SetAttribute("SkinningSourceMeshId", v6);
    p3:SetAttribute("ProceduralHatSkinning", true);
    p3:SetAttribute("SkinningReady", true);
    p3:SetAttribute("Roots", table.concat(v14, ","));
    p3:SetAttribute("AnchorDepth", 0);
    p3:SetAttribute("Damping", 0.25);
    p3:SetAttribute("Stiffness", 0.65);
    p3:SetAttribute("WindInfluence", 0.15);
    local v71 = {
        EditableMesh = u7,
        Bones = u12,
        WeightedVertices = v41
    };
    u2[p3] = v71;
    CollectionService:AddTag(p3, "SmartBone");

    return v71;
end;

return v1;