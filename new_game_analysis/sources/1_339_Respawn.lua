-- Decompiled with Potassium's decompiler.

return {
    Clearance = 1,
    Priority = 2,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "InPlace",
            Name = "InPlace",
            Required = false,
            Suggester = { "true", "false" },

            Completer = function(p1: string) -- Line: 29, Name: Completer
                if p1 == nil then
                    return nil;
                end;

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

    Server = function(p3: userdata, p4: table, p5: any) -- Line: 38, Name: Server
        for _, v in ipairs(p4) do
            if p5 == true then
                local v6;

                if v.Character == nil then
                    v6 = nil;
                else
                    v6 = v.Character:FindFirstChild("HumanoidRootPart") or nil;
                end;

                if v6 ~= nil then
                    v:SetAttribute("RespawnInPlace", v6.Position);
                end;
            end;

            v:LoadCharacter();
        end;
    end
};