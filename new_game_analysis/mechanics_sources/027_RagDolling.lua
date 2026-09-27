-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local LocalPlayer = game.Players.LocalPlayer;
local Character = LocalPlayer.Character;
local Humanoid = Character:WaitForChild("Humanoid");
Character:WaitForChild("HumanoidRootPart");
local u1 = { "RagDoll", "ragdoll", "Ragdoll", "ragDoll" };
local u2 = { "noragdoll" };

function check_can_ragdoll()
    -- upvalues: Humanoid (copy)
    local v3;

    if Humanoid == nil then
        v3 = false;
    else
        v3 = Humanoid.HumanoidState == Enum.HumanoidStateType.Dead;
    end;

    return not v3;
end;

Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
local u4 = game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(LocalPlayer.Name);
local u5 = { Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.PlatformStanding };
local u6 = false;
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));

function updvalues()
    -- upvalues: u4 (copy), u1 (copy), u2 (copy), Character (copy), Humanoid (copy), u6 (ref), u5 (copy), DebrisModule (copy)
    if u4 ~= nil then
        local v7 = false;

        for _, v in pairs(u1) do
            if u4:FindFirstChild(v) ~= nil then
                v7 = true;
            end;
        end;

        for _, v in pairs(u2) do
            if u4:FindFirstChild(v) ~= nil then
                v7 = false;
            end;
        end;

        local Attribute = Character:GetAttribute("SwimState");

        if typeof(Attribute) == "number" and Attribute > 0 then
            v7 = false;
        end;

        if Humanoid ~= nil and (Humanoid.Health > 0 and Humanoid:GetState() ~= Enum.HumanoidStateType.Dead) then
            if v7 == true then
                if u6 == false then
                    u6 = true;

                    for _, v in pairs(u5) do
                        Humanoid:SetStateEnabled(v, false);
                    end;

                    Humanoid:ChangeState(Enum.HumanoidStateType.Physics);
                end;
            elseif u6 == true then
                u6 = false;
                local BoolValue = Instance.new("BoolValue");
                BoolValue.Name = "novelocity";
                BoolValue.Parent = u4;
                DebrisModule:AddItem(BoolValue, 0.2);

                for _, v in pairs(u5) do
                    Humanoid:SetStateEnabled(v, true);
                end;

                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
            end;
        end;
    end;
end;

updvalues();
Character:GetAttributeChangedSignal("SwimState"):Connect(updvalues);
u4.ChildAdded:Connect(function(p8) -- Line: 82
    -- upvalues: u1 (copy), u2 (copy)
    local v9 = table.find(u1, p8.Name) ~= nil;

    if (table.find(u2, p8.Name) ~= nil and true or v9) == true then
        updvalues();
    end;
end);
u4.ChildRemoved:Connect(function(p10) -- Line: 94
    -- upvalues: u1 (copy), u2 (copy)
    local v11 = table.find(u1, p10.Name) ~= nil;

    if (table.find(u2, p10.Name) ~= nil and true or v11) == true then
        updvalues();
    end;
end);