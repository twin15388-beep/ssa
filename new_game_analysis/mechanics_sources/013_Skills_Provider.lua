-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Global = CAM:WaitForChild("Global");
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local Character_info_provider = require(Global:WaitForChild("Character_info_provider"));
local Items = require(Global:WaitForChild("Collectibles"):WaitForChild("Items"));
local ClanSkills = require(CAM:WaitForChild("Clans"):WaitForChild("ClanSkills"));
local FightingStyles = require(Global:WaitForChild("Collectibles"):WaitForChild("FightingStyles"));
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local PlayerProgression = require(ReplicatedStorage.CAM.Global.PlayerProgression);
local Resolve = require(ReplicatedStorage.CAM.Global.Powers.Resolve);
local u1 = game:GetService("RunService"):IsClient();
local u4 = {
    Keys_Changed = simplesignal.new(),

    ModeBarFull = function() -- Line: 37, Name: ModeBarFull
        -- upvalues: Utility (copy), Players (copy)
        local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer);
        local v2 = valuesfolder ~= nil and valuesfolder:FindFirstChild("ModeBar") or nil;
        local v3;

        if v2 == nil then
            v3 = false;
        else
            v3 = v2.Value >= v2.MaxValue;
        end;

        return v3;
    end
};
local u5 = {};

function u4.AuraActive(p6: string) -- Line: 51
    -- upvalues: Utility (copy), Players (copy)
    local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer);
    local v7;

    if valuesfolder == nil then
        v7 = false;
    else
        v7 = valuesfolder:FindFirstChild(p6) ~= nil;
    end;

    return v7;
end;

function u4.IsHeld(p8: string) -- Line: 57
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character;
    local v9;

    if Character == nil then
        v9 = nil;
    else
        v9 = Character:FindFirstChild("SHC") or nil;
    end;

    local v10;

    if v9 == nil then
        v10 = false;
    else
        v10 = v9.Value == p8;
    end;

    return v10;
end;

local Default = Menum.skillState.Default;
local u11 = false;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local LocalPlayer = Players.LocalPlayer;
local Data = Utility.GetData(LocalPlayer, true);
local valuesfolder = Utility.getvaluesfolder(LocalPlayer, true);
local u15 = false;

local function upd_keys() -- Line: 75
    -- upvalues: LocalPlayer (copy), u4 (copy), u15 (ref)
    local Character = LocalPlayer.Character;

    if Character then
        local SHC = Character:FindFirstChild("SHC");

        if SHC and (SHC:GetAttribute("en") == true or SHC.Value ~= "") then
            local Value = SHC.Value;

            if Value ~= "" and SHC:GetAttribute("en") ~= true then
                local v16 = false;

                for _, v in u4.get_current_keys() do
                    if v.Name == Value then
                        v16 = true;
                        break;
                    end;
                end;

                if not v16 then
                    u15 = true;
                    require(script.Parent.Skill_Controller).StopHold(Value);

                    return;
                end;
            end;

            u15 = true;

            return;
        end;
    end;

    u15 = false;
    local _current_keys = u4.get_current_keys();
    u4.Keys_Changed:Fire(_current_keys);
end;

local Items_Config = LocalPlayer:WaitForChild("Items_Config");
Data:WaitForChild("Powers");
Items_Config:WaitForChild("Equipped").Changed:Connect(upd_keys);

for _, child in pairs(Data.Powers:GetChildren()) do
    child.Changed:connect(upd_keys);
end;

for _, child in Data.Inventory.Toolbar:GetChildren() do
    local u17 = child.Name == "One" and 1 or (child.Name == "Two" and 2 or (child.Name == "Three" and 3 or false));
    child.Changed:Connect(function() -- Line: 120
        -- upvalues: u17 (copy), Items_Config (copy), upd_keys (copy)
        if u17 == Items_Config.Equipped.Value then
            upd_keys();
        end;
    end);
end;

local function watchValue(p18: userdata, u19: string) -- Line: 131
    -- upvalues: upd_keys (copy)
    local function bind(p20: userdata) -- Line: 132
        -- upvalues: u19 (copy), upd_keys (ref)
        if p20.Name ~= u19 or not p20:IsA("ValueBase") then
            return;
        end;

        p20:GetPropertyChangedSignal("Value"):Connect(upd_keys);
    end;

    local v21 = p18:FindFirstChild(u19);

    if v21 ~= nil and (v21.Name == u19 and v21:IsA("ValueBase")) then
        v21:GetPropertyChangedSignal("Value"):Connect(upd_keys);
    end;

    p18.ChildAdded:Connect(bind);
end;

local u22 = "Clan";

local function v24(p23: userdata) -- Line: 132
    -- upvalues: u22 (copy), upd_keys (copy)
    if p23.Name ~= u22 or not p23:IsA("ValueBase") then
        return;
    end;

    p23:GetPropertyChangedSignal("Value"):Connect(upd_keys);
end;

local Clan = Data:FindFirstChild("Clan");

if Clan ~= nil and (Clan.Name == "Clan" and Clan:IsA("ValueBase")) then
    Clan:GetPropertyChangedSignal("Value"):Connect(upd_keys);
end;

Data.ChildAdded:Connect(v24);
local u25 = "Race";

local function v27(p26: userdata) -- Line: 132
    -- upvalues: u25 (copy), upd_keys (copy)
    if p26.Name ~= u25 or not p26:IsA("ValueBase") then
        return;
    end;

    p26:GetPropertyChangedSignal("Value"):Connect(upd_keys);
end;

local Race = Data:FindFirstChild("Race");

if Race ~= nil and (Race.Name == "Race" and Race:IsA("ValueBase")) then
    Race:GetPropertyChangedSignal("Value"):Connect(upd_keys);
end;

Data.ChildAdded:Connect(v27);
local Progression = Data:WaitForChild("Progression", 10);

if Progression ~= nil then
    for _, v in PlayerProgression.Sides do
        local v28 = Progression:WaitForChild(v, 10);

        if v28 ~= nil then
            local u29 = "Max";

            local function v31(p30: userdata) -- Line: 132
                -- upvalues: u29 (copy), upd_keys (copy)
                if p30.Name ~= u29 or not p30:IsA("ValueBase") then
                    return;
                end;

                p30:GetPropertyChangedSignal("Value"):Connect(upd_keys);
            end;

            local Max = v28:FindFirstChild("Max");

            if Max ~= nil and (Max.Name == "Max" and Max:IsA("ValueBase")) then
                Max:GetPropertyChangedSignal("Value"):Connect(upd_keys);
            end;

            v28.ChildAdded:Connect(v31);
        end;
    end;
end;

local u32 = false;

local function bindModeBar(u33: userdata, p34: boolean?) -- Line: 156
    -- upvalues: u32 (ref), upd_keys (copy)
    if u33.Name ~= "ModeBar" or not u33:IsA("IntConstrainedValue") then
        return;
    end;

    u32 = u33.Value >= u33.MaxValue;
    u33.Changed:Connect(function() -- Line: 159
        -- upvalues: u33 (copy), u32 (ref), upd_keys (ref)
        local v35 = u33.Value >= u33.MaxValue;

        if v35 == u32 then
            return;
        end;

        u32 = v35;
        upd_keys();
    end);

    if p34 then
        upd_keys();
    end;
end;

local ModeBar = valuesfolder:FindFirstChild("ModeBar");

if ModeBar ~= nil and (ModeBar.Name == "ModeBar" and ModeBar:IsA("IntConstrainedValue")) then
    if ModeBar.Value >= ModeBar.MaxValue then
        u32 = true;
    else
        u32 = false;
    end;

    ModeBar.Changed:Connect(function() -- Line: 159
        -- upvalues: ModeBar (copy), u32 (ref), upd_keys (copy)
        local v36 = ModeBar.Value >= ModeBar.MaxValue;

        if v36 == u32 then
            return;
        end;

        u32 = v36;
        upd_keys();
    end);
end;

valuesfolder.ChildAdded:Connect(function(p37: userdata) -- Line: 169
    -- upvalues: bindModeBar (copy), u5 (copy), upd_keys (copy)
    bindModeBar(p37, true);

    if u5[p37.Name] then
        upd_keys();
    end;
end);
valuesfolder.ChildRemoved:Connect(function(p38) -- Line: 174
    -- upvalues: u32 (ref), upd_keys (copy), u5 (copy)
    if p38.Name == "ModeBar" then
        u32 = false;
        upd_keys();
    end;

    if u5[p38.Name] then
        upd_keys();
    end;
end);
local u39 = cleanit.new();
local u40 = 0;

function UpdDMG()
    -- upvalues: u39 (copy), u40 (ref), valuesfolder (copy), Utility (copy), Default (ref), u11 (ref), upd_keys (copy)
    u39:Clean();
    u40 = 0;
    local DMG = valuesfolder:FindFirstChild("DMG");

    local function UpdDMGState() -- Line: 192
        -- upvalues: u40 (ref), DMG (copy), Utility (ref), UpdDMGState (copy), Default (ref), u11 (ref), upd_keys (ref)
        local math_random_ret = math.random(1, 999);
        u40 = math_random_ret;
        local v41 = nil;

        if DMG ~= nil and DMG:GetAttribute("EngagedUsing") == "Fist" then
            local v42 = Utility.Tick() - DMG:GetAttribute("LastEngaged");

            if v42 < 2 then
                task.delay(2 - v42, function() -- Line: 201
                    -- upvalues: math_random_ret (copy), u40 (ref), UpdDMGState (ref)
                    if math_random_ret == u40 then
                        UpdDMGState();
                    end;
                end);
                v41 = true;
            end;
        end;

        if Default ~= v41 then
            Default = v41;

            if u11 then
                upd_keys();
            end;
        end;
    end;

    UpdDMGState();
    u39:Connect(DMG:GetAttributeChangedSignal("AttackerUsed"), UpdDMGState);
    u39:Connect(DMG:GetAttributeChangedSignal("EngagedUsing"), UpdDMGState);
    u39:Connect(DMG:GetAttributeChangedSignal("LastEngaged"), UpdDMGState);
end;

if valuesfolder:FindFirstChild("DMG") ~= nil then
    UpdDMG();
end;

local function updCustomState() -- Line: 224
    -- upvalues: valuesfolder (copy), u14 (ref), u13 (ref), upd_keys (copy)
    local v43, v44;

    if valuesfolder:FindFirstChild("CustomSkillState") == nil then
        v43 = nil;
        v44 = nil;
    else
        v43 = "";
        v44 = {};

        for _, v in ipairs(valuesfolder:QueryDescendants("#CustomSkillState")) do
            local Attribute = v:GetAttribute("Skill");
            local Value = v.Value;
            v43 = v43 .. Attribute .. Value;
            v44[Attribute] = Value;
        end;
    end;

    if v43 ~= u14 then
        u14 = v43;
        u13 = v44;
        upd_keys();
    end;
end;

valuesfolder.ChildAdded:Connect(function(p45) -- Line: 243
    -- upvalues: updCustomState (copy)
    if p45.Name == "DMG" then
        UpdDMG();

        return;
    end;

    if p45.Name == "CustomSkillState" then
        updCustomState();
    end;
end);
valuesfolder.ChildRemoved:Connect(function(p46) -- Line: 250
    -- upvalues: updCustomState (copy)
    if p46.Name == "CustomSkillState" then
        updCustomState();
    end;
end);

local function updChar(u47: userdata) -- Line: 256
    -- upvalues: u12 (ref), upd_keys (copy), u15 (ref)
    local HumanoidRootPart = u47:WaitForChild("HumanoidRootPart", 3);

    if HumanoidRootPart == nil then
        return;
    end;

    u12 = false;
    local u48 = false;

    local function updv() -- Line: 261
        -- upvalues: u48 (ref), HumanoidRootPart (copy), u12 (ref), upd_keys (ref)
        local v49 = not u48 and HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil;

        if v49 ~= u12 then
            u12 = v49;
            upd_keys();
        end;
    end;

    local u50 = nil;

    local function updSHC() -- Line: 269
        -- upvalues: u50 (ref), u47 (copy), u48 (ref), HumanoidRootPart (copy), u12 (ref), upd_keys (ref), u15 (ref)
        if u50 ~= nil then
            u50:Disconnect();
        end;

        local SHC = u47.SHC;
        SHC.Changed:Connect(function(p51) -- Line: 274
            -- upvalues: u48 (ref), HumanoidRootPart (ref), u12 (ref), upd_keys (ref), u15 (ref)
            local v52 = p51 ~= "";

            if u48 ~= v52 then
                u48 = v52;
                local v53 = not u48 and HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil;

                if v53 ~= u12 then
                    u12 = v53;
                    upd_keys();
                end;
            end;

            if not v52 and u15 then
                upd_keys();
            end;
        end);
        SHC:GetAttributeChangedSignal("en"):Connect(function() -- Line: 284
            -- upvalues: SHC (copy), u15 (ref), upd_keys (ref)
            if SHC:GetAttribute("en") ~= true and (SHC.Value == "" and u15) then
                upd_keys();
            end;
        end);
    end;

    if u47:FindFirstChild("SHC") == nil then
        u50 = u47.ChildAdded:Connect(function(p54: userdata) -- Line: 293
            -- upvalues: updSHC (copy)
            if p54.Name == "SHC" then
                updSHC();
            end;
        end);
    else
        updSHC();
    end;

    HumanoidRootPart.ChildAdded:Connect(function(p55) -- Line: 299
        -- upvalues: u48 (ref), HumanoidRootPart (copy), u12 (ref), upd_keys (ref)
        if p55.Name == "air_combo_bp" then
            local v56 = not u48 and HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil;

            if v56 ~= u12 then
                u12 = v56;
                upd_keys();
            end;
        end;
    end);
    HumanoidRootPart.ChildRemoved:Connect(function(p57) -- Line: 304
        -- upvalues: u48 (ref), HumanoidRootPart (copy), u12 (ref), upd_keys (ref)
        if p57.Name == "air_combo_bp" then
            local v58 = not u48 and HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil;

            if v58 ~= u12 then
                u12 = v58;
                upd_keys();
            end;
        end;
    end);
end;

if LocalPlayer.Character ~= nil then
    updChar(LocalPlayer.Character);
end;

LocalPlayer.CharacterAdded:Connect(updChar);
local u59 = {
    DemonArt = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Powers"):WaitForChild("DemonArts")),
    Breathing = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Powers"):WaitForChild("Breathings"))
};
local table_find = table.find;
local table_insert = table.insert;

function u4.get_current_keys(p60) -- Line: 324
    -- upvalues: Players (copy), Utility (copy), Character_info_provider (copy), Items (copy), FightingStyles (copy), u59 (copy), Resolve (copy), u12 (ref), Menum (copy), Default (ref), u13 (ref), table_insert (copy), ClanSkills (copy), u4 (copy), u5 (copy), table_find (copy), PlayerProgression (copy), u11 (ref), u1 (copy)
    local v61 = false;
    local v62 = "";
    local LocalPlayer2 = Players.LocalPlayer;
    local Data2 = Utility.GetData(LocalPlayer2, true);
    local _equipped_tool = Character_info_provider.Get_equipped_tool(LocalPlayer2);
    local v63 = {};
    local v64 = {};
    local v65;

    if _equipped_tool and Items[_equipped_tool.Name] then
        local v66 = Items[_equipped_tool.Name];

        if v66 ~= nil then
            local v67 = v66.Breathing and "Breathing" or (v66.DemonArt and "DemonArt" or nil);

            if v67 ~= nil then
                local Race2 = Data2:FindFirstChild("Race");

                if Race2 then
                    Race2 = Race2.Value;
                end;

                local v68;

                if v67 == "Breathing" and (Race2 == "Human" or (Race2 == "Slayer" or Race2 == "Hybrid")) then
                    v68 = true;
                elseif v67 == "DemonArt" then
                    v68 = Race2 == "Demon" and true or Race2 == "Hybrid";
                else
                    v68 = false;
                end;

                if not v68 then
                    v67 = nil;
                end;
            end;

            if v67 ~= nil and v66[v67] ~= nil then
                local v69 = v66[v67];

                if _equipped_tool.Name == FightingStyles.TOOL_NAME then
                    local _, v70 = FightingStyles.For(LocalPlayer2);

                    if v70 ~= nil and v70[v67] ~= nil then
                        v69 = v70[v67];
                    end;
                end;

                local v71;

                if u59[v67] == nil then
                    v71 = nil;
                else
                    v71 = u59[v67][Data2.Powers[v67].Value] or nil;
                end;

                local v72;

                if type(v71) == "table" then
                    v72 = v71.CustomPower == true;
                else
                    v72 = false;
                end;

                if (v72 or Resolve.LaneCarries(v69, Data2.Powers[v67].Value)) and (v71 ~= nil and (v71.Category == nil or v71.Category == v66.Category) and (v71 and Data2.Powers:FindFirstChild(v67))) then
                    for _, v in pairs(v71.Skills or {}) do
                        if v.ToolCategory == nil or v.ToolCategory == v66.Category then
                            if v.State == true then
                                table_insert(v63, u12 and v[Menum.skillState.Air] or Default and v[Menum.skillState.Combat] or (u13 and u13[v.Name] and v[u13[v.Name]] or v[Menum.skillState.Default]));
                                v61 = true;
                            else
                                table_insert(v63, v);
                            end;
                        end;
                    end;

                    v62 = Data2.Powers[v67].Value;
                    v64[v67] = true;
                end;
            end;
        end;

        local Skills = Items[_equipped_tool.Name].Skills;

        if _equipped_tool.Name == ClanSkills.TOOL_NAME then
            local Clan2 = Data2:FindFirstChild("Clan");
            local v73;

            if Clan2 == nil then
                v73 = nil;
            else
                v73 = Clan2.Value or nil;
            end;

            Skills = ClanSkills.SkillsFor(v73, Players.LocalPlayer);
        end;

        if _equipped_tool.Name == FightingStyles.TOOL_NAME then
            local v74;
            v65, v74 = FightingStyles.For(Players.LocalPlayer);

            if v74 == nil then
                v65 = v62;
            else
                Skills = v74.Skills;

                if #v62 ~= 0 then
                    v65 = `{v62},{v65}`;
                end;
            end;
        else
            v65 = v62;
        end;

        local v75 = {};

        for _, v in pairs(v63) do
            table_insert(v75, v.Name);
        end;

        if Skills == nil then
            table.clear(v75);
        else
            if #v65 == 0 then
                v65 = _equipped_tool.Name;
            else
                v65 = v65 .. `,{_equipped_tool.Name}`;
            end;

            local v76 = #v63 > 0;
            local v77 = true;

            for _, v in pairs(Skills) do
                if v.RequiresModeBar ~= true or (u4.ModeBarFull() or u4.IsHeld(v.Name)) then
                    local v78, v79, v80, v81;

                    if v.RequiresAura == nil then
                        if table_find(v75, v.Name) == nil and (not v76 or v.Name ~= "Blocking") then
                            if v.State == true then
                                v78 = u12 and v[Menum.skillState.Air] or Default and v[Menum.skillState.Combat] or (u13 and u13[v.Name] and v[u13[v.Name]] or v[Menum.skillState.Default]);
                                v61 = true;
                            else
                                v78 = v;
                            end;

                            if v77 then
                                v79 = #v63;

                                if v79 > 0 then
                                    v80 = table.clone(v63[v79]);
                                    v80.SplitHere = 1;
                                    v63[v79] = v80;
                                end;

                                if v76 then
                                    v81 = table.clone(v78);
                                    v81.SplitHere = 2;
                                    table_insert(v63, v81);
                                else
                                    table_insert(v63, v78);
                                end;

                                v77 = false;
                            else
                                table_insert(v63, v78);
                            end;
                        end;
                    else
                        u5[v.RequiresAura] = true;

                        if u4.AuraActive(v.RequiresAura) or u4.IsHeld(v.Name) then
                            if table_find(v75, v.Name) == nil and (not v76 or v.Name ~= "Blocking") then
                                if v.State == true then
                                    v78 = u12 and v[Menum.skillState.Air] or Default and v[Menum.skillState.Combat] or (u13 and u13[v.Name] and v[u13[v.Name]] or v[Menum.skillState.Default]);
                                    v61 = true;
                                else
                                    v78 = v;
                                end;

                                if v77 then
                                    v79 = #v63;

                                    if v79 > 0 then
                                        v80 = table.clone(v63[v79]);
                                        v80.SplitHere = 1;
                                        v63[v79] = v80;
                                    end;

                                    if v76 then
                                        v81 = table.clone(v78);
                                        v81.SplitHere = 2;
                                        table_insert(v63, v81);
                                    else
                                        table_insert(v63, v78);
                                    end;

                                    v77 = false;
                                else
                                    table_insert(v63, v78);
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            table.clear(v75);
        end;
    else
        v65 = v62;
    end;

    for i, v in PlayerProgression.GrantedSkills do
        if v64[v.Side == "Slayer" and "Breathing" or "DemonArt"] and PlayerProgression.HasGrantedSkill(LocalPlayer2, i) then
            table_insert(v63, v.Skill);
        end;
    end;

    script.CurPower.Value = v65;
    u11 = v61;
    local v82 = #v63;

    if u1 and game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.HUD.Skills.Value < v82 then
        game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.HUD.Skills.Value = v82;
    end;

    return v63;
end;

return u4;