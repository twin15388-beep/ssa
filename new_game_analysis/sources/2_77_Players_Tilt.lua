-- Decompiled with Potassium's decompiler.

game:GetService("CollectionService");
game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local LocalPlayer = game.Players.LocalPlayer;
local math_clamp = math.clamp;
local _ = math.rad;
local u1 = {};
local u2 = {
    AxeAndMace = true
};

local function getdefaultc1(p3) -- Line: 34
    -- upvalues: u1 (copy)
    if not u1[p3] then
        u1[p3] = p3.C1;
    end;

    return u1[p3];
end;

local function getangle(p4, p5) -- Line: 19
    -- upvalues: Items (copy), Character_info_provider (copy), LocalPlayer (copy), u2 (copy), math_clamp (copy)
    local v6 = Items[Character_info_provider.EquippedTool];
    local v7;

    if v6 == nil then
        v7 = nil;
    else
        v7 = v6.Category;
    end;

    if LocalPlayer:FindFirstChild("Transforming_to_mode") == nil and (p4 and (p4.Parent ~= nil and (u2[v7] == nil and (p5 and (p5.Health > 0 and (p5.MoveDirection.Magnitude > 0.1 and p4.Velocity.Magnitude > 0.1)))))) then
        local v8 = p4.Velocity * Vector3.new(1, 0, 1);

        if v8.Magnitude > 2 then
            return math_clamp(v8.Unit:Dot(p4.CFrame.rightVector), -0.11, 0.11);
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

                local v9 = u1[Root];

                if not u1[Waist] then
                    u1[Waist] = Waist.C1;
                end;

                local v10 = u1[Waist];
                local v11 = getangle(HumanoidRootPart, Humanoid);
                local CFrame_Angles_ret = CFrame.Angles(0, 0, v11);
                Root.C1 = Root.C1:Lerp(v9 * CFrame_Angles_ret, 0.11);
                Waist.C1 = Waist.C1:Lerp(v10 * CFrame_Angles_ret, 0.11);
            end;
        end;
    end;

    task.wait();
end;