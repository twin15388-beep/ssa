-- Decompiled with Potassium's decompiler.

local ClientEffects = game.ReplicatedStorage:WaitForChild("Communication"):WaitForChild("CnC"):WaitForChild("ClientEffects");
local LocalPlayer = game.Players.LocalPlayer;
local u1 = game.ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Values"):WaitForChild(LocalPlayer.Name);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };

function upd_char(u2)
    -- upvalues: u1 (copy), LocalPlayer (copy), RaycastParams_new_ret (copy), ClientEffects (copy)
    if u2 ~= nil then
        local Humanoid = u2:WaitForChild("Humanoid");
        local Position = u2:WaitForChild("HumanoidRootPart").Position;
        local v3 = nil;

        while u2 ~= nil and (u2:IsDescendantOf(workspace) == true and u2:FindFirstChild("HumanoidRootPart")) do
            local Position2 = u2.HumanoidRootPart.Position;
            local v4 = Position2 - Position;
            local State = Humanoid:GetState();
            local v5 = v4.Magnitude > 2.25 and (u1:FindFirstChild("AIRDASHASD123") == nil and (u1:FindFirstChild("NOMouvementlines") == nil and (workspace.Debree:FindFirstChild(LocalPlayer.Name .. LocalPlayer.UserId .. "\'s gamatundeasd12-12") == nil and (State ~= Enum.HumanoidStateType.Dead and State ~= Enum.HumanoidStateType.Physics))));

            if v5 == true then
                local v6 = workspace:Raycast(u2.HumanoidRootPart.Position, v4.Unit * 6, RaycastParams_new_ret);

                if v6 ~= nil and v6.Instance ~= nil then
                    v5 = false;
                end;
            end;

            if v5 == v3 then
                v5 = v3;
            elseif v5 == true then
                task.spawn(function() -- Line: 35
                    -- upvalues: ClientEffects (ref), u2 (copy)
                    ClientEffects:Fire("Mouvement_Trail_Thing", u2.HumanoidRootPart, "preset1", "Front", true);
                end);
            else
                task.spawn(function() -- Line: 39
                    -- upvalues: ClientEffects (ref), u2 (copy)
                    ClientEffects:Fire("Mouvement_Trail_Thing", u2.HumanoidRootPart, "preset1", "Front", false);
                end);
            end;

            wait();
            v3 = v5;
            Position = Position2;
        end;
    end;
end;

upd_char(LocalPlayer.Character);