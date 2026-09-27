-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local v1 = {};
local SkillStats = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("StatsFetch"):WaitForChild("Modules"):WaitForChild("SkillStats"));

function v1.new(p2: userdata, p3: number, u4: table?, p5: string?) -- Line: 7
    -- upvalues: SkillStats (copy), simplesignal (copy), Utility (copy)
    local v6 = true;

    if p5 ~= nil then
        local v7 = SkillStats.Get(p5);

        if v7 and v7.cancel_bypass ~= nil then
            v6 = false;
        end;
    end;

    local v8 = p3 or 5;

    if p2 then
        local u9 = simplesignal.new();
        local u10 = nil;

        local function destroy() -- Line: 26
            -- upvalues: u10 (ref), u9 (ref)
            if u10 then
                u10:Disconnect();
                u10 = nil;
            end;

            if u9 then
                u9:DisconnectAll();
                u9:Destroy();
                u9 = nil;
            end;
        end;

        if v6 == true then
            u10 = Utility.getvaluesfolder(p2).ChildAdded:Connect(function(p11) -- Line: 39
                -- upvalues: u4 (copy), Utility (ref), u9 (ref), u10 (ref)
                if u4 ~= nil and table.find(u4, p11.Name) or u4 == nil and Utility.Cancel_Values[p11.Name] then
                    u9:Fire(p11.Name);

                    if u10 then
                        u10:Disconnect();
                        u10 = nil;
                    end;

                    if u9 then
                        u9:DisconnectAll();
                        u9:Destroy();
                        u9 = nil;
                    end;
                end;
            end);
        end;

        if v8 >= 0 then
            task.delay(v8, destroy);
        end;

        return u9, destroy;
    end;

    warn("No player provided to module:New");
end;

return v1;