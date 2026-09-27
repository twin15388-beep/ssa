-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
require(ReplicatedStorage.CAM.Global.Types.CraftingTypes);
local v1 = {
    Points = 90000,
    RefineKept = 1,
    Materials = { {
            name = "Mythic Refinement Ore",
            amount = 10
        }, {
            name = "Metal Scraps",
            amount = 500
        }, {
            name = "Silk Thread",
            amount = 300
        } }
};
local u2 = {};

for i, v in {
    volcanic_katana = { "Flame Katana", "Volcanic Katana" },
    tornadic_katana = { "Wind Katana", "Tornadic Katana" },
    tidal_katana = { "Water Katana", "Tidal Katana" },
    thundercloud_katana = { "Thunder Katana", "Thundercloud Katana" },
    serpentine_katana = { "Serpent Katana", "Serpentine Katana" },
    butterfly_katana = { "Insect Katana", "Butterfly Katana" },
    reverb_cleavers = { "Sound Katanas", "Reverb Cleavers" },
    seismic_axe_and_mace = { "Axe and Mace", "Seismic Axe and Mace" },
    damascus_bladed_wagasa = { "Bladed Wagasa", "Damascus Bladed Wagasa" },
    damascus_claws = { "Claws", "Damascus Claws" },
    damascus_gauntlet = { "Gauntlet", "Damascus Gauntlet" },
    damascus_scythe = { "Scythe", "Damascus Scythe" },
    damascus_shotgun = { "Shotgun", "Damascus Shotgun" },
    damascus_sickles = { "Sickles", "Damascus Sickles" },
    damascus_sickles_blood = { "Blood Sickles", "Damascus Sickles" },
    damascus_spear = { "Spear", "Damascus Spear" },
    damascus_tanto = { "Tanto", "Damascus Tanto" },
    damascus_war_fans = { "War Fans", "Damascus War Fans" }
} do
    local v3 = v;
    local v4 = {};

    for _, v2 in v1.Materials do
        table.insert(v4, {
            name = v2.name,
            amount = v2.amount
        });
    end;

    u2[i] = {
        station = "Ouwigahara",
        amount = 1,
        result = v3[2],
        price = {
            RunPoints = v1.Points
        },
        required = {
            {
                amount = 1,
                name = v3[1]
            }
        },
        additionalMaterials = v4,
        refineKept = v1.RefineKept
    };
end;

u2.enryu_katana = {
    station = "Hidden Mist",
    result = "Enryu Katana",
    amount = 1,
    price = {},
    required = { {
            name = "Crude Iron Ingot",
            amount = 1
        } },
    additionalMaterials = {}
};
u2.shinkage_katana = {
    station = "Hidden Mist",
    result = "Shinkage Katana",
    amount = 1,
    price = {},
    required = { {
            name = "Crude Iron Ingot",
            amount = 1
        } },
    additionalMaterials = {}
};
u2.tengoku_katana = {
    station = "Hidden Mist",
    result = "Tengoku Katana",
    amount = 1,
    price = {},
    required = { {
            name = "Crude Iron Ingot",
            amount = 1
        } },
    additionalMaterials = {}
};
u2.shotgun = {
    station = "Ouwland",
    result = "Shotgun",
    amount = 1,
    price = {
        Wen = 25000
    },
    required = { {
            name = "Shotgun Schematic",
            amount = 1
        } },
    additionalMaterials = { {
            name = "Silk Thread",
            amount = 200
        }, {
            name = "Metal Scraps",
            amount = 100
        } }
};
local u5 = {
    Wen = 1000000,
    MaterialEach = 5,
    Generic = {
        ["Metal Scraps"] = 1000,
        ["Silk Thread"] = 1000
    },
    Weapons = {
        ["Firstlight Katana"] = { "Volcanic Katana", "Tornadic Katana", "Tidal Katana", "Thundercloud Katana" },
        ["Firstlight Insect Katana"] = { "Butterfly Katana" },
        ["Firstlight Sound Cleavers"] = { "Reverb Cleavers" },
        ["Firstlight Bladed Wagasa"] = { "Damascus Bladed Wagasa" },
        ["Firstlight Spear"] = { "Damascus Spear" },
        ["Firstlight Tanto"] = { "Damascus Tanto" },
        ["Firstlight War Fans"] = { "Damascus War Fans" },
        ["Nightfall Katana"] = { "Volcanic Katana", "Tornadic Katana", "Tidal Katana", "Thundercloud Katana" },
        ["Nightfall Serpent Katana"] = { "Serpentine Katana" },
        ["Nightfall Axe and Mace"] = { "Seismic Axe and Mace" },
        ["Nightfall Claws"] = { "Damascus Claws" },
        ["Nightfall Gauntlet"] = { "Damascus Gauntlet" },
        ["Nightfall Scythe"] = { "Damascus Scythe" },
        ["Nightfall Sickles"] = { "Damascus Sickles" }
    },
    Kinds = { "Metal", "Cloth", "Third" },
    Wearables = {
        Firstlight = {
            Materials = {
                Metal = "Firstlight Forged Ingot",
                Cloth = "Firstlight Weaver\'s Silk",
                Third = "Firstlight Star Ore"
            },
            Pieces = {
                ["Firstlight Haori"] = "Armor",
                ["Firstlight Mask"] = "Accessory",
                ["Firstlight Lantern"] = "Accessory"
            }
        },
        Nightfall = {
            Materials = {
                Metal = "Nightfall Forged Ingot",
                Cloth = "Nightfall Weaver\'s Cloth",
                Third = "Nightfall Reinforced Plating"
            },
            Pieces = {
                ["Nightfall Cape"] = "Accessory",
                ["Nightfall Mask"] = "Accessory",
                ["Nightfall Top"] = "Armor",
                ["Nightfall Bottom"] = "Armor"
            }
        }
    },
    Tower = {
        Pieces = { "Firstlight Top", "Firstlight Bottom" },
        Price = {
            RunPoints = 500000,
            Wen = 500000
        },
        Generic = {
            ["Metal Scraps"] = 750,
            ["Silk Thread"] = 750
        }
    },
    TierUps = {
        [2] = {
            Wen = 750000,
            Generic = {
                ["Metal Scraps"] = 750,
                ["Silk Thread"] = 750
            },
            Materials = {
                Weapon = {
                    Metal = 6,
                    Third = 6
                },
                Armor = {
                    Metal = 6,
                    Cloth = 6
                },
                Accessory = {
                    Third = 4,
                    Cloth = 3
                }
            }
        },
        [3] = {
            Wen = 1500000,
            Generic = {},
            Materials = {
                Weapon = {
                    Metal = 12,
                    Third = 12
                },
                Armor = {
                    Metal = 12,
                    Cloth = 12
                },
                Accessory = {
                    Third = 6,
                    Cloth = 6
                }
            }
        }
    },
    Fished = {
        ["Lost Shotgun"] = {
            [2] = 2,
            [3] = 6
        }
    }
};

local function seriesId(p6: string) -- Line: 240
    return string.lower((string.gsub(p6, "%W", "_")));
end;

local function seriesGeneric(p7: table) -- Line: 243
    local v8 = {};

    for i, v in p7 do
        table.insert(v8, {
            name = i,
            amount = v
        });
    end;

    return v8;
end;

local function seriesTierUps(p9: string, p10: string?) -- Line: 253
    -- upvalues: u5 (copy), seriesGeneric (copy), u2 (copy)
    local v11 = u5.Fished[p9];

    for i, v in u5.TierUps do
        local v12 = seriesGeneric(v.Generic);
        local v13, v14;

        if v11 == nil then
            local v15 = u5.Wearables[string.match(p9, "^(%a+) ")];
            local v16 = v.Materials[p10];
            v13 = v;
            v14 = i;

            for _, v2 in u5.Kinds do
                if v16[v2] ~= nil then
                    table.insert(v12, {
                        name = v15.Materials[v2],
                        amount = v16[v2]
                    });
                end;
            end;
        else
            v13 = v;
            v14 = i;

            for _, v2 in u5.Wearables do
                local v17 = v2;

                for _, v3 in u5.Kinds do
                    table.insert(v12, {
                        name = v17.Materials[v3],
                        amount = v11[v14]
                    });
                end;
            end;
        end;

        u2[`{string.lower((string.gsub(p9, "%W", "_")))}_t{v14}`] = {
            station = "Ouwland",
            amount = 1,
            refineKept = 1,
            fullPrice = true,
            result = p9,
            price = {
                Wen = v13.Wen
            },
            required = {
                {
                    amount = 1,
                    name = p9
                }
            },
            additionalMaterials = v12,
            keep = v11 == nil and { p9 .. " Schematic" } or nil,
            requiredTier = v14 - 1,
            tier = v14,
            listedWhenHeld = v11 ~= nil
        };
    end;
end;

for i, v in u5.Weapons do
    local v18 = i;

    for _, v2 in v do
        u2[`{string.lower((string.gsub(v18, "%W", "_")))}__{string.lower((string.gsub(v2, "%W", "_")))}`] = {
            station = "Ouwland",
            amount = 1,
            refineKept = 1,
            tier = 1,
            fullPrice = true,
            result = v18,
            price = {
                Wen = u5.Wen
            },
            required = {
                {
                    amount = 1,
                    name = v2
                }
            },
            additionalMaterials = seriesGeneric(u5.Generic),
            keep = { v18 .. " Schematic" }
        };
    end;

    seriesTierUps(v18, "Weapon");
end;

for i in u5.Fished do
    seriesTierUps(i);
end;

for _, v in u5.Wearables do
    local v19 = v;

    for i, v2 in v.Pieces do
        local v20 = i;
        local v21 = {};

        for _, v3 in u5.Kinds do
            table.insert(v21, {
                name = v19.Materials[v3],
                amount = u5.MaterialEach
            });
        end;

        u2[string.lower((string.gsub(v20, "%W", "_")))] = {
            station = "Ouwland",
            amount = 1,
            tier = 1,
            fullPrice = true,
            result = v20,
            price = {
                Wen = u5.Wen
            },
            required = v21,
            additionalMaterials = seriesGeneric(u5.Generic),
            keep = { v20 .. " Schematic" }
        };
        seriesTierUps(v20, v2);
    end;
end;

for _, v in u5.Tower.Pieces do
    local v22 = v;
    local v23 = {};

    for i, v2 in u5.Tower.Generic do
        table.insert(v23, {
            name = i,
            amount = v2
        });
    end;

    u2[string.lower((string.gsub(v22, "%W", "_")))] = {
        station = "Ouwigahara",
        amount = 1,
        tier = 1,
        fullPrice = true,
        result = v22,
        price = table.clone(u5.Tower.Price),
        required = v23,
        additionalMaterials = {},
        keep = { v22 .. " Schematic" }
    };
    seriesTierUps(v22, "Armor");
end;

if not RunService:IsStudio() then
    return u2;
end;

for i, v in {
    firstlight_katana = {
        result = "Firstlight Katana",
        amount = 1,
        price = {
            Product = 3709745729
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 3
            }, {
                name = "Firstlight Star Ore",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 5
            }, {
                name = "Silk Thread",
                amount = 3
            } }
    },
    firstlight_haori = {
        result = "Firstlight Haori",
        amount = 1,
        price = {
            ["Silk Thread"] = 12
        },
        required = { {
                name = "Firstlight Weaver\'s Silk",
                amount = 4
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 6
            } }
    },
    firstlight_mask = {
        result = "Firstlight Mask",
        amount = 1,
        price = {
            ["Golden Fish"] = 2
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 1
            }, {
                name = "Firstlight Weaver\'s Silk",
                amount = 1
            }, {
                name = "Firstlight Star Ore",
                amount = 1
            } },
        additionalMaterials = {}
    },
    firstlight_spear = {
        result = "Firstlight Spear",
        amount = 1,
        price = {
            Wen = 450,
            ["Metal Scraps"] = 10
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Refinement Ore",
                amount = 2
            }, {
                name = "Coral",
                amount = 1
            }, {
                name = "Worm",
                amount = 4
            } }
    },
    nightfall_katana = {
        result = "Nightfall Katana",
        amount = 1,
        price = {
            ["Mythic Refinement Ore"] = 3
        },
        required = { {
                name = "Nightfall Forged Ingot",
                amount = 3
            }, {
                name = "Nightfall Reinforced Plating",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 8
            } }
    },
    nightfall_scythe = {
        result = "Nightfall Scythe",
        amount = 1,
        price = {
            ["Refinement Ore"] = 5
        },
        required = { {
                name = "Nightfall Forged Ingot",
                amount = 2
            }, {
                name = "Nightfall Reinforced Plating",
                amount = 2
            }, {
                name = "Nightfall Weaver\'s Cloth",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 4
            }, {
                name = "Silk Thread",
                amount = 2
            }, {
                name = "Fish Head",
                amount = 1
            }, {
                name = "Mythic Refinement Ore",
                amount = 1
            } }
    },
    nightfall_serpent_katana = {
        result = "Nightfall Serpent Katana",
        amount = 1,
        price = {
            Wen = 900,
            ["Demon Horns"] = 4
        },
        required = { {
                name = "Nightfall Forged Ingot",
                amount = 3
            }, {
                name = "Krathulon",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 6
            }, {
                name = "Sea Horse",
                amount = 2
            } }
    },
    firstlight_insect_katana = {
        result = "Firstlight Insect Katana",
        amount = 1,
        price = {
            Product = 3709745340
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 3
            }, {
                name = "Firstlight Star Ore",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 2
            }, {
                name = "Metal Scraps",
                amount = 6
            }, {
                name = "Refinement Ore",
                amount = 2
            }, {
                name = "Mythic Refinement Ore",
                amount = 1
            }, {
                name = "Coral",
                amount = 3
            }, {
                name = "Worm",
                amount = 5
            }, {
                name = "Fish Head",
                amount = 2
            }, {
                name = "Sea Horse",
                amount = 1
            }, {
                name = "Zebra Fish",
                amount = 2
            }, {
                name = "Golden Tentacle",
                amount = 1
            } }
    },
    firstlight_sound_cleavers = {
        result = "Firstlight Sound Cleavers",
        amount = 1,
        price = {
            Wen = 650,
            ["Metal Scraps"] = 5
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 4
            } },
        additionalMaterials = {}
    },
    firstlight_bladed_wagasa = {
        result = "Firstlight Bladed Wagasa",
        amount = 1,
        price = {
            ["Golden Fish"] = 5,
            ["Refinement Ore"] = 2
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 2
            }, {
                name = "Firstlight Weaver\'s Silk",
                amount = 3
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 4
            }, {
                name = "Coral",
                amount = 2
            } }
    },
    nightfall_axe_and_mace = {
        result = "Nightfall Axe and Mace",
        amount = 1,
        price = {
            ["Demon Horns"] = 10
        },
        required = { {
                name = "Nightfall Forged Ingot",
                amount = 3
            }, {
                name = "Nightfall Reinforced Plating",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 10
            } }
    },
    firstlight_top = {
        result = "Firstlight Top",
        amount = 1,
        price = {
            ["Silk Thread"] = 8
        },
        required = { {
                name = "Firstlight Weaver\'s Silk",
                amount = 3
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 5
            } }
    },
    firstlight_bottom = {
        result = "Firstlight Bottom",
        amount = 1,
        price = {
            Wen = 300
        },
        required = { {
                name = "Firstlight Weaver\'s Silk",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 4
            } }
    },
    nightfall_top = {
        result = "Nightfall Top",
        amount = 1,
        price = {
            Product = 3709745395
        },
        required = { {
                name = "Nightfall Weaver\'s Cloth",
                amount = 3
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 5
            } }
    },
    nightfall_bottom = {
        result = "Nightfall Bottom",
        amount = 1,
        price = {
            ["Metal Scraps"] = 15
        },
        required = { {
                name = "Nightfall Weaver\'s Cloth",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 4
            } }
    },
    nightfall_cape = {
        result = "Nightfall Cape",
        amount = 1,
        price = {
            Wen = 500,
            ["Golden Fish"] = 1
        },
        required = { {
                name = "Nightfall Weaver\'s Cloth",
                amount = 4
            }, {
                name = "Nightfall Reinforced Plating",
                amount = 1
            } },
        additionalMaterials = {}
    },
    nightfall_mask = {
        result = "Nightfall Mask",
        amount = 1,
        price = {
            ["Demon Horns"] = 2
        },
        required = { {
                name = "Nightfall Forged Ingot",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Zebra Fish",
                amount = 1
            } }
    },
    firstlight_lantern = {
        result = "Firstlight Lantern",
        amount = 2,
        price = {
            Wen = 150
        },
        required = { {
                name = "Firstlight Star Ore",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Golden Tentacle",
                amount = 1
            } }
    },
    nightfall_gauntlet = {
        result = "Nightfall Gauntlet",
        amount = 1,
        price = {
            ["Refinement Ore"] = 3
        },
        required = { {
                name = "Nightfall Reinforced Plating",
                amount = 3
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 6
            } }
    },
    nightfall_claws = {
        result = "Nightfall Claws",
        amount = 1,
        price = {
            ["Mythic Refinement Ore"] = 1,
            ["Metal Scraps"] = 6
        },
        required = { {
                name = "Nightfall Forged Ingot",
                amount = 2
            }, {
                name = "Nightfall Reinforced Plating",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Fish Head",
                amount = 3
            } }
    },
    firstlight_war_fans = {
        result = "Firstlight War Fans",
        amount = 1,
        price = {
            Product = 3709745729
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 1
            }, {
                name = "Firstlight Weaver\'s Silk",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 3
            } }
    },
    firstlight_tanto = {
        result = "Firstlight Tanto",
        amount = 3,
        price = {
            Wen = 400
        },
        required = { {
                name = "Firstlight Forged Ingot",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 3
            } }
    },
    nightfall_sickles = {
        result = "Nightfall Sickles",
        amount = 1,
        price = {
            ["Refinement Ore"] = 6
        },
        required = { {
                name = "Nightfall Forged Ingot",
                amount = 2
            }, {
                name = "Nightfall Reinforced Plating",
                amount = 1
            }, {
                name = "Nightfall Weaver\'s Cloth",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Metal Scraps",
                amount = 4
            } }
    },
    rarity_common = {
        result = "Black Bandana",
        amount = 1,
        price = {
            Wen = 100
        },
        required = { {
                name = "Metal Scraps",
                amount = 1
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 1
            } }
    },
    rarity_uncommon = {
        result = "Fancy Katana",
        amount = 1,
        price = {
            ["Golden Fish"] = 3
        },
        required = { {
                name = "Metal Scraps",
                amount = 2
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 2
            } }
    },
    rarity_rare = {
        result = "Azure Cloak",
        amount = 1,
        price = {
            Product = 3709745340
        },
        required = { {
                name = "Metal Scraps",
                amount = 3
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 3
            } }
    },
    rarity_epic = {
        result = "Autumn Haori",
        amount = 1,
        price = {
            ["Refinement Ore"] = 4
        },
        required = { {
                name = "Metal Scraps",
                amount = 4
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 4
            } }
    },
    rarity_legendary = {
        result = "Blood Sickles",
        amount = 1,
        price = {
            Wen = 500,
            ["Mythic Refinement Ore"] = 2
        },
        required = { {
                name = "Metal Scraps",
                amount = 5
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 5
            } }
    },
    rarity_mythic = {
        result = "Akatsuki Straw Hat",
        amount = 1,
        price = {
            Product = 3709745395
        },
        required = { {
                name = "Metal Scraps",
                amount = 6
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 6
            } }
    },
    rarity_impossible = {
        result = "Dev Cape",
        amount = 1,
        price = {
            ["Demon Horns"] = 7,
            ["Metal Scraps"] = 20
        },
        required = { {
                name = "Metal Scraps",
                amount = 7
            } },
        additionalMaterials = { {
                name = "Silk Thread",
                amount = 7
            } }
    }
} do
    u2[i] = v;
end;

return u2;