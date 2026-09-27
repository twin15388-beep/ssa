-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local BoatTween = require(ReplicatedStorage.CAM.Client.Modules.Effects.BoatTween);
local faye = require(ReplicatedStorage.Packages.faye);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local DartShootingUI = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Training.DartShootingUI);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local workspace_CurrentCamera = workspace.CurrentCamera;
local v1 = {};
local u2 = nil;

local function teardown() -- Line: 34
    -- upvalues: u2 (ref), RunService (copy), Camera_Traffic_Handler (copy)
    local v3 = u2;
    u2 = nil;
    RunService:UnbindFromRenderStep("targetshooting_cam");

    if Camera_Traffic_Handler.TargetShooting then
        Camera_Traffic_Handler.TargetShooting = false;
    end;

    if v3 then
        v3:Destroy();
    end;
end;

local u4 = {
    x = { -15, 15 },
    y = { -7, 7 }
};
u4.x[3] = u4.x[2] - u4.x[1];
u4.y[3] = u4.y[2] - u4.y[1];
local u5 = {
    x = { -30, 30 },
    y = { -30, 30 }
};
u5.x[3] = u5.x[2] - u5.x[1];
u5.y[3] = u5.y[2] - u5.y[1];
local u6 = {
    FillTransparency = 0.2,
    OutlineTransparency = 0,
    FillColor = Color3.new(1, 1, 1),
    OutlineColor = Color3.new(1, 1, 1)
};
local Color3_fromRGB_ret = Color3.fromRGB(0, 255, 0);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 0, 0);
local Random_new_ret = Random.new();
local SoundService = game:GetService("SoundService");

local function PlaySound(p7: userdata?, p8: userdata?) -- Line: 95
    -- upvalues: SoundService (copy), DebrisModule (copy)
    if p7 == nil then
        return;
    end;

    local v9 = p7:Clone();
    v9.Parent = p8 or SoundService;
    v9:Play();
    DebrisModule:AddItem(v9, (v9.TimeLength > 0 and v9.TimeLength or 3) + 0.2);
end;

function v1.Do(p10: userdata, p11: userdata, p12: userdata, p13: userdata?) -- Line: 102
    -- upvalues: u2 (ref), RunService (copy), Camera_Traffic_Handler (copy), SignalEvent (copy), faye (copy), Utility (copy), valuesfolder (copy), workspace_CurrentCamera (copy), UserInputService (copy), PlatformLeniency (copy), DartShootingUI (copy), Random_new_ret (copy), u4 (copy), u6 (copy), u5 (copy), DebrisModule (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), BoatTween (copy), SoundService (copy), TweenService (copy)
    local v14 = u2;
    u2 = nil;
    RunService:UnbindFromRenderStep("targetshooting_cam");

    if Camera_Traffic_Handler.TargetShooting then
        Camera_Traffic_Handler.TargetShooting = false;
    end;

    if v14 then
        v14:Destroy();
    end;

    if p13 == nil then
        SignalEvent.ToServer("training_signaler", "Stop", false);

        return;
    end;

    u2 = faye.new();
    local u15 = u2;
    local Parent = p13.Parent.Parent;
    local CFrame2 = Parent.Center.CFrame;
    u2:Add(Utility.AddValue(valuesfolder, "skill_stand_still"));
    u2:Add(Utility.AddValue(valuesfolder, "pause_gameplay"));
    u2:Add(Utility.AddValue(valuesfolder, "NR"));
    local Folder = Instance.new("Folder");
    Folder.Name = "TargetShootingDarts";
    Folder.Parent = workspace.Debree;
    u2:Add(Folder);
    local Camera = Parent:FindFirstChild("Camera");

    if Camera then
        Camera_Traffic_Handler.TargetShooting = true;
        local u16 = 0;
        local u17 = 0;
        RunService:BindToRenderStep("targetshooting_cam", Enum.RenderPriority.Camera.Value, function() -- Line: 142
            -- upvalues: Camera_Traffic_Handler (ref), workspace_CurrentCamera (ref), UserInputService (ref), u16 (ref), u17 (ref), Camera (copy)
            if Camera_Traffic_Handler.Equipped_Hirearchy ~= "TargetShooting" then
                return;
            end;

            local ViewportSize = workspace_CurrentCamera.ViewportSize;
            local MouseLocation = UserInputService:GetMouseLocation();
            local math_clamp_ret = math.clamp((MouseLocation.X - ViewportSize.X / 2) / (ViewportSize.X / 2), -1, 1);
            local math_clamp_ret2 = math.clamp((MouseLocation.Y - ViewportSize.Y / 2) / (ViewportSize.Y / 2), -1, 1);
            u16 = u16 + (math_clamp_ret - u16) * 0.1;
            u17 = u17 + (math_clamp_ret2 - u17) * 0.1;
            workspace_CurrentCamera.CFrame = Camera.CFrame * CFrame.new(u16 * 0.4, -u17 * 0.4, 0) * CFrame.Angles(-u17 * 0.08726646259971647, -u16 * 0.08726646259971647, 0);
        end);
    end;

    local Misc = p10.PlayerGui:WaitForChild("Misc");
    local u18 = false;
    local u19 = false;
    local v20 = PlatformLeniency();
    local u21 = 3 * v20;
    local u22 = 0.8 * v20;
    local u24 = DartShootingUI(Misc, {
        Thread = u2,

        Stop = function(p23: boolean) -- Line: 178, Name: Stop
            -- upvalues: u18 (ref), u19 (ref), SignalEvent (ref)
            if u18 then
                return;
            end;

            u18 = true;
            u19 = true;
            SignalEvent.ToServer("training_signaler", "Stop", p23 == true);
        end
    });
    task.spawn(function() -- Line: 186
        -- upvalues: u15 (copy), u19 (ref), CFrame2 (copy), Random_new_ret (ref), u4 (ref), Folder (copy), u6 (ref), u5 (ref), DebrisModule (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), BoatTween (ref), SoundService (ref), workspace_CurrentCamera (ref), TweenService (ref), u24 (copy), RunService (ref), u21 (copy), u22 (copy)
        while u15.IsActive and not u19 do
            local u25 = CFrame2 * CFrame.new(Random_new_ret:NextNumber() * u4.x[3] + u4.x[1], Random_new_ret:NextNumber() * u4.y[3] + u4.y[1], 0);
            local u26 = script.DarBoard:Clone();
            u26.Parent = Folder;
            local u27 = u26:FindFirstChild("Root") or u26.PrimaryPart;
            local ClickDetector = Instance.new("ClickDetector", u27);
            ClickDetector.MaxActivationDistance = 200;
            local u28 = nil;
            ClickDetector.MouseHoverEnter:Connect(function() -- Line: 198
                -- upvalues: u28 (ref), u26 (copy), u6 (ref)
                if u28 ~= nil then
                    u28:Destroy();
                    u28 = nil;
                end;

                u28 = Instance.new("Highlight", u26);

                for i, v in u6 do
                    u28[i] = v;
                end;
            end);
            ClickDetector.MouseHoverLeave:Connect(function() -- Line: 208
                -- upvalues: u28 (ref)
                if u28 ~= nil then
                    u28:Destroy();
                    u28 = nil;
                end;
            end);
            local u29 = false;
            local u30 = false;

            local function Delete() -- Line: 216
                -- upvalues: u29 (ref), u27 (copy), u26 (copy), Random_new_ret (ref), u5 (ref), DebrisModule (ref)
                if u29 then
                    return;
                end;

                u29 = true;
                local v31 = u27;

                for _, child in u26:GetChildren() do
                    if child ~= u26.PrimaryPart and child:IsA("BasePart") then
                        child.CanCollide = false;
                        child.Anchored = false;
                        local CFrame3 = v31.CFrame;
                        local v32 = Random_new_ret:NextNumber() * u5.x[3] + u5.x[1];
                        local v33 = Random_new_ret:NextNumber() * u5.y[3] + u5.y[1];
                        child.AssemblyLinearVelocity = CFrame3:VectorToWorldSpace((Vector3.new(v32, v33, 0)));
                    end;
                end;

                DebrisModule:AddItem(u26, 3);
            end;

            local function FadeOutHighlight(p34: boolean) -- Line: 241
                -- upvalues: u28 (ref), u26 (copy), u6 (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), BoatTween (ref)
                if u28 == nil then
                    u28 = Instance.new("Highlight", u26);

                    for i, v in u6 do
                        u28[i] = v;
                    end;
                end;

                local u35 = u28;
                u28 = nil;
                local v36 = p34 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
                u35.FillColor = v36;
                u35.OutlineColor = v36;
                local u37 = BoatTween:Create(u35, {
                    Time = 0.3,
                    EasingStyle = "Quad",
                    EasingDirection = "Out",
                    Goal = {
                        FillTransparency = 1,
                        OutlineTransparency = 1
                    }
                });
                u37:Play();
                task.defer(function() -- Line: 260
                    -- upvalues: u37 (copy), u35 (copy)
                    u37.Completed:Wait();
                    u37:Destroy();

                    if u35 then
                        u35:Destroy();
                    end;
                end);
            end;

            local function FireDart(u38: function) -- Line: 272
                -- upvalues: Folder (ref), SoundService (ref), DebrisModule (ref), workspace_CurrentCamera (ref), u27 (copy), TweenService (ref)
                local u39 = script.Dart:Clone();
                local Root = u39.Root;
                local Dart = u39.Dart;
                Root.Anchored = true;
                u39.Parent = Folder;
                local script_PS2trainingDARTSthrow = script.PS2trainingDARTSthrow;

                if script_PS2trainingDARTSthrow ~= nil then
                    local v40 = script_PS2trainingDARTSthrow:Clone();
                    v40.Parent = SoundService;
                    v40:Play();
                    DebrisModule:AddItem(v40, (v40.TimeLength > 0 and v40.TimeLength or 3) + 0.2);
                end;

                local CFrame_lookAt_ret = CFrame.lookAt(workspace_CurrentCamera.CFrame.Position + workspace_CurrentCamera.CFrame.LookVector * 4, u27.Position);
                Root.CFrame = CFrame_lookAt_ret;
                local v41 = CFrame_lookAt_ret.Rotation + u27.Position;
                local u42 = TweenService:Create(Root, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    CFrame = v41
                });
                u42:Play();
                task.defer(function() -- Line: 296
                    -- upvalues: u42 (copy), u38 (copy), Dart (copy), TweenService (ref), u39 (copy)
                    u42.Completed:Wait();
                    u38();
                    task.wait(0.25);

                    if Dart.Parent == nil then
                        return;
                    end;

                    local v43 = TweenService:Create(Dart, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 1
                    });
                    v43:Play();
                    v43.Completed:Wait();
                    u39:Destroy();
                end);
            end;

            ClickDetector.MouseClick:Connect(function() -- Line: 313
                -- upvalues: u29 (ref), u30 (ref), u19 (ref), ClickDetector (ref), FireDart (copy), u27 (copy), SoundService (ref), DebrisModule (ref), FadeOutHighlight (copy), u24 (ref), Delete (copy)
                if u29 or (u30 or u19) then
                    return;
                end;

                u30 = true;

                if ClickDetector ~= nil then
                    ClickDetector:Destroy();
                    ClickDetector = nil;
                end;

                FireDart(function() -- Line: 322
                    -- upvalues: u27 (ref), SoundService (ref), DebrisModule (ref), FadeOutHighlight (ref), u24 (ref), Delete (ref)
                    local script_PS2trainingDARTSsmash = script.PS2trainingDARTSsmash;
                    local v44 = u27;

                    if script_PS2trainingDARTSsmash ~= nil then
                        local v45 = script_PS2trainingDARTSsmash:Clone();
                        v45.Parent = v44 or SoundService;
                        v45:Play();
                        DebrisModule:AddItem(v45, (v45.TimeLength > 0 and v45.TimeLength or 3) + 0.2);
                    end;

                    FadeOutHighlight(true);
                    u24.Hit();
                    Delete();
                end);
            end);
            u26:PivotTo(u25);
            u26:ScaleTo(0.05);
            local NumberValue = Instance.new("NumberValue");
            NumberValue.Value = 0.05;
            local u46 = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 336
                -- upvalues: u29 (ref), u26 (copy), NumberValue (copy)
                if u29 or u26.Parent == nil then
                    return;
                end;

                u26:ScaleTo(NumberValue.Value);
            end);
            local u47 = BoatTween:Create(NumberValue, {
                Time = 0.4,
                EasingStyle = "Bounce",
                EasingDirection = "Out",
                Goal = {
                    Value = 1
                }
            });
            u47:Play();
            task.defer(function() -- Line: 347
                -- upvalues: u47 (copy), u46 (copy), NumberValue (copy)
                u47.Completed:Wait();
                u47:Destroy();
                u46:Disconnect();
                NumberValue:Destroy();
            end);
            task.spawn(function() -- Line: 358
                -- upvalues: u29 (ref), u30 (ref), u26 (copy), RunService (ref), u21 (ref), u25 (copy)
                local v48 = 0;

                while not (u29 or (u30 or u26.Parent == nil)) do
                    v48 = v48 + RunService.Heartbeat:Wait();
                    local v49 = u21 - v48;

                    if v49 <= 0.75 then
                        local math_clamp_ret = math.clamp((0.75 - v49) / 0.75, 0, 1);
                        local v50 = v48 * 25;
                        local v51 = math.noise(v50, 0, 0) * 0.6 * math_clamp_ret;
                        local v52 = math.noise(0, v50, 7.3) * 0.6 * math_clamp_ret;

                        if u29 or u30 then
                            break;
                        end;

                        u26:PivotTo(u25 * CFrame.new(v51, v52, 0));
                    end;
                end;
            end);
            task.delay(u21, function() -- Line: 373
                -- upvalues: u29 (ref), u30 (ref), u19 (ref), ClickDetector (ref), u27 (copy), SoundService (ref), DebrisModule (ref), FadeOutHighlight (copy), u24 (ref), Delete (copy)
                if u29 or (u30 or u19) then
                    return;
                end;

                if ClickDetector ~= nil then
                    ClickDetector:Destroy();
                    ClickDetector = nil;
                end;

                local script_PS2trainingDARTSsmash = script.PS2trainingDARTSsmash;
                local v53 = u27;

                if script_PS2trainingDARTSsmash ~= nil then
                    local v54 = script_PS2trainingDARTSsmash:Clone();
                    v54.Parent = v53 or SoundService;
                    v54:Play();
                    DebrisModule:AddItem(v54, (v54.TimeLength > 0 and v54.TimeLength or 3) + 0.2);
                end;

                FadeOutHighlight(false);
                u24.Miss();
                Delete();
            end);
            task.wait(u22);
        end;
    end);
end;

function v1.Stop(p55: userdata, p56: userdata, p57: userdata) -- Line: 390
    -- upvalues: u2 (ref), RunService (copy), Camera_Traffic_Handler (copy)
    local v58 = u2;
    u2 = nil;
    RunService:UnbindFromRenderStep("targetshooting_cam");

    if Camera_Traffic_Handler.TargetShooting then
        Camera_Traffic_Handler.TargetShooting = false;
    end;

    if v58 then
        v58:Destroy();
    end;
end;

return v1;