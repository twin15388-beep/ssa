-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local Global = CAM:WaitForChild("Global");
local Skills = ReplicatedStorage:WaitForChild("Skills");
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local Utility = require(Global:WaitForChild("Utility"));
local DebrisModule = require(CAM:WaitForChild("DebrisModule"));
local ServerClientPortal = require(Global:WaitForChild("ServerClientPortal"));
local Run_Handler = require(CAM:WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Run_Handler"));
local Config = require(script.Parent.Config);
local u1 = {
    Id = 0
};
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local skill_stand_still = Skills:WaitForChild("holder"):WaitForChild("skill_stand_still");
local Name = script.Parent.Name;
local u2 = cleanit.new();
local u3 = cleanit.new();
local u4 = nil;

local function enhancedHearingClip() -- Line: 48
    -- upvalues: Skills (copy)
    local Clan = Skills:FindFirstChild("Clan");
    local v5 = Clan ~= nil and Clan:FindFirstChild("Enhanced Hearing") or nil;
    local v6 = v5 ~= nil and v5:FindFirstChild("Enhanced Hearing") or nil;

    if v6 == nil then
        return nil;
    end;

    local v7 = v6:FindFirstChild("EnhancedHearing") or v6:FindFirstChild("Animation");

    if v7 == nil or not v7:IsA("Animation") then
        return nil;
    end;

    return v7;
end;

local function stopWatch() -- Line: 57
    -- upvalues: u3 (copy), u4 (ref)
    u3:Clean();

    if u4 ~= nil and u4.__Active then
        u4:Destroy();
    end;

    u4 = nil;
end;

local function startWatch(u8: userdata) -- Line: 67
    -- upvalues: u3 (copy), u4 (ref), ServerClientPortal (copy), Name (copy), Config (copy), Run_Handler (copy)
    u3:Clean();

    if u4 ~= nil and u4.__Active then
        u4:Destroy();
    end;

    u4 = nil;
    local v9 = ServerClientPortal.Link(Name, Config.WINDUP + Config.DURATION + 1);
    u4 = v9;
    local u10 = false;
    local u11 = false;

    local function report(p12: boolean?) -- Line: 73
        -- upvalues: u10 (ref), Run_Handler (ref), u8 (copy), Config (ref), u11 (ref), ServerClientPortal (ref), Name (ref)
        if not u10 then
            return;
        end;

        local v13;

        if Run_Handler.Is_Running == true then
            v13 = u8.MoveDirection.Magnitude > Config.MOVE_THRESHOLD;
        else
            v13 = false;
        end;

        if v13 == u11 and not p12 then
            return;
        end;

        u11 = v13;
        ServerClientPortal.Server(Name, u11);
    end;

    v9:Connect(function(p14) -- Line: 81
        -- upvalues: u10 (ref), Run_Handler (ref), u8 (copy), Config (ref), u11 (ref), ServerClientPortal (ref), Name (ref), u3 (ref), u4 (ref)
        if p14 ~= "Start" then
            if p14 == "End" then
                u3:Clean();

                if u4 ~= nil and u4.__Active then
                    u4:Destroy();
                end;

                u4 = nil;
            end;

            return;
        end;

        u10 = true;

        if not u10 then
            return;
        end;

        local v15;

        if Run_Handler.Is_Running == true then
            v15 = u8.MoveDirection.Magnitude > Config.MOVE_THRESHOLD;
        else
            v15 = false;
        end;

        local _ = v15 == u11;
        u11 = v15;
        ServerClientPortal.Server(Name, u11);
    end);
    u3:Connect(Run_Handler.RunningChanged.Event, function() -- Line: 90
        -- upvalues: u10 (ref), Run_Handler (ref), u8 (copy), Config (ref), u11 (ref), ServerClientPortal (ref), Name (ref)
        if not u10 then
            return;
        end;

        local v16;

        if Run_Handler.Is_Running == true then
            v16 = u8.MoveDirection.Magnitude > Config.MOVE_THRESHOLD;
        else
            v16 = false;
        end;

        if v16 == u11 then
            return;
        end;

        u11 = v16;
        ServerClientPortal.Server(Name, u11);
    end);
    u3:Connect(u8:GetPropertyChangedSignal("MoveDirection"), function() -- Line: 93
        -- upvalues: u10 (ref), Run_Handler (ref), u8 (copy), Config (ref), u11 (ref), ServerClientPortal (ref), Name (ref)
        if not u10 then
            return;
        end;

        local v17;

        if Run_Handler.Is_Running == true then
            v17 = u8.MoveDirection.Magnitude > Config.MOVE_THRESHOLD;
        else
            v17 = false;
        end;

        if v17 == u11 then
            return;
        end;

        u11 = v17;
        ServerClientPortal.Server(Name, u11);
    end);
end;

function u1.Hold(p18: userdata) -- Line: 98
    -- upvalues: u2 (copy), u1 (copy), skill_stand_still (copy), DebrisModule (copy), Config (copy), Utility (copy), valuesfolder (copy), enhancedHearingClip (copy), startWatch (copy)
    if p18 == nil then
        return false;
    end;

    local Character = p18.Character;

    if Character == nil then
        return false;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v19 = Character:FindFirstChildOfClass("Humanoid");

    if HumanoidRootPart == nil or v19 == nil then
        return false;
    end;

    u2:Clean();
    local Id = u1.Id;
    local v20 = skill_stand_still:Clone();
    v20.Parent = HumanoidRootPart;
    u2:Add(v20);
    DebrisModule:AddItem(v20, Config.WINDUP);
    u2:Add(Utility.AddValue(valuesfolder, "NR", Config.WINDUP));
    local v21 = enhancedHearingClip();
    local v22 = v19:FindFirstChildOfClass("Animator");
    local u23;

    if v21 == nil or v22 == nil then
        u23 = nil;
    else
        u23 = v22:LoadAnimation(v21);
        u2:Add(u23);
        u23:Play();
        u23.Stopped:Once(function() -- Line: 127
            -- upvalues: u23 (copy)
            u23:Destroy();
        end);
    end;

    startWatch(v19);
    task.wait(Config.WINDUP);

    if Id ~= u1.Id then
        return true;
    end;

    if u23 ~= nil then
        u2:Remove(u23);
    end;

    u2:Clean();

    return true;
end;

function u1.Cancel(p24: userdata) -- Line: 143
    -- upvalues: u2 (copy)
    u2:Clean();
end;

return u1;