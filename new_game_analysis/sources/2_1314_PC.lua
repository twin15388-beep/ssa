-- Decompiled with Potassium's decompiler.

local TextService = game:GetService("TextService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PermanentMarker = Enum.Font.PermanentMarker;
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Offset = gameSettings.KeybindTextSize.X.Offset;
local Vector2_new_ret = Vector2.new(2000, gameSettings.Width);
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local u1 = {
    One = 1,
    Two = 2,
    Three = 3,
    Four = 4,
    Five = 5,
    Six = 6
};

local function resolve(p2: string) -- Line: 26
    -- upvalues: InputHandler (copy)
    local Mapping = InputHandler.GetMapping(p2);

    if Mapping == nil then
        return p2;
    end;

    for _, v in Mapping do
        if typeof(v) ~= "table" then
            return InputHandler.PrettyInput(v.Name);
        end;
    end;

    return p2;
end;

return function(p3: userdata) -- Line: 39
    -- upvalues: resolve (copy), u1 (copy), TextService (copy), Offset (copy), PermanentMarker (copy), Vector2_new_ret (copy)
    local v4 = resolve(p3.Name);
    local v5 = u1[v4] or v4;
    local TextSize = TextService:GetTextSize(v5, Offset, PermanentMarker, Vector2_new_ret);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.TextScaled = true;
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    TextLabel.Size = UDim2.fromScale(TextSize.X / Offset * 1.325, 1.325);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.Parent = p3;
    TextLabel.TextTransparency = 0;
    TextLabel.Font = PermanentMarker;
    TextLabel.TextColor3 = Color3.new(1, 1, 1);
    TextLabel.Text = v5;
    TextLabel.BackgroundTransparency = 1;
    local UIStroke = Instance.new("UIStroke", TextLabel);
    UIStroke.Thickness = 1;
    UIStroke.Transparency = 0.15;

    return TextLabel;
end;