-- Decompiled with Potassium's decompiler.

return {
    Id = {},

    Hold = function(p1, p2, p3) -- Line: 2, Name: Hold
        print("hold block for ", p1);
    end,

    UnHold = function(p4, p5, p6) -- Line: 5, Name: UnHold
        print("Unhold for ", p4.Name);
    end,

    Cancel = function(p7, p8, p9) -- Line: 8, Name: Cancel
        print("Cancel block for ", p7.Name);
    end
};