-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid", 5);

if not Humanoid then
    return;
end;

local u1 = Humanoid:FindFirstChildOfClass("Animator") or Humanoid:WaitForChild("Animator", 5);

if not u1 then
    return;
end;

local u2 = 0;
local u3 = 0;
local u4 = {};
local u5 = setmetatable({}, {
    __mode = "k"
});
local u6 = setmetatable({}, {
    __mode = "k"
});
script_Parent:SetAttribute("ToolEquipLocked", false);

local function refreshToolLock() -- Line: 27
    -- upvalues: u4 (copy), u5 (copy), script_Parent (copy)
    local os_clock_ret = os.clock();
    local v7 = false;

    for i in pairs(u4) do
        if i.IsPlaying and os_clock_ret < (u5[i] or 0) then
            v7 = true;
        else
            u4[i] = nil;
            u5[i] = nil;
        end;
    end;

    script_Parent:SetAttribute("ToolEquipLocked", v7);
end;

local function isLocomotionTrack(p8) -- Line: 42
    local Animation = p8.Animation;
    local v9 = Animation and string.lower(Animation.Name) or "";

    return (v9 == "walk" or (v9 == "run" or (v9 == "idle" or (v9 == "jump" or (v9 == "fall" or (v9 == "climb" or (v9 == "swim" or v9 == "toolnone"))))))) and true or v9 == "toolnoneanim";
end;

local function captureTrack(u10) -- Line: 56
    -- upvalues: u4 (copy), u5 (copy), u2 (ref), u3 (ref), script_Parent (copy), refreshToolLock (copy)
    if not u4[u10] then
        local Animation = u10.Animation;
        local v11 = Animation and string.lower(Animation.Name) or "";

        if not (v11 == "walk" or (v11 == "run" or (v11 == "idle" or (v11 == "jump" or (v11 == "fall" or (v11 == "climb" or (v11 == "swim" or v11 == "toolnone")))))) or v11 == "toolnoneanim" or u10.Looped) then
            u4[u10] = true;
            local v12 = tonumber(u10.Length) or 0;
            u5[u10] = os.clock() + math.clamp(v12 + 0.75, 1, 4);
            u2 = 0;
            u3 = 0;
            script_Parent:SetAttribute("ToolEquipLocked", true);
            u10.Stopped:Connect(function() -- Line: 64
                -- upvalues: u4 (ref), u10 (copy), u5 (ref), refreshToolLock (ref)
                u4[u10] = nil;
                u5[u10] = nil;
                refreshToolLock();
            end);
        end;
    end;
end;

local function scanFreshTracks() -- Line: 71
    -- upvalues: u1 (copy), captureTrack (copy), u2 (ref)
    for _, v in ipairs(u1:GetPlayingAnimationTracks()) do
        if v.TimePosition <= 0.45 then
            captureTrack(v);

            if u2 == 0 then
                break;
            end;
        end;
    end;
end;

local function armCapture() -- Line: 85
    -- upvalues: script_Parent (copy), u2 (ref), u3 (ref), scanFreshTracks (copy)
    local os_clock_ret = os.clock();
    script_Parent:SetAttribute("ToolEquipLocked", true);
    u2 = math.max(u2, os_clock_ret + 1.5);
    u3 = math.max(u3, os_clock_ret + 0.18);
    task.defer(scanFreshTracks);
end;

RunService.Heartbeat:Connect(function() -- Line: 95
    -- upvalues: u2 (ref), scanFreshTracks (copy), u4 (copy), refreshToolLock (copy), u3 (ref), script_Parent (copy)
    local os_clock_ret = os.clock();

    if u2 > 0 then
        if os_clock_ret <= u2 then
            scanFreshTracks();
        else
            u2 = 0;
        end;
    end;

    if next(u4) ~= nil then
        refreshToolLock();
    end;

    if u3 > 0 and u3 <= os_clock_ret then
        u3 = 0;

        if next(u4) == nil then
            script_Parent:SetAttribute("ToolEquipLocked", false);
        end;
    elseif u2 == 0 and (next(u4) == nil and script_Parent:GetAttribute("ToolEquipLocked") == true) then
        script_Parent:SetAttribute("ToolEquipLocked", false);
    end;
end);
RunService.RenderStepped:Connect(function() -- Line: 124
    -- upvalues: script_Parent (copy), Humanoid (copy)
    if script_Parent:GetAttribute("ToolEquipLocked") ~= true then
        return;
    end;

    Humanoid:Move(Vector3.new(0, 0, 0), false);
    Humanoid.Jump = false;
    local HumanoidRootPart = script_Parent:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, HumanoidRootPart.AssemblyLinearVelocity.Y, 0);
    end;
end);

local function bindTool(p13) -- Line: 136
    -- upvalues: u6 (copy), armCapture (copy)
    if not p13:IsA("Tool") or u6[p13] then
        return;
    end;

    u6[p13] = true;
    p13.Equipped:Connect(armCapture);
    p13.Unequipped:Connect(armCapture);
end;

local v14 = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:WaitForChild("Backpack", 5);

if v14 then
    for _, child in ipairs(v14:GetChildren()) do
        if child:IsA("Tool") then
            if not u6[child] then
                u6[child] = true;
                child.Equipped:Connect(armCapture);
                child.Unequipped:Connect(armCapture);
            end;
        end;
    end;

    v14.ChildAdded:Connect(bindTool);
end;

for _, child in ipairs(script_Parent:GetChildren()) do
    if child:IsA("Tool") then
        if not u6[child] then
            u6[child] = true;
            child.Equipped:Connect(armCapture);
            child.Unequipped:Connect(armCapture);
        end;
    end;
end;

script_Parent.ChildAdded:Connect(bindTool);
u1.AnimationPlayed:Connect(function(p15) -- Line: 151
    -- upvalues: u2 (ref), captureTrack (copy)
    if os.clock() <= u2 then
        captureTrack(p15);
    end;
end);
Humanoid.Died:Connect(function() -- Line: 157
    -- upvalues: u4 (copy), u5 (copy), script_Parent (copy)
    table.clear(u4);
    table.clear(u5);
    script_Parent:SetAttribute("ToolEquipLocked", false);
end);
script.Destroying:Connect(function() -- Line: 163
    -- upvalues: script_Parent (copy)
    if script_Parent.Parent then
        script_Parent:SetAttribute("ToolEquipLocked", false);
    end;
end);