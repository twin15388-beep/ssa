-- Decompiled with Potassium's decompiler.

local Heartbeat = game:GetService("RunService").Heartbeat;

local function getPromiseReference() -- Line: 26
    return false;
end;

local u1 = newproxy(true);

getmetatable(u1).__tostring = function() -- Line: 31
    return "IndicesReference";
end;

local u2 = newproxy(true);

getmetatable(u2).__tostring = function() -- Line: 36
    return "LinkToInstanceIndex";
end;

local u3 = {
    IGNORE_MEMORY_DEBUG = true,
    ClassName = "Janitor",
    __index = {
        CurrentlyCleaning = true,
        [u1] = nil
    }
};
local u4 = {
    ["function"] = true,
    Promise = "cancel",
    RBXScriptConnection = "Disconnect"
};

function u3.new() -- Line: 58
    -- upvalues: u1 (copy), u3 (copy)
    return setmetatable({
        CurrentlyCleaning = false,
        [u1] = nil
    }, u3);
end;

function u3.Is(p5) -- Line: 65
    -- upvalues: u3 (copy)
    local v6;

    if type(p5) == "table" then
        v6 = getmetatable(p5) == u3;
    else
        v6 = false;
    end;

    return v6;
end;

u3.is = u3.Is;

function u3.__index.Add(p7, p8, p9, p10) -- Line: 71
    -- upvalues: u1 (copy), u4 (copy)
    if p10 then
        p7:Remove(p10);
        local v11 = p7[u1];

        if not v11 then
            v11 = {};
            p7[u1] = v11;
        end;

        v11[p10] = p8;
    end;

    local v12 = typeof(p8);
    local v13 = p9 or (u4[v12 == "table" and string.match(tostring(p8), "Promise") and "Promise" or v12] or "Destroy");

    if type(p8) ~= "function" and not p8[v13] then
        warn(string.format("Object %s doesn\'t have method %s, are you sure you want to add it? Traceback: %s", tostring(p8), tostring(v13), debug.traceback(nil, 2)));
    end;

    p7[p8] = { v13, (debug.traceback("")) };

    return p8;
end;

u3.__index.Give = u3.__index.Add;

function u3.__index.AddPromise(p14, u15) -- Line: 103
    local v16 = false;

    if not v16 then
        return u15;
    end;

    if not v16.is(u15) then
        error(string.format("Invalid argument #1 to \'Janitor:AddPromise\' (Promise expected, got %s (%s))", typeof(u15), (tostring(u15))));
    end;

    if u15:getStatus() ~= v16.Status.Started then
        return u15;
    end;

    local v17 = newproxy(false);
    local v21 = p14:Add(v16.new(function(p18, p19, p20) -- Line: 111
        -- upvalues: u15 (copy)
        if p20(function() -- Line: 112
            -- upvalues: u15 (ref)
            u15:cancel();
        end) then
            return;
        end;

        p18(u15);
    end), "cancel", v17);
    v21:finallyCall(p14.Remove, p14, v17);

    return v21;
end;

u3.__index.GivePromise = u3.__index.AddPromise;

function u3.__index.AddObject(p22, p23) -- Line: 133
    local v24 = newproxy(false);
    local v25 = false;

    if not (v25 and v25.is(p23)) then
        return p22:Add(p23, false, v24), v24;
    end;

    if p23:getStatus() ~= v25.Status.Started then
        return p23;
    end;

    local v26 = p22:Add(v25.resolve(p23), "cancel", v24);
    v26:finallyCall(p22.Remove, p22, v24);

    return v26, v24;
end;

u3.__index.GiveObject = u3.__index.AddObject;

function u3.__index.Remove(p27, p28) -- Line: 151
    -- upvalues: u1 (copy)
    local v29 = p27[u1];
    local v30 = v29 and v29[p28];

    if v30 then
        local v31 = p27[v30];

        if v31 then
            v31 = v31[1];
        end;

        if v31 then
            if v31 == true then
                v30();
            else
                local v32 = v30[v31];

                if v32 then
                    v32(v30);
                end;
            end;

            p27[v30] = nil;
        end;

        v29[p28] = nil;
    end;

    return p27;
end;

function u3.__index.Get(p33, p34) -- Line: 180
    -- upvalues: u1 (copy)
    local v35 = p33[u1];

    if v35 then
        return v35[p34];
    end;

    return nil;
end;

function u3.__index.Cleanup(p36) -- Line: 188
    -- upvalues: u1 (copy)
    if not p36.CurrentlyCleaning then
        p36.CurrentlyCleaning = nil;

        for i, v in next, p36 do
            if i ~= u1 then
                local v37 = type(i);

                if v37 == "string" or v37 == "number" then
                    p36[i] = nil;
                else
                    local v38 = v[1];
                    local u39 = v[2];

                    local function warnUser(p40) -- Line: 205
                        -- upvalues: u39 (copy)
                        local debug_traceback_ret = debug.traceback("", 3);
                        warn("-------- Janitor Error --------" .. "\n" .. tostring(p40) .. "\n" .. debug_traceback_ret .. "" .. u39);
                    end;

                    if v38 == true then
                        local success, result = pcall(i);

                        if not success then
                            local debug_traceback_ret = debug.traceback("", 3);
                            warn("-------- Janitor Error --------" .. "\n" .. tostring(result) .. "\n" .. debug_traceback_ret .. "" .. u39);
                        end;
                    else
                        local v41 = i[v38];

                        if v41 then
                            local success, result = pcall(v41, i);
                            local v42;

                            if typeof(i) == "Instance" then
                                v42 = v41 == "Destroy";
                            else
                                v42 = false;
                            end;

                            if not (success or v42) then
                                local debug_traceback_ret = debug.traceback("", 3);
                                warn("-------- Janitor Error --------" .. "\n" .. tostring(result) .. "\n" .. debug_traceback_ret .. "" .. u39);
                            end;
                        end;
                    end;

                    p36[i] = nil;
                end;
            end;
        end;

        local v43 = p36[u1];

        if v43 then
            for i in next, v43 do
                v43[i] = nil;
            end;

            p36[u1] = {};
        end;

        p36.CurrentlyCleaning = false;
    end;
end;

u3.__index.Clean = u3.__index.Cleanup;

function u3.__index.Destroy(p44) -- Line: 244
    p44:Cleanup();
end;

u3.__call = u3.__index.Cleanup;
local u45 = {
    Connected = true
};
u45.__index = u45;

function u45.Disconnect(p46) -- Line: 254
    if p46.Connected then
        p46.Connected = false;
        p46.Connection:Disconnect();
    end;
end;

function u45.__tostring(p47) -- Line: 261
    return "Disconnect<" .. tostring(p47.Connected) .. ">";
end;

function u3.__index.LinkToInstance(u48, p49, p50) -- Line: 265
    -- upvalues: u2 (copy), u45 (copy), Heartbeat (copy)
    local u51 = nil;
    local v52 = p50 and newproxy(false) or u2;
    local u53 = p49.Parent == nil;
    local u54 = setmetatable({}, u45);
    u51 = p49.AncestryChanged:Connect(function(p55, p56) -- Line: 271, Name: ChangedFunction
        -- upvalues: u54 (copy), u53 (ref), Heartbeat (ref), u51 (ref), u48 (copy)
        u53 = u54.Connected and p56 == nil;

        if u53 then
            coroutine.wrap(function() -- Line: 277
                -- upvalues: Heartbeat (ref), u54 (ref), u51 (ref), u48 (ref), u53 (ref)
                Heartbeat:Wait();

                if not u54.Connected then
                    return;
                end;

                if not u51.Connected then
                    u48:Cleanup();

                    return;
                end;

                while u53 and (u51.Connected and u54.Connected) do
                    Heartbeat:Wait();
                end;

                if u54.Connected and u53 then
                    u48:Cleanup();
                end;
            end)();
        end;
    end);
    u54.Connection = u51;

    if u53 then
        local Parent = p49.Parent;

        if u54.Connected then
            if Parent == nil then
                u53 = true;
            else
                u53 = false;
            end;

            if u53 then
                coroutine.wrap(function() -- Line: 277
                    -- upvalues: Heartbeat (ref), u54 (copy), u51 (ref), u48 (copy), u53 (ref)
                    Heartbeat:Wait();

                    if not u54.Connected then
                        return;
                    end;

                    if not u51.Connected then
                        u48:Cleanup();

                        return;
                    end;

                    while u53 and (u51.Connected and u54.Connected) do
                        Heartbeat:Wait();
                    end;

                    if u54.Connected and u53 then
                        u48:Cleanup();
                    end;
                end)();
            end;
        end;
    end;

    return u48:Add(u54, "Disconnect", v52);
end;

function u3.__index.LinkToInstances(p57, ...) -- Line: 308
    -- upvalues: u3 (copy)
    local v58 = u3.new();

    for _, v in ipairs({ ... }) do
        v58:Add(p57:LinkToInstance(v, true), "Disconnect");
    end;

    return v58;
end;

for i, v in next, u3.__index do
    local string_lower_ret = string.lower(i);
    local v59 = string.sub(string_lower_ret, 1, 1) .. string.sub(i, 2);
    u3.__index[v59] = v;
end;

return u3;