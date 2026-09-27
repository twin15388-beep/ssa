-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};
local Network = ReplicatedStorage:WaitForChild("Network");
local Combat = Network:WaitForChild("Combat");
local Abilities = Network:WaitForChild("Abilities");
local Systems = Network:WaitForChild("Systems");
local Functions = Network:WaitForChild("Functions");
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local Remotes = ReplicatedStorage:WaitForChild("ArczisCombat"):WaitForChild("Remotes");
local Remotes2 = ReplicatedStorage:WaitForChild("Remotes");
u1.Folders = {
    Network = Network,
    Combat = Combat,
    Abilities = Abilities,
    Systems = Systems,
    Functions = Functions
};
u1.Legacy = {
    Events = Eventos,
    ArczisCombat = Remotes,
    Root = Remotes2
};
local u2 = {
    BreakNeck = { Eventos, "BreakNeckRemote" },
    BloodDrink = { Eventos, "BloodDrinkRemote" },
    Infect = { Eventos, "InfectRemote" },
    Punch = { Eventos, "PunchRemote" },
    Stake = { Eventos, "StakeRemote" },
    Hypnosis = { Eventos, "HypnosisRemote" },
    HeartRipping = { Eventos, "HeartRippingRemote" },
    Incendia = { Eventos, "IncendiaRemote" },
    WitchPetrification = { Eventos, "WitchPetrificationRemote" },
    WitchHeartRipping = { Eventos, "WitchHeartRippingRemote" },
    Combat = { Remotes, "CombatEvent" },
    Block = { Remotes, "BlockEvent" },
    HitReaction = { Remotes, "HitReactionEvent" },
    Sound = { Remotes, "SoundEvent" },
    Clash = { Remotes, "ClashEvent" },
    RunningState = { Remotes, "UpdateRunningState" }
};

function u1.GetLegacyCombat(p3) -- Line: 50
    -- upvalues: u2 (copy)
    local v4 = u2[p3];
    local v5 = tostring(p3);
    assert(v4, ("Unknown combat remote: %s"):format(v5));

    return v4[1]:WaitForChild(v4[2]);
end;

function u1.GetEvent(p6, p7) -- Line: 56
    -- upvalues: u1 (copy)
    local v8 = u1.Folders[p6];
    local v9 = tostring(p6);
    assert(v8, ("Unknown network folder: %s"):format(v9));
    local v10 = v8:WaitForChild(p7);
    local v11 = v10:IsA("RemoteEvent");
    assert(v11, ("%s.%s is not a RemoteEvent"):format(p6, p7));

    return v10;
end;

function u1.GetFunction(p12, p13) -- Line: 64
    -- upvalues: u1 (copy)
    local v14 = u1.Folders[p12];
    local v15 = tostring(p12);
    assert(v14, ("Unknown network folder: %s"):format(v15));
    local v16 = v14:WaitForChild(p13);
    local v17 = v16:IsA("RemoteFunction");
    assert(v17, ("%s.%s is not a RemoteFunction"):format(p12, p13));

    return v16;
end;

return u1;