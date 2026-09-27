-- Decompiled with Potassium's decompiler.

return {
    Do = function(p1: userdata, p2: userdata, p3: table, p4: userdata, p5: userdata?) -- Line: 2, Name: Do
        local Parent = p5.Parent.Parent;
        p3.Mat = Parent;
        p3.W = Instance.new("Weld");
        p3.W.Part0 = p2.HumanoidRootPart;
        p3.W.Part1 = Parent.Root;
        p3.W.Parent = Parent.Root;

        return true, true;
    end,

    Destroying = function(p6: userdata, p7: userdata, p8: table, p9: userdata) -- Line: 16, Name: Destroying
        if p8.W ~= nil then
            p8.W:Destroy();
            p8.W = nil;
        end;
    end,

    Stop = function(p10: userdata, p11: userdata, p12: table, ...) -- Line: 22, Name: Stop
        return true;
    end
};