-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local Mapa = workspace:WaitForChild("Mapa", 10);

if Mapa then
    Mapa = Mapa:WaitForChild("CIDADE2", 10);
end;

if not Mapa then
    return;
end;

local u1 = {};

local function registerTree(p2) -- Line: 13
    -- upvalues: u1 (copy)
    if not p2:IsA("Model") or p2.Name ~= "(Animated) Realistic tree" then
        return;
    end;

    local Part = p2:FindFirstChild("Part");

    if not (Part and Part:IsA("BasePart")) then
        return;
    end;

    for _, v in ipairs(u1) do
        if v.part == Part then
            return;
        end;
    end;

    local v3 = {
        phase = -99999,
        part = Part,
        baseCFrame = Part.CFrame,
        basePosition = Part.Position - Vector3.new(0, 0.2, 0),
        tall = math.max(Part.Size.Y / 2, 0.01)
    };
    table.insert(u1, v3);
end;

for _, child in ipairs(Mapa:GetChildren()) do
    registerTree(child);
end;

Mapa.ChildAdded:Connect(registerTree);
local u4 = 0;
RunService.RenderStepped:Connect(function(p5) -- Line: 45
    -- upvalues: u4 (ref), LocalPlayer (copy), u1 (copy)
    u4 = u4 + p5;

    if u4 < 0.06666666666666667 then
        return;
    end;

    local v6 = u4;
    u4 = 0;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v7 = LocalPlayer:GetAttribute("LowGraphicsEnabled") == true;

    for i = #u1, 1, -1 do
        local v8 = u1[i];
        local part = v8.part;
        local v9;

        if part.Parent then
            local v10 = not v7;

            if v10 then
                if Character then
                    v10 = (part.Position - Character.Position).Magnitude <= 260;
                else
                    v10 = Character;
                end;
            end;

            if v10 then
                v8.phase = v8.phase + v6 * 1.8;
                local basePosition = v8.basePosition;
                local v11 = basePosition.X + math.sin(v8.phase + basePosition.X / 5) * math.sin(v8.phase / 9) / 3;
                local v12 = basePosition.Z + math.sin(v8.phase + basePosition.Z / 6) * math.sin(v8.phase / 12) / 4;
                part.CFrame = CFrame.new(v11, basePosition.Y, v12) * CFrame.Angles((v12 - basePosition.Z) / v8.tall, 0, (v11 - basePosition.X) / -v8.tall);
                v9 = i;
            elseif part.CFrame == v8.baseCFrame then
                v9 = i;
            else
                part.CFrame = v8.baseCFrame;
                v9 = i;
            end;
        else
            table.remove(u1, i);
            v9 = i;
        end;
    end;
end);