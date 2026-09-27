-- Decompiled with Potassium's decompiler.

local LocalPlayer = game.Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local u1 = {
    Shift_lock = 1
};
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local RunService = game:GetService("RunService");
local gameSettings = require(game:GetService("ReplicatedStorage"):WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
u1.Test = "";
u1.Forced = "";
local u2 = {
    PC = 1,
    Mobile = 2,
    Xbox = 3,
    Playstation = 4
};
local u3 = RunService:IsStudio();

function u1.update_platform() -- Line: 44
    -- upvalues: UserInputService (copy), u1 (copy), u2 (copy), u3 (copy)
    local v4, v5;

    if game.Players.LocalPlayer:FindFirstChild("PlayerGui") == nil or (game.Players.LocalPlayer.PlayerGui:FindFirstChild("TouchGui") == nil or (game.Players.LocalPlayer.PlayerGui.TouchGui:FindFirstChild("TouchControlFrame") == nil or game.Players.LocalPlayer.PlayerGui.TouchGui.TouchControlFrame:FindFirstChild("JumpButton") == nil)) then
        v4 = "PC";
        v5 = 1;
    else
        v4 = "Mobile";
        v5 = 2;
    end;

    if v4 ~= "Mobile" and (UserInputService.TouchEnabled and not (UserInputService.KeyboardEnabled or UserInputService.MouseEnabled)) then
        v4 = "Mobile";
        v5 = 2;
    end;

    if UserInputService.GamepadEnabled == true and v4 ~= "Mobile" then
        local LastInputType = UserInputService:GetLastInputType();

        if LastInputType ~= Enum.UserInputType.Keyboard and LastInputType.Name:sub(1, 5) ~= "Mouse" then
            if UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonY) == "ButtonTriangle" then
                v4 = "Playstation";
                v5 = 4;
            else
                v4 = "Xbox";
                v5 = 3;
            end;
        end;
    end;

    if u1.Forced == "Console" then
        if v4 ~= "Xbox" and v4 ~= "Playstation" then
            v4 = "Xbox";
            v5 = 3;
        end;
    elseif u2[u1.Forced] ~= nil then
        v4 = u1.Forced;
        v5 = u2[u1.Forced];
    end;

    if u3 and u2[u1.Test] ~= nil then
        v4 = u1.Test;
        v5 = u2[u1.Test];
    end;

    if u1.Platform.Value ~= v4 then
        u1.Platform.Value = v4;
        u1.Platform.Id = v5;
        u1.Platform.Changed:Fire(v4, v5);
    end;

    local v6;

    if v4 == "Xbox" then
        v6 = false;
    else
        v6 = v4 ~= "Playstation";
    end;

    UserInputService.MouseIconEnabled = v6;

    return v4, v5;
end;

u1.Apply = u1.update_platform;
u1.Platform = {
    Value = "",
    Id = 0,
    Changed = script:WaitForChild("Event")
};
local v7, v8 = u1.update_platform();
u1.Platform.Value = v7;
u1.Platform.Id = v8;
UserInputService.GamepadConnected:Connect(u1.update_platform);
UserInputService.GamepadDisconnected:Connect(u1.update_platform);
UserInputService.LastInputTypeChanged:Connect(u1.update_platform);
task.spawn(function() -- Line: 116
    -- upvalues: LocalPlayer (copy), u1 (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 30);

    if PlayerGui == nil then
        return;
    end;

    PlayerGui.DescendantAdded:Connect(function(p9: userdata) -- Line: 119
        -- upvalues: u1 (ref)
        if p9.Name == "JumpButton" or p9.Name == "TouchGui" then
            task.defer(u1.update_platform);
        end;
    end);
    u1.update_platform();
end);

function u1.ShowsKeyLabels() -- Line: 131
    -- upvalues: u1 (copy)
    return u1.Platform.Value == "PC";
end;

function u1.IsGamepad() -- Line: 138
    -- upvalues: u1 (copy)
    return u1.Platform.Value == "Xbox" and true or u1.Platform.Value == "Playstation";
end;

function u1.KeyLabelOffset() -- Line: 143
    -- upvalues: u1 (copy), gameSettings (copy)
    return not u1.ShowsKeyLabels() and 0 or gameSettings.KeybindTextOffset;
end;

function u1.Get_Key_Visual(p10) -- Line: 147
    -- upvalues: UserInputService (copy)
    if p10 ~= nil then
        local ImageForKeyCode = UserInputService:GetImageForKeyCode(Enum.KeyCode[p10]);
        local v11;

        if ImageForKeyCode and #ImageForKeyCode > 0 then
            v11 = "Image";
        else
            ImageForKeyCode = p10;
            v11 = "Text";
        end;

        return ImageForKeyCode, v11;
    end;
end;

local u12 = nil;
local u13 = nil;
local Vector2_zero = Vector2.zero;
local Vector2_zero2 = Vector2.zero;
local u14 = 0;
local u15 = 0;
local u16 = false;

local function pointerOf(p17: userdata) -- Line: 200
    -- upvalues: UserInputService (copy), GuiService (copy)
    if p17.UserInputType == Enum.UserInputType.Touch then
        return Vector2.new(p17.Position.X, p17.Position.Y);
    end;

    return UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
end;

local u18 = {
    Dash = true,
    Blocking = true,
    ["Double Jump"] = true
};

local function heldSkill() -- Line: 225
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v19;

    if Character == nil then
        v19 = nil;
    else
        v19 = Character:FindFirstChild("SHC");
    end;

    return v19 == nil and "" or v19.Value;
end;

local function holdingSkill() -- Line: 232
    -- upvalues: LocalPlayer (copy), u18 (copy)
    local Character = LocalPlayer.Character;
    local v20;

    if Character == nil then
        v20 = nil;
    else
        v20 = Character:FindFirstChild("SHC");
    end;

    local v21 = v20 == nil and "" or v20.Value;
    local v22;

    if v21 == "" then
        v22 = false;
    else
        v22 = u18[v21] ~= true;
    end;

    return v22;
end;

function u1.AimCentre() -- Line: 236
    -- upvalues: GuiService (copy)
    local GuiInset = GuiService:GetGuiInset();
    local ViewportSize = workspace.CurrentCamera.ViewportSize;

    return Vector2.new(ViewportSize.X / 2 - GuiInset.X, ViewportSize.Y / 2 - GuiInset.Y);
end;

function u1.HoldingSkill() -- Line: 242
    -- upvalues: LocalPlayer (copy), u18 (copy)
    local Character = LocalPlayer.Character;
    local v23;

    if Character == nil then
        v23 = nil;
    else
        v23 = Character:FindFirstChild("SHC");
    end;

    local v24 = v23 == nil and "" or v23.Value;
    local v25;

    if v24 == "" then
        v25 = false;
    else
        v25 = u18[v24] ~= true;
    end;

    return v25;
end;

function u1.AimActive() -- Line: 248
    -- upvalues: u1 (copy), LocalPlayer (copy), u18 (copy), u15 (ref), u14 (ref), u16 (ref)
    if u1.Platform.Value ~= "Mobile" then
        if not u1.IsGamepad() then
            return false;
        end;

        local Character = LocalPlayer.Character;
        local v26;

        if Character == nil then
            v26 = nil;
        else
            v26 = Character:FindFirstChild("SHC");
        end;

        local v27 = v26 == nil and "" or v26.Value;
        local v28;

        if v27 == "" then
            v28 = false;
        else
            v28 = u18[v27] ~= true;
        end;

        return v28 or u16;
    end;

    local os_clock_ret = os.clock();
    local Character = LocalPlayer.Character;
    local v29;

    if Character == nil then
        v29 = nil;
    else
        v29 = Character:FindFirstChild("SHC");
    end;

    local v30 = v29 == nil and "" or v29.Value;
    local v31;

    if v30 == "" then
        v31 = false;
    else
        v31 = u18[v30] ~= true;
    end;

    if v31 then
        u15 = os_clock_ret;

        return true;
    end;

    local v32;

    if os_clock_ret - u15 <= 1 then
        v32 = os_clock_ret - u14 <= 0.3;
    else
        v32 = false;
    end;

    return v32;
end;

function u1.SetAimLock(p33: boolean) -- Line: 264
    -- upvalues: u16 (ref)
    u16 = p33 == true;
end;

function u1.BeginAim(p34: userdata) -- Line: 269
    -- upvalues: u1 (copy), Vector2_zero2 (ref), u12 (ref), u13 (ref), UserInputService (copy), GuiService (copy), Vector2_zero (ref)
    if not u1.AimActive() then
        Vector2_zero2 = Vector2.zero;
    end;

    u12 = p34;
    local v35;

    if p34.UserInputType == Enum.UserInputType.Touch then
        v35 = Vector2.new(p34.Position.X, p34.Position.Y);
    else
        v35 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
    end;

    u13 = v35;
    Vector2_zero = Vector2_zero2;
end;

function u1.EndAim(p36: userdata) -- Line: 278
    -- upvalues: u12 (ref), u13 (ref)
    if p36 ~= u12 then
        return;
    end;

    u12 = nil;
    u13 = nil;
end;

local u37 = nil;

function u1.SkillDragTurnsCamera() -- Line: 291
    -- upvalues: u37 (ref)
    if u37 == nil then
        local SettingsKeys = require(game:GetService("ReplicatedStorage").CAM.Global.Subsets.Gameplay.SettingsKeys);
        local DataValue = require(game:GetService("ReplicatedStorage").CAM.Client.Modules.DataValue);
        local MobileSkillDragTurnsCamera = SettingsKeys.MobileSkillDragTurnsCamera;
        u37 = DataValue.new(MobileSkillDragTurnsCamera.Path, MobileSkillDragTurnsCamera.Default, SettingsKeys.Scope);
    end;

    return u37:Get() == true;
end;

function u1.AimInput() -- Line: 303
    -- upvalues: u12 (ref)
    return u12;
end;

function u1.AimPoint() -- Line: 306
    -- upvalues: u1 (copy), Mouse (copy), u12 (ref), u13 (ref), Vector2_zero2 (ref), Vector2_zero (ref), UserInputService (copy), GuiService (copy)
    if u1.Platform.Value ~= "Mobile" and not u1.IsGamepad() then
        return Vector2.new(Mouse.X, Mouse.Y);
    end;

    local v38 = u1.AimCentre();
    local v39 = u12;
    local v40 = u13;

    if v39 ~= nil and (v40 ~= nil and not u1.SkillDragTurnsCamera()) then
        local v41;

        if v39.UserInputType == Enum.UserInputType.Touch then
            v41 = Vector2.new(v39.Position.X, v39.Position.Y);
        else
            v41 = UserInputService:GetMouseLocation() - GuiService:GetGuiInset();
        end;

        Vector2_zero2 = Vector2_zero + (v41 - v40);
    end;

    local v42 = workspace.CurrentCamera.ViewportSize - GuiService:GetGuiInset();
    local v43 = v38 + Vector2_zero2;

    return Vector2.new(math.clamp(v43.X, 0, v42.X), (math.clamp(v43.Y, 0, v42.Y)));
end;

function u1.NudgeAim(p44) -- Line: 328
    -- upvalues: Vector2_zero2 (ref), u12 (ref), Vector2_zero (ref)
    Vector2_zero2 = Vector2_zero2 + p44;

    if u12 ~= nil then
        Vector2_zero = Vector2_zero + p44;
    end;
end;

function getmouse_cor(p45: string?)
    -- upvalues: u18 (copy), LocalPlayer (copy), u14 (ref), u1 (copy)
    if not p45 then
        local Character = LocalPlayer.Character;
        local v46;

        if Character == nil then
            v46 = nil;
        else
            v46 = Character:FindFirstChild("SHC");
        end;

        p45 = v46 == nil and "" or v46.Value;
    end;

    if u18[p45] ~= true then
        u14 = os.clock();
    end;

    local v47 = u1.AimPoint();

    return v47.X, v47.Y;
end;

local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Debree };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
local u48 = nil;
local table_find = table.find;

function u1.mousepos(p49: number?, p50: userdata?, p51: string?) -- Line: 378
    -- upvalues: LocalPlayer (copy), u48 (ref), table_find (copy), RaycastParams_new_ret (copy), workspace_CurrentCamera (copy)
    if LocalPlayer.Character ~= nil and (u48 ~= LocalPlayer.Character and table_find(RaycastParams_new_ret.FilterDescendantsInstances, LocalPlayer.Character) == nil) then
        RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Debree, LocalPlayer.Character };
        u48 = LocalPlayer.Character;
    end;

    local v52, v53 = getmouse_cor(p51);
    local v54 = workspace_CurrentCamera:ScreenPointToRay(v52, v53);
    local v55 = v54.Direction * math.max(p49 or 500, 500);
    local v56 = nil;

    if p50 ~= nil then
        local v57 = workspace:Raycast(v54.Origin, v55, p50);

        if v57 ~= nil and v57.Position ~= nil then
            v56 = v57.Position;
        end;
    end;

    if v56 == nil then
        local v58 = workspace:Raycast(v54.Origin, v55, RaycastParams_new_ret);
        v56 = v58 ~= nil and v58.Position ~= nil and v58.Position or v54.Origin + v55;
    end;

    if p49 ~= nil then
        local v59;

        if LocalPlayer.Character == nil then
            v59 = false;
        else
            v59 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
        end;

        if v59 ~= nil then
            local v60 = v56 - v59.Position;

            if p49 < v60.Magnitude then
                v56 = v59.Position + v60.Unit * p49;
            end;
        end;
    end;

    return v56;
end;

function u1.getMouseDirection(p61: vector?, p62: userdata?) -- Line: 408
    -- upvalues: u1 (copy)
    if p61 == nil then
        p61 = u1.mousepos();
    end;

    if p62 == nil and game.Players.LocalPlayer.Character ~= nil then
        p62 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position;
    end;

    local v63 = p61 - vector.create(p62.X, p61.Y, p62.Z);

    return vector.normalize(v63);
end;

return u1;