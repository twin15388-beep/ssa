-- Decompiled with Potassium's decompiler.

local v1 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local UserFlag = v1.getUserFlag("UserPlayerScriptsFireThroughScriptableBindings");
local UserFlag2 = v1.getUserFlag("UserPlayerScriptsUseReplicatedCameraAPI");
local UserFlag3 = v1.getUserFlag("UserPlayerScriptsStopFireCameraAction");
local UserFlag4 = v1.getUserFlag("UserPlayerScriptsSAuthDirectAPIs2");
local UserFlag5 = v1.getUserFlag("UserPlayerScriptsCCLIntegrationD");
game:GetService("StarterPlayer");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local Workspace = game:GetService("Workspace");
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"));
local UserFlag6 = v1.getUserFlag("UserAbilitiesUserInterfaceB");
local u2 = UserFlag6 and "ControlState" or "PlayerControlState";
local u3 = {};
u3.__index = u3;

function u3._calculatePlayerInputValues(u4: userdata) -- Line: 18
    -- upvalues: UserFlag4 (copy), UserFlag2 (copy)
    local Character = u4.Character;

    if Character == nil then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 1), false;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid == nil then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 1), false;
    end;

    local InputContexts = u4:FindFirstChild("InputContexts");

    if InputContexts == nil then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 1), false;
    end;

    local CharacterContext = InputContexts:FindFirstChild("CharacterContext");

    if CharacterContext == nil then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 1), false;
    end;

    local CameraContext = InputContexts:FindFirstChild("CameraContext");
    local MoveAction = CharacterContext.MoveAction;

    if CameraContext then
        CameraContext = CameraContext.CameraAction;
    end;

    local RotationAction = CharacterContext:FindFirstChild("RotationAction");
    local v5;

    if RotationAction == nil then
        v5 = false;
    else
        v5 = RotationAction:GetState();
    end;

    local function isValidInput2D(p6) -- Line: 42
        return p6.X == p6.X and (p6.Y == p6.Y and p6.X ~= (1 / 0)) and p6.Y ~= (1 / 0);
    end;

    local function isValidInput3D(p7: vector) -- Line: 50
        return p7.X == p7.X and (p7.Y == p7.Y and (p7.Z == p7.Z and (p7.X ~= (1 / 0) and p7.Y ~= (1 / 0)))) and p7.Z ~= (1 / 0);
    end;

    local v8;

    if MoveAction == nil then
        v8 = Vector2.new(0, 0);
    else
        v8 = MoveAction:GetState();
    end;

    local v9 = nil;
    local v10;

    if UserFlag4 then
        v10 = u4:GetCameraState().CFrame.LookVector;
    elseif UserFlag2 then
        local success, result = pcall(function() -- Line: 65
            -- upvalues: u4 (copy)
            return u4:GetCameraState();
        end);

        if success and result then
            local CFrame2 = result.CFrame;

            if CFrame2 ~= CFrame.identity and (result.FieldOfView > 0 and result.ViewportSize.Magnitude > 0) then
                v9 = CFrame2.LookVector;
            end;
        end;

        v10 = v9 or (CameraContext == nil and Vector3.new(0, 0, 0) or CameraContext:GetState());
    else
        v10 = CameraContext == nil and Vector3.new(0, 0, 0) or CameraContext:GetState();
    end;

    if v8.X ~= v8.X or (v8.Y ~= v8.Y or v8.X == (1 / 0)) or v8.Y == (1 / 0) or (v10.X ~= v10.X or (v10.Y ~= v10.Y or (v10.Z ~= v10.Z or (v10.X == (1 / 0) or v10.Y == (1 / 0)))) or v10.Z == (1 / 0) or v10.Magnitude <= 0) then
        return Vector3.new(0, 0, 0), Vector3.new(0, 0, 1), false;
    end;

    if Humanoid and Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
        v10 = Vector3.new(v10.X, 0, v10.Z).Unit;
    end;

    local Unit = v10:Cross(Vector3.new(0, 1, 0)).Unit;

    return v10 * v8.Y + Unit * v8.X, v10, v5;
end;

function u3.CloneInputsIfAbsent(p11: userdata) -- Line: 96
    if p11:FindFirstChild("InputContexts") then
        return;
    end;

    local v12 = script.Parent.Parent.InputContexts:Clone();
    v12.CharacterContext.Enabled = true;
    v12.CameraContext.Enabled = true;
    v12.Parent = p11;
end;

function u3.FireCustomInputs(u13: userdata) -- Line: 106
    -- upvalues: UserFlag4 (copy), UserGameSettings (copy), UserFlag3 (copy), Workspace (copy), UserFlag (copy)
    local InputContexts = u13:FindFirstChild("InputContexts");

    if not InputContexts then
        return;
    end;

    local CharacterContext = InputContexts:FindFirstChild("CharacterContext");

    if not CharacterContext then
        return;
    end;

    local CameraContext = InputContexts:FindFirstChild("CameraContext");

    if not CameraContext then
        return;
    end;

    if UserFlag4 then
        local RotationAction = CharacterContext:FindFirstChild("RotationAction");
        local v14 = RotationAction and RotationAction:FindFirstChild("RotationScriptableBinding");

        if v14 then
            v14:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
        end;
    else
        local v15 = true;

        if UserFlag3 then
            local success, result = pcall(function() -- Line: 125
                -- upvalues: u13 (copy)
                return u13:GetCameraState();
            end);

            if success and (result and (result.CFrame ~= CFrame.identity and (result.FieldOfView > 0 and result.ViewportSize.Magnitude > 0))) then
                v15 = false;
            end;
        end;

        local v16 = v15 and CameraContext:FindFirstChild("CameraAction");

        if v16 then
            local CurrentCamera = Workspace.CurrentCamera;

            if UserFlag then
                local CameraScriptableBinding = v16:FindFirstChild("CameraScriptableBinding");

                if CameraScriptableBinding then
                    local success, _ = pcall(function() -- Line: 140
                        -- upvalues: CameraScriptableBinding (copy), CurrentCamera (copy)
                        CameraScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                        CameraScriptableBinding:Fire(CurrentCamera.CFrame.LookVector);
                    end);

                    if not success then
                        v16:Fire(CurrentCamera.CFrame.LookVector);
                    end;
                else
                    v16:Fire(CurrentCamera.CFrame.LookVector);
                end;
            else
                v16:Fire(CurrentCamera.CFrame.LookVector);
            end;
        end;

        local RotationAction = CharacterContext:FindFirstChild("RotationAction");

        if RotationAction then
            if UserFlag then
                local RotationScriptableBinding = RotationAction:FindFirstChild("RotationScriptableBinding");

                if not RotationScriptableBinding then
                    RotationAction:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);

                    return;
                end;

                local success, _ = pcall(function() -- Line: 161
                    -- upvalues: RotationScriptableBinding (copy), UserGameSettings (ref)
                    RotationScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                    RotationScriptableBinding:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
                end);

                if not success then
                    RotationAction:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
                end;
            else
                RotationAction:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
            end;
        end;
    end;
end;

function u3.SendInputToCCLCharacter(p17: userdata) -- Line: 180
    -- upvalues: AvatarAbilitiesInterface (copy), u3 (copy)
    if not p17 then
        return;
    end;

    local v18 = AvatarAbilitiesInterface.get(p17);
    local InputContexts = p17:FindFirstChild("InputContexts");

    if not InputContexts then
        return;
    end;

    local CharacterContext = InputContexts:FindFirstChild("CharacterContext");

    if not CharacterContext then
        return;
    end;

    for _, v in v18:GetAbilities() do
        local v19 = CharacterContext:FindFirstChild(v .. "Action");

        if v19 then
            v18:SendInput(v, v19:GetState());
        end;
    end;

    local v20, v21, v22 = u3._calculatePlayerInputValues(p17);
    v18:SendInput("Move", v20);
    v18:SendInput("CameraLookDirection", v21);
    v18:SendInput("CameraRelativeRotation", v22);
end;

function u3.SendInputToHumanoidForServerAuth(p23: userdata) -- Line: 201
    -- upvalues: u3 (copy)
    local Character = p23.Character;

    if Character == nil then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid == nil then
        return;
    end;

    local InputContexts = p23:FindFirstChild("InputContexts");

    if InputContexts == nil then
        return;
    end;

    local CharacterContext = InputContexts:FindFirstChild("CharacterContext");

    if CharacterContext == nil then
        return;
    end;

    local JumpAction = CharacterContext.JumpAction;
    local v24, v25, v26 = u3._calculatePlayerInputValues(p23);
    Humanoid:Move(v24);
    Humanoid.AutoRotate = not v26;

    if v26 and (Humanoid.SeatPart == nil and (Humanoid.RootPart ~= nil and not (Humanoid.Sit or Humanoid.RootPart:IsGrounded()))) then
        Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + v25);
    end;

    local v27;

    if JumpAction == nil then
        v27 = false;
    else
        v27 = JumpAction:GetState();
    end;

    Humanoid.Jump = v27;
end;

function u3.setupPlayerControlState(p28) -- Line: 230
    p28:AddVector3Field("Move", Vector3.new(0, 0, 0), 1);
    p28:AddBoolField("Jump", false);
    p28:AddBoolField("RotateToLookDirection", false);
    p28:AddUnitVector3Field("LookDirection", Vector3.new(0, 0, 1));
end;

function u3.watchForPlayerControlState(p29: userdata) -- Line: 238
    -- upvalues: u2 (copy), u3 (copy)
    local function watchCharacter(p30: userdata) -- Line: 239
        -- upvalues: u2 (ref), u3 (ref)
        local function onPCSAdded(p31: userdata) -- Line: 240
            -- upvalues: u2 (ref), u3 (ref)
            if p31:IsA(u2) then
                u3.setupPlayerControlState(p31);
            end;
        end;

        local v32 = p30:FindFirstChildOfClass(u2);

        if v32 then
            u3.setupPlayerControlState(v32);
        end;

        p30.ChildAdded:Connect(onPCSAdded);
    end;

    if p29.Character then
        local Character = p29.Character;

        local function v34(p33: userdata) -- Line: 240
            -- upvalues: u2 (ref), u3 (ref)
            if p33:IsA(u2) then
                u3.setupPlayerControlState(p33);
            end;
        end;

        local v35 = Character:FindFirstChildOfClass(u2);

        if v35 then
            u3.setupPlayerControlState(v35);
        end;

        Character.ChildAdded:Connect(v34);
    end;

    p29.CharacterAdded:Connect(watchCharacter);
end;

function u3.createPlayerControlState(u36: userdata) -- Line: 254
    -- upvalues: UserFlag6 (copy), u2 (copy), u3 (copy)
    local function createForCharacter(p37: userdata) -- Line: 255
        -- upvalues: UserFlag6 (ref), u2 (ref), u36 (copy), u3 (ref)
        if UserFlag6 then
            if p37:FindFirstChildOfClass(u2) then
                return;
            end;
        elseif p37:FindFirstChild(u2) then
            return;
        end;

        local Instance_new_ret = Instance.new(u2);
        Instance_new_ret.Owner = u36;
        Instance_new_ret.Parent = p37;
        u3.setupPlayerControlState(Instance_new_ret);
    end;

    if u36.Character then
        local Character = u36.Character;
        local v38;

        if UserFlag6 then
            if not Character:FindFirstChildOfClass(u2) then
                v38 = Instance.new(u2);
                v38.Owner = u36;
                v38.Parent = Character;
                u3.setupPlayerControlState(v38);
            end;
        elseif not Character:FindFirstChild(u2) then
            v38 = Instance.new(u2);
            v38.Owner = u36;
            v38.Parent = Character;
            u3.setupPlayerControlState(v38);
        end;
    end;

    u36.CharacterAdded:Connect(createForCharacter);
end;

function u3.writeInputToPCS(p39: userdata, p40: any, p41: boolean) -- Line: 271
    -- upvalues: UserFlag6 (copy), u2 (copy), UserGameSettings (copy), Workspace (copy), UserFlag5 (copy), AvatarAbilitiesInterface (copy)
    local Character = p39.Character;

    if not Character then
        return;
    end;

    local v42;

    if UserFlag6 then
        v42 = Character:FindFirstChildOfClass(u2);
    else
        v42 = Character:FindFirstChild(u2);
    end;

    if not v42 then
        return;
    end;

    local humanoid = p40.humanoid;

    if not humanoid then
        return;
    end;

    local v43;

    if p41 then
        v43 = p39:FindFirstChild("InputContexts");
    else
        v43 = script.Parent.Parent:FindFirstChild("InputContexts");
    end;

    if v43 then
        v43 = v43:FindFirstChild("CharacterContext");
    end;

    if not v43 then
        return;
    end;

    local MoveAction = v43:FindFirstChild("MoveAction");
    local JumpAction = v43:FindFirstChild("JumpAction");
    local v44;

    if MoveAction then
        v44 = MoveAction:GetState();
    else
        v44 = Vector2.zero;
    end;

    local v45;

    if JumpAction then
        v45 = JumpAction:GetState();
    else
        v45 = false;
    end;

    local v46 = p40:calculateRawMoveVector(humanoid, (Vector3.new(v44.X, 0, -v44.Y)));
    local v47 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative;
    local v48 = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1);
    local Vector3_new_ret = Vector3.new(v48.X, 0, v48.Z);
    local v49 = {
        Move = v46,
        RotateToLookDirection = v47,
        LookDirection = Vector3_new_ret.Magnitude <= 0.001 and Vector3.new(0, 0, 1) or Vector3_new_ret.Unit
    };

    if not (UserFlag5 and AvatarAbilitiesInterface.get(p39):isEnabled()) then
        v49.Jump = v45;
    end;

    v42:UpdateFields(v49);
end;

function u3.processPCSInputs(p50: userdata) -- Line: 309
    -- upvalues: UserFlag6 (copy), u2 (copy)
    local Character = p50.Character;

    if Character == nil then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if Humanoid == nil then
        return;
    end;

    local v51;

    if UserFlag6 then
        v51 = Character:FindFirstChildOfClass(u2);
    else
        v51 = Character:FindFirstChild(u2);
    end;

    if v51 == nil then
        return;
    end;

    local State = v51:GetState();
    local Move = State.Move;
    local Jump = State.Jump;
    local RotateToLookDirection = State.RotateToLookDirection;
    local LookDirection = State.LookDirection;

    if Move then
        Humanoid:Move(Move);
    end;

    Humanoid.AutoRotate = not RotateToLookDirection;

    if RotateToLookDirection and (LookDirection ~= nil and (Humanoid.RootPart ~= nil and not (Humanoid.Sit or (Humanoid.SeatPart ~= nil or Humanoid.RootPart:IsGrounded())))) then
        Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + LookDirection);
    end;

    Humanoid.Jump = Jump or false;
end;

return u3;