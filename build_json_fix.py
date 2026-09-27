from pathlib import Path
s=Path('core_debug_logic.lua').read_text()
def rep(a,b):
 global s
 assert a in s,a[:120]
 s=s.replace(a,b)
rep('Universal Game Debug 1.3 (focused core profile).','Universal Game Debug 1.4 (safe JSON fallback).')
rep('alive = true, busy = false, cancel = false, logs','alive = true, busy = false, exporting = false, cancelExport = false, cancel = false, logs')
rep('''        if state.busy then notify("Scan already running") return end''','''        if state.busy or state.exporting then notify("Wait for the current scan/export") return end''')
rep('''if state.busy then notify("Wait for scan completion, or press Cancel") return end''','''if state.busy or state.exporting then notify("Wait for scan/export completion, or press Cancel") return end''')
rep('''if state.busy then notify("Wait for scan completion or cancel first") return end''','''if state.busy or state.exporting then notify("Wait for scan/export completion or cancel first") return end''')
rep('''if state.busy then notify("Wait for scan to finish") return end''','''if state.busy or state.exporting then notify("Wait for scan/export to finish") return end''')
rep('''format = "NZL Game Debug 1.3"''','''format = "NZL Game Debug 1.4"''')
rep('''NZL Game Debug Bundle 1.3''','''NZL Game Debug Bundle 1.4''')
a=s.index('    local function encodeReport()')
b=s.index('    local manualFrame',a)
s=s[:a]+'''    local function encodeSafe(report)
        if state.exporting then notify("Export already running") return end
        state.exporting, state.cancelExport = true, false
        status("Encoding report...")
        local ok, text, info = pcall(function()
            local success, result = pcall(function() return Http:JSONEncode(report) end)
            if success and type(result)=="string" and result~="" then return result end
            local details = { error = str(result or "Native encoder returned no text",1000), fields = {} }
            -- First identify failing top-level fields; never discard them silently.
            for key, v in pairs(report) do
                if not state.alive or state.cancelExport then error("Export cancelled; cached scan retained",0) end
                local fieldOK, fieldError = pcall(function() return Http:JSONEncode(v) end)
                if not fieldOK then details.fields[#details.fields+1] = { field = tostring(key), error = str(fieldError,500) } end
                task.wait()
            end
            status("Native JSON failed; using portable export...")
            return PortableJSON(report, details, function(count, bytes)
                if not state.alive or state.cancelExport then error("Export cancelled; cached scan retained",0) end
                status("Exporting: " .. count .. " values / " .. math.floor(bytes/1024) .. " KB")
                task.wait()
            end)
        end)
        state.exporting = false
        if not ok then
            status("Export stopped; report remains in memory")
            notify("Export error: " .. str(text,180))
            return
        end
        state.lastSerialization = info
        lastExport = text
        status("Export ready: " .. #text .. " bytes")
        if info then
            notify("Portable JSON ready. Normalized values: " .. info.normalizationCount .. ". Details: _jsonExport.")
        end
        return text
    end
    local function encodeReport()
        local report = selectReport()
        if not report then return end
        return encodeSafe(report)
    end
''' + s[b:]
a=s.index('        local ok, text = pcall(function()\n            return Http:JSONEncode({ format = "NZL Game Debug Bundle 1.4"')
b=s.index('    local function copy(bundle)',a)
s=s[:a]+'''        return encodeSafe({ format = "NZL Game Debug Bundle 1.4", exportType = "bundle",
            createdUTC = os.date("!%Y-%m-%dT%H:%M:%SZ"), reportCount = #reports,
            reports = reports, logsAtExport = table.clone(state.logs),
            note = "Full cached scans, ignoring export filters. Client-visible data only; review before sharing." })
    end
''' + s[b:]
rep('''Version = "1.3"''','''Version = "1.4 / JSON fix"''')
rep('''    controls:Button({ Name = "Cancel (keep partial report)", Callback = function()
        if not state.busy then''','''    controls:Button({ Name = "Cancel (keep partial report)", Callback = function()
        if state.exporting then state.cancelExport=true;notify("Cancelling export; cached scan retained") return end
        if not state.busy then''')
rep('''    notes:Label("Text is not syntax-checked or executed.")''','''    notes:Label("Text is not syntax-checked or executed.")
    notes:Label("JSON failure: portable fallback keeps the report.")
    notes:Label("Normalization details: _jsonExport issue paths.")
    notes:Label("Large overview: prefer Save report (.json).")''')
rep('''New game: CORE dependencies -> Game overview -> Export / Save ALL scans. RightControl: menu.''','''JSON fix ready. Scan Game overview -> Export / Save report. CORE does not need repeating if already exported.''')
Path('json_fix_logic.lua').write_text(s)
old=Path('Debug_New_Game_Core.lua').read_text()
lib=old[old.index('local Lumen = (function()'):old.index('-- Universal Game Debug 1.3')]
header='''-- GAME DEBUG 1.4 | JSON EXPORT FIX | Standalone Lumen UI
-- Keeps overview/core/universal profiles. No gameplay remote calls or require().
-- Native JSON failure -> portable JSON with explicit normalization diagnostics.
-- Invalid UTF-8 is replaced, never claimed byte-exact: see _jsonExport.
-- Run whole file, scan Game overview (no source), then Export -> Save report (.json).
'''
Path('Debug_JSON_Fix_v1.4.lua').write_text(header+lib+Path('portable_json.lua').read_text()+'\n'+s)
print('Wrote',Path('Debug_JSON_Fix_v1.4.lua').stat().st_size,'bytes')
