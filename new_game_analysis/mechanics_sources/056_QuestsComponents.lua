-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local LocalPlayer = game.Players.LocalPlayer;
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local Data = Utility.GetData(LocalPlayer, true);
local script_IndividualQuest = require(script.IndividualQuest);
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);

if RunService:IsStudio() and not RunService:IsRunning() then
    require(ReplicatedStorage.Regions);
end;

local u1 = faye.Info(0.3, Enum.EasingStyle.Sine);

local function sizeRef() -- Line: 43
    -- upvalues: Platform_Handler (copy)
    return Platform_Handler.Platform.Value == "Mobile" and 108.75 or 145;
end;

return function(u2) -- Line: 46
    -- upvalues: Data (copy), DataValue (copy), u1 (copy), script_IndividualQuest (copy), Platform_Handler (copy)
    local u3 = u2:Value({});
    local u4 = 0;
    local v5;

    if Data == nil then
        v5 = nil;
    else
        v5 = Data:WaitForChild("Quests"):WaitForChild("Holder");
    end;

    if v5 ~= nil then
        for _, child in pairs(v5:GetChildren()) do
            if not u3:ItemExists(child.Name) then
                u4 = u4 + 1;
                u3:Add(child.Name, child);
            end;
        end;

        u2:Connect(v5.ChildAdded, function(p6: userdata) -- Line: 60
            -- upvalues: u3 (copy), u4 (ref)
            if not u3:ItemExists(p6.Name) then
                u4 = u4 + 1;
                u3:Add(p6.Name, p6);
            end;
        end);
        u2:Connect(v5.ChildRemoved, function(p7) -- Line: 66
            -- upvalues: u4 (ref), u3 (copy)
            u4 = u4 - 1;
            u3:Remove(p7.Name);
        end);
    end;

    local v8 = DataValue.new("Misc/QuestHud", true);
    local u9 = u2:Value(v8:Get() ~= false);
    u2:Add(v8.Changed:Connect(function(p10) -- Line: 81
        -- upvalues: u9 (copy)
        u9:Set(p10 ~= false);
    end));
    u2:Add(v8);
    local u11 = u2:Value(u9:Compare(true));
    local u12 = u2:Value(false);
    u2:Connect(u9.Changed, function() -- Line: 87
        -- upvalues: u9 (copy), u12 (copy), u11 (copy), u2 (copy), u1 (ref)
        if u9:Compare(true) then
            u12:Set(false);
            u11:Set(true);

            return;
        end;

        u12:Set(true);
        u2:Delay(u1.Time, function() -- Line: 93
            -- upvalues: u9 (ref), u11 (ref)
            if not u9:Compare(true) then
                u11:Set(false);
            end;
        end);
    end);
    local UDim2_new_ret = UDim2.new();
    local UDim2_fromScale_ret = UDim2.fromScale(-0.25, 0);

    return u2:Create("Frame")({
        Name = "zQuestsFrame",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        u2:State(function(p13: any, u14: any, u15: userdata?) -- Line: 107
            -- upvalues: u11 (copy), u12 (copy), UDim2_fromScale_ret (copy), UDim2_new_ret (copy), u1 (ref), u3 (copy), script_IndividualQuest (ref), Platform_Handler (ref)
            if p13(u11) == true then
                return u14:Create("CanvasGroup")({
                    Name = "Panel",
                    Size = UDim2.new(2, 0, 1, 0),
                    BackgroundTransparency = 1,
                    u14:Create("UIPadding")({
                        PaddingRight = UDim.new(0.5, 0)
                    }),
                    Position = u14:Do(function(p16) -- Line: 126
                        -- upvalues: u12 (ref), u14 (copy), UDim2_fromScale_ret (ref), UDim2_new_ret (ref), u1 (ref)
                        local v17 = p16(u12) == true;
                        local v18;

                        if v17 then
                            v18 = UDim2_fromScale_ret;
                        else
                            v18 = UDim2_new_ret;
                        end;

                        return u14:Animation(v18, u1, not v17 and {
                            From = UDim2_fromScale_ret
                        } or nil);
                    end),
                    GroupTransparency = u14:Do(function(p19) -- Line: 130
                        -- upvalues: u12 (ref), u14 (copy), u1 (ref)
                        local v20 = p19(u12) == true;

                        return u14:Animation(v20 and 1 or 0, u1, not v20 and {
                            From = 1
                        } or nil);
                    end),
                    u14:Create("UIListLayout")({
                        Name = "List",
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 5),

                        [u14:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p21) -- Line: 138
                            -- upvalues: u15 (copy)
                            local Y = p21.AbsoluteContentSize.Y;

                            if u15 ~= nil and u15:IsA("GuiObject") then
                                u15.Size = UDim2.new(u15.Size.X.Scale, 0, 0, Y <= 0 and 0 or Y + 2);
                            end;
                        end
                    }),
                    u14:Iterate(u3, function(p22, p23, p24) -- Line: 146
                        -- upvalues: script_IndividualQuest (ref), Platform_Handler (ref)
                        return script_IndividualQuest(p24, p22, p23, Platform_Handler.Platform.Value == "Mobile" and 108.75 or 145);
                    end)
                });
            end;

            if u15 ~= nil and u15:IsA("GuiObject") then
                u15.Size = UDim2.new(u15.Size.X.Scale, 0, 0, 0);
            end;

            return nil;
        end)
    });
end;