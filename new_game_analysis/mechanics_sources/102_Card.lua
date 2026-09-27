-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextService = game:GetService("TextService");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local faye = require(ReplicatedStorage.Packages.faye);
local interfaceutility = require(ReplicatedStorage.Packages.interfaceutility);
local config = require(ReplicatedStorage.SmartBone.Dependencies.Iris.config);
local u1 = faye.SpringInfo(0.3, 1, 0.45);
local Config = require(script.Parent.Config);
local HoldPress = require(script.Parent.HoldPress);
local Random_new_ret = Random.new();
local Vector2_new_ret = Vector2.new(12, 12);

local function trim(p2: string) -- Line: 18
    return p2:match("^%s*(.-)%s*$") or "";
end;

local function splitTopLevel(p3: string, p4: string) -- Line: 22
    local v5 = 0;
    local v6 = {};
    local v7 = 1;

    for i = 1, #p3 do
        local v8 = p3:sub(i, i);
        local v9;

        if v8 == "{" or v8 == "(" then
            v5 = v5 + 1;
            v9 = i;
        elseif v8 == "}" or v8 == ")" then
            v5 = v5 - 1;
            v9 = i;
        elseif v8 == p4 and v5 == 0 then
            table.insert(v6, p3:sub(v7, i - 1));
            v7 = i + 1;
            v9 = i;
        else
            v9 = i;
        end;
    end;

    table.insert(v6, p3:sub(v7));

    return v6;
end;

local function parseValue(p10: string) -- Line: 39
    -- upvalues: splitTopLevel (copy), parseValue (copy)
    local v11 = p10:match("^%s*(.-)%s*$") or "";

    if v11 == "true" then
        return true;
    end;

    if v11 == "false" then
        return false;
    end;

    local v12 = tonumber(v11);

    if v12 then
        return v12;
    end;

    if v11:sub(1, 1) ~= "{" or v11:sub(-1) ~= "}" then
        return v11;
    end;

    local v13 = {};

    for _, v in splitTopLevel(v11:sub(2, -2), ",") do
        table.insert(v13, parseValue(v));
    end;

    return v13;
end;

local function parseChecks(p14: string) -- Line: 55
    -- upvalues: splitTopLevel (copy), parseValue (copy)
    local v15 = {};

    for _, v in splitTopLevel(p14, ",") do
        local v16 = v:match("^%s*(.-)%s*$") or "";
        local v17 = v16:sub(1, 1);
        local v18 = v16:sub(-1);

        if v17 == "(" and v18 == ")" or v17 == "{" and v18 == "}" then
            v16 = v16:sub(2, -2);
        end;

        local v19 = {};

        for _, v2 in splitTopLevel(v16, ",") do
            local v20, v21 = v2:match("^%s*([%w_ ]-)%s*=%s*(.-)%s*$");

            if v20 and v21 then
                v19[v20:match("^%s*(.-)%s*$") or ""] = parseValue(v21);
            end;
        end;

        if v19.Name ~= nil then
            v15[v19.Name] = v19.Value;
        end;
    end;

    return v15;
end;

local u22 = {};

function getChecksModule(p23: string)
    -- upvalues: u22 (copy)
    if u22[p23] then
        return u22[p23];
    end;

    local v24 = script.Checks:FindFirstChild(p23);

    if v24 ~= nil then
        u22[p23] = require(v24);

        return u22[p23];
    end;
end;

return function(p25: userdata, u26: userdata, p27: any, u28: any) -- Line: 91
    -- upvalues: Quests (copy), Players (copy), parseChecks (copy), Config (copy), u1 (copy), config (copy), HoldPress (copy), interfaceutility (copy), TextService (copy), Vector2_new_ret (copy), Random_new_ret (copy)
    local ObjectText = u26.ObjectText;
    local ActionText = u26.ActionText;

    if #ObjectText == 0 then
        ObjectText = nil;
    end;

    if #ActionText == 0 then
        ActionText = nil;
    end;

    local Attribute = u26:GetAttribute("Icon");
    local Attribute2 = u26:GetAttribute("MaskUntilQuest");

    if typeof(Attribute2) == "string" and Quests.GetPlayerQuestState(Players.LocalPlayer, Attribute2) == "None" then
        Attribute = nil;
        ObjectText = "???";
    end;

    local Attribute3 = u26:GetAttribute("Checks");
    local v29 = Attribute3 == nil and {} or parseChecks(Attribute3);
    local v30 = {};

    if next(v29) ~= nil then
        for i, v in v29 do
            local v31 = getChecksModule(i);

            if v31 ~= nil then
                v31(v, v30);
            end;
        end;
    end;

    local u32;

    if v30 then
        u32 = #v30 > 0;
    else
        u32 = v30;
    end;

    local u33 = u28:Value(0);
    local u34 = u28:Value(0.15);
    local u35 = u28:Value(0.6);
    local u36 = u28:Value(Color3.new(1, 1, 1));
    local u37 = u28:Value(Color3.new(0.175, 0.175, 0.175));
    local u38 = u28:Value(Color3.new(1, 1, 1));
    local u39 = u28:Value(0.65);
    local u40 = u28:Value(1);
    local u41 = u28:Value(1);
    local u42 = u28:Value(0);
    local u43 = u28:Value(1);
    local u44 = u28:Value(false);
    local u45 = nil;

    local function update() -- Line: 139
        -- upvalues: u41 (copy), u43 (copy), u45 (ref), u37 (copy), u38 (copy), u39 (copy), u40 (copy), u44 (copy), u35 (copy), u33 (copy), u34 (copy), Config (ref), u36 (copy)
        local v46 = u41:Get();
        local v47 = u43:Get();

        if v47 >= 2 then
            v46 = v47 + 1;
        end;

        if v46 ~= u45 then
            local v48 = false;
            u45 = v46;
            local v49 = false;

            if v46 == 2 then
                u37:Set(Color3.new());
                u38:Set(Color3.new());
                u39:Set(0);
                u40:Set(0.5);
                v48 = true;
            elseif v46 >= 3 then
                v49 = true;
                v48 = u44.Value;
                u35:Set(1);
                u33:Set(1);
                u40:Set(1);
                u34:Set(1);
                u39:Set(1);

                if v46 == 3 then
                    u37:Set(Config.TriggeredColor);
                    u36:Set(Config.TriggeredColor);
                else
                    u37:Reset();
                end;
            else
                u40:Reset();
                u39:Reset();
                u38:Reset();
                u37:Reset();
            end;

            if not v49 then
                u35:Reset();
                u33:Reset();
                u34:Reset();
                u36:Reset();
            end;

            u44:Set(v48);
        end;
    end;

    u41.Changed:Connect(update);
    u43.Changed:Connect(update);
    local KeyContent = Config.GetKeyContent(u26, p27);
    local v50;

    if KeyContent.Type == "Text" then
        v50 = u28:Create("TextLabel")({
            BackgroundTransparency = 1,
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.785),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Text = KeyContent.Content,
            TextTransparency = u28:Animation(u33, Config.TransitionInfoLong),
            Font = Enum.Font.SourceSansBold,
            TextColor3 = u28:Animation(u38, Config.TransitionInfo)
        });
    else
        v50 = u28:Create("ImageLabel")({
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.85, 0.85),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            ImageTransparency = u28:Animation(u33, Config.TransitionInfoLong),
            Image = KeyContent.Content,
            ImageColor3 = u28:Animation(u38, Config.TransitionInfo)
        });
    end;

    local v51;

    if v30 == nil or #v30 <= 0 then
        v51 = nil;
    else
        local v52 = { u28:Create("UIListLayout")({
                Name = "List",
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0.05, 0)
            }) };

        for _, v in v30 do
            local v53 = u28:Create("Frame");
            local v54 = {
                Name = "ChkEntry",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1 / #v30)
            };
            local v55 = u28:Create("UIListLayout")({
                Name = "List",
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.0075, 0)
            });
            local v56;

            if v.Image then
                v56 = u28:Create("ImageLabel")({
                    Name = "ChkIcon",
                    Size = UDim2.fromScale(1, 1),
                    Instance.new("UIAspectRatioConstraint"),
                    BackgroundTransparency = 1,
                    ImageTransparency = u28:Animation(u33, Config.TransitionInfoLong),
                    Image = v.Image,
                    ImageColor3 = u28:Animation(u36, Config.TransitionInfoLong)
                });
            else
                v56 = nil;
            end;

            local v57;

            if v.Text then
                v57 = u28:Create("TextLabel")({
                    Name = "ChkText",
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Size = UDim2.fromScale(10, 0.925),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = v.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = Color3.new(1, 0.3, 0.3),
                    TextTransparency = u28:Animation(u33, Config.TransitionInfoLong)
                });
            else
                v57 = nil;
            end;

            v54[1], v54[2], v54[3] = v55, v56, v57;
            table.insert(v52, v53(v54));
        end;

        v51 = u28:Create("Frame")({
            Name = "bchecks",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, #v30 * 0.3),
            unpack(v52)
        });
    end;

    local v58 = u28:Create("Frame");
    local v59 = {
        Parent = p25,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1
    };
    local v71 = u28:Create("Frame")({
        Name = "Bg",
        u28:Create("Frame")({
            Size = UDim2.new(1, -10, 1, -10),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            ZIndex = 2,
            BackgroundColor3 = u28:Animation(u36, Config.TransitionInfo),
            BackgroundTransparency = u28:Animation(u40, Config.TransitionInfo),
            u28:Create("UICorner")({
                CornerRadius = UDim.new(0.075)
            }),
            u28:Create("UIGradient")({
                Rotation = 0,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(0.3, 0.7), NumberSequenceKeypoint.new(1, 0.9) })
            })
        }),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
        u28:Create("Frame")({
            Name = "BgActual",
            BackgroundTransparency = u28:Animation(u33, Config.TransitionInfo),
            Size = u28:Animation(UDim2.fromScale(1, 1), u1, {
                From = UDim2.fromScale(0.75, 0.75)
            }),
            BackgroundColor3 = u28:Animation(u37, Config.TransitionInfo),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            u28:Create("UIGradient")({
                Rotation = -35,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 0.7) })
            }),
            u28:Create("UICorner")({
                CornerRadius = UDim.new(0.1)
            })
        }),
        u28:State(function(p60: function, p61: any, p62: userdata?) -- Line: 329
            -- upvalues: u44 (copy), config (ref), u36 (copy), Config (ref), u33 (copy), u42 (copy)
            if p60(u44) then
                return p61:Create("Frame")({
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Name = "Holding",
                    CleanDelay = config.CleanDelay,
                    p61:Create("Frame")({
                        Size = UDim2.fromScale(0.5, 1),
                        Position = UDim2.fromScale(0),
                        Name = "right",
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        p61:Create("Frame")({
                            Name = "Holder",
                            Size = UDim2.fromScale(2, 1),
                            BackgroundTransparency = 1,
                            Position = UDim2.fromScale(0, 0),
                            p61:Create("UIStroke")({
                                Thickness = 2,
                                BorderOffset = UDim.new(0, -4),
                                Color = p61:Animation(u36, Config.TransitionInfoLong),
                                Transparency = p61:Animation(u33, Config.TransitionInfoLong),
                                p61:Create("UIGradient")({
                                    Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 0.3),
                                        NumberSequenceKeypoint.new(0.499, 0.3),
                                        NumberSequenceKeypoint.new(0.501, 1),
                                        NumberSequenceKeypoint.new(1, 1)
                                    }),
                                    Rotation = p61:Do(function(p63: function, p64: any, p65: userdata?) -- Line: 359
                                        -- upvalues: u42 (ref)
                                        local v66 = (1 - p63(u42)) * 360 - 180;

                                        return math.clamp(v66, 0, 180);
                                    end)
                                })
                            }),
                            p61:Create("UICorner")({
                                CornerRadius = UDim.new(0.1)
                            })
                        })
                    }),
                    p61:Create("Frame")({
                        Size = UDim2.fromScale(0.5, 1),
                        Position = UDim2.fromScale(0.5),
                        Name = "right",
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        p61:Create("Frame")({
                            Name = "Holder",
                            Size = UDim2.fromScale(2, 1),
                            BackgroundTransparency = 1,
                            Position = UDim2.fromScale(-1, 0),
                            p61:Create("UIStroke")({
                                Thickness = 2,
                                BorderOffset = UDim.new(0, -4),
                                Color = p61:Animation(u36, Config.TransitionInfoLong),
                                Transparency = p61:Animation(u33, Config.TransitionInfoLong),
                                p61:Create("UIGradient")({
                                    Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 1),
                                        NumberSequenceKeypoint.new(0.499, 1),
                                        NumberSequenceKeypoint.new(0.501, 0.3),
                                        NumberSequenceKeypoint.new(1, 0.3)
                                    }),
                                    Rotation = p61:Do(function(p67: function, p68: any, p69: userdata?) -- Line: 392
                                        -- upvalues: u42 (ref)
                                        local v70 = (1 - p67(u42)) * 360;

                                        return math.clamp(v70, 0, 180);
                                    end)
                                })
                            }),
                            p61:Create("UICorner")({
                                CornerRadius = UDim.new(0.1)
                            })
                        })
                    })
                });
            end;
        end)
    });
    local v72 = u28:Create("TextButton")({
        BackgroundTransparency = 1,
        Name = "DetectBox",
        Size = UDim2.fromScale(1, 1),
        InputBegan = HoldPress(u28, u26)
    });
    local v73 = u28:Create("Frame");
    local v74 = {
        Name = "Holder",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1
    };
    local v75 = u28:Create("UIListLayout")({
        Name = "List",
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0.05, 0)
    });

    if v51 == nil then
        v51 = nil;
    end;

    local v76;

    if (ActionText or v50) and not u32 then
        local v77 = u28:Create("Frame");
        local v78 = {
            Name = "cActionContent",
            Size = UDim2.fromScale(1, 0.45),
            BackgroundTransparency = 1
        };
        local v79 = u28:Create("UIListLayout")({
            Name = "List",
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0.015, 0)
        });
        local v80 = u28:Create("Frame");
        local v81 = {
            Name = "KeyHolder",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = u28:Animation(u36, Config.TransitionInfoLong),
            Instance.new("UIAspectRatioConstraint"),
            BackgroundTransparency = u28:Animation(u39, Config.TransitionInfoLong)
        };
        local v82 = u28:Create("UIGradient")({
            Rotation = 135,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.95) })
        });
        local v83 = u28:Create("UICorner");
        local v84 = {};
        local v85;

        if p27 == Enum.ProximityPromptInputType.Gamepad then
            v85 = UDim.new(1);
        else
            v85 = UDim.new(0.1);
        end;

        v84.CornerRadius = v85;
        v81[2], v81[3], v81[4], v81[5] = v82, v83(v84), u28:Create("UIStroke")({
    Thickness = 1.5,
    BorderOffset = UDim.new(-0.1, 0),
    Color = u28:Animation(u38, Config.TransitionInfoLong),
    Transparency = u28:Animation(u35, Config.TransitionInfoLong)
}), v50;
        local v86 = v80(v81);
        local v87;

        if ActionText then
            v87 = u28:Create("TextLabel")({
                Name = "actiontxt",
                BackgroundTransparency = 1,
                TextScaled = true,
                Font = Enum.Font.SourceSansSemibold,
                Text = ActionText,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.fromScale(1, 0.8),
                TextTransparency = u28:Animation(u34, Config.TransitionInfoLong),
                TextColor3 = u28:Animation(u36, Config.TransitionInfoLong)
            });
        else
            v87 = nil;
        end;

        v78[1], v78[2], v78[3] = v79, v86, v87;
        v76 = v77(v78);
    else
        v76 = nil;
    end;

    local v88;

    if ObjectText or Attribute then
        local v89 = u28:Create("Frame");
        local v90 = {
            Name = "aObjectContent",
            Size = UDim2.fromScale(1, 0.35),
            BackgroundTransparency = 1
        };
        local v91 = u28:Create("UIListLayout")({
            Name = "List",
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal
        });
        local v92;

        if ObjectText then
            v92 = u28:Create("TextLabel")({
                Name = "ObjectText",
                BackgroundTransparency = 1,
                TextScaled = true,
                Size = UDim2.fromScale(10, 1),
                Font = Enum.Font.SourceSansSemibold,
                Text = ObjectText,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextColor3 = u28:Animation(u36, Config.TransitionInfoLong),
                TextTransparency = u28:Animation(u33, Config.TransitionInfoLong)
            });
        else
            v92 = nil;
        end;

        local v93;

        if Attribute then
            v93 = u28:Create("ImageLabel")({
                Size = UDim2.fromScale(1, 1),
                Instance.new("UIAspectRatioConstraint"),
                BackgroundTransparency = 1,
                ImageTransparency = u28:Animation(u33, Config.TransitionInfoLong),
                Image = Attribute,
                ImageColor3 = u28:Animation(u36, Config.TransitionInfoLong)
            });
        else
            v93 = nil;
        end;

        v90[1], v90[2], v90[3] = v91, v92, v93;
        v88 = v89(v90);
    else
        v88 = nil;
    end;

    v74[1], v74[2], v74[3], v74[4] = v75, v51, v76, v88;
    v59[1], v59[2], v59[3] = v71, v72, v73(v74);

    function v59.After(p94: userdata) -- Line: 522
        -- upvalues: interfaceutility (ref), TextService (ref), Vector2_new_ret (ref)
        local AbsoluteSize = interfaceutility.GetAbsoluteSize(p94);

        if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
            return;
        end;

        local v95 = 0;
        local v96 = 0;
        local v97 = 0;
        local aObjectContent = p94.Holder:FindFirstChild("aObjectContent");

        if aObjectContent ~= nil then
            local v98 = 0.35 * AbsoluteSize.Y;
            local v99 = 0;
            local ObjectText2 = aObjectContent:FindFirstChild("ObjectText");

            if ObjectText2 ~= nil then
                local X = TextService:GetTextSize(ObjectText2.Text, v98 * ObjectText2.Size.Y.Scale, ObjectText2.Font, Vector2.new((1 / 0), (1 / 0))).X;
                ObjectText2.Size = UDim2.fromScale(X / AbsoluteSize.X, ObjectText2.Size.Y.Scale);
                v99 = v99 + X;
            end;

            if aObjectContent:FindFirstChildOfClass("ImageLabel") ~= nil then
                v99 = v99 + v98;
            end;

            v95 = math.max(v95, v99);
            v96 = v96 + v98;
            v97 = v97 + 1;
        end;

        local bchecks = p94.Holder:FindFirstChild("bchecks");

        if bchecks ~= nil then
            local v100 = {};

            for _, child in bchecks:GetChildren() do
                if child:IsA("Frame") then
                    table.insert(v100, child);
                end;
            end;

            local v101 = #v100;

            if v101 > 0 then
                local v102 = bchecks.Size.Y.Scale * AbsoluteSize.Y / v101;
                local v103 = 0;

                for _, v in v100 do
                    local v104 = 0;
                    local v105 = v:FindFirstChildOfClass("UIListLayout");
                    local v106 = (v105 and v105.Padding.Scale or 0) * AbsoluteSize.X;
                    local ChkText = v:FindFirstChild("ChkText");

                    if ChkText ~= nil then
                        local X = TextService:GetTextSize(ChkText.Text, v102 * ChkText.Size.Y.Scale, ChkText.Font, Vector2.new((1 / 0), (1 / 0))).X;
                        ChkText.Size = UDim2.fromScale(X / AbsoluteSize.X, ChkText.Size.Y.Scale);
                        v104 = v104 + X;
                    end;

                    if v:FindFirstChild("ChkIcon") ~= nil then
                        v104 = v104 + v102;

                        if ChkText ~= nil then
                            v104 = v104 + v106;
                        end;
                    end;

                    v103 = math.max(v103, v104);
                end;

                local v107 = bchecks:FindFirstChildOfClass("UIListLayout");
                local v108 = v107 and v107.AbsoluteContentSize or Vector2.new(v103, v102 * v101);
                local math_max_ret = math.max(v108.Y, v102 * v101);
                local math_max_ret2 = math.max(v108.X, v103);
                v95 = math.max(v95, math_max_ret2);
                v96 = v96 + math_max_ret;
                v97 = v97 + 1;
            end;
        end;

        local cActionContent = p94.Holder:FindFirstChild("cActionContent");

        if cActionContent ~= nil then
            local v109 = 0.45 * AbsoluteSize.Y;
            local v110 = 0.015 * AbsoluteSize.X;
            local actiontxt = cActionContent:FindFirstChild("actiontxt");
            local v111;

            if actiontxt == nil then
                v111 = v109;
            else
                local X = TextService:GetTextSize(actiontxt.Text, v109 * actiontxt.Size.Y.Scale, actiontxt.Font, Vector2.new((1 / 0), (1 / 0))).X;
                actiontxt.Size = UDim2.fromScale(X / AbsoluteSize.X, actiontxt.Size.Y.Scale);
                v111 = v109 + v110 + X;
            end;

            v95 = math.max(v95, v111);
            v96 = v96 + v109;
            v97 = v97 + 1;
        end;

        if v97 > 1 then
            v96 = v96 + 0.035 * AbsoluteSize.Y * (v97 - 1);
        end;

        p94.Bg.Size = UDim2.fromScale((v95 + Vector2_new_ret.X) / AbsoluteSize.X, (v96 + Vector2_new_ret.Y) / AbsoluteSize.Y + p94.Holder.List.Padding.Scale * (#p94.Holder:GetChildren() - 2));
    end;

    v58(v59);
    local u112 = u26:GetAttribute("CoolDown") or Config.CoolDown;
    local u113 = nil;
    local u114 = false;
    local u115 = 0;
    local HoldDuration = u26.HoldDuration;

    local function stateManager() -- Line: 625
        -- upvalues: Random_new_ret (ref), u115 (ref), u114 (ref), u28 (copy), HoldDuration (copy), u42 (copy), u41 (copy)
        local v116 = 1;
        local u117 = Random_new_ret:NextNumber(1, 999);
        u115 = u117;

        if u114 == true then
            u28:Spawn(function() -- Line: 631
                -- upvalues: u117 (copy), u115 (ref), HoldDuration (ref), u42 (ref)
                local os_clock_ret = os.clock();

                while u117 == u115 do
                    local v118 = (os.clock() - os_clock_ret) / HoldDuration;
                    local math_clamp_ret = math.clamp(v118, 0, 1);
                    u42:Set(math_clamp_ret);

                    if math_clamp_ret >= 1 then
                        break;
                    end;

                    task.wait();
                end;
            end);
            v116 = 2;
        end;

        u41:Set(v116);
    end;

    u28:Connect(u26.PromptButtonHoldBegan, function() -- Line: 649
        -- upvalues: u32 (copy), u26 (copy), u114 (ref), u113 (ref), Config (ref), u28 (copy), stateManager (copy)
        if u32 then
            return;
        end;

        if u26:GetAttribute("OnCooldown") then
            return;
        end;

        u114 = true;
        u113 = Config.PlaySound(u28, u26, "Hold", u113);
        stateManager();
    end);
    u28:Connect(u26.PromptButtonHoldEnded, function() -- Line: 656
        -- upvalues: u114 (ref), u43 (copy), u113 (ref), Config (ref), u28 (copy), u26 (copy), stateManager (copy)
        if not u114 then
            return;
        end;

        u114 = false;

        if u43:Compare(1) then
            u113 = Config.PlaySound(u28, u26, "NoneFromHold", u113);
        end;

        task.wait();

        if not u28.IsActive then
            return;
        end;

        stateManager();
    end);
    u28:Connect(u26.Triggered, function() -- Line: 666
        -- upvalues: u32 (copy), u43 (copy), u113 (ref), Config (ref), u28 (copy), u26 (copy), u112 (copy)
        if u32 then
            return;
        end;

        if not u43:Compare(1) then
            return;
        end;

        u113 = Config.PlaySound(u28, u26, "Triggered", u113);
        u43:Set(2);
        u26:SetAttribute("OnCooldown", true);
        task.wait(u112);
        u26:SetAttribute("OnCooldown", nil);

        if not u28.IsActive then
            return;
        end;

        if u43 ~= nil and u43:Compare(2) then
            u43:Reset();
        end;
    end);

    return function() -- Line: 680
        -- upvalues: u113 (ref), u28 (copy), u43 (copy), Config (ref)
        if u113 and u113.Parent then
            u28:Remove(u113);
            u113:Destroy();
            u113 = nil;
        end;

        u43:Set(3);
        task.wait(Config.CleanDelay);
    end;
end;