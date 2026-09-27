-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 1
    local CollisionsData = p1.CollisionsData;
    local CollisionHits = p1.CollisionHits;
    table.clear(CollisionsData);
    table.clear(CollisionHits);

    for _, v in p3 do
        if v:GetCollisions(p2, p1.Radius, CollisionsData) then
            table.insert(CollisionHits, v:GetObject());
        end;
    end;

    for _, v in CollisionsData do
        p2 = v.ClosestPoint + v.Normal * p1.Radius;
    end;

    return p2;
end;