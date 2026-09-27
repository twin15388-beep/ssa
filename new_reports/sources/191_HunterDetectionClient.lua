-- Decompiled with Potassium's decompiler.

local u1 = {};

local function clearHunter(p2) -- Line: 10
    -- upvalues: u1 (copy)
    local v3 = u1[p2];

    if v3 then
        if v3.highlight then
            v3.highlight:Destroy();
        end;

        if v3.alert then
            v3.alert:Destroy();
        end;

        u1[p2] = nil;
    end;
end;

local function showDetected(u4) -- Line: 23
    -- upvalues: u1 (copy)
    if typeof(u4) ~= "Instance" or not (u4:IsA("Model") and u4.Parent) then
        return;
    end;

    local v5 = u1[u4];

    if v5 then
        if v5.highlight then
            v5.highlight:Destroy();
        end;

        if v5.alert then
            v5.alert:Destroy();
        end;

        u1[u4] = nil;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "HunterDetectedOutline_Local";
    Highlight.Adornee = u4;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.fromRGB(255, 35, 35);
    Highlight.OutlineTransparency = 0;
    Highlight.Parent = u4;
    local Head = u4:FindFirstChild("Head");
    local u6;

    if Head and Head:IsA("BasePart") then
        u6 = Instance.new("BillboardGui");
        u6.Name = "HunterDetectedAlert_Local";
        u6.Adornee = Head;
        u6.Size = UDim2.fromOffset(52, 52);
        u6.StudsOffsetWorldSpace = Vector3.new(0, 3.65, 0);
        u6.AlwaysOnTop = true;
        u6.LightInfluence = 0;
        u6.MaxDistance = 90;
        u6.Parent = Head;
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Size = UDim2.fromScale(1, 1);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.Text = "!";
        TextLabel.TextColor3 = Color3.fromRGB(255, 35, 35);
        TextLabel.TextStrokeTransparency = 1;
        TextLabel.Font = Enum.Font.Ubuntu;
        TextLabel.TextScaled = true;
        TextLabel.Parent = u6;
    else
        u6 = nil;
    end;

    u1[u4] = {
        highlight = Highlight,
        alert = u6
    };

    if u6 then
        task.delay(1.1, function() -- Line: 69
            -- upvalues: u1 (ref), u4 (copy), u6 (ref)
            local v7 = u1[u4];

            if v7 and (v7.alert == u6 and u6.Parent) then
                u6:Destroy();
                v7.alert = nil;
            end;
        end);
    end;

    u4.AncestryChanged:Connect(function(p8, p9) -- Line: 78
        -- upvalues: u4 (copy), u1 (ref)
        if not p9 then
            local v10 = u4;
            local v11 = u1[v10];

            if v11 then
                if v11.highlight then
                    v11.highlight:Destroy();
                end;

                if v11.alert then
                    v11.alert:Destroy();
                end;

                u1[v10] = nil;
            end;
        end;
    end);
end;

game:GetService("ReplicatedStorage"):WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("HunterDetectionRemote").OnClientEvent:Connect(function(p12, p13) -- Line: 85
    -- upvalues: showDetected (copy), u1 (copy)
    if p12 == "Detected" then
        showDetected(p13);

        return;
    end;

    local v14 = p12 == "Lost" and u1[p13];

    if v14 then
        if v14.highlight then
            v14.highlight:Destroy();
        end;

        if v14.alert then
            v14.alert:Destroy();
        end;

        u1[p13] = nil;
    end;
end);