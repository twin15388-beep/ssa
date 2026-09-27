-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skill_Controller = require(ReplicatedStorage.CAM.Client.Controllers.Skill_Controller);
require(ReplicatedStorage.Packages.cleanit);
local u2 = {
 LastDid = 0,
 LifeCleaner = nil,

 Letter = function(p1) -- Line: 35, Name: Letter
 return math.abs(p1.X) > math.abs(p1.Y) and (p1.X > 0 and "D" or "A") or (p1.Y < 0 and "W" or "S");
 end
};

function u2.MovementLetter() -- Line: 50
 -- upvalues: u2 (copy)
 local Character = game:GetService("Players").LocalPlayer.Character;

 if Character then
 Character = Character:FindFirstChildOfClass("Humanoid");
 end;

 local workspace_CurrentCamera = workspace.CurrentCamera;

 if Character == nil or workspace_CurrentCamera == nil then
 return "W";
 end;

 local MoveDirection = Character.MoveDirection;

 if MoveDirection.Magnitude < 0.1 then
 return "W";
 end;

 local LookVector = workspace_CurrentCamera.CFrame.LookVector;
 local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);

 if Vector3_new_ret.Magnitude < 0.01 then
 return "W";
 end;

 local Unit = Vector3_new_ret.Unit;
 local Vector3_new_ret2 = Vector3.new(-Unit.Z, 0, Unit.X);

 return u2.Letter(Vector2.new(MoveDirection:Dot(Vector3_new_ret2), -MoveDirection:Dot(Unit)));
end;

function u2.Perform(p3: string) -- Line: 66
 -- upvalues: Skill_Controller (copy), u2 (copy)
 local v4 = Skill_Controller.Attempt_Hold("Dash", p3);

 if v4 == true then
 Skill_Controller.StopHold("Dash");
 end;

 u2.LastDid = tick();

 return v4 == true;
end;

return u2;