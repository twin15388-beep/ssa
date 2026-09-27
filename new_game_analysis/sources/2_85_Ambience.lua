-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = nil;
local TweenInfo_new_ret = TweenInfo.new(1);

function UpdateAmbience()
    -- upvalues: LocalPlayer (copy), u1 (ref), u2 (ref), TweenService (copy), TweenInfo_new_ret (copy), DebrisModule (copy)
    local v3 = LocalPlayer.Character ~= nil and LocalPlayer.Character:GetAttribute("CameraInSwimPart") and "Underwater" or nil;

    if v3 ~= u1 then
        u1 = v3;

        if u2 ~= nil then
            TweenService:Create(u2, TweenInfo_new_ret, {
                Volume = 0
            }):Play();
            DebrisModule:AddItem(u2, 1);
            u2 = nil;
        end;

        local v4 = v3 ~= nil and script:FindFirstChild(v3) or nil;

        if v4 ~= nil then
            local v5 = v4:Clone();
            u2 = v5;
            local Volume = v5.Volume;
            v5.Parent = script;
            v5.Volume = 0;
            v5:Play();
            TweenService:Create(v5, TweenInfo_new_ret, {
                Volume = Volume
            }):Play();
        end;
    end;
end;

local u6 = cleanit.new();

function updCharacter(p7: userdata)
    -- upvalues: u6 (copy)
    u6:Clean();
    u6:Add(p7:GetAttributeChangedSignal("CameraInSwimPart"):Connect(UpdateAmbience));
end;

if LocalPlayer.Character ~= nil then
    updCharacter(LocalPlayer.Character);
end;

LocalPlayer.CharacterAdded:Connect(updCharacter);