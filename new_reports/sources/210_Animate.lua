-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local Torso = script_Parent:WaitForChild("Torso");
local u1 = Torso:WaitForChild("Right Shoulder");
local u2 = Torso:WaitForChild("Left Shoulder");
local u3 = Torso:WaitForChild("Right Hip");
local u4 = Torso:WaitForChild("Left Hip");
Torso:WaitForChild("Neck");
local Humanoid = script_Parent:WaitForChild("Humanoid");
local u5 = "Standing";
local success, result = pcall(function() -- Line: 15
    return UserSettings():IsUserFeatureEnabled("UserAnimateRemoveEmoteChatHook");
end);

local function getRigScale() -- Line: 23
    -- upvalues: script_Parent (copy)
    return script_Parent:GetScale();
end;

local u6 = "";
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = 1;
local u11 = {};
local u12 = {
    idle = { {
            id = "http://www.roblox.com/asset/?id=180435571",
            weight = 9
        }, {
            id = "http://www.roblox.com/asset/?id=180435792",
            weight = 1
        } },
    walk = { {
            id = "http://www.roblox.com/asset/?id=180426354",
            weight = 10
        } },
    run = { {
            id = "run.xml",
            weight = 10
        } },
    jump = { {
            id = "http://www.roblox.com/asset/?id=125750702",
            weight = 10
        } },
    fall = { {
            id = "http://www.roblox.com/asset/?id=180436148",
            weight = 10
        } },
    climb = { {
            id = "http://www.roblox.com/asset/?id=180436334",
            weight = 10
        } },
    sit = { {
            id = "http://www.roblox.com/asset/?id=178130996",
            weight = 10
        } },
    toolnone = { {
            id = "http://www.roblox.com/asset/?id=182393478",
            weight = 10
        } },
    toolslash = { {
            id = "http://www.roblox.com/asset/?id=129967390",
            weight = 10
        } },
    toollunge = { {
            id = "http://www.roblox.com/asset/?id=129967478",
            weight = 10
        } },
    wave = { {
            id = "http://www.roblox.com/asset/?id=128777973",
            weight = 10
        } },
    point = { {
            id = "http://www.roblox.com/asset/?id=128853357",
            weight = 10
        } },
    dance1 = { {
            id = "http://www.roblox.com/asset/?id=182435998",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=182491037",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=182491065",
            weight = 10
        } },
    dance2 = { {
            id = "http://www.roblox.com/asset/?id=182436842",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=182491248",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=182491277",
            weight = 10
        } },
    dance3 = { {
            id = "http://www.roblox.com/asset/?id=182436935",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=182491368",
            weight = 10
        }, {
            id = "http://www.roblox.com/asset/?id=182491423",
            weight = 10
        } },
    laugh = { {
            id = "http://www.roblox.com/asset/?id=129423131",
            weight = 10
        } },
    cheer = { {
            id = "http://www.roblox.com/asset/?id=129423030",
            weight = 10
        } }
};
local u13 = { "dance1", "dance2", "dance3" };
local u14 = {
    wave = false,
    point = false,
    dance1 = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
};

function configureAnimationSet(u15, u16)
    -- upvalues: u11 (copy)
    if u11[u15] ~= nil then
        for _, v in pairs(u11[u15].connections) do
            v:disconnect();
        end;
    end;

    u11[u15] = {};
    u11[u15].count = 0;
    u11[u15].totalWeight = 0;
    u11[u15].connections = {};
    local v17 = script:FindFirstChild(u15);

    if v17 ~= nil then
        table.insert(u11[u15].connections, v17.ChildAdded:connect(function(p18) -- Line: 114
            -- upvalues: u15 (copy), u16 (copy)
            configureAnimationSet(u15, u16);
        end));
        table.insert(u11[u15].connections, v17.ChildRemoved:connect(function(p19) -- Line: 115
            -- upvalues: u15 (copy), u16 (copy)
            configureAnimationSet(u15, u16);
        end));
        local v20 = 1;

        for _, child in pairs(v17:GetChildren()) do
            if child:IsA("Animation") then
                table.insert(u11[u15].connections, child.Changed:connect(function(p21) -- Line: 119
                    -- upvalues: u15 (copy), u16 (copy)
                    configureAnimationSet(u15, u16);
                end));
                u11[u15][v20] = {};
                u11[u15][v20].anim = child;
                local Weight = child:FindFirstChild("Weight");

                if Weight == nil then
                    u11[u15][v20].weight = 1;
                else
                    u11[u15][v20].weight = Weight.Value;
                end;

                u11[u15].count = u11[u15].count + 1;
                u11[u15].totalWeight = u11[u15].totalWeight + u11[u15][v20].weight;
                v20 = v20 + 1;
            end;
        end;
    end;

    if u11[u15].count <= 0 then
        for i, v in pairs(u16) do
            u11[u15][i] = {};
            u11[u15][i].anim = Instance.new("Animation");
            u11[u15][i].anim.Name = u15;
            u11[u15][i].anim.AnimationId = v.id;
            u11[u15][i].weight = v.weight;
            u11[u15].count = u11[u15].count + 1;
            u11[u15].totalWeight = u11[u15].totalWeight + v.weight;
        end;
    end;
end;

function scriptChildModified(p22)
    -- upvalues: u12 (copy)
    local v23 = u12[p22.Name];

    if v23 ~= nil then
        configureAnimationSet(p22.Name, v23);
    end;
end;

script.ChildAdded:connect(scriptChildModified);
script.ChildRemoved:connect(scriptChildModified);
local v24;

if Humanoid then
    v24 = Humanoid:FindFirstChildOfClass("Animator");
else
    v24 = nil;
end;

if v24 then
    local PlayingAnimationTracks = v24:GetPlayingAnimationTracks();

    for _, v in ipairs(PlayingAnimationTracks) do
        v:Stop(0);
        v:Destroy();
    end;
end;

for i, v in pairs(u12) do
    configureAnimationSet(i, v);
end;

local u25 = "None";
local u26 = 0;
local u27 = 0;

function stopAllAnimations()
    -- upvalues: u6 (ref), u14 (copy), u7 (ref), u9 (ref), u8 (ref)
    local v28 = u6;
    local v29 = u14[v28] ~= nil and u14[v28] == false and "idle" or v28;
    u6 = "";
    u7 = nil;

    if u9 ~= nil then
        u9:disconnect();
    end;

    if u8 ~= nil then
        u8:Stop();
        u8:Destroy();
        u8 = nil;
    end;

    return v29;
end;

function setAnimationSpeed(p30)
    -- upvalues: u10 (ref), u8 (ref)
    if p30 ~= u10 then
        u10 = p30;
        u8:AdjustSpeed(u10);
    end;
end;

function keyFrameReachedFunc(p31)
    -- upvalues: u6 (ref), u14 (copy), u10 (ref), Humanoid (copy)
    if p31 == "End" then
        local v32 = u6;
        playAnimation(u14[v32] ~= nil and u14[v32] == false and "idle" or v32, 0, Humanoid);
        setAnimationSpeed(u10);
    end;
end;

function playAnimation(p33, p34, p35)
    -- upvalues: u11 (copy), u7 (ref), u8 (ref), u10 (ref), u6 (ref), u9 (ref)
    local math_random_ret = math.random(1, u11[p33].totalWeight);
    local v36 = 1;

    while u11[p33][v36].weight < math_random_ret do
        math_random_ret = math_random_ret - u11[p33][v36].weight;
        v36 = v36 + 1;
    end;

    local anim = u11[p33][v36].anim;

    if anim ~= u7 then
        if u8 ~= nil then
            u8:Stop(p34);
            u8:Destroy();
        end;

        u10 = 1;
        u8 = p35:LoadAnimation(anim);
        u8.Priority = Enum.AnimationPriority.Core;
        u8:Play(p34);
        u6 = p33;
        u7 = anim;

        if u9 ~= nil then
            u9:disconnect();
        end;

        u9 = u8.KeyframeReached:connect(keyFrameReachedFunc);
    end;
end;

local u37 = "";
local u38 = nil;
local u39 = nil;
local u40 = nil;

function toolKeyFrameReachedFunc(p41)
    -- upvalues: u37 (ref), Humanoid (copy)
    if p41 == "End" then
        playToolAnimation(u37, 0, Humanoid);
    end;
end;

function playToolAnimation(p42, p43, p44, p45)
    -- upvalues: u11 (copy), u39 (ref), u38 (ref), u37 (ref), u40 (ref)
    local math_random_ret = math.random(1, u11[p42].totalWeight);
    local v46 = 1;

    while u11[p42][v46].weight < math_random_ret do
        math_random_ret = math_random_ret - u11[p42][v46].weight;
        v46 = v46 + 1;
    end;

    local anim = u11[p42][v46].anim;

    if u39 ~= anim then
        if u38 ~= nil then
            u38:Stop();
            u38:Destroy();
            p43 = 0;
        end;

        u38 = p44:LoadAnimation(anim);

        if p45 then
            u38.Priority = p45;
        end;

        u38:Play(p43);
        u37 = p42;
        u39 = anim;
        u40 = u38.KeyframeReached:connect(toolKeyFrameReachedFunc);
    end;
end;

function stopToolAnimations()
    -- upvalues: u37 (ref), u40 (ref), u39 (ref), u38 (ref)
    local v47 = u37;

    if u40 ~= nil then
        u40:disconnect();
    end;

    u37 = "";
    u39 = nil;

    if u38 ~= nil then
        u38:Stop();
        u38:Destroy();
        u38 = nil;
    end;

    return v47;
end;

function onRunning(p48)
    -- upvalues: script_Parent (copy), Humanoid (copy), u7 (ref), u5 (ref), u14 (copy), u6 (ref)
    local v49 = p48 / script_Parent:GetScale();

    if v49 <= 0.01 then
        if u14[u6] == nil then
            playAnimation("idle", 0.1, Humanoid);
            u5 = "Standing";
        end;

        return;
    end;

    playAnimation("walk", 0.1, Humanoid);

    if u7 and u7.AnimationId == "http://www.roblox.com/asset/?id=180426354" then
        setAnimationSpeed(v49 / 14.5);
    end;

    u5 = "Running";
end;

function onDied()
    -- upvalues: u5 (ref)
    u5 = "Dead";
end;

function onJumping()
    -- upvalues: Humanoid (copy), u27 (ref), u5 (ref)
    playAnimation("jump", 0.1, Humanoid);
    u27 = 0.3;
    u5 = "Jumping";
end;

function onClimbing(p50)
    -- upvalues: script_Parent (copy), Humanoid (copy), u5 (ref)
    local v51 = p50 / script_Parent:GetScale();
    playAnimation("climb", 0.1, Humanoid);
    setAnimationSpeed(v51 / 12);
    u5 = "Climbing";
end;

function onGettingUp()
    -- upvalues: u5 (ref)
    u5 = "GettingUp";
end;

function onFreeFall()
    -- upvalues: u27 (ref), Humanoid (copy), u5 (ref)
    if u27 <= 0 then
        playAnimation("fall", 0.3, Humanoid);
    end;

    u5 = "FreeFall";
end;

function onFallingDown()
    -- upvalues: u5 (ref)
    u5 = "FallingDown";
end;

function onSeated()
    -- upvalues: u5 (ref)
    u5 = "Seated";
end;

function onPlatformStanding()
    -- upvalues: u5 (ref)
    u5 = "PlatformStanding";
end;

function onSwimming(p52)
    -- upvalues: u5 (ref)
    if p52 > 0 then
        u5 = "Running";

        return;
    end;

    u5 = "Standing";
end;

function getTool()
    -- upvalues: script_Parent (copy)
    for _, child in ipairs(script_Parent:GetChildren()) do
        if child.className == "Tool" then
            return child;
        end;
    end;

    return nil;
end;

function getToolAnim(p53)
    for _, child in ipairs(p53:GetChildren()) do
        if child.Name == "toolanim" and child.className == "StringValue" then
            return child;
        end;
    end;

    return nil;
end;

function animateTool()
    -- upvalues: u25 (ref), Humanoid (copy)
    if u25 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle);

        return;
    end;

    if u25 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action);

        return;
    end;

    if u25 ~= "Lunge" then
        return;
    end;

    playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action);
end;

function moveSit()
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), u4 (copy)
    u1.MaxVelocity = 0.15;
    u2.MaxVelocity = 0.15;
    u1:SetDesiredAngle(1.57);
    u2:SetDesiredAngle(-1.57);
    u3:SetDesiredAngle(1.57);
    u4:SetDesiredAngle(-1.57);
end;

local u54 = 0;

function move(p55)
    -- upvalues: u54 (ref), u27 (ref), u5 (ref), Humanoid (copy), u1 (copy), u2 (copy), u3 (copy), u4 (copy), u25 (ref), u26 (ref), u39 (ref)
    local v56 = 1;
    local v57 = 1;
    local v58 = p55 - u54;
    u54 = p55;
    local v59 = false;

    if u27 > 0 then
        u27 = u27 - v58;
    end;

    if u5 == "FreeFall" and u27 <= 0 then
        playAnimation("fall", 0.3, Humanoid);
    else
        if u5 == "Seated" then
            playAnimation("sit", 0.5, Humanoid);

            return;
        end;

        if u5 == "Running" then
            playAnimation("walk", 0.1, Humanoid);
        elseif u5 == "Dead" or (u5 == "GettingUp" or (u5 == "FallingDown" or (u5 == "Seated" or u5 == "PlatformStanding"))) then
            stopAllAnimations();
            v59 = true;
            v57 = 1;
            v56 = 0.1;
        end;
    end;

    if v59 then
        local v60 = v56 * math.sin(p55 * v57);
        u1:SetDesiredAngle(v60 + 0);
        u2:SetDesiredAngle(v60 - 0);
        u3:SetDesiredAngle(-v60);
        u4:SetDesiredAngle(-v60);
    end;

    local v61 = getTool();

    if v61 and v61:FindFirstChild("Handle") then
        local v62 = getToolAnim(v61);

        if v62 then
            u25 = v62.Value;
            v62.Parent = nil;
            u26 = p55 + 0.3;
        end;

        if u26 < p55 then
            u26 = 0;
            u25 = "None";
        end;

        animateTool();

        return;
    end;

    stopToolAnimations();
    u25 = "None";
    u39 = nil;
    u26 = 0;
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

if not (success and result) then
    game:GetService("Players").LocalPlayer.Chatted:connect(function(p63) -- Line: 542
        -- upvalues: u13 (copy), u5 (ref), u14 (copy), Humanoid (copy)
        local v64 = "";

        if p63 == "/e dance" then
            v64 = u13[math.random(1, #u13)];
        elseif string.sub(p63, 1, 3) == "/e " then
            v64 = string.sub(p63, 4);
        elseif string.sub(p63, 1, 7) == "/emote " then
            v64 = string.sub(p63, 8);
        end;

        if u5 == "Standing" and u14[v64] ~= nil then
            playAnimation(v64, 0.1, Humanoid);
        end;
    end);
end;

script:WaitForChild("PlayEmote").OnInvoke = function(p65) -- Line: 559
    -- upvalues: u5 (ref), u14 (copy), Humanoid (copy), u8 (ref)
    if u5 == "Standing" then
        if u14[p65] == nil then
            return false;
        end;

        playAnimation(p65, 0.1, Humanoid);

        return true, u8;
    end;
end;

playAnimation("idle", 0.1, Humanoid);
u5 = "Standing";

while script_Parent.Parent ~= nil do
    local _, v66 = wait(0.1);
    move(v66);
end;