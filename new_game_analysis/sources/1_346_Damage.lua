-- Decompiled with Potassium's decompiler.

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Amount",
            Name = "Amount",
            Required = true,

            Completer = function(p1: string) -- Line: 23, Name: Completer
                return tonumber(p1);
            end
        }
    },

    Server = function(p2: userdata, p3: table, p4: any) -- Line: 28, Name: Server
        local v5 = tonumber(p4);

        if v5 == nil or v5 <= 0 then
            return;
        end;

        for _, v in ipairs(p3) do
            local Character = v.Character;
            local v6;

            if Character == nil then
                v6 = nil;
            else
                v6 = Character:FindFirstChild("Humanoid") or nil;
            end;

            if v6 ~= nil and v6.Health > 0 then
                v6:TakeDamage((math.min(v5, v6.Health)));
            end;
        end;
    end
};