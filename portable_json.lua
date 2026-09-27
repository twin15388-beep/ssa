-- Portable fallback exporter. Does not execute source or mutate the report.
-- Returns a JSON object with an explicit _jsonExport diagnostics field.
local function PortableJSON(data, nativeInfo, checkpoint)
    assert(type(data)=="table", "Report root must be a table")
    local chunks, active, issues = {}, {}, {}
    local operations, byteCount, issueCount = 0, 0, 0
    local collecting = true
    local function textOf(v)
        local ok,s=pcall(tostring,v)
        return ok and s or "<tostring unavailable>"
    end
    local function issue(path,kind,detail)
        if not collecting then return end
        issueCount=issueCount+1
        if #issues<100 then
            issues[#issues+1]={path=textOf(path):sub(1,800),kind=kind,detail=textOf(detail):sub(1,600)}
        end
    end
    local function put(s)
        chunks[#chunks+1]=s;byteCount=byteCount+#s
    end
    local function pace()
        operations=operations+1
        if checkpoint and operations%2000==0 then checkpoint(operations,byteCount) end
    end
    local function safeUTF8(s,path)
        if utf8 and type(utf8.len)=="function" then
            local ok,n=pcall(utf8.len,s)
            if ok and n~=nil then return s end
        end
        local out,start,i,bad={},1,1,0
        local function continuation(b) return b and b>=128 and b<=191 end
        while i<=#s do
            local b=s:byte(i);local n=0
            if b<128 then n=1
            elseif b>=194 and b<=223 and continuation(s:byte(i+1)) then n=2
            elseif b>=224 and b<=239 then
                local c=s:byte(i+1)
                if continuation(c) and continuation(s:byte(i+2)) and not (b==224 and c<160) and not (b==237 and c>159) then n=3 end
            elseif b>=240 and b<=244 then
                local c=s:byte(i+1)
                if continuation(c) and continuation(s:byte(i+2)) and continuation(s:byte(i+3)) and not (b==240 and c<144) and not (b==244 and c>143) then n=4 end
            end
            if n>0 then i=i+n
            else
                if i>start then out[#out+1]=s:sub(start,i-1) end
                out[#out+1]="\239\191\189" -- U+FFFD; never silently pretend bytes were preserved.
                bad=bad+1;i=i+1;start=i
            end
            if checkpoint and i%32768==0 then checkpoint(operations,byteCount) end
        end
        if bad==0 then return s end
        if start<=#s then out[#out+1]=s:sub(start) end
        issue(path,"invalid_utf8",bad.." invalid byte(s) replaced by U+FFFD")
        return table.concat(out)
    end
    local function quoted(s,path)
        s=safeUTF8(s,path)
        s=s:gsub('[%z\1-\31\\"]',function(c)
            if c=='"' then return '\\"' end
            if c=='\\' then return '\\\\' end
            return string.format('\\u%04x',string.byte(c))
        end)
        return '"'..s..'"'
    end
    local function keysOf(t,path)
        local rows,used={},{ }
        for k,v in next,t do
            local key
            if type(k)=="string" then key=safeUTF8(k,path..".<key>")
            else key=textOf(k);issue(path,"non_string_object_key","Key of type "..type(k).." converted to text") end
            key=safeUTF8(key,path..".<key>")
            local original=key;local n=1
            while used[key] do n=n+1;key=original.."#key"..n end
            if n>1 then issue(path,"key_collision","Preserved colliding key as "..key) end
            used[key]=true
            rows[#rows+1]={key=key,value=v}
        end
        table.sort(rows,function(a,b) return a.key<b.key end)
        return rows
    end
    local encode
    encode=function(v,path,depth)
        pace()
        local t=type(v)
        if t=="nil" then put("null")
        elseif t=="boolean" then put(v and "true" or "false")
        elseif t=="number" then
            if v~=v or v==math.huge or v==-math.huge then
                issue(path,"non_finite_number",textOf(v).." replaced by null");put("null")
            else put((string.format("%.17g",v):gsub(",","."))) end
        elseif t=="string" then put(quoted(v,path))
        elseif t=="table" then
            if active[v] then issue(path,"cycle","Reference to "..active[v].." replaced by null");put("null");return end
            if depth>64 then issue(path,"depth_limit","Nested table below depth 64 replaced by null");put("null");return end
            active[v]=path
            local count,maxIndex,dense=0,0,true
            for k in next,v do
                count=count+1
                if type(k)~="number" or k<1 or k%1~=0 or k==math.huge then dense=false
                elseif k>maxIndex then maxIndex=k end
            end
            dense=dense and maxIndex==count
            if dense then
                put("[")
                for i=1,count do if i>1 then put(",") end;encode(rawget(v,i),path.."["..i.."]",depth+1) end
                put("]")
            else
                local rows=keysOf(v,path)
                put("{")
                for i,row in ipairs(rows) do
                    if i>1 then put(",") end
                    put(quoted(row.key,path..".<key>"));put(":")
                    encode(row.value,path.."["..quoted(row.key,path).."]",depth+1)
                end
                put("}")
            end
            active[v]=nil
        else
            local kind=(typeof and typeof(v)) or t
            local label="["..kind.."] "..textOf(v)
            if kind=="Instance" then
                local ok,p=pcall(function() return v:GetFullName() end)
                if ok then label="[Instance] "..p end
            end
            issue(path,"unsupported_value",kind.." converted to text")
            put(quoted(label,path))
        end
    end
    local rows=keysOf(data,"$")
    local diagnosticKey="_jsonExport"
    while rawget(data,diagnosticKey)~=nil do diagnosticKey=diagnosticKey.."_" end
    active[data]="$";put("{")
    for i,row in ipairs(rows) do
        if i>1 then put(",") end
        put(quoted(row.key,"$.<key>"));put(":")
        encode(row.value,"$["..quoted(row.key,"$").."]",1)
    end
    active[data]=nil
    local info={
        serializer="portable-json-v1",nativeError=nativeInfo and nativeInfo.error or "",
        nativeFailedFields=nativeInfo and nativeInfo.fields or {},normalizationCount=issueCount,
        changedValues=issueCount>0,issues=issues,issueDetailsTruncated=issueCount>#issues,
        note="Invalid UTF-8 replaced; unsupported/non-finite/cyclic values normalized with issue paths. Source text is not executed. Scan completeness flags are separate.",
    }
    collecting=false
    if #rows>0 then put(",") end
    put(quoted(diagnosticKey,"$"));put(":");encode(info,"$."..diagnosticKey,1);put("}")
    if checkpoint then checkpoint(operations,byteCount) end
    return table.concat(chunks),info
end
