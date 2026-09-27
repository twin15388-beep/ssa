-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local v1 = RunService:IsServer();
local Give = require(script.Parent.Give);
local u2;

if v1 then
    u2 = require(ServerStorage.SAM.BanActions) or nil;
else
    u2 = nil;
end;

local u3 = v1 and require(ServerStorage.SAM.Services.DiscordLogService) or nil;
local u4 = { "Ban", "Unban", "Kick", "Bring", "Goto", "Give" };
local u5 = { "Level", "Item", "Wen" };

local function named(p6: table, p7: any) -- Line: 41
    local v8 = tostring(p7):lower();

    for _, v in p6 do
        if v:lower() == v8 then
            return v;
        end;
    end;

    return nil;
end;

local function target(p9: userdata, p10: any) -- Line: 52
    -- upvalues: Players (copy), u2 (copy)
    local v11 = Players:FindFirstChild((tostring(p10)));

    if v11 == nil or not v11:IsA("Player") then
        error((`No player named "{p10}" in this server`));
    end;

    if v11 == p9 then
        error("Staff cannot use this on themselves");
    end;

    if u2.IsStaff(v11) then
        error("Staff cannot use this on other staff");
    end;

    return v11;
end;

local function optional(p12: string) -- Line: 67
    if p12 == nil or p12 == "" then
        return nil;
    end;

    return tonumber(p12) or p12;
end;

return {
    Clearance = 0.75,
    Keys = {
        {
            Type = "Action",
            Name = "Action",
            Required = true,
            Suggester = u4,

            Completer = function(p13: string) -- Line: 80, Name: Completer
                -- upvalues: u4 (copy)
                local v14 = tostring(p13):lower();

                for _, v in u4 do
                    if v:lower() == v14 then
                        return v;
                    end;
                end;

                return nil;
            end
        },
        {
            Type = "Username",
            Name = "Username",
            Required = true,

            Suggester = function() -- Line: 88, Name: Suggester
                -- upvalues: Players (copy)
                local v15 = {};

                for _, v in Players:GetPlayers() do
                    table.insert(v15, v.Name);
                end;

                return v15;
            end
        },
        {
            Type = "Value",
            Name = "Hours / reason / give type",
            Required = false,

            Suggester = function(p16: table) -- Line: 102, Name: Suggester
                -- upvalues: u4 (copy), u5 (copy)
                local v17 = tostring(p16[1] or ""):lower();
                local v18 = nil;

                for _, v in u4 do
                    if v:lower() == v17 then
                        v18 = v;
                        break;
                    end;
                end;

                local v19;

                if v18 == "Give" then
                    v19 = u5;
                else
                    v19 = nil;
                end;

                return v19, true;
            end,

            Completer = optional
        },
        {
            Type = "Value",
            Name = "Reason / give value",
            Required = false,
            Completer = optional
        },
        {
            Type = "Amount",
            Name = "Amount",
            Required = false,

            Completer = function(p20: string) -- Line: 117, Name: Completer
                return tonumber(p20);
            end
        }
    },

    Server = function(p21: userdata, p22: string, p23: any, p24: any, p25: any, p26: any) -- Line: 122, Name: Server
        -- upvalues: u4 (copy), Players (copy), u2 (copy), target (copy), u3 (copy), u5 (copy), Give (copy)
        local v27 = tostring(p22):lower();
        local v28 = nil;

        for _, v in u4 do
            if v:lower() == v27 then
                v28 = v;
                break;
            end;
        end;

        if v28 == nil then
            error((`Invalid staff action: {p22}`));
        end;

        if v28 == "Unban" then
            local success, result = pcall(Players.GetUserIdFromNameAsync, Players, (tostring(p23)));

            if not success then
                error((`No Roblox account named "{p23}"`));
            end;

            u2.Lift(result, p21);

            return {
                Content = `Unbanned {p23} ({result})`,
                ContentColor = Color3.new(1, 1, 1),
                BgColor = Color3.fromRGB(30, 110, 60)
            };
        end;

        local v29 = target(p21, p23);

        if v28 == "Ban" then
            local v30 = tonumber(p24);

            if v30 == nil or v30 < 0 then
                error((`Hours must be a number (0 = permanent), not "{p24}"`));
            end;

            if typeof(p25) ~= "string" or string.match(p25, "^%s*$") ~= nil then
                error("A reason is required");
            end;

            u2.Manual(v29, v30 <= 0 and -1 or v30 * 3600, p25, p21);

            return {
                Content = `Banned {v29.Name} {v30 <= 0 and "permanently" or `for {v30}h`}: {p25}`,
                ContentColor = Color3.new(1, 1, 1),
                BgColor = Color3.fromRGB(150, 30, 30)
            };
        end;

        if v28 == "Kick" then
            local v31 = (typeof(p24) ~= "string" or p24 == "") and "You were removed by a moderator." or p24;
            u3.Send("moderation", "Kick", {
                player = p21,
                target = v29,
                data = {
                    reason = v31
                }
            });
            v29:Kick(v31);
        elseif v28 == "Bring" or v28 == "Goto" then
            local v32;

            if v28 == "Bring" then
                v32 = v29;
            else
                v32 = p21;
            end;

            local v33;

            if v28 == "Bring" then
                v33 = p21;
            else
                v33 = v29;
            end;

            local v34;

            if v33.Character == nil then
                v34 = nil;
            else
                v34 = v33.Character:FindFirstChild("HumanoidRootPart");
            end;

            if v34 == nil then
                error((`{v33.Name} has no character`));
            end;

            if v32.Character ~= nil then
                local Position = v34.Position;
                local Position2 = (v34.CFrame * CFrame.new(0, 0, -4)).Position;
                v32.Character:PivotTo(CFrame.lookAt(Position2, Position));
                v32.Character:MoveTo(Position2);
            end;

            u3.Send("moderation", v28, {
                player = p21,
                target = v29
            });
        elseif v28 == "Give" then
            local v35 = tostring(p24 or ""):lower();
            local v36 = nil;

            for _, v in u5 do
                if v:lower() == v35 then
                    v36 = v;
                    break;
                end;
            end;

            if v36 == nil then
                error((`Staff can give {table.concat(u5, ", ")}, not "{p24}"`));
            end;

            if p25 == nil then
                error((`Give {v36} needs a value`));
            end;

            return Give.Server(p21, { v29 }, v36, p25, p26);
        end;

        return nil;
    end
};