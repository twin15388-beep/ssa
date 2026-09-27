-- Decompiled with Potassium's decompiler.

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Player",
            Required = true
        },
        {
            Type = "Subject",
            Required = true,
            Suggester = { "Water Mark" }
        },
        {
            Type = "Boolean",
            Required = true,

            Completer = function(p1: string) -- Line: 42, Name: Completer
                local v2 = p1:lower();

                if v2 == "true" then
                    return true;
                end;

                if v2 == "false" then
                    return false;
                end;

                return nil;
            end
        }
    },

    Client = function(p3: any, p4: userdata, p5: any, p6: any, p7: any) -- Line: 50, Name: Client
        if p6 == "Water Mark" then
            local v8 = p5 or game:GetService("Players").LocalPlayer;
            local Watermark = v8.PlayerGui:FindFirstChild("Watermark", true);

            if Watermark == nil then
                error((`No gui named "Watermark" anywhere in {v8.Name}'s PlayerGui, other players' guis aren't visible from your client`));
            end;

            if Watermark:IsA("GuiObject") then
                Watermark.Visible = p7;

                return;
            end;

            Watermark.Enabled = p7;
        end;
    end
};