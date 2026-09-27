-- Decompiled with Potassium's decompiler.

require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local LocalPlayer = game.Players.LocalPlayer;
local v1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
local HumanoidRootPart = v1:WaitForChild("HumanoidRootPart");
local Humanoid = v1:WaitForChild("Humanoid");
local Equipped = LocalPlayer:WaitForChild("Items_Config", 999):WaitForChild("Equipped");
local Over_Written_Animation_Player = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Over_Written_Animation_Player"));
local StringValue = Instance.new("StringValue", script);
StringValue.Name = "current_run_anim";
game.ReplicatedStorage.Player_Service:WaitForChild("Values"):WaitForChild(LocalPlayer.Name);
local v2 = game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Data"):WaitForChild(game.Players.LocalPlayer.Name, 9999);
local v3 = v2.slots:FindFirstChild("Slot" .. v2.slotEquipped.Value);
local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));

function upd()
    -- upvalues: Over_Written_Animation_Player (copy), StringValue (copy), Character_info_provider (copy), LocalPlayer (copy), Humanoid (copy)
    task.wait();

    for i, v in pairs(Over_Written_Animation_Player.Curernt_Anims_Playing.Run) do
        v:Stop();
        Over_Written_Animation_Player.Curernt_Anims_Playing.Run[i] = nil;
    end;

    if StringValue ~= nil and StringValue.Value ~= "" then
        local _core_anim = Character_info_provider.get_core_anim(LocalPlayer, "run", true);

        if _core_anim ~= nil then
            if _core_anim == nil then
                return;
            end;

            local v4 = Humanoid.Animator:LoadAnimation(_core_anim);
            v4.Priority = Enum.AnimationPriority.Idle;
            v4:Play();
            table.insert(Over_Written_Animation_Player.Curernt_Anims_Playing.Run, v4);
        end;
    end;
end;

StringValue.Changed:Connect(upd);
v1.ChildAdded:Connect(function(p5) -- Line: 38
    if p5.Name == "Mode" then
        upd();
    end;
end);
Equipped.Changed:Connect(upd);

for _, child in pairs(v3.Inventory.Toolbar:GetChildren()) do
    local u6 = child.Name == "One" and 1 or (child.Name == "Two" and 2 or (child.Name == "Three" and 3 or (child.Name == "Four" and 4 or (child.Name == "Five" and 5 or false))));
    child.Changed:Connect(function() -- Line: 46
        -- upvalues: u6 (copy), Equipped (copy)
        if u6 == Equipped.Value then
            upd();
        end;
    end);
end;

v1.ChildRemoved:Connect(function(p7) -- Line: 52
    if p7.Name == "Mode" then
        upd();
    end;
end);

while true do
    local State = Humanoid:GetState();
    StringValue.Value = (Humanoid == nil or (State == Enum.HumanoidStateType.FallingDown or (HumanoidRootPart == nil or (HumanoidRootPart.Velocity.Magnitude <= 5 or (Humanoid.MoveDirection.Magnitude < 0.1 or (State == Enum.HumanoidStateType.Freefall or State == Enum.HumanoidStateType.Jumping)))))) and "" or (Over_Written_Animation_Player.Get_movement_anim_eq() or "");
    task.wait();
end;