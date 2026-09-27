-- Decompiled with Potassium's decompiler.

local u1 = {
    appVersion = "v3.4.0",
    latestVersion = nil
};

function u1.getLatestVersion() -- Line: 14
    -- upvalues: u1 (copy)
    local latestVersion = u1.latestVersion;

    if latestVersion then
        return latestVersion;
    end;

    local v2;

    while true do
        local v3;
        v3, v2 = pcall(function() -- Line: 22
            return game:GetService("MarketplaceService"):GetProductInfo(117501901079852);
        end);

        if v3 and v2 then
            break;
        end;

        task.wait(1);
    end;

    local string_match_ret = string.match(v2.Name, "^TopbarPlus (.*)$");

    if string_match_ret then
        string_match_ret = string_match_ret:gsub("%s+", "");
    end;

    u1.latestVersion = string_match_ret;

    return string_match_ret;
end;

function u1.getAppVersion() -- Line: 39
    -- upvalues: u1 (copy)
    return u1.appVersion;
end;

function u1.isUpToDate() -- Line: 43
    -- upvalues: u1 (copy)
    local LatestVersion = u1.getLatestVersion();
    local AppVersion = u1.getAppVersion();
    local v4;

    if LatestVersion == nil then
        v4 = false;
    else
        v4 = LatestVersion == AppVersion;
    end;

    return v4;
end;

return u1;