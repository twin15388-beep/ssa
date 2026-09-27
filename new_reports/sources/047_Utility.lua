-- Decompiled with Potassium's decompiler.

local u1 = {};
local LocalPlayer = game:GetService("Players").LocalPlayer;

function u1.createStagger(p2, u3, u4) -- Line: 13
    local u5 = false;
    local u6 = false;
    local u7 = (not p2 or p2 == 0) and 0.01 or p2;

    local function staggeredCallback(...) -- Line: 29
        -- upvalues: u5 (ref), u6 (ref), u4 (copy), u7 (ref), u3 (copy), staggeredCallback (copy)
        if u5 then
            u6 = true;

            return;
        end;

        local table_pack_ret = table.pack(...);
        u5 = true;
        u6 = false;
        task.spawn(function() -- Line: 37
            -- upvalues: u4 (ref), u7 (ref), u3 (ref), table_pack_ret (copy)
            if u4 then
                task.wait(u7);
            end;

            u3(table.unpack(table_pack_ret));
        end);
        task.delay(u7, function() -- Line: 43
            -- upvalues: u5 (ref), u6 (ref), staggeredCallback (ref), table_pack_ret (copy)
            u5 = false;

            if u6 then
                staggeredCallback(table.unpack(table_pack_ret));
            end;
        end);
    end;

    return staggeredCallback;
end;

function u1.round(p8) -- Line: 55
    return math.floor(p8 + 0.5);
end;

function u1.reverseTable(p9) -- Line: 60
    for i = 1, math.floor(#p9 / 2) do
        local v10 = #p9 - i + 1;
        local v11 = p9[i];
        p9[i] = p9[v10];
        p9[v10] = v11;
        local _ = i;
    end;
end;

function u1.copyTable(p12) -- Line: 67
    -- upvalues: u1 (copy)
    local v13 = type(p12) == "table";
    assert(v13, "First argument must be a table");
    local table_create_ret = table.create(#p12);

    for i, v in pairs(p12) do
        if type(v) == "table" then
            table_create_ret[i] = u1.copyTable(v);
        else
            table_create_ret[i] = v;
        end;
    end;

    return table_create_ret;
end;

local u14 = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "?", "@", "{", "}", "[", "]", "!", "(", ")", "=", "+", "~", "#" };

function u1.generateUID(p15) -- Line: 82
    -- upvalues: u14 (copy)
    local v16 = u14;
    local v17 = #v16;
    local v18 = "";

    for i = 1, p15 or 8 do
        v18 = v18 .. v16[math.random(1, v17)];
        local _ = i;
    end;

    return v18;
end;

local u19 = {};

function u1.setVisible(u20, p21, p22) -- Line: 95
    -- upvalues: u19 (copy)
    local v23 = u19[u20];

    if not v23 then
        v23 = {};
        u19[u20] = v23;
        u20.Destroying:Once(function() -- Line: 104
            -- upvalues: u19 (ref), u20 (copy)
            u19[u20] = nil;
        end);
    end;

    if p21 then
        v23[p22] = nil;
    else
        v23[p22] = true;
    end;

    if p21 then
        for _, _ in pairs(v23) do
            p21 = false;
            break;
        end;
    end;

    u20.Visible = p21;
end;

function u1.formatStateName(p24) -- Line: 123
    return string.upper((string.sub(p24, 1, 1))) .. string.lower((string.sub(p24, 2)));
end;

function u1.localPlayerRespawned(p25) -- Line: 127
    -- upvalues: LocalPlayer (copy)
    LocalPlayer.CharacterRemoving:Connect(p25);
end;

function u1.getClippedContainer(p26) -- Line: 137
    local ClippedContainer = p26:FindFirstChild("ClippedContainer");

    if not ClippedContainer then
        ClippedContainer = Instance.new("Folder");
        ClippedContainer.Name = "ClippedContainer";
        ClippedContainer.Parent = p26;
    end;

    return ClippedContainer;
end;

local Janitor = require(script.Parent.Packages.Janitor);
local GuiService = game:GetService("GuiService");

function u1.clipOutside(u27, u28) -- Line: 151
    -- upvalues: Janitor (copy), u1 (copy), GuiService (copy)
    local u29 = u27.janitor:add(Janitor.new());
    u28.Destroying:Once(function() -- Line: 153
        -- upvalues: u29 (copy)
        u29:Destroy();
    end);
    u27.janitor:add(u28);
    local Parent = u28.Parent;
    local u30 = u29:add(Instance.new("Frame"));
    u30:SetAttribute("IsAClippedClone", true);
    u30.Name = u28.Name;
    u30.AnchorPoint = u28.AnchorPoint;
    u30.Size = u28.Size;
    u30.Position = u28.Position;
    u30.BackgroundTransparency = 1;
    u30.LayoutOrder = u28.LayoutOrder;
    u30.Parent = Parent;
    local ObjectValue = Instance.new("ObjectValue");
    ObjectValue.Name = "OriginalInstance";
    ObjectValue.Value = u28;
    ObjectValue.Parent = u30;
    local v31 = ObjectValue:Clone();
    u28:SetAttribute("HasAClippedClone", true);
    v31.Name = "ClippedClone";
    v31.Value = u30;
    v31.Parent = u28;
    local u32 = nil;
    local iconModule = require(u27.iconModule);
    local container = iconModule.container;

    local function updateScreenGui() -- Line: 183
        -- upvalues: Parent (copy), u32 (ref), container (copy), u28 (copy), u1 (ref)
        local v33 = Parent:FindFirstAncestorWhichIsA("ScreenGui");

        if not string.match(v33.Name, "Clipped") then
            v33 = container[v33.Name .. "Clipped"];
        end;

        u32 = v33;
        u28.AnchorPoint = Vector2.new(0, 0);
        u28.Parent = u1.getClippedContainer(u32);
    end;

    u29:add(u27.alignmentChanged:Connect(updateScreenGui));
    updateScreenGui();

    for _, child in pairs(u28:GetChildren()) do
        if child:IsA("UIAspectRatioConstraint") then
            child:Clone().Parent = u30;
        end;
    end;

    local widget = u27.widget;
    local u34 = false;
    local Attribute = u28:GetAttribute("IgnoreVisibilityUpdater");

    local function updateVisibility() -- Line: 205
        -- upvalues: Attribute (copy), widget (copy), u34 (ref), u1 (ref), u28 (copy)
        if Attribute then
            return;
        end;

        local Visible = widget.Visible;

        if u34 then
            Visible = false;
        end;

        u1.setVisible(u28, Visible, "ClipHandler");
    end;

    u29:add(widget:GetPropertyChangedSignal("Visible"):Connect(updateVisibility));
    local u35 = nil;

    local function checkIfOutsideParentXBounds() -- Line: 218
        -- upvalues: u27 (copy), u28 (copy), iconModule (copy), u34 (ref), Attribute (copy), widget (copy), u1 (ref), u35 (ref), checkIfOutsideParentXBounds (copy), u29 (copy)
        task.defer(function() -- Line: 220
            -- upvalues: u27 (ref), u28 (ref), iconModule (ref), u34 (ref), Attribute (ref), widget (ref), u1 (ref), u35 (ref), checkIfOutsideParentXBounds (ref), u29 (ref)
            local v36 = nil;
            local UID = u27.UID;
            local v37;

            if u28:GetAttribute("ClipToJoinedParent") then
                v37 = UID;

                for i = 1, 10 do
                    local IconByUID = iconModule.getIconByUID(UID);

                    if not IconByUID then
                        break;
                    end;

                    local joinedFrame = IconByUID.joinedFrame;
                    UID = IconByUID.parentIconUID;

                    if not joinedFrame then
                        break;
                    end;

                    if joinedFrame and joinedFrame.Name == "DropdownScroller" then
                        v36 = joinedFrame;
                        break;
                    end;

                    v36 = joinedFrame;
                    local _ = i;
                end;
            else
                v37 = UID;
            end;

            if not v36 then
                u34 = false;

                if Attribute then
                    return;
                end;

                local Visible = widget.Visible;

                if u34 then
                    Visible = false;
                end;

                u1.setVisible(u28, Visible, "ClipHandler");

                return;
            end;

            local AbsolutePosition = v36.AbsolutePosition;
            local AbsoluteSize = v36.AbsoluteSize;
            local v38 = u28.AbsolutePosition + u28.AbsoluteSize / 2;
            local v39 = v38.X < AbsolutePosition.X or (v38.X > AbsolutePosition.X + AbsoluteSize.X or (v38.Y < AbsolutePosition.Y or v38.Y > AbsolutePosition.Y + AbsoluteSize.Y));

            if v39 ~= u34 then
                u34 = v39;

                if not Attribute then
                    local Visible = widget.Visible;

                    if u34 then
                        Visible = false;
                    end;

                    u1.setVisible(u28, Visible, "ClipHandler");
                end;
            end;

            if v36:IsA("ScrollingFrame") and u35 ~= v36 then
                u35 = v36;
                u29:add(v36:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- Line: 265
                    -- upvalues: checkIfOutsideParentXBounds (ref)
                    checkIfOutsideParentXBounds();
                end), "Disconnect", "TrackUtilityScroller-" .. v37);
            end;
        end);
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local u40 = u28:GetAttribute("AdditionalOffsetX") or 0;

    local function trackProperty(u41) -- Line: 275
        -- upvalues: u30 (copy), workspace_CurrentCamera (copy), u28 (copy), GuiService (ref), u32 (ref), iconModule (copy), u40 (copy), u27 (copy), u34 (ref), Attribute (copy), widget (copy), u1 (ref), u35 (ref), checkIfOutsideParentXBounds (copy), u29 (copy)
        local u42 = "Absolute" .. u41;

        local function updateProperty() -- Line: 277
            -- upvalues: u30 (ref), u42 (copy), u41 (copy), workspace_CurrentCamera (ref), u28 (ref), GuiService (ref), u32 (ref), iconModule (ref), u40 (ref), u27 (ref), u34 (ref), Attribute (ref), widget (ref), u1 (ref), u35 (ref), checkIfOutsideParentXBounds (ref), u29 (ref)
            local v43 = u30[u42];
            local UDim2_fromOffset_ret = UDim2.fromOffset(v43.X, v43.Y);

            if u41 == "Position" then
                local v44 = workspace_CurrentCamera.ViewportSize.X - u28.AbsoluteSize.X - 4;
                local Offset = UDim2_fromOffset_ret.X.Offset;

                if Offset < 4 then
                    v44 = 4;
                elseif v44 >= Offset then
                    v44 = Offset;
                end;

                local UDim2_fromOffset_ret2 = UDim2.fromOffset(v44, UDim2_fromOffset_ret.Y.Offset);
                local X = workspace.CurrentCamera.ViewportSize.X;
                local X2 = u32.AbsoluteSize.X;
                local X3 = u32.AbsolutePosition.X;

                if not iconModule.isOldTopbar then
                    X3 = X - X2 - 0;
                end;

                UDim2_fromOffset_ret = UDim2_fromOffset_ret2 + UDim2.fromOffset(-(X3 - u40), GuiService.TopbarInset.Height);
                task.defer(function() -- Line: 220
                    -- upvalues: u27 (ref), u28 (ref), iconModule (ref), u34 (ref), Attribute (ref), widget (ref), u1 (ref), u35 (ref), checkIfOutsideParentXBounds (ref), u29 (ref)
                    local v45 = nil;
                    local UID = u27.UID;
                    local v46;

                    if u28:GetAttribute("ClipToJoinedParent") then
                        v46 = UID;

                        for i = 1, 10 do
                            local IconByUID = iconModule.getIconByUID(UID);

                            if not IconByUID then
                                break;
                            end;

                            local joinedFrame = IconByUID.joinedFrame;
                            UID = IconByUID.parentIconUID;

                            if not joinedFrame then
                                break;
                            end;

                            if joinedFrame and joinedFrame.Name == "DropdownScroller" then
                                v45 = joinedFrame;
                                break;
                            end;

                            v45 = joinedFrame;
                            local _ = i;
                        end;
                    else
                        v46 = UID;
                    end;

                    if not v45 then
                        u34 = false;

                        if Attribute then
                            return;
                        end;

                        local Visible = widget.Visible;

                        if u34 then
                            Visible = false;
                        end;

                        u1.setVisible(u28, Visible, "ClipHandler");

                        return;
                    end;

                    local AbsolutePosition = v45.AbsolutePosition;
                    local AbsoluteSize = v45.AbsoluteSize;
                    local v47 = u28.AbsolutePosition + u28.AbsoluteSize / 2;
                    local v48 = v47.X < AbsolutePosition.X or (v47.X > AbsolutePosition.X + AbsoluteSize.X or (v47.Y < AbsolutePosition.Y or v47.Y > AbsolutePosition.Y + AbsoluteSize.Y));

                    if v48 ~= u34 then
                        u34 = v48;

                        if not Attribute then
                            local Visible = widget.Visible;

                            if u34 then
                                Visible = false;
                            end;

                            u1.setVisible(u28, Visible, "ClipHandler");
                        end;
                    end;

                    if v45:IsA("ScrollingFrame") and u35 ~= v45 then
                        u35 = v45;
                        u29:add(v45:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- Line: 265
                            -- upvalues: checkIfOutsideParentXBounds (ref)
                            checkIfOutsideParentXBounds();
                        end), "Disconnect", "TrackUtilityScroller-" .. v46);
                    end;
                end);
            end;

            u28[u41] = UDim2_fromOffset_ret;
        end;

        local u49 = u1.createStagger(0.01, updateProperty);
        u29:add(u30:GetPropertyChangedSignal(u42):Connect(u49));
        u29:add(u30:GetAttributeChangedSignal("ForceUpdate"):Connect(function() -- Line: 317
            -- upvalues: u49 (copy)
            u49();
        end));
        local v50 = u1.createStagger(0.5, updateProperty, true);
        u29:add(u30:GetPropertyChangedSignal(u42):Connect(v50));

        if u41 == "Position" then
            u29:add(u32:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 336
                -- upvalues: u49 (copy)
                u49();
            end));
        end;
    end;

    task.delay(0.1, checkIfOutsideParentXBounds);
    task.defer(function() -- Line: 220
        -- upvalues: u27 (copy), u28 (copy), iconModule (copy), u34 (ref), Attribute (copy), widget (copy), u1 (ref), u35 (ref), checkIfOutsideParentXBounds (copy), u29 (copy)
        local v51 = nil;
        local UID = u27.UID;
        local v52;

        if u28:GetAttribute("ClipToJoinedParent") then
            v52 = UID;

            for i = 1, 10 do
                local IconByUID = iconModule.getIconByUID(UID);

                if not IconByUID then
                    break;
                end;

                local joinedFrame = IconByUID.joinedFrame;
                UID = IconByUID.parentIconUID;

                if not joinedFrame then
                    break;
                end;

                if joinedFrame and joinedFrame.Name == "DropdownScroller" then
                    v51 = joinedFrame;
                    break;
                end;

                v51 = joinedFrame;
                local _ = i;
            end;
        else
            v52 = UID;
        end;

        if not v51 then
            u34 = false;

            if Attribute then
                return;
            end;

            local Visible = widget.Visible;

            if u34 then
                Visible = false;
            end;

            u1.setVisible(u28, Visible, "ClipHandler");

            return;
        end;

        local AbsolutePosition = v51.AbsolutePosition;
        local AbsoluteSize = v51.AbsoluteSize;
        local v53 = u28.AbsolutePosition + u28.AbsoluteSize / 2;
        local v54 = v53.X < AbsolutePosition.X or (v53.X > AbsolutePosition.X + AbsoluteSize.X or (v53.Y < AbsolutePosition.Y or v53.Y > AbsolutePosition.Y + AbsoluteSize.Y));

        if v54 ~= u34 then
            u34 = v54;

            if not Attribute then
                local Visible = widget.Visible;

                if u34 then
                    Visible = false;
                end;

                u1.setVisible(u28, Visible, "ClipHandler");
            end;
        end;

        if v51:IsA("ScrollingFrame") and u35 ~= v51 then
            u35 = v51;
            u29:add(v51:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- Line: 265
                -- upvalues: checkIfOutsideParentXBounds (ref)
                checkIfOutsideParentXBounds();
            end), "Disconnect", "TrackUtilityScroller-" .. v52);
        end;
    end);

    if not Attribute then
        local Visible = widget.Visible;

        if u34 then
            Visible = false;
        end;

        u1.setVisible(u28, Visible, "ClipHandler");
    end;

    trackProperty("Position");
    u29:add(u28:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 348
    end));

    if u28:GetAttribute("TrackCloneSize") then
        trackProperty("Size");
    else
        u29:add(u28:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 358
            -- upvalues: u28 (copy), u30 (copy)
            local AbsoluteSize = u28.AbsoluteSize;
            u30.Size = UDim2.fromOffset(AbsoluteSize.X, AbsoluteSize.Y);
        end));
    end;

    return u30;
end;

function u1.joinFeature(u55, u56, u57, p58) -- Line: 367
    local joinJanitor = u55.joinJanitor;
    joinJanitor:clean();

    if not p58 then
        u55:leave();

        return;
    end;

    u55.parentIconUID = u56.UID;
    u55.joinedFrame = p58;
    joinJanitor:add(u56.alignmentChanged:Connect(function() -- Line: 378, Name: updateAlignent
        -- upvalues: u56 (copy), u55 (copy)
        local alignment = u56.alignment;
        u55:setAlignment(alignment == "Center" and "Left" or alignment, true);
    end));
    local alignment = u56.alignment;
    u55:setAlignment(alignment == "Center" and "Left" or alignment, true);
    u55:modifyTheme({ "IconButton", "BackgroundTransparency", 1 }, "JoinModification");
    u55:modifyTheme({ "ClickRegion", "Active", false }, "JoinModification");

    if u56.childModifications then
        task.defer(function() -- Line: 393
            -- upvalues: u55 (copy), u56 (copy)
            u55:modifyTheme(u56.childModifications, u56.childModificationsUID);
        end);
    end;

    local Instance2 = u55:getInstance("ClickRegion");

    local function makeSelectable() -- Line: 399
        -- upvalues: Instance2 (copy), u56 (copy)
        Instance2.Selectable = u56.isSelected;
    end;

    joinJanitor:add(u56.toggled:Connect(makeSelectable));
    task.defer(makeSelectable);
    joinJanitor:add(function() -- Line: 404
        -- upvalues: Instance2 (copy)
        Instance2.Selectable = true;
    end);
    local UID = u55.UID;
    table.insert(u57, UID);
    u56:autoDeselect(false);
    u56.childIconsDict[UID] = true;

    if not u56.isEnabled then
        u56:setEnabled(true);
    end;

    u55.joinedParent:Fire(u56);
    joinJanitor:add(function() -- Line: 422
        -- upvalues: u55 (copy), u57 (copy), UID (copy), u56 (copy)
        if not u55.joinedFrame then
            return;
        end;

        for i, v in pairs(u57) do
            if v == UID then
                table.remove(u57, i);
                break;
            end;
        end;

        local IconByUID = require(u55.iconModule).getIconByUID(u55.parentIconUID);

        if not IconByUID then
            return;
        end;

        u55:setAlignment(u55.originalAlignment);
        u55.parentIconUID = false;
        u55.joinedFrame = false;
        u55:removeModification("JoinModification");
        local v59 = true;
        local childIconsDict = IconByUID.childIconsDict;
        childIconsDict[UID] = nil;

        for _, _ in pairs(childIconsDict) do
            v59 = false;
            break;
        end;

        if v59 and not IconByUID.isAnOverflow then
            IconByUID:setEnabled(false);
        end;

        local alignment2 = u56.alignment;
        u55:setAlignment(alignment2 == "Center" and "Left" or alignment2, true);
    end);
end;

return u1;