-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local CommonUtils = require(script:WaitForChild("CommonUtils"));
local u1 = CommonUtils.get("CharacterUtil");
local u2 = CommonUtils.get("ConnectionUtil");
local u3 = CommonUtils.get("EventBus");
local CameraModule = require(script:WaitForChild("CameraModule"));
local ControlModule = require(script:WaitForChild("ControlModule"));
local ServerAuthority = require(script:WaitForChild("ServerAuthority"));
local u4 = {};
u4.__index = u4;

function u4.new() -- Line: 67
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v5 = {
        data = {
            isServerAuthority = false,
            playerData = {},
            connectionUtil = u2.new(),
            eventBus = u3.new()
        }
    };

    return setmetatable(v5, u4);
end;

function u4.start(u6) -- Line: 80
    -- upvalues: u1 (copy), ServerAuthority (copy), ControlModule (copy), RunService (copy), CameraModule (copy)
    u6.data.connectionUtil:trackConnection("ONLOCALPLAYER", u1.onLocalPlayer(function(p7) -- Line: 82
        -- upvalues: u6 (copy), ServerAuthority (ref), ControlModule (ref), RunService (ref), u1 (ref), CameraModule (ref)
        u6.data.playerData[p7] = {
            isJumping = false,
            character = nil,
            moveVector = Vector2.new(),
            actions = {},
            player = p7
        };
        ServerAuthority.initialize(u6.data);
        ControlModule:initialize(u6.data, u6.data.playerData[p7]);
        RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_INPUT", Enum.RenderPriority.Input.Value, function(p8) -- Line: 97
            -- upvalues: u6 (ref), u1 (ref), ControlModule (ref)
            for _, v in pairs(u6.data.playerData) do
                v.character = u1.getCharacter();

                if not v.character then
                    return;
                end;

                ControlModule:Update(u6.data, v, p8);
            end;
        end);
        u6.data.connectionUtil:trackBoundFunction("PLAYERMODULE_RENDERSTEPPED_INPUT", function() -- Line: 107
            -- upvalues: RunService (ref)
            RunService:UnbindFromRenderStep("PLAYERMODULE_RENDERSTEPPED_INPUT");
        end);
        RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_CAMERA", Enum.RenderPriority.Camera.Value, function(p9) -- Line: 112
            -- upvalues: u6 (ref), CameraModule (ref)
            for _, v in pairs(u6.data.playerData) do
                CameraModule:Update(v, p9);
            end;
        end);
        u6.data.connectionUtil:trackBoundFunction("PLAYERMODULE_RENDERSTEPPED_CAMERA", function() -- Line: 117
            -- upvalues: RunService (ref)
            RunService:UnbindFromRenderStep("PLAYERMODULE_RENDERSTEPPED_CAMERA");
        end);
    end));
end;

function u4.stop(p10) -- Line: 123
    p10.data.connectionUtil:disconnectAll();
end;

u4.new():start();

return {};