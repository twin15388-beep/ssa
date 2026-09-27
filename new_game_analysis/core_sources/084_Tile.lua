-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local Adders = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.Adders);
local u1 = faye.Info(0.2);
local Color3_fromRGB_ret = Color3.fromRGB(255, 95, 95);

return function(u2: any, p3: number, u4: string, u5: table) -- Line: 21
    -- upvalues: Items (copy), Rarities (copy), u1 (copy), Color3_fromRGB_ret (copy), Adders (copy), ScreenEffects (copy)
    local v6 = Items[u4];
    local v7 = v6 ~= nil and Rarities.Colors[v6.Rarity] or Color3.new(1, 1, 1);
    local string_gsub_ret = string.gsub(u4, "^%a+ ", "");
    local u8 = u5.Owned ~= nil and (u5.Owned[u4] or 0) or nil;
    local u9 = u8 == 0;
    local u10 = false;
    local u11 = u2:Value(false);

    local function state(p12) -- Line: 30
        -- upvalues: u5 (copy), u4 (copy), u11 (copy), u9 (copy)
        return p12(u5.Picked) == u4 and 2 or (p12(u11) and not u9 and 1 or 0);
    end;

    local v13 = u2:Create("Frame");
    local v15 = {
        Name = u4,
        LayoutOrder = p3,
        Size = UDim2.fromScale(1, 1),
        u2:Create("UIAspectRatioConstraint")({
            DominantAxis = Enum.DominantAxis.Height
        }),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        BackgroundTransparency = u2:Do(function(p14) -- Line: 44
            -- upvalues: u2 (copy), u5 (copy), u4 (copy), u11 (copy), u9 (copy), u1 (ref)
            return u2:Animation(({ 0.7, 0.5, 0.3 })[(p14(u5.Picked) == u4 and 2 or (p14(u11) and not u9 and 1 or 0)) + 1], u1);
        end)
    };
    local v16 = u2:Create("UICorner")({
        CornerRadius = UDim.new(0.15)
    });
    local v19 = u2:Create("UIStroke")({
        Color = Color3.new(1, 1, 1),
        BorderOffset = UDim.new(0, -4),
        Transparency = u2:Do(function(p17) -- Line: 53
            -- upvalues: u2 (copy), u5 (copy), u4 (copy), u11 (copy), u9 (copy), u1 (ref)
            return u2:Animation(({ 0.9, 0.6, 0.2 })[(p17(u5.Picked) == u4 and 2 or (p17(u11) and not u9 and 1 or 0)) + 1], u1);
        end),
        Thickness = u2:Do(function(p18) -- Line: 56
            -- upvalues: u2 (copy), u5 (copy), u4 (copy), u11 (copy), u9 (copy), u1 (ref)
            return u2:Animation(({ 1, 1.5, 2 })[(p18(u5.Picked) == u4 and 2 or (p18(u11) and not u9 and 1 or 0)) + 1], u1);
        end)
    });
    local v20 = u2:Create("Frame")({
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.fromScale(1, 0.5),
        BackgroundColor3 = v7,
        ZIndex = 0,
        u2:Create("UICorner")({
            CornerRadius = UDim.new(0.15)
        }),
        u2:Create("UIGradient")({
            Rotation = -90,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 1) })
        })
    });
    local v21 = u2:Create("ImageLabel")({
        Name = "Icon",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.06),
        Size = UDim2.fromScale(0.5, 0.5),
        ImageTransparency = u9 and 0.6 or 0,
        Image = v6 == nil and "" or (v6.Icon or "")
    });
    local v22 = u2:Create("TextLabel")({
        Name = "ItemName",
        BackgroundTransparency = 1,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0.58),
        Size = UDim2.fromScale(0.92, 0.16),
        Font = Enum.Font.SourceSansSemibold,
        Text = string_gsub_ret,
        TextColor3 = Color3.new(1, 1, 1),
        TextTransparency = u9 and 0.5 or 0
    });
    local v23;

    if u8 == nil then
        v23 = nil;
    else
        local v24 = u2:Create("TextLabel");
        local v25 = {
            Name = "Count",
            BackgroundTransparency = 1,
            TextScaled = true,
            TextStrokeTransparency = 0.8,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.76),
            Size = UDim2.fromScale(0.9, 0.2),
            Font = Enum.Font.SourceSansBold,
            Text = `x{u8}`
        };
        local v26;

        if u9 then
            v26 = Color3_fromRGB_ret;
        else
            v26 = Color3.new(1, 1, 1);
        end;

        v25.TextColor3 = v26;
        v23 = v24(v25) or nil;
    end;

    v15[2], v15[3], v15[4], v15[5], v15[6], v15[7], v15[8], v15[9] = v16, v19, v20, v21, v22, v23, u2:State(function(p27, p28) -- Line: 111
    -- upvalues: u5 (copy), u4 (copy), u8 (copy), u1 (ref), Adders (ref)
    local Editor = u5.Editor;

    if Editor ~= nil and (p27(u5.Picked) == u4 and (u8 or 0) >= 2) then
        local Step = Editor.Step;

        return p28:Create("Frame")({
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.3),
            Size = UDim2.fromScale(0.9, 0.25),
            BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
            BackgroundTransparency = p28:Animation(0.2, u1, {
                From = 1
            }),
            p28:Create("UIGradient")({
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.25, 0),
                    NumberSequenceKeypoint.new(0.75, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
            }),
            p28:Create("TextLabel")({
                ZIndex = 5,
                BackgroundTransparency = 1,
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.45, 0.95),
                Font = Enum.Font.SourceSansBold,
                Text = p28:Do(function(p29) -- Line: 137
                    -- upvalues: Editor (copy)
                    return tostring(p29(Editor.Amount));
                end),
                TextColor3 = Color3.new(1, 1, 1)
            }),
            Adders(p28, {}, -90, function() -- Line: 143
                -- upvalues: Step (copy)
                Step(1);
            end),
            Adders(p28, {
                Position = UDim2.fromScale(1, 0.5),
                AnchorPoint = Vector2.new(1, 0.5)
            }, 90, function() -- Line: 146
                -- upvalues: Step (copy)
                Step(-1);
            end)
        });
    end;
end), u2:Create("TextButton")({
    Name = "Hover",
    ZIndex = 3,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),

    MouseButton1Click = function() -- Line: 156, Name: MouseButton1Click
        -- upvalues: u9 (copy), ScreenEffects (ref), u5 (copy), u4 (copy)
        if u9 then
            return;
        end;

        ScreenEffects.CircleClick();
        u5.Pick(u4);
    end,

    MouseEnter = function() -- Line: 161, Name: MouseEnter
        -- upvalues: u10 (ref), u11 (copy)
        if u10 then
            return;
        end;

        u10 = true;
        u11:Set(true);
    end,

    MouseLeave = function() -- Line: 166, Name: MouseLeave
        -- upvalues: u10 (ref), u11 (copy)
        if not u10 then
            return;
        end;

        u10 = false;
        u11:Reset();
    end
});

    return v13(v15);
end;