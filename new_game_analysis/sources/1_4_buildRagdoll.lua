-- Decompiled with Potassium's decompiler.

local buildConstraints = require(script:WaitForChild("buildConstraints"));
local buildCollisionFilters = require(script:WaitForChild("buildCollisionFilters"));

function buildAttachmentMap(p1)
    local v2 = {};

    for _, child in pairs(p1:GetChildren()) do
        if child:IsA("BasePart") then
            for _, child2 in pairs(child:GetChildren()) do
                if child2:IsA("Attachment") then
                    local v3 = child2.Name:match("^(.+)RigAttachment$");
                    local v4;

                    if v3 then
                        v4 = child2.Parent:FindFirstChild(v3) or nil;
                    else
                        v4 = nil;
                    end;

                    if v4 then
                        v2[child2.Name] = {
                            Joint = v4,
                            Attachment0 = v4.Part0[child2.Name],
                            Attachment1 = v4.Part1[child2.Name]
                        };
                    end;
                end;
            end;
        end;
    end;

    return v2;
end;

return function(p5) -- Line: 50
    -- upvalues: buildConstraints (copy), buildCollisionFilters (copy)
    local Parent = p5.Parent;
    p5.BreakJointsOnDeath = false;
    local HumanoidRootPart = Parent:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        HumanoidRootPart.CanCollide = false;
    end;

    local v6 = buildAttachmentMap(Parent);
    local v7 = buildConstraints(v6);
    buildCollisionFilters(v6, Parent.PrimaryPart).Parent = v7;
    v7.Parent = Parent;
    game:GetService("CollectionService"):AddTag(p5, "Ragdoll");
end;