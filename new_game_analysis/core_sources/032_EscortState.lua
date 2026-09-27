-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};

local function visibleToMe(p2: userdata) -- Line: 26
    -- upvalues: Players (copy)
    local Attribute = p2:GetAttribute("VisibleTo");

    if Attribute == nil then
        return true;
    end;

    if type(Attribute) ~= "string" then
        return false;
    end;

    local v3 = tostring(Players.LocalPlayer.UserId);

    for _, v in string.split(Attribute, ",") do
        if v == v3 then
            return true;
        end;
    end;

    return false;
end;

local function findRunFolder(p4: string) -- Line: 39
    -- upvalues: visibleToMe (copy)
    local Humanoids = workspace:FindFirstChild("Humanoids");

    if Humanoids == nil then
        return nil;
    end;

    for _, child in Humanoids:GetChildren() do
        if child.Name == `Escort - {p4}` then
            local EscortInfo = child:FindFirstChild("EscortInfo");

            if EscortInfo ~= nil and visibleToMe(EscortInfo) then
                local v5 = child:FindFirstChildOfClass("Model");

                if v5 ~= nil then
                    return child, v5;
                end;
            end;
        end;
    end;

    return nil;
end;

function v1.forQuest(u6: string) -- Line: 54
    -- upvalues: ReplicatedStorage (copy), findRunFolder (copy)
    return {
        Do = function(p7: userdata, p8: userdata, u9: any) -- Line: 56, Name: Do
            -- upvalues: ReplicatedStorage (ref), u6 (copy), findRunFolder (ref)
            local MarkerHandler = require(ReplicatedStorage.CAM.Client.Modules.MarkerHandler);
            local u10 = `EscortMarker-{u6}`;
            local u11 = true;
            u9:Add(function() -- Line: 60
                -- upvalues: u11 (ref), MarkerHandler (copy), u10 (copy)
                u11 = false;
                MarkerHandler.removeMarker(u10);
            end);
            task.spawn(function() -- Line: 65
                -- upvalues: u11 (ref), findRunFolder (ref), u6 (ref), MarkerHandler (copy), u10 (copy), u9 (copy)
                local v12 = nil;
                local v13 = nil;

                while u11 do
                    v12, v13 = findRunFolder(u6);

                    if v12 ~= nil then
                        break;
                    end;

                    task.wait(0.5);
                end;

                if not (u11 and (v12 ~= nil and v13 ~= nil)) then
                    return;
                end;

                local HumanoidRootPart = v13:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart == nil then
                    return;
                end;

                MarkerHandler.addMarker(u10, {
                    transparency = 0.25,
                    offset = Vector3.new(0, 3, 0),
                    minDistance = 8,
                    margin = 15,
                    markerType = MarkerHandler.markerType.Both,
                    offScreenMode = MarkerHandler.offScreenMode.Compass,
                    img = v12:GetAttribute("Icon"),
                    position = HumanoidRootPart
                });
                u9:Add(v12.Destroying:Connect(function() -- Line: 89
                    -- upvalues: MarkerHandler (ref), u10 (ref)
                    MarkerHandler.removeMarker(u10);
                end));
            end);
        end
    };
end;

return v1;