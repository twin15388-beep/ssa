-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return {
    forTask = function(u1: string, u2: string) -- Line: 21, Name: forTask
        -- upvalues: Quests (copy), Utility (copy), SignalEvent (copy)
        return {
            Tasks = {
                [u2] = {
                    Do = function(p3: userdata, p4: userdata, u5: any) -- Line: 25, Name: Do
                        -- upvalues: Quests (ref), u1 (copy), u2 (copy), Utility (ref), SignalEvent (ref)
                        local RequiredItem = Quests.Holder[u1].TaskSpecs[u2].RequiredItem;
                        local Inventory = Utility.GetData(p3).Inventory.Inventory;

                        local function nudge() -- Line: 30
                            -- upvalues: SignalEvent (ref), u1 (ref), u2 (ref)
                            SignalEvent.ToServer("QuestProgress", u1, u2);
                        end;

                        local function watchAmount(p6: userdata) -- Line: 33
                            -- upvalues: u5 (copy), nudge (copy), SignalEvent (ref), u1 (ref), u2 (ref)
                            if p6.Name ~= "Amount" then
                                return;
                            end;

                            u5:Connect(p6.Changed, nudge);
                            SignalEvent.ToServer("QuestProgress", u1, u2);
                        end;

                        u5:Connect(Inventory.ChildAdded, function(p7: userdata) -- Line: 38, Name: watchEntry
                            -- upvalues: RequiredItem (copy), u5 (copy), watchAmount (copy), nudge (copy), SignalEvent (ref), u1 (ref), u2 (ref)
                            if p7.Name ~= RequiredItem then
                                return;
                            end;

                            u5:Connect(p7.ChildAdded, watchAmount);
                            local Amount = p7:FindFirstChild("Amount");

                            if Amount ~= nil then
                                u5:Connect(Amount.Changed, nudge);
                            end;

                            SignalEvent.ToServer("QuestProgress", u1, u2);
                        end);
                        local v8 = Inventory:FindFirstChild(RequiredItem);

                        if v8 ~= nil then
                            if v8.Name ~= RequiredItem then
                                return;
                            end;

                            u5:Connect(v8.ChildAdded, watchAmount);
                            local Amount = v8:FindFirstChild("Amount");

                            if Amount ~= nil then
                                u5:Connect(Amount.Changed, nudge);
                            end;

                            SignalEvent.ToServer("QuestProgress", u1, u2);
                        end;
                    end
                }
            }
        };
    end
};