-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;

local function isHuman() -- Line: 6
    -- upvalues: LocalPlayer (copy)
    local v1;

    if LocalPlayer.Team == nil then
        v1 = false;
    else
        v1 = LocalPlayer.Team.Name == "Humans";
    end;

    return v1;
end;

local function updatePrompt(p2) -- Line: 10
    -- upvalues: LocalPlayer (copy)
    if p2:IsA("ProximityPrompt") and p2.Name == "GrimoriPactPrompt" then
        local v3;

        if LocalPlayer.Team == nil then
            v3 = false;
        else
            v3 = LocalPlayer.Team.Name == "Humans";
        end;

        p2.Enabled = v3;
    end;
end;

workspace.DescendantAdded:Connect(function(p4) -- Line: 22
    -- upvalues: LocalPlayer (copy)
    if p4:IsA("ProximityPrompt") and (p4.Name == "GrimoriPactPrompt" and (p4:IsA("ProximityPrompt") and p4.Name == "GrimoriPactPrompt")) then
        local v5;

        if LocalPlayer.Team == nil then
            v5 = false;
        else
            v5 = LocalPlayer.Team.Name == "Humans";
        end;

        p4.Enabled = v5;
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 16, Name: updateAllPrompts
    -- upvalues: LocalPlayer (copy)
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Name == "GrimoriPactPrompt" then
            local v6;

            if LocalPlayer.Team == nil then
                v6 = false;
            else
                v6 = LocalPlayer.Team.Name == "Humans";
            end;

            descendant.Enabled = v6;
        end;
    end;
end);

for _, descendant in ipairs(workspace:GetDescendants()) do
    if descendant:IsA("ProximityPrompt") and descendant.Name == "GrimoriPactPrompt" then
        local v7;

        if LocalPlayer.Team == nil then
            v7 = false;
        else
            v7 = LocalPlayer.Team.Name == "Humans";
        end;

        descendant.Enabled = v7;
    end;
end;