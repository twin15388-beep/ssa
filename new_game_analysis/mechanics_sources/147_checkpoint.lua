-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local u1 = {};
u1.__index = u1;
local TweenInfo_new_ret = TweenInfo.new(4);
local TweenInfo_new_ret2 = TweenInfo.new(0.5);

function u1.Reset(p2, p3) -- Line: 11
    if p2.Checkpoint == nil then
        return;
    end;

    if p2.Tweens then
        for _, v in p2.Tweens do
            v:Cancel();
        end;

        table.clear(p2.Tweens);
    end;

    if not p3 then
        return;
    end;

    local FlagMesh = p2.Checkpoint.Flag:FindFirstChild("FlagMesh");
    local Attribute = p2.Checkpoint:GetAttribute("Start");

    if FlagMesh and Attribute then
        FlagMesh.CFrame = Attribute;
    end;

    local TouchPart = p2.Checkpoint:FindFirstChild("TouchPart");

    if TouchPart then
        TouchPart = TouchPart:FindFirstChild("MainAt");
    end;

    if TouchPart then
        local Attribute2 = p2.Checkpoint:GetAttribute("MainAtStart");

        if Attribute2 then
            TouchPart.CFrame = Attribute2;
        end;

        local Beam = TouchPart:FindFirstChild("Beam");

        if Beam then
            Beam.Width0 = p2.Checkpoint:GetAttribute("BeamWidth0") or 0;
            Beam.Width1 = p2.Checkpoint:GetAttribute("BeamWidth1") or 0;
        end;

        local Beam1 = TouchPart:FindFirstChild("Beam1");

        if Beam1 then
            Beam1.Width0 = p2.Checkpoint:GetAttribute("Beam1Width0") or 0;
            Beam1.Width1 = p2.Checkpoint:GetAttribute("Beam1Width1") or 0;
        end;
    end;
end;

function u1.Destroy(p4) -- Line: 44
    p4:Reset(true);

    if p4.Connections then
        for _, v in p4.Connections do
            v:Disconnect();
        end;

        p4.Connections = nil;
    end;

    p4.Tweens = nil;
    setmetatable(p4, nil);
end;

function u1.Open(u5) -- Line: 55
    -- upvalues: TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy)
    local function track(p6, p7) -- Line: 56
        -- upvalues: u5 (copy)
        if u5.Tweens then
            if u5.Tweens[p6] then
                u5.Tweens[p6]:Cancel();
            end;

            u5.Tweens[p6] = p7;
        end;

        return p7;
    end;

    local FlagMesh = u5.Checkpoint:WaitForChild("Flag"):WaitForChild("FlagMesh");
    local Attribute = u5.Checkpoint:GetAttribute("Start");

    if Attribute == nil then
        Attribute = FlagMesh.CFrame;
        u5.Checkpoint:SetAttribute("Start", Attribute);
    end;

    local MainAt = u5.Checkpoint:WaitForChild("TouchPart"):WaitForChild("MainAt");
    MainAt:WaitForChild("Beam");
    MainAt:WaitForChild("Beam1");

    if u5.Checkpoint:GetAttribute("MainAtStart") == nil then
        u5.Checkpoint:SetAttribute("MainAtStart", MainAt.CFrame);
        u5.Checkpoint:SetAttribute("BeamWidth0", MainAt.Beam.Width0);
        u5.Checkpoint:SetAttribute("BeamWidth1", MainAt.Beam.Width1);
        u5.Checkpoint:SetAttribute("Beam1Width0", MainAt.Beam1.Width0);
        u5.Checkpoint:SetAttribute("Beam1Width1", MainAt.Beam1.Width1);
    end;

    local v8 = TweenService:Create(FlagMesh, TweenInfo_new_ret, {
        CFrame = Attribute * CFrame.new(0, 8, 0)
    });

    if u5.Tweens then
        if u5.Tweens.Flag then
            u5.Tweens.Flag:Cancel();
        end;

        u5.Tweens.Flag = v8;
    end;

    v8:Play();
    local v9 = TweenService:Create(MainAt.Beam, TweenInfo_new_ret2, {
        Width0 = 3
    });

    if u5.Tweens then
        if u5.Tweens.BeamW0 then
            u5.Tweens.BeamW0:Cancel();
        end;

        u5.Tweens.BeamW0 = v9;
    end;

    v9:Play();
    local v10 = TweenService:Create(MainAt.Beam, TweenInfo_new_ret2, {
        Width1 = 3
    });

    if u5.Tweens then
        if u5.Tweens.BeamW1 then
            u5.Tweens.BeamW1:Cancel();
        end;

        u5.Tweens.BeamW1 = v10;
    end;

    v10:Play();
    local v11 = TweenService:Create(MainAt.Beam1, TweenInfo_new_ret2, {
        Width0 = 3
    });

    if u5.Tweens then
        if u5.Tweens.Beam1W0 then
            u5.Tweens.Beam1W0:Cancel();
        end;

        u5.Tweens.Beam1W0 = v11;
    end;

    v11:Play();
    local v12 = TweenService:Create(MainAt.Beam1, TweenInfo_new_ret2, {
        Width1 = 3
    });

    if u5.Tweens then
        if u5.Tweens.Beam1W1 then
            u5.Tweens.Beam1W1:Cancel();
        end;

        u5.Tweens.Beam1W1 = v12;
    end;

    v12:Play();
    local v13 = TweenService:Create(MainAt, TweenInfo_new_ret2, {
        CFrame = CFrame.new(1.15, 0, 0)
    });

    if u5.Tweens then
        if u5.Tweens.MainAt then
            u5.Tweens.MainAt:Cancel();
        end;

        u5.Tweens.MainAt = v13;
    end;

    v13:Play();
end;

return function(u14: userdata, u15: any, p16: any) -- Line: 90
    -- upvalues: u1 (copy), Players (copy), Ouwmit (copy), DebrisModule (copy)
    local u17 = setmetatable({
        Checkpoint = u14,
        Connections = {},
        Tweens = {}
    }, u1);
    p16:Add(task.spawn(function() -- Line: 92
        -- upvalues: u17 (copy), u14 (copy), Players (ref), u15 (copy), Ouwmit (ref), DebrisModule (ref)
        u17:Open();
        local u18 = tonumber(string.match(u14.Name, "%d+"));

        if not u18 then
            return;
        end;

        local v19 = u14.Parent:FindFirstChild("Checkpoint" .. u18 + 1);

        if not v19 then
            return;
        end;

        local function bind(u20: userdata) -- Line: 100
            -- upvalues: u17 (ref), Players (ref), u15 (ref), u18 (copy), Ouwmit (ref), DebrisModule (ref)
            if not u20:IsA("BasePart") then
                return;
            end;

            table.insert(u17.Connections, u20.Touched:Connect(function(p21) -- Line: 102
                -- upvalues: Players (ref), u15 (ref), u18 (ref), u20 (copy), Ouwmit (ref), DebrisModule (ref)
                local LocalPlayer = Players.LocalPlayer;

                if LocalPlayer then
                    LocalPlayer = LocalPlayer.Character;
                end;

                if not LocalPlayer then
                    return;
                end;

                if not p21:IsDescendantOf(LocalPlayer) then
                    return;
                end;

                if (u15:GetAttribute("Checkpoint") or 0) >= u18 + 1 then
                    return;
                end;

                u15:SetAttribute("Checkpoint", u18 + 1);
                local v22 = script.CheckpointEffect:Clone();
                v22.Parent = workspace.Debree;
                v22:PivotTo(CFrame.new(u20.Position) * CFrame.new(0, -0.45, 0));
                Ouwmit.Emit(v22);
                DebrisModule:AddItem(v22, 1.5);
                local v23 = script.Parent.Sounds.PS2checkpoint:Clone();
                v23.Parent = u20;
                v23:Play();
                DebrisModule:AddItem(v23, 0);
            end));
        end;

        local TouchPart = v19:FindFirstChild("TouchPart");

        if TouchPart and TouchPart:IsA("BasePart") then
            table.insert(u17.Connections, TouchPart.Touched:Connect(function(p24) -- Line: 102
                -- upvalues: Players (ref), u15 (ref), u18 (copy), TouchPart (copy), Ouwmit (ref), DebrisModule (ref)
                local LocalPlayer = Players.LocalPlayer;

                if LocalPlayer then
                    LocalPlayer = LocalPlayer.Character;
                end;

                if not LocalPlayer then
                    return;
                end;

                if not p24:IsDescendantOf(LocalPlayer) then
                    return;
                end;

                if (u15:GetAttribute("Checkpoint") or 0) >= u18 + 1 then
                    return;
                end;

                u15:SetAttribute("Checkpoint", u18 + 1);
                local v25 = script.CheckpointEffect:Clone();
                v25.Parent = workspace.Debree;
                v25:PivotTo(CFrame.new(TouchPart.Position) * CFrame.new(0, -0.45, 0));
                Ouwmit.Emit(v25);
                DebrisModule:AddItem(v25, 1.5);
                local v26 = script.Parent.Sounds.PS2checkpoint:Clone();
                v26.Parent = TouchPart;
                v26:Play();
                DebrisModule:AddItem(v26, 0);
            end));
        end;

        table.insert(u17.Connections, v19.ChildAdded:Connect(function(u27) -- Line: 124
            -- upvalues: u17 (ref), Players (ref), u15 (ref), u18 (copy), Ouwmit (ref), DebrisModule (ref)
            if u27.Name == "TouchPart" then
                if not u27:IsA("BasePart") then
                    return;
                end;

                table.insert(u17.Connections, u27.Touched:Connect(function(p28) -- Line: 102
                    -- upvalues: Players (ref), u15 (ref), u18 (ref), u27 (copy), Ouwmit (ref), DebrisModule (ref)
                    local LocalPlayer = Players.LocalPlayer;

                    if LocalPlayer then
                        LocalPlayer = LocalPlayer.Character;
                    end;

                    if not LocalPlayer then
                        return;
                    end;

                    if not p28:IsDescendantOf(LocalPlayer) then
                        return;
                    end;

                    if (u15:GetAttribute("Checkpoint") or 0) >= u18 + 1 then
                        return;
                    end;

                    u15:SetAttribute("Checkpoint", u18 + 1);
                    local v29 = script.CheckpointEffect:Clone();
                    v29.Parent = workspace.Debree;
                    v29:PivotTo(CFrame.new(u27.Position) * CFrame.new(0, -0.45, 0));
                    Ouwmit.Emit(v29);
                    DebrisModule:AddItem(v29, 1.5);
                    local v30 = script.Parent.Sounds.PS2checkpoint:Clone();
                    v30.Parent = u27;
                    v30:Play();
                    DebrisModule:AddItem(v30, 0);
                end));
            end;
        end));
    end));

    return u17;
end;