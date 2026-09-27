-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ContentProvider = game:GetService("ContentProvider");
local StarterGui = game:GetService("StarterGui");
local Players = game:GetService("Players");
require(script.Types);
local u1 = script;
local Reference = require(u1.Reference);
local Object = Reference.getObject();
local v2;

if Object then
    v2 = Object.Value;
else
    v2 = Object;
end;

if v2 and v2 ~= u1 then
    return require(v2);
end;

if not Object then
    Reference.addToReplicatedStorage();
end;

local GoodSignal = require(u1.Packages.GoodSignal);
local Janitor = require(u1.Packages.Janitor);
local Utility = require(u1.Utility);
local Themes = require(u1.Features.Themes);
local Gamepad = require(u1.Features.Gamepad);
local Overflow = require(u1.Features.Overflow);
local u3 = {};
u3.__index = u3;
local LocalPlayer = Players.LocalPlayer;
local Themes2 = u1.Features.Themes;
local u4 = {};
local u5 = GoodSignal.new();
local Elements = u1.Elements;
local u6 = 0;
local u7 = {
    mobile = Enum.PreferredInput.Touch,
    desktop = Enum.PreferredInput.KeyboardAndMouse,
    console = Enum.PreferredInput.Gamepad
};
u3.baseDisplayOrderChanged = GoodSignal.new();
u3.baseDisplayOrder = 10;
u3.baseTheme = require(Themes2.Default);
u3.isOldTopbar = false;
u3.iconsDictionary = u4;
u3.insetHeightChanged = GoodSignal.new();
u3.container = require(Elements.Container)(u3);
u3.topbarEnabled = true;
u3.iconAdded = GoodSignal.new();
u3.iconRemoved = GoodSignal.new();
u3.iconChanged = GoodSignal.new();

function u3.getIcons() -- Line: 110
    -- upvalues: u3 (copy)
    return u3.iconsDictionary;
end;

function u3.getIconByUID(p8) -- Line: 114
    -- upvalues: u3 (copy)
    return u3.iconsDictionary[p8] or nil;
end;

function u3.getIcon(p9) -- Line: 122
    -- upvalues: u3 (copy), u4 (copy)
    local IconByUID = u3.getIconByUID(p9);

    if IconByUID then
        return IconByUID;
    end;

    for _, v in pairs(u4) do
        if v.name == p9 then
            return v;
        end;
    end;

    return nil;
end;

function u3.setTopbarEnabled(p10, p11) -- Line: 135
    -- upvalues: u3 (copy)
    if typeof(p10) ~= "boolean" then
        p10 = u3.topbarEnabled;
    end;

    if not p11 then
        u3.topbarEnabled = p10;
    end;

    for _, v in pairs(u3.container) do
        v.Enabled = p10;
    end;
end;

function u3.modifyBaseTheme(p12) -- Line: 147
    -- upvalues: Themes (copy), u3 (copy), u4 (copy)
    local Modifications = Themes.getModifications(p12);

    for _, v in pairs(Modifications) do
        local v13 = v;

        for _, v3 in pairs(u3.baseTheme) do
            Themes.merge(v3, v13);
        end;
    end;

    for _, v in pairs(u4) do
        v:setTheme(u3.baseTheme);
    end;
end;

function u3.setDisplayOrder(p14) -- Line: 159
    -- upvalues: u3 (copy)
    u3.baseDisplayOrder = p14;
    u3.baseDisplayOrderChanged:Fire(p14);
end;

task.defer(Gamepad.start, u3);
task.defer(Overflow.start, u3);
task.defer(function() -- Line: 169
    -- upvalues: LocalPlayer (copy), u3 (copy), u1 (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

    for _, v in pairs(u3.container) do
        v.Parent = PlayerGui;
    end;

    require(u1.Attribute);
end);

function u3.new() -- Line: 180
    -- upvalues: u3 (copy), Janitor (copy), Utility (copy), u4 (copy), GoodSignal (copy), u1 (copy), Elements (copy), u6 (ref), UserInputService (copy), u7 (copy), u5 (copy), StarterGui (copy)
    local u15 = {};
    setmetatable(u15, u3);
    local v16 = Janitor.new();
    u15.janitor = v16;
    u15.themesJanitor = v16:add(Janitor.new());
    u15.singleClickJanitor = v16:add(Janitor.new());
    u15.captionJanitor = v16:add(Janitor.new());
    u15.joinJanitor = v16:add(Janitor.new());
    u15.menuJanitor = v16:add(Janitor.new());
    u15.dropdownJanitor = v16:add(Janitor.new());
    local u17 = Utility.generateUID();
    u4[u17] = u15;
    v16:add(function() -- Line: 197
        -- upvalues: u4 (ref), u17 (copy)
        u4[u17] = nil;
    end);
    u15.selected = v16:add(GoodSignal.new());
    u15.deselected = v16:add(GoodSignal.new());
    u15.toggled = v16:add(GoodSignal.new());
    u15.viewingStarted = v16:add(GoodSignal.new());
    u15.viewingEnded = v16:add(GoodSignal.new());
    u15.stateChanged = v16:add(GoodSignal.new());
    u15.notified = v16:add(GoodSignal.new());
    u15.noticeStarted = v16:add(GoodSignal.new());
    u15.noticeChanged = v16:add(GoodSignal.new());
    u15.endNotices = v16:add(GoodSignal.new());
    u15.toggleKeyAdded = v16:add(GoodSignal.new());
    u15.fakeToggleKeyChanged = v16:add(GoodSignal.new());
    u15.alignmentChanged = v16:add(GoodSignal.new());
    u15.updateSize = v16:add(GoodSignal.new());
    u15.resizingComplete = v16:add(GoodSignal.new());
    u15.joinedParent = v16:add(GoodSignal.new());
    u15.menuSet = v16:add(GoodSignal.new());
    u15.dropdownSet = v16:add(GoodSignal.new());
    u15.updateMenu = v16:add(GoodSignal.new());
    u15.startMenuUpdate = v16:add(GoodSignal.new());
    u15.childThemeModified = v16:add(GoodSignal.new());
    u15.indicatorSet = v16:add(GoodSignal.new());
    u15.dropdownChildAdded = v16:add(GoodSignal.new());
    u15.menuChildAdded = v16:add(GoodSignal.new());
    u15.iconModule = u1;
    u15.UID = u17;
    u15.isEnabled = true;
    u15.enabled = u15.isEnabled;
    u15.isSelected = false;
    u15.isViewing = false;
    u15.joinedFrame = false;
    u15.parentIconUID = false;
    u15.deselectWhenOtherIconSelected = true;
    u15.totalNotices = 0;
    u15.activeState = "Deselected";
    u15.alignment = "";
    u15.originalAlignment = "";
    u15.appliedTheme = {};
    u15.appearance = {};
    u15.cachedInstances = {};
    u15.cachedNamesToInstances = {};
    u15.cachedCollectives = {};
    u15.bindedToggleKeys = {};
    u15.customBehaviours = {};
    u15.toggleItems = {};
    u15.bindedEvents = {};
    u15.notices = {};
    u15.menuIcons = {};
    u15.dropdownIcons = {};
    u15.childIconsDict = {};
    u15.creationTime = os.clock();
    u15.widget = v16:add(require(Elements.Widget)(u15, u3));
    u15:setAlignment();
    u6 = u6 + 1;
    local v18 = u6 * 0.01 + 1;
    u15:setOrder(v18, "deselected");
    u15:setOrder(v18, "selected");
    u15:setTheme(u3.baseTheme);
    local Instance = u15:getInstance("ClickRegion");
    local u19 = false;
    local u20 = 0;

    local function handleToggle() -- Line: 277
        -- upvalues: u15 (copy), u20 (ref)
        if u15.locked then
            return;
        end;

        local v21 = tick();

        if v21 - u20 < 0.1 then
            return;
        end;

        u20 = v21;

        if u15.isSelected then
            u15:deselect("User", u15);

            return;
        end;

        u15:select("User", u15);
    end;

    Instance.MouseButton1Click:Connect(function() -- Line: 296
        -- upvalues: u19 (ref), u15 (copy), u20 (ref)
        u19 = true;

        if u15.locked then
            return;
        end;

        local v22 = tick();

        if v22 - u20 < 0.1 then
            return;
        end;

        u20 = v22;

        if u15.isSelected then
            u15:deselect("User", u15);

            return;
        end;

        u15:select("User", u15);
    end);
    Instance.TouchTap:Connect(function() -- Line: 301
        -- upvalues: u19 (ref), u15 (copy), u20 (ref)
        if not u19 then
            if u15.locked then
                return;
            end;

            local v23 = tick();

            if v23 - u20 < 0.1 then
                return;
            end;

            u20 = v23;

            if u15.isSelected then
                u15:deselect("User", u15);

                return;
            end;

            u15:select("User", u15);
        end;
    end);
    v16:add(UserInputService.InputBegan:Connect(function(p24, p25) -- Line: 314
        -- upvalues: u15 (copy), u20 (ref)
        if u15.locked then
            return;
        end;

        if u15.bindedToggleKeys[p24.KeyCode] and not p25 then
            if u15.locked then
                return;
            end;

            local v26 = tick();

            if v26 - u20 < 0.1 then
                return;
            end;

            u20 = v26;

            if u15.isSelected then
                u15:deselect("User", u15);

                return;
            end;

            u15:select("User", u15);
        end;
    end));

    local function viewingEnded() -- Line: 336
        -- upvalues: u15 (copy)
        if u15.locked then
            return;
        end;

        u15.isViewing = false;
        u15.viewingEnded:Fire(true);
        u15:setState(nil, "User", u15);
    end;

    u15.joinedParent:Connect(function() -- Line: 344
        -- upvalues: u15 (copy)
        if u15.isViewing then
            if u15.locked then
                return;
            end;

            u15.isViewing = false;
            u15.viewingEnded:Fire(true);
            u15:setState(nil, "User", u15);
        end;
    end);
    Instance.MouseEnter:Connect(function() -- Line: 349
        -- upvalues: UserInputService (ref), u7 (ref), u15 (copy)
        local v27 = UserInputService.PreferredInput ~= u7.desktop;

        if u15.locked then
            return;
        end;

        u15.isViewing = true;
        u15.viewingStarted:Fire(true);

        if not v27 then
            u15:setState("Viewing", "User", u15);
        end;
    end);
    local u28 = 0;
    v16:add(UserInputService.TouchEnded:Connect(viewingEnded));
    Instance.MouseLeave:Connect(viewingEnded);
    Instance.SelectionGained:Connect(function(p29) -- Line: 326, Name: viewingStarted
        -- upvalues: u15 (copy)
        if u15.locked then
            return;
        end;

        u15.isViewing = true;
        u15.viewingStarted:Fire(true);

        if not p29 then
            u15:setState("Viewing", "User", u15);
        end;
    end);
    Instance.SelectionLost:Connect(viewingEnded);
    Instance.MouseButton1Down:Connect(function() -- Line: 358
        -- upvalues: u15 (copy), UserInputService (ref), u7 (ref), u28 (ref)
        if not u15.locked and UserInputService.PreferredInput == u7.mobile then
            u28 = u28 + 1;
            local u30 = u28;
            task.delay(0.2, function() -- Line: 362
                -- upvalues: u30 (copy), u28 (ref), u15 (ref)
                if u30 == u28 then
                    if u15.locked then
                        return;
                    end;

                    u15.isViewing = true;
                    u15.viewingStarted:Fire(true);
                    u15:setState("Viewing", "User", u15);
                end;
            end);
        end;
    end);
    Instance.MouseButton1Up:Connect(function() -- Line: 369
        -- upvalues: u28 (ref)
        u28 = u28 + 1;
    end);
    local Instance2 = u15:getInstance("IconOverlay");
    u15.viewingStarted:Connect(function() -- Line: 375
        -- upvalues: Instance2 (copy), u15 (copy)
        Instance2.Visible = not u15.overlayDisabled;
    end);
    u15.viewingEnded:Connect(function() -- Line: 378
        -- upvalues: Instance2 (copy)
        Instance2.Visible = false;
    end);
    v16:add(u5:Connect(function(p31) -- Line: 383
        -- upvalues: u15 (copy)
        if p31 ~= u15 and (u15.deselectWhenOtherIconSelected and p31.deselectWhenOtherIconSelected) then
            u15:deselect("AutoDeselect", p31);
        end;
    end));
    local debug_info_ret = debug.info(2, "s");
    local string_split_ret = string.split(debug_info_ret, ".");
    local v32 = game;
    local v33 = nil;

    for _, v in pairs(string_split_ret) do
        v32 = v32:FindFirstChild(v);

        if not v32 then
            break;
        end;

        if v32:IsA("ScreenGui") then
            v33 = v32;
        end;
    end;

    if v32 and (v33 and v33.ResetOnSpawn == true) then
        u15.originsScreenGui = v33;
        Utility.localPlayerRespawned(function() -- Line: 409
            -- upvalues: u15 (copy)
            u15:destroy();
        end);
    end;

    u15.toggled:Connect(function(p34) -- Line: 415
        -- upvalues: u15 (copy), u3 (ref)
        u15.noticeChanged:Fire(u15.totalNotices);

        for i, _ in pairs(u15.childIconsDict) do
            local IconByUID = u3.getIconByUID(i);
            IconByUID.noticeChanged:Fire(IconByUID.totalNotices);

            if not p34 and IconByUID.isSelected then
                for _, _ in pairs(IconByUID.childIconsDict) do
                    IconByUID:deselect("HideParentFeature", u15);
                end;
            end;
        end;
    end);
    u15.selected:Connect(function() -- Line: 438
        -- upvalues: u15 (copy), StarterGui (ref)
        if #u15.dropdownIcons > 0 then
            if StarterGui:GetCore("ChatActive") and u15.alignment ~= "Right" then
                u15.chatWasPreviouslyActive = true;
                StarterGui:SetCore("ChatActive", false);
            end;

            if StarterGui:GetCoreGuiEnabled("PlayerList") and u15.alignment ~= "Left" then
                u15.playerlistWasPreviouslyActive = true;
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
            end;
        end;
    end);
    u15.deselected:Connect(function() -- Line: 451
        -- upvalues: u15 (copy), StarterGui (ref)
        if u15.chatWasPreviouslyActive then
            u15.chatWasPreviouslyActive = nil;
            StarterGui:SetCore("ChatActive", true);
        end;

        if u15.playerlistWasPreviouslyActive then
            u15.playerlistWasPreviouslyActive = nil;
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true);
        end;
    end);
    task.delay(0.1, function() -- Line: 465
        -- upvalues: u15 (copy)
        if u15.activeState == "Deselected" then
            u15.stateChanged:Fire("Deselected");
            u15:refresh();
        end;
    end);
    u3.iconAdded:Fire(u15);

    return u15;
end;

function u3.setName(p35, p36) -- Line: 481
    p35.widget.Name = p36;
    p35.name = p36;

    return p35;
end;

function u3.setState(p37, p38, p39, p40) -- Line: 487
    -- upvalues: Utility (copy), u5 (copy)
    local v41 = Utility.formatStateName(p38 or (p37.isSelected and "Selected" or "Deselected"));

    if p37.activeState == v41 then
        return;
    end;

    local isSelected = p37.isSelected;
    p37.activeState = v41;

    if v41 == "Deselected" then
        p37.isSelected = false;

        if isSelected then
            p37.toggled:Fire(false, p39, p40);
            p37.deselected:Fire(p39, p40);
        end;

        p37:_setToggleItemsVisible(false, p39, p40);
    elseif v41 == "Selected" then
        p37.isSelected = true;

        if not isSelected then
            p37.toggled:Fire(true, p39, p40);
            p37.selected:Fire(p39, p40);
            u5:Fire(p37, p39, p40);
        end;

        p37:_setToggleItemsVisible(true, p39, p40);
    end;

    p37.stateChanged:Fire(v41, p39, p40);
end;

function u3.getInstance(u42, u43) -- Line: 520
    -- upvalues: Themes (copy)
    local v44 = u42.cachedNamesToInstances[u43];

    if v44 then
        return v44;
    end;

    local function cacheInstance(u45, u46) -- Line: 528
        -- upvalues: u42 (copy)
        if not u42.cachedInstances[u46] then
            local Attribute = u46:GetAttribute("Collective");

            if Attribute then
                Attribute = u42.cachedCollectives[Attribute];
            end;

            if Attribute then
                table.insert(Attribute, u46);
            end;

            u42.cachedNamesToInstances[u45] = u46;
            u42.cachedInstances[u46] = true;
            u46.Destroying:Once(function() -- Line: 538
                -- upvalues: u42 (ref), u45 (copy), u46 (copy)
                u42.cachedNamesToInstances[u45] = nil;
                u42.cachedInstances[u46] = nil;
            end);
        end;
    end;

    local widget = u42.widget;
    cacheInstance("Widget", widget);

    if u43 == "Widget" then
        return widget;
    end;

    local u47 = nil;

    local function scanChildren(p48) -- Line: 551
        -- upvalues: u42 (copy), Themes (ref), scanChildren (copy), cacheInstance (copy), u43 (copy), u47 (ref)
        for _, child in pairs(p48:GetChildren()) do
            local Attribute = child:GetAttribute("WidgetUID");

            if not Attribute or Attribute == u42.UID then
                local v49 = Themes.getRealInstance(child) or child;
                scanChildren(v49);

                if v49:IsA("GuiBase") or (v49:IsA("UIBase") or v49:IsA("ValueBase")) then
                    local Name = v49.Name;
                    cacheInstance(Name, v49);

                    if Name == u43 then
                        u47 = v49;
                    end;
                end;
            end;
        end;
    end;

    scanChildren(widget);

    return u47;
end;

function u3.getCollective(p50, p51) -- Line: 580
    local v52 = p50.cachedCollectives[p51];

    if v52 then
        return v52;
    end;

    local v53 = {};

    for i, _ in pairs(p50.cachedInstances) do
        if i:GetAttribute("Collective") == p51 then
            table.insert(v53, i);
        end;
    end;

    p50.cachedCollectives[p51] = v53;

    return v53;
end;

function u3.getInstanceOrCollective(p54, p55) -- Line: 601
    local v56 = {};
    local Instance = p54:getInstance(p55);

    if Instance then
        table.insert(v56, Instance);
    end;

    if #v56 == 0 then
        v56 = p54:getCollective(p55);
    end;

    return v56;
end;

function u3.getStateGroup(p57, p58) -- Line: 615
    local v59 = p58 or p57.activeState;
    local v60 = p57.appearance[v59];

    if not v60 then
        v60 = {};
        p57.appearance[v59] = v60;
    end;

    return v60;
end;

function u3.refreshAppearance(p61, p62, p63) -- Line: 625
    -- upvalues: Themes (copy)
    Themes.refresh(p61, p62, p63);

    return p61;
end;

function u3.refresh(p64) -- Line: 630
    p64:refreshAppearance(p64.widget);
    p64.updateSize:Fire();

    return p64;
end;

function u3.updateParent(p65) -- Line: 636
    -- upvalues: u3 (copy)
    local IconByUID = u3.getIconByUID(p65.parentIconUID);

    if IconByUID then
        IconByUID.updateSize:Fire();
    end;
end;

function u3.setBehaviour(p66, p67, p68, p69, p70) -- Line: 643
    p66.customBehaviours[p67 .. "-" .. p68] = p69;

    if p70 then
        local InstanceOrCollective = p66:getInstanceOrCollective(p67);

        for _, v in pairs(InstanceOrCollective) do
            p66:refreshAppearance(v, p68);
        end;
    end;
end;

function u3.modifyTheme(p71, p72, p73) -- Line: 656
    -- upvalues: Themes (copy)
    return p71, Themes.modify(p71, p72, p73);
end;

function u3.modifyChildTheme(p74, p75, p76) -- Line: 661
    -- upvalues: u3 (copy)
    p74.childModifications = p75;
    p74.childModificationsUID = p76;

    for i, _ in pairs(p74.childIconsDict) do
        u3.getIconByUID(i):modifyTheme(p75, p76);
    end;

    p74.childThemeModified:Fire();

    return p74;
end;

function u3.removeModification(p77, p78) -- Line: 674
    -- upvalues: Themes (copy)
    Themes.remove(p77, p78);

    return p77;
end;

function u3.removeModificationWith(p79, p80, p81, p82) -- Line: 679
    -- upvalues: Themes (copy)
    Themes.removeWith(p79, p80, p81, p82);

    return p79;
end;

function u3.setTheme(p83, p84) -- Line: 684
    -- upvalues: Themes (copy)
    Themes.set(p83, p84);

    return p83;
end;

function u3.setEnabled(p85, p86) -- Line: 689
    p85.isEnabled = p86;
    p85.enabled = p85.isEnabled;
    p85.widget.Visible = p86;
    p85:updateParent();

    return p85;
end;

function u3.select(p87, p88, p89) -- Line: 697
    p87:setState("Selected", p88, p89);

    return p87;
end;

function u3.deselect(p90, p91, p92) -- Line: 702
    p90:setState("Deselected", p91, p92);

    return p90;
end;

function u3.notify(p93, p94, p95) -- Line: 707
    -- upvalues: Elements (copy), u3 (copy)
    if not p93.notice then
        p93.notice = require(Elements.Notice)(p93, u3);
    end;

    p93.noticeStarted:Fire(p94, p95);

    return p93;
end;

function u3.clearNotices(p96) -- Line: 721
    p96.endNotices:Fire();

    return p96;
end;

function u3.disableOverlay(p97, p98) -- Line: 726
    p97.overlayDisabled = p98;

    return p97;
end;

u3.disableStateOverlay = u3.disableOverlay;

function u3.setImage(p99, u100, p101) -- Line: 732
    -- upvalues: ContentProvider (copy)
    p99:modifyTheme({
        "IconImage",
        "Image",
        u100,
        p101
    });
    task.spawn(function() -- Line: 736
        -- upvalues: u100 (copy), ContentProvider (ref)
        local v102;

        if tonumber(u100) then
            v102 = `rbxassetid://{u100}`;
        else
            v102 = u100;
        end;

        if ContentProvider:GetAssetFetchStatus(v102) ~= Enum.AssetFetchStatus.Success then
            pcall(ContentProvider.PreloadAsync, ContentProvider, { v102 });
        end;
    end);

    return p99;
end;

function u3.setLabel(p103, p104, p105) -- Line: 748
    p103:modifyTheme({
        "IconLabel",
        "Text",
        p104,
        p105
    });

    return p103;
end;

function u3.setOrder(p106, p107, p108) -- Line: 753
    local v109 = p107 * 100;
    p106:modifyTheme({
        "IconSpot",
        "LayoutOrder",
        v109,
        p108
    });
    p106:modifyTheme({
        "Widget",
        "LayoutOrder",
        v109,
        p108
    });

    return p106;
end;

function u3.setCornerRadius(p110, p111, p112) -- Line: 762
    p110:modifyTheme({
        "IconCorners",
        "CornerRadius",
        p111,
        p112
    });

    return p110;
end;

function u3.align(p113, p114, p115) -- Line: 767
    -- upvalues: u3 (copy)
    local v116 = tostring(p114):lower();
    local v117 = (v116 == "mid" or v116 == "centre") and "center" or v116;
    local v118 = v117 ~= "left" and (v117 ~= "center" and v117 ~= "right") and "left" or v117;
    local v119 = v118 == "center" and u3.container.TopbarCentered or u3.container.TopbarStandard;
    local Holders = v119.Holders;
    local v120 = string.upper((string.sub(v118, 1, 1))) .. string.sub(v118, 2);

    if not p115 then
        p113.originalAlignment = v120;
    end;

    local joinedFrame = p113.joinedFrame;
    local v121 = Holders[v120];
    p113.screenGui = v119;
    p113.alignmentHolder = v121;

    if not p113.isDestroyed then
        p113.widget.Parent = joinedFrame or v121;
    end;

    p113.alignment = v120;
    p113.alignmentChanged:Fire(v120);
    u3.iconChanged:Fire(p113);

    return p113;
end;

u3.setAlignment = u3.align;

function u3.setLeft(p122) -- Line: 796
    p122:setAlignment("Left");

    return p122;
end;

function u3.setMid(p123) -- Line: 801
    p123:setAlignment("Center");

    return p123;
end;

function u3.setRight(p124) -- Line: 806
    p124:setAlignment("Right");

    return p124;
end;

function u3.setWidth(p125, p126, p127) -- Line: 811
    p125:modifyTheme({
        "Widget",
        "DesiredWidth",
        p126,
        p127
    });

    return p125;
end;

function u3.setImageScale(p128, p129, p130) -- Line: 819
    p128:modifyTheme({
        "IconImageScale",
        "Value",
        p129,
        p130
    });

    return p128;
end;

function u3.setImageRatio(p131, p132, p133) -- Line: 824
    p131:modifyTheme({
        "IconImageRatio",
        "AspectRatio",
        p132,
        p133
    });

    return p131;
end;

function u3.setTextSize(p134, p135, p136) -- Line: 829
    p134:modifyTheme({
        "IconLabel",
        "TextSize",
        p135,
        p136
    });

    return p134;
end;

function u3.setTextFont(p137, p138, p139, p140, p141) -- Line: 834
    local v142 = p139 or Enum.FontWeight.Regular;
    local v143 = p140 or Enum.FontStyle.Normal;
    local v144 = nil;
    local v145 = typeof(p138);

    if v145 == "number" then
        v144 = Font.fromId(p138, v142, v143);
    elseif v145 == "EnumItem" then
        v144 = Font.fromEnum(p138);
    elseif v145 == "string" and not p138:match("rbxasset") then
        v144 = Font.fromName(p138, v142, v143);
    end;

    p137:modifyTheme({
        "IconLabel",
        "FontFace",
        v144 or Font.new(p138, v142, v143),
        p141
    });

    return p137;
end;

function u3.setTextColor(p146, p147, p148) -- Line: 855
    if p147 == nil or (p147 == "" or (type(p147) ~= "userdata" or typeof(p147) ~= "Color3")) then
        if p147 ~= nil and p147 ~= "" then
            warn("setTextColor item must be a Color3 value! Changed the color to white.");
        end;

        p147 = Color3.fromRGB(255, 255, 255);
    end;

    p146:modifyTheme({
        "IconLabel",
        "TextColor3",
        p147,
        p148
    });

    return p146;
end;

function u3.bindToggleItem(p149, p150) -- Line: 867
    if not (p150:IsA("GuiObject") or p150:IsA("LayerCollector")) then
        error("Toggle item must be a GuiObject or LayerCollector!");
    end;

    p149.toggleItems[p150] = true;
    p149:_updateSelectionInstances();

    return p149;
end;

function u3.unbindToggleItem(p151, p152) -- Line: 876
    p151.toggleItems[p152] = nil;
    p151:_updateSelectionInstances();

    return p151;
end;

function u3._updateSelectionInstances(p153) -- Line: 882
    for i, _ in pairs(p153.toggleItems) do
        local v154 = {};

        for _, descendant in pairs(i:GetDescendants()) do
            if (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) and descendant.Active then
                table.insert(v154, descendant);
            end;
        end;

        p153.toggleItems[i] = v154;
    end;
end;

function u3._setToggleItemsVisible(p155, p156, p157, p158) -- Line: 896
    for i, _ in pairs(p155.toggleItems) do
        if not (p158 and (p158 ~= p155 and p158.toggleItems[i] ~= nil)) then
            i[i:IsA("LayerCollector") and "Enabled" or "Visible"] = p156;
        end;
    end;
end;

function u3.bindEvent(u159, p160, u161) -- Line: 908
    local v162 = u159[p160];
    local v163;

    if v162 then
        if typeof(v162) == "table" then
            v163 = v162.Connect;
        else
            v163 = false;
        end;
    else
        v163 = v162;
    end;

    assert(v163, "argument[1] must be a valid topbarplus icon event name!");
    local v164 = typeof(u161) == "function";
    assert(v164, "argument[2] must be a function!");
    u159.bindedEvents[p160] = v162:Connect(function(...) -- Line: 912
        -- upvalues: u161 (copy), u159 (copy)
        u161(u159, ...);
    end);

    return u159;
end;

function u3.unbindEvent(p165, p166) -- Line: 918
    local v167 = p165.bindedEvents[p166];

    if v167 then
        v167:Disconnect();
        p165.bindedEvents[p166] = nil;
    end;

    return p165;
end;

function u3.bindToggleKey(p168, p169) -- Line: 927
    local v170 = typeof(p169) == "EnumItem";
    assert(v170, "argument[1] must be a KeyCode EnumItem!");
    p168.bindedToggleKeys[p169] = true;
    p168.toggleKeyAdded:Fire(p169);
    p168:setCaption("_hotkey_");

    return p168;
end;

function u3.unbindToggleKey(p171, p172) -- Line: 935
    local v173 = typeof(p172) == "EnumItem";
    assert(v173, "argument[1] must be a KeyCode EnumItem!");
    p171.bindedToggleKeys[p172] = nil;

    return p171;
end;

function u3.call(u174, u175, ...) -- Line: 941
    local table_pack_ret = table.pack(...);
    task.spawn(function() -- Line: 943
        -- upvalues: u175 (copy), u174 (copy), table_pack_ret (copy)
        u175(u174, table.unpack(table_pack_ret));
    end);

    return u174;
end;

function u3.addToJanitor(p176, p177, p178, p179) -- Line: 949
    p176.janitor:add(p177, p178, p179);

    return p176;
end;

function u3.lock(p180) -- Line: 954
    p180:getInstance("ClickRegion").Visible = false;
    p180.locked = true;

    return p180;
end;

function u3.unlock(p181) -- Line: 962
    p181:getInstance("ClickRegion").Visible = true;
    p181.locked = false;

    return p181;
end;

function u3.debounce(p182, p183) -- Line: 969
    p182:lock();
    task.wait(p183);
    p182:unlock();

    return p182;
end;

function u3.autoDeselect(p184, p185) -- Line: 976
    p184.deselectWhenOtherIconSelected = p185 == nil and true or p185;

    return p184;
end;

function u3.oneClick(u186, p187) -- Line: 986
    local singleClickJanitor = u186.singleClickJanitor;
    singleClickJanitor:clean();

    if p187 or p187 == nil then
        singleClickJanitor:add(u186.selected:Connect(function() -- Line: 992
            -- upvalues: u186 (copy)
            u186:deselect("OneClick", u186);
        end));
    end;

    u186.oneClickEnabled = true;

    return u186;
end;

function u3.setCaption(p188, p189) -- Line: 1000
    -- upvalues: Elements (copy)
    if p189 == "_hotkey_" and p188.captionText then
        return p188;
    end;

    local captionJanitor = p188.captionJanitor;
    p188.captionJanitor:clean();

    if not p189 or p189 == "" then
        p188.caption = nil;
        p188.captionText = nil;

        return p188;
    end;

    local v190 = captionJanitor:add(require(Elements.Caption)(p188));
    v190:SetAttribute("CaptionText", p189);
    p188.caption = v190;
    p188.captionText = p189;

    return p188;
end;

function u3.setCaptionHint(p191, p192) -- Line: 1018
    local v193 = typeof(p192) == "EnumItem";
    assert(v193, "argument[1] must be a KeyCode EnumItem!");
    p191.fakeToggleKey = p192;
    p191.fakeToggleKeyChanged:Fire(p192);
    p191:setCaption("_hotkey_");

    return p191;
end;

function u3.leave(p194) -- Line: 1026
    p194.joinJanitor:clean();

    return p194;
end;

function u3.joinMenu(p195, p196) -- Line: 1032
    -- upvalues: Utility (copy)
    Utility.joinFeature(p195, p196, p196.menuIcons, p196:getInstance("Menu"));
    p196.menuChildAdded:Fire(p195);

    return p195;
end;

function u3.setMenu(p197, p198) -- Line: 1038
    p197.menuSet:Fire(p198);

    return p197;
end;

function u3.setFixedMenu(p199, p200) -- Line: 1043
    p199:freezeMenu(p200);
    p199:setMenu(p200);
end;

u3.setFrozenMenu = u3.setFixedMenu;

function u3.freezeMenu(u201) -- Line: 1049
    u201:select("FrozenMenu", u201);
    u201:bindEvent("deselected", function(p202) -- Line: 1053
        -- upvalues: u201 (copy)
        p202:select("FrozenMenu", u201);
    end);
    u201:modifyTheme({ "IconSpot", "Visible", false });
end;

function u3.joinDropdown(p203, p204) -- Line: 1059
    -- upvalues: Utility (copy)
    p204:getDropdown();
    Utility.joinFeature(p203, p204, p204.dropdownIcons, p204:getInstance("DropdownScroller"));
    p204.dropdownChildAdded:Fire(p203);

    return p203;
end;

function u3.getDropdown(p205) -- Line: 1066
    -- upvalues: Elements (copy)
    local dropdown = p205.dropdown;

    if not dropdown then
        dropdown = require(Elements.Dropdown)(p205);
        p205.dropdown = dropdown;
        p205:clipOutside(dropdown);
    end;

    return dropdown;
end;

function u3.setDropdown(p206, p207) -- Line: 1076
    p206:getDropdown();
    p206.dropdownSet:Fire(p207);

    return p206;
end;

function u3.clipOutside(p208, p209) -- Line: 1082
    -- upvalues: Utility (copy)
    local v210 = Utility.clipOutside(p208, p209);
    p208:refreshAppearance(p209);

    return p208, v210;
end;

function u3.setIndicator(p211, p212) -- Line: 1093
    -- upvalues: Elements (copy), u3 (copy)
    if not p211.indicator then
        p211.indicator = p211.janitor:add(require(Elements.Indicator)(p211, u3));
    end;

    p211.indicatorSet:Fire(p212);
end;

function u3.convertLabelToNumberSpinner(u213, u214, u215) -- Line: 1105
    task.defer(function() -- Line: 1106
        -- upvalues: u213 (copy), u214 (copy), u215 (copy)
        local Instance = u213:getInstance("IconLabel");
        Instance.Transparency = 1;
        u214.Parent = Instance.Parent;
        u214.Size = UDim2.fromScale(1, 1);
        u214.AnchorPoint = Vector2.new(0.5, 0.5);
        u214.Position = UDim2.new(0.5, 0, 0.5, 0);
        u214.TextXAlignment = Enum.TextXAlignment.Center;
        u214.ClipsDescendants = false;

        for _, v in ipairs({ "FontFace", "BorderSizePixel", "BorderColor3", "Rotation", "TextStrokeTransparency", "TextStrokeColor3", "TextStrokeTransparency", "TextColor3" }) do
            u214[v] = Instance[v];
            u213:addToJanitor(Instance:GetPropertyChangedSignal(v):Connect(function() -- Line: 1129
                -- upvalues: u214 (ref), v (copy), Instance (copy)
                u214[v] = Instance[v];
            end));
        end;

        local function getSpinnerSizeAndDigitCount() -- Line: 1136
            -- upvalues: u214 (ref)
            local v216 = 0;
            local v217 = 0;

            for _, child in u214.Frame:GetChildren() do
                local string_lower_ret = string.lower(child.Name);

                if string_lower_ret == "digit" then
                    v216 = v216 + child.AbsoluteSize.X;
                    v217 = v217 + 1;
                elseif (string_lower_ret == "prefix" or (string_lower_ret == "suffix" or string_lower_ret == "comma")) and child.Text ~= "" then
                    v216 = v216 + child.AbsoluteSize.X;
                    v217 = v217 + 1;
                end;
            end;

            return v216, v217;
        end;

        local function getLabelParentContainerXSize() -- Line: 1154
            -- upvalues: Instance (copy), u214 (ref)
            local Parent = Instance.Parent;

            if Parent then
                Parent = Parent.Parent;
            end;

            if Parent == nil then
                return 0;
            end;

            if Parent.IconImage.Visible == true then
                return u214.Frame.AbsoluteSize.X + Instance.Parent.Parent.IconImage.AbsoluteSize.X;
            end;

            return Parent.AbsoluteSize.X;
        end;

        local function getNumberSpinnerXSize() -- Line: 1166
            -- upvalues: u214 (ref)
            return u214.Frame.AbsoluteSize.X;
        end;

        local function adjustSize() -- Line: 1170
            -- upvalues: getSpinnerSizeAndDigitCount (copy), u213 (ref), u214 (ref), Instance (copy)
            local v218, v219 = getSpinnerSizeAndDigitCount();

            if v219 < 18 then
                u213:setLabel(u214.Value);
            end;

            local X = u214.Frame.AbsoluteSize.X;

            while v218 < X and u213.isDestroyed ~= true do
                task.wait(0.05);

                if v219 > 0 and v219 < 8 then
                    u214.TextSize = Instance.TextSize;
                    break;
                end;

                local v220 = u214;
                v220.TextSize = v220.TextSize + 1;
                X = u214.Frame.AbsoluteSize.X;
                v218, v219 = getSpinnerSizeAndDigitCount();
            end;

            local Parent = Instance.Parent;

            if Parent then
                Parent = Parent.Parent;
            end;

            local v221;

            if Parent == nil then
                v221 = 0;
            elseif Parent.IconImage.Visible == true then
                v221 = u214.Frame.AbsoluteSize.X + Instance.Parent.Parent.IconImage.AbsoluteSize.X;
            else
                v221 = Parent.AbsoluteSize.X;
            end;

            while v221 < v218 and u213.isDestroyed ~= true do
                task.wait(0.05);

                if v219 < 8 and v219 > 0 then
                    u214.TextSize = Instance.TextSize;

                    return;
                end;

                local v222 = u214;
                v222.TextSize = v222.TextSize - 1;
                local Parent2 = Instance.Parent;

                if Parent2 then
                    Parent2 = Parent2.Parent;
                end;

                if Parent2 == nil then
                    v221 = 0;
                elseif Parent2.IconImage.Visible == true then
                    v221 = u214.Frame.AbsoluteSize.X + Instance.Parent.Parent.IconImage.AbsoluteSize.X;
                else
                    v221 = Parent2.AbsoluteSize.X;
                end;

                v218, v219 = getSpinnerSizeAndDigitCount();
            end;
        end;

        u213:addToJanitor(u214.Frame.ChildAdded:Connect(adjustSize));
        u213:addToJanitor(u214.Frame.ChildRemoved:Connect(adjustSize));
        u213:addToJanitor(u213.iconAdded:Connect(function() -- Line: 1208
            -- upvalues: adjustSize (copy)
            task.wait(1);
            adjustSize();
        end));
        u213:updateParent();
        u214.Name = "LabelSpinner";
        u214.Prefix = "$";
        u214.Commas = true;
        u214.Decimals = 0;
        u214.Duration = 0.25;
        u214.Value = 10;
        task.wait(0.2);

        if typeof(u215) == "function" then
            u215();
        end;
    end);

    return u213;
end;

function u3.destroy(p223) -- Line: 1235
    -- upvalues: u3 (copy)
    if p223.isDestroyed then
        return;
    end;

    p223:clearNotices();

    if p223.parentIconUID then
        p223:leave();
    end;

    p223.isDestroyed = true;
    p223.janitor:clean();
    u3.iconRemoved:Fire(p223);
end;

u3.Destroy = u3.destroy;

return u3;