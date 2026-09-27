-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local faye = require(ReplicatedStorage.Packages.faye);
local u1 = RunService:IsStudio() and not RunService:IsRunning();
local u2 = { "Player1", "Player2", "Playful", "Tanjiro", "Zenitsu", "Nezuko" };
local Color3_new_ret = Color3.new(0.15, 0.15, 0.15);
local Color3_new_ret2 = Color3.new(0.2, 0.2, 0.2);
local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0.85) });
local NumberSequence_new_ret2 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0) });
local Color3_new_ret3 = Color3.new(0.87, 0.87, 0.87);
local Color3_fromRGB_ret = Color3.fromRGB(130, 255, 160);
local Color3_fromRGB_ret2 = Color3.fromRGB(20, 48, 30);
local Color3_new_ret4 = Color3.new(1, 1, 1);
local Color3_new_ret5 = Color3.new(0.6, 0.6, 0.6);
local u3 = faye.Info(0.15);
local Font_new_ret = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
local u4 = faye.SpringInfo(0.3, 1, 0.5);
local u5 = faye.Info(0.3);
local u6 = faye.Info(0.2);
local u7 = faye.Info(0.125);

local function namesHere() -- Line: 88
    -- upvalues: Players (copy)
    local v8 = {};

    for _, v in Players:GetPlayers() do
        if v ~= Players.LocalPlayer then
            table.insert(v8, v.Name);
        end;
    end;

    return v8;
end;

local function findPlayer(p9: string) -- Line: 100
    -- upvalues: Players (copy), u1 (copy), u2 (copy)
    if p9 == "" then
        return nil;
    end;

    local string_lower_ret = string.lower(p9);

    for _, v in Players:GetPlayers() do
        if v ~= Players.LocalPlayer and string.lower(v.Name) == string_lower_ret then
            return v.Name;
        end;
    end;

    local v10 = nil;

    for _, v in Players:GetPlayers() do
        if v ~= Players.LocalPlayer and string.lower(v.DisplayName) == string_lower_ret then
            if v10 ~= nil then
                return nil;
            end;

            v10 = v.Name;
        end;
    end;

    if v10 ~= nil then
        return v10;
    end;

    if u1 then
        for _, v in u2 do
            if string.lower(v) == string_lower_ret then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function matchesFor(p11: string) -- Line: 133
    -- upvalues: namesHere (copy)
    local v12 = {};

    if p11 == "" then
        return v12;
    end;

    local string_lower_ret = string.lower(p11);

    for _, v in namesHere() do
        local string_lower_ret2 = string.lower(v);

        if string.sub(string_lower_ret2, 1, #string_lower_ret) == string_lower_ret then
            table.insert(v12, v);
        end;
    end;

    table.sort(v12, function(p13, p14) -- Line: 142
        if #p13 == #p14 then
            return p13 < p14;
        end;

        return #p13 < #p14;
    end);

    while #v12 > 5 do
        table.remove(v12);
    end;

    return v12;
end;

local function sameNames(p15: table, p16: table) -- Line: 154
    if #p15 ~= #p16 then
        return false;
    end;

    for i = 1, #p15 do
        if p15[i] ~= p16[i] then
            return false;
        end;

        local _ = i;
    end;

    return true;
end;

return function(u17, u18, u19) -- Line: 166
    -- upvalues: Color3_new_ret (copy), NumberSequence_new_ret (copy), Color3_new_ret4 (copy), Color3_fromRGB_ret2 (copy), NumberSequence_new_ret2 (copy), Color3_fromRGB_ret (copy), Color3_new_ret2 (copy), findPlayer (copy), Players (copy), u3 (copy), BunchaIcons (copy), Color3_new_ret5 (copy), matchesFor (copy), u7 (copy), Color3_new_ret3 (copy), u4 (copy), u6 (copy), u5 (copy), Font_new_ret (copy), ScreenEffects (copy)
    local u20 = u17:Value("");
    local u21 = u17:Value(Color3_new_ret);
    local u22 = u17:Value(0.25);
    local u23 = u17:Value(NumberSequence_new_ret);
    local u24 = u17:Value(1);
    local u25 = u17:Value(Color3_new_ret4);
    local u26 = u17:Value(UDim2.new(1, -40, 0.8, 0));
    local u27 = u17:Value({});
    local u28 = u17:Value(UDim2.new(1, 0, 0, 0));
    local u29 = u17:Value(false);
    local u30 = false;
    local u31 = nil;

    local function applyLook() -- Line: 188
        -- upvalues: u18 (copy), u21 (copy), Color3_fromRGB_ret2 (ref), u22 (copy), u23 (copy), NumberSequence_new_ret2 (ref), u24 (copy), u25 (copy), Color3_fromRGB_ret (ref), u30 (ref), Color3_new_ret2 (ref)
        if not u18:Compare("") then
            u21:Set(Color3_fromRGB_ret2);
            u22:Set(0);
            u23:Set(NumberSequence_new_ret2);
            u24:Set(0.15);
            u25:Set(Color3_fromRGB_ret);

            return;
        end;

        if u30 then
            u21:Set(Color3_new_ret2);
            u22:Set(0);
            u23:Set(NumberSequence_new_ret2);
            u24:Reset();
            u25:Reset();

            return;
        end;

        u21:Reset();
        u22:Reset();
        u23:Reset();
        u24:Reset();
        u25:Reset();
    end;

    local function clear() -- Line: 211
        -- upvalues: u18 (copy), u19 (copy), u20 (copy), u27 (copy), u28 (copy), u29 (copy), u31 (ref), applyLook (copy)
        u18:Set("");
        u19:Set("");
        u20:Set("");
        u27:Set({});
        u28:Set(UDim2.new(1, 0, 0, 0));
        u29:Set(false);

        if u31 ~= nil then
            u31.Text = "";
        end;

        applyLook();
    end;

    local function resolve(p32: string) -- Line: 224
        -- upvalues: u18 (copy), findPlayer (ref), u19 (copy), applyLook (copy)
        u18:Set(findPlayer(p32) or "");
        u19:Set((string.gsub(p32, "^%s*(.-)%s*$", "%1")));
        applyLook();
    end;

    local function take(p33: string) -- Line: 231
        -- upvalues: u31 (ref), u20 (copy), u29 (copy), u18 (copy), findPlayer (ref), u19 (copy), applyLook (copy)
        if u31 ~= nil then
            u31.Text = p33;
        end;

        u20:Set("");
        u29:Set(false);
        u18:Set(findPlayer(p33) or "");
        u19:Set((string.gsub(p33, "^%s*(.-)%s*$", "%1")));
        applyLook();
    end;

    u17:Connect(Players.ChildRemoved, function(p34: userdata) -- Line: 241
        -- upvalues: u18 (copy), clear (copy)
        if p34:IsA("Player") and u18:Compare(p34.Name) then
            clear();
        end;
    end);

    return u17:Create("Frame")({
        Name = "GiftBox",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = u17:Animation(u21, u3),
        BackgroundTransparency = u17:Animation(u22, u3),

        AbsoluteSizeOnChangedInit = function(p35: userdata, p36) -- Line: 252, Name: AbsoluteSizeOnChangedInit
            -- upvalues: u26 (copy)
            u26:Set(UDim2.new(1, -(10 + p36.Y * 0.5616 + 16), 0.8, 0));
        end,

        u17:Create("UIShadow")({
            Transparency = 0.85,
            Color = Color3.new(0.7, 0.7, 0.75),
            BlurRadius = UDim.new(0.8, 0)
        }),
        u17:Create("UIGradient")({
            Rotation = -90,
            Transparency = u17:Animation(u23, u3)
        }),
        u17:Create("UICorner")({
            CornerRadius = UDim.new(1)
        }),
        u17:Create("UIStroke")({
            Thickness = 1,
            Color = Color3_fromRGB_ret,
            Transparency = u17:Animation(u24, u3)
        }),
        u17:Create("ImageLabel")({
            Name = "Glyph",
            Size = UDim2.fromScale(0.5616, 0.5616),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 10, 0.5, 0),
            BackgroundTransparency = 1,
            Image = BunchaIcons.Gift,
            ScaleType = Enum.ScaleType.Fit,
            u17:Create("UIShadow")({
                Transparency = 0.7,
                BlurRadius = UDim.new(0.8, 0)
            })
        }),
        u17:Create("Frame")({
            Name = "Textboxholder",
            Size = u26,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -8, 0.5, 0),
            BackgroundTransparency = 1,

            AbsoluteSizeOnChangedInit = function(p37: userdata) -- Line: 299, Name: AbsoluteSizeOnChangedInit
                local math_floor_ret = math.floor(p37.AbsoluteSize.Y * 0.75);
                local math_max_ret = math.max(math_floor_ret, 1);

                for _, child in p37:GetChildren() do
                    if child:IsA("TextBox") or child:IsA("TextLabel") then
                        child.TextSize = math_max_ret;
                    end;
                end;
            end,

            u17:Create("TextBox")({
                Name = "Textbox",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                TextScaled = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextColor3 = u17:Animation(u25, u3),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                Font = Enum.Font.SourceSansSemibold,
                PlaceholderColor3 = Color3_new_ret5,
                PlaceholderText = "Gift to...",
                ClearTextOnFocus = false,

                function(p38: userdata) -- Line: 320
                    -- upvalues: u31 (ref), u30 (ref), applyLook (copy), u20 (copy), u18 (copy), findPlayer (ref), u19 (copy), u17 (copy), u29 (copy)
                    u31 = p38;

                    return {
                        Focused = function() -- Line: 323, Name: Focused
                            -- upvalues: u30 (ref), applyLook (ref)
                            u30 = true;
                            applyLook();
                        end,

                        FocusLost = function(p39: userdata, p40: boolean) -- Line: 327, Name: FocusLost
                            -- upvalues: u20 (ref), u30 (ref), u18 (ref), findPlayer (ref), u19 (ref), applyLook (ref), u17 (ref), u29 (ref)
                            if p40 and u20.Value ~= "" then
                                p39.Text = u20.Value;
                            end;

                            u20:Set("");
                            u30 = false;
                            local Text = p39.Text;
                            u18:Set(findPlayer(Text) or "");
                            u19:Set((string.gsub(Text, "^%s*(.-)%s*$", "%1")));
                            applyLook();
                            task.delay(0.25, function() -- Line: 337
                                -- upvalues: u17 (ref), u30 (ref), u29 (ref)
                                if not u17.IsActive or u30 then
                                    return;
                                end;

                                u29:Set(false);
                            end);
                        end
                    };
                end,

                TextOnChanged = function(p41: userdata, p42: string) -- Line: 344, Name: TextOnChanged
                    -- upvalues: u18 (copy), findPlayer (ref), u19 (copy), applyLook (copy), u20 (copy), matchesFor (ref), u27 (copy), u28 (copy), u29 (copy)
                    u18:Set(findPlayer(p42) or "");
                    u19:Set((string.gsub(p42, "^%s*(.-)%s*$", "%1")));
                    applyLook();

                    if not p41:IsFocused() then
                        u20:Set("");

                        return;
                    end;

                    local v43 = matchesFor(p42);
                    local v44 = u27:Get();
                    local v45;

                    if #v43 == #v44 then
                        v45 = true;

                        for i = 1, #v43 do
                            if v43[i] ~= v44[i] then
                                v45 = false;
                                break;
                            end;

                            local _ = i;
                        end;
                    else
                        v45 = false;
                    end;

                    if not v45 then
                        u27:Set(v43);
                        u28:Set(UDim2.new(1, 0, 0, #v43 * 25));
                    end;

                    u29:Set(#v43 > 0);
                    local v46 = v43[1];
                    u20:Set(v46 == nil and "" or p42 .. string.sub(v46, #p42 + 1, #v46));
                end
            }),
            u17:Create("TextLabel")({
                Name = "AutoComplete",
                BackgroundTransparency = 1,
                ZIndex = -1,
                TextTransparency = 0.35,
                TextScaled = false,
                Size = UDim2.fromScale(1, 1),
                TextColor3 = Color3_new_ret5,
                Text = u20,
                Font = Enum.Font.SourceSansSemibold,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextYAlignment = Enum.TextYAlignment.Center,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        }),
        u17:State(function(p47, p48) -- Line: 380
            -- upvalues: u29 (copy), u28 (copy), u7 (ref), u27 (copy), Color3_new_ret3 (ref), u4 (ref), u6 (ref), u5 (ref), Font_new_ret (ref), ScreenEffects (ref), u31 (ref), u20 (copy), u18 (copy), findPlayer (ref), u19 (copy), applyLook (copy)
            if p47(u29) then
                return p48:Create("CanvasGroup")({
                    Name = "Options",
                    Position = UDim2.fromScale(0, 1.1),
                    Size = u28,
                    BackgroundTransparency = 1,
                    ZIndex = 4,
                    OnClean = {
                        GroupTransparency = p48:Animation(1, u7)
                    },
                    p48:Create("UICorner")({
                        CornerRadius = UDim.new(0, 12)
                    }),
                    p48:Create("Frame")({
                        Name = "Holder",
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        CleanDelay = u7.Time,
                        p48:Create("UIListLayout")({
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center
                        }),
                        p48:AdvancedIterate(u27, function(p49: number, u50: string, p51: any) -- Line: 409
                            -- upvalues: Color3_new_ret3 (ref), u4 (ref), u6 (ref), u7 (ref), u5 (ref), Font_new_ret (ref), ScreenEffects (ref), u31 (ref), u20 (ref), u29 (ref), u18 (ref), findPlayer (ref), u19 (ref), applyLook (ref)
                            local u52 = false;
                            local u53 = p51:Value(Color3.new(1, 1, 1));
                            local v54 = p51:Value(Color3.new());

                            local function updPlate() -- Line: 415
                                -- upvalues: u52 (ref), u53 (copy), Color3_new_ret3 (ref)
                                if u52 then
                                    u53:Set(Color3_new_ret3);

                                    return;
                                end;

                                u53:Reset();
                            end;

                            return p51:Create("TextButton")({
                                Name = u50,
                                AutoButtonColor = false,
                                LayoutOrder = p49,
                                Size = p51:Animation(UDim2.new(1, 0, 0, 25), u4, {
                                    From = UDim2.new(1, 0, 0, 8.75)
                                }),
                                BackgroundColor3 = p51:Animation(u53, u6),
                                ZIndex = 5,
                                ClipsDescendants = true,
                                CleanDelay = u7.Time,
                                p51:Create("TextLabel")({
                                    Name = "Txt",
                                    BackgroundTransparency = 1,
                                    ZIndex = 6,
                                    TextSize = 20,
                                    Text = u50,
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Position = UDim2.fromScale(0.5, 0.5),
                                    Size = UDim2.fromScale(1, 0.8),
                                    TextColor3 = p51:Animation(v54, u6),
                                    TextTransparency = p51:Animation(0, u5, {
                                        From = 1
                                    }),
                                    FontFace = Font_new_ret
                                }),

                                MouseEnter = function() -- Line: 446, Name: MouseEnter
                                    -- upvalues: u52 (ref), u53 (copy), Color3_new_ret3 (ref)
                                    u52 = true;

                                    if u52 then
                                        u53:Set(Color3_new_ret3);

                                        return;
                                    end;

                                    u53:Reset();
                                end,

                                MouseLeave = function() -- Line: 450, Name: MouseLeave
                                    -- upvalues: u52 (ref), u53 (copy), Color3_new_ret3 (ref)
                                    u52 = false;

                                    if u52 then
                                        u53:Set(Color3_new_ret3);

                                        return;
                                    end;

                                    u53:Reset();
                                end,

                                MouseButton1Click = function() -- Line: 454, Name: MouseButton1Click
                                    -- upvalues: ScreenEffects (ref), u50 (copy), u31 (ref), u20 (ref), u29 (ref), u18 (ref), findPlayer (ref), u19 (ref), applyLook (ref)
                                    ScreenEffects.CircleClick();
                                    local v55 = u50;

                                    if u31 ~= nil then
                                        u31.Text = v55;
                                    end;

                                    u20:Set("");
                                    u29:Set(false);
                                    u18:Set(findPlayer(v55) or "");
                                    u19:Set((string.gsub(v55, "^%s*(.-)%s*$", "%1")));
                                    applyLook();
                                end
                            });
                        end)
                    })
                });
            end;

            return nil;
        end)
    });
end;