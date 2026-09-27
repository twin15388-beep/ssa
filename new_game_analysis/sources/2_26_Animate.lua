-- Decompiled with Potassium's decompiler.

local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
local u1 = "Standing";
local LocalPlayer = game.Players.LocalPlayer;
game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Default_Core");
local success, result = pcall(function() -- Line: 8
    return UserSettings():IsUserFeatureEnabled("UserNoUpdateOnLoop");
end);
local u2 = success and result;
local success2, result2 = pcall(function() -- Line: 11
    return UserSettings():IsUserFeatureEnabled("UserEmoteToRunThresholdChange");
end);
local u3 = success2 and result2;
local success3, result3 = pcall(function() -- Line: 18
    return UserSettings():IsUserFeatureEnabled("UserPlayEmoteByIdAnimTrackReturn2");
end);
local u4 = success3 and result3;
local ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent");
local u5 = "";
local currentAnimInstance = script:WaitForChild("currentAnimInstance");
current_anims_ft = {};
local Equipped = game.Players.LocalPlayer:WaitForChild("Items_Config", 999):WaitForChild("Equipped");
local v6 = game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Data"):WaitForChild(game.Players.LocalPlayer.Name, 9999);
v6:WaitForChild("slotEquipped");
local v7 = v6.slots:FindFirstChild("Slot" .. v6.slotEquipped.Value);
local CurPower = game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Skills_Provider"):WaitForChild("CurPower");

function upd_animz()
    -- upvalues: script_Parent (copy), u5 (ref), Humanoid (copy)
    task.wait();

    if script_Parent and (script_Parent:FindFirstChild("Humanoid") and script_Parent.Humanoid.Health > 0) then
        playAnimation(u5, 0.2, Humanoid);
    end;
end;

script_Parent.ChildAdded:Connect(function(p8) -- Line: 60
    if p8.Name == "Mode" then
        upd_animz();
    end;
end);
script_Parent.ChildRemoved:Connect(function(p9) -- Line: 65
    if p9.Name == "Mode" then
        upd_animz();
    end;
end);
CurPower.Changed:Connect(upd_animz);
v7.Race.Changed:Connect(upd_animz);
local u10 = {};
local u11 = {};
local u12 = nil;
local u13 = nil;
local u14 = 1;
local u15 = nil;
local u16 = nil;

for _, child in pairs(v7.Powers:GetChildren()) do
    child.Changed:Connect(upd_animz);
end;

Equipped.Changed:Connect(upd_animz);

for _, child in pairs(v7.Inventory.Toolbar:GetChildren()) do
    local u17 = child.Name == "One" and 1 or (child.Name == "Two" and 2 or (child.Name == "Three" and 3 or (child.Name == "Four" and 4 or (child.Name == "Five" and 5 or false))));
    child.Changed:Connect(function() -- Line: 78
        -- upvalues: u17 (copy), Equipped (copy)
        if u17 == Equipped.Value then
            upd_animz();
        end;
    end);
end;

local u18 = {
    idle = { {
            id = "rbxassetid://10586618784",
            weight = 9
        } },
    walk = { {
            id = "rbxassetid://10586557245",
            weight = 10
        } },
    run = { {
            id = "rbxassetid://10559842909",
            weight = 10
        } },
    swim = { {
            id = "http://www.roblox.com/asset/?id=507784897",
            weight = 10
        } },
    swimidle = { {
            id = "http://www.roblox.com/asset/?id=507785072",
            weight = 10
        } },
    jump = { {
            id = "rbxassetid://11872465397",
            weight = 10
        } },
    fall = { {
            id = "rbxassetid://10586578992",
            weight = 10
        } },
    climb = { {
            id = "http://www.roblox.com/asset/?id=507765644",
            weight = 10
        } },
    sit = { {
            id = "http://www.roblox.com/asset/?id=2506281703",
            weight = 10
        } },
    toolnone = { {
            id = "http://www.roblox.com/asset/?id=507768375",
            weight = 10
        } },
    toolslash = { {
            id = "http://www.roblox.com/asset/?id=522635514",
            weight = 10
        } },
    toollunge = { {
            id = "http://www.roblox.com/asset/?id=522638767",
            weight = 10
        } },
    wave = { {
            id = "http://www.roblox.com/asset/?id=507770239",
            weight = 10
        } },
    point = { {
            id = "http://www.roblox.com/asset/?id=507770453",
            weight = 10
        } },
    dance = { {
            id = "http://www.roblox.com/asset/?id=507771019",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507771955",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507772104",
            weight = 10
        } },
    dance2 = { {
            id = "http://www.roblox.com/asset/?id=507776043",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507776720",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507776879",
            weight = 10
        } },
    dance3 = { {
            id = "http://www.roblox.com/asset/?id=507777268",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507777451",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=507777623",
            weight = 10
        } },
    laugh = { {
            id = "http://www.roblox.com/asset/?id=507770818",
            weight = 10
        } },
    cheer = { {
            id = "http://www.roblox.com/asset/?id=507770677",
            weight = 10
        } }
};
local u19 = {
    wave = false,
    point = false,
    dance = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
};
math.randomseed(tick());

function findExistingAnimationInSet(p20, p21)
    if p20 == nil or p21 == nil then
        return 0;
    end;

    for i = 1, p20.count do
        if p20[i].anim.AnimationId == p21.AnimationId then
            return i;
        end;

        local _ = i;
    end;

    return 0;
end;

function configureAnimationSet(u22, u23)
    -- upvalues: u10 (copy), u11 (copy), Humanoid (copy)
    if u10[u22] ~= nil then
        for _, v in pairs(u10[u22].connections) do
            v:disconnect();
        end;
    end;

    u10[u22] = {};
    u10[u22].count = 0;
    u10[u22].totalWeight = 0;
    u10[u22].connections = {};
    local u24 = true;
    local success4, _ = pcall(function() -- Line: 186
        -- upvalues: u24 (ref)
        u24 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u24 = not success4 and true or u24;
    local v25 = script:FindFirstChild(u22);

    if u24 and v25 ~= nil then
        table.insert(u10[u22].connections, v25.ChildAdded:connect(function(p26) -- Line: 194
            -- upvalues: u22 (copy), u23 (copy)
            configureAnimationSet(u22, u23);
        end));
        table.insert(u10[u22].connections, v25.ChildRemoved:connect(function(p27) -- Line: 195
            -- upvalues: u22 (copy), u23 (copy)
            configureAnimationSet(u22, u23);
        end));

        for _, child in pairs(v25:GetChildren()) do
            if child:IsA("Animation") then
                local Weight = child:FindFirstChild("Weight");
                local v28 = Weight == nil and 1 or Weight.Value;
                u10[u22].count = u10[u22].count + 1;
                local count = u10[u22].count;
                u10[u22][count] = {};
                u10[u22][count].anim = child;
                u10[u22][count].weight = v28;
                u10[u22].totalWeight = u10[u22].totalWeight + u10[u22][count].weight;
                table.insert(u10[u22].connections, child.Changed:connect(function(p29) -- Line: 211
                    -- upvalues: u22 (copy), u23 (copy)
                    configureAnimationSet(u22, u23);
                end));
                table.insert(u10[u22].connections, child.ChildAdded:connect(function(p30) -- Line: 212
                    -- upvalues: u22 (copy), u23 (copy)
                    configureAnimationSet(u22, u23);
                end));
                table.insert(u10[u22].connections, child.ChildRemoved:connect(function(p31) -- Line: 213
                    -- upvalues: u22 (copy), u23 (copy)
                    configureAnimationSet(u22, u23);
                end));
            end;
        end;
    end;

    if u10[u22].count <= 0 then
        for i, v in pairs(u23) do
            u10[u22][i] = {};
            u10[u22][i].anim = Instance.new("Animation");
            u10[u22][i].anim.Name = u22;
            u10[u22][i].anim.AnimationId = v.id;
            u10[u22][i].weight = v.weight;
            u10[u22].count = u10[u22].count + 1;
            u10[u22].totalWeight = u10[u22].totalWeight + v.weight;
        end;
    end;

    for _, v in pairs(u10) do
        local v32 = v;

        for i = 1, v.count do
            local v33;

            if u11[v32[i].anim.AnimationId] == nil then
                Humanoid:LoadAnimation(v32[i].anim);
                u11[v32[i].anim.AnimationId] = true;
                v33 = i;
            else
                v33 = i;
            end;
        end;
    end;
end;

function configureAnimationSetOld(u34, u35)
    -- upvalues: u10 (copy), Humanoid (copy)
    if u10[u34] ~= nil then
        for _, v in pairs(u10[u34].connections) do
            v:disconnect();
        end;
    end;

    u10[u34] = {};
    u10[u34].count = 0;
    u10[u34].totalWeight = 0;
    u10[u34].connections = {};
    local u36 = true;
    local success4, _ = pcall(function() -- Line: 257
        -- upvalues: u36 (ref)
        u36 = game:GetService("StarterPlayer").AllowCustomAnimations;
    end);
    u36 = not success4 and true or u36;
    local v37 = script:FindFirstChild(u34);

    if u36 and v37 ~= nil then
        table.insert(u10[u34].connections, v37.ChildAdded:connect(function(p38) -- Line: 265
            -- upvalues: u34 (copy), u35 (copy)
            configureAnimationSet(u34, u35);
        end));
        table.insert(u10[u34].connections, v37.ChildRemoved:connect(function(p39) -- Line: 266
            -- upvalues: u34 (copy), u35 (copy)
            configureAnimationSet(u34, u35);
        end));
        local v40 = 1;

        for _, child in pairs(v37:GetChildren()) do
            if child:IsA("Animation") then
                table.insert(u10[u34].connections, child.Changed:connect(function(p41) -- Line: 270
                    -- upvalues: u34 (copy), u35 (copy)
                    configureAnimationSet(u34, u35);
                end));
                u10[u34][v40] = {};
                u10[u34][v40].anim = child;
                local Weight = child:FindFirstChild("Weight");

                if Weight == nil then
                    u10[u34][v40].weight = 1;
                else
                    u10[u34][v40].weight = Weight.Value;
                end;

                u10[u34].count = u10[u34].count + 1;
                u10[u34].totalWeight = u10[u34].totalWeight + u10[u34][v40].weight;
                v40 = v40 + 1;
            end;
        end;
    end;

    if u10[u34].count <= 0 then
        for i, v in pairs(u35) do
            u10[u34][i] = {};
            u10[u34][i].anim = Instance.new("Animation");
            u10[u34][i].anim.Name = u34;
            u10[u34][i].anim.AnimationId = v.id;
            u10[u34][i].weight = v.weight;
            u10[u34].count = u10[u34].count + 1;
            u10[u34].totalWeight = u10[u34].totalWeight + v.weight;
        end;
    end;

    for _, v in pairs(u10) do
        local v42 = v;

        for i = 1, v.count do
            Humanoid:LoadAnimation(v42[i].anim);
            local _ = i;
        end;
    end;
end;

function scriptChildModified(p43)
    -- upvalues: u18 (copy)
    local v44 = u18[p43.Name];

    if v44 ~= nil then
        configureAnimationSet(p43.Name, v44);
    end;
end;

script.ChildAdded:connect(scriptChildModified);
script.ChildRemoved:connect(scriptChildModified);
local v45;

if Humanoid then
    v45 = Humanoid:FindFirstChildOfClass("Animator");
else
    v45 = nil;
end;

if v45 then
    local PlayingAnimationTracks = v45:GetPlayingAnimationTracks();

    for _, v in ipairs(PlayingAnimationTracks) do
        v:Stop(0);
        v:Destroy();
    end;
end;

for i, v in pairs(u18) do
    configureAnimationSet(i, v);
end;

local u46 = 0;
local u47 = false;

function stopAllAnimations()
    -- upvalues: u5 (ref), u19 (copy), u47 (ref), currentAnimInstance (copy), u15 (ref), u12 (ref), u13 (ref), u16 (ref)
    local v48 = u5;
    local v49 = u19[v48] ~= nil and u19[v48] == false and "idle" or v48;

    if u47 then
        v49 = "idle";
        u47 = false;
    end;

    u5 = "";
    currentAnimInstance.Value = nil;

    if u15 ~= nil then
        u15:disconnect();
    end;

    if u12 ~= nil then
        u12:Stop();
        u12:Destroy();
        u12 = nil;
    end;

    if u13 ~= nil then
        u13:disconnect();
    end;

    if u16 ~= nil then
        u16:Stop();
        u16:Destroy();
        u16 = nil;
    end;

    return v49;
end;

function getHeightScale()
    -- upvalues: Humanoid (copy), ScaleDampeningPercent (ref)
    if not Humanoid then
        return 1;
    end;

    if not Humanoid.AutomaticScalingEnabled then
        return 1;
    end;

    local v50 = Humanoid.HipHeight / 2;

    if ScaleDampeningPercent == nil then
        ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent");
    end;

    if ScaleDampeningPercent ~= nil then
        v50 = 1 + (Humanoid.HipHeight - 2) * ScaleDampeningPercent.Value / 2;
    end;

    return v50;
end;

local function rootMotionCompensation(p51) -- Line: 407
    return p51 * 1.25 / getHeightScale();
end;

local function setRunSpeed(p52) -- Line: 415
    -- upvalues: u12 (ref), u16 (ref)
    local v53 = p52 * 1.25 / getHeightScale();
    local v54 = 0.0001;
    local _ = v53 / 0.5;
    local _ = v53 / 1;
    local v55;

    if v53 <= 0.5 then
        v54 = 1;
        v55 = 0.0001;
    elseif v53 < 1 then
        v55 = (v53 - 0.5) / 0.5;
        v54 = 1 - v55;
    else
        v55 = 1;
    end;

    u12:AdjustWeight(v54);
    u16:AdjustWeight(v55);
end;

function keyFrameReachedFunc(p56)
    -- upvalues: u5 (ref), u2 (copy), u16 (ref), u12 (ref), u19 (copy), u47 (ref), u14 (ref), Humanoid (copy)
    if p56 == "End" then
        if u5 == "walk" then
            if u2 ~= true then
                u16.TimePosition = 0;
                u12.TimePosition = 0;

                return;
            end;

            if u16.Looped ~= true then
                u16.TimePosition = 0;
            end;

            if u12.Looped ~= true then
                u12.TimePosition = 0;
            end;
        else
            local v57 = u5;
            local v58 = u19[v57] ~= nil and u19[v57] == false and "idle" or v57;

            if u47 then
                if u12.Looped then
                    return;
                end;

                v58 = "idle";
                u47 = false;
            end;

            playAnimation(v58, 0.15, Humanoid);
        end;
    end;
end;

function rollAnimation(p59)
    -- upvalues: u10 (copy)
    local math_random_ret = math.random(1, u10[p59].totalWeight);
    local v60 = 1;

    while u10[p59][v60].weight < math_random_ret do
        math_random_ret = math_random_ret - u10[p59][v60].weight;
        v60 = v60 + 1;
    end;

    return v60;
end;

local function switchToAnim(p61, p62, p63, p64) -- Line: 503
    -- upvalues: currentAnimInstance (copy), u12 (ref), u16 (ref), u2 (copy), u14 (ref), u5 (ref), u15 (ref), Character_info_provider (copy), LocalPlayer (copy), u10 (copy), u13 (ref)
    if p61 ~= currentAnimInstance.Value then
        if u12 ~= nil then
            u12:Stop(p63);
            u12:Destroy();
        end;

        if u16 ~= nil then
            u16:Stop(p63);
            u16:Destroy();

            if u2 == true then
                u16 = nil;
            end;
        end;

        u14 = 1;
        u12 = p64:LoadAnimation(p61);

        if p62 ~= "jump" then
            u12.Priority = Enum.AnimationPriority.Core;
        end;

        u12:Play(p63);
        u5 = p62;
        currentAnimInstance.Value = p61;

        if u15 ~= nil then
            u15:disconnect();
        end;

        u15 = u12.KeyframeReached:connect(keyFrameReachedFunc);

        if p62 == "walk" then
            local v65 = rollAnimation("run");
            u16 = p64:LoadAnimation(Character_info_provider.get_core_anim(LocalPlayer, "run") or u10.run[v65].anim);
            u16.Priority = Enum.AnimationPriority.Core;
            u16:Play(p63);

            if u13 ~= nil then
                u13:disconnect();
            end;

            u13 = u16.KeyframeReached:connect(keyFrameReachedFunc);
        end;
    end;
end;

function playAnimation(p66, p67, p68)
    -- upvalues: u5 (ref), u10 (copy), Character_info_provider (copy), LocalPlayer (copy), switchToAnim (copy), u47 (ref)
    if p66 == nil then
        p66 = u5;
    end;

    local v69 = rollAnimation(p66);
    local anim = u10[p66][v69].anim;
    switchToAnim(Character_info_provider.get_core_anim(LocalPlayer, p66) or anim, p66, p67, p68);
    u47 = false;
end;

function playEmote(p70, p71, p72)
    -- upvalues: switchToAnim (copy), u47 (ref)
    switchToAnim(p70, p70.Name, p71, p72);
    u47 = true;
end;

local u73 = "";
local u74 = nil;
local u75 = nil;
local u76 = nil;

function toolKeyFrameReachedFunc(p77)
    -- upvalues: u73 (ref), Humanoid (copy)
    if p77 == "End" then
        playToolAnimation(u73, 0, Humanoid);
    end;
end;

function playToolAnimation(p78, p79, p80, p81)
    -- upvalues: u10 (copy), u75 (ref), u74 (ref), u73 (ref), u76 (ref)
    local v82 = rollAnimation(p78);
    local anim = u10[p78][v82].anim;

    if u75 ~= anim then
        if u74 ~= nil then
            u74:Stop();
            u74:Destroy();
            p79 = 0;
        end;

        u74 = p80:LoadAnimation(anim);

        if p81 then
            u74.Priority = p81;
        end;

        u74:Play(p79);
        u73 = p78;
        u75 = anim;
        u76 = u74.KeyframeReached:connect(toolKeyFrameReachedFunc);
    end;
end;

function stopToolAnimations()
    -- upvalues: u73 (ref), u76 (ref), u75 (ref), u74 (ref)
    local v83 = u73;

    if u76 ~= nil then
        u76:disconnect();
    end;

    u73 = "";
    u75 = nil;

    if u74 ~= nil then
        u74:Stop();
        u74:Destroy();
        u74 = nil;
    end;

    return v83;
end;

local u84 = nil;

function onRunning(p85)
    -- upvalues: u3 (ref), u47 (ref), Humanoid (copy), u84 (ref), u1 (ref), u19 (copy), u5 (ref)
    local v86 = u3 and u47 and Humanoid.MoveDirection == Vector3.new(0, 0, 0) and Humanoid.WalkSpeed or 0.75;
    local v87 = v86 < p85;

    if v87 ~= u84 or u1 ~= "Running" and u1 ~= "Standing" then
        if v86 < p85 then
            playAnimation("walk", 0.2, Humanoid);
            u1 = "Running";
        elseif u19[u5] == nil and not u47 then
            playAnimation("idle", 0.2, Humanoid);
            u1 = "Standing";
        end;

        u84 = v87;
    end;
end;

function onDied()
    -- upvalues: u1 (ref)
    u1 = "Dead";
end;

function onJumping()
    -- upvalues: Humanoid (copy), u46 (ref), u1 (ref)
    playAnimation("jump", 0.1, Humanoid);
    u46 = 0.31;
    u1 = "Jumping";
end;

function onClimbing(p88)
    -- upvalues: Humanoid (copy), u1 (ref)
    playAnimation("climb", 0.1, Humanoid);
    u1 = "Climbing";
end;

function onGettingUp()
    -- upvalues: u1 (ref)
    u1 = "GettingUp";
end;

function onFreeFall()
    -- upvalues: u46 (ref), Humanoid (copy), u1 (ref)
    if u46 <= 0 then
        playAnimation("fall", 0.2, Humanoid);
    end;

    u1 = "FreeFall";
end;

function onFallingDown()
    -- upvalues: u1 (ref)
    u1 = "FallingDown";
end;

function onSeated()
    -- upvalues: u1 (ref)
    u1 = "Seated";
end;

function onPlatformStanding()
    -- upvalues: u1 (ref)
    u1 = "PlatformStanding";
end;

function onSwimming(p89)
    -- upvalues: Humanoid (copy), u1 (ref)
    if p89 > 1 then
        playAnimation("swim", 0.4, Humanoid);
        u1 = "Swimming";

        return;
    end;

    playAnimation("swimidle", 0.4, Humanoid);
    u1 = "Standing";
end;

function animateTool()
    -- upvalues: Humanoid (copy)
    playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle);
end;

function getToolAnim(p90)
    for _, child in ipairs(p90:GetChildren()) do
        if child.Name == "toolanim" and child.className == "StringValue" then
            return child;
        end;
    end;

    return nil;
end;

local u91 = 0;

function stepAnimate(p92)
    -- upvalues: u91 (ref), u46 (ref), u1 (ref), Humanoid (copy)
    local v93 = p92 - u91;
    u91 = p92;

    if u46 > 0 then
        u46 = u46 - v93;
    end;

    if u1 == "FreeFall" and u46 <= 0 then
        playAnimation("fall", 0.2, Humanoid);

        return;
    end;

    if u1 == "Seated" then
        playAnimation("sit", 0.5, Humanoid);

        return;
    end;

    if u1 == "Running" then
        playAnimation("walk", 0.2, Humanoid);

        return;
    end;

    if u1 == "Dead" or (u1 == "GettingUp" or (u1 == "FallingDown" or (u1 == "Seated" or u1 == "PlatformStanding"))) then
        stopAllAnimations();
    end;
end;

Humanoid.Died:connect(onDied);
Humanoid.Running:connect(onRunning);
Humanoid.Jumping:connect(onJumping);
Humanoid.Climbing:connect(onClimbing);
Humanoid.GettingUp:connect(onGettingUp);
Humanoid.FreeFalling:connect(onFreeFall);
Humanoid.FallingDown:connect(onFallingDown);
Humanoid.Seated:connect(onSeated);
Humanoid.PlatformStanding:connect(onPlatformStanding);
Humanoid.Swimming:connect(onSwimming);
game:GetService("Players").LocalPlayer.Chatted:connect(function(p94) -- Line: 791
    -- upvalues: u1 (ref), u19 (copy), Humanoid (copy)
    local v95 = "";

    if string.sub(p94, 1, 3) == "/e " then
        v95 = string.sub(p94, 4);
    elseif string.sub(p94, 1, 7) == "/emote " then
        v95 = string.sub(p94, 8);
    end;

    if u1 == "Standing" and u19[v95] ~= nil then
        playAnimation(v95, 0.1, Humanoid);
    end;
end);

script:WaitForChild("PlayEmote").OnInvoke = function(p96) -- Line: 805
    -- upvalues: u1 (ref), u19 (copy), Humanoid (copy), u4 (ref), u12 (ref)
    if u1 == "Standing" then
        if u19[p96] ~= nil then
            playAnimation(p96, 0.1, Humanoid);

            if u4 then
                return true, u12;
            end;

            return true;
        end;

        if typeof(p96) ~= "Instance" or not p96:IsA("Animation") then
            return false;
        end;

        playEmote(p96, 0.1, Humanoid);

        if u4 then
            return true, u12;
        end;

        return true;
    end;
end;

if script_Parent.Parent ~= nil then
    playAnimation("idle", 0.1, Humanoid);
    u1 = "Standing";
end;

while script_Parent.Parent ~= nil do
    local _, v97 = wait(0.1);
    stepAnimate(v97);
end;