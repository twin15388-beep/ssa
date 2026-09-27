-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local CombatBalance = require(ReplicatedStorage.CAM.Global.CombatBalance);
local Refinement = require(ReplicatedStorage.CAM.Global.Refinement);
local Series = require(ReplicatedStorage.CAM.Global.Series);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local ItemSources = require(ReplicatedStorage.CAM.Client.Modules.ItemSources);
local DetailPanel = require(ReplicatedStorage.CAM.Client.Components.Misc.DetailPanel);
local u1 = faye.Info(0.2, Enum.EasingStyle.Back);
local u2 = { {
        Key = "Stats",
        Header = "Worn"
    }, {
        Key = "ToolbarStats",
        Header = "On Toolbar"
    }, {
        Key = "ActiveToolStats",
        Header = "Held"
    } };

local function linesOf(p3: table?) -- Line: 28
    local v4 = {};

    if type(p3) ~= "table" then
        return v4;
    end;

    for i, v in p3 do
        if v == true or type(v) == "number" and v ~= 0 then
            table.insert(v4, {
                stat = i,
                amount = v
            });
        end;
    end;

    table.sort(v4, function(p5, p6) -- Line: 36
        return p5.stat < p6.stat;
    end);

    return v4;
end;

local function percentText(p7: number) -- Line: 43
    local v8 = math.clamp(p7, 0, 1) * 10000;

    return `{math.round(v8) / 100}%`;
end;

local u9 = {
    CatchChance = true
};

local function fishingLinesOf(p10: table?) -- Line: 55
    -- upvalues: u9 (copy)
    local v11 = {};

    if type(p10) ~= "table" then
        return v11;
    end;

    for i, v in p10 do
        if not u9[i] then
            local v12;

            if type(v) == "string" then
                v12 = v;
                table.insert(v11, {
                    stat = i,
                    amount = v,
                    text = v12
                });
            elseif type(v) == "number" then
                if string.find(i, "Multiplier", 1, true) == nil then
                    if string.find(i, "Chance", 1, true) == nil then
                        if v > 0 then
                            v12 = `+{v}`;
                        else
                            v12 = tostring(v);
                        end;
                    else
                        v12 = `{math.round(v * 100)}%`;
                    end;
                else
                    v12 = `{v}x`;
                end;

                table.insert(v11, {
                    stat = i,
                    amount = v,
                    text = v12
                });
            end;
        end;
    end;

    table.sort(v11, function(p13, p14) -- Line: 74
        return p13.stat < p14.stat;
    end);

    return v11;
end;

return function(p15: any, u16: userdata, u17: any, u18: any, u19: any) -- Line: 87
    -- upvalues: Items (copy), Series (copy), CombatBalance (copy), Refinement (copy), u2 (copy), linesOf (copy), fishingLinesOf (copy), ItemSources (copy), Rarities (copy), u1 (copy), DetailPanel (copy), BunchaIcons (copy)
    return p15:State(function(p20, u21) -- Line: 88
        -- upvalues: u17 (copy), Items (ref), Series (ref), CombatBalance (ref), Refinement (ref), u2 (ref), linesOf (ref), fishingLinesOf (ref), u18 (copy), ItemSources (ref), u19 (copy), Rarities (ref), u1 (ref), DetailPanel (ref), u16 (copy), BunchaIcons (ref)
        local v22 = p20(u17);
        local u23;

        if typeof(v22) == "Instance" then
            u23 = v22.Name;
        elseif typeof(v22) == "string" and v22 ~= "" then
            u23 = v22;
        else
            u23 = nil;
        end;

        local u24;

        if u23 == nil then
            u24 = nil;
        else
            u24 = Items[u23];
        end;

        if u24 ~= nil and u23 ~= nil then
            local v25;

            if typeof(v22) == "Instance" then
                v25 = v22:FindFirstChild("RefineLevel");
            else
                v25 = nil;
            end;

            local u26 = v25 == nil and 0 or v25.Value;
            local Multiplier = Series.Multiplier;
            local v27;

            if typeof(v22) == "Instance" then
                v27 = v22;
            else
                v27 = nil;
            end;

            local u28 = Multiplier(v27);
            local v29 = Series.SetOf(u23);
            local u30;

            if typeof(v22) == "Instance" and v29 ~= nil then
                u30 = `Tier {Series.TierOf(v22)}`;
            else
                u30 = nil;
            end;

            local u31;

            if u30 == nil or Series.TierOf(v22) < Series.PassiveTier then
                u31 = nil;
            elseif u24.HasCombat then
                u31 = Series.Passives[v29];
            elseif u24.SeriesCapstone then
                u31 = Series.OutfitPassives[v29];
            else
                u31 = nil;
            end;

            local function scaled(p32: table?, p33: boolean, p34: boolean, p35: boolean?) -- Line: 118
                -- upvalues: CombatBalance (ref), u23 (copy), Refinement (ref), u26 (copy), u28 (copy)
                if type(p32) ~= "table" then
                    return p32;
                end;

                local table_clone_ret = table.clone(p32);

                for i, v in p32 do
                    if type(v) == "number" then
                        local v36;

                        if p35 == true then
                            v36 = CombatBalance.IsWeighted(i);
                        else
                            v36 = false;
                        end;

                        local v37 = not v36 and 1 or CombatBalance.Knob(u23, "Upgrades");
                        local v38 = not p33 and 1 or Refinement.GetStatMultiplier(u23, i, u26);
                        local v39 = not p34 and 1 or u28;

                        if v37 ~= 1 then
                            v38 = 1 + (v38 - 1) * v37;
                            v39 = 1 + (v39 - 1) * v37;
                        end;

                        local v40 = v38 * v39 * (not v36 and 1 or CombatBalance.Knob(u23, "Stats"));
                        local v41;

                        if v40 == 1 then
                            v41 = v;
                        else
                            v41 = math.round(v * v40 * 10000) / 10000;
                        end;

                        table_clone_ret[i] = v41;
                    end;
                end;

                return table_clone_ret;
            end;

            local v42 = {};

            for _, v in u2 do
                local v43 = u24[v.Key];
                local v44;

                if v.Key == "ActiveToolStats" then
                    v44 = true;
                elseif v.Key == "Stats" then
                    v44 = u24.Refinable == true;
                else
                    v44 = false;
                end;

                local v45 = v.Key ~= "ToolbarStats";
                local v46 = linesOf((scaled(v43, v44, v45)));
                local v47 = scaled(v43, v44, v45, true);
                local v48 = v;

                for _, v2 in v46 do
                    local v49;

                    if v47 == nil then
                        v49 = nil;
                    else
                        v49 = v47[v2.stat];
                    end;

                    if type(v49) == "number" and v49 ~= v2.amount then
                        v2.pvp = v49;
                    end;
                end;

                if #v46 > 0 then
                    table.insert(v42, {
                        Header = v48.Header,
                        Lines = v46
                    });
                end;
            end;

            if #v42 == 1 then
                v42[1].Header = "Stats";
            end;

            local v50 = fishingLinesOf((scaled(u24.FishingStats, true, true)));

            if #v50 > 0 then
                table.insert(v42, {
                    Header = "Fishing",
                    Lines = v50
                });
            end;

            local u51 = {};

            local function list(p52: string?, p53: string, p54: boolean?) -- Line: 171
                -- upvalues: CombatBalance (ref), u51 (copy)
                for _, v in CombatBalance.Lines(CombatBalance.Block(p52), p53, p54) do
                    local v55 = {
                        stat = v.Label,
                        amount = v.Share,
                        text = `{math.round(v.Share * 100)}%`
                    };
                    table.insert(u51, v55);
                end;
            end;

            if u24.HasCombat then
                list(u23, "M1 ", true);
            end;

            for _, v in u24.Skills or {} do
                list(v.Name, (`{v.Name} `));
            end;

            if #u51 > 0 then
                table.insert(v42, {
                    Header = "Against players",
                    Lines = u51
                });
            end;

            local u56;

            if u31 == nil then
                u56 = nil;
            else
                u56 = u31.Description;
            end;

            if u31 ~= nil then
                local Name = u31.Name;

                for _, v in CombatBalance.Lines(CombatBalance.Block(Name), (`{Name} `)) do
                    u56 = `{u56}\n{v.Label} against players: {math.round(v.Share * 100)}%`;
                end;
            end;

            if u18 ~= nil then
                local v57 = {};

                for _, v in ItemSources.Get(u23) do
                    local v58 = {
                        amount = false,
                        stat = v.Where
                    };
                    local v59;

                    if v.Chance == nil then
                        v59 = "";
                    else
                        local v60 = math.clamp(v.Chance, 0, 1) * 10000;
                        v59 = `{math.round(v60) / 100}%`;
                    end;

                    v58.text = v59;
                    table.insert(v57, v58);
                end;

                if #v57 > 0 then
                    table.insert(v42, {
                        Header = "Source",
                        Lines = v57
                    });
                end;
            end;

            local function extraRows(p61) -- Line: 217
                -- upvalues: u24 (copy), u21 (copy), u30 (copy), u31 (ref), u56 (ref)
                local v62 = {};
                local v63;

                if u24.Description == nil then
                    v63 = nil;
                else
                    local v64 = u21:Create("TextLabel");
                    local v65 = {
                        Name = "Description",
                        LayoutOrder = 3,
                        BackgroundTransparency = 1,
                        TextWrapped = true,
                        TextTransparency = 0.25,
                        Size = UDim2.fromScale(1, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Font = Enum.Font.SourceSansSemibold
                    };
                    local v66;

                    if u30 == nil then
                        v66 = u24.Description;
                    else
                        v66 = `{u24.Description}\n\n{u30}`;
                    end;

                    v65.Text = v66;
                    v65.TextColor3 = Color3.new(1, 1, 1);
                    v65.TextXAlignment = Enum.TextXAlignment.Left;
                    v65.TextYAlignment = Enum.TextYAlignment.Top;
                    v65.TextSize = p61.bodyTextSize();
                    v63 = v64(v65) or nil;
                end;

                local v67;

                if u24.Description == nil or u24.Class == nil then
                    v67 = nil;
                else
                    v67 = u21:Create("Frame")({
                        Name = "DescriptionGap",
                        LayoutOrder = 4,
                        BackgroundTransparency = 1,
                        Size = p61.rowHeight(p61.SECTION_GAP)
                    }) or nil;
                end;

                local v68;

                if u24.Class == nil then
                    v68 = nil;
                else
                    v68 = u21:Create("TextLabel")({
                        Name = "Class",
                        LayoutOrder = 5,
                        BackgroundTransparency = 1,
                        TextWrapped = true,
                        TextTransparency = 0.25,
                        Size = UDim2.fromScale(1, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Font = Enum.Font.SourceSansSemibold,
                        Text = `Class: {u24.Class}`,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = p61.bodyTextSize()
                    }) or nil;
                end;

                local v69;

                if u31 == nil then
                    v69 = nil;
                else
                    v69 = u21:Create("Frame")({
                        Name = "PassiveGap",
                        LayoutOrder = 6,
                        BackgroundTransparency = 1,
                        Size = p61.rowHeight(p61.SECTION_GAP)
                    }) or nil;
                end;

                local v70;

                if u31 == nil then
                    v70 = nil;
                else
                    v70 = p61.sectionHeader(`Passive: {u31.Name}`, 7) or nil;
                end;

                local v71;

                if u31 == nil then
                    v71 = nil;
                else
                    v71 = u21:Create("TextLabel")({
                        Name = "Passive",
                        LayoutOrder = 8,
                        BackgroundTransparency = 1,
                        TextWrapped = true,
                        TextTransparency = 0.25,
                        Size = UDim2.fromScale(1, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Font = Enum.Font.SourceSansSemibold,
                        Text = u56,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top,
                        TextSize = p61.bodyTextSize()
                    }) or nil;
                end;

                v62[1], v62[2], v62[3], v62[4], v62[5], v62[6] = v63, v67, v68, v69, v70, v71;

                return v62;
            end;

            local v72;

            if u18 == nil then
                v72 = false;
            else
                v72 = p20(u18)[u23] ~= true;
            end;

            local v73 = not v72;

            if v73 then
                if u19 == nil then
                    v73 = false;
                else
                    v73 = p20(u19)[u23] ~= true;
                end;
            end;

            local math_clamp_ret = math.clamp(u24.Rarity or 1, 1, #Rarities.Order);
            local v74 = u21:Create("Frame");
            local v75 = {
                Name = "ItemViewer",
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.new(1, 8, 0, 0),
                Size = u21:Animation(UDim2.fromScale(0.4, 1), u1, {
                    From = UDim2.fromScale(0.36000000000000004, 0.9)
                }),
                BackgroundTransparency = 1
            };
            local v76 = {
                Name = string.gsub(u23, "_", " "),
                Rarity = math_clamp_ret,
                Locked = v72 or (v73 or nil)
            };
            local v77;

            if v73 then
                v77 = BunchaIcons.NotHeld;
            else
                v77 = nil;
            end;

            v76.LockIcon = v77;
            local v78;

            if u24.Unique == true then
                v78 = BunchaIcons.Unique;
            else
                v78 = nil;
            end;

            v76.Mark = v78;

            if u24.Description == nil and (u24.Class == nil and u31 == nil) then
                extraRows = nil;
            end;

            v76.Extra = extraRows;
            v76.Sections = v42;
            v75[1] = DetailPanel(u21, u16, v76);

            return v74(v75);
        end;
    end);
end;