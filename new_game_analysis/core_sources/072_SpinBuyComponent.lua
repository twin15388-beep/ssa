-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local u1 = require(ReplicatedStorage.Packages.faye).Info(0.15, Enum.EasingStyle.Sine);
local Color3_new_ret = Color3.new(0.15, 0.15, 0.15);
local robuxColor = gameSettings.robuxColor;
local Color3_new_ret2 = Color3.new(1, 1, 1);
local Color3_new_ret3 = Color3.new(1, 0.35, 0.35);
local u2 = false;

return function(u3: any, u4: table, u5: any, p6: number?) -- Line: 56
    -- upvalues: robuxColor (copy), Utility (copy), Shop (copy), BunchaIcons (copy), Players (copy), Color3_new_ret (copy), u1 (copy), Color3_new_ret2 (copy), Color3_new_ret3 (copy), u2 (ref), ScreenEffects (copy), PopUpCreator (copy), SignalFunction (copy), ReplicatedStorage (copy), DebrisModule (copy)
    local v7 = robuxColor;
    local v8;

    if u4.Price == nil then
        v8 = "";
    else
        v8 = Utility.addCommasToNumber(u4.Price);

        if u4.ListedPrice ~= nil and u4.ListedPrice ~= u4.Price then
            v8 = `{v8} <font face="SourceSans" color="rgb(170,170,170)" transparency=".45"><s>{Utility.addCommasToNumber(u4.ListedPrice)}</s></font>`;
        end;
    end;

    local OreContent = Shop.GetOreContent(nil, u4.Name);
    local u9 = OreContent == nil and "" or Utility.addCommasToNumber(OreContent.Price);

    local function perSpinOf(p10: number?, p11: string) -- Line: 73
        -- upvalues: u4 (copy)
        if p10 == nil then
            return "";
        end;

        local v12 = p10 / math.max(u4.Spins, 1) * 10 + 0.5;

        return `{p11}{math.floor(v12) / 10} / Spin`;
    end;

    local u13 = u3:Value(v8);
    local u14 = u3:Value(BunchaIcons.Robux);
    local u15 = u3:Value(robuxColor);
    local u16 = u3:Value(robuxColor);
    local Price = u4.Price;
    local v17;

    if Price == nil then
        v17 = "";
    else
        local v18 = Price / math.max(u4.Spins, 1) * 10 + 0.5;
        v17 = `R${math.floor(v18) / 10} / Spin`;
    end;

    local u19 = u3:Value(v17);

    local function inOre() -- Line: 85
        -- upvalues: u5 (copy), OreContent (copy)
        local v20;

        if u5 == nil or u5.Value ~= "Ore" then
            v20 = false;
        else
            v20 = OreContent ~= nil;
        end;

        return v20;
    end;

    local u21 = u3:Value(0);

    if OreContent ~= nil then
        local Data = Utility.GetData(Players.LocalPlayer);
        local v22;

        if Data == nil then
            v22 = nil;
        else
            v22 = Data:FindFirstChild("Inventory") or nil;
        end;

        local v23;

        if v22 == nil then
            v23 = nil;
        else
            v23 = v22:FindFirstChild("Inventory") or nil;
        end;

        if v23 ~= nil then
            local function bump() -- Line: 96
                -- upvalues: u21 (copy)
                u21:Set(u21.Value + 1);
            end;

            local function watchStack(p24: userdata) -- Line: 99
                -- upvalues: OreContent (copy), u21 (copy), u3 (copy), bump (copy)
                if p24.Name ~= OreContent.Item then
                    return;
                end;

                u21:Set(u21.Value + 1);
                local Amount = p24:FindFirstChild("Amount");

                if Amount ~= nil then
                    u3:Connect(Amount.Changed, bump);
                end;
            end;

            local v25 = v23:FindFirstChild(OreContent.Item);

            if v25 ~= nil and v25.Name == OreContent.Item then
                u21:Set(u21.Value + 1);
                local Amount = v25:FindFirstChild("Amount");

                if Amount ~= nil then
                    u3:Connect(Amount.Changed, bump);
                end;
            end;

            u3:Connect(v23.ChildAdded, watchStack);
            u3:Connect(v23.ChildRemoved, function(p26: userdata) -- Line: 112
                -- upvalues: OreContent (copy), u21 (copy)
                if p26.Name == OreContent.Item then
                    u21:Set(u21.Value + 1);
                end;
            end);
        end;
    end;

    local u27 = u3:Value(0.92);
    local u28 = u3:Value(0.8);
    local u29 = u3:Value(false);
    local v30 = u3:Create("Frame");
    local v31 = {
        Name = u4.Name,
        LayoutOrder = -u4.Spins,
        CleanDelay = p6 or 0.45,
        Size = UDim2.fromScale(1, 0.2),
        u3:Create("UIAspectRatioConstraint")({
            AspectRatio = 5.5,
            AspectType = Enum.AspectType.ScaleWithParentSize,
            DominantAxis = Enum.DominantAxis.Width
        }),
        BackgroundTransparency = 1
    };
    local v32 = u3:Create("Frame");
    local v33 = {
        Name = "ActualHolder",
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, -2, 1, -2),
        u3:Create("UICorner")({
            CornerRadius = UDim.new(0.2)
        }),
        BackgroundColor3 = Color3_new_ret
    };
    local v34 = u3:Create("Frame")({
        Name = "Fg",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = v7,
        BackgroundTransparency = u3:Animation(u27, u1),
        u3:Create("UICorner")({
            CornerRadius = UDim.new(0.2)
        }),
        u3:Create("UIGradient")({
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.6, 0.9), NumberSequenceKeypoint.new(1, 1) })
        })
    });
    local v35 = u3:Create("UIStroke")({
        Thickness = 1,
        Color = v7,
        Transparency = u3:Animation(u28, u1)
    });
    local v36 = u3:Create("Frame")({
        Name = "Left",
        Size = UDim2.new(0.6, 0, 1, -4),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 4, 0.5, 0),
        BackgroundTransparency = 1,
        u3:Create("UIListLayout")({
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        }),
        u3:Create("Frame")({
            Name = "NameRow",
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 0.7),
            BackgroundTransparency = 1,
            u3:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            }),
            u3:Create("TextLabel")({
                Name = "Title",
                LayoutOrder = 1,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromScale(0, 1),
                BackgroundTransparency = 1,
                Text = u4.Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextScaled = true,
                Font = Enum.Font.SourceSansBold,
                TextColor3 = Color3_new_ret2,
                u3:Create("UIStroke")({
                    Thickness = 1,
                    Transparency = 0.5
                })
            }),
            u3:Create("TextLabel")({
                Name = "PerSpin",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                TextScaled = true,
                TextTransparency = 0.6,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromScale(0, 0.5),
                Text = u19,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.SourceSansSemibold,
                TextColor3 = Color3_new_ret2
            })
        })
    });
    local v37 = u3:Create("Frame")({
        Name = "Price",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -6, 0.5, 0),
        Size = UDim2.new(0.4, -6, 0.51, 0),
        BackgroundTransparency = 1,
        u3:Create("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 1)
        }),
        u3:Create("Frame")({
            Name = "IconHolder",
            LayoutOrder = 1,
            Size = UDim2.fromScale(0.8, 0.8),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            BackgroundTransparency = 1,
            u3:Create("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.55),
                Size = UDim2.fromScale(0.8, 0.8),
                Image = u14,
                ImageColor3 = u3:Animation(u16, u1)
            })
        }),
        u3:Create("TextLabel")({
            Name = "Amount",
            LayoutOrder = 2,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromScale(0, 1),
            BackgroundTransparency = 1,
            RichText = true,
            Text = u13,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextScaled = true,
            Font = Enum.Font.SourceSansBold,
            TextColor3 = u3:Animation(u15, u1),
            u3:Create("UIStroke")({
                Thickness = 1,
                Transparency = 0.5
            })
        })
    });
    local v38;

    if u5 == nil then
        v38 = nil;
    else
        v38 = u3:State(function(p39, p40) -- Line: 291
            -- upvalues: u21 (copy), u5 (copy), OreContent (copy), Shop (ref), Players (ref), u4 (copy), u13 (copy), u9 (copy), u14 (copy), u16 (copy), Color3_new_ret2 (ref), u15 (copy), Color3_new_ret3 (ref), u19 (copy)
            p39(u21);

            if p39(u5) == "Ore" and OreContent ~= nil then
                local OreContent2 = Shop.GetOreContent(Players.LocalPlayer, u4.Name);
                local v41;

                if OreContent2 == nil then
                    v41 = false;
                else
                    v41 = OreContent2.CanBuy == false;
                end;

                local v42;

                if v41 then
                    v42 = `<s>{u9}</s>`;
                else
                    v42 = u9;
                end;

                u13:Set(v42);
                u14:Set(OreContent.Icon);
                u16:Set(Color3_new_ret2);
                local v43;

                if v41 then
                    v43 = Color3_new_ret3;
                else
                    v43 = Color3_new_ret2;
                end;

                u15:Set(v43);
                local Price2 = OreContent.Price;
                local v44;

                if Price2 == nil then
                    v44 = "";
                else
                    local v45 = Price2 / math.max(u4.Spins, 1) * 10 + 0.5;
                    v44 = `{math.floor(v45) / 10} / Spin`;
                end;

                u19:Set(v44);
            else
                u13:Reset();
                u14:Reset();
                u16:Reset();
                u15:Reset();
                u19:Reset();
            end;

            return p40:Create("Frame")({
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 0)
            });
        end) or nil;
    end;

    v33[2], v33[3], v33[4], v33[5], v33[6], v33[7], v33[8] = v34, v35, v36, v37, v38, u3:State(function(p46, p47) -- Line: 317
    -- upvalues: u29 (copy), u27 (copy), u28 (copy)
    if p46(u29) then
        u27:Set(0.45);
        u28:Set(0.25);
    else
        u27:Reset();
        u28:Reset();
    end;

    return p47:Create("Frame")({
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0, 0)
    });
end), u3:Create("TextButton")({
    Name = "Hit",
    ZIndex = 3,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),

    MouseButton1Click = function() -- Line: 336, Name: MouseButton1Click
        -- upvalues: u2 (ref), ScreenEffects (ref), u5 (copy), OreContent (copy), Shop (ref), Players (ref), u4 (copy), PopUpCreator (ref), Utility (ref), SignalFunction (ref), ReplicatedStorage (ref), DebrisModule (ref)
        if u2 then
            return;
        end;

        ScreenEffects.CircleClick();
        u2 = true;
        local v48;

        if u5 == nil or u5.Value ~= "Ore" then
            v48 = false;
        else
            v48 = OreContent ~= nil;
        end;

        if v48 then
            local OreContent2 = Shop.GetOreContent(Players.LocalPlayer, u4.Name);

            if PopUpCreator.new({
                Type = "Question",
                Content = `You have {Utility.addCommasToNumber(OreContent2 ~= nil and OreContent2.Held or nil or 0)} {OreContent.Item} left, are you sure you want to buy this?`
            }).Result:Wait(5) ~= "Yes" then
                u2 = false;

                return;
            end;
        end;

        local v49 = PopUpCreator.new({
            Type = "LoadingFull"
        });
        local v50;

        if u5 == nil or u5.Value ~= "Ore" then
            v50 = false;
        else
            v50 = OreContent ~= nil;
        end;

        local v51, v52;

        if v50 then
            v51, v52 = pcall(SignalFunction.ToServer, "PurchaseFromShopWithOre", u4.Name);
        else
            v51, v52 = pcall(SignalFunction.ToServer, "PurchaseFromShop", u4.Name, 1);
        end;

        v49:Destroy();
        u2 = false;
        local v53 = ReplicatedStorage.Assets.Sounds.Misc[v51 and v52 == true and "Money_Kaching" or "denied_old"]:Clone();
        v53.Parent = script;
        v53:Play();
        DebrisModule:AddItem(v53, v53.TimeLength);
    end,

    MouseEnter = function() -- Line: 375, Name: MouseEnter
        -- upvalues: u29 (copy)
        if u29.Value == false then
            u29:Set(true);
        end;
    end,

    MouseLeave = function() -- Line: 380, Name: MouseLeave
        -- upvalues: u29 (copy)
        if u29.Value == true then
            u29:Set(false);
        end;
    end
});
    v31[2] = v32(v33);

    return v30(v31);
end;