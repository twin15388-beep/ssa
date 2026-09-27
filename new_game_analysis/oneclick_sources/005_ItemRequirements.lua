-- Decompiled with Potassium's decompiler.

local Items = require(script.Parent.Items);
local gameSettings = require(script.Parent.Parent.gameSettings);
local u3 = {
 Resolve = function(p1: userdata?, p2: string) -- Line: 47, Name: Resolve
 if p1 == nil or p2 == nil then
 return nil;
 end;

 for i in string.gmatch(p2, "[^%.]+") do
 if p1 == nil then
 return nil;
 end;

 p1 = p1:FindFirstChild(i);
 end;

 if p1 == nil or not p1:IsA("ValueBase") then
 return nil;
 end;

 return p1;
 end
};

function u3.Passes(p4: userdata?, p5: table?) -- Line: 62
 -- upvalues: u3 (copy), gameSettings (copy)
 if p5 == nil then
 return true;
 end;

 if p4 == nil then
 return false;
 end;

 for i, v in pairs(p5) do
 if i == "Level" and typeof(v) == "number" then
 local v6 = u3.Resolve(p4, "Exp.Goal");

 if v6 == nil or v6.Value / gameSettings.expPerLevel < v then
 return false;
 end;
 elseif i == "MaxLevel" and typeof(v) == "number" then
 local v7 = u3.Resolve(p4, "Exp.Goal");

 if v7 == nil or v < v7.Value / gameSettings.expPerLevel then
 return false;
 end;
 elseif i == "Items" then
 local Inventory = p4:FindFirstChild("Inventory");
 local v8;

 if Inventory == nil then
 v8 = nil;
 else
 v8 = Inventory:FindFirstChild("Inventory") or nil;
 end;

 if v8 == nil then
 return false;
 end;

 local v9 = typeof(v) ~= "table" and { v } or v;
 local v10 = false;

 for _, v2 in ipairs(v9) do
 if type(v2) == "string" and v8:FindFirstChild(v2) ~= nil then
 v10 = true;
 break;
 end;
 end;

 if not v10 then
 return false;
 end;
 else
 local v11 = u3.Resolve(p4, i);
 local v12;

 if v11 == nil then
 v12 = nil;
 else
 v12 = v11.Value;
 end;

 if typeof(v) == "table" then
 if table.find(v, v12) == nil then
 return false;
 end;
 elseif v12 ~= v then
 return false;
 end;
 end;
 end;

 return true;
end;

function u3.Satisfies(p13: userdata, p14: string, p15: boolean?) -- Line: 114
 -- upvalues: Items (copy), u3 (copy)
 local v16 = Items[p14];
 local v17;

 if v16 == nil then
 v17 = nil;
 else
 v17 = v16.Requirements or nil;
 end;

 if p15 == true and (v16 ~= nil and v16.NoSaveRequirements ~= nil) then
 v17 = v16.NoSaveRequirements;
 end;

 return u3.Passes(p13, v17);
end;

function u3.SatisfiesEquip(p18: userdata?, p19: string) -- Line: 124
 -- upvalues: Items (copy), u3 (copy)
 local v20 = Items[p19];
 local v21;

 if v20 == nil then
 v21 = nil;
 else
 v21 = v20.EquipRequirements or nil;
 end;

 return u3.Passes(p18, v21);
end;

function u3.Describe(p22: table?) -- Line: 132
 if p22 == nil then
 return "";
 end;

 local v23 = {};

 for i, v in p22 do
 if i ~= "Level" then
 if i ~= "MaxLevel" then
 if i == "Items" then
 local v24;

 if typeof(v) == "table" then
 v24 = v[1];
 else
 v24 = v;
 end;

 if v24 ~= nil then
 local v25 = `holding an {v24}`;
 table.insert(v23, v25);
 end;
 elseif typeof(v) == "table" then
 if v[1] ~= nil then
 local v26 = tostring(v[1]);
 table.insert(v23, v26);
 end;
 else
 local v27 = tostring(v);
 table.insert(v23, v27);
 end;
 end;
 end;
 end;

 if p22.Level == nil or p22.MaxLevel == nil then
 if p22.Level == nil then
 if p22.MaxLevel ~= nil then
 local v28 = `Lvl. {p22.MaxLevel} max`;
 table.insert(v23, v28);
 end;
 else
 local v29 = `Lvl. {p22.Level}+`;
 table.insert(v23, v29);
 end;
 else
 local v30 = `Lvl. {p22.Level}-{p22.MaxLevel}`;
 table.insert(v23, v30);
 end;

 return table.concat(v23, ", ");
end;

local u31 = nil;

function u3.Keys() -- Line: 162
 -- upvalues: u31 (ref), Items (copy)
 if u31 ~= nil then
 return u31;
 end;

 local v32 = {};

 for _, v in pairs(Items) do
 if typeof(v) == "table" then
 for _, v2 in { v.Requirements, v.NoSaveRequirements, v.EquipRequirements } do
 if typeof(v2) == "table" then
 for i in pairs(v2) do
 v32[i] = true;
 end;
 end;
 end;
 end;
 end;

 u31 = {};

 for i in pairs(v32) do
 table.insert(u31, i);
 end;

 return u31;
end;

return u3;