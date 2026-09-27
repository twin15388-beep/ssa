-- Decompiled with Potassium's decompiler.

return {
    Do = function(p1: userdata, p2: userdata, p3: table, p4: userdata, p5: userdata?) -- Line: 2, Name: Do
        local Parent = p5.Parent.Parent;
        local HumanoidRootPart = p2.HumanoidRootPart;
        p3.Rack = Parent;
        p3.W = Instance.new("Weld");
        p3.W.Part0 = HumanoidRootPart;
        p3.W.Part1 = Parent.Root;
        p3.W.Parent = Parent.Root;
        p3.Barbell = Parent.Rack.Barbell;
        p3.Barbell.Parent = game.Lighting;
        p3.ActualBarbell = script.Barbell:Clone();
        p3.ActualBarbell.Parent = p2;
        p3.ActualBarbell.Weld.Part0 = p2:FindFirstChild("UpperTorso");
        local v6 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p1.Name);

        if v6 then
            local tooldisabled = v6:FindFirstChild("tooldisabled");

            if tooldisabled == nil then
                tooldisabled = Instance.new("StringValue");
                tooldisabled.Name = "tooldisabled";
                tooldisabled.Parent = v6;
            end;

            tooldisabled.Value = "all";
            p3.ToolDisabled = tooldisabled;
            local BoolValue = Instance.new("BoolValue");
            BoolValue.Name = "iframe";
            BoolValue.Parent = v6;
            p3.IFrame = BoolValue;
        end;

        return true, true;
    end,

    Destroying = function(p7: userdata, p8: userdata, p9: table, p10: userdata) -- Line: 45, Name: Destroying
        if p9.Barbell then
            p9.Barbell.Parent = p9.Rack.Rack;
        end;

        if p9.W ~= nil then
            p9.W:Destroy();
            p9.W = nil;
        end;

        if p9.ActualBarbell then
            p9.ActualBarbell:Destroy();
            p9.ActualBarbell = nil;
        end;

        if p9.ToolDisabled and p9.ToolDisabled.Parent ~= nil then
            p9.ToolDisabled:Destroy();
        end;

        if p9.IFrame and p9.IFrame.Parent ~= nil then
            p9.IFrame:Destroy();
        end;
    end,

    Stop = function(p11: userdata, p12: userdata, p13: table, ...) -- Line: 64, Name: Stop
        return true;
    end
};