-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local faye = require(ReplicatedStorage.Packages.faye);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Data = Utility.GetData(LocalPlayer, true);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local u1 = {
    Data.Inventory.Accessories.Stats.One,
    Data.Inventory.Accessories.Stats.Two,
    Data.Inventory.Accessories.Stats.Three,
    Data.Inventory.Accessories.Stats.Four,
    Data.Inventory.Accessories.Stats.Five
};
local u2 = {
    Data.Inventory.Accessories.Vanity.One,
    Data.Inventory.Accessories.Vanity.Two,
    Data.Inventory.Accessories.Vanity.Three,
    Data.Inventory.Accessories.Vanity.Four,
    Data.Inventory.Accessories.Vanity.Five
};
local u3 = faye.Info(0.1);
local ItemIcon = require(ReplicatedStorage.CAM.Global.Collectibles.ItemIcon);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local script_Slot = require(script.Slot);

return function(p4: any, p5: userdata, u6: any) -- Line: 34
    -- upvalues: u2 (copy), u1 (copy), Character_info_provider (copy), LocalPlayer (copy), ItemIcon (copy), script_Slot (copy), GradientButton (copy), SignalEvent (copy), u3 (copy)
    local u7 = p4:Value("One");
    local u8 = p4:Value("One");
    local u9 = {
        Vanity = {
            Type = 2,
            BgColor = p4:Value(Color3.new(0.936187, 0.90518, 0.404486)),
            Info = p4.Info(0.2),
            Text = p4:Value("Equip Vanity"),
            Value = u8,
            Order = u2
        },
        Stats = {
            Enabled = false,
            Type = 1,
            BgColor = p4:Value(Color3.new(0.834806, 0.703838, 0.976837)),
            Info = p4.Info(0.2),
            Text = p4:Value("Equip Stats"),
            Value = u7,
            Order = u1
        }
    };

    local function updItems() -- Line: 60
        -- upvalues: u6 (copy), u1 (ref), u7 (copy), u2 (ref), u8 (copy)
        local v10 = u6:Get();
        local u11 = v10 ~= nil and v10.Id.Value or nil;

        local function pickSlot(p12, p13) -- Line: 66
            -- upvalues: u11 (copy)
            if u11 ~= nil then
                for _, v in p12 do
                    if v.Value == u11 then
                        p13.Value = v.Name;

                        return;
                    end;
                end;
            end;

            for i = 1, 5 do
                if p12[i].Value == 0 then
                    p13.Value = p12[i].Name;

                    return;
                end;

                local _ = i;
            end;

            p13.Value = p12[5].Name;
        end;

        pickSlot(u1, u7);
        pickSlot(u2, u8);
    end;

    updItems();
    local u29 = p4:Space(function(p14: table, p15: any, p16: any, p17: any, p18: any, p19: any, p20: any, p21: any, p22: any, p23: any) -- Line: 89
        -- upvalues: Character_info_provider (ref), LocalPlayer (ref), u6 (copy), ItemIcon (ref), u7 (copy), u8 (copy)
        local v24 = 0;
        local Value = p16.Value;
        local v25;

        if Value == p14.LastNew then
            v25 = false;
        else
            v25 = true;
            local v26 = "";

            if Value ~= nil then
                local ItemFromId = Character_info_provider.GetItemFromId(LocalPlayer, Value);

                if ItemFromId ~= nil then
                    u6:Compare(ItemFromId);
                    v26 = ItemIcon.For(LocalPlayer, ItemFromId.Name);
                end;
            end;

            p15:Set(v26);
            p14.LastNew = Value;
        end;

        local v27;

        if p14.Type == 1 then
            v27 = u7:Compare(p14.Index) and 1 or v24;
        else
            v27 = u8:Compare(p14.Index) and 1 or v24;
        end;

        local v28 = v27 == 0 and p14.In and 2 or v27;

        if v28 ~= p14.State or v25 then
            p14.State = v28;

            if v28 == 1 then
                p17:Set(0);
                p20:Set(UDim2.fromScale(0.8, 0.8));
                p21:Set(UDim2.fromScale(0.85, 0.85));
                p19:Set(0.75);
                p18:Set(0.25);
                p23:Set(2);

                return;
            end;

            if Value > 0 then
                p17:Set(0);
            else
                p17:Reset();
            end;

            p20:Reset();
            p21:Reset();
            p19:Reset();

            if v28 == 2 then
                p23:Set(1);
                p18:Set(0.4);

                return;
            end;

            p23:Reset();
            p18:Reset();
        end;
    end);
    u29:Connect(u6.Changed);
    p4:Connect(u6.Changed, updItems);
    u29:Connect(u8.Changed);
    u29:Connect(u7.Changed);

    for i, v in u9 do
        local function updSlot() -- Line: 162
            -- upvalues: u6 (copy), Character_info_provider (ref), i (copy), LocalPlayer (ref), v (copy)
            if u6:Compare(Character_info_provider[`getEquippedAccessory{i}`](LocalPlayer, v.Value:Get())) then
                v.Enabled = false;
                v.BgColor:Set(Color3.new(1, 0, 0));
                v.Text:Set("UnEquip");

                return;
            end;

            v.Text:Reset();
            v.BgColor:Reset();
            v.Enabled = true;
        end;

        updSlot();
        local v30 = v;

        for _, v2 in pairs(v.Order) do
            p4:Connect(v2.Changed, updSlot);
            u29:Connect(v2.Changed, (`{v30.Type}-{v2.Name}`));
        end;

        v30.Value.Changed:Connect(updSlot);
    end;

    return p4:Create("Frame")({
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Name = "AccessoriesEquipped",
        p4:Create("Frame")({
            Name = "Stats",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            p4:Create("Frame")({
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Name = "Holder",
                p4:Create("UIListLayout")({
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0.0075, 0)
                }),
                p4:Iterate(u1, function(p31, p32, p33) -- Line: 201
                    -- upvalues: script_Slot (ref), u7 (copy), u29 (copy)
                    return script_Slot(p33, p31, p32, u7, u29, 1);
                end)
            }),
            p4:Create("Frame")({
                Name = "Title",
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.fromScale(0, 1.5),
                Size = UDim2.fromScale(0.2, 0.4),
                p4:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                p4:Create("UIGradient")({
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 1) })
                }),
                p4:Create("TextLabel")({
                    Size = UDim2.fromScale(1, 1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0.12, 3, 0.5, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.SourceSansSemibold,
                    Text = "Stats",
                    TextTransparency = 0.15,
                    TextScaled = true,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    p4:Create("UIStroke")({
                        Thickness = 1,
                        Transparency = 0.5
                    })
                }),
                p4:Create("ImageLabel")({
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://130994003654653",
                    ImageTransparency = 0.15,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.fromScale(-0.015, 0.6),
                    Size = UDim2.fromScale(0.2, 1),
                    ScaleType = Enum.ScaleType.Fit
                })
            }),
            GradientButton(p4, {
                GradientRotation = -90,
                Properties = {
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.fromScale(0.4375, 1.15),
                    Size = UDim2.fromScale(0.2, 0.4)
                },
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.75, 0.5), NumberSequenceKeypoint.new(1, 0.5) }),
                TextXAlignment = Enum.TextXAlignment.Center,

                Clicked = function() -- Line: 262, Name: Clicked
                    -- upvalues: u6 (copy), u7 (copy), u9 (copy), SignalEvent (ref)
                    local Value = u6:Get().Id.Value;
                    local v34 = u7:Get();

                    if v34 ~= "" and Value ~= nil then
                        if not u9.Stats.Enabled then
                            SignalEvent.ToServer("AccessoryEquip", v34, 0, "Stats");

                            return;
                        end;

                        SignalEvent.ToServer("AccessoryEquip", v34, Value, "Stats");
                    end;
                end,

                BgColor = p4:Animation(u9.Stats.BgColor, u3),
                Text = u9.Stats.Text,
                ContentColor = Color3.new(1, 1, 1)
            })
        }),
        p4:Create("Frame")({
            Name = "Vanity",
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(1, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            p4:Create("Frame")({
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Name = "Holder",
                p4:Create("UIListLayout")({
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0.0075, 0)
                }),
                p4:Iterate(u2, function(p35, p36, p37) -- Line: 298
                    -- upvalues: script_Slot (ref), u8 (copy), u29 (copy)
                    return script_Slot(p37, p35 + 10, p36, u8, u29, 2);
                end)
            }),
            p4:Create("Frame")({
                Name = "Title",
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.fromScale(1, 1.4),
                Size = UDim2.fromScale(0.2, 0.4),
                p4:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                p4:Create("UIGradient")({
                    Rotation = 180,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 1) })
                }),
                p4:Create("TextLabel")({
                    Size = UDim2.fromScale(1, 1),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(-0.155, -3, 0.5, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.SourceSansSemibold,
                    Text = "Vanity",
                    TextScaled = true,
                    TextTransparency = 0.15,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    p4:Create("UIStroke")({
                        Thickness = 1,
                        Transparency = 0.5
                    })
                }),
                p4:Create("ImageLabel")({
                    BackgroundTransparency = 1,
                    ImageTransparency = 0.15,
                    Image = "rbxassetid://81079881410330",
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.fromScale(1.015, 0.6),
                    Size = UDim2.fromScale(0.2, 1),
                    ScaleType = Enum.ScaleType.Fit
                })
            }),
            GradientButton(p4, {
                GradientRotation = -90,
                Properties = {
                    AnchorPoint = Vector2.new(0, 0),
                    Position = UDim2.fromScale(0.5625, 1.15),
                    Size = UDim2.fromScale(0.2, 0.4)
                },
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.75, 0.5), NumberSequenceKeypoint.new(1, 0.5) }),
                TextXAlignment = Enum.TextXAlignment.Center,

                Clicked = function() -- Line: 358, Name: Clicked
                    -- upvalues: u6 (copy), u8 (copy), u9 (copy), SignalEvent (ref)
                    local Value = u6:Get().Id.Value;
                    local v38 = u8:Get();

                    if v38 ~= "" and Value ~= nil then
                        if not u9.Vanity.Enabled then
                            SignalEvent.ToServer("AccessoryEquip", v38, 0, "Vanity");

                            return;
                        end;

                        SignalEvent.ToServer("AccessoryEquip", v38, Value, "Vanity");
                    end;
                end,

                BgColor = p4:Animation(u9.Vanity.BgColor, u3),
                Text = u9.Vanity.Text,
                ContentColor = Color3.new(1, 1, 1)
            })
        })
    });
end;