-- Decompiled with Potassium's decompiler.

return {
    Clearance = 7,
    Keys = {
        {
            Type = "Action",
            Name = "Action",
            Required = false,
            Suggester = { "Toggle", "Open", "Close" },

            Completer = function(p1: string) -- Line: 24, Name: Completer
                if p1 == nil or p1 == "" then
                    return nil;
                end;

                return p1;
            end
        }
    },

    Client = function(p2: any, p3: userdata, p4: string?) -- Line: 30, Name: Client
        local RuntimeExplorerHooks = game.ReplicatedStorage:FindFirstChild("RuntimeExplorerHooks");

        if RuntimeExplorerHooks == nil then
            error("Explorer: RuntimeExplorerHooks is missing, the RuntimeExplorer server script isn\'t running in this place");
        end;

        local v5 = require(RuntimeExplorerHooks);
        local v6 = p4 == nil and "toggle" or (string.lower(p4) or "toggle");
        local v7 = nil;

        if v6 == "toggle" then
            v7 = v5.Client.ToggleTool;
        elseif v6 == "open" then
            v7 = v5.Client.OpenTool;
        elseif v6 == "close" then
            v7 = v5.Client.CloseTool;
        else
            error((`Explorer: unknown action "{v6}" (Toggle, Open, Close)`));
        end;

        if not pcall(v7, v5.Client) then
            error("Explorer: the explorer client isn\'t mounted for you (check RuntimeExplorer Permissions, or it\'s still loading)");
        end;
    end
};