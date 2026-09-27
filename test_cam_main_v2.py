from pathlib import Path
# Roblox/UI fixture only, not the obsolete v1 feature tests.
prefix=Path('test_cam_main.py').read_text().split("lua.execute(Path('portable_json.lua').read_text()")[0]
exec(compile(prefix,'fixture_v2','exec'))
lua.execute(r'''
local vm=getmetatable(Vector3.zero);vm.__unm=function(v) return Vector3.new(-v.X,-v.Y,-v.Z) end
local cm={};cm.__mul=function(a,b) return CFrame.new(a.Position+b.Position) end
CFrame.new=function(x,y,z)
 local cf={__type='CFrame',Position=type(x)=='table' and x or Vector3.new(x or 0,y or 0,z or 0),LookVector=Vector3.new(0,0,-1),RightVector=Vector3.new(1,0,0)}
 setmetatable(cf,cm);cf.Rotation=setmetatable({Position=Vector3.zero},cm)
 function cf:PointToWorldSpace(v) return self.Position+v end
 return cf
end
CFrame.lookAt=function(pos,to) return CFrame.new(pos) end
local rootMT={__index=function(t,k) if k=='CFrame' then return rawget(t,'_cf') elseif k=='Position' then return rawget(t,'_cf').Position end end,
 __newindex=function(t,k,v) if k=='CFrame' then rawset(t,'_cf',v) elseif k=='Position' then rawset(t,'_cf',CFrame.new(v)) else rawset(t,k,v) end end}
function _syncRoot(root) root._cf=CFrame.new(root.Position);root.CFrame=nil;root.Position=nil;setmetatable(root,rootMT) end
_syncRoot(_root);_syncRoot(_hunter:FindFirstChild('HumanoidRootPart'))
_hunter.Name='Bandit';_enemyPlayer.Name='Bandit'
function _npc(name,pos)
 local n=_add(workspace,_obj(name,'Model'));_add(n,_obj('Humanoid','Humanoid',{Health=100,MaxHealth=100}));local r=_add(n,_obj('HumanoidRootPart','Part',{Position=pos,CFrame=CFrame.new(pos)}));_syncRoot(r);return n
end
_zuko=_npc('Zuko',Vector3.new(-422.491821,1243.50012,-952.493408))
_unknown=_npc('Random civilian',Vector3.new(1,0,0))
local inventory=_path(_data,{'Inventory','Inventory'});local toolbar=_path(_data,{'Inventory','Toolbar'})
for i,n in ipairs({'One','Two','Three','Four','Five'}) do _add(toolbar,_obj(n,'IntValue',{Value=({1,2,14,0,0})[i]})) end
_itemsById={}
for id,name in pairs({[1]='Combat',[2]='Clan Skills',[14]='Tanto'}) do local item=_add(inventory,_obj(name,'Folder'));_add(item,_obj('Id','IntValue',{Value=id}));_itemsById[id]=item end
_equipped=_LP:FindFirstChild('Items_Config'):FindFirstChild('Equipped')
local exp=_path(_data,{'Exp'});_goal=_add(exp,_obj('Goal','IntValue',{Value=480}));_current=_add(exp,_obj('Current','IntValue',{Value=384}))
_localValues=_path(_RS,{'Player_Service','Values','LocalPlayer'});_combo=_path(_localValues,{'ComboTrackerClient'});_comboTime=_add(_combo,_obj('Time','IntValue',{Value=0}))
_questHolder=_path(_data,{'Quests','Holder'})
_mods.Character_info_provider={GetItemFromId=function(lp,id) return _itemsById[id] end,Get_equipped_tool=function(lp) local n=({'One','Two','Three','Four','Five'})[_equipped.Value];local slot=n and toolbar:FindFirstChild(n);return slot and _itemsById[slot.Value] end}
_mods.Items={Combat={HasCombat=true},Tanto={HasCombat=true}}
_locked=false
_mods.ToolbarItemRestrictions={GetCurrentRestrictions=function() return {Locked=_locked} end}
_mods.ItemRequirements={SatisfiesEquip=function(d,n) return not _locked end,Passes=function(d,req) return (req.Level or 0)<=_goal.Value/60 and not req.blocked end}
_mods.Regions={}
_mods.Quests.Holder={}
_mods.Quests.CanAddQuest=function(key) assert(type(key)=='string');return _questAllowed,_questAllowed and nil or 'cooldown' end
for _,p in ipairs({{'Regions'},{'CAM','Global','Character_info_provider'},{'CAM','Global','Collectibles','Items'},{'CAM','Global','Collectibles','ItemRequirements'},{'CAM','Global','Subsets','Gameplay','ToolbarItemRestrictions'}}) do _path(_RS,p,'ModuleScript') end
_combatScript=_path(_LP,{'PlayerScripts','CU','Combat'},'LocalScript');_punchCount=0
getsenv=function(o) assert(o==_combatScript);return {punch=function()
 _punchCount=_punchCount+1;_comboTime.Value=_clock
 local target=CAMMainHub.State.target
 if target and not _noDamage then local h=target:FindFirstChildOfClass('Humanoid');h.Health=math.max(1,h.Health-10) end
 return 0.4
end} end
function _makeQuest(route)
 local q=_obj(route.title,'Configuration');local ts=_add(q,_obj('Tasks','Configuration'));local t=_add(ts,_obj('Kills','Configuration'))
 _add(t,_obj('Value','IntValue',{Value=0}));_add(t,_obj('Max','IntValue',{Value=route.count}));_add(t,_obj('Code','StringValue',{Value=route.code}));_add(q,_obj('QuestString','StringValue',{Value=route.key}));return q
end
_spawnCursor=0
function _runTasks() local n=#_spawn;for i=_spawnCursor+1,n do _spawnCursor=i;_spawn[i]() end end
function _step(dt) _beat(dt or 0.3);_runTasks() end
function _stop() CAMMainHub.StopAll() end
_saved={};writefile=function(n,t) _saved[n]=t end;setclipboard=function(t) _clipboard=t end
''')
# Expose only catalog fixture; production still has locals.
catalog=Path('cam_catalog.lua').read_text()
lua.execute(catalog+'\n_testCatalog=CAM_CATALOG\nfor _,r in ipairs(CAM_CATALOG.quests) do _mods.Quests.Holder[r.key]={Category="Combat",Requirements={Level=r.level},QuestInstance=_makeQuest(r)} end')
lua.execute(Path('portable_json.lua').read_text()+'\n'+Path('cam_boss_names.lua').read_text()+'\n'+catalog+Path('cam_main_logic.lua').read_text())
assert lua.eval('_requireCalls')==0
print('Fixture-only suite: kaitan pipeline UI was absent in 3.1.0 and restored in 3.1.1; this file remains the shared fixture for the other suites.')
