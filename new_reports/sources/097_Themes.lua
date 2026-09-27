-- Decompiled with Potassium's decompiler.

local u1 = {};
local Utility = require(script.Parent.Parent.Utility);
local script_Default = require(script.Default);

function u1.getThemeValue(p2, p3, p4, p5) -- Line: 16
    if p2 then
        for _, v in pairs(p2) do
            local v6, v7, v8 = unpack(v);

            if p3 == v6 and p4 == v7 then
                return v8;
            end;
        end;
    end;

    return nil;
end;

function u1.getInstanceValue(u9, u10) -- Line: 28
    local success, result = pcall(function() -- Line: 29
        -- upvalues: u9 (copy), u10 (copy)
        return u9[u10];
    end);

    if not success then
        result = u9:GetAttribute(u10);
    end;

    return result;
end;

function u1.getRealInstance(p11) -- Line: 38
    if not p11:GetAttribute("IsAClippedClone") then
        return;
    end;

    local OriginalInstance = p11:FindFirstChild("OriginalInstance");

    if OriginalInstance then
        return OriginalInstance.Value;
    end;
end;

function u1.getClippedClone(p12) -- Line: 49
    if not p12:GetAttribute("HasAClippedClone") then
        return;
    end;

    local ClippedClone = p12:FindFirstChild("ClippedClone");

    if ClippedClone then
        return ClippedClone.Value;
    end;
end;

function u1.refresh(p13, p14, p15) -- Line: 60
    -- upvalues: u1 (copy)
    if p15 then
        local StateGroup = p13:getStateGroup();
        local v16 = u1.getThemeValue(StateGroup, p14.Name, p15) or u1.getInstanceValue(p14, p15);
        u1.apply(p13, p14, p15, v16, true);

        return;
    end;

    local StateGroup = p13:getStateGroup();

    if not StateGroup then
        return;
    end;

    local v17 = {
        [p14.Name] = p14
    };

    for _, descendant in pairs(p14:GetDescendants()) do
        local Attribute = descendant:GetAttribute("Collective");

        if Attribute then
            v17[Attribute] = descendant;
        end;

        v17[descendant.Name] = descendant;
    end;

    for _, v in pairs(StateGroup) do
        local v18, v19, v20 = unpack(v);
        local v21 = v17[v18];

        if v21 then
            u1.apply(p13, v21.Name, v19, v20, true);
        end;
    end;
end;

function u1.apply(p22, p23, u24, u25, p26) -- Line: 93
    -- upvalues: u1 (copy)
    if p22.isDestroyed then
        return;
    end;

    local v27;

    if typeof(p23) == "Instance" then
        p23 = p23.Name;
        v27 = { p23 };
    else
        v27 = p22:getInstanceOrCollective(p23);
    end;

    local v28 = p22.customBehaviours[p23 .. "-" .. u24];

    for _, v in pairs(v27) do
        local ClippedClone = u1.getClippedClone(v);

        if ClippedClone then
            table.insert(v27, ClippedClone);
        end;
    end;

    for _, v in pairs(v27) do
        if u24 ~= "Position" or not u1.getClippedClone(v) then
            if (u24 ~= "Size" or not u1.getRealInstance(v)) and (p26 or u25 ~= u1.getInstanceValue(v, u24)) then
                if v28 then
                    local v29 = v28(u25, v, u24);

                    if v29 ~= nil then
                        u25 = v29;
                    end;
                end;

                if not pcall(function() -- Line: 139
                    -- upvalues: v (copy), u24 (copy), u25 (ref)
                    v[u24] = u25;
                end) then
                    v:SetAttribute(u24, u25);
                end;
            end;
        end;
    end;
end;

function u1.getModifications(p30) -- Line: 153
    return typeof(p30[1]) ~= "table" and { p30 } or p30;
end;

function u1.merge(p31, p32, p33) -- Line: 162
    -- upvalues: u1 (copy)
    local table_unpack_ret, v34, v35, v36 = table.unpack(p32);
    local table_unpack_ret2, v37, _, v38 = table.unpack(p31);

    if table_unpack_ret ~= table_unpack_ret2 or (v34 ~= v37 or not u1.statesMatch(v36, v38)) then
        return false;
    end;

    p31[3] = v35;

    if p33 then
        p33(p31);
    end;

    return true;
end;

function u1.modify(u39, u40, u41) -- Line: 175
    -- upvalues: Utility (copy), u1 (copy)
    task.spawn(function() -- Line: 183
        -- upvalues: u41 (ref), Utility (ref), u40 (ref), u1 (ref), u39 (copy)
        u41 = u41 or Utility.generateUID();
        u40 = u1.getModifications(u40);

        for _, v in pairs(u40) do
            local table_unpack_ret, u42, u43, v44 = table.unpack(v);

            if v44 == nil then
                u1.modify(u39, {
                    table_unpack_ret,
                    u42,
                    u43,
                    "Selected"
                }, u41);
                u1.modify(u39, {
                    table_unpack_ret,
                    u42,
                    u43,
                    "Viewing"
                }, u41);
            end;

            local u45 = Utility.formatStateName(v44 or "Deselected");
            local StateGroup = u39:getStateGroup(u45);

            local function nowSetIt() -- Line: 195
                -- upvalues: u45 (copy), u39 (ref), u1 (ref), table_unpack_ret (copy), u42 (copy), u43 (copy)
                if u45 == u39.activeState then
                    u1.apply(u39, table_unpack_ret, u42, u43);
                end;
            end;

            (function() -- Line: 200, Name: updateRecord
                -- upvalues: StateGroup (copy), u1 (ref), v (copy), u41 (ref), u45 (copy), u39 (ref), table_unpack_ret (copy), u42 (copy), u43 (copy)
                for _, v2 in pairs(StateGroup) do
                    if u1.merge(v2, v, function(p46) -- Line: 202
                        -- upvalues: u41 (ref), u45 (ref), u39 (ref), u1 (ref), table_unpack_ret (ref), u42 (ref), u43 (ref)
                        p46[5] = u41;

                        if u45 == u39.activeState then
                            u1.apply(u39, table_unpack_ret, u42, u43);
                        end;
                    end) then
                        return;
                    end;
                end;

                table.insert(StateGroup, {
                    table_unpack_ret,
                    u42,
                    u43,
                    u45,
                    u41
                });

                if u45 == u39.activeState then
                    u1.apply(u39, table_unpack_ret, u42, u43);
                end;
            end)();
        end;
    end);

    return u41;
end;

function u1.remove(p47, p48) -- Line: 220
    -- upvalues: u1 (copy)
    for _, v in pairs(p47.appearance) do
        local v49 = v;

        for i = #v, 1, -1 do
            local v50;

            if v49[i][5] == p48 then
                table.remove(v49, i);
                v50 = i;
            else
                v50 = i;
            end;
        end;
    end;

    u1.rebuild(p47);
end;

function u1.removeWith(p51, p52, p53, p54) -- Line: 233
    -- upvalues: u1 (copy)
    for i, v in pairs(p51.appearance) do
        if p54 == i or not p54 then
            local v55 = v;

            for i2 = #v, 1, -1 do
                local v56 = v55[i2];
                local v57;

                if v56[1] == p52 and v56[2] == p53 then
                    table.remove(v55, i2);
                    v57 = i2;
                else
                    v57 = i2;
                end;
            end;
        end;
    end;

    u1.rebuild(p51);
end;

function u1.change(p58) -- Line: 249
    -- upvalues: u1 (copy)
    local StateGroup = p58:getStateGroup();

    for _, v in pairs(StateGroup) do
        local v59, v60, v61 = unpack(v);
        u1.apply(p58, v59, v60, v61);
    end;
end;

function u1.set(u62, p63) -- Line: 259
    -- upvalues: u1 (copy)
    local themesJanitor = u62.themesJanitor;
    themesJanitor:clean();
    themesJanitor:add(u62.stateChanged:Connect(function() -- Line: 265
        -- upvalues: u1 (ref), u62 (copy)
        u1.change(u62);
    end));

    if typeof(p63) == "Instance" and p63:IsA("ModuleScript") then
        p63 = require(p63);
    end;

    u62.appliedTheme = p63;
    u1.rebuild(u62);
end;

function u1.statesMatch(p64, p65) -- Line: 275
    local v66;

    if p64 then
        v66 = string.lower(p64);
    else
        v66 = p64;
    end;

    local v67;

    if p65 then
        v67 = string.lower(p65);
    else
        v67 = p65;
    end;

    return v66 == v67 and true or not (p64 and p65);
end;

function u1.rebuild(u68) -- Line: 282
    -- upvalues: u1 (copy), Utility (copy), script_Default (copy)
    local appliedTheme = u68.appliedTheme;
    local u69 = { "Deselected", "Selected", "Viewing" };
    (function() -- Line: 289, Name: generateTheme
        -- upvalues: u69 (copy), u1 (ref), Utility (ref), script_Default (ref), appliedTheme (copy), u68 (copy)
        for _, v in pairs(u69) do
            local u70 = {};

            local function updateDetails(p71, p72) -- Line: 295
                -- upvalues: u1 (ref), Utility (ref), u70 (copy)
                if not p71 then
                    return;
                end;

                for _, v2 in pairs(p71) do
                    local v73 = v2[5];

                    if u1.statesMatch(p72, v2[4]) then
                        local v74 = v2[1] .. "-" .. v2[2];
                        local v75 = Utility.copyTable(v2);
                        v75[5] = v73;
                        u70[v74] = v75;
                    end;
                end;
            end;

            if v == "Selected" then
                updateDetails(script_Default, "Deselected");
            end;

            updateDetails(script_Default, "Empty");
            updateDetails(script_Default, v);

            if appliedTheme ~= script_Default then
                if v == "Selected" then
                    updateDetails(appliedTheme, "Deselected");
                end;

                updateDetails(script_Default, "Empty");
                updateDetails(appliedTheme, v);
            end;

            local v76 = {};
            local v77 = u68.appearance[v];
            local v78;

            if v77 then
                v78 = v;

                for _, v2 in pairs(v77) do
                    local v79 = v2[5];

                    if v79 ~= nil then
                        table.insert(v76, {
                            v2[1],
                            v2[2],
                            v2[3],
                            v78,
                            v79
                        });
                    end;
                end;
            else
                v78 = v;
            end;

            updateDetails(v76, v78);
            local v80 = {};

            for _, v2 in pairs(u70) do
                table.insert(v80, v2);
            end;

            u68.appearance[v78] = v80;
        end;

        u1.change(u68);
    end)();
end;

return u1;