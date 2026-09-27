-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local v1 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local UserFlag = v1.getUserFlag("UserPlayerScriptsCCLIntegrationD");
local UserFlag2 = v1.getUserFlag("UserPlayerScriptsClassicThumbstickRenameUI");
local UserFlag3 = v1.getUserFlag("UserPlayerScriptsFireThroughScriptableBindings");
local UserFlag4 = v1.getUserFlag("UserPlayerScriptsSAuthDirectAPIs2");
local UserFlag5 = v1.getUserFlag("UserAbilitiesUserInterfaceC");
local UserFlag6 = v1.getUserFlag("UserPlayerScriptsResetDTTouchOnCreate");
local ThumbstickAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("TransformerContext"):WaitForChild("ThumbstickAction");
local Vector2_new_ret = Vector2.new(-1, -1);
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"));
local u2;

if UserFlag then
    u2 = AvatarAbilitiesInterface.get(Players.LocalPlayer);
else
    u2 = nil;
end;

local ActionController = require(script.Parent:WaitForChild("ActionController"));
local u3 = setmetatable({}, ActionController);
u3.__index = u3;

function u3.new(p4) -- Line: 32
    -- upvalues: ActionController (copy), u3 (copy)
    local v5 = ActionController.new();
    local v6 = setmetatable(v5, u3);
    v6.playerData = p4;
    v6.enabled = false;
    v6.isTouchActive = false;
    v6.isFollowStick = false;
    v6.thumbstickFrame = nil;
    v6.screenPos = nil;
    v6.stickImage = nil;
    v6.thumbstickSize = nil;

    return v6;
end;

local function setupThumbstickInput(p7) -- Line: 49
    -- upvalues: ThumbstickAction (copy)
    for _, child in ThumbstickAction:GetChildren() do
        if child.Name == "DynamicTouchBinding" or child.Name == "ClassicTouchBinding" then
            child:Destroy();
        end;
    end;

    local InputBinding = Instance.new("InputBinding");
    InputBinding.Name = "ClassicTouchBinding";
    InputBinding.KeyCode = Enum.KeyCode.TouchPosition;
    InputBinding.UIModifier = p7.thumbstickButton;
    InputBinding.Parent = ThumbstickAction;
end;

local function enableThumbstickInput(p8: any, p9: boolean) -- Line: 62
    -- upvalues: setupThumbstickInput (copy), ThumbstickAction (copy)
    if not p9 then
        ThumbstickAction.Enabled = false;

        if p8.thumbstickStateChangedConn then
            p8.thumbstickStateChangedConn:Disconnect();
            p8.thumbstickStateChangedConn = nil;
        end;

        return;
    end;

    setupThumbstickInput(p8);
    p8.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p8.onStateChanged);
    ThumbstickAction.Enabled = true;
end;

function u3.Enable(p10: table, p11: boolean?, p12: any) -- Line: 76
    -- upvalues: ActionController (copy), UserFlag6 (copy), setupThumbstickInput (copy), ThumbstickAction (copy)
    if p11 == nil then
        return false;
    end;

    local v13 = p11 and true or false;

    if p10.enabled == v13 then
        return true;
    end;

    ActionController.Enable(p10, v13);
    p10.isJumping = false;

    if v13 then
        if not p10.thumbstickFrame then
            p10:Create(p12);
        end;

        if UserFlag6 then
            setupThumbstickInput(p10);
            p10.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p10.onStateChanged);
            ThumbstickAction.Enabled = true;
        else
            p10.thumbstickStateChangedConn = ThumbstickAction.StateChanged:Connect(p10.onStateChanged);
            ThumbstickAction.Enabled = true;
        end;

        p10.thumbstickFrame.Visible = true;
    else
        if UserFlag6 then
            ThumbstickAction.Enabled = false;

            if p10.thumbstickStateChangedConn then
                p10.thumbstickStateChangedConn:Disconnect();
                p10.thumbstickStateChangedConn = nil;
            end;
        else
            ThumbstickAction.Enabled = false;

            if p10.thumbstickStateChangedConn then
                p10.thumbstickStateChangedConn:Disconnect();
                p10.thumbstickStateChangedConn = nil;
            end;
        end;

        p10.thumbstickFrame.Visible = false;
        p10:OnInputEnded();
    end;

    p10.enabled = v13;
end;

function u3.OnInputEnded(p14) -- Line: 114
    -- upvalues: UserFlag4 (copy), UserFlag3 (copy)
    p14.isTouchActive = false;
    p14.thumbstickFrame.Position = p14.screenPos;
    p14.stickImage.Position = UDim2.new(0, p14.thumbstickFrame.Size.X.Offset / 2 - p14.thumbstickSize / 4, 0, p14.thumbstickFrame.Size.Y.Offset / 2 - p14.thumbstickSize / 4);

    if UserFlag4 then
        local ClassicThumbstickScriptableBinding = p14.playerData.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding");

        if ClassicThumbstickScriptableBinding then
            ClassicThumbstickScriptableBinding:Fire(Vector2.zero);
        end;
    elseif UserFlag3 then
        local ClassicThumbstickScriptableBinding = p14.playerData.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding");

        if ClassicThumbstickScriptableBinding then
            local success, _ = pcall(function() -- Line: 127
                -- upvalues: ClassicThumbstickScriptableBinding (copy)
                ClassicThumbstickScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                ClassicThumbstickScriptableBinding:Fire(Vector2.zero);
            end);

            if not success then
                p14.playerData.actions.MoveAction:Fire(Vector2.zero);
            end;
        else
            p14.playerData.actions.MoveAction:Fire(Vector2.zero);
        end;
    else
        p14.playerData.actions.MoveAction:Fire(Vector2.zero);
    end;

    p14.isJumping = false;
    p14.thumbstickFrame.Position = p14.screenPos;
end;

function u3.Create(u15, u16) -- Line: 144
    -- upvalues: ThumbstickAction (copy), UserFlag2 (copy), UserFlag (copy), u2 (copy), AvatarAbilitiesInterface (copy), UserFlag6 (copy), UserFlag4 (copy), UserFlag3 (copy), UserFlag5 (copy), Vector2_new_ret (copy), GuiService (copy)
    if u15.thumbstickFrame then
        ThumbstickAction.Enabled = false;

        if u15.thumbstickStateChangedConn then
            u15.thumbstickStateChangedConn:Disconnect();
            u15.thumbstickStateChangedConn = nil;
        end;

        u15.thumbstickFrame:Destroy();
        u15.thumbstickFrame = nil;

        if u15.absoluteSizeChangedConn then
            u15.absoluteSizeChangedConn:Disconnect();
            u15.absoluteSizeChangedConn = nil;
        end;

        if u15.avatarAbilitiesEnabledChangedConn then
            u15.avatarAbilitiesEnabledChangedConn:Disconnect();
            u15.avatarAbilitiesEnabledChangedConn = nil;
        end;
    end;

    u15.thumbstickFrame = Instance.new("Frame");
    u15.thumbstickFrame.Name = UserFlag2 and "ClassicThumbstickFrame" or "ThumbstickFrame";
    u15.thumbstickFrame.Active = true;
    u15.thumbstickFrame.Visible = false;
    u15.thumbstickFrame.BackgroundTransparency = 1;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "OuterImage";
    ImageLabel.Image = "rbxasset://textures/ui/TouchControlsSheet.png";
    ImageLabel.ImageRectOffset = Vector2.new();
    ImageLabel.ImageRectSize = Vector2.new(220, 220);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Position = UDim2.new(0, 0, 0, 0);
    u15.stickImage = Instance.new("ImageLabel");
    u15.stickImage.Name = "StickImage";
    u15.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png";
    u15.stickImage.ImageRectOffset = Vector2.new(220, 0);
    u15.stickImage.ImageRectSize = Vector2.new(111, 111);
    u15.stickImage.BackgroundTransparency = 1;
    u15.stickImage.ZIndex = 2;

    local function ResizeThumbstick() -- Line: 187
        -- upvalues: u16 (copy), UserFlag (ref), u2 (ref), AvatarAbilitiesInterface (ref), u15 (copy), ImageLabel (copy)
        local v17 = math.min(u16.AbsoluteSize.X, u16.AbsoluteSize.Y) <= 500;
        local v18;

        if UserFlag then
            v18 = u2:isEnabled();
        else
            v18 = AvatarAbilitiesInterface.isEnabled();
        end;

        if v18 then
            u15.thumbstickSize = v17 and 72 or 120;
            u15.screenPos = UDim2.new(0, v17 and 64 or 100, 1, -u15.thumbstickSize - (v17 and 64 or 112));
        else
            u15.thumbstickSize = v17 and 70 or 120;
            u15.screenPos = v17 and UDim2.new(0, u15.thumbstickSize / 2 - 10, 1, -u15.thumbstickSize - 20) or UDim2.new(0, u15.thumbstickSize / 2, 1, -u15.thumbstickSize * 1.75);
        end;

        u15.thumbstickFrame.Size = UDim2.new(0, u15.thumbstickSize, 0, u15.thumbstickSize);
        u15.thumbstickFrame.Position = u15.screenPos;
        ImageLabel.Size = UDim2.new(0, u15.thumbstickSize, 0, u15.thumbstickSize);
        u15.stickImage.Size = UDim2.new(0, u15.thumbstickSize / 2, 0, u15.thumbstickSize / 2);
        u15.stickImage.Position = UDim2.new(0, u15.thumbstickSize / 2 - u15.thumbstickSize / 4, 0, u15.thumbstickSize / 2 - u15.thumbstickSize / 4);
    end;

    ResizeThumbstick();
    u15.absoluteSizeChangedConn = u16:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick);

    if UserFlag then
        u15.avatarAbilitiesEnabledChangedConn = u2:GetEnabledChangedSignal():Connect(ResizeThumbstick);
    else
        u15.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeThumbstick);
    end;

    ImageLabel.Parent = u15.thumbstickFrame;
    u15.stickImage.Parent = u15.thumbstickFrame;
    u15.thumbstickButton = Instance.new("ImageButton");
    u15.thumbstickButton.Name = "ClassicThumbstickUIModifier";
    u15.thumbstickButton.BackgroundTransparency = 1;
    u15.thumbstickButton.ImageTransparency = 1;
    u15.thumbstickButton.AutoButtonColor = false;
    u15.thumbstickButton.Size = UDim2.new(1, 0, 1, 0);
    u15.thumbstickButton.ZIndex = u15.thumbstickFrame.ZIndex;
    u15.thumbstickButton.Visible = true;
    u15.thumbstickButton.Active = false;
    u15.thumbstickButton.Parent = u15.thumbstickFrame;

    if not UserFlag6 then
        local InputBinding = Instance.new("InputBinding");
        InputBinding.Name = "ClassicTouchBinding";
        InputBinding.KeyCode = Enum.KeyCode.TouchPosition;
        InputBinding.UIModifier = u15.thumbstickButton;
        InputBinding.Parent = ThumbstickAction;
    end;

    local u19 = nil;

    local function DoMove(p20) -- Line: 245
        -- upvalues: u15 (copy), UserFlag4 (ref), UserFlag3 (ref)
        local v21 = p20 / (u15.thumbstickSize / 2);
        local magnitude = v21.magnitude;
        local v22;

        if magnitude < 0.05 then
            v22 = Vector2.new();
        else
            v22 = v21.unit * math.min(1, (magnitude - 0.05) / 0.95);
        end;

        local Vector2_new_ret2 = Vector2.new(v22.X, -v22.Y);

        if UserFlag4 then
            local ClassicThumbstickScriptableBinding = u15.playerData.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding");

            if ClassicThumbstickScriptableBinding then
                ClassicThumbstickScriptableBinding:Fire(Vector2_new_ret2);
            end;
        elseif UserFlag3 then
            local ClassicThumbstickScriptableBinding = u15.playerData.actions.MoveAction:FindFirstChild("ClassicThumbstickScriptableBinding");

            if ClassicThumbstickScriptableBinding then
                local success, _ = pcall(function() -- Line: 267
                    -- upvalues: ClassicThumbstickScriptableBinding (copy), Vector2_new_ret2 (ref)
                    ClassicThumbstickScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                    ClassicThumbstickScriptableBinding:Fire(Vector2_new_ret2);
                end);

                if not success then
                    u15.playerData.actions.MoveAction:Fire(Vector2_new_ret2);
                end;
            else
                u15.playerData.actions.MoveAction:Fire(Vector2_new_ret2);
            end;
        else
            u15.playerData.actions.MoveAction:Fire(Vector2_new_ret2);
        end;
    end;

    local function MoveStick(p23: vector) -- Line: 282
        -- upvalues: u19 (ref), u15 (copy), UserFlag5 (ref), u16 (copy)
        local Vector2_new_ret2 = Vector2.new(p23.X - u19.X, p23.Y - u19.Y);
        local magnitude = Vector2_new_ret2.magnitude;
        local v24 = u15.thumbstickFrame.AbsoluteSize.X / 2;

        if u15.isFollowStick and v24 < magnitude then
            local v25 = Vector2_new_ret2.unit * v24;

            if UserFlag5 then
                local AbsolutePosition = u16.AbsolutePosition;
                u15.thumbstickFrame.Position = UDim2.new(0, p23.X - AbsolutePosition.X - u15.thumbstickFrame.AbsoluteSize.X / 2 - v25.X, 0, p23.Y - AbsolutePosition.Y - u15.thumbstickFrame.AbsoluteSize.Y / 2 - v25.Y);
            else
                u15.thumbstickFrame.Position = UDim2.new(0, p23.X - u15.thumbstickFrame.AbsoluteSize.X / 2 - v25.X, 0, p23.Y - u15.thumbstickFrame.AbsoluteSize.Y / 2 - v25.Y);
            end;
        else
            local math_min_ret = math.min(magnitude, v24);
            Vector2_new_ret2 = Vector2_new_ret2.unit * math_min_ret;
        end;

        u15.stickImage.Position = UDim2.new(0, Vector2_new_ret2.X + u15.stickImage.AbsoluteSize.X / 2, 0, Vector2_new_ret2.Y + u15.stickImage.AbsoluteSize.Y / 2);
    end;

    function u15.onStateChanged(p26) -- Line: 305
        -- upvalues: Vector2_new_ret (ref), GuiService (ref), u15 (copy), UserFlag5 (ref), u16 (copy), u19 (ref), DoMove (copy), MoveStick (copy)
        if p26 == Vector2_new_ret then
            if u15.isTouchActive then
                u15:OnInputEnded();
            end;

            return;
        end;

        local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min;
        local Vector3_new_ret = Vector3.new(p26.X + Min.X, p26.Y + Min.Y, 0);

        if u15.isTouchActive then
            u19 = Vector2.new(u15.thumbstickFrame.AbsolutePosition.X + u15.thumbstickFrame.AbsoluteSize.X / 2, u15.thumbstickFrame.AbsolutePosition.Y + u15.thumbstickFrame.AbsoluteSize.Y / 2);
            DoMove((Vector2.new(Vector3_new_ret.X - u19.X, Vector3_new_ret.Y - u19.Y)));
            MoveStick(Vector3_new_ret);

            return;
        end;

        u15.isTouchActive = true;

        if UserFlag5 then
            local AbsolutePosition = u16.AbsolutePosition;
            u15.thumbstickFrame.Position = UDim2.new(0, Vector3_new_ret.X - AbsolutePosition.X - u15.thumbstickFrame.Size.X.Offset / 2, 0, Vector3_new_ret.Y - AbsolutePosition.Y - u15.thumbstickFrame.Size.Y.Offset / 2);
        else
            u15.thumbstickFrame.Position = UDim2.new(0, Vector3_new_ret.X - u15.thumbstickFrame.Size.X.Offset / 2, 0, Vector3_new_ret.Y - u15.thumbstickFrame.Size.Y.Offset / 2);
        end;

        u19 = Vector2.new(u15.thumbstickFrame.AbsolutePosition.X + u15.thumbstickFrame.AbsoluteSize.X / 2, u15.thumbstickFrame.AbsolutePosition.Y + u15.thumbstickFrame.AbsoluteSize.Y / 2);
    end;

    GuiService.MenuOpened:Connect(function() -- Line: 344
        -- upvalues: u15 (copy)
        if u15.isTouchActive then
            u15:OnInputEnded();
        end;
    end);
    u15.thumbstickFrame.Parent = u16;
end;

return u3;