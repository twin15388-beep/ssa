-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Titles = require(ReplicatedStorage.CAM.Global.Titles);
local TitleParticles = require(ReplicatedStorage.CAM.Client.Modules.TitleParticles);
local faye = require(ReplicatedStorage.Packages.faye);

return function(p1: userdata, u2: userdata, p3: userdata, u4: userdata) -- Line: 17
    -- upvalues: faye (copy), Titles (copy), TitleParticles (copy)
    local u5 = faye.new();
    local u6 = u5:Value("");
    local u7 = u5:Value(ColorSequence.new(Color3.new(1, 1, 1)));
    local u8 = p1:FindFirstAncestorOfClass("BillboardGui");
    local u9 = nil;

    local function labelOf() -- Line: 27
        -- upvalues: u9 (ref)
        return u9;
    end;

    local function refresh() -- Line: 30
        -- upvalues: u2 (copy), Titles (ref), u6 (copy), u7 (copy), TitleParticles (ref), u8 (copy), u4 (copy), labelOf (copy)
        local Attribute = u2:GetAttribute("VanityTitle");
        local v10;

        if type(Attribute) == "string" then
            v10 = Titles.Get(Attribute);
        else
            v10 = nil;
        end;

        u6:Set(v10 == nil and "" or v10.displayName);

        if v10 ~= nil then
            u7:Set(Titles.GetColor(Attribute));
        end;

        local v11;

        if v10 == nil then
            v11 = nil;
        else
            v11 = TitleParticles.TemplateFor(v10.displayName);
        end;

        if v11 == nil or (u8 == nil or u4 == nil) then
            TitleParticles.Remove(u2);

            return;
        end;

        TitleParticles.Add(u2, u4, u8, labelOf, v11);
    end;

    refresh();
    u5:Connect(u2:GetAttributeChangedSignal("VanityTitle"), refresh);
    u5:Create("TextLabel")({
        Name = "AVanityTitle",
        Parent = p1,

        function(p12: userdata) -- Line: 54
            -- upvalues: u9 (ref)
            u9 = p12;
        end,

        Size = UDim2.fromScale(1, 0.28),
        BackgroundTransparency = 1,
        Visible = u5:Do(function(p13) -- Line: 60
            -- upvalues: u6 (copy)
            return p13(u6) ~= "";
        end),
        Font = Enum.Font.SourceSansBold,
        Text = u6,
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        u5:Create("UIStroke")({
            Thickness = 1.5,
            Transparency = 0.75
        }),
        u5:Create("UIGradient")({
            Rotation = -90,
            Color = u7
        })
    });

    return function() -- Line: 78
        -- upvalues: TitleParticles (ref), u2 (copy), u5 (copy)
        TitleParticles.Remove(u2);
        u5:Destroy();
    end;
end;