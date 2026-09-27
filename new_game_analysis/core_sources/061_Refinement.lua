-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local RefinementPanel = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.RefinementPanel);
local u1 = require(ReplicatedStorage.Packages.faye).Info(0.45);
local UDim2_fromScale_ret = UDim2.fromScale(0.5, 0.7475);
local UDim2_fromScale_ret2 = UDim2.fromScale(1, 0.69);
local UDim2_fromScale_ret3 = UDim2.fromScale(0.5, 0.66);
local UDim2_new_ret = UDim2.new(1, 0, 0.66, 25);

return function() -- Line: 33
    -- upvalues: Platform_Handler (copy), UDim2_fromScale_ret3 (copy), UDim2_fromScale_ret (copy), UDim2_new_ret (copy), UDim2_fromScale_ret2 (copy), u1 (copy), RefinementPanel (copy)
    return function(p2: any, p3: userdata, p4: userdata, p5: any) -- Line: 34
        -- upvalues: Platform_Handler (ref), UDim2_fromScale_ret3 (ref), UDim2_fromScale_ret (ref), UDim2_new_ret (ref), UDim2_fromScale_ret2 (ref), u1 (ref), RefinementPanel (ref)
        local v6 = Platform_Handler.Platform.Value == "Mobile";
        local v7 = p3:FindFirstAncestorWhichIsA("ScreenGui");

        if v6 and v7 ~= nil then
            local ModeBar = v7:FindFirstChild("ModeBar");

            if ModeBar ~= nil then
                ModeBar.Visible = false;
                p2:Add(function() -- Line: 43
                    -- upvalues: ModeBar (copy)
                    if ModeBar.Parent ~= nil then
                        ModeBar.Visible = true;
                    end;
                end);
            end;
        end;

        local v8 = p2:Create("CanvasGroup");
        local v9 = {
            Parent = v7 or p3,
            AnchorPoint = Vector2.new(0.5, 1)
        };
        local v10;

        if v6 then
            v10 = UDim2_fromScale_ret3;
        else
            v10 = UDim2_fromScale_ret;
        end;

        v9.Position = v10;
        local v11;

        if v6 then
            v11 = UDim2_new_ret;
        else
            v11 = UDim2_fromScale_ret2;
        end;

        v9.Size = v11;
        v9.BackgroundTransparency = 1;
        v9.CleanDelay = u1.Time;
        v9.GroupTransparency = p2:Animation(0, u1, {
            From = 1
        });

        function v9.OnClean(p12) -- Line: 56
            -- upvalues: u1 (ref)
            return {
                GroupTransparency = p12:Animation(1, u1)
            };
        end;

        v9[1] = RefinementPanel(p2);

        return v8(v9);
    end;
end;