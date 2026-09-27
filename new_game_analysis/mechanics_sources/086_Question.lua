-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker.Presets);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local faye = require(ReplicatedStorage.Packages.faye);
local u1 = faye.Info(0.15);
local u2 = faye.Info(0.4);
local u3 = faye.Info(0.3, Enum.EasingStyle.Back);
local u4 = {
    Yes = BunchaIcons.Checkmark2,
    No = BunchaIcons.DeniedMark2
};

return function(u5: any, p6: userdata, p7: any, u8: number, u9: userdata?) -- Line: 24
    -- upvalues: GuiService (copy), u1 (copy), TweenService (copy), u2 (copy), GradientButton (copy), PopUpCreator (copy), u4 (copy), u3 (copy)
    local QuestionCounter = p6:FindFirstChild("QuestionCounter");
    local Y = GuiService:GetGuiInset().Y;

    if QuestionCounter == nil then
        QuestionCounter = Instance.new("Frame");
        QuestionCounter.Size = UDim2.new(1, 0, 1, Y);
        QuestionCounter.Name = "QuestionCounter";
        QuestionCounter.Position = UDim2.fromOffset(0, -Y);
        QuestionCounter.Parent = p6;
        QuestionCounter.BackgroundColor3 = Color3.new();
        QuestionCounter.BackgroundTransparency = 1;
        local Frame = Instance.new("Frame", QuestionCounter);
        Frame.Name = "Holder";
        Frame.Size = UDim2.fromScale(1, 1);
        Frame.BackgroundTransparency = 1;
        u5:LoadAnimation(QuestionCounter, {
            BackgroundTransparency = p7.BackgroundTransparency or 0.2
        }, u1):Play();
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.Parent = Frame;
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        UIListLayout.FillDirection = Enum.FillDirection.Vertical;
        UIListLayout.Padding = UDim.new(0, 5);
        local TextButton = Instance.new("TextButton", QuestionCounter);
        TextButton.Size = UDim2.fromScale(1, 1);
        TextButton.Name = "Button";
        TextButton.Text = "";
        TextButton.ZIndex = -1;
        TextButton.BackgroundTransparency = 1;
    end;

    local u10 = false;
    local u11 = p7.Timout or 5;
    script.PS2notificationOPEN.TimePosition = 0;
    script.PS2notificationOPEN:Play();
    local v12 = QuestionCounter:GetAttribute("Count") or 0;

    if v12 < 0 then
        local Button = QuestionCounter:FindFirstChild("Button");

        if Button == nil then
            v12 = 0;
        else
            Button.Size = UDim2.fromScale(1, 1);
            v12 = 0;
        end;
    end;

    QuestionCounter:SetAttribute("Count", v12 + 1);
    local Content = p7.Content;
    local v13, v14;

    if typeof(Content) == "table" then
        v13 = Content.Text or "Are you sure about this?";
        v14 = Content.Options;
    else
        v14 = nil;
        v13 = Content or "Are you sure about this?";
    end;

    local v15 = v14 == nil and {
        {
            Text = "Yes",
            Color = Color3.new(0.15, 1, 0.15)
        },
        {
            Text = "No",
            Color = Color3.new(1, 0.15, 0.15)
        }
    } or v14;
    u5:Add(function() -- Line: 87
        -- upvalues: QuestionCounter (ref), TweenService (ref), u2 (ref)
        if QuestionCounter.Parent == nil then
            return;
        end;

        local v16 = (QuestionCounter:GetAttribute("Count") or 1) - 1;
        QuestionCounter:SetAttribute("Count", v16);

        if v16 == 0 then
            local math_random_ret = math.random(-999, -1);
            QuestionCounter:SetAttribute("Count", math_random_ret);
            TweenService:Create(QuestionCounter, TweenInfo.new(u2.Time), {
                BackgroundTransparency = 1
            }):Play();
            local Button = QuestionCounter:FindFirstChild("Button");

            if Button ~= nil then
                Button.Size = UDim2.fromScale();
            end;

            task.delay(u2.Time, function() -- Line: 105
                -- upvalues: QuestionCounter (ref), math_random_ret (copy)
                local Attribute = QuestionCounter:GetAttribute("Count");

                if QuestionCounter.Parent ~= nil and Attribute == math_random_ret then
                    QuestionCounter:Destroy();
                end;
            end);
        end;
    end);
    local u17 = u5:Value(UDim2.new());
    u5:Create("CanvasGroup")({
        Parent = QuestionCounter.Holder,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromScale(0.2, 0.2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        GroupTransparency = u5:Animation(0, u1, {
            From = 1
        }),

        OnClean = function() -- Line: 125, Name: OnClean
            -- upvalues: u5 (copy), u2 (ref)
            return {
                GroupTransparency = u5:Animation(1, u2),
                Size = u5:Animation(UDim2.fromScale(0.17, 0.17), u2)
            };
        end,

        u5:Create("UIAspectRatioConstraint")({
            AspectRatio = 2
        }),
        u5:Create("UICorner")({
            CornerRadius = UDim.new(0.1)
        }),
        u5:Create("Frame")({
            Name = "Bg",
            ZIndex = -1,
            u5:Create("UIGradient")({
                Rotation = 40,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.3) })
            }),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromScale(1, 1),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
            BackgroundTransparency = u5:Animation(0.1, u1, {
                From = 1
            })
        }),
        u5:Create("UIStroke")({
            Transparency = 0.8,
            BorderOffset = UDim.new(0, -6),
            Color = Color3.new(1, 1, 1)
        }),
        u5:Create("ScrollingFrame")({
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Name = "Holder",
            ScrollingDirection = Enum.ScrollingDirection.Y,
            CanvasSize = u17,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.6,
            u5:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 5),

                AbsoluteContentSizeOnChangedInit = function(p18: userdata) -- Line: 174, Name: AbsoluteContentSizeOnChangedInit
                    -- upvalues: u17 (copy)
                    u17:Set(UDim2.fromOffset(0, p18.AbsoluteContentSize.Y));
                end
            }),
            u5:Create("TextLabel")({
                Name = "TextContent",
                Size = UDim2.fromScale(0.9, 0.55),
                BackgroundTransparency = 1,
                Text = v13,
                RichText = true,
                Font = Enum.Font.SourceSansBold,
                TextColor3 = Color3.new(1, 1, 1),
                TextWrapped = true,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                u5:Create("UITextSizeConstraint")({
                    MaxTextSize = 30
                }),
                u5:Create("UIStroke")({
                    Thickness = 1.5,
                    Transparency = 0.35,
                    Color = Color3.new()
                })
            }),
            u5:Create("Frame")({
                BackgroundTransparency = 1,
                Name = "ZButtonsHolder",
                Size = UDim2.fromScale(0.25, 0.15),
                u5:Create("UIListLayout")({
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0.15, 0)
                }),
                u5:Iterate(v15, function(u19: any, p20: any, p21: any, p22: userdata) -- Line: 223
                    -- upvalues: u5 (copy), u2 (ref), GradientButton (ref), u10 (ref), u9 (copy), PopUpCreator (ref), u8 (copy), u4 (ref), u11 (copy)
                    local u23, u24;

                    if typeof(p20) == "table" then
                        u23 = p20.Text or "";
                        u24 = p20.Color;
                    else
                        u23 = p20;
                        u24 = nil;
                    end;

                    return u5:Create("Frame")({
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        CleanDelay = u2.Time,
                        GradientButton(u5, {
                            GradientRotation = -90,
                            StrokeClick = true,
                            BgColor = u24,

                            Clicked = function() -- Line: 240, Name: Clicked
                                -- upvalues: u10 (ref), u9 (ref), u23 (ref), PopUpCreator (ref), u8 (ref)
                                if u10 then
                                    return;
                                end;

                                u10 = true;

                                if u9 ~= nil then
                                    u9:Fire(u23);
                                end;

                                PopUpCreator.signal:Fire(u8);
                            end,

                            Text = u23,
                            Properties = {
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5)
                            },
                            Image = u4[u23],
                            GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
                        }),

                        function() -- Line: 260
                            -- upvalues: u19 (copy), u5 (ref), u24 (ref), u11 (ref)
                            if u19 == 2 then
                                return u5:Create("Frame")({
                                    Size = UDim2.new(0.8, 0, 0, 2),
                                    AnchorPoint = Vector2.new(0.5, 0),
                                    Position = UDim2.new(0.5, 0, 1, 4),
                                    BackgroundTransparency = 0.75,
                                    BackgroundColor3 = u24,
                                    u5:Create("Frame")({
                                        Name = "Bar",
                                        BackgroundColor3 = u24,
                                        Size = u5:Animation(UDim2.fromScale(0, 1), u5.Info(u11), {
                                            From = UDim2.fromScale(1, 1)
                                        })
                                    })
                                });
                            end;
                        end
                    });
                end)
            })
        }),

        After = function(p25: userdata) -- Line: 280, Name: After
            -- upvalues: u5 (copy), u3 (ref)
            return {
                Size = u5:Animation(p25.Size, u3, {
                    From = UDim2.fromScale(0.15, 0.15)
                })
            };
        end
    });
end;