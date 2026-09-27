-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local interfaceutility = require(ReplicatedStorage.Packages.interfaceutility);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);

return function(p1: userdata, p2: userdata, p3: userdata, p4: userdata) -- Line: 29
    -- upvalues: Players (copy), faye (copy), Platform_Handler (copy), BunchaIcons (copy), interfaceutility (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p2);

    if PlayerFromCharacter ~= nil then
        local u5 = faye.new();

        local function listless() -- Line: 36
            -- upvalues: Platform_Handler (ref)
            return Platform_Handler.IsGamepad() or Platform_Handler.Platform.Value == "Mobile";
        end;

        local u6 = u5:Value(Platform_Handler.IsGamepad() or Platform_Handler.Platform.Value == "Mobile");
        u5:Connect(Platform_Handler.Platform.Changed.Event, function() -- Line: 40
            -- upvalues: u6 (copy), Platform_Handler (ref)
            u6:Set(Platform_Handler.IsGamepad() or Platform_Handler.Platform.Value == "Mobile");
        end);
        local u7 = u5:Value("");

        local function follow(u8: userdata) -- Line: 46
            -- upvalues: u7 (copy), u5 (copy)
            if not u8:IsA("IntValue") then
                return;
            end;

            local function read() -- Line: 48
                -- upvalues: u7 (ref), u8 (copy)
                u7:Set((tostring(u8.Value)));
            end;

            u7:Set((tostring(u8.Value)));
            u5:Connect(u8.Changed, read);
        end;

        local function hookFolder(p9: userdata) -- Line: 54
            -- upvalues: u7 (copy), u5 (copy)
            local Reputation = p9:FindFirstChild("Reputation");

            if Reputation == nil then
                u5:Connect(p9.ChildAdded, function(u10: userdata) -- Line: 60
                    -- upvalues: u7 (ref), u5 (ref)
                    if u10.Name == "Reputation" then
                        if not u10:IsA("IntValue") then
                            return;
                        end;

                        local function v11() -- Line: 48
                            -- upvalues: u7 (ref), u10 (copy)
                            u7:Set((tostring(u10.Value)));
                        end;

                        u7:Set((tostring(u10.Value)));
                        u5:Connect(u10.Changed, v11);
                    end;
                end);

                return;
            end;

            if not Reputation:IsA("IntValue") then
                return;
            end;

            local function v12() -- Line: 48
                -- upvalues: u7 (ref), Reputation (copy)
                u7:Set((tostring(Reputation.Value)));
            end;

            u7:Set((tostring(Reputation.Value)));
            u5:Connect(Reputation.Changed, v12);
        end;

        local leaderstats = PlayerFromCharacter:FindFirstChild("leaderstats");

        if leaderstats == nil then
            u5:Connect(PlayerFromCharacter.ChildAdded, function(p13: userdata) -- Line: 68
                -- upvalues: u7 (copy), u5 (copy)
                if p13.Name == "leaderstats" then
                    local Reputation = p13:FindFirstChild("Reputation");

                    if Reputation ~= nil then
                        if not Reputation:IsA("IntValue") then
                            return;
                        end;

                        local function v14() -- Line: 48
                            -- upvalues: u7 (ref), Reputation (copy)
                            u7:Set((tostring(Reputation.Value)));
                        end;

                        u7:Set((tostring(Reputation.Value)));
                        u5:Connect(Reputation.Changed, v14);

                        return;
                    end;

                    u5:Connect(p13.ChildAdded, function(u15: userdata) -- Line: 60
                        -- upvalues: u7 (ref), u5 (ref)
                        if u15.Name == "Reputation" then
                            if not u15:IsA("IntValue") then
                                return;
                            end;

                            local function v16() -- Line: 48
                                -- upvalues: u7 (ref), u15 (copy)
                                u7:Set((tostring(u15.Value)));
                            end;

                            u7:Set((tostring(u15.Value)));
                            u5:Connect(u15.Changed, v16);
                        end;
                    end);
                end;
            end);
        else
            local Reputation = leaderstats:FindFirstChild("Reputation");

            if Reputation == nil then
                u5:Connect(leaderstats.ChildAdded, function(u17: userdata) -- Line: 60
                    -- upvalues: u7 (copy), u5 (copy)
                    if u17.Name == "Reputation" then
                        if not u17:IsA("IntValue") then
                            return;
                        end;

                        local function v18() -- Line: 48
                            -- upvalues: u7 (ref), u17 (copy)
                            u7:Set((tostring(u17.Value)));
                        end;

                        u7:Set((tostring(u17.Value)));
                        u5:Connect(u17.Changed, v18);
                    end;
                end);
            elseif Reputation:IsA("IntValue") then
                u7:Set((tostring(Reputation.Value)));
                u5:Connect(Reputation.Changed, function() -- Line: 48, Name: read
                    -- upvalues: u7 (copy), Reputation (copy)
                    u7:Set((tostring(Reputation.Value)));
                end);
            end;
        end;

        u5:Create("Frame")({
            Name = "IReputation",
            Parent = p1,
            Size = UDim2.fromScale(1, 0.25),
            BackgroundTransparency = 1,
            Visible = u5:Do(function(p19) -- Line: 83
                -- upvalues: u6 (copy), u7 (copy)
                local v20;

                if p19(u6) == true then
                    v20 = p19(u7) ~= "";
                else
                    v20 = false;
                end;

                return v20;
            end),
            u5:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.Name,
                Padding = UDim.new(0.02, 0)
            }),
            u5:Create("ImageLabel")({
                Name = "AIcon",
                Size = UDim2.fromScale(0, 1),
                BackgroundTransparency = 1,
                Image = BunchaIcons.Reputation,
                u5:Create("UIAspectRatioConstraint")({
                    AspectRatio = 1,
                    AspectType = Enum.AspectType.ScaleWithParentSize,
                    DominantAxis = Enum.DominantAxis.Height
                })
            }),
            u5:Create("TextLabel")({
                Name = "Value",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = u7,
                TextColor3 = Color3.new(1, 1, 1),
                TextScaled = true,
                FontFace = Font.fromEnum(Enum.Font.SourceSansSemibold),
                u5:Create("UIStroke")({
                    Thickness = 1.5,
                    Transparency = 0.75
                }),

                After = function(u21: userdata) -- Line: 120, Name: After
                    -- upvalues: interfaceutility (ref), u5 (copy)
                    local function fit() -- Line: 122
                        -- upvalues: u21 (copy), interfaceutility (ref)
                        if u21.Text == "" then
                            return;
                        end;

                        u21.Size = UDim2.fromScale(interfaceutility.GetScaledTextSize(u21), 1);
                    end;

                    if u21.Text ~= "" then
                        u21.Size = UDim2.fromScale(interfaceutility.GetScaledTextSize(u21), 1);
                    end;

                    u5:Connect(u21:GetPropertyChangedSignal("Text"), fit);
                end
            })
        });

        return function() -- Line: 131
            -- upvalues: u5 (copy)
            u5:Destroy();
        end;
    end;
end;