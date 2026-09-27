-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local Shaking = script:WaitForChild("Shaking");
local u1 = script:WaitForChild("Going Up");
local EmitWhenGoingDown = script:WaitForChild("EmitWhenGoingDown");
local Sounds = script:WaitForChild("Sounds");
local PS2dungeonPILLARshake = Sounds:WaitForChild("PS2dungeonPILLARshake");
local PS2dungeonPILLARdrop = Sounds:WaitForChild("PS2dungeonPILLARdrop");
local PS2dungeonPILLARrise = Sounds:WaitForChild("PS2dungeonPILLARrise");
local TweenInfo_new_ret = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local TweenInfo_new_ret2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = {};
u2.__index = u2;

local function fadeOutParticle(p3: userdata?) -- Line: 43
    -- upvalues: DebrisModule (copy)
    if p3 == nil or p3.Parent == nil then
        return;
    end;

    p3.Enabled = false;
    DebrisModule:AddItem(p3, 3);
end;

local function startSound(p4: userdata, p5: userdata) -- Line: 50
    local v6 = p4:Clone();
    v6.Parent = p5;
    v6:Play();

    return v6;
end;

local function stopSound(p7: userdata?) -- Line: 57
    -- upvalues: DebrisModule (copy)
    if p7 == nil or p7.Parent == nil then
        return;
    end;

    p7:Stop();
    DebrisModule:AddItem(p7, 0.1);
end;

local function emitSound(p8: userdata, p9: userdata) -- Line: 63
    -- upvalues: DebrisModule (copy)
    local v10 = p8:Clone();
    v10.Parent = p9;
    v10:Play();
    DebrisModule:AddItem(v10, v10.TimeLength + 1);
end;

local function trackShake(p11: any, p12: vector, p13: any) -- Line: 71
    -- upvalues: Cam_Shaker (copy)
    local v14 = Cam_Shaker(p12, p13);
    table.insert(p11.Shakes, v14);

    return v14;
end;

local function stopAllShakes(p15) -- Line: 77
    for _, v in p15.Shakes do
        if v:IsShaking() then
            v:Stop();
        end;
    end;

    table.clear(p15.Shakes);
end;

function u2.Reset(p16: table, p17: boolean?) -- Line: 86
    -- upvalues: stopAllShakes (copy), DebrisModule (copy)
    if not p16.TouchPart then
        return;
    end;

    if p17 then
        if p16.Tween then
            p16.Tween:Cancel();
            p16.Tween = nil;
        end;

        stopAllShakes(p16);
        local ShakingFx = p16.ShakingFx;

        if ShakingFx ~= nil and ShakingFx.Parent ~= nil then
            ShakingFx.Enabled = false;
            DebrisModule:AddItem(ShakingFx, 3);
        end;

        p16.ShakingFx = nil;
        local GoingUpFx = p16.GoingUpFx;

        if GoingUpFx ~= nil and GoingUpFx.Parent ~= nil then
            GoingUpFx.Enabled = false;
            DebrisModule:AddItem(GoingUpFx, 3);
        end;

        p16.GoingUpFx = nil;
        local ShakeSound = p16.ShakeSound;

        if ShakeSound ~= nil and ShakeSound.Parent ~= nil then
            ShakeSound:Stop();
            DebrisModule:AddItem(ShakeSound, 0.1);
        end;

        p16.ShakeSound = nil;
    end;

    if p16.StartCF then
        p16.TouchPart.CFrame = p16.StartCF;
    end;

    p16.Falling = false;
end;

function u2.Destroy(p18) -- Line: 107
    p18.Stopped = true;
    p18:Reset(true);

    if p18.Connections then
        for _, v in p18.Connections do
            v:Disconnect();
        end;

        p18.Connections = nil;
    end;

    setmetatable(p18, nil);
end;

return function(p19: userdata, p20: any, u21: userdata) -- Line: 119
    -- upvalues: u2 (copy), PlatformLeniency (copy), Cam_Shaker (copy), DebrisModule (copy), Shaking (copy), PS2dungeonPILLARshake (copy), PS2dungeonPILLARdrop (copy), EmitWhenGoingDown (copy), TweenService (copy), TweenInfo_new_ret (copy), u1 (copy), PS2dungeonPILLARrise (copy), TweenInfo_new_ret2 (copy)
    local u22 = p19.PrimaryPart or p19:FindFirstChild("TouchPart");

    if u22 and u22:IsA("BasePart") then
        local u23 = p19:FindFirstChild("EffectPart") or p19:FindFirstChild("EffectsPart");

        if not (u23 and u23:IsA("BasePart")) then
            u23 = nil;
        end;

        local u24 = setmetatable({
            Falling = false,
            Stopped = false,
            Tween = nil,
            ShakingFx = nil,
            GoingUpFx = nil,
            ShakeSound = nil,
            Model = p19,
            TouchPart = u22,
            EffectPart = u23,
            StartCF = u22.CFrame,
            Connections = {},
            Shakes = {}
        }, u2);

        local function trigger() -- Line: 144
            -- upvalues: u24 (copy), PlatformLeniency (ref), u22 (ref), Cam_Shaker (ref), DebrisModule (ref), u23 (copy), Shaking (ref), PS2dungeonPILLARshake (ref), PS2dungeonPILLARdrop (ref), EmitWhenGoingDown (ref), TweenService (ref), TweenInfo_new_ret (ref), u1 (ref), PS2dungeonPILLARrise (ref), TweenInfo_new_ret2 (ref)
            if u24.Falling or u24.Stopped then
                return;
            end;

            u24.Falling = true;
            local StartCF = u24.StartCF;
            local u25 = 2 * PlatformLeniency();
            local v26 = Cam_Shaker(u22.Position, {
                FadeInTime = 0.1,
                Frequency = 0.25,
                Amplitude = 0.25,
                FadeOutTime = 0.75,
                RotationInfluence = Vector3.new(0.06, 0.06, 0.06),
                PositionInfluence = Vector3.new(1, 1, 1),
                SustainTime = u25
            });
            table.insert(u24.Shakes, v26);
            local ShakingFx = u24.ShakingFx;

            if ShakingFx ~= nil and ShakingFx.Parent ~= nil then
                ShakingFx.Enabled = false;
                DebrisModule:AddItem(ShakingFx, 3);
            end;

            if u23 then
                local v27 = Shaking:Clone();
                v27.Enabled = true;
                v27.Parent = u23;
                u24.ShakingFx = v27;
            end;

            local ShakeSound = u24.ShakeSound;

            if ShakeSound ~= nil and ShakeSound.Parent ~= nil then
                ShakeSound:Stop();
                DebrisModule:AddItem(ShakeSound, 0.1);
            end;

            local v28 = PS2dungeonPILLARshake:Clone();
            v28.Parent = u23 or u22;
            v28:Play();
            u24.ShakeSound = v28;
            task.spawn(function() -- Line: 178
                -- upvalues: u24 (ref), u25 (copy), StartCF (copy), DebrisModule (ref), PS2dungeonPILLARdrop (ref), u23 (ref), u22 (ref), Cam_Shaker (ref), EmitWhenGoingDown (ref), TweenService (ref), TweenInfo_new_ret (ref), u1 (ref), PS2dungeonPILLARrise (ref), TweenInfo_new_ret2 (ref)
                local os_clock_ret = os.clock();
                local v29 = (-1 / 0);
                local v30 = Vector3.new(0, 0, 0);
                local v31 = Vector3.new(0, 0, 0);

                while not u24.Stopped and os.clock() - os_clock_ret < u25 do
                    local os_clock_ret2 = os.clock();
                    local v32 = 0.9 * ((os_clock_ret2 - os_clock_ret) / u25);

                    if os_clock_ret2 - v29 >= 0.09 then
                        local v33 = math.random() * 3.141592653589793 * 2;
                        local v34 = v32 * (0.5 + math.random() * 0.5);
                        local v35 = math.cos(v33) * v34;
                        local v36 = math.sin(v33) * v34;
                        v30 = Vector3.new(v35, 0, v36);
                    else
                        os_clock_ret2 = v29;
                    end;

                    v31 = v31:Lerp(v30, 0.18);

                    if u24.TouchPart then
                        u24.TouchPart.CFrame = StartCF * CFrame.new(v31);
                    end;

                    task.wait();
                    v29 = os_clock_ret2;
                end;

                if u24.Stopped or not u24.TouchPart then
                    return;
                end;

                u24.TouchPart.CFrame = StartCF;
                local ShakingFx2 = u24.ShakingFx;

                if ShakingFx2 ~= nil and ShakingFx2.Parent ~= nil then
                    ShakingFx2.Enabled = false;
                    DebrisModule:AddItem(ShakingFx2, 3);
                end;

                u24.ShakingFx = nil;
                local ShakeSound2 = u24.ShakeSound;

                if ShakeSound2 ~= nil and ShakeSound2.Parent ~= nil then
                    ShakeSound2:Stop();
                    DebrisModule:AddItem(ShakeSound2, 0.1);
                end;

                u24.ShakeSound = nil;
                local v37 = PS2dungeonPILLARdrop:Clone();
                v37.Parent = u23 or u22;
                v37:Play();
                DebrisModule:AddItem(v37, v37.TimeLength + 1);
                local v38 = Cam_Shaker(StartCF.Position, {
                    FadeInTime = 0.1,
                    Frequency = 0.3,
                    Amplitude = 0.5,
                    SustainTime = 0.1,
                    FadeOutTime = 0.3,
                    RotationInfluence = Vector3.new(0.18, 0.18, 0.18),
                    PositionInfluence = Vector3.new(1.4, 1.4, 1.4)
                });
                table.insert(u24.Shakes, v38);

                if u23 then
                    for _, child in EmitWhenGoingDown:GetChildren() do
                        if child:IsA("ParticleEmitter") then
                            local v39 = child:Clone();
                            v39.Parent = u23;
                            v39:Emit(v39:GetAttribute("EmitCount") or 1);
                            DebrisModule:AddItem(v39, 4);
                        end;
                    end;
                end;

                u24.Tween = TweenService:Create(u24.TouchPart, TweenInfo_new_ret, {
                    CFrame = StartCF * CFrame.new(0, -80, 0)
                });
                u24.Tween:Play();
                task.wait(0.75);

                if u24.Stopped or not u24.TouchPart then
                    return;
                end;

                task.wait(4.5);

                if u24.Stopped or not u24.TouchPart then
                    return;
                end;

                local GoingUpFx = u24.GoingUpFx;

                if GoingUpFx ~= nil and GoingUpFx.Parent ~= nil then
                    GoingUpFx.Enabled = false;
                    DebrisModule:AddItem(GoingUpFx, 3);
                end;

                local v40 = u1:Clone();
                v40.Enabled = true;
                v40.Parent = u22;
                u24.GoingUpFx = v40;
                local v41 = PS2dungeonPILLARrise:Clone();
                v41.Parent = u22;
                v41:Play();
                DebrisModule:AddItem(v41, v41.TimeLength + 1);
                local v42 = Cam_Shaker(StartCF.Position, {
                    FadeInTime = 0.15,
                    Frequency = 0.3,
                    Amplitude = 0.5,
                    SustainTime = 0.5,
                    FadeOutTime = 0.4,
                    RotationInfluence = Vector3.new(0.15, 0.15, 0.15),
                    PositionInfluence = Vector3.new(2, 2, 2)
                });
                table.insert(u24.Shakes, v42);
                u24.Tween = TweenService:Create(u24.TouchPart, TweenInfo_new_ret2, {
                    CFrame = StartCF
                });
                u24.Tween:Play();
                task.wait(0.5);

                if u24.Stopped or not u24.TouchPart then
                    return;
                end;

                local GoingUpFx2 = u24.GoingUpFx;

                if GoingUpFx2 ~= nil and GoingUpFx2.Parent ~= nil then
                    GoingUpFx2.Enabled = false;
                    DebrisModule:AddItem(GoingUpFx2, 3);
                end;

                u24.GoingUpFx = nil;
                u24.Tween = nil;
                u24.Falling = false;
            end);
        end;

        local function bindTouch(p43: userdata) -- Line: 282
            -- upvalues: u24 (copy), u21 (copy), trigger (copy)
            table.insert(u24.Connections, p43.Touched:Connect(function(p44) -- Line: 283
                -- upvalues: u21 (ref), trigger (ref)
                if not (p44 and u21) then
                    return;
                end;

                if not p44:IsDescendantOf(u21) then
                    return;
                end;

                trigger();
            end));
        end;

        table.insert(u24.Connections, u22.Touched:Connect(function(p45) -- Line: 283
            -- upvalues: u21 (copy), trigger (copy)
            if not (p45 and u21) then
                return;
            end;

            if not p45:IsDescendantOf(u21) then
                return;
            end;

            trigger();
        end));
        table.insert(u24.Connections, p19.ChildAdded:Connect(function(p46) -- Line: 291
            -- upvalues: u22 (ref), u24 (copy), u21 (copy), trigger (copy)
            if p46.Name ~= u22.Name or not p46:IsA("BasePart") then
                return;
            end;

            u22 = p46;
            u24.TouchPart = p46;
            u24.StartCF = p46.CFrame;
            u24.Falling = false;
            table.insert(u24.Connections, p46.Touched:Connect(function(p47) -- Line: 283
                -- upvalues: u21 (ref), trigger (ref)
                if not (p47 and u21) then
                    return;
                end;

                if not p47:IsDescendantOf(u21) then
                    return;
                end;

                trigger();
            end));
        end));

        return u24;
    end;
end;