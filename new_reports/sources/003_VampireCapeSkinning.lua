-- Decompiled with Potassium's decompiler.

local AssetService = game:GetService("AssetService");
local CollectionService = game:GetService("CollectionService");
local v1 = {};
local u2 = setmetatable({}, {
    __mode = "k"
});

local function prepare(p3) -- Line: 7
    -- upvalues: AssetService (copy)
    local v4 = p3:GetAttribute("CapeSourceMeshId") or p3.MeshId;
    local u5 = AssetService:CreateEditableMeshAsync(Content.fromUri(v4), {
        FixedSize = false
    });
    local v6;

    if u5 then
        v6 = #u5:GetBones() == 0;
    else
        v6 = u5;
    end;

    assert(v6, "Cape source must be an unskinned editable mesh");
    local Size = u5:GetSize();
    local Center = u5:GetCenter();
    local v7 = Center.Y - Size.Y / 2;
    local v8 = v7 + Size.Y * 0.92;
    local v9 = {};

    for _, v in u5:GetVertices() do
        local v10 = {
            id = v,
            pos = u5:GetPosition(v)
        };
        table.insert(v9, v10);
    end;

    local u11 = {};
    local u12 = {};

    local function add(p13, p14, p15) -- Line: 19
        -- upvalues: u5 (copy), u11 (copy), u12 (copy)
        local CFrame_new_ret = CFrame.new(p14);

        if p15 then
            CFrame_new_ret = CFrame_new_ret * CFrame.Angles(3.141592653589793, 0, 0);
        end;

        local v16 = {
            Virtual = false,
            Name = p13,
            CFrame = CFrame_new_ret
        };

        if p15 then
            v16.ParentId = p15;
        end;

        local v17 = u5:AddBone(v16);
        local v18 = {
            id = v17,
            name = p13,
            pos = p14,
            bind = CFrame_new_ret,
            parent = p15
        };
        table.insert(u11, v18);
        u12[v17] = v18;

        return v17;
    end;

    local v19 = add("CapeAnchor", (Vector3.new(Center.X - Size.X * 0.25, v8, Center.Z)));
    local v20 = {};
    local v21 = {};
    local v22 = {};

    for i = 1, 10 do
        local v23 = v8 - (v8 - v7) * (i - 1) / 9;
        local v24 = (1 / 0);
        local v25 = (-1 / 0);

        for _, v in v9 do
            local pos = v.pos;

            if math.abs(pos.Y - v23) < Size.Y * 0.07 and pos.X < Center.X + Size.X * 0.05 then
                v24 = math.min(v24, pos.Z);
                v25 = math.max(v25, pos.Z);
            end;
        end;

        if v24 == (1 / 0) then
            v24 = Center.Z - Size.Z / 2;
            v25 = Center.Z + Size.Z / 2;
        end;

        v20[i] = {
            min = v24,
            max = v25,
            y = v23
        };
    end;

    for i = 1, 7 do
        v21[i] = {};
        local v26 = i;

        for i2 = 1, 10 do
            local v27 = v20[i2];
            local v28 = v27.min + (v27.max - v27.min) * (v26 - 1) / 6;
            local v29 = i2;
            local v30 = {};

            for _, v in v9 do
                local pos = v.pos;

                if pos.Y <= v8 + Size.Y * 0.06 and pos.X < Center.X + Size.X * 0.05 then
                    local v31 = (pos.Y - v27.y) / Size.Y;
                    local v32 = (pos.Z - v28) / Size.Z;
                    table.insert(v30, {
                        p = pos,
                        d = v31 * v31 + v32 * v32
                    });
                end;
            end;

            table.sort(v30, function(p33, p34) -- Line: 57
                return p33.d < p34.d;
            end);
            local math_min_ret = math.min(8, #v30);
            assert(math_min_ret > 0, "Cape cloth surface not found");
            local v35 = 0;

            for i3 = 1, math_min_ret do
                v35 = v35 + v30[i3].p.X;
                local _ = i3;
            end;

            local Vector3_new_ret = Vector3.new(v35 / math_min_ret, v27.y, v28);
            v21[v26][v29] = add("Cape" .. v26 .. "_" .. v29, Vector3_new_ret, v29 == 1 and v19 and v19 or v21[v26][v29 - 1]);
        end;

        table.insert(v22, "Cape" .. v26 .. "_1");
    end;

    local v36 = 0;
    local v37 = 0;

    for _, v in v9 do
        local pos = v.pos;
        local v38, v39;

        if v8 <= pos.Y or pos.X >= Center.X + Size.X * 0.05 then
            v36 = v36 + 1;
            v38 = { 1 };
            v39 = { v19 };
        else
            local v40 = math.clamp((v8 - pos.Y) / (v8 - v7), 0, 1) * 9;
            local v41 = math.floor(v40) + 1;
            local math_min_ret = math.min(v41, 9);
            local v42 = v40 - (math_min_ret - 1);
            local v43 = v20[math_min_ret].min * (1 - v42) + v20[math_min_ret + 1].min * v42;
            local v44 = (pos.Z - v43) / math.max(v20[math_min_ret].max * (1 - v42) + v20[math_min_ret + 1].max * v42 - v43, 0.0001);
            local v45 = math.clamp(v44, 0, 1) * 6;
            local v46 = math.floor(v45) + 1;
            local math_min_ret2 = math.min(v46, 6);
            local v47 = v45 - (math_min_ret2 - 1);
            v39 = {
                v21[math_min_ret2][math_min_ret],
                v21[math_min_ret2][math_min_ret + 1],
                v21[math_min_ret2 + 1][math_min_ret],
                v21[math_min_ret2 + 1][math_min_ret + 1]
            };
            v38 = {
                (1 - v47) * (1 - v42),
                (1 - v47) * v42,
                v47 * (1 - v42),
                v47 * v42
            };
            v37 = v37 + 1;
        end;

        local v48 = v;
        local v49 = {};
        local v50 = 0;
        local v51 = {};

        for i, v2 in v38 do
            local v52 = v2 * 255;
            v49[i] = math.floor(v52);
            v50 = v50 + v49[i];
            table.insert(v51, {
                i = i,
                f = v52 - v49[i]
            });
        end;

        table.sort(v51, function(p53, p54) -- Line: 92
            return p53.f > p54.f;
        end);

        for i = 1, 255 - v50 do
            local i2 = v51[i].i;
            v49[i2] = v49[i2] + 1;
            local _ = i;
        end;

        for i, v2 in v49 do
            v38[i] = v2 / 255;
        end;

        u5:SetVertexBones(v48.id, v39);
        u5:SetVertexBoneWeights(v48.id, v38);
    end;

    return {
        editable = u5,
        defs = u11,
        byId = u12,
        size = Size,
        center = Center,
        roots = v22,
        asset = v4,
        vertices = #v9,
        pinned = v36,
        cloth = v37
    };
end;

local function installBones(p55, p56) -- Line: 101
    local v57 = p55.Size / p56.size;
    local v58 = {};

    for _, v in p56.defs do
        local v59 = p55:FindFirstChild(v.name, true) or Instance.new("Bone");
        local v60 = v59:IsA("Bone");
        assert(v60, "Cape bone name collision");
        v59.Name = v.name;
        local v61;

        if v.parent then
            v61 = v58[v.parent] or p55;
        else
            v61 = p55;
        end;

        local v62 = (v.pos - p56.center) * v57;
        local v63 = CFrame.new(v62) * v.bind.Rotation;
        local CFrame_identity = CFrame.identity;

        if v.parent then
            local v64 = p56.byId[v.parent];
            CFrame_identity = CFrame.new((v64.pos - p56.center) * v57) * v64.bind.Rotation;
        end;

        v59.CFrame = CFrame_identity:ToObjectSpace(v63);
        v59.Transform = CFrame.identity;
        v59:SetAttribute("CapeRestWidth", v62.Z);
        v59.Parent = v61;
        v58[v.id] = v59;
    end;

    p55:SetAttribute("CapeSourceMeshId", p56.asset);
    p55:SetAttribute("ProceduralCapeSkinning", true);
    p55:SetAttribute("Roots", table.concat(p56.roots, ","));
end;

function v1.CreateRig(p65) -- Line: 127
    -- upvalues: prepare (copy), installBones (copy), CollectionService (copy)
    local v66 = not game:GetService("RunService"):IsRunning();
    assert(v66, "CreateRig is for Edit only");
    local v67 = prepare(p65);
    installBones(p65, v67);
    v67.editable:Destroy();
    p65:SetAttribute("CapeSkinningReady", false);
    p65:SetAttribute("AnchorDepth", 0);
    p65:SetAttribute("Damping", 0.25);
    p65:SetAttribute("Stiffness", 0.55);
    p65:SetAttribute("Inertia", 0.25);
    p65:SetAttribute("WindInfluence", 0.12);
    p65:SetAttribute("Gravity", Vector3.new(0, -1.5, 0));
    p65:SetAttribute("Force", Vector3.new(0, 0, 0));
    CollectionService:RemoveTag(p65, "SmartBone");

    return {
        bones = #v67.defs,
        vertices = v67.vertices,
        pinned = v67.pinned,
        cloth = v67.cloth
    };
end;

local function stabilizeCape(p68) -- Line: 144
    p68:SetAttribute("WindType", "None");
    p68:SetAttribute("WindInfluence", 0);
    p68:SetAttribute("MatchWorkspaceWind", true);
    p68:SetAttribute("Force", Vector3.new(0, 0, 0));
    p68:SetAttribute("Gravity", (Vector3.new(0, -workspace.Gravity, 0)));
    p68:SetAttribute("Stiffness", 0.35);
    p68:SetAttribute("Damping", 0.25);
    p68:SetAttribute("Inertia", 0.8);
end;

local function installBodyColliders(p69) -- Line: 155
    -- upvalues: CollectionService (copy)
    local v70 = p69:FindFirstAncestorOfClass("Accessory");
    local v71;

    if v70 then
        v71 = v70.Parent;
    else
        v71 = v70;
    end;

    if not (v71 and (v71:IsA("Model") and v71:FindFirstChildOfClass("Humanoid"))) then
        return;
    end;

    local v72 = "VampireCape:" .. game:GetService("HttpService"):GenerateGUID(false);
    p69:SetAttribute("ColliderKey", v72);
    local _CapeBodyColliders = v70:FindFirstChild("_CapeBodyColliders");

    if _CapeBodyColliders then
        _CapeBodyColliders:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "_CapeBodyColliders";
    Folder.Parent = v70;

    for _, v in { "Torso", "UpperTorso", "LowerTorso" } do
        local v73 = v71:FindFirstChild(v);

        if v73 and v73:IsA("BasePart") then
            local Part = Instance.new("Part");
            Part.Name = "CapeCollider_" .. v;
            Part.Size = v73.Size + Vector3.new(0.12, 0.06, 0.16);
            Part.CFrame = v73.CFrame;
            Part.Transparency = 1;
            Part.CastShadow = false;
            Part.Anchored = false;
            Part.Massless = true;
            Part.CanCollide = false;
            Part.CanTouch = false;
            Part.CanQuery = false;
            Part:SetAttribute("ColliderKey", v72);
            Part:SetAttribute("ColliderShape", "Box");
            Part:SetAttribute("CapeBackOnly", true);
            Part.Parent = Folder;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = v73;
            WeldConstraint.Part1 = Part;
            WeldConstraint.Parent = Part;
            CollectionService:AddTag(Part, "SmartCollider");
        end;
    end;
end;

function v1.Build(p74) -- Line: 186
    -- upvalues: u2 (copy), CollectionService (copy), prepare (copy), AssetService (copy), installBones (copy), stabilizeCape (copy), installBodyColliders (copy)
    local v75 = game:GetService("RunService"):IsClient();
    assert(v75, "Cape skinning is client-only");
    local v76 = u2[p74];
    local CapeAnchor = p74:FindFirstChild("CapeAnchor", true);

    if v76 and (p74:GetAttribute("CapeSkinningReady") == true and (CapeAnchor and (CapeAnchor:IsA("Bone") and CollectionService:HasTag(p74, "SmartBone")))) then
        return v76;
    end;

    u2[p74] = nil;
    p74:SetAttribute("CapeSkinningReady", false);
    CollectionService:RemoveTag(p74, "SmartBone");
    local v77 = prepare(p74);
    local v78 = AssetService:CreateMeshPartAsync(Content.fromObject(v77.editable), {
        CollisionFidelity = p74.CollisionFidelity,
        RenderFidelity = p74.RenderFidelity
    });
    local Size = p74.Size;
    CollectionService:RemoveTag(p74, "SmartBone");
    p74:ApplyMesh(v78);
    p74.Size = Size;
    v78:Destroy();
    installBones(p74, v77);
    u2[p74] = v77;
    stabilizeCape(p74);
    installBodyColliders(p74);
    p74:SetAttribute("CapeSkinningReady", true);
    CollectionService:AddTag(p74, "SmartBone");

    return v77;
end;

return v1;