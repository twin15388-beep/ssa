-- Decompiled with Potassium's decompiler.

local u1 = game:GetService("RunService"):IsServer();

return {
    AddItem = function(p2: table, u3: any, p4: number, p5: string?) -- Line: 6, Name: AddItem
        -- upvalues: u1 (copy)
        if u3 == nil then
            return;
        end;

        if p4 == 0 and u3.ClassName == "Sound" then
            task.delay(0.5, function() -- Line: 9
                -- upvalues: u3 (ref)
                if u3 == nil or u3.Parent == nil then
                    return;
                end;

                local v6 = u3.TimeLength - 0.5;

                if v6 > 0 then
                    task.wait(v6);
                end;

                if u3 == nil or u3.Parent == nil then
                    return;
                end;

                u3:Destroy();
                u3 = nil;
            end);

            return;
        end;

        if u1 and typeof(u3) == "Instance" then
            u3:AddTag("OuwDebris");
            u3:SetAttribute("_OuwDebrisAt", workspace:GetServerTimeNow() + p4);
        end;

        task.delay(p4, u3.Destroy, u3);
    end
};