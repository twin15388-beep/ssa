-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {};
local u3 = {
    { "Draw Internal Bone", "Draws a sphere with the specified radius of the bone around where SmartBone believes the bone is.", "DRAW_BONE" },
    { "Draw Physical Bone", "Draws the actual bone objects CFrame with axis arrows.", "DRAW_PHYSICAL_BONE" },
    { "Draw Root Part", "Draws a bounding box and fills in the root part.", "DRAW_ROOT_PART" },
    { "Draw Bounding Box", "Draws the bounding box used for frustum culling.", "DRAW_BOUNDING_BOX" },
    { "Draw Axis Limits", "Draws the axis limits for each bone.", "DRAW_AXIS_LIMITS" },
    { "Draw Rotation Limits", "Draws the rotation limits for each bone.", "DRAW_ROTATION_LIMITS" },
    { "Draw Acceleration Info", "Draws the acceleration and the required values to derive it.", "DRAW_ACCELERATION_INFO" },
    { "Draw Colliders", "Draws all the colliders this root object can collide with.", "DRAW_COLLIDERS" },
    { "Draw Collider Influence", "Shows the sphere of influence around each collider.", "DRAW_COLLIDER_INFLUENCE" },
    { "Draw Collider Awake", "Shows if a collider is awake or asleep.", "DRAW_COLLIDER_AWAKE" },
    { "Draw Collider BroadPhase", "Shows if a collider isn\'t reaching NarrowPhase.", "DRAW_COLLIDER_BROADPHASE" },
    { "Draw Fill Colliders", "Fills all colliders this root object can collide with.", "DRAW_FILL_COLLIDERS" },
    { "Draw Contacts", "Draws the position and normal of the points which bones collide with colliders.", "DRAW_CONTACTS" }
};

local function infoText(p4, p5) -- Line: 25
    p4.PushConfig({
        TextColor = p4._config.TextDisabledColor
    });
    p4.Text({ p5 });
    p4.PopConfig();
end;

local function helpMarker(p6, p7) -- Line: 31
    p6.PushConfig({
        TextColor = p6._config.TextDisabledColor
    });
    local v8 = p6.Text({ "(?)" });
    p6.PopConfig();
    p6.PushConfig({
        ContentWidth = UDim.new(0, 350)
    });

    if v8.hovered() then
        p6.Tooltip({ p7 });
    end;

    p6.PopConfig();
end;

local function BoneEditor(p9, p10) -- Line: 43
    -- upvalues: u1 (copy)
    local v11 = p9.Window({ (`Editing bone: {p10.Bone.Name}`) });
    v11.isOpened.value = true;
    p10.Radius = p9.InputNum({ "Radius", 0.1, 0, (1 / 0), "%.3f" }, {
        number = p10.Radius
    }).number.value;
    p10.RotationLimit = p9.InputNum({ "Rotation Limit", 0.1, 0, 180, "%.3f" }, {
        number = p10.RotationLimit
    }).number.value;
    p10.Anchored = p9.Checkbox({ "Anchored" }, {
        isChecked = p10.Anchored
    }).isChecked.value;
    p9.Text("Axis Lock");
    p9.Indent();
    p9.SameLine();
    p9.Text("X: ");
    local v12 = p9.Checkbox({ "" }, {
        isChecked = p10.AxisLocked[1]
    });
    p9.Text("Y: ");
    local v13 = p9.Checkbox({ "" }, {
        isChecked = p10.AxisLocked[2]
    });
    p9.Text("Z: ");
    local v14 = p9.Checkbox({ "" }, {
        isChecked = p10.AxisLocked[3]
    });
    p9.End();
    p9.End();
    local v15 = p9.State(Vector2.new(p10.XAxisLimits.Min, p10.XAxisLimits.Max));
    local v16 = p9.State(Vector2.new(p10.YAxisLimits.Min, p10.YAxisLimits.Max));
    local v17 = p9.State(Vector2.new(p10.ZAxisLimits.Min, p10.ZAxisLimits.Max));
    p9.Text("Axis Limits");
    p9.Indent();
    p9.DragVector2({ "X Axis Limit", 0.05, nil, nil, { "Min: %.2f", "Max: %.2f" } }, {
        number = v15
    });
    p9.DragVector2({ "Y Axis Limit", 0.05, nil, nil, { "Min: %.2f", "Max: %.2f" } }, {
        number = v16
    });
    p9.DragVector2({ "Z Axis Limit", 0.05, nil, nil, { "Min: %.2f", "Max: %.2f" } }, {
        number = v17
    });
    p9.End();
    p9.End();
    p10.AxisLocked[1] = v12.isChecked.value;
    p10.AxisLocked[2] = v13.isChecked.value;
    p10.AxisLocked[3] = v14.isChecked.value;
    p10.XAxisLimits = NumberRange.new(v15:get().X, v15:get().Y);
    p10.YAxisLimits = NumberRange.new(v16:get().X, v16:get().Y);
    p10.ZAxisLimits = NumberRange.new(v17:get().X, v17:get().Y);

    if v11.closed() then
        u1[p10] = nil;
    end;
end;

local function ColliderEditor(p18, p19) -- Line: 98
    -- upvalues: u2 (copy)
    local v20 = p18.Window({ (`Editing collider of type: {p19.Type}`) });
    v20.isOpened.value = true;
    local v21 = p18.State(p19.Type);
    local v22 = p18.State(p19.Scale);
    local v23 = p18.State(p19.Offset);
    local v24 = p18.State(p19.Rotation);
    p18.Combo({ "Collider Type" }, {
        index = v21
    });
    p18.Selectable({ "Box", "Box" }, {
        index = v21
    });
    p18.Selectable({ "Sphere", "Sphere" }, {
        index = v21
    });
    p18.Selectable({ "Capsule", "Capsule" }, {
        index = v21
    });
    p18.End();
    p18.DragVector3({ "Scale", 0.1, 0, nil }, {
        number = v22
    });
    p18.DragVector3({ "Offset", 0.1, nil, nil }, {
        number = v23
    });
    p18.DragVector3({ "Rotation", 0.5, -180, 180 }, {
        number = v24
    });
    p19.Type = v21:get();
    p19.Scale = v22:get();
    p19.Offset = v23:get();
    p19.Rotation = v24:get();
    p18.End();

    if v20.closed() then
        u2[p19] = nil;
    end;
end;

return function(p25, p26, p27) -- Line: 129
    -- upvalues: u1 (copy), BoneEditor (copy), u2 (copy), ColliderEditor (copy), u3 (copy), helpMarker (copy), infoText (copy)
    local v28 = {};

    for _, v in p26.BoneTrees do
        local RootPart = v.RootPart;
        local v29 = v28[RootPart];

        if not v29 then
            v28[RootPart] = {};
            v29 = v28[RootPart];
        end;

        table.insert(v29, v);
    end;

    for i, _ in u1 do
        local v30 = `{p26.ID} - {i.ParentIndex + 1}`;
        p25.PushId(v30);
        BoneEditor(p25, i);
        p25.PopId();
    end;

    for i, _ in u2 do
        p25.PushId(i.GUID);
        ColliderEditor(p25, i);
        p25.PopId();
    end;

    local v31 = #p26.BoneTrees;
    local v32 = #p26.ColliderObjects;
    local v33 = `{v31} BoneTree{v31 == 1 and "" or "s"}`;
    local v34 = `{v32} Collider{v32 == 1 and "" or "s"}`;
    p25.Window({
        `SmartBone Runtime Editor. {v33}, {v34}`,
        [p25.Args.Window.NoClose] = true
    });
    p25.Tree({ "Debug Gizmos", true }, {
        isUncollapsed = true
    });

    for _, v in u3 do
        p25.SameLine();
        p25.Checkbox({ v[1] }, {
            isChecked = p27[v[3]]
        });
        helpMarker(p25, v[2]);
        p25.End();
    end;

    p25.End();
    p25.Separator();
    infoText(p25, "Simulated Objects");

    for i, v in v28 do
        p25.Tree((`{i.Name} - Root Part`));

        for i2, v2 in v do
            p25.Tree((`BoneTree #{i2}`));
            infoText(p25, (`Throttled Update Rate: {string.format("%.1f", v2.UpdateRate)} / {string.format("%.1f", v2.Settings.UpdateRate)} fps`));
            infoText(p25, (`In View: {v2.InView}`));
            local v35 = p25.State(v2.Settings.Constraint);
            local v36 = p25.State(v2.Settings.WindType);
            local v37 = p25.State(v2.Settings.UpdateRate);
            local v38 = p25.State(v2.Settings.ActivationDistance);
            local v39 = p25.State(v2.Settings.ThrottleDistance);
            p25.SameLine();
            helpMarker(p25, "The constraint used, distance is more flowy while spring is more rigid.");
            p25.Combo({ "Constraint Type" }, {
                index = v35
            });
            p25.Selectable({ "Distance", "Distance" }, {
                index = v35
            });
            p25.Selectable({ "Spring", "Spring" }, {
                index = v35
            });
            p25.End();
            p25.End();
            p25.SameLine();
            helpMarker(p25, "The wind solver used, sine is a smoother wind, noise is more chaotic and hybrid is a mix of the two.");
            p25.Combo({ "Wind Type" }, {
                index = v36
            });
            p25.Selectable({ "Sine", "Sine" }, {
                index = v36
            });
            p25.Selectable({ "Noise", "Noise" }, {
                index = v36
            });
            p25.Selectable({ "Hybrid", "Hybrid" }, {
                index = v36
            });
            p25.End();
            p25.End();
            p25.SameLine();
            helpMarker(p25, "The target update rate for the bone tree");
            p25.SliderNum({ "Update Rate", 5, 0, 120 }, {
                number = v37
            });
            p25.End();
            p25.SameLine();
            helpMarker(p25, "The distance at which the bone tree stops updating");
            p25.SliderNum({ "Activation Distance", 1, 0, 500 }, {
                number = v38
            });
            p25.End();
            p25.SameLine();
            helpMarker(p25, "The distance at which the bone tree starts throttling its update rate");
            p25.SliderNum({ "Throttle Distance", 1, 0, 500 }, {
                number = v39
            });
            p25.End();
            v2.Settings.Constraint = v35:get();
            v2.Settings.WindType = v36:get();
            v2.Settings.UpdateRate = v37:get();
            v2.Settings.ActivationDistance = v38:get();
            v2.Settings.ThrottleDistance = v39:get();
            p25.Table({ 4, false, false, false });
            p25.NextColumn();
            p25.Text("Bone #");
            p25.NextColumn();
            p25.Text("Bone Name");
            p25.NextColumn();
            p25.Text("Parent #");
            p25.NextColumn();
            p25.Text("Edit");
            p25.End();
            p25.Table({ 4 });

            for i3, v3 in v2.Bones do
                p25.NextColumn();
                p25.Text((tostring(i3)));
                p25.NextColumn();
                p25.Text(v3.Bone.Name);
                p25.NextColumn();
                p25.Text((tostring(v3.ParentIndex)));
                p25.NextColumn();
                p25.SameLine();
                p25.Text("");

                if p25.SmallButton({ "Edit" }).clicked() then
                    u1[v3] = true;
                end;

                p25.End();
            end;

            p25.End();
            p25.End();
        end;

        p25.End();
    end;

    infoText(p25, "Active Colliders");

    for _, v in p26.ColliderObjects do
        p25.Tree({ v.m_Object.Name });
        infoText(p25, "Colliders adorned to this object");
        p25.Table({ 5, false, false, false });
        p25.NextColumn();
        p25.Text("Type");
        p25.NextColumn();
        p25.Text("Scale");
        p25.NextColumn();
        p25.Text("Offset");
        p25.NextColumn();
        p25.Text("Rotation");
        p25.NextColumn();
        p25.Text("Edit");
        p25.End();
        p25.Table({ 5 });

        for _, v2 in v.Colliders do
            p25.NextColumn();
            p25.Text((tostring(v2.Type)));
            p25.NextColumn();
            p25.Text((tostring(v2.Scale)));
            p25.NextColumn();
            p25.Text((tostring(v2.Offset)));
            p25.NextColumn();
            p25.Text((tostring(v2.Rotation)));
            p25.NextColumn();
            p25.SameLine();
            p25.Text("");

            if p25.SmallButton({ "Edit" }).clicked() then
                u2[v2] = true;
            end;

            p25.End();
        end;

        p25.End();
        p25.End();
    end;

    p25.End();
end;