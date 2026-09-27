-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local script_Parent = require(script.Parent);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = {
    MIZUNOTO_TASK = "Defeat Mizunotos",
    MIZUNOTO_COUNT = 5,
    POWERUP_TIME = 1.6666666666666667
};
local u2 = {
    Meditate = "Meditation",
    ["Push ups"] = "Pushups",
    ["Aim Training"] = "Target Shooting",
    ["Cup Training"] = "Cup Game",
    ["Barbell squats"] = "Squat",
    ["Boulder Push"] = "Boulder Push",
    ["Boulder Split"] = "Boulder Split"
};
u1.Trainings = {
    Arrow = { "Meditate", "Aim Training", "Boulder Push" },
    Reaper = { "Cup Training", "Aim Training", "Boulder Split" },
    Cryokinesis = { "Meditate", "Boulder Split", "Underwater Rocks" },
    Shockwave = { "Push ups", "Barbell squats", "Boulder Push", "Boulder Split" },
    ["Blood Manipulation"] = { "Cup Training", "Push ups", "Aim Training" },
    Tamari = { "Cup Training", "Push ups", "Boulder Split" },
    ["Obi Manipulation"] = { "Barbell squats", "Boulder Push", "Boulder Split" },
    Dream = { "Meditate", "Cup Training", "Aim Training" },
    Pyrokenesis = { "Push ups", "Boulder Push", "Aim Training" }
};

function u1.QuestName(p3: string) -- Line: 66
    return `{p3} Core Training`;
end;

function u1.Key(p4: string) -- Line: 69
    return `I will train my {p4} core`;
end;

function u1.Definitions() -- Line: 73
    -- upvalues: gameSettings (copy), u1 (copy), script_Parent (copy), u2 (copy), BunchaIcons (copy)
    local v5 = gameSettings.UnderwaterRockSpots[game.PlaceId];
    local v6 = {};

    for i, v in u1.Trainings do
        local v7 = i;
        local v8 = {};
        local v9 = nil;
        local v10 = {};

        for _, v2 in v do
            if v2 == "Underwater Rocks" then
                if v5 == nil then
                    warn((`EvilArtCores: this place has no UnderwaterRockSpots, "{v2}" skipped for {v7}`));
                else
                    table.insert(v8, script_Parent.QuestTask(v2, #v5, nil, v9));
                    v10[v2] = {
                        Type = "Pickup",
                        Positions = v5
                    };
                    v9 = v2;
                end;
            else
                local v11 = u2[v2];

                if v11 ~= nil then
                    table.insert(v8, script_Parent.QuestTask(v2, 1, v11, v9));
                    v9 = v2;
                end;

                warn((`EvilArtCores: "{v2}" is not a training station, skipped for {v7}`));
            end;
        end;

        table.insert(v8, script_Parent.QuestTask(u1.MIZUNOTO_TASK, u1.MIZUNOTO_COUNT, "Mizunoto_MistfallHarbor", v9));
        v6[u1.Key(v7)] = {
            OfferNpc = false,
            Category = "Muzan",
            QuestInstance = script_Parent.Quest(u1.QuestName(v7), v8),
            Rewards = {
                Exp = 900,
                Wen = 405,
                Power = v7
            },
            Requirements = {
                Race = { "Demon", "Hybrid" }
            },
            CompletionNotify = {
                Text = "You\'ve proven yourself.",
                Icon = BunchaIcons.MuzanIcon
            },
            TaskSpecs = v10,
            Markers = {
                [u1.MIZUNOTO_TASK] = {
                    Npc = "Mizunoto"
                }
            }
        };
    end;

    return v6;
end;

return u1;