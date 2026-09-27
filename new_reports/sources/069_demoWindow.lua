-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);

return function(u1) -- Line: 3
    local u2 = u1.State(true);
    local u3 = u1.State(false);
    local u4 = u1.State(false);
    local u5 = u1.State(false);
    local u6 = u1.State(false);
    local u7 = u1.State(false);

    local function helpMarker(p8) -- Line: 12
        -- upvalues: u1 (copy)
        u1.PushConfig({
            TextColor = u1._config.TextDisabledColor
        });
        local v9 = u1.Text({ "(?)" });
        u1.PopConfig();
        u1.PushConfig({
            ContentWidth = UDim.new(0, 350)
        });

        if v9.hovered() then
            u1.Tooltip({ p8 });
        end;

        u1.PopConfig();
    end;

    local u41 = {
        Basic = function() -- Line: 26, Name: Basic
            -- upvalues: u1 (copy)
            u1.Tree({ "Basic" });
            u1.SeparatorText({ "Basic" });
            local v10 = u1.State(1);
            u1.Button({ "Button" });
            u1.SmallButton({ "SmallButton" });
            u1.Text({ "Text" });
            u1.TextWrapped({ string.rep("Text Wrapped ", 5) });
            u1.TextColored({ "Colored Text", Color3.fromRGB(255, 128, 0) });
            u1.Text({ "Rich Text: <b>bold text</b> <i>italic text</i> <u>underline text</u> <s>strikethrough text</s> <font color= \"rgb(240, 40, 10)\">red text</font> <font size=\"32\">bigger text</font>", true, nil, true });
            u1.SameLine();
            u1.RadioButton({ "Index \'1\'", 1 }, {
                index = v10
            });
            u1.RadioButton({ "Index \'two\'", "two" }, {
                index = v10
            });

            if u1.RadioButton({ "Index \'false\'", false }, {
                index = v10
            }).active() == false and u1.SmallButton({ "Select last" }).clicked() then
                v10:set(false);
            end;

            u1.End();
            u1.Text({ "The Index is: " .. tostring(v10.value) });
            u1.SeparatorText({ "Inputs" });
            u1.InputNum({});
            u1.DragNum({});
            u1.SliderNum({});
            u1.End();
        end,

        Tree = function() -- Line: 57, Name: Tree
            -- upvalues: u1 (copy), helpMarker (copy)
            u1.Tree({ "Trees" });
            u1.Tree({
                "Tree using SpanAvailWidth",
                [u1.Args.Tree.SpanAvailWidth] = true
            });
            helpMarker("SpanAvailWidth determines if the Tree is selectable from its entire with, or only the text area");
            u1.End();
            local v11 = u1.Tree({ "Tree with Children" });
            u1.Text({ "Im inside the first tree!" });
            u1.Button({ "Im a button inside the first tree!" });
            u1.Tree({ "Im a tree inside the first tree!" });
            u1.Text({ "I am the innermost text!" });
            u1.End();
            u1.End();
            u1.Checkbox({ "Toggle above tree" }, {
                isChecked = v11.state.isUncollapsed
            });
            u1.End();
        end,

        CollapsingHeader = function() -- Line: 76, Name: CollapsingHeader
            -- upvalues: u1 (copy)
            u1.Tree({ "Collapsing Headers" });
            u1.CollapsingHeader({ "A header" });
            u1.Text({ "This is under the first header!" });
            u1.End();
            local v12 = u1.State(true);
            u1.CollapsingHeader({ "Another header" }, {
                isUncollapsed = v12
            });

            if u1.Button({ "Shhh... secret button!" }).clicked() then
                v12:set(true);
            end;

            u1.End();
            u1.End();
        end,

        Group = function() -- Line: 91, Name: Group
            -- upvalues: u1 (copy)
            u1.Tree({ "Groups" });
            u1.SameLine();
            u1.Group();
            u1.Text({ "I am in group A" });
            u1.Button({ "Im also in A" });
            u1.End();
            u1.Separator();
            u1.Group();
            u1.Text({ "I am in group B" });
            u1.Button({ "Im also in B" });
            u1.Button({ "Also group B" });
            u1.End();
            u1.End();
            u1.End();
        end,

        Indent = function() -- Line: 110, Name: Indent
            -- upvalues: u1 (copy)
            u1.Tree({ "Indents" });
            u1.Text({ "Not Indented" });
            u1.Indent();
            u1.Text({ "Indented" });
            u1.Indent({ 7 });
            u1.Text({ "Indented by 7 more pixels" });
            u1.End();
            u1.Indent({ -7 });
            u1.Text({ "Indented by 7 less pixels" });
            u1.End();
            u1.End();
            u1.End();
        end,

        Input = function() -- Line: 126, Name: Input
            -- upvalues: u1 (copy), helpMarker (copy)
            u1.Tree({ "Input" });
            local v13 = u1.State(false);
            local v14 = u1.State(false);
            local v15 = u1.State(0);
            local v16 = u1.State(100);
            local v17 = u1.State(1);
            local v18 = u1.State("%d");
            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            local v19 = u1.InputNum({
                "Input Number",
                [u1.Args.InputNum.NoButtons] = v14.value,
                [u1.Args.InputNum.Min] = v15.value,
                [u1.Args.InputNum.Max] = v16.value,
                [u1.Args.InputNum.Increment] = v17.value,
                [u1.Args.InputNum.Format] = { v18.value }
            });
            u1.PopConfig();
            u1.Text({ "The Value is: " .. v19.number.value });

            if u1.Button({ "Randomize Number" }).clicked() then
                v19.number:set(math.random(1, 99));
            end;

            local v20 = u1.Checkbox({ "NoField" }, {
                isChecked = v13
            });
            local v21 = u1.Checkbox({ "NoButtons" }, {
                isChecked = v14
            });

            if v20.checked() and v21.isChecked.value == true then
                v21.isChecked:set(false);
            end;

            if v21.checked() and v20.isChecked.value == true then
                v20.isChecked:set(false);
            end;

            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            u1.InputVector2({ "InputVector2" });
            u1.InputVector3({ "InputVector3" });
            u1.InputUDim({ "InputUDim" });
            u1.InputUDim2({ "InputUDim2" });
            local v22 = u1.State(false);
            local v23 = u1.State(false);
            local v24 = u1.State(Color3.new());
            local v25 = u1.State(0);
            u1.SliderNum({ "Transparency", 0.01, 0, 1 }, {
                number = v25
            });
            u1.InputColor3({ "InputColor3", v22:get(), v23:get() }, {
                color = v24
            });
            u1.InputColor4({ "InputColor4", v22:get(), v23:get() }, {
                color = v24,
                transparency = v25
            });
            u1.SameLine();
            u1.Text({ v24:get():ToHex() });
            u1.Checkbox({ "Use Floats" }, {
                isChecked = v22
            });
            u1.Checkbox({ "Use HSV" }, {
                isChecked = v23
            });
            u1.End();
            u1.PopConfig();
            u1.Separator();
            u1.SameLine();
            u1.Text({ "Slider Numbers" });
            helpMarker("ctrl + click slider number widgets to input a number");
            u1.End();
            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            u1.SliderNum({ "Slide Int", 1, 1, 8 });
            u1.SliderNum({ "Slide Float", 0.01, 0, 100 });
            u1.SliderNum({ "Small Numbers", 0.001, -2, 1, "%f radians" });
            u1.SliderNum({ "Odd Ranges", 0.001, -3.141592653589793, 3.141592653589793, "%f radians" });
            u1.SliderNum({ "Big Numbers", 10000, 100000, 10000000 });
            u1.SliderNum({ "Few Numbers", 1, 0, 3 });
            u1.PopConfig();
            u1.Separator();
            u1.SameLine();
            u1.Text({ "Drag Numbers" });
            helpMarker("ctrl + click or double click drag number widgets to input a number, hold shift/alt while dragging to increase/decrease speed");
            u1.End();
            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            u1.DragNum({ "Drag Int" });
            u1.DragNum({ "Slide Float", 0.001, -10, 10 });
            u1.DragNum({ "Percentage", 1, 0, 100, "%d %%" });
            u1.PopConfig();
            u1.End();
        end,

        InputText = function() -- Line: 203, Name: InputText
            -- upvalues: u1 (copy)
            u1.Tree({ "Input Text" });
            u1.PushConfig({
                ContentWidth = UDim.new(0, 250)
            });
            local v26 = u1.InputText({
                "Input Text Test",
                [u1.Args.InputText.TextHint] = "Input Text here"
            });
            u1.PopConfig();
            u1.Text({ "The text is: " .. v26.text.value });
            u1.End();
        end,

        MultiInput = function() -- Line: 212, Name: MultiInput
            -- upvalues: u1 (copy)
            u1.Tree({ "Multi-Component Input" });
            local v27 = u1.State(Vector2.new());
            local v28 = u1.State((Vector3.new()));
            local v29 = u1.State(UDim.new());
            local v30 = u1.State(UDim2.new());
            local v31 = u1.State(Color3.new());
            local v32 = u1.State(Rect.new(0, 0));
            u1.SeparatorText({ "Input" });
            u1.InputVector2({}, {
                number = v27
            });
            u1.InputVector3({}, {
                number = v28
            });
            u1.InputUDim({}, {
                number = v29
            });
            u1.InputUDim2({}, {
                number = v30
            });
            u1.InputRect({}, {
                number = v32
            });
            u1.SeparatorText({ "Drag" });
            u1.DragVector2({}, {
                number = v27
            });
            u1.DragVector3({}, {
                number = v28
            });
            u1.DragUDim({}, {
                number = v29
            });
            u1.DragUDim2({}, {
                number = v30
            });
            u1.DragRect({}, {
                number = v32
            });
            u1.SeparatorText({ "Slider" });
            u1.SliderVector2({}, {
                number = v27
            });
            u1.SliderVector3({}, {
                number = v28
            });
            u1.SliderUDim({}, {
                number = v29
            });
            u1.SliderUDim2({}, {
                number = v30
            });
            u1.SliderRect({}, {
                number = v32
            });
            u1.SeparatorText({ "Color" });
            u1.InputColor3({}, {
                color = v31
            });
            u1.InputColor4({}, {
                color = v31
            });
            u1.End();
        end,

        Tooltip = function() -- Line: 254, Name: Tooltip
            -- upvalues: u1 (copy)
            u1.PushConfig({
                ContentWidth = UDim.new(0, 250)
            });
            u1.Tree({ "Tooltip" });

            if u1.Text({ "Hover over me to reveal a tooltip" }).hovered() then
                u1.Tooltip({ "I am some helpful tooltip text" });
            end;

            local v33 = u1.State("Hello ");
            local v34 = u1.State(1);

            if u1.InputNum({ "# of repeat", 1, 1, 50 }, {
                number = v34
            }).numberChanged() then
                v33:set(string.rep("Hello ", v34:get()));
            end;

            if u1.Checkbox({ "Show dynamic text tooltip" }).isChecked.value then
                u1.Tooltip({ v33:get() });
            end;

            u1.End();
            u1.PopConfig();
        end,

        Selectable = function() -- Line: 272, Name: Selectable
            -- upvalues: u1 (copy)
            u1.Tree({ "Selectable" });
            local v35 = u1.State(2);
            u1.Selectable({ "Selectable #1", 1 }, {
                index = v35
            });
            u1.Selectable({ "Selectable #2", 2 }, {
                index = v35
            });

            if u1.Selectable({ "Double click Selectable", 3, true }, {
                index = v35
            }).doubleClicked() then
                v35:set(3);
            end;

            u1.Selectable({ "Impossible to select", 4, true }, {
                index = v35
            });

            if u1.Button({ "Select last" }).clicked() then
                v35:set(4);
            end;

            u1.Selectable({ "Independent Selectable" });
            u1.End();
        end,

        Combo = function() -- Line: 288, Name: Combo
            -- upvalues: u1 (copy)
            u1.Tree({ "Combo" });
            u1.PushConfig({
                ContentWidth = UDim.new(1, -120)
            });
            local v36 = u1.State("No Selection");
            u1.SameLine();
            local v37 = u1.Checkbox({ "No Preview" });
            local v38 = u1.Checkbox({ "No Button" });

            if v37.checked() and v38.isChecked.value == true then
                v38.isChecked:set(false);
            end;

            if v38.checked() and v37.isChecked.value == true then
                v37.isChecked:set(false);
            end;

            u1.End();
            u1.Combo({ "Basic Usage", v38.isChecked:get(), v37.isChecked:get() }, {
                index = v36
            });
            u1.Selectable({ "Select 1", "One" }, {
                index = v36
            });
            u1.Selectable({ "Select 2", "Two" }, {
                index = v36
            });
            u1.Selectable({ "Select 3", "Three" }, {
                index = v36
            });
            u1.End();
            u1.ComboArray({ "Using ComboArray" }, {
                index = "No Selection"
            }, { "Red", "Green", "Blue" });
            local v39 = u1.State("7 AM");
            u1.Combo({ "Combo with Inner widgets" }, {
                index = v39
            });
            u1.Tree({ "Morning Shifts" });
            u1.Selectable({ "Shift at 7 AM", "7 AM" }, {
                index = v39
            });
            u1.Selectable({ "Shift at 11 AM", "11 AM" }, {
                index = v39
            });
            u1.Selectable({ "Shist at 3 PM", "3 PM" }, {
                index = v39
            });
            u1.End();
            u1.Tree({ "Night Shifts" });
            u1.Selectable({ "Shift at 6 PM", "6 PM" }, {
                index = v39
            });
            u1.Selectable({ "Shift at 9 PM", "9 PM" }, {
                index = v39
            });
            u1.End();
            u1.End();
            local v40 = u1.ComboEnum({ "Using ComboEnum" }, {
                index = Enum.UserInputState.Begin
            }, Enum.UserInputState);
            u1.Text({ "Selected: " .. v40.index:get().Name });
            u1.PopConfig();
            u1.End();
        end
    };
    local u42 = { "Basic", "Tree", "CollapsingHeader", "Group", "Indent", "Input", "MultiInput", "InputText", "Tooltip", "Selectable", "Combo" };

    local function recursiveTree() -- Line: 331
        -- upvalues: u1 (copy), recursiveTree (copy)
        if u1.Tree({ "Recursive Tree" }).state.isUncollapsed.value then
            recursiveTree();
        end;

        u1.End();
    end;

    local function recursiveWindow(p43) -- Line: 339
        -- upvalues: u1 (copy), recursiveWindow (copy)
        u1.Window({ "Recursive Window" }, {
            size = u1.State(Vector2.new(175, 100)),
            isOpened = p43
        });
        local v44 = u1.Checkbox({ "Recurse Again" });
        u1.End();

        if v44.isChecked.value then
            recursiveWindow(v44.isChecked);
        end;
    end;

    local function runtimeInfo() -- Line: 349
        -- upvalues: u1 (copy), u4 (copy), helpMarker (copy)
        local v45 = u1.Window({ "Runtime Info" }, {
            isOpened = u4
        });
        local _lastVDOM = u1.Internal._lastVDOM;
        local _states = u1.Internal._states;
        local v46 = u1.State(3);
        local v47 = u1.State(0);
        local v48 = u1.State(os.clock());
        u1.SameLine();
        u1.InputNum({
            "",
            [u1.Args.InputNum.Format] = "%d Seconds",
            [u1.Args.InputNum.Max] = 10
        }, {
            number = v46
        });

        if u1.Button({ "Disable" }).clicked() then
            u1.Disabled = true;
            task.delay(v46:get(), function() -- Line: 362
                -- upvalues: u1 (ref)
                u1.Disabled = false;
            end);
        end;

        u1.End();
        local os_clock_ret = os.clock();
        v47.value = v47.value + (os_clock_ret - v48.value - v47.value) * 0.2;
        v48.value = os_clock_ret;
        u1.Text({ string.format("Average %.3f ms/frame (%.1f FPS)", v47.value * 1000, 1 / v47.value) });
        u1.Text({ string.format("Window Position: (%d, %d), Window Size: (%d, %d)", v45.position.value.X, v45.position.value.Y, v45.size.value.X, v45.size.value.Y) });
        u1.SameLine();
        u1.Text({ "Enter an ID to learn more about it." });
        helpMarker("every widget and state has an ID which Iris tracks to remember which widget is which. below lists all widgets and states, with their respective IDs");
        u1.End();
        u1.PushConfig({
            ItemWidth = UDim.new(1, -150)
        });
        local value = u1.InputText({ "ID field" }, {
            text = u1.State(v45.ID)
        }).text.value;
        u1.PopConfig();
        u1.Indent();
        local v49 = _lastVDOM[value];
        local v50 = _states[value];

        if v49 then
            u1.Table({
                1,
                [u1.Args.Table.RowBg] = false
            });
            u1.Text({ string.format("The ID, \"%s\", is a widget", value) });
            u1.NextRow();
            u1.Text({ string.format("Widget is type: %s", v49.type) });
            u1.NextRow();
            u1.Tree({ "Widget has Args:" }, {
                isUncollapsed = u1.State(true)
            });

            for i, v in v49.arguments do
                u1.Text({ i .. " - " .. tostring(v) });
            end;

            u1.End();
            u1.NextRow();

            if v49.state then
                u1.Tree({ "Widget has State:" }, {
                    isUncollapsed = u1.State(true)
                });

                for i, v in v49.state do
                    u1.Text({ i .. " - " .. tostring(v.value) });
                end;

                u1.End();
            end;

            u1.End();
        elseif v50 then
            u1.Table({
                1,
                [u1.Args.Table.RowBg] = false
            });
            u1.Text({ string.format("The ID, \"%s\", is a state", value) });
            u1.NextRow();
            u1.Text({ string.format("Value is type: %s, Value = %s", typeof(v50.value), (tostring(v50.value))) });
            u1.NextRow();
            u1.Tree({ "state has connected widgets:" }, {
                isUncollapsed = u1.State(true)
            });

            for i, v in v50.ConnectedWidgets do
                u1.Text({ i .. " - " .. v.type });
            end;

            u1.End();
            u1.NextRow();
            u1.Text({ string.format("state has: %d connected functions", #v50.ConnectedFunctions) });
            u1.End();
        else
            u1.Text({ string.format("The ID, \"%s\", is not a state or widget", value) });
        end;

        u1.End();

        if u1.Tree({ "Widgets" }).isUncollapsed.value then
            local v51 = 0;
            local v52 = "";

            for _, v in _lastVDOM do
                v51 = v51 + 1;
                v52 = v52 .. "\n" .. v.ID .. " - " .. v.type;
            end;

            u1.Text({ "Number of Widgets: " .. v51 });
            u1.Text({ v52 });
        end;

        u1.End();

        if u1.Tree({ "States" }).isUncollapsed.value then
            local v53 = 0;
            local v54 = "";

            for i, v in _states do
                v53 = v53 + 1;
                v54 = v54 .. "\n" .. i .. " - " .. tostring(v.value);
            end;

            u1.Text({ "Number of States: " .. v53 });
            u1.Text({ v54 });
        end;

        u1.End();
        u1.End();
    end;

    local function recursiveMenu() -- Line: 464
        -- upvalues: u1 (copy), recursiveMenu (copy)
        if u1.Menu({ "Recursive" }).state.isOpened.value then
            u1.MenuItem({ "New", Enum.KeyCode.N, Enum.ModifierKey.Ctrl });
            u1.MenuItem({ "Open", Enum.KeyCode.O, Enum.ModifierKey.Ctrl });
            u1.MenuItem({ "Save", Enum.KeyCode.S, Enum.ModifierKey.Ctrl });
            u1.Separator();
            u1.MenuToggle({ "Autosave" });
            u1.MenuToggle({ "Checked" });
            u1.Separator();
            u1.Menu({ "Options" });
            u1.MenuItem({ "Red" });
            u1.MenuItem({ "Yellow" });
            u1.MenuItem({ "Green" });
            u1.MenuItem({ "Blue" });
            u1.Separator();
            recursiveMenu();
            u1.End();
        end;

        u1.End();
    end;

    local function mainMenuBar() -- Line: 488
        -- upvalues: u1 (copy), recursiveMenu (copy), u3 (copy), u6 (copy), u7 (copy), u4 (copy), u5 (copy)
        u1.MenuBar();
        u1.Menu({ "File" });
        u1.MenuItem({ "New", Enum.KeyCode.N, Enum.ModifierKey.Ctrl });
        u1.MenuItem({ "Open", Enum.KeyCode.O, Enum.ModifierKey.Ctrl });
        u1.MenuItem({ "Save", Enum.KeyCode.S, Enum.ModifierKey.Ctrl });
        recursiveMenu();
        u1.MenuItem({ "Quit", Enum.KeyCode.Q, Enum.ModifierKey.Alt });
        u1.End();
        u1.Menu({ "Examples" });
        u1.MenuToggle({ "Recursive Window" }, {
            isChecked = u3
        });
        u1.MenuToggle({ "Windowless" }, {
            isChecked = u6
        });
        u1.MenuToggle({ "Main Menu Bar" }, {
            isChecked = u7
        });
        u1.End();
        u1.Menu({ "Tools" });
        u1.MenuToggle({ "Runtime Info" }, {
            isChecked = u4
        });
        u1.MenuToggle({ "Style Editor" }, {
            isChecked = u5
        });
        u1.End();
        u1.End();
    end;

    local function mainMenuBarExample() -- Line: 511
        -- upvalues: u1 (copy), mainMenuBar (copy)
        local _ = u1.Internal._rootWidget.Instance.PseudoWindowScreenGui.AbsoluteSize;
        mainMenuBar();
    end;

    local function u65() -- Line: 526
        -- upvalues: u1 (copy), u5 (copy)
        local v55 = u1.State(1);
        local v64 = {
            { "Sizing", function() -- Line: 532
                    -- upvalues: u1 (ref)
                    local v56 = u1.State({});

                    if u1.Button({ "Update Config" }).clicked() then
                        u1.UpdateGlobalConfig(v56:get());
                        v56:set({});
                    end;

                    for _, v in {
                        {
                            "ItemWidth",
                            nil,
                            UDim.new(),
                            UDim.new(1, 200)
                        },
                        {
                            "ContentWidth",
                            nil,
                            UDim.new(),
                            UDim.new(1, 200)
                        }
                    } do
                        local v57 = u1.SliderUDim({ table.unpack(v) }, {
                            number = u1.WeakState(u1._config[v[1]])
                        });

                        if v57.numberChanged() then
                            v56:get()[v[1]] = v57.number:get();
                        end;
                    end;

                    for _, v in {
                        {
                            "WindowPadding",
                            nil,
                            Vector2.zero,
                            Vector2.one * 20
                        },
                        {
                            "WindowResizePadding",
                            nil,
                            Vector2.zero,
                            Vector2.one * 20
                        },
                        {
                            "FramePadding",
                            nil,
                            Vector2.zero,
                            Vector2.one * 20
                        },
                        {
                            "ItemSpacing",
                            nil,
                            Vector2.zero,
                            Vector2.one * 20
                        },
                        {
                            "ItemInnerSpacing",
                            nil,
                            Vector2.zero,
                            Vector2.one * 20
                        },
                        {
                            "CellPadding",
                            nil,
                            Vector2.zero,
                            Vector2.one * 20
                        },
                        {
                            "DisplaySafeAreaPadding",
                            nil,
                            Vector2.zero,
                            Vector2.one * 20
                        }
                    } do
                        local v58 = u1.SliderVector2({ table.unpack(v) }, {
                            number = u1.WeakState(u1._config[v[1]])
                        });

                        if v58.numberChanged() then
                            v56:get()[v[1]] = v58.number:get();
                        end;
                    end;

                    for _, v in { { "TextSize", 1, 4, 20 }, { "FrameBorderSize", 0.1, 0, 1 }, { "FrameRounding", 1, 0, 12 }, { "GrabRounding", 1, 0, 12 }, { "WindowBorderSize", 0.1, 0, 1 }, { "PopupBorderSize", 0.1, 0, 1 }, { "PopupRounding", 1, 0, 12 }, { "ScrollbarSize", 1, 0, 20 }, { "GrabMinSize", 1, 0, 20 } } do
                        local v59 = u1.SliderNum({ table.unpack(v) }, {
                            number = u1.WeakState(u1._config[v[1]])
                        });

                        if v59.numberChanged() then
                            v56:get()[v[1]] = v59.number:get();
                        end;
                    end;

                    for _, v in { "WindowTitleAlign" } do
                        local v60 = u1.ComboEnum({ v }, {
                            index = u1.WeakState(u1._config[v])
                        }, u1._config[v].EnumType);

                        if v60.closed() then
                            u1.UpdateGlobalConfig({
                                [v] = v60.index:get()
                            });
                        end;
                    end;
                end },
            { "Colors", function() -- Line: 599
                    -- upvalues: u1 (ref)
                    local v61 = u1.State({});

                    if u1.Button({ "Update Config" }).clicked() then
                        u1.UpdateGlobalConfig(v61:get());
                        v61:set({});
                    end;

                    for _, v in { "BorderColor", "BorderActiveColor" } do
                        local v62 = u1.InputColor3({ v }, {
                            color = u1.WeakState(u1._config[v])
                        });

                        if v62.numberChanged() then
                            u1.UpdateGlobalConfig({
                                [v] = v62.color:get()
                            });
                        end;
                    end;

                    for _, v in { "Text", "TextDisabled", "WindowBg", "ScrollbarGrab", "TitleBg", "TitleBgActive", "TitleBgCollapsed", "MenubarBg", "FrameBg", "FrameBgHovered", "FrameBgActive", "Button", "ButtonHovered", "ButtonActive", "SliderGrab", "SliderGrabActive", "Header", "HeaderHovered", "HeaderActive", "SelectionImageObject", "SelectionImageObjectBorder", "TableBorderStrong", "TableBorderLight", "TableRowBg", "TableRowBgAlt", "NavWindowingHighlight", "NavWindowingDimBg", "Separator", "CheckMark" } do
                        local v63 = u1.InputColor4({ v }, {
                            color = u1.WeakState(u1._config[v .. "Color"]),
                            transparency = u1.WeakState(u1._config[v .. "Transparency"])
                        });

                        if v63.numberChanged() then
                            v61:get()[v .. "Color"] = v63.color:get();
                            v61:get()[v .. "Transparency"] = v63.transparency:get();
                        end;
                    end;
                end }
        };
        u1.Window({ "Style Editor" }, {
            isOpened = u5
        });
        u1.Text({ "Customize the look of Iris in realtime." });
        u1.SameLine();

        if u1.SmallButton({ "Light Theme" }).clicked() then
            u1.UpdateGlobalConfig(u1.TemplateConfig.colorLight);
        end;

        if u1.SmallButton({ "Dark Theme" }).clicked() then
            u1.UpdateGlobalConfig(u1.TemplateConfig.colorDark);
        end;

        u1.End();
        u1.SameLine();

        if u1.SmallButton({ "Classic Size" }).clicked() then
            u1.UpdateGlobalConfig(u1.TemplateConfig.sizeDefault);
        end;

        if u1.SmallButton({ "Larger Size" }).clicked() then
            u1.UpdateGlobalConfig(u1.TemplateConfig.sizeClear);
        end;

        u1.End();

        if u1.SmallButton({ "Reset Everything" }).clicked() then
            u1.UpdateGlobalConfig(u1.TemplateConfig.colorDark);
            u1.UpdateGlobalConfig(u1.TemplateConfig.sizeDefault);
        end;

        u1.Separator();
        u1.SameLine();

        for i, v in ipairs(v64) do
            u1.RadioButton({ v[1], i }, {
                index = v55
            });
        end;

        u1.End();
        v64[v55:get()][2]();
        u1.End();
    end;

    local function widgetEventInteractivity() -- Line: 699
        -- upvalues: u1 (copy)
        u1.CollapsingHeader({ "Widget Event Interactivity" });
        local v66 = u1.State(0);

        if u1.Button({ "Click to increase Number" }).clicked() then
            v66:set(v66:get() + 1);
        end;

        u1.Text({ "The Number is: " .. v66:get() });
        u1.Separator();
        local v67 = u1.State(false);
        local v68 = u1.State("clicked");
        u1.SameLine();
        u1.RadioButton({ "clicked", "clicked" }, {
            index = v68
        });
        u1.RadioButton({ "rightClicked", "rightClicked" }, {
            index = v68
        });
        u1.RadioButton({ "doubleClicked", "doubleClicked" }, {
            index = v68
        });
        u1.RadioButton({ "ctrlClicked", "ctrlClicked" }, {
            index = v68
        });
        u1.End();
        u1.SameLine();

        if u1.Button({ v68:get() .. " to reveal text" })[v68:get()]() then
            v67:set(not v67:get());
        end;

        if v67:get() then
            u1.Text({ "Here i am!" });
        end;

        u1.End();
        u1.Separator();
        local v69 = u1.State(0);
        u1.SameLine();

        if u1.Button({ "Click to show text for 20 frames" }).clicked() then
            v69:set(20);
        end;

        if v69:get() > 0 then
            u1.Text({ "Here i am!" });
        end;

        u1.End();
        local v70 = v69:get() - 1;
        v69:set((math.max(0, v70)));
        u1.Text({ "Text Timer: " .. v69:get() });
        local v71 = u1.Checkbox({ "Event-tracked checkbox" });
        u1.Indent();
        u1.Text({ "unchecked: " .. tostring(v71.unchecked()) });
        u1.Text({ "checked: " .. tostring(v71.checked()) });
        u1.End();
        u1.SameLine();

        if u1.Button({ "Hover over me" }).hovered() then
            u1.Text({ "The button is hovered" });
        end;

        u1.End();
        u1.End();
    end;

    local function widgetStateInteractivity() -- Line: 755
        -- upvalues: u1 (copy)
        u1.CollapsingHeader({ "Widget State Interactivity" });
        local v72 = u1.Checkbox({ "Widget-Generated State" });
        u1.Text({ (`isChecked: {v72.state.isChecked.value}\n`) });
        local v73 = u1.State(false);
        local v74 = u1.Checkbox({ "User-Generated State" }, {
            isChecked = v73
        });
        u1.Text({ (`isChecked: {v74.state.isChecked.value}\n`) });
        local v75 = u1.Checkbox({ "Widget Coupled State" });
        local v76 = u1.Checkbox({ "Coupled to above Checkbox" }, {
            isChecked = v75.state.isChecked
        });
        u1.Text({ (`isChecked: {v76.state.isChecked.value}\n`) });
        local v77 = u1.State(false);
        u1.Checkbox({ "Widget and Code Coupled State" }, {
            isChecked = v77
        });

        if u1.Button({ "Click to toggle above checkbox" }).clicked() then
            v77:set(not v77:get());
        end;

        u1.Text({ (`isChecked: {v77.value}\n`) });
        local v78 = u1.State(true);
        local v80 = u1.ComputedState(v78, function(p79) -- Line: 777
            return not p79;
        end);
        u1.Checkbox({ "ComputedState (dynamic coupling)" }, {
            isChecked = v78
        });
        u1.Checkbox({ "Inverted of above checkbox" }, {
            isChecked = v80
        });
        u1.Text({ (`isChecked: {v80.value}\n`) });
        u1.End();
    end;

    local function dynamicStyle() -- Line: 787
        -- upvalues: u1 (copy), helpMarker (copy)
        u1.CollapsingHeader({ "Dynamic Styles" });
        local v81 = u1.State(0);
        u1.SameLine();

        if u1.Button({ "Change Color" }).clicked() then
            v81:set(math.random());
        end;

        local Text = u1.Text;
        local v82 = {};
        local v83 = v81:get() * 255;
        v82[1] = "Hue: " .. math.floor(v83);
        Text(v82);
        helpMarker("Using PushConfig with a changing value, this can be done with any config field");
        u1.End();
        u1.PushConfig({
            TextColor = Color3.fromHSV(v81:get(), 1, 1)
        });
        u1.Text({ "Text with a unique and changable color" });
        u1.PopConfig();
        u1.End();
    end;

    local function tablesDemo() -- Line: 803
        -- upvalues: u1 (copy), helpMarker (copy)
        local v84 = u1.State(false);
        u1.CollapsingHeader({ "Tables & Columns" }, {
            isUncollapsed = v84
        });

        if v84.value == false then
            u1.End();

            return;
        end;

        u1.SameLine();
        u1.Text({ "Table using NextRow and NextColumn syntax:" });
        helpMarker("calling Iris.NextRow() in the outer loop, and Iris.NextColumn()in the inner loop");
        u1.End();
        u1.Table({ 3 });

        for i = 1, 4 do
            u1.NextRow();
            local v85 = i;

            for i2 = 1, 3 do
                u1.NextColumn();
                u1.Text({ (`Row: {v85}, Column: {i2}`) });
                local _ = i2;
            end;
        end;

        u1.End();
        u1.Text({ "" });
        u1.SameLine();
        u1.Text({ "Table using NextColumn only syntax:" });
        helpMarker("only calling Iris.NextColumn() in the inner loop, the result is identical");
        u1.End();
        u1.Table({ 2 });

        for i = 1, 4 do
            local v86 = i;

            for i2 = 1, 2 do
                u1.NextColumn();
                u1.Text({ (`Row: {v86}, Column: {i2}`) });
                local _ = i2;
            end;
        end;

        u1.End();
        u1.Separator();
        local v87 = u1.State(false);
        local v88 = u1.State(false);
        local v89 = u1.State(true);
        local v90 = u1.State(true);
        local v91 = u1.State(3);
        u1.Text({ "Table with Customizable Arguments" });
        u1.Table({
            4,
            [u1.Args.Table.RowBg] = v87.value,
            [u1.Args.Table.BordersOuter] = v88.value,
            [u1.Args.Table.BordersInner] = v89.value
        });

        for i = 1, v91:get() do
            local v92 = i;

            for i2 = 1, 4 do
                u1.NextColumn();
                local v93;

                if v90.value then
                    u1.Button({ (`Month: {v92}, Week: {i2}`) });
                    v93 = i2;
                else
                    u1.Text({ (`Month: {v92}, Week: {i2}`) });
                    v93 = i2;
                end;
            end;
        end;

        u1.End();
        u1.Checkbox({ "RowBg" }, {
            isChecked = v87
        });
        u1.Checkbox({ "BordersOuter" }, {
            isChecked = v88
        });
        u1.Checkbox({ "BordersInner" }, {
            isChecked = v89
        });
        u1.SameLine();
        u1.RadioButton({ "Buttons", true }, {
            index = v90
        });
        u1.RadioButton({ "Text", false }, {
            index = v90
        });
        u1.End();
        u1.InputNum({
            "Number of rows",
            [u1.Args.InputNum.Min] = 0,
            [u1.Args.InputNum.Max] = 100,
            [u1.Args.InputNum.Format] = "%d"
        }, {
            number = v91
        });
        u1.End();
    end;

    local function layoutDemo() -- Line: 888
        -- upvalues: u1 (copy), helpMarker (copy)
        u1.CollapsingHeader({ "Widget Layout" });
        u1.Tree({ "Content Width" });
        local v94 = u1.State(50);
        local v95 = u1.State(Enum.Axis.X);
        u1.Text({ "The Content Width is a size property which determines the width of input fields." });
        u1.SameLine();
        u1.Text({ "By default the value is UDim.new(0.65, 0)" });
        helpMarker("This is the default value from Dear ImGui.\nIt is 65% of the window width.");
        u1.End();
        u1.Text({ "This works well, but sometimes we know how wide elements are going to be and want to maximise the space." });
        u1.Text({ "Therefore, we can use Iris.PushConfig() to change the width" });
        u1.Separator();
        u1.SameLine();
        u1.Text({ "Content Width = 150 pixels" });
        helpMarker("UDim.new(0, 150)");
        u1.End();
        u1.PushConfig({
            ContentWidth = UDim.new(0, 150)
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v94
        });
        u1.ComboEnum({ "axis" }, {
            index = v95
        }, Enum.Axis);
        u1.PopConfig();
        u1.SameLine();
        u1.Text({ "Content Width = 50% window width" });
        helpMarker("UDim.new(0.5, 0)");
        u1.End();
        u1.PushConfig({
            ContentWidth = UDim.new(0.5, 0)
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v94
        });
        u1.ComboEnum({ "axis" }, {
            index = v95
        }, Enum.Axis);
        u1.PopConfig();
        u1.SameLine();
        u1.Text({ "Content Width = -150 pixels from the right side" });
        helpMarker("UDim.new(1, -150)");
        u1.End();
        u1.PushConfig({
            ContentWidth = UDim.new(1, -150)
        });
        u1.DragNum({ "number", 1, 0, 100 }, {
            number = v94
        });
        u1.InputEnum({ "axis" }, {
            index = v95
        }, Enum.Axis);
        u1.PopConfig();
        u1.End();
        u1.End();
    end;

    local function windowlessDemo() -- Line: 935
        -- upvalues: u1 (copy), helpMarker (copy)
        u1.PushConfig({
            ItemWidth = UDim.new(0, 150)
        });
        u1.SameLine();
        u1.TextWrapped({ "Windowless widgets" });
        helpMarker("Widgets which are placed outside of a window will appear on the top left side of the screen.");
        u1.End();
        u1.Button({});
        u1.Tree({});
        u1.InputText({});
        u1.End();
        u1.PopConfig();
    end;

    return function() -- Line: 949
        -- upvalues: u1 (copy), u2 (copy), mainMenuBar (copy), widgetEventInteractivity (copy), widgetStateInteractivity (copy), recursiveTree (copy), dynamicStyle (copy), u42 (copy), u41 (copy), tablesDemo (copy), layoutDemo (copy), u3 (copy), recursiveWindow (copy), u4 (copy), runtimeInfo (copy), u5 (copy), u65 (ref), u6 (copy), windowlessDemo (copy), u7 (copy)
        local v96 = u1.State(false);
        local v97 = u1.State(false);
        local v98 = u1.State(false);
        local v99 = u1.State(true);
        local v100 = u1.State(false);
        local v101 = u1.State(false);
        local v102 = u1.State(false);
        local v103 = u1.State(false);
        local v104 = u1.State(false);

        if u2.value == false then
            u1.Checkbox({ "Open main window" }, {
                isChecked = u2
            });

            return;
        end;

        u1.Window({
            "Iris Demo Window",
            [u1.Args.Window.NoTitleBar] = v96.value,
            [u1.Args.Window.NoBackground] = v97.value,
            [u1.Args.Window.NoCollapse] = v98.value,
            [u1.Args.Window.NoClose] = v99.value,
            [u1.Args.Window.NoMove] = v100.value,
            [u1.Args.Window.NoScrollbar] = v101.value,
            [u1.Args.Window.NoResize] = v102.value,
            [u1.Args.Window.NoNav] = v103.value,
            [u1.Args.Window.NoMenu] = v104.value
        }, {
            size = u1.State(Vector2.new(600, 550)),
            position = u1.State(Vector2.new(100, 25)),
            isOpened = u2
        });
        mainMenuBar();
        u1.Text({ "Iris says hello. (2.1.1)" });
        u1.CollapsingHeader({ "Window Options" });
        u1.Table({ 3, false, false, false });
        u1.NextColumn();
        u1.Checkbox({ "NoTitleBar" }, {
            isChecked = v96
        });
        u1.NextColumn();
        u1.Checkbox({ "NoBackground" }, {
            isChecked = v97
        });
        u1.NextColumn();
        u1.Checkbox({ "NoCollapse" }, {
            isChecked = v98
        });
        u1.NextColumn();
        u1.Checkbox({ "NoClose" }, {
            isChecked = v99
        });
        u1.NextColumn();
        u1.Checkbox({ "NoMove" }, {
            isChecked = v100
        });
        u1.NextColumn();
        u1.Checkbox({ "NoScrollbar" }, {
            isChecked = v101
        });
        u1.NextColumn();
        u1.Checkbox({ "NoResize" }, {
            isChecked = v102
        });
        u1.NextColumn();
        u1.Checkbox({ "NoNav" }, {
            isChecked = v103
        });
        u1.NextColumn();
        u1.Checkbox({ "NoMenu" }, {
            isChecked = v104
        });
        u1.End();
        u1.End();
        widgetEventInteractivity();
        widgetStateInteractivity();
        u1.CollapsingHeader({ "Recursive Tree" });

        if u1.Tree({ "Recursive Tree" }).state.isUncollapsed.value then
            recursiveTree();
        end;

        u1.End();
        u1.End();
        dynamicStyle();
        u1.Separator();
        u1.CollapsingHeader({ "Widgets" });

        for _, v in u42 do
            u41[v]();
        end;

        u1.End();
        tablesDemo();
        layoutDemo();
        u1.End();

        if u3.value then
            recursiveWindow(u3);
        end;

        if u4.value then
            runtimeInfo();
        end;

        if u5.value then
            u65();
        end;

        if u6.value then
            windowlessDemo();
        end;

        if u7.value then
            local _ = u1.Internal._rootWidget.Instance.PseudoWindowScreenGui.AbsoluteSize;
            mainMenuBar();
        end;
    end;
end;