-- Decompiled with Potassium's decompiler.

local gameSettings = require(script.Parent.Global.gameSettings);
local v1 = {
    Image = { { "rbxassetid://122726915559820", "rbxassetid://126478315213404", "rbxassetid://83854516599440", "rbxassetid://135846092739063" }, { "rbxassetid://100760495545423", "rbxassetid://75844099380860", "rbxassetid://112548642468767", "rbxassetid://74129545153354" }, { "rbxassetid://94267737571637", "rbxassetid://86566116521928", "rbxassetid://117953739036731", "rbxassetid://124509291942928" }, { "rbxassetid://80660300812124", "rbxassetid://74694360341608", "rbxassetid://120088468476283", "rbxassetid://78889280949062" } },
    TopLeft = {
        X = -3087.361,
        Z = -3989.256
    },
    BottomRight = {
        X = 2977.139,
        Z = 1635.244
    }
};
local u2 = {
    Grid = {
        ["Test Place"] = {
            Id = 17047024836,
            Icon = "rbxassetid://85111783817768",
            Browsable = true,
            BiwaBellEnabled = true,
            PrivateServerHostable = true,
            SunDamage = true,
            RequiredGroup = {
                Id = 12851171,
                Rank = 3
            },
            Minimap = {
                Image = "rbxassetid://77255534096018",
                TopLeft = {
                    X = 1020,
                    Z = 1023
                },
                BottomRight = {
                    X = -1024,
                    Z = -1022
                }
            }
        },
        Ouwland = {
            Id = 136406881576517,
            Icon = "rbxassetid://113581254918526",
            Browsable = true,
            BiwaBellEnabled = true,
            PrivateServerHostable = true,
            SunDamage = true,
            SpawnAnywhere = true,
            Minimap = v1
        },
        ["Ouwland Test"] = {
            Id = 130395143593224,
            Icon = "rbxassetid://113581254918526",
            Browsable = true,
            BiwaBellEnabled = true,
            PrivateServerHostable = true,
            SunDamage = true,
            SpawnAnywhere = true,
            RequiredGroup = {
                Id = 12851171,
                Rank = 3
            },
            Minimap = v1
        },
        ["Main Menu"] = {
            Id = 16205713724,
            Icon = "",
            Ignore = true,
            BanPartyTeleport = true
        },
        Minigames = {
            Icon = "",
            Ignore = true,
            BanPartyTeleport = true,
            Id = gameSettings.HUDQueuPlaceId
        }
    },
    ById = {},
    ByName = {}
};

for i, v in u2.Grid do
    v.Name = i;
    u2.ByName[i] = v;
    u2.ById[v.Id] = v;
end;

function u2.MeetsRequirements(p3: userdata, p4: table, p5: userdata?) -- Line: 147
    -- upvalues: gameSettings (copy)
    local RequiredGroup = p4.RequiredGroup;

    if RequiredGroup ~= nil then
        local success, result = pcall(p3.GetRankInGroup, p3, RequiredGroup.Id);

        if not success or result < RequiredGroup.Rank then
            return false, `You don't have access to {p4.Name}.`;
        end;
    end;

    local RequiredLevel = p4.RequiredLevel;

    if RequiredLevel ~= nil then
        local v6;

        if p5 == nil then
            v6 = nil;
        else
            v6 = p5:FindFirstChild("Exp");
        end;

        local v7;

        if v6 == nil then
            v7 = nil;
        else
            v7 = v6:FindFirstChild("Goal");
        end;

        if v7 == nil or v7.Value / gameSettings.expPerLevel < RequiredLevel then
            return false, `You need to be level {RequiredLevel} to play {p4.Name}.`;
        end;
    end;

    return true;
end;

function u2.CanSee(p8: userdata, p9: table, p10: userdata?) -- Line: 168
    -- upvalues: u2 (copy)
    return u2.MeetsRequirements(p8, p9, p10);
end;

function u2.IsMenuPlace() -- Line: 179
    -- upvalues: u2 (copy)
    local v11 = u2.ByName["Main Menu"];

    return v11 ~= nil and game.PlaceId == v11.Id and true or workspace:GetAttribute("IsMenu") == true;
end;

return u2;