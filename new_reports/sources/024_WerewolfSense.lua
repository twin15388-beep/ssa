-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local v1 = {};
local u2 = false;
local Color3_fromRGB_ret = Color3.fromRGB(255, 35, 35);

function v1.Start() -- Line: 11
    -- upvalues: u2 (ref), Players (copy), Workspace (copy), Color3_fromRGB_ret (copy), RunService (copy)
    if u2 then
        return;
    end;

    u2 = true;
    local LocalPlayer = Players.LocalPlayer;
    local _LocalWerewolfSense = Workspace:FindFirstChild("_LocalWerewolfSense");

    if _LocalWerewolfSense then
        _LocalWerewolfSense:Destroy();
    end;

    local Folder = Instance.new("Folder");
    Folder.Name = "_LocalWerewolfSense";
    Folder.Parent = Workspace;
    local u3 = {};

    local function clearAll() -- Line: 37
        -- upvalues: u3 (copy)
        for i, v in u3 do
            v:Destroy();
            u3[i] = nil;
        end;
    end;

    local function update() -- Line: 44
        -- upvalues: LocalPlayer (copy), u3 (copy), Players (ref), Color3_fromRGB_ret (ref), Folder (copy)
        local v4;

        if LocalPlayer.Team == nil then
            v4 = false;
        else
            v4 = LocalPlayer.Team.Name == "Werewolfs";
        end;

        if not v4 then
            for i, v in u3 do
                v:Destroy();
                u3[i] = nil;
            end;

            return;
        end;

        local v5 = {};

        for _, v in Players:GetPlayers() do
            if v ~= LocalPlayer then
                v5[v] = true;
                local Character = v.Character;
                local v6;

                if Character then
                    v6 = Character:FindFirstChildOfClass("Humanoid");
                else
                    v6 = Character;
                end;

                if Character and (v6 and v6.Health > 0) then
                    local v7 = u3[v];

                    if not v7 then
                        v7 = Instance.new("Highlight");
                        v7.Name = "WerewolfOutline_" .. tostring(v.UserId);
                        v7.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                        v7.FillTransparency = 1;
                        v7.OutlineColor = Color3_fromRGB_ret;
                        v7.OutlineTransparency = 0;
                        v7.Parent = Folder;
                        u3[v] = v7;
                    end;

                    v7.Adornee = Character;
                    v7.Enabled = true;
                else
                    local v8 = u3[v];

                    if v8 then
                        v8:Destroy();
                        u3[v] = nil;
                    end;
                end;
            end;
        end;

        for i in u3 do
            if not v5[i] then
                local v9 = u3[i];

                if v9 then
                    v9:Destroy();
                    u3[i] = nil;
                end;
            end;
        end;
    end;

    local u10 = 0.2;
    RunService.RenderStepped:Connect(function(p11) -- Line: 86
        -- upvalues: u10 (ref), update (copy)
        u10 = u10 + p11;

        if u10 >= 0.2 then
            u10 = 0;
            update();
        end;
    end);
    Players.PlayerRemoving:Connect(function(p12) -- Line: 29, Name: clearHighlight
        -- upvalues: u3 (copy)
        local v13 = u3[p12];

        if v13 then
            v13:Destroy();
            u3[p12] = nil;
        end;
    end);
    LocalPlayer:GetPropertyChangedSignal("Team"):Connect(update);
    update();
end;

return v1;