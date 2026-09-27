-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local v1 = {
    Id = {}
};
local _ = math.clamp;
local os_clock = os.clock;
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local u2 = {
    Stun = true,
    Strict_Stun = true,
    CombatStun = true
};

local function idleUntilStunned(p3: userdata, p4: number) -- Line: 20
    -- upvalues: u2 (copy)
    local coroutine_running_ret = coroutine.running();
    local u5 = false;

    local function wake() -- Line: 23
        -- upvalues: u5 (ref), coroutine_running_ret (copy)
        if u5 then
            return;
        end;

        u5 = true;
        task.spawn(coroutine_running_ret);
    end;

    local v7 = p3.ChildAdded:Connect(function(p6) -- Line: 28
        -- upvalues: u2 (ref), u5 (ref), coroutine_running_ret (copy)
        if u2[p6.Name] then
            if u5 then
                return;
            end;

            u5 = true;
            task.spawn(coroutine_running_ret);
        end;
    end);
    task.delay(p4, wake);
    coroutine.yield();
    v7:Disconnect();
end;

local function refreshBlockStats(p8: userdata, p9: userdata) -- Line: 38
    -- upvalues: PlayerStatResolver (copy), gameSettings (copy)
    local v10 = PlayerStatResolver.GetStat(p8, "Block Points") or 0;
    local math_round_ret = math.round(gameSettings.BaseStats.BlockPoints + v10);
    local math_max_ret = math.max(math_round_ret, 1);

    if math_max_ret ~= p9.MaxValue then
        local v11 = p9.Value / math.max(p9.MaxValue, 1);
        p9.MaxValue = math_max_ret;
        p9.Value = math_max_ret * v11;
    end;

    p9:SetAttribute("AddedBlockPoints", v10);
    p9:SetAttribute("BlockRegen", PlayerStatResolver.GetStat(p8, "Block Regen") or 0);
end;

function v1.Hold(u12) -- Line: 54
    -- upvalues: refreshBlockStats (copy), PlayerStatResolver (copy), os_clock (copy), gameSettings (copy), Utility (copy), idleUntilStunned (copy), DebrisModule (copy)
    local u13 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(u12.Name);

    if u13 ~= nil then
        local Blocking = u12:FindFirstChild("Blocking");

        if Blocking == nil then
            Blocking = Instance.new("IntConstrainedValue");
            Blocking.Name = "Blocking";
            refreshBlockStats(u12, Blocking);
            Blocking.Value = Blocking.MaxValue;
            Blocking.Parent = u13;

            local function onStatChange() -- Line: 68
                -- upvalues: refreshBlockStats (ref), u12 (copy), Blocking (ref)
                refreshBlockStats(u12, Blocking);
            end;

            local u14 = PlayerStatResolver.Attach(u12, "Block Points", onStatChange);
            local u15 = PlayerStatResolver.Attach(u12, "Block Regen", onStatChange);
            local u16 = os_clock();
            local u17 = Blocking.Value / Blocking.MaxValue;
            local u19 = Blocking.Changed:Connect(function() -- Line: 76
                -- upvalues: Blocking (ref), u17 (ref), u16 (ref), os_clock (ref)
                if Blocking then
                    local v18 = Blocking.Value / Blocking.MaxValue;

                    if v18 < u17 then
                        u16 = os_clock();
                    end;

                    u17 = v18;
                end;
            end);

            local function postBreakRegenReady() -- Line: 92
                -- upvalues: Blocking (ref), gameSettings (ref), Utility (ref), u13 (copy)
                local Attribute = Blocking:GetAttribute("BreakAt");

                if Attribute == nil then
                    return false;
                end;

                local v20 = Attribute + gameSettings.BlockBreakRegenDelay;

                if Utility.Tick() < v20 then
                    return false;
                end;

                local DMG = u13:FindFirstChild("DMG");
                local v21;

                if DMG == nil then
                    v21 = nil;
                else
                    v21 = DMG:GetAttribute("LastAttacked") or nil;
                end;

                if v21 == nil or v20 >= v21 then
                    return true;
                end;

                Blocking:SetAttribute("BreakAt", nil);

                return false;
            end;

            task.spawn(function() -- Line: 109
                -- upvalues: u12 (copy), u13 (copy), Blocking (ref), gameSettings (ref), Utility (ref), os_clock (ref), u16 (ref), postBreakRegenReady (copy), idleUntilStunned (ref), u19 (copy), u14 (copy), u15 (copy)
                while u12 ~= nil and (u13 ~= nil and (u12.Parent == game.Players and (Blocking ~= nil and (Blocking.Parent == u12 or Blocking.Parent == u13)))) do
                    local v22;

                    if gameSettings.BlockRegenWhileStunned == true then
                        v22 = (u13:FindFirstChild("Stun") ~= nil or u13:FindFirstChild("Strict_Stun") ~= nil) and true or u13:FindFirstChild("CombatStun") ~= nil;
                    else
                        v22 = false;
                    end;

                    local v23 = Utility.TemporaryBoostOf(u13, gameSettings.StunChainBoost.Stat);
                    local v24;

                    if v23 > 1 then
                        v24 = gameSettings.StunChainBoost.SkipsRegenCooldown == true;
                    else
                        v24 = false;
                    end;

                    if v22 or (v24 or (os_clock() - u16 > gameSettings.BlockRegenerateCoolDown or postBreakRegenReady())) then
                        if (Blocking:GetAttribute("D") or 0) > 0 then
                            Blocking:SetAttribute("D", 0);
                        else
                            local v25 = Blocking;
                            v25.Value = v25.Value + 1;
                        end;

                        if Blocking.Value >= Blocking.MaxValue then
                            Blocking:SetAttribute("BreakAt", nil);
                        end;

                        task.wait(gameSettings.BlockRegenInterval / ((1 + (Blocking:GetAttribute("BlockRegen") or 0)) * v23));
                    elseif gameSettings.BlockRegenWhileStunned == true then
                        idleUntilStunned(u13, 1);
                    else
                        task.wait(1);
                    end;
                end;

                if u19 ~= nil then
                    u19:Disconnect();
                end;

                if u14 ~= nil then
                    u14();
                end;

                if u15 ~= nil then
                    u15();
                end;
            end);
        end;

        local StringValue = Instance.new("StringValue");
        StringValue.Name = "escapeiframe";
        StringValue.Parent = u13;
        DebrisModule:AddItem(StringValue, 0.025);
        refreshBlockStats(u12, Blocking);
        Blocking.Name = "Blocking";
        Blocking.Parent = u13;
        Blocking:AddTag("Blocking");

        if u13:FindFirstChild("Stun") == nil and u13:FindFirstChild("CombatStun") == nil and (u13:FindFirstChild("DMG") and Utility.Tick() - u13.DMG:GetAttribute("LastAttacked") or 2) >= 1 then
            local StringValue2 = Instance.new("StringValue", Blocking);
            StringValue2.Name = "Perfect";
            DebrisModule:AddItem(StringValue2, 0.1);
            local StringValue3 = Instance.new("StringValue", Blocking);
            StringValue3.Name = "PerfectNpc";
            DebrisModule:AddItem(StringValue3, 0.25);
        end;
    end;
end;

function v1.UnHold(p26) -- Line: 179
    local v27 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p26.Name);

    if v27 ~= nil then
        local Blocking = v27:FindFirstChild("Blocking");
        task.wait();

        if Blocking ~= nil then
            Blocking:RemoveTag("Blocking");
            Blocking.Parent = p26;
        end;
    end;
end;

function v1.Cancel(p28) -- Line: 190
    local v29 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p28.Name);

    if v29 ~= nil then
        local Blocking = v29:FindFirstChild("Blocking");
        task.wait();

        if Blocking ~= nil then
            Blocking:RemoveTag("Blocking");
            Blocking.Parent = p28;
        end;
    end;
end;

return v1;