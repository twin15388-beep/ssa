-- Decompiled with Potassium's decompiler.

game:GetService("TweenService");
local vfxUtility = require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));

return {
    TurnOnAura = function(p1: userdata, p2: number?) -- Line: 7, Name: TurnOnAura
        -- upvalues: vfxUtility (copy), DebrisModule (copy)
        local v3 = p2 == nil and 12 or p2;
        local Has_Blade = p1:FindFirstChild("Has_Blade", true);

        if Has_Blade ~= nil then
            local Blade = Has_Blade.Parent:FindFirstChild("Blade");

            if Blade ~= nil then
                local v4 = script.Assets.Aura:Clone();
                v4.CFrame = Blade.CFrame;
                v4.Parent = Blade;
                v4.Name = "Aura";
                vfxUtility.WeldConstraint(v4, Blade);
                vfxUtility.TweenBeams(v4, {
                    Time = 0.4
                });
                DebrisModule:AddItem(v4, v3);
            end;
        end;
    end,

    TurnOffAura = function(p5: userdata) -- Line: 26, Name: TurnOffAura
        -- upvalues: vfxUtility (copy), DebrisModule (copy)
        local Has_Blade = p5:FindFirstChild("Has_Blade", true);

        if Has_Blade ~= nil then
            local Blade = Has_Blade.Parent:FindFirstChild("Blade");

            if Blade ~= nil then
                for _, child in ipairs(Blade:GetChildren()) do
                    if child.Name == "Aura" then
                        vfxUtility.TweenBeams(child, {
                            Time = 0.4,
                            Off = true
                        });
                        DebrisModule:AddItem(child, 1);
                    end;
                end;
            end;
        end;
    end
};