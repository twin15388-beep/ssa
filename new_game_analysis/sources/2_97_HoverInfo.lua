-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local HoverInfo = require(ReplicatedStorage.CAM.Client.Modules.HoverInfo);
local ComponentsHolder = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ComponentsHolder");
local HUD = ReplicatedStorage.CAM.Client.Components.Layout.Visibility.HUD;
local u1 = faye.SpringInfo(0.2, 1, 0.5);
local UDim2_fromOffset_ret = UDim2.fromOffset(0, -12);
local UDim2_fromOffset_ret2 = UDim2.fromOffset(0, 12);

local function flipped(p2, p3) -- Line: 59
    return p2.Y.Offset - 12 - p3.Y.Offset < 4;
end;

local u4 = faye.new();
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;

local function pointerPosition() -- Line: 73
    -- upvalues: UserInputService (copy), GuiService (copy)
    local MouseLocation = UserInputService:GetMouseLocation();

    return UDim2.fromOffset(MouseLocation.X, MouseLocation.Y - GuiService:GetGuiInset().Y);
end;

local function Build(p11) -- Line: 78
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), ComponentsHolder (copy), UDim2_fromOffset_ret2 (copy), UDim2_fromOffset_ret (copy), u1 (copy)
    u6 = p11:Value("");
    u7 = p11:Value({});
    u8 = p11:Value(false);
    u9 = p11:Value(UDim2.fromOffset(0, 0));
    u10 = p11:Value(UDim2.fromOffset(50, 50));
    local u12 = p11:Value(UDim2.fromOffset(0, 0));
    local u13 = p11:Value(UDim2.fromOffset(0, 0));
    p11:Create("Frame")({
        Name = "HoverInfo",
        Parent = ComponentsHolder,
        Position = p11:Do(function(p14) -- Line: 91
            -- upvalues: u9 (ref), u10 (ref), UDim2_fromOffset_ret2 (ref), UDim2_fromOffset_ret (ref)
            local v15 = p14(u9);
            local v16 = p14(u10);
            local v17;

            if v15.Y.Offset - 12 - v16.Y.Offset < 4 then
                v17 = UDim2_fromOffset_ret2;
            else
                v17 = UDim2_fromOffset_ret;
            end;

            return v15 + v17;
        end),
        Visible = u8,
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        BackgroundTransparency = 0.35,
        ZIndex = 199,
        AnchorPoint = p11:Do(function(p18) -- Line: 99
            -- upvalues: u9 (ref), u10 (ref)
            local v19 = p18(u9);
            local v20 = p18(u10);

            if v19.Y.Offset - 12 - v20.Y.Offset < 4 then
                return Vector2.new(0.5, 0);
            end;

            return Vector2.new(0.5, 1);
        end),
        Size = p11:Animation(u10, u1),
        p11:Create("ImageLabel")({
            Name = "Pointer",
            BackgroundTransparency = 1,
            Image = "rbxassetid://78357863901704",
            ImageTransparency = 0.35,
            ZIndex = 199,
            Size = UDim2.fromOffset(22, 22),
            Position = p11:Do(function(p21) -- Line: 108
                -- upvalues: u9 (ref), u10 (ref)
                local v22 = p21(u9);
                local v23 = p21(u10);

                if v22.Y.Offset - 12 - v23.Y.Offset < 4 then
                    return UDim2.fromScale(0.5, 0);
                end;

                return UDim2.fromScale(0.5, 1);
            end),
            Rotation = p11:Do(function(p24) -- Line: 111
                -- upvalues: u9 (ref), u10 (ref)
                local v25 = p24(u9);
                local v26 = p24(u10);

                return v25.Y.Offset - 12 - v26.Y.Offset < 4 and 180 or 0;
            end),
            AnchorPoint = p11:Do(function(p27) -- Line: 114
                -- upvalues: u9 (ref), u10 (ref)
                local v28 = p27(u9);
                local v29 = p27(u10);

                if v28.Y.Offset - 12 - v29.Y.Offset < 4 then
                    return Vector2.new(0.5, 1);
                end;

                return Vector2.new(0.5, 0);
            end),
            ImageColor3 = Color3.new(0.1, 0.1, 0.1)
        }),
        p11:Create("UICorner")({
            CornerRadius = UDim.new(0, 5)
        }),
        p11:Create("Frame")({
            Name = "ContentHolder",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            ZIndex = 199,
            p11:Create("UIListLayout")({
                AbsoluteContentSizeOnChangedInit = function(p30, p31) -- Line: 130, Name: AbsoluteContentSizeOnChangedInit
                    -- upvalues: u10 (ref)
                    u10:Set(UDim2.fromOffset(p31.X, p31.Y));
                end,

                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }),
            p11:Create("Frame")({
                Name = "NameHolder",
                Size = u12,
                BackgroundTransparency = 1,
                ZIndex = 199,
                p11:Create("TextLabel")({
                    TextSize = 25,
                    BackgroundTransparency = 1,
                    ZIndex = 199,
                    Font = Enum.Font.SourceSansSemibold,
                    Text = u6,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    TextColor3 = Color3.new(1, 1, 1),

                    TextBoundsOnChangedInit = function(p32, p33) -- Line: 151, Name: TextBoundsOnChangedInit
                        -- upvalues: u12 (copy)
                        u12:Set(UDim2.fromOffset(p33.X + 15, 30));
                    end
                })
            }),
            p11:Create("Frame")({
                Name = "StatsHolder",
                BackgroundTransparency = 1,
                Size = u13,
                ZIndex = 199,
                p11:Create("UIListLayout")({
                    VerticalAlignment = Enum.VerticalAlignment.Top,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,

                    AbsoluteContentSizeOnChangedInit = function(p34, p35) -- Line: 167, Name: AbsoluteContentSizeOnChangedInit
                        -- upvalues: u13 (copy)
                        u13:Set(UDim2.fromOffset(p35.X, p35.Y));
                    end
                }),
                p11:Iterate(u7, function(p36, p37, p38) -- Line: 171
                    return p38:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        ZIndex = 199,
                        Size = UDim2.fromOffset(35, 35),
                        ImageColor3 = Color3.new(1, 1, 1),
                        Image = p37
                    });
                end)
            })
        })
    });
end;

local function render(p39) -- Line: 190
    -- upvalues: u5 (ref), u8 (ref), u7 (ref), u6 (ref), u9 (ref), pointerPosition (copy)
    if u5 == nil then
        return;
    end;

    if p39 == nil then
        u8:Set(false);
        u7:Set({});

        return;
    end;

    u6:Set(p39.Name or "");
    u7:Set(p39.Icons or {});
    u9:Set(pointerPosition());
    u8:Set(true);
end;

local function update() -- Line: 208
    -- upvalues: HUD (copy), u5 (ref), HoverInfo (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u4 (copy), Build (copy)
    if HUD.Value == true == (u5 ~= nil) then
        return;
    end;

    if u5 == nil then
        u5 = u4:Extend();
        Build(u5);

        return;
    end;

    HoverInfo.Reset();
    u5:Destroy();
    u5 = nil;
    u6 = nil;
    u7 = nil;
    u8 = nil;
    u9 = nil;
    u10 = nil;
end;

update();
u4:Connect(HUD.Changed, update);
HoverInfo.Changed:Connect(render);
render(HoverInfo.Current());
UserInputService.InputChanged:Connect(function(p40) -- Line: 228
    -- upvalues: u5 (ref), u8 (ref), u9 (ref), pointerPosition (copy)
    if p40.UserInputType ~= Enum.UserInputType.MouseMovement then
        return;
    end;

    if u5 == nil or not u8:Get() then
        return;
    end;

    u9:Set(pointerPosition());
end);