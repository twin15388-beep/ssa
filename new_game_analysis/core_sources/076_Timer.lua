-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local u1 = faye.Info(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = faye.Info(0.2);
local Color3_new_ret = Color3.new(1, 1, 1);

local function display(p3: number) -- Line: 26
    -- upvalues: Utility (copy)
    return string.gsub(Utility.formatTime(p3), "s", "");
end;

return function(u4: any, u5: function, p6: number?) -- Line: 34
    -- upvalues: Utility (copy), Color3_new_ret (copy), gameSettings (copy), u1 (copy), u2 (copy)
    local string_split = string.split;
    local v7 = p6 or u5();
    local u8 = {};
    local v9 = 0;

    for i, v in string_split(string.gsub(Utility.formatTime(v7), "s", ""), ":") do
        if i > 1 then
            table.insert(u8, {
                Type = "Separator"
            });
        end;

        for i2 = 1, #v do
            v9 = v9 + 1;
            table.insert(u8, {
                Type = "Digit",
                Digit = v9
            });
            local _ = i2;
        end;
    end;

    local v10 = u5();
    local string_gsub_ret = string.gsub(Utility.formatTime(v10), "s", "");
    local u11 = #u8 - #string_gsub_ret;
    local u12 = Color3_new_ret;
    local u13 = {};
    local u14 = {};
    local u15 = {};
    local u16 = {};

    local function rawOf(p17) -- Line: 59
        if p17 == nil then
            return nil;
        end;

        return typeof(p17) == "Instance" and p17 and p17 or p17.Instance;
    end;

    local function makeDigitLabel(p18: userdata, p19: string) -- Line: 63
        -- upvalues: gameSettings (ref), u12 (copy)
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = "Value";
        TextLabel.Size = UDim2.fromScale(1, 1);
        TextLabel.Position = UDim2.fromScale(0, -1);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.TextScaled = true;
        TextLabel.FontFace = gameSettings.preferedFont;
        TextLabel.TextColor3 = u12;
        TextLabel.Text = p19;
        TextLabel.Parent = p18;

        return TextLabel;
    end;

    local function setDigit(p20: number, p21: string) -- Line: 76
        -- upvalues: u13 (copy), u15 (copy), u16 (copy), makeDigitLabel (copy), u4 (copy), u1 (ref)
        local v22 = u13[p20];
        local v23;

        if v22 == nil then
            v23 = nil;
        else
            v23 = typeof(v22) == "Instance" and v22 and v22 or v22.Instance;
        end;

        if v23 == nil then
            return;
        end;

        if u15[p20] == p21 then
            return;
        end;

        u15[p20] = p21;
        local v24 = u16[p20];
        local v25;

        if v24 == nil then
            v25 = nil;
        else
            v25 = typeof(v24) == "Instance" and v24 and v24 or v24.Instance;
        end;

        local v26 = makeDigitLabel(v23, p21);
        u16[p20] = v26;

        if v25 == nil then
            v26.Position = UDim2.fromScale(0, 0);

            return;
        end;

        u4:LoadAnimation(v25, {
            Position = UDim2.fromScale(0, 1)
        }, u1):Play();
        task.delay(u1.Time + 0.05, v25.Destroy, v25);
        u4:LoadAnimation(v26, {
            Position = UDim2.fromScale(0, 0)
        }, u1):Play();
    end;

    local function render() -- Line: 96
        -- upvalues: u5 (copy), Utility (ref), u8 (copy), u14 (copy), u15 (copy), setDigit (copy)
        local v27 = u5();
        local string_gsub_ret2 = string.gsub(Utility.formatTime(v27), "s", "");
        local v28 = #u8 - #string_gsub_ret2;

        for i, v in u8 do
            local v29 = u14[i];
            local v30;

            if v29 == nil then
                v30 = nil;
            else
                v30 = typeof(v29) == "Instance" and v29 and v29 or v29.Instance;
            end;

            if v30 ~= nil then
                local v31 = i - v28;

                if v31 < 1 then
                    v30.Visible = false;

                    if v.Type == "Digit" then
                        u15[v.Digit] = nil;
                    end;
                else
                    v30.Visible = true;

                    if v.Type == "Digit" then
                        setDigit(v.Digit, (string.sub(string_gsub_ret2, v31, v31)));
                    end;
                end;
            end;
        end;
    end;

    local v40 = u4:Create("Frame")({
        Name = "Timer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        u4:Create("UIListLayout")({
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 1)
        }),
        u4:Iterate(u8, function(p32, p33, p34) -- Line: 130
            -- upvalues: u11 (copy), u2 (ref), gameSettings (ref), Color3_new_ret (ref), u14 (copy), string_gsub_ret (copy), u15 (copy), u16 (copy), u13 (copy)
            if p33.Type == "Separator" then
                local v35 = p34:Create("Frame")({
                    Name = `Separator{p32}`,
                    LayoutOrder = p32,
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Visible = p32 - u11 >= 1,
                    p34:Create("UIAspectRatioConstraint")({
                        AspectRatio = 0.15
                    }),
                    p34:Create("TextLabel")({
                        Name = "Colon",
                        BackgroundTransparency = 1,
                        Text = ":",
                        TextScaled = true,
                        Size = UDim2.fromScale(1, 1),
                        TextTransparency = p34:Animation(0, u2, {
                            From = 1
                        }),
                        FontFace = gameSettings.preferedFont,
                        TextColor3 = Color3_new_ret
                    })
                });
                u14[p32] = v35;

                return v35;
            end;

            local v36 = p32 - u11;
            local v37;

            if v36 >= 1 then
                v37 = string.sub(string_gsub_ret, v36, v36);
            else
                v37 = nil;
            end;

            local v38;

            if v37 == nil or v37 == "" then
                v38 = nil;
            else
                v38 = p34:Create("TextLabel")({
                    Name = "Value",
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Size = UDim2.fromScale(1, 1),
                    TextTransparency = p34:Animation(0, u2, {
                        From = 1
                    }),
                    FontFace = gameSettings.preferedFont,
                    TextColor3 = Color3_new_ret,
                    Text = v37
                });
            end;

            if v38 ~= nil then
                u15[p33.Digit] = v37;
                u16[p33.Digit] = v38;
            end;

            local v39 = p34:Create("Frame")({
                Name = `Digit{p33.Digit}`,
                LayoutOrder = p32,
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Visible = v36 >= 1,
                ClipsDescendants = true,
                p34:Create("UIAspectRatioConstraint")({
                    AspectRatio = 0.55
                }),
                v38
            });
            u13[p33.Digit] = v39;
            u14[p32] = v39;

            return v39;
        end)
    });
    render();
    u4:Spawn(function() -- Line: 196
        -- upvalues: render (copy)
        while true do
            task.wait(0.5);
            render();
        end;
    end);

    return v40;
end;