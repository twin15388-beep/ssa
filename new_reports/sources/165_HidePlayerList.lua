-- Decompiled with Potassium's decompiler.

local StarterGui = game:GetService("StarterGui");

local function hidePlayerList() -- Line: 3
    -- upvalues: StarterGui (copy)
    pcall(function() -- Line: 4
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    end);
end;

pcall(function() -- Line: 4
    -- upvalues: StarterGui (copy)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
end);
task.spawn(function() -- Line: 13
    -- upvalues: StarterGui (copy)
    for i = 1, 12 do
        task.wait(0.5);
        pcall(function() -- Line: 4
            -- upvalues: StarterGui (ref)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
        end);
        local _ = i;
    end;
end);