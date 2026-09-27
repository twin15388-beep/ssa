-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local v1 = ReplicatedStorage:WaitForChild("Animações");
local CharacterAnimations = require(v1:WaitForChild("CharacterAnimations"));
local u2 = 0;
local u3 = {};
local u4 = false;

local function disconnectCharacter() -- Line: 14
    -- upvalues: u3 (copy)
    for _, v in u3 do
        v:Disconnect();
    end;

    table.clear(u3);
end;

local function isConfigured(p5) -- Line: 21
    if type(p5) ~= "string" then
        return false;
    end;

    local v6 = tonumber(string.match(p5, "%d+"));
    local v7;

    if v6 == nil then
        v7 = false;
    else
        v7 = v6 > 0;
    end;

    return v7;
end;

local function findAnimation(p8, p9) -- Line: 29
    for _, v in p9 do
        p8 = p8:FindFirstChild(v);

        if not p8 then
            return nil;
        end;
    end;

    return p8:IsA("Animation") and p8 and p8 or nil;
end;

local function setAnimation(p10, p11, p12) -- Line: 40
    -- upvalues: findAnimation (copy)
    local v13;

    if type(p12) == "string" then
        local v14 = tonumber(string.match(p12, "%d+"));

        if v14 == nil then
            v13 = false;
        else
            v13 = v14 > 0;
        end;
    else
        v13 = false;
    end;

    if not v13 then
        return false;
    end;

    local v15 = findAnimation(p10, p11);

    if not v15 then
        return false;
    end;

    local v16 = v15.AnimationId ~= p12;
    v15.AnimationId = p12;

    return v16;
end;

local function applyToCharacter(p17, p18) -- Line: 53
    -- upvalues: LocalPlayer (copy), u2 (ref), CharacterAnimations (copy), findAnimation (copy)
    if LocalPlayer.Character ~= p17 or u2 ~= p18 then
        return;
    end;

    local Animate = p17:WaitForChild("Animate", 10);

    if not Animate or LocalPlayer.Character ~= p17 then
        return;
    end;

    local v19 = LocalPlayer.Team and LocalPlayer.Team.Name or "Humans";
    local ForTeam = CharacterAnimations.GetForTeam(v19);
    local v20 = { "idle", "Animation1" };
    local Animation1 = ForTeam.Idle.Animation1;
    local v21;

    if type(Animation1) == "string" then
        local v22 = tonumber(string.match(Animation1, "%d+"));

        if v22 == nil then
            v21 = false;
        else
            v21 = v22 > 0;
        end;
    else
        v21 = false;
    end;

    local v23;

    if v21 then
        local v24 = findAnimation(Animate, v20);

        if v24 then
            v23 = v24.AnimationId ~= Animation1;
            v24.AnimationId = Animation1;
        else
            v23 = false;
        end;
    else
        v23 = false;
    end;

    local v25 = { "idle", "Animation2" };
    local Animation2 = ForTeam.Idle.Animation2;
    local v26;

    if type(Animation2) == "string" then
        local v27 = tonumber(string.match(Animation2, "%d+"));

        if v27 == nil then
            v26 = false;
        else
            v26 = v27 > 0;
        end;
    else
        v26 = false;
    end;

    local v28;

    if v26 then
        local v29 = findAnimation(Animate, v25);

        if v29 then
            v28 = v29.AnimationId ~= Animation2;
            v29.AnimationId = Animation2;
        else
            v28 = false;
        end;
    else
        v28 = false;
    end;

    local v30 = { "walk", "WalkAnim" };
    local Walk = ForTeam.Walk;
    local v31;

    if type(Walk) == "string" then
        local v32 = tonumber(string.match(Walk, "%d+"));

        if v32 == nil then
            v31 = false;
        else
            v31 = v32 > 0;
        end;
    else
        v31 = false;
    end;

    local v33;

    if v31 then
        local v34 = findAnimation(Animate, v30);

        if v34 then
            v33 = v34.AnimationId ~= Walk;
            v34.AnimationId = Walk;
        else
            v33 = false;
        end;
    else
        v33 = false;
    end;

    local v35 = { "run", "RunAnim" };
    local Run = ForTeam.Run;
    local v36;

    if type(Run) == "string" then
        local v37 = tonumber(string.match(Run, "%d+"));

        if v37 == nil then
            v36 = false;
        else
            v36 = v37 > 0;
        end;
    else
        v36 = false;
    end;

    local v38;

    if v36 then
        local v39 = findAnimation(Animate, v35);

        if v39 then
            v38 = v39.AnimationId ~= Run;
            v39.AnimationId = Run;
        else
            v38 = false;
        end;
    else
        v38 = false;
    end;

    local v40 = { "jump", "JumpAnim" };
    local Jump = ForTeam.Jump;
    local v41;

    if type(Jump) == "string" then
        local v42 = tonumber(string.match(Jump, "%d+"));

        if v42 == nil then
            v41 = false;
        else
            v41 = v42 > 0;
        end;
    else
        v41 = false;
    end;

    local v43;

    if v41 then
        local v44 = findAnimation(Animate, v40);

        if v44 then
            v43 = v44.AnimationId ~= Jump;
            v44.AnimationId = Jump;
        else
            v43 = false;
        end;
    else
        v43 = false;
    end;

    local v45 = { "fall", "FallAnim" };
    local Fall = ForTeam.Fall;
    local v46;

    if type(Fall) == "string" then
        local v47 = tonumber(string.match(Fall, "%d+"));

        if v47 == nil then
            v46 = false;
        else
            v46 = v47 > 0;
        end;
    else
        v46 = false;
    end;

    local v48;

    if v46 then
        local v49 = findAnimation(Animate, v45);

        if v49 then
            v48 = v49.AnimationId ~= Fall;
            v49.AnimationId = Fall;
        else
            v48 = false;
        end;
    else
        v48 = false;
    end;

    local v50 = { "climb", "ClimbAnim" };
    local Climb = ForTeam.Climb;
    local v51;

    if type(Climb) == "string" then
        local v52 = tonumber(string.match(Climb, "%d+"));

        if v52 == nil then
            v51 = false;
        else
            v51 = v52 > 0;
        end;
    else
        v51 = false;
    end;

    local v53;

    if v51 then
        local v54 = findAnimation(Animate, v50);

        if v54 then
            v53 = v54.AnimationId ~= Climb;
            v54.AnimationId = Climb;
        else
            v53 = false;
        end;
    else
        v53 = false;
    end;

    local v55 = { "swim", "Swim" };
    local Swim = ForTeam.Swim;
    local v56;

    if type(Swim) == "string" then
        local v57 = tonumber(string.match(Swim, "%d+"));

        if v57 == nil then
            v56 = false;
        else
            v56 = v57 > 0;
        end;
    else
        v56 = false;
    end;

    local v58;

    if v56 then
        local v59 = findAnimation(Animate, v55);

        if v59 then
            v58 = v59.AnimationId ~= Swim;
            v59.AnimationId = Swim;
        else
            v58 = false;
        end;
    else
        v58 = false;
    end;

    local v60 = { "swimidle", "SwimIdle" };
    local SwimIdle = ForTeam.SwimIdle;
    local v61;

    if type(SwimIdle) == "string" then
        local v62 = tonumber(string.match(SwimIdle, "%d+"));

        if v62 == nil then
            v61 = false;
        else
            v61 = v62 > 0;
        end;
    else
        v61 = false;
    end;

    local v63;

    if v61 then
        local v64 = findAnimation(Animate, v60);

        if v64 then
            v63 = v64.AnimationId ~= SwimIdle;
            v64.AnimationId = SwimIdle;
        else
            v63 = false;
        end;
    else
        v63 = false;
    end;

    if (v63 or (v58 or (v53 or (v48 or (v43 or (v38 or (v33 or (v28 or (v23 or false))))))))) and (LocalPlayer.Character == p17 and u2 == p18) then
        Animate.Disabled = true;
        task.wait();

        if Animate.Parent and LocalPlayer.Character == p17 then
            Animate.Disabled = false;
        end;
    end;

    p17:SetAttribute("AnimationTeam", v19);
end;

local function queueApply(u65, u66) -- Line: 88
    -- upvalues: u4 (ref), applyToCharacter (copy)
    if u4 then
        return;
    end;

    u4 = true;
    task.defer(function() -- Line: 93
        -- upvalues: u4 (ref), applyToCharacter (ref), u65 (copy), u66 (copy)
        u4 = false;
        applyToCharacter(u65, u66);
    end);
end;

local function setupCharacter(u67) -- Line: 99
    -- upvalues: u2 (ref), u3 (copy), u4 (ref), applyToCharacter (copy)
    u2 = u2 + 1;
    local u68 = u2;

    for _, v in u3 do
        v:Disconnect();
    end;

    table.clear(u3);
    table.insert(u3, u67.ChildAdded:Connect(function(p69) -- Line: 104
        -- upvalues: u67 (copy), u68 (copy), u4 (ref), applyToCharacter (ref)
        if p69.Name == "Animate" then
            local u70 = u67;
            local u71 = u68;

            if u4 then
                return;
            end;

            u4 = true;
            task.defer(function() -- Line: 93
                -- upvalues: u4 (ref), applyToCharacter (ref), u70 (copy), u71 (copy)
                u4 = false;
                applyToCharacter(u70, u71);
            end);
        end;
    end));
    task.spawn(applyToCharacter, u67, u68);
    task.delay(1, function() -- Line: 111
        -- upvalues: applyToCharacter (ref), u67 (copy), u68 (copy)
        applyToCharacter(u67, u68);
    end);
end;

LocalPlayer.CharacterAdded:Connect(setupCharacter);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 117
    -- upvalues: LocalPlayer (copy), u2 (ref), u4 (ref), applyToCharacter (copy)
    local Character = LocalPlayer.Character;

    if Character then
        local u72 = u2;

        if u4 then
            return;
        end;

        u4 = true;
        task.defer(function() -- Line: 93
            -- upvalues: u4 (ref), applyToCharacter (ref), Character (copy), u72 (copy)
            u4 = false;
            applyToCharacter(Character, u72);
        end);
    end;
end);

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character);
end;