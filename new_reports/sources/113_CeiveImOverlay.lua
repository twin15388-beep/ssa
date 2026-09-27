-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local Font_new_ret = Font.new("rbxasset://fonts/families/PressStart2P.json");
local u1 = {};
u1.__index = u1;

function u1.new(p2: number?, p3: number?, p4: boolean?) -- Line: 22
    -- upvalues: GuiService (copy), u1 (copy)
    local v5 = p4 == nil and true or p4;
    local UDim2_fromOffset_ret = UDim2.fromOffset(25, 5 + GuiService:GetGuiInset().Y);
    local UDim2_new_ret = UDim2.new(1, -25, 1, -5);
    local UDim2_fromOffset_ret2 = UDim2.fromOffset(0, 0);
    local UDim2_fromScale_ret = UDim2.fromScale(1, 1);
    local v6 = setmetatable({}, u1);
    v6.DefaultY = p2 or 5;
    v6.TextSize = p3 or 11;
    v6.BackFrame = Instance.new("Frame");

    if v5 then
        UDim2_fromOffset_ret2 = UDim2_fromOffset_ret or UDim2_fromOffset_ret2;
    end;

    v6.BackFrame.Position = UDim2_fromOffset_ret2;

    if v5 then
        UDim2_fromScale_ret = UDim2_new_ret or UDim2_fromScale_ret;
    end;

    v6.BackFrame.Size = UDim2_fromScale_ret;
    v6.BackFrame.Name = "BackFrame";
    v6.BackFrame.Transparency = 1;
    v6.ListLayout = Instance.new("UIListLayout");
    v6.ListLayout.Padding = UDim.new(0, 2);
    v6.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    v6.ListLayout.Parent = v6.BackFrame;
    v6.m_Indent = 0;
    v6.DidUpdate = false;
    v6.m_State = "";
    v6.m_PreviousState = "";
    v6.m_RenderGroup = {};
    v6.m_ItemPool = {};

    return v6;
end;

function u1.Begin(p7: table, p8: string, p9, p10) -- Line: 64
    if not p8 or type(p8) ~= "string" then
        warn("Expected text to ImOverlay::Begin", debug.traceback());

        return;
    end;

    if p9 and typeof(p9) ~= "Color3" then
        warn("BackgroundColor should be a Color3", debug.traceback());

        return;
    end;

    if p10 and typeof(p10) ~= "Color3" then
        warn("TextColor should be a Color3", debug.traceback());

        return;
    end;

    p7:Text(p8, p9, p10);
    p7.m_Indent = p7.m_Indent + 1;
end;

function u1.End(p11) -- Line: 84
    if p11.m_Indent - 1 < 0 then
        error("Too many callbacks to ImOverlay::End");

        return;
    end;

    p11.m_Indent = p11.m_Indent - 1;
end;

function u1.Text(p12: table, p13: string, p14, p15) -- Line: 93
    if not p13 or type(p13) ~= "string" then
        warn("Expected text to ImOverlay::Text", debug.traceback());

        return;
    end;

    if p14 and typeof(p14) ~= "Color3" then
        warn("BackgroundColor should be a Color3", debug.traceback());

        return;
    end;

    if p15 and typeof(p15) ~= "Color3" then
        warn("TextColor should be a Color3", debug.traceback());

        return;
    end;

    local v16 = p14 or Color3.new();
    local v17 = p15 or Color3.new(1, 1, 1);
    table.insert(p12.m_RenderGroup, {
        Text = p13,
        TextColor = v17,
        BackgroundColor = v16,
        Indent = p12.m_Indent
    });
    p12.m_State = p12.m_State .. `{p13}|{v17}|{v16}|{p12.m_Indent}`;
end;

function u1.m_Pool(p18) -- Line: 122
    for _, child in p18.BackFrame:GetChildren() do
        if not child:IsA("UIListLayout") and child.Visible then
            child.Visible = false;
            table.insert(p18.m_ItemPool, child);
        end;
    end;
end;

function u1.m_Cleanup(p19) -- Line: 137
    p19.m_State = "";
    p19.m_Indent = 0;
    p19.m_RenderGroup = {};
end;

function u1.m_CreateLabel(p20: table, p21: string, p22, p23, p24: number) -- Line: 145
    -- upvalues: Font_new_ret (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Background";
    Frame.AutomaticSize = Enum.AutomaticSize.XY;
    Frame.BackgroundColor3 = p23;
    Frame.BackgroundTransparency = 0.4;
    Frame.BorderSizePixel = 0;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "TaskText";
    TextLabel.FontFace = Font_new_ret;
    TextLabel.Text = p21;
    TextLabel.TextColor3 = p22;
    TextLabel.TextSize = p20.TextSize;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = UDim2.fromOffset(p24 * 50, 0);
    TextLabel.Size = UDim2.fromOffset(0, p20.DefaultY);
    TextLabel.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "UIPadding";
    UIPadding.PaddingBottom = UDim.new(0, 2);
    UIPadding.Parent = TextLabel;
    local UIPadding2 = Instance.new("UIPadding");
    UIPadding2.Name = "UIPadding";
    UIPadding2.PaddingRight = UDim.new(0, 5);
    UIPadding2.PaddingLeft = UDim.new(0, 5);
    UIPadding2.Parent = Frame;

    return Frame;
end;

function u1.Render(p25) -- Line: 182
    if p25.m_State == "" then
        p25:m_Pool();
        p25:m_Cleanup();
        p25.DidUpdate = false;

        return;
    end;

    p25.m_State = p25.m_State .. `{p25.DefaultY}|{p25.TextSize}`;

    if p25.m_State == p25.m_PreviousState then
        p25:m_Cleanup();
        p25.DidUpdate = false;

        return;
    end;

    p25:m_Pool();
    p25.m_PreviousState = p25.m_State;
    p25.DidUpdate = true;

    for i, v in p25.m_RenderGroup do
        if #p25.m_ItemPool == 0 then
            local v26 = p25:m_CreateLabel(v.Text, v.TextColor, v.BackgroundColor, v.Indent);
            v26.LayoutOrder = i;
            v26.Parent = p25.BackFrame;
        else
            local table_remove_ret = table.remove(p25.m_ItemPool, #p25.m_ItemPool);
            local TaskText = table_remove_ret.TaskText;
            table_remove_ret.LayoutOrder = i;
            table_remove_ret.BackgroundColor3 = v.BackgroundColor;
            TaskText.Text = v.Text;
            TaskText.TextColor3 = v.TextColor;
            TaskText.Position = UDim2.fromOffset(50 * v.Indent, 0);
            table_remove_ret.Visible = true;
            table_remove_ret.Parent = p25.BackFrame;
        end;
    end;

    p25:m_Cleanup();
end;

function u1.Destroy(p27) -- Line: 239
    p27.BackFrame:Destroy();
    setmetatable(p27, nil);
end;

return u1;