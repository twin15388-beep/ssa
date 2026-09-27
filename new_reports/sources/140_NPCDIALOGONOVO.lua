-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local ProximityPromptService = game:GetService("ProximityPromptService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local u1 = {
    [Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/xboxX.png",
    [Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/xboxY.png",
    [Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/xboxA.png",
    [Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/xboxB.png",
    [Enum.KeyCode.DPadLeft] = "rbxasset://textures/ui/Controls/dpadLeft.png",
    [Enum.KeyCode.DPadRight] = "rbxasset://textures/ui/Controls/dpadRight.png",
    [Enum.KeyCode.DPadUp] = "rbxasset://textures/ui/Controls/dpadUp.png",
    [Enum.KeyCode.DPadDown] = "rbxasset://textures/ui/Controls/dpadDown.png",
    [Enum.KeyCode.ButtonSelect] = "rbxasset://textures/ui/Controls/xboxmenu.png",
    [Enum.KeyCode.ButtonL1] = "rbxasset://textures/ui/Controls/xboxLS.png",
    [Enum.KeyCode.ButtonR1] = "rbxasset://textures/ui/Controls/xboxRS.png"
};
local u2 = {
    [Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
    [Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
    [Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
    [Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
};
local u3 = {
    ["\'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
    [","] = "rbxasset://textures/ui/Controls/comma.png",
    ["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
    ["."] = "rbxasset://textures/ui/Controls/period.png",
    [" "] = "rbxasset://textures/ui/Controls/spacebar.png"
};
local u4 = {
    [Enum.KeyCode.LeftControl] = "Ctrl",
    [Enum.KeyCode.RightControl] = "Ctrl",
    [Enum.KeyCode.LeftAlt] = "Alt",
    [Enum.KeyCode.RightAlt] = "Alt",
    [Enum.KeyCode.F1] = "F1",
    [Enum.KeyCode.F2] = "F2",
    [Enum.KeyCode.F3] = "F3",
    [Enum.KeyCode.F4] = "F4",
    [Enum.KeyCode.F5] = "F5",
    [Enum.KeyCode.F6] = "F6",
    [Enum.KeyCode.F7] = "F7",
    [Enum.KeyCode.F8] = "F8",
    [Enum.KeyCode.F9] = "F9",
    [Enum.KeyCode.F10] = "F10",
    [Enum.KeyCode.F11] = "F11",
    [Enum.KeyCode.F12] = "F12"
};

local function getScreenGui() -- Line: 60
    -- upvalues: PlayerGui (copy)
    local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts");

    if ProximityPrompts == nil then
        ProximityPrompts = Instance.new("ScreenGui");
        ProximityPrompts.Name = "ProximityPrompts";
        ProximityPrompts.ResetOnSpawn = false;
        ProximityPrompts.Parent = PlayerGui;
    end;

    return ProximityPrompts;
end;

local function setUpCircularProgressBar(p5) -- Line: 71
    local UIGradient = p5.LeftGradient.ProgressBarImage.UIGradient;
    local UIGradient2 = p5.RightGradient.ProgressBarImage.UIGradient;
    p5.Progress.Changed:Connect(function(p6) -- Line: 76
        -- upvalues: UIGradient (copy), UIGradient2 (copy)
        local math_clamp_ret = math.clamp(p6 * 360, 0, 360);
        UIGradient.Rotation = math.clamp(math_clamp_ret, 180, 360);
        UIGradient2.Rotation = math.clamp(math_clamp_ret, 0, 180);
    end);
end;

local function createPrompt(u7, p8, p9) -- Line: 83
    -- upvalues: TweenService (copy), u1 (copy), UserInputService (copy), u2 (copy), u3 (copy), u4 (copy), TextService (copy)
    local u10 = {};
    local u11 = {};
    local u12 = {};
    local u13 = {};
    local TweenInfo_new_ret = TweenInfo.new(u7.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local TweenInfo_new_ret2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local TweenInfo_new_ret3 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local TweenInfo_new_ret4 = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u14 = nil;
    local Attribute = u7:GetAttribute("Theme");

    if Attribute then
        local v15 = script:FindFirstChild(Attribute);

        if v15 then
            u14 = v15:Clone();
        end;
    end;

    if u14 == nil then
        u14 = script.Default:Clone();
    end;

    u14.Enabled = true;
    local PromptFrame = u14.PromptFrame;
    local InputFrame = PromptFrame.InputFrame;
    local ActionText = PromptFrame.ActionText;
    local ObjectText = PromptFrame.ObjectText;
    local BackgroundTransparency = PromptFrame.BackgroundTransparency;
    local ImageTransparency = PromptFrame.ImageTransparency;
    PromptFrame.BackgroundTransparency = 1;
    PromptFrame.ImageTransparency = 1;
    local v16 = {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    };
    table.insert(u10, TweenService:Create(PromptFrame, TweenInfo_new_ret2, v16));
    local v17 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    };
    table.insert(u11, TweenService:Create(PromptFrame, TweenInfo_new_ret2, v17));
    local v18 = {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Size = UDim2.fromScale(0.5, 1)
    };
    table.insert(u12, TweenService:Create(PromptFrame, TweenInfo_new_ret2, v18));
    local v19 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = BackgroundTransparency,
        ImageTransparency = ImageTransparency
    };
    table.insert(u13, TweenService:Create(PromptFrame, TweenInfo_new_ret2, v19));

    local function setupUIStrokeTweens(p20) -- Line: 126
        -- upvalues: u10 (copy), TweenService (ref), TweenInfo_new_ret2 (copy), u11 (copy), u12 (copy), u13 (copy)
        local Transparency = p20.Transparency;
        p20.Transparency = 1;
        table.insert(u10, TweenService:Create(p20, TweenInfo_new_ret2, {
            Transparency = 1
        }));
        table.insert(u11, TweenService:Create(p20, TweenInfo_new_ret2, {
            Transparency = Transparency
        }));
        table.insert(u12, TweenService:Create(p20, TweenInfo_new_ret2, {
            Transparency = 1
        }));
        table.insert(u13, TweenService:Create(p20, TweenInfo_new_ret2, {
            Transparency = Transparency
        }));
    end;

    local function setupGUIObjectTweens(p21) -- Line: 135
        -- upvalues: u10 (copy), TweenService (ref), TweenInfo_new_ret2 (copy), u11 (copy), u12 (copy), u13 (copy)
        local BackgroundTransparency2 = p21.BackgroundTransparency;
        p21.BackgroundTransparency = 1;
        table.insert(u10, TweenService:Create(p21, TweenInfo_new_ret2, {
            BackgroundTransparency = 1
        }));
        table.insert(u11, TweenService:Create(p21, TweenInfo_new_ret2, {
            BackgroundTransparency = BackgroundTransparency2
        }));
        table.insert(u12, TweenService:Create(p21, TweenInfo_new_ret2, {
            BackgroundTransparency = 1
        }));
        table.insert(u13, TweenService:Create(p21, TweenInfo_new_ret2, {
            BackgroundTransparency = BackgroundTransparency2
        }));
    end;

    local function setupTextLabelTweens(p22) -- Line: 144
        -- upvalues: u10 (copy), TweenService (ref), TweenInfo_new_ret2 (copy), u11 (copy), u12 (copy), u13 (copy)
        local TextTransparency = p22.TextTransparency;
        local TextStrokeTransparency = p22.TextStrokeTransparency;
        p22.TextTransparency = 1;
        p22.TextStrokeTransparency = 1;
        table.insert(u10, TweenService:Create(p22, TweenInfo_new_ret2, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u11, TweenService:Create(p22, TweenInfo_new_ret2, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
        table.insert(u12, TweenService:Create(p22, TweenInfo_new_ret2, {
            TextTransparency = 1,
            TextStrokeTransparency = 1
        }));
        table.insert(u13, TweenService:Create(p22, TweenInfo_new_ret2, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency
        }));
    end;

    local function setupImageLabelTweens(p23) -- Line: 155
        -- upvalues: u10 (copy), TweenService (ref), TweenInfo_new_ret2 (copy), u11 (copy), u12 (copy), u13 (copy)
        local ImageTransparency2 = p23.ImageTransparency;
        p23.ImageTransparency = 1;
        table.insert(u10, TweenService:Create(p23, TweenInfo_new_ret2, {
            ImageTransparency = 1
        }));
        table.insert(u11, TweenService:Create(p23, TweenInfo_new_ret2, {
            ImageTransparency = ImageTransparency2
        }));
        table.insert(u12, TweenService:Create(p23, TweenInfo_new_ret2, {
            ImageTransparency = 1
        }));
        table.insert(u13, TweenService:Create(p23, TweenInfo_new_ret2, {
            ImageTransparency = ImageTransparency2
        }));
    end;

    local function setupUnexpectedChildTweens(p24) -- Line: 164
        -- upvalues: setupUIStrokeTweens (copy), setupGUIObjectTweens (copy), setupTextLabelTweens (copy), setupImageLabelTweens (copy), setupUnexpectedChildTweens (copy)
        if p24:IsA("UIStroke") then
            setupUIStrokeTweens(p24);
        elseif not p24:IsA("UIGradient") and p24:IsA("GuiObject") then
            setupGUIObjectTweens(p24);

            if p24:IsA("TextLabel") then
                setupTextLabelTweens(p24);
            elseif p24:IsA("ImageLabel") then
                setupImageLabelTweens(p24);
            end;
        end;

        for _, child in pairs(p24:GetChildren()) do
            setupUnexpectedChildTweens(child);
        end;
    end;

    local v25 = {
        [InputFrame] = false,
        [ActionText] = true,
        [ObjectText] = true
    };

    for _, child in pairs(PromptFrame:GetChildren()) do
        if v25[child] == nil then
            setupUnexpectedChildTweens(child);
        elseif v25[child] == true then
            for _, child2 in pairs(child:GetChildren()) do
                setupUnexpectedChildTweens(child2);
            end;
        end;
    end;

    local Frame = InputFrame.Frame;
    local UIScale = Frame.UIScale;
    table.insert(u10, TweenService:Create(UIScale, TweenInfo_new_ret2, {
        Scale = p8 == Enum.ProximityPromptInputType.Touch and 1.6 or 1.33
    }));
    table.insert(u11, TweenService:Create(UIScale, TweenInfo_new_ret2, {
        Scale = 1
    }));
    setupTextLabelTweens(ActionText);
    setupTextLabelTweens(ObjectText);
    local ButtonFrame = Frame.ButtonFrame;
    local BackgroundTransparency2 = ButtonFrame.BackgroundTransparency;
    local ImageTransparency2 = ButtonFrame.ImageTransparency;
    table.insert(u12, TweenService:Create(ButtonFrame, TweenInfo_new_ret3, {
        BackgroundTransparency = 1,
        ImageTransparency = 1
    }));
    table.insert(u13, TweenService:Create(ButtonFrame, TweenInfo_new_ret3, {
        BackgroundTransparency = BackgroundTransparency2,
        ImageTransparency = ImageTransparency2
    }));
    local ButtonText = Frame.ButtonText;
    local ButtonTextImage = Frame.ButtonTextImage;
    local ButtonImage = Frame.ButtonImage;

    local function setupButtonTextTweens() -- Line: 220
        -- upvalues: ButtonText (copy), u12 (copy), TweenService (ref), TweenInfo_new_ret3 (copy), u13 (copy)
        local TextTransparency = ButtonText.TextTransparency;
        local TextStrokeTransparency = ButtonText.TextStrokeTransparency;
        local BackgroundTransparency3 = ButtonText.BackgroundTransparency;
        ButtonText.BackgroundTransparency = 1;
        ButtonText.TextStrokeTransparency = 1;
        ButtonText.TextTransparency = 1;
        table.insert(u12, TweenService:Create(ButtonText, TweenInfo_new_ret3, {
            TextTransparency = 1,
            TextStrokeTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u13, TweenService:Create(ButtonText, TweenInfo_new_ret3, {
            TextTransparency = TextTransparency,
            TextStrokeTransparency = TextStrokeTransparency,
            BackgroundTransparency = BackgroundTransparency3
        }));

        for _, v in pairs(ButtonText:getChildren()) do
            if v:IsA("UIStroke") then
                local Transparency = v.Transparency;
                table.insert(u12, TweenService:Create(v, TweenInfo_new_ret3, {
                    Transparency = 1
                }));
                table.insert(u13, TweenService:Create(v, TweenInfo_new_ret3, {
                    Transparency = Transparency
                }));
            end;
        end;
    end;

    local function setupButtonImageTweens() -- Line: 240
        -- upvalues: ButtonImage (copy), u12 (copy), TweenService (ref), TweenInfo_new_ret3 (copy), u13 (copy)
        local ImageTransparency3 = ButtonImage.ImageTransparency;
        local BackgroundTransparency3 = ButtonImage.BackgroundTransparency;
        ButtonImage.BackgroundTransparency = 1;
        ButtonImage.ImageTransparency = 1;
        table.insert(u12, TweenService:Create(ButtonImage, TweenInfo_new_ret3, {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u13, TweenService:Create(ButtonImage, TweenInfo_new_ret3, {
            ImageTransparency = ImageTransparency3,
            BackgroundTransparency = BackgroundTransparency3
        }));
    end;

    local function setupIconTweens() -- Line: 249
        -- upvalues: ButtonTextImage (copy), u12 (copy), TweenService (ref), TweenInfo_new_ret3 (copy), u13 (copy)
        local BackgroundTransparency3 = ButtonTextImage.BackgroundTransparency;
        local ImageTransparency3 = ButtonTextImage.ImageTransparency;
        ButtonTextImage.BackgroundTransparency = 1;
        ButtonTextImage.ImageTransparency = 1;
        table.insert(u12, TweenService:Create(ButtonTextImage, TweenInfo_new_ret3, {
            ImageTransparency = 1,
            BackgroundTransparency = 1
        }));
        table.insert(u13, TweenService:Create(ButtonTextImage, TweenInfo_new_ret3, {
            ImageTransparency = ImageTransparency3,
            BackgroundTransparency = BackgroundTransparency3
        }));
    end;

    if p8 == Enum.ProximityPromptInputType.Gamepad then
        if u1[u7.GamepadKeyCode] then
            setupIconTweens();
            ButtonTextImage.Size = UDim2.fromOffset(24, 24);
            ButtonTextImage.Image = u1[u7.GamepadKeyCode];
            ButtonText.Visible = false;
            ButtonImage.Visible = false;
            ButtonTextImage.Visible = true;
        end;
    elseif p8 == Enum.ProximityPromptInputType.Touch then
        setupButtonImageTweens();
        ButtonImage.Size = UDim2.fromOffset(25, 31);
        ButtonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png";
        ButtonText.Visible = false;
        ButtonTextImage.Visible = false;
        ButtonImage.Visible = true;
    else
        setupButtonImageTweens();
        ButtonImage.Size = UDim2.fromOffset(28, 30);
        ButtonImage.Visible = true;
        local StringForKeyCode = UserInputService:GetStringForKeyCode(u7.KeyboardKeyCode);
        local v26 = u2[u7.KeyboardKeyCode];

        if v26 == nil then
            v26 = u3[StringForKeyCode];
        end;

        if v26 == nil then
            StringForKeyCode = u4[u7.KeyboardKeyCode] or StringForKeyCode;
        end;

        if v26 then
            setupIconTweens();
            ButtonTextImage.Size = UDim2.fromOffset(36, 36);
            ButtonTextImage.Image = v26;
            ButtonText.Visible = false;
            ButtonTextImage.Visible = true;
        elseif StringForKeyCode == nil or StringForKeyCode == "" then
            error("ProximityPrompt \'" .. u7.Name .. "\' has an unsupported keycode for rendering UI: " .. tostring(u7.KeyboardKeyCode));
        else
            if string.len(StringForKeyCode) > 2 then
                ButtonText.TextSize = math.round(ButtonText.TextSize * 6 / 7);
            end;

            setupButtonTextTweens();
            ButtonText.Text = StringForKeyCode;
            ButtonTextImage.Visible = false;
            ButtonText.Visible = true;
        end;
    end;

    if p8 == Enum.ProximityPromptInputType.Touch or u7.ClickablePrompt then
        local TextButton = u14.TextButton;
        local u27 = false;
        TextButton.InputBegan:Connect(function(p28) -- Line: 327
            -- upvalues: u7 (copy), u27 (ref)
            if (p28.UserInputType == Enum.UserInputType.Touch or p28.UserInputType == Enum.UserInputType.MouseButton1) and p28.UserInputState ~= Enum.UserInputState.Change then
                u7:InputHoldBegin();
                u27 = true;
            end;
        end);
        TextButton.InputEnded:Connect(function(p29) -- Line: 334
            -- upvalues: u27 (ref), u7 (copy)
            if (p29.UserInputType == Enum.UserInputType.Touch or p29.UserInputType == Enum.UserInputType.MouseButton1) and u27 then
                u27 = false;
                u7:InputHoldEnd();
            end;
        end);
        u14.Active = true;
    end;

    if u7.HoldDuration > 0 then
        local ProgressBar = Frame.ProgressBar;
        local UIGradient = ProgressBar.LeftGradient.ProgressBarImage.UIGradient;
        local UIGradient2 = ProgressBar.RightGradient.ProgressBarImage.UIGradient;
        ProgressBar.Progress.Changed:Connect(function(p30) -- Line: 76
            -- upvalues: UIGradient (copy), UIGradient2 (copy)
            local math_clamp_ret = math.clamp(p30 * 360, 0, 360);
            UIGradient.Rotation = math.clamp(math_clamp_ret, 180, 360);
            UIGradient2.Rotation = math.clamp(math_clamp_ret, 0, 180);
        end);
        table.insert(u10, TweenService:Create(ProgressBar.Progress, TweenInfo_new_ret, {
            Value = 1
        }));
        table.insert(u11, TweenService:Create(ProgressBar.Progress, TweenInfo_new_ret4, {
            Value = 0
        }));
    end;

    local u31, u32;

    if u7.HoldDuration > 0 then
        u31 = u7.PromptButtonHoldBegan:Connect(function() -- Line: 359
            -- upvalues: u10 (copy)
            for _, v in ipairs(u10) do
                v:Play();
            end;
        end);
        u32 = u7.PromptButtonHoldEnded:Connect(function() -- Line: 365
            -- upvalues: u11 (copy)
            for _, v in ipairs(u11) do
                v:Play();
            end;
        end);
    else
        u31 = nil;
        u32 = nil;
    end;

    local u33 = u7.Triggered:Connect(function() -- Line: 372
        -- upvalues: u12 (copy)
        for _, v in ipairs(u12) do
            v:Play();
        end;
    end);
    local u34 = u7.TriggerEnded:Connect(function() -- Line: 378
        -- upvalues: u13 (copy)
        for _, v in ipairs(u13) do
            v:Play();
        end;
    end);

    local function updateUIFromPrompt() -- Line: 384
        -- upvalues: TextService (ref), u7 (copy), ActionText (copy), ObjectText (copy), u14 (ref)
        local TextSize = TextService:GetTextSize(u7.ActionText, ActionText.TextSize, ActionText.Font, Vector2.new(1000, 1000));
        local TextSize2 = TextService:GetTextSize(u7.ObjectText, ObjectText.TextSize, ObjectText.Font, Vector2.new(1000, 1000));
        local math_max_ret = math.max(TextSize.X, TextSize2.X);
        local v35 = (u7.ActionText == nil or u7.ActionText == "") and (u7.ObjectText == nil or u7.ObjectText == "") and 72 or math_max_ret + 72 + 24;
        local _ = u7.ObjectText == nil or u7.ObjectText == "";
        ActionText.Position = UDim2.new(0.65, -10, 0, -55);
        ObjectText.Position = UDim2.new(0.65, -10, 0, -71);
        ActionText.Text = u7.ActionText;
        ObjectText.Text = u7.ObjectText;
        ActionText.AutoLocalize = u7.AutoLocalize;
        ActionText.RootLocalizationTable = u7.RootLocalizationTable;
        ObjectText.AutoLocalize = u7.AutoLocalize;
        ObjectText.RootLocalizationTable = u7.RootLocalizationTable;
        u14.Size = UDim2.fromOffset(v35, 72);
        u14.SizeOffset = Vector2.new(u7.UIOffset.X / u14.Size.Width.Offset, u7.UIOffset.Y / u14.Size.Height.Offset);
    end;

    local u36 = u7.Changed:Connect(updateUIFromPrompt);
    updateUIFromPrompt();
    u14.Adornee = u7.Parent;
    u14.Parent = p9;

    for _, v in ipairs(u13) do
        v:Play();
    end;

    return function() -- Line: 427, Name: cleanup
        -- upvalues: u31 (ref), u32 (ref), u33 (ref), u34 (ref), u36 (copy), u12 (copy), u14 (ref)
        if u31 then
            u31:Disconnect();
        end;

        if u32 then
            u32:Disconnect();
        end;

        u33:Disconnect();
        u34:Disconnect();
        u36:Disconnect();

        for _, v in ipairs(u12) do
            v:Play();
        end;

        wait(0.2);
        u14.Parent = nil;
    end;
end;

local function onLoad() -- Line: 452
    -- upvalues: ProximityPromptService (copy), PlayerGui (copy), createPrompt (copy)
    ProximityPromptService.PromptShown:Connect(function(p37, p38) -- Line: 453
        -- upvalues: PlayerGui (ref), createPrompt (ref)
        if p37.Style == Enum.ProximityPromptStyle.Default then
            return;
        end;

        local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts");

        if ProximityPrompts == nil then
            ProximityPrompts = Instance.new("ScreenGui");
            ProximityPrompts.Name = "ProximityPrompts";
            ProximityPrompts.ResetOnSpawn = false;
            ProximityPrompts.Parent = PlayerGui;
        end;

        local v39 = createPrompt(p37, p38, ProximityPrompts);
        p37.PromptHidden:Wait();
        v39();
    end);
end;

ProximityPromptService.PromptShown:Connect(function(p40, p41) -- Line: 453
    -- upvalues: PlayerGui (copy), createPrompt (copy)
    if p40.Style == Enum.ProximityPromptStyle.Default then
        return;
    end;

    local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts");

    if ProximityPrompts == nil then
        ProximityPrompts = Instance.new("ScreenGui");
        ProximityPrompts.Name = "ProximityPrompts";
        ProximityPrompts.ResetOnSpawn = false;
        ProximityPrompts.Parent = PlayerGui;
    end;

    local v42 = createPrompt(p40, p41, ProximityPrompts);
    p40.PromptHidden:Wait();
    v42();
end);