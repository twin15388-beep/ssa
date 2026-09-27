-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.Types.ScenariosType);
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Combat_presets = require(ReplicatedStorage.CAM.Global.Combat_presets);
require(ReplicatedStorage.RemotePlus.Handlers.Utility);
game.ReplicatedStorage.Player_Service.Values:WaitForChild(game.Players.LocalPlayer.Name);
local u1 = 0;
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.5);
local os_clock = os.clock;

return {
    Activators = {
        EquippedAccessory = "Stone Breathing Weapon"
    },

    Do = function(p2: userdata, u3: userdata) -- Line: 21, Name: Do
        -- upvalues: u1 (ref), RaycastHelper (copy), os_clock (copy), Combat_presets (copy), TweenService (copy), TweenInfo_new_ret (copy), Ouwmit (copy), DebrisModule (copy)
        local math_random_ret = math.random(1, 99999);
        u1 = math_random_ret;
        local v4 = u3.Tool_Accessories:FindFirstChild("Stone Breathing Weapon");
        local Humanoid = u3:FindFirstChild("Humanoid");

        if v4 ~= nil and v4:WaitForChild("RootPart", 0.2) ~= nil then
            if math_random_ret ~= u1 then
                return;
            end;

            local PrimaryPart = u3.PrimaryPart;
            local Ball = v4.RootPart:FindFirstChild("Ball");

            if Ball ~= nil and PrimaryPart ~= nil then
                task.spawn(function() -- Line: 31
                    -- upvalues: math_random_ret (copy), u1 (ref), u3 (copy), Ball (copy), PrimaryPart (copy), Humanoid (copy), RaycastHelper (ref), os_clock (ref), Combat_presets (ref), TweenService (ref), TweenInfo_new_ret (ref), Ouwmit (ref), DebrisModule (ref)
                    local u5 = script.DragPart:Clone();
                    u5.Parent = workspace.Debree;
                    local PointLight = u5.Sparks.PointLight;
                    local PlaybackSpeed = u5.Sound.PlaybackSpeed;
                    local v6 = false;
                    local v7 = nil;

                    while math_random_ret == u1 and (u3.Parent ~= nil and (Ball ~= nil and (Ball.Parent ~= nil and (PrimaryPart ~= nil and (PrimaryPart.Parent ~= nil and (Humanoid ~= nil and Humanoid.Parent ~= nil)))))) do
                        local v8 = workspace:Raycast(Ball.TransformedWorldCFrame.Position + Vector3.new(0, 4, 0), Vector3.new(0, -7.25, 0), RaycastHelper.Crater);

                        if v8 == nil or (v8.Position == nil or (vector.magnitude(Humanoid.MoveDirection) <= 0.05 or (vector.magnitude(PrimaryPart.AssemblyLinearVelocity) <= 2 or (os_clock() - Combat_presets.Last_Punched <= Combat_presets.combo_duration or not (os_clock() - Combat_presets.lastRunHit and (u3:FindFirstChild("SHC") == nil or u3.SHC.Value == "")))))) then
                            if v6 then
                                local math_random_ret2 = math.random(1, 999);
                                local u9 = math_random_ret2;
                                TweenService:Create(u5.Sound, TweenInfo_new_ret, {
                                    Volume = 0
                                }):Play();
                                TweenService:Create(PointLight, TweenInfo_new_ret, {
                                    Brightness = 0,
                                    Range = 0
                                }):Play();
                                task.delay(TweenInfo_new_ret.Time, function() -- Line: 80
                                    -- upvalues: u9 (ref), math_random_ret2 (copy), u5 (copy)
                                    if u9 ~= math_random_ret2 then
                                        return;
                                    end;

                                    u5.Sound:Stop();
                                end);
                                Ouwmit.Enable(u5, false);
                                v6 = false;
                            end;
                        else
                            u5.CFrame = CFrame.new(v8.Position) * PrimaryPart.CFrame.Rotation * CFrame.new(0, 0.05, 0);

                            if v6 == false then
                                u5.Sound.Volume = 0;
                                u5.Sound:Play();
                                TweenService:Create(u5.Sound, TweenInfo_new_ret, {
                                    Volume = script.DragPart.Sound.Volume
                                }):Play();
                                TweenService:Create(PointLight, TweenInfo_new_ret, {
                                    Brightness = script.DragPart.Sparks.PointLight.Brightness,
                                    Range = script.DragPart.Sparks.PointLight.Range
                                }):Play();
                                Ouwmit.Enable(u5, true, {
                                    ColorBlacklist = "Sparks",
                                    Color = v8.Instance.Color
                                });
                                v7 = v8.Instance;
                                v6 = true;
                            elseif v7 ~= v8.Instance then
                                v7 = v8.Instance;

                                for _, child in ipairs(u5:GetChildren()) do
                                    if child:IsA("ParticleEmitter") then
                                        child.Color = ColorSequence.new(v8.Instance.Color);
                                    end;
                                end;
                            end;

                            local v10 = Humanoid.WalkSpeed / 16;

                            if v10 > 1 then
                                v10 = 1 + (v10 - 1) * 0.5;
                            end;

                            if PlaybackSpeed ~= v10 then
                                TweenService:Create(u5.Sound, TweenInfo_new_ret, {
                                    PlaybackSpeed = v10
                                }):Play();
                                PlaybackSpeed = v10;
                            end;
                        end;

                        task.wait(0.05);
                    end;

                    TweenService:Create(PointLight, TweenInfo_new_ret, {
                        Brightness = 0,
                        Range = 0
                    }):Play();
                    TweenService:Create(u5.Sound, TweenInfo_new_ret, {
                        Volume = 0
                    }):Play();
                    Ouwmit.Enable(u5, false);
                    DebrisModule:AddItem(u5, 1);
                end);
            end;
        end;
    end,

    Stop = function(p11: userdata, p12: userdata) -- Line: 99, Name: Stop
        -- upvalues: u1 (ref)
        u1 = 0;
    end
};