-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local u1 = faye.Info(0.15, Enum.EasingStyle.Sine);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);

return function(p2: any, p3: any, u4: any, u5: table) -- Line: 9
    -- upvalues: u1 (copy), ScreenEffects (copy), SignalFunction (copy), GradientButton (copy), SignalEvent (copy)
    local u6 = {
        In = false,
        Editable = p2:Value(false),
        ButtonEnabled = p2:Value(true),
        TextColor = p2:Value(Color3.new(1, 1, 1)),
        Color = p2:Value(Color3.new(0.15, 0.15, 0.15)),
        AspectRatio = p2:Value(6.5),
        StrokeTransparency = p2:Value(1),
        StrokeSize = p2:Value(UDim2.new(1, -6, 1, -6)),
        Name = u5.Name,
        TextSize = p2:Value(UDim2.new(1, 0, 1, -6)),
        TextPosition = p2:Value(UDim2.fromScale(0.5, 0.5))
    };
    local u7 = p3:Add(u6, p2, true):Call();
    local u8 = nil;

    return p2:Create("Frame")({
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Name = "Holder",
        p2:Create("UIAspectRatioConstraint")({
            AspectRatio = p2:Animation(u6.AspectRatio, u1)
        }),
        p2:Create("Frame")({
            p2:Create("UIAspectRatioConstraint")({
                AspectRatio = 6.5
            }),
            Name = "Main",
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = p2:Animation(u6.Color, u1),
            p2:Create("UICorner")({
                CornerRadius = UDim.new(0.25)
            }),
            p2:Create("TextButton")({
                ZIndex = 2,
                BackgroundTransparency = 1,
                Visible = u6.ButtonEnabled,
                Size = UDim2.fromScale(1, 1),

                MouseEnter = function() -- Line: 51, Name: MouseEnter
                    -- upvalues: u6 (copy), u7 (copy)
                    u6.In = true;
                    u7:Call();
                end,

                MouseLeave = function() -- Line: 55, Name: MouseLeave
                    -- upvalues: u6 (copy), u7 (copy)
                    u6.In = false;
                    u7:Call();
                end,

                MouseButton1Down = function(p9) -- Line: 59, Name: MouseButton1Down
                    -- upvalues: u4 (copy), u5 (copy), ScreenEffects (ref)
                    if u4:Compare(u5.Name) then
                        u4:Reset();
                    else
                        u4:Set(u5.Name);
                    end;

                    ScreenEffects.StrokeClick(p9);
                end
            }),
            p2:Create("Frame")({
                Name = "StrokeHolder",
                ZIndex = 3,
                Size = p2:Animation(u6.StrokeSize, u1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                p2:Create("UICorner")({
                    CornerRadius = UDim.new(0.25)
                }),
                BackgroundTransparency = 1,
                p2:Create("UIStroke")({
                    Transparency = p2:Animation(u6.StrokeTransparency, u1),
                    Color = Color3.new(1, 1, 1)
                })
            }),
            p2:Create("Frame")({
                Name = "TextHolder",
                Position = p2:Animation(u6.TextPosition, u1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = p2:Animation(u6.TextSize, u1),
                BackgroundTransparency = 1,
                p2:Create("TextBox")({
                    Name = "Txt",
                    Size = UDim2.fromScale(1, 1),
                    TextScaled = true,
                    TextEditable = u6.Editable,
                    ClearTextOnFocus = false,
                    Position = UDim2.fromScale(0.02, 0.5),
                    AnchorPoint = Vector2.new(0, 0.5),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    Font = Enum.Font.SourceSansSemibold,
                    BackgroundTransparency = 1,
                    Text = u5:FindFirstChild("Name").Value,
                    TextColor3 = p2:Animation(u6.TextColor, u1),

                    FocusLost = function(p10) -- Line: 104, Name: FocusLost
                        -- upvalues: u8 (ref), SignalFunction (ref), u5 (copy)
                        local Text = p10.Text;

                        if u8 ~= nil and u8 ~= Text then
                            Text = SignalFunction.ToServer("HandleLoadoutActions", u5.Name, 3, Text);
                            p10.Text = Text;
                        end;

                        u8 = Text;
                    end,

                    function(p11) -- Line: 113
                        -- upvalues: u8 (ref)
                        u8 = p11.Text;
                    end
                })
            }),
            p2:State(function(p12, p13, p14) -- Line: 119
                -- upvalues: u6 (copy), GradientButton (ref), SignalEvent (ref), u5 (copy), u4 (copy)
                if p12(u6.Editable) then
                    return { p13:Create("Frame")({
                            Name = "Save",
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 6, 0.5, 0),
                            Size = UDim2.new(0.2925, 0, 1, -12),
                            BackgroundTransparency = 1,
                            GradientButton(p13, {
                                Text = "Save",
                                TweenInfo = p13.Info(0.1),
                                BgColor = Color3.new(0.807843, 0.94902, 0.74902),
                                TextXAlignment = Enum.TextXAlignment.Center,
                                TextBoxSize = UDim2.fromScale(1, 1),

                                Clicked = function() -- Line: 134, Name: Clicked
                                    -- upvalues: SignalEvent (ref), u5 (ref), u4 (ref)
                                    SignalEvent.ToServer("HandleLoadoutActions", u5.Name, 1);
                                    u4:Reset();
                                end
                            })
                        }), p13:Create("Frame")({
                            Name = "Load",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(0.2925, 0, 1, -12),
                            BackgroundTransparency = 1,
                            GradientButton(p13, {
                                Text = "Load",
                                BgColor = Color3.new(0.55, 0.55, 0.55),
                                TextXAlignment = Enum.TextXAlignment.Center,
                                TextBoxSize = UDim2.fromScale(1, 1),
                                TweenInfo = p13.Info(0.1),
                                Properties = {
                                    AnchorPoint = Vector2.new(0.5, 0),
                                    Position = UDim2.fromScale(0.5, 0)
                                },

                                Clicked = function() -- Line: 157, Name: Clicked
                                    -- upvalues: SignalEvent (ref), u5 (ref), u4 (ref)
                                    SignalEvent.ToServer("HandleLoadoutActions", u5.Name, 2);
                                    u4:Reset();
                                end
                            })
                        }), p13:Create("Frame")({
                            Name = "Cancel",
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, -6, 0.5, 0),
                            Size = UDim2.new(0.2925, 0, 1, -12),
                            BackgroundTransparency = 1,
                            GradientButton(p13, {
                                Text = "Close",
                                BgColor = Color3.new(1, 0.364706, 0.364706),
                                TextXAlignment = Enum.TextXAlignment.Center,
                                TextBoxSize = UDim2.fromScale(1, 1),
                                TweenInfo = p13.Info(0.1),
                                Properties = {
                                    AnchorPoint = Vector2.new(1, 0),
                                    Position = UDim2.fromScale(1, 0)
                                },

                                Clicked = function() -- Line: 180, Name: Clicked
                                    -- upvalues: u4 (ref)
                                    u4:Reset();
                                end
                            })
                        }) };
                end;
            end)
        })
    });
end;