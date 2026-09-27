-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);

return function(u1) -- Line: 3
    local u2 = {
        _started = false,
        _cycleTick = 0,
        _globalRefreshRequested = false,
        _localRefreshActive = false,
        _widgets = {},
        _widgetCount = 0,
        _stackIndex = 1,
        _rootInstance = nil
    };
    u2._rootWidget = {
        ID = "R",
        type = "Root",
        ZIndex = 0,
        Instance = u2._rootInstance
    };
    u2._lastWidget = u2._rootWidget;
    u2._rootConfig = {};
    u2._config = u2._rootConfig;
    u2._IDStack = { "R" };
    u2._usedIDs = {};
    u2._pushedId = nil;
    u2._nextWidgetId = nil;
    u2._states = {};
    u2._postCycleCallbacks = {};
    u2._connectedFunctions = {};
    u2._cycleCoroutine = coroutine.create(function() -- Line: 49
        -- upvalues: u2 (copy)
        while true do
            for _, v in u2._connectedFunctions do
                local success, result = pcall(v);

                if not success then
                    u2._stackIndex = 1;
                    coroutine.yield(false, result);
                end;

                if u2._stackIndex ~= 1 then
                    u2._stackIndex = 1;
                    error("Callback has too few calls to Iris.End()", 0);
                end;
            end;

            coroutine.yield(true);
        end;
    end);
    local v3 = {};
    v3.__index = v3;

    function v3.get(p4) -- Line: 80
        return p4.value;
    end;

    function v3.set(p5, p6) -- Line: 84
        -- upvalues: u2 (copy)
        if p6 == p5.value then
            return p5.value;
        end;

        p5.value = p6;

        for _, v in p5.ConnectedWidgets do
            u2._widgets[v.type].UpdateState(v);
        end;

        for _, v in p5.ConnectedFunctions do
            v(p6);
        end;

        return p5.value;
    end;

    function v3.onChange(p7: table, p8: function) -- Line: 99
        table.insert(p7.ConnectedFunctions, p8);
    end;

    u2.StateClass = v3;

    function u2._cycle() -- Line: 111
        -- upvalues: u1 (copy), u2 (copy)
        if u1.Disabled then
            return;
        end;

        u2._rootWidget.lastCycleTick = u2._cycleTick;

        if u2._rootInstance == nil or u2._rootInstance.Parent == nil then
            u1.ForceRefresh();
        end;

        for _, v in u2._lastVDOM do
            if v.lastCycleTick ~= u2._cycleTick then
                u2._DiscardWidget(v);
            end;
        end;

        u2._lastVDOM = u2._VDOM;
        u2._VDOM = u2._generateEmptyVDOM();
        task.spawn(function() -- Line: 135
            -- upvalues: u2 (ref)
            for _, v in u2._postCycleCallbacks do
                v();
            end;
        end);

        if u2._globalRefreshRequested then
            u2._generateSelectionImageObject();
            u2._globalRefreshRequested = false;

            for _, v in u2._lastVDOM do
                u2._DiscardWidget(v);
            end;

            u2._generateRootInstance();
            u2._lastVDOM = u2._generateEmptyVDOM();
        end;

        local v9 = u2;
        v9._cycleTick = v9._cycleTick + 1;
        u2._widgetCount = 0;
        table.clear(u2._usedIDs);

        if u2.parentInstance:IsA("GuiBase2d") and math.min(u2.parentInstance.AbsoluteSize.X, u2.parentInstance.AbsoluteSize.Y) < 100 then
            error("Iris Parent Instance is too small");
        end;

        if (u2.parentInstance:IsA("GuiBase2d") or u2.parentInstance:IsA("CoreGui") or (u2.parentInstance:IsA("PluginGui") or u2.parentInstance:IsA("PlayerGui"))) == false then
            error("Iris Parent Instance cant contain GUI");
        end;

        if game:GetService("RunService"):IsStudio() then
            for _, v in u2._connectedFunctions do
                v();
            end;

            return;
        end;

        local coroutine_status_ret = coroutine.status(u2._cycleCoroutine);

        if coroutine_status_ret == "suspended" then
            local _, v10, v11 = coroutine.resume(u2._cycleCoroutine);

            if v10 == false then
                error(v11, 0);
            end;
        else
            if coroutine_status_ret == "running" then
                error("Iris cycleCoroutine took to long to yield. Connected functions should not yield.");

                return;
            end;

            error("unrecoverable state");
        end;
    end;

    function u2._NoOp() -- Line: 206
    end;

    function u2.WidgetConstructor(p12: string, p13: any) -- Line: 210
        -- upvalues: u2 (copy), u1 (copy)
        local v14 = {
            All = {
                Required = { "Generate", "Discard", "Update", "Args", "Events", "hasChildren", "hasState" },
                Optional = {}
            },
            IfState = {
                Required = { "GenerateState", "UpdateState" },
                Optional = {}
            },
            IfChildren = {
                Required = { "ChildAdded" },
                Optional = { "ChildDiscarded" }
            }
        };
        local v15 = {};

        for _, v in v14.All.Required do
            local v16 = p13[v] ~= nil;
            local v17 = `field {v} is missing from widget {p12}, it is required for all widgets`;
            assert(v16, v17);
            v15[v] = p13[v];
        end;

        for _, v in v14.All.Optional do
            if p13[v] == nil then
                v15[v] = u2._NoOp;
            else
                v15[v] = p13[v];
            end;
        end;

        if p13.hasState then
            for _, v in v14.IfState.Required do
                local v18 = p13[v] ~= nil;
                local v19 = `field {v} is missing from widget {p12}, it is required for all widgets with state`;
                assert(v18, v19);
                v15[v] = p13[v];
            end;

            for _, v in v14.IfState.Optional do
                if p13[v] == nil then
                    v15[v] = u2._NoOp;
                else
                    v15[v] = p13[v];
                end;
            end;
        end;

        if p13.hasChildren then
            for _, v in v14.IfChildren.Required do
                local v20 = p13[v] ~= nil;
                local v21 = `field {v} is missing from widget {p12}, it is required for all widgets with children`;
                assert(v20, v21);
                v15[v] = p13[v];
            end;

            for _, v in v14.IfChildren.Optional do
                if p13[v] == nil then
                    v15[v] = u2._NoOp;
                else
                    v15[v] = p13[v];
                end;
            end;
        end;

        u2._widgets[p12] = v15;
        u1.Args[p12] = v15.Args;
        local v22 = {};

        for i, v in v15.Args do
            v22[v] = i;
        end;

        v15.ArgNames = v22;

        for i, _ in v15.Events do
            if u1.Events[i] == nil then
                u1.Events[i] = function() -- Line: 301
                    -- upvalues: u2 (ref), i (copy)
                    return u2._EventCall(u2._lastWidget, i);
                end;
            end;
        end;
    end;

    function u2._Insert(p23: string, p24: any, p25: any) -- Line: 308
        -- upvalues: u2 (copy)
        local v26 = nil;
        local v27 = u2._getID(3);
        local v28 = u2._widgets[p23];
        local v29 = u2;
        v29._widgetCount = v29._widgetCount + 1;

        if u2._VDOM[v27] then
            return u2._ContinueWidget(v27, p23);
        end;

        local v30 = {};

        if p24 ~= nil then
            for i, v in type(p24) ~= "table" and { p24 } or p24 do
                v30[v28.ArgNames[i]] = v;
            end;
        end;

        table.freeze(v30);

        if u2._lastVDOM[v27] and p23 == u2._lastVDOM[v27].type then
            if u2._localRefreshActive then
                u2._DiscardWidget(u2._lastVDOM[v27]);
            else
                v26 = u2._lastVDOM[v27];
            end;
        end;

        if v26 == nil then
            v26 = u2._GenNewWidget(p23, v30, p25, v27);
        end;

        if u2._deepCompare(v26.providedArguments, v30) == false then
            v26.arguments = u2._deepCopy(v30);
            v26.providedArguments = v30;
            v28.Update(v26);
        end;

        v26.lastCycleTick = u2._cycleTick;

        if v28.hasChildren then
            local v31 = u2;
            v31._stackIndex = v31._stackIndex + 1;
            u2._IDStack[u2._stackIndex] = v26.ID;
        end;

        u2._VDOM[v27] = v26;
        u2._lastWidget = v26;

        return v26;
    end;

    function u2._GenNewWidget(p32: string, p33: any, p34: any, p35: any) -- Line: 375
        -- upvalues: u2 (copy)
        local v36 = u2._IDStack[u2._stackIndex];
        local v37 = u2._widgets[p32];
        local u38 = {};
        setmetatable(u38, u38);
        u38.ID = p35;
        u38.type = p32;
        u38.parentWidget = u2._VDOM[v36];
        u38.trackedEvents = {};
        u38.ZIndex = u38.parentWidget.ZIndex + u2._widgetCount * 64 + u2._config.ZIndexOffset;
        u38.Instance = v37.Generate(u38);
        local Instance2 = u38.Instance;
        local v39;

        if u2._config.Parent then
            v39 = u2._config.Parent;
        else
            v39 = u2._widgets[u38.parentWidget.type].ChildAdded(u38.parentWidget, u38);
        end;

        Instance2.Parent = v39;
        u38.providedArguments = p33;
        u38.arguments = u2._deepCopy(p33);
        v37.Update(u38);
        local v40;

        if v37.hasState then
            if p34 then
                for i, v in p34 do
                    if type(v) ~= "table" or getmetatable(v) ~= u2.StateClass then
                        p34[i] = u2._widgetState(u38, i, v);
                    end;
                end;

                u38.state = p34;

                for _, v in p34 do
                    v.ConnectedWidgets[u38.ID] = u38;
                end;
            else
                u38.state = {};
            end;

            v37.GenerateState(u38);
            v37.UpdateState(u38);
            u38.stateMT = {};
            setmetatable(u38.state, u38.stateMT);
            u38.__index = u38.state;
            v40 = u38.stateMT;
        else
            v40 = u38;
        end;

        function v40.__index(p41: any, u42: string) -- Line: 432
            -- upvalues: u2 (ref), u38 (copy)
            return function() -- Line: 433
                -- upvalues: u2 (ref), u38 (ref), u42 (copy)
                return u2._EventCall(u38, u42);
            end;
        end;

        return u38;
    end;

    function u2._ContinueWidget(p43: any, p44: string) -- Line: 440
        -- upvalues: u2 (copy)
        local v45 = u2._VDOM[p43];

        if u2._widgets[p44].hasChildren then
            local v46 = u2;
            v46._stackIndex = v46._stackIndex + 1;
            u2._IDStack[u2._stackIndex] = v45.ID;
        end;

        u2._lastWidget = v45;

        return v45;
    end;

    function u2._DiscardWidget(p47) -- Line: 454
        -- upvalues: u2 (copy)
        local parentWidget = p47.parentWidget;

        if parentWidget then
            u2._widgets[parentWidget.type].ChildDiscarded(parentWidget, p47);
        end;

        u2._widgets[p47.type].Discard(p47);
    end;

    function u2._widgetState(p48: any, p49: string, p50: any) -- Line: 465
        -- upvalues: u2 (copy)
        local v51 = p48.ID .. p49;

        if u2._states[v51] then
            u2._states[v51].ConnectedWidgets[p48.ID] = p48;

            return u2._states[v51];
        end;

        u2._states[v51] = {
            value = p50,
            ConnectedWidgets = {
                [p48.ID] = p48
            },
            ConnectedFunctions = {}
        };
        setmetatable(u2._states[v51], u2.StateClass);

        return u2._states[v51];
    end;

    function u2._EventCall(p52: any, p53: string) -- Line: 481
        -- upvalues: u2 (copy)
        local v54 = u2._widgets[p52.type].Events[p53];
        local v55 = `widget {p52.type} has no event of name {p53}`;
        assert(v54 ~= nil, v55);

        if p52.trackedEvents[p53] == nil then
            v54.Init(p52);
            p52.trackedEvents[p53] = true;
        end;

        return v54.Get(p52);
    end;

    function u2._GetParentWidget() -- Line: 493
        -- upvalues: u2 (copy)
        return u2._VDOM[u2._IDStack[u2._stackIndex]];
    end;

    function u2._generateEmptyVDOM() -- Line: 499
        -- upvalues: u2 (copy)
        return {
            R = u2._rootWidget
        };
    end;

    function u2._generateRootInstance() -- Line: 505
        -- upvalues: u2 (copy)
        u2._rootInstance = u2._widgets.Root.Generate(u2._widgets.Root);
        u2._rootInstance.Parent = u2.parentInstance;
        u2._rootWidget.Instance = u2._rootInstance;
    end;

    function u2._generateSelectionImageObject() -- Line: 512
        -- upvalues: u2 (copy)
        if u2.SelectionImageObject then
            u2.SelectionImageObject:Destroy();
        end;

        local Frame = Instance.new("Frame");
        Frame.Position = UDim2.fromOffset(-1, -1);
        Frame.Size = UDim2.new(1, 2, 1, 2);
        Frame.BackgroundColor3 = u2._config.SelectionImageObjectColor;
        Frame.BackgroundTransparency = u2._config.SelectionImageObjectTransparency;
        Frame.BorderSizePixel = 0;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Thickness = 1;
        UIStroke.Color = u2._config.SelectionImageObjectBorderColor;
        UIStroke.Transparency = u2._config.SelectionImageObjectBorderTransparency;
        UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Parent = Frame;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 2);
        UICorner.Parent = Frame;
        u2.SelectionImageObject = Frame;
    end;

    function u2._getID(p56: number) -- Line: 543
        -- upvalues: u2 (copy)
        if u2._nextWidgetId then
            local _nextWidgetId = u2._nextWidgetId;
            u2._nextWidgetId = nil;

            return _nextWidgetId;
        end;

        local v57 = 1 + (p56 or 1);
        local debug_info_ret = debug.info(v57, "l");
        local v58 = "";

        while debug_info_ret ~= -1 and debug_info_ret ~= nil do
            v58 = v58 .. "+" .. debug_info_ret;
            v57 = v57 + 1;
            debug_info_ret = debug.info(v57, "l");
        end;

        if u2._usedIDs[v58] then
            local _usedIDs = u2._usedIDs;
            _usedIDs[v58] = _usedIDs[v58] + 1;
        else
            u2._usedIDs[v58] = 1;
        end;

        local v59;

        if u2._pushedId then
            v59 = u2._pushedId;
        else
            v59 = u2._usedIDs[v58];
        end;

        return v58 .. ":" .. v59;
    end;

    function u2._deepCompare(p60: table, p61: table) -- Line: 570
        -- upvalues: u2 (copy)
        for i, v in p60 do
            local v62 = p61[i];

            if type(v) == "table" then
                if not v62 or type(v62) ~= "table" then
                    return false;
                end;

                if u2._deepCompare(v, v62) == false then
                    return false;
                end;
            elseif type(v) ~= type(v62) or v ~= v62 then
                return false;
            end;
        end;

        return true;
    end;

    function u2._deepCopy(p63: table) -- Line: 592
        -- upvalues: u2 (copy)
        local v64 = {};

        for i, v in pairs(p63) do
            local v65;

            if type(v) == "table" then
                v65 = u2._deepCopy(v);
            else
                v65 = v;
            end;

            v64[i] = v65;
        end;

        return v64;
    end;

    u2._lastVDOM = u2._generateEmptyVDOM();
    u2._VDOM = u2._generateEmptyVDOM();
    u1.Internal = u2;
    u1._config = u2._config;

    return u2;
end;