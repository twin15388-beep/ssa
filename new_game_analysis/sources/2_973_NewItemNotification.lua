-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return function(p1) -- Line: 5
    game.ReplicatedStorage.Communication.CnC.Notifications.CenterNotification:Fire("NewItem", p1);
end;