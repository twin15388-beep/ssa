-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local script_Individual = require(script.Individual);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local Name = require(ReplicatedStorage.CAM.Global.shopSettings).Loadouts.ExtraLoadout.Name;

return function(p1: any, p2: table) -- Line: 27
    -- upvalues: PopUpCreator (copy), SignalFunction (copy), Name (copy), ReplicatedStorage (copy), DebrisModule (copy), GradientButton (copy), script_Individual (copy)
    local u3 = p1:Value("");
    local u4 = false;

    local function buySlot() -- Line: 31
        -- upvalues: u4 (ref), PopUpCreator (ref), SignalFunction (ref), Name (ref), ReplicatedStorage (ref), DebrisModule (ref)
        if u4 then
            return;
        end;

        u4 = true;
        local v5 = PopUpCreator.new({
            Type = "LoadingFull"
        });
        local success, result = pcall(SignalFunction.ToServer, "PurchaseFromShop", Name, 1);
        v5:Destroy();
        u4 = false;
        local v6 = ReplicatedStorage.Assets.Sounds.Misc[success and result == true and "Money_Kaching" or "denied_old"]:Clone();
        v6.Parent = script;
        v6:Play();
        DebrisModule:AddItem(v6, v6.TimeLength);
    end;

    local u9 = p1:Space(function(p7: table) -- Line: 45
        -- upvalues: u3 (copy)
        local v8 = u3:Compare(p7.Name) and 1 or (p7.In and 2 or 0);

        if v8 ~= p7.LastState then
            p7.LastState = v8;

            if v8 == 1 then
                p7.Color:Set(Color3.new(0.235, 0.235, 0.235));
                p7.TextColor:Reset();
                p7.StrokeTransparency:Set(0.5);
                p7.StrokeSize:Set(UDim2.new(1, -8, 1, -8));
                p7.AspectRatio:Set(3.5);
                p7.Editable:Set(true);
                p7.ButtonEnabled:Set(false);
                p7.TextPosition:Set(UDim2.fromScale(0.5, -0.5));

                return;
            end;

            if v8 == 2 then
                p7.Color:Set(Color3.new(1, 1, 1));
                p7.TextColor:Set(Color3.new());
                p7.AspectRatio:Reset();
                p7.TextPosition:Reset();
                p7.Editable:Reset();
                p7.ButtonEnabled:Reset();

                return;
            end;

            p7.TextColor:Reset();
            p7.Color:Reset();
            p7.AspectRatio:Reset();
            p7.StrokeSize:Reset();
            p7.StrokeTransparency:Reset();
            p7.TextPosition:Reset();
            p7.Editable:Reset();
            p7.ButtonEnabled:Reset();
        end;
    end);
    u9:Connect(u3.Changed);

    return p1:Create("Frame")({
        Name = "Loadout",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(-0.05, 0.55),
        Size = p1:Animation(UDim2.fromScale(0.3, 0.5), p1.SpringInfo(0.35, 1, 0.65), {
            From = UDim2.fromScale(0.24, 0.4)
        }),
        BackgroundTransparency = 1,
        p1:Create("UIListLayout")({
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.Name,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        }),
        GradientButton(p1, {
            Text = "Add more",
            Properties = {
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.fromScale(0.8, 0.065)
            },
            GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.75, 0.5), NumberSequenceKeypoint.new(1, 0.5) }),
            TextXAlignment = Enum.TextXAlignment.Center,
            Clicked = buySlot,
            BgColor = Color3.new(0.627451, 1, 0.466667)
        }),
        p1:Create("ScrollingFrame")({
            Name = "AScrollingFrame",
            Size = UDim2.fromScale(1, 0.935),
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            p1:Create("UIListLayout")({
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.Name,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,

                [p1:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p10) -- Line: 126
                    local AbsoluteContentSize = p10.AbsoluteContentSize;
                    p10.Parent.CanvasSize = UDim2.fromOffset(AbsoluteContentSize.X, AbsoluteContentSize.Y);
                end
            }),
            p1:AdvancedIterate(p2, function(p11, p12, p13) -- Line: 131
                -- upvalues: script_Individual (ref), u9 (copy), u3 (copy)
                return script_Individual(p13, u9, u3, p12);
            end)
        })
    });
end;