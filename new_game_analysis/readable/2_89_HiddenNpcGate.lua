-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = ReplicatedStorage.Player_Service.Values:WaitForChild(Players.LocalPlayer.Name);
local Folder = Instance.new("Folder");
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = {};

local function facesOf(p7: userdata) -- Line: 53
    -- upvalues: u5 (copy)
    local v8 = {};

    for _, v in p7:QueryDescendants("BasePart:not([$SetTransparency]),Decal:not([$SetTransparency])") do
        if u5[v] == nil then
            u5[v] = v.Transparency;
        end;

        table.insert(v8, v);
    end;

    return v8;
end;

local function write(p9: table, p10: number) -- Line: 64
    -- upvalues: u5 (copy)
    for _, v in p9 do
        local v11 = u5[v];
        v.Transparency = v11 + (1 - v11) * p10;
    end;
end;

local function setAlpha(p12: userdata, p13: number) -- Line: 71
    -- upvalues: u4 (copy), facesOf (copy), u5 (copy)
    u4[p12] = p13;

    for _, v in facesOf(p12) do
        local v14 = u5[v];
        v.Transparency = v14 + (1 - v14) * p13;
    end;
end;

local function suppress(p15: userdata, p16: boolean) -- Line: 78
    -- upvalues: u6 (copy)
    for _, v in p15:QueryDescendants("ProximityPrompt,BillboardGui") do
        if p16 then
            if u6[v] == nil then
                u6[v] = v.Enabled;
                v.Enabled = false;
            end;
        elseif u6[v] ~= nil then
            v.Enabled = u6[v];
            u6[v] = nil;
        end;
    end;
end;

local function cancelFade(p17: userdata) -- Line: 92
    -- upvalues: u3 (copy)
    local v18 = u3[p17];

    if v18 ~= nil then
        v18.conn:Disconnect();
        u3[p17] = nil;
    end;
end;

local function fadeTo(u19: userdata, u20: number, u21: function?) -- Line: 102
    -- upvalues: u3 (copy), u4 (copy), facesOf (copy), u5 (copy), RunService (copy)
    local v22 = u3[u19];

    if v22 ~= nil then
        v22.conn:Disconnect();
        u3[u19] = nil;
    end;

    local u23 = u4[u19] or 0;
    local math_abs_ret = math.abs(u20 - u23);

    if math_abs_ret <= 0.01 then
        u4[u19] = u20;

        for _, v in facesOf(u19) do
            local v24 = u5[v];
            v.Transparency = v24 + (1 - v24) * u20;
        end;

        if u21 then
            u21();
        end;

        return;
    end;

    local u25 = facesOf(u19);
    local os_clock_ret = os.clock();
    local u26 = nil;
    u26 = RunService.RenderStepped:Connect(function() -- Line: 114
        -- upvalues: os_clock_ret (copy), math_abs_ret (copy), u4 (ref), u19 (copy), u23 (copy), u20 (copy), u25 (copy), u5 (ref), u26 (ref), u3 (ref), u21 (copy)
        local v27 = (os.clock() - os_clock_ret) / (math_abs_ret * 0.5);
        local math_clamp_ret = math.clamp(v27, 0, 1);
        u4[u19] = u23 + (u20 - u23) * (math_clamp_ret * math_clamp_ret * (3 - math_clamp_ret * 2));
        local v28 = u4[u19];

        for _, v in u25 do
            local v29 = u5[v];
            v.Transparency = v29 + (1 - v29) * v28;
        end;

        if math_clamp_ret >= 1 then
            u26:Disconnect();
            u3[u19] = nil;

            if u21 then
                u21();
            end;
        end;
    end);
    u3[u19] = {
        conn = u26,
        target = u20
    };
end;

local function park(p30: userdata) -- Line: 128
    -- upvalues: Folder (copy), u2 (copy), u4 (copy), facesOf (copy), u5 (copy), u6 (copy)
    if p30.Parent ~= nil and p30.Parent ~= Folder then
        u2[p30] = p30.Parent;
        p30.Parent = Folder;
        u4[p30] = 0;

        for _, v in facesOf(p30) do
            local v31 = u5[v];
            v.Transparency = v31 + (1 - v31) * 0;
        end;
    end;

    for _, v in p30:QueryDescendants("ProximityPrompt,BillboardGui") do
        if u6[v] ~= nil then
            v.Enabled = u6[v];
            u6[v] = nil;
        end;
    end;
end;

local function apply(u32: userdata, p33: boolean?) -- Line: 140
    -- upvalues: u1 (copy), CollectionService (copy), u3 (copy), Folder (copy), u2 (copy), u4 (copy), facesOf (copy), u5 (copy), u6 (copy), fadeTo (copy)
    local v34 = u1:FindFirstChild("HiddenNpc_" .. u32.Name);
    local v35;

    if v34 == nil then
        v35 = false;
    else
        v35 = v34.Value == true;
    end;

    if CollectionService:HasTag(u32, "HideableNpc") then
        v35 = not v35;
    end;

    local v36 = u3[u32];
    local v37;

    if v36 == nil then
        v37 = false;
    else
        v37 = v36.target == 1;
    end;

    if u32.Parent ~= Folder then
        if v35 then
            if v37 then
                fadeTo(u32, 0, function() -- Line: 160
                    -- upvalues: u32 (copy), u6 (ref)
                    for _, v in u32:QueryDescendants("ProximityPrompt,BillboardGui") do
                        if u6[v] ~= nil then
                            v.Enabled = u6[v];
                            u6[v] = nil;
                        end;
                    end;
                end);

                return;
            end;
        elseif u32.Parent ~= nil and not v37 then
            if p33 then
                local v38 = u3[u32];

                if v38 ~= nil then
                    v38.conn:Disconnect();
                    u3[u32] = nil;
                end;

                if u32.Parent ~= nil and u32.Parent ~= Folder then
                    u2[u32] = u32.Parent;
                    u32.Parent = Folder;
                    u4[u32] = 0;

                    for _, v in facesOf(u32) do
                        local v39 = u5[v];
                        v.Transparency = v39 + (1 - v39) * 0;
                    end;
                end;

                for _, v in u32:QueryDescendants("ProximityPrompt,BillboardGui") do
                    if u6[v] ~= nil then
                        v.Enabled = u6[v];
                        u6[v] = nil;
                    end;
                end;

                return;
            end;

            for _, v in u32:QueryDescendants("ProximityPrompt,BillboardGui") do
                if u6[v] == nil then
                    u6[v] = v.Enabled;
                    v.Enabled = false;
                end;
            end;

            fadeTo(u32, 1, function() -- Line: 170
                -- upvalues: u32 (copy), Folder (ref), u2 (ref), u4 (ref), facesOf (ref), u5 (ref), u6 (ref)
                local v40 = u32;

                if v40.Parent ~= nil and v40.Parent ~= Folder then
                    u2[v40] = v40.Parent;
                    v40.Parent = Folder;
                    u4[v40] = 0;

                    for _, v in facesOf(v40) do
                        local v41 = u5[v];
                        v.Transparency = v41 + (1 - v41) * 0;
                    end;
                end;

                for _, v in v40:QueryDescendants("ProximityPrompt,BillboardGui") do
                    if u6[v] ~= nil then
                        v.Enabled = u6[v];
                        u6[v] = nil;
                    end;
                end;
            end);
        end;

        return;
    end;

    if not v35 then
        return;
    end;

    u32.Parent = u2[u32];

    if p33 then
        u4[u32] = 0;

        for _, v in facesOf(u32) do
            local v42 = u5[v];
            v.Transparency = v42 + (1 - v42) * 0;
        end;

        return;
    end;

    u4[u32] = 1;

    for _, v in facesOf(u32) do
        local v43 = u5[v];
        v.Transparency = v43 + (1 - v43) * 1;
    end;

    for _, v in u32:QueryDescendants("ProximityPrompt,BillboardGui") do
        if u6[v] == nil then
            u6[v] = v.Enabled;
            v.Enabled = false;
        end;
    end;

    fadeTo(u32, 0, function() -- Line: 154
        -- upvalues: u32 (copy), u6 (ref)
        for _, v in u32:QueryDescendants("ProximityPrompt,BillboardGui") do
            if u6[v] ~= nil then
                v.Enabled = u6[v];
                u6[v] = nil;
            end;
        end;
    end);
end;

local u44 = {};

local function track(u45: userdata) -- Line: 179
    -- upvalues: u44 (copy), ReplicatedStorage (copy), apply (copy)
    if not u44[u45] then
        if u45:IsDescendantOf(ReplicatedStorage) then
            return;
        end;

        u44[u45] = true;
        u45:GetPropertyChangedSignal("Parent"):Connect(function() -- Line: 183
            -- upvalues: apply (ref), u45 (copy)
            apply(u45, true);
        end);
    end;

    apply(u45, true);
end;

for _, v in { "HiddenNpc", "HideableNpc" } do
    for _, v2 in CollectionService:GetTagged(v) do
        track(v2);
    end;

    CollectionService:GetInstanceAddedSignal(v):Connect(track);
end;

CollectionService:GetInstanceAddedSignal("FadeInOnSpawn"):Connect(function(p46) -- Line: 199
    -- upvalues: ReplicatedStorage (copy), u4 (copy), facesOf (copy), u5 (copy), fadeTo (copy)
    if p46:IsDescendantOf(ReplicatedStorage) then
        return;
    end;

    u4[p46] = 1;

    for _, v in facesOf(p46) do
        local v47 = u5[v];
        v.Transparency = v47 + (1 - v47) * 1;
    end;

    fadeTo(p46, 0);
end);

local function refresh() -- Line: 208
    -- upvalues: u44 (copy), apply (copy)
    for i in u44 do
        apply(i);
    end;
end;

u1.ChildAdded:Connect(function(p48) -- Line: 214
    -- upvalues: refresh (copy), u44 (copy), apply (copy)
    if p48.Name:sub(1, 10) ~= "HiddenNpc_" then
        return;
    end;

    p48.Changed:Connect(refresh);

    for i in u44 do
        apply(i);
    end;
end);
u1.ChildRemoved:Connect(function(p49) -- Line: 220
    -- upvalues: refresh (copy)
    if p49.Name:sub(1, 10) ~= "HiddenNpc_" then
        return;
    end;

    task.defer(refresh);
end);

for _, child in u1:GetChildren() do
    if child.Name:sub(1, 10) == "HiddenNpc_" then
        child.Changed:Connect(refresh);
    end;
end;