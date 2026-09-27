-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = {
    functiontxt = "function",
    tf = table.find,
    tof = typeof,
    tr = table.remove,
    tins = table.insert,
    IsRunning = RunService:IsRunning(),
    IsServer = RunService:IsServer()
};

function u1.GetRemote(p2: userdata, p3: string) -- Line: 14
    -- upvalues: u1 (ref)
    if u1.IsRunning then
        if not u1.IsServer then
            return p2:WaitForChild(p3);
        end;

        local v4 = p2:FindFirstChild(p3);

        if v4 == nil then
            v4 = p3 == "Event" and Instance.new("RemoteEvent") or (p3 == "Function" and Instance.new("RemoteFunction") or Instance.new("UnreliableRemoteEvent"));
            v4.Name = p3;
            v4.Parent = p2;
        end;

        return v4;
    end;
end;

function u1.GetFireFunction(p5: userdata, p6: boolean?) -- Line: 28
    -- upvalues: u1 (ref)
    if u1.IsRunning then
        if p5.ClassName == "RemoteEvent" or p5.ClassName == "UnreliableRemoteEvent" then
            if not u1.IsServer then
                return p5.FireServer;
            end;

            if p6 then
                return p5.FireAllClients;
            end;

            return p5.FireClient;
        end;

        if not u1.IsServer then
            return p5.InvokeServer;
        end;

        if p6 then
            return nil;
        end;

        return p5.InvokeClient;
    end;
end;

function u1.Connect(p7: userdata, p8: function) -- Line: 51
    -- upvalues: u1 (ref)
    if not u1.IsRunning then
        return;
    end;

    if p7.ClassName == "RemoteEvent" or p7.ClassName == "UnreliableRemoteEvent" then
        if u1.IsServer then
            return p7.OnServerEvent:Connect(p8);
        end;

        return p7.OnClientEvent:Connect(p8);
    end;

    if u1.IsServer then
        p7.OnServerInvoke = p8;

        return;
    end;

    p7.OnClientInvoke = p8;
end;

if u1.IsServer and u1.IsRunning then
    u1.Players = {};
    game.Players.PlayerAdded:Connect(function(p9) -- Line: 73
        -- upvalues: u1 (ref)
        u1.tins(u1.Players, p9);
    end);
    game.Players.PlayerRemoving:Connect(function(p10) -- Line: 76
        -- upvalues: u1 (ref)
        local v11 = u1.tf(u1.Players, p10);

        if v11 ~= nil then
            u1.tr(u1.Players, v11);
        end;
    end);
end;

return u1;