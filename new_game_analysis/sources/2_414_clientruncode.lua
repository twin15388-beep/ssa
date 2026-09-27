-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, false, 0.2);
local TweenInfo_new_ret2 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, false, 0.2);
local Folder = Instance.new("Folder");
Folder.Name = "marker3DFolder";
Folder.Parent = workspace;
local LocalPlayer = game.Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local MarkerHandler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("MarkerHandler"));
local RunService = game:GetService("RunService");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.ResetOnSpawn = false;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.DisplayOrder = 1;
ScreenGui.Name = "markergui";
ScreenGui.Parent = PlayerGui;
ScreenGui.ScreenInsets = Enum.ScreenInsets.None;
local workspace_CurrentCamera = workspace.CurrentCamera;

local function getCompass() -- Line: 32
    -- upvalues: PlayerGui (copy)
    local ComponentsHolder = PlayerGui:FindFirstChild("ComponentsHolder");

    if ComponentsHolder then
        return ComponentsHolder:FindFirstChild("Compass");
    end;

    return nil;
end;

local function getPlayerPosition() -- Line: 38
    -- upvalues: LocalPlayer (copy), workspace_CurrentCamera (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    return Character and Character.Position or workspace_CurrentCamera.CFrame.Position;
end;

local function fullName_toAddress(p1) -- Line: 44
    local string_split_ret = string.split(p1, ".");
    local v2 = game;
    local table_find_ret = table.find(string_split_ret, "game");

    if table_find_ret then
        table.remove(string_split_ret, table_find_ret);
    end;

    for i = 1, #string_split_ret do
        v2 = v2:FindFirstChild(string_split_ret[i]);

        if v2 == nil then
            return;
        end;

        local _ = i;
    end;

    return v2;
end;

local function extractPosition(p3) -- Line: 59
    -- upvalues: fullName_toAddress (copy)
    if typeof(p3) == "Instance" then
        return p3.Position;
    end;

    if typeof(p3) ~= "string" then
        return p3;
    end;

    local v4 = fullName_toAddress(p3);

    if v4 then
        v4 = v4.Position;
    end;

    return v4;
end;

local function transparency(p5, p6, p7, p8, p9) -- Line: 70
    -- upvalues: MarkerHandler (copy)
    local v10 = p6.margin or 10;
    local v11 = not p6.maxDistance and 0 or math.clamp(p7 - p6.maxDistance - v10, 0, v10) / v10;
    local v12 = not p6.minDistance and 0 or 1 - math.clamp(p7 - p6.minDistance - v10, 0, v10) / v10;
    local math_max_ret = math.max(v12, v11);

    if p6.currenttransparencyvalue ~= math_max_ret then
        p6.currenttransparencyvalue = math_max_ret;
        MarkerHandler.Styles[p8].applyOpacity(p5, math_max_ret, p9);
    end;
end;

local u13 = {};

local function claim(p14: string, p15: userdata?, p16: userdata) -- Line: 97
    local v17 = p16:FindFirstChild(p14);

    if p15 == nil then
        return v17;
    end;

    if v17 ~= nil then
        p15:Destroy();

        return v17;
    end;

    p15.Name = p14;
    p15.Parent = p16;

    return p15;
end;

local function mainLoop(p18) -- Line: 110
    -- upvalues: workspace_CurrentCamera (copy), MarkerHandler (copy), fullName_toAddress (copy), ScreenGui (copy), u13 (copy), LocalPlayer (copy), TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), PlayerGui (copy), transparency (copy), Folder (copy)
    local Y = game.GuiService:GetGuiInset().Y;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    for i, v in pairs(MarkerHandler.currentMarkers) do
        if not (MarkerHandler.allDisabled or MarkerHandler.disabledTags[v.tag]) then
            local position = v.position;

            if typeof(position) == "Instance" then
                position = position.Position;
            elseif typeof(position) == "string" then
                position = fullName_toAddress(position);

                if position then
                    position = position.Position;
                end;
            end;

            local v19 = (position or Vector3.new(0, 0, 0)) + (v.offset or Vector3.new(0, 0, 0));

            if v.markerType == MarkerHandler.markerType.Regular then
                local v20 = ScreenGui:FindFirstChild(i);
                local v21 = v.style or "Default";
                local v22 = MarkerHandler.Styles[v21];
                local v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, v60, v61, v62, v63, v64, v65, v66;

                if v20 == nil then
                    if not u13[i] then
                        u13[i] = true;
                        v20 = v22.createInterface(v, i);
                        u13[i] = nil;
                        local v67 = ScreenGui;
                        local v68 = v67:FindFirstChild(i);

                        if v20 == nil then
                            v20 = v68;
                        elseif v68 == nil then
                            v20.Name = i;
                            v20.Parent = v67;
                        else
                            v20:Destroy();
                            v20 = v68;
                        end;

                        if v20 ~= nil then
                            if v.displayDistance or (v.minDistance or v.maxDistance) then
                                v23 = LocalPlayer.Character;

                                if v23 then
                                    v23 = v23:FindFirstChild("HumanoidRootPart");
                                end;

                                v24 = math.floor((v19 - (v23 and v23.Position or workspace_CurrentCamera.CFrame.Position)).Magnitude);
                            else
                                v24 = 0;
                            end;

                            if v.displayDistance then
                                v20.dist.Text = v24 .. "m";
                            end;

                            v25 = v.indicator or (v.count or 1) > 1;
                            v26 = v20:GetAttribute("hasCountLabel") == true;

                            if v25 and not v26 then
                                v27 = Instance.new("Frame");
                                v27.Name = "countlabel";
                                v27.ZIndex = -10;
                                v27.Size = UDim2.fromScale(1, 1);
                                v27.BorderSizePixel = 0;
                                v27.BackgroundTransparency = 1;
                                v27.Parent = v20;
                                v28 = Instance.new("ImageLabel");
                                v28.BackgroundTransparency = 1;
                                v28.Parent = v27;
                                v28.Size = UDim2.fromScale(0.7, 0.7);
                                v28.AnchorPoint = Vector2.new(0.5, 0.5);
                                v28.Position = UDim2.fromScale(0.5, 0.5);
                                v28.ImageTransparency = 0;
                                v28.ImageColor3 = v.indicatorColor or Color3.new(1, 0.2, 0.2);
                                v28.Image = "rbxassetid://17359135613";
                                TweenService:Create(v28, TweenInfo_new_ret, {
                                    Size = UDim2.fromScale(1, 1)
                                }):Play();
                                TweenService:Create(v28, TweenInfo_new_ret2, {
                                    ImageTransparency = 1
                                }):Play();
                                v20:SetAttribute("hasCountLabel", true);
                            elseif not v25 and v26 then
                                v29 = v20:FindFirstChild("countlabel");

                                if v29 then
                                    v29:Destroy();
                                end;

                                v20:SetAttribute("hasCountLabel", false);
                            end;

                            v30, v31 = workspace_CurrentCamera:WorldToScreenPoint(v19);
                            v32 = v20.AbsoluteSize.X;
                            v33 = ViewportSize.X - v32;
                            v34 = ViewportSize.Y - v32;
                            v35 = v30 + Vector3.new(0, Y, 0);
                            v36 = v35.X;
                            v37 = math.max(v32, v33);
                            v38 = math.clamp(v36, 0, v37);
                            v39 = v35.Y;
                            v40 = math.max(v32, v34);
                            v41 = math.clamp(v39, 0, v40);
                            v42 = (v38 ~= v35.X or v41 ~= v35.Y) and true or v31 == false;

                            if v.offScreenMode == MarkerHandler.offScreenMode.Compass and v42 then
                                v43 = PlayerGui:FindFirstChild("ComponentsHolder");

                                if v43 then
                                    v44 = v43:FindFirstChild("Compass");
                                else
                                    v44 = nil;
                                end;

                                v45 = v44 or nil;
                            else
                                v45 = nil;
                            end;

                            v46 = v19 - CFrame2.Position;
                            v47 = CFrame2:VectorToObjectSpace(v46);

                            if v45 then
                                v48 = v45.AbsolutePosition;
                                v49 = v45.AbsoluteSize;
                                v50 = CFrame2.LookVector;
                                v51 = Vector2.new(v50.X, v50.Z).Unit;
                                v52 = Vector2.new(v46.X, v46.Z).Unit;
                                v53 = v51.X * v52.Y - v51.Y * v52.X;
                                v54 = v51:Dot(v52);
                                v55 = math.atan2(v53, v54);
                                v56 = math.deg(v55);
                                v57 = math.clamp(v48.X + v49.X / 2 + v56 * (v49.X / workspace_CurrentCamera.FieldOfView), v48.X, v48.X + v49.X);
                                v58 = 1 - math.exp(-15 * p18);

                                if v._compassX then
                                    v57 = v._compassX + (v57 - v._compassX) * v58 or v57;
                                end;

                                v._compassX = v57;
                                v38 = v._compassX;
                                v41 = v48.Y + v49.Y + Y + v49.Y * 0.5 + 4;

                                if v22.setPointer then
                                    v59 = Vector2.new(v47.X, v47.Y).Unit;
                                    v60 = v22.setPointer;
                                    v61 = math.atan2(v59.X, v59.Y);
                                    v60(v20, true, math.deg(v61) - 90);
                                end;
                            elseif v22.setPointer then
                                if v42 then
                                    v62 = Vector2.new(v47.X, v47.Y).Unit;
                                    v63 = math.atan2(v62.X, v62.Y);

                                    if math.abs(v62.Y * v33) > math.abs(v62.X * v34) then
                                        v64 = v62 * math.abs(v34 / 2 / v62.Y);
                                    else
                                        v64 = v62 * math.abs(v33 / 2 / v62.X);
                                    end;

                                    v38 = ViewportSize.X / 2 + v64.X;
                                    v41 = ViewportSize.Y / 2 - v64.Y;
                                    v22.setPointer(v20, true, math.deg(v63) - 90);
                                else
                                    v22.setPointer(v20, false, 0);
                                end;
                            end;

                            v65 = v45 ~= nil;

                            if v._inCompass ~= v65 and v._inCompass ~= nil then
                                v._lerpTimer = 0.25;
                            end;

                            v._inCompass = v65;

                            if v.maxDistance or v.minDistance then
                                transparency(v20, v, v24, v21);
                            end;

                            if v._lerpTimer and v._lerpTimer > 0 then
                                v._lerpTimer = v._lerpTimer - p18;
                                v66 = 1 - math.exp(-15 * p18);
                                v._posX = (v._posX or v38) + (v38 - (v._posX or v38)) * v66;
                                v._posY = (v._posY or v41) + (v41 - (v._posY or v41)) * v66;
                            else
                                v._posX = v38;
                                v._posY = v41;
                                v._lerpTimer = nil;
                            end;

                            v20.Position = UDim2.fromOffset(v._posX, v._posY);
                        end;
                    end;
                elseif v20 ~= nil then
                    if v.displayDistance or (v.minDistance or v.maxDistance) then
                        v23 = LocalPlayer.Character;

                        if v23 then
                            v23 = v23:FindFirstChild("HumanoidRootPart");
                        end;

                        v24 = math.floor((v19 - (v23 and v23.Position or workspace_CurrentCamera.CFrame.Position)).Magnitude);
                    else
                        v24 = 0;
                    end;

                    if v.displayDistance then
                        v20.dist.Text = v24 .. "m";
                    end;

                    v25 = v.indicator or (v.count or 1) > 1;
                    v26 = v20:GetAttribute("hasCountLabel") == true;

                    if v25 and not v26 then
                        v27 = Instance.new("Frame");
                        v27.Name = "countlabel";
                        v27.ZIndex = -10;
                        v27.Size = UDim2.fromScale(1, 1);
                        v27.BorderSizePixel = 0;
                        v27.BackgroundTransparency = 1;
                        v27.Parent = v20;
                        v28 = Instance.new("ImageLabel");
                        v28.BackgroundTransparency = 1;
                        v28.Parent = v27;
                        v28.Size = UDim2.fromScale(0.7, 0.7);
                        v28.AnchorPoint = Vector2.new(0.5, 0.5);
                        v28.Position = UDim2.fromScale(0.5, 0.5);
                        v28.ImageTransparency = 0;
                        v28.ImageColor3 = v.indicatorColor or Color3.new(1, 0.2, 0.2);
                        v28.Image = "rbxassetid://17359135613";
                        TweenService:Create(v28, TweenInfo_new_ret, {
                            Size = UDim2.fromScale(1, 1)
                        }):Play();
                        TweenService:Create(v28, TweenInfo_new_ret2, {
                            ImageTransparency = 1
                        }):Play();
                        v20:SetAttribute("hasCountLabel", true);
                    elseif not v25 and v26 then
                        v29 = v20:FindFirstChild("countlabel");

                        if v29 then
                            v29:Destroy();
                        end;

                        v20:SetAttribute("hasCountLabel", false);
                    end;

                    v30, v31 = workspace_CurrentCamera:WorldToScreenPoint(v19);
                    v32 = v20.AbsoluteSize.X;
                    v33 = ViewportSize.X - v32;
                    v34 = ViewportSize.Y - v32;
                    v35 = v30 + Vector3.new(0, Y, 0);
                    v36 = v35.X;
                    v37 = math.max(v32, v33);
                    v38 = math.clamp(v36, 0, v37);
                    v39 = v35.Y;
                    v40 = math.max(v32, v34);
                    v41 = math.clamp(v39, 0, v40);
                    v42 = (v38 ~= v35.X or v41 ~= v35.Y) and true or v31 == false;

                    if v.offScreenMode == MarkerHandler.offScreenMode.Compass and v42 then
                        v43 = PlayerGui:FindFirstChild("ComponentsHolder");

                        if v43 then
                            v44 = v43:FindFirstChild("Compass");
                        else
                            v44 = nil;
                        end;

                        v45 = v44 or nil;
                    else
                        v45 = nil;
                    end;

                    v46 = v19 - CFrame2.Position;
                    v47 = CFrame2:VectorToObjectSpace(v46);

                    if v45 then
                        v48 = v45.AbsolutePosition;
                        v49 = v45.AbsoluteSize;
                        v50 = CFrame2.LookVector;
                        v51 = Vector2.new(v50.X, v50.Z).Unit;
                        v52 = Vector2.new(v46.X, v46.Z).Unit;
                        v53 = v51.X * v52.Y - v51.Y * v52.X;
                        v54 = v51:Dot(v52);
                        v55 = math.atan2(v53, v54);
                        v56 = math.deg(v55);
                        v57 = math.clamp(v48.X + v49.X / 2 + v56 * (v49.X / workspace_CurrentCamera.FieldOfView), v48.X, v48.X + v49.X);
                        v58 = 1 - math.exp(-15 * p18);

                        if v._compassX then
                            v57 = v._compassX + (v57 - v._compassX) * v58 or v57;
                        end;

                        v._compassX = v57;
                        v38 = v._compassX;
                        v41 = v48.Y + v49.Y + Y + v49.Y * 0.5 + 4;

                        if v22.setPointer then
                            v59 = Vector2.new(v47.X, v47.Y).Unit;
                            v60 = v22.setPointer;
                            v61 = math.atan2(v59.X, v59.Y);
                            v60(v20, true, math.deg(v61) - 90);
                        end;
                    elseif v22.setPointer then
                        if v42 then
                            v62 = Vector2.new(v47.X, v47.Y).Unit;
                            v63 = math.atan2(v62.X, v62.Y);

                            if math.abs(v62.Y * v33) > math.abs(v62.X * v34) then
                                v64 = v62 * math.abs(v34 / 2 / v62.Y);
                            else
                                v64 = v62 * math.abs(v33 / 2 / v62.X);
                            end;

                            v38 = ViewportSize.X / 2 + v64.X;
                            v41 = ViewportSize.Y / 2 - v64.Y;
                            v22.setPointer(v20, true, math.deg(v63) - 90);
                        else
                            v22.setPointer(v20, false, 0);
                        end;
                    end;

                    v65 = v45 ~= nil;

                    if v._inCompass ~= v65 and v._inCompass ~= nil then
                        v._lerpTimer = 0.25;
                    end;

                    v._inCompass = v65;

                    if v.maxDistance or v.minDistance then
                        transparency(v20, v, v24, v21);
                    end;

                    if v._lerpTimer and v._lerpTimer > 0 then
                        v._lerpTimer = v._lerpTimer - p18;
                        v66 = 1 - math.exp(-15 * p18);
                        v._posX = (v._posX or v38) + (v38 - (v._posX or v38)) * v66;
                        v._posY = (v._posY or v41) + (v41 - (v._posY or v41)) * v66;
                    else
                        v._posX = v38;
                        v._posY = v41;
                        v._lerpTimer = nil;
                    end;

                    v20.Position = UDim2.fromOffset(v._posX, v._posY);
                end;
            elseif v.markerType == MarkerHandler.markerType.PointerMarker then
                local v69 = ScreenGui:FindFirstChild(i);

                if v69 == nil and v.in3DSpace == true then
                    v69 = Folder:FindFirstChild(i);
                end;

                local v70, v71, v72, v73, v74, v75, v76, v77, v78, v79, v80, v81, v82, v83, v84, v85, v86, v87, v88, v89;

                if v69 == nil then
                    if not u13[i] then
                        v70 = v.style or "PointerMarkerDefault";
                        u13[i] = true;
                        v69 = MarkerHandler.Styles[v70].createInterface(v, i);
                        u13[i] = nil;
                        local v90 = v.in3DSpace == true and Folder or ScreenGui;
                        local v91 = v90:FindFirstChild(i);

                        if v69 == nil then
                            v69 = v91;
                        elseif v91 == nil then
                            v69.Name = i;
                            v69.Parent = v90;
                        else
                            v69:Destroy();
                            v69 = v91;
                        end;

                        if v69 ~= nil then
                            if v.in3DSpace then
                                v71 = LocalPlayer.Character;

                                if v71 then
                                    v72 = v71:FindFirstChild("HumanoidRootPart");
                                else
                                    v72 = v71;
                                end;

                                v73 = v72 and v72.Position or workspace_CurrentCamera.CFrame.Position;

                                if v72 then
                                    v74, v75 = v72.CFrame:ToOrientation();
                                else
                                    v75 = 0;
                                end;

                                v76, v77, v78 = CFrame.new(v73, v19):ToOrientation();

                                if v69:FindFirstChild("Weld") == nil and v72 then
                                    MarkerHandler.Styles[v70].createWeld(v72, v69, v71);
                                end;

                                v79 = v69.Weld;
                                v80 = CFrame.Angles;
                                v81 = math.deg(v75) - math.deg(v77) + 90;
                                v79.C1 = v80(0, math.rad(v81), 0);

                                if v.maxDistance or v.minDistance then
                                    transparency(v69, v, math.floor((v19 - v73).Magnitude), v70, v.in3DSpace);
                                end;
                            else
                                v82 = LocalPlayer.Character;

                                if v82 then
                                    v82 = v82:FindFirstChild("HumanoidRootPart");
                                end;

                                v83 = v82 and v82.Position or workspace_CurrentCamera.CFrame.Position;
                                v84, v85, v86 = CFrame2:ToOrientation();
                                v87, v88, v89 = CFrame.new(v83, v19):ToOrientation();
                                v69.Holder.Rotation = math.deg(v85) - math.deg(v88);

                                if v.maxDistance or v.minDistance then
                                    transparency(v69, v, math.floor((v19 - v83).Magnitude), v70);
                                end;
                            end;
                        end;
                    end;
                else
                    v70 = "PointerMarkerDefault";

                    if v69 ~= nil then
                        if v.in3DSpace then
                            v71 = LocalPlayer.Character;

                            if v71 then
                                v72 = v71:FindFirstChild("HumanoidRootPart");
                            else
                                v72 = v71;
                            end;

                            v73 = v72 and v72.Position or workspace_CurrentCamera.CFrame.Position;

                            if v72 then
                                v74, v75 = v72.CFrame:ToOrientation();
                            else
                                v75 = 0;
                            end;

                            v76, v77, v78 = CFrame.new(v73, v19):ToOrientation();

                            if v69:FindFirstChild("Weld") == nil and v72 then
                                MarkerHandler.Styles[v70].createWeld(v72, v69, v71);
                            end;

                            v79 = v69.Weld;
                            v80 = CFrame.Angles;
                            v81 = math.deg(v75) - math.deg(v77) + 90;
                            v79.C1 = v80(0, math.rad(v81), 0);

                            if v.maxDistance or v.minDistance then
                                transparency(v69, v, math.floor((v19 - v73).Magnitude), v70, v.in3DSpace);
                            end;
                        else
                            v82 = LocalPlayer.Character;

                            if v82 then
                                v82 = v82:FindFirstChild("HumanoidRootPart");
                            end;

                            v83 = v82 and v82.Position or workspace_CurrentCamera.CFrame.Position;
                            v84, v85, v86 = CFrame2:ToOrientation();
                            v87, v88, v89 = CFrame.new(v83, v19):ToOrientation();
                            v69.Holder.Rotation = math.deg(v85) - math.deg(v88);

                            if v.maxDistance or v.minDistance then
                                transparency(v69, v, math.floor((v19 - v83).Magnitude), v70);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local u92 = nil;

local function updv() -- Line: 325
    -- upvalues: MarkerHandler (copy), u92 (ref), RunService (copy), mainLoop (copy)
    local v93 = MarkerHandler.markerCount.value > 0;

    if v93 ~= u92 then
        if v93 == true then
            RunService:BindToRenderStep("markerbind", Enum.RenderPriority.Last.Value, mainLoop);
        else
            RunService:UnbindFromRenderStep("markerbind");
        end;

        u92 = v93;
    end;
end;

local v94 = MarkerHandler.markerCount.value > 0;

if v94 ~= u92 then
    if v94 == true then
        RunService:BindToRenderStep("markerbind", Enum.RenderPriority.Last.Value, mainLoop);
    else
        RunService:UnbindFromRenderStep("markerbind");
    end;

    u92 = v94;
end;

MarkerHandler.markerCount.Changed:Connect(updv);