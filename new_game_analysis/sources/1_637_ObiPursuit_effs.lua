-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local workspace_Debree = workspace.Debree;
local Assets = script:FindFirstChild("Assets");
local Sounds = script:FindFirstChild("Sounds");
local CAM = ReplicatedStorage.CAM;
local Modules = CAM.Client.Modules;
local DebrisModule = require(CAM.DebrisModule);
local Cam_Shaker = require(Modules.Effects.Cam_Shaker);
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

function BlurEffect(p1)
    -- upvalues: DebrisModule (copy)
    local BlurEffect2 = Instance.new("BlurEffect");
    local game_Lighting = game.Lighting;
    BlurEffect2.Size = 5;
    BlurEffect2.Parent = game_Lighting;
    DebrisModule:AddItem(BlurEffect2, p1 or 0.08333333333333333);
end;

local function PlaySlash(u2, u3, p4) -- Line: 44
    local u5 = p4 or 60;
    task.spawn(function() -- Line: 46
    end);
    task.spawn(function() -- Line: 49
        -- upvalues: u3 (copy), u2 (copy), u5 (ref)
        for _, v in u3 do
            u2.Decal.Texture = v;
            task.wait(1 / u5);
        end;
    end);
end;

local function PlayFlipbook(u6, u7, p8) -- Line: 57
    local u9 = p8 or 60;
    task.spawn(function() -- Line: 60
        -- upvalues: u7 (copy), u6 (copy), u9 (ref)
        for _, v in u7 do
            u6.Image = v;
            task.wait(1 / u9);
        end;
    end);
end;

local TweenInfo_new_ret = TweenInfo.new(0.25);

return function(p10: userdata, p11: string, p12: any) -- Line: 70
    -- upvalues: workspace_CurrentCamera (copy), workspace_Debree (copy), vfxUtility (copy), Sounds (copy), DebrisModule (copy), Assets (copy), Cam_Shaker (copy), RaycastHelper (copy), Ouwmit (copy), TweenService (copy), TweenInfo_new_ret (copy)
    if p10 == nil then
        return;
    end;

    local HumanoidRootPart = p10:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if not table.find({ "Cancel", "Release" }, p11) and (HumanoidRootPart.Position - workspace_CurrentCamera.CFrame.Position).Magnitude > 250 then
        return;
    end;

    local string_format_ret = string.format("%s Obi_Pursuit_Effects", p10.Name);
    local v13 = p10:FindFirstChild("Accessories") and p10:FindFirstChild("Accessories"):FindFirstChild("Ribbons");
    local u14 = workspace_Debree:FindFirstChild(string_format_ret);

    if p11 == "Start" then
        vfxUtility.PlaySound(Sounds, "PS2FleshManiFurtherSliceSTART", HumanoidRootPart, true);

        if u14 ~= nil then
            u14:Destroy();
        end;

        u14 = Instance.new("Folder");
        u14.Name = string_format_ret;
        u14.Parent = workspace.Debree;
        DebrisModule:AddItem(u14, 12);
        u14:SetAttribute("Active", true);
        local v15 = Assets.SkillInitialFX:Clone();
        v15.Parent = u14;
        v15.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -1, 0);
        vfxUtility.EmitAll(v15:GetDescendants());
        DebrisModule:AddItem(v15, 6);
        Cam_Shaker(HumanoidRootPart.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.02,
            SustainTime = 0.5,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(1, 1, 1)
        });
        task.wait(0.2);

        if not (u14:GetAttribute("Active") and u14:IsDescendantOf(workspace)) then
            return;
        end;

        Cam_Shaker(HumanoidRootPart.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.06,
            SustainTime = 0.5,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(1, 1, 1)
        });
        local v16 = Assets.Dash:Clone();
        v16.Parent = u14;
        v16:PivotTo(HumanoidRootPart.CFrame);
        DebrisModule:AddItem(v16, 3);
        local v17 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v18 = v17 and vfxUtility.GetDustColorSettings(v17.Instance) or nil;
        Ouwmit.Emit(v16, v18);
        task.wait(0.1);

        if not (u14:GetAttribute("Active") and u14:IsDescendantOf(workspace)) then
            return;
        end;

        vfxUtility.PlaySound(Sounds, "PS2FleshManiFurtherSliceDARTDASH", v16.HumanoidRootPart, true);

        if v13 then
            local RootPart = v13.RootPart;
            local v19 = RootPart:FindFirstChild("WrapA.R.009", true);
            local v20 = RootPart:FindFirstChild("WrapA.L.009", true);
            local v21 = Assets.Part.regLeft:Clone();
            v21.Parent = v19;
            DebrisModule:AddItem(v21, 2);
            local v22 = Assets.Part.regRight:Clone();
            v22.Parent = v20;
            DebrisModule:AddItem(v22, 2);
        end;

        local v23 = Assets.Dust:Clone();
        v23.Parent = u14;
        v23.CFrame = HumanoidRootPart.CFrame * CFrame.new(2.35772705078125, -2.5828161239624023, 2.021240234375);
        vfxUtility.EnableAll(v23, true);
        DebrisModule:AddItem(v23, 2);
        local u24 = vfxUtility.PlaySound(Sounds, "PS2FleshManiFurtherSliceDRAGloop", HumanoidRootPart, false);
        local u25 = nil;
        u25 = u14.AttributeChanged:Connect(function(p26: string) -- Line: 174
            -- upvalues: u14 (ref), u25 (ref), TweenService (ref), u24 (copy), TweenInfo_new_ret (ref), DebrisModule (ref)
            if u14:GetAttribute("Active") then
                return;
            end;

            u25:Disconnect();
            TweenService:Create(u24, TweenInfo_new_ret, {
                Volume = 0
            }):Play();
            DebrisModule:AddItem(u24, TweenInfo_new_ret.Time);
        end);
        local Weld = Instance.new("Weld");
        Weld.Part0 = HumanoidRootPart;
        Weld.Part1 = v23;
        Weld.Parent = HumanoidRootPart;
        Weld.C0 = CFrame.new(2.35772705078125, -2.5828161239624023, 2.021240234375);
        local u27 = Assets.Hrp:Clone();
        u27.Parent = u14;
        u27.CFrame = HumanoidRootPart.CFrame * CFrame.new(0.51, -1.39, 4.63);
        vfxUtility.EnableAll(u27, true);
        DebrisModule:AddItem(u27, 2);
        local Weld2 = Instance.new("Weld");
        Weld2.Part0 = HumanoidRootPart;
        Weld2.Part1 = u27;
        Weld2.Parent = HumanoidRootPart;
        Weld2.C0 = CFrame.new(0.51, -1.39, 4.63);
        task.delay(0.5, function() -- Line: 203
            -- upvalues: vfxUtility (ref), u27 (copy)
            vfxUtility.EnableAll(u27, false);
        end);
    elseif u14 == nil then
        return;
    end;

    if p11 == "Release" then
        local v28 = workspace.Debree:FindFirstChild(string_format_ret);

        if not v28 then
            return;
        end;

        v28:SetAttribute("Active", false);
        local Hrp = v28:FindFirstChild("Hrp");

        if Hrp then
            vfxUtility.EnableAll(Hrp, false);
            DebrisModule:AddItem(Hrp, 1.5);
        end;

        local Dust = v28:FindFirstChild("Dust");

        if Dust then
            vfxUtility.EnableAll(Dust, false);
            DebrisModule:AddItem(Dust, 1.5);
        end;

        vfxUtility.EnableAll(v13, false);
    elseif p11 == "Slash" then
        vfxUtility.PlaySound(Sounds, "PS2FleshManiFurtherSliceSLASH", HumanoidRootPart, true);
        vfxUtility.EnableAll(v13, false);
        local v29 = Assets.MewSlash:Clone();
        v29.Parent = u14;
        v29:PivotTo(HumanoidRootPart.CFrame);
        DebrisModule:AddItem(v29, 3);
        local v30 = workspace:Raycast(HumanoidRootPart.CFrame.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
        local v31 = v30 and vfxUtility.GetDustColorSettings(v30.Instance) or nil;
        Ouwmit.Emit(v29, v31);
        Cam_Shaker(HumanoidRootPart.Position, {
            FadeInTime = 0,
            Frequency = 0.1,
            Amplitude = 0.06,
            SustainTime = 0.5,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(1, 1, 1)
        });
    elseif p11 == "Hit" then
        vfxUtility.EnableAll(v13, false);
        local v32 = Assets.Hitfx:Clone();
        v32.Parent = u14;
        v32:PivotTo(p12);
        vfxUtility.EmitAll(v32:GetDescendants());
        DebrisModule:AddItem(v32, 2);
        Cam_Shaker(v32.Position, {
            FadeInTime = 0,
            Frequency = 0.05,
            Amplitude = 0.1,
            SustainTime = 0.1,
            FadeOutTime = 0.2,
            RotationInfluence = Vector3.new(0.25, 0.25, 0.25),
            PositionInfluence = Vector3.new(3.5, 3.5, 3.5)
        });
    elseif p11 == "Cancel" then
        vfxUtility.EnableAll(v13, false);

        if u14 then
            u14.Name = "_";
            u14:SetAttribute("Active", false);
            vfxUtility.EnableAll(u14, false);
            DebrisModule:AddItem(u14, 2);
        end;
    end;
end;