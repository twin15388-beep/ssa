-- Decompiled with Potassium's decompiler.

local faye = game:GetService("ReplicatedStorage").Packages.faye;
local u1 = require(faye).Info(0.1);

return function(p2: any, p3: number, u4: userdata, u5: any, p6: any, p7: number) -- Line: 7
    -- upvalues: u1 (copy)
    local v8 = p2:Value(0.75);
    local v9 = p2:Value(0.95);
    local v10 = p2:Value(0.95);
    local v11 = p2:Value();
    local v12 = p2:Value(UDim2.fromScale(0.75, 0.75));
    local v13 = p2:Value(UDim2.fromScale(1, 1));
    local v14 = p2:Value(UDim2.fromScale(1.1, 1.1));
    local v15 = p2:Value(1);
    local u16 = {
        In = false,
        Index = u4.Name,
        Type = p7
    };
    local u17 = p6:Add({
        u16,
        v11,
        u4,
        v8,
        v9,
        v10,
        v12,
        v13,
        v14,
        v15
    }):Call():SetId((`{p7}-{u4.Name}`));

    return p2:Create("Frame")({
        Size = UDim2.fromScale(1, 1),
        Instance.new("UIAspectRatioConstraint"),
        BackgroundTransparency = 1,
        Name = `{p3}-{u4.Name}`,
        p2:Create("TextButton")({
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),

            MouseEnter = function() -- Line: 28, Name: MouseEnter
                -- upvalues: u16 (copy), u17 (copy)
                u16.In = true;
                u17:Call();
            end,

            MouseLeave = function() -- Line: 32, Name: MouseLeave
                -- upvalues: u16 (copy), u17 (copy)
                u16.In = false;
                u17:Call();
            end,

            MouseButton1Up = function() -- Line: 36, Name: MouseButton1Up
                -- upvalues: u5 (copy), u4 (copy)
                u5:Set(u4.Name);
            end
        }),
        p2:Create("Frame")({
            Name = "Holder",
            Size = UDim2.fromScale(0.8, 0.8),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            p2:Create("Frame")({
                Name = "Bg",
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = p2:Animation(v13, u1),
                BackgroundTransparency = p2:Animation(v10, u1),
                p2:Create("UICorner")({
                    CornerRadius = UDim.new(0.15, 0)
                })
            }),
            p2:Create("Frame")({
                Name = "StrokeHolder",
                Size = p2:Animation(v14, u1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                BackgroundTransparency = 1,
                p2:Create("UICorner")({
                    CornerRadius = UDim.new(0.15, 0)
                }),
                p2:Create("UIStroke")({
                    Color = Color3.new(1, 1, 1),
                    Transparency = p2:Animation(v9, u1),
                    Thickness = p2:Animation(v15, u1)
                })
            }),
            p2:Create("ImageLabel")({
                Name = "Img",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = p2:Animation(v12, u1),
                Position = UDim2.fromScale(0.5, 0.5),
                ImageTransparency = p2:Animation(v8, u1),
                Image = v11
            })
        })
    });
end;