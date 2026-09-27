-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local faye = require(ReplicatedStorage.Packages.faye);
local UDim2_fromScale_ret = UDim2.fromScale(0.45, 1.6);
local UDim2_fromScale_ret2 = UDim2.fromScale(0.3, 1.1);
local UDim2_fromScale_ret3 = UDim2.fromScale(0.275, 0.245);

local function scaled(p1, p2: number) -- Line: 21
    if p2 == 1 then
        return p1;
    end;

    return UDim2.fromScale(p1.X.Scale * p2, p1.Y.Scale * p2);
end;

local u3 = faye.Info(0.15);
local u4 = faye.Info(0.4);
local u5 = faye.Info(0.3, Enum.EasingStyle.Back);
local u6 = {
    Yes = BunchaIcons.Checkmark2,
    No = BunchaIcons.DeniedMark2,
    Accept = BunchaIcons.Checkmark2,
    Decline = BunchaIcons.DeniedMark2
};

local function resolveHost() -- Line: 47
    -- upvalues: Players (copy)
    local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui");

    if PlayerGui == nil then
        return nil;
    end;

    local QuestionStrip = PlayerGui:FindFirstChild("QuestionStrip", true);

    if QuestionStrip ~= nil then
        return QuestionStrip;
    end;

    local ComponentsHolder = PlayerGui:FindFirstChild("ComponentsHolder");
    local v7;

    if ComponentsHolder == nil then
        v7 = nil;
    else
        v7 = ComponentsHolder:FindFirstChild("BottomHolder") or nil;
    end;

    local v8;

    if v7 == nil then
        v8 = nil;
    else
        v8 = v7:FindFirstChild("AAABottomCenterNotifications") or nil;
    end;

    if v8 ~= nil then
        return v8;
    end;

    local BottomCenterNotifications = PlayerGui:FindFirstChild("BottomCenterNotifications", true);

    if BottomCenterNotifications == nil then
        warn("[CenterBottomQuestion] no BottomCenterNotifications strip in PlayerGui, popup not shown");
    end;

    return BottomCenterNotifications;
end;

return function(u9: any, p10: userdata, p11: any, u12: number, u13: userdata?) -- Line: 67
    -- upvalues: Platform_Handler (copy), resolveHost (copy), UDim2_fromScale_ret (copy), u4 (copy), u3 (copy), UDim2_fromScale_ret3 (copy), GradientButton (copy), PopUpCreator (copy), u6 (copy), u5 (copy), UDim2_fromScale_ret2 (copy)
    local u14 = false;
    local u15 = p11.Timout or 5;
    local Content = p11.Content;
    local v16, v17;

    if typeof(Content) == "table" then
        v16 = Content.Text or "Are you sure about this?";
        v17 = Content.Options;
    else
        v17 = nil;
        v16 = Content or "Are you sure about this?";
    end;

    local u18 = v17 == nil and {
        {
            Text = "Yes",
            Color = Color3.new(0.15, 1, 0.15)
        },
        {
            Text = "No",
            Color = Color3.new(1, 0.15, 0.15)
        }
    } or v17;
    local PS2notificationOPEN = script:FindFirstChild("PS2notificationOPEN");

    if PS2notificationOPEN then
        PS2notificationOPEN.TimePosition = 0;
        PS2notificationOPEN:Play();
    end;

    local v19 = Platform_Handler.Platform.Value == "Mobile";
    local u20 = v19 and 1.35 or 1;
    local v21 = v19 and 1.8 or 1;
    local v22 = u9:Create("CanvasGroup");
    local v23 = {
        Parent = resolveHost()
    };
    local v24 = UDim2_fromScale_ret;

    if u20 ~= 1 then
        v24 = UDim2.fromScale(v24.X.Scale * u20, v24.Y.Scale * u20);
    end;

    v23.Size = v24;
    v23.BackgroundTransparency = 1;
    v23.CleanDelay = u4.Time;
    v23.GroupTransparency = u9:Animation(0, u3, {
        From = 1
    });

    function v23.OnClean() -- Line: 109
        -- upvalues: u9 (copy), u4 (ref)
        return {
            GroupTransparency = u9:Animation(1, u4)
        };
    end;

    local v25 = u9:Create("UIAspectRatioConstraint")({
        AspectRatio = 2.2
    });
    local v26 = u9:Create("UICorner")({
        CornerRadius = UDim.new(0.1)
    });
    local v27 = u9:Create("Frame")({
        Name = "Bg",
        ZIndex = -1,
        u9:Create("UIGradient")({
            Rotation = 40,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.3) })
        }),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
        BackgroundTransparency = u9:Animation(0.1, u3, {
            From = 1
        })
    });
    local v28 = u9:Create("Frame");
    local v29 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Name = "Holder"
    };
    local v30 = u9:Create("UIListLayout")({
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 5)
    });
    local v32 = u9:Create("TextLabel")({
        Name = "TextContent",
        BackgroundTransparency = 1,
        RichText = true,
        TextWrapped = true,
        Size = UDim2.fromScale(0.9, 0.9),
        Text = v16,
        Font = Enum.Font.SourceSansSemibold,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,

        TextBoundsOnChangedInit = function(p31: userdata) -- Line: 162, Name: TextBoundsOnChangedInit
            p31.TextSize = math.clamp(p31.Parent.AbsoluteSize.X * 0.1, 5, 100);

            if p31.TextBounds.X > 0 then
                p31.Size = UDim2.fromOffset(p31.TextBounds.X, p31.TextBounds.Y);
            end;
        end
    });
    local v33 = u9:Create("Frame");
    local v34 = {
        BackgroundTransparency = 1,
        Name = "ZButtonsHolder"
    };
    local v35 = UDim2_fromScale_ret3;

    if v21 ~= 1 then
        v35 = UDim2.fromScale(v35.X.Scale * v21, v35.Y.Scale * v21);
    end;

    v34.Size = v35;
    v34[1], v34[2] = u9:Create("UIListLayout")({
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0.15, 0)
}), u9:Iterate(u18, function(u36: any, p37: any, p38: any, p39: userdata) -- Line: 182
    -- upvalues: u9 (copy), u4 (ref), GradientButton (ref), u14 (ref), u13 (copy), PopUpCreator (ref), u12 (copy), u6 (ref), u18 (ref), u15 (copy)
    local u40, u41;

    if typeof(p37) == "table" then
        u40 = p37.Text or "";
        u41 = p37.Color;
    else
        u40 = p37;
        u41 = nil;
    end;

    return u9:Create("Frame")({
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        CleanDelay = u4.Time,
        GradientButton(u9, {
            GradientRotation = -90,
            StrokeClick = true,
            BgColor = u41,

            Clicked = function() -- Line: 198, Name: Clicked
                -- upvalues: u14 (ref), u13 (ref), u40 (ref), PopUpCreator (ref), u12 (ref)
                if u14 then
                    return;
                end;

                u14 = true;

                if u13 ~= nil then
                    u13:Fire(u40);
                end;

                PopUpCreator.signal:Fire(u12);
            end,

            Text = u40,
            Properties = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5)
            },
            Image = u6[u40],
            GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
        }),

        function() -- Line: 220
            -- upvalues: u36 (copy), u18 (ref), u9 (ref), u41 (ref), u15 (ref)
            if u36 == #u18 then
                return u9:Create("Frame")({
                    Name = "Countdown",
                    Size = UDim2.new(0.8, 0, 0, 2),
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 1, 4),
                    BackgroundColor3 = u41 or Color3.new(1, 0.15, 0.15),
                    BackgroundTransparency = 0.75,
                    u9:Create("Frame")({
                        Name = "Bar",
                        BackgroundColor3 = u41 or Color3.new(1, 0.15, 0.15),
                        Size = u9:Animation(UDim2.fromScale(0, 1), u9.Info(u15), {
                            From = UDim2.fromScale(1, 1)
                        })
                    })
                });
            end;
        end
    });
end);
    v29[1], v29[2], v29[3] = v30, v32, v33(v34);
    v23[1], v23[2], v23[3], v23[4] = v25, v26, v27, v28(v29);

    function v23.After(p42: userdata) -- Line: 241
        -- upvalues: u9 (copy), u5 (ref), UDim2_fromScale_ret2 (ref), u20 (copy)
        local v43 = {};
        local Size = p42.Size;
        local v44 = {};
        local v45 = UDim2_fromScale_ret2;
        local v46 = u20;

        if v46 ~= 1 then
            v45 = UDim2.fromScale(v45.X.Scale * v46, v45.Y.Scale * v46);
        end;

        v44.From = v45;
        v43.Size = u9:Animation(Size, u5, v44);

        return v43;
    end;

    v22(v23);
end;