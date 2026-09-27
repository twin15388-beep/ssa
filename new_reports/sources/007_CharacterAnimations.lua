-- Decompiled with Potassium's decompiler.

local u1 = {
    Humans = {
        Walk = "rbxassetid://73113600954594",
        Run = "rbxassetid://101268965782907",
        Jump = "rbxassetid://132068249743492",
        Fall = "rbxassetid://112859355208888",
        Climb = "rbxassetid://0",
        Swim = "rbxassetid://0",
        SwimIdle = "rbxassetid://0",
        Idle = {
            Animation1 = "rbxassetid://94815192021041",
            Animation2 = "rbxassetid://0"
        }
    },
    Vampires = {
        Walk = "rbxassetid://73113600954594",
        Run = "rbxassetid://107624694408749",
        Jump = "rbxassetid://132068249743492",
        Fall = "rbxassetid://112859355208888",
        Climb = "rbxassetid://0",
        Swim = "rbxassetid://0",
        SwimIdle = "rbxassetid://0",
        Idle = {
            Animation1 = "rbxassetid://94815192021041",
            Animation2 = "rbxassetid://0"
        }
    },
    Werewolfs = {
        Walk = "rbxassetid://73113600954594",
        Run = "rbxassetid://107624694408749",
        Jump = "rbxassetid://132068249743492",
        Fall = "rbxassetid://112859355208888",
        Climb = "rbxassetid://0",
        Swim = "rbxassetid://0",
        SwimIdle = "rbxassetid://0",
        Idle = {
            Animation1 = "rbxassetid://94815192021041",
            Animation2 = "rbxassetid://0"
        }
    }
};

function u1.GetForTeam(p2) -- Line: 57
    -- upvalues: u1 (copy)
    return u1[p2 == "Cannibal Raised" and "Vampires" or p2] or u1.Humans;
end;

return u1;