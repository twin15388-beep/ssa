-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Adders = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.Adders);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local u1 = faye.Info(0.45);
local UDim2_fromScale_ret = UDim2.fromScale(0.075, 0.06);

local function size() -- Line: 12
    -- upvalues: Platform_Handler (copy), UDim2_fromScale_ret (copy)
    if Platform_Handler.Platform.Value == "Mobile" then
        return UDim2.fromScale(UDim2_fromScale_ret.X.Scale * 2.5, UDim2_fromScale_ret.Y.Scale * 2.5);
    end;

    return UDim2_fromScale_ret;
end;

return function(p2: any, p3: userdata, p4: userdata, u5: any) -- Line: 17
    -- upvalues: Platform_Handler (copy), UDim2_fromScale_ret (copy), u1 (copy), Adders (copy)
    local u6 = nil;
    u5.Amount = 1;

    local function adjust(p7) -- Line: 22
        -- upvalues: u6 (ref), u5 (copy)
        local v8 = tonumber(u6.Instance.Text) or 0;
        local v9 = math.floor(v8) + p7;
        local math_clamp_ret = math.clamp(v9, 1, 99);
        u6.Instance.Text = math_clamp_ret;
        u5.Amount = math_clamp_ret;
    end;

    u6 = p2:Create("TextBox")({
        BackgroundTransparency = 1,
        TextScaled = true,
        Text = 1,
        Size = UDim2.new(1, -2, 1, -2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Font = Enum.Font.SourceSansBold,

        FocusLost = function(p10, p11) -- Line: 35, Name: FocusLost
            -- upvalues: u5 (copy)
            local v12 = tonumber(p10.Text) or 0;
            local math_floor_ret = math.floor(v12);
            local math_clamp_ret = math.clamp(math_floor_ret, 1, 99);
            p10.Text = math_clamp_ret;
            u5.Amount = math_clamp_ret;
        end
    });
    local v13 = p2:Create("CanvasGroup");
    local v14 = {
        Parent = p3
    };
    local v15;

    if Platform_Handler.Platform.Value == "Mobile" then
        v15 = UDim2.fromScale(UDim2_fromScale_ret.X.Scale * 2.5, UDim2_fromScale_ret.Y.Scale * 2.5);
    else
        v15 = UDim2_fromScale_ret;
    end;

    v14.Size = v15;
    v14.AnchorPoint = Vector2.new(0.5, 1);
    v14.Position = UDim2.fromScale(0.5, 1);
    v14.BackgroundTransparency = 1;
    v14.GroupTransparency = p2:Animation(0, u1, {
        From = 1
    });

    function v14.OnClean(p16) -- Line: 49
        -- upvalues: u1 (ref)
        return {
            GroupTransparency = p16:Animation(1, u1)
        };
    end;

    v14[1], v14[2], v14[3], v14[4] = p2:Create("TextLabel")({
    BackgroundTransparency = 1,
    Text = "Custom Amount",
    TextScaled = true,
    TextStrokeTransparency = 0.75,
    Size = UDim2.fromScale(1, 0.4),
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Color3.new(1, 1, 1)
}), Adders(p2, {
    Position = UDim2.fromScale(0, 0.72),
    AnchorPoint = Vector2.new(0, 0.5),
    Size = UDim2.fromScale(0.2, 0.55)
}, 90, function() -- Line: 64
    -- upvalues: u6 (ref), u5 (copy)
    local v17 = tonumber(u6.Instance.Text) or 0;
    local v18 = math.floor(v17) + -1;
    local math_clamp_ret = math.clamp(v18, 1, 99);
    u6.Instance.Text = math_clamp_ret;
    u5.Amount = math_clamp_ret;
end), Adders(p2, {
    Position = UDim2.fromScale(1, 0.72),
    AnchorPoint = Vector2.new(1, 0.5),
    Size = UDim2.fromScale(0.2, 0.55)
}, -90, function() -- Line: 67
    -- upvalues: u6 (ref), u5 (copy)
    local v19 = tonumber(u6.Instance.Text) or 0;
    local v20 = math.floor(v19) + 1;
    local math_clamp_ret = math.clamp(v20, 1, 99);
    u6.Instance.Text = math_clamp_ret;
    u5.Amount = math_clamp_ret;
end), p2:Create("Frame")({
    Name = "CustomAdderHolder",
    Size = UDim2.fromScale(0.6, 0.55),
    Position = UDim2.fromScale(0.5, 0.45),
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundTransparency = 0,
    p2:Create("UICorner")({
        CornerRadius = UDim.new(1)
    }),
    u6
});

    return v13(v14);
end;