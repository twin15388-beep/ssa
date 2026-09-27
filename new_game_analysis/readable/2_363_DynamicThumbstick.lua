-- Decompiled with Potassium's decompiler.

local u1 = { 0.10999999999999999, 0.30000000000000004, 0.4, 0.5, 0.6, 0.7, 0.75 };
local u2 = { 0.55, 0.65, 0.7, 0.75, 0.8, 0.85, 0.875 };
local u3 = #u1;
local Vector2_new_ret = Vector2.new(-1, -1);
local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
local v4 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local UserFlag = v4.getUserFlag("UserPlayerScriptsCCLIntegrationD");
local UserFlag2 = v4.getUserFlag("UserAllowAbilityControlsBonus");
local UserFlag3 = v4.getUserFlag("UserPlayerScriptsFireThroughScriptableBindings");
local UserFlag4 = v4.getUserFlag("UserPlayerScriptsSAuthDirectAPIs2");
local UserFlag5 = v4.getUserFlag("UserDoubleJumpButtonFix");
local UserFlag6 = v4.getUserFlag("UserPlayerScriptsResetDTTouchOnCreate");
local Players = game:GetService("Players");
local GuiService = game:GetService("GuiService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ThumbstickAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("TransformerContext"):WaitForChild("ThumbstickAction");
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"));
local u5;

if UserFlag then
    u5 = AvatarAbilitiesInterface.get(Players.LocalPlayer);
else
    u5 = nil;
end;

local LocalPlayer = Players.LocalPlayer;

if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
    LocalPlayer = Players.LocalPlayer;
end;

local ActionController = require(script.Parent:WaitForChild("ActionController"));
local u6 = setmetatable({}, ActionController);
u6.__index = u6;

function u6.new(p7) -- Line: 69
    -- upvalues: ActionController (copy), u6 (copy)
    local v8 = ActionController.new();
    local v9 = setmetatable(v8, u6);
    v9.playerData = p7;
    v9.enabled = false;
    v9.isTouchActive = false;
    v9.moveTouchFirstChanged = false;
    v9.moveTouchStartPosition = nil;
    v9.startImage = nil;
    v9.endImage = nil;
    v9.endImageStroke = nil;
    v9.endImageCenter = nil;
    v9.middleImages = {};
    v9.startImageFadeTween = nil;
    v9.endImageFadeTween = nil;
    v9.endImageCenterFadeTween = nil;
    v9.middleImageFadeTweens = {};
    v9.isFirstTouch = true;
    v9.thumbstickFrame = nil;
    v9.onRenderSteppedConn = nil;
    v9.fadeInAndOutBalance = 0.5;
    v9.fadeInAndOutHalfDuration = 0.3;
    v9.hasFadedBackgroundInPortrait = false;
    v9.hasFadedBackgroundInLandscape = false;
    v9.tweenInAlphaStart = nil;
    v9.tweenOutAlphaStart = nil;
    v9.newStyle = false;

    return v9;
end;

function u6.GetIsJumping(p10) -- Line: 111
    local isJumping = p10.isJumping;
    p10.isJumping = false;

    return isJumping;
end;

local function setupThumbstickInput(p11) -- Line: 117
    -- upvalues: ThumbstickAction (copy)
    for _, child in ThumbstickAction:GetChildren() do
        if child.Name == "DynamicTouchBinding" or child.Name == "ClassicTouchBinding" then
            child:Destroy();
        end;
    end;

    local InputBinding = Instance.new("InputBinding");
    InputBinding.Name = "DynamicTouchBinding";
    InputBinding.KeyCode = Enum.KeyCode.TouchPosition;
    InputBinding.UIModifier = p11.thumbstickButton;
    InputBinding.Parent = ThumbstickAction;
end;

local function enableThumbstickInput(p12: any, p13: boolean) -- Line: 130
    -- upvalues: setupThumbstickInput (copy), ThumbstickAction (copy)
    if not p13 then
        ThumbstickAction.Enabled = false;

        if p12.thumbstickStateChangedConn then
            p12.thumbstickStateChangedConn:Disconnect();
            p12.thumbstickStateChangedConn = nil;
        end;

        return;
    end;

    setupThumbstickInput(p12);
    p12.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p12.onStateChanged);
    ThumbstickAction.Enabled = true;
end;

function u6.Enable(u14: table, p15: boolean?, u16: any) -- Line: 144
    -- upvalues: ActionController (copy), UserFlag (copy), u5 (copy), UserFlag6 (copy), setupThumbstickInput (copy), ThumbstickAction (copy)
    if p15 == nil then
        return false;
    end;

    local v17 = p15 and true or false;

    if u14.enabled == v17 then
        return true;
    end;

    ActionController.Enable(u14, v17);

    if v17 then
        if not u14.thumbstickFrame then
            u14:Create(u16);

            if UserFlag and not u14.avatarAbilitiesEnabledChangedConn then
                u14.avatarAbilitiesEnabledChangedConn = u5:GetEnabledChangedSignal():Connect(function() -- Line: 155
                    -- upvalues: u14 (copy), u16 (copy), UserFlag6 (ref), setupThumbstickInput (ref), ThumbstickAction (ref)
                    if u14.enabled then
                        u14:Create(u16);

                        if UserFlag6 then
                            local v18 = u14;
                            setupThumbstickInput(v18);
                            v18.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(v18.onStateChanged);
                            ThumbstickAction.Enabled = true;
                        else
                            u14.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(u14.onStateChanged);
                            ThumbstickAction.Enabled = true;
                        end;

                        u14.thumbstickFrame.Visible = true;
                    end;
                end);
            end;
        end;

        if UserFlag6 then
            setupThumbstickInput(u14);
            u14.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(u14.onStateChanged);
            ThumbstickAction.Enabled = true;
        else
            u14.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(u14.onStateChanged);
            ThumbstickAction.Enabled = true;
        end;
    else
        if UserFlag6 then
            ThumbstickAction.Enabled = false;

            if u14.thumbstickStateChangedConn then
                u14.thumbstickStateChangedConn:Disconnect();
                u14.thumbstickStateChangedConn = nil;
            end;
        else
            ThumbstickAction.Enabled = false;

            if u14.thumbstickStateChangedConn then
                u14.thumbstickStateChangedConn:Disconnect();
                u14.thumbstickStateChangedConn = nil;
            end;
        end;

        u14:OnInputEnded();
    end;

    u14.enabled = v17;
    u14.thumbstickFrame.Visible = v17;

    return nil;
end;

function u6.OnInputEnded(p19) -- Line: 196
    -- upvalues: UserFlag4 (copy), UserFlag3 (copy)
    p19.isTouchActive = false;

    if UserFlag4 then
        local DynamicThumbstickScriptableBinding = p19.playerData.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding");

        if DynamicThumbstickScriptableBinding then
            DynamicThumbstickScriptableBinding:Fire(Vector2.zero);
        end;
    elseif UserFlag3 then
        local DynamicThumbstickScriptableBinding = p19.playerData.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding");

        if DynamicThumbstickScriptableBinding then
            local success, _ = pcall(function() -- Line: 206
                -- upvalues: DynamicThumbstickScriptableBinding (copy)
                DynamicThumbstickScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                DynamicThumbstickScriptableBinding:Fire(Vector2.zero);
            end);

            if not success then
                p19.playerData.actions.MoveAction:Fire(Vector2.zero);
            end;
        else
            p19.playerData.actions.MoveAction:Fire(Vector2.zero);
        end;
    else
        p19.playerData.actions.MoveAction:Fire(Vector2.zero);
    end;

    p19:FadeThumbstick(false);
end;

function u6.FadeThumbstick(p20: table, p21: boolean?) -- Line: 222
    -- upvalues: UserFlag (copy), TweenService (copy), TweenInfo_new_ret (copy), u2 (copy), u1 (copy)
    if not p21 and p20.isTouchActive then
        return;
    end;

    if p20.isFirstTouch then
        return;
    end;

    if p20.startImageFadeTween then
        p20.startImageFadeTween:Cancel();
    end;

    if p20.endImageFadeTween then
        p20.endImageFadeTween:Cancel();
    end;

    if UserFlag and p20.endImageCenterFadeTween then
        p20.endImageCenterFadeTween:Cancel();
    end;

    for i = 1, #p20.middleImages do
        local v22;

        if p20.middleImageFadeTweens[i] then
            p20.middleImageFadeTweens[i]:Cancel();
            v22 = i;
        else
            v22 = i;
        end;
    end;

    if p21 then
        if UserFlag and p20.newStyle then
            p20.startImageFadeTween = TweenService:Create(p20.startImage, TweenInfo_new_ret, {
                BackgroundTransparency = 0.4
            });
            p20.startImageFadeTween:Play();
            p20.endImageFadeTween = TweenService:Create(p20.endImageStroke, TweenInfo_new_ret, {
                Transparency = 0
            });
            p20.endImageFadeTween:Play();
            p20.endImageCenterFadeTween = TweenService:Create(p20.endImageCenter, TweenInfo_new_ret, {
                BackgroundTransparency = 0
            });
            p20.endImageCenterFadeTween:Play();
        else
            p20.startImageFadeTween = TweenService:Create(p20.startImage, TweenInfo_new_ret, {
                ImageTransparency = 0
            });
            p20.startImageFadeTween:Play();
            p20.endImageFadeTween = TweenService:Create(p20.endImage, TweenInfo_new_ret, {
                ImageTransparency = 0.2
            });
            p20.endImageFadeTween:Play();
        end;

        for i = 1, #p20.middleImages do
            if UserFlag and p20.newStyle then
                p20.middleImageFadeTweens[i] = TweenService:Create(p20.middleImages[i], TweenInfo_new_ret, {
                    BackgroundTransparency = u2[i]
                });
            else
                p20.middleImageFadeTweens[i] = TweenService:Create(p20.middleImages[i], TweenInfo_new_ret, {
                    ImageTransparency = u1[i]
                });
            end;

            p20.middleImageFadeTweens[i]:Play();
            local _ = i;
        end;

        return;
    end;

    if UserFlag and p20.newStyle then
        p20.startImageFadeTween = TweenService:Create(p20.startImage, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        });
        p20.startImageFadeTween:Play();
        p20.endImageFadeTween = TweenService:Create(p20.endImageStroke, TweenInfo_new_ret, {
            Transparency = 1
        });
        p20.endImageFadeTween:Play();
        p20.endImageCenterFadeTween = TweenService:Create(p20.endImageCenter, TweenInfo_new_ret, {
            BackgroundTransparency = 1
        });
        p20.endImageCenterFadeTween:Play();
    else
        p20.startImageFadeTween = TweenService:Create(p20.startImage, TweenInfo_new_ret, {
            ImageTransparency = 1
        });
        p20.startImageFadeTween:Play();
        p20.endImageFadeTween = TweenService:Create(p20.endImage, TweenInfo_new_ret, {
            ImageTransparency = 1
        });
        p20.endImageFadeTween:Play();
    end;

    for i = 1, #p20.middleImages do
        if UserFlag and p20.newStyle then
            p20.middleImageFadeTweens[i] = TweenService:Create(p20.middleImages[i], TweenInfo_new_ret, {
                BackgroundTransparency = 1
            });
        else
            p20.middleImageFadeTweens[i] = TweenService:Create(p20.middleImages[i], TweenInfo_new_ret, {
                ImageTransparency = 1
            });
        end;

        p20.middleImageFadeTweens[i]:Play();
        local _ = i;
    end;
end;

function u6.FadeThumbstickFrame(p23: table, p24: number, p25: number) -- Line: 298
    p23.fadeInAndOutHalfDuration = p24 * 0.5;
    p23.fadeInAndOutBalance = p25;
    p23.tweenInAlphaStart = tick();
end;

function u6.DoFadeInBackground(p26) -- Line: 304
    -- upvalues: LocalPlayer (ref)
    local v27 = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    local v28 = false;

    if v27 then
        if v27.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or v27.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
            v28 = p26.hasFadedBackgroundInLandscape;
            p26.hasFadedBackgroundInLandscape = true;
        elseif v27.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
            v28 = p26.hasFadedBackgroundInPortrait;
            p26.hasFadedBackgroundInPortrait = true;
        end;
    end;

    if not v28 then
        p26.fadeInAndOutHalfDuration = 0.3;
        p26.fadeInAndOutBalance = 0.5;
        p26.tweenInAlphaStart = tick();
    end;
end;

function u6.DoMove(p29: table, p30) -- Line: 327
    -- upvalues: UserFlag4 (copy), UserFlag3 (copy)
    local v31 = p30;
    local v32;

    if v31.Magnitude < p29.radiusOfDeadZone then
        v32 = Vector2.new();
    else
        v32 = v31.Unit * (1 - math.max(0, (p29.radiusOfMaxSpeed - v31.Magnitude) / p29.radiusOfMaxSpeed));
    end;

    local Vector2_new_ret2 = Vector2.new(v32.X, -v32.Y);

    if UserFlag4 then
        local DynamicThumbstickScriptableBinding = p29.playerData.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding");

        if DynamicThumbstickScriptableBinding then
            DynamicThumbstickScriptableBinding:Fire(Vector2_new_ret2);
        end;
    elseif UserFlag3 then
        local DynamicThumbstickScriptableBinding = p29.playerData.actions.MoveAction:FindFirstChild("DynamicThumbstickScriptableBinding");

        if DynamicThumbstickScriptableBinding then
            local success, _ = pcall(function() -- Line: 349
                -- upvalues: DynamicThumbstickScriptableBinding (copy), Vector2_new_ret2 (ref)
                DynamicThumbstickScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                DynamicThumbstickScriptableBinding:Fire(Vector2_new_ret2);
            end);

            if not success then
                p29.playerData.actions.MoveAction:Fire(Vector2_new_ret2);
            end;
        else
            p29.playerData.actions.MoveAction:Fire(Vector2_new_ret2);
        end;
    else
        p29.playerData.actions.MoveAction:Fire(Vector2_new_ret2);
    end;
end;

function u6.LayoutMiddleImages(p33: table, p34: vector, p35: vector) -- Line: 364
    -- upvalues: u3 (copy)
    local v36 = p33.thumbstickSize / 2 + p33.middleSize;
    local v37 = p35 - p34;
    local v38 = v37.Magnitude - p33.thumbstickRingSize / 2 - p33.middleSize;
    local Unit = v37.Unit;
    local middleSpacing = p33.middleSpacing;

    if p33.middleSpacing * u3 < v38 then
        middleSpacing = v38 / u3;
    end;

    for i = 1, u3 do
        local v39 = p33.middleImages[i];
        local v40 = v36 + middleSpacing * (i - 1);
        local v41;

        if v36 + middleSpacing * (i - 2) < v38 then
            local v42 = p35 - Unit * v40;
            local math_clamp_ret = math.clamp(1 - (v40 - v38) / middleSpacing, 0, 1);
            v39.Visible = true;
            v39.Position = UDim2.new(0, v42.X, 0, v42.Y);
            v39.Size = UDim2.new(0, p33.middleSize * math_clamp_ret, 0, p33.middleSize * math_clamp_ret);
            v41 = i;
        else
            v39.Visible = false;
            v41 = i;
        end;
    end;
end;

function u6.MoveStick(p43, p44) -- Line: 395
    local v45 = Vector2.new(p43.moveTouchStartPosition.X, p43.moveTouchStartPosition.Y) - p43.thumbstickFrame.AbsolutePosition;
    local v46 = Vector2.new(p44.X, p44.Y) - p43.thumbstickFrame.AbsolutePosition;
    p43.endImage.Position = UDim2.new(0, v46.X, 0, v46.Y);
    p43:LayoutMiddleImages(v45, v46);
end;

function u6.Create(u47: table, u48: userdata) -- Line: 403
    -- upvalues: UserFlag6 (copy), ThumbstickAction (copy), UserFlag (copy), u5 (copy), UserFlag5 (copy), u3 (copy), u2 (copy), u1 (copy), AvatarAbilitiesInterface (copy), UserFlag2 (copy), RunService (copy), Vector2_new_ret (copy), GuiService (copy), TweenService (copy), LocalPlayer (ref)
    if u47.thumbstickFrame then
        if UserFlag6 then
            ThumbstickAction.Enabled = false;

            if u47.thumbstickStateChangedConn then
                u47.thumbstickStateChangedConn:Disconnect();
                u47.thumbstickStateChangedConn = nil;
            end;
        else
            ThumbstickAction.Enabled = false;

            if u47.thumbstickStateChangedConn then
                u47.thumbstickStateChangedConn:Disconnect();
                u47.thumbstickStateChangedConn = nil;
            end;
        end;

        u47.thumbstickFrame:Destroy();
        u47.thumbstickFrame = nil;

        if u47.onRenderSteppedConn then
            u47.onRenderSteppedConn:Disconnect();
            u47.onRenderSteppedConn = nil;
        end;

        if u47.absoluteSizeChangedConn then
            u47.absoluteSizeChangedConn:Disconnect();
            u47.absoluteSizeChangedConn = nil;
        end;

        if not UserFlag and u47.avatarAbilitiesEnabledChangedConn then
            u47.avatarAbilitiesEnabledChangedConn:Disconnect();
            u47.avatarAbilitiesEnabledChangedConn = nil;
        end;

        if UserFlag then
            if u47.cameraChangedConn then
                u47.cameraChangedConn:Disconnect();
                u47.cameraChangedConn = nil;
            end;

            if u47.currentCameraChangedConn then
                u47.currentCameraChangedConn:Disconnect();
                u47.currentCameraChangedConn = nil;
            end;

            if u47.menuOpenedConnection then
                u47.menuOpenedConnection:Disconnect();
                u47.menuOpenedConnection = nil;
            end;

            if u47.playerGuiChangedConn then
                u47.playerGuiChangedConn:Disconnect();
                u47.playerGuiChangedConn = nil;
            end;
        end;
    end;

    local function layoutThumbstickFrame(p49: boolean) -- Line: 451
        -- upvalues: u47 (copy)
        if p49 then
            u47.thumbstickFrame.Size = UDim2.new(1, 100, 0.4, 100);
            u47.thumbstickFrame.Position = UDim2.new(0, -100, 0.6, 0);

            return;
        end;

        u47.thumbstickFrame.Size = UDim2.new(0.4, 100, 0.6666666666666666, 100);
        u47.thumbstickFrame.Position = UDim2.new(0, -100, 0.3333333333333333, 0);
    end;

    local v50 = UserFlag and u5:isEnabled();
    u47.newStyle = v50;
    u47.thumbstickFrame = Instance.new("Frame");
    u47.thumbstickFrame.BorderSizePixel = 0;
    u47.thumbstickFrame.Name = "DynamicThumbstickFrame";
    u47.thumbstickFrame.Visible = false;
    u47.thumbstickFrame.BackgroundTransparency = 1;
    u47.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
    u47.thumbstickFrame.Active = false;
    u47.thumbstickFrame.Size = UDim2.new(0.4, 100, 0.6666666666666666, 100);
    u47.thumbstickFrame.Position = UDim2.new(0, -100, 0.3333333333333333, 0);
    u47.thumbstickButton = Instance.new("ImageButton");
    u47.thumbstickButton.Name = "DynamicThumbstickUIModifier";
    u47.thumbstickButton.BackgroundTransparency = 1;
    u47.thumbstickButton.ImageTransparency = 1;
    u47.thumbstickButton.AutoButtonColor = false;
    u47.thumbstickButton.Size = UDim2.new(1, 0, 1, 0);
    u47.thumbstickButton.ZIndex = u47.thumbstickFrame.ZIndex;
    u47.thumbstickButton.Visible = true;
    u47.thumbstickButton.Active = false;
    u47.thumbstickButton.Parent = u47.thumbstickFrame;

    if not UserFlag6 then
        local v51;

        if UserFlag5 then
            v51 = ThumbstickAction:FindFirstChild("DynamicTouchBinding");
        else
            v51 = nil;
        end;

        if not v51 then
            v51 = Instance.new("InputBinding");
            v51.Name = "DynamicTouchBinding";
            v51.KeyCode = Enum.KeyCode.TouchPosition;
            v51.Parent = ThumbstickAction;
        end;

        v51.UIModifier = u47.thumbstickButton;
    end;

    if UserFlag and u47.newStyle then
        u47.startImage = Instance.new("Frame");
        u47.startImage.Name = "ThumbstickStart";
        u47.startImage.BackgroundColor3 = Color3.fromRGB(18, 18, 21);
        u47.startImage.BackgroundTransparency = 0.4;
        u47.startImage.AnchorPoint = Vector2.new(0.5, 0.5);
        u47.startImage.ZIndex = 10;
        u47.startImage.Parent = u47.thumbstickFrame;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0.5, 0);
        UICorner.Parent = u47.startImage;
        u47.endImage = Instance.new("Frame");
        u47.endImage.Name = "ThumbstickEnd";
        u47.endImage.BackgroundTransparency = 1;
        u47.endImage.AnchorPoint = Vector2.new(0.5, 0.5);
        u47.endImage.ZIndex = 10;
        u47.endImage.Parent = u47.thumbstickFrame;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0.5, 0);
        UICorner2.Parent = u47.endImage;
        u47.endImageStroke = Instance.new("UIStroke");
        u47.endImageStroke.Thickness = UserFlag5 and 1.5 or 2;
        u47.endImageStroke.Color = Color3.fromRGB(213, 215, 221);
        u47.endImageStroke.Parent = u47.endImage;
        u47.endImageCenter = Instance.new("Frame");
        u47.endImageCenter.Name = "ThumbstickEndCenter";
        u47.endImageCenter.BackgroundTransparency = 0;
        u47.endImageCenter.BackgroundColor3 = Color3.fromRGB(213, 215, 221);
        u47.endImageCenter.AnchorPoint = Vector2.new(0.5, 0.5);
        u47.endImageCenter.Size = UDim2.new(0.74, 0, 0.74, 0);
        u47.endImageCenter.Position = UDim2.new(0.5, 0, 0.5, 0);
        u47.endImageCenter.ZIndex = 10;
        u47.endImageCenter.Parent = u47.endImage;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.CornerRadius = UDim.new(0.5, 0);
        UICorner3.Parent = u47.endImageCenter;

        for i = 1, u3 do
            u47.middleImages[i] = Instance.new("Frame");
            u47.middleImages[i].Name = "ThumbstickMiddle";
            u47.middleImages[i].Visible = false;
            u47.middleImages[i].BackgroundTransparency = u2[i];
            u47.middleImages[i].BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            u47.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5);
            u47.middleImages[i].ZIndex = 9;
            u47.middleImages[i].Parent = u47.thumbstickFrame;
            local UICorner4 = Instance.new("UICorner");
            UICorner4.CornerRadius = UDim.new(0.5, 0);
            UICorner4.Parent = u47.middleImages[i];
            local _ = i;
        end;
    else
        u47.startImage = Instance.new("ImageLabel");
        u47.startImage.Name = "ThumbstickStart";
        u47.startImage.Visible = true;
        u47.startImage.BackgroundTransparency = 1;
        u47.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
        u47.startImage.ImageRectOffset = Vector2.new(1, 1);
        u47.startImage.ImageRectSize = Vector2.new(144, 144);
        u47.startImage.ImageColor3 = Color3.new(0, 0, 0);
        u47.startImage.AnchorPoint = Vector2.new(0.5, 0.5);
        u47.startImage.ZIndex = 10;
        u47.startImage.Parent = u47.thumbstickFrame;
        u47.endImage = Instance.new("ImageLabel");
        u47.endImage.Name = "ThumbstickEnd";
        u47.endImage.Visible = true;
        u47.endImage.BackgroundTransparency = 1;
        u47.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
        u47.endImage.ImageRectOffset = Vector2.new(1, 1);
        u47.endImage.ImageRectSize = Vector2.new(144, 144);
        u47.endImage.AnchorPoint = Vector2.new(0.5, 0.5);
        u47.endImage.ZIndex = 10;
        u47.endImage.Parent = u47.thumbstickFrame;

        for i = 1, u3 do
            u47.middleImages[i] = Instance.new("ImageLabel");
            u47.middleImages[i].Name = "ThumbstickMiddle";
            u47.middleImages[i].Visible = false;
            u47.middleImages[i].BackgroundTransparency = 1;
            u47.middleImages[i].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
            u47.middleImages[i].ImageRectOffset = Vector2.new(1, 1);
            u47.middleImages[i].ImageRectSize = Vector2.new(144, 144);
            u47.middleImages[i].ImageTransparency = u1[i];
            u47.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5);
            u47.middleImages[i].ZIndex = 9;
            u47.middleImages[i].Parent = u47.thumbstickFrame;
            local _ = i;
        end;
    end;

    local function ResizeThumbstick() -- Line: 593
        -- upvalues: u48 (copy), UserFlag (ref), u47 (copy), AvatarAbilitiesInterface (ref), UserFlag2 (ref)
        local AbsoluteSize = u48.AbsoluteSize;
        local v52 = math.min(AbsoluteSize.X, AbsoluteSize.Y) > 500;
        local v53;

        if UserFlag then
            v53 = u47.newStyle;
        else
            v53 = AvatarAbilitiesInterface.isEnabled();
        end;

        local v54 = UserFlag2 and (v53 and v52) and 1.6216216216216217 or (v52 and 2 or 1);
        u47.thumbstickSize = 45 * v54;
        u47.thumbstickRingSize = 20 * v54;
        u47.middleSize = 10 * v54;
        u47.middleSpacing = 14 * v54;
        u47.radiusOfDeadZone = 2 * v54;
        u47.radiusOfMaxSpeed = 20 * v54;
        local v55 = 74 * v54;

        if not UserFlag or u47.isFirstTouch then
            if v53 then
                u47.startImage.Position = UDim2.new(0, v55 * 0.5 + 100 + (v52 and 100 or 64), 1, -v55 * 0.5 - 100 - (v52 and 112 or 64));
                u47.startImage.Size = UDim2.new(0, v55, 0, v55);
            else
                u47.startImage.Position = UDim2.new(0, u47.thumbstickRingSize * 3.3 + 100, 1, -u47.thumbstickRingSize * 2.8 - 100);
                u47.startImage.Size = UDim2.new(0, v55, 0, v55);
            end;
        end;

        u47.endImage.Position = u47.startImage.Position;

        if UserFlag and u47.newStyle then
            u47.endImage.Size = UDim2.new(0, u47.thumbstickSize * 0.6, 0, u47.thumbstickSize * 0.6);

            return;
        end;

        u47.endImage.Size = UDim2.new(0, u47.thumbstickSize * 0.8, 0, u47.thumbstickSize * 0.8);
    end;

    ResizeThumbstick();
    u47.absoluteSizeChangedConn = u48:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick);

    if not UserFlag then
        u47.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeThumbstick);
    end;

    local function onCurrentCameraChanged() -- Line: 648
        -- upvalues: u47 (copy), layoutThumbstickFrame (copy)
        if u47.cameraChangedConn then
            u47.cameraChangedConn:Disconnect();
            u47.cameraChangedConn = nil;
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            local function onViewportSizeChanged() -- Line: 655
                -- upvalues: workspace_CurrentCamera (copy), layoutThumbstickFrame (ref)
                local ViewportSize = workspace_CurrentCamera.ViewportSize;
                layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y);
            end;

            u47.cameraChangedConn = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged);
            local ViewportSize = workspace_CurrentCamera.ViewportSize;
            layoutThumbstickFrame(ViewportSize.X < ViewportSize.Y);
        end;
    end;

    u47.currentCameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged);

    if workspace.CurrentCamera or UserFlag then
        onCurrentCameraChanged();
    end;

    u47.startImageFadeTween = nil;
    u47.endImageFadeTween = nil;
    u47.endImageCenterFadeTween = nil;
    u47.middleImageFadeTweens = {};

    if UserFlag6 and u47.isTouchActive then
        u47:OnInputEnded();
    end;

    u47.moveTouchStartPosition = nil;
    u47.onRenderSteppedConn = RunService.RenderStepped:Connect(function() -- Line: 679
        -- upvalues: u47 (copy)
        if u47.tweenInAlphaStart == nil then
            if u47.tweenOutAlphaStart ~= nil then
                local v56 = tick() - u47.tweenOutAlphaStart;
                local v57 = u47.fadeInAndOutHalfDuration * 2 - u47.fadeInAndOutHalfDuration * 2 * u47.fadeInAndOutBalance;
                u47.thumbstickFrame.BackgroundTransparency = math.min(v56 / v57, 1) * 0.35 + 0.65;

                if v57 < v56 then
                    u47.tweenOutAlphaStart = nil;
                end;
            end;
        else
            local v58 = tick() - u47.tweenInAlphaStart;
            local v59 = u47.fadeInAndOutHalfDuration * 2 * u47.fadeInAndOutBalance;
            u47.thumbstickFrame.BackgroundTransparency = 1 - math.min(v58 / v59, 1) * 0.35;

            if v59 < v58 then
                u47.tweenOutAlphaStart = tick();
                u47.tweenInAlphaStart = nil;
            end;
        end;
    end);

    function u47.onStateChanged(p60) -- Line: 698
        -- upvalues: Vector2_new_ret (ref), GuiService (ref), u47 (copy), TweenService (ref), UserFlag (ref)
        if p60 == Vector2_new_ret then
            if u47.isTouchActive then
                u47:OnInputEnded();
            end;
        else
            local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min;
            local Vector3_new_ret = Vector3.new(p60.X + Min.X, p60.Y + Min.Y, 0);

            if not u47.isTouchActive then
                u47.isTouchActive = true;

                if u47.isFirstTouch then
                    u47.isFirstTouch = false;
                    local TweenInfo_new_ret2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
                    TweenService:Create(u47.startImage, TweenInfo_new_ret2, {
                        Size = UDim2.new(0, 0, 0, 0)
                    }):Play();

                    if not (UserFlag and u47.newStyle) then
                        TweenService:Create(u47.endImage, TweenInfo_new_ret2, {
                            Size = UDim2.new(0, u47.thumbstickSize, 0, u47.thumbstickSize),
                            ImageColor3 = Color3.new(0, 0, 0)
                        }):Play();
                    end;
                end;

                u47.moveTouchStartPosition = Vector3_new_ret;
                u47.moveTouchFirstChanged = true;
                u47:DoFadeInBackground();

                return;
            end;

            if u47.moveTouchFirstChanged then
                u47.moveTouchFirstChanged = false;
                local Vector2_new_ret2 = Vector2.new(u47.moveTouchStartPosition.X - u47.thumbstickFrame.AbsolutePosition.X, u47.moveTouchStartPosition.Y - u47.thumbstickFrame.AbsolutePosition.Y);
                u47.startImage.Visible = true;
                u47.startImage.Position = UDim2.new(0, Vector2_new_ret2.X, 0, Vector2_new_ret2.Y);
                u47.endImage.Visible = true;
                u47.endImage.Position = u47.startImage.Position;
                u47:FadeThumbstick(true);
                u47:MoveStick(u47.moveTouchStartPosition);
            end;

            local Vector2_new_ret2 = Vector2.new(Vector3_new_ret.X - u47.moveTouchStartPosition.X, Vector3_new_ret.Y - u47.moveTouchStartPosition.Y);

            if Vector2_new_ret2.Magnitude > 0 then
                u47:DoMove(Vector2_new_ret2);
                u47:MoveStick(Vector3_new_ret);
            end;
        end;
    end;

    u47.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- Line: 759
        -- upvalues: u47 (copy)
        if u47.isTouchActive then
            u47:OnInputEnded();
        end;
    end);
    local u61 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    while not u61 do
        LocalPlayer.ChildAdded:wait();
        u61 = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    end;

    local u62 = u61.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft and true or u61.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight;

    local function longShowBackground() -- Line: 774
        -- upvalues: u47 (copy)
        u47.fadeInAndOutHalfDuration = 2.5;
        u47.fadeInAndOutBalance = 0.05;
        u47.tweenInAlphaStart = tick();
    end;

    u47.playerGuiChangedConn = u61:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- Line: 780
        -- upvalues: u62 (copy), u61 (ref), u47 (copy)
        if not ((not u62 or u61.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) and (u62 or u61.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait)) then
            u47.playerGuiChangedConn:Disconnect();
            u47.fadeInAndOutHalfDuration = 2.5;
            u47.fadeInAndOutBalance = 0.05;
            u47.tweenInAlphaStart = tick();

            if u62 then
                u47.hasFadedBackgroundInPortrait = true;

                return;
            end;

            u47.hasFadedBackgroundInLandscape = true;
        end;
    end);
    u47.thumbstickFrame.Parent = u48;

    if game:IsLoaded() then
        u47.fadeInAndOutHalfDuration = 2.5;
        u47.fadeInAndOutBalance = 0.05;
        u47.tweenInAlphaStart = tick();
    else
        coroutine.wrap(function() -- Line: 800
            -- upvalues: u47 (copy)
            game.Loaded:Wait();
            u47.fadeInAndOutHalfDuration = 2.5;
            u47.fadeInAndOutBalance = 0.05;
            u47.tweenInAlphaStart = tick();
        end)();
    end;
end;

return u6;