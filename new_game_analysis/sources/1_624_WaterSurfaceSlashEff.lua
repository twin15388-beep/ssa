-- Decompiled with Potassium's decompiler.

local vfxUtility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("vfxUtility"));
local u1 = workspace.Debree:FindFirstChild(game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd");

if u1 == nil then
    u1 = Instance.new("Folder", workspace.Debree);
    u1.Name = game.Players.LocalPlayer.Name .. "\'s effects debree thing213asdasdasdasd";
end;

local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local TweenService = game:GetService("TweenService");
local BoatTween = require(game.ReplicatedStorage.CAM.Client:WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("BoatTween"));
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));

return function(p2, p3) -- Line: 16
    -- upvalues: u1 (ref), BoatTween (copy), DebrisModule (copy), TweenService (copy), vfxUtility (copy), Cam_Shaker (copy)
    local v4 = `{p2.Name}+{script.Name}`;
    local v5 = u1:FindFirstChild(v4);

    if v5 ~= nil then
        v5.Name = "--";
        local WindDash = v5:FindFirstChild("WindDash");

        if WindDash ~= nil then
            local v6 = next;
            local Descendants, v7 = WindDash:GetDescendants();

            for _, v in v6, Descendants, v7 do
                if v:IsA("Beam") then
                    BoatTween:Create(v, {
                        Time = 0.4,
                        EasingStyle = "Quad",
                        EasingDirection = "In",
                        StepType = "RenderStepped",
                        Goal = {
                            TextureSpeed = 0,
                            Transparency = NumberSequence.new(1)
                        }
                    }):Play();
                elseif v:IsA("ParticleEmitter") then
                    v.Enabled = false;
                end;
            end;
        end;

        DebrisModule:AddItem(v5, 3);
        local Dust = v5:FindFirstChild("Dust");

        if Dust then
            local PS2WBblitzLOOP = Dust:FindFirstChild("PS2WBblitzLOOP");

            if PS2WBblitzLOOP ~= nil then
                TweenService:Create(PS2WBblitzLOOP, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                    Volume = 0
                }):Play();
            end;

            local PS2WBblitzRUNnotlooped = Dust:FindFirstChild("PS2WBblitzRUNnotlooped");

            if PS2WBblitzRUNnotlooped ~= nil then
                TweenService:Create(PS2WBblitzRUNnotlooped, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                    Volume = 0
                }):Play();
            end;

            vfxUtility.DisableAll(Dust);
        end;
    end;

    local Sword_At_A = p2:FindFirstChild("Sword_At_A", true);

    if Sword_At_A ~= nil then
        local Parent = Sword_At_A.Parent;

        if Parent ~= nil and Parent:FindFirstChild("bladetfftians##asd") then
            local u8 = {};

            for _, child in pairs(Parent:GetChildren()) do
                if child.Name == "bladetfftians##asd" then
                    child.Name = "--";
                    table.insert(u8, child);
                end;
            end;

            if #u8 > 0 then
                task.delay(0.35, function() -- Line: 72
                    -- upvalues: u8 (copy)
                    if u8 ~= nil then
                        for _, v in pairs(u8) do
                            v.Enabled = false;
                        end;
                    end;

                    task.wait(1);

                    for _, v in ipairs(u8) do
                        v:Destroy();
                    end;
                end);
            end;
        end;
    end;

    if p2 == nil then
        return;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude >= 250 then
        return;
    end;

    if p3 ~= "Init" then
        if p3 == "Slash" then
            local v9 = script.SurfaceSlash:Clone();
            v9:SetPrimaryPartCFrame(HumanoidRootPart.CFrame);
            v9.Parent = u1;
            v9.Root.PS2WBblitzSLASH:Play();
            DebrisModule:AddItem(v9, 2);
            TweenService:Create(v9.SlashBeamStart, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {
                CFrame = v9.SlashBeamEnd.CFrame
            }):Play();
            vfxUtility.EmitAll(v9.EmittingParts);
            vfxUtility.EmitAll(v9.SlashBeam);
            TweenService:Create(v9.SlashBeam.Slash.Attachment.PointLight, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Brightness = 0
            }):Play();

            for _, descendant in pairs(v9.SlashBeamStart:GetDescendants()) do
                if descendant:IsA("Beam") then
                    local _ = descendant.TextureLength;
                    local _ = descendant.Width0;
                    local _ = descendant.Width1;
                    TweenService:Create(descendant, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        TextureLength = 0.1
                    }):Play();
                    local u10 = TweenService:Create(descendant, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        Width0 = 0,
                        Width1 = 0
                    });
                    task.delay(0.2, function() -- Line: 173
                        -- upvalues: u10 (copy)
                        u10:Play();
                    end);
                end;
            end;

            Cam_Shaker(HumanoidRootPart.Position, {
                FadeInTime = 0.1,
                Frequency = 0.35,
                Amplitude = 0.4,
                SustainTime = 0.2,
                FadeOutTime = 0.3,
                RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
                PositionInfluence = Vector3.new(1, 1, 1)
            });
        end;

        return;
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = v4;
    Folder.Parent = u1;
    local v11 = script.WindDash:Clone();
    v11.Parent = Folder;
    local Weld = Instance.new("Weld", v11);
    Weld.Part0 = HumanoidRootPart;
    Weld.Part1 = v11;
    DebrisModule:AddItem(Folder, 7);
    local v12 = script.Dust:Clone();
    v12.Parent = Folder;
    local Weld2 = Instance.new("Weld", v12);
    Weld2.Part0 = HumanoidRootPart;
    Weld2.Part1 = v12;
    Weld2.C0 = CFrame.new(0, -2.5, -1.5);
    local v13 = Cam_Shaker(HumanoidRootPart.Position, {
        FadeInTime = 0.1,
        Frequency = 0.25,
        Amplitude = 0.04,
        SustainTime = 6,
        FadeOutTime = 0.5,
        RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
        PositionInfluence = Vector3.new(0.6, 0.6, 0.6)
    });
    v12.PS2WBblitzDASH:Play();
    v12.PS2WBblitzRUNnotlooped:Play();
    v12.PS2WBblitzLOOP:Play();
    local Sword_At_A2 = p2:FindFirstChild("Sword_At_A", true);

    if Sword_At_A2 ~= nil then
        local Parent = Sword_At_A2.Parent;
        local u14 = {};

        for _, child in pairs(script.Parent.SwordTrail:GetChildren()) do
            local v15 = child:Clone();
            v15.Name = "bladetfftians##asd";
            table.insert(u14, v15);
            v15.Parent = Parent;

            if v15:IsA("Trail") then
                v15.Attachment0 = Parent.Sword_At_A;
                v15.Attachment1 = Parent.Sword_At_B;
            end;
        end;

        if u14 ~= nil and u14[1] ~= nil then
            task.delay(5, function() -- Line: 138
                -- upvalues: u14 (copy)
                if u14[1].Name ~= "--" then
                    for _, v in ipairs(u14) do
                        v:Destroy();
                    end;
                end;
            end);
        end;
    end;

    while Folder ~= nil and (Folder.Parent == u1 and (Folder.Name ~= "--" and HumanoidRootPart ~= nil)) do
        task.wait(0.1);
    end;

    v13:Destroy();
end;