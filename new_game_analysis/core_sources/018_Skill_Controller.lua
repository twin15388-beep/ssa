-- Decompiled with Potassium's decompiler.

local script_Settings = require(script.Settings);
local LocalPlayer = game.Players.LocalPlayer;
local UserInputService = game:GetService("UserInputService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skills_Module = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Skills_Module"));
local PlayerProfile = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("PlayerProfile"));
local Random_new_ret = Random.new();

function generate_id()
    -- upvalues: Random_new_ret (copy)
    return Random_new_ret:NextNumber();
end;

local manage_cd = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("manage_cd"));
local u1 = nil;
LocalPlayer.CharacterRemoving:Connect(function(p2: userdata) -- Line: 19
    -- upvalues: u1 (ref), manage_cd (copy)
    u1 = manage_cd.snapshot(p2);
end);
LocalPlayer.CharacterAdded:Connect(function(p3: userdata) -- Line: 22
    -- upvalues: u1 (ref), manage_cd (copy)
    local v4 = u1;
    u1 = nil;
    manage_cd.restore(p3, v4);
end);
local os_clock = os.clock;
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Skill_Switch_Adder = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("Skill_Switch_Adder"));
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local StatsFetch = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.StatsFetch);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local u5 = nil;

local function generalSounds() -- Line: 42
    -- upvalues: u5 (ref), ReplicatedStorage (copy)
    if u5 == nil then
        local Assets = ReplicatedStorage:FindFirstChild("Assets");
        u5 = Assets ~= nil and Assets:FindFirstChild("Sounds") or false;
    end;

    return u5 or nil;
end;

local function playLaneSound(p6: userdata, p7: string) -- Line: 51
    -- upvalues: PlayerProfile (copy), vfxUtility (copy), u5 (ref), ReplicatedStorage (copy)
    local v8 = PlayerProfile.skill_info[p7];

    if v8 == nil or v8.CategoryType ~= "Breathing" then
        return;
    end;

    local HumanoidRootPart = p6:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    local PlaySound = vfxUtility.PlaySound;

    if u5 == nil then
        local Assets = ReplicatedStorage:FindFirstChild("Assets");
        local v9;

        if Assets == nil then
            v9 = false;
        else
            v9 = Assets:FindFirstChild("Sounds") or false;
        end;

        u5 = v9;
    end;

    PlaySound(u5 or nil, "PS2breath", HumanoidRootPart, true);
end;

local u10 = false;

function script_Settings.Attempt_Hold(u11, p12) -- Line: 59
    -- upvalues: LocalPlayer (copy), u10 (ref), Platform_Handler (copy), Skill_Switch_Adder (copy), Skills_Module (copy), SignalEvent (copy), Checker (copy), script_Settings (copy), StatsFetch (copy), os_clock (copy), SignalFunction (copy), PlayerProfile (copy), vfxUtility (copy), u5 (ref), ReplicatedStorage (copy), manage_cd (copy)
    local Character = LocalPlayer.Character;

    if u10 then
        return;
    end;

    if Character == nil then
        return;
    end;

    if Character:FindFirstChild("SHC") == nil then
        local StringValue = Instance.new("StringValue");
        StringValue.Name = "SHC";
        StringValue:SetAttribute("CK", "");
        StringValue:SetAttribute("en", false);
        StringValue.Parent = Character;
    end;

    local SHC = Character.SHC;
    local v13 = Platform_Handler.mousepos(nil, nil, u11);

    if u11 then
        local v14 = LocalPlayer:FindFirstChild(u11 .. Skill_Switch_Adder.extension);

        if v14 and v14:FindFirstChild("Disabled") == nil then
            if SHC:GetAttribute("en") == true or SHC.Value == u11 then
                return;
            end;

            v14:Destroy();
            local v15 = Skills_Module[u11];

            if v15 then
                SignalEvent.ToServer("server_skill_controller_signaler", u11, "Switch", v13);

                if v15.Switch then
                    Skills_Module[u11].Id = generate_id();
                    v15.Switch(LocalPlayer, v13);
                end;
            end;

            if SHC.Value == u11 then
                SHC.Value = "";
            end;

            return;
        end;
    end;

    if SHC:GetAttribute("en") ~= true and (Skills_Module.Can_Skill(LocalPlayer, u11) == true and (Skills_Module[u11] ~= nil and Checker.check(LocalPlayer, u11))) then
        local u16 = Platform_Handler.mousepos(nil, nil, u11);
        script_Settings.AutoUnholdDisabled = nil;
        script_Settings.UnHoldBoolean = nil;
        local v17, v18 = StatsFetch.CanPlayOver(Character, u11, SHC.Value);
        local v19 = v17 == true and v18 == true;

        if v19 ~= true then
            local Value = SHC.Value;

            if #Value > 0 then
                task.spawn(function() -- Line: 114
                    -- upvalues: script_Settings (ref), Value (copy)
                    script_Settings.StopHold(Value);
                end);
            end;

            SHC:SetAttribute("en", true);
            SHC:SetAttribute("last_performed", os_clock());

            if SHC.Value ~= "" and Skills_Module[SHC.Value] ~= nil then
                Skills_Module[SHC.Value].Id = generate_id();

                if Skills_Module[SHC.Value].After_Server_Cancel_Signal then
                    task.spawn(function() -- Line: 124
                        -- upvalues: SignalFunction (ref), SHC (copy), u16 (copy), Skills_Module (ref), LocalPlayer (ref)
                        local v20 = SignalFunction.ToServer("server_skill_controller_signaler", SHC.Value, "Cancel", u16);
                        Skills_Module[SHC.Value].After_Server_Cancel_Signal(LocalPlayer, u16, v20);
                    end);
                else
                    SignalEvent.ToServer("server_skill_controller_signaler", SHC.Value, "Cancel", u16);
                end;

                pcall(Skills_Module[SHC.Value].Cancel, LocalPlayer, u16);
            end;
        end;

        PlayerProfile.skill_info[u11].lastUsed = os_clock();
        local v21 = generate_id();
        Skills_Module[u11].Id = v21;

        if v19 ~= true then
            SHC.Value = u11;
        end;

        if Skills_Module[u11].After_Server_Hold_Signal then
            task.spawn(function() -- Line: 143
                -- upvalues: SignalFunction (ref), u11 (copy), u16 (copy), Character (copy), Skills_Module (ref), LocalPlayer (ref)
                local v22 = SignalFunction.ToServer("server_skill_controller_signaler", u11, "Hold", u16);

                if Character:FindFirstChild("SHCS") and Character.SHCS.Value == u11 then
                    Skills_Module[u11].After_Server_Hold_Signal(LocalPlayer, u16, v22);
                end;
            end);
        else
            SignalEvent.ToServer("server_skill_controller_signaler", u11, "Hold", u16);
        end;

        if v19 == true then
            SHC:SetAttribute("CK2", p12 or "");
            SHC:SetAttribute("LastCkType", "CK2");
        else
            SHC:SetAttribute("CK", p12 or "");
            SHC:SetAttribute("LastCkType", "CK");
        end;

        local v23 = PlayerProfile.skill_info[u11];

        if v23 ~= nil and v23.CategoryType == "Breathing" then
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart ~= nil then
                local PlaySound = vfxUtility.PlaySound;

                if u5 == nil then
                    local Assets = ReplicatedStorage:FindFirstChild("Assets");
                    local v24;

                    if Assets == nil then
                        v24 = false;
                    else
                        v24 = Assets:FindFirstChild("Sounds") or false;
                    end;

                    u5 = v24;
                end;

                PlaySound(u5 or nil, "PS2breath", HumanoidRootPart, true);
            end;
        end;

        if Skills_Module[u11].Hold then
            local success, result = pcall(Skills_Module[u11].Hold, LocalPlayer, u16);

            if not success then
                result = false;
            end;

            if result == false and (SHC.Value == u11 and v19 ~= true) then
                SHC.Value = "";
            elseif result == true and (SHC.Value == u11 and v19 ~= true) then
                local v25 = manage_cd.fetch(LocalPlayer, u11);

                if v25 and v25 > 0 then
                    manage_cd.set_skill_cd(LocalPlayer, u11, v25);
                end;

                if u11 ~= "Dash" and u11 ~= "Double_Jump" then
                    PlayerProfile.lastperformedaskill = os_clock();
                end;

                SHC.Value = "";
            end;
        end;

        SHC:SetAttribute("en", false);

        if Skills_Module[u11].Id == v21 then
            script_Settings.Canceld = nil;
        end;

        return true;
    end;
end;

function script_Settings.Counter(u26, p27, p28, ...) -- Line: 196
    -- upvalues: LocalPlayer (copy), u10 (ref), Utility (copy), script_Settings (copy), Skills_Module (copy), Platform_Handler (copy), SignalFunction (copy), SignalEvent (copy), Skill_Switch_Adder (copy), manage_cd (copy)
    local SHC = LocalPlayer.Character:FindFirstChild("SHC");

    if SHC == nil or u10 then
        return;
    end;

    local v29 = SHC.Value == u26;

    if not v29 then
        local valuesfolder = Utility.getvaluesfolder(LocalPlayer);
        local v30;

        if valuesfolder == nil then
            v30 = nil;
        else
            v30 = valuesfolder:FindFirstChild("Counter") or nil;
        end;

        if v30 == nil then
            v29 = false;
        else
            v29 = v30:IsA("StringValue") and v30.Value == u26;
        end;
    end;

    if v29 then
        SHC:SetAttribute("en", true);
        script_Settings.UnHoldBoolean = nil;
        local v31 = generate_id();
        Skills_Module[u26].Id = v31;
        local u32 = Platform_Handler.mousepos(nil, nil, u26);

        if p28 == nil or p28 == true then
            if Skills_Module[u26].After_Server_Counter_Signal then
                task.spawn(function() -- Line: 220
                    -- upvalues: SignalFunction (ref), u26 (copy), u32 (copy), Skills_Module (ref), LocalPlayer (ref)
                    local v33 = SignalFunction.ToServer("server_skill_controller_signaler", u26, "Counter", u32);
                    Skills_Module[u26].After_Server_Counter_Signal(LocalPlayer, u32, v33);
                end);
            else
                SignalEvent.ToServer("server_skill_controller_signaler", u26, "Counter", u32);
            end;
        end;

        local v34 = u26 .. Skill_Switch_Adder.extension;

        if LocalPlayer:FindFirstChild(v34) then
            LocalPlayer:FindFirstChild(v34):Destroy();
        end;

        if p27 == nil or p27 == true then
            local v35 = manage_cd.fetch(LocalPlayer, u26);

            if v35 and (v35 > 0 and SHC.Value == u26) then
                manage_cd.set_skill_cd(LocalPlayer, u26, v35);
            end;
        end;

        if SHC.Value == u26 then
            SHC.Value = "";
        end;

        if Skills_Module[u26].Counter then
            Skills_Module[u26].Counter(LocalPlayer, u32, ...);
        end;

        if Skills_Module[u26].Id == v31 then
            SHC:SetAttribute("en", false);
        end;

        script_Settings.Canceld = nil;
    end;
end;

function script_Settings.Toggle(p36, p37, p38, ...) -- Line: 250
    -- upvalues: u10 (ref), Skills_Module (copy), LocalPlayer (copy)
    if u10 then
        return;
    end;

    Skills_Module[p36].Id = generate_id();

    if Skills_Module[p36].Toggle then
        Skills_Module[p36].Toggle(LocalPlayer, ...);
    end;
end;

function script_Settings.StopHold(u39: string, p40: number?, p41: boolean?, u42: boolean?) -- Line: 260
    -- upvalues: Skills_Module (copy), LocalPlayer (copy), u10 (ref), StatsFetch (copy), script_Settings (copy), Platform_Handler (copy), SignalFunction (copy), PlayerProfile (copy), SignalEvent (copy), os_clock (copy), manage_cd (copy)
    if Skills_Module[u39] ~= nil then
        local SHC = LocalPlayer.Character:FindFirstChild("SHC");

        if SHC == nil or (SHC:GetAttribute("en") == true or u10) then
            return false;
        end;

        local v43, v44 = StatsFetch.CanPlayOver(LocalPlayer.Character, u39, SHC.Value);
        local v45 = v43 == true and v44 == true;

        if SHC.Value == u39 or v45 then
            local Value = SHC.Value;
            u10 = true;
            script_Settings.UnHoldBoolean = nil;
            SHC:SetAttribute("en", true);
            local v46 = generate_id();
            Skills_Module[u39].Id = v46;
            local u47 = Platform_Handler.mousepos(nil, nil, u39);

            if p41 == nil or p41 == true then
                if Skills_Module[u39].After_Server_Unhold_Signal then
                    task.spawn(function() -- Line: 281
                        -- upvalues: SignalFunction (ref), u39 (copy), u47 (copy), PlayerProfile (ref), u42 (copy), Skills_Module (ref), LocalPlayer (ref)
                        local v48;

                        if PlayerProfile.skill_info[u39].UnholdStatus then
                            v48 = u42;
                        else
                            v48 = nil;
                        end;

                        local v49 = SignalFunction.ToServer("server_skill_controller_signaler", u39, "UnHold", u47, v48);
                        local v50;

                        if PlayerProfile.skill_info[u39].UnholdStatus then
                            v50 = u42;
                        else
                            v50 = nil;
                        end;

                        Skills_Module[u39].After_Server_Unhold_Signal(LocalPlayer, u47, v49, v50);
                    end);
                else
                    local v51;

                    if PlayerProfile.skill_info[u39].UnholdStatus then
                        v51 = u42;
                    else
                        v51 = nil;
                    end;

                    SignalEvent.ToServer("server_skill_controller_signaler", u39, "UnHold", u47, v51);
                end;
            end;

            if u39 ~= "Dash" and u39 ~= "Double_Jump" then
                PlayerProfile.lastperformedaskill = os_clock();
            end;

            if p40 == nil or p40 == true then
                local v52 = manage_cd.fetch(LocalPlayer, u39);

                if v52 and (v52 > 0 and (SHC.Value == u39 or v45)) then
                    manage_cd.set_skill_cd(LocalPlayer, u39, v52);
                end;
            end;

            if v45 ~= true and (SHC.Value == u39 or u39 ~= Value) then
                SHC.Value = "";
            end;

            SHC:SetAttribute("CK2", "");

            if Skills_Module[u39].UnHold then
                local success, result = pcall(function() -- Line: 318
                    -- upvalues: Skills_Module (ref), u39 (copy), LocalPlayer (ref), u47 (copy), u42 (copy)
                    return { Skills_Module[u39].UnHold(LocalPlayer, u47, u42) };
                end);
                local v53 = not success and {} or result;

                if v53 == nil or #v53 <= 0 then
                    SignalEvent.ToServer("server_skill_controller_signaler", u39, "Cancel", u47);
                else
                    if not PlayerProfile.skill_info[u39].UnholdStatus then
                        u42 = nil;
                    end;

                    SignalEvent.ToServer("server_skill_controller_signaler", u39, "UnHoldAfterClient", u47, u42, table.unpack(v53));
                end;
            end;

            SHC:SetAttribute("en", false);
            u10 = false;
            script_Settings.Canceld = nil;

            return true;
        end;
    end;

    return false;
end;

local function releases(p54: any, p55: string) -- Line: 343
    -- upvalues: UserInputService (copy)
    if type(p54) ~= "string" or p54 == "" then
        return false;
    end;

    if p54 == p55 then
        return true;
    end;

    if p54:find("+", 1, true) == nil then
        return false;
    end;

    local v56 = false;

    for _, v in string.split(p54, "+") do
        if v == p55 then
            v56 = true;
        elseif Enum.KeyCode[v] ~= nil and UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode[v]) then
            return false;
        end;
    end;

    return v56;
end;

UserInputService.InputEnded:Connect(function(p57) -- Line: 357
    -- upvalues: LocalPlayer (copy), releases (copy), script_Settings (copy)
    if LocalPlayer ~= nil and (LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild("SHC") ~= nil) then
        local SHC = LocalPlayer.Character.SHC;
        local Name = p57.KeyCode.Name;

        if releases(SHC:GetAttribute("CK"), Name) or releases(SHC:GetAttribute("CK2"), Name) then
            local Value = SHC.Value;

            if Value ~= nil and Value ~= "" then
                script_Settings.UnHoldBoolean = true;
            end;
        end;
    end;
end);
task.spawn(function() -- Line: 370
    -- upvalues: LocalPlayer (copy), script_Settings (copy), Platform_Handler (copy), UserInputService (copy), Utility (copy), SignalEvent (copy)
    local os_clock2 = os.clock;

    while true do
        if LocalPlayer.Character ~= nil then
            local SHC = LocalPlayer.Character:FindFirstChild("SHC");
            local v58 = false;

            if script_Settings.UnHoldAllBoolean then
                local HeldSkill = script_Settings.HeldSkill;

                if not (HeldSkill ~= nil and HeldSkill ~= "" or (SHC == nil or SHC.Value == "")) then
                    HeldSkill = SHC.Value;
                end;

                if HeldSkill == nil or HeldSkill == "" then
                    script_Settings.UnHoldAllBoolean = nil;
                    v58 = true;
                elseif script_Settings.StopHold(HeldSkill) and HeldSkill == script_Settings.HeldSkill then
                    script_Settings.HeldSkill = nil;
                    script_Settings.CurrentMax = nil;
                    v58 = true;
                else
                    v58 = true;
                end;
            elseif script_Settings.UnHoldTarget ~= nil then
                local UnHoldTarget = script_Settings.UnHoldTarget;

                if script_Settings.UnHoldTargetUntil == nil or os_clock2() <= script_Settings.UnHoldTargetUntil then
                    if script_Settings.StopHold(UnHoldTarget) then
                        script_Settings.UnHoldTarget = nil;
                        script_Settings.UnHoldTargetUntil = nil;

                        if UnHoldTarget == script_Settings.HeldSkill then
                            script_Settings.HeldSkill = nil;
                            script_Settings.CurrentMax = nil;
                            v58 = true;
                        else
                            v58 = true;
                        end;
                    else
                        v58 = true;
                    end;
                else
                    script_Settings.UnHoldTarget = nil;
                    script_Settings.UnHoldTargetUntil = nil;
                    v58 = true;
                end;
            end;

            if not v58 and script_Settings.UnHoldBoolean then
                if script_Settings.StopHold(script_Settings.HeldSkill) then
                    script_Settings.HeldSkill = nil;
                    script_Settings.CurrentMax = nil;
                    v58 = true;
                else
                    v58 = true;
                end;
            end;

            if not (v58 or (SHC == nil or SHC.Value == "")) then
                local Attribute = SHC:GetAttribute("last_performed");

                if script_Settings.CurrentMax ~= nil and (script_Settings.CurrentMax > 0 and (Attribute ~= nil and (os_clock2() - Attribute > script_Settings.CurrentMax and (script_Settings.AutoUnholdDisabled == nil and script_Settings.StopHold(script_Settings.HeldSkill, nil, nil, true))))) then
                    script_Settings.HeldSkill = nil;
                    script_Settings.CurrentMax = nil;
                end;
            end;

            if SHC ~= nil and (SHC:GetAttribute("en") ~= true and (Platform_Handler.Platform.Value == "PC" and not UserInputService:IsKeyDown(Enum.KeyCode.F))) then
                local valuesfolder = Utility.getvaluesfolder(LocalPlayer);

                if valuesfolder ~= nil and valuesfolder:FindFirstChild("Blocking") ~= nil then
                    if SHC.Value == "Blocking" then
                        if script_Settings.StopHold("Blocking") and script_Settings.HeldSkill == "Blocking" then
                            script_Settings.HeldSkill = nil;
                            script_Settings.CurrentMax = nil;
                        end;
                    elseif script_Settings.LastBlockingNudge == nil or os_clock2() - script_Settings.LastBlockingNudge > 1 then
                        script_Settings.LastBlockingNudge = os_clock2();
                        SignalEvent.ToServer("server_skill_controller_signaler", "Blocking", "UnHold", Platform_Handler.mousepos(nil, nil, "Blocking"));
                    end;
                end;
            end;

            if SHC ~= nil and SHC.Value ~= "" then
                local Character = LocalPlayer.Character;

                if script_Settings.Canceld == true or (Character == nil or (Character:FindFirstChild("Humanoid") == nil or Character.Humanoid.Health == 0)) then
                    script_Settings.ForceCancel(SHC.Value);
                    script_Settings.HeldSkill = nil;
                    script_Settings.CurrentMax = nil;
                end;
            end;
        end;

        task.wait(0.05);
    end;
end);

function script_Settings.ForceCancel(u59, p60, p61) -- Line: 460
    -- upvalues: LocalPlayer (copy), u10 (ref), StatsFetch (copy), script_Settings (copy), Platform_Handler (copy), Skills_Module (copy), SignalFunction (copy), SignalEvent (copy), Skill_Switch_Adder (copy), manage_cd (copy)
    local SHC = LocalPlayer.Character:FindFirstChild("SHC");

    if SHC == nil or u10 then
        return;
    end;

    local v62, v63 = StatsFetch.CanPlayOver(LocalPlayer.Character, u59, SHC.Value);
    local v64 = v62 == true and v63 == true;

    if SHC.Value == u59 or v64 then
        SHC:SetAttribute("en", true);
        script_Settings.UnHoldBoolean = nil;
        u10 = true;
        local v65 = generate_id();
        local u66 = Platform_Handler.mousepos(nil, nil, u59);
        Skills_Module[u59].Id = v65;

        if p61 == nil or p61 == true then
            if Skills_Module[u59].After_Server_Cancel_Signal then
                task.spawn(function() -- Line: 479
                    -- upvalues: SignalFunction (ref), u59 (copy), u66 (copy), Skills_Module (ref), LocalPlayer (ref)
                    local v67 = SignalFunction.ToServer("server_skill_controller_signaler", u59, "Cancel", u66);
                    Skills_Module[u59].After_Server_Cancel_Signal(LocalPlayer, u66, v67);
                end);
            else
                SignalEvent.ToServer("server_skill_controller_signaler", u59, "Cancel", u66);
            end;
        end;

        local v68 = u59 .. Skill_Switch_Adder.extension;

        if LocalPlayer:FindFirstChild(v68) then
            LocalPlayer:FindFirstChild(v68):Destroy();
        end;

        if p60 == nil or p60 == true then
            local v69 = manage_cd.fetch(LocalPlayer, u59);

            if v69 and (v69 > 0 and (SHC.Value == u59 or v64)) then
                manage_cd.set_skill_cd(LocalPlayer, u59, v69);
            end;
        end;

        if v64 ~= true and SHC.Value == u59 then
            SHC.Value = "";
        end;

        if Skills_Module[u59].Cancel then
            pcall(Skills_Module[u59].Cancel, LocalPlayer, u66);
        end;

        SHC:SetAttribute("en", false);
        u10 = false;
        script_Settings.Canceld = nil;
    end;
end;

return script_Settings;