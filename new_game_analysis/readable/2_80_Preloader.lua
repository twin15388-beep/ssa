-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ContentProvider = game:GetService("ContentProvider");
local v1 = {};
local v2 = {};
local u3 = {
    Current = 0,
    Max = 0
};

for _, v in ipairs({ "anims_preload_tag_priority", "anims_preload_tag" }) do
    for _, v3 in ipairs(CollectionService:GetTagged(v)) do
        if v3:IsA("Animation") and (v3.AnimationId ~= "" and not v1[v3]) then
            v1[v3] = true;
            table.insert(v2, v3);
        end;
    end;
end;

u3.Max = #v2;

for i = 1, #v2, 25 do
    local _ = i;
    local u4 = {};

    for i2 = i, math.min(i + 24, #v2) do
        table.insert(u4, v2[i2]);
        local _ = i2;
    end;

    local success, result = pcall(function() -- Line: 30
        -- upvalues: ContentProvider (copy), u4 (copy), u3 (copy)
        ContentProvider:PreloadAsync(u4, function() -- Line: 31
            -- upvalues: u3 (ref)
            local v5 = u3;
            v5.Current = v5.Current + 1;
        end);
    end);

    if not success then
        warn("Preload batch failed:", result);
    end;

    task.wait(0.1);
end;