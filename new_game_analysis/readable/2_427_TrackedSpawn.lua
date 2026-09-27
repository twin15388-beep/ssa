-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarkerHandler = require(ReplicatedStorage.CAM.Client.Modules.MarkerHandler);
local Color3_fromRGB_ret = Color3.fromRGB(195, 140, 255);
local u1 = {};

local function anchorsFolder() -- Line: 28
    local TrackedSpawnAnchors = workspace:FindFirstChild("TrackedSpawnAnchors");

    if TrackedSpawnAnchors == nil then
        TrackedSpawnAnchors = Instance.new("Folder");
        TrackedSpawnAnchors.Name = "TrackedSpawnAnchors";
        TrackedSpawnAnchors.Parent = workspace;
    end;

    return TrackedSpawnAnchors;
end;

local function markerKey(p2: string) -- Line: 38
    return `Tracked_{p2}`;
end;

local function remove(p3: string) -- Line: 42
    -- upvalues: u1 (copy), MarkerHandler (copy)
    local v4 = u1[p3];

    if v4 == nil then
        return;
    end;

    u1[p3] = nil;
    MarkerHandler.removeMarker((`Tracked_{p3}`));
    v4:Destroy();
end;

local function add(p5: string, p6: table) -- Line: 50
    -- upvalues: u1 (copy), MarkerHandler (copy), Color3_fromRGB_ret (copy)
    local v7 = u1[p5];

    if v7 ~= nil then
        u1[p5] = nil;
        MarkerHandler.removeMarker((`Tracked_{p5}`));
        v7:Destroy();
    end;

    local Part = Instance.new("Part");
    Part.Name = `Tracked_{p5}`;
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Position = p6.Position;
    local TrackedSpawnAnchors = workspace:FindFirstChild("TrackedSpawnAnchors");

    if TrackedSpawnAnchors == nil then
        TrackedSpawnAnchors = Instance.new("Folder");
        TrackedSpawnAnchors.Name = "TrackedSpawnAnchors";
        TrackedSpawnAnchors.Parent = workspace;
    end;

    Part.Parent = TrackedSpawnAnchors;
    u1[p5] = Part;
    MarkerHandler.addMarker(`Tracked_{p5}`, {
        tag = "Default",
        displayDistance = true,
        minDistance = 20,
        margin = 10,
        indicator = true,
        onMap = true,
        kind = "TrackedSpawn",
        markerType = MarkerHandler.markerType.Regular,
        img = p6.Icon,
        position = Part,
        indicatorColor = Color3_fromRGB_ret,
        ping = Color3_fromRGB_ret
    });
end;

return function(p8: string, p9: string, p10: any) -- Line: 81
    -- upvalues: add (copy), u1 (copy), MarkerHandler (copy)
    if p9 == nil then
        return;
    end;

    if p8 == "Add" and (p10 ~= nil and p10.Position ~= nil) then
        add(p9, p10);

        return;
    end;

    if p8 == "Move" and typeof(p10) == "Vector3" then
        local v11 = u1[p9];

        if v11 ~= nil then
            v11.Position = p10;
        end;
    elseif p8 == "Remove" then
        local v12 = u1[p9];

        if v12 == nil then
            return;
        end;

        u1[p9] = nil;
        MarkerHandler.removeMarker((`Tracked_{p9}`));
        v12:Destroy();
    end;
end;