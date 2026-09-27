-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local faye = require(ReplicatedStorage.Packages.faye);

return function(p1: userdata, p2: userdata, p3: userdata, p4: userdata) -- Line: 22
    -- upvalues: Players (copy), faye (copy), BunchaIcons (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p2);

    if PlayerFromCharacter ~= nil then
        local u5 = faye.new();
        local u6 = u5:Value("");

        local function refresh() -- Line: 29
            -- upvalues: PlayerFromCharacter (copy), u6 (copy), BunchaIcons (ref)
            local Attribute = PlayerFromCharacter:GetAttribute("FactionBanner");

            if type(Attribute) ~= "string" then
                u6:Set("");

                return;
            end;

            if Attribute == "" then
                Attribute = BunchaIcons.NoFactionIcon;
            end;

            u6:Set(Attribute);
        end;

        local Attribute = PlayerFromCharacter:GetAttribute("FactionBanner");

        if type(Attribute) == "string" then
            if Attribute == "" then
                Attribute = BunchaIcons.NoFactionIcon;
            end;

            u6:Set(Attribute);
        else
            u6:Set("");
        end;

        u5:Connect(PlayerFromCharacter:GetAttributeChangedSignal("FactionBanner"), refresh);
        u5:Create("Frame")({
            Name = "IFaction",
            Parent = p1,
            Size = UDim2.fromScale(1, 0.6),
            BackgroundTransparency = 1,
            Visible = u5:Do(function(p7) -- Line: 61
                -- upvalues: u6 (copy)
                return p7(u6) ~= "";
            end),
            u5:Create("ImageLabel")({
                Name = "Banner",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                ImageTransparency = 0.1,
                ScaleType = Enum.ScaleType.Fit,
                Image = u6,
                u5:Create("UIAspectRatioConstraint")({
                    AspectRatio = 1,
                    AspectType = Enum.AspectType.ScaleWithParentSize,
                    DominantAxis = Enum.DominantAxis.Height
                })
            })
        });

        return function() -- Line: 80
            -- upvalues: u5 (copy)
            u5:Destroy();
        end;
    end;
end;