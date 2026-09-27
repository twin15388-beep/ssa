-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local MarkerHandler = require(ReplicatedStorage.CAM.Client.Modules.MarkerHandler);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);

return function(u1: userdata, p2: userdata) -- Line: 16
    -- upvalues: ReplicatedStorage (copy), cleanit (copy), MarkerHandler (copy), Color3_fromRGB_ret (copy), RunService (copy), Players (copy)
    local partyId = p2.Parent.Parent:WaitForChild("partyInfo"):WaitForChild("partyId");
    local Parties = ReplicatedStorage:WaitForChild("Player_Service"):WaitForChild("Parties");
    local v3 = cleanit.new();
    local u4 = nil;
    local u5 = {};
    local u6 = 0;

    local function markerKey(p7: number) -- Line: 26
        return "party_" .. p7;
    end;

    local PartyMarkerAnchors = workspace:FindFirstChild("PartyMarkerAnchors");

    if PartyMarkerAnchors == nil then
        PartyMarkerAnchors = Instance.new("Folder");
        PartyMarkerAnchors.Name = "PartyMarkerAnchors";
        PartyMarkerAnchors.Parent = workspace;
    end;

    local function bindMember(u8: userdata, u9: userdata) -- Line: 41
        -- upvalues: u5 (copy), cleanit (ref), PartyMarkerAnchors (ref), MarkerHandler (ref), Color3_fromRGB_ret (ref), RunService (ref)
        local UserId = u8.UserId;

        if u5[UserId] then
            return;
        end;

        local v10 = cleanit.new();
        u5[UserId] = v10;
        local u11 = "party_" .. UserId;
        local Part = Instance.new("Part");
        Part.Name = u11;
        Part.Size = Vector3.new(1, 1, 1);
        Part.Transparency = 1;
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        v10:Add(Part);

        local function resolve() -- Line: 60
            -- upvalues: u8 (copy), u9 (copy)
            local Character = u8.Character;
            local v12 = Character ~= nil and Character:FindFirstChild("HumanoidRootPart") or nil;

            if v12 ~= nil then
                return v12.Position;
            end;

            local Attribute = u9:GetAttribute("Position");

            if typeof(Attribute) == "Vector3" then
                return Attribute;
            end;

            return nil;
        end;

        local u13 = false;

        local function show() -- Line: 70
            -- upvalues: u13 (ref), Part (copy), PartyMarkerAnchors (ref), MarkerHandler (ref), u11 (copy), u8 (copy), Color3_fromRGB_ret (ref)
            if u13 then
                return;
            end;

            u13 = true;
            Part.Parent = PartyMarkerAnchors;
            MarkerHandler.addMarker(u11, {
                style = "PartyMember",
                offset = Vector3.new(0, 3, 0),
                onMap = true,
                tag = "PartyMarkers",
                displayDistance = true,
                minDistance = 15,
                margin = 10,
                markerType = MarkerHandler.markerType.Regular,
                position = Part,
                player = u8,
                color = Color3_fromRGB_ret
            });
        end;

        local function hide() -- Line: 88
            -- upvalues: u13 (ref), MarkerHandler (ref), u11 (copy), Part (copy)
            if not u13 then
                return;
            end;

            u13 = false;
            MarkerHandler.removeMarker(u11);
            Part.Parent = nil;
        end;

        local function update() -- Line: 94
            -- upvalues: u8 (copy), u9 (copy), u13 (ref), MarkerHandler (ref), u11 (copy), Part (copy), show (copy)
            local Character = u8.Character;
            local v14 = Character ~= nil and Character:FindFirstChild("HumanoidRootPart") or nil;
            local v15;

            if v14 == nil then
                v15 = u9:GetAttribute("Position");

                if typeof(v15) ~= "Vector3" then
                    v15 = nil;
                end;
            else
                v15 = v14.Position;
            end;

            if v15 ~= nil then
                Part.Position = v15;
                show();

                return;
            end;

            if not u13 then
                return;
            end;

            u13 = false;
            MarkerHandler.removeMarker(u11);
            Part.Parent = nil;
        end;

        local Character = u8.Character;
        local v16;

        if Character == nil then
            v16 = nil;
        else
            v16 = Character:FindFirstChild("HumanoidRootPart") or nil;
        end;

        local v17;

        if v16 == nil then
            v17 = u9:GetAttribute("Position");

            if typeof(v17) ~= "Vector3" then
                v17 = nil;
            end;
        else
            v17 = v16.Position;
        end;

        if v17 == nil then
            if u13 then
                u13 = false;
                MarkerHandler.removeMarker(u11);
                Part.Parent = nil;
            end;
        else
            Part.Position = v17;
            show();
        end;

        v10:Connect(RunService.Heartbeat, update);
        v10:Add(function() -- Line: 108
            -- upvalues: MarkerHandler (ref), u11 (copy)
            MarkerHandler.removeMarker(u11);
        end);
    end;

    local function unbindMember(p18: number?) -- Line: 112
        -- upvalues: u5 (copy), MarkerHandler (ref)
        if p18 == nil then
            return;
        end;

        local v19 = u5[p18];

        if v19 then
            v19:Destroy();
            u5[p18] = nil;
        end;

        MarkerHandler.removeMarker("party_" .. p18);
    end;

    local function tryBind(p20: number?, p21: userdata) -- Line: 120
        -- upvalues: u1 (copy), u5 (copy), Players (ref), bindMember (copy)
        if p20 == nil or p20 == u1.UserId then
            return;
        end;

        if u5[p20] then
            return;
        end;

        if p21:FindFirstChild((tostring(p20))) == nil then
            return;
        end;

        local PlayerByUserId = Players:GetPlayerByUserId(p20);

        if PlayerByUserId == nil then
            return;
        end;

        bindMember(PlayerByUserId, p21:FindFirstChild((tostring(p20))));
    end;

    local function unbindParty() -- Line: 129
        -- upvalues: u6 (ref), u4 (ref), u5 (copy), MarkerHandler (ref)
        u6 = u6 + 1;

        if u4 then
            u4:Destroy();
            u4 = nil;
        end;

        for i, v in u5 do
            v:Destroy();
            MarkerHandler.removeMarker("party_" .. i);
        end;

        table.clear(u5);
    end;

    local function bindParty(u22: string) -- Line: 139
        -- upvalues: unbindParty (copy), u6 (ref), Parties (copy), u4 (ref), cleanit (ref), tryBind (copy), u5 (copy), MarkerHandler (ref), Players (ref)
        unbindParty();

        if u22 == nil or u22 == "" then
            return;
        end;

        u6 = u6 + 1;
        local u23 = u6;
        task.spawn(function() -- Line: 144
            -- upvalues: Parties (ref), u22 (copy), u23 (copy), u6 (ref), u4 (ref), cleanit (ref), tryBind (ref), u5 (ref), MarkerHandler (ref), Players (ref)
            local u24 = Parties:FindFirstChild(u22) or Parties:WaitForChild(u22, 10);

            if u24 == nil or u23 ~= u6 then
                return;
            end;

            u4 = cleanit.new();

            for _, child in u24:GetChildren() do
                tryBind(tonumber(child.Name), u24);
            end;

            u4:Connect(u24.ChildAdded, function(p25) -- Line: 150
                -- upvalues: tryBind (ref), u24 (copy)
                tryBind(tonumber(p25.Name), u24);
            end);
            u4:Connect(u24.ChildRemoved, function(p26) -- Line: 151
                -- upvalues: u5 (ref), MarkerHandler (ref)
                local v27 = tonumber(p26.Name);

                if v27 == nil then
                    return;
                end;

                local v28 = u5[v27];

                if v28 then
                    v28:Destroy();
                    u5[v27] = nil;
                end;

                MarkerHandler.removeMarker("party_" .. v27);
            end);
            u4:Connect(Players.PlayerAdded, function(p29) -- Line: 153
                -- upvalues: tryBind (ref), u24 (copy)
                tryBind(p29.UserId, u24);
            end);
            u4:Connect(Players.PlayerRemoving, function(p30) -- Line: 154
                -- upvalues: u5 (ref), MarkerHandler (ref)
                local UserId = p30.UserId;

                if UserId == nil then
                    return;
                end;

                local v31 = u5[UserId];

                if v31 then
                    v31:Destroy();
                    u5[UserId] = nil;
                end;

                MarkerHandler.removeMarker("party_" .. UserId);
            end);
        end);
    end;

    local Value = partyId.Value;
    unbindParty();

    if Value ~= nil and Value ~= "" then
        u6 = u6 + 1;
        local u32 = u6;
        task.spawn(function() -- Line: 144
            -- upvalues: Parties (copy), Value (copy), u32 (copy), u6 (ref), u4 (ref), cleanit (ref), tryBind (copy), u5 (copy), MarkerHandler (ref), Players (ref)
            local u33 = Parties:FindFirstChild(Value) or Parties:WaitForChild(Value, 10);

            if u33 == nil or u32 ~= u6 then
                return;
            end;

            u4 = cleanit.new();

            for _, child in u33:GetChildren() do
                tryBind(tonumber(child.Name), u33);
            end;

            u4:Connect(u33.ChildAdded, function(p34) -- Line: 150
                -- upvalues: tryBind (ref), u33 (copy)
                tryBind(tonumber(p34.Name), u33);
            end);
            u4:Connect(u33.ChildRemoved, function(p35) -- Line: 151
                -- upvalues: u5 (ref), MarkerHandler (ref)
                local v36 = tonumber(p35.Name);

                if v36 == nil then
                    return;
                end;

                local v37 = u5[v36];

                if v37 then
                    v37:Destroy();
                    u5[v36] = nil;
                end;

                MarkerHandler.removeMarker("party_" .. v36);
            end);
            u4:Connect(Players.PlayerAdded, function(p38) -- Line: 153
                -- upvalues: tryBind (ref), u33 (copy)
                tryBind(p38.UserId, u33);
            end);
            u4:Connect(Players.PlayerRemoving, function(p39) -- Line: 154
                -- upvalues: u5 (ref), MarkerHandler (ref)
                local UserId = p39.UserId;

                if UserId == nil then
                    return;
                end;

                local v40 = u5[UserId];

                if v40 then
                    v40:Destroy();
                    u5[UserId] = nil;
                end;

                MarkerHandler.removeMarker("party_" .. UserId);
            end);
        end);
    end;

    v3:Connect(partyId.Changed, function() -- Line: 159
        -- upvalues: partyId (copy), unbindParty (copy), u6 (ref), Parties (copy), u4 (ref), cleanit (ref), tryBind (copy), u5 (copy), MarkerHandler (ref), Players (ref)
        local Value2 = partyId.Value;
        unbindParty();

        if Value2 ~= nil then
            if Value2 == "" then
                return;
            end;

            u6 = u6 + 1;
            local u41 = u6;
            task.spawn(function() -- Line: 144
                -- upvalues: Parties (ref), Value2 (copy), u41 (copy), u6 (ref), u4 (ref), cleanit (ref), tryBind (ref), u5 (ref), MarkerHandler (ref), Players (ref)
                local u42 = Parties:FindFirstChild(Value2) or Parties:WaitForChild(Value2, 10);

                if u42 == nil or u41 ~= u6 then
                    return;
                end;

                u4 = cleanit.new();

                for _, child in u42:GetChildren() do
                    tryBind(tonumber(child.Name), u42);
                end;

                u4:Connect(u42.ChildAdded, function(p43) -- Line: 150
                    -- upvalues: tryBind (ref), u42 (copy)
                    tryBind(tonumber(p43.Name), u42);
                end);
                u4:Connect(u42.ChildRemoved, function(p44) -- Line: 151
                    -- upvalues: u5 (ref), MarkerHandler (ref)
                    local v45 = tonumber(p44.Name);

                    if v45 == nil then
                        return;
                    end;

                    local v46 = u5[v45];

                    if v46 then
                        v46:Destroy();
                        u5[v45] = nil;
                    end;

                    MarkerHandler.removeMarker("party_" .. v45);
                end);
                u4:Connect(Players.PlayerAdded, function(p47) -- Line: 153
                    -- upvalues: tryBind (ref), u42 (copy)
                    tryBind(p47.UserId, u42);
                end);
                u4:Connect(Players.PlayerRemoving, function(p48) -- Line: 154
                    -- upvalues: u5 (ref), MarkerHandler (ref)
                    local UserId = p48.UserId;

                    if UserId == nil then
                        return;
                    end;

                    local v49 = u5[UserId];

                    if v49 then
                        v49:Destroy();
                        u5[UserId] = nil;
                    end;

                    MarkerHandler.removeMarker("party_" .. UserId);
                end);
            end);
        end;
    end);
end;