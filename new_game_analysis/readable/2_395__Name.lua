-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local interfaceutility = require(ReplicatedStorage.Packages.interfaceutility);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local u1 = {
    Mobile = BunchaIcons.Devices.Mobile,
    Xbox = BunchaIcons.Devices.Console,
    Playstation = BunchaIcons.Devices.Console
};

return function(p2: userdata, u3: userdata, p4: userdata, p5: userdata) -- Line: 13
    -- upvalues: faye (copy), interfaceutility (copy), Players (copy), BunchaIcons (copy), u1 (copy)
    local u6 = faye.new();
    local v7;

    if p4 == nil then
        v7 = false;
    else
        v7 = p4.DisplayName;
    end;

    local u8 = (v7 == nil or v7 == "") and (u3 == nil and "Invalid Name" or (u3.Name or "Invalid Name")) or v7;

    local function clanName() -- Line: 24
        -- upvalues: u3 (copy)
        local Attribute = u3:GetAttribute("Clan");

        if typeof(Attribute) == "string" and Attribute ~= "" then
            return Attribute;
        end;

        return nil;
    end;

    local function withClan() -- Line: 29
        -- upvalues: u3 (copy), u8 (ref)
        local Attribute = u3:GetAttribute("Clan");

        if typeof(Attribute) ~= "string" or Attribute == "" then
            Attribute = nil;
        end;

        if Attribute == nil then
            return u8;
        end;

        return `{u8} {Attribute}`;
    end;

    local Attribute = u3:GetAttribute("Font");

    local function badge(p9: string, p10: function) -- Line: 36
        -- upvalues: u6 (copy)
        return u6:Create("ImageLabel")({
            Name = p9,
            Size = UDim2.fromScale(0, 1),
            BackgroundTransparency = 1,
            Visible = false,
            u6:Create("UIAspectRatioConstraint")({
                AspectRatio = 1,
                AspectType = Enum.AspectType.ScaleWithParentSize,
                DominantAxis = Enum.DominantAxis.Height
            }),
            After = p10
        });
    end;

    local v11 = u6:Create("Frame");
    local v12 = {
        Size = UDim2.fromScale(1, 0.35),
        Parent = p2,
        Name = "NameHolder",
        BackgroundTransparency = 1
    };
    local v13 = u6:Create("UIListLayout")({
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.Name,
        Padding = UDim.new(0.02, 0)
    });
    local v14 = u6:Create("TextLabel");
    local v15 = {
        Name = "AAName",
        Size = UDim2.fromScale(3, 1),
        BackgroundTransparency = 1
    };
    local Attribute2 = u3:GetAttribute("Clan");

    if typeof(Attribute2) ~= "string" or Attribute2 == "" then
        Attribute2 = nil;
    end;

    local v16;

    if Attribute2 == nil then
        v16 = u8;
    else
        v16 = `{u8} {Attribute2}`;
    end;

    v15.Text = v16;
    v15.TextColor3 = Color3.new(1, 1, 1);
    v15.TextScaled = true;
    v15.FontFace = Attribute or Font.fromEnum(Enum.Font.SourceSansSemibold);
    v15[1] = u6:Create("UIStroke")({
    Thickness = 1.5,
    Transparency = 0.75
});

    function v15.After(u17: userdata) -- Line: 78
        -- upvalues: u3 (copy), u8 (ref), Attribute (copy), interfaceutility (ref), u6 (copy)
        local function fit() -- Line: 81
            -- upvalues: u17 (copy), u3 (ref), u8 (ref), Attribute (ref), interfaceutility (ref)
            local Attribute3 = u3:GetAttribute("Clan");

            if typeof(Attribute3) ~= "string" or Attribute3 == "" then
                Attribute3 = nil;
            end;

            local v18;

            if Attribute3 == nil then
                v18 = u8;
            else
                v18 = `{u8} {Attribute3}`;
            end;

            u17.Text = v18;

            if Attribute == nil then
                local ScaledTextSize = interfaceutility.GetScaledTextSize(u17);
                u17.Size = UDim2.fromScale(ScaledTextSize, 1);
            end;
        end;

        local Attribute3 = u3:GetAttribute("Clan");

        if typeof(Attribute3) ~= "string" or Attribute3 == "" then
            Attribute3 = nil;
        end;

        local v19;

        if Attribute3 == nil then
            v19 = u8;
        else
            v19 = `{u8} {Attribute3}`;
        end;

        u17.Text = v19;

        if Attribute == nil then
            local ScaledTextSize = interfaceutility.GetScaledTextSize(u17);
            u17.Size = UDim2.fromScale(ScaledTextSize, 1);
        end;

        u6:Connect(u3:GetAttributeChangedSignal("Clan"), fit);
    end;

    v12[1], v12[2], v12[3], v12[4] = v13, v14(v15), badge("AVerified", function(p20: userdata) -- Line: 96
    -- upvalues: Players (ref), u3 (copy), BunchaIcons (ref)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(u3);

    if PlayerFromCharacter == nil or PlayerFromCharacter.HasVerifiedBadge ~= true then
        return;
    end;

    p20.Image = BunchaIcons.Verified;
    p20.Visible = true;
end), badge("Device", function(u21: userdata) -- Line: 102
    -- upvalues: Players (ref), u3 (copy), u1 (ref), u6 (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(u3);

    if PlayerFromCharacter == nil then
        return;
    end;

    local function refresh() -- Line: 105
        -- upvalues: u1 (ref), PlayerFromCharacter (copy), u21 (copy)
        local v22 = u1[PlayerFromCharacter:GetAttribute("Device")];
        u21.Image = v22 or "";
        u21.Visible = v22 ~= nil;
    end;

    local v23 = u1[PlayerFromCharacter:GetAttribute("Device")];
    u21.Image = v23 or "";
    u21.Visible = v23 ~= nil;
    u6:Connect(PlayerFromCharacter:GetAttributeChangedSignal("Device"), refresh);
end);
    Imgl = v11(v12);

    return function() -- Line: 114
        -- upvalues: u6 (copy)
        u6:Destroy();
    end;
end;