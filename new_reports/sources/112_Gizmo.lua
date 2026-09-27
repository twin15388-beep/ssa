-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Terrain = workspace:WaitForChild("Terrain");
local Terrain2 = workspace:WaitForChild("Terrain");
assert(Terrain, "No terrain object found under workspace");
assert(Terrain2, "No target parent found.");
local AOTGizmoAdornment = Terrain2:FindFirstChild("AOTGizmoAdornment");
local GizmoAdornment = Terrain2:FindFirstChild("GizmoAdornment");

if not AOTGizmoAdornment then
    AOTGizmoAdornment = Instance.new("WireframeHandleAdornment");
    AOTGizmoAdornment.Adornee = Terrain;
    AOTGizmoAdornment.ZIndex = 1;
    AOTGizmoAdornment.AlwaysOnTop = true;
    AOTGizmoAdornment.Name = "AOTGizmoAdornment";
    AOTGizmoAdornment.Parent = Terrain2;
end;

if not GizmoAdornment then
    GizmoAdornment = Instance.new("WireframeHandleAdornment");
    GizmoAdornment.Adornee = Terrain;
    GizmoAdornment.ZIndex = 1;
    GizmoAdornment.AlwaysOnTop = false;
    GizmoAdornment.Name = "GizmoAdornment";
    GizmoAdornment.Parent = Terrain2;
end;

local Gizmos = script.Parent:WaitForChild("Gizmos");
local u1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = {
    AlwaysOnTop = true,
    Transparency = 0,
    Color3 = Color3.fromRGB(13, 105, 172)
};
local u6 = {};
local u7 = false;

local function Register(p8) -- Line: 50
    -- upvalues: Terrain2 (copy), u1 (ref)
    p8.Parent = Terrain2;
    table.insert(u1, p8);
end;

local function Lerp(p9, p10, p11) -- Line: 80
    return p9 + (p10 - p9) * p11;
end;

local function deepCopy(p12) -- Line: 84
    -- upvalues: deepCopy (copy)
    local v13 = {};

    for i, v in pairs(p12) do
        local v14;

        if type(v) == "table" then
            v14 = deepCopy(v);
        else
            v14 = v;
        end;

        v13[i] = v14;
    end;

    return v13;
end;

local u19 = {
    Enabled = true,
    ActiveRays = 0,
    ActiveInstances = 0,
    Styles = {
        Color = "Color3",
        Transparency = "Transparency",
        AlwaysOnTop = "AlwaysOnTop"
    },
    AOTWireframeHandle = AOTGizmoAdornment,
    WireframeHandle = GizmoAdornment,

    GetPoolSize = function() -- Line: 506, Name: GetPoolSize
        -- upvalues: u6 (copy)
        local v15 = 0;

        for _, v in u6 do
            v15 = v15 + #v;
        end;

        return v15;
    end,

    PushProperty = function(u16, u17) -- Line: 521, Name: PushProperty
        -- upvalues: u5 (copy), AOTGizmoAdornment (ref), GizmoAdornment (ref)
        u5[u16] = u17;

        if u16 == "AlwaysOnTop" then
            return;
        end;

        pcall(function() -- Line: 528
            -- upvalues: AOTGizmoAdornment (ref), u16 (copy), u17 (copy), GizmoAdornment (ref)
            AOTGizmoAdornment[u16] = u17;
            GizmoAdornment[u16] = u17;
        end);
    end,

    PopProperty = function(p18) -- Line: 539, Name: PopProperty
        -- upvalues: u5 (copy), AOTGizmoAdornment (ref)
        if u5[p18] then
            return u5[p18];
        end;

        return AOTGizmoAdornment[p18];
    end
};

function u19.SetStyle(p20, p21, p22) -- Line: 553
    -- upvalues: u19 (copy)
    if p20 ~= nil and typeof(p20) == "Color3" then
        u19.PushProperty("Color3", p20);
    end;

    if p21 ~= nil and typeof(p21) == "number" then
        u19.PushProperty("Transparency", p21);
    end;

    if p22 ~= nil and typeof(p22) == "boolean" then
        u19.PushProperty("AlwaysOnTop", p22);
    end;
end;

function u19.DoCleaning() -- Line: 569
    -- upvalues: AOTGizmoAdornment (ref), GizmoAdornment (ref), u1 (ref), u6 (copy), u19 (copy)
    AOTGizmoAdornment:Clear();
    GizmoAdornment:Clear();

    for _, v in u1 do
        local ClassName = v.ClassName;

        if not u6[ClassName] then
            u6[ClassName] = {};
        end;

        v:Remove();
        table.insert(u6[ClassName], v);
    end;

    u1 = {};
    u19.ActiveRays = 0;
    u19.ActiveInstances = 0;
end;

function u19.ScheduleCleaning() -- Line: 585
    -- upvalues: u7 (ref), u19 (copy)
    if u7 then
        return;
    end;

    u7 = true;
    task.delay(0, function() -- Line: 592
        -- upvalues: u19 (ref), u7 (ref)
        u19.DoCleaning();
        u7 = false;
    end);
end;

function u19.AddDebrisInSeconds(p23: number, p24: any) -- Line: 604
    -- upvalues: u3 (copy)
    local v25 = {
        "Seconds",
        p23,
        os.clock(),
        p24
    };
    table.insert(u3, v25);
end;

function u19.AddDebrisInFrames(p26: number, p27: any) -- Line: 613
    -- upvalues: u3 (copy)
    table.insert(u3, {
        "Frames",
        p26,
        0,
        p27
    });
end;

function u19.TweenProperties(p28: table, p29: table, p30: userdata) -- Line: 624
    -- upvalues: deepCopy (copy), u4 (copy)
    local u31 = {
        Time = 0,
        p_Properties = p28,
        Properties = deepCopy(p28),
        Goal = p29,
        TweenInfo = p30
    };
    u4[u31] = true;

    return function() -- Line: 638
        -- upvalues: u4 (ref), u31 (copy)
        u4[u31] = nil;
    end;
end;

function u19.Init() -- Line: 645
    -- upvalues: RunService (copy), u19 (copy), Terrain2 (copy), AOTGizmoAdornment (ref), Terrain (copy), GizmoAdornment (ref), u4 (copy), TweenService (copy), u3 (copy), u2 (copy)
    RunService.RenderStepped:Connect(function(p32) -- Line: 646
        -- upvalues: u19 (ref), Terrain2 (ref), AOTGizmoAdornment (ref), Terrain (ref), GizmoAdornment (ref), u4 (ref), TweenService (ref), u3 (ref), u2 (ref)
        if u19.Enabled then
            if not Terrain2:FindFirstChild("AOTGizmoAdornment") then
                AOTGizmoAdornment = Instance.new("WireframeHandleAdornment");
                AOTGizmoAdornment.Adornee = Terrain;
                AOTGizmoAdornment.ZIndex = 1;
                AOTGizmoAdornment.AlwaysOnTop = true;
                AOTGizmoAdornment.Name = "AOTGizmoAdornment";
                AOTGizmoAdornment.Parent = Terrain2;
                u19.AOTWireframeHandle = AOTGizmoAdornment;
            end;

            if not Terrain2:FindFirstChild("GizmoAdornment") then
                GizmoAdornment = Instance.new("WireframeHandleAdornment");
                GizmoAdornment.Adornee = Terrain;
                GizmoAdornment.ZIndex = 1;
                GizmoAdornment.AlwaysOnTop = false;
                GizmoAdornment.Name = "GizmoAdornment";
                GizmoAdornment.Parent = Terrain2;
                u19.WireframeHandle = GizmoAdornment;
            end;
        end;

        for i in u4 do
            i.Time = i.Time + p32;
            local v33 = i.Time / i.TweenInfo.Time;
            local v34 = v33 > 1 and 1 or v33;

            local function LerpProperty(p35, p36, p37) -- Line: 680
                if type(p35) == "number" then
                    return p35 + (p36 - p35) * p37;
                end;

                return p35:Lerp(p36, p37);
            end;

            local v38 = i;

            for i2, v in i.Properties do
                if v38.Goal[i2] then
                    local Value = TweenService:GetValue(v34, v38.TweenInfo.EasingStyle, v38.TweenInfo.EasingDirection);
                    local v39 = v38.Goal[i2];
                    local v40;

                    if type(v) == "number" then
                        v40 = v + (v39 - v) * Value;
                    else
                        v40 = v:Lerp(v39, Value);
                    end;

                    v38.p_Properties[i2] = v40;
                end;
            end;

            if v34 == 1 then
                u4[v38] = nil;
            end;
        end;

        for i = #u3, 1, -1 do
            local v41 = u3[i];
            local v42 = v41[2];
            local v43 = v41[3];
            local v44 = v41[4];
            local v45;

            if v41[1] == "Seconds" then
                if v42 < os.clock() - v43 then
                    table.remove(u3, i);
                    v45 = i;
                else
                    v44();
                    v45 = i;
                end;
            elseif v42 < v43 then
                table.remove(u3, i);
                v45 = i;
            else
                v41[2] = v41[2] + 1;
                v44();
                v45 = i;
            end;
        end;

        for i = #u2, 1, -1 do
            local v46 = u2[i];
            local v47 = v46[2];
            local v48;

            if v47.Enabled then
                if v47.Destroy then
                    table.remove(u2, i);
                    v48 = i;
                else
                    v46[1]:Update(v47);
                    v48 = i;
                end;
            else
                v48 = i;
            end;
        end;
    end);
end;

function u19.SetEnabled(p49) -- Line: 753
    -- upvalues: u19 (copy)
    u19.Enabled = p49;

    if p49 == false then
        u19.DoCleaning();
    end;
end;

function u19.RemoveAdornments() -- Line: 764
    -- upvalues: Terrain2 (copy)
    if Terrain2:FindFirstChild("AOTGizmoAdornment") then
        Terrain2:FindFirstChild("AOTGizmoAdornment"):Destroy();
    end;

    if Terrain2:FindFirstChild("GizmoAdornment") then
        Terrain2:FindFirstChild("GizmoAdornment"):Destroy();
    end;
end;

local function Request(p50) -- Line: 66
    -- upvalues: u6 (copy)
    if u6[p50] then
        return table.remove(u6[p50]) or Instance.new(p50);
    end;

    return Instance.new(p50);
end;

local function Release(p51) -- Line: 55
    -- upvalues: u6 (copy)
    local ClassName = p51.ClassName;

    if not u6[ClassName] then
        u6[ClassName] = {};
    end;

    p51:Remove();
    table.insert(u6[ClassName], p51);
end;

local function Retain(p52, p53) -- Line: 46
    -- upvalues: u2 (copy)
    table.insert(u2, { p52, p53 });
end;

for _, child in Gizmos:GetChildren() do
    u19[child.Name] = require(child).Init(u19, u5, Request, Release, Retain, Register);
end;

return u19;