-- Decompiled with Potassium's decompiler.

game:GetService("CollectionService");
game:GetService("RunService");
local LocalPlayer = game.Players.LocalPlayer;
local math_clamp = math.clamp;
local _ = math.rad;
local u1 = {};

local function getdefaultc1(p2) -- Line: 20
    -- upvalues: u1 (copy)
    if not u1[p2] then
        u1[p2] = p2.C1;
    end;

    return u1[p2];
end;

local function getangle(p3, p4) -- Line: 10
    -- upvalues: LocalPlayer (copy), math_clamp (copy)
    if LocalPlayer:FindFirstChild("Transforming_to_mode") == nil and (p3 and (p3.Parent and (not p3.Parent:FindFirstChild(p3.Parent.Name .. "\'s Wagon") and (p4 and (p4.Health > 0 and (p4.MoveDirection.Magnitude > 0.1 and p3.Velocity.Magnitude > 0.1)))))) then
        local v5 = p3.Velocity * Vector3.new(1, 0, 1);

        if v5.Magnitude > 2 then
            return math_clamp(v5.Unit:Dot(p3.CFrame.rightVector), -0.11, 0.11);
        end;
    end;

    return 0;
end;

while true do
    local Character = LocalPlayer.Character;

    if Character and Character.Parent == workspace.Humanoids then
        local Humanoid = Character:FindFirstChild("Humanoid");
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        local LowerTorso = Character:FindFirstChild("LowerTorso");
        local UpperTorso = Character:FindFirstChild("UpperTorso");

        if Humanoid and (HumanoidRootPart and (LowerTorso and UpperTorso)) then
            local Root = LowerTorso:FindFirstChild("Root");
            local Waist = UpperTorso:FindFirstChild("Waist");

            if Root and Waist then
                if not u1[Root] then
                    u1[Root] = Root.C1;
                end;

                local v6 = u1[Root];

                if not u1[Waist] then
                    u1[Waist] = Waist.C1;
                end;

                local v7 = u1[Waist];
                local v8 = getangle(HumanoidRootPart, Humanoid);
                local CFrame_Angles_ret = CFrame.Angles(0, 0, v8);
                Root.C1 = Root.C1:Lerp(v6 * CFrame_Angles_ret, 0.11);
                Waist.C1 = Waist.C1:Lerp(v7 * CFrame_Angles_ret, 0.11);
            end;
        end;
    end;

    task.wait();
end;