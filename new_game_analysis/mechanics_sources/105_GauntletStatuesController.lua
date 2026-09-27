-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local TweenService = game:GetService("TweenService");
local u1 = {
    Weapon = Color3.fromRGB(80, 255, 110),
    Power = Color3.fromRGB(190, 90, 255),
    Fighting = Color3.fromRGB(255, 60, 60)
};
local u2 = {};
local u3 = {};
local u4 = {};
local v5 = {};

local function show(p6: userdata) -- Line: 24
    -- upvalues: u2 (copy), u3 (copy), TweenService (copy), u1 (copy)
    local Attribute = p6:GetAttribute("type");
    local v7 = u2[Attribute];
    local Eyes = p6:FindFirstChild("Eyes");

    if v7 == nil or (Eyes == nil or not Eyes:IsA("BasePart")) then
        return;
    end;

    if u3[Eyes] == nil then
        u3[Eyes] = Eyes.Color;
    end;

    TweenService:Create(Eyes, TweenInfo.new(0.4), {
        Color = u3[Eyes]:Lerp(u1[Attribute], v7)
    }):Play();

    if v7 >= 1 then
        Eyes.Material = Enum.Material.Neon;
    end;
end;

function v5.handle(p8: table) -- Line: 44
    -- upvalues: u2 (copy), CollectionService (copy), u4 (copy), show (copy)
    u2[p8.Type] = p8.Ratio;

    for _, v in CollectionService:GetTagged("GauntletStatue") do
        if v:GetAttribute("type") == p8.Type then
            if not u4[v] then
                u4[v] = true;
                v.ChildAdded:Connect(function(p9) -- Line: 38
                    -- upvalues: show (ref), v (copy)
                    if p9.Name == "Eyes" then
                        show(v);
                    end;
                end);
                show(v);
            end;
        end;
    end;
end;

function v5.Done() -- Line: 51
    -- upvalues: u1 (copy), u2 (copy)
    for i in u1 do
        if (u2[i] or 0) < 1 then
            return false;
        end;
    end;

    return true;
end;

local function track(u10: userdata) -- Line: 35
    -- upvalues: u4 (copy), show (copy)
    if u4[u10] then
        return;
    end;

    u4[u10] = true;
    u10.ChildAdded:Connect(function(p11) -- Line: 38
        -- upvalues: show (ref), u10 (copy)
        if p11.Name == "Eyes" then
            show(u10);
        end;
    end);
    show(u10);
end;

for _, v in CollectionService:GetTagged("GauntletStatue") do
    if not u4[v] then
        u4[v] = true;
        v.ChildAdded:Connect(function(p12) -- Line: 38
            -- upvalues: show (copy), v (copy)
            if p12.Name == "Eyes" then
                show(v);
            end;
        end);
        show(v);
    end;
end;

CollectionService:GetInstanceAddedSignal("GauntletStatue"):Connect(track);
CollectionService:GetInstanceRemovedSignal("GauntletStatue"):Connect(function(p13) -- Line: 62
    -- upvalues: u4 (copy)
    u4[p13] = nil;
end);

return v5;