-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local faye = require(ReplicatedStorage.Packages.faye);
local LocalPlayer = Players.LocalPlayer;
local u1 = faye.Info(0.1);
local u2 = DataValue.new("Misc/EquippedBaitId", 0);

return function(p3: any, p4: userdata, u5: any) -- Line: 30
    -- upvalues: u2 (copy), Character_info_provider (copy), LocalPlayer (copy), Items (copy), u1 (copy), GradientButton (copy), SignalEvent (copy)
    local u6 = p3:Value(u2:Get());
    local u7 = p3:Value("");
    local u8 = p3:Value(0.75);
    local v9 = p3:Value(0.95);
    local v10 = p3:Value(0.95);
    local u11 = p3:Value(Color3.new(0.53, 0.78, 0.62));
    local u12 = p3:Value("Equip Bait");

    local function entryId(p13: userdata?) -- Line: 42
        if p13 == nil then
            return nil;
        end;

        local Id = p13:FindFirstChild("Id");

        if Id == nil or not Id:IsA("ValueBase") then
            return nil;
        end;

        return Id.Value;
    end;

    local function isSelectedEquipped() -- Line: 49
        -- upvalues: u6 (copy), u5 (copy)
        local v14 = u6:Get();
        local v15;

        if v14 == 0 then
            v15 = false;
        else
            local v16 = u5:Get();
            local v17;

            if v16 == nil then
                v17 = nil;
            else
                local Id = v16:FindFirstChild("Id");

                if Id == nil or not Id:IsA("ValueBase") then
                    v17 = nil;
                else
                    v17 = Id.Value;
                end;
            end;

            v15 = v17 == v14;
        end;

        return v15;
    end;

    local function resolveEquippedConfig() -- Line: 56
        -- upvalues: u6 (copy), Character_info_provider (ref), LocalPlayer (ref), Items (ref)
        local v18 = u6:Get();

        if type(v18) ~= "number" or v18 == 0 then
            return nil;
        end;

        local success, result = pcall(Character_info_provider.GetItemFromId, LocalPlayer, v18);

        if success and result ~= nil then
            return Items[result.Name];
        end;

        return nil;
    end;

    local function update() -- Line: 64
        -- upvalues: u6 (copy), Character_info_provider (ref), LocalPlayer (ref), Items (ref), u7 (copy), u8 (copy), u5 (copy), u12 (copy), u11 (copy)
        local v19 = u6:Get();
        local v20;

        if type(v19) == "number" and v19 ~= 0 then
            local success, result = pcall(Character_info_provider.GetItemFromId, LocalPlayer, v19);

            if success and result ~= nil then
                v20 = Items[result.Name];
            else
                v20 = nil;
            end;
        else
            v20 = nil;
        end;

        u7:Set(v20 == nil and "" or (v20.Icon or ""));

        if v20 == nil then
            u8:Reset();
        else
            u8:Set(0);
        end;

        local v21 = u6:Get();
        local v22;

        if v21 == 0 then
            v22 = false;
        else
            local v23 = u5:Get();
            local v24;

            if v23 == nil then
                v24 = nil;
            else
                local Id = v23:FindFirstChild("Id");

                if Id == nil or not Id:IsA("ValueBase") then
                    v24 = nil;
                else
                    v24 = Id.Value;
                end;
            end;

            v22 = v24 == v21;
        end;

        if v22 then
            u12:Set("UnEquip");
            u11:Set(Color3.new(1, 0, 0));

            return;
        end;

        u12:Reset();
        u11:Reset();
    end;

    update();
    p3:Connect(u5.Changed, update);
    p3:Add(u2.Changed:Connect(function(p25) -- Line: 84
        -- upvalues: u6 (copy), update (copy)
        u6:Set(p25);
        update();
    end));

    return p3:Create("Frame")({
        Name = "BaitEquipped",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        p3:Create("Frame")({
            Name = "Holder",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            p3:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal
            }),
            p3:Create("Frame")({
                Name = "Slot",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Instance.new("UIAspectRatioConstraint"),
                p3:Create("Frame")({
                    Name = "Bg",
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.fromScale(0.8, 0.8),
                    BackgroundTransparency = p3:Animation(v10, u1),
                    p3:Create("UICorner")({
                        CornerRadius = UDim.new(0.15, 0)
                    })
                }),
                p3:Create("Frame")({
                    Name = "StrokeHolder",
                    Size = UDim2.fromScale(0.88, 0.88),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    BackgroundTransparency = 1,
                    p3:Create("UICorner")({
                        CornerRadius = UDim.new(0.15, 0)
                    }),
                    p3:Create("UIStroke")({
                        Thickness = 1,
                        Color = Color3.new(1, 1, 1),
                        Transparency = p3:Animation(v9, u1)
                    })
                }),
                p3:Create("ImageLabel")({
                    Name = "Img",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(0.6, 0.6),
                    ImageTransparency = p3:Animation(u8, u1),
                    Image = u7
                })
            })
        }),
        GradientButton(p3, {
            GradientRotation = -90,
            Properties = {
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 1.15),
                Size = UDim2.fromScale(0.2, 0.4)
            },
            GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.75, 0.5), NumberSequenceKeypoint.new(1, 0.5) }),
            TextXAlignment = Enum.TextXAlignment.Center,

            Clicked = function() -- Line: 159, Name: Clicked
                -- upvalues: u5 (copy), SignalEvent (ref), u6 (copy)
                local v26 = u5:Get();
                local v27;

                if v26 == nil then
                    v27 = nil;
                else
                    local Id = v26:FindFirstChild("Id");

                    if Id == nil or not Id:IsA("ValueBase") then
                        v27 = nil;
                    else
                        v27 = Id.Value;
                    end;
                end;

                if v27 == nil then
                    return;
                end;

                local ToServer = SignalEvent.ToServer;
                local v28 = u6:Get();
                local v29;

                if v28 == 0 then
                    v29 = false;
                else
                    local v30 = u5:Get();
                    local v31;

                    if v30 == nil then
                        v31 = nil;
                    else
                        local Id = v30:FindFirstChild("Id");

                        if Id == nil or not Id:IsA("ValueBase") then
                            v31 = nil;
                        else
                            v31 = Id.Value;
                        end;
                    end;

                    v29 = v31 == v28;
                end;

                ToServer("EquipBait", v29 and 0 or v27);
            end,

            BgColor = p3:Animation(u11, u1),
            Text = u12,
            ContentColor = Color3.new(1, 1, 1)
        })
    });
end;