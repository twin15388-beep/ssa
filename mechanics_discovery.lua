    -- Read-only discovery of gameplay scripts. Assets/packages/other players are not traversed.
    local mechanicTerms={
        stamina={"stamina","exhaust","sustain","climb","swim","run_handler","dash","horse"},
        combat={"combat","parry","blocking","hitbox","damage","ragdoll","death","despawn","npcservice","aimimic"},
        fishing={"fishing","fish","bait","barkeepup"},
        training={"training","skilltree","mastery","breathing","meditation","pushup","boulder","cup game","target shooting"},
        quests={"quest","dialogue","deliver","escort"},
        modes={"queue","minigame","ouwi","ranked","dungeon","wave","gauntlet","card","matchmaking","joinworld"},
        items={"potion","shop","inventory","equipment","toolscript","schematic","craft","crystal","loot","chest","cache","soul","reward","redeem","restock"},
        race={"race","muzan","sunlight","sundamage"},
    }
    local importantNames={checker=true,utility=true,skills_module=true,skill_controller=true,skills_provider=true,
        character_info_provider=true,serverclientportal=true,signalevent=true,signalfunction=true,queuesignal=true,
        itemrequirements=true,toolbaritemrestrictions=true,statsfetch=true,gamesettings=true,playerstatresolver=true,stats=true,skill_info=true,manage_cd=true,effectsevent=true}
    local function canonical(p)
        local names=string.split and string.split(p,".") or nil
        if names and names[1]=="Players" and names[2]==LP.Name then names[2]="<local>";return table.concat(names,".") end
        local start="Players."..LP.Name.."."
        if p:sub(1,#start)==start then return "Players.<local>."..p:sub(#start+1) end
        return p
    end
    local function mechanismGroups(p)
        local result={};local lower=p:lower()
        for category,words in pairs(mechanicTerms) do
            for _,word in ipairs(words) do if lower:find(word,1,true) then result[#result+1]=category;break end end
        end
        table.sort(result);return result
    end
    local function discoverFocusedRoots()
        local RS=game:GetService("ReplicatedStorage")
        local diagnostics={paths={},errors={},groups={},knownReferences={},remotes={},excluded={},deferred={},visited=0,eligible=0,
            scope="Gameplay scripts, local client scripts and current-place Content; no asset models, packages or other player data"}
        local candidates,queue,seen={}, {},{}
        local function add(root) if root then queue[#queue+1]=root end end
        add(RS);add(LP:FindFirstChild("PlayerScripts"));add(LP:FindFirstChild("PlayerGui"));add(LP.Character);add(LP:FindFirstChild("Backpack"))
        local ok,first=pcall(function() return game:GetService("ReplicatedFirst") end);if ok then add(first) end
        local head=1
        local excludedNames={CorePackages=true,CoreGui=true,RobloxReplicatedStorage=true,Packages=true,NodeModules=true,
            Assets=true,Effects=true,Animations=true,Player_Service=true,OCIFolder=true,DefaultChatSystemChatEvents=true,
            TextChatService=true,Chat=true,ExperienceChat=true,ChatScript=true,PlayerList=true}
        while head<=#queue and diagnostics.visited<25000 and state.alive and not state.cancel do
            local o=queue[head];queue[head]=false;head=head+1
            if o and not seen[o] then
                seen[o]=true;diagnostics.visited=diagnostics.visited+1
                local p=path(o);local name=tostring(o.Name);local lower=name:lower()
                local skip=excludedNames[name] or o==Lumen.State.Screen or lower:find("cam_main",1,true) or lower:find("cam_debug",1,true)
                if name=="Effects" and p:find(".Communication.",1,true) then skip=false end
                if o:IsA("Model") and o~=LP.Character then skip=true end
                if skip then
                    if #diagnostics.excluded<100 then diagnostics.excluded[#diagnostics.excluded+1]=p end
                else
                    if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") or o:IsA("UnreliableRemoteEvent") or o:IsA("BindableEvent") or o:IsA("BindableFunction") then
                        if #diagnostics.remotes<600 then diagnostics.remotes[#diagnostics.remotes+1]={path=p,class=o.ClassName,groups=mechanismGroups(p)} else diagnostics.remoteLimitReached=true end
                    end
                    if o:IsA("ModuleScript") or o:IsA("LocalScript") or (o:IsA("Script") and tostring(o.RunContext)=="Enum.RunContext.Client") then
                        local key=canonical(p);local groups=mechanismGroups(p)
                        local known=CAM_KNOWN_MECHANICS_SOURCES[key]
                        local sameBuild=game.PlaceId==136406881576517 and game.PlaceVersion==5354
                        -- Re-read mechanic-specific sources, reuse unrelated known content only on the same build.
                        local content=p:find(".Content.",1,true)~=nil
                        local critical=importantNames[lower] or (#groups>0 and not content)
                        if not (state.scannedPaths and state.scannedPaths[p]) then
                            if known and sameBuild and not critical then
                                if #diagnostics.knownReferences<2000 then diagnostics.knownReferences[#diagnostics.knownReferences+1]={path=p,reference=known} else diagnostics.referenceLimitReached=true end
                            else
                                local score=(critical and 100 or #groups>0 and 60 or 20)+(known and 0 or 10)+(content and not sameBuild and 30 or 0)
                                if lower:find("stamina",1,true) or importantNames[lower] then score=score+50 end
                                candidates[#candidates+1]={o=o,path=p,score=score,groups=groups}
                            end
                        end
                    end
                    local success,children=pcall(function() return o:GetChildren() end)
                    if success then
                        for _,child in ipairs(children) do
                            if #queue<25000 then queue[#queue+1]=child else diagnostics.limitReached=true;break end
                        end
                    elseif #diagnostics.errors<50 then diagnostics.errors[#diagnostics.errors+1]=p..": "..str(children,400) end
                end
            end
            if head%200==0 then task.wait() end
        end
        if head<=#queue then diagnostics.limitReached=true end
        diagnostics.eligible=#candidates
        table.sort(candidates,function(a,b) if a.score==b.score then return a.path<b.path end;return a.score>b.score end)
        local roots={};local limit=state.latePass and 80 or 350
        for i,c in ipairs(candidates) do
            if i<=limit then
                roots[#roots+1]=c.o;diagnostics.paths[#diagnostics.paths+1]=c.path
                for _,group in ipairs(c.groups) do diagnostics.groups[group]=(diagnostics.groups[group] or 0)+1 end
            else
                diagnostics.selectionLimitReached=true
                if #diagnostics.deferred<500 then diagnostics.deferred[#diagnostics.deferred+1]={path=c.path,groups=c.groups,priority=c.score} else diagnostics.deferredListLimitReached=true end
            end
        end
        diagnostics.selected=#roots
        return roots,diagnostics
    end
