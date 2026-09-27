-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local Combat_Swings = require(script.Parent:WaitForChild("Combat_Swings"));
local u1 = { "Sword_At_A", "Sword_At_C", "Sword_At_D" };
local table_find = table.find;

return function(p2: userdata?, p3: number?, p4: boolean?, p5: table?) -- Line: 46
    -- upvalues: Combat_Swings (copy), u1 (copy), table_find (copy), DebrisModule (copy)
    if p2 == nil then
        return;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    local v6 = p2:FindFirstChild("WeaponAura", true) or p2:FindFirstChild("Has_Blade", true);

    if v6 == nil then
        if p5 ~= nil and p5.skipSound ~= true then
            Combat_Swings(p2, p3, p4);
        end;

        return;
    end;

    local Effects = script:FindFirstChild("Effects");

    if Effects == nil then
        return;
    end;

    local v7 = (v6.ClassName ~= "StringValue" or Effects:FindFirstChild(v6.Value) == nil) and "Default" or v6.Value;
    local v8 = Effects:FindFirstChild(v7);

    if v8 == nil then
        return;
    end;

    local v9;

    if p5 == nil then
        v9 = false;
    else
        v9 = p5.skipTrails == true;
    end;

    local v10;

    if p5 == nil then
        v10 = false;
    else
        v10 = p5.skipParticles == true;
    end;

    local v11 = {};

    if p5 == nil then
        local Blade = v6.Parent:FindFirstChild("Blade");

        if Blade == nil then
            return;
        end;

        if Blade:FindFirstChild("Sword_At_A") ~= nil then
            table.insert(v11, Blade);
        end;
    else
        for _, v in p2:QueryDescendants("BasePart") do
            if p5.anchorParts[v.Name] == true and v:FindFirstChild("Sword_At_A", true) ~= nil then
                table.insert(v11, v);
            end;
        end;
    end;

    for _, v in v11 do
        local v12 = v;
        local v13 = {};

        for _, v2 in u1 do
            local v14 = v12:FindFirstChild(v2, true);

            if v14 ~= nil then
                table.insert(v13, v14);
            end;
        end;

        local Attribute = v12:GetAttribute("Slash_Color");
        local v15 = v8:Clone();

        for _, child in v15:GetChildren() do
            if child:IsA("BasePart") or child:IsA("Folder") then
                child:Destroy();
            elseif child:IsA("Trail") and v9 then
                child:Destroy();
            elseif v10 and not child:IsA("Trail") then
                child:Destroy();
            end;
        end;

        local u16 = {};
        local v17 = {};

        for _, descendant in v15:GetDescendants() do
            if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or (descendant:IsA("Trail") or descendant:IsA("PointLight"))) then
                table.insert(u16, descendant);
            end;
        end;

        for _, child in v15:GetChildren() do
            local v18;

            if child.ClassName == "Trail" then
                local string_split_ret = string.split(child.Name, ",");
                v18 = child;

                for _, v2 in v13 do
                    if table_find(string_split_ret, v2.Name) ~= nil then
                        if string_split_ret[1] == v2.Name then
                            v18.Attachment0 = v2;
                        else
                            v18.Attachment1 = v2;
                        end;
                    end;
                end;

                if Attribute ~= nil then
                    v18.Color = ColorSequence.new(Attribute);
                end;
            elseif child:IsA("Attachment") then
                local Attribute2 = child:GetAttribute("Anchor");

                if Attribute2 == nil then
                    v18 = child;
                else
                    local v19 = v12:FindFirstChild(tostring(Attribute2), true);

                    if v19 == nil or not v19:IsA("Bone") then
                        if v19 == nil then
                            v18 = child;
                        else
                            child.Position = v12.CFrame:ToObjectSpace(v19.WorldCFrame).Position;
                            v18 = child;
                        end;
                    else
                        child.Parent = v19;
                        v17[child] = true;
                        v18 = child;
                    end;
                end;
            else
                v18 = child;
            end;

            if not v17[v18] then
                v18.Parent = v12;
            end;

            DebrisModule:AddItem(v18, 0.8);
        end;

        v15:Destroy();

        for _, v2 in u16 do
            v2.Enabled = true;
        end;

        task.delay(0.3, function() -- Line: 159
            -- upvalues: u16 (copy)
            for _, v2 in u16 do
                v2.Enabled = false;
            end;
        end);
    end;

    if p5 ~= nil and p5.skipSound then
        return;
    end;

    local Sounds = script:FindFirstChild("Sounds");

    if Sounds == nil then
        return;
    end;

    local v20;

    if p5 == nil then
        v20 = nil;
    else
        v20 = p5.fallbackSound or nil;
    end;

    if Sounds:FindFirstChild(v7) == nil or not v7 then
        v7 = (v20 == nil or (Sounds:FindFirstChild(v20) == nil or not v20)) and "SwingSharp" or v20;
    end;

    local v21 = Sounds:FindFirstChild(v7);

    if v21 == nil then
        return;
    end;

    if v21:IsA("Folder") then
        local Children = v21:GetChildren();
        v21 = Children[math.random(1, #Children)];
    end;

    local v22 = v21:Clone();
    v22.Parent = HumanoidRootPart;
    v22:Play();
    DebrisModule:AddItem(v22, 1);
end;