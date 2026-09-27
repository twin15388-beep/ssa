-- Decompiled with Potassium's decompiler.

require(script.Types);
local u1 = {};
local u2 = require(script.Internal)(u1);
u1.Disabled = false;
u1.Args = {};
u1.Events = {};

function u1.HasInit() -- Line: 12
    -- upvalues: u2 (copy)
    return u2._started;
end;

function u1.Init(p3: userdata?, u4: any) -- Line: 16
    -- upvalues: u2 (copy), u1 (copy)
    if p3 == nil then
        p3 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
    end;

    if u4 == nil then
        u4 = game:GetService("RunService").Heartbeat;
    end;

    u2.parentInstance = p3;
    assert(u2._started == false, "Iris.Init can only be called once.");
    u2._started = true;
    u2._generateRootInstance();
    u2._generateSelectionImageObject();
    task.spawn(function() -- Line: 33
        -- upvalues: u4 (ref), u2 (ref)
        if typeof(u4) ~= "function" then
            if u4 ~= nil then
                u4:Connect(function() -- Line: 40
                    -- upvalues: u2 (ref)
                    u2._cycle();
                end);
            end;

            return;
        end;

        while true do
            u4();
            u2._cycle();
        end;
    end);

    return u1;
end;

function u1.Connect(p5: table, p6: function) -- Line: 49
    -- upvalues: u2 (copy)
    if u2._started == false then
        warn("Iris:Connect() was called before calling Iris.Init(), the connected function will never run");
    end;

    table.insert(u2._connectedFunctions, p6);
end;

function u1.Append(p7: userdata) -- Line: 56
    -- upvalues: u2 (copy)
    local v8 = u2._GetParentWidget();
    local v9;

    if u2._config.Parent then
        v9 = u2._config.Parent;
    else
        v9 = u2._widgets[v8.type].ChildAdded(v8, {
            type = "userInstance"
        });
    end;

    p7.Parent = v9;
end;

function u1.End() -- Line: 67
    -- upvalues: u2 (copy)
    if u2._stackIndex == 1 then
        error("Callback has too many calls to Iris.End()", 2);
    end;

    u2._IDStack[u2._stackIndex] = nil;
    local v10 = u2;
    v10._stackIndex = v10._stackIndex - 1;
end;

function u1.ForceRefresh() -- Line: 81
    -- upvalues: u2 (copy)
    u2._globalRefreshRequested = true;
end;

function u1.UpdateGlobalConfig(p11: table) -- Line: 85
    -- upvalues: u2 (copy), u1 (copy)
    for i, v in p11 do
        u2._rootConfig[i] = v;
    end;

    u1.ForceRefresh();
end;

function u1.PushConfig(p12: table) -- Line: 92
    -- upvalues: u1 (copy), u2 (copy)
    local v13 = u1.State(-1);

    if v13.value == -1 then
        v13:set(p12);
    elseif u2._deepCompare(v13:get(), p12) == false then
        u2._localRefreshActive = true;
        v13:set(p12);
    end;

    u2._config = setmetatable(p12, {
        __index = u2._config
    });
end;

function u1.PopConfig() -- Line: 110
    -- upvalues: u2 (copy)
    u2._localRefreshActive = false;
    u2._config = getmetatable(u2._config).__index;
end;

u1.TemplateConfig = require(script.config);
u1.UpdateGlobalConfig(u1.TemplateConfig.colorDark);
u1.UpdateGlobalConfig(u1.TemplateConfig.sizeDefault);
u1.UpdateGlobalConfig(u1.TemplateConfig.utilityDefault);
u2._globalRefreshRequested = false;

function u1.PushId(p14) -- Line: 127
    -- upvalues: u2 (copy)
    local v15 = typeof(p14) == "string";
    assert(v15, "Iris expected Iris.PushId id to PushId to be a string.");
    u2._pushedId = tostring(p14);
end;

function u1.PopId() -- Line: 133
    -- upvalues: u2 (copy)
    u2._pushedId = nil;
end;

function u1.SetNextWidgetID(p16) -- Line: 137
    -- upvalues: u2 (copy)
    u2._nextWidgetId = p16;
end;

function u1.State(p17) -- Line: 147
    -- upvalues: u2 (copy)
    local v18 = u2._getID(2);

    if u2._states[v18] then
        return u2._states[v18];
    end;

    u2._states[v18] = {
        value = p17,
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    setmetatable(u2._states[v18], u2.StateClass);

    return u2._states[v18];
end;

function u1.WeakState(p19) -- Line: 161
    -- upvalues: u2 (copy)
    local v20 = u2._getID(2);

    if u2._states[v20] then
        if #u2._states[v20].ConnectedWidgets ~= 0 then
            return u2._states[v20];
        end;

        u2._states[v20] = nil;
    end;

    u2._states[v20] = {
        value = p19,
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    setmetatable(u2._states[v20], u2.StateClass);

    return u2._states[v20];
end;

function u1.ComputedState(p21: any, u22: function) -- Line: 179
    -- upvalues: u2 (copy)
    local u23 = u2._getID(2);

    if u2._states[u23] then
        return u2._states[u23];
    end;

    u2._states[u23] = {
        value = u22(p21.value),
        ConnectedWidgets = {},
        ConnectedFunctions = {}
    };
    p21:onChange(function(p24) -- Line: 190
        -- upvalues: u2 (ref), u23 (copy), u22 (copy)
        u2._states[u23]:set(u22(p24));
    end);
    setmetatable(u2._states[u23], u2.StateClass);

    return u2._states[u23];
end;

u1.ShowDemoWindow = require(script.demoWindow)(u1);
print(warn(debug.traceback()));
require(script.widgets)(u2);
require(script.API)(u1);

return u1;