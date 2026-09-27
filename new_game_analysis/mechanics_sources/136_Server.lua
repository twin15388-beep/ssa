-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local FirstlightWagasa = require(ServerStorage.SAM.WorldEvents.FirstlightWagasa);
local TrainingStorage = require(ServerStorage.SAM.Utility.TrainingStorage);
local TrainingQuestCredit = require(ServerStorage.SAM.Utility.TrainingQuestCredit);
local TrainingResult = require(ServerStorage.SAM.Utility.TrainingResult);
local v1 = {};

local function setPushing(p2: table, p3: boolean) -- Line: 16
    -- upvalues: EffectsEvent (copy)
    if p2.Pushing == p3 then
        return;
    end;

    p2.Pushing = p3;
    local WeldedBoulder = p2.WeldedBoulder;

    if WeldedBoulder == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(WeldedBoulder, "BoulderPushEffect", WeldedBoulder, p3);
end;

function v1.Do(u4: userdata, p5: userdata, p6: table, u7: userdata, p8: userdata?) -- Line: 24
    -- upvalues: FirstlightWagasa (copy), EffectsEvent (copy), TrainingQuestCredit (copy), TrainingResult (copy), TrainingStorage (copy)
    p6.Boulder = p8.Parent;
    p6.Pushing = false;
    p6.Boulder.Transparency = 1;
    p6.Boulder.CanCollide = false;
    p6.WeldedBoulder = script.Boulder:Clone();
    p6.WeldedBoulder.Parent = workspace.Debree;
    p6.WeldedBoulder.Weld.Part0 = p5.HumanoidRootPart;
    local v9 = script.PS2trainingBOULDPUSHgrab:Clone();
    v9.Parent = p6.WeldedBoulder;
    v9:Play();
    local u10 = FirstlightWagasa.GoalFor(u4, p6.Boulder.Parent);
    local u11 = u10 or p6.Boulder.Parent:FindFirstChild("Goal");

    if u10 ~= nil then
        u7:SetAttribute("WagasaRoute", true);
    end;

    local v12 = u11 == nil and 0 or (u11:GetPivot().Position - p6.Boulder.Position).Magnitude;
    u7:SetAttribute("LeashCenter", p6.Boulder.Position);
    u7:SetAttribute("LeashRadius", v12 + 75);

    if u11 ~= nil then
        local Pivot = u11:GetPivot();
        u7:SetAttribute("GoalName", u11.Name);
        u7:SetAttribute("GoalPosition", Pivot.Position);
        local u13 = false;
        p6.WeldedBoulder.Touched:Connect(function(p14: userdata) -- Line: 60
            -- upvalues: u13 (ref), u11 (copy), EffectsEvent (ref), Pivot (copy), TrainingQuestCredit (ref), u4 (copy), TrainingResult (ref), u10 (copy), FirstlightWagasa (ref), u7 (copy), TrainingStorage (ref)
            if u13 then
                return;
            end;

            if p14 ~= u11 and not p14:IsDescendantOf(u11) then
                return;
            end;

            u13 = true;
            EffectsEvent.ToAllInRange(Pivot, "BoulderPlaced", Pivot);
            TrainingQuestCredit(u4, "Boulder Push");
            TrainingResult(u4, "Boulder Push", true);

            if u10 ~= nil then
                FirstlightWagasa.Reveal(u4);
            end;

            u7:Destroy();
            TrainingStorage.ClearStorage(u4);
        end);
    end;

    return true, true;
end;

function v1.Destroying(p15: userdata, p16: userdata, p17: table, p18: userdata) -- Line: 87
    p17.Boulder.Transparency = 0;
    p17.Boulder.CanCollide = true;
    p17.Boulder = nil;
    p17.WeldedBoulder:Destroy();
    p17.WeldedBoulder = nil;
end;

function v1.StateChanged(p19: userdata, p20: userdata, p21: table, p22: boolean?) -- Line: 96
    -- upvalues: EffectsEvent (copy)
    local v23 = p22 == true;

    if p21.Pushing == v23 then
        return;
    end;

    p21.Pushing = v23;
    local WeldedBoulder = p21.WeldedBoulder;

    if WeldedBoulder == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(WeldedBoulder, "BoulderPushEffect", WeldedBoulder, v23);
end;

function v1.Stop(p24: userdata, p25: userdata, p26: table, ...) -- Line: 99
    return true;
end;

return v1;