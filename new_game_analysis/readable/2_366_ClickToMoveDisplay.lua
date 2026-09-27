-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = "rbxasset://textures/ui/traildot.png";
local u3 = "rbxasset://textures/ui/waypoint.png";
local u4 = false;
local UDim2_new_ret = UDim2.new(0, 42, 0, 50);
local Vector2_new_ret = Vector2.new(0, 0.5);
local Vector2_new_ret2 = Vector2.new(0, 1);
local Vector2_new_ret3 = Vector2.new(0, 0.5);
local Vector2_new_ret4 = Vector2.new(0.1, 0.5);
local Vector2_new_ret5 = Vector2.new(-0.1, 0.5);
local Vector2_new_ret6 = Vector2.new(1.5, 1.5);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local UserFlag = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserRaycastUpdateAPI2");
local LocalPlayer = Players.LocalPlayer;

local function CreateWaypointTemplates() -- Line: 55
    -- upvalues: Vector2_new_ret6 (ref), u4 (ref), u2 (ref), UDim2_new_ret (copy), Vector2_new_ret (copy), u3 (ref), Vector2_new_ret3 (copy)
    local Part = Instance.new("Part");
    Part.Size = Vector3.new(1, 1, 1);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.Name = "TrailDot";
    Part.Transparency = 1;
    local ImageHandleAdornment = Instance.new("ImageHandleAdornment");
    ImageHandleAdornment.Name = "TrailDotImage";
    ImageHandleAdornment.Size = Vector2_new_ret6;
    ImageHandleAdornment.SizeRelativeOffset = Vector3.new(0, 0, -0.1);
    ImageHandleAdornment.AlwaysOnTop = u4;
    ImageHandleAdornment.Image = u2;
    ImageHandleAdornment.Adornee = Part;
    ImageHandleAdornment.Parent = Part;
    local Part2 = Instance.new("Part");
    Part2.Size = Vector3.new(2, 2, 2);
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.Name = "EndWaypoint";
    Part2.Transparency = 1;
    local ImageHandleAdornment2 = Instance.new("ImageHandleAdornment");
    ImageHandleAdornment2.Name = "TrailDotImage";
    ImageHandleAdornment2.Size = Vector2_new_ret6;
    ImageHandleAdornment2.SizeRelativeOffset = Vector3.new(0, 0, -0.1);
    ImageHandleAdornment2.AlwaysOnTop = u4;
    ImageHandleAdornment2.Image = u2;
    ImageHandleAdornment2.Adornee = Part2;
    ImageHandleAdornment2.Parent = Part2;
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "EndWaypointBillboard";
    BillboardGui.Size = UDim2_new_ret;
    BillboardGui.LightInfluence = 0;
    BillboardGui.SizeOffset = Vector2_new_ret;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.Adornee = Part2;
    BillboardGui.Parent = Part2;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Image = u3;
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Size = UDim2.new(1, 0, 1, 0);
    ImageLabel.Parent = BillboardGui;
    local Part3 = Instance.new("Part");
    Part3.Size = Vector3.new(2, 2, 2);
    Part3.Anchored = true;
    Part3.CanCollide = false;
    Part3.Name = "FailureWaypoint";
    Part3.Transparency = 1;
    local ImageHandleAdornment3 = Instance.new("ImageHandleAdornment");
    ImageHandleAdornment3.Name = "TrailDotImage";
    ImageHandleAdornment3.Size = Vector2_new_ret6;
    ImageHandleAdornment3.SizeRelativeOffset = Vector3.new(0, 0, -0.1);
    ImageHandleAdornment3.AlwaysOnTop = u4;
    ImageHandleAdornment3.Image = u2;
    ImageHandleAdornment3.Adornee = Part3;
    ImageHandleAdornment3.Parent = Part3;
    local BillboardGui2 = Instance.new("BillboardGui");
    BillboardGui2.Name = "FailureWaypointBillboard";
    BillboardGui2.Size = UDim2_new_ret;
    BillboardGui2.LightInfluence = 0;
    BillboardGui2.SizeOffset = Vector2_new_ret3;
    BillboardGui2.AlwaysOnTop = true;
    BillboardGui2.Adornee = Part3;
    BillboardGui2.Parent = Part3;
    local Frame = Instance.new("Frame");
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.new(0, 0, 0, 0);
    Frame.Position = UDim2.new(0.5, 0, 1, 0);
    Frame.Parent = BillboardGui2;
    local ImageLabel2 = Instance.new("ImageLabel");
    ImageLabel2.Image = u3;
    ImageLabel2.BackgroundTransparency = 1;
    ImageLabel2.Position = UDim2.new(0, -UDim2_new_ret.X.Offset / 2, 0, -UDim2_new_ret.Y.Offset);
    ImageLabel2.Size = UDim2_new_ret;
    ImageLabel2.Parent = Frame;

    return Part, Part2, Part3;
end;

local u5, u6, u7 = CreateWaypointTemplates();

local function getTrailDotParent() -- Line: 141
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local ClickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay");

    if not ClickToMoveDisplay then
        ClickToMoveDisplay = Instance.new("Model");
        ClickToMoveDisplay.Name = "ClickToMoveDisplay";
        ClickToMoveDisplay.Parent = CurrentCamera;
    end;

    return ClickToMoveDisplay;
end;

local function placePathWaypoint(p8: any, p9: vector) -- Line: 152
    -- upvalues: UserFlag (copy), RaycastParams_new_ret (copy), Workspace (copy), LocalPlayer (copy)
    if UserFlag then
        RaycastParams_new_ret.FilterDescendantsInstances = { Workspace.CurrentCamera, LocalPlayer.Character };
        local v10 = Workspace:Raycast(p9 + Vector3.new(0, 2.5, 0), Vector3.new(-0, -10, -0), RaycastParams_new_ret);

        if v10 then
            p8.CFrame = CFrame.lookAlong(v10.Position, v10.Normal);
            local CurrentCamera = Workspace.CurrentCamera;
            local ClickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay");

            if not ClickToMoveDisplay then
                ClickToMoveDisplay = Instance.new("Model");
                ClickToMoveDisplay.Name = "ClickToMoveDisplay";
                ClickToMoveDisplay.Parent = CurrentCamera;
            end;

            p8.Parent = ClickToMoveDisplay;
        end;
    else
        local v11, v12, v13 = Workspace:FindPartOnRayWithIgnoreList(Ray.new(p9 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)), { Workspace.CurrentCamera, LocalPlayer.Character });

        if v11 then
            p8.CFrame = CFrame.new(v12, v12 + v13);
            local CurrentCamera = Workspace.CurrentCamera;
            local ClickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay");

            if not ClickToMoveDisplay then
                ClickToMoveDisplay = Instance.new("Model");
                ClickToMoveDisplay.Name = "ClickToMoveDisplay";
                ClickToMoveDisplay.Parent = CurrentCamera;
            end;

            p8.Parent = ClickToMoveDisplay;
        end;
    end;
end;

local u14 = {};
u14.__index = u14;

function u14.Destroy(p15) -- Line: 177
    p15.DisplayModel:Destroy();
end;

function u14.NewDisplayModel(p16, p17) -- Line: 181
    -- upvalues: u5 (ref), placePathWaypoint (copy)
    local v18 = u5:Clone();
    placePathWaypoint(v18, p17);

    return v18;
end;

function u14.new(p19, p20) -- Line: 187
    -- upvalues: u14 (copy)
    local v21 = setmetatable({}, u14);
    v21.DisplayModel = v21:NewDisplayModel(p19);
    v21.ClosestWayPoint = p20;

    return v21;
end;

local u22 = {};
u22.__index = u22;

function u22.Destroy(p23) -- Line: 199
    p23.Destroyed = true;
    p23.Tween:Cancel();
    p23.DisplayModel:Destroy();
end;

function u22.NewDisplayModel(p24, p25) -- Line: 205
    -- upvalues: u6 (ref), placePathWaypoint (copy)
    local v26 = u6:Clone();
    placePathWaypoint(v26, p25);

    return v26;
end;

function u22.CreateTween(p27) -- Line: 211
    -- upvalues: TweenService (copy), Vector2_new_ret2 (copy)
    local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true);
    local v28 = TweenService:Create(p27.DisplayModel.EndWaypointBillboard, TweenInfo_new_ret, {
        SizeOffset = Vector2_new_ret2
    });
    v28:Play();

    return v28;
end;

function u22.TweenInFrom(p29: table, p30: vector) -- Line: 222
    -- upvalues: TweenService (copy)
    p29.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, (p30 - p29.DisplayModel.Position).Y, 0);
    local TweenInfo_new_ret = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
    local v31 = TweenService:Create(p29.DisplayModel.EndWaypointBillboard, TweenInfo_new_ret, {
        StudsOffset = Vector3.new(0, 0, 0)
    });
    v31:Play();

    return v31;
end;

function u22.new(p32: vector, p33: number?, p34: vector?) -- Line: 236
    -- upvalues: u22 (copy)
    local u35 = setmetatable({}, u22);
    u35.DisplayModel = u35:NewDisplayModel(p32);
    u35.Destroyed = false;

    if p34 and (p34 - p32).Magnitude > 5 then
        u35.Tween = u35:TweenInFrom(p34);
        coroutine.wrap(function() -- Line: 243
            -- upvalues: u35 (copy)
            u35.Tween.Completed:Wait();

            if not u35.Destroyed then
                u35.Tween = u35:CreateTween();
            end;
        end)();
    else
        u35.Tween = u35:CreateTween();
    end;

    u35.ClosestWayPoint = p33;

    return u35;
end;

local u36 = {};
u36.__index = u36;

function u36.Hide(p37) -- Line: 260
    p37.DisplayModel.Parent = nil;
end;

function u36.Destroy(p38) -- Line: 264
    p38.DisplayModel:Destroy();
end;

function u36.NewDisplayModel(p39, p40) -- Line: 268
    -- upvalues: u7 (ref), placePathWaypoint (copy), UserFlag (copy), RaycastParams_new_ret (copy), Workspace (copy), LocalPlayer (copy)
    local v41 = u7:Clone();
    placePathWaypoint(v41, p40);

    if UserFlag then
        RaycastParams_new_ret.FilterDescendantsInstances = { Workspace.CurrentCamera, LocalPlayer.Character };
        local v42 = Workspace:Raycast(p40 + Vector3.new(0, 2.5, 0), Vector3.new(-0, -10, -0), RaycastParams_new_ret);

        if v42 then
            v41.CFrame = CFrame.lookAlong(v42.Position, v42.Normal);
            local CurrentCamera = Workspace.CurrentCamera;
            local ClickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay");

            if not ClickToMoveDisplay then
                ClickToMoveDisplay = Instance.new("Model");
                ClickToMoveDisplay.Name = "ClickToMoveDisplay";
                ClickToMoveDisplay.Parent = CurrentCamera;
            end;

            v41.Parent = ClickToMoveDisplay;

            return v41;
        end;
    else
        local v43, v44, v45 = Workspace:FindPartOnRayWithIgnoreList(Ray.new(p40 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0)), { Workspace.CurrentCamera, LocalPlayer.Character });

        if v43 then
            v41.CFrame = CFrame.new(v44, v44 + v45);
            local CurrentCamera = Workspace.CurrentCamera;
            local ClickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay");

            if not ClickToMoveDisplay then
                ClickToMoveDisplay = Instance.new("Model");
                ClickToMoveDisplay.Name = "ClickToMoveDisplay";
                ClickToMoveDisplay.Parent = CurrentCamera;
            end;

            v41.Parent = ClickToMoveDisplay;
        end;
    end;

    return v41;
end;

function u36.RunFailureTween(p46) -- Line: 292
    -- upvalues: TweenService (copy), Vector2_new_ret4 (copy), Vector2_new_ret5 (copy), Vector2_new_ret3 (copy)
    wait(0.125);
    local TweenInfo_new_ret = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
    local v47 = TweenService:Create(p46.DisplayModel.FailureWaypointBillboard, TweenInfo_new_ret, {
        SizeOffset = Vector2_new_ret4
    });
    v47:Play();
    TweenService:Create(p46.DisplayModel.FailureWaypointBillboard.Frame, TweenInfo_new_ret, {
        Rotation = 10
    }):Play();
    v47.Completed:wait();
    local TweenInfo_new_ret2 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true);
    local v48 = TweenService:Create(p46.DisplayModel.FailureWaypointBillboard, TweenInfo_new_ret2, {
        SizeOffset = Vector2_new_ret5
    });
    v48:Play();
    local TweenInfo_new_ret3 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true);
    TweenService:Create(p46.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, TweenInfo_new_ret3, {
        ImageColor3 = Color3.new(0.75, 0.75, 0.75)
    }):Play();
    TweenService:Create(p46.DisplayModel.FailureWaypointBillboard.Frame, TweenInfo_new_ret3, {
        Rotation = -10
    }):Play();
    v48.Completed:wait();
    local TweenInfo_new_ret4 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
    local v49 = TweenService:Create(p46.DisplayModel.FailureWaypointBillboard, TweenInfo_new_ret4, {
        SizeOffset = Vector2_new_ret3
    });
    v49:Play();
    TweenService:Create(p46.DisplayModel.FailureWaypointBillboard.Frame, TweenInfo_new_ret4, {
        Rotation = 0
    }):Play();
    v49.Completed:wait();
    wait(0.125);
end;

function u36.new(p50) -- Line: 341
    -- upvalues: u36 (copy)
    local v51 = setmetatable({}, u36);
    v51.DisplayModel = v51:NewDisplayModel(p50);

    return v51;
end;

local Animation = Instance.new("Animation");
Animation.AnimationId = "rbxassetid://2874840706";
local u52 = nil;

local function getFailureAnimationTrack(p53) -- Line: 355
    -- upvalues: u52 (ref), Animation (copy)
    if p53 == nil then
        return u52;
    end;

    u52 = p53:LoadAnimation(Animation);
    assert(u52, "");
    u52.Priority = Enum.AnimationPriority.Action;
    u52.Looped = false;

    return u52;
end;

local function findPlayerHumanoid() -- Line: 366
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChildOfClass("Humanoid");
    end;
end;

local function createTrailDots(p54: table, p55: vector) -- Line: 373
    -- upvalues: u14 (copy), u22 (copy)
    local v56 = {};
    local v57 = 1;

    for i = 1, #p54 - 1 do
        local v58 = (p54[i].Position - p54[#p54].Position).Magnitude < 3;
        local v59;

        if i % 2 == 0 then
            v59 = not v58;
        else
            v59 = false;
        end;

        local v60;

        if v59 then
            v56[v57] = u14.new(p54[i].Position, i);
            v57 = v57 + 1;
            v60 = i;
        else
            v60 = i;
        end;
    end;

    local v61 = u22.new(p54[#p54].Position, #p54, p55);
    table.insert(v56, v61);
    local v62 = {};
    local v63 = 1;

    for i = #v56, 1, -1 do
        v62[v63] = v56[i];
        v63 = v63 + 1;
        local _ = i;
    end;

    return v62;
end;

local function getTrailDotScale(p64: number, p65) -- Line: 398
    return p65 * (math.clamp(p64 - 10, 0, 90) / 90 * 1.5 + 1);
end;

local u66 = 0;

function v1.CreatePathDisplay(u67, p68) -- Line: 407
    -- upvalues: u66 (ref), createTrailDots (copy), RunService (copy), Workspace (copy), Vector2_new_ret6 (ref)
    u66 = u66 + 1;
    local u69 = createTrailDots(u67, p68);

    local function removePathBeforePoint(p70) -- Line: 411
        -- upvalues: u69 (copy)
        for i = #u69, 1, -1 do
            local v71 = u69[i];

            if v71.ClosestWayPoint > p70 then
                break;
            end;

            v71:Destroy();
            u69[i] = nil;
            local _ = i;
        end;
    end;

    local u72 = "ClickToMoveResizeTrail" .. u66;
    RunService:BindToRenderStep(u72, Enum.RenderPriority.Camera.Value - 1, function() -- Line: 425, Name: resizeTrailDots
        -- upvalues: u69 (copy), RunService (ref), u72 (copy), Workspace (ref), Vector2_new_ret6 (ref)
        if #u69 == 0 then
            RunService:UnbindFromRenderStep(u72);

            return;
        end;

        local Position = Workspace.CurrentCamera.CFrame.Position;

        for i = 1, #u69 do
            local TrailDotImage = u69[i].DisplayModel:FindFirstChild("TrailDotImage");
            local v73;

            if TrailDotImage then
                TrailDotImage.Size = Vector2_new_ret6 * (math.clamp((u69[i].DisplayModel.Position - Position).Magnitude - 10, 0, 90) / 90 * 1.5 + 1);
                v73 = i;
            else
                v73 = i;
            end;
        end;
    end);

    return function() -- Line: 441, Name: removePath
        -- upvalues: removePathBeforePoint (copy), u67 (copy)
        removePathBeforePoint(#u67);
    end, removePathBeforePoint;
end;

local u74 = nil;

function v1.DisplayFailureWaypoint(p75) -- Line: 449
    -- upvalues: u74 (ref), u36 (copy)
    if u74 then
        u74:Hide();
    end;

    local u76 = u36.new(p75);
    u74 = u76;
    coroutine.wrap(function() -- Line: 455
        -- upvalues: u76 (ref)
        u76:RunFailureTween();
        u76:Destroy();
        u76 = nil;
    end)();
end;

function v1.CreateEndWaypoint(p77) -- Line: 462
    -- upvalues: u22 (copy)
    return u22.new(p77);
end;

function v1.PlayFailureAnimation() -- Line: 466
    -- upvalues: LocalPlayer (copy), u52 (ref), Animation (copy)
    local Character = LocalPlayer.Character;
    local v78;

    if Character then
        v78 = Character:FindFirstChildOfClass("Humanoid");
    else
        v78 = nil;
    end;

    if v78 then
        local v79;

        if v78 == nil then
            v79 = u52;
        else
            u52 = v78:LoadAnimation(Animation);
            assert(u52, "");
            u52.Priority = Enum.AnimationPriority.Action;
            u52.Looped = false;
            v79 = u52;
        end;

        v79:Play();
    end;
end;

function v1.CancelFailureAnimation() -- Line: 474
    -- upvalues: u52 (ref)
    if u52 ~= nil and u52.IsPlaying then
        u52:Stop();
    end;
end;

function v1.SetWaypointTexture(p80) -- Line: 480
    -- upvalues: u2 (ref), u5 (ref), u6 (ref), u7 (ref), CreateWaypointTemplates (copy)
    u2 = p80;
    local v81, v82, v83 = CreateWaypointTemplates();
    u5 = v81;
    u6 = v82;
    u7 = v83;
end;

function v1.GetWaypointTexture() -- Line: 485
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.SetWaypointRadius(p84) -- Line: 489
    -- upvalues: Vector2_new_ret6 (ref), u5 (ref), u6 (ref), u7 (ref), CreateWaypointTemplates (copy)
    Vector2_new_ret6 = Vector2.new(p84, p84);
    local v85, v86, v87 = CreateWaypointTemplates();
    u5 = v85;
    u6 = v86;
    u7 = v87;
end;

function v1.GetWaypointRadius() -- Line: 494
    -- upvalues: Vector2_new_ret6 (ref)
    return Vector2_new_ret6.X;
end;

function v1.SetEndWaypointTexture(p88) -- Line: 498
    -- upvalues: u3 (ref), u5 (ref), u6 (ref), u7 (ref), CreateWaypointTemplates (copy)
    u3 = p88;
    local v89, v90, v91 = CreateWaypointTemplates();
    u5 = v89;
    u6 = v90;
    u7 = v91;
end;

function v1.GetEndWaypointTexture() -- Line: 503
    -- upvalues: u3 (ref)
    return u3;
end;

function v1.SetWaypointsAlwaysOnTop(p92) -- Line: 507
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u7 (ref), CreateWaypointTemplates (copy)
    u4 = p92;
    local v93, v94, v95 = CreateWaypointTemplates();
    u5 = v93;
    u6 = v94;
    u7 = v95;
end;

function v1.GetWaypointsAlwaysOnTop() -- Line: 512
    -- upvalues: u4 (ref)
    return u4;
end;

return v1;