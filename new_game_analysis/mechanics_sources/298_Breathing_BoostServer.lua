-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage.CAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ServerClientPortal = require(CAM.Global.ServerClientPortal);
local Skill_Switch_Adder = require(CAM.Global.Subsets.Gameplay.Skill_Switch_Adder);
local StatTypes = require(CAM.Global.Types.StatTypes);
local Utility = require(CAM.Global.Utility);
local Config = require(script.Parent.Config);
local u1 = {
    Id = {}
};
local Name = script.Parent.Name;
local u2 = Name .. "Skill_Switch";
local u3 = setmetatable({}, {
    __mode = "k"
});

local function stop(p4: userdata) -- Line: 55
    -- upvalues: u3 (copy)
    local v5 = u3[p4];

    if v5 ~= nil then
        v5();
    end;
end;

function u1.Hold(u6: userdata, p7: any, p8: any) -- Line: 60
    -- upvalues: Utility (copy), Config (copy), u3 (copy), u1 (copy), EffectsEvent (copy), StatTypes (copy), u2 (copy), ServerClientPortal (copy), Name (copy), Skill_Switch_Adder (copy)
    local Character = u6.Character;

    if Character == nil then
        return false;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v9 = Character:FindFirstChildOfClass("Humanoid");
    local valuesfolder = Utility.getvaluesfolder(u6);

    if HumanoidRootPart == nil or (v9 == nil or valuesfolder == nil) then
        return false;
    end;

    local Stamina = valuesfolder:FindFirstChild("Stamina");
    local v10;

    if Stamina == nil then
        v10 = false;
    else
        v10 = Stamina:IsA("ValueBase") and typeof(Stamina.Value) == "number";
    end;

    if v10 and Stamina.Value <= Config.STAMINA_FLOOR then
        return false;
    end;

    local v11 = u3[u6];

    if v11 ~= nil then
        v11();
    end;

    local v12 = u1.Id[u6.UserId];
    EffectsEvent.ToAllInRange(HumanoidRootPart, "BreathingBoostVFX", Character, "Initiate");
    task.wait(Config.WINDUP);

    if v12 ~= u1.Id[u6.UserId] then
        return false;
    end;

    if HumanoidRootPart.Parent == nil or v9.Health <= 0 then
        return false;
    end;

    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = Config.BUFF_VALUE;
    BoolValue.Value = true;
    BoolValue:AddTag(StatTypes.ValueStatTag);
    BoolValue:SetAttribute(StatTypes.StatToAttribute("Run Speed Factor"), Config.RUN_SPEED_FACTOR);
    BoolValue:SetAttribute(StatTypes.StatToAttribute("Stamina Drain Rate"), Config.STAMINA_DRAIN);
    BoolValue.Parent = valuesfolder;
    local u13 = {};
    local u14 = nil;
    local u15 = false;

    local function finish() -- Line: 99
        -- upvalues: u15 (ref), u3 (ref), u6 (copy), finish (copy), u13 (copy), BoolValue (copy), u14 (ref), u2 (ref), HumanoidRootPart (copy), EffectsEvent (ref), Character (copy)
        if u15 then
            return;
        end;

        u15 = true;

        if u3[u6] == finish then
            u3[u6] = nil;
        end;

        for _, v in u13 do
            v:Disconnect();
        end;

        table.clear(u13);

        if BoolValue.Parent ~= nil then
            BoolValue:Destroy();
        end;

        if u14 ~= nil and u14.__Active then
            u14:ToClient("End");
            u14:Destroy();
        end;

        u14 = nil;
        local v16 = u6:FindFirstChild(u2);

        if v16 ~= nil then
            v16:Destroy();
        end;

        if HumanoidRootPart.Parent ~= nil then
            EffectsEvent.ToAllInRange(HumanoidRootPart, "BreathingBoostVFX", Character, "End");
        end;
    end;

    u3[u6] = finish;

    if v10 then
        local PropertyChangedSignal = Stamina:GetPropertyChangedSignal("Value");
        table.insert(u13, PropertyChangedSignal:Connect(function() -- Line: 123
            -- upvalues: Stamina (copy), Config (ref), finish (copy)
            if Stamina.Value <= Config.STAMINA_FLOOR then
                finish();
            end;
        end));
    end;

    table.insert(u13, v9.Died:Connect(finish));
    task.delay(Config.DURATION, finish);
    u14 = ServerClientPortal.Create(u6, Name, Config.DURATION + 1);
    local u17 = false;
    local u18 = 0;
    u14:Connect(function(p19) -- Line: 134
        -- upvalues: u15 (ref), u17 (ref), u18 (ref), HumanoidRootPart (copy), EffectsEvent (ref), Character (copy)
        if u15 then
            return;
        end;

        local v20 = p19 == true;

        if v20 == u17 or os.clock() - u18 < 0.2 then
            return;
        end;

        local os_clock_ret = os.clock();
        u17 = v20;
        u18 = os_clock_ret;

        if HumanoidRootPart.Parent == nil then
            return;
        end;

        EffectsEvent.ToAllInRange(HumanoidRootPart, "BreathingBoostVFX", Character, u17 and "Run" or "Stop");
    end);
    u14:ToClient("Start");
    Skill_Switch_Adder.Add(u6, Name, Config.DURATION);

    return true;
end;

function u1.Switch(p21: userdata) -- Line: 155
    -- upvalues: u3 (copy)
    local v22 = u3[p21];

    if v22 ~= nil then
        v22();
    end;
end;

function u1.Cancel(p23: userdata) -- Line: 164
end;

return u1;