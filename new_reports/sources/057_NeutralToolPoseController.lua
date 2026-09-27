-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;
local script_Parent = script.Parent;
local u1 = false;
local u2 = nil;

local function isDefaultToolPose(p3) -- Line: 8
    local Animation = p3.Animation;

    if not Animation then
        return false;
    end;

    local string_lower_ret = string.lower(Animation.Name);

    return string.match(Animation.AnimationId or "", "%d+") == "182393478" and true or string.find(string_lower_ret, "toolnone", 1, true) ~= nil;
end;

local function stopDefaultToolPose(u4) -- Line: 19
    -- upvalues: isDefaultToolPose (copy)
    if isDefaultToolPose(u4) then
        task.defer(function() -- Line: 21
            -- upvalues: u4 (copy)
            if u4.IsPlaying then
                u4:Stop(0.1);
            end;
        end);
    end;
end;

local function beginNeutralPose() -- Line: 29
    -- upvalues: u1 (ref), u2 (ref), script_Parent (copy), isDefaultToolPose (copy)
    u1 = true;

    if u2 then
        u2:Disconnect();
        u2 = nil;
    end;

    local Parent = script_Parent.Parent;

    if Parent then
        Parent = Parent:FindFirstChildOfClass("Humanoid");
    end;

    if Parent then
        Parent = Parent:FindFirstChildOfClass("Animator");
    end;

    if not Parent then
        return;
    end;

    for _, v in Parent:GetPlayingAnimationTracks() do
        if isDefaultToolPose(v) then
            task.defer(function() -- Line: 21
                -- upvalues: v (copy)
                if v.IsPlaying then
                    v:Stop(0.1);
                end;
            end);
        end;
    end;

    u2 = Parent.AnimationPlayed:Connect(function(u5) -- Line: 46
        -- upvalues: u1 (ref), isDefaultToolPose (ref)
        if u1 and isDefaultToolPose(u5) then
            task.defer(function() -- Line: 21
                -- upvalues: u5 (copy)
                if u5.IsPlaying then
                    u5:Stop(0.1);
                end;
            end);
        end;
    end);
end;

local function endNeutralPose() -- Line: 53
    -- upvalues: u1 (ref), u2 (ref)
    u1 = false;

    if u2 then
        u2:Disconnect();
        u2 = nil;
    end;
end;

script_Parent.Equipped:Connect(beginNeutralPose);
script_Parent.Unequipped:Connect(endNeutralPose);
script_Parent.Destroying:Connect(endNeutralPose);
task.defer(function() -- Line: 65
    -- upvalues: LocalPlayer (copy), script_Parent (copy), beginNeutralPose (copy)
    if LocalPlayer.Character and script_Parent.Parent == LocalPlayer.Character then
        beginNeutralPose();
    end;
end);