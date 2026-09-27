-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local faye = require(ReplicatedStorage.Packages.faye);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local MobileLayout = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.MobileLayout);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local SavedLayout = require(script.Parent.SavedLayout);
local MobileButtonScale = require(game:GetService("ReplicatedStorage").CAM.Client.Modules.MobileButtonScale);
local LayoutActions = require(script.Parent.LayoutActions);
local Bounds = require(script.Parent.Bounds);
local Pointer = require(script.Parent.Pointer);
local EditPlate = require(script.Parent.EditPlate);
local HolderDrag = require(script.Parent.HolderDrag);
local JumpButton = require(script.Parent.JumpButton);
local Dash_Handler = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dash_Handler);
local Mounted = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Mounted);
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1 = faye.Info(0.08);
local UDim2_fromScale_ret = UDim2.fromScale(1, 1);
local Size = MobileLayout.Toolbar.Size;
local Color3_new_ret = Color3.new();
local Color3_new_ret2 = Color3.new();
local Color3_new_ret3 = Color3.new(1, 1, 1);
local Color3_new_ret4 = Color3.new(1, 1, 1);
local DashIcon = BunchaIcons.DashIcon;
local UDim2_fromScale_ret2 = UDim2.fromScale(0.5, 0.5);
local u2 = {
    GlowScale = 2.15,
    CircleScale = 0.8
};
local u3 = faye.Info(0.2);

return function(u4: any, p5: userdata, u6: any) -- Line: 125
    -- upvalues: SettingsKeys (copy), DataValue (copy), Players (copy), Mounted (copy), InputHandler (copy), Utility (copy), MobileLayout (copy), Size (copy), MobileButtonScale (copy), JumpButton (copy), Bounds (copy), SavedLayout (copy), UDim2_fromScale_ret2 (copy), Dash_Handler (copy), UserInputService (copy), RunService (copy), Pointer (copy), UDim2_fromScale_ret (copy), u3 (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), Color3_new_ret4 (copy), u1 (copy), DashIcon (copy), Color3_new_ret3 (copy), EditPlate (copy), u2 (copy), HolderDrag (copy), LayoutActions (copy)
    local u7 = u4:Value(false);
    local MobileDirectionalDash = SettingsKeys.MobileDirectionalDash;
    local u8 = DataValue.new(MobileDirectionalDash.Path, MobileDirectionalDash.Default, SettingsKeys.Scope);
    u7:Set(u8:Get() == true);
    u4:Add(u8.Changed:Connect(function(p9) -- Line: 133
        -- upvalues: u7 (copy)
        u7:Set(p9 == true);
    end), true);
    u4:Add(function() -- Line: 136
        -- upvalues: u8 (copy)
        u8:Destroy();
    end);
    local u10 = u4:Value(false);

    local function watch(u11: userdata) -- Line: 164
        -- upvalues: u10 (copy), u4 (copy)
        local function read() -- Line: 165
            -- upvalues: u10 (ref), u11 (copy)
            u10:Set(u11.MoveDirection.Magnitude > 0);
        end;

        u4:Connect(u11:GetPropertyChangedSignal("MoveDirection"), read);
        u10:Set(u11.MoveDirection.Magnitude > 0);
    end;

    local function hook(p12: userdata) -- Line: 171
        -- upvalues: u10 (copy), u4 (copy)
        local u13 = p12:FindFirstChildOfClass("Humanoid");

        if u13 == nil then
            u4:Connect(p12.ChildAdded, function(u14: userdata) -- Line: 178
                -- upvalues: u10 (ref), u4 (ref)
                if u14:IsA("Humanoid") then
                    local function v15() -- Line: 165
                        -- upvalues: u10 (ref), u14 (copy)
                        u10:Set(u14.MoveDirection.Magnitude > 0);
                    end;

                    u4:Connect(u14:GetPropertyChangedSignal("MoveDirection"), v15);
                    u10:Set(u14.MoveDirection.Magnitude > 0);
                end;
            end);

            return;
        end;

        local function v16() -- Line: 165
            -- upvalues: u10 (ref), u13 (copy)
            u10:Set(u13.MoveDirection.Magnitude > 0);
        end;

        u4:Connect(u13:GetPropertyChangedSignal("MoveDirection"), v16);
        u10:Set(u13.MoveDirection.Magnitude > 0);
    end;

    local Character = Players.LocalPlayer.Character;

    if Character == nil then
        u4:Connect(Players.LocalPlayer.CharacterAdded, hook);
    else
        local u17 = Character:FindFirstChildOfClass("Humanoid");

        if u17 == nil then
            u4:Connect(Character.ChildAdded, function(u18: userdata) -- Line: 178
                -- upvalues: u10 (copy), u4 (copy)
                if u18:IsA("Humanoid") then
                    local function v19() -- Line: 165
                        -- upvalues: u10 (ref), u18 (copy)
                        u10:Set(u18.MoveDirection.Magnitude > 0);
                    end;

                    u4:Connect(u18:GetPropertyChangedSignal("MoveDirection"), v19);
                    u10:Set(u18.MoveDirection.Magnitude > 0);
                end;
            end);
        else
            u4:Connect(u17:GetPropertyChangedSignal("MoveDirection"), function() -- Line: 165, Name: read
                -- upvalues: u10 (copy), u17 (copy)
                u10:Set(u17.MoveDirection.Magnitude > 0);
            end);
            u10:Set(u17.MoveDirection.Magnitude > 0);
        end;
    end;

    local u20 = u4:Value(Mounted.Is());
    local Character2 = Players.LocalPlayer.Character;

    if Character2 ~= nil then
        u4:Add(Mounted.Watch(Character2, function(p21: boolean) -- Line: 195
            -- upvalues: u20 (copy)
            u20:Set(p21);
        end));
    end;

    local u22 = u4:Value(InputHandler.IsAvailable());
    u4:Add(InputHandler.Available:Connect(function(p23: boolean) -- Line: 201
        -- upvalues: u22 (copy)
        u22:Set(p23 == true);
    end), true);
    local u24 = u4:Value(false);
    local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer);

    if valuesfolder ~= nil then
        local function _() -- Line: 218
            -- upvalues: u24 (copy), valuesfolder (copy)
            u24:Set(valuesfolder:FindFirstChild("Blocking") ~= nil);
        end;

        u4:Connect(valuesfolder.ChildAdded, function(p25: userdata) -- Line: 221
            -- upvalues: u24 (copy), valuesfolder (copy)
            if p25.Name == "Blocking" then
                u24:Set(valuesfolder:FindFirstChild("Blocking") ~= nil);
            end;
        end);
        u4:Connect(valuesfolder.ChildRemoved, function(p26: userdata) -- Line: 224
            -- upvalues: u24 (copy), valuesfolder (copy)
            if p26.Name == "Blocking" then
                u24:Set(valuesfolder:FindFirstChild("Blocking") ~= nil);
            end;
        end);
        u24:Set(valuesfolder:FindFirstChild("Blocking") ~= nil);
    end;

    local function shown(p27) -- Line: 239
        -- upvalues: u20 (copy), u24 (copy), u10 (copy), u22 (copy)
        if p27(u20) == true then
            return false;
        end;

        if p27(u24) == true then
            return true;
        end;

        local v28;

        if p27(u10) == true then
            v28 = p27(u22) == true;
        else
            v28 = false;
        end;

        return v28;
    end;

    local u29 = 0;
    local u30 = 0;
    local u31 = u4:Value(Vector2.zero);
    local u32 = u4:Value(UDim2.fromOffset(MobileLayout.Dash.X, MobileLayout.Dash.Y));
    local u33 = u4:Value(UDim2.fromOffset(Size * 0.75, Size * 0.75));
    local u34 = nil;

    local function updatePosition() -- Line: 254
        -- upvalues: MobileButtonScale (ref), Size (ref), u33 (copy), MobileLayout (ref), u29 (ref), u30 (ref), u31 (copy), u34 (ref), JumpButton (ref), Bounds (ref), u32 (copy)
        local v35 = MobileButtonScale.Get();
        local v36 = Size * 0.75 * v35;
        local Vector2_new_ret = Vector2.new(v36, v36);
        u33:Set(UDim2.fromOffset(v36, v36));
        local v37 = Vector2.new(MobileLayout.Dash.X * v35 + u29, MobileLayout.Dash.Y * v35 + u30) + u31:Get();
        local v38 = u34;

        if v38 ~= nil and v38.AbsoluteSize.X > 0 then
            local v39 = v37 - Vector2.new(JumpButton.RowShift(v38), 0);
            v37 = Bounds.ClampCornerOffset(v39, Vector2_new_ret, v38.AbsoluteSize);
        end;

        u32:Set(UDim2.fromOffset(v37.X, v37.Y));
    end;

    SavedLayout(u4, "Dash", nil, function(p40, p41) -- Line: 271
        -- upvalues: u29 (ref), u30 (ref), updatePosition (copy)
        u29 = p40;
        u30 = p41;
        updatePosition();
    end);
    u4:Connect(u31.Changed, updatePosition);
    u4:Add(MobileButtonScale.Changed:Connect(updatePosition));
    local u42 = u4:Value(UDim2_fromScale_ret2);
    local u43 = nil;
    local u44 = nil;
    local Vector2_zero = Vector2.zero;
    local u45 = false;

    local function release() -- Line: 292
        -- upvalues: u43 (ref), u42 (copy), UDim2_fromScale_ret2 (ref), Vector2_zero (ref), u45 (ref), Dash_Handler (ref)
        u43 = nil;
        u42:Set(UDim2_fromScale_ret2);
        local v46 = Vector2_zero;
        Vector2_zero = Vector2.zero;
        u45 = false;

        if v46.Magnitude < 0.2 then
            Dash_Handler.Perform(Dash_Handler.MovementLetter());

            return;
        end;

        Dash_Handler.Perform(Dash_Handler.Letter(v46));
    end;

    u4:Connect(UserInputService.InputEnded, function(p47: userdata) -- Line: 309
        -- upvalues: u43 (ref), release (copy)
        if p47 ~= u43 then
            return;
        end;

        release();
    end);
    u4:Connect(RunService.RenderStepped, function() -- Line: 315
        -- upvalues: u43 (ref), u44 (ref), Pointer (ref), u45 (ref), u42 (copy), UDim2_fromScale_ret2 (ref), Vector2_zero (ref)
        local v48 = u43;
        local v49 = u44;

        if v48 == nil or v49 == nil then
            return;
        end;

        local AbsoluteSize = v49.AbsoluteSize;

        if AbsoluteSize.X <= 0 then
            return;
        end;

        local v50 = v49.AbsolutePosition + AbsoluteSize * 0.5;
        local v51 = (Pointer(v48) - v50) / AbsoluteSize.X;
        local Magnitude = v51.Magnitude;

        if not u45 then
            if Magnitude < 0.12 then
                return;
            end;

            u45 = true;
        end;

        if Magnitude > 0.32000000000000006 then
            v51 = v51 * (0.32000000000000006 / Magnitude);
            Magnitude = 0.32000000000000006;
        end;

        u42:Set(UDim2_fromScale_ret2 + UDim2.fromScale(v51.X, v51.Y));

        if Vector2_zero.Magnitude < Magnitude then
            Vector2_zero = v51;
        end;
    end);

    return u4:Create("Frame")({
        Name = "Dash",
        AnchorPoint = Vector2.new(1, 1),
        Size = u33,
        Position = u4:Do(function(p52) -- Line: 346
            -- upvalues: UDim2_fromScale_ret (ref), u32 (copy)
            return UDim2_fromScale_ret + p52(u32);
        end),
        BackgroundTransparency = 1,

        function(p53: userdata) -- Line: 350
            -- upvalues: u44 (ref), u34 (ref), u4 (copy), updatePosition (copy)
            u44 = p53;
            local Parent = p53.Parent;
            u34 = Parent;
            u4:Connect(Parent:GetPropertyChangedSignal("AbsoluteSize"), updatePosition);
            updatePosition();
        end,

        u4:Create("CanvasGroup")({
            Name = "Fade",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(2.3, 2.3),
            BackgroundTransparency = 1,
            GroupTransparency = u4:Do(function(p54) -- Line: 367
                -- upvalues: u4 (copy), u20 (copy), u24 (copy), u10 (copy), u22 (copy), u3 (ref)
                local v55;

                if p54(u20) == true then
                    v55 = false;
                elseif p54(u24) == true then
                    v55 = true;
                elseif p54(u10) == true then
                    v55 = p54(u22) == true;
                else
                    v55 = false;
                end;

                return u4:Animation(v55 and 0 or 1, u3);
            end),
            u4:Create("Frame")({
                Name = "Content",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.4347826086956522, 0.4347826086956522),
                BackgroundTransparency = 1,
                Visible = u4:Do(function(p56) -- Line: 378
                    -- upvalues: u6 (copy)
                    return p56(u6) ~= true;
                end),
                u4:Create("ImageLabel")({
                    Name = "Bg",
                    ZIndex = -1,
                    Image = "http://www.roblox.com/asset/?id=134657809787110",
                    BackgroundTransparency = 1,
                    ImageTransparency = 0.3,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(2.15, 2.15),
                    ImageColor3 = Color3_new_ret
                }),
                u4:Create("ImageLabel")({
                    Name = "CircleSelect",
                    BackgroundTransparency = 1,
                    Image = "http://www.roblox.com/asset/?id=119489413451678",
                    ImageTransparency = 0.8,
                    Size = UDim2.fromScale(0.8, 0.8),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    ImageColor3 = Color3_new_ret2
                }),
                u4:Create("ImageLabel")({
                    Name = "Directions",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://72837589649301",
                    ZIndex = 2,
                    ImageTransparency = 0.75,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),
                    ImageColor3 = Color3_new_ret4,
                    Visible = u4:Do(function(p57) -- Line: 413
                        -- upvalues: u7 (copy)
                        return p57(u7) == true;
                    end)
                }),
                u4:Create("Frame")({
                    Name = "CenterStick",
                    Size = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 5,
                    Position = u4:Animation(u42, u1),
                    BackgroundTransparency = 1,
                    u4:Create("ImageLabel")({
                        Name = "DashIcon",
                        BackgroundTransparency = 1,
                        ZIndex = 5,
                        Image = DashIcon,
                        ImageColor3 = Color3_new_ret3,
                        Size = UDim2.fromScale(0.9, 0.9),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5)
                    })
                }),
                u4:Create("TextButton")({
                    Name = "Press",
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 5,
                    Size = UDim2.fromScale(1, 1),
                    Interactable = u4:Do(function(p58) -- Line: 447
                        -- upvalues: u20 (copy), u24 (copy), u10 (copy), u22 (copy)
                        if p58(u20) == true then
                            return false;
                        end;

                        if p58(u24) == true then
                            return true;
                        end;

                        local v59;

                        if p58(u10) == true then
                            v59 = p58(u22) == true;
                        else
                            v59 = false;
                        end;

                        return v59;
                    end),

                    InputBegan = function(p60: any, p61: userdata) -- Line: 454, Name: InputBegan
                        -- upvalues: u43 (ref), u7 (copy), Dash_Handler (ref), u24 (copy)
                        if u43 ~= nil then
                            return;
                        end;

                        if p61.UserInputState ~= Enum.UserInputState.Begin then
                            return;
                        end;

                        if p61.UserInputType ~= Enum.UserInputType.Touch and p61.UserInputType ~= Enum.UserInputType.MouseButton1 then
                            return;
                        end;

                        if u7:Compare(true) then
                            u43 = p61;

                            return;
                        end;

                        Dash_Handler.Perform(u24:Compare(true) and "S" or Dash_Handler.MovementLetter());
                    end
                })
            })
        }),
        EditPlate(u4, u6, u2),
        HolderDrag(u4, u6, u31, {
            Drop = function(p62) -- Line: 475, Name: Drop
                -- upvalues: u29 (ref), u30 (ref), updatePosition (copy), LayoutActions (ref)
                u29 = u29 + p62.X;
                u30 = u30 + p62.Y;
                updatePosition();
                LayoutActions.Move("Dash", nil, u29, u30);
            end,

            Tap = function() -- Line: 481, Name: Tap
                -- upvalues: u29 (ref), u30 (ref), updatePosition (copy), LayoutActions (ref)
                u29 = 0;
                u30 = 0;
                updatePosition();
                LayoutActions.Reset("Dash", nil);
            end
        })
    });
end;