-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2: number?) -- Line: 6
    -- upvalues: u1 (copy)
    return setmetatable({
        _voxelSize = p2 or 50,
        _voxels = {}
    }, u1);
end;

function u1._debugDrawVoxel(p3: table, p4: vector) -- Line: 13
    local Part = Instance.new("Part");
    Part.Name = tostring(p4);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(1, 1, 1) * p3._voxelSize;
    Part.Position = p4 * p3._voxelSize + Vector3.new(1, 1, 1) * (p3._voxelSize / 2);
    Part.Parent = workspace;
    local SelectionBox = Instance.new("SelectionBox");
    SelectionBox.Color3 = Color3.new(0, 0, 1);
    SelectionBox.Adornee = Part;
    SelectionBox.Parent = Part;
    task.delay(0.03333333333333333, Part.Destroy, Part);
end;

function u1.AddObject(p5: table, p6: vector, p7: any) -- Line: 31
    local ClassName = p7.ClassName;
    local _voxelSize = p5._voxelSize;
    local math_floor_ret = math.floor(p6.X / _voxelSize);
    local math_floor_ret2 = math.floor(p6.Y / _voxelSize);
    local math_floor_ret3 = math.floor(p6.Z / _voxelSize);
    local Vector3_new_ret = Vector3.new(math_floor_ret, math_floor_ret2, math_floor_ret3);
    local v8 = p5._voxels[Vector3_new_ret];

    if v8 == nil then
        p5._voxels[Vector3_new_ret] = {
            [ClassName] = { p7 }
        };

        return Vector3_new_ret;
    end;

    if v8[ClassName] == nil then
        v8[ClassName] = { p7 };

        return Vector3_new_ret;
    end;

    table.insert(v8[ClassName], p7);

    return Vector3_new_ret;
end;

function u1.RemoveObject(p9: table, p10: vector, p11: any) -- Line: 56
    local v12 = p9._voxels[p10];

    if v12 == nil then
        return;
    end;

    local ClassName = p11.ClassName;

    if v12[ClassName] == nil then
        return;
    end;

    local v13 = v12[ClassName];

    for i, v in v13 do
        if v == p11 then
            local v14 = #v13;
            v13[i] = v13[v14];
            v13[v14] = nil;
            break;
        end;
    end;

    if #v13 == 0 then
        v12[ClassName] = nil;

        if next(v12) == nil then
            p9._voxels[p10] = nil;
        end;
    end;
end;

function u1.GetVoxel(p15: table, p16: vector) -- Line: 90
    return p15._voxels[p16];
end;

function u1.ForEachObjectInRegion(p17: table, p18: vector, p19: vector, p20: function) -- Line: 94
    local _voxelSize = p17._voxelSize;
    local math_min_ret = math.min(p19.X, p18.X);
    local math_min_ret2 = math.min(p19.Y, p18.Y);
    local math_min_ret3 = math.min(p19.Z, p18.Z);
    local math_max_ret = math.max(p19.X, p18.X);
    local math_max_ret2 = math.max(p19.Y, p18.Y);
    local math_max_ret3 = math.max(p19.Z, p18.Z);

    for i = math.floor(math_min_ret / _voxelSize), math.floor(math_max_ret / _voxelSize) do
        local v21 = i;

        for i2 = math.floor(math_min_ret3 / _voxelSize), math.floor(math_max_ret3 / _voxelSize) do
            local v22 = i2;

            for i3 = math.floor(math_min_ret2 / _voxelSize), math.floor(math_max_ret2 / _voxelSize) do
                local v23 = p17._voxels[Vector3.new(v21, i3, v22)];
                local v24;

                if v23 then
                    v24 = i3;

                    for i4, v in v23 do
                        local v25 = i4;

                        for _, v2 in v do
                            p20(v25, v2);
                        end;
                    end;
                else
                    v24 = i3;
                end;
            end;
        end;
    end;
end;

function u1.ForEachObjectInView(p26: table, p27: userdata, p28: number, p29: function) -- Line: 117
    local _voxelSize = p26._voxelSize;
    local CFrame2 = p27.CFrame;
    local Position = CFrame2.Position;
    local RightVector = CFrame2.RightVector;
    local UpVector = CFrame2.UpVector;
    local u30 = p28 / 2;
    local math_rad_ret = math.rad((p27.FieldOfView + 5) / 2);
    local u31 = math.tan(math_rad_ret) * p28;
    local u32 = u31 * (p27.ViewportSize.X / p27.ViewportSize.Y);
    local v33 = CFrame2 * CFrame.new(0, 0, -p28);
    local v34 = v33 * Vector3.new(-u32, u31, 0);
    local v35 = v33 * Vector3.new(u32, u31, 0);
    local v36 = v33 * Vector3.new(-u32, -u31, 0);
    local v37 = v33 * Vector3.new(u32, -u31, 0);
    local u38 = (CFrame2 * CFrame.new(0, 0, -u30)):Inverse();
    local Unit = UpVector:Cross(v37 - Position).Unit;
    local Unit2 = UpVector:Cross(v36 - Position).Unit;
    local Unit3 = RightVector:Cross(Position - v35).Unit;
    local Unit4 = RightVector:Cross(Position - v37).Unit;
    local v39 = Position:Min(v34):Min(v35):Min(v36):Min(v37);
    local v40 = Position:Max(v34):Max(v35):Max(v36):Max(v37);
    local math_floor_ret = math.floor(v39.X / _voxelSize);
    local math_floor_ret2 = math.floor(v39.Y / _voxelSize);
    local math_floor_ret3 = math.floor(v39.Z / _voxelSize);
    local Vector3_new_ret = Vector3.new(math_floor_ret, math_floor_ret2, math_floor_ret3);
    local math_floor_ret4 = math.floor(v40.X / _voxelSize);
    local math_floor_ret5 = math.floor(v40.Y / _voxelSize);
    local math_floor_ret6 = math.floor(v40.Z / _voxelSize);
    local Vector3_new_ret2 = Vector3.new(math_floor_ret4, math_floor_ret5, math_floor_ret6);

    local function isPointInView(p41: vector) -- Line: 155
        -- upvalues: u38 (copy), u32 (copy), u31 (copy), u30 (copy), Position (copy), Unit (copy), Unit2 (copy), Unit3 (copy), Unit4 (copy)
        local v42 = u38 * p41;

        if u32 < v42.X or (v42.X < -u32 or (u31 < v42.Y or (v42.Y < -u31 or (u30 < v42.Z or v42.Z < -u30)))) then
            return false;
        end;

        local v43 = p41 - Position;

        return Unit:Dot(v43) >= 0 and (Unit2:Dot(v43) <= 0 and (Unit3:Dot(v43) >= 0 and Unit4:Dot(v43) <= 0));
    end;

    for i = Vector3_new_ret.X, Vector3_new_ret2.X do
        local v44 = i * _voxelSize;
        local math_clamp_ret = math.clamp(v33.X, v44, v44 + _voxelSize);
        local v45 = i;

        for i2 = Vector3_new_ret.Y, Vector3_new_ret2.Y do
            local v46 = i2 * _voxelSize;
            local math_clamp_ret2 = math.clamp(v33.Y, v46, v46 + _voxelSize);
            local v47 = i2;

            for i3 = Vector3_new_ret.Z, Vector3_new_ret2.Z do
                local v48 = i3 * _voxelSize;
                local math_clamp_ret3 = math.clamp(v33.Z, v48, v48 + _voxelSize);

                if isPointInView((Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3))) then
                    local v49 = Vector3_new_ret.Z - 1;
                    local Z = Vector3_new_ret2.Z;
                    local v50 = i3;
                    local v51 = v50;
                    local v52 = v50;
                    v50 = v51;
                    v52 = v51;

                    while v51 <= Z do
                        local math_floor_ret7 = math.floor((v51 + Z) / 2);
                        local math_clamp_ret4 = math.clamp(v33.Z, math_floor_ret7 * _voxelSize, math_floor_ret7 * _voxelSize + _voxelSize);

                        if isPointInView((Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret4))) then
                            v51 = math_floor_ret7 + 1;
                        else
                            Z = math_floor_ret7 - 1;
                            math_floor_ret7 = v49;
                        end;

                        v49 = math_floor_ret7;
                    end;

                    for i4 = v50, v49 do
                        local v53 = p26._voxels[Vector3.new(v45, v47, i4)];
                        local v54;

                        if v53 then
                            v54 = i4;

                            for i5, v in v53 do
                                local v55 = i5;

                                for _, v2 in v do
                                    p29(v55, v2);
                                end;
                            end;
                        else
                            v54 = i4;
                        end;
                    end;

                    break;
                end;

                local _ = i3;
            end;
        end;
    end;
end;

function u1.ClearAll(p56) -- Line: 238
    p56._voxels = {};
end;

return u1;