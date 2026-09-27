-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local CAM = ReplicatedStorage.CAM;
local Cam_Shaker = require(CAM.Client.Modules.Effects.Cam_Shaker);
local Ouwmit = require(CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local DebrisModule = require(CAM.DebrisModule);
local Combat_Swings = require(script.Parent:WaitForChild("Combat_Swings"));
local u1 = { "PS2dreamM1s1", "PS2dreamM1s2", "PS2dreamM1s3", "PS2dreamM1s4", "PS2dreamM1s5", "PS2dreamM1sUPTILT", "PS2dreamM1sDOWNSLAM" };

local function playDreamSound(p2: string?, p3: userdata, p4: string?) -- Line: 54
    -- upvalues: DebrisModule (copy)
    if p3.Parent == nil then
        return;
    end;

    local Sounds = script:FindFirstChild("Sounds");

    if Sounds == nil then
        return;
    end;

    local v5 = p2 ~= nil and Sounds:FindFirstChild(p2) or (p4 ~= nil and Sounds:FindFirstChild(p4) or nil);

    if v5 == nil then
        return;
    end;

    local v6 = v5:Clone();
    v6.Parent = p3;
    v6:Play();
    DebrisModule:AddItem(v6, v6.TimeLength + 1);
end;

local u7 = {
    [5] = true,
    [7] = true
};
local CFrame_new_ret = CFrame.new(-1.16265869, 2.33672333, -4.97831726, -1, 0, 0, 0, 1, 0, 0, 0, -1);
local u8 = { 1.8 };
local TweenInfo_new_ret = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
local TweenInfo_new_ret2 = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
local u9 = {};

local function playTentaSwing(p10: table, p11: number) -- Line: 107
    local v12 = p10.Model:FindFirstChildOfClass("AnimationController");
    local v13;

    if v12 == nil then
        v13 = nil;
    else
        v13 = v12:FindFirstChildOfClass("Animator") or nil;
    end;

    local Tenta_Swings = script:FindFirstChild("Tenta_Swings");

    if v13 == nil or Tenta_Swings == nil then
        return;
    end;

    local v14 = Tenta_Swings:FindFirstChild("Swing_" .. p11) or Tenta_Swings:FindFirstChild("Swing_1");

    if v14 == nil then
        return;
    end;

    if p10.Track ~= nil then
        p10.Track:Stop();
    end;

    local v15 = p10.Tracks[v14.Name];

    if v15 == nil then
        v15 = v13:LoadAnimation(v14);
        p10.Tracks[v14.Name] = v15;
    end;

    v15:Play();
    p10.Track = v15;
end;

local function tentaFade(p16: table, p17: boolean, p18: userdata) -- Line: 126
    -- upvalues: TweenService (copy)
    for _, v in p16.Parts do
        TweenService:Create(v.Part, p18, {
            Transparency = not p17 and 1 or v.Authored
        }):Play();
    end;
end;

local function raiseTenta(u19: userdata, u20: userdata, p21: number) -- Line: 132
    -- upvalues: u9 (copy), tentaFade (copy), TweenInfo_new_ret (copy), playDreamSound (copy), CFrame_new_ret (copy), playTentaSwing (copy), u8 (copy), TweenInfo_new_ret2 (copy)
    local u22 = u9[u19];

    if u22 == nil or u22.Model.Parent == nil then
        local Tenta = script:FindFirstChild("Tenta");

        if Tenta == nil then
            return;
        end;

        local v23 = Tenta:Clone();
        u22 = {
            Token = 0,
            FadingOut = false,
            Model = v23,
            Parts = {},
            Tracks = {}
        };

        for _, descendant in v23:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(u22.Parts, {
                    Part = descendant,
                    Authored = descendant.Transparency
                });
                descendant.Transparency = 1;
            end;
        end;

        v23.Parent = workspace.Debree;
        u9[u19] = u22;
        tentaFade(u22, true, TweenInfo_new_ret);
        playDreamSound("PS2dreamM1sSUMMON", u20);
    elseif u22.FadingOut then
        u22.FadingOut = false;
        tentaFade(u22, true, TweenInfo_new_ret);
    end;

    u22.Model:PivotTo(u20.CFrame * CFrame_new_ret);
    playTentaSwing(u22, p21);
    u22.Token = u22.Token + 1;
    local Token = u22.Token;
    local u24 = u8[p21] or 2;
    local math_max_ret = math.max(u24 - 1, 0);
    task.delay(math_max_ret, function() -- Line: 161
        -- upvalues: u9 (ref), u19 (copy), u22 (ref), Token (copy), tentaFade (ref), TweenInfo_new_ret2 (ref), playDreamSound (ref), u20 (copy), u24 (copy), math_max_ret (copy)
        if u9[u19] ~= u22 or u22.Token ~= Token then
            return;
        end;

        u22.FadingOut = true;
        tentaFade(u22, false, TweenInfo_new_ret2);
        playDreamSound("PS2dreamM1sDESUMMON", u20);
        task.delay(u24 - math_max_ret, function() -- Line: 168
            -- upvalues: u9 (ref), u19 (ref), u22 (ref), Token (ref)
            if u9[u19] == u22 and u22.Token == Token then
                u9[u19] = nil;
                u22.Model:Destroy();
            end;
        end);
    end);
end;

return function(p25: userdata?, p26: number?, p27: boolean?) -- Line: 178
    -- upvalues: Combat_Swings (copy), Cam_Shaker (copy), u7 (copy), raiseTenta (copy), playDreamSound (copy), u1 (copy), vfxUtility (copy), RaycastHelper (copy), Ouwmit (copy)
    if p27 == true and p26 == 1 then
        Combat_Swings(p25, p26, p27);

        return;
    end;

    if p25 == nil or p26 == nil then
        return;
    end;

    local HumanoidRootPart = p25:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    Cam_Shaker(HumanoidRootPart.Position, u7[p26] and "dream_final_shake" or "dream_swing_shake");
    raiseTenta(p25, HumanoidRootPart, p26);
    playDreamSound(u1[p26], HumanoidRootPart, "PS2dreamM1s1");
    local Swings = script:FindFirstChild("Swings");

    if Swings == nil then
        return;
    end;

    local v28 = vfxUtility.cloneAsset(Swings, workspace.Debree, "m" .. p26, HumanoidRootPart.CFrame, 3) or vfxUtility.cloneAsset(Swings, workspace.Debree, "m1", HumanoidRootPart.CFrame, 3);

    if v28 == nil then
        return;
    end;

    local v29 = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 5, 0), Vector3.new(-0, -15, -0), RaycastHelper.Crater);
    local v30 = v29 and vfxUtility.GetDustColorSettings(v29.Instance) or nil;
    Ouwmit.Emit(v28, v30);
end;