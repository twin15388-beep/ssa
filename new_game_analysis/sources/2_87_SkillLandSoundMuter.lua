-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");

local function watchCharacter(u1: userdata) -- Line: 13
    local u2 = false;
    local u3 = 0;

    local function bindSHCS(u4: userdata) -- Line: 17
        -- upvalues: u2 (ref), u3 (ref)
        if not u4:IsA("StringValue") then
            return;
        end;

        local function upd() -- Line: 19
            -- upvalues: u4 (copy), u2 (ref), u3 (ref)
            local v5 = u4.Value ~= "";

            if u2 and not v5 then
                u3 = os.clock();
            end;

            u2 = v5;
        end;

        local v6 = u4.Value ~= "";

        if u2 and not v6 then
            u3 = os.clock();
        end;

        u2 = v6;
        u4.Changed:Connect(upd);
    end;

    local SHCS = u1:FindFirstChild("SHCS");

    if SHCS and SHCS:IsA("StringValue") then
        local function v8() -- Line: 19
            -- upvalues: SHCS (copy), u2 (ref), u3 (ref)
            local v7 = SHCS.Value ~= "";

            if u2 and not v7 then
                u3 = os.clock();
            end;

            u2 = v7;
        end;

        local v9 = SHCS.Value ~= "";

        if u2 and not v9 then
            u3 = os.clock();
        end;

        u2 = v9;
        SHCS.Changed:Connect(v8);
    end;

    u1.ChildAdded:Connect(function(u10) -- Line: 32
        -- upvalues: u2 (ref), u3 (ref)
        if u10.Name == "SHCS" then
            if not u10:IsA("StringValue") then
                return;
            end;

            local function v12() -- Line: 19
                -- upvalues: u10 (copy), u2 (ref), u3 (ref)
                local v11 = u10.Value ~= "";

                if u2 and not v11 then
                    u3 = os.clock();
                end;

                u2 = v11;
            end;

            local v13 = u10.Value ~= "";

            if u2 and not v13 then
                u3 = os.clock();
            end;

            u2 = v13;
            u10.Changed:Connect(v12);
        end;
    end);
    task.spawn(function() -- Line: 36
        -- upvalues: u1 (copy), u2 (ref), u3 (ref)
        local HumanoidRootPart = u1:WaitForChild("HumanoidRootPart", 15);

        if not HumanoidRootPart then
            return;
        end;

        local Landing = HumanoidRootPart:WaitForChild("Landing", 15);

        if not (Landing and Landing:IsA("Sound")) then
            return;
        end;

        Landing:GetPropertyChangedSignal("Playing"):Connect(function() -- Line: 42
            -- upvalues: Landing (copy), u2 (ref), u3 (ref)
            if Landing.Playing and (u2 or os.clock() - u3 < 0.8) then
                Landing.Playing = false;
            end;
        end);
    end);
end;

local function watchPlayer(p14: userdata) -- Line: 50
    -- upvalues: watchCharacter (copy)
    if p14.Character then
        task.spawn(watchCharacter, p14.Character);
    end;

    p14.CharacterAdded:Connect(watchCharacter);
end;

for _, v in Players:GetPlayers() do
    if v.Character then
        task.spawn(watchCharacter, v.Character);
    end;

    v.CharacterAdded:Connect(watchCharacter);
end;

Players.PlayerAdded:Connect(watchPlayer);