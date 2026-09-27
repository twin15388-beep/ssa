-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};
local Dialogue = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue);
local u2 = typeof;

function u1.ExtractValue(p3, p4) -- Line: 9
    -- upvalues: Dialogue (copy), u1 (copy), u2 (copy)
    if p3 ~= nil then
        local Storage = Dialogue.Storage;

        if Dialogue.Functions[p3] then
            return u1.ExtractValue(Dialogue.Functions[p3](p4, Storage));
        end;

        if u2(p3) == "function" then
            return u1.ExtractValue(p3(p4, Storage));
        end;

        if Dialogue.Diagloues[p3] == nil then
            return p3;
        end;

        return p3;
    end;
end;

function u1.BeforeRun(p5: any, p6: userdata?) -- Line: 22
    -- upvalues: u1 (copy), Dialogue (copy)
    if type(p5) == "table" then
        if p5.Function ~= nil then
            local v7 = u1.ExtractValue(p5.Function, p6);

            if v7 ~= nil then
                if p5.Results ~= nil and p5.Results[v7] ~= nil then
                    v7 = u1.ExtractValue(p5.Results[v7], v7);
                end;

                if v7 ~= nil then
                    if v7 == "Close" or v7 == false then
                        return false;
                    end;

                    return v7;
                end;
            end;
        end;

        return nil;
    end;

    local v8 = u1.ExtractValue(p5, p6);

    if v8 == nil then
        return nil;
    end;

    if v8 == "Close" or v8 == false then
        return false;
    end;

    if Dialogue.Diagloues[v8] == nil then
        return nil;
    end;

    return v8;
end;

function u1.Close() -- Line: 50
    -- upvalues: Dialogue (copy)
    Dialogue.CurrentDialogue.Current = nil;
    Dialogue.CurrentDialogue.Cancel:Fire();
end;

function u1.Do(p9, p10) -- Line: 54
    -- upvalues: Dialogue (copy)
    if p9 ~= nil then
        if Dialogue.Functions[p9] then
            Dialogue.Functions[p9](p10, Dialogue.Storage);

            return true;
        end;

        if not Dialogue.Diagloues[p9] then
            return nil;
        end;

        Dialogue.AttemptDialogue:Fire(p9);

        return true;
    end;
end;

function u1.DoAll(p11: any, p12: any, p13: boolean?) -- Line: 66
    -- upvalues: u1 (copy)
    if p11 ~= nil then
        local v14 = u1.ExtractValue(p11, p12);

        if u1.Do(v14, p12) then
            return true;
        end;

        if v14 ~= nil and (v14 ~= "" and v14 ~= false) then
            warn((`[Dialogue] answer value "{tostring(v14)}" (from "{tostring(p11)}") is neither a Function nor a dialogue node, closing`));
        end;

        if not p13 then
            u1.Close();
        end;

        return nil;
    end;
end;

return u1;