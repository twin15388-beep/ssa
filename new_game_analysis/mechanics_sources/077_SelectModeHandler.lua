-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SolidRectangleGradientHover = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.SolidRectangleGradientHover);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
require(ReplicatedStorage.Packages.faye);
require(ReplicatedStorage.Packages.simplesignal);

return function(p1: any, u2: table) -- Line: 16
    -- upvalues: Utility (copy), Players (copy), PopUpCreator (copy), SignalFunction (copy), SolidRectangleGradientHover (copy)
    local u3 = p1:Value();
    local u4 = p1:Value("Edit");
    local u5 = p1:Value("rbxassetid://101612286691224");
    local u6 = p1:Value(Color3.new(1, 1, 1));
    local v7 = {
        BackgroundTransparency = 0.5
    };
    local u8 = {
        Name = "3Select",
        TextStrokeTransparency = 0.85,
        StrokeThickness = 1.5,
        StrokeDisabled = true,
        TweenSizeOnEntry = true,
        Color = u6,
        Image = u5,
        Text = u4,
        Alignment = Enum.TextXAlignment.Right,

        Clicked = function() -- Line: 36, Name: Clicked
            -- upvalues: u2 (copy)
            u2.Enabled:Set(not u2.Enabled.Value);
        end,

        BgProperties = v7,
        ContentColor = u6
    };
    local u9 = false;
    local u21 = {
        TextStrokeTransparency = 0.85,
        Text = "Delete",
        StrokeDisabled = true,
        TweenSizeOnEntry = true,
        Name = "2Sell",
        StrokeThickness = 1.5,
        Color = Color3.new(1, 0.007843, 0.007843),
        BgProperties = v7,
        ContentColor = Color3.new(1, 0.737255, 0.670588),

        Clicked = function() -- Line: 53, Name: Clicked
            -- upvalues: u9 (ref), Utility (ref), Players (ref), u2 (copy), PopUpCreator (ref), SignalFunction (ref)
            if u9 then
                return;
            end;

            local Data = Utility.GetData(Players.LocalPlayer);
            local v10 = Data ~= nil and Data.Inventory.Inventory or nil;
            local v11 = {};
            local v12 = {};

            for i, v in pairs(u2.Selected:Get()) do
                local v13 = 0;
                local v14;

                if type(v) == "table" then
                    v14 = i;

                    for i2, v2 in v do
                        if i2 ~= "Count" and type(v2) == "number" then
                            v13 = v13 + v2;
                        end;
                    end;
                else
                    v14 = i;
                end;

                local v15 = v13 < 1 and 1 or v13;
                local v16;

                if v10 == nil then
                    v16 = nil;
                else
                    v16 = v10:FindFirstChild(v14) or nil;
                end;

                local v17;

                if v16 == nil then
                    v17 = nil;
                else
                    v17 = v16:FindFirstChild("Amount") or nil;
                end;

                if v17 ~= nil and v17.Value < v15 then
                    v15 = v17.Value;
                end;

                v11[v14] = v15;
                local string_gsub_ret = string.gsub(v14, "_", " ");

                if v15 > 1 then
                    string_gsub_ret = string_gsub_ret .. ` x{v15}`;
                end;

                table.insert(v12, string_gsub_ret);
            end;

            if #v12 == 0 then
                return;
            end;

            local v18;

            if #v12 > 3 then
                v18 = `{v12[1]}, {v12[2]}, {v12[3]} +{#v12 - 3}`;
            elseif #v12 == 1 then
                v18 = v12[1];
            else
                v18 = `{table.concat(v12, ", ", 1, #v12 - 1)} and {v12[#v12]}`;
            end;

            u9 = true;

            if PopUpCreator.new({
                Type = "Question",
                Content = `Are you sure you want to delete {v18}?`
            }).Result:Wait(5) == "Yes" then
                local v19 = PopUpCreator.new({
                    Type = "LoadingFull"
                });
                local v20 = SignalFunction.ToServer("DeleteItems", v11);
                v19:Destroy();
                u2.Selected:Set({});

                if (tonumber(v20) or 0) < 1 then
                    game.ReplicatedStorage.Communication.CnC.Notifications.Notification:Fire("Notify", {
                        Text = "Nothing could be deleted, those items are protected.",
                        Type = "Denied"
                    });
                end;
            end;

            u9 = false;
        end
    };

    local function updButtonsEq(p22) -- Line: 145
        -- upvalues: u6 (copy), u4 (copy), u5 (copy), u3 (copy), u8 (copy), u21 (copy)
        if p22 then
            u6:Set(Color3.new(1, 0.627451, 0.627451));
            u4:Set("Close");
            u5:Set("rbxassetid://140084835628457");
            u3:Set({ u8, u21 });

            return;
        end;

        u6:Reset();
        u4:Reset();
        u5:Reset();
        u3:Set({ u8 });
    end;

    updButtonsEq(u2.Enabled:Get());
    u2.Enabled.Changed:Connect(updButtonsEq);

    return p1:Iterate(u3, function(p23, p24, p25) -- Line: 165
        -- upvalues: SolidRectangleGradientHover (ref)
        return SolidRectangleGradientHover(p25, p24);
    end);
end;