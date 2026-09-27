-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CommonUtils = require(script.Parent.Parent.Parent:WaitForChild("CommonUtils"));
local v1 = CommonUtils.get("FlagUtil");
local v2 = CommonUtils.get("CameraWrapper");
local v3 = CommonUtils.get("ConnectionUtil");
local UserFlag = v1.getUserFlag("UserRaycastUpdateAPI2");
local UserFlag2 = v1.getUserFlag("UserCurrentCameraUpdate2");
local UserFlag3 = v1.getUserFlag("UserPlayerConnectionMemoryLeak");
local u4;

if UserFlag2 then
    u4 = v2.new();
else
    u4 = nil;
end;

local u5;

if UserFlag2 then
    u5 = nil;
else
    u5 = game.Workspace.CurrentCamera;
end;

if UserFlag2 then
    u4:Enable();
end;

local math_min = math.min;
local math_tan = math.tan;
local math_rad = math.rad;
local Ray_new = Ray.new;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.IgnoreWater = true;
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.RespectCanCollide = true;
local RaycastParams_new_ret2 = RaycastParams.new();
RaycastParams_new_ret2.IgnoreWater = true;
RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Include;
local u6;

if UserFlag3 then
    u6 = v3.new();
else
    u6 = nil;
end;

local function getTotalTransparency(p7) -- Line: 43
    return 1 - (1 - p7.Transparency) * (1 - p7.LocalTransparencyModifier);
end;

local function eraseFromEnd(p8, p9) -- Line: 47
    for i = #p8, p9 + 1, -1 do
        p8[i] = nil;
        local _ = i;
    end;
end;

local u10 = nil;
local u11 = nil;
local u12;

if UserFlag2 then
    local function updateProjection() -- Line: 57
        -- upvalues: u4 (copy), math_rad (copy), u11 (ref), math_tan (copy), u10 (ref)
        local Camera = u4:getCamera();
        local v13 = math_rad(Camera.FieldOfView);
        local ViewportSize = Camera.ViewportSize;
        local v14 = ViewportSize.X / ViewportSize.Y;
        u11 = math_tan(v13 / 2) * 2;
        u10 = v14 * u11;
    end;

    u4:Connect("FieldOfView", updateProjection);
    u4:Connect("ViewportSize", updateProjection);
    local Camera = u4:getCamera();
    local v15 = math_rad(Camera.FieldOfView);
    local ViewportSize = Camera.ViewportSize;
    local v16 = ViewportSize.X / ViewportSize.Y;
    u11 = math_tan(v15 / 2) * 2;
    u10 = v16 * u11;
    u12 = u4:getCamera().NearPlaneZ;
    u4:Connect("NearPlaneZ", function() -- Line: 73
        -- upvalues: u12 (ref), u4 (copy)
        u12 = u4:getCamera().NearPlaneZ;
    end);
else
    local function v19() -- Line: 79
        -- upvalues: u5 (ref), math_rad (copy), u11 (ref), math_tan (copy), u10 (ref)
        local v17 = math_rad(u5.FieldOfView);
        local ViewportSize = u5.ViewportSize;
        local v18 = ViewportSize.X / ViewportSize.Y;
        u11 = math_tan(v17 / 2) * 2;
        u10 = v18 * u11;
    end;

    u5:GetPropertyChangedSignal("FieldOfView"):Connect(v19);
    u5:GetPropertyChangedSignal("ViewportSize"):Connect(v19);
    local v20 = math_rad(u5.FieldOfView);
    local ViewportSize = u5.ViewportSize;
    local v21 = ViewportSize.X / ViewportSize.Y;
    u11 = math_tan(v20 / 2) * 2;
    u10 = v21 * u11;
    u12 = u5.NearPlaneZ;
    u5:GetPropertyChangedSignal("NearPlaneZ"):Connect(function() -- Line: 93
        -- upvalues: u12 (ref), u5 (ref)
        u12 = u5.NearPlaneZ;
    end);
end;

local u22 = {};
local u23 = {};

local function refreshIgnoreList() -- Line: 102
    -- upvalues: u22 (ref), u23 (copy)
    local v24 = 1;
    u22 = {};

    for _, v in pairs(u23) do
        u22[v24] = v;
        v24 = v24 + 1;
    end;
end;

local function playerAdded(u25) -- Line: 111
    -- upvalues: u23 (copy), u22 (ref), UserFlag3 (copy), u6 (copy)
    local function characterAdded(p26) -- Line: 112
        -- upvalues: u23 (ref), u25 (copy), u22 (ref)
        u23[u25] = p26;
        local v27 = 1;
        u22 = {};

        for _, v in pairs(u23) do
            u22[v27] = v;
            v27 = v27 + 1;
        end;
    end;

    local function characterRemoving() -- Line: 116
        -- upvalues: u23 (ref), u25 (copy), u22 (ref)
        u23[u25] = nil;
        local v28 = 1;
        u22 = {};

        for _, v in pairs(u23) do
            u22[v28] = v;
            v28 = v28 + 1;
        end;
    end;

    if UserFlag3 then
        u6:trackConnection(`{u25.UserId}CharacterAdded`, u25.CharacterAdded:Connect(characterAdded));
        u6:trackConnection(`{u25.UserId}CharacterRemoving`, u25.CharacterRemoving:Connect(characterRemoving));
    else
        u25.CharacterAdded:Connect(characterAdded);
        u25.CharacterRemoving:Connect(characterRemoving);
    end;

    if u25.Character then
        u23[u25] = u25.Character;
        local v29 = 1;
        u22 = {};

        for _, v in pairs(u23) do
            u22[v29] = v;
            v29 = v29 + 1;
        end;
    end;
end;

local function playerRemoving(p30) -- Line: 134
    -- upvalues: u23 (copy), u22 (ref), UserFlag3 (copy), u6 (copy)
    u23[p30] = nil;
    local v31 = 1;
    u22 = {};

    for _, v in pairs(u23) do
        u22[v31] = v;
        v31 = v31 + 1;
    end;

    if UserFlag3 then
        u6:disconnect((`{p30.UserId}CharacterAdded`));
        u6:disconnect((`{p30.UserId}CharacterRemoving`));
    end;
end;

Players.PlayerAdded:Connect(playerAdded);
Players.PlayerRemoving:Connect(playerRemoving);

for _, v in ipairs(Players:GetPlayers()) do
    playerAdded(v);
end;

local v32 = 1;
u22 = {};

for _, v in pairs(u23) do
    u22[v32] = v;
    v32 = v32 + 1;
end;

local u33 = nil;
local u34 = nil;

if UserFlag2 then
    u4:Connect("CameraSubject", function() -- Line: 174
        -- upvalues: u4 (copy), u34 (ref)
        local CameraSubject = u4:getCamera().CameraSubject;

        if CameraSubject and CameraSubject:IsA("Humanoid") then
            u34 = CameraSubject.RootPart;

            return;
        end;

        if CameraSubject and CameraSubject:IsA("BasePart") then
            u34 = CameraSubject;

            return;
        end;

        u34 = nil;
    end);
else
    u5:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 185
        -- upvalues: u5 (ref), u34 (ref)
        local CameraSubject = u5.CameraSubject;

        if CameraSubject:IsA("Humanoid") then
            u34 = CameraSubject.RootPart;

            return;
        end;

        if CameraSubject:IsA("BasePart") then
            u34 = CameraSubject;

            return;
        end;

        u34 = nil;
    end);
end;

local function canOcclude(p35) -- Line: 197
    -- upvalues: UserFlag (copy), u33 (ref)
    local v36;

    if 1 - (1 - p35.Transparency) * (1 - p35.LocalTransparencyModifier) < 0.25 then
        v36 = UserFlag or p35.CanCollide;

        if v36 then
            if u33 == (p35:GetRootPart() or p35) then
                v36 = false;
            else
                v36 = not p35:IsA("TrussPart");
            end;
        end;
    else
        v36 = false;
    end;

    return v36;
end;

local u37 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2)
};

local function getCollisionPoint(p38, p39) -- Line: 225
    -- upvalues: UserFlag (copy), RaycastParams_new_ret (copy), u22 (ref), Ray_new (copy)
    if UserFlag then
        RaycastParams_new_ret.FilterDescendantsInstances = u22;
        local v40 = workspace:Raycast(p38, p39, RaycastParams_new_ret);

        if v40 then
            return v40.Position, true;
        end;
    else
        local v41 = #u22;
        local v42;

        repeat
            local v43;
            v42, v43 = workspace:FindPartOnRayWithIgnoreList(Ray_new(p38, p39), u22, false, true);

            if v42 then
                if v42.CanCollide then
                    local v44 = u22;

                    for i = #v44, v41 + 1, -1 do
                        v44[i] = nil;
                        local _ = i;
                    end;

                    return v43, true;
                end;

                u22[#u22 + 1] = v42;
            end;
        until not v42;

        local v45 = u22;

        for i = #v45, v41 + 1, -1 do
            v45[i] = nil;
            local _ = i;
        end;
    end;

    return p38 + p39, false;
end;

local function queryPoint(p46, p47, p48, p49) -- Line: 258
    -- upvalues: u22 (ref), u12 (ref), UserFlag (copy), RaycastParams_new_ret (copy), u33 (ref), RaycastParams_new_ret2 (copy), Ray_new (copy)
    debug.profilebegin("queryPoint");
    local v50 = #u22;
    local v51 = p48 + u12;
    local v52 = p46 + p47 * v51;
    local v53 = (1 / 0);
    local v54 = (1 / 0);
    local v55 = 0;
    local v56;

    if UserFlag then
        RaycastParams_new_ret.FilterDescendantsInstances = u22;
        local v57 = p46;

        while true do
            local v58 = workspace:Raycast(p46, v52 - p46, RaycastParams_new_ret);

            if not v58 then
                v56 = v53;
                break;
            end;

            v55 = v55 + 1;
            local Instance = v58.Instance;
            local Position = v58.Position;
            v56 = (Position - v57).Magnitude;

            if v55 >= 64 then
                v54 = v56;
                v56 = v53;
            else
                local v59;

                if 1 - (1 - Instance.Transparency) * (1 - Instance.LocalTransparencyModifier) < 0.25 then
                    v59 = UserFlag or Instance.CanCollide;

                    if v59 then
                        if u33 == (Instance:GetRootPart() or Instance) then
                            v59 = false;
                        else
                            v59 = not Instance:IsA("TrussPart");
                        end;
                    end;
                else
                    v59 = false;
                end;

                if v59 then
                    RaycastParams_new_ret2.FilterDescendantsInstances = { Instance };

                    if workspace:Raycast(v52, Position - v52, RaycastParams_new_ret2) then
                        local v60;

                        if p49 then
                            v60 = workspace:Raycast(p49, v52 - p49, RaycastParams_new_ret2) or workspace:Raycast(v52, p49 - v52, RaycastParams_new_ret2);
                        else
                            v60 = false;
                        end;

                        if v60 then
                            v54 = v56;
                            v56 = v53;
                        elseif v51 >= v53 then
                            v56 = v53;
                        end;
                    else
                        v54 = v56;
                        v56 = v53;
                    end;
                else
                    v56 = v53;
                end;
            end;

            RaycastParams_new_ret:AddToFilter(Instance);
            p46 = Position - p47 * 0.001;

            if v54 < (1 / 0) or not Instance then
                break;
            end;

            v53 = v56;
        end;
    else
        local v61 = p46;

        while true do
            local v62;

            if true then
                local v63;
                v62, v63 = workspace:FindPartOnRayWithIgnoreList(Ray_new(p46, v52 - p46), u22, false, true);
                v55 = v55 + 1;

                if v62 then
                    local v64 = v55 >= 64;
                    local v65;

                    if 1 - (1 - v62.Transparency) * (1 - v62.LocalTransparencyModifier) < 0.25 then
                        v65 = UserFlag or v62.CanCollide;

                        if v65 then
                            if u33 == (v62:GetRootPart() or v62) then
                                v65 = false;
                            else
                                v65 = not v62:IsA("TrussPart");
                            end;
                        end;
                    else
                        v65 = false;
                    end;

                    if v65 or v64 then
                        local v66 = { v62 };
                        local v67 = workspace:FindPartOnRayWithWhitelist(Ray_new(v52, v63 - v52), v66, true);
                        v56 = (v63 - v61).Magnitude;

                        if v67 and not v64 then
                            local v68;

                            if p49 then
                                v68 = workspace:FindPartOnRayWithWhitelist(Ray_new(p49, v52 - p49), v66, true) or workspace:FindPartOnRayWithWhitelist(Ray_new(v52, p49 - v52), v66, true);
                            else
                                v68 = false;
                            end;

                            if v68 then
                                v54 = v56;
                                v56 = v53;
                            elseif v51 >= v53 then
                                v56 = v53;
                            end;
                        else
                            v54 = v56;
                            v56 = v53;
                        end;
                    else
                        v56 = v53;
                    end;

                    u22[#u22 + 1] = v62;
                    p46 = v63 - p47 * 0.001;
                else
                    v56 = v53;
                end;
            end;

            if v54 < (1 / 0) or not v62 then
                break;
            end;

            v53 = v56;
        end;

        local v69 = u22;

        for i = #v69, v50 + 1, -1 do
            v69[i] = nil;
            local _ = i;
        end;
    end;

    debug.profileend();

    return v56 - u12, v54 - u12;
end;

local function queryViewport(p70, p71) -- Line: 361
    -- upvalues: u5 (ref), UserFlag2 (copy), u4 (copy), u10 (ref), u11 (ref), u12 (ref), queryPoint (copy)
    debug.profilebegin("queryViewport");
    local Position = p70.Position;
    local rightVector = p70.rightVector;
    local upVector = p70.upVector;
    local v72 = -p70.lookVector;
    local v73;

    if UserFlag2 then
        v73 = u4:getCamera();
    else
        v73 = u5;
    end;

    u5 = v73;
    local ViewportSize = u5.ViewportSize;
    local v74 = (1 / 0);
    local v75 = (1 / 0);

    for i = 0, 1 do
        local v76 = rightVector * ((i - 0.5) * u10);
        local v77 = i;

        for i2 = 0, 1 do
            local v78, v79 = queryPoint(Position + u12 * (v76 + upVector * ((i2 - 0.5) * u11)), v72, p71, u5:ViewportPointToRay(ViewportSize.x * v77, ViewportSize.y * i2).Origin);

            if v79 >= v74 then
                v79 = v74;
            end;

            local v80;

            if v78 < v75 then
                v75 = v78;
                v80 = i2;
                v74 = v79;
            else
                v80 = i2;
                v74 = v79;
            end;
        end;
    end;

    debug.profileend();

    return v75, v74;
end;

local function testPromotion(p81, p82, p83) -- Line: 404
    -- upvalues: getCollisionPoint (copy), math_min (copy), queryPoint (copy), u37 (copy)
    debug.profilebegin("testPromotion");
    local Position = p81.Position;
    local rightVector = p81.rightVector;
    local upVector = p81.upVector;
    local v84 = -p81.lookVector;
    debug.profilebegin("extrapolate");
    local Magnitude = (getCollisionPoint(Position, p83.posVelocity * 1.25) - Position).Magnitude;

    for i = 0, math_min(1.25, p83.rotVelocity.magnitude + Magnitude / p83.posVelocity.magnitude), 0.0625 do
        local v85 = p83.extrapolate(i);

        if p82 <= queryPoint(v85.Position, -v85.lookVector, p82) then
            return false;
        end;

        local _ = i;
    end;

    debug.profileend();
    debug.profilebegin("testOffsets");

    for _, v in ipairs(u37) do
        local v86 = getCollisionPoint(Position, rightVector * v.x + upVector * v.y);

        if queryPoint(v86, (Position + v84 * p82 - v86).Unit, p82) == (1 / 0) then
            return false;
        end;
    end;

    debug.profileend();
    debug.profileend();

    return true;
end;

return function(p87, p88, p89) -- Line: 453, Name: Popper
    -- upvalues: u33 (ref), u34 (ref), queryViewport (copy), testPromotion (copy)
    debug.profilebegin("popper");
    u33 = u34 and u34:GetRootPart() or u34;
    local v90, v91 = queryViewport(p87, p88);

    if v91 >= p88 then
        v91 = p88;
    end;

    if v90 < v91 then
        if not testPromotion(p87, p88, p89) then
            v90 = v91;
        end;
    else
        v90 = v91;
    end;

    u33 = nil;
    debug.profileend();

    return v90;
end;