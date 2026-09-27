from pathlib import Path
import json,re
base=Path('new_game_analysis/world_sources')
manifest=json.loads((base/'manifest.json').read_text());sources={r['path']:Path(r['file']).read_text() for r in manifest}
Q=r'"((?:\\.|[^"\\])*)"'
def unq(s):return re.sub(r'\\([\\\"\'nrt])',lambda m:{'n':'\n','r':'\r','t':'\t'}.get(m[1],m[1]),s)
def quoted(field,text):
 m=re.search(r'\b'+re.escape(field)+r'\s*=\s*'+Q,text);return unq(m[1]) if m else None
def point(s):
 m=re.search(r'(?:Vector3|CFrame)\.new\(\s*([-+\deE.]+)\s*,\s*([-+\deE.]+)\s*,\s*([-+\deE.]+)',s)
 return [float(m[i]) for i in range(1,4)] if m else None
def after(field,s):
 m=re.search(r'\b'+field+r'\s*=',s);return s[m.end():] if m else ''
def expand_shared(path,text,seen=None):
 seen=set() if seen is None else seen
 region=path.split('.Content.',1)[1].split('.',1)[0]
 extras=[]
 for p,s in sources.items():
  if '.Content.'+region+'.NpcShared.' in p and p.split('.')[-1] in text and p not in seen:
   seen.add(p);extras.append(s);extras.append(expand_shared(p,s,seen))
 return '\n'.join(extras)
def table_entries(s):
 start=s.find('return {')
 if start<0:return
 start=s.index('{',start)+1;i=start;depth=1
 while i<len(s) and depth>0:
  if s.startswith('--',i):
   j=s.find('\n',i);i=len(s) if j<0 else j+1;continue
  if s[i] in '"\'`':
   quote=s[i];i+=1
   while i<len(s):
    if s[i]=='\\':i+=2;continue
    if s[i]==quote:i+=1;break
    i+=1
   continue
  if depth==1:
   m=re.match(r'\[\s*'+Q+r'\s*\]\s*=\s*\{',s[i:])
   if m:
    key=unq(m[1]);a=i+m.end();j=a;d=1
    while j<len(s) and d:
     if s[j] in '"\'`':
      quote=s[j];j+=1
      while j<len(s):
       if s[j]=='\\':j+=2;continue
       if s[j]==quote:j+=1;break
       j+=1
      continue
     if s.startswith('--',j):
      end=s.find('\n',j);j=len(s) if end<0 else end+1;continue
     if s[j]=='{':d+=1
     elif s[j]=='}':d-=1
     j+=1
    yield key,s[a:j-1];i=j;continue
  if s[i]=='{':depth+=1
  elif s[i]=='}':depth-=1
  i+=1
npcs=[];givers={}
for path,s in sources.items():
 if '.ActiveNpcs.' in path:
  shared=expand_shared(path,s);name=quoted('Name',s) or path.split('.')[-1]
  code=quoted('NpcCode',s) or quoted('NpcCode',shared)
  loc=point(after('Locations',s)) or point(after('Spawns',shared)) or point(after('Center',s))
  aliases={name}
  if code:aliases.add(code)
  a=re.search(r'Appearance\s*=\s*ReplicatedStorage\.Assets\.Npcs[^\n]+',s)
  if a:
   tail=re.findall(r'\.(\w+)',a[0]);tail=[x for x in tail if x not in ['Assets','Npcs','GetChildren']]
   if tail:aliases.add(tail[-1])
  quantity=re.search(r'Quantity\s*=\s*(\d+)',s)
  if code and loc:npcs.append({'name':name,'code':code,'position':loc,'boss':bool(quantity and int(quantity[1])==1),'aliases':sorted(aliases),'source':path})
 elif '.Npcs.' in path and '.NpcContents.' not in path:
  name=quoted('Name',s) or path.split('.')[-1];pos=point(after('Spawns',s))
  if not pos:
   ref=re.search(r'Spawns\s*=\s*\{\s*(\w+)\s*\}',s)
   if ref:
    assign=re.search(r'local\s+'+ref[1]+r'\s*=([^;]+)',s)
    if assign:pos=point(assign[1])
  if pos:givers[(path.split('.Content.',1)[1].split('.',1)[0],name)]=pos
routes=[]
for path,s in sources.items():
 if '.Dialogues.Quests.' not in path:continue
 region=path.split('.Content.',1)[1].split('.',1)[0];npc=path.split('.')[-1]
 for key,entry in table_entries(s):
  if quoted('Category',entry)!='Combat' or any(x in entry for x in ['NextQuest =','NoSave = true','WenCostOnAccept','ItemCostOnAccept','TaskSpecs =','LogCompletion = true']):continue
  title=re.search(r'Quests\.Quest\(\s*'+Q,entry)
  tasks=re.findall(r'Quests\.QuestTask\(\s*'+Q+r'\s*,\s*(\d+)\s*,\s*([^\)]+)\)',entry)
  if not title or len(tasks)!=1:continue
  arg=tasks[0][2].strip()
  if arg.startswith('"'):code=unq(re.match(Q,arg)[1])
  else:
   prefix=arg.split('.')[0];shared=[t for p,t in sources.items() if '.NpcShared.' in p and p.split('.')[-1]==prefix and '.Content.'+region+'.' in p]
   code=quoted('NpcCode',shared[0]) if len(shared)==1 else None
  enemies=[x for x in npcs if x['code']==code]
  pos=givers.get((region,npc))
  if not enemies or not pos:continue
  level=re.search(r'Requirements\s*=\s*\{[^}]*?\bLevel\s*=\s*(\d+)',entry)
  routes.append({'key':key,'title':unq(title[1]),'npc':npc,'npcPosition':pos,'code':code,'count':int(tasks[0][1]),'level':int(level[1]) if level else 0,'region':region,'targetPosition':enemies[0]['position'],'source':path})
routes.sort(key=lambda q:(q['level'],q['key']))
result={'npcs':npcs,'quests':routes,'expPerLevel':60,'note':'Conservative static extraction from supplied decompiled content. Only single kill-task, no-cost, repeatable Combat routes with known NPC/spawn positions.'}
Path('new_game_analysis/cam_catalog.json').write_text(json.dumps(result,ensure_ascii=False,indent=2))
def lua(v):
 if isinstance(v,dict):return '{'+','.join('['+json.dumps(k,ensure_ascii=False)+']='+lua(x) for k,x in v.items())+'}'
 if isinstance(v,list):return '{'+','.join(lua(x) for x in v)+'}'
 if isinstance(v,str):return json.dumps(v,ensure_ascii=False)
 if isinstance(v,bool):return str(v).lower()
 return repr(v)
Path('cam_catalog.lua').write_text('local CAM_CATALOG = '+lua(result)+'\n')
print('Catalog:',len(npcs),'active NPC definitions;',len(routes),'supported repeatable combat quest routes')
for q in routes:print(q['level'],q['key'],'->',q['code'],'NPC',q['npc'])
assert any(q['code']=='Zuko' and q['level']==7 for q in routes)
assert any(q['code']=='BearCub' and q['level']==10 for q in routes)
