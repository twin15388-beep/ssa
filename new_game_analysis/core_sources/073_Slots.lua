-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local script_Slot = require(script.Slot);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
require(ReplicatedStorage.CAM.Global.Policies);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local VipAccess = require(ReplicatedStorage.CAM.Global.VipAccess);
require(ReplicatedStorage.CAM.Global.Subscriptions);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local u1 = require(ReplicatedStorage.Packages.faye).Info(0.35);
local Color3_fromRGB_ret = Color3.fromRGB(85, 170, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 200, 60);

local function actionButton(p2: any, p3: string, p4, p5: function) -- Line: 25
    -- upvalues: GradientButton (copy)
    return GradientButton(p2, {
        GradientRotation = -90,
        Text = p3,
        BgColor = p4,
        Clicked = p5,
        TextXAlignment = Enum.TextXAlignment.Center,
        Properties = {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5)
        },
        GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.5) })
    });
end;

return function(p6: any, u7: boolean) -- Line: 42
    -- upvalues: Utility (copy), Players (copy), VipAccess (copy), PopUpCreator (copy), SignalFunction (copy), u1 (copy), ScreenEffects (copy), BunchaIcons (copy), actionButton (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), script_Slot (copy)
    local Data = Utility.GetData(Players.LocalPlayer, true);
    local u8 = Data.Spinning[u7 and "ClanBag" or "EABag"];
    local u9 = p6:Value("One");
    local LocalPlayer = Players.LocalPlayer;
    local u10 = p6:Value(VipAccess.Has(LocalPlayer));
    p6:Connect(VipAccess.Changed(), function() -- Line: 51
        -- upvalues: u10 (copy), VipAccess (ref), LocalPlayer (copy)
        u10:Set(VipAccess.Has(LocalPlayer));
    end);
    local u11;

    if u7 then
        u11 = Data.Clan;
    else
        u11 = Data.Powers.DemonArt;
    end;

    local function nameOf(p12: string) -- Line: 57
        return (p12 == "" or p12 == "None") and "Nothing" or p12;
    end;

    local u13 = false;

    local function act(u14: string) -- Line: 63
        -- upvalues: u13 (ref), u10 (copy), u8 (copy), u9 (copy), u11 (copy), PopUpCreator (ref), Utility (ref), SignalFunction (ref), u7 (copy)
        if u13 or not u10.Value then
            return;
        end;

        u13 = true;
        task.spawn(function() -- Line: 66
            -- upvalues: u8 (ref), u9 (ref), u13 (ref), u14 (copy), u11 (ref), PopUpCreator (ref), Utility (ref), SignalFunction (ref), u7 (ref)
            local v15 = u8:FindFirstChild(u9.Value);

            if v15 == nil then
                u13 = false;

                return;
            end;

            local v16;

            if u14 == "Set" then
                v16 = u11.Value;
            else
                v16 = v15.Value;
            end;

            local v17 = (v16 == "" or v16 == "None") and "Nothing" or v16;
            local new = PopUpCreator.new;
            local v18 = {
                Type = "Question"
            };
            local v19;

            if u14 == "Set" then
                v19 = `Are you sure you want to save {Utility.NameTag(v17, true)} to this slot?`;
            else
                v19 = `Are you sure you want to load {Utility.NameTag(v17, true)}?`;
            end;

            v18.Content = v19;

            if new(v18):WaitResult() ~= "Yes" then
                u13 = false;

                return;
            end;

            local v20 = PopUpCreator.new({
                Type = "LoadingFull"
            });
            pcall(SignalFunction.ToServer, "SpinBag", u14, u7, u9.Value);
            v20:Destroy();
            u13 = false;
        end);
    end;

    return p6:Create("Frame")({
        Name = "ActualSlotHolder",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        p6:State(function(p21: function, p22: any, p23: userdata?) -- Line: 90
            -- upvalues: u10 (copy), u1 (ref), u13 (ref), ScreenEffects (ref), PopUpCreator (ref), VipAccess (ref), BunchaIcons (ref), u7 (copy)
            if not p21(u10) then
                return p22:Create("CanvasGroup")({
                    Name = "VipCover",
                    ZIndex = 99,
                    Size = UDim2.new(1, 4, 1, 4),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    BackgroundTransparency = 1,
                    OnClean = {
                        GroupTransparency = p22:Animation(1, u1)
                    },
                    p22:Create("TextButton")({
                        ZIndex = 99,
                        CleanDelay = u1.Time,

                        MouseButton1Click = function(p24) -- Line: 107, Name: MouseButton1Click
                            -- upvalues: u13 (ref), ScreenEffects (ref), PopUpCreator (ref), VipAccess (ref)
                            if u13 then
                                return;
                            end;

                            u13 = true;
                            ScreenEffects.StrokeClick(p24.Parent, UDim.new(0.2));
                            local v25 = PopUpCreator.new({
                                Type = "LoadingFull"
                            });
                            VipAccess.PromptPurchase();
                            v25:Destroy();
                            u13 = false;
                        end,

                        BackgroundTransparency = 0.05,
                        Selectable = true,
                        AutoButtonColor = false,
                        Size = UDim2.new(1, 4, 1, 4),
                        BackgroundColor3 = Color3.new(),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        p22:Create("UICorner")({
                            CornerRadius = UDim.new(0.2)
                        }),
                        p22:Create("UIGradient")({
                            Rotation = -90,
                            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.5) })
                        }),
                        p22:Create("UIListLayout")({
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            FillDirection = Enum.FillDirection.Vertical
                        }),
                        p22:Create("ImageLabel")({
                            Size = UDim2.fromScale(0.3, 0.3),
                            Instance.new("UIAspectRatioConstraint"),
                            BackgroundTransparency = 1,
                            Image = BunchaIcons.Locked
                        }),
                        p22:Create("TextLabel")({
                            BackgroundTransparency = 1,
                            TextScaled = true,
                            Size = UDim2.new(1, -4, 0.5),
                            TextColor3 = Color3.new(1, 1, 1),
                            Text = `Purchase VIP to load and save your {u7 and "Clans" or "Evil Arts"}! (Click me)`,
                            Font = Enum.Font.SourceSansSemibold
                        })
                    })
                });
            end;
        end),
        p6:Create("UIShadow")({
            Transparency = 0.5,
            BlurRadius = UDim.new(0.5)
        }),
        p6:Create("Frame")({
            Name = "Holder",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            p6:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0.05)
            }),
            p6:Create("Frame")({
                Name = "ASet",
                Size = UDim2.fromScale(0.8, 0.2),
                BackgroundTransparency = 1,
                actionButton(p6, "Set", Color3_fromRGB_ret, function() -- Line: 180
                    -- upvalues: u13 (ref), u10 (copy), u8 (copy), u9 (copy), u11 (copy), PopUpCreator (ref), Utility (ref), SignalFunction (ref), u7 (copy)
                    if not u13 then
                        if not u10.Value then
                            return;
                        end;

                        u13 = true;
                        local u26 = "Set";
                        task.spawn(function() -- Line: 66
                            -- upvalues: u8 (ref), u9 (ref), u13 (ref), u26 (copy), u11 (ref), PopUpCreator (ref), Utility (ref), SignalFunction (ref), u7 (ref)
                            local v27 = u8:FindFirstChild(u9.Value);

                            if v27 == nil then
                                u13 = false;

                                return;
                            end;

                            local v28;

                            if u26 == "Set" then
                                v28 = u11.Value;
                            else
                                v28 = v27.Value;
                            end;

                            local v29 = (v28 == "" or v28 == "None") and "Nothing" or v28;
                            local new = PopUpCreator.new;
                            local v30 = {
                                Type = "Question"
                            };
                            local v31;

                            if u26 == "Set" then
                                v31 = `Are you sure you want to save {Utility.NameTag(v29, true)} to this slot?`;
                            else
                                v31 = `Are you sure you want to load {Utility.NameTag(v29, true)}?`;
                            end;

                            v30.Content = v31;

                            if new(v30):WaitResult() ~= "Yes" then
                                u13 = false;

                                return;
                            end;

                            local v32 = PopUpCreator.new({
                                Type = "LoadingFull"
                            });
                            pcall(SignalFunction.ToServer, "SpinBag", u26, u7, u9.Value);
                            v32:Destroy();
                            u13 = false;
                        end);
                    end;
                end)
            }),
            p6:Create("Frame")({
                Name = "BLoad",
                Size = UDim2.fromScale(0.8, 0.2),
                BackgroundTransparency = 1,
                actionButton(p6, "Load", Color3_fromRGB_ret2, function() -- Line: 188
                    -- upvalues: u13 (ref), u10 (copy), u8 (copy), u9 (copy), u11 (copy), PopUpCreator (ref), Utility (ref), SignalFunction (ref), u7 (copy)
                    if not u13 then
                        if not u10.Value then
                            return;
                        end;

                        u13 = true;
                        local u33 = "Load";
                        task.spawn(function() -- Line: 66
                            -- upvalues: u8 (ref), u9 (ref), u13 (ref), u33 (copy), u11 (ref), PopUpCreator (ref), Utility (ref), SignalFunction (ref), u7 (ref)
                            local v34 = u8:FindFirstChild(u9.Value);

                            if v34 == nil then
                                u13 = false;

                                return;
                            end;

                            local v35;

                            if u33 == "Set" then
                                v35 = u11.Value;
                            else
                                v35 = v34.Value;
                            end;

                            local v36 = (v35 == "" or v35 == "None") and "Nothing" or v35;
                            local new = PopUpCreator.new;
                            local v37 = {
                                Type = "Question"
                            };
                            local v38;

                            if u33 == "Set" then
                                v38 = `Are you sure you want to save {Utility.NameTag(v36, true)} to this slot?`;
                            else
                                v38 = `Are you sure you want to load {Utility.NameTag(v36, true)}?`;
                            end;

                            v37.Content = v38;

                            if new(v37):WaitResult() ~= "Yes" then
                                u13 = false;

                                return;
                            end;

                            local v39 = PopUpCreator.new({
                                Type = "LoadingFull"
                            });
                            pcall(SignalFunction.ToServer, "SpinBag", u33, u7, u9.Value);
                            v39:Destroy();
                            u13 = false;
                        end);
                    end;
                end)
            }),
            p6:Create("Frame")({
                Name = "SlotsHolder",
                Size = UDim2.fromScale(1, 0.4),
                BackgroundTransparency = 1,
                p6:State(function(p40: function, p41: any) -- Line: 199
                    -- upvalues: u10 (copy), u7 (copy), u8 (copy), script_Slot (ref), u9 (copy)
                    if p40(u10) then
                        local u42 = p41:Value(UDim2.new());
                        local u43 = nil;

                        local function centreCanvas() -- Line: 211
                            -- upvalues: u43 (ref)
                            if u43 == nil or u43.Parent == nil then
                                return;
                            end;

                            local math_max_ret = math.max(u43.AbsoluteCanvasSize.X - u43.AbsoluteWindowSize.X, 0);
                            u43.CanvasPosition = Vector2.new(math_max_ret / 2, 0);
                        end;

                        local v44 = p41:Create("CanvasGroup");
                        local v45 = {
                            Name = "Slots",
                            Size = UDim2.fromScale(1, 1),
                            BackgroundTransparency = 1
                        };
                        local v46;

                        if u7 then
                            v46 = p41:Create("UIGradient")({
                                Transparency = NumberSequence.new({
                                    NumberSequenceKeypoint.new(0, 1),
                                    NumberSequenceKeypoint.new(0.25, 0),
                                    NumberSequenceKeypoint.new(0.75, 0),
                                    NumberSequenceKeypoint.new(1, 1)
                                })
                            }) or nil;
                        else
                            v46 = nil;
                        end;

                        v45[1], v45[2] = v46, p41:Create("ScrollingFrame")({
    Name = "Scroller",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 0,
    ScrollingDirection = Enum.ScrollingDirection.X,
    CanvasSize = u42,

    function(p47: userdata) -- Line: 242
        -- upvalues: u43 (ref), centreCanvas (copy)
        u43 = p47;
        task.defer(centreCanvas);
    end,

    p41:Create("UIListLayout")({
        Name = "List",
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 2),

        AbsoluteContentSizeOnChangedInit = function(p48: userdata, p49) -- Line: 252, Name: AbsoluteContentSizeOnChangedInit
            -- upvalues: u42 (copy), centreCanvas (copy)
            u42:Set(UDim2.fromOffset(p49.X * 1.3, 0));
            task.defer(centreCanvas);
        end
    }),
    p41:Iterate(u8:GetChildren(), function(p50: any, p51: any, p52: any, p53: userdata?) -- Line: 258
        -- upvalues: script_Slot (ref), u9 (ref)
        return script_Slot(p52, u9, p51);
    end)
});

                        return v44(v45);
                    end;
                end)
            })
        })
    });
end;