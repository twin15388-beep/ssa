-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local SaneValue = require(script.Parent:WaitForChild("SaneValue"));
local u1 = RunService:IsServer();
local _ = table.find;
local _ = table.remove;
script:WaitForChild("DeletedNotifier");
local Event = script:WaitForChild("Event");
local Function = script:WaitForChild("Function");
local u2 = {
    CurrentConnections = u1 and {} or nil,
    CurrentListeners = not u1 and ({} or nil) or nil
};
local u11 = {
    ToClient = function(p3, ...) -- Line: 19, Name: ToClient
        -- upvalues: Event (copy)
        Event:FireClient(p3.Player, p3.ConnectionName, ...);
    end,

    YieldToClient = function(p4, ...) -- Line: 23, Name: YieldToClient
        -- upvalues: Function (copy)
        return Function:InvokeClient(p4.Player, p4.ConnectionName, ...);
    end,

    Call = function(p5, ...) -- Line: 26, Name: Call
        if p5.Callback ~= nil then
            if not p5.__DeleteAfterCall then
                return p5.Callback(...);
            end;

            local Callback = p5.Callback;
            p5:Destroy();

            return Callback(...);
        end;
    end,

    Connect = function(p6: table, p7: function) -- Line: 36, Name: Connect
        p6.Callback = p7;
    end,

    Once = function(p8: table, p9: function) -- Line: 39, Name: Once
        p8.Callback = p9;
        p8.__DeleteAfterCall = true;
    end,

    Destroy = function(p10) -- Line: 43, Name: Destroy
        -- upvalues: u2 (copy)
        if not p10.__Active then
            return;
        end;

        u2.CurrentConnections[p10.KeyName] = nil;
        script.DeletedNotifier:FireClient(p10.Player, p10.ConnectionName);
        p10.Player = nil;
        p10.KeyName = nil;
        p10.ConnectionName = nil;
        p10.__DeleteAfterCall = nil;
        p10.Callback = nil;
        p10.__Active = nil;
        setmetatable(p10, nil);
    end
};
u11.__index = u11;
local u22 = {
    Server = function(p12, ...) -- Line: 69, Name: Server
        -- upvalues: Event (copy)
        Event:FireServer(p12.ConnectionName, ...);
    end,

    YieldServer = function(p13, ...) -- Line: 72, Name: YieldServer
        -- upvalues: Function (copy)
        return Function:InvokeServer(p13.ConnectionName, ...);
    end,

    Call = function(p14, ...) -- Line: 75, Name: Call
        if p14.Callback ~= nil then
            if not p14.__DeleteAfterCall then
                return p14.Callback(...);
            end;

            local Callback = p14.Callback;
            p14:Destroy();

            return Callback(...);
        end;
    end,

    OnDestroyed = function(p15: table, p16: function) -- Line: 85, Name: OnDestroyed
        p15.OnDestroyedCallback = p16;
    end,

    Connect = function(p17: table, p18: function) -- Line: 88, Name: Connect
        p17.Callback = p18;
    end,

    Once = function(p19: table, p20: function) -- Line: 91, Name: Once
        p19.Callback = p20;
        p19.__DeleteAfterCall = true;
    end,

    Destroy = function(p21) -- Line: 95, Name: Destroy
        -- upvalues: u2 (copy)
        if not p21.__Active then
            return;
        end;

        u2.CurrentListeners[p21.ConnectionName] = nil;
        p21.ConnectionName = nil;
        p21.Callback = nil;
        p21.OnDestroyedCallback = nil;
        p21.__DeleteAfterCall = nil;
        p21.__Active = nil;
        setmetatable(p21, nil);
    end
};
u22.__index = u22;

function u2.Create(p23: userdata, p24: string, p25: number?) -- Line: 124
    -- upvalues: u11 (copy), u2 (copy)
    if p24 ~= nil then
        local v26 = p25 or 5;
        local v27 = {
            __Active = true,
            Player = p23,
            ConnectionName = p24,
            KeyName = `{p23.Name}-{p23.UserId}-{p24}`
        };
        local u28 = setmetatable(v27, u11);

        if v26 >= 0 then
            task.delay(v26, function() -- Line: 135
                -- upvalues: u28 (copy)
                if u28.__Active then
                    u28:Destroy();
                end;
            end);
        end;

        if u2.CurrentConnections[u28.KeyName] ~= nil then
            u2.CurrentConnections[u28.KeyName]:Destroy();
        end;

        u2.CurrentConnections[u28.KeyName] = u28;

        return u28;
    end;
end;

function u2.Link(p29: string, p30: number?) -- Line: 154
    -- upvalues: u22 (copy), u2 (copy)
    if p29 ~= nil then
        local v31 = p30 or 5;
        local u32 = setmetatable({
            __Active = true,
            ConnectionName = p29
        }, u22);

        if v31 >= 0 then
            task.delay(v31, function() -- Line: 163
                -- upvalues: u32 (copy)
                if u32.__Active then
                    u32:Destroy();
                end;
            end);
        end;

        if u2.CurrentListeners[p29] ~= nil then
            u2.CurrentListeners[p29]:Destroy();
        end;

        u2.CurrentListeners[p29] = u32;

        return u32;
    end;
end;

if u1 then
    function u2.ToClient(p33: userdata, p34: string, ...) -- Line: 186
        -- upvalues: Event (copy)
        if p33 == nil or p34 == nil then
            return;
        end;

        Event:FireClient(p33, p34, ...);
    end;

    function u2.YieldToClient(p35: userdata, p36: string, ...) -- Line: 196
        -- upvalues: Function (copy)
        if p35 ~= nil and p36 ~= nil then
            return Function:InvokeClient(p35, p36, ...);
        end;
    end;

    function u2.ToAllClients(p37: string, ...) -- Line: 205
        -- upvalues: Event (copy)
        if p37 == nil then
            return;
        end;

        for _, v in ipairs(game.Players:GetPlayers()) do
            Event:FireClient(v, p37, ...);
        end;
    end;
else
    function u2.Server(p38: string, ...) -- Line: 217
        -- upvalues: Event (copy)
        if p38 == nil then
            return;
        end;

        Event:FireServer(p38, ...);
    end;

    function u2.YieldServer(p39: string, ...) -- Line: 226
        -- upvalues: Function (copy)
        if p39 ~= nil then
            return Function:InvokeServer(p39, ...);
        end;
    end;
end;

function u2.Destroy(p40: any, p41: string?) -- Line: 242
    -- upvalues: u1 (copy), u2 (copy)
    local v42;

    if p41 == nil then
        v42 = nil;
    else
        v42 = p40;
        p40 = p41;
    end;

    if u1 then
        if v42 == nil or p40 == nil then
            for _, v in pairs(u2.CurrentConnections) do
                v:Destroy();
            end;

            return;
        end;

        local v43 = `{v42.Name}-{v42.UserId}-{p40}`;

        if u2.CurrentConnections[v43] ~= nil then
            u2.CurrentConnections[v43]:Destroy();
        end;
    elseif p40 == nil then
        for _, v in pairs(u2.CurrentListeners) do
            v:Destroy();
        end;
    elseif u2.CurrentListeners[p40] ~= nil then
        u2.CurrentListeners[p40]:Destroy();
    end;
end;

if not u1 then
    function Function.OnClientInvoke(p44: string, ...) -- Line: 334
        -- upvalues: u2 (copy)
        if u2.CurrentListeners[p44] ~= nil then
            return u2.CurrentListeners[p44]:Call(...);
        end;
    end;

    Event.OnClientEvent:Connect(function(p45: string, ...) -- Line: 339
        -- upvalues: u2 (copy)
        if u2.CurrentListeners[p45] ~= nil then
            u2.CurrentListeners[p45]:Call(...);
        end;
    end);
    script.DeletedNotifier.OnClientEvent:Connect(function(p46: string) -- Line: 344
        -- upvalues: u2 (copy)
        local v47 = u2.CurrentListeners[p46];

        if v47 == nil then
            return;
        end;

        if v47.OnDestroyedCallback then
            v47.OnDestroyedCallback();
        end;

        if v47.__Active then
            v47:Destroy();
        end;
    end);

    return u2;
end;

local u48 = setmetatable({}, {
    __mode = "k"
});

local function allowed(p49: userdata, p50: any) -- Line: 285
    -- upvalues: u48 (copy)
    if typeof(p50) ~= "string" then
        return false;
    end;

    local os_clock_ret = os.clock();
    local v51 = u48[p49];

    if v51 == nil then
        v51 = {
            tokens = 90,
            at = os_clock_ret
        };
        u48[p49] = v51;
    end;

    v51.tokens = math.min(90, v51.tokens + (os_clock_ret - v51.at) * 30);
    v51.at = os_clock_ret;

    if v51.tokens < 1 then
        return false;
    end;

    v51.tokens = v51.tokens - 1;

    return true;
end;

local function saneArgs(...) -- Line: 302
    -- upvalues: SaneValue (copy)
    for i = 1, select("#", ...) do
        local v52 = select(i, ...);
        local v53;

        if typeof(v52) == "table" then
            v53 = i;
            local v54 = 0;

            for _, v in v52 do
                v54 = v54 + 1;

                if v54 > 16 or not SaneValue(v) then
                    return false;
                end;
            end;
        else
            if not SaneValue(v52) then
                return false;
            end;

            v53 = i;
        end;
    end;

    return true;
end;

function Function.OnServerInvoke(p55: userdata, p56: string, ...) -- Line: 317
    -- upvalues: allowed (copy), saneArgs (copy), u2 (copy)
    if not (allowed(p55, p56) and saneArgs(...)) then
        return;
    end;

    local v57 = `{p55.Name}-{p55.UserId}-{p56}`;

    if u2.CurrentConnections[v57] ~= nil then
        return u2.CurrentConnections[v57]:Call(...);
    end;
end;

Event.OnServerEvent:Connect(function(p58: userdata, p59: string, ...) -- Line: 324
    -- upvalues: allowed (copy), saneArgs (copy), u2 (copy)
    if not (allowed(p58, p59) and saneArgs(...)) then
        return;
    end;

    local v60 = `{p58.Name}-{p58.UserId}-{p59}`;

    if u2.CurrentConnections[v60] ~= nil then
        u2.CurrentConnections[v60]:Call(...);
    end;
end);

return u2;