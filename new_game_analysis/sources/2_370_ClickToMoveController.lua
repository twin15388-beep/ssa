-- Decompiled with Potassium's decompiler.

local success, result = pcall(function() -- Line: 10
    return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding");
end);
local u1 = success and result;
local success2, result2 = pcall(function() -- Line: 14
    return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2");
end);
local u2 = success2 and result2;
local UserInputService = game:GetService("UserInputService");
local PathfindingService = game:GetService("PathfindingService");
local Players = game:GetService("Players");
game:GetService("Debris");
local Workspace = game:GetService("Workspace");
local CollectionService = game:GetService("CollectionService");
local GuiService = game:GetService("GuiService");
local v3 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local UserFlag = v3.getUserFlag("UserRaycastUpdateAPI2");
local UserFlag2 = v3.getUserFlag("UserPlayerScriptsCTMDirectPlayerData");
local UserFlag3 = v3.getUserFlag("UserPSIASClickToMoveRelaxTeleport");
local UserFlag4 = v3.getUserFlag("UserPlayerScriptsRefactor2");
local UserFlag5 = v3.getUserFlag("UserPlayerScriptsFireThroughScriptableBindings");
local UserFlag6 = v3.getUserFlag("UserPlayerScriptsSAuthDirectAPIs2");
local UserFlag7 = v3.getUserFlag("UserDoubleJumpButtonFix");
local CharacterContext = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CharacterContext");
local ClickToMoveAction = CharacterContext:WaitForChild("ClickToMoveAction");
local ClickToMovePositionAction = CharacterContext:WaitForChild("ClickToMovePositionAction");
local u4 = true;
local u5 = true;
local u6 = false;
local u7 = 1;
local u8 = 8;
local LocalPlayer = Players.LocalPlayer;
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"));
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local u9 = {};

if not UserFlag then
    local function FindCharacterAncestor(p10) -- Line: 66
        -- upvalues: FindCharacterAncestor (copy)
        if p10 then
            local v11 = p10:FindFirstChildOfClass("Humanoid");

            if v11 then
                return p10, v11;
            end;

            return FindCharacterAncestor(p10.Parent);
        end;
    end;

    u9.FindCharacterAncestor = FindCharacterAncestor;

    local function Raycast(p12: any, p13: boolean, p14: table) -- Line: 78
        -- upvalues: Workspace (copy), FindCharacterAncestor (copy), Raycast (copy)
        local v15 = p14 or {};
        local v16, v17, v18, v19 = Workspace:FindPartOnRayWithIgnoreList(p12, v15);

        if not v16 then
            return nil, nil;
        end;

        if p13 and v16.CanCollide == false then
            local v20;

            if v16 then
                v20 = v16:FindFirstChildOfClass("Humanoid");

                if not v20 then
                    local v21;
                    v21, v20 = FindCharacterAncestor(v16.Parent);
                end;
            else
                v20 = nil;
            end;

            if v20 == nil then
                table.insert(v15, v16);

                return Raycast(p12, p13, v15);
            end;
        end;

        return v16, v17, v18, v19;
    end;

    u9.Raycast = Raycast;
end;

local u22 = {};

local function findPlayerHumanoid(p23: userdata) -- Line: 100
    -- upvalues: u22 (copy)
    local v24;

    if p23 then
        v24 = p23.Character;
    else
        v24 = p23;
    end;

    if v24 then
        local v25 = u22[p23];

        if v25 and v25.Parent == v24 then
            return v25;
        end;

        u22[p23] = nil;
        local v26 = v24:FindFirstChildOfClass("Humanoid");

        if v26 then
            u22[p23] = v26;
        end;

        return v26;
    end;
end;

local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;

local function GetCharacter() -- Line: 124
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer and LocalPlayer.Character;
end;

local function UpdateIgnoreTag(p31) -- Line: 128
    -- upvalues: u28 (ref), u29 (ref), u30 (ref), u27 (ref), LocalPlayer (copy), CollectionService (copy)
    if p31 == u28 then
        return;
    end;

    if u29 then
        u29:Disconnect();
        u29 = nil;
    end;

    if u30 then
        u30:Disconnect();
        u30 = nil;
    end;

    u28 = p31;
    local v32 = {};
    v32[1] = LocalPlayer and LocalPlayer.Character;
    u27 = v32;

    if u28 ~= nil then
        local Tagged = CollectionService:GetTagged(u28);

        for _, v in ipairs(Tagged) do
            table.insert(u27, v);
        end;

        u29 = CollectionService:GetInstanceAddedSignal(u28):Connect(function(p33) -- Line: 148
            -- upvalues: u27 (ref)
            table.insert(u27, p33);
        end);
        u30 = CollectionService:GetInstanceRemovedSignal(u28):Connect(function(p34) -- Line: 152
            -- upvalues: u27 (ref)
            for i = 1, #u27 do
                if u27[i] == p34 then
                    u27[i] = u27[#u27];
                    table.remove(u27);

                    return;
                end;

                local _ = i;
            end;
        end);
    end;
end;

local function getIgnoreList() -- Line: 164
    -- upvalues: u27 (ref), LocalPlayer (copy)
    if u27 then
        return u27;
    end;

    u27 = {};
    assert(u27, "");
    table.insert(u27, LocalPlayer and LocalPlayer.Character);

    return u27;
end;

local function minV(p35: vector, p36: vector) -- Line: 174
    local math_min_ret = math.min(p35.X, p36.X);
    local math_min_ret2 = math.min(p35.Y, p36.Y);
    local math_min_ret3 = math.min(p35.Z, p36.Z);

    return Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
end;

local function maxV(p37, p38) -- Line: 177
    local math_max_ret = math.max(p37.X, p38.X);
    local math_max_ret2 = math.max(p37.Y, p38.Y);
    local math_max_ret3 = math.max(p37.Z, p38.Z);

    return Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
end;

local function getCollidableExtentsSize(p39: userdata?) -- Line: 180
    if p39 ~= nil and p39.PrimaryPart ~= nil then
        assert(p39, "");
        assert(p39.PrimaryPart, "");
        local v40 = p39.PrimaryPart.CFrame:Inverse();
        local v41 = Vector3.new(inf, inf, inf);
        local v42 = Vector3.new(-inf, -inf, -inf);

        for _, descendant in pairs(p39:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.CanCollide then
                local v43 = v40 * descendant.CFrame;
                local Vector3_new_ret = Vector3.new(descendant.Size.X / 2, descendant.Size.Y / 2, descendant.Size.Z / 2);
                local v44 = {
                    Vector3.new(Vector3_new_ret.X, Vector3_new_ret.Y, Vector3_new_ret.Z),
                    Vector3.new(Vector3_new_ret.X, Vector3_new_ret.Y, -Vector3_new_ret.Z),
                    Vector3.new(Vector3_new_ret.X, -Vector3_new_ret.Y, Vector3_new_ret.Z),
                    Vector3.new(Vector3_new_ret.X, -Vector3_new_ret.Y, -Vector3_new_ret.Z),
                    Vector3.new(-Vector3_new_ret.X, Vector3_new_ret.Y, Vector3_new_ret.Z),
                    Vector3.new(-Vector3_new_ret.X, Vector3_new_ret.Y, -Vector3_new_ret.Z),
                    Vector3.new(-Vector3_new_ret.X, -Vector3_new_ret.Y, Vector3_new_ret.Z),
                    (Vector3.new(-Vector3_new_ret.X, -Vector3_new_ret.Y, -Vector3_new_ret.Z))
                };

                for _, v in ipairs(v44) do
                    local v45 = v43 * v;
                    local math_min_ret = math.min(v41.X, v45.X);
                    local math_min_ret2 = math.min(v41.Y, v45.Y);
                    local math_min_ret3 = math.min(v41.Z, v45.Z);
                    v41 = Vector3.new(math_min_ret, math_min_ret2, math_min_ret3);
                    local math_max_ret = math.max(v42.X, v45.X);
                    local math_max_ret2 = math.max(v42.Y, v45.Y);
                    local math_max_ret3 = math.max(v42.Z, v45.Z);
                    v42 = Vector3.new(math_max_ret, math_max_ret2, math_max_ret3);
                end;
            end;
        end;

        local v46 = v42 - v41;

        if v46.X < 0 or (v46.Y < 0 or v46.Z < 0) then
            return nil;
        end;

        return v46;
    end;
end;

local function Pather(p47: any, p48: any, p49: boolean?) -- Line: 215
    -- upvalues: u6 (ref), LocalPlayer (copy), u22 (copy), u7 (ref), u1 (copy), getCollidableExtentsSize (copy), u2 (copy), PathfindingService (copy), u4 (ref), ClickToMoveDisplay (copy), u8 (ref), UserFlag3 (copy), UserFlag (copy), RaycastParams_new_ret (copy), u27 (ref), Workspace (copy)
    local u50 = {};
    local v51;

    if p49 == nil then
        v51 = u6;
        p49 = true;
    else
        v51 = p49;
    end;

    u50.Cancelled = false;
    u50.Started = false;
    u50.Finished = Instance.new("BindableEvent");
    u50.PathFailed = Instance.new("BindableEvent");
    u50.PathComputing = false;
    u50.PathComputed = false;
    u50.OriginalTargetPoint = p47;
    u50.TargetPoint = p47;
    u50.TargetSurfaceNormal = p48;
    u50.DiedConn = nil;
    u50.SeatedConn = nil;
    u50.BlockedConn = nil;
    u50.TeleportedConn = nil;
    u50.CurrentPoint = 0;
    u50.HumanoidOffsetFromPath = Vector3.new(0, 0, 0);
    u50.CurrentWaypointPosition = nil;
    u50.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
    u50.CurrentWaypointPlaneDistance = 0;
    u50.CurrentWaypointNeedsJump = false;
    u50.CurrentHumanoidPosition = Vector3.new(0, 0, 0);
    u50.CurrentHumanoidVelocity = 0;
    u50.NextActionMoveDirection = Vector3.new(0, 0, 0);
    u50.NextActionJump = false;
    u50.Timeout = 0;
    local v52 = LocalPlayer;
    local v53;

    if v52 then
        v53 = v52.Character;
    else
        v53 = v52;
    end;

    local v54;

    if v53 then
        v54 = u22[v52];

        if not v54 or v54.Parent ~= v53 then
            u22[v52] = nil;
            v54 = v53:FindFirstChildOfClass("Humanoid");

            if v54 then
                u22[v52] = v54;
            end;
        end;
    else
        v54 = nil;
    end;

    u50.Humanoid = v54;
    u50.OriginPoint = nil;
    u50.AgentCanFollowPath = false;
    u50.DirectPath = false;
    u50.DirectPathRiseFirst = false;
    u50.stopTraverseFunc = nil;
    u50.setPointFunc = nil;
    u50.pointList = nil;
    local v55 = u50.Humanoid and u50.Humanoid.RootPart;

    if v55 then
        u50.OriginPoint = v55.CFrame.Position;
        local v56 = 2;
        local v57 = 5;
        local v58 = true;
        local SeatPart = u50.Humanoid.SeatPart;

        if SeatPart and SeatPart:IsA("VehicleSeat") then
            local v59 = SeatPart:FindFirstAncestorOfClass("Model");

            if v59 then
                local PrimaryPart = v59.PrimaryPart;
                v59.PrimaryPart = SeatPart;

                if p49 then
                    local ExtentsSize = v59:GetExtentsSize();
                    v56 = u7 * 0.5 * math.sqrt(ExtentsSize.X * ExtentsSize.X + ExtentsSize.Z * ExtentsSize.Z);
                    v57 = u7 * ExtentsSize.Y;
                    u50.AgentCanFollowPath = true;
                    u50.DirectPath = p49;
                    v58 = false;
                end;

                v59.PrimaryPart = PrimaryPart;
            end;
        else
            local v60 = nil;

            if u1 then
                local v61 = LocalPlayer and LocalPlayer.Character;

                if v61 ~= nil then
                    v60 = getCollidableExtentsSize(v61);
                end;
            end;

            if v60 == nil then
                v60 = (LocalPlayer and LocalPlayer.Character):GetExtentsSize();
            end;

            assert(v60, "");
            v56 = u7 * 0.5 * math.sqrt(v60.X * v60.X + v60.Z * v60.Z);
            v57 = u7 * v60.Y;
            v58 = u50.Humanoid.JumpPower > 0;
            u50.AgentCanFollowPath = true;
            u50.DirectPath = v51;
            u50.DirectPathRiseFirst = u50.Humanoid.Sit;
        end;

        if u2 then
            u50.pathResult = PathfindingService:CreatePath({
                AgentCanClimb = true,
                AgentRadius = v56,
                AgentHeight = v57,
                AgentCanJump = v58
            });
        else
            u50.pathResult = PathfindingService:CreatePath({
                AgentRadius = v56,
                AgentHeight = v57,
                AgentCanJump = v58
            });
        end;
    end;

    function u50.Cleanup(p62) -- Line: 333
        -- upvalues: u50 (copy)
        if u50.stopTraverseFunc then
            u50.stopTraverseFunc();
            u50.stopTraverseFunc = nil;
        end;

        if u50.BlockedConn then
            u50.BlockedConn:Disconnect();
            u50.BlockedConn = nil;
        end;

        if u50.DiedConn then
            u50.DiedConn:Disconnect();
            u50.DiedConn = nil;
        end;

        if u50.SeatedConn then
            u50.SeatedConn:Disconnect();
            u50.SeatedConn = nil;
        end;

        if u50.TeleportedConn then
            u50.TeleportedConn:Disconnect();
            u50.TeleportedConn = nil;
        end;

        u50.Started = false;
    end;

    function u50.Cancel(p63) -- Line: 362
        -- upvalues: u50 (copy)
        u50.Cancelled = true;
        u50:Cleanup();
    end;

    function u50.IsActive(p64) -- Line: 367
        -- upvalues: u50 (copy)
        return u50.AgentCanFollowPath and u50.Started and not u50.Cancelled;
    end;

    function u50.OnPathInterrupted(p65) -- Line: 371
        -- upvalues: u50 (copy)
        u50.Cancelled = true;
        u50:OnPointReached(false);
    end;

    function u50.ComputePath(p66) -- Line: 377
        -- upvalues: u50 (copy)
        if u50.OriginPoint then
            if u50.PathComputed or u50.PathComputing then
                return;
            end;

            u50.PathComputing = true;

            if u50.AgentCanFollowPath then
                if u50.DirectPath then
                    u50.pointList = { PathWaypoint.new(u50.OriginPoint, Enum.PathWaypointAction.Walk), PathWaypoint.new(u50.TargetPoint, u50.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk) };
                    u50.PathComputed = true;
                else
                    u50.pathResult:ComputeAsync(u50.OriginPoint, u50.TargetPoint);
                    u50.pointList = u50.pathResult:GetWaypoints();
                    u50.BlockedConn = u50.pathResult.Blocked:Connect(function(p67) -- Line: 391
                        -- upvalues: u50 (ref)
                        u50:OnPathBlocked(p67);
                    end);
                    u50.PathComputed = u50.pathResult.Status == Enum.PathStatus.Success;
                end;
            end;

            u50.PathComputing = false;
        end;
    end;

    function u50.IsValidPath(p68) -- Line: 399
        -- upvalues: u50 (copy)
        u50:ComputePath();

        return u50.PathComputed and u50.AgentCanFollowPath;
    end;

    u50.Recomputing = false;

    function u50.OnPathBlocked(p69, p70) -- Line: 405
        -- upvalues: u50 (copy), u4 (ref), ClickToMoveDisplay (ref)
        if u50.CurrentPoint > p70 or u50.Recomputing then
            return;
        end;

        u50.Recomputing = true;

        if u50.stopTraverseFunc then
            u50.stopTraverseFunc();
            u50.stopTraverseFunc = nil;
        end;

        u50.OriginPoint = u50.Humanoid.RootPart.CFrame.Position;
        u50.pathResult:ComputeAsync(u50.OriginPoint, u50.TargetPoint);
        u50.pointList = u50.pathResult:GetWaypoints();

        if #u50.pointList > 0 then
            u50.HumanoidOffsetFromPath = u50.pointList[1].Position - u50.OriginPoint;
        end;

        u50.PathComputed = u50.pathResult.Status == Enum.PathStatus.Success;

        if u4 then
            local v71, v72 = ClickToMoveDisplay.CreatePathDisplay(u50.pointList);
            u50.stopTraverseFunc = v71;
            u50.setPointFunc = v72;
        end;

        if u50.PathComputed then
            u50.CurrentPoint = 1;
            u50:OnPointReached(true);
        else
            u50.PathFailed:Fire();
            u50:Cleanup();
        end;

        u50.Recomputing = false;
    end;

    function u50.OnRenderStepped(p73: table, p74: number) -- Line: 441
        -- upvalues: u50 (copy), u8 (ref)
        if u50.Started and not u50.Cancelled then
            u50.Timeout = u50.Timeout + p74;

            if u8 < u50.Timeout then
                u50:OnPointReached(false);

                return;
            end;

            u50.CurrentHumanoidPosition = u50.Humanoid.RootPart.Position + u50.HumanoidOffsetFromPath;
            u50.CurrentHumanoidVelocity = u50.Humanoid.RootPart.Velocity;

            while u50.Started and u50:IsCurrentWaypointReached() do
                u50:OnPointReached(true);
            end;

            if u50.Started then
                u50.NextActionMoveDirection = u50.CurrentWaypointPosition - u50.CurrentHumanoidPosition;

                if u50.NextActionMoveDirection.Magnitude > 1e-6 then
                    u50.NextActionMoveDirection = u50.NextActionMoveDirection.Unit;
                else
                    u50.NextActionMoveDirection = Vector3.new(0, 0, 0);
                end;

                if u50.CurrentWaypointNeedsJump then
                    u50.NextActionJump = true;
                    u50.CurrentWaypointNeedsJump = false;

                    return;
                end;

                u50.NextActionJump = false;
            end;
        end;
    end;

    function u50.IsCurrentWaypointReached(p75) -- Line: 479
        -- upvalues: u50 (copy)
        local v76;

        if u50.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then
            v76 = true;
        else
            local v77 = u50.CurrentWaypointPlaneNormal:Dot(u50.CurrentHumanoidPosition) - u50.CurrentWaypointPlaneDistance;
            local v78 = 0.0625 * -u50.CurrentWaypointPlaneNormal:Dot(u50.CurrentHumanoidVelocity);
            v76 = v77 < math.max(1, v78);
        end;

        if v76 then
            u50.CurrentWaypointPosition = nil;
            u50.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u50.CurrentWaypointPlaneDistance = 0;
        end;

        return v76;
    end;

    function u50.OnPointReached(p79, p80) -- Line: 505
        -- upvalues: u50 (copy)
        if not p80 or u50.Cancelled then
            u50.PathFailed:Fire();
            u50:Cleanup();

            return;
        end;

        if u50.setPointFunc then
            u50.setPointFunc(u50.CurrentPoint);
        end;

        local v81 = u50.CurrentPoint + 1;

        if #u50.pointList < v81 then
            if u50.stopTraverseFunc then
                u50.stopTraverseFunc();
            end;

            u50.Finished:Fire();
            u50:Cleanup();

            return;
        end;

        local v82 = u50.pointList[u50.CurrentPoint];
        local v83 = u50.pointList[v81];
        local State = u50.Humanoid:GetState();

        if (State == Enum.HumanoidStateType.FallingDown or State == Enum.HumanoidStateType.Freefall) and true or State == Enum.HumanoidStateType.Jumping then
            local v84 = v83.Action == Enum.PathWaypointAction.Jump;

            if not v84 and u50.CurrentPoint > 1 then
                local v85 = v82.Position - u50.pointList[u50.CurrentPoint - 1].Position;
                local v86 = v83.Position - v82.Position;
                v84 = Vector2.new(v85.x, v85.z).Unit:Dot(Vector2.new(v86.x, v86.z).Unit) < 0.996;
            end;

            if v84 then
                u50.Humanoid.FreeFalling:Wait();
                wait(0.1);
            end;
        end;

        u50:MoveToNextWayPoint(v82, v83, v81);
    end;

    function u50.MoveToNextWayPoint(p87: table, p88: userdata, p89: userdata, p90: number) -- Line: 568
        -- upvalues: u50 (copy), u2 (ref)
        u50.CurrentWaypointPlaneNormal = p88.Position - p89.Position;

        if not u2 or p89.Label ~= "Climb" then
            u50.CurrentWaypointPlaneNormal = Vector3.new(u50.CurrentWaypointPlaneNormal.X, 0, u50.CurrentWaypointPlaneNormal.Z);
        end;

        if u50.CurrentWaypointPlaneNormal.Magnitude > 1e-6 then
            u50.CurrentWaypointPlaneNormal = u50.CurrentWaypointPlaneNormal.Unit;
            u50.CurrentWaypointPlaneDistance = u50.CurrentWaypointPlaneNormal:Dot(p89.Position);
        else
            u50.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0);
            u50.CurrentWaypointPlaneDistance = 0;
        end;

        u50.CurrentWaypointNeedsJump = p89.Action == Enum.PathWaypointAction.Jump;
        u50.CurrentWaypointPosition = p89.Position;
        u50.CurrentPoint = p90;
        u50.Timeout = 0;
    end;

    function u50.Start(p91, p92) -- Line: 600
        -- upvalues: u50 (copy), ClickToMoveDisplay (ref), u4 (ref), UserFlag3 (ref)
        if not u50.AgentCanFollowPath then
            u50.PathFailed:Fire();

            return;
        end;

        if u50.Started then
            return;
        end;

        u50.Started = true;
        ClickToMoveDisplay.CancelFailureAnimation();

        if u4 and (p92 == nil or p92) then
            local v93, v94 = ClickToMoveDisplay.CreatePathDisplay(u50.pointList, u50.OriginalTargetPoint);
            u50.stopTraverseFunc = v93;
            u50.setPointFunc = v94;
        end;

        if #u50.pointList <= 0 then
            u50.PathFailed:Fire();

            if u50.stopTraverseFunc then
                u50.stopTraverseFunc();
            end;

            return;
        end;

        u50.HumanoidOffsetFromPath = Vector3.new(0, u50.pointList[1].Position.Y - u50.OriginPoint.Y, 0);
        u50.CurrentHumanoidPosition = u50.Humanoid.RootPart.Position + u50.HumanoidOffsetFromPath;
        u50.CurrentHumanoidVelocity = u50.Humanoid.RootPart.Velocity;
        u50.SeatedConn = u50.Humanoid.Seated:Connect(function(p95, p96) -- Line: 627
            -- upvalues: u50 (ref)
            u50:OnPathInterrupted();
        end);
        u50.DiedConn = u50.Humanoid.Died:Connect(function() -- Line: 628
            -- upvalues: u50 (ref)
            u50:OnPathInterrupted();
        end);

        if UserFlag3 then
            u50.lastPosition = u50.Humanoid.RootPart.CFrame.Position;
            u50.TeleportedConn = u50.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 631
                -- upvalues: u50 (ref)
                local Position = u50.Humanoid.RootPart.CFrame.Position;
                local Magnitude = (Position - u50.lastPosition).Magnitude;
                u50.lastPosition = Position;

                if u50.Humanoid.WalkSpeed < Magnitude then
                    u50:OnPathInterrupted();
                end;
            end);
        else
            u50.TeleportedConn = u50.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function() -- Line: 640
                -- upvalues: u50 (ref)
                u50:OnPathInterrupted();
            end);
        end;

        u50.CurrentPoint = 1;
        u50:OnPointReached(true);
    end;

    local v97 = u50.TargetPoint + u50.TargetSurfaceNormal * 1.5;

    if UserFlag then
        local v98;

        if u27 then
            v98 = u27;
        else
            u27 = {};
            assert(u27, "");
            table.insert(u27, LocalPlayer and LocalPlayer.Character);
            v98 = u27;
        end;

        RaycastParams_new_ret.FilterDescendantsInstances = v98;
        local v99 = Workspace:Raycast(v97, Vector3.new(-0, -50, -0), RaycastParams_new_ret);

        if v99 then
            u50.TargetPoint = v99.Position;
        end;
    else
        local Ray_new_ret = Ray.new(v97, Vector3.new(0, -50, 0));
        local v100;

        if u27 then
            v100 = u27;
        else
            u27 = {};
            assert(u27, "");
            table.insert(u27, LocalPlayer and LocalPlayer.Character);
            v100 = u27;
        end;

        local v101, v102 = Workspace:FindPartOnRayWithIgnoreList(Ray_new_ret, v100);

        if v101 then
            u50.TargetPoint = v102;
        end;
    end;

    u50:ComputePath();

    return u50;
end;

local function CheckAlive() -- Line: 677
    -- upvalues: LocalPlayer (copy), u22 (copy)
    local v103 = LocalPlayer;
    local v104;

    if v103 then
        v104 = v103.Character;
    else
        v104 = v103;
    end;

    local v105;

    if v104 then
        v105 = u22[v103];

        if not v105 or v105.Parent ~= v104 then
            u22[v103] = nil;
            v105 = v104:FindFirstChildOfClass("Humanoid");

            if v105 then
                u22[v103] = v105;
            end;
        end;
    else
        v105 = nil;
    end;

    local v106;

    if v105 == nil then
        v106 = false;
    else
        v106 = v105.Health > 0;
    end;

    return v106;
end;

local function GetEquippedTool(p107: userdata?) -- Line: 682
    if p107 ~= nil then
        for _, child in pairs(p107:GetChildren()) do
            if child:IsA("Tool") then
                return child;
            end;
        end;
    end;
end;

local function DisconnectEvent(p108) -- Line: 692
    if p108 then
        p108:Disconnect();
    end;
end;

local function calculateLocalMoveVector(p109: vector) -- Line: 698
    -- upvalues: Workspace (copy)
    local Vector3_new_ret = Vector3.new(p109.X, 0, p109.Z);

    if Vector3_new_ret.Magnitude < 1e-6 then
        return Vector2.zero;
    end;

    local Unit = Vector3_new_ret.Unit;
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return Vector2.new(Unit.X, -Unit.Z);
    end;

    local _, v110, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ();
    local v111 = CFrame.Angles(0, v110, 0):VectorToObjectSpace(Unit);

    return Vector2.new(v111.X, -v111.Z);
end;

local u112 = {};
u112.__index = u112;

function u112.new(p113) -- Line: 717
    -- upvalues: u112 (copy), UserFlag7 (copy), UserFlag2 (copy)
    local v114 = setmetatable({}, u112);
    v114.mouse2DownTime = tick();
    v114.mouse2DownPos = Vector2.new();
    v114.mouse2UpTime = tick();
    v114.humanoidDiedConn = nil;
    v114.characterChildAddedConn = nil;
    v114.onCharacterAddedConn = nil;
    v114.characterChildRemovedConn = nil;
    v114.renderSteppedConn = nil;
    v114.menuOpenedConnection = nil;
    v114.preferredInputChangedConnection = nil;

    if not UserFlag7 then
        v114.jumpEnabled = true;
    end;

    v114.clickPressedConn = nil;
    v114.clickReleasedConn = nil;
    v114.shouldCleanupPath = false;

    if not UserFlag2 then
        v114.lastPatherMoveVector = Vector2.new(0, 0);
    end;

    v114.lastPatherJumped = false;
    v114.playerData = nil;
    v114.running = false;

    return v114;
end;

local u115 = nil;
local u116 = nil;
local u117 = nil;

function u112.CleanupPath(p118) -- Line: 755
    -- upvalues: u115 (ref), u116 (ref), u117 (ref)
    if u115 then
        u115:Cancel();
        u115 = nil;
    end;

    if u116 then
        u116:Disconnect();
        u116 = nil;
    end;

    if u117 then
        u117:Disconnect();
        u117 = nil;
    end;

    p118.shouldCleanupPath = true;
end;

function u112.HandleMoveTo(u119, p120, u121, u122, u123, u124) -- Line: 774
    -- upvalues: u115 (ref), u116 (ref), GetEquippedTool (copy), u117 (ref), u5 (ref), ClickToMoveDisplay (copy)
    u119.shouldCleanupPath = false;

    if u115 then
        u119:CleanupPath();
    end;

    u115 = p120;
    p120:Start(u124);
    u116 = p120.Finished.Event:Connect(function() -- Line: 783
        -- upvalues: u119 (copy), u122 (copy), GetEquippedTool (ref), u123 (copy)
        u119:CleanupPath();
        local v125 = u122 and GetEquippedTool(u123);

        if v125 then
            v125:Activate();
        end;
    end);
    u117 = p120.PathFailed.Event:Connect(function() -- Line: 792
        -- upvalues: u119 (copy), u124 (copy), u5 (ref), u115 (ref), ClickToMoveDisplay (ref), u121 (copy)
        u119:CleanupPath();

        if u124 == nil or u124 then
            local v126 = u5;

            if v126 then
                local v127 = u115 and u115:IsActive();
                v126 = not v127;
            end;

            if v126 then
                ClickToMoveDisplay.PlayFailureAnimation();
            end;

            ClickToMoveDisplay.DisplayFailureWaypoint(u121);
        end;
    end);
end;

function u112.ShowPathFailedFeedback(p128, p129) -- Line: 804
    -- upvalues: u115 (ref), u5 (ref), ClickToMoveDisplay (copy)
    if u115 and u115:IsActive() then
        u115:Cancel();
    end;

    if u5 then
        ClickToMoveDisplay.PlayFailureAnimation();
    end;

    ClickToMoveDisplay.DisplayFailureWaypoint(p129);
end;

function u112.OnTap(p130: table, p131: table, p132: vector?) -- Line: 814
    -- upvalues: Workspace (copy), LocalPlayer (copy), u22 (copy), UserFlag (copy), u27 (ref), RaycastParams_new_ret (copy), Pather (copy), u9 (copy), GetEquippedTool (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local Character = LocalPlayer.Character;
    local v133 = LocalPlayer;
    local v134;

    if v133 then
        v134 = v133.Character;
    else
        v134 = v133;
    end;

    local v135;

    if v134 then
        v135 = u22[v133];

        if not v135 or v135.Parent ~= v134 then
            u22[v133] = nil;
            v135 = v134:FindFirstChildOfClass("Humanoid");

            if v135 then
                u22[v133] = v135;
            end;
        end;
    else
        v135 = nil;
    end;

    local v136;

    if v135 == nil then
        v136 = false;
    else
        v136 = v135.Health > 0;
    end;

    if not v136 then
        return;
    end;

    if #p131 ~= 1 and not p132 then
        local v137 = #p131 >= 2 and (CurrentCamera and GetEquippedTool(Character));

        if v137 then
            v137:Activate();
        end;

        return;
    end;

    if not CurrentCamera then
        return;
    end;

    local v138 = CurrentCamera:ScreenPointToRay(p131[1].X, p131[1].Y);

    if not UserFlag then
        local Ray_new_ret = Ray.new(v138.Origin, v138.Direction * 1000);
        local Raycast = u9.Raycast;
        local v139;

        if u27 then
            v139 = u27;
        else
            u27 = {};
            assert(u27, "");
            table.insert(u27, LocalPlayer and LocalPlayer.Character);
            v139 = u27;
        end;

        local v140, v141, v142 = Raycast(Ray_new_ret, true, v139);
        local v143, _ = u9.FindCharacterAncestor(v140);

        if p132 then
            v143 = nil;
        else
            p132 = v141;
        end;

        if p132 and Character then
            p130:CleanupPath();
            local v144 = Pather(p132, v142);

            if v144:IsValidPath() then
                p130:HandleMoveTo(v144, p132, v143, Character);

                return;
            end;

            v144:Cleanup();
            p130:ShowPathFailedFeedback(p132);

            return;
        end;

        return;
    end;

    local v145 = nil;
    local v146;

    if u27 then
        v146 = u27;
    else
        u27 = {};
        assert(u27, "");
        table.insert(u27, LocalPlayer and LocalPlayer.Character);
        v146 = u27;
    end;

    if not v146 then
        v146 = {};
    end;

    while true do
        local v147 = true;
        RaycastParams_new_ret.FilterDescendantsInstances = v146;
        local v148 = Workspace:Raycast(v138.Origin, v138.Direction * 1000, RaycastParams_new_ret);
        local v149, v150;

        if v148 then
            local Instance2 = v148.Instance;

            if not Instance2.CanCollide then
                local v151, v152;

                while true do
                    v151 = Instance2:FindFirstChildOfClass("Humanoid");
                    v152 = Instance2.Parent;

                    if v151 or not v152 then
                        break;
                    end;

                    Instance2 = v152;
                end;

                if v151 or not v152 then
                    v145 = Instance2;
                else
                    table.insert(v146, v152);
                    v147 = false;
                    v145 = nil;
                end;

                if v147 then
                    if not (v148 and Character) then
                        return;
                    end;

                    v149 = v148.Position;

                    if p132 then
                        v145 = nil;
                    else
                        p132 = v149;
                    end;

                    p130:CleanupPath();
                    v150 = Pather(p132, v148.Normal);

                    if v150:IsValidPath() then
                        p130:HandleMoveTo(v150, p132, v145, Character);

                        return;
                    end;

                    v150:Cleanup();
                    p130:ShowPathFailedFeedback(p132);

                    return;
                end;
            end;
        end;

        if v147 then
            if not (v148 and Character) then
                return;
            end;

            v149 = v148.Position;

            if p132 then
                v145 = nil;
            else
                p132 = v149;
            end;

            p130:CleanupPath();
            v150 = Pather(p132, v148.Normal);

            if v150:IsValidPath() then
                p130:HandleMoveTo(v150, p132, v145, Character);

                return;
            end;

            v150:Cleanup();
            p130:ShowPathFailedFeedback(p132);

            return;
        end;
    end;
end;

function u112.DisconnectEvents(p153) -- Line: 909
    local humanoidDiedConn = p153.humanoidDiedConn;

    if humanoidDiedConn then
        humanoidDiedConn:Disconnect();
    end;

    local characterChildAddedConn = p153.characterChildAddedConn;

    if characterChildAddedConn then
        characterChildAddedConn:Disconnect();
    end;

    local onCharacterAddedConn = p153.onCharacterAddedConn;

    if onCharacterAddedConn then
        onCharacterAddedConn:Disconnect();
    end;

    local renderSteppedConn = p153.renderSteppedConn;

    if renderSteppedConn then
        renderSteppedConn:Disconnect();
    end;

    local characterChildRemovedConn = p153.characterChildRemovedConn;

    if characterChildRemovedConn then
        characterChildRemovedConn:Disconnect();
    end;

    local menuOpenedConnection = p153.menuOpenedConnection;

    if menuOpenedConnection then
        menuOpenedConnection:Disconnect();
    end;

    local preferredInputChangedConnection = p153.preferredInputChangedConnection;

    if preferredInputChangedConnection then
        preferredInputChangedConnection:Disconnect();
    end;

    local clickPressedConn = p153.clickPressedConn;

    if clickPressedConn then
        clickPressedConn:Disconnect();
    end;

    local clickReleasedConn = p153.clickReleasedConn;

    if clickReleasedConn then
        clickReleasedConn:Disconnect();
    end;
end;

function u112.OnPreferredInputChanged(p154) -- Line: 921
    -- upvalues: LocalPlayer (copy), UserInputService (copy)
    local Character = LocalPlayer.Character;

    if Character then
        local v155 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;

        for _, child in pairs(Character:GetChildren()) do
            if child:IsA("Tool") then
                child.ManualActivationOnly = v155;
            end;
        end;
    end;
end;

function u112.OnCharacterAdded(u156, p157) -- Line: 933
    -- upvalues: ClickToMoveAction (copy), GuiService (copy), ClickToMovePositionAction (copy), UserFlag4 (copy), u115 (ref), UserInputService (copy)
    u156:DisconnectEvents();
    u156.clickPressedConn = ClickToMoveAction.Pressed:Connect(function() -- Line: 936
        -- upvalues: GuiService (ref), ClickToMovePositionAction (ref), UserFlag4 (ref), u156 (copy)
        local GuiInset, _ = GuiService:GetGuiInset();
        local State = ClickToMovePositionAction:GetState();

        if State.X == -1 and State.Y == -1 then
            return;
        end;

        local v158;

        if UserFlag4 then
            local Min = GuiService:GetInsetArea(Enum.ScreenInsets.None).Min;
            v158 = Vector2.new(State.X + Min.X, State.Y + Min.Y);
        else
            v158 = Vector2.new(State.X - GuiInset.X, State.Y - GuiInset.Y);
        end;

        u156.mouse2DownPos = v158;
        u156.mouse2DownTime = tick();
    end);
    u156.clickReleasedConn = ClickToMoveAction.Released:Connect(function() -- Line: 952
        -- upvalues: u156 (copy), u115 (ref)
        u156.mouse2UpTime = tick();
        local mouse2DownPos = u156.mouse2DownPos;

        if not (u156.playerData and u156.playerData.actions.MoveAction) then
            return;
        end;

        local v159 = u115 or u156.playerData.actions.MoveAction:GetState().Magnitude <= 0;

        if u156.mouse2UpTime - u156.mouse2DownTime < 0.25 and v159 then
            u156:OnTap({ mouse2DownPos });
        end;
    end);
    u156.menuOpenedConnection = GuiService.MenuOpened:Connect(function() -- Line: 967
        -- upvalues: u156 (copy)
        u156:CleanupPath();
    end);

    local function OnCharacterChildAdded(p160) -- Line: 971
        -- upvalues: UserInputService (ref), u156 (copy)
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and p160:IsA("Tool") then
            p160.ManualActivationOnly = true;
        end;

        if p160:IsA("Humanoid") then
            local humanoidDiedConn = u156.humanoidDiedConn;

            if humanoidDiedConn then
                humanoidDiedConn:Disconnect();
            end;

            u156.humanoidDiedConn = p160.Died:Connect(function() -- Line: 979
            end);
        end;
    end;

    u156.characterChildAddedConn = p157.ChildAdded:Connect(function(p161) -- Line: 987
        -- upvalues: OnCharacterChildAdded (copy)
        OnCharacterChildAdded(p161);
    end);
    u156.characterChildRemovedConn = p157.ChildRemoved:Connect(function(p162) -- Line: 990
        -- upvalues: UserInputService (ref)
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch and p162:IsA("Tool") then
            p162.ManualActivationOnly = false;
        end;
    end);

    for _, child in pairs(p157:GetChildren()) do
        OnCharacterChildAdded(child);
    end;

    u156.preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 1001
        -- upvalues: u156 (copy)
        u156:OnPreferredInputChanged();
    end);
end;

function u112.Start(p163) -- Line: 1006
    p163:Enable(true);
end;

function u112.Stop(p164) -- Line: 1010
    p164:Enable(false);
end;

function u112.Enable(u165: table, p166: boolean, p167: boolean, p168: any) -- Line: 1015
    -- upvalues: LocalPlayer (copy), UserFlag7 (copy), UserInputService (copy), ClickToMoveAction (copy), ClickToMovePositionAction (copy)
    if p166 then
        if not u165.running then
            if LocalPlayer.Character then
                u165:OnCharacterAdded(LocalPlayer.Character);
            end;

            u165.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(p169) -- Line: 1021
                -- upvalues: u165 (copy)
                u165:OnCharacterAdded(p169);
            end);
            u165.running = true;
        end;

        if not UserFlag7 then
            u165.touchJumpController = p168;

            if u165.touchJumpController then
                u165.touchJumpController:Enable(u165.jumpEnabled);
            end;
        end;
    else
        if u165.running then
            u165:DisconnectEvents();
            u165:CleanupPath();

            if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
                local Character = LocalPlayer.Character;

                if Character then
                    for _, child in pairs(Character:GetChildren()) do
                        if child:IsA("Tool") then
                            child.ManualActivationOnly = false;
                        end;
                    end;
                end;
            end;

            u165.running = false;
        end;

        if not UserFlag7 then
            if u165.touchJumpController and not u165.jumpEnabled then
                u165.touchJumpController:Enable(true);
            end;

            u165.touchJumpController = nil;
        end;
    end;

    ClickToMoveAction.Enabled = p166;
    ClickToMovePositionAction.Enabled = p166;
    u165.wasdEnabled = p166 and p167 and p167 or false;
    u165.enabled = p166;
end;

function u112.Update(p170, p171, p172) -- Line: 1064
    -- upvalues: u115 (ref), UserFlag2 (copy), calculateLocalMoveVector (copy), UserFlag6 (copy), UserFlag5 (copy), ClickToMoveDisplay (copy)
    assert(p171.actions.MoveAction);
    assert(p171.actions.JumpAction);

    if not p170.playerData then
        p170.playerData = p171;
    end;

    local v173 = u115;

    if v173 then
        v173:OnRenderStepped(p172);

        if u115 and u115 == v173 then
            if UserFlag2 then
                local u174 = calculateLocalMoveVector(v173.NextActionMoveDirection);

                if UserFlag6 then
                    local ClickToMoveScriptableBinding = p171.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding");

                    if ClickToMoveScriptableBinding then
                        ClickToMoveScriptableBinding:Fire(u174);
                    end;
                elseif UserFlag5 then
                    local ClickToMoveScriptableBinding = p171.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding");

                    if ClickToMoveScriptableBinding then
                        local success3, _ = pcall(function() -- Line: 1091
                            -- upvalues: ClickToMoveScriptableBinding (copy), u174 (copy)
                            ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                            ClickToMoveScriptableBinding:Fire(u174);
                        end);

                        if not success3 then
                            p171.actions.MoveAction:Fire(u174);
                        end;
                    else
                        p171.actions.MoveAction:Fire(u174);
                    end;
                else
                    p171.actions.MoveAction:Fire(u174);
                end;

                p171.moveVector = u174;

                if v173.NextActionJump then
                    if p171.actions.JumpAction:GetState() ~= true then
                        if UserFlag6 then
                            local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                            if ClickToMoveScriptableBinding then
                                ClickToMoveScriptableBinding:Fire(true);
                            end;
                        elseif UserFlag5 then
                            local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                            if ClickToMoveScriptableBinding then
                                local success3, _ = pcall(function() -- Line: 1117
                                    -- upvalues: ClickToMoveScriptableBinding (copy)
                                    ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                                    ClickToMoveScriptableBinding:Fire(true);
                                end);

                                if not success3 then
                                    p171.actions.JumpAction:Fire(true);
                                end;
                            else
                                p171.actions.JumpAction:Fire(true);
                            end;
                        else
                            p171.actions.JumpAction:Fire(true);
                        end;
                    end;

                    p170.lastPatherJumped = true;
                    p171.isJumping = true;
                elseif p170.lastPatherJumped then
                    if p171.actions.JumpAction:GetState() == true then
                        if UserFlag6 then
                            local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                            if ClickToMoveScriptableBinding then
                                ClickToMoveScriptableBinding:Fire(false);
                            end;
                        elseif UserFlag5 then
                            local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                            if ClickToMoveScriptableBinding then
                                local success3, _ = pcall(function() -- Line: 1143
                                    -- upvalues: ClickToMoveScriptableBinding (copy)
                                    ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                                    ClickToMoveScriptableBinding:Fire(false);
                                end);

                                if not success3 then
                                    p171.actions.JumpAction:Fire(false);
                                end;
                            else
                                p171.actions.JumpAction:Fire(false);
                            end;
                        else
                            p171.actions.JumpAction:Fire(false);
                        end;
                    end;

                    p170.lastPatherJumped = false;
                    p171.isJumping = false;
                end;
            else
                local State = p171.actions.MoveAction:GetState();
                local u175 = calculateLocalMoveVector(v173.NextActionMoveDirection);

                if (State - p170.lastPatherMoveVector).Magnitude > 1e-6 then
                    p170:CleanupPath();
                    ClickToMoveDisplay.CancelFailureAnimation();
                else
                    p170.lastPatherMoveVector = u175;

                    if UserFlag5 then
                        local ClickToMoveScriptableBinding = p171.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding");

                        if ClickToMoveScriptableBinding then
                            local success3, _ = pcall(function() -- Line: 1174
                                -- upvalues: ClickToMoveScriptableBinding (copy), u175 (copy)
                                ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                                ClickToMoveScriptableBinding:Fire(u175);
                            end);

                            if not success3 then
                                p171.actions.MoveAction:Fire(u175);
                            end;
                        else
                            p171.actions.MoveAction:Fire(u175);
                        end;
                    else
                        p171.actions.MoveAction:Fire(u175);
                    end;

                    if v173.NextActionJump then
                        if p171.actions.JumpAction:GetState() ~= true then
                            if UserFlag5 then
                                local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                                if ClickToMoveScriptableBinding then
                                    local success3, _ = pcall(function() -- Line: 1194
                                        -- upvalues: ClickToMoveScriptableBinding (copy)
                                        ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                                        ClickToMoveScriptableBinding:Fire(true);
                                    end);

                                    if not success3 then
                                        p171.actions.JumpAction:Fire(true);
                                    end;
                                else
                                    p171.actions.JumpAction:Fire(true);
                                end;
                            else
                                p171.actions.JumpAction:Fire(true);
                            end;

                            p170.lastPatherJumped = true;
                        end;
                    elseif p170.lastPatherJumped then
                        if p171.actions.JumpAction:GetState() == true then
                            if UserFlag5 then
                                local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                                if ClickToMoveScriptableBinding then
                                    local success3, _ = pcall(function() -- Line: 1214
                                        -- upvalues: ClickToMoveScriptableBinding (copy)
                                        ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                                        ClickToMoveScriptableBinding:Fire(false);
                                    end);

                                    if not success3 then
                                        p171.actions.JumpAction:Fire(false);
                                    end;
                                else
                                    p171.actions.JumpAction:Fire(false);
                                end;
                            else
                                p171.actions.JumpAction:Fire(false);
                            end;
                        end;

                        p170.lastPatherJumped = false;
                    end;
                end;
            end;
        else
            if not UserFlag2 then
                p170.lastPatherMoveVector = Vector2.zero;
            end;

            if p170.lastPatherJumped then
                if p171.actions.JumpAction:GetState() == true then
                    if UserFlag6 then
                        local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                        if ClickToMoveScriptableBinding then
                            ClickToMoveScriptableBinding:Fire(false);
                        end;
                    elseif UserFlag5 then
                        local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                        if ClickToMoveScriptableBinding then
                            local success3, _ = pcall(function() -- Line: 1247
                                -- upvalues: ClickToMoveScriptableBinding (copy)
                                ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                                ClickToMoveScriptableBinding:Fire(false);
                            end);

                            if not success3 then
                                p171.actions.JumpAction:Fire(false);
                            end;
                        else
                            p171.actions.JumpAction:Fire(false);
                        end;
                    else
                        p171.actions.JumpAction:Fire(false);
                    end;
                end;

                p170.lastPatherJumped = false;
            end;
        end;
    end;

    if p170.shouldCleanupPath then
        p170.shouldCleanupPath = false;

        if UserFlag2 then
            if UserFlag6 then
                local ClickToMoveScriptableBinding = p171.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding");

                if ClickToMoveScriptableBinding then
                    ClickToMoveScriptableBinding:Fire(Vector2.zero);
                end;
            elseif UserFlag5 then
                local ClickToMoveScriptableBinding = p171.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding");

                if ClickToMoveScriptableBinding then
                    local success3, _ = pcall(function() -- Line: 1277
                        -- upvalues: ClickToMoveScriptableBinding (copy)
                        ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                        ClickToMoveScriptableBinding:Fire(Vector2.zero);
                    end);

                    if not success3 then
                        p171.actions.MoveAction:Fire(Vector2.zero);
                    end;
                else
                    p171.actions.MoveAction:Fire(Vector2.zero);
                end;
            else
                p171.actions.MoveAction:Fire(Vector2.zero);
            end;

            p171.moveVector = Vector2.zero;
            p170.lastPatherJumped = false;

            if UserFlag6 then
                local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                if ClickToMoveScriptableBinding then
                    ClickToMoveScriptableBinding:Fire(false);
                end;
            elseif UserFlag5 then
                local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

                if ClickToMoveScriptableBinding then
                    local success3, _ = pcall(function() -- Line: 1300
                        -- upvalues: ClickToMoveScriptableBinding (copy)
                        ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                        ClickToMoveScriptableBinding:Fire(false);
                    end);

                    if not success3 then
                        p171.actions.JumpAction:Fire(false);
                    end;
                else
                    p171.actions.JumpAction:Fire(false);
                end;
            else
                p171.actions.JumpAction:Fire(false);
            end;

            p171.isJumping = false;

            return;
        end;

        p170.lastPatherMoveVector = Vector2.zero;

        if UserFlag6 then
            local ClickToMoveScriptableBinding = p171.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding");

            if ClickToMoveScriptableBinding then
                ClickToMoveScriptableBinding:Fire(Vector2.zero);
            end;
        elseif UserFlag5 then
            local ClickToMoveScriptableBinding = p171.actions.MoveAction:FindFirstChild("ClickToMoveScriptableBinding");

            if ClickToMoveScriptableBinding then
                local success3, _ = pcall(function() -- Line: 1324
                    -- upvalues: ClickToMoveScriptableBinding (copy)
                    ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                    ClickToMoveScriptableBinding:Fire(Vector2.zero);
                end);

                if not success3 then
                    p171.actions.MoveAction:Fire(Vector2.zero);
                end;
            else
                p171.actions.MoveAction:Fire(Vector2.zero);
            end;
        else
            p171.actions.MoveAction:Fire(Vector2.zero);
        end;

        p170.lastPatherJumped = false;

        if UserFlag6 then
            local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

            if ClickToMoveScriptableBinding then
                ClickToMoveScriptableBinding:Fire(false);
            end;
        elseif UserFlag5 then
            local ClickToMoveScriptableBinding = p171.actions.JumpAction:FindFirstChild("ClickToMoveScriptableBinding");

            if not ClickToMoveScriptableBinding then
                p171.actions.JumpAction:Fire(false);

                return;
            end;

            local success3, _ = pcall(function() -- Line: 1346
                -- upvalues: ClickToMoveScriptableBinding (copy)
                ClickToMoveScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                ClickToMoveScriptableBinding:Fire(false);
            end);

            if not success3 then
                p171.actions.JumpAction:Fire(false);
            end;
        else
            p171.actions.JumpAction:Fire(false);
        end;
    end;
end;

function u112.SetShowPath(p176, p177) -- Line: 1364
    -- upvalues: u4 (ref)
    u4 = p177;
end;

function u112.GetShowPath(p178) -- Line: 1368
    -- upvalues: u4 (ref)
    return u4;
end;

function u112.SetWaypointTexture(p179, p180) -- Line: 1372
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointTexture(p180);
end;

function u112.GetWaypointTexture(p181) -- Line: 1376
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointTexture();
end;

function u112.SetWaypointRadius(p182, p183) -- Line: 1380
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointRadius(p183);
end;

function u112.GetWaypointRadius(p184) -- Line: 1384
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointRadius();
end;

function u112.SetEndWaypointTexture(p185, p186) -- Line: 1388
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetEndWaypointTexture(p186);
end;

function u112.GetEndWaypointTexture(p187) -- Line: 1392
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetEndWaypointTexture();
end;

function u112.SetWaypointsAlwaysOnTop(p188, p189) -- Line: 1396
    -- upvalues: ClickToMoveDisplay (copy)
    ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p189);
end;

function u112.GetWaypointsAlwaysOnTop(p190) -- Line: 1400
    -- upvalues: ClickToMoveDisplay (copy)
    return ClickToMoveDisplay.GetWaypointsAlwaysOnTop();
end;

function u112.SetFailureAnimationEnabled(p191, p192) -- Line: 1404
    -- upvalues: u5 (ref)
    u5 = p192;
end;

function u112.GetFailureAnimationEnabled(p193) -- Line: 1408
    -- upvalues: u5 (ref)
    return u5;
end;

function u112.SetIgnoredPartsTag(p194, p195) -- Line: 1412
    -- upvalues: UpdateIgnoreTag (copy)
    UpdateIgnoreTag(p195);
end;

function u112.GetIgnoredPartsTag(p196) -- Line: 1416
    -- upvalues: u28 (ref)
    return u28;
end;

function u112.SetUseDirectPath(p197, p198) -- Line: 1420
    -- upvalues: u6 (ref)
    u6 = p198;
end;

function u112.GetUseDirectPath(p199) -- Line: 1424
    -- upvalues: u6 (ref)
    return u6;
end;

function u112.SetAgentSizeIncreaseFactor(p200: table, p201: number) -- Line: 1428
    -- upvalues: u7 (ref)
    u7 = p201 / 100 + 1;
end;

function u112.GetAgentSizeIncreaseFactor(p202) -- Line: 1432
    -- upvalues: u7 (ref)
    return (u7 - 1) * 100;
end;

function u112.SetUnreachableWaypointTimeout(p203, p204) -- Line: 1436
    -- upvalues: u8 (ref)
    u8 = p204;
end;

function u112.GetUnreachableWaypointTimeout(p205) -- Line: 1440
    -- upvalues: u8 (ref)
    return u8;
end;

if not UserFlag7 then
    function u112.SetUserJumpEnabled(p206, p207) -- Line: 1445
        p206.jumpEnabled = p207;

        if p206.touchJumpController then
            p206.touchJumpController:Enable(p207);
        end;
    end;

    function u112.GetUserJumpEnabled(p208) -- Line: 1452
        return p208.jumpEnabled;
    end;
end;

function u112.MoveTo(p209, p210, p211, p212) -- Line: 1457
    -- upvalues: LocalPlayer (copy), Pather (copy)
    local Character = LocalPlayer.Character;

    if Character == nil then
        return false;
    end;

    local v213 = Pather(p210, Vector3.new(0, 1, 0), p212);

    if not (v213 and v213:IsValidPath()) then
        return false;
    end;

    p209:HandleMoveTo(v213, p210, nil, Character, p211);

    return true;
end;

return u112;