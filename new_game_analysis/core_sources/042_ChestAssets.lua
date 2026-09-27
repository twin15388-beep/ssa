-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Ouwmit = require(ReplicatedStorage.CAM.Client.Modules.Effects.Ouwmit);
local vfxUtility = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local Chest_Anims = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Chest_Anims");
local Chests = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Sounds"):WaitForChild("Chests");
local Effect = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Chests"):WaitForChild("Effect");
local u4 = {
    EffectFolder = Effect,

    key = function(p1: userdata) -- Line: 27, Name: key
        return p1:GetAttribute("ChestModel") or (p1:GetAttribute("ChestId") or p1.Name);
    end,

    animator = function(p2: userdata) -- Line: 33, Name: animator
        local v3 = p2:QueryDescendants("Animator")[1];

        if v3 then
            return v3;
        end;

        local AnimationController = p2:WaitForChild("AnimationController", 5);

        if AnimationController then
            return AnimationController:WaitForChild("Animator", 5);
        end;

        return nil;
    end
};

function u4.track(p5: userdata, p6: userdata?, p7: string) -- Line: 42
    -- upvalues: u4 (copy), Chest_Anims (copy)
    if not p6 then
        return nil;
    end;

    local v8 = u4.key(p5);
    local v9 = Chest_Anims:FindFirstChild(v8) or Chest_Anims:FindFirstChild("Common Chest");
    local v10;

    if v9 then
        v10 = v9:QueryDescendants((`Animation#{p7}`))[1];
    else
        v10 = nil;
    end;

    if not v10 then
        warn((`Chest '{v8}' missing {p7}`));

        return nil;
    end;

    local v11 = p6:LoadAnimation(v10);
    v11.Looped = false;
    local v12 = os.clock() + 5;

    while v11.Length == 0 and os.clock() < v12 do
        task.wait();
    end;

    return v11;
end;

function u4.sound(p13: userdata, p14: string) -- Line: 64
    -- upvalues: u4 (copy), Chests (copy)
    local v15 = p13.PrimaryPart or p13:QueryDescendants("BasePart")[1];

    if not v15 then
        return nil;
    end;

    local v16 = Chests:FindFirstChild((u4.key(p13))) or Chests:FindFirstChild("Common Chest");
    local v17;

    if v16 then
        v17 = v16:QueryDescendants((`Sound#{p14}`))[1];
    else
        v17 = nil;
    end;

    if not v17 then
        return nil;
    end;

    local v18 = v17:Clone();
    v18.Parent = v15;

    return v18;
end;

function u4.play(p19: userdata?) -- Line: 80
    if not p19 then
        return;
    end;

    p19:Stop();
    p19.TimePosition = 0;
    p19:Play();
end;

function u4.burst(p20: userdata, p21: string) -- Line: 90
    -- upvalues: Effect (copy), RaycastHelper (copy), vfxUtility (copy), Ouwmit (copy), DebrisModule (copy)
    local Attribute = p20:GetAttribute(p21);

    if typeof(Attribute) ~= "string" then
        return;
    end;

    local v22 = Effect:FindFirstChild(Attribute);

    if not v22 then
        warn((`Chest effect '{Attribute}' not found in Assets.Chests.Effect`));

        return;
    end;

    local Pivot = p20:GetPivot();
    local Attribute2 = p20:GetAttribute("SpawnOffset");

    if typeof(Attribute2) == "Vector3" then
        Pivot = Pivot * CFrame.new(-Attribute2);
    end;

    local v23 = v22:Clone();
    v23.Parent = workspace.Debree;
    v23:PivotTo(Pivot);
    local v24 = workspace:Raycast(Pivot.Position + Vector3.new(0, 3, 0), Vector3.new(0, -20, 0), RaycastHelper.Crater);
    local v25 = v24 and vfxUtility.GetDustColorSettings(v24.Instance) or nil;
    Ouwmit.Emit(v23, v25);
    DebrisModule:AddItem(v23, 5);
end;

function u4.flash(p26: userdata) -- Line: 122
    -- upvalues: Effect (copy)
    local Highlight = Effect:FindFirstChild("Highlight");

    if not (Highlight and Highlight:IsA("Highlight")) then
        return nil;
    end;

    local v27 = Highlight:Clone();
    v27.Adornee = p26;
    v27.Enabled = false;
    v27.Parent = p26;

    return v27;
end;

return u4;