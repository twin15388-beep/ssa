-- Decompiled with Potassium's decompiler.

local function parsePath(p1) -- Line: 4
    local string_split_ret = string.split(p1, "/");

    for i = #string_split_ret, 1, -1 do
        local v2;

        if string_split_ret[i] == "" then
            table.remove(string_split_ret, i);
            v2 = i;
        else
            v2 = i;
        end;
    end;

    return string_split_ret;
end;

local function isManifestResolved(p3, p4) -- Line: 14
    local v5 = 0;

    for _ in pairs(p3) do
        v5 = v5 + 1;
    end;

    assert(v5 <= p4, v5);

    return v5 == p4;
end;

local function unbindNodeDescend(p6, p7) -- Line: 24
    -- upvalues: unbindNodeDescend (copy)
    if p6.instance == nil then
        return;
    end;

    p6.instance = nil;
    local connections = p6.connections;

    if connections then
        for _, v in ipairs(connections) do
            v:Disconnect();
        end;

        table.clear(connections);
    end;

    if p7 and p6.alias then
        p7[p6.alias] = nil;
    end;

    local children = p6.children;

    if children then
        for _, v in pairs(children) do
            unbindNodeDescend(v, p7);
        end;
    end;
end;

local u8 = {};
u8.__index = u8;

function u8.new(p9, p10) -- Line: 54
    -- upvalues: parsePath (copy), u8 (copy)
    local v11 = {};
    local v12 = 1;
    local v13 = {};
    local v14 = {};
    local v15 = {};
    local v16 = {};

    for i, v in pairs(p9) do
        v11[i] = parsePath(v);
        v12 = v12 + 1;
    end;

    return setmetatable({
        _boundFn = p10,
        _parsedManifest = v11,
        _manifestSizeTarget = v12,
        _dtorMap = v13,
        _connections = v14,
        _rootInstToRootNode = v15,
        _rootInstToManifest = v16
    }, u8);
end;

function u8._startBoundFn(p17, p18, p19) -- Line: 80
    local _boundFn = p17._boundFn;
    local _dtorMap = p17._dtorMap;
    local v20 = _dtorMap[p18];

    if v20 then
        v20();
        _dtorMap[p18] = nil;
    end;

    local v21 = _boundFn(p19);

    if v21 then
        _dtorMap[p18] = v21;
    end;
end;

function u8._stopBoundFn(p22, p23) -- Line: 96
    local _dtorMap = p22._dtorMap;
    local v24 = _dtorMap[p23];

    if v24 then
        v24();
        _dtorMap[p23] = nil;
    end;
end;

function u8.bindRoot(u25, u26) -- Line: 106
    -- upvalues: unbindNodeDescend (copy)
    debug.profilebegin("AtomicBinding:BindRoot");
    local _parsedManifest = u25._parsedManifest;
    local _rootInstToRootNode = u25._rootInstToRootNode;
    local _rootInstToManifest = u25._rootInstToManifest;
    local _manifestSizeTarget = u25._manifestSizeTarget;
    assert(_rootInstToManifest[u26] == nil);
    local u27 = {};
    _rootInstToManifest[u26] = u27;
    debug.profilebegin("BuildTree");
    local v28 = {
        alias = "root",
        instance = u26
    };

    if next(_parsedManifest) then
        v28.children = {};
        v28.connections = {};
    end;

    _rootInstToRootNode[u26] = v28;

    for i, v in pairs(_parsedManifest) do
        local v29 = v28;
        local v30 = i;
        local v31 = v;

        for i2, v2 in ipairs(v) do
            local v32 = v28.children[v2] or {};

            if i2 == #v31 then
                if v32.alias ~= nil then
                    error("Multiple aliases assigned to one instance");
                end;

                v32.alias = v30;
            else
                v32.children = v32.children or {};
                v32.connections = v32.connections or {};
            end;

            v28.children[v2] = v32;
            v28 = v32;
        end;

        v28 = v29;
    end;

    debug.profileend();

    local function processNode(p33) -- Line: 160
        -- upvalues: u27 (copy), processNode (copy), u25 (copy), u26 (copy), unbindNodeDescend (ref), _manifestSizeTarget (copy)
        local u34 = assert(p33.instance);
        local children = p33.children;
        local alias = p33.alias;
        local v35 = not children;

        if alias then
            u27[alias] = u34;
        end;

        if not v35 then
            local function processAddChild(p36) -- Line: 172
                -- upvalues: children (copy), processNode (ref)
                local v37 = children[p36.Name];

                if not v37 or v37.instance ~= nil then
                    return;
                end;

                v37.instance = p36;
                processNode(v37);
            end;

            local function processDeleteChild(p38) -- Line: 183
                -- upvalues: children (copy), u25 (ref), u26 (ref), unbindNodeDescend (ref), u27 (ref), u34 (copy), processNode (ref)
                local Name = p38.Name;
                local v39 = children[Name];

                if not v39 then
                    return;
                end;

                if v39.instance ~= p38 then
                    return;
                end;

                u25:_stopBoundFn(u26);
                unbindNodeDescend(v39, u27);
                assert(v39.instance == nil);
                local v40 = u34:FindFirstChild(Name);
                local v41 = v40 and children[v40.Name];

                if v41 then
                    if v41.instance ~= nil then
                        return;
                    end;

                    v41.instance = v40;
                    processNode(v41);
                end;
            end;

            for _, child in ipairs(u34:GetChildren()) do
                local v42 = children[child.Name];

                if v42 then
                    if v42.instance == nil then
                        v42.instance = child;
                        processNode(v42);
                    end;
                end;
            end;

            table.insert(p33.connections, u34.ChildAdded:Connect(processAddChild));
            table.insert(p33.connections, u34.ChildRemoved:Connect(processDeleteChild));
        end;

        if v35 then
            local v43 = _manifestSizeTarget;
            local v44 = 0;

            for _ in pairs(u27) do
                v44 = v44 + 1;
            end;

            assert(v44 <= v43, v44);

            if v44 == v43 then
                u25:_startBoundFn(u26, u27);
            end;
        end;
    end;

    debug.profilebegin("ResolveTree");
    processNode(v28);
    debug.profileend();
    debug.profileend();
end;

function u8.unbindRoot(p45, p46) -- Line: 236
    -- upvalues: unbindNodeDescend (copy)
    local _rootInstToRootNode = p45._rootInstToRootNode;
    local _rootInstToManifest = p45._rootInstToManifest;
    p45:_stopBoundFn(p46);
    local v47 = _rootInstToRootNode[p46];

    if v47 then
        unbindNodeDescend(v47, (assert(_rootInstToManifest[p46])));
        _rootInstToRootNode[p46] = nil;
    end;

    _rootInstToManifest[p46] = nil;
end;

function u8.destroy(p48) -- Line: 252
    -- upvalues: unbindNodeDescend (copy)
    debug.profilebegin("AtomicBinding:destroy");

    for _, v in pairs(p48._dtorMap) do
        v:destroy();
    end;

    table.clear(p48._dtorMap);

    for _, v in ipairs(p48._connections) do
        v:Disconnect();
    end;

    table.clear(p48._connections);
    local _rootInstToManifest = p48._rootInstToManifest;

    for i, v in pairs(p48._rootInstToRootNode) do
        unbindNodeDescend(v, (assert(_rootInstToManifest[i])));
    end;

    table.clear(p48._rootInstToManifest);
    table.clear(p48._rootInstToRootNode);
    debug.profileend();
end;

return u8;