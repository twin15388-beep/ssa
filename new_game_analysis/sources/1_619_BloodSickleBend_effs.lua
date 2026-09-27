-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local TweenService = game:GetService("TweenService");
game:GetService("ReplicatedStorage");
game:GetService("Players");
local RunService = game:GetService("RunService");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };

local function StopSound(p2: userdata, p3: string) -- Line: 22
    -- upvalues: TweenService (copy)
    local u4 = p2:FindFirstChild(p3);

    if not u4 then
        return;
    end;

    u4.Name = string.rep("_", 16);
    TweenService:Create(u4, TweenInfo.new(0.5), {
        Volume = 0
    }):Play();
    task.delay(0.5, function() -- Line: 31
        -- upvalues: u4 (copy)
        u4:Destroy();
    end);
end;

local function lerp(p5, p6, p7) -- Line: 36
    return p5 + (p6 - p5) * p7;
end;

local function QuadBezier(p8, p9, p10, p11) -- Line: 39
    local v12 = p9 + (p10 - p9) * p8;

    return v12 + (p10 + (p11 - p10) * p8 - v12) * p8;
end;

local script_Assets = script.Assets;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret2.IgnoreWater = true;
RaycastParams_new_ret2.RespectCanCollide = true;
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local u13 = {
    FadeInTime = 0,
    Frequency = 0.125,
    Amplitude = 0.25,
    SustainTime = 10,
    FadeOutTime = 0.5,
    RotationInfluence = Vector3.new(0.15, 0.15, 0.15),
    PositionInfluence = Vector3.new(1, 1, 1)
};
local u14 = game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(game.Players.LocalPlayer.Name);

local function u44(p15: any, p16: any, p17: any, u18: boolean) -- Line: 64
    -- upvalues: script_Assets (copy), u1 (ref), DebrisModule (copy), vfxUtility (copy), u14 (copy), TweenService (copy), Cam_Shaker (copy), u44 (ref), u13 (copy), RaycastParams_new_ret2 (copy), RunService (copy)
    if p15 == nil or p16 == nil then
        return;
    end;

    local HumanoidRootPart = p15:FindFirstChild("HumanoidRootPart");
    local RightHand = p15:FindFirstChild("RightHand");

    if HumanoidRootPart == nil or RightHand == nil then
        return;
    end;

    local u19 = p17;

    if u19 == nil then
        if p16 ~= "Startup" then
            return;
        end;

        u19 = workspace.Debree.Projectiles:WaitForChild("BendProjectile" .. p15.Name, 3);

        if u19 == nil then
            return;
        end;
    end;

    local v20 = u19 and u19:IsA("Part") and u19.CFrame or HumanoidRootPart.CFrame;
    local u21 = p15 == game.Players.LocalPlayer.Character;

    if not (u21 or (v20 == nil or (v20.Position - workspace.CurrentCamera.CFrame.Position).Magnitude < 250) and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude < 250) then
        return;
    end;

    if p16 == "Startup" then
        local v22 = script_Assets.Startup:Clone();
        v22.CFrame = HumanoidRootPart.CFrame;
        v22.Parent = u1;
        DebrisModule:AddItem(v22, 2);
        vfxUtility.EnableAll(v22, true);
        task.wait(0.2);
        vfxUtility.EnableAll(v22, false);
        local v23 = script_Assets.ShootEffect:Clone();
        v23.CFrame = u19.CFrame;
        v23.Parent = u1;
        vfxUtility.EmitAll(v23);
        DebrisModule:AddItem(v23, 1.25);
        local v24 = script_Assets.Main:Clone();
        v24.Parent = u19;
        v24.Name = "VFX";
        local Weld = Instance.new("Weld");
        Weld.Part0 = u19;
        Weld.Part1 = v24;
        Weld.Parent = v24;
        vfxUtility.EnableAll(v24, true);

        if u21 and u19:FindFirstChild("CamPart") then
            local ObjectValue = Instance.new("ObjectValue");
            ObjectValue.Name = "camsubject";
            ObjectValue.Value = u19:FindFirstChild("CamPart");
            DebrisModule:AddItem(ObjectValue, 7);
            ObjectValue.Parent = u14;
        end;

        vfxUtility.PlaySound(script.Sounds, "PS2bloodsickBENDlaunch", v23);
        vfxUtility.PlaySound(script.Sounds, "PS2bloodsickBENDloop", u19);
    elseif p16 == "Expire" then
        if u21 then
            local camsubject = u14:FindFirstChild("camsubject");

            if u19 and u19:FindFirstChild("CamPart") then
                local CamPart = u19:FindFirstChild("CamPart");

                if camsubject ~= nil and camsubject.Value == CamPart then
                    if u18 then
                        camsubject:Destroy();
                    else
                        if CamPart:FindFirstChild("Weld") then
                            CamPart:FindFirstChild("Weld"):Destroy();
                        end;

                        TweenService:Create(CamPart, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                            CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.25, -0.05, -0.7)
                        }):Play();
                        DebrisModule:AddItem(camsubject, 0.4);
                        task.delay(0.4, function() -- Line: 151
                            -- upvalues: Cam_Shaker (ref), HumanoidRootPart (copy)
                            Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
                        end);
                    end;
                end;
            end;
        end;

        local VFX = u19:FindFirstChild("VFX");

        if not VFX then
            task.spawn(u44, p15, "GoBack", u19);

            return;
        end;

        if VFX:FindFirstChild("PS2bloodsickBENDloop") and VFX:FindFirstChild("PS2bloodsickBENDloop").IsPlaying then
            VFX:FindFirstChild("PS2bloodsickBENDloop"):Stop();
        end;

        local v25 = next;
        local Descendants, v26 = VFX:GetDescendants();

        for _, v in v25, Descendants, v26 do
            if v.ClassName == "Beam" then
                TweenService:Create(v, TweenInfo.new(0.3), {
                    Width0 = 0,
                    Width1 = 0
                }):Play();
            end;
        end;

        vfxUtility.EnableAll(VFX, false);
        DebrisModule:AddItem(VFX, 1.25);
        task.spawn(u44, p15, "GoBack", u19);
        task.delay(0.4, function() -- Line: 180
            -- upvalues: Cam_Shaker (ref), HumanoidRootPart (copy)
            Cam_Shaker(HumanoidRootPart.Position, "activate_shake");
        end);
    elseif p16 == "Chainsaw" then
        task.delay(0.1, function() -- Line: 185
            -- upvalues: u21 (copy), u14 (ref), u19 (ref), TweenService (ref), HumanoidRootPart (copy), DebrisModule (ref)
            if u21 then
                local camsubject = u14:FindFirstChild("camsubject");

                if u19 and u19:FindFirstChild("CamPart") then
                    local CamPart = u19:FindFirstChild("CamPart");

                    if camsubject ~= nil and camsubject.Value == u19:FindFirstChild("CamPart") then
                        if CamPart:FindFirstChild("Weld") then
                            CamPart:FindFirstChild("Weld"):Destroy();
                        end;

                        TweenService:Create(CamPart, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                            CFrame = HumanoidRootPart.CFrame * CFrame.new(-0.25, -0.05, -0.7)
                        }):Play();
                        DebrisModule:AddItem(camsubject, 0.3);
                    end;
                end;
            end;
        end);
        local VFX = u19:FindFirstChild("VFX");

        if not VFX then
            return;
        end;

        if VFX:FindFirstChild("PS2bloodsickBENDloop") and VFX:FindFirstChild("PS2bloodsickBENDloop").IsPlaying then
            VFX:FindFirstChild("PS2bloodsickBENDloop"):Stop();
        end;

        local v27 = next;
        local Descendants, v28 = VFX:GetDescendants();

        for _, v in v27, Descendants, v28 do
            if v.ClassName == "Beam" then
                TweenService:Create(v, TweenInfo.new(0.3), {
                    Width0 = 0,
                    Width1 = 0
                }):Play();
            end;
        end;

        vfxUtility.EnableAll(VFX, false);
        DebrisModule:AddItem(VFX, 1.25);
        local v29 = Cam_Shaker(u18.Position, u13);
        local v30 = script_Assets.Buzzsaw:Clone();
        v30.CFrame = u18 * CFrame.Angles(0, 0, 1.5707963267948966);
        v30.Parent = u1;
        vfxUtility.EnableAll(v30, true);
        vfxUtility.PlaySound(script.Sounds, "PS2bloodsickBENDsuccess", v30);
        local v31 = workspace:Raycast(v30.Position + Vector3.new(0, 5, 0), -CFrame.new(v30.Position).UpVector * 10, RaycastParams_new_ret2);
        local v32 = nil;

        if v31 then
            local Vector3_new_ret = Vector3.new(v30.CFrame.LookVector.X, 0, v30.CFrame.LookVector.Z);
            v32 = script_Assets.SawMark:Clone();
            v32.CFrame = CFrame.lookAt(v31.Position, v31.Position + Vector3_new_ret, v31.Normal);
            v32.Parent = u1;
            vfxUtility.EnableAll(v32, true);
        else
            vfxUtility.EnableAll(v30.Dust, false);
        end;

        local v33 = script_Assets.SlashSpawnEffect:Clone();
        v33.CFrame = u18;
        v33.Parent = u1;
        vfxUtility.EmitAll(v33);
        DebrisModule:AddItem(v33, 1.25);
        task.wait(1.5);
        v29:Stop();
        v29:Destroy();
        vfxUtility.EnableAll(v30, false);
        DebrisModule:AddItem(v30, 1.75);

        if v32 then
            vfxUtility.EnableAll(v32, false);
            DebrisModule:AddItem(v32, 1.15);
        end;

        task.spawn(u44, p15, "GoBack", u19, true);
    elseif p16 == "GoBack" then
        local v34 = {
            CFrame.new(-40, 15, 0),
            CFrame.new(-40, 0, 0),
            CFrame.new(40, 15, 0),
            CFrame.new(40, 0, 0),
            CFrame.new(0, 30, 0)
        };
        local CFrame2 = u19.CFrame;

        for i = 1, 5 do
            local u35 = script_Assets.Trail:Clone();
            u35.Position = CFrame2.Position;
            u35.Parent = u1;
            vfxUtility.EnableAll(u35, true);
            local Position = (CFrame.lookAt(u35.Position:Lerp(HumanoidRootPart.Position, 0.25), HumanoidRootPart.Position) * v34[i]).Position;
            local u36 = 0;
            local u37 = nil;
            u37 = RunService.Heartbeat:Connect(function(p38) -- Line: 298
                -- upvalues: u36 (ref), CFrame2 (copy), Position (copy), HumanoidRootPart (copy), u37 (ref), vfxUtility (ref), u35 (copy), DebrisModule (ref)
                u36 = u36 + p38 * 2.5;
                local v39 = u36;
                local Position2 = CFrame2.Position;
                local v40 = Position;
                local v41 = Position2 + (v40 - Position2) * v39;
                local v42 = v41 + (v40 + (HumanoidRootPart.Position - v40) * v39 - v41) * v39;

                if u36 < 1 then
                    u35.Position = v42;

                    return;
                end;

                u37:Disconnect();
                vfxUtility.EnableAll(u35, false);
                DebrisModule:AddItem(u35, 1.25);
            end);
            local _ = i;
        end;

        task.delay(0.4, function() -- Line: 314
            -- upvalues: script_Assets (ref), HumanoidRootPart (copy), u1 (ref), vfxUtility (ref), DebrisModule (ref), u18 (copy)
            local v43 = script_Assets.Startup:Clone();
            v43.CFrame = HumanoidRootPart.CFrame;
            v43.Parent = u1;
            vfxUtility.EmitAll(v43);
            DebrisModule:AddItem(v43, 1.25);
            vfxUtility.PlaySound(script.Sounds, u18 and "PS2bloodsickBENDreturnSUCCESS" or "PS2bloodsickBENDreturn", HumanoidRootPart);
        end);
    end;
end;

return u44;