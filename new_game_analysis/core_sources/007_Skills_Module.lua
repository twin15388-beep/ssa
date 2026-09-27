-- Decompiled with Potassium's decompiler.

local u1 = {
    serverMarginOfError = 1
};
local os_clock = os.clock;
local Skills = game.ReplicatedStorage:WaitForChild("Skills");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = RunService:IsServer();
local u3;

if u2 then
    u3 = require(game:GetService("ServerStorage").SAM.BanActions);
else
    u3 = nil;
end;

local string_find = string.find;
local string_lower = string.lower;
task.spawn(function() -- Line: 17
    -- upvalues: Skills (copy), RunService (copy), string_find (copy), string_lower (copy), u1 (copy)
    for _, v in pairs(Skills:QueryDescendants("ModuleScript:not([$Ignore])")) do
        if RunService:IsServer() and string_find(string_lower(v.Name), "server") or RunService:IsServer() == false and string_find(string_lower(v.Name), "server") == nil then
            u1[v.Name] = require(v);
        end;
    end;
end);
local manage_cd = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("manage_cd"));
local Skill_Info = require(ReplicatedStorage.CAM.Global.PlayerProfile.Skill_Info);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
local u4 = 0;
local u5 = 0;

function u1.Can_Skill(p6, p7) -- Line: 39
    -- upvalues: string_find (copy), manage_cd (copy), Skill_Info (copy), u2 (copy), u1 (copy), os_clock (copy), Stats (copy), u3 (copy), u5 (ref), PlayerStatResolver (copy), u4 (ref)
    local v8;

    if p6 == nil or p6.Character == nil then
        v8 = nil;
    else
        v8 = p6.Character:FindFirstChild("SHC") or p6.Character:FindFirstChild("SHCS");
    end;

    local v9 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p6.Name);
    local skillsdisabled = v9:FindFirstChild("skillsdisabled");

    if skillsdisabled ~= nil then
        if string_find(skillsdisabled.Value, "all") == nil then
            if string_find(skillsdisabled.Value, p7) ~= nil then
                return;
            end;
        elseif string_find(skillsdisabled.Value, "except" .. p7) == nil then
            return;
        end;
    end;

    local v10 = manage_cd.filter_cd_name(p6, p7);
    local v11 = Skill_Info[p7];
    local v12;

    if p6 == nil or (p6.Character == nil or v8 == nil) then
        v12 = false;
    else
        v12 = v8:FindFirstChild(v10);
    end;

    local v13;

    if v12 == nil then
        v13 = true;
    else
        local v14 = u2 ~= true and 0 or u1.serverMarginOfError;
        local v15 = os_clock() - v12:GetAttribute("Started") + v14;

        if v14 > 0 then
            v15 = math.round(v15);
        end;

        local Value = v12.Value;
        v13 = typeof(Value) == "number" and Value <= v15 and true or v12;
    end;

    local _, v16 = Stats.GetRequirements(p6, p7);
    local v17 = v16 and true or false;
    local v18, v19 = Stats.SourceCheck(p6, p7);

    if not v18 and u3 ~= nil then
        u3.Tier1(p6, "Casted a skill their loadout does not provide", v19);
    end;

    local v20;

    if v11 == nil or v11.RequiresAura == nil then
        v20 = true;
    else
        v20 = v9:FindFirstChild(v11.RequiresAura) ~= nil;

        if not (v20 or (u2 or os_clock() - u5 <= 1.5)) then
            u5 = os_clock();
            game.ReplicatedStorage.Communication.CnC.Notifications.Notification:Fire("Notify", {
                Type = "Warn",
                Text = v11.RequiresAura .. " is not active"
            });
        end;
    end;

    local v21;

    if v11 == nil or v11.Stamina == nil then
        v21 = true;
    else
        local v22 = PlayerStatResolver.GetStat(p6, "Stamina Cost Factor") or 0;

        if v11.Category ~= nil then
            v22 = v22 + (PlayerStatResolver.GetStat(p6, v11.Category .. " Stamina Cost Factor") or 0);
        end;

        local math_max_ret = math.max(0, v11.Stamina * (1 + v22));
        v21 = math_max_ret <= v9.Stamina.Value;

        if v21 then
            if u2 and (v20 and (v18 and (v13 == true and v17))) then
                local Stamina = v9.Stamina;
                Stamina.Value = Stamina.Value - math_max_ret;
            end;
        elseif not u2 then
            game.ReplicatedStorage.Communication.CnC.NotEnoughStamina:Fire(v11.Stamina / v9.Stamina.MaxValue);

            if os_clock() - u4 > 1.5 then
                u4 = os_clock();
                game.ReplicatedStorage.Communication.CnC.Notifications.Notification:Fire("Notify", {
                    Text = "Your stamina is too low",
                    Type = "Warn"
                });
            end;
        end;
    end;

    local v23;

    if v11 == nil or v11.RequiresModeBar ~= true then
        v23 = true;
    else
        local ModeBar = v9:FindFirstChild("ModeBar");

        if ModeBar == nil then
            v23 = false;
        else
            v23 = ModeBar.Value >= ModeBar.MaxValue;
        end;

        if v23 and (u2 and (v13 == true and (v17 and (v21 and (v20 and v18))))) then
            ModeBar.Value = 0;
        end;
    end;

    if v13 == true then
        if v17 then
            if v21 then
                if v23 then
                    if not v20 then
                        v18 = v20;
                    end;
                else
                    v18 = v23;
                end;
            else
                v18 = v21;
            end;
        else
            v18 = v17;
        end;
    else
        v18 = false;
    end;

    return v18;
end;

return u1;