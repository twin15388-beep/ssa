-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local script_Settings = require(script.Settings);
local script_VectorMap = require(script.VectorMap);
local BindableEvent = Instance.new("BindableEvent");
local BindableEvent2 = Instance.new("BindableEvent");
local BindableEvent3 = Instance.new("BindableEvent");
local BindableEvent4 = Instance.new("BindableEvent");
local BindableEvent5 = Instance.new("BindableEvent");

return {
    RenderDistance = 150,
    MaxRefreshRate = 0.016666666666666666,
    Handled = 0,
    Active = 0,
    SharedSettings = script_Settings.new(script),
    ObjectMetadata = {},
    VectorMap = script_VectorMap.new(),
    _partList = table.create(500),
    _cframeList = table.create(500),
    ObjectShakeAdded = BindableEvent.Event,
    ObjectShakeRemoved = BindableEvent2.Event,
    ObjectShakeUpdated = BindableEvent3.Event,
    Paused = BindableEvent4.Event,
    Resumed = BindableEvent5.Event,

    Connect = function(u1: table, p2: string, p3: userdata) -- Line: 62, Name: Connect
        local u4 = u1[p2];
        local v5 = typeof(u4) == "function";
        assert(v5, "Unknown function: " .. p2);

        return p3:Connect(function(...) -- Line: 66
            -- upvalues: u4 (copy), u1 (copy)
            return u4(u1, ...);
        end);
    end,

    AddObjectShake = function(p6: table, p7: userdata, p8: table?) -- Line: 71, Name: AddObjectShake
        -- upvalues: script_Settings (copy), BindableEvent (copy)
        if typeof(p7) ~= "Instance" then
            return;
        end;

        if not (p7:IsA("BasePart") or p7:IsA("Bone")) then
            return;
        end;

        local ObjectMetadata = p6.ObjectMetadata;

        if ObjectMetadata[p7] then
            return;
        end;

        p6.Handled = p6.Handled + 1;
        local v9 = {};
        local VectorMap = p6.VectorMap;
        local v10;

        if p7:IsA("Bone") then
            v10 = p7.WorldPosition;
        else
            v10 = p7.Position;
        end;

        v9.ChunkKey = VectorMap:AddObject(v10, p7);
        v9.Settings = script_Settings.new(p7);
        v9.Seed = math.random(5000) * 0.32;
        local v11;

        if p7:IsA("Bone") then
            v11 = p7.WorldCFrame;
        else
            v11 = p7.CFrame;
        end;

        v9.Origin = v11;
        v9.LastUpdate = os.clock();
        ObjectMetadata[p7] = v9;

        if p8 then
            p6:UpdateObjectSettings(p7, p8);
        end;

        BindableEvent:Fire(p7);
    end,

    RemoveObjectShake = function(p12: table, p13: userdata) -- Line: 107, Name: RemoveObjectShake
        -- upvalues: BindableEvent2 (copy)
        if typeof(p13) ~= "Instance" then
            return;
        end;

        local ObjectMetadata = p12.ObjectMetadata;
        local v14 = ObjectMetadata[p13];

        if v14 then
            p12.Handled = p12.Handled - 1;
            ObjectMetadata[p13] = nil;
            v14.Settings:Destroy();
            p12.VectorMap:RemoveObject(v14.ChunkKey, p13);

            if p13:IsA("BasePart") then
                p13.CFrame = v14.Origin;
            elseif p13:IsA("Bone") then
                p13.WorldCFrame = v14.Origin;
            end;
        end;

        BindableEvent2:Fire(p13);
    end,

    Update = function(p15: table, p16: number) -- Line: 131, Name: Update
        debug.profilebegin("WindShake");
        local u17 = 0;
        debug.profilebegin("Update");
        local os_clock_ret = os.clock();
        local u18 = p16 * 3;
        local math_min_ret = math.min(1, p16 * 5);
        local u19 = 0;
        local _partList = p15._partList;
        local _cframeList = p15._cframeList;
        table.clear(_partList);
        table.clear(_cframeList);
        local ObjectMetadata = p15.ObjectMetadata;
        local workspace_CurrentCamera = workspace.CurrentCamera;
        local Position = workspace_CurrentCamera.CFrame.Position;
        local RenderDistance = p15.RenderDistance;
        local MaxRefreshRate = p15.MaxRefreshRate;
        local SharedSettings = p15.SharedSettings;
        local WindPower = SharedSettings.WindPower;
        local WindSpeed = SharedSettings.WindSpeed;
        local WindDirection = SharedSettings.WindDirection;
        p15.VectorMap:ForEachObjectInView(workspace_CurrentCamera, RenderDistance, function(p20: string, p21: userdata) -- Line: 161
            -- upvalues: ObjectMetadata (copy), Position (copy), RenderDistance (copy), u18 (copy), MaxRefreshRate (copy), os_clock_ret (copy), u17 (ref), WindDirection (copy), WindPower (copy), WindSpeed (copy), math_min_ret (copy), u19 (ref), _partList (copy), _cframeList (copy)
            local v22 = ObjectMetadata[p21];
            local v23 = v22.LastUpdate or 0;
            local v24 = p20 == "Bone";
            local v25;

            if v24 then
                v25 = p21.WorldCFrame;
            else
                v25 = p21.CFrame;
            end;

            local v26 = (Position - v25.Position).Magnitude / RenderDistance;
            local v27 = v26 * v26;
            local v28 = 1 / math.random(60, 120);

            if u18 * v27 + MaxRefreshRate >= os_clock_ret - v23 + v28 then
                return;
            end;

            v22.LastUpdate = os_clock_ret;
            u17 = u17 + 1;
            local Settings = v22.Settings;
            local v29 = Settings.WindDirection or WindDirection;

            if v29.Magnitude < 0.00001 then
                return;
            end;

            local v30 = (Settings.WindPower or WindPower) * 0.2;

            if v30 < 0.00001 then
                return;
            end;

            local v31 = os_clock_ret * ((Settings.WindSpeed or WindSpeed) * 0.08);

            if v31 < 0.00001 then
                return;
            end;

            local Seed = v22.Seed;
            local v32 = (math.noise(v31, 0, Seed) + 0.4) * v30;
            local math_clamp_ret = math.clamp(math_min_ret + v27, 0.1, 0.5);
            local v33 = v30 / 3;
            local v34 = v22.Origin * (Settings.PivotOffset or CFrame.identity);
            local v35 = v34:VectorToObjectSpace(v29);

            if v24 then
                p21.Transform = p21.Transform:Lerp(CFrame.fromAxisAngle(v35:Cross(Vector3.new(0, 1, 0)), -v32) * CFrame.Angles(math.noise(Seed, 0, v31) * v33, math.noise(Seed, v31, 0) * v33, math.noise(v31, Seed, 0) * v33) + v35 * v32 * v30, math_clamp_ret);

                return;
            end;

            u19 = u19 + 1;
            _partList[u19] = p21;
            _cframeList[u19] = v25:Lerp(v34 * CFrame.fromAxisAngle(v35:Cross(Vector3.new(0, 1, 0)), -v32) * CFrame.Angles(math.noise(Seed, 0, v31) * v33, math.noise(Seed, v31, 0) * v33, math.noise(v31, Seed, 0) * v33) * (Settings.PivotOffsetInverse or CFrame.identity) + v29 * v32 * (v30 * 2), math_clamp_ret);
        end);
        p15.Active = u17;
        debug.profileend();
        workspace:BulkMoveTo(_partList, _cframeList, Enum.BulkMoveMode.FireCFrameChanged);
        debug.profileend();
    end,

    Pause = function(p36) -- Line: 247, Name: Pause
        -- upvalues: BindableEvent4 (copy)
        if p36.UpdateConnection then
            p36.UpdateConnection:Disconnect();
            p36.UpdateConnection = nil;
        end;

        p36.Active = 0;
        p36.Running = false;
        BindableEvent4:Fire();
    end,

    Resume = function(p37) -- Line: 259, Name: Resume
        -- upvalues: RunService (copy), BindableEvent5 (copy)
        if p37.Running then
            return;
        end;

        p37.Running = true;
        p37.UpdateConnection = p37:Connect("Update", RunService.Heartbeat);
        BindableEvent5:Fire();
    end,

    Init = function(u38: table, p39: table) -- Line: 272, Name: Init
        -- upvalues: CollectionService (copy)
        if u38.Initialized then
            return;
        end;

        local Attribute = script:GetAttribute("WindPower");
        local Attribute2 = script:GetAttribute("WindSpeed");
        local Attribute3 = script:GetAttribute("WindDirection");

        if typeof(Attribute) ~= "number" then
            script:SetAttribute("WindPower", 0.5);
        end;

        if typeof(Attribute2) ~= "number" then
            script:SetAttribute("WindSpeed", 20);
        end;

        if typeof(Attribute3) ~= "Vector3" then
            script:SetAttribute("WindDirection", Vector3.new(0.5, 0, 0.5));
        end;

        u38:Cleanup();
        u38.Initialized = true;
        u38.AddedConnection = u38:Connect("AddObjectShake", (CollectionService:GetInstanceAddedSignal("WindShake")));
        u38.RemovedConnection = u38:Connect("RemoveObjectShake", (CollectionService:GetInstanceRemovedSignal("WindShake")));

        for _, v in CollectionService:GetTagged("WindShake") do
            u38:AddObjectShake(v);
        end;

        if p39 and p39.MatchWorkspaceWind then
            u38:MatchWorkspaceWind();
            u38.WorkspaceWindConnection = workspace:GetPropertyChangedSignal("GlobalWind"):Connect(function() -- Line: 312
                -- upvalues: u38 (copy)
                u38:MatchWorkspaceWind();
            end);
        end;

        u38:Resume();
    end,

    Cleanup = function(p40) -- Line: 321, Name: Cleanup
        if not p40.Initialized then
            return;
        end;

        p40:Pause();

        if p40.AddedConnection then
            p40.AddedConnection:Disconnect();
            p40.AddedConnection = nil;
        end;

        if p40.RemovedConnection then
            p40.RemovedConnection:Disconnect();
            p40.RemovedConnection = nil;
        end;

        if p40.WorkspaceWindConnection then
            p40.WorkspaceWindConnection:Disconnect();
            p40.WorkspaceWindConnection = nil;
        end;

        table.clear(p40.ObjectMetadata);
        p40.VectorMap:ClearAll();
        p40.Handled = 0;
        p40.Active = 0;
        p40.Initialized = false;
    end,

    UpdateObjectSettings = function(p41: table, p42: userdata, p43: table) -- Line: 351, Name: UpdateObjectSettings
        -- upvalues: BindableEvent3 (copy)
        if typeof(p42) ~= "Instance" then
            return;
        end;

        if typeof(p43) ~= "table" then
            return;
        end;

        if not p41.ObjectMetadata[p42] and p42 ~= script then
            return;
        end;

        for i, v in p43 do
            p42:SetAttribute(i, v);
        end;

        BindableEvent3:Fire(p42);
    end,

    UpdateAllObjectSettings = function(p44: table, p45: table) -- Line: 371, Name: UpdateAllObjectSettings
        -- upvalues: BindableEvent3 (copy)
        if typeof(p45) ~= "table" then
            return;
        end;

        for i, _ in p44.ObjectMetadata do
            local v46 = i;

            for i2, v in p45 do
                v46:SetAttribute(i2, v);
            end;

            BindableEvent3:Fire(v46);
        end;
    end,

    SetDefaultSettings = function(p47: table, p48: table) -- Line: 384, Name: SetDefaultSettings
        p47:UpdateObjectSettings(script, p48);
    end,

    MatchWorkspaceWind = function(p49) -- Line: 388, Name: MatchWorkspaceWind
        local workspace_GlobalWind = workspace.GlobalWind;
        local Unit = workspace_GlobalWind.Unit;
        local Magnitude = workspace_GlobalWind.Magnitude;
        local v50, v51;

        if Magnitude > 0 then
            v50 = Magnitude <= 1 and 0.3 or math.log10(Magnitude) + 0.2;

            if Magnitude < 100 then
                v51 = Magnitude * 1.2 + 5;
            else
                v51 = 125;
            end;
        else
            v51 = 0;
            v50 = 0;
        end;

        p49:SetDefaultSettings({
            WindDirection = Unit,
            WindSpeed = v51,
            WindPower = v50
        });
    end
};