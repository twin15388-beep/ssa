-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local faye = require(ReplicatedStorage.Packages.faye);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local CupGameUI = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.Training.CupGameUI);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);
local workspace_CurrentCamera = workspace.CurrentCamera;
local Sounds = script.Parent:WaitForChild("Sounds");
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);
local AlwaysOnTop = Enum.HighlightDepthMode.AlwaysOnTop;
local CFrame_Angles_ret = CFrame.Angles(3.141592653589793, 0, 0);
local TweenInfo_new_ret = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local TweenInfo_new_ret2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad);
local TweenInfo_new_ret3 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out);
local TweenInfo_new_ret4 = TweenInfo.new(0.4, Enum.EasingStyle.Quad);
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = 0;
local u6 = nil;

local function partOf(p7: userdata) -- Line: 69
    if p7:IsA("BasePart") then
        return p7;
    end;

    return p7:IsA("Model") and p7.PrimaryPart or nil;
end;

local function setTransparency(p8: userdata, p9: number) -- Line: 74
    if not p8:IsA("BasePart") then
        p8 = p8:IsA("Model") and p8.PrimaryPart or nil;
    end;

    if p8 then
        p8.Transparency = p9;
    end;
end;

local function playSound(p10: string, p11: userdata?) -- Line: 81
    -- upvalues: Sounds (copy), DebrisModule (copy)
    local v12 = Sounds:FindFirstChild(p10);

    if not v12 then
        return;
    end;

    local v13 = v12:Clone();

    if p11 then
        if not p11:IsA("BasePart") then
            p11 = p11:IsA("Model") and p11.PrimaryPart or nil;
        end;

        if not p11 then
            p11 = Sounds;
        end;
    else
        p11 = Sounds;
    end;

    v13.Parent = p11;
    v13:Play();
    DebrisModule:AddItem(v13, v13.TimeLength + 1);
end;

local u14 = {};
local u15 = {};
local u16 = {};

local function moveTo(p17: userdata, p18: userdata, p19) -- Line: 104
    -- upvalues: TweenService (copy), u16 (copy)
    if not p17:IsA("BasePart") then
        p17:PivotTo(p19);

        return;
    end;

    local v20 = TweenService:Create(p17, p18, {
        CFrame = p19
    });
    table.insert(u16, v20);
    v20:Play();
end;

local function cancelTweens() -- Line: 114
    -- upvalues: u16 (copy)
    for _, v in u16 do
        v:Cancel();
    end;

    table.clear(u16);
end;

local function snapTo(p21: userdata, p22) -- Line: 121
    if p21:IsA("BasePart") then
        p21.CFrame = p22;

        return;
    end;

    p21:PivotTo(p22);
end;

local function teardown() -- Line: 129
    -- upvalues: u2 (ref), u3 (ref), u6 (ref), u4 (ref), u5 (ref), RunService (copy), Camera_Traffic_Handler (copy), u16 (copy), u14 (copy), u15 (copy)
    local v23 = u2;
    local v24 = u3;
    local u25 = u6;
    local v26 = u4;
    u2 = nil;
    u3 = nil;
    u6 = nil;
    u4 = nil;
    u5 = u5 + 1;
    RunService:UnbindFromRenderStep("cupgame_cam");

    if Camera_Traffic_Handler.CupGame then
        Camera_Traffic_Handler.CupGame = false;
    end;

    for _, v in u16 do
        v:Cancel();
    end;

    table.clear(u16);

    if v26 then
        v26();
    end;

    if v24 then
        v24:Stop(0.3);
    end;

    if v23 then
        v23:Destroy();
    end;

    task.defer(function() -- Line: 162
        -- upvalues: u25 (copy), u14 (ref), u15 (ref)
        if not u25 then
            return;
        end;

        for _, v in u25.cups do
            local v27 = u14[v];

            if v:IsA("BasePart") then
                v.CFrame = v27;
            else
                v:PivotTo(v27);
            end;
        end;

        local v28 = u25.ball and u15[u25.ball];

        if v28 then
            local ball = u25.ball;
            local cf = v28.cf;

            if ball:IsA("BasePart") then
                ball.CFrame = cf;
            else
                ball:PivotTo(cf);
            end;

            local ball2 = u25.ball;
            local transparency = v28.transparency;

            if not ball2:IsA("BasePart") then
                ball2 = ball2:IsA("Model") and ball2.PrimaryPart or nil;
            end;

            if ball2 then
                ball2.Transparency = transparency;
            end;
        end;
    end);
end;

function v1.Do(p29: userdata, p30: userdata, p31: userdata, p32: userdata?) -- Line: 175
    -- upvalues: teardown (copy), u5 (ref), u2 (ref), faye (copy), Utility (copy), valuesfolder (copy), u3 (ref), u14 (copy), u15 (copy), u6 (ref), Camera_Traffic_Handler (copy), RunService (copy), workspace_CurrentCamera (copy), SignalEvent (copy), u4 (ref), CupGameUI (copy), TweenService (copy), moveTo (copy), TweenInfo_new_ret4 (copy), TweenInfo_new_ret (copy), playSound (copy), TweenInfo_new_ret2 (copy), CFrame_Angles_ret (copy), PlatformLeniency (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), AlwaysOnTop (copy), TweenInfo_new_ret3 (copy)
    teardown();
    u5 = u5 + 1;
    local u33 = u5;
    u2 = faye.new();
    u2:Add(Utility.AddValue(valuesfolder, "skill_stand_still"));
    u2:Add(Utility.AddValue(valuesfolder, "pause_gameplay"));
    u2:Add(Utility.AddValue(valuesfolder, "NR"));
    u3 = p30.Humanoid.Animator:LoadAnimation(script["Cup Game"]);
    u3:Play();

    if not p32 then
        return;
    end;

    local Parent = p32.Parent;

    if Parent then
        Parent = Parent.Parent;
    end;

    if not Parent then
        return;
    end;

    local Camera = Parent:FindFirstChild("Camera");
    local Cups = Parent:FindFirstChild("Cups");

    if not (Camera and Cups) then
        return;
    end;

    local Ball = Cups:FindFirstChild("Ball");
    local u34 = {};

    for _, child in Cups:GetChildren() do
        if child:IsA("BasePart") and child.Name:match("^Cup%d+$") then
            table.insert(u34, child);
        end;
    end;

    if #u34 < 3 or not Ball then
        return;
    end;

    local RightVector = Camera.CFrame.RightVector;
    local Position = Camera.Position;
    table.sort(u34, function(p35, p36) -- Line: 212
        -- upvalues: Position (copy), RightVector (copy)
        return (p35.Position - Position):Dot(RightVector) < (p36.Position - Position):Dot(RightVector);
    end);

    for _, v in u34 do
        if u14[v] == nil then
            local Attribute = v:GetAttribute("CupGameHome");

            if typeof(Attribute) ~= "CFrame" then
                Attribute = v.CFrame;
                v:SetAttribute("CupGameHome", Attribute);
            end;

            u14[v] = Attribute;
        end;
    end;

    local u37 = { u14[u34[1]], u14[u34[2]], u14[u34[3]] };

    if u15[Ball] == nil then
        local Attribute = Ball:GetAttribute("CupGameBallHome");
        local Attribute2 = Ball:GetAttribute("CupGameBallTransparency");

        if typeof(Attribute) ~= "CFrame" then
            local v38;

            if Ball:IsA("BasePart") then
                v38 = Ball;
            elseif Ball:IsA("Model") then
                v38 = Ball.PrimaryPart or nil;
            else
                v38 = nil;
            end;

            Attribute = Ball:GetPivot();
            Attribute2 = v38 and v38.Transparency or 0;
            Ball:SetAttribute("CupGameBallHome", Attribute);
            Ball:SetAttribute("CupGameBallTransparency", Attribute2);
        end;

        u15[Ball] = {
            cf = Attribute,
            transparency = Attribute2
        };
    end;

    local cf = u15[Ball].cf;
    u6 = {
        model = Parent,
        cameraPart = Camera,
        ball = Ball,
        cups = u34,
        slots = u37,
        slotCups = { u34[1], u34[2], u34[3] },
        ballHomeCF = cf
    };
    local v39;

    if Ball:IsA("BasePart") then
        v39 = Ball;
    elseif Ball:IsA("Model") then
        v39 = Ball.PrimaryPart or nil;
    else
        v39 = nil;
    end;

    if v39 then
        v39.Transparency = 0;
    end;

    if Ball:IsA("BasePart") then
        Ball.CFrame = cf;
    else
        Ball:PivotTo(cf);
    end;

    Camera_Traffic_Handler.CupGame = true;
    RunService:BindToRenderStep("cupgame_cam", Enum.RenderPriority.Camera.Value, function() -- Line: 264
        -- upvalues: Camera_Traffic_Handler (ref), workspace_CurrentCamera (ref), Camera (copy)
        if Camera_Traffic_Handler.Equipped_Hirearchy == "CupGame" then
            workspace_CurrentCamera.CFrame = Camera.CFrame;
        end;
    end);
    local u40 = false;

    local function stop(p41: boolean) -- Line: 272
        -- upvalues: u40 (ref), SignalEvent (ref)
        if u40 then
            return;
        end;

        u40 = true;
        SignalEvent.ToServer("training_signaler", "Stop", p41 == true);
    end;

    local v42, v43, v44, v45, v46 = CupGameUI(p29.PlayerGui:WaitForChild("Misc"), stop);
    u4 = v42;
    local u47 = v43;
    local u48 = v45;
    local u49 = v46;
    local u50 = v44;
    u2:Spawn(function() -- Line: 287
        -- upvalues: u33 (copy), u5 (ref), RunService (ref), TweenService (ref), u6 (ref), u37 (copy), u34 (copy), moveTo (ref), TweenInfo_new_ret4 (ref), Ball (copy), cf (copy), TweenInfo_new_ret (ref), playSound (ref), TweenInfo_new_ret2 (ref), CFrame_Angles_ret (ref), PlatformLeniency (ref), u2 (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), AlwaysOnTop (ref), TweenInfo_new_ret3 (ref), u48 (ref), u49 (ref), u40 (ref), SignalEvent (ref), u50 (ref), u47 (ref)
        local function guard() -- Line: 288
            -- upvalues: u33 (ref), u5 (ref)
            return u33 ~= u5;
        end;

        local function arcMove(p51: userdata, p52, p53, p54: number, p55: number) -- Line: 295
            -- upvalues: RunService (ref), u33 (ref), u5 (ref), TweenService (ref)
            local Position2 = p52.Position;
            local Position3 = p53.Position;
            local v56 = (Position2 + Position3) / 2 + Vector3.new(0, p54, 0);
            local v57 = 0;

            while v57 < p55 do
                local v58 = RunService.Heartbeat:Wait();

                if u33 ~= u5 then
                    return;
                end;

                v57 = math.min(v57 + v58, p55);
                local Value = TweenService:GetValue(v57 / p55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
                local v59 = 1 - Value;
                local v60 = CFrame.new(v59 * v59 * Position2 + 2 * v59 * Value * v56 + Value * Value * Position3) * p52:Lerp(p53, Value).Rotation;

                if p51:IsA("BasePart") then
                    p51.CFrame = v60;
                else
                    p51:PivotTo(v60);
                end;
            end;

            if p51:IsA("BasePart") then
                p51.CFrame = p53;

                return;
            end;

            p51:PivotTo(p53);
        end;

        local function ballOnTable(p61: number) -- Line: 314
            -- upvalues: u6 (ref), u37 (ref)
            local v62 = u6.slotCups[p61];

            if not v62:IsA("BasePart") then
                v62 = v62:IsA("Model") and v62.PrimaryPart or nil;
            end;

            local ball = u6.ball;

            if not ball:IsA("BasePart") then
                ball = ball:IsA("Model") and ball.PrimaryPart or nil;
            end;

            return CFrame.new(u37[p61].Position + Vector3.new(0, (ball and ball.Size.Y / 2 or 0) - (v62 and v62.Size.Y / 2 or 0), 0));
        end;

        local function ballInCup(p63: number) -- Line: 326
            -- upvalues: u6 (ref), u37 (ref)
            local v64 = u6.slotCups[p63];

            if not v64:IsA("BasePart") then
                v64 = v64:IsA("Model") and v64.PrimaryPart or nil;
            end;

            return CFrame.new(v64 and v64.Position or u37[p63].Position);
        end;

        local function toStart() -- Line: 333
            -- upvalues: u6 (ref), u34 (ref), moveTo (ref), TweenInfo_new_ret4 (ref), u37 (ref), Ball (ref), cf (ref)
            for i = 1, 3 do
                u6.slotCups[i] = u34[i];
                moveTo(u34[i], TweenInfo_new_ret4, u37[i] + Vector3.new(0, 0.3, 0));
                local _ = i;
            end;

            local v65 = Ball;

            if not v65:IsA("BasePart") then
                v65 = v65:IsA("Model") and v65.PrimaryPart or nil;
            end;

            if v65 then
                v65.Transparency = 0;
            end;

            moveTo(Ball, TweenInfo_new_ret4, cf);
        end;

        local function runSequence(p66: number) -- Line: 344
            -- upvalues: toStart (copy), u33 (ref), u5 (ref), moveTo (ref), Ball (ref), TweenInfo_new_ret (ref), ballInCup (copy), playSound (ref), u6 (ref), TweenInfo_new_ret2 (ref), u37 (ref), CFrame_Angles_ret (ref), PlatformLeniency (ref), arcMove (copy), u2 (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), AlwaysOnTop (ref), TweenInfo_new_ret3 (ref), ballOnTable (copy)
            toStart();
            task.wait(0.4);

            if u33 ~= u5 then
                return false;
            end;

            moveTo(Ball, TweenInfo_new_ret, ballInCup(2));
            playSound("PS2trainingCUPSplaceball", Ball);
            task.wait(0.4);

            if u33 ~= u5 then
                return false;
            end;

            local v67 = Ball;

            if not v67:IsA("BasePart") then
                v67 = v67:IsA("Model") and v67.PrimaryPart or nil;
            end;

            if v67 then
                v67.Transparency = 1;
            end;

            local v68 = u6.slotCups[2];
            moveTo(u6.slotCups[1], TweenInfo_new_ret2, u37[1] * CFrame_Angles_ret);
            moveTo(u6.slotCups[2], TweenInfo_new_ret2, u37[2] * CFrame_Angles_ret);
            moveTo(u6.slotCups[3], TweenInfo_new_ret2, u37[3] * CFrame_Angles_ret);
            playSound("PS2trainingCUPSflip1", u6.slotCups[2]);
            task.wait(0.3);

            if u33 ~= u5 then
                return false;
            end;

            local math_max_ret = math.max(0, 1 - (p66 - 1) * 0.07);
            local v69 = PlatformLeniency();
            local v70 = math.max(0.15, math_max_ret * 0.45) * v69;
            local v71 = math.max(0.03, math_max_ret * 0.15) * v69;
            local TweenInfo_new_ret5 = TweenInfo.new(v70, Enum.EasingStyle.Quad);
            local math_round_ret = math.round(2 ^ (p66 - 1) * 4);

            for i = 1, math.min(12, math_round_ret) do
                local v72 = math.random(1, 2) == 1 and 1 or 3;
                local v73;

                if math.random(1, 2) == 1 then
                    v73 = v72;
                    v72 = 2;
                else
                    v73 = 2;
                end;

                local v74 = u6.slotCups[v73];
                local v75 = u6.slotCups[v72];
                local slotCups = u6.slotCups;
                u6.slotCups[v73] = v75;
                slotCups[v72] = v74;
                playSound("PS2trainingCUPSslide", v75);
                moveTo(v75, TweenInfo_new_ret5, u37[v73] * CFrame_Angles_ret);
                arcMove(v74, u37[v73] * CFrame_Angles_ret, u37[v72] * CFrame_Angles_ret, 3.5, v70);

                if u33 ~= u5 then
                    return false;
                end;

                local table_find_ret = table.find(u6.slotCups, v68);

                if table_find_ret then
                    local v76 = Ball;
                    local v77 = u6.slotCups[table_find_ret];

                    if not v77:IsA("BasePart") then
                        v77 = v77:IsA("Model") and v77.PrimaryPart or nil;
                    end;

                    local CFrame_new_ret = CFrame.new(v77 and v77.Position or u37[table_find_ret].Position);

                    if v76:IsA("BasePart") then
                        v76.CFrame = CFrame_new_ret;
                    else
                        v76:PivotTo(CFrame_new_ret);
                    end;
                end;

                task.wait(v71);

                if u33 ~= u5 then
                    return false;
                end;

                local _ = i;
            end;

            local v78 = u2:Extend();
            local u79 = v78:Add(Instance.new("BindableEvent"));
            local u80 = nil;

            for i = 1, 3 do
                local u81 = u6.slotCups[i];
                local ClickDetector = Instance.new("ClickDetector");
                ClickDetector.MaxActivationDistance = 1000;
                ClickDetector.Parent = u81;
                v78:Add(ClickDetector);
                local Highlight = Instance.new("Highlight");
                Highlight.Adornee = u81;
                Highlight.FillColor = Color3_fromRGB_ret;
                Highlight.OutlineColor = Color3_fromRGB_ret2;
                Highlight.FillTransparency = 0.6;
                Highlight.OutlineTransparency = 0;
                Highlight.DepthMode = AlwaysOnTop;
                Highlight.Enabled = false;
                Highlight.Parent = u81;
                v78:Add(Highlight);
                v78:Connect(ClickDetector.MouseHoverEnter, function() -- Line: 429
                    -- upvalues: Highlight (copy)
                    Highlight.Enabled = true;
                end);
                v78:Connect(ClickDetector.MouseHoverLeave, function() -- Line: 432
                    -- upvalues: Highlight (copy)
                    Highlight.Enabled = false;
                end);
                v78:Connect(ClickDetector.MouseClick, function() -- Line: 435
                    -- upvalues: u80 (ref), u81 (copy), playSound (ref), u79 (copy)
                    if u80 == nil then
                        u80 = u81;
                        playSound("PS2trainingCUPSlift", u81);
                        u79:Fire();
                    end;
                end);
                local _ = i;
            end;

            u79.Event:Wait();
            v78:Destroy();

            if u33 ~= u5 then
                return false;
            end;

            local table_find_ret = table.find(u6.slotCups, u80);

            if table_find_ret then
                moveTo(u80, TweenInfo_new_ret3, u37[table_find_ret] * CFrame_Angles_ret + Vector3.new(0, 2.5, 0));
            end;

            if u80 ~= v68 then
                task.wait(0.35);

                return false;
            end;

            local table_find_ret2 = table.find(u6.slotCups, v68);
            local v82 = Ball;

            if not v82:IsA("BasePart") then
                v82 = v82:IsA("Model") and v82.PrimaryPart or nil;
            end;

            if v82 then
                v82.Transparency = 0;
            end;

            if table_find_ret2 then
                local v83 = Ball;
                local v84 = ballOnTable(table_find_ret2);

                if v83:IsA("BasePart") then
                    v83.CFrame = v84;
                else
                    v83:PivotTo(v84);
                end;
            end;

            task.wait(0.8);

            return true;
        end;

        local v85 = 1;
        local v86 = 0;

        while u33 == u5 do
            local v87 = runSequence(v85);

            if u33 ~= u5 then
                return;
            end;

            if v87 then
                v86 = v86 + 1;
                u48:Set(v86);
                v85 = v85 + 1;

                if u49 <= v86 then
                    if u40 then
                        return;
                    end;

                    u40 = true;
                    SignalEvent.ToServer("training_signaler", "Stop", true);

                    return;
                end;
            else
                if u50 > 0 then
                    u47[u50]:Set(false);
                    u50 = u50 - 1;
                end;

                if u50 <= 0 then
                    if u40 then
                        return;
                    end;

                    u40 = true;
                    SignalEvent.ToServer("training_signaler", "Stop", false);

                    return;
                end;
            end;
        end;
    end);
end;

function v1.Stop(p88: userdata, p89: userdata, p90: userdata) -- Line: 498
    -- upvalues: teardown (copy)
    teardown();
end;

return v1;