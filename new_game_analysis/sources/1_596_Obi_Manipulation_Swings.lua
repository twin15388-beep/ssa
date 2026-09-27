-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local vfxUtility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("vfxUtility"));
local u1 = {
    [99] = 0.265,
    [1] = 0.135
};
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Combat_Swings = require(script.Parent:WaitForChild("Combat_Swings"));

return function(p2, p3, p4) -- Line: 10
    -- upvalues: Combat_Swings (copy), u1 (copy), RaycastHelper (copy), vfxUtility (copy)
    if p2 == nil then
        return;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if vector.magnitude(HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position) >= 100 then
        return;
    end;

    local v5 = p4 and 99 or p3;

    if v5 == 6 then
        Combat_Swings(p2, v5, p4);

        return;
    end;

    local v6 = script.Swing:Clone();
    v6.Parent = HumanoidRootPart;
    v6:Play();
    game.Debris:AddItem(v6, v6.TimeLength);
    task.wait(u1[v5] or 0.125);
    local v7 = (script:FindFirstChild("Swing" .. v5) or script:FindFirstChild("Swing1")):Clone();
    v7.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2, -3);
    v7.Parent = workspace.Debree;
    game.Debris:AddItem(v7, 3);
    local Attachment = v7.Attachment;
    Attachment.WorldCFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -2);
    local v8 = workspace:Raycast(v7.Position + Vector3.new(0, 2, 0), Vector3.new(0, -10, 0), RaycastHelper.Crater);

    if v8 ~= nil and v8.Instance ~= nil then
        v7.Dust.Color = ColorSequence.new(v8.Instance.Color);

        if v5 == 5 then
            v7.CFrame = CFrame.new(v8.Position + Vector3.new(0, v7.Size.Y / 2, 0)) * v7.CFrame.Rotation * CFrame.Angles(0, -0.3141592653589793, 0);
            local Dust = v7.Dust;
            Dust.Acceleration = Dust.Acceleration + HumanoidRootPart.CFrame.RightVector * -80;
        else
            v7.CFrame = CFrame.new(v8.Position + Vector3.new(0, v7.Size.Y / 2, 0)) * v7.CFrame.Rotation;
        end;

        vfxUtility.EmitAll(v7);
    end;

    vfxUtility.EmitAll(Attachment);
end;