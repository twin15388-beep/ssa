-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local Efeitos = ReplicatedStorage:WaitForChild("Efeitos");
local BloodImpactEvent = Efeitos:WaitForChild("BloodImpactEvent");
local BloodImpactVisuals = Efeitos:WaitForChild("BloodImpactVisuals");
local Random_new_ret = Random.new();
local Folder = Instance.new("Folder");
Folder.Name = "BloodImpactFX";
Folder.Parent = workspace;
local u1 = {
    Fists = 8,
    DrinkBlood = 18,
    HeartRipping = 24
};
local u2 = 0;

local function makeSplat(p3, p4) -- Line: 20
    -- upvalues: u2 (ref), Random_new_ret (copy), BloodImpactVisuals (copy), Folder (copy), TweenService (copy)
    if u2 >= 120 then
        return;
    end;

    local v5 = BloodImpactVisuals:FindFirstChild("blood" .. tostring(Random_new_ret:NextInteger(1, 3)));

    if not (v5 and v5:IsA("BasePart")) then
        return;
    end;

    local u6 = v5:Clone();
    local v7 = Random_new_ret:NextNumber(0.7, 1.45);
    u6.Anchored = true;
    u6.CanCollide = false;
    u6.CanTouch = false;
    u6.CanQuery = false;
    u6.CastShadow = false;
    u6.Size = Vector3.new(0.05, 0.05, 0.05);
    local CFrame_lookAt_ret = CFrame.lookAt(p3 + p4 * 0.035, p3 + p4);
    local CFrame_Angles = CFrame.Angles;
    local v8 = Random_new_ret:NextInteger(0, 359);
    u6.CFrame = CFrame_lookAt_ret * CFrame_Angles(1.5707963267948966, math.rad(v8), 0);
    u6.Parent = Folder;
    u2 = u2 + 1;
    TweenService:Create(u6, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(v7, 0.08, v7 * 0.55)
    }):Play();
    task.delay(8, function() -- Line: 44
        -- upvalues: u6 (copy), u2 (ref), TweenService (ref)
        if not u6.Parent then
            u2 = math.max(0, u2 - 1);

            return;
        end;

        for _, descendant in ipairs(u6:GetDescendants()) do
            if descendant:IsA("Decal") then
                TweenService:Create(descendant, TweenInfo.new(0.6), {
                    Transparency = 1
                }):Play();
            end;
        end;

        task.delay(0.65, function() -- Line: 54
            -- upvalues: u6 (ref), u2 (ref)
            u6:Destroy();
            u2 = math.max(0, u2 - 1);
        end);
    end);
end;

local function splash(p9, p10) -- Line: 61
    -- upvalues: u2 (ref), Random_new_ret (copy), Folder (copy), LocalPlayer (copy), BloodImpactVisuals (copy), TweenService (copy), Debris (copy), makeSplat (copy)
    if u2 >= 120 then
        return;
    end;

    local v11 = Random_new_ret:NextNumber(-3.2, 3.2);
    local v12 = Random_new_ret:NextNumber(-3.2, 3.2);
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    local v13 = { Folder };

    if p10 then
        table.insert(v13, p10);
    end;

    if LocalPlayer.Character then
        table.insert(v13, LocalPlayer.Character);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v13;
    local u14 = workspace:Raycast(p9 + Vector3.new(v11, 2, v12), Vector3.new(0, -18, 0), RaycastParams_new_ret);

    if not u14 or u14.Normal.Y < 0.35 then
        return;
    end;

    local bloodbullet = BloodImpactVisuals:FindFirstChild("bloodbullet");

    if not (bloodbullet and bloodbullet:IsA("BasePart")) then
        return;
    end;

    local v15 = bloodbullet:Clone();
    v15.Anchored = true;
    v15.CanCollide = false;
    v15.CanTouch = false;
    v15.CanQuery = false;
    local CFrame_new = CFrame.new;
    local v16 = Random_new_ret:NextNumber(-0.3, 0.3);
    local v17 = Random_new_ret:NextNumber(0, 0.4);
    v15.CFrame = CFrame_new(p9 + Vector3.new(v16, v17, Random_new_ret:NextNumber(-0.3, 0.3)));
    v15.Parent = Folder;
    local v18 = Random_new_ret:NextNumber(0.18, 0.3);
    TweenService:Create(v15, TweenInfo.new(v18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        CFrame = CFrame.new(u14.Position + u14.Normal * 0.1)
    }):Play();
    Debris:AddItem(v15, v18 + 0.15);
    task.delay(v18, function() -- Line: 95
        -- upvalues: makeSplat (ref), u14 (copy)
        makeSplat(u14.Position, u14.Normal);
    end);
end;

BloodImpactEvent.OnClientEvent:Connect(function(u19, p20, u21) -- Line: 100
    -- upvalues: u1 (copy), LocalPlayer (copy), splash (copy)
    if typeof(u19) ~= "Vector3" then
        return;
    end;

    local v22 = u1[p20];

    if not v22 then
        return;
    end;

    local v23 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not v23 or (v23.Position - u19).Magnitude > 130 then
        return;
    end;

    for i = 1, v22 do
        task.delay((i - 1) * 0.012, function() -- Line: 107
            -- upvalues: splash (ref), u19 (copy), u21 (copy)
            splash(u19, u21);
        end);
        local _ = i;
    end;
end);