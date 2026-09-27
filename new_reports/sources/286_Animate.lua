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
    return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun");
end);
local u6 = success and result;

local function getRigScale() -- Line: 18
    -- upvalues: u6 (copy), script_Parent (copy)
    return not u6 and 1 or script_Parent:GetScale();
end;

local u7 = "";
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = 1;
local u12 = {};
local u13 = {
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
local u14 = { "dance1", "dance2", "dance3" };
local u15 = {
    wave = false,
    point = false,
    dance1 = true,
    dance2 = true,
    dance3 = true,
    laugh = false,
    cheer = false
};

function configureAnimationSet(u16, u17)
    -- upvalues: u12 (copy)
    if u12[u16] ~= nil then
        for _, v in pairs(u12[u16].connections) do
            v:disconnect();
        end;
    end;

    u12[u16] = {};
    u12[u16].count = 0;
    u12[u16].totalWeight = 0;
    u12[u16].connections = {};
    local v18 = script:FindFirstChild(u16);

    if v18 ~= nil then
        table.insert(u12[u16].connections, v18.ChildAdded:connect(function(p19) -- Line: 113
            -- upvalues: u16 (copy), u17 (copy)
            configureAnimationSet(u16, u17);
        end));
        table.insert(u12[u16].connections, v18.ChildRemoved:connect(function(p20) -- Line: 114
            -- upvalues: u16 (copy), u17 (copy)
            configureAnimationSet(u16, u17);
        end));
        local v21 = 1;

        for _, child in pairs(v18:GetChildren()) do
            if child:IsA("Animation") then
                table.insert(u12[u16].connections, child.Changed:connect(function(p22) -- Line: 118
                    -- upvalues: u16 (copy), u17 (copy)
                    configureAnimationSet(u16, u17);
                end));
                u12[u16][v21] = {};
                u12[u16][v21].anim = child;
                local Weight = child:FindFirstChild("Weight");

                if Weight == nil then
                    u12[u16][v21].weight = 1;
                else
                    u12[u16][v21].weight = Weight.Value;
                end;

                u12[u16].count = u12[u16].count + 1;
                u12[u16].totalWeight = u12[u16].totalWeight + u12[u16][v21].weight;
                v21 = v21 + 1;
            end;
        end;
    end;

    if u12[u16].count <= 0 then
        for i, v in pairs(u17) do
            u12[u16][i] = {};
            u12[u16][i].anim = Instance.new("Animation");
            u12[u16][i].anim.Name = u16;
            u12[u16][i].anim.AnimationId = v.id;
            u12[u16][i].weight = v.weight;
            u12[u16].count = u12[u16].count + 1;
            u12[u16].totalWeight = u12[u16].totalWeight + v.weight;
        end;
    end;
end;

function scriptChildModified(p23)
    -- upvalues: u13 (copy)
    local v24 = u13[p23.Name];

    if v24 ~= nil then
        configureAnimationSet(p23.Name, v24);
    end;
end;

script.ChildAdded:connect(scriptChildModified);
script.ChildRemoved:connect(scriptChildModified);
local v25;

if Humanoid then
    v25 = Humanoid:FindFirstChildOfClass("Animator");
else
    v25 = nil;
end;

if v25 then
    local PlayingAnimationTracks = v25:GetPlayingAnimationTracks();

    for _, v in ipairs(PlayingAnimationTracks) do
        v:Stop(0);
        v:Destroy();
    end;
end;

for i, v in pairs(u13) do
    configureAnimationSet(i, v);
end;

local u26 = "None";
local u27 = 0;
local u28 = 0;

function stopAllAnimations()
    -- upvalues: u7 (ref), u15 (copy), u8 (ref), u10 (ref), u9 (ref)
    local v29 = u7;
    local v30 = u15[v29] ~= nil and u15[v29] == false and "idle" or v29;
    u7 = "";
    u8 = nil;

    if u10 ~= nil then
        u10:disconnect();
    end;

    if u9 ~= nil then
        u9:Stop();
        u9:Destroy();
        u9 = nil;
    end;

    return v30;
end;

function setAnimationSpeed(p31)
    -- upvalues: u11 (ref), u9 (ref)
    if p31 ~= u11 then
        u11 = p31;
        u9:AdjustSpeed(u11);
    end;
end;

function keyFrameReachedFunc(p32)
    -- upvalues: u7 (ref), u15 (copy), u11 (ref), Humanoid (copy)
    if p32 == "End" then
        local v33 = u7;
        playAnimation(u15[v33] ~= nil and u15[v33] == false and "idle" or v33, 0, Humanoid);
        setAnimationSpeed(u11);
    end;
end;

function playAnimation(p34, p35, p36)
    -- upvalues: u12 (copy), u8 (ref), u9 (ref), u11 (ref), u7 (ref), u10 (ref)
    local math_random_ret = math.random(1, u12[p34].totalWeight);
    local v37 = 1;

    while u12[p34][v37].weight < math_random_ret do
        math_random_ret = math_random_ret - u12[p34][v37].weight;
        v37 = v37 + 1;
    end;

    local anim = u12[p34][v37].anim;

    if anim ~= u8 then
        if u9 ~= nil then
            u9:Stop(p35);
            u9:Destroy();
        end;

        u11 = 1;
        u9 = p36:LoadAnimation(anim);
        u9.Priority = Enum.AnimationPriority.Core;
        u9:Play(p35);
        u7 = p34;
        u8 = anim;

        if u10 ~= nil then
            u10:disconnect();
        end;

        u10 = u9.KeyframeReached:connect(keyFrameReachedFunc);
    end;
end;

local u38 = "";
local u39 = nil;
local u40 = nil;
local u41 = nil;

function toolKeyFrameReachedFunc(p42)
    -- upvalues: u38 (ref), Humanoid (copy)
    if p42 == "End" then
        playToolAnimation(u38, 0, Humanoid);
    end;
end;

function playToolAnimation(p43, p44, p45, p46)
    -- upvalues: u12 (copy), u40 (ref), u39 (ref), u38 (ref), u41 (ref)
    local math_random_ret = math.random(1, u12[p43].totalWeight);
    local v47 = 1;

    while u12[p43][v47].weight < math_random_ret do
        math_random_ret = math_random_ret - u12[p43][v47].weight;
        v47 = v47 + 1;
    end;

    local anim = u12[p43][v47].anim;

    if u40 ~= anim then
        if u39 ~= nil then
            u39:Stop();
            u39:Destroy();
            p44 = 0;
        end;

        u39 = p45:LoadAnimation(anim);

        if p46 then
            u39.Priority = p46;
        end;

        u39:Play(p44);
        u38 = p43;
        u40 = anim;
        u41 = u39.KeyframeReached:connect(toolKeyFrameReachedFunc);
    end;
end;

function stopToolAnimations()
    -- upvalues: u38 (ref), u41 (ref), u40 (ref), u39 (ref)
    local v48 = u38;

    if u41 ~= nil then
        u41:disconnect();
    end;

    u38 = "";
    u40 = nil;

    if u39 ~= nil then
        u39:Stop();
        u39:Destroy();
        u39 = nil;
    end;

    return v48;
end;

function onRunning(p49)
    -- upvalues: u6 (copy), script_Parent (copy), Humanoid (copy), u8 (ref), u5 (ref), u15 (copy), u7 (ref)
    local v50 = p49 / (not u6 and 1 or script_Parent:GetScale());

    if v50 <= 0.01 then
        if u15[u7] == nil then
            playAnimation("idle", 0.1, Humanoid);
            u5 = "Standing";
        end;

        return;
    end;

    playAnimation("walk", 0.1, Humanoid);

    if u8 and u8.AnimationId == "http://www.roblox.com/asset/?id=180426354" then
        setAnimationSpeed(v50 / 14.5);
    end;

    u5 = "Running";
end;

function onDied()
    -- upvalues: u5 (ref)
    u5 = "Dead";
end;

function onJumping()
    -- upvalues: Humanoid (copy), u28 (ref), u5 (ref)
    playAnimation("jump", 0.1, Humanoid);
    u28 = 0.3;
    u5 = "Jumping";
end;

function onClimbing(p51)
    -- upvalues: u6 (copy), script_Parent (copy), Humanoid (copy), u5 (ref)
    local v52 = p51 / (not u6 and 1 or script_Parent:GetScale());
    playAnimation("climb", 0.1, Humanoid);
    setAnimationSpeed(v52 / 12);
    u5 = "Climbing";
end;

function onGettingUp()
    -- upvalues: u5 (ref)
    u5 = "GettingUp";
end;

function onFreeFall()
    -- upvalues: u28 (ref), Humanoid (copy), u5 (ref)
    if u28 <= 0 then
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

function onSwimming(p53)
    -- upvalues: u5 (ref)
    if p53 > 0 then
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

function getToolAnim(p54)
    for _, child in ipairs(p54:GetChildren()) do
        if child.Name == "toolanim" and child.className == "StringValue" then
            return child;
        end;
    end;

    return nil;
end;

function animateTool()
    -- upvalues: u26 (ref), Humanoid (copy)
    if u26 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle);

        return;
    end;

    if u26 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action);

        return;
    end;

    if u26 ~= "Lunge" then
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

local u55 = 0;

function move(p56)
    -- upvalues: u55 (ref), u28 (ref), u5 (ref), Humanoid (copy), u1 (copy), u2 (copy), u3 (copy), u4 (copy), u26 (ref), u27 (ref), u40 (ref)
    local v57 = 1;
    local v58 = 1;
    local v59 = p56 - u55;
    u55 = p56;
    local v60 = false;

    if u28 > 0 then
        u28 = u28 - v59;
    end;

    if u5 == "FreeFall" and u28 <= 0 then
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
            v60 = true;
            v58 = 1;
            v57 = 0.1;
        end;
    end;

    if v60 then
        local v61 = v57 * math.sin(p56 * v58);
        u1:SetDesiredAngle(v61 + 0);
        u2:SetDesiredAngle(v61 - 0);
        u3:SetDesiredAngle(-v61);
        u4:SetDesiredAngle(-v61);
    end;

    local v62 = getTool();

    if v62 and v62:FindFirstChild("Handle") then
        local v63 = getToolAnim(v62);

        if v63 then
            u26 = v63.Value;
            v63.Parent = nil;
            u27 = p56 + 0.3;
        end;

        if u27 < p56 then
            u27 = 0;
            u26 = "None";
        end;

        animateTool();

        return;
    end;

    stopToolAnimations();
    u26 = "None";
    u40 = nil;
    u27 = 0;
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
game:GetService("Players").LocalPlayer.Chatted:connect(function(p64) -- Line: 540
    -- upvalues: u14 (copy), u5 (ref), u15 (copy), Humanoid (copy)
    local v65 = "";

    if p64 == "/e dance" then
        v65 = u14[math.random(1, #u14)];
    elseif string.sub(p64, 1, 3) == "/e " then
        v65 = string.sub(p64, 4);
    elseif string.sub(p64, 1, 7) == "/emote " then
        v65 = string.sub(p64, 8);
    end;

    if u5 == "Standing" and u15[v65] ~= nil then
        playAnimation(v65, 0.1, Humanoid);
    end;
end);

script:WaitForChild("PlayEmote").OnInvoke = function(p66) -- Line: 557
    -- upvalues: u5 (ref), u15 (copy), Humanoid (copy), u9 (ref)
    if u5 == "Standing" then
        if u15[p66] == nil then
            return false;
        end;

        playAnimation(p66, 0.1, Humanoid);

        return true, u9;
    end;
end;

playAnimation("idle", 0.1, Humanoid);
u5 = "Standing";

while script_Parent.Parent ~= nil do
    local _, v67 = wait(0.1);
    move(v67);
end;