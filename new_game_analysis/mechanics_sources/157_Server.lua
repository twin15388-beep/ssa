-- Decompiled with Potassium's decompiler.

return {
    Do = function(p1: userdata, p2: userdata, p3: table, p4: userdata, p5: userdata?) -- Line: 2, Name: Do
        warn("Start server");

        return true, false;
    end,

    StateChanged = function(p6: userdata, p7: userdata, p8: table, ...) -- Line: 11, Name: StateChanged
        warn("State changed server");
    end,

    Destroying = function(p9: userdata, p10: userdata, p11: table, p12: userdata) -- Line: 18, Name: Destroying
        warn("Destroying server");
    end,

    Stop = function(p13: userdata, p14: userdata, p15: table, ...) -- Line: 21, Name: Stop
        warn("Stop server");

        return true;
    end
};