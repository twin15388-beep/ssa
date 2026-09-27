-- Decompiled with Potassium's decompiler.

local AssetService = game:GetService("AssetService");
local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");

local function copyAppearance(p1, p2) -- Line: 8
    p2.Color = p1.Color;
    p2.Material = p1.Material;
    p2.MaterialVariant = p1.MaterialVariant;
    p2.Transparency = p1.Transparency;
    p2.Reflectance = p1.Reflectance;
    p2.CastShadow = p1.CastShadow;

    for _, child in p1:GetChildren() do
        if child:IsA("SurfaceAppearance") then
            child:Clone().Parent = p2;
        end;
    end;
end;

local function buildSmartBoneHat(u3) -- Line: 23
    -- upvalues: AssetService (copy), copyAppearance (copy), CollectionService (copy), RunService (copy)
    local Chapeu_SmartBone = workspace:FindFirstChild("Chapeu_SmartBone");

    if Chapeu_SmartBone and Chapeu_SmartBone:GetAttribute("SmartBoneGenerated") then
        Chapeu_SmartBone:Destroy();
    end;

    local u4 = AssetService:CreateEditableMeshAsync(u3.MeshContent, {
        FixedSize = false
    });
    assert(u4, "Could not create EditableMesh for Chapeu");
    local Vertices = u4:GetVertices();
    local v5 = (-1 / 0);
    local v6 = 0;

    for _, v in Vertices do
        local Position = u4:GetPosition(v);
        v5 = math.max(v5, Position.Y);
        local Magnitude = Vector2.new(Position.X, Position.Z).Magnitude;
        v6 = math.max(v6, Magnitude);
    end;

    local math_max_ret = math.max(0.505, v6);
    local u7 = {};

    local function addBone(p8, p9, p10) -- Line: 51
        -- upvalues: u4 (copy), u7 (copy)
        local v11 = {
            Virtual = false,
            Name = p8,
            CFrame = CFrame.new(p9)
        };

        if p10 then
            v11.ParentId = p10;
        end;

        local v12 = u4:AddBone(v11);
        u7[p8] = p9;

        return v12;
    end;

    local v13 = u4:AddBone({
        Name = "HatStatic",
        Virtual = false,
        CFrame = CFrame.new(Vector3.new(0, -0.074, 0))
    });
    u7.HatStatic = Vector3.new(0, -0.074, 0);
    local v14 = u4:AddBone({
        Name = "TopRoot",
        Virtual = false,
        CFrame = CFrame.new(Vector3.new(0, -0.068, 0))
    });
    u7.TopRoot = Vector3.new(0, -0.068, 0);
    local Vector3_new_ret = Vector3.new(0, -0.068 + (v5 - -0.068) * 0.52, 0);
    local v15 = {
        Name = "TopMid",
        Virtual = false,
        CFrame = CFrame.new(Vector3_new_ret)
    };

    if v14 then
        v15.ParentId = v14;
    end;

    local v16 = u4:AddBone(v15);
    u7.TopMid = Vector3_new_ret;
    local Vector3_new_ret2 = Vector3.new(0, v5, 0);
    local v17 = {
        Name = "TopTip",
        Virtual = false,
        CFrame = CFrame.new(Vector3_new_ret2)
    };

    if v16 then
        v17.ParentId = v16;
    end;

    local v18 = u4:AddBone(v17);
    u7.TopTip = Vector3_new_ret2;
    local v19 = {};

    for i = 1, 8 do
        local v20 = (i - 1) / 8 * 3.141592653589793 * 2;
        local math_cos_ret = math.cos(v20);
        local math_sin_ret = math.sin(v20);
        local Vector3_new_ret3 = Vector3.new(math_cos_ret, 0, math_sin_ret);
        local v21 = Vector3_new_ret3 * 0.205 + Vector3.new(0, -0.074, 0);
        local v22 = Vector3_new_ret3 * ((math_max_ret + 0.205) * 0.55) + Vector3.new(0, -0.074, 0);
        local v23 = Vector3_new_ret3 * math_max_ret + Vector3.new(0, -0.074, 0);
        local string_format_ret = string.format("Brim%02d", i);
        local v24 = string_format_ret .. "Root";
        local v25 = u4:AddBone({
            Virtual = false,
            Name = v24,
            CFrame = CFrame.new(v21)
        });
        u7[v24] = v21;
        local v26 = string_format_ret .. "Mid";
        local v27 = {
            Virtual = false,
            Name = v26,
            CFrame = CFrame.new(v22)
        };

        if v25 then
            v27.ParentId = v25;
        end;

        local v28 = u4:AddBone(v27);
        u7[v26] = v22;
        local v29 = string_format_ret .. "Tip";
        local v30 = {
            Virtual = false,
            Name = v29,
            CFrame = CFrame.new(v23)
        };

        if v28 then
            v30.ParentId = v28;
        end;

        local v31 = u4:AddBone(v30);
        u7[v29] = v23;
        v19[i] = {
            root = v25,
            mid = v28,
            tip = v31
        };
        local _ = i;
    end;

    local function addWeight(p32, p33, p34) -- Line: 93
        if p34 > 0 then
            p32[p33] = (p32[p33] or 0) + p34;
        end;
    end;

    local function radialWeights(p35, p36) -- Line: 99
        -- upvalues: math_max_ret (copy)
        local v37 = (p36 - 0.205) / math.max(0.001, math_max_ret - 0.205);
        local math_clamp_ret = math.clamp(v37, 0, 1);

        if math_clamp_ret <= 0.5 then
            local v38 = math_clamp_ret * 2;

            return p35.root, 1 - v38, p35.mid, v38;
        end;

        local v39 = (math_clamp_ret - 0.5) * 2;

        return p35.mid, 1 - v39, p35.tip, v39;
    end;

    for _, v in Vertices do
        local Position = u4:GetPosition(v);
        local Magnitude = Vector2.new(Position.X, Position.Z).Magnitude;
        local v40 = {};

        if Position.Y > -0.074 and Magnitude <= 0.25625 then
            local v41 = (Position.Y - -0.068) / math.max(0.001, v5 - -0.068);
            local math_clamp_ret = math.clamp(v41, 0, 1);

            if math_clamp_ret <= 0.5 then
                local v42 = math_clamp_ret * 2;
                local v43 = 1 - v42;

                if v43 > 0 then
                    v40[v14] = (v40[v14] or 0) + v43;
                end;

                if v42 > 0 then
                    v40[v16] = (v40[v16] or 0) + v42;
                end;
            else
                local v44 = (math_clamp_ret - 0.5) * 2;
                local v45 = 1 - v44;

                if v45 > 0 then
                    v40[v16] = (v40[v16] or 0) + v45;
                end;

                if v44 > 0 then
                    v40[v18] = (v40[v18] or 0) + v44;
                end;
            end;
        else
            local math_atan2_ret = math.atan2(Position.Z, Position.X);

            if math_atan2_ret < 0 then
                math_atan2_ret = math_atan2_ret + 6.283185307179586;
            end;

            local v46 = math_atan2_ret / 6.283185307179586 * 8;
            local v47 = math.floor(v46) % 8 + 1;
            local v48 = v47 % 8 + 1;
            local v49 = v46 - math.floor(v46);

            if Magnitude < 0.205 then
                v40[v13] = (v40[v13] or 0) + 1;
            else
                local v50 = v19[v47];
                local v51 = (Magnitude - 0.205) / math.max(0.001, math_max_ret - 0.205);
                local math_clamp_ret = math.clamp(v51, 0, 1);
                local v52, v53, v54, v55;

                if math_clamp_ret <= 0.5 then
                    v52 = math_clamp_ret * 2;
                    v53 = v50.root;
                    v54 = 1 - v52;
                    v55 = v50.mid;
                else
                    v52 = (math_clamp_ret - 0.5) * 2;
                    v53 = v50.mid;
                    v54 = 1 - v52;
                    v55 = v50.tip;
                end;

                local v56 = v19[v48];
                local v57 = (Magnitude - 0.205) / math.max(0.001, math_max_ret - 0.205);
                local math_clamp_ret2 = math.clamp(v57, 0, 1);
                local v58, v59, v60, v61;

                if math_clamp_ret2 <= 0.5 then
                    v58 = math_clamp_ret2 * 2;
                    v59 = v56.root;
                    v60 = 1 - v58;
                    v61 = v56.mid;
                else
                    v58 = (math_clamp_ret2 - 0.5) * 2;
                    v59 = v56.mid;
                    v60 = 1 - v58;
                    v61 = v56.tip;
                end;

                local v62 = v54 * (1 - v49);

                if v62 > 0 then
                    v40[v53] = (v40[v53] or 0) + v62;
                end;

                local v63 = v52 * (1 - v49);

                if v63 > 0 then
                    v40[v55] = (v40[v55] or 0) + v63;
                end;

                local v64 = v60 * v49;

                if v64 > 0 then
                    v40[v59] = (v40[v59] or 0) + v64;
                end;

                local v65 = v58 * v49;

                if v65 > 0 then
                    v40[v61] = (v40[v61] or 0) + v65;
                end;
            end;
        end;

        local v66 = v;
        local v67 = 0;
        local v68 = {};
        local v69 = {};

        for _, v2 in v40 do
            v67 = v67 + v2;
        end;

        if v67 <= 0 then
            v68[1] = v13;
            v69[1] = 1;
        else
            for i, v2 in v40 do
                table.insert(v68, i);
                table.insert(v69, v2 / v67);
            end;
        end;

        u4:SetVertexBones(v66, v68);
        u4:SetVertexBoneWeights(v66, v69);
    end;

    local u70 = AssetService:CreateMeshPartAsync(Content.fromObject(u4), {
        CollisionFidelity = Enum.CollisionFidelity.Hull
    });
    u70.Name = "Chapeu_SmartBone";
    u70.CFrame = u3.CFrame;
    u70.Anchored = true;
    u70.CanCollide = false;
    u70.CanTouch = false;
    u70.CanQuery = false;
    u70.Massless = true;
    u70:SetAttribute("SmartBoneGenerated", true);
    u70:SetAttribute(
        "Roots",
        "TopRoot,Brim01Root,Brim02Root,Brim03Root,Brim04Root,Brim05Root,Brim06Root,Brim07Root,Brim08Root"
    );
    u70:SetAttribute("AnchorDepth", 0);
    u70:SetAttribute("Damping", 0.38);
    u70:SetAttribute("Stiffness", 0.72);
    u70:SetAttribute("Inertia", 0.62);
    u70:SetAttribute("Elasticity", 0.18);
    u70:SetAttribute("Gravity", Vector3.new(0, -0.08, 0));
    u70:SetAttribute("WindInfluence", 0.08);
    u70:SetAttribute("UpdateRate", 60);
    u70:SetAttribute("ActivationDistance", 120);
    u70:SetAttribute("ThrottleDistance", 70);
    copyAppearance(u3, u70);
    local u71 = {};

    local function createBone(p72, p73) -- Line: 208
        -- upvalues: u71 (copy), u70 (copy), u7 (copy)
        local Bone = Instance.new("Bone");
        Bone.Name = p72;
        local v74 = p73 and u71[p73] or u70;
        Bone.CFrame = CFrame.new(u7[p72] - (p73 and u7[p73] or Vector3.new(0, 0, 0)));
        Bone.Parent = v74;
        u71[p72] = Bone;
    end;

    local Bone = Instance.new("Bone");
    Bone.Name = "HatStatic";
    Bone.CFrame = CFrame.new(u7.HatStatic - Vector3.new(0, 0, 0));
    Bone.Parent = u70;
    u71.HatStatic = Bone;
    local Bone2 = Instance.new("Bone");
    Bone2.Name = "TopRoot";
    Bone2.CFrame = CFrame.new(u7.TopRoot - Vector3.new(0, 0, 0));
    Bone2.Parent = u70;
    u71.TopRoot = Bone2;
    local Bone3 = Instance.new("Bone");
    Bone3.Name = "TopMid";
    local v75 = u71.TopRoot or u70;
    Bone3.CFrame = CFrame.new(u7.TopMid - (u7.TopRoot or Vector3.new(0, 0, 0)));
    Bone3.Parent = v75;
    u71.TopMid = Bone3;
    local Bone4 = Instance.new("Bone");
    Bone4.Name = "TopTip";
    local v76 = u71.TopMid or u70;
    Bone4.CFrame = CFrame.new(u7.TopTip - (u7.TopMid or Vector3.new(0, 0, 0)));
    Bone4.Parent = v76;
    u71.TopTip = Bone4;

    for i = 1, 8 do
        local string_format_ret = string.format("Brim%02d", i);
        local v77 = string_format_ret .. "Root";
        local Bone5 = Instance.new("Bone");
        Bone5.Name = v77;
        Bone5.CFrame = CFrame.new(u7[v77] - Vector3.new(0, 0, 0));
        Bone5.Parent = u70;
        u71[v77] = Bone5;
        local v78 = string_format_ret .. "Mid";
        local v79 = string_format_ret .. "Root";
        local Bone6 = Instance.new("Bone");
        Bone6.Name = v78;
        local v80;

        if v79 then
            v80 = u71[v79] or u70;
        else
            v80 = u70;
        end;

        Bone6.CFrame = CFrame.new(u7[v78] - (v79 and (u7[v79] or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0)));
        Bone6.Parent = v80;
        u71[v78] = Bone6;
        local v81 = string_format_ret .. "Tip";
        local v82 = string_format_ret .. "Mid";
        local Bone7 = Instance.new("Bone");
        Bone7.Name = v81;
        local v83;

        if v82 then
            v83 = u71[v82] or u70;
        else
            v83 = u70;
        end;

        Bone7.CFrame = CFrame.new(u7[v81] - (v82 and (u7[v82] or Vector3.new(0, 0, 0)) or Vector3.new(0, 0, 0)));
        Bone7.Parent = v83;
        u71[v81] = Bone7;
        local _ = i;
    end;

    u70.Parent = workspace;
    CollectionService:AddTag(u70, "SmartBone");
    u3.LocalTransparencyModifier = 1;
    local u84 = nil;
    u84 = RunService.PreRender:Connect(function() -- Line: 235
        -- upvalues: u3 (copy), u70 (copy), u84 (ref)
        if u3.Parent and u70.Parent then
            u70.CFrame = u3.CFrame;

            return;
        end;

        u84:Disconnect();

        if u70.Parent then
            u70:Destroy();
        end;
    end);

    return u70;
end;

local function trySetupSource(p85) -- Line: 249
    -- upvalues: buildSmartBoneHat (copy)
    if not p85 or p85.Name ~= "Chapeu" then
        return false;
    end;

    if not p85:IsA("MeshPart") then
        return false;
    end;

    local success, result = pcall(buildSmartBoneHat, p85);

    if not success then
        warn("[ChapeuSmartBoneSetup] " .. tostring(result));
    end;

    return success;
end;

local Chapeu = workspace:FindFirstChild("Chapeu");

if Chapeu then
    if Chapeu then
        if Chapeu.Name ~= "Chapeu" then
            return;
        end;

        if not Chapeu:IsA("MeshPart") then
            return;
        end;

        local success, result = pcall(buildSmartBoneHat, Chapeu);

        if not success then
            warn("[ChapeuSmartBoneSetup] " .. tostring(result));
        end;
    end;
else
    local u86 = nil;
    u86 = workspace.ChildAdded:Connect(function(p87) -- Line: 269
        -- upvalues: u86 (ref), buildSmartBoneHat (copy)
        if p87.Name == "Chapeu" then
            u86:Disconnect();

            if p87 then
                if p87.Name ~= "Chapeu" then
                    return;
                end;

                if not p87:IsA("MeshPart") then
                    return;
                end;

                local success, result = pcall(buildSmartBoneHat, p87);

                if not success then
                    warn("[ChapeuSmartBoneSetup] " .. tostring(result));
                end;
            end;
        end;
    end);
end;