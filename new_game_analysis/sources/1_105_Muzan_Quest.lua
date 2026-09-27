-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarkerHandler = require(ReplicatedStorage.CAM.Client.Modules.MarkerHandler);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);

return {
    Tasks = {
        ["Deliver Dr. Higoshima"] = {
            Do = function(u1: userdata, p2: userdata, p3: any) -- Line: 35, Name: Do
                -- upvalues: MarkerHandler (copy), MuzanSettings (copy), BunchaIcons (copy)
                local u4 = false;
                local u5 = false;
                local u6 = nil;
                p3:Add(function() -- Line: 38, Name: clearZone
                    -- upvalues: u5 (ref), MarkerHandler (ref), u6 (ref)
                    if u5 then
                        u5 = false;
                        MarkerHandler.removeMarker("Muzan Quest - Deliver Dr. Higoshima");
                    end;

                    if u6 ~= nil then
                        u6:Destroy();
                        u6 = nil;
                    end;
                end);

                local function sync() -- Line: 49
                    -- upvalues: u1 (copy), u4 (ref), MarkerHandler (ref), MuzanSettings (ref), BunchaIcons (ref), u5 (ref), u6 (ref)
                    local Attribute = u1:GetAttribute("HigoshimaDeliverTo");
                    local v7 = typeof(Attribute) == "CFrame";

                    if v7 or u4 then
                        if v7 and u4 then
                            u4 = false;
                            MarkerHandler.removeMarker("Muzan Quest - Dr. Higoshima");
                        end;
                    else
                        u4 = true;
                        MarkerHandler.addMarker("Muzan Quest - Dr. Higoshima", {
                            minDistance = 35,
                            margin = 10,
                            position = MuzanSettings.HigoshimaSpawn.Position + Vector3.new(0, 3, 0),
                            img = BunchaIcons.Combat
                        });
                    end;

                    if v7 and not u5 then
                        u5 = true;
                        MarkerHandler.addMarker("Muzan Quest - Deliver Dr. Higoshima", {
                            style = "Simple",
                            img = "rbxassetid://78675452486649",
                            tag = "HigoshimaZoneMarker",
                            markerType = MarkerHandler.markerType.Regular,
                            position = Attribute.Position + Vector3.new(0, 3, 0)
                        });
                        local HigoshimaSafeZone = script:FindFirstChild("HigoshimaSafeZone");

                        if HigoshimaSafeZone ~= nil and (HigoshimaSafeZone:IsA("Model") and u6 == nil) then
                            local v8 = HigoshimaSafeZone:Clone();

                            for _, descendant in v8:GetDescendants() do
                                if descendant:IsA("BasePart") then
                                    descendant.Anchored = true;
                                end;
                            end;

                            v8:PivotTo(Attribute);
                            v8.Parent = workspace.Debree;
                            u6 = v8;
                        end;
                    elseif not v7 and u5 then
                        if u5 then
                            u5 = false;
                            MarkerHandler.removeMarker("Muzan Quest - Deliver Dr. Higoshima");
                        end;

                        if u6 ~= nil then
                            u6:Destroy();
                            u6 = nil;
                        end;
                    end;
                end;

                p3:Connect(u1:GetAttributeChangedSignal("HigoshimaDeliverTo"), sync);
                sync();
            end,

            Stop = function(p9: userdata, p10: userdata, p11: any) -- Line: 94, Name: Stop
                -- upvalues: MarkerHandler (copy)
                MarkerHandler.removeMarker("Muzan Quest - Dr. Higoshima");
            end
        }
    }
};