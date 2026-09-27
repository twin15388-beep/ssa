import json, re, hashlib, csv, io, zipfile
from pathlib import Path
base=Path('/home/user/new_reports')
groups={};missing=[];usage=[]
for p in sorted(base.glob('report_*.json')):
 d=json.loads(p.read_text());profile=d['settings']['profile']
 for r in d['records']:
  src=r.get('source')
  if src is None:
   missing.append({'profile':profile,**r});continue
  entry=groups.setdefault(src,{'occurrences':[]})
  entry['occurrences'].append({'profile':profile,'path':r['path'],'nodeId':r['id'],'sourceStatus':r['sourceStatus'],'sourceTruncated':r.get('sourceTruncated',False)})
manifest=[];index=['# Извлечённые тексты Game Debug 1.1','','Декомпиляция не является оригинальным исходником; код не запускался. Ошибки декомпилятора выделены в TXT.','','| Файл | Первый путь | Число копий | Тип |','|---|---|---:|---|']
with zipfile.ZipFile('/home/user/Исходники_и_индекс_v1.1.zip','w',zipfile.ZIP_DEFLATED) as z:
 for i,(src,g) in enumerate(groups.items(),1):
  commentOnly=all(not l.strip() or l.lstrip().startswith('--') for l in src.splitlines())
  failed=commentOnly and bool(re.search(r'^\s*--\s*Error:',src,re.M))
  title=re.sub(r'[^\w.-]+','_',g['occurrences'][0]['path'].split('.')[-1])
  fn=f'{"decompiler_errors" if failed else "sources"}/{i:03d}_{title}{".txt" if failed else ".lua"}'
  z.writestr(fn,src.encode('utf-8'))
  manifest.append({'file':fn,'kind':'decompiler_error_text' if failed else 'unverified_decompiled_source','sha256':hashlib.sha256(src.encode()).hexdigest(),'bytes':len(src.encode()),**g})
  index.append(f'| [{fn}]({fn}) | `{g["occurrences"][0]["path"]}` | {len(g["occurrences"])} | {"Ошибка" if failed else "Непроверенный код"} |')
  for lineNo,line in enumerate(src.splitlines(),1):
   ops=re.findall(r':(FireServer|InvokeServer)\s*\(|\b(OnClientEvent)\b',line)
   if ops:
    usage.append([fn,lineNo,', '.join(a or b for a,b in ops),g['occurrences'][0]['path'],line.strip()])
 z.writestr('manifest.json',json.dumps(manifest,ensure_ascii=False,indent=2))
 z.writestr('not_extracted.json',json.dumps(missing,ensure_ascii=False,indent=2))
 z.writestr('index.md','\n'.join(index))
 buf=io.StringIO();w=csv.writer(buf);w.writerow(['file','line','text_match','first_script_path','source_line']);w.writerows(usage)
 z.writestr('remote_usage.csv',b'\xef\xbb\xbf'+buf.getvalue().encode())
 z.write('/home/user/Разбор_игры_v1.1.md','Разбор_игры.md')
 z.writestr('README.txt','234 уникальных текста кода, 1 уникальный текст ошибки (2 записи). Код не изменялся и не выполнялся. Путь к каждой копии указан в manifest.json. remote_usage.csv — поиск текстовых совпадений, не анализ потока данных и не запись сетевого трафика. Декомпиляция может содержать ошибки. Перед публикацией проверьте приватные сведения.')
print('Unique:',len(manifest),'Errors:',sum(x['kind']=='decompiler_error_text' for x in manifest),'Usage rows:',len(usage))
with zipfile.ZipFile('/home/user/Исходники_и_индекс_v1.1.zip') as z:
 assert z.testzip() is None
 assert len([n for n in z.namelist() if n.endswith('.lua')])==234
print('ZIP verified')
