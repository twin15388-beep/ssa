-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {
    Info = require(ReplicatedStorage.Packages.faye).Info(0.2)
};

function u1.FadeOutOnClean(u2) -- Line: 15
    -- upvalues: u1 (copy)
    return function(p3: any, p4: userdata) -- Line: 16
        -- upvalues: u1 (ref), u2 (copy)
        for _, descendant in p4:GetDescendants() do
            if descendant:IsA("GuiObject") then
                p3:LoadAnimation(descendant, {
                    BackgroundTransparency = 1
                }, u1.Info):Play();
            end;

            if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
                p3:LoadAnimation(descendant, {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1
                }, u1.Info):Play();
            end;

            if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                p3:LoadAnimation(descendant, {
                    ImageTransparency = 1
                }, u1.Info):Play();
            end;

            if descendant:IsA("UIStroke") or descendant:IsA("UIShadow") then
                p3:LoadAnimation(descendant, {
                    Transparency = 1
                }, u1.Info):Play();
            end;
        end;

        return u2 == nil and {
            BackgroundTransparency = p3:Animation(1, u1.Info)
        } or {
            BackgroundTransparency = p3:Animation(1, u1.Info),
            Position = p3:Animation(u2, u1.Info)
        };
    end;
end;

return u1;