-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local Utility = require(CAM.Global.Utility);
local StatTypes = require(CAM.Global.Types.StatTypes);
local Skill_Switch_Adder = require(CAM.Global.Subsets.Gameplay.Skill_Switch_Adder);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Name = script.Parent.Name;
local Clans = require(CAM.Clans);
local u1 = {
    Kamado = {
        duration = 10,
        bank = "Taken"
    },
    Soyama = {
        duration = 12,
        stat = "Damage Reduction Factor",
        amount = 0.08,
        bank = "Dealt",
        bankPvp = 0.75,
        bankPve = 0.5
    }
};
local Kamado = u1.Kamado;

local function variantFor(p2: userdata) -- Line: 60
    -- upvalues: u1 (copy), Clans (copy), Kamado (copy)
    return u1[Clans.ClanOfCharacter(p2) or ""] or Kamado;
end;

local u3 = StatTypes.StatToAttribute(Name);
local DebrisModule = require(CAM.DebrisModule);

local function auraOf(p4: userdata) -- Line: 77
    -- upvalues: Name (copy)
    local v5 = p4:FindFirstChild(Name);

    if v5 == nil or v5:GetAttribute("_ClanAura") ~= true then
        return nil;
    end;

    return v5;
end;

local function retimeAura(p6: userdata, p7: number, p8: number) -- Line: 83
    -- upvalues: Name (copy), DebrisModule (copy)
    local v9 = p6:FindFirstChild(Name);

    if v9 == nil or v9:GetAttribute("_ClanAura") ~= true then
        v9 = nil;
    end;

    if v9 == nil then
        return;
    end;

    v9:SetAttribute("_Started", workspace:GetServerTimeNow());
    v9:SetAttribute("_Duration", p7);
    DebrisModule:AddItem(v9, p8);
end;

local v10 = {};

local function release(p11: userdata, p12: userdata, p13: userdata, p14: boolean) -- Line: 93
    -- upvalues: Name (copy), Skill_Switch_Adder (copy), retimeAura (copy), Utility (copy), StatTypes (copy), u3 (copy), EffectsEvent (copy)
    local CombatIntuitionStorage = p13:FindFirstChild("CombatIntuitionStorage");

    if CombatIntuitionStorage == nil then
        return;
    end;

    local Value = CombatIntuitionStorage.Value;
    CombatIntuitionStorage:Destroy();
    local CombatIntuitionStore = p13:FindFirstChild("CombatIntuitionStore");

    if CombatIntuitionStore ~= nil then
        CombatIntuitionStore:Destroy();
    end;

    local v15;

    if p11 == nil then
        v15 = nil;
    else
        v15 = p11:FindFirstChild(Name .. Skill_Switch_Adder.extension) or nil;
    end;

    if v15 ~= nil then
        v15:Destroy();
    end;

    local v16 = Value * 0.1;

    if v16 <= 0 then
        local v17 = p13:FindFirstChild(Name);

        if v17 == nil or v17:GetAttribute("_ClanAura") ~= true then
            v17 = nil;
        end;

        if v17 ~= nil then
            v17:Destroy();
        end;

        return;
    end;

    retimeAura(p13, 7, 7);
    local v18 = Utility.AddValue(p13, "CombatIntuitionBonus", 7);
    v18:AddTag(StatTypes.ValueStatTag);
    v18:SetAttribute(StatTypes.StatToAttribute("Additional Damage"), v16);
    v18:SetAttribute(u3, true);

    if p12.Parent ~= nil then
        EffectsEvent.ToAllInRange(p12:FindFirstChild("HumanoidRootPart") or p12, "ActivationVFX", p12, Name, "Release");
    end;
end;

function v10.Activate(u19: userdata, u20: userdata, u21: userdata, p22: any) -- Line: 128
    -- upvalues: u1 (copy), Clans (copy), Kamado (copy), Utility (copy), StatTypes (copy), u3 (copy), Skill_Switch_Adder (copy), Name (copy), retimeAura (copy), release (copy)
    if u21:FindFirstChild("CombatIntuitionStorage") ~= nil then
        return;
    end;

    local v23 = u1[Clans.ClanOfCharacter(u20) or ""] or Kamado;
    local u24 = Utility.AddValue(u21, "CombatIntuitionStorage", nil, "NumberValue", 0);
    u24:SetAttribute("_Started", workspace:GetServerTimeNow());
    u24:SetAttribute("_Length", v23.duration);
    u24:SetAttribute("_Storing", true);
    u24:SetAttribute("_Bank", v23.bank);
    u24:SetAttribute("_BankPvp", v23.bankPvp or 1);
    u24:SetAttribute("_BankPve", v23.bankPve or 1);
    local v25 = Utility.AddValue(u21, "CombatIntuitionStore", v23.duration);
    v25:AddTag(StatTypes.ValueStatTag);

    if v23.stat ~= nil then
        v25:SetAttribute(StatTypes.StatToAttribute(v23.stat), v23.amount);
    end;

    v25:SetAttribute(u3, true);

    if u19 ~= nil then
        Skill_Switch_Adder.Add(u19, Name, v23.duration);
    end;

    retimeAura(u21, v23.duration, v23.duration + 7);
    task.delay(v23.duration, function() -- Line: 161
        -- upvalues: u24 (copy), u19 (copy), release (ref), u20 (copy), u21 (copy)
        if u24.Parent == nil then
            return;
        end;

        if u19 == nil or u19.Parent ~= nil then
            release(u19, u19 ~= nil and u19.Character or u20, u21, false);

            return;
        end;

        u24:Destroy();
    end);
end;

function v10.Switch(p26: userdata, p27: userdata, p28: userdata, p29: any) -- Line: 171
    -- upvalues: Name (copy), Skill_Switch_Adder (copy), release (copy)
    local CombatIntuitionStorage = p28:FindFirstChild("CombatIntuitionStorage");

    if CombatIntuitionStorage ~= nil then
        local Attribute = CombatIntuitionStorage:GetAttribute("_Started");
        local v30 = typeof(Attribute) == "number" and (workspace:GetServerTimeNow() - Attribute or (1 / 0)) or (1 / 0);

        if v30 < 0.3 then
            local v31 = (CombatIntuitionStorage:GetAttribute("_Length") or 0) - v30;

            if v31 > 0 and p26:FindFirstChild(Name .. Skill_Switch_Adder.extension) == nil then
                Skill_Switch_Adder.Add(p26, Name, v31);
            end;

            return;
        end;
    end;

    release(p26, p27, p28, true);
end;

function v10.Cancel(p32: userdata, p33: userdata, p34: userdata, p35: any) -- Line: 189
end;

return v10;