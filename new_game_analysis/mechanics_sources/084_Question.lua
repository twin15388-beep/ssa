-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(0.5, 0.9), NumberSequenceKeypoint.new(1, 1) });
local UDim_new_ret = UDim.new(0.1);
local Color3_new_ret = Color3.new();
local UDim_new_ret2 = UDim.new(1, 0);
local SourceSansSemibold = Enum.Font.SourceSansSemibold;
local Color3_new_ret2 = Color3.new(0.15, 1, 0.15);
local Color3_new_ret3 = Color3.new(1, 0.15, 0.15);
local NumberSequence_new_ret2 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) });
local u1 = {
    Yes = BunchaIcons.Checkmark2,
    No = BunchaIcons.DeniedMark2
};
local u2 = {
    {
        Text = "Yes",
        Color = Color3_new_ret2
    },
    {
        Text = "No",
        Color = Color3_new_ret3
    }
};
local u3 = faye.Info(0.15);

return function(p4: any, u5: table) -- Line: 68
    -- upvalues: u3 (copy), NumberSequence_new_ret (copy), UDim_new_ret (copy), Color3_new_ret (copy), UDim_new_ret2 (copy), SourceSansSemibold (copy), u2 (copy), GradientButton (copy), u1 (copy), NumberSequence_new_ret2 (copy)
    local u6 = false;

    return p4:Create("CanvasGroup")({
        Name = "Question",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        GroupTransparency = p4:Animation(0, u3, {
            From = 1
        }),
        p4:Create("Frame")({
            Name = "Card",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.96),
            Size = UDim2.fromScale(1, 0.32),
            BackgroundTransparency = 1,
            p4:Create("UIAspectRatioConstraint")({
                AspectRatio = 2.2
            }),
            p4:Create("Frame")({
                Name = "Bg",
                ZIndex = 0,
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(),
                p4:Create("UIGradient")({
                    Rotation = -90,
                    Transparency = NumberSequence_new_ret
                }),
                p4:Create("UICorner")({
                    CornerRadius = UDim_new_ret
                }),
                p4:Create("UIShadow")({
                    Transparency = 0.5,
                    Color = Color3_new_ret,
                    BlurRadius = UDim_new_ret2
                })
            }),
            p4:Create("Frame")({
                Name = "Rows",
                ZIndex = 1,
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                p4:Create("UIListLayout")({
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 5)
                }),
                p4:Create("TextLabel")({
                    Name = "TextContent",
                    LayoutOrder = 1,
                    Size = UDim2.fromScale(0.9, 0.6),
                    BackgroundTransparency = 1,
                    Text = u5.Text,
                    RichText = true,
                    Font = SourceSansSemibold,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextWrapped = true,
                    TextScaled = true,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Bottom,
                    p4:Create("UITextSizeConstraint")({
                        MaxTextSize = 30
                    })
                }),
                p4:Create("Frame")({
                    Name = "ZButtonsHolder",
                    LayoutOrder = 2,
                    Size = UDim2.fromScale(0.22, 0.2),
                    BackgroundTransparency = 1,
                    p4:Create("UIListLayout")({
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDim.new(0.15, 0)
                    }),
                    p4:Iterate(u2, function(p7, u8, p9) -- Line: 153
                        -- upvalues: GradientButton (ref), u1 (ref), NumberSequence_new_ret2 (ref), u6 (ref), u5 (copy)
                        return p9:Create("Frame")({
                            Name = u8.Text,
                            Size = UDim2.fromScale(1, 1),
                            BackgroundTransparency = 1,
                            GradientButton(p9, {
                                GradientRotation = -90,
                                StrokeClick = true,
                                BgColor = u8.Color,
                                Text = u8.Text,
                                Image = u1[u8.Text],
                                Properties = {
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Position = UDim2.fromScale(0.5, 0.5)
                                },
                                GradientTransparency = NumberSequence_new_ret2,

                                Clicked = function() -- Line: 169, Name: Clicked
                                    -- upvalues: u6 (ref), u5 (ref), u8 (copy)
                                    if u6 then
                                        return;
                                    end;

                                    u6 = true;
                                    u5.Answer(u8.Text);
                                end
                            })
                        });
                    end)
                })
            })
        })
    });
end;