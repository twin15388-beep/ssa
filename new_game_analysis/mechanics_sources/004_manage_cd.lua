-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local PlayerProfile = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("PlayerProfile"));
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
local PlayerStatResolver = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("PlayerStatResolver"));
local CombatBalance = require(game.ReplicatedStorage.CAM.Global.CombatBalance);
local Stats = require(game.ReplicatedStorage.CAM.Global.SkillService.Stats);
local _ = string.gsub;
local u1 = {};
local os_clock = os.clock;
local u2 = game:GetService("RunService"):IsServer();

local function scaleCooldown(p3: userdata, p4: number, p5: string) -- Line: 22
    -- upvalues: PlayerStatResolver (copy), CombatBalance (copy)
    if typeof(p4) ~= "number" or p4 <= 0 then
        return p4;
    end;

    local v6 = (1 - (PlayerStatResolver.GetStat(p3, "Cooldown Reduction Factor") or 0)) * CombatBalance.CastKnob(p3, p5, "Cooldown");

    return p4 * math.max(v6, 0.1);
end;

function u1.fetch(p7: userdata, p8: string) -- Line: 28
    -- upvalues: Character_info_provider (copy), PlayerProfile (copy), PlayerStatResolver (copy), CombatBalance (copy), gameSettings (copy)
    if p7 == nil or p8 == nil then
        return 9999;
    end;

    game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Data"):WaitForChild(p7.Name);
    local _equipped_tool = Character_info_provider.Get_equipped_tool(p7);
    local v9 = 9999;
    local v10 = PlayerProfile.skill_info[p8];

    if v10 then
        if typeof(v10.Cooldown) == "number" then
            local Cooldown = v10.Cooldown;

            if typeof(Cooldown) ~= "number" or Cooldown <= 0 then
                return Cooldown;
            end;

            local v11 = (1 - (PlayerStatResolver.GetStat(p7, "Cooldown Reduction Factor") or 0)) * CombatBalance.CastKnob(p7, p8, "Cooldown");

            return Cooldown * math.max(v11, 0.1);
        end;

        if typeof(v10.Cooldown) ~= "table" then
            local v12 = gameSettings.defaultSkillCooldown or 1;

            if typeof(v12) ~= "number" or v12 <= 0 then
                return v12;
            end;

            local v13 = (1 - (PlayerStatResolver.GetStat(p7, "Cooldown Reduction Factor") or 0)) * CombatBalance.CastKnob(p7, p8, "Cooldown");

            return v12 * math.max(v13, 0.1);
        end;

        if _equipped_tool == nil or not v10.Cooldown[_equipped_tool.Name] then
            for _, v in pairs(v10.Cooldown) do
                v9 = v;
                break;
            end;
        else
            v9 = v10.Cooldown[_equipped_tool.Name];
        end;

        if typeof(v9) ~= "number" or v9 <= 0 then
            return v9;
        end;

        local v14 = (1 - (PlayerStatResolver.GetStat(p7, "Cooldown Reduction Factor") or 0)) * CombatBalance.CastKnob(p7, p8, "Cooldown");
        v9 = v9 * math.max(v14, 0.1);
    end;

    return v9;
end;

function u1.skillStatus(p15: userdata, p16: string) -- Line: 58
    -- upvalues: PlayerProfile (copy)
    local v17 = p15 ~= nil and p15.Character ~= nil and (p15.Character:FindFirstChild("SHC") or p15.Character:FindFirstChild("SHCS"));

    if v17 then
        if p16 == nil then
            p16 = v17.Value;
        end;

        local v18 = PlayerProfile.skill_info[p16];

        if v18 then
            return v18.lastUsed or 0, v17.Value == p16;
        end;
    end;

    return 0, false;
end;

local function serverLead() -- Line: 75
    -- upvalues: u2 (copy)
    return u2 and 0.25 or 0;
end;

function u1.set_skill_cd(p19: userdata, p20: string, p21: number) -- Line: 78
    -- upvalues: u1 (copy), os_clock (copy), DebrisModule (copy), u2 (copy), PlayerProfile (copy), Stats (copy), gameSettings (copy)
    if p19 == nil or p19.Character == nil then
        return;
    end;

    local v22 = p21 == nil and 9999 or p21;
    local v23 = p19.Character:FindFirstChild("SHC") or p19.Character:FindFirstChild("SHCS");

    if not v23 then
        return;
    end;

    local v24 = u1.filter_cd_name(p19, p20);

    if v23:FindFirstChild(v24) ~= nil then
        v23[v24]:Destroy();
    end;

    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = v24;
    NumberValue.Value = v22;
    NumberValue:SetAttribute("Started", os_clock());
    NumberValue.Parent = v23;
    DebrisModule:AddItem(NumberValue, v22 - (u2 and 0.25 or 0));
    local CooldownGroup = PlayerProfile.skill_info[p20].CooldownGroup;

    if CooldownGroup == nil then
        return;
    end;

    local v25 = os_clock();

    for i, v in PlayerProfile.skill_info do
        if v.CooldownGroup == CooldownGroup and (i ~= p20 and Stats.SourceCheck(p19, i)) then
            local _, v26 = Stats.GetRequirements(p19, i);

            if v26 then
                local v27 = u1.filter_cd_name(p19, i);
                local v28 = u1.fetch(p19, i) * gameSettings.CooldownGroupShare;
                local v29 = v23:FindFirstChild(v27);
                local v30;

                if v29 == nil then
                    v30 = Instance.new("NumberValue");
                    v30.Name = v27;
                    v30.Value = v28;
                    v30:SetAttribute("Started", v25);
                    v30.Parent = v23;
                    DebrisModule:AddItem(v30, v28 - (u2 and 0.25 or 0));
                elseif v28 > v29:GetAttribute("Started") + v29.Value - v25 then
                    v29:Destroy();
                    v30 = Instance.new("NumberValue");
                    v30.Name = v27;
                    v30.Value = v28;
                    v30:SetAttribute("Started", v25);
                    v30.Parent = v23;
                    DebrisModule:AddItem(v30, v28 - (u2 and 0.25 or 0));
                end;
            end;
        end;
    end;
end;

local u31 = u2 and "SHCS" or "SHC";

local function ensureSlot(p32: userdata) -- Line: 150
    -- upvalues: u31 (copy)
    local v33 = p32:FindFirstChild(u31);

    if v33 == nil then
        v33 = Instance.new("StringValue");
        v33.Name = u31;
        v33:SetAttribute("CK", "");
        v33:SetAttribute("en", false);
        v33.Parent = p32;
    end;

    return v33;
end;

function u1.RuleEnabled(p34: string) -- Line: 167
    -- upvalues: gameSettings (copy)
    local SkillCooldownRules = gameSettings.SkillCooldownRules;
    local v35;

    if SkillCooldownRules == nil then
        v35 = nil;
    else
        v35 = SkillCooldownRules[p34];
    end;

    if v35 == nil or v35.Enabled ~= true then
        return false;
    end;

    for _, v in v35.DisabledPlaces or {} do
        if v == game.PlaceId then
            return false;
        end;
    end;

    local PvPModes = v35.PvPModes;

    if PvPModes ~= nil and workspace:GetAttribute("MinigameKey") == "PvP" then
        local Attribute = workspace:GetAttribute("MinigameGamemode");
        local v36;

        if typeof(Attribute) == "string" then
            v36 = PvPModes[Attribute];
        else
            v36 = nil;
        end;

        if v36 == nil then
            v36 = PvPModes.Default;
        end;

        if v36 ~= nil then
            return v36 == true;
        end;
    end;

    return true;
end;

function u1.snapshot(p37: userdata?) -- Line: 186
    -- upvalues: u1 (copy), u31 (copy), os_clock (copy)
    if not u1.RuleEnabled("CarryAcrossDeath") then
        return nil;
    end;

    local v38;

    if p37 == nil then
        v38 = nil;
    else
        v38 = p37:FindFirstChild(u31);
    end;

    if v38 == nil then
        return nil;
    end;

    local v39 = os_clock();
    local v40 = {};

    for _, child in v38:GetChildren() do
        local Attribute = child:GetAttribute("Started");

        if child:IsA("NumberValue") and (typeof(Attribute) == "number" and v39 < Attribute + child.Value) then
            table.insert(v40, {
                Name = child.Name,
                CoolDown = child.Value,
                Started = Attribute
            });
        end;
    end;

    if #v40 > 0 then
        return v40;
    end;

    return nil;
end;

function u1.restore(p41: userdata?, p42: table?) -- Line: 201
    -- upvalues: u31 (copy), os_clock (copy), u2 (copy), DebrisModule (copy)
    if p41 == nil or p42 == nil then
        return;
    end;

    local v43 = p41:FindFirstChild(u31);

    if v43 == nil then
        v43 = Instance.new("StringValue");
        v43.Name = u31;
        v43:SetAttribute("CK", "");
        v43:SetAttribute("en", false);
        v43.Parent = p41;
    end;

    local v44 = os_clock();
    local v45 = u2 and 0.25 or 0;

    for _, v in p42 do
        local v46 = v.Started + v.CoolDown - v44;

        if v46 > v45 and v43:FindFirstChild(v.Name) == nil then
            local NumberValue = Instance.new("NumberValue");
            NumberValue.Name = v.Name;
            NumberValue.Value = v.CoolDown;
            NumberValue:SetAttribute("Started", v.Started);
            NumberValue.Parent = v43;
            DebrisModule:AddItem(NumberValue, v46 - v45);
        end;
    end;
end;

function u1.filter_cd_name(p47: userdata, p48: string) -- Line: 218
    -- upvalues: PlayerProfile (copy)
    if p47 ~= nil and p48 ~= nil then
        return PlayerProfile.skill_info[p48].CoolDownName or p48;
    end;
end;

return u1;