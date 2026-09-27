-- Decompiled with Potassium's decompiler.

return {
    Prefix = ":",
    Toggle = {
        KeycodeReps = 2,
        Keycode = Enum.KeyCode.Semicolon
    },
    Clearances = {
        Default = game:GetService("RunService"):IsStudio() and 6 or nil,
        Group = {
            Id = 12851171,
            Ranks = {
                [255] = 7,
                [254] = 7,
                [6] = 7,
                [5] = 0.75
            }
        },
        PlaceIds = {
            [17047024836] = {
                Group = {
                    Id = 12851171,
                    Ranks = {
                        [4] = 0.5
                    }
                }
            },
            [130395143593224] = {
                Group = {
                    Id = 12851171,
                    Ranks = {
                        [4] = 0.5
                    }
                }
            }
        }
    }
};