-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local u1 = faye.Info(0.2);
local Color3_fromRGB_ret = Color3.fromRGB(255, 95, 95);
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_fromRGB_ret2 = Color3.fromRGB(85, 170, 255);
local Color3_new_ret2 = Color3.new(0.35, 0.35, 0.35);

return function(u2: any, u3: table) -- Line: 28
    -- upvalues: Shop (copy), Utility (copy), Color3_new_ret (copy), Color3_fromRGB_ret (copy), u1 (copy), GradientButton (copy), Color3_fromRGB_ret2 (copy), Color3_new_ret2 (copy)
    local CanPay = u3.CanPay;
    local PriceLines = u3.PriceLines;
    local u4 = {
        BgColor = false,
        ContentTransparency = false
    };

    return u2:Create("Frame")({
        Name = "Footer",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 0.1),
        BackgroundTransparency = 1,
        u2:Create("Frame")({
            Name = "Cost",
            Size = UDim2.fromScale(0.6, 1),
            BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
            BackgroundTransparency = 0.5,
            u2:Create("UICorner")({
                CornerRadius = UDim.new(0.3)
            }),
            u2:Create("UIStroke")({
                Transparency = 0.9,
                Color = Color3.new(1, 1, 1),
                BorderOffset = UDim.new(0, -4)
            }),
            u2:Create("UIPadding")({
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            }),
            u2:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            }),
            u2:Create("TextLabel")({
                Name = "Label",
                LayoutOrder = 0,
                BackgroundTransparency = 1,
                TextTransparency = 0.25,
                TextScaled = true,
                Size = UDim2.fromScale(0, 0.5),
                AutomaticSize = Enum.AutomaticSize.X,
                Font = Enum.Font.SourceSansSemibold,
                Text = u3.Label or (#PriceLines > 0 and "Cost" or "Free"),
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            u2:Iterate(PriceLines, function(p5: any, u6: any, u7: any, p8: userdata?) -- Line: 77
                -- upvalues: Shop (ref), Utility (ref), CanPay (copy), Color3_new_ret (ref), Color3_fromRGB_ret (ref), u1 (ref)
                local u9 = Shop.cashiers[u6.Currency];
                local v10;

                if u9 == nil then
                    v10 = false;
                else
                    v10 = u9.Deferred == true;
                end;

                local v11;

                if u9 == nil or v10 then
                    v11 = nil;
                else
                    v11 = u9.GetContent(u6.Amount);
                end;

                local u12 = u7:Value(v11);

                if v10 then
                    task.spawn(function() -- Line: 85
                        -- upvalues: u9 (copy), u6 (copy), u7 (copy), u12 (copy)
                        local Content = u9.GetContent(u6.Amount);

                        if not u7.IsActive then
                            return;
                        end;

                        u12:Set(Content);
                    end);
                end;

                return u7:Create("Frame")({
                    Name = u6.Currency,
                    LayoutOrder = p5,
                    Size = UDim2.fromScale(0, 1),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    u7:Create("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 3)
                    }),
                    u7:Create("ImageLabel")({
                        Name = "Icon",
                        LayoutOrder = 1,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(0.55, 0.55),
                        SizeConstraint = Enum.SizeConstraint.RelativeYY,
                        Image = u7:Do(function(p13) -- Line: 113
                            -- upvalues: u12 (copy)
                            local v14 = p13(u12);

                            return v14 ~= nil and v14.Icon or "";
                        end),
                        ScaleType = Enum.ScaleType.Fit
                    }),
                    u7:Create("TextLabel")({
                        Name = "Amount",
                        LayoutOrder = 2,
                        BackgroundTransparency = 1,
                        RichText = true,
                        TextScaled = true,
                        Size = UDim2.fromScale(0, 0.5),
                        AutomaticSize = Enum.AutomaticSize.X,
                        Font = Enum.Font.SourceSansBold,
                        Text = u7:Do(function(p15) -- Line: 130
                            -- upvalues: u12 (copy), Utility (ref), CanPay (ref), u6 (copy)
                            local v16 = p15(u12);

                            if v16 == nil then
                                return "...";
                            end;

                            local v17 = Utility.addCommasToNumber(v16.Price);

                            if CanPay(p15, u6.Currency, u6.Amount) then
                                return v17;
                            end;

                            return `<s>{v17}</s>`;
                        end),
                        TextColor3 = u7:Do(function(p18) -- Line: 137
                            -- upvalues: u12 (copy), Color3_new_ret (ref), u7 (copy), CanPay (ref), u6 (copy), Color3_fromRGB_ret (ref), u1 (ref)
                            local v19 = p18(u12);
                            local v20 = v19 ~= nil and v19.Color or Color3_new_ret;

                            if not CanPay(p18, u6.Currency, u6.Amount) then
                                v20 = Color3_fromRGB_ret;
                            end;

                            return u7:Animation(v20, u1);
                        end),
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                });
            end)
        }),
        u2:Create("Frame")({
            Name = "ActionButton",
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.new(0.4, -6, 1, 0),
            BackgroundTransparency = 1,
            GradientButton(u2, {
                GradientRotation = -90,
                StrokeClick = true,
                Text = u3.Text,
                Font = Enum.Font.SourceSansBold,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextBoxSize = UDim2.fromScale(0.8, 0.55),
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) }),
                BgColor = u2:Do(function(p21) -- Line: 170
                    -- upvalues: u3 (copy), Color3_fromRGB_ret2 (ref), Color3_new_ret2 (ref), u4 (copy), u2 (copy), u1 (ref)
                    local v22;

                    if u3.Ready(p21) then
                        v22 = Color3_fromRGB_ret2;
                    else
                        v22 = Color3_new_ret2;
                    end;

                    if u4.BgColor then
                        return u2:Animation(v22, u1);
                    end;

                    u4.BgColor = true;

                    return v22;
                end),
                ContentTransparency = u2:Do(function(p23) -- Line: 178
                    -- upvalues: u3 (copy), u4 (copy), u2 (copy), u1 (ref)
                    local v24 = u3.Ready(p23) and 0 or 0.5;

                    if u4.ContentTransparency then
                        return u2:Animation(v24, u1);
                    end;

                    u4.ContentTransparency = true;

                    return v24;
                end),
                CornerRadius = UDim.new(0.3),
                Clicked = u3.Clicked,
                Properties = {
                    Size = UDim2.fromScale(0.9, 1),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5)
                }
            })
        })
    });
end;