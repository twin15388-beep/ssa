-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Value = Enum.RenderPriority.Character.Value;
local u1 = {};
local u2 = 0;
local workspace_CurrentCamera = workspace.CurrentCamera;

local function shouldTrack(p3, p4: vector) -- Line: 36
    local v5 = p4 - p3.Position;
    local Magnitude = v5.Magnitude;

    if Magnitude <= 25 then
        return true;
    end;

    if Magnitude > 250 then
        return false;
    end;

    return v5:Dot(p3.LookVector) / Magnitude >= 0.25;
end;

local function driveProxy(p6) -- Line: 60
    -- upvalues: RaycastHelper (copy)
    local v7 = p6[1];
    local CFrame = p6[2].CFrame;
    local Position = (CFrame * p6[5].C1:Inverse()).Position;
    local v8 = p6[6] or CFrame.Position;
    local v9 = Position - v8;
    local v10;

    if v9.Magnitude > 0.001 then
        local v11 = workspace:Raycast(v8, v9, RaycastHelper.Crater);

        if v11 == nil then
            v10 = Position;
        else
            v10 = v11.Position + v11.Normal * 2;
            CFrame = CFrame + (v10 - Position);
        end;
    else
        v10 = Position;
    end;

    v7.CFrame = CFrame;
    p6[6] = v10;
end;

local function update() -- Line: 86
    -- upvalues: workspace_CurrentCamera (copy), u1 (copy), driveProxy (copy)
    local CFrame = workspace_CurrentCamera.CFrame;

    for i = #u1, 1, -1 do
        local v12 = u1[i];
        local v13;

        if v12[1] == nil or (v12[2] == nil or (v12[1].Parent == nil or v12[2].Parent == nil)) then
            if v12[1] == nil then
                v13 = i;
            else
                v12[1]:RemoveTag("WeldPartThingOuw");
                v13 = i;
            end;
        else
            local v14 = v12[2].Position - CFrame.Position;
            local Magnitude = v14.Magnitude;
            local v15;

            if Magnitude <= 25 then
                v15 = true;
            elseif Magnitude > 250 then
                v15 = false;
            else
                v15 = v14:Dot(CFrame.LookVector) / Magnitude >= 0.25;
            end;

            if v15 then
                driveProxy(v12);
                v13 = i;
            else
                v12[6] = nil;
                v13 = i;
            end;
        end;
    end;
end;

local function bind() -- Line: 104
    -- upvalues: RunService (copy), Value (copy), update (copy)
    RunService:BindToRenderStep("ouw-weld-render", Value, update);
end;

local function unbind() -- Line: 107
    -- upvalues: RunService (copy)
    RunService:UnbindFromRenderStep("ouw-weld-render");
end;

local function TagAdded(p16: userdata) -- Line: 111
    -- upvalues: u1 (copy), u2 (ref), RunService (copy), Value (copy), update (copy)
    if p16 == nil or (p16:FindFirstChild("To") == nil or (p16.To.Value == nil or (p16:FindFirstChild("Weld") == nil or (p16.Weld.Part1 == nil or p16:FindFirstChild("Start") == nil)))) then
        return;
    end;

    table.insert(u1, {
        p16,
        p16.To.Value,
        p16.Start.Value,
        p16.Weld.Part1,
        p16.Weld
    });

    if u2 == 0 then
        RunService:BindToRenderStep("ouw-weld-render", Value, update);
    end;

    u2 = u2 + 1;
end;

local function TagRemoved(p17: userdata) -- Line: 121
    -- upvalues: u1 (copy), driveProxy (copy), RaycastHelper (copy), u2 (ref), RunService (copy)
    for i, v in ipairs(u1) do
        if v[1] == p17 then
            if v[1] ~= nil and (v[2] ~= nil and (v[1].Parent ~= nil and v[2].Parent ~= nil)) then
                driveProxy(v);
            end;

            if v[2] ~= nil and (v[4] ~= nil and v[4].Parent ~= nil) then
                local v18 = v[2].CFrame * v[5].C1:Inverse();
                v[4].CFrame = RaycastHelper.ResolveCarryRelease(v[2].CFrame.Position, v18, v[3].Position);
            end;

            table.remove(u1, i);
            u2 = u2 - 1;

            if u2 == 0 then
                RunService:UnbindFromRenderStep("ouw-weld-render");

                return;
            end;

            break;
        end;
    end;
end;

CollectionService:GetInstanceAddedSignal("WeldPartThingOuw"):Connect(TagAdded);
CollectionService:GetInstanceRemovedSignal("WeldPartThingOuw"):Connect(TagRemoved);