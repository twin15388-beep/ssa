-- Decompiled with Potassium's decompiler.

task.wait();

function Tick()
    return workspace:GetServerTimeNow();
end;

local Character_info_provider = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Character_info_provider"));
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local RaycastHelper = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("RaycastHelper"));
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
local CollectionService = game:GetService("CollectionService");
local NpcAnimDistanceGating = gameSettings.NpcAnimDistanceGating;
local u1;

if NpcAnimDistanceGating == 2 then
    u1 = false;
else
    u1 = NpcAnimDistanceGating ~= false;
end;

if typeof(NpcAnimDistanceGating) ~= "number" or (NpcAnimDistanceGating == 1 or NpcAnimDistanceGating == 2) then
    NpcAnimDistanceGating = nil;
end;

local workspace_CurrentCamera = workspace.CurrentCamera;
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 56
    -- upvalues: workspace_CurrentCamera (ref)
    workspace_CurrentCamera = workspace.CurrentCamera;
end);
local u2 = {};
local u3 = { {}, {}, {} };
local Random_new_ret = Random.new();
local u4 = {};
local u5 = NpcAnimDistanceGating == nil and { nil, 0.5, 1.5 } or { 1, 1.5, 2 };
local u6 = nil;
local u7 = nil;

local function bandInsert(p8, p9, p10) -- Line: 91
    -- upvalues: u3 (copy), u4 (copy), u6 (ref)
    u3[p10][p8] = p9;
    p9.Band = p10;

    if u4[p10] == nil then
        u6(p10);
    end;
end;

local u11 = {
    Default = 2,
    idle = 1
};
local u12 = { "flee1", "flee2" };
local u13 = { "flee", "fleedamaged", "cower" };

function ClearCivilian(p14)
    if p14.CivilianAnim then
        p14.CivilianAnim:Stop(0.3);
        p14.CivilianAnim = nil;
    end;

    if p14.CivilianDisconnect then
        p14.CivilianDisconnect:Disconnect();
        p14.CivilianDisconnect = nil;
    end;

    p14.CivilianVariant = nil;
    p14.CivilianAnimItem = nil;
end;

function UnloadTracks(p15)
    if p15.Anim then
        p15.Anim:Stop(0.3);
        p15.Anim = nil;
    end;

    p15.CurrentInstance = nil;

    if p15.CivilianAnim then
        p15.CivilianAnim:Stop(0.3);
        p15.CivilianAnim = nil;
    end;

    p15.CivilianAnimItem = nil;
end;

function Clear(p16)
    -- upvalues: u2 (copy), u3 (copy)
    if u2[p16] then
        ClearCivilian(u2[p16]);

        if u2[p16].Anim then
            u2[p16].Anim:Stop();
            u2[p16].Anim = nil;
        end;

        if u2[p16].Disconnect then
            u2[p16].Disconnect:Disconnect();
            u2[p16].Disconnect = nil;
        end;

        if u2[p16].AggroDisconnect then
            u2[p16].AggroDisconnect:Disconnect();
            u2[p16].AggroDisconnect = nil;
        end;

        local v17 = u3[u2[p16].Band];

        if v17 ~= nil then
            v17[p16] = nil;
        end;

        u2[p16] = nil;
    end;
end;

function Handle(u18)
    -- upvalues: u2 (copy), u1 (copy), u3 (copy), u4 (copy), u6 (ref), NpcAnimDistanceGating (copy), u7 (ref), Character_info_provider (copy), u11 (copy), u13 (copy), u12 (copy)
    local Parent = u18.Parent;

    if Parent == nil then
        return;
    end;

    Parent:WaitForChild("ClientAnimatorServer", 5);
    local v19 = Parent:FindFirstChild("Humanoid") or Parent:WaitForChild("Humanoid", 8);

    if v19 ~= nil then
        v19:WaitForChild("Animator", 5);
    end;

    Clear(u18);

    if Parent == nil or Parent:FindFirstChild("ClientAnimatorServer") == nil then
        return;
    end;

    local ClientAnimatorServer = Parent.ClientAnimatorServer;
    local CurrentAnim = ClientAnimatorServer.CurrentAnim;
    local u20 = {
        Active = false,
        Band = 1,
        CurrentInstance = nil,
        Parent = Parent,
        Root = Parent:FindFirstChild("HumanoidRootPart") or u18
    };
    u2[u18] = u20;

    if u1 then
        u3[1][u18] = u20;
        u20.Band = 1;

        if u4[1] == nil then
            u6(1);
        end;

        if NpcAnimDistanceGating == nil then
            u20.AggroDisconnect = Parent:GetAttributeChangedSignal("Aggroed"):Connect(function() -- Line: 189
                -- upvalues: u2 (ref), u18 (copy), u20 (copy), Parent (copy), u3 (ref), u4 (ref), u6 (ref), u7 (ref)
                if u2[u18] ~= u20 then
                    return;
                end;

                if Parent:GetAttribute("Aggroed") ~= true then
                    return;
                end;

                if u20.Band ~= 1 then
                    u3[u20.Band][u18] = nil;
                    local v21 = u20;
                    u3[1][u18] = v21;
                    v21.Band = 1;

                    if u4[1] == nil then
                        u6(1);
                    end;
                end;

                u7(u20, true);
            end);
        end;
    end;

    local Anims = ClientAnimatorServer:FindFirstChild("Anims");

    local function updAnim() -- Line: 201
        -- upvalues: u18 (copy), u2 (ref), Anims (copy), CurrentAnim (copy), Character_info_provider (ref), Parent (copy), u20 (copy), ClientAnimatorServer (copy), u11 (ref)
        if u18 == nil or u18.Parent == nil then
            return;
        end;

        if u2[u18] == nil or u2[u18].Active ~= true then
            return;
        end;

        local v22 = Anims ~= nil and Anims:FindFirstChild(CurrentAnim.Value) or nil;

        if v22 == nil or (v22:GetAttribute("Custom") ~= true or not v22) then
            v22 = Character_info_provider.get_core_anim(Parent, CurrentAnim.Value, true) or v22;
        end;

        if v22 == nil then
            return;
        end;

        if u20.CurrentInstance ~= v22 then
            if u20.Anim then
                u20.Anim:Stop(0.3);
                u20.Anim = nil;
            end;

            if Parent.Parent == workspace.Debree then
                return;
            end;

            local Humanoid = Parent:FindFirstChild("Humanoid");
            local v23;

            if Humanoid == nil then
                v23 = nil;
            else
                v23 = Humanoid:FindFirstChildOfClass("Animator") or nil;
            end;

            if v23 == nil then
                return;
            end;

            if u18.Parent == nil or (u2[u18] == nil or u20.Active ~= true) then
                return;
            end;

            u20.Anim = v23:LoadAnimation(v22);
            local v24 = 999;

            if u20.Anim.Length > 0 then
                v24 = u20.Anim.Length or v24;
            end;

            local v25 = (Tick() - ClientAnimatorServer.LastSwap.Value) % u20.Anim.Length;
            local math_min_ret = math.min(v25, v24 - 0.01);
            u20.Anim:Play(0.3);
            u20.Anim.TimePosition = math_min_ret ~= math_min_ret and 0 or math_min_ret;
            u20.Anim:AdjustWeight(u11[CurrentAnim.Value] or 2);
            u20.CurrentInstance = v22;
        end;
    end;

    u20.UpdAnim = updAnim;
    u20.Disconnect = CurrentAnim.Changed:Connect(updAnim);

    local function updCivilian() -- Line: 242
        -- upvalues: u2 (ref), u18 (copy), u20 (copy), Parent (copy), u13 (ref), u12 (ref), Character_info_provider (ref)
        if u2[u18] == nil or u20.Active ~= true then
            return;
        end;

        local Attribute = Parent:GetAttribute("CivilianState");

        if Attribute == nil or Attribute == 0 then
            if u20.CivilianAnim then
                u20.CivilianAnim:Stop(0.3);
                u20.CivilianAnim = nil;
            end;

            u20.CivilianVariant = nil;
            u20.CivilianAnimItem = nil;

            return;
        end;

        local v26 = u13[Attribute];

        if v26 == nil then
            return;
        end;

        if v26 == "flee" then
            if u20.CivilianVariant == nil then
                u20.CivilianVariant = u12[math.random(1, #u12)];
            end;

            v26 = u20.CivilianVariant;
        else
            u20.CivilianVariant = nil;
        end;

        local _core_anim = Character_info_provider.get_core_anim(Parent, v26, true);

        if _core_anim == nil then
            return;
        end;

        if u20.CivilianAnimItem == _core_anim then
            return;
        end;

        local Humanoid = Parent:FindFirstChild("Humanoid");
        local v27;

        if Humanoid == nil then
            v27 = nil;
        else
            v27 = Humanoid:FindFirstChildOfClass("Animator") or nil;
        end;

        if v27 == nil then
            return;
        end;

        if u18.Parent == nil or (u2[u18] == nil or u20.Active ~= true) then
            return;
        end;

        if u20.CivilianAnim then
            u20.CivilianAnim:Stop(0.3);
        end;

        u20.CivilianAnimItem = _core_anim;
        u20.CivilianAnim = v27:LoadAnimation(_core_anim);
        u20.CivilianAnim:Play(0.3);
    end;

    u20.UpdCivilian = updCivilian;
    u20.CivilianDisconnect = Parent:GetAttributeChangedSignal("CivilianState"):Connect(updCivilian);

    if not u1 then
        u20.Active = true;
        updAnim();
        updCivilian();
    end;
end;

u7 = function(p28, p29) -- Line: 293
    if p29 ~= p28.Active then
        p28.Active = p29;

        if p29 then
            if p28.UpdAnim then
                p28.UpdAnim();
            end;

            if p28.UpdCivilian then
                p28.UpdCivilian();
            end;
        else
            UnloadTracks(p28);
        end;
    end;
end;

local function processRig(p30, p31, p32, p33) -- Line: 305
    -- upvalues: NpcAnimDistanceGating (copy), u3 (copy), u4 (copy), u6 (ref), u7 (ref), Utility (copy), RaycastHelper (copy)
    local Parent = p31.Parent;

    if Parent == nil or Parent.Parent == nil then
        return;
    end;

    local Root = p31.Root;

    if Root == nil or Root.Parent == nil then
        return;
    end;

    if NpcAnimDistanceGating == nil and Parent:GetAttribute("Aggroed") == true then
        if p31.Band ~= 1 then
            u3[p31.Band][p30] = nil;
            u3[1][p30] = p31;
            p31.Band = 1;

            if u4[1] == nil then
                u6(1);
            end;
        end;

        u7(p31, true);

        return;
    end;

    local v34 = Root.Position - p32;
    local v35;

    if NpcAnimDistanceGating == nil then
        local Attribute = Parent:GetAttribute("PlayAnimDistance");

        if Attribute == nil and Utility.IsMeshRig(Parent) then
            Attribute = false;
        end;

        v35 = Attribute == false and (1 / 0) or (typeof(Attribute) ~= "number" and 200 or Attribute);
    else
        v35 = NpcAnimDistanceGating;
    end;

    local Magnitude = v34.Magnitude;
    local v36 = Magnitude <= v35 + (NpcAnimDistanceGating == nil and 75 or 0) and 1 or (Magnitude <= v35 + 200 and 2 or 3);

    if v36 ~= p31.Band then
        u3[p31.Band][p30] = nil;
        u3[v36][p30] = p31;
        p31.Band = v36;

        if u4[v36] == nil then
            u6(v36);
        end;
    end;

    local v37 = false;

    if v36 == 1 then
        if NpcAnimDistanceGating == nil and Magnitude > 25 then
            if Magnitude > 0 then
                local v38 = v34:Dot(p33) / Magnitude;

                if (Magnitude <= v35 and true or v38 >= 0.95) and v38 > 0 then
                    v37 = workspace:Raycast(p32, v34, RaycastHelper.Map) == nil;
                end;
            end;
        else
            v37 = true;
        end;
    end;

    u7(p31, v37);
end;

u6 = function(u39) -- Line: 383
    -- upvalues: Random_new_ret (copy), u4 (copy), u5 (copy), u3 (copy), workspace_CurrentCamera (ref), processRig (copy)
    local u40 = Random_new_ret:NextNumber();
    u4[u39] = u40;
    local u41 = u5[u39];
    task.spawn(function() -- Line: 387
        -- upvalues: u4 (ref), u39 (copy), u40 (copy), u41 (copy), u3 (ref), workspace_CurrentCamera (ref), processRig (ref)
        while u4[u39] == u40 do
            if u41 == nil then
                task.wait();
            else
                task.wait(u41);
            end;

            if u4[u39] ~= u40 then
                break;
            end;

            if next(u3[u39]) == nil then
                u4[u39] = nil;

                return;
            end;

            local v42 = workspace_CurrentCamera;

            if v42 ~= nil then
                local CFrame = v42.CFrame;
                local Position = CFrame.Position;
                local LookVector = CFrame.LookVector;

                for i, v in pairs(u3[u39]) do
                    processRig(i, v, Position, LookVector);
                end;
            end;
        end;
    end);
end;

for _, v in pairs(CollectionService:GetTagged("ClientAnimTagForNpc")) do
    task.spawn(Handle, v);
end;

CollectionService:GetInstanceAddedSignal("ClientAnimTagForNpc"):Connect(Handle);
CollectionService:GetInstanceRemovedSignal("ClientAnimTagForNpc"):Connect(Clear);