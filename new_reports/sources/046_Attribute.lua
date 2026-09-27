-- Decompiled with Potassium's decompiler.

task.defer(function() -- Line: 21
    local RunService = game:GetService("RunService");
    local VERSION = require(script.Parent.VERSION);
    local AppVersion = VERSION.getAppVersion();
    local LatestVersion = VERSION.getLatestVersion();
    local v1 = not VERSION.isUpToDate();

    if not RunService:IsStudio() then
        print((`🍍 Running TopbarPlus {AppVersion} by @ForeverHD & HD Admin`));
    end;

    if v1 then
        warn((`A new version of TopbarPlus ({LatestVersion}) is available: https://devforum.roblox.com/t/topbarplus/1017485`));
    end;
end);

return {};