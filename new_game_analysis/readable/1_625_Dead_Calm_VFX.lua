-- Decompiled with Potassium's decompiler.

game:GetService("Players");
local TweenService = game:GetService("TweenService");
game:GetService("RunService");
local CAM = game:GetService("ReplicatedStorage").CAM;
local Modules = CAM.Client.Modules;
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
script:FindFirstChild("Sounds");
local DebrisModule = require(CAM.DebrisModule);
require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterHandler);
require(Modules.Effects.BoatTween);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;

function PlayAnimation(p1: any, p2: string, p3: number?, p4: any)
    -- upvalues: Assets (copy)
    local v5 = Assets:FindFirstChild(p2);

    if p1 and v5 then
        local v6 = p1:LoadAnimation(v5);
        v6:Play();

        if p4 then
            v6.Stopped:Once(p4);
        end;

        return v6;
    end;
end;

local function SwordTrail(p7: userdata, p8: boolean) -- Line: 55
    -- upvalues: vfxUtility (copy)
    local Has_Blade = p7:FindFirstChild("Has_Blade", true);
    local v9;

    if Has_Blade == nil or Has_Blade.Parent == nil then
        v9 = nil;
    else
        v9 = Has_Blade.Parent:FindFirstChild("Blade");
    end;

    if v9 == nil then
        return;
    end;

    if p8 == true or p8 == nil then
        local u10 = {};

        for _, child in pairs(script.Parent.SwordTrail:GetChildren()) do
            local v11 = child:Clone();
            v11.Name = "bladetfftians##asd";
            v11.Parent = v9;
            table.insert(u10, v11);

            if v11:IsA("Trail") then
                v11.Attachment0 = v9:FindFirstChild("Sword_At_A");
                v11.Attachment1 = v9:FindFirstChild("Sword_At_B");
            end;
        end;

        if u10 ~= nil and u10[1] ~= nil then
            task.delay(5, function() -- Line: 75
                -- upvalues: u10 (copy)
                if u10[1].Name ~= "--" then
                    for _, v in ipairs(u10) do
                        v:Destroy();
                    end;
                end;
            end);
        end;
    else
        local u12 = {};

        for _, child in pairs(v9:GetChildren()) do
            if child.Name == "bladetfftians##asd" then
                child.Name = "--";
                table.insert(u12, child);
            end;
        end;

        if #u12 > 0 then
            task.delay(0.35, function() -- Line: 92
                -- upvalues: u12 (copy)
                if u12 ~= nil then
                    for _, v in pairs(u12) do
                        v.Enabled = false;
                    end;
                end;

                task.wait(1);

                for _, v in ipairs(u12) do
                    v:Destroy();
                end;
            end);
        end;
    end;

    vfxUtility.EnableAll(v9, p8 or p8 == nil);
end;

return function(p13: userdata, p14: any, p15: any) -- Line: 110
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), Assets (copy), vfxUtility (copy), DebrisModule (copy), SwordTrail (copy), TweenService (copy)
    local v16 = p13:FindFirstChild("HumanoidRootPart") or p13.PrimaryPart;

    if v16 == nil then
        return;
    end;

    if p14 ~= "Cancel" and (v16.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local string_format_ret = string.format("%s Whirl_Pool_Effects", p13.Name);
    local v17 = workspace_Debree:FindFirstChild(string_format_ret);

    if p14 == "Startup" then
        local v18 = Assets.Startup:Clone();
        v18.CFrame = v16.CFrame;
        v18.Parent = workspace.Debree;
        vfxUtility.EmitAll(v18);
        DebrisModule:AddItem(v18, 3);
        local v19 = script.Sounds.PS2WBwaterwheelSTART:Clone();
        v19.Parent = v18;
        v19:Play();

        return;
    end;

    if p14 ~= "Cutscene" then
        if p14 == "Cancel" then
            if v17 ~= nil then
                v17.Name = "_";
                v17:SetAttribute("Active", nil);
                DebrisModule:AddItem(v17, 2.5);

                if v17:FindFirstChild("DeadCalmVFX") ~= nil then
                    local PS2WBdeadcalm = v17.DeadCalmVFX.PrimaryPart:FindFirstChild("PS2WBdeadcalm");

                    if PS2WBdeadcalm ~= nil then
                        PS2WBdeadcalm:Destroy();
                    end;

                    for _, descendant in ipairs(v17.DeadCalmVFX:GetDescendants()) do
                        if descendant:IsA("MeshPart") or (descendant:IsA("Part") or (descendant:IsA("Decal") or descendant:IsA("BasePart"))) then
                            descendant.Transparency = 1;
                        end;
                    end;
                end;

                vfxUtility.EnableAll(v17, false);
                vfxUtility.TweenLight(v17, {
                    Time = 0.2,
                    Off = true
                });
            end;

            SwordTrail(p13, false);
        end;

        return;
    end;

    if v17 ~= nil then
        v17:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = string_format_ret;
    Folder.Parent = workspace_Debree;
    Folder:SetAttribute("Active", true);
    DebrisModule:AddItem(Folder, 12);
    SwordTrail(p13);

    if not (Folder:GetAttribute("Active") and Folder:IsDescendantOf(workspace)) then
        return;
    end;

    local v20 = Assets.Startup:Clone();
    v20.CFrame = v16.CFrame;
    v20.Parent = Folder;
    vfxUtility.EmitAll(v20);
    DebrisModule:AddItem(v20, 3);

    if not Folder then
        SwordTrail(p13, false);

        return;
    end;

    local u21 = Assets.DeadCalmVFX:Clone();
    u21:PivotTo(v16.CFrame);
    u21.Parent = Folder;
    vfxUtility.PlaySound(script.Sounds, "PS2WBdeadcalm", u21.PrimaryPart, true);
    DebrisModule:AddItem(u21, 15);
    vfxUtility.TweenLight(u21, {
        Time = 0.3
    });
    u21.Puddle.RootPart.CFrame = u21.Puddle.RootPart.CFrame * CFrame.new(0, 0.25, 0);
    PlayAnimation(u21.Puddle.AnimationController.Animator, "Puddle");
    PlayAnimation(u21.Wave.AnimationController, "Wave");
    vfxUtility.EnableAll(u21.Puddle, true);
    task.delay(7, function() -- Line: 171
        -- upvalues: Folder (copy), vfxUtility (ref), u21 (copy)
        if not (Folder:GetAttribute("Active") and Folder:IsDescendantOf(workspace)) then
            return;
        end;

        vfxUtility.EnableAll(u21.Puddle, false);
        vfxUtility.TweenLight(u21, {
            Time = 0.3,
            Off = true
        });
    end);
    task.wait(4.7);

    if not (Folder:GetAttribute("Active") and Folder:IsDescendantOf(workspace)) then
        return;
    end;

    vfxUtility.EnableAll(u21["Mutli-Slash"], true);
    task.delay(0.15, function() -- Line: 189
        -- upvalues: Folder (copy), vfxUtility (ref), u21 (copy)
        if not (Folder:GetAttribute("Active") and Folder:IsDescendantOf(workspace)) then
            return;
        end;

        vfxUtility.EmitAll(u21.WaveAppear);
        vfxUtility.EnableAll(u21.Wave, true);
    end);
    task.wait(1.1);

    if not (Folder:GetAttribute("Active") and Folder:IsDescendantOf(workspace)) then
        return;
    end;

    vfxUtility.EnableAll(u21["Mutli-Slash"], false);
    task.wait(0.4);

    if not (Folder:GetAttribute("Active") and Folder:IsDescendantOf(workspace)) then
        return;
    end;

    vfxUtility.EmitAll(u21.Impact);
    vfxUtility.EnableAll(u21.Wave, false);
    DebrisModule:AddItem(u21, 2.1);
    task.wait(1.9);

    if not (Folder:GetAttribute("Active") and Folder:IsDescendantOf(workspace)) then
        return;
    end;

    for _, v in { u21.Puddle, u21.Wave } do
        for _, descendant in v:GetDescendants() do
            if descendant:IsA("MeshPart") then
                TweenService:Create(descendant, TweenInfo.new(0.1), {
                    Transparency = 1
                }):Play();
            end;
        end;
    end;

    if Folder then
        Folder.Name = "_";
        Folder:SetAttribute("Active", nil);
        DebrisModule:AddItem(Folder, 2);
    end;

    SwordTrail(p13, false);
end;