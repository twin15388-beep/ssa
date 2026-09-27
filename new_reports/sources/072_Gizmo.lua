-- Decompiled with Potassium's decompiler.

local _ = script.Parent.Parent;
local Config = require(script.Parent.Parent.Parent:WaitForChild("Config"));
local Gizmo = require(script:WaitForChild("Gizmo"));
local u1 = game:GetService("RunService"):IsStudio() or Config.ALLOW_LIVE_GAME_DEBUG;

if u1 then
    Gizmo.Init();
end;

local v4 = setmetatable({}, {
    __index = function(p2, p3) -- Line: 21, Name: __index
        -- upvalues: u1 (copy), Gizmo (copy)
        return not u1 and (({
            SetStyle = true,
            AddDebrisInSeconds = true,
            PushProperty = true,
            PopProperty = true,
            AddDebrisInFrames = true,
            SetEnabled = true,
            DoCleaning = true,
            ScheduleCleaning = true,
            TweenProperties = true
        })[p3] and function() -- Line: 38
        end or {
            Draw = function() -- Line: 42, Name: Draw
            end,

            Create = function() -- Line: 43, Name: Create
            end
        }) or Gizmo[p3];
    end
});

return table.freeze(v4);