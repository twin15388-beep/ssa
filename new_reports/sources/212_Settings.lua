-- Decompiled with Potassium's decompiler.

return {
    new = function(u1: userdata) -- Line: 10, Name: new
        local u2 = {};
        local Attribute = u1:GetAttribute("WindPower");
        local Attribute2 = u1:GetAttribute("WindSpeed");
        local Attribute3 = u1:GetAttribute("WindDirection");

        if typeof(Attribute) ~= "number" then
            Attribute = nil;
        end;

        u2.WindPower = Attribute;

        if typeof(Attribute2) ~= "number" then
            Attribute2 = nil;
        end;

        u2.WindSpeed = Attribute2;
        local v3;

        if typeof(Attribute3) == "Vector3" then
            v3 = Attribute3.Magnitude <= 0 and Vector3.new(0, 0, 0) or Attribute3.Unit;
        else
            v3 = nil;
        end;

        u2.WindDirection = v3;
        local v4;

        if u1:IsA("BasePart") then
            v4 = u1.PivotOffset;
        else
            v4 = nil;
        end;

        u2.PivotOffset = v4;
        local v5;

        if typeof(u2.PivotOffset) == "CFrame" then
            v5 = u2.PivotOffset:Inverse();
        else
            v5 = nil;
        end;

        u2.PivotOffsetInverse = v5;
        local u7 = u1:GetAttributeChangedSignal("WindPower"):Connect(function() -- Line: 30
            -- upvalues: Attribute (ref), u1 (copy), u2 (copy)
            Attribute = u1:GetAttribute("WindPower");
            local v6;

            if typeof(Attribute) == "number" then
                v6 = Attribute;
            else
                v6 = nil;
            end;

            u2.WindPower = v6;
        end);
        local u9 = u1:GetAttributeChangedSignal("WindSpeed"):Connect(function() -- Line: 35
            -- upvalues: Attribute2 (ref), u1 (copy), u2 (copy)
            Attribute2 = u1:GetAttribute("WindSpeed");
            local v8;

            if typeof(Attribute2) == "number" then
                v8 = Attribute2;
            else
                v8 = nil;
            end;

            u2.WindSpeed = v8;
        end);
        local u11 = u1:GetAttributeChangedSignal("WindDirection"):Connect(function() -- Line: 40
            -- upvalues: Attribute3 (ref), u1 (copy), u2 (copy)
            Attribute3 = u1:GetAttribute("WindDirection");
            local v10;

            if typeof(Attribute3) == "Vector3" then
                v10 = Attribute3.Magnitude <= 0 and Vector3.new(0, 0, 0) or Attribute3.Unit;
            else
                v10 = nil;
            end;

            u2.WindDirection = v10;
        end);
        local u12;

        if u1:IsA("BasePart") then
            u12 = u1:GetPropertyChangedSignal("PivotOffset"):Connect(function() -- Line: 49
                -- upvalues: u2 (copy), u1 (copy)
                u2.PivotOffset = u1.PivotOffset;
                u2.PivotOffsetInverse = u2.PivotOffset:Inverse();
            end);
        else
            u12 = nil;
        end;

        function u2.Destroy(p13) -- Line: 57
            -- upvalues: u7 (copy), u9 (copy), u11 (copy), u12 (ref), u2 (copy)
            u7:Disconnect();
            u9:Disconnect();
            u11:Disconnect();

            if u12 then
                u12:Disconnect();
            end;

            table.clear(u2);
        end;

        return u2;
    end
};