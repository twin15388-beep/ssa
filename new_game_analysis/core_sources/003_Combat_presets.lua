-- Decompiled with Potassium's decompiler.

game:GetService("StarterPlayer");
local u1 = {
    Last_Punched = 0,
    lastRunHit = 0,
    slow_walk_duration = 0.5,
    slow_walk_speed = 7,
    Last_Punched_Jump = 0,
    No_Jump_Duration = 1.15,
    Last_Combo = 0,
    Last_Climb = 0,
    Is_Air_Combo = false,
    combo_duration = 1.35,
    Default_Swing_Wait = 0.15,
    Presets = {
        Combat = {
            default = 0.26,
            default_before_hit = 0.2,
            default_before_swing = 0.2,
            run_swing_remove_on_first = 0.092,
            final = 1.65,
            AccessoryHitBoxAdditions = {
                Ribbons = 6
            },
            AnimSpeed = {
                Default = 1.125,
                [3] = 1.3,
                [4] = 1.5,
                [5] = 0.85
            },
            delay_before_swing = {
                [5] = 0.2,
                [1] = 0.07,
                [7] = 0.255
            },
            delay_before_hit = {
                [6] = 0.16666666666666666,
                [5] = 0.35,
                [7] = 0.295
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Punch_Effect",
                [7] = "N/A"
            }
        },
        ["Regular Katana"] = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [7] = "N/A"
            }
        },
        ["Insect Katana"] = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25,
                [6] = 1.35,
                [7] = 1.3
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [7] = "N/A"
            }
        },
        ["Sound Katanas"] = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [7] = "N/A"
            }
        },
        Scythe = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [7] = "N/A"
            }
        },
        ["Bladed Wagasa"] = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [7] = "N/A"
            }
        },
        Gauntlet = {
            default = 0.26,
            default_before_hit = 0.2,
            default_before_swing = 0.2,
            run_swing_remove_on_first = 0.085,
            final = 1.65,
            delay_before_swing = {
                [5] = 0.2,
                [1] = 0.07,
                [7] = 0.255
            },
            delay_before_hit = {
                [6] = 0.16666666666666666,
                [7] = 0.295
            },
            finals = { 5, 7 },
            Widths = {
                Default = 2
            },
            Reaches = {
                Default = 1
            },
            Effects = {
                Default = "Normal_Punch_Effect",
                [7] = "N/A"
            }
        },
        Soryu = {
            default = 0.32,
            default_before_hit = 0.2,
            default_before_swing = 0.2,
            run_swing_remove_on_first = 0.092,
            final = 1.65,
            AnimSpeed = {
                Default = 1.5
            },
            finals = { 5, 7 },
            Reaches = {
                Default = 2
            },
            Widths = {
                Default = 1.5
            },
            Effects = {
                Default = "Normal_Punch_Effect",
                [7] = "N/A"
            }
        },
        ["Tai Chi"] = {
            default = 0.26,
            default_before_hit = 0.2,
            default_before_swing = 0.25,
            run_swing_remove_on_first = 0.092,
            final = 1.65,
            finals = { 5, 7 },
            Reaches = {
                Default = 2
            },
            Widths = {
                Default = 1.5
            },
            Effects = {
                Default = "Normal_Punch_Effect",
                [7] = "N/A"
            }
        },
        Spear = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            Reaches = {
                Default = 2
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [7] = "N/A"
            }
        },
        Tanto = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [5] = "Normal_Punch_Effect",
                [7] = "N/A"
            }
        },
        ["War Fans"] = {
            default = 0.25,
            default_before_hit = 0.275,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15,
                [-1] = 1.3,
                [4] = 1.25
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.15,
                [1] = 0.15,
                [7] = 0.2
            },
            delay_before_hit = {
                [5] = 0.275,
                [4] = 0.25,
                [7] = 0.25
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sword_Slash_Effect",
                [7] = "N/A"
            }
        },
        Shotgun = {
            default = 0.25,
            default_before_hit = 0.24,
            default_before_swing = 0.15,
            run_swing_remove_on_first = 0.032,
            final = 1.65,
            finals = { 5, 7 },
            Effects = {
                Default = "Hit_Highlight_Effect",
                [6] = "Normal_Punch_Effect",
                [7] = "Hit_Highlight_Effect"
            }
        },
        Sickles = {
            default = 0.25,
            default_before_hit = 0.2,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.092,
            final = 1.65,
            AnimSpeed = {
                Default = 1.15
            },
            delay_before_swing = {
                [5] = 0.2,
                [4] = 0.25,
                [1] = 0.14,
                [7] = 0.3
            },
            delay_before_hit = {
                [5] = 0.25,
                [4] = 0.25,
                [6] = 0.19,
                [7] = 0.35
            },
            finals = { 5, 7 },
            Effects = {
                Default = "Normal_Sickle_Slash_Effect",
                [7] = "N/A"
            }
        },
        Claws = {
            default = 0.3,
            default_before_hit = 0.22,
            default_before_swing = 0.21,
            run_swing_remove_on_first = 0.092,
            final = 1.65,
            AnimSpeed = {
                Default = 1
            },
            finals = { 5, 7 },
            delay_before_swing = {
                [5] = 0.3
            },
            delay_before_hit = {
                [5] = 0.4
            },
            Effects = {
                Default = "Claw_Slash_Effect",
                [7] = "N/A"
            }
        }
    }
};

for i, v in pairs(require(script:WaitForChild("MorePresets"))) do
    u1.Presets[i] = v;
end;

u1.Presets["Blood Manipulation"] = u1.Presets.Sickles;

for i in require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Powers"):WaitForChild("FightingStyles")) do
    if u1.Presets[i] == nil then
        u1.Presets[i] = u1.Presets.Combat;
    end;
end;

local u2 = { "Landed_Anim", "Dash", "blockr", "blockl", "backpack_anim" };

function u1.stop_extra_anims(p3: userdata, p4: table) -- Line: 232
    -- upvalues: u2 (copy)
    for _, v in pairs(p3.Animator:GetPlayingAnimationTracks()) do
        if string.find(v.Name, "React_") ~= nil or (string.find(v.Name, "Dash_") ~= nil or p4 ~= nil and table.find(p4, v.Name) ~= nil) or table.find(u2, v.Name) then
            v:Stop();
            v:Destroy();
        end;
    end;
end;

local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
local PlayerStatResolver = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("PlayerStatResolver"));
local os_clock = os.clock;
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local math_clamp = math.clamp;

function u1.attackSpeedMult(p5: userdata?) -- Line: 250
    -- upvalues: PlayerStatResolver (copy)
    if p5 == nil then
        return 1;
    end;

    local v6;

    if p5:IsA("Player") then
        v6 = p5;
    else
        v6 = game.Players:GetPlayerFromCharacter(p5);
    end;

    local v7 = 1 + (PlayerStatResolver.GetStat(v6 or p5, "Attack Speed Factor") or 0);

    return math.max(v7, 0.25);
end;

function u1.runHitPreset(p8: any, p9: boolean) -- Line: 260
    -- upvalues: u1 (copy)
    if p9 and (p8 ~= nil and p8.CombatRunHit == true) then
        return u1.Presets.Combat;
    end;

    return p8;
end;

function get_combat_cd_info(p10, p11, p12)
    -- upvalues: u1 (copy), os_clock (copy), math_clamp (copy)
    if p10 ~= nil or (p11 ~= nil or p12 ~= nil) then
        local Attribute = p10:GetAttribute("last_cmbat");
        local Attribute2 = p10:GetAttribute("last_combo");
        local v13 = 10000;

        if p12 - 1 == Attribute2 or p12 == 6 and p12 - 2 == Attribute2 then
            v13 = p11.customDelay and p11.customDelay[p12] or p11.default;
        elseif p12 == 1 then
            if Attribute2 == 5 or Attribute2 == 7 then
                v13 = p11.final;
            else
                v13 = u1.combo_duration;
            end;
        end;

        local v14 = v13 / u1.attackSpeedMult(p10);
        local v15 = os_clock() - Attribute;

        return math_clamp(v14 - v15, 0, 1), v15 / v14;
    end;
end;

local math_random = math.random;

function u1.PlayReactAnim(p16: userdata?, p17: number?, p18: number?, p19: userdata?) -- Line: 295
    -- upvalues: math_random (copy), u1 (copy), Character_info_provider (copy)
    if p16 ~= nil then
        local Parent = p16.Parent;

        if p17 == nil and p19 == nil then
            p17 = math_random(1, 5);
        end;

        local v20 = p17 == 5 and 6 or p17;
        u1.stop_extra_anims(p16);
        local v21 = p19 or Character_info_provider.get_core_anim(Parent, "React_" .. v20);

        if v21 == nil and p19 == nil then
            v21 = Character_info_provider.get_core_anim(Parent, "React_" .. (v20 - 1) % 3 + 1);
        end;

        local v22;

        if v21 then
            v22 = p16.Animator:LoadAnimation(v21);
            v22:Play();

            if p18 == nil then
                p18 = v21:GetAttribute("SI");
            end;

            local _ = v22.Length;

            if p18 then
                v22:AdjustSpeed(p18);
            end;
        else
            v22 = nil;
        end;

        return v22;
    end;
end;

function u1.Check_can_do_combat_server(p23, p24, p25) -- Line: 325
    -- upvalues: os_clock (copy)
    local v26 = false;

    if p23 ~= nil and (p24 ~= nil and p25 ~= nil) then
        if p23:GetAttribute("last_cmbat") == nil then
            v26 = true;
        else
            local v27, _ = get_combat_cd_info(p23, p24, p25);
            task.wait(v27);
            local v28, v29 = get_combat_cd_info(p23, p24, p25);
            v26 = v28 ~= nil and v29 >= 0.95 and true or v26;
        end;

        if v26 == true then
            p23:SetAttribute("last_cmbat", os_clock());
            p23:SetAttribute("last_combo", p25);
        end;
    end;

    return v26;
end;

function u1.Get_Players_For_Combat(p30, p31, p32, p33, p34, p35) -- Line: 353
    -- upvalues: PlayerStatResolver (copy), Character_info_provider (copy), u1 (copy), gameSettings (copy), Utility (copy)
    local PlayerFromCharacter = game:GetService("Players"):GetPlayerFromCharacter(p32);
    local v36 = 1 + (PlayerStatResolver.GetStat(PlayerFromCharacter or p32, "Dash Speed Factor") or 0);
    local math_max_ret = math.max(1, v36);
    local math_clamp_ret = math.clamp(p30.Velocity.Magnitude / 5, 0, math_max_ret * 13);

    if math_clamp_ret <= 5 then
        math_clamp_ret = math_clamp_ret / 2;
    end;

    local v37 = p30.Velocity.Unit * math_clamp_ret;
    local v38 = Vector3.new(v37.X, 0, v37.Z) * 1.25;

    if v38.Magnitude <= 1 or (v38.Magnitude > 100 or v38.Magnitude ~= v38.Magnitude) then
        v38 = p30.CFrame.lookVector;
    end;

    if p30:FindFirstChild("last_magasd") == nil then
        local IntValue = Instance.new("IntValue");
        IntValue.Name = "last_magasd";
        local u39 = 0;
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = "last_root";
        ObjectValue.Parent = IntValue;
        IntValue.Parent = p30;
        IntValue.Changed:Connect(function() -- Line: 379
            -- upvalues: u39 (ref), IntValue (copy)
            local math_random_ret = math.random(1, 9999);
            u39 = math_random_ret;
            task.wait(0.75);

            if u39 == math_random_ret then
                IntValue.Value = 0;

                if IntValue:FindFirstChild("last_root") ~= nil then
                    IntValue.last_root.Value = nil;
                end;
            end;
        end);
    end;

    if p33 == true then
        if p30.last_magasd.Value < v38.Magnitude then
            p30.last_magasd.Value = v38.Magnitude;
        else
            p30.last_magasd.Value = (p30.last_magasd.Value + v38.Magnitude) * 0.5;
        end;
    end;

    local v40 = p34 == nil and 0 or (p34.MinHitboxSize or 0);
    local _equipped_tool = Character_info_provider.Get_equipped_tool(p32);

    if _equipped_tool then
        local v41 = u1.Presets[_equipped_tool.Name];

        if v41 then
            v40 = math.max(v40, v41.MinHitboxSize or 0);

            if v41.AccessoryHitBoxAdditions then
                for i, v in pairs(v41.AccessoryHitBoxAdditions) do
                    if p32:FindFirstChild("Accessories") ~= nil and p32.Accessories:FindFirstChild(i) ~= nil then
                        v40 = math.max(v, v40);
                    end;
                end;
            end;
        end;
    end;

    if p34.Reaches ~= nil and (p34.Reaches[p31] or p34.Reaches.Default) then
        v40 = v40 + (p34.Reaches[p31] or p34.Reaches.Default);
    end;

    local Unit = v38.Unit;

    if p30.last_magasd.last_root.Value ~= nil then
        Unit = CFrame.new(p30.Position, p30.last_magasd.last_root.Value.Position).LookVector;
    end;

    local math_min_ret = math.min(p30.last_magasd.Value, 7);
    local v42;

    if v40 < 0 then
        v42 = math.max(math_min_ret + v40, 1);
    else
        local math_max_ret2 = math.max(v40, math_min_ret);
        v42 = math.clamp(math_min_ret, math_max_ret2, 99999);
    end;

    local v43 = Unit * v42;
    local v44 = p30.CFrame * CFrame.new(0, -1, 0);

    if p34.YOffsets ~= nil and (p34.YOffsets[p31] or p34.YOffsets.Default) then
        v44 = v44 * CFrame.new(0, p34.YOffsets[p31] or p34.YOffsets.Default, 0);
    end;

    local v45, v46;

    if p31 == 7 then
        v45 = 4;
        v46 = 7;
    else
        v45 = 0;
        v46 = 0;
    end;

    local v47 = not p35 and 1 or 1 / gameSettings.NpcCombatHitboxShrink;
    local v48 = (p34.Widths == nil or not (p34.Widths[p31] or p34.Widths.Default)) and 0 or (p34.Widths[p31] or p34.Widths.Default);
    local math_max_ret2 = math.max(v46 + 9 + ((p34.Depths == nil or not (p34.Depths[p31] or p34.Depths.Default)) and 0 or (p34.Depths[p31] or p34.Depths.Default)), 1);
    local v49 = Vector3.new(v45 + 6 + v48, v48 + 6.25, math_max_ret2) * v47 + Vector3.new(0, 0, v43.Magnitude);
    local v50 = CFrame.new(v44.Position, v44.Position + v43) * CFrame.new(0, 0, -v43.Magnitude * 0.75);

    if p34.ZOffsets ~= nil and (p34.ZOffsets[p31] or p34.ZOffsets.Default) then
        v50 = v50 * CFrame.new(0, 0, -(p34.ZOffsets[p31] or p34.ZOffsets.Default));
    end;

    local ModelInRegion = Utility.GetModelInRegion(v50, v49, nil, 350);
    local v51 = {};

    for _, v in pairs(ModelInRegion) do
        if v:FindFirstChild("Humanoid") and (v ~= p32 and table.find(v51, v) == nil) then
            table.insert(v51, v);
        end;
    end;

    return v51;
end;

return u1;