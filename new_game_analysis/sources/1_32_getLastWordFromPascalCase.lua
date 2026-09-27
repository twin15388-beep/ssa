-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 12
    return p1:sub(#p1 - ((p1:reverse():find("%u") or #p1 + 1) - 1)):gsub("%d+$", "");
end;