-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local faye = require(ReplicatedStorage.Packages.faye);
local Notification = ReplicatedStorage.Communication.CnC.Notifications.Notification;
local robuxColor = gameSettings.robuxColor;
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(1, 0.35, 0.35);
local u1 = false;
local u2 = faye.Info(0.2);
local u3 = faye.SpringInfo(0.4, 1, 0.6);
local u4 = {
    White = Color3.new(1, 1, 1),
    Green = Color3.fromRGB(130, 255, 160),
    Red = Color3.fromRGB(255, 120, 120),
    Purple = Color3.fromRGB(195, 140, 255),
    Blue = Color3.fromRGB(130, 185, 255),
    Yellow = Color3.fromRGB(255, 225, 130)
};

local function accentOf(p5: string?) -- Line: 54
    -- upvalues: u4 (copy)
    local v6;

    if p5 == nil then
        v6 = nil;
    else
        v6 = u4[p5] or nil;
    end;

    if v6 == nil and p5 ~= nil then
        warn((`Shop GridContent: no accent colour "{p5}", using White`));
    end;

    return v6 or u4.White;
end;

return function(u7: any, p8: any, u9: table, u10: any, p11: string, u12: any, u13: any) -- Line: 100
    -- upvalues: u4 (copy), Shop (copy), Utility (copy), BunchaIcons (copy), robuxColor (copy), Players (copy), u2 (copy), u1 (ref), Notification (copy), ScreenEffects (copy), PopUpCreator (copy), SignalFunction (copy), ReplicatedStorage (copy), DebrisModule (copy), u3 (copy), Color3_new_ret (copy), Color3_new_ret2 (copy)
    local Color = u9.Color;
    local v14;

    if Color == nil then
        v14 = nil;
    else
        v14 = u4[Color] or nil;
    end;

    if v14 == nil and Color ~= nil then
        warn((`Shop GridContent: no accent colour "{Color}", using White`));
    end;

    local v15 = v14 or u4.White;
    local u16 = {
        Value = u9,
        In = u7:Value(false),
        BgColor = u7:Value(Color3.new(0.25, 0.25, 0.25)),
        ShadowTransparency = u7:Value(0.4),
        StrokeTransparency = u7:Value(0.7),
        StrokeThickness = u7:Value(1),
        GradientTransparency = u7:Value(NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.35, 0.9), NumberSequenceKeypoint.new(1, 1) })),
        IconSize = u7:Value(UDim2.fromScale(1.2, 1.2))
    };
    p8:Add(u16, u7, true):Call():Connect(u16.In.Changed);
    local RobuxPrice = Shop.cashiers.Product.GetRobuxPrice(u9.ProductId);
    local v17;

    if RobuxPrice == nil then
        v17 = "";
    else
        v17 = Utility.addCommasToNumber(RobuxPrice);

        if u9.ListedPrice ~= nil and u9.ListedPrice ~= RobuxPrice then
            v17 = `{v17} <font face="SourceSans" color="rgb(190,190,190)" transparency=".2"><s>{Utility.addCommasToNumber(u9.ListedPrice)}</s></font>`;
        end;
    end;

    local OreContent = Shop.GetOreContent(nil, u9.Name);
    local u18 = OreContent == nil and "" or Utility.addCommasToNumber(OreContent.Price);
    local u19 = u7:Value(v17);
    local u20 = u7:Value(BunchaIcons.Robux);
    local u21 = u7:Value(robuxColor);
    local u22 = u7:Value(robuxColor);
    local u23 = u7:Value(0);

    if OreContent ~= nil then
        local Data = Utility.GetData(Players.LocalPlayer);
        local v24;

        if Data == nil then
            v24 = nil;
        else
            v24 = Data:FindFirstChild("Inventory") or nil;
        end;

        local v25;

        if v24 == nil then
            v25 = nil;
        else
            v25 = v24:FindFirstChild("Inventory") or nil;
        end;

        if v25 ~= nil then
            local function bump() -- Line: 154
                -- upvalues: u23 (copy)
                u23:Set(u23.Value + 1);
            end;

            local function watchStack(p26: userdata) -- Line: 157
                -- upvalues: OreContent (copy), u23 (copy), u7 (copy), bump (copy)
                if p26.Name ~= OreContent.Item then
                    return;
                end;

                u23:Set(u23.Value + 1);
                local Amount = p26:FindFirstChild("Amount");

                if Amount ~= nil then
                    u7:Connect(Amount.Changed, bump);
                end;
            end;

            local v27 = v25:FindFirstChild(OreContent.Item);

            if v27 ~= nil and v27.Name == OreContent.Item then
                u23:Set(u23.Value + 1);
                local Amount = v27:FindFirstChild("Amount");

                if Amount ~= nil then
                    u7:Connect(Amount.Changed, bump);
                end;
            end;

            u7:Connect(v25.ChildAdded, watchStack);
            u7:Connect(v25.ChildRemoved, function(p28: userdata) -- Line: 170
                -- upvalues: OreContent (copy), u23 (copy)
                if p28.Name == OreContent.Item then
                    u23:Set(u23.Value + 1);
                end;
            end);
        end;
    end;

    return u7:Create("Frame")({
        Name = "Content",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        u7:Create("Frame")({
            Size = UDim2.new(1, -4, 1, -4),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = u7:Animation(u16.BgColor, u2),
            u7:Create("UIShadow")({
                Color = Color3.new(0.25, 0.25, 0.25),
                BlurRadius = UDim.new(0.4),
                Transparency = u7:Animation(u16.ShadowTransparency, u2)
            }),
            u7:Create("UICorner")({
                CornerRadius = UDim.new(0.2)
            }),
            u7:Create("UIStroke")({
                Color = v15,
                BorderOffset = UDim.new(0, -3),
                Transparency = u7:Animation(u16.StrokeTransparency, u2),
                Thickness = u7:Animation(u16.StrokeThickness, u2)
            }),
            u7:Create("TextButton")({
                Name = "Hitbox",
                BackgroundTransparency = 1,
                ZIndex = 5,
                Size = UDim2.fromScale(1, 1),

                MouseButton1Click = function() -- Line: 212, Name: MouseButton1Click
                    -- upvalues: u1 (ref), u12 (copy), u13 (copy), Notification (ref), u10 (copy), OreContent (copy), ScreenEffects (ref), Shop (ref), Players (ref), u9 (copy), Utility (ref), PopUpCreator (ref), SignalFunction (ref), ReplicatedStorage (ref), DebrisModule (ref)
                    if u1 then
                        return;
                    end;

                    local v29;

                    if u12.Value == "" then
                        v29 = nil;
                    else
                        v29 = u12.Value;
                    end;

                    if v29 == nil and u13.Value ~= "" then
                        Notification:Fire("Notify", {
                            Type = "Denied",
                            Text = `No player named {u13.Value} is in this server`
                        });

                        return;
                    end;

                    local v30;

                    if u10.Value == "Ore" then
                        v30 = OreContent ~= nil;
                    else
                        v30 = false;
                    end;

                    if v29 ~= nil and v30 then
                        Notification:Fire(
                            "Notify",
                            {
                                Text = "Gifts can only be bought with Robux, switch to the Robux tab",
                                Type = "Denied"
                            }
                        );

                        return;
                    end;

                    ScreenEffects.CircleClick();
                    u1 = true;
                    local v31 = nil;

                    if v30 then
                        local OreContent2 = Shop.GetOreContent(Players.LocalPlayer, u9.Name);
                        v31 = `You have {Utility.addCommasToNumber(OreContent2 == nil and 0 or (OreContent2.Held or 0))} {OreContent.Item} left, are you sure you want to buy this?`;
                    elseif v29 ~= nil then
                        v31 = `Gift {u9.Label or u9.Name} to {v29}?`;
                    end;

                    if v31 ~= nil and PopUpCreator.new({
                        Type = "Question",
                        Content = v31
                    }).Result:Wait(5) ~= "Yes" then
                        u1 = false;

                        return;
                    end;

                    local v32 = PopUpCreator.new({
                        Type = "LoadingFull"
                    });
                    local v33, v34, v35;

                    if v30 then
                        v33, v34, v35 = pcall(SignalFunction.ToServer, "PurchaseFromShopWithOre", u9.Name, 1, v29);
                    else
                        v33, v34, v35 = pcall(SignalFunction.ToServer, "PurchaseFromShop", u9.Name, 1, v29);
                    end;

                    v32:Destroy();
                    u1 = false;

                    if v33 and (v34 ~= true and typeof(v35) == "string") then
                        Notification:Fire("Notify", {
                            Type = "Denied",
                            Text = v35
                        });
                    end;

                    local v36 = ReplicatedStorage.Assets.Sounds.Misc[v33 and v34 == true and "Money_Kaching" or "denied_old"]:Clone();
                    v36.Parent = script;
                    v36:Play();
                    DebrisModule:AddItem(v36, v36.TimeLength);
                end,

                MouseEnter = function() -- Line: 282, Name: MouseEnter
                    -- upvalues: u16 (copy)
                    u16.In:Set(true);
                end,

                MouseLeave = function() -- Line: 285, Name: MouseLeave
                    -- upvalues: u16 (copy)
                    if not u16.In:Compare(true) then
                        return;
                    end;

                    u16.In:Set(false);
                end
            }),
            u7:Create("ImageLabel")({
                Name = "Icon",
                Size = u7:Animation(u16.IconSize, u3),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                u7:Create("UICorner")({
                    CornerRadius = UDim.new(0.2)
                }),
                Image = u9.Icon,
                ScaleType = Enum.ScaleType.Fit,
                BackgroundTransparency = 1
            }),
            u7:Create("TextLabel")({
                Name = "Title",
                Size = UDim2.fromScale(0.9, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.4),
                BackgroundTransparency = 1,
                ZIndex = 33,
                Text = u9.Label or u9.Name,
                TextColor3 = Color3.new(1, 1, 1),
                TextScaled = true,
                Font = Enum.Font.SourceSansSemibold,
                u7:Create("UIShadow")({
                    Transparency = 0.7,
                    BlurRadius = UDim.new(0.5)
                }),
                u7:Create("UIStroke")({
                    Thickness = 2,
                    Color = Color3.new(),
                    u7:Create("UIGradient")({
                        Rotation = -90,
                        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.75) })
                    })
                })
            }),
            u7:Create("Frame")({
                Name = "Price",
                ZIndex = 3,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 0.95),
                Size = UDim2.fromScale(0.9, (p11 == "Half" and 1.7 or 1) * 0.16),
                BackgroundTransparency = 1,
                u7:Create("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 1)
                }),
                u7:Create("Frame")({
                    Name = "IconHolder",
                    LayoutOrder = 1,
                    Size = UDim2.fromScale(0.8, 0.8),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    BackgroundTransparency = 1,
                    u7:Create("ImageLabel")({
                        Name = "Icon",
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.55),
                        Size = UDim2.fromScale(0.8, 0.8),
                        BackgroundTransparency = 1,
                        Image = u20,
                        ImageColor3 = u7:Animation(u22, u2),
                        u7:Create("UIShadow")({
                            Transparency = 0.7,
                            BlurRadius = UDim.new(0.5)
                        })
                    })
                }),
                u7:Create("TextLabel")({
                    Name = "Amount",
                    LayoutOrder = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.fromScale(0, 1),
                    BackgroundTransparency = 1,
                    RichText = true,
                    Text = u19,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextScaled = true,
                    Font = Enum.Font.SourceSansBold,
                    TextColor3 = u7:Animation(u21, u2),
                    u7:Create("UIShadow")({
                        Transparency = 0.7,
                        BlurRadius = UDim.new(0.5)
                    }),
                    u7:Create("UIStroke")({
                        Thickness = 1,
                        Transparency = 0.5
                    })
                }),
                u7:State(function(p37, p38) -- Line: 391
                    -- upvalues: u23 (copy), u10 (copy), OreContent (copy), Shop (ref), Players (ref), u9 (copy), u19 (copy), u18 (copy), u20 (copy), u22 (copy), Color3_new_ret (ref), u21 (copy), Color3_new_ret2 (ref)
                    p37(u23);

                    if p37(u10) == "Ore" and OreContent ~= nil then
                        local OreContent2 = Shop.GetOreContent(Players.LocalPlayer, u9.Name);
                        local v39;

                        if OreContent2 == nil then
                            v39 = false;
                        else
                            v39 = OreContent2.CanBuy == false;
                        end;

                        local v40;

                        if v39 then
                            v40 = `<s>{u18}</s>`;
                        else
                            v40 = u18;
                        end;

                        u19:Set(v40);
                        u20:Set(OreContent.Icon);
                        u22:Set(Color3_new_ret);
                        local v41;

                        if v39 then
                            v41 = Color3_new_ret2;
                        else
                            v41 = Color3_new_ret;
                        end;

                        u21:Set(v41);
                    else
                        u19:Reset();
                        u20:Reset();
                        u22:Reset();
                        u21:Reset();
                    end;

                    return p38:Create("Frame")({
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(0, 0)
                    });
                end)
            }),
            u7:Create("Frame")({
                Size = UDim2.fromScale(1, 1),
                ZIndex = 2,
                BackgroundColor3 = v15,
                u7:Create("UICorner")({
                    CornerRadius = UDim.new(0.2)
                }),
                u7:Create("UIGradient")({
                    Rotation = -90,
                    Transparency = u7:Animation(u16.GradientTransparency, u2)
                })
            })
        })
    });
end;