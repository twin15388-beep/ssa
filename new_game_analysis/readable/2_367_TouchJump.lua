-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"));
local u1 = CommonUtils.get("ConnectionUtil");
local u2 = CommonUtils.get("CharacterUtil");
local v3 = CommonUtils.get("FlagUtil");
local UserFlag = v3.getUserFlag("UserPlayerScriptsCCLIntegrationD");
local UserFlag2 = v3.getUserFlag("UserPlayerScriptsRefactor1");
local UserFlag3 = v3.getUserFlag("UserPlayerScriptsFireThroughScriptableBindings");
local UserFlag4 = v3.getUserFlag("UserPlayerScriptsFixTouchJumpVisibility");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local Combat_presets = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local Mounted = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Mounted);

local function comboeing() -- Line: 41
    -- upvalues: Players (copy), Combat_presets (copy)
    local Character = Players.LocalPlayer.Character;
    local v4;

    if Character == nil then
        v4 = nil;
    else
        v4 = Character:FindFirstChild("HumanoidRootPart");
    end;

    return v4 ~= nil and v4:FindFirstChild("air_combo_bp") ~= nil and true or os.clock() - Combat_presets.Last_Punched_Jump <= Combat_presets.No_Jump_Duration;
end;

local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"));
local u5 = { "rbxasset://textures/ui/Input/JumpButtonRegular.png", "rbxasset://textures/ui/Input/JumpButtonPressed.png" };
local ActionController = require(script.Parent:WaitForChild("ActionController"));
local u6 = setmetatable({}, ActionController);
u6.__index = u6;

function u6.new(p7, p8) -- Line: 91
    -- upvalues: ActionController (copy), u6 (copy), UserFlag4 (copy), u1 (copy)
    local v9 = ActionController.new();
    local u10 = setmetatable(v9, u6);
    u10.playerData = p8;
    p7.eventBus:subscribe("ACTIONS_RELOADED"):Connect(function() -- Line: 95
        -- upvalues: u10 (copy), UserFlag4 (ref)
        u10:Create();

        if UserFlag4 and u10._active then
            u10._active = false;
            u10:EnableButton(true);
        end;
    end);
    u10.parentUIFrame = nil;
    u10.jumpButton = nil;
    u10.externallyEnabled = false;
    u10._active = false;
    u10._connectionUtil = u1.new();

    return u10;
end;

function u6._reset(p11) -- Line: 113
    -- upvalues: InputHandler (copy), UserFlag3 (copy), UserFlag (copy), AvatarAbilitiesInterface (copy), u5 (copy)
    InputHandler.VirtualRelease("Jump");

    if not UserFlag3 and p11.playerData.actions.JumpAction then
        p11.playerData.actions.JumpAction:Fire(false);
    end;

    if p11.jumpButton then
        if not UserFlag and AvatarAbilitiesInterface.isEnabled() then
            p11.jumpButton.Image = u5[1];

            return;
        end;

        p11.jumpButton.ImageRectOffset = Vector2.new(1, 146);
    end;
end;

function u6.EnableButton(u12, p13) -- Line: 133
    -- upvalues: UserFlag3 (copy), GuiService (copy)
    if p13 == u12._active then
        return;
    end;

    if p13 then
        if not u12.jumpButton then
            u12:Create();
        end;

        u12.jumpButton.Visible = true;

        if not UserFlag3 then
            u12._connectionUtil:trackConnection("MENU_OPENED", GuiService.MenuOpened:Connect(function() -- Line: 148
                -- upvalues: u12 (copy)
                u12:_reset();
            end));
        end;
    else
        if u12.jumpButton then
            u12.jumpButton.Visible = false;
        end;

        if not UserFlag3 then
            u12._connectionUtil:disconnect("MENU_OPENED");
        end;
    end;

    u12:_reset();
    u12._active = p13;
end;

function u6.UpdateEnabled(p14) -- Line: 165
    -- upvalues: u2 (copy), comboeing (copy), Mounted (copy)
    local Child = u2.getChild("Humanoid", "Humanoid");
    local v15;

    if Child == nil then
        v15 = false;
    elseif Child.UseJumpPower and Child.JumpPower > 0 then
        v15 = true;
    else
        v15 = not Child.UseJumpPower and Child.JumpHeight > 0;
    end;

    if Child and (p14.externallyEnabled and (v15 or (comboeing() or Mounted.Is()))) and Child:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
        p14:EnableButton(true);

        return;
    end;

    p14:EnableButton(false);
end;

function u6._setupConfigurations(u16) -- Line: 176
    -- upvalues: u2 (copy)
    local function update() -- Line: 177
        -- upvalues: u16 (copy)
        u16:UpdateEnabled();
    end;

    local v20 = u2.onChild("Humanoid", "Humanoid", function(p17) -- Line: 182
        -- upvalues: u16 (copy), update (copy)
        u16:UpdateEnabled();
        u16:_reset();
        u16._connectionUtil:trackConnection("HUMANOID_JUMP_POWER", p17:GetPropertyChangedSignal("JumpPower"):Connect(update));
        u16._connectionUtil:trackConnection("HUMANOID_JUMP_HEIGHT", p17:GetPropertyChangedSignal("JumpHeight"):Connect(update));
        u16._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p17.StateEnabledChanged:Connect(function(p18, p19) -- Line: 195
            -- upvalues: u16 (ref)
            if p18 == Enum.HumanoidStateType.Jumping and p19 ~= u16._active then
                u16:UpdateEnabled();
            end;
        end));
    end);
    u16._connectionUtil:trackConnection("HUMANOID", v20);
end;

function u6.Enable(p21, p22, p23) -- Line: 207
    -- upvalues: ActionController (copy)
    if p23 then
        p21.parentUIFrame = p23;
    end;

    if p21.externallyEnabled == p22 then
        return;
    end;

    p21.externallyEnabled = p22;
    ActionController.Enable(p21, p22);
    p21:UpdateEnabled();

    if p22 then
        p21:_setupConfigurations();

        return;
    end;

    p21._connectionUtil:disconnectAll();
end;

function u6.Create(u24) -- Line: 225
    -- upvalues: UserFlag (copy), UserFlag2 (copy), AvatarAbilitiesInterface (copy), u5 (copy), InputHandler (copy)
    if not u24.parentUIFrame then
        return;
    end;

    if u24.jumpButton then
        u24.jumpButton:Destroy();
        u24.jumpButton = nil;
    end;

    if u24.absoluteSizeChangedConn then
        u24.absoluteSizeChangedConn:Disconnect();
        u24.absoluteSizeChangedConn = nil;
    end;

    if not UserFlag and u24.avatarAbilitiesEnabledChangedConn then
        u24.avatarAbilitiesEnabledChangedConn:Disconnect();
        u24.avatarAbilitiesEnabledChangedConn = nil;
    end;

    u24.jumpButton = Instance.new("ImageButton");
    u24.jumpButton.Name = "JumpButton";
    u24.jumpButton.Visible = false;
    u24.jumpButton.BackgroundTransparency = 1;

    if UserFlag2 then
        u24.jumpButton.ZIndex = 10;
    end;

    if UserFlag or not AvatarAbilitiesInterface.isEnabled() then
        u24.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
        u24.jumpButton.ImageRectOffset = Vector2.new(1, 146);
        u24.jumpButton.ImageRectSize = Vector2.new(144, 144);
    else
        u24.jumpButton.Image = u5[1];
    end;

    local function ResizeJumpButton() -- Line: 263
        -- upvalues: u24 (copy), UserFlag (ref), AvatarAbilitiesInterface (ref), u5 (ref)
        local v25 = math.min(u24.parentUIFrame.AbsoluteSize.x, u24.parentUIFrame.AbsoluteSize.y) <= 500;

        if UserFlag or not AvatarAbilitiesInterface.isEnabled() then
            local v26 = v25 and 70 or 120;
            u24.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png";
            u24.jumpButton.ImageRectOffset = Vector2.new(1, 146);
            u24.jumpButton.ImageRectSize = Vector2.new(144, 144);
            u24.jumpButton.Size = UDim2.new(0, v26, 0, v26);
            u24.jumpButton.Position = v25 and UDim2.new(1, -(v26 * 1.5 - 10), 1, -v26 - 20) or UDim2.new(1, -(v26 * 1.5 - 10), 1, -v26 * 1.75);

            return;
        end;

        local v27 = v25 and 72 or 120;
        u24.jumpButton.Image = u5[1];
        u24.jumpButton.ImageRectOffset = Vector2.new(0, 0);
        u24.jumpButton.ImageRectSize = Vector2.new(0, 0);
        u24.jumpButton.Size = UDim2.new(0, v27, 0, v27);
        u24.jumpButton.Position = UDim2.new(1, -v27 - (v25 and 64 or 100), 1, -v27 - (v25 and 64 or 112));
    end;

    ResizeJumpButton();
    u24.absoluteSizeChangedConn = u24.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton);

    if not UserFlag then
        u24.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface.GetEnabledChangedSignal():Connect(ResizeJumpButton);
    end;

    u24.jumpButton.Parent = u24.parentUIFrame;
    local u28 = nil;
    u24.jumpButton.InputBegan:Connect(function(p29: userdata) -- Line: 306
        -- upvalues: u28 (ref), u24 (copy), InputHandler (ref)
        if u28 ~= nil or (p29.UserInputType ~= Enum.UserInputType.Touch or p29.UserInputState ~= Enum.UserInputState.Begin) then
            return;
        end;

        if not u24.jumpButton.Visible then
            return;
        end;

        u28 = p29;
        InputHandler.VirtualPress("Jump");
    end);
    u24.jumpButton.InputEnded:Connect(function(p30: userdata) -- Line: 315
        -- upvalues: u28 (ref), InputHandler (ref)
        if p30 ~= u28 then
            return;
        end;

        u28 = nil;
        InputHandler.VirtualRelease("Jump");
    end);

    if not u24.playerData.actions.JumpAction then
        return;
    end;

    u24.playerData.actions.JumpAction:WaitForChild("TouchBinding").UIButton = u24.jumpButton;
    u24.playerData.actions.JumpAction.Pressed:Connect(function() -- Line: 327
        -- upvalues: u24 (copy), UserFlag (ref), AvatarAbilitiesInterface (ref), u5 (ref)
        if not u24.jumpButton then
            return;
        end;

        if UserFlag or not AvatarAbilitiesInterface.isEnabled() then
            u24.jumpButton.ImageRectOffset = Vector2.new(146, 146);

            return;
        end;

        u24.jumpButton.Image = u5[2];
    end);
    u24.playerData.actions.JumpAction.Released:Connect(function() -- Line: 339
        -- upvalues: u24 (copy), UserFlag (ref), AvatarAbilitiesInterface (ref), u5 (ref)
        if not u24.jumpButton then
            return;
        end;

        if UserFlag or not AvatarAbilitiesInterface.isEnabled() then
            u24.jumpButton.ImageRectOffset = Vector2.new(1, 146);

            return;
        end;

        u24.jumpButton.Image = u5[1];
    end);
end;

return u6;