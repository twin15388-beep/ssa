-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local SourceSansBold = Enum.Font.SourceSansBold;
local UDim_new_ret = UDim.new(0.75);

local function isPadButton(p1) -- Line: 32
    if typeof(p1) ~= "EnumItem" or p1.EnumType ~= Enum.KeyCode then
        return false;
    end;

    local Name = p1.Name;

    return (Name:match("^Button") ~= nil or Name:match("^DPad") ~= nil) and true or Name:match("^Thumbstick") ~= nil;
end;

local function resolve(p2: string) -- Line: 42
    -- upvalues: InputHandler (copy), isPadButton (copy)
    local Mapping = InputHandler.GetMapping(p2);

    if Mapping == nil then
        return nil, nil;
    end;

    local v3 = nil;
    local v4 = nil;

    for _, v in Mapping do
        if typeof(v) == "table" then
            if v.Alone == true and isPadButton(v.Input) then
                return v.Input, nil;
            end;

            if v3 == nil and (isPadButton(v.Input) and isPadButton(v.Modifier)) then
                v3 = v.Input;
                v4 = v.Modifier;
            end;
        elseif isPadButton(v) then
            return v, nil;
        end;
    end;

    return v3, v4;
end;

local function glyph(p5: string, p6: userdata) -- Line: 64
    -- upvalues: UDim_new_ret (copy)
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
    ImageLabel.Size = UDim2.fromScale(1, 1);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = p5;
    Instance.new("UIAspectRatioConstraint").Parent = ImageLabel;
    local UIShadow = Instance.new("UIShadow");
    UIShadow.BlurRadius = UDim_new_ret;
    UIShadow.Transparency = 0.65;
    UIShadow.Parent = ImageLabel;
    ImageLabel.Parent = p6;

    return ImageLabel;
end;

return function(p7: userdata) -- Line: 81
    -- upvalues: resolve (copy), UserInputService (copy), glyph (copy), SourceSansBold (copy)
    local v8, v9 = resolve(p7.Name);

    if v8 == nil then
        return nil;
    end;

    local ImageForKeyCode = UserInputService:GetImageForKeyCode(v8);

    if ImageForKeyCode == nil or #ImageForKeyCode == 0 then
        return nil;
    end;

    if v9 == nil then
        return glyph(ImageForKeyCode, p7);
    end;

    local ImageForKeyCode2 = UserInputService:GetImageForKeyCode(v9);

    if ImageForKeyCode2 == nil or #ImageForKeyCode2 == 0 then
        return nil;
    end;

    local Frame = Instance.new("Frame");
    Frame.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame.Position = UDim2.fromScale(0.5, 0.5);
    Frame.Size = UDim2.new(2.45, 4, 1, 0);
    Frame.BackgroundTransparency = 1;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.Parent = Frame;

    for i, v in { ImageForKeyCode2, ImageForKeyCode } do
        local Frame2 = Instance.new("Frame");
        Frame2.LayoutOrder = i * 2;
        Frame2.Size = UDim2.fromScale(1, 1);
        Frame2.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        Frame2.BackgroundTransparency = 1;
        glyph(v, Frame2);
        Frame2.Parent = Frame;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.LayoutOrder = 3;
    TextLabel.Size = UDim2.fromScale(0.45, 1);
    TextLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Text = "+";
    TextLabel.TextScaled = true;
    TextLabel.Font = SourceSansBold;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.Parent = Frame;
    Frame.Parent = p7;

    return Frame;
end;