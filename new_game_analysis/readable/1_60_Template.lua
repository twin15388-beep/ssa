-- Decompiled with Potassium's decompiler.

return {
    Id = 0,

    Hold = function(p1) -- Line: 2, Name: Hold
        print("hold block for ", p1);
    end,

    UnHold = function(p2) -- Line: 5, Name: UnHold
        print("Unhold for ", p2.Name);
    end,

    Cancel = function(p3) -- Line: 8, Name: Cancel
        print("Cancel block for ", p3.Name);
    end
};