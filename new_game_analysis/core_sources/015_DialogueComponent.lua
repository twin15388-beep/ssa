-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local textplus = require(game.ReplicatedStorage.Packages.textplus);
local Dialogue = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue);
local faye = require(ReplicatedStorage.Packages.faye);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local script_DialogueUtility = require(script.DialogueUtility);
local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local u1 = faye.Info(0.45);
local u2 = faye.Info(0.75);
local u3 = faye.Info(0.25);
local u4 = faye.Info(0.2);
local u5 = faye.SpringInfo(0.3, 1, 0.5);
local script_Option = require(script.Option);
local u6 = typeof;
local u7 = faye.Info(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(1, Enum.EasingStyle.Sine);
local u8 = {
    Back = 1,
    Close = 2,
    Cancel = 2,
    Nevermind = 2,
    Farewell = 2,
    ["Not yet"] = 2
};
local u9 = {
    ["Buy the selection"] = 1,
    ["Sell the selection"] = 1,
    ["Make the exchange"] = 1,
    ["Take the drawings"] = 1
};

return function(p10: userdata, p11: string, p12: userdata) -- Line: 82
    -- upvalues: Platform_Handler (copy), Dialogue (copy), script_DialogueUtility (copy), faye (copy), u1 (copy), u4 (copy), ScreenEffects (copy), u6 (copy), u5 (copy), u7 (copy), u3 (copy), u2 (copy), u9 (copy), u8 (copy), script_Option (copy), Camera_Traffic_Handler (copy), gameSettings (copy), textplus (copy), TweenService (copy), TweenInfo_new_ret (copy), SignalEvent (copy)
    local u13 = Platform_Handler.Platform.Value == "Mobile";
    local v14 = u13 and 0.44999999999999996 or 0.3;
    local v15 = 1 - v14 + 0.0625;
    local u16, u17, u18;

    if p12 == nil then
        u16 = p12;
        u17 = nil;
        u18 = nil;
    else
        u17 = p12.MaxActivationDistance;
        local Parent = p12.Parent;
        u16 = p12;
        u18 = nil;

        while Parent ~= nil do
            if Parent.ClassName == "Model" then
                if Parent.PrimaryPart ~= nil then
                    p12 = Parent;
                    break;
                end;
            else
                if not Parent:IsA("BasePart") then
                    break;
                end;

                u18 = u18 or Parent;
            end;

            Parent = Parent.Parent;
        end;

        if p12 ~= u16 then
            u18 = p12;
        end;
    end;

    Dialogue.ResetStorage();
    local Character = game.Players.LocalPlayer.Character;
    local u19;

    if Character == nil or Character.PrimaryPart == nil then
        u19 = nil;
    else
        u19 = Character.PrimaryPart;
    end;

    local v20 = script_DialogueUtility.ExtractValue(p11 == nil and "NoQuest" or p11, u16);

    if v20 == nil then
        return;
    end;

    local u21 = Dialogue.Diagloues[v20];

    if u21 ~= nil then
        local v22;

        if u21 == nil or u21.BeforeRun == nil then
            v22 = v20;
        else
            v22 = script_DialogueUtility.BeforeRun(u21.BeforeRun, u16);

            if v22 == nil then
                v22 = v20;
            elseif v22 == false or Dialogue.Diagloues[v22] == nil then
                return;
            end;
        end;

        local u23;

        if u18 == nil then
            u23 = false;
        else
            u23 = u18:IsA("BasePart") and u18.Position or u18.PrimaryPart.Position;
        end;

        local u24 = faye.new();
        local u25 = false;
        local u26 = u24:Value({});
        local u27 = u24:Value(false);
        local u28 = 0;
        local u29 = u24:Create("Frame")({
            Name = "DialogueHolder",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0.8, 0.8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5)
        });
        local u30 = nil;
        local u31 = nil;
        local u32;

        if u18 == nil then
            u32 = nil;
        else
            u32 = u16:GetAttribute("Icon") or u18:GetAttribute("Icon");
        end;

        local u33;

        if u18 == nil then
            u33 = nil;
        else
            u33 = u16:GetAttribute("Name") or u18.Name;
        end;

        local u34 = u24:Value(u32);
        local u35 = u24:Value(u33);
        local u36 = nil;
        local u37 = nil;
        local u39 = u24:Space(function(p38: table) -- Line: 165
            if p38.In == true then
                p38.Fg:Set(Color3.new(1, 1, 1));
                p38.Bg:Set(Color3.new(1, 1, 1));
                p38.Txt:Set(Color3.new());
                p38.ST:Set(0.7);
                p38.S:Set(UDim2.fromScale(1.1, 1.1));

                return;
            end;

            p38.S:Reset();
            p38.ST:Reset();
            p38.Txt:Reset();
            p38.Bg:Reset();
            p38.Fg:Reset();
        end);
        local v40 = u24:Create("Frame");
        local v41 = {
            Parent = p10,
            Name = "DialogueContent",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, v15),
            Size = UDim2.fromScale(0.9, (v15 - 0.0125) * 1.35),
            BackgroundTransparency = 1,
            CleanDelay = u1.Time
        };
        local v42;

        if u13 then
            v42 = u24:Create("UIScale")({
                Scale = 2
            });
        else
            v42 = nil;
        end;

        v41[1] = v42;
        local u43 = v40(v41);
        u24:Create("Frame")({
            Parent = p10,
            Name = "DialogueFrame",
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.fromScale(1, v14),
            BackgroundTransparency = u24:Animation(0, u4, {
                From = 1
            }),
            BackgroundColor3 = Color3.new(),
            u24:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(0.8, 0.9), NumberSequenceKeypoint.new(1, 1) })
            }),
            Position = UDim2.fromScale(0, 1),

            OnClean = function(p44) -- Line: 215, Name: OnClean
                -- upvalues: u31 (ref), u1 (ref)
                if u31 ~= nil then
                    p44:Configure(u31)({
                        GroupTransparency = p44:Animation(1, u1)
                    });
                end;

                return {
                    BackgroundTransparency = p44:Animation(1, u1)
                };
            end,

            u24:Create("Frame")({
                Name = "Actual",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.5, 0.5),
                BackgroundTransparency = 1,
                u24:Create("TextButton")({
                    Name = "ClickDetector",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1.2, 1),
                    BackgroundTransparency = 1,
                    ZIndex = 2,
                    Visible = u24:DelayValue(u27, nil):For(false, u1.Time),

                    MouseButton1Click = function(p45) -- Line: 241, Name: MouseButton1Click
                        -- upvalues: u27 (copy), ScreenEffects (ref), u25 (ref), u30 (ref), u29 (copy), u21 (ref), u6 (ref), script_DialogueUtility (ref), u16 (copy)
                        if not u27:Get() then
                            return;
                        end;

                        ScreenEffects.StrokeClick(p45.Parent, UDim.new(1));

                        if u25 then
                            if u30 ~= nil then
                                u30:Print(u29);
                            end;
                        else
                            if u6(u21.Answers) == "table" then
                                return;
                            end;

                            if u21.IfTrue then
                                script_DialogueUtility.DoAll(u21.IfTrue, u16);

                                return;
                            end;

                            script_DialogueUtility.Close();
                        end;
                    end,

                    u24:State(function(p46, p47) -- Line: 269
                        -- upvalues: u27 (copy), u5 (ref), u7 (ref), u3 (ref)
                        if p46(u27) then
                            return p47:Create("ImageLabel")({
                                Name = "PointerImage",
                                Size = p47:Animation(UDim2.fromScale(0.2, 0.2), u5, {
                                    From = UDim2.fromScale(0.1, 0.1)
                                }),
                                Instance.new("UIAspectRatioConstraint"),
                                Image = "rbxassetid://18240409219",
                                BackgroundTransparency = 1,
                                Rotation = 90,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = p47:Animation(UDim2.fromScale(0.5, 0.95), u7, {
                                    From = UDim2.fromScale(0.5, 1.05)
                                }),

                                OnClean = function(p48) -- Line: 281, Name: OnClean
                                    -- upvalues: u3 (ref)
                                    return {
                                        ImageTransparency = p48:Animation(1, u3)
                                    };
                                end
                            });
                        end;

                        return nil;
                    end)
                }),
                u24:Create("Frame")({
                    Name = "Bg",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    u24:Create("UICorner")({
                        CornerRadius = UDim.new(1)
                    }),
                    u24:State(function(p49, u50) -- Line: 299
                        -- upvalues: u34 (copy), u35 (copy), u2 (ref)
                        local u51 = p49(u34);
                        local u52 = p49(u35);

                        if u51 == nil and (u52 == nil or u52 == "") then
                            return nil;
                        end;

                        return u50:Create("Frame")({
                            Name = "NpcProfileHolder",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.fromScale(0.3, 0.02),
                            Size = UDim2.fromScale(0.4, 0.2),
                            u50:Create("UIListLayout")({
                                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                FillDirection = Enum.FillDirection.Horizontal,
                                Padding = UDim.new(0.025, 0)
                            }),
                            BackgroundTransparency = 1,

                            function() -- Line: 317
                                -- upvalues: u51 (copy), u50 (copy), u2 (ref)
                                if u51 == nil then
                                    return nil;
                                end;

                                return u50:Create("ImageLabel")({
                                    Size = UDim2.fromScale(0.35, 1),
                                    u50:Create("UIAspectRatioConstraint")({}),
                                    BackgroundTransparency = 1,
                                    Image = "rbxassetid://16873598266",
                                    ImageColor3 = Color3.new(0.15, 0.15, 0.15),
                                    u50:Create("ImageLabel")({
                                        BackgroundTransparency = 1,
                                        Size = UDim2.fromScale(1, 1),
                                        Image = u51,
                                        u50:Create("UICorner")({
                                            CornerRadius = UDim.new(1)
                                        }),

                                        CleanFunction = function() -- Line: 332, Name: CleanFunction
                                            -- upvalues: u50 (ref), u2 (ref)
                                            return {
                                                ImageTransparency = u50:Animation(1, u2)
                                            };
                                        end
                                    }),

                                    CleanFunction = function() -- Line: 338, Name: CleanFunction
                                        -- upvalues: u50 (ref), u2 (ref)
                                        return {
                                            ImageTransparency = u50:Animation(1, u2)
                                        };
                                    end
                                });
                            end,

                            function() -- Line: 347
                                -- upvalues: u52 (copy), u50 (copy), u2 (ref)
                                if u52 == nil or u52 == "" then
                                    return nil;
                                end;

                                return u50:Create("TextLabel")({
                                    Name = "NpcName",
                                    Size = UDim2.fromScale(1, 0.9),
                                    BackgroundTransparency = 1,
                                    Text = u52,
                                    TextScaled = true,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    Font = Enum.Font.SourceSansSemibold,
                                    TextColor3 = Color3.new(1, 1, 1),
                                    u50:Create("UIStroke")({
                                        Thickness = 1,
                                        Transparency = 0.75,

                                        CleanFunction = function() -- Line: 361, Name: CleanFunction
                                            -- upvalues: u50 (ref), u2 (ref)
                                            return {
                                                Transparency = u50:Animation(1, u2)
                                            };
                                        end
                                    }),

                                    CleanFunction = function() -- Line: 367, Name: CleanFunction
                                        -- upvalues: u50 (ref), u2 (ref)
                                        return {
                                            TextTransparency = u50:Animation(1, u2)
                                        };
                                    end
                                });
                            end
                        });
                    end),
                    BackgroundColor3 = Color3.new(0.05, 0.05, 0.05),
                    Size = u24:Animation(UDim2.fromScale(1, 1), u5, {
                        From = UDim2.fromScale(0.8, 0.8)
                    }),
                    u24:Create("UIGradient")({
                        Rotation = 90,
                        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0.4) })
                    }),
                    ZIndex = -1,

                    CleanFunction = function() -- Line: 387, Name: CleanFunction
                        -- upvalues: u24 (copy), u2 (ref)
                        return {
                            BackgroundTransparency = u24:Animation(1, u2)
                        };
                    end
                }),
                u24:Create("UIAspectRatioConstraint")({
                    AspectRatio = 3
                }),
                u29,
                u24:Create("Frame")({
                    Name = "ButtonHolder",
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.fromScale(1.035, 0.5),
                    Size = UDim2.fromScale(0.3, 0.2),
                    BackgroundTransparency = 1,
                    u24:Create("UIListLayout")({
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0.2, 0),
                        SortOrder = Enum.SortOrder.Name
                    }),
                    u24:AdvancedIterate(u26, function(p53, p54, p55) -- Line: 409
                        -- upvalues: u28 (ref), u9 (ref), u8 (ref), script_Option (ref), u39 (copy)
                        u28 = u28 + 1;
                        local v56 = p55:Create("Frame");
                        local v57 = {};
                        local v58;

                        if u9[p53] == nil then
                            if u8[p53] == nil then
                                v58 = p53;
                            else
                                v58 = "ZZZZZZZZZ" .. u8[p53];
                            end;
                        else
                            v58 = "000000000" .. u9[p53];
                        end;

                        v57.Name = v58;
                        v57.Size = UDim2.fromScale(1, 1);
                        v57.BackgroundTransparency = 1;
                        v57[1] = script_Option(p55, p53, p54, u28, u39);

                        return v56(v57);
                    end)
                })
            })
        });
        local u59 = nil;

        local function resolveContinue(p60) -- Line: 431
            -- upvalues: u59 (ref), u16 (copy), Dialogue (ref)
            if type(p60) == "function" then
                return p60(u59, u16, Dialogue.Storage) == true;
            end;

            return p60 == true;
        end;

        local function applyNodeIcon(p61) -- Line: 441
            -- upvalues: u34 (copy), u35 (copy), u59 (ref), u16 (copy), Dialogue (ref), u32 (copy), u33 (copy)
            if p61.Icon == nil and p61.Name == nil then
                local ContinueIcon = p61.ContinueIcon;
                local v62;

                if type(ContinueIcon) == "function" then
                    v62 = ContinueIcon(u59, u16, Dialogue.Storage) == true;
                else
                    v62 = ContinueIcon == true;
                end;

                if not v62 then
                    if not u34:Compare(u32) then
                        u34:Set(u32);
                    end;

                    if not u35:Compare(u33) then
                        u35:Set(u33);
                    end;
                end;
            else
                if p61.Icon ~= nil and not u34:Compare(p61.Icon) then
                    u34:Set(p61.Icon);
                end;

                if p61.Name ~= nil and not u35:Compare(p61.Name) then
                    u35:Set(p61.Name);
                end;
            end;
        end;

        local u63 = false;
        local u64 = nil;
        local u65 = 0;

        local function lerpCameraTo(u66, u67: function?) -- Line: 467
            -- upvalues: u65 (ref), Camera_Traffic_Handler (ref)
            u65 = u65 + 1;
            local u68 = u65;
            local workspace_CurrentCamera = workspace.CurrentCamera;
            local CFrame2 = workspace_CurrentCamera.CFrame;
            local os_clock_ret = os.clock();
            task.spawn(function() -- Line: 473
                -- upvalues: u65 (ref), u68 (copy), Camera_Traffic_Handler (ref), os_clock_ret (copy), workspace_CurrentCamera (copy), CFrame2 (copy), u66 (copy), u67 (copy)
                while u65 == u68 do
                    if Camera_Traffic_Handler.Equipped_Hirearchy ~= "Dialogue" then
                        return;
                    end;

                    local v69 = (os.clock() - os_clock_ret) / 0.5;
                    local math_min_ret = math.min(v69, 1);
                    workspace_CurrentCamera.CFrame = CFrame2:Lerp(u66, math_min_ret * math_min_ret * (3 - math_min_ret * 2));

                    if math_min_ret >= 1 then
                        if u67 ~= nil then
                            u67();
                        end;

                        return;
                    end;

                    task.wait();
                end;
            end);
        end;

        local function releaseCamera() -- Line: 486
            -- upvalues: u63 (ref), u64 (ref), Camera_Traffic_Handler (ref), u65 (ref)
            if not u63 then
                return;
            end;

            u63 = false;
            local u70 = u64;
            u64 = nil;

            if u70 == nil then
                Camera_Traffic_Handler.Dialogue = false;

                return;
            end;

            local function u71() -- Line: 492
                -- upvalues: Camera_Traffic_Handler (ref)
                Camera_Traffic_Handler.Dialogue = false;
            end;

            u65 = u65 + 1;
            local u72 = u65;
            local workspace_CurrentCamera = workspace.CurrentCamera;
            local CFrame2 = workspace_CurrentCamera.CFrame;
            local os_clock_ret = os.clock();
            task.spawn(function() -- Line: 473
                -- upvalues: u65 (ref), u72 (copy), Camera_Traffic_Handler (ref), os_clock_ret (copy), workspace_CurrentCamera (copy), CFrame2 (copy), u70 (copy), u71 (copy)
                while u65 == u72 do
                    if Camera_Traffic_Handler.Equipped_Hirearchy ~= "Dialogue" then
                        return;
                    end;

                    local v73 = (os.clock() - os_clock_ret) / 0.5;
                    local math_min_ret = math.min(v73, 1);
                    workspace_CurrentCamera.CFrame = CFrame2:Lerp(u70, math_min_ret * math_min_ret * (3 - math_min_ret * 2));

                    if math_min_ret >= 1 then
                        if u71 ~= nil then
                            u71();
                        end;

                        return;
                    end;

                    task.wait();
                end;
            end);
        end;

        local function applyNodeCamera(p74) -- Line: 499
            -- upvalues: u6 (ref), u16 (copy), Dialogue (ref), u63 (ref), u64 (ref), Camera_Traffic_Handler (ref), u65 (ref), u59 (ref)
            local CameraCFrame = p74.CameraCFrame;

            if u6(CameraCFrame) == "function" then
                CameraCFrame = CameraCFrame(u16, Dialogue.Storage);
            end;

            if u6(CameraCFrame) ~= "CFrame" then
                local ContinueCamera = p74.ContinueCamera;
                local v75;

                if type(ContinueCamera) == "function" then
                    v75 = ContinueCamera(u59, u16, Dialogue.Storage) == true;
                else
                    v75 = ContinueCamera == true;
                end;

                if not v75 then
                    if not u63 then
                        return;
                    end;

                    u63 = false;
                    local u76 = u64;
                    u64 = nil;

                    if u76 ~= nil then
                        local function u77() -- Line: 492
                            -- upvalues: Camera_Traffic_Handler (ref)
                            Camera_Traffic_Handler.Dialogue = false;
                        end;

                        u65 = u65 + 1;
                        local u78 = u65;
                        local workspace_CurrentCamera = workspace.CurrentCamera;
                        local CFrame2 = workspace_CurrentCamera.CFrame;
                        local os_clock_ret = os.clock();
                        task.spawn(function() -- Line: 473
                            -- upvalues: u65 (ref), u78 (copy), Camera_Traffic_Handler (ref), os_clock_ret (copy), workspace_CurrentCamera (copy), CFrame2 (copy), u76 (copy), u77 (copy)
                            while u65 == u78 do
                                if Camera_Traffic_Handler.Equipped_Hirearchy ~= "Dialogue" then
                                    return;
                                end;

                                local v79 = (os.clock() - os_clock_ret) / 0.5;
                                local math_min_ret = math.min(v79, 1);
                                workspace_CurrentCamera.CFrame = CFrame2:Lerp(u76, math_min_ret * math_min_ret * (3 - math_min_ret * 2));

                                if math_min_ret >= 1 then
                                    if u77 ~= nil then
                                        u77();
                                    end;

                                    return;
                                end;

                                task.wait();
                            end;
                        end);

                        return;
                    end;

                    Camera_Traffic_Handler.Dialogue = false;
                end;

                return;
            end;

            if not u63 then
                u63 = true;
                u64 = workspace.CurrentCamera.CFrame;
                Camera_Traffic_Handler.Dialogue = true;
            end;

            u65 = u65 + 1;
            local u80 = u65;
            local workspace_CurrentCamera = workspace.CurrentCamera;
            local CFrame2 = workspace_CurrentCamera.CFrame;
            local os_clock_ret = os.clock();
            local u81 = nil;
            task.spawn(function() -- Line: 473
                -- upvalues: u65 (ref), u80 (copy), Camera_Traffic_Handler (ref), os_clock_ret (copy), workspace_CurrentCamera (copy), CFrame2 (copy), CameraCFrame (copy), u81 (copy)
                while u65 == u80 do
                    if Camera_Traffic_Handler.Equipped_Hirearchy ~= "Dialogue" then
                        return;
                    end;

                    local v82 = (os.clock() - os_clock_ret) / 0.5;
                    local math_min_ret = math.min(v82, 1);
                    workspace_CurrentCamera.CFrame = CFrame2:Lerp(CameraCFrame, math_min_ret * math_min_ret * (3 - math_min_ret * 2));

                    if math_min_ret >= 1 then
                        if u81 ~= nil then
                            u81();
                        end;

                        return;
                    end;

                    task.wait();
                end;
            end);
        end;

        local u83 = nil;

        local function fireHidden() -- Line: 520
            -- upvalues: u83 (ref), u6 (ref), u16 (copy), Dialogue (ref)
            local v84 = u83;
            u83 = nil;

            if v84 ~= nil and u6(v84.OnHidden) == "function" then
                task.spawn(v84.OnHidden, u16, Dialogue.Storage);
            end;
        end;

        local u85 = nil;
        local u86 = 0;

        local function tryEnableClick(u87) -- Line: 534
            -- upvalues: u86 (ref), u85 (ref), u27 (copy)
            local v88 = u86 - os.clock();

            if v88 > 0 then
                task.delay(v88, function() -- Line: 537
                    -- upvalues: u85 (ref), u87 (copy), u27 (ref)
                    if u85 == u87 then
                        u27:Set(true);
                    end;
                end);

                return;
            end;

            u27:Set(true);
        end;

        local function PerformDialogue(p89: string) -- Line: 546
            -- upvalues: u85 (ref), u83 (ref), u6 (ref), u16 (copy), Dialogue (ref), u21 (ref), u27 (copy), u63 (ref), u64 (ref), Camera_Traffic_Handler (ref), u65 (ref), script_DialogueUtility (ref), u86 (ref), tryEnableClick (copy), applyNodeCamera (copy), applyNodeIcon (copy), u59 (ref), u37 (ref), u36 (ref), u24 (copy), u43 (ref), u26 (copy), u29 (copy), u25 (ref), gameSettings (ref), u13 (copy), textplus (ref), u30 (ref), u31 (ref), u28 (ref)
            local math_random_ret = math.random(1, 999);
            u85 = math_random_ret;
            local v90 = u83;
            u83 = nil;

            if v90 ~= nil and u6(v90.OnHidden) == "function" then
                task.spawn(v90.OnHidden, u16, Dialogue.Storage);
            end;

            u21 = Dialogue.Diagloues[p89];

            if u21 == nil or (u21.Text == nil or u21.Answers == nil) then
                u27:Reset();

                if u63 then
                    u63 = false;
                    local u91 = u64;
                    u64 = nil;

                    if u91 == nil then
                        Camera_Traffic_Handler.Dialogue = false;
                    else
                        local function u92() -- Line: 492
                            -- upvalues: Camera_Traffic_Handler (ref)
                            Camera_Traffic_Handler.Dialogue = false;
                        end;

                        u65 = u65 + 1;
                        local u93 = u65;
                        local workspace_CurrentCamera = workspace.CurrentCamera;
                        local CFrame2 = workspace_CurrentCamera.CFrame;
                        local os_clock_ret = os.clock();
                        task.spawn(function() -- Line: 473
                            -- upvalues: u65 (ref), u93 (copy), Camera_Traffic_Handler (ref), os_clock_ret (copy), workspace_CurrentCamera (copy), CFrame2 (copy), u91 (copy), u92 (copy)
                            while u65 == u93 do
                                if Camera_Traffic_Handler.Equipped_Hirearchy ~= "Dialogue" then
                                    return;
                                end;

                                local v94 = (os.clock() - os_clock_ret) / 0.5;
                                local math_min_ret = math.min(v94, 1);
                                workspace_CurrentCamera.CFrame = CFrame2:Lerp(u91, math_min_ret * math_min_ret * (3 - math_min_ret * 2));

                                if math_min_ret >= 1 then
                                    if u92 ~= nil then
                                        u92();
                                    end;

                                    return;
                                end;

                                task.wait();
                            end;
                        end);
                    end;
                end;

                script_DialogueUtility.Close();

                return;
            end;

            u86 = os.clock() + (tonumber(u21.MinShowTime) or 0);

            if u21.NotSkipable or u21.NoInput then
                u27:Reset();
            else
                if u86 > os.clock() then
                    u27:Reset();
                end;

                tryEnableClick(math_random_ret);
            end;

            applyNodeCamera(u21);
            applyNodeIcon(u21);

            if u6(u21.OnShow) == "function" then
                task.spawn(u21.OnShow, u16, Dialogue.Storage);
            end;

            u83 = u21;
            u59 = p89;
            local v95;

            if type(u21.Content) == "function" then
                v95 = u21.Content;
            else
                v95 = nil;
            end;

            if v95 ~= u37 then
                local ContinueContent = u21.ContinueContent;
                local v96;

                if type(ContinueContent) == "function" then
                    v96 = ContinueContent(u59, u16, Dialogue.Storage) == true;
                else
                    v96 = ContinueContent == true;
                end;

                if not v96 then
                    u37 = v95;

                    if u36 ~= nil then
                        u36:Destroy();
                        u36 = nil;
                    end;

                    if v95 ~= nil then
                        u36 = u24:Extend();
                        v95(u36, u43.Instance, u16, Dialogue.Storage);
                    end;
                end;
            end;

            local u97;

            if type(u21.Text) == "function" then
                u97 = u21.Text(u16, Dialogue.Storage);
            else
                u97 = u21.Text;
            end;

            u24:Spawn(function() -- Line: 600
                -- upvalues: u26 (ref), u29 (ref), u25 (ref), gameSettings (ref), u13 (ref), textplus (ref), u97 (copy), u30 (ref), u31 (ref), u21 (ref), u27 (ref), u28 (ref), u86 (ref), u85 (ref), math_random_ret (copy), tryEnableClick (ref), u6 (ref), script_DialogueUtility (ref), u16 (ref)
                u26:Reset();
                local Children = u29:GetChildren();

                for i = 1, #Children do
                    Children[i]:Destroy();
                    local _ = i;
                end;

                u25 = true;
                local table_clone_ret = table.clone(gameSettings.DialogueTextSettings);

                if u13 and table_clone_ret.MobileScale ~= nil then
                    table_clone_ret.Scale = table_clone_ret.MobileScale;
                end;

                table_clone_ret.MobileScale = nil;
                table_clone_ret.Overfill = true;
                local Y = u29.AbsoluteSize.Y;

                if Y > 0 then
                    for i = 1, 6 do
                        if textplus.new(u97, table_clone_ret):GetContentSize(u29).Y <= Y * 0.98 then
                            break;
                        end;

                        table_clone_ret.Scale = table_clone_ret.Scale * 0.92;
                        local _ = i;
                    end;
                end;

                local v98, v99 = textplus.new(u97, table_clone_ret):Play(u29);
                u30 = v98;
                u31 = v99;
                u30:Wait();
                u30 = nil;
                u25 = false;
                local Answers = u21.Answers;

                if typeof(Answers) == "table" then
                    u27:Reset();
                    u28 = 0;
                    local v100 = u86 - os.clock();

                    if v100 > 0 then
                        task.delay(v100, function() -- Line: 654
                            -- upvalues: u85 (ref), math_random_ret (ref), u26 (ref), Answers (copy)
                            if u85 == math_random_ret then
                                u26:Set(Answers);
                            end;
                        end);
                    else
                        u26:Set(Answers);
                    end;
                elseif Answers == true then
                    if u21.NoInput then
                        u27:Reset();
                    else
                        tryEnableClick(math_random_ret);
                    end;
                else
                    u27:Reset();

                    if u6(Answers) == "number" then
                        if Answers ~= (1 / 0) then
                            task.delay(Answers, function() -- Line: 677
                                -- upvalues: u85 (ref), math_random_ret (ref), script_DialogueUtility (ref)
                                if u85 == math_random_ret then
                                    script_DialogueUtility.Close();
                                end;
                            end);
                        end;
                    else
                        script_DialogueUtility.Close();
                    end;
                end;

                if u6(u21.AutoNext) == "number" then
                    task.delay(u21.AutoNext, function() -- Line: 693
                        -- upvalues: u85 (ref), math_random_ret (ref), u21 (ref), script_DialogueUtility (ref), u16 (ref)
                        if u85 ~= math_random_ret then
                            return;
                        end;

                        if u21.IfTrue then
                            script_DialogueUtility.DoAll(u21.IfTrue, u16);

                            return;
                        end;

                        script_DialogueUtility.Close();
                    end);
                end;
            end);
        end;

        PerformDialogue(v22);
        u24:Connect(Dialogue.AttemptDialogue, function(p101) -- Line: 706
            -- upvalues: PerformDialogue (copy)
            PerformDialogue(p101);
        end);
        local u102 = nil;

        if u23 ~= nil and (u19 ~= nil and u17 ~= nil) then
            if not u18:IsA("BasePart") then
                u18 = u18.PrimaryPart;
            end;

            local v103 = u18:IsA("Model") and u18:GetAttribute("IdleNpc") == true;
            local v104 = v103 or u18:GetAttribute("NoDialogueTurn") == true;
            local Attribute = u18:GetAttribute("DefaultCF");

            if not (v104 or (Attribute ~= nil or u18 == nil)) then
                Attribute = u18.CFrame;
                u18:SetAttribute("DefaultCF", Attribute);
            end;

            local Humanoid = u18:FindFirstChild("Humanoid");

            if Humanoid ~= nil then
                if u18:GetAttribute("NoDialogueAnim") ~= true then
                    u102 = Humanoid.Animator:LoadAnimation(script.NpcYaps:FindFirstChild("Anim" .. math.random(1, 3)));
                    u102:Play();
                end;

                if not (v104 or (u18 == nil or Attribute == nil)) then
                    local Position = u19.Position;
                    TweenService:Create(u18, TweenInfo_new_ret, {
                        CFrame = CFrame.new(Attribute.Position, (vector.create(Position.X, Attribute.Position.Y, Position.Z)))
                    }):Play();
                end;
            end;

            task.spawn(function() -- Line: 741
                -- upvalues: u24 (copy), u19 (ref), u23 (copy), u17 (ref), script_DialogueUtility (ref)
                while u24.IsActive and u19 ~= nil do
                    if u17 < vector.magnitude(u19.Position - u23) then
                        script_DialogueUtility.Close();
                    end;

                    task.wait(0.2);
                end;
            end);
        end;

        return function() -- Line: 751
            -- upvalues: u85 (ref), SignalEvent (ref), u83 (ref), u6 (ref), u16 (copy), Dialogue (ref), u63 (ref), u64 (ref), Camera_Traffic_Handler (ref), u65 (ref), u102 (ref), u18 (ref), TweenService (ref), TweenInfo_new_ret (ref), u27 (copy), u24 (copy)
            u85 = nil;
            SignalEvent.ToServer("NpcTalking", "Ended");
            local v105 = u83;
            u83 = nil;

            if v105 ~= nil and u6(v105.OnHidden) == "function" then
                task.spawn(v105.OnHidden, u16, Dialogue.Storage);
            end;

            if u63 then
                u63 = false;
                local u106 = u64;
                u64 = nil;

                if u106 == nil then
                    Camera_Traffic_Handler.Dialogue = false;
                else
                    local function u107() -- Line: 492
                        -- upvalues: Camera_Traffic_Handler (ref)
                        Camera_Traffic_Handler.Dialogue = false;
                    end;

                    u65 = u65 + 1;
                    local u108 = u65;
                    local workspace_CurrentCamera = workspace.CurrentCamera;
                    local CFrame2 = workspace_CurrentCamera.CFrame;
                    local os_clock_ret = os.clock();
                    task.spawn(function() -- Line: 473
                        -- upvalues: u65 (ref), u108 (copy), Camera_Traffic_Handler (ref), os_clock_ret (copy), workspace_CurrentCamera (copy), CFrame2 (copy), u106 (copy), u107 (copy)
                        while u65 == u108 do
                            if Camera_Traffic_Handler.Equipped_Hirearchy ~= "Dialogue" then
                                return;
                            end;

                            local v109 = (os.clock() - os_clock_ret) / 0.5;
                            local math_min_ret = math.min(v109, 1);
                            workspace_CurrentCamera.CFrame = CFrame2:Lerp(u106, math_min_ret * math_min_ret * (3 - math_min_ret * 2));

                            if math_min_ret >= 1 then
                                if u107 ~= nil then
                                    u107();
                                end;

                                return;
                            end;

                            task.wait();
                        end;
                    end);
                end;
            end;

            if u102 ~= nil then
                u102:Stop(0.5);
            end;

            if u18 ~= nil and (u18:IsA("Model") and (u18:FindFirstChild("Humanoid") ~= nil and (u18:GetAttribute("IdleNpc") ~= true and u18:GetAttribute("NoDialogueTurn") ~= true))) then
                local PrimaryPart = u18.PrimaryPart;

                if PrimaryPart ~= nil then
                    local Attribute = u18:GetAttribute("DefaultCF");

                    if Attribute ~= nil then
                        TweenService:Create(PrimaryPart, TweenInfo_new_ret, {
                            CFrame = Attribute
                        }):Play();
                    end;
                end;
            end;

            u27:Reset();
            u24:Destroy();
        end;
    end;
end;