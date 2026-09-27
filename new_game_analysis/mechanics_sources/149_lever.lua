-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Cam_Shaker = require(ReplicatedStorage.CAM.Client.Modules.Effects.Cam_Shaker);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Sounds = script.Parent:WaitForChild("Sounds");
local CFrame_new_ret = CFrame.new(17.5, 0, 0);

local function rebaseGatePiece(p1: userdata) -- Line: 14
    if not p1:IsA("BasePart") or p1:GetAttribute("CFsRebased") then
        return;
    end;

    local Attribute = p1:GetAttribute("StartCF");
    local Attribute2 = p1:GetAttribute("EndCF");

    if Attribute == nil or Attribute2 == nil then
        return;
    end;

    local v2 = p1.CFrame * Attribute:Inverse();
    p1:SetAttribute("StartCF", p1.CFrame);
    p1:SetAttribute("EndCF", v2 * Attribute2);
    p1:SetAttribute("CFsRebased", true);
end;

local u3 = {};
u3.__index = u3;

function u3.PoseGate(p4: table, p5: userdata?) -- Line: 27
    -- upvalues: rebaseGatePiece (copy), CFrame_new_ret (copy)
    local Gate = p4.Gate;

    if Gate == nil then
        return;
    end;

    if Gate:GetAttribute("IsCF") then
        local v6 = p4.GateOpen and "EndCF" or "StartCF";

        for _, v in p5 ~= nil and { p5 } or Gate:GetChildren() do
            if v:IsA("BasePart") then
                rebaseGatePiece(v);
                local Attribute = v:GetAttribute(v6);

                if Attribute then
                    v.CFrame = Attribute;
                end;
            end;
        end;

        return;
    end;

    local Attribute = Gate:GetAttribute("GateStart");

    if p5 == nil then
        p5 = Gate:FindFirstChild("Top");
    end;

    if Attribute == nil or (p5 == nil or (p5.Name ~= "Top" or not p5:IsA("BasePart"))) then
        return;
    end;

    if p4.GateOpen then
        Attribute = Attribute * CFrame_new_ret;
    end;

    p5.CFrame = Attribute;
end;

function u3.Reset(p7, p8, p9) -- Line: 47
    if p7.Lever == nil then
        return;
    end;

    local A_ = p7.Lever:FindFirstChild("A_");

    if A_ == nil then
        return;
    end;

    if p8 then
        if not p9 then
            A_:SetAttribute("On", false);
        end;

        if p7.Tweens then
            for _, v in p7.Tweens do
                v:Cancel();
            end;

            table.clear(p7.Tweens);
        end;

        if p7.Dusts then
            for _, v in p7.Dusts do
                v:Destroy();
            end;

            table.clear(p7.Dusts);
        end;

        if p7.Shake then
            if p7.Shake:IsShaking() then
                p7.Shake:Stop();
            end;

            p7.Shake = nil;
        end;

        if p7.LeverStop then
            p7.LeverStop();
            p7.LeverStop = nil;
        end;

        if p7.GateStop then
            p7.GateStop();
            p7.GateStop = nil;
        end;

        if p7.Sounds then
            for _, v in p7.Sounds do
                if v and v.Parent then
                    v:Stop();
                    v:Destroy();
                end;
            end;

            table.clear(p7.Sounds);
        end;

        if p7.Gate and not p9 then
            p7.GateOpen = false;
            p7:PoseGate();
        end;
    end;

    local v10;

    if A_:GetAttribute("On") then
        v10 = A_:GetAttribute("EndPivot");
    else
        v10 = A_:GetAttribute("StartPivot");
    end;

    if not v10 then
        return;
    end;

    A_:PivotTo(v10);
end;

function u3.Destroy(p11, p12) -- Line: 101
    p11:Reset(true, p12);

    if p12 and p11.Lever then
        local A_ = p11.Lever:FindFirstChild("A_");

        if A_ then
            A_ = A_:FindFirstChild("LeverMain");
        end;

        if A_ then
            A_ = A_:FindFirstChild("ProximityPrompt");
        end;

        if A_ then
            A_.Enabled = false;
        end;
    end;

    p11.HoldStarted = nil;

    for _, v in { p11.Connections, p11.PromptConnections } do
        if v ~= nil then
            for _, v2 in v do
                v2:Disconnect();
            end;
        end;
    end;

    p11.Connections = nil;
    p11.PromptConnections = nil;
    p11.Tweens = nil;
    p11.Dusts = nil;
    p11.Sounds = nil;
    p11.LeverStop = nil;
    p11.GateStop = nil;
    setmetatable(p11, nil);
end;

local TweenInfo_new_ret = TweenInfo.new(0.1);
local TweenInfo_new_ret2 = TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
local Color3_new_ret = Color3.new(0.109804, 0.952941, 0.109804);
local Color3_new_ret2 = Color3.new(0.941176, 0.345098, 0.345098);
local Color3_fromRGB_ret = Color3.fromRGB(250, 186, 48);
local Color3_fromRGB_ret2 = Color3.fromRGB(150, 85, 85);
local Color3_fromRGB_ret3 = Color3.fromRGB(85, 150, 85);
local Color3_fromRGB_ret4 = Color3.fromRGB(175, 124, 30);

local function playSequence(u13: userdata, p14: string, p15: string, u16: string, p17: table) -- Line: 136
    -- upvalues: Sounds (copy), DebrisModule (copy)
    local u18 = Sounds[p14]:Clone();
    u18.Parent = u13;
    table.insert(p17, u18);
    u18:Play();
    local u19 = Sounds[p15]:Clone();
    u19.Looped = true;
    u19.Parent = u13;
    table.insert(p17, u19);
    u19:Play();
    local u20 = false;

    return function() -- Line: 147
        -- upvalues: u20 (ref), u18 (copy), u19 (copy), Sounds (ref), u16 (copy), u13 (copy), DebrisModule (ref)
        if u20 then
            return;
        end;

        u20 = true;

        if u18.Parent then
            u18:Stop();
            u18:Destroy();
        end;

        if u19.Parent then
            u19:Stop();
            u19:Destroy();
        end;

        local v21 = Sounds[u16]:Clone();
        v21.Parent = u13;
        v21:Play();
        DebrisModule:AddItem(v21, 0);
    end;
end;

return function(u22: userdata, u23: userdata?, p24: any, u25: userdata, u26: number, p27: number?) -- Line: 166
    -- upvalues: u3 (copy), Color3_new_ret (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), Color3_new_ret2 (copy), Color3_fromRGB_ret2 (copy), TweenService (copy), TweenInfo_new_ret (copy), playSequence (copy), TweenInfo_new_ret2 (copy), DebrisModule (copy), Ouwmit (copy), CFrame_new_ret (copy), Cam_Shaker (copy), SignalEvent (copy)
    local u28 = p27 or 1;
    local u29 = setmetatable({
        GateOpen = false,
        LeverStop = nil,
        GateStop = nil,
        Lever = u22,
        Gate = u23,
        Connections = {},
        PromptConnections = {},
        Tweens = {},
        Dusts = {},
        Sounds = {}
    }, u3);
    p24:Add(task.spawn(function() -- Line: 169
        -- upvalues: u22 (copy), u23 (copy), u29 (copy), u25 (copy), Color3_new_ret (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref), Color3_new_ret2 (ref), Color3_fromRGB_ret2 (ref), TweenService (ref), TweenInfo_new_ret (ref), playSequence (ref), TweenInfo_new_ret2 (ref), DebrisModule (ref), Ouwmit (ref), CFrame_new_ret (ref), Cam_Shaker (ref), SignalEvent (ref), u28 (ref), u26 (copy)
        local A_ = u22:WaitForChild("A_");
        local LeverMain = A_:WaitForChild("LeverMain");
        local ProximityPrompt = LeverMain:WaitForChild("ProximityPrompt");

        if u23 and (not u23:GetAttribute("IsCF") and u23:GetAttribute("GateStart") == nil) then
            u23:SetAttribute("GateStart", u23:WaitForChild("Top").CFrame);
        end;

        u29:PoseGate();
        local u30 = A_:GetAttribute("On") or false;
        local u31 = nil;
        local u32 = u30;

        local function track(p33, p34) -- Line: 182
            -- upvalues: u29 (ref)
            if u29.Tweens then
                if u29.Tweens[p33] then
                    u29.Tweens[p33]:Cancel();
                end;

                u29.Tweens[p33] = p34;
            end;

            return p34;
        end;

        local function updateColors() -- Line: 191
            -- upvalues: u25 (ref), u30 (ref), Color3_new_ret (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref), Color3_new_ret2 (ref), Color3_fromRGB_ret2 (ref), u22 (ref), A_ (copy), TweenService (ref), TweenInfo_new_ret (ref), u29 (ref)
            local Attribute = u25:GetAttribute("Level");

            if Attribute then
                Attribute = Attribute % 1 == 0;
            end;

            local v35, v36;

            if u30 then
                if Attribute then
                    v35 = Color3_new_ret;
                else
                    v35 = Color3_fromRGB_ret;
                end;

                if Attribute then
                    v36 = Color3_fromRGB_ret3;
                else
                    v36 = Color3_fromRGB_ret4;
                end;
            else
                v35 = Color3_new_ret2;
                v36 = Color3_fromRGB_ret2;
            end;

            local color = u22:FindFirstChild("color");
            local v37;

            if color then
                v37 = color:FindFirstChild("PointLight");
            else
                v37 = color;
            end;

            local color2 = A_:FindFirstChild("color");

            if v37 then
                local v38 = TweenService:Create(v37, TweenInfo_new_ret, {
                    Color = v35
                });

                if u29.Tweens then
                    if u29.Tweens.Light then
                        u29.Tweens.Light:Cancel();
                    end;

                    u29.Tweens.Light = v38;
                end;

                v38:Play();
            end;

            if color then
                local v39 = TweenService:Create(color, TweenInfo_new_ret, {
                    Color = v36
                });

                if u29.Tweens then
                    if u29.Tweens.ParentColor then
                        u29.Tweens.ParentColor:Cancel();
                    end;

                    u29.Tweens.ParentColor = v39;
                end;

                v39:Play();
            end;

            if color2 then
                local v40 = TweenService:Create(color2, TweenInfo_new_ret, {
                    Color = v36
                });

                if u29.Tweens then
                    if u29.Tweens.LeverColor then
                        u29.Tweens.LeverColor:Cancel();
                    end;

                    u29.Tweens.LeverColor = v40;
                end;

                v40:Play();
            end;
        end;

        local function Update() -- Line: 214
            -- upvalues: u25 (ref), updateColors (copy), u32 (ref), u30 (ref), u23 (ref), u29 (ref), playSequence (ref), TweenInfo_new_ret2 (ref), DebrisModule (ref), Ouwmit (ref), TweenService (ref), CFrame_new_ret (ref), Cam_Shaker (ref)
            local Attribute = u25:GetAttribute("Level");

            if Attribute then
                Attribute = Attribute % 1 == 0;
            end;

            updateColors();

            if not Attribute then
                return;
            end;

            if u32 ~= u30 then
                if u23 then
                    local v41;

                    if u23:GetAttribute("IsCF") then
                        v41 = u23:FindFirstChild("Center");
                    else
                        v41 = u23:FindFirstChild("Top");
                    end;

                    if v41 then
                        if u30 then
                            if u29.GateStop then
                                u29.GateStop();
                                u29.GateStop = nil;
                            end;

                            local u42 = playSequence(v41, "PS2gateBEGINLIFT", "PS2gateOPENLOOP", "PS2leverGATESTOP", u29.Sounds);
                            u29.GateStop = u42;
                            task.delay(TweenInfo_new_ret2.Time, function() -- Line: 230
                                -- upvalues: u29 (ref), u42 (copy)
                                if u29.GateStop == u42 then
                                    u42();
                                    u29.GateStop = nil;
                                end;
                            end);
                        elseif u29.GateStop then
                            u29.GateStop();
                            u29.GateStop = nil;
                        end;
                    end;

                    u29.GateOpen = u30;

                    if u23:GetAttribute("IsCF") then
                        u29:PoseGate();
                        local v43 = u30 and u23:FindFirstChild("Center");

                        if v43 then
                            local v44 = script.IsCF.At:Clone();
                            v44.Parent = v43;
                            DebrisModule:AddItem(v44, 3);
                            Ouwmit.Emit(v44);
                        end;
                    else
                        local Attribute2 = u23:GetAttribute("GateStart");
                        local Top = u23:FindFirstChild("Top");

                        if Attribute2 and Top then
                            if u30 then
                                local v45 = TweenService:Create(Top, TweenInfo_new_ret2, {
                                    CFrame = Attribute2 * CFrame_new_ret
                                });

                                if u29.Tweens then
                                    if u29.Tweens.Gate then
                                        u29.Tweens.Gate:Cancel();
                                    end;

                                    u29.Tweens.Gate = v45;
                                end;

                                v45:Play();

                                if u29.Shake and u29.Shake:IsShaking() then
                                    u29.Shake:Stop();
                                end;

                                u29.Shake = Cam_Shaker(Top.Position, {
                                    FadeInTime = 0.3,
                                    Frequency = 0.15,
                                    Amplitude = 0.2,
                                    SustainTime = 2,
                                    FadeOutTime = 3,
                                    RotationInfluence = Vector3.new(0.1, 0.1, 0.1),
                                    PositionInfluence = Vector3.new(2, 2, 2)
                                });
                                local Bottom = u23:FindFirstChild("Bottom");

                                for _, child in script.OpenDusts:GetChildren() do
                                    local v46 = child;

                                    for _, v in { Top, Bottom } do
                                        if v then
                                            local u47 = v46:Clone();
                                            u47.Parent = v;

                                            if u29.Dusts then
                                                table.insert(u29.Dusts, u47);
                                            end;

                                            task.delay(3, function() -- Line: 280
                                                -- upvalues: u47 (copy)
                                                if u47.Parent then
                                                    u47.Enabled = false;
                                                end;
                                            end);
                                            task.delay(7, function() -- Line: 285
                                                -- upvalues: u47 (copy)
                                                if u47.Parent then
                                                    u47:Destroy();
                                                end;
                                            end);
                                        end;
                                    end;
                                end;
                            else
                                local v48 = TweenService:Create(Top, TweenInfo_new_ret2, {
                                    CFrame = Attribute2
                                });

                                if u29.Tweens then
                                    if u29.Tweens.Gate then
                                        u29.Tweens.Gate:Cancel();
                                    end;

                                    u29.Tweens.Gate = v48;
                                end;

                                v48:Play();
                            end;
                        end;
                    end;
                end;

                u32 = u30;
            end;
        end;

        local Attribute = A_:GetAttribute("StartPivot");

        if not Attribute then
            Attribute = A_:GetPivot();
            A_:SetAttribute("StartPivot", Attribute);
        end;

        local u49 = Attribute * CFrame.Angles(0, 2.356194490192345, 0);
        A_:SetAttribute("EndPivot", u49);

        local function bindPrompt(p50: userdata) -- Line: 309
            -- upvalues: u29 (ref), ProximityPrompt (ref), u30 (ref), u31 (ref), A_ (copy), SignalEvent (ref), u22 (ref), u28 (ref), u25 (ref), u26 (ref), DebrisModule (ref), Color3_fromRGB_ret (ref), Color3_new_ret (ref), Color3_new_ret2 (ref), Ouwmit (ref), u49 (copy), Attribute (ref), playSequence (ref), LeverMain (ref)
            for _, v in u29.PromptConnections do
                v:Disconnect();
            end;

            table.clear(u29.PromptConnections);
            ProximityPrompt = p50;
            ProximityPrompt.Enabled = not u30;
            table.insert(u29.PromptConnections, ProximityPrompt.Triggered:Connect(function() -- Line: 319
                -- upvalues: ProximityPrompt (ref), u31 (ref), u30 (ref), A_ (ref), SignalEvent (ref), u22 (ref), u28 (ref), u25 (ref), u26 (ref), DebrisModule (ref), Color3_fromRGB_ret (ref), Color3_new_ret (ref), Color3_new_ret2 (ref), Ouwmit (ref)
                if ProximityPrompt.HoldDuration > 0 and not u31 then
                    return;
                end;

                if u30 then
                    return;
                end;

                u30 = true;
                A_:SetAttribute("On", u30);
                ProximityPrompt.Enabled = false;
                SignalEvent.ToServer("training_signaler", "StateChanged", u22);
                local color = u22:FindFirstChild("color");
                local v51 = (u25:GetAttribute("Level") or u26) + u28;
                local v52 = v51 % 1 == 0;

                if color then
                    local v53 = script.Attachment:Clone();
                    v53.Parent = color;
                    DebrisModule:AddItem(v53, 1.5);
                    local v54;

                    if v52 then
                        if u30 then
                            v54 = Color3_new_ret;
                        else
                            v54 = Color3_new_ret2;
                        end;
                    else
                        v54 = Color3_fromRGB_ret;
                    end;

                    Ouwmit.Emit(v53, {
                        ColorWhitelist = "SetColor",
                        Color = v54
                    });
                end;

                u25:SetAttribute("Level", v51);
                u31 = nil;
            end));
            table.insert(u29.PromptConnections, ProximityPrompt.PromptButtonHoldBegan:Connect(function() -- Line: 340
                -- upvalues: ProximityPrompt (ref), u31 (ref), u30 (ref), u49 (ref), Attribute (ref), u29 (ref), playSequence (ref), LeverMain (ref), A_ (ref)
                if ProximityPrompt:GetAttribute("OnCooldown") then
                    u31 = nil;

                    return;
                end;

                local v55, v56;

                if u30 then
                    v55 = u49;
                    v56 = Attribute;
                else
                    v55 = Attribute;
                    v56 = u49;
                end;

                u29.HoldStarted = os.clock();
                u31 = true;

                if u29.LeverStop then
                    u29.LeverStop();
                    u29.LeverStop = nil;
                end;

                u29.LeverStop = playSequence(LeverMain, "PS2leverPULL", "PS2leverPULLloop", "PS2leverSTOP", u29.Sounds);

                while u29.HoldStarted ~= nil do
                    local v57 = (os.clock() - u29.HoldStarted) / ProximityPrompt.HoldDuration;
                    A_:PivotTo(v55:Lerp(v56, (math.clamp(v57, 0, 1))));
                    task.wait();
                end;
            end));
            table.insert(u29.PromptConnections, ProximityPrompt.PromptButtonHoldEnded:Connect(function() -- Line: 362
                -- upvalues: u29 (ref), ProximityPrompt (ref)
                if u29.HoldStarted == nil then
                    return;
                end;

                task.wait();

                if u29.HoldStarted == nil then
                    return;
                end;

                if os.clock() - u29.HoldStarted < ProximityPrompt.HoldDuration then
                    u29:Reset();
                end;

                u29.HoldStarted = nil;

                if u29.LeverStop then
                    u29.LeverStop();
                    u29.LeverStop = nil;
                end;
            end));
        end;

        Update();
        u29.HoldStarted = nil;
        bindPrompt(ProximityPrompt);
        local Connections = u29.Connections;
        local AttributeChangedSignal = u25:GetAttributeChangedSignal("Level");
        table.insert(Connections, AttributeChangedSignal:Connect(Update));
        table.insert(u29.Connections, u22.DescendantAdded:Connect(function(p58) -- Line: 382
            -- upvalues: bindPrompt (copy), LeverMain (ref), u29 (ref), updateColors (copy)
            if p58:IsA("ProximityPrompt") then
                bindPrompt(p58);

                return;
            end;

            if p58:IsA("BasePart") then
                if p58.Name == "LeverMain" then
                    LeverMain = p58;
                end;

                u29:Reset();
                updateColors();
            end;
        end));

        if u23 then
            table.insert(u29.Connections, u23.ChildAdded:Connect(function(p59) -- Line: 394
                -- upvalues: u29 (ref)
                u29:PoseGate(p59);
            end));
        end;
    end));

    return u29;
end;