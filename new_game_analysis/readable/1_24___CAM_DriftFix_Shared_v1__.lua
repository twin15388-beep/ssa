-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

if script.Parent ~= ReplicatedStorage or script.Name ~= "__CAM_DriftFix_Shared_v1__" then
    local __CAM_DriftFix_Shared_v1__ = ReplicatedStorage:FindFirstChild("__CAM_DriftFix_Shared_v1__");

    if not __CAM_DriftFix_Shared_v1__ then
        __CAM_DriftFix_Shared_v1__ = script:Clone();
        __CAM_DriftFix_Shared_v1__.Name = "__CAM_DriftFix_Shared_v1__";
        __CAM_DriftFix_Shared_v1__.Parent = ReplicatedStorage;
    end;

    return require(__CAM_DriftFix_Shared_v1__);
end;

local RunService = game:GetService("RunService");
local u1 = 0;
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = Enum.RenderPriority.Camera.Value + 1;

local function getCamera() -- Line: 12
    return workspace.CurrentCamera;
end;

return {
    activate = function() -- Line: 17, Name: activate
        -- upvalues: u1 (ref), u4 (ref), RunService (copy), u5 (copy), u2 (ref), u3 (ref)
        u1 = u1 + 1;

        if u1 == 1 then
            if not u4 then
                u4 = true;
                RunService:BindToRenderStep("__CAM_DriftFix_Shared_v1__", u5, function() -- Line: 22
                    -- upvalues: u2 (ref)
                    local workspace_CurrentCamera = workspace.CurrentCamera;

                    if workspace_CurrentCamera then
                        u2 = workspace_CurrentCamera.CFrame;
                    end;
                end);
            end;

            u3 = RunService.Heartbeat:Connect(function() -- Line: 29
                -- upvalues: u2 (ref)
                local workspace_CurrentCamera = workspace.CurrentCamera;

                if workspace_CurrentCamera and u2 then
                    workspace_CurrentCamera.CFrame = u2;
                end;
            end);
        end;
    end,

    deactivate = function() -- Line: 37, Name: deactivate
        -- upvalues: u1 (ref), u3 (ref), u4 (ref), RunService (copy), u2 (ref)
        u1 = math.max(0, u1 - 1);

        if u1 == 0 then
            if u3 then
                u3:Disconnect();
                u3 = nil;
            end;

            if u4 then
                RunService:UnbindFromRenderStep("__CAM_DriftFix_Shared_v1__");
                u4 = false;
            end;

            u2 = nil;
        end;
    end
};