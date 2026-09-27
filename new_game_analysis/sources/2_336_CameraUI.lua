-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");
local u1 = false;
local u2 = {};

function u2.setCameraModeToastEnabled(p3: boolean) -- Line: 10
    -- upvalues: u1 (ref), u2 (copy)
    if not (p3 or u1) then
        return;
    end;

    if not u1 then
        u1 = true;
    end;

    if not p3 then
        u2.setCameraModeToastOpen(false);
    end;
end;

function u2.setCameraModeToastOpen(p4: boolean) -- Line: 24
    -- upvalues: u1 (ref), StarterGui (copy)
    assert(u1);

    if p4 then
        StarterGui:SetCore(
            "SendNotification",
            {
                Title = "Camera Control Enabled",
                Text = "Right click to toggle",
                Duration = 3
            }
        );
    end;
end;

return u2;