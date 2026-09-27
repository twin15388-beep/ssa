-- CAM MAIN HUB 3.2.4 | New CAM game, NOT the old NZL game.
-- Place 136406881576517; catalog baseline 5354, removal bug captured on game version 5400.
-- Standalone: embedded Lumen UI, no loadstring/HTTP downloads.
-- All automation OFF. RightControl: menu. Unload: settings. Unload restores local edits.
-- Auto Level / Auto Farm connect native modules on explicit enable. Above position default.
-- Native actions/server acceptance are not live-tested here. Read the feature matrix.
--[[
	lumen ui - single file roblox ui library
	made as a clean rewrite, no external assets / no http font downloads

	LOAD:
		local Lumen = loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/lumen.lua"))()

	STRUCTURE:
		Lumen:Window(data)                      -> Window
		Window:Page(data)                       -> Page   (data.Group = sidebar group label)
		every window auto-creates a "settings" page (configs/themes/menu key);
		disable with Window({ SettingsPage = false })
		Window:SetOpen(bool) / Window:SetMinimized(bool) / Window:Unload()
		Page:SubPage(data)                      -> SubPage   (needs Page.SubPages = true)
		Page:Section(data)                      -> Section   (SubPage:Section works too)
		Section:Toggle(data)                    -> Toggle
			Toggle:Keybind(data)                -> Keybind
			Toggle:Colorpicker(data)            -> Colorpicker
		Section:Slider(data)                    -> Slider
		Section:Dropdown(data)                  -> Dropdown
		Section:Textbox(data)                   -> Textbox
		Section:Button(data)                    -> Button
		Section:Label(text, alignment, tooltip) -> Label
			Label:Keybind(data) / Label:Colorpicker(data)
		Section:Keybind(data) / Section:Colorpicker(data)
		Lumen:Watermark(text, data)             -> Watermark
		Lumen:KeybindsList(data)                -> KeybindsList
		Lumen:Notification(data)
		Lumen:SetTheme(name) / Lumen:SetColor(key, color3) / Lumen:SetAccent(color3)
		   -- the preset dropdown in appearance -> theme lists every theme, animated first:
		   -- NZL (rainbow), Aurora, Cyber, Voltage, Storm, Void, Alarm.
		Lumen:SetWindowTransparency(value) / SetNotificationDuration(sec)
		Lumen:SaveConfig(name) / LoadConfig / DeleteConfig / GetConfigs
		Lumen:BuildConfigSection(section) / Lumen:BuildThemeSection(section)
		Lumen:Unload()   -- removes every widget, connection and thread the ui created

	DRAGGING:
		the window is dragged by the top bar or the brand block. while it moves it
		shows a drag hud (brackets, hub name, speed bar), a translucent trail and
		guides on the screen edges; dropping it near an edge docks it there.
	all of that is one shot tweens + one short loop that only runs while the
	title bar is held - nothing ticks while the menu sits still.

	THE SETTINGS PAGE (built with the window) HAS:
		menu       - menu key, watermark, keybind list, fade speed, unload ui
		appearance - window transparency, notification duration
		configs    - save / load / delete / autoload
		theme      - presets, per color editing, saved themes

	NOTES:
		* azure is the default theme (shinri was removed).
		* the watermark stats line reads the ping from Stats -> Network ->
		  ServerStatsItem["Data Ping"] (milliseconds) and falls back to
		  LocalPlayer:GetNetworkPing() when the stats service has nothing. samples are
		  smoothed, and when no sample could be read for three seconds the line shows
		  "-- ms" instead of a fake zero. Lumen:GetPing() returns the same number.
		* there is no client drawn focus outline anywhere: every button, textbox and
		  scroller this library creates gets Selectable = false and a blank
		  SelectionImageObject, so clicking a widget never paints the default
		  blue/white selection box on top of the design.
		* a closed menu is completely inert: dropdown lists close, floating popups
		  (colorpickers, keybind menus, tooltips) hide and a keybind waiting for a
		  key stops listening - nothing can be pressed, hovered or outlined while the
		  window is not on screen.
		* right click on a keybind button opens the mode menu (toggle / hold / always,
		  show in list, clear bind). the old "right click also wipes the bind" was a
		  double handler and is gone - clearing the bind lives in that menu.
		* the drag fx is tied to a real drag of the title bar: the drop ring, the trail,
		  the speed hud and the edge guides only appear while the window is actually
		  being moved. releasing the mouse anywhere else (clicking in the game world
		  with the menu closed) does nothing, so no outline can flash over the screen.

	HOW TO RUN:
		executor:  paste this whole file as one script and execute.
		studio:    LocalScript in StarterPlayerScripts, paste there.
		then in the SAME script (or another one) use:
			local Lumen = getgenv().CAMMainLumen
			local Window = Lumen:Window({ Name = "my hub" })
		lumen_demo.lua in this folder is this file with the example
		already uncommented - paste it if you just want to see the menu.

	FULL EXAMPLE AT THE VERY BOTTOM OF THIS FILE.
]]

--#region bootstrap
if getgenv and getgenv().CAMMainLumen and getgenv().CAMMainLumen.Unload then
	pcall(function() getgenv().CAMMainLumen:Unload() end)
end

local Lumen = { }

Lumen.LibraryName = "CAM Main"
Lumen.Version = "1.0.0"

-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

-- the stats service reports the ping the client itself uses (in milliseconds).
-- it is optional: on some clients it is missing, so every read is guarded.
local Stats = nil
pcall(function()
	Stats = game:GetService("Stats")
end)

local LocalPlayer = Players.LocalPlayer

-- the camera can be missing for a frame or two right after joining
local function viewportSize()
	local camera = Workspace.CurrentCamera
	if camera then
		local size = camera.ViewportSize
		if size.X > 1 and size.Y > 1 then
			return size
		end
	end

	return Vector2.new(1280, 720)
end

local function guiParent()
	local ok, result = pcall(gethui)
	if ok and result then
		return result
	end

	return game:GetService("CoreGui")
end

-- executor shims so nothing errors in studio / vanilla clients
local cloneref = cloneref or function(ref) return ref end
local gethui = gethui or function() return game:GetService("CoreGui") end
local isfile = isfile or function() return false end
local isfolder = isfolder or function() return false end
local readfile = readfile or function() return "" end
local writefile = writefile or function() end
local delfile = delfile or function() end
local makefolder = makefolder or function() end
local listfiles = listfiles or function() return { } end
local getgenv = getgenv or function() return _G end

Players = cloneref(Players)
RunService = cloneref(RunService)
UserInputService = cloneref(UserInputService)

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- folders
Lumen.Folder = "nzl_studio"
Lumen.ConfigFolder = Lumen.Folder .. "/configs"
Lumen.ThemeFolder = Lumen.Folder .. "/themes"

-- fonts / tween defaults
Lumen.Font = Enum.Font.Gotham
Lumen.FontMedium = Enum.Font.GothamMedium
Lumen.FontBold = Enum.Font.GothamBold
Lumen.TextSize = 13
Lumen.TweenTime = 0.18
Lumen.TweenStyle = Enum.EasingStyle.Quad
Lumen.TweenDirection = Enum.EasingDirection.Out

-- config
Lumen.Flags = { }
Lumen.Options = { }
Lumen.Connections = { }

-- every connection that only lives while something is hovered / listened to.
-- they are tracked too, so Unload() leaves nothing behind (see the settings page).
Lumen.TransientConnections = { }

-- ui preferences (settings -> appearance), kept on the library so a reload keeps them
Lumen.WindowTransparency = 0      -- 0 .. 0.85
Lumen.NotificationDuration = 4    -- seconds, used when a toast has no Duration

local function createState()
	return {
		Running = true,
		Ready = false,
		Screen = nil,
		Popups = nil,
		Notifications = nil,
		MinimizedBar = nil,
		Window = nil,
		Keybinds = { },
		KeybindsList = nil,
		Dropdowns = { },
		PopupWindows = { },
		ThemeRegistry = { },
		ThemeRefreshers = { },
		ThemePreset = "Azure",
		InputHandler = false,
		FlagCount = 0,
	}
end

Lumen.State = createState()
--#endregion

--#region utility
-- the client paints its own focus box around a button the moment it is clicked (and
-- around anything selectable a gamepad lands on). this one blank template is handed
-- to every interactive object we build, so the only outlines the user ever sees are
-- the ones this library draws itself.
local BlankSelection = Instance.new("Frame")
BlankSelection.Name = "lumen_selection_blank"
BlankSelection.BackgroundTransparency = 1
BlankSelection.BorderSizePixel = 0
BlankSelection.Size = UDim2.fromOffset(0, 0)

-- it is never parented, so nothing else can destroy it: keep it in reach so a
-- reload does not leave one of these behind for every execution of the script
Lumen.State.BlankSelection = BlankSelection

local function unselectable(instance)
	pcall(function()
		instance.Selectable = false
		instance.SelectionImageObject = BlankSelection
	end)

	return instance
end

local function new(className, properties)
	local instance = Instance.new(className)

	if properties then
		local parent = properties.Parent
		local children = properties.Children

		for property, value in next, properties do
			if property ~= "Parent" and property ~= "Children" then
				instance[property] = value
			end
		end

		if children then
			for _, child in next, children do
				child.Parent = instance
			end
		end

		if parent then
			instance.Parent = parent
		end
	end

	-- no default focus / selection outline on anything clickable
	if instance:IsA("GuiButton") or instance:IsA("TextBox") or instance:IsA("ScrollingFrame") then
		unselectable(instance)
	end

	return instance
end

local function corner(parent, radius)
	return new("UICorner", { Parent = parent, CornerRadius = UDim.new(0, radius or 6) })
end

local function stroke(parent, color, thickness, transparency)
	return new("UIStroke", {
		Parent = parent,
		Color = color or Lumen.Theme.Border,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		LineJoinMode = Enum.LineJoinMode.Round,
	})
end

local function list(parent, props)
	local layout = new("UIListLayout", props or { })
	layout.Parent = parent
	return layout
end

local function padding(parent, top, bottom, left, right)
	new("UIPadding", {
		Parent = parent,
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft = UDim.new(0, left or 0),
		PaddingRight = UDim.new(0, right or 0),
	})
end

local function tween(instance, properties, time, style, direction)
	if not instance or not instance.Parent then
		return nil
	end

	local info = TweenInfo.new(
		time or Lumen.TweenTime,
		style or Lumen.TweenStyle,
		direction or Lumen.TweenDirection
	)

	local tweenObject = TweenService:Create(instance, info, properties)
	tweenObject:Play()
	return tweenObject
end

local function safe(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end

	local success, result = pcall(fn, ...)
	if not success then
		warn("[lumen] callback error: " .. tostring(result))
	end

	return success
end

local function connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Lumen.Connections, connection)
	return connection
end

-- short lived connection (hover tooltips, key capture): tracked separately, so
-- Lumen:Unload() can close them even if the widget is destroyed while they run
local function connectTransient(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Lumen.TransientConnections, connection)
	return connection
end

local function disconnectTransient(connection)
	if not connection then
		return
	end

	for index, entry in next, Lumen.TransientConnections do
		if entry == connection then
			table.remove(Lumen.TransientConnections, index)
			break
		end
	end

	pcall(function()
		connection:Disconnect()
	end)
end

-- interaction gate -------------------------------------------------------------
-- every widget asks this before it reacts to a click, a hover or a key capture.
-- while the menu is closed, minimized or being dragged the answer is false, so an
-- invisible menu can never be pressed by accident, and no hover effect, tooltip or
-- focus outline can appear over a closed ui.
local function canInteract()
	local window = Lumen.State.Window

	if not window or not window.Alive then
		return false
	end

	if not window.IsOpen or window.IsMinimized or window.IsDragging then
		return false
	end

	return true
end

-- floating popups (colorpickers, keybind menus, tooltips) are children of the screen
-- and not of the window, so they have to be switched off by hand whenever the menu
-- leaves the screen. a hidden frame also swallows every mouse event for its children,
-- which is what keeps a closed menu from reacting to anything at all.
local function syncPopups()
	if Lumen.State.Popups then
		Lumen.State.Popups.Visible = canInteract()
	end
end

-- runs every time the menu changes visibility: closes open dropdown lists, stops a
-- keybind that is waiting for a key and re-syncs the floating popups
local function closeTransientUI()
	for _, dropdown in next, Lumen.State.Dropdowns or { } do
		pcall(function()
			dropdown:SetOpen(false)
		end)
	end

	for _, keybind in next, Lumen.State.Keybinds do
		if keybind.Listening then
			pcall(function()
				keybind:StopListening()
			end)
		end
	end

	syncPopups()
end

local function nextFlag()
	Lumen.State.FlagCount = Lumen.State.FlagCount + 1
	return string.format("lumen_unnamed_%d", Lumen.State.FlagCount)
end

local function registerOption(element, flag)
	flag = flag or nextFlag()
	element.Flag = flag
	-- the window that owns this widget: when it is destroyed the option goes with it,
	-- so a replaced menu cannot answer configs or autoload restores any more
	element.Window = Lumen.State.Window
	Lumen.Options[flag] = element
	Lumen.Flags[flag] = element.Value
	return flag
end

-- every value a widget stores passes through here. it is the single place that knows
-- the setup changed, which is what the autosave timer hangs on: no flag write can
-- slip past it.
local autosaveThread = nil

local function scheduleAutosave()
	if not Lumen.State or not Lumen.State.Running then
		return
	end

	-- a menu that is being built only knows its defaults: writing them out would
	-- replace the saved setup with a fresh one every time the window is rebuilt
	if Lumen.State.Building then
		return
	end

	if not Lumen:IsAutosave() then
		return
	end

	if autosaveThread then
		pcall(task.cancel, autosaveThread)
		autosaveThread = nil
	end

	-- a quiet period: dragging a slider writes thirty values a second, the file is
	-- written once when the hand stops
	autosaveThread = task.delay(2, function()
		autosaveThread = nil

		-- the ui may be gone by now, or autosave may have been switched off / taken
		-- over by a named config in the meantime: a stale timer must not write a
		-- snapshot of itself over the file the next launch reads
		if not Lumen.State or not Lumen.State.Running or not Lumen:IsAutosave() then
			return
		end

		Lumen:SaveAutosave()
	end)
end

local function writeFlag(flag, value)
	if flag then
		Lumen.Flags[flag] = value
		scheduleAutosave()
	end
end

local function addThemeRefresher(fn)
	table.insert(Lumen.State.ThemeRefreshers, fn)
end

-- drag / resize / drag-sliders
-- gate: optional predicate. When it returns false the drag never starts (and an
-- active drag stops), which is how the keybind list keeps its "move me" mode honest.
local function makeDraggable(gui, handle, hooks, gate)
	handle = handle or gui

	local dragging = false
	local moved = false
	local dragStart = nil
	local startPos = nil

	connect(handle.InputBegan, function(input)
		if gate and not gate() then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = gui.Position

			if hooks and hooks.Begin then
				hooks.Begin()
			end
		end
	end)

	connect(UserInputService.InputChanged, function(input)
		if not dragging then
			return
		end

		if gate and not gate() then
			dragging = false
			moved = false
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart

		-- a few pixels of slack: a plain click on the handle is not a drag
		if not moved and (math.abs(delta.X) + math.abs(delta.Y)) > 3 then
			moved = true
		end

		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end)

	connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			-- an End is only reported for a drag that actually started on this handle.
			-- any left click released anywhere in the world (menu closed, window hidden)
			-- used to land here too, and the drop ring of the drag fx flashed in the
			-- middle of the screen - that is the outline that showed up "outside the ui".
			local wasDragging = dragging
			local didMove = moved
			dragging = false
			moved = false

			if wasDragging and hooks and hooks.End then
				hooks.End(didMove)
			end
		end
	end)
end

local function makeResizable(gui, handle, minimum)
	local resizing = false
	local dragStart = nil
	local startSize = nil

	connect(handle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			dragStart = input.Position
			startSize = gui.AbsoluteSize
		end
	end)

	connect(UserInputService.InputChanged, function(input)
		if not resizing then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart
		local width = math.max(minimum.X, startSize.X + delta.X)
		local height = math.max(minimum.Y, startSize.Y + delta.Y)

		gui.Size = UDim2.fromOffset(width, height)
	end)

	connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)
end

-- generic "drag inside this gui" -> callback(xRatio, yRatio)
local function dragArea(gui, callback)
	local active = false

	local function stop()
		active = false
	end

	local function handle(position)
		if not canInteract() then
			stop()
			return
		end

		local pos = gui.AbsolutePosition
		local size = gui.AbsoluteSize

		local x = math.clamp((position.X - pos.X) / math.max(size.X, 1), 0, 1)
		local y = math.clamp((position.Y - pos.Y) / math.max(size.Y, 1), 0, 1)

		callback(x, y)
	end

	connect(gui.InputBegan, function(input)
		if not canInteract() then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			active = true
			handle(input.Position)
		end
	end)

	connect(UserInputService.InputChanged, function(input)
		if not active then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			handle(input.Position)
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			stop()
		end
	end)
end

-- colors
local function colorLerp(a, b, t)
	return Color3.new(
		a.R + (b.R - a.R) * t,
		a.G + (b.G - a.G) * t,
		a.B + (b.B - a.B) * t
	)
end

local function brighten(color, amount)
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, math.clamp(s * (1 - amount * 0.4), 0, 1), math.clamp(v + amount, 0, 1))
end

local function darken(color, amount)
	local h, s, v = color:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(v - amount, 0, 1))
end

-- keybind names
local KeyNames = {
	LeftShift = "LShift", RightShift = "RShift",
	LeftControl = "LCtrl", RightControl = "RCtrl",
	LeftAlt = "LAlt", RightAlt = "RAlt",
	MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3",
	Backspace = "None", Escape = "Esc", Return = "Enter",
	One = "1", Two = "2", Three = "3", Four = "4", Five = "5",
	Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0",
	LeftBracket = "[", RightBracket = "]", Semicolon = ";", Comma = ",",
	Period = ".", Slash = "/", BackSlash = "\\", Quote = "'", Minus = "-", Equals = "=",
	PageUp = "PgUp", PageDown = "PgDn", Insert = "Ins", Delete = "Del",
	KeypadOne = "Num1", KeypadTwo = "Num2", KeypadThree = "Num3", KeypadFour = "Num4",
	KeypadFive = "Num5", KeypadSix = "Num6", KeypadSeven = "Num7", KeypadEight = "Num8",
	KeypadNine = "Num9", KeypadZero = "Num0",
}

local function keyName(input)
	if not input then
		return "None"
	end

	local name
	if typeof(input) == "EnumItem" then
		name = input.Name
	else
		name = tostring(input)
	end

	if name == "Unknown" then
		return "None"
	end

	return KeyNames[name] or name
end
--#endregion

--#region themes
Lumen.Themes = {
	-- the house theme: the palette is a starting point, Lumen:SetTheme keeps the
	-- accent, the dim accent and the borders moving (see SetAnimatedTheme)
	["NZL"] = {
		Animated = true, Effect = "rainbow",
		Accent = Color3.fromRGB(0, 224, 198),
		AccentDim = Color3.fromRGB(0, 122, 120),
		Background = Color3.fromRGB(6, 8, 12),
		Sidebar = Color3.fromRGB(8, 10, 15),
		Panel = Color3.fromRGB(13, 17, 24),
		Element = Color3.fromRGB(22, 27, 36),
		ElementHover = Color3.fromRGB(32, 39, 51),
		Border = Color3.fromRGB(30, 40, 52),
		Text = Color3.fromRGB(240, 248, 250),
		TextDim = Color3.fromRGB(126, 142, 152),
		Success = Color3.fromRGB(86, 240, 176),
		Error = Color3.fromRGB(255, 110, 130),
	},

	--// fourth batch: ten more animated variants (neon motel, festival, waterfall, blueprint,
	-- coffee, royalty, red alert, iridescence, zen garden, winter)






	["Alarm"] = {
		Animated = true, Effect = "alarm",
		Accent = Color3.fromRGB(255, 38, 38),
		AccentDim = Color3.fromRGB(140, 20, 20),
		Background = Color3.fromRGB(12, 4, 4),
		Sidebar = Color3.fromRGB(16, 6, 6),
		Panel = Color3.fromRGB(22, 9, 9),
		Element = Color3.fromRGB(32, 14, 14),
		ElementHover = Color3.fromRGB(44, 19, 19),
		Border = Color3.fromRGB(42, 18, 18),
		Text = Color3.fromRGB(255, 232, 232),
		TextDim = Color3.fromRGB(164, 118, 118),
		Success = Color3.fromRGB(140, 220, 140),
		Error = Color3.fromRGB(255, 90, 90),
	},




	--// third batch: ten animated variants from other worlds (radar, retro, paper, weather, sea, candy)




	["Storm"] = {
		Animated = true, Effect = "storm",
		Accent = Color3.fromRGB(176, 206, 255),
		AccentDim = Color3.fromRGB(74, 94, 132),
		Background = Color3.fromRGB(10, 12, 18),
		Sidebar = Color3.fromRGB(13, 16, 23),
		Panel = Color3.fromRGB(18, 22, 31),
		Element = Color3.fromRGB(26, 31, 43),
		ElementHover = Color3.fromRGB(36, 43, 58),
		Border = Color3.fromRGB(34, 40, 55),
		Text = Color3.fromRGB(232, 238, 250),
		TextDim = Color3.fromRGB(124, 134, 156),
		Success = Color3.fromRGB(140, 220, 190),
		Error = Color3.fromRGB(255, 124, 124),
	},





	["Void"] = {
		Animated = true, Effect = "void",
		Accent = Color3.fromRGB(228, 232, 242),
		AccentDim = Color3.fromRGB(108, 112, 124),
		Background = Color3.fromRGB(4, 4, 5),
		Sidebar = Color3.fromRGB(6, 6, 7),
		Panel = Color3.fromRGB(9, 9, 11),
		Element = Color3.fromRGB(15, 15, 18),
		ElementHover = Color3.fromRGB(22, 22, 26),
		Border = Color3.fromRGB(21, 21, 25),
		Text = Color3.fromRGB(238, 240, 246),
		TextDim = Color3.fromRGB(128, 130, 140),
		Success = Color3.fromRGB(186, 204, 196),
		Error = Color3.fromRGB(238, 130, 130),
	},

	--// second batch: twelve more animated variants (batch two of the style engine)





	["Voltage"] = {
		Animated = true, Effect = "voltage",
		Accent = Color3.fromRGB(255, 232, 64),
		AccentDim = Color3.fromRGB(148, 124, 24),
		Background = Color3.fromRGB(13, 12, 5),
		Sidebar = Color3.fromRGB(17, 16, 7),
		Panel = Color3.fromRGB(25, 23, 10),
		Element = Color3.fromRGB(36, 34, 15),
		ElementHover = Color3.fromRGB(49, 46, 22),
		Border = Color3.fromRGB(47, 44, 20),
		Text = Color3.fromRGB(255, 252, 226),
		TextDim = Color3.fromRGB(156, 148, 106),
		Success = Color3.fromRGB(200, 255, 120),
		Error = Color3.fromRGB(255, 96, 96),
	},







	--// ten more animated variants: same engine, different character (see ANIMATED_STYLES)
	["Aurora"] = {
		Animated = true, Effect = "aurora",
		Accent = Color3.fromRGB(120, 240, 200),
		AccentDim = Color3.fromRGB(46, 132, 112),
		Background = Color3.fromRGB(6, 12, 12),
		Sidebar = Color3.fromRGB(8, 15, 15),
		Panel = Color3.fromRGB(13, 22, 22),
		Element = Color3.fromRGB(21, 33, 33),
		ElementHover = Color3.fromRGB(31, 46, 46),
		Border = Color3.fromRGB(28, 44, 44),
		Text = Color3.fromRGB(232, 246, 242),
		TextDim = Color3.fromRGB(122, 146, 142),
		Success = Color3.fromRGB(120, 240, 180),
		Error = Color3.fromRGB(255, 120, 140),
	},


	["Cyber"] = {
		Animated = true, Effect = "cyber",
		Accent = Color3.fromRGB(80, 230, 255),
		AccentDim = Color3.fromRGB(30, 96, 130),
		Background = Color3.fromRGB(5, 7, 13),
		Sidebar = Color3.fromRGB(7, 9, 16),
		Panel = Color3.fromRGB(11, 14, 24),
		Element = Color3.fromRGB(18, 22, 36),
		ElementHover = Color3.fromRGB(27, 33, 51),
		Border = Color3.fromRGB(26, 34, 55),
		Text = Color3.fromRGB(236, 245, 255),
		TextDim = Color3.fromRGB(120, 132, 156),
		Success = Color3.fromRGB(120, 255, 200),
		Error = Color3.fromRGB(255, 110, 170),
	},








	["Azure"] = {
		Accent = Color3.fromRGB(96, 168, 255),
		AccentDim = Color3.fromRGB(52, 92, 150),
		Background = Color3.fromRGB(10, 12, 16),
		Sidebar = Color3.fromRGB(10, 12, 16),
		Panel = Color3.fromRGB(19, 22, 27),
		Element = Color3.fromRGB(29, 33, 40),
		ElementHover = Color3.fromRGB(40, 45, 54),
		Border = Color3.fromRGB(34, 38, 46),
		Text = Color3.fromRGB(235, 240, 246),
		TextDim = Color3.fromRGB(132, 140, 152),
		Success = Color3.fromRGB(110, 230, 170),
		Error = Color3.fromRGB(255, 116, 116),
	},

	["Midnight"] = {
		Accent = Color3.fromRGB(140, 178, 255),
		AccentDim = Color3.fromRGB(72, 98, 158),
		Background = Color3.fromRGB(10, 10, 12),
		Sidebar = Color3.fromRGB(13, 13, 16),
		Panel = Color3.fromRGB(18, 18, 21),
		Element = Color3.fromRGB(29, 29, 34),
		ElementHover = Color3.fromRGB(40, 40, 46),
		Border = Color3.fromRGB(33, 33, 39),
		Text = Color3.fromRGB(236, 236, 240),
		TextDim = Color3.fromRGB(134, 134, 143),
		Success = Color3.fromRGB(96, 226, 148),
		Error = Color3.fromRGB(255, 116, 116),
	},

	["Amethyst"] = {
		Accent = Color3.fromRGB(186, 142, 255),
		AccentDim = Color3.fromRGB(104, 76, 156),
		Background = Color3.fromRGB(11, 10, 14),
		Sidebar = Color3.fromRGB(15, 13, 19),
		Panel = Color3.fromRGB(20, 18, 26),
		Element = Color3.fromRGB(32, 29, 41),
		ElementHover = Color3.fromRGB(44, 40, 56),
		Border = Color3.fromRGB(37, 34, 47),
		Text = Color3.fromRGB(238, 235, 245),
		TextDim = Color3.fromRGB(138, 132, 152),
		Success = Color3.fromRGB(126, 231, 175),
		Error = Color3.fromRGB(255, 122, 150),
	},

	["Emerald"] = {
		Accent = Color3.fromRGB(104, 226, 170),
		AccentDim = Color3.fromRGB(56, 128, 96),
		Background = Color3.fromRGB(9, 12, 11),
		Sidebar = Color3.fromRGB(12, 16, 15),
		Panel = Color3.fromRGB(17, 22, 20),
		Element = Color3.fromRGB(27, 35, 32),
		ElementHover = Color3.fromRGB(37, 47, 43),
		Border = Color3.fromRGB(31, 41, 38),
		Text = Color3.fromRGB(232, 242, 238),
		TextDim = Color3.fromRGB(128, 148, 141),
		Success = Color3.fromRGB(110, 240, 170),
		Error = Color3.fromRGB(255, 128, 118),
	},

	["Crimson"] = {
		Accent = Color3.fromRGB(255, 116, 116),
		AccentDim = Color3.fromRGB(148, 64, 68),
		Background = Color3.fromRGB(13, 10, 10),
		Sidebar = Color3.fromRGB(17, 13, 13),
		Panel = Color3.fromRGB(23, 18, 18),
		Element = Color3.fromRGB(36, 28, 28),
		ElementHover = Color3.fromRGB(49, 38, 38),
		Border = Color3.fromRGB(42, 33, 33),
		Text = Color3.fromRGB(244, 236, 236),
		TextDim = Color3.fromRGB(152, 132, 134),
		Success = Color3.fromRGB(120, 230, 160),
		Error = Color3.fromRGB(255, 96, 96),
	},

	["Mono"] = {
		Accent = Color3.fromRGB(232, 232, 236),
		AccentDim = Color3.fromRGB(122, 122, 130),
		Background = Color3.fromRGB(9, 9, 10),
		Sidebar = Color3.fromRGB(12, 12, 13),
		Panel = Color3.fromRGB(17, 17, 19),
		Element = Color3.fromRGB(28, 28, 31),
		ElementHover = Color3.fromRGB(39, 39, 43),
		Border = Color3.fromRGB(32, 32, 36),
		Text = Color3.fromRGB(238, 238, 240),
		TextDim = Color3.fromRGB(132, 132, 140),
		Success = Color3.fromRGB(200, 230, 200),
		Error = Color3.fromRGB(240, 160, 160),
	},

	["Sunset"] = {
		Accent = Color3.fromRGB(255, 166, 102),
		AccentDim = Color3.fromRGB(150, 92, 56),
		Background = Color3.fromRGB(15, 11, 10),
		Sidebar = Color3.fromRGB(15, 11, 10),
		Panel = Color3.fromRGB(24, 18, 16),
		Element = Color3.fromRGB(36, 28, 25),
		ElementHover = Color3.fromRGB(48, 38, 34),
		Border = Color3.fromRGB(42, 33, 30),
		Text = Color3.fromRGB(246, 238, 232),
		TextDim = Color3.fromRGB(152, 138, 130),
		Success = Color3.fromRGB(140, 230, 160),
		Error = Color3.fromRGB(255, 110, 110),
	},

	["Sakura"] = {
		Accent = Color3.fromRGB(255, 158, 194),
		AccentDim = Color3.fromRGB(150, 88, 112),
		Background = Color3.fromRGB(15, 10, 13),
		Sidebar = Color3.fromRGB(15, 10, 13),
		Panel = Color3.fromRGB(24, 17, 21),
		Element = Color3.fromRGB(36, 26, 32),
		ElementHover = Color3.fromRGB(48, 36, 43),
		Border = Color3.fromRGB(42, 31, 37),
		Text = Color3.fromRGB(246, 236, 242),
		TextDim = Color3.fromRGB(150, 132, 142),
		Success = Color3.fromRGB(140, 230, 170),
		Error = Color3.fromRGB(255, 110, 120),
	},

	["Gold"] = {
		Accent = Color3.fromRGB(255, 214, 120),
		AccentDim = Color3.fromRGB(150, 122, 66),
		Background = Color3.fromRGB(14, 12, 9),
		Sidebar = Color3.fromRGB(14, 12, 9),
		Panel = Color3.fromRGB(23, 20, 15),
		Element = Color3.fromRGB(35, 31, 24),
		ElementHover = Color3.fromRGB(47, 42, 33),
		Border = Color3.fromRGB(41, 37, 29),
		Text = Color3.fromRGB(246, 240, 228),
		TextDim = Color3.fromRGB(150, 142, 124),
		Success = Color3.fromRGB(150, 230, 160),
		Error = Color3.fromRGB(255, 110, 100),
	},

	["Ocean"] = {
		Accent = Color3.fromRGB(92, 225, 220),
		AccentDim = Color3.fromRGB(52, 128, 126),
		Background = Color3.fromRGB(9, 13, 14),
		Sidebar = Color3.fromRGB(9, 13, 14),
		Panel = Color3.fromRGB(16, 22, 23),
		Element = Color3.fromRGB(25, 34, 35),
		ElementHover = Color3.fromRGB(35, 46, 47),
		Border = Color3.fromRGB(30, 40, 41),
		Text = Color3.fromRGB(232, 244, 244),
		TextDim = Color3.fromRGB(128, 148, 148),
		Success = Color3.fromRGB(120, 240, 180),
		Error = Color3.fromRGB(255, 120, 120),
	},
}

-- default theme
Lumen.DefaultTheme = "Azure"
Lumen.ThemeName = Lumen.DefaultTheme
Lumen.Theme = { }

for key, value in next, Lumen.Themes[Lumen.DefaultTheme] do
	Lumen.Theme[key] = value
end

Lumen.State.ThemePreset = Lumen.ThemeName

local function themed(instance, property, key)
	instance[property] = Lumen.Theme[key]
	table.insert(Lumen.State.ThemeRegistry, {
		Instance = instance,
		Property = property,
		Key = key,
		-- nearly every widget is themed after it was parented; the few that are not
		-- (a keybind swatch, for instance) are checked again on the next theme pass
		Parented = instance.Parent ~= nil,
	})
	return instance
end

-- widgets that were destroyed (their window was replaced, a page was torn down) must
-- not be walked on every theme change: the registry is pruned as it is used, which is
-- exactly when the cost of stale entries would show up
local function pruneThemeRegistry()
	local registry = Lumen.State.ThemeRegistry
	local index = 1

	while index <= #registry do
		local entry = registry[index]
		local instance = entry and entry.Instance

		if instance and instance.Parent then
			-- alive and in the tree: remember it, so it becomes prunable later
			entry.Parented = true
			index = index + 1
		elseif instance and not entry.Parented then
			-- still being built (a keybind swatch is themed before it is parented):
			-- keep it, it is not dead
			index = index + 1
		else
			table.remove(registry, index)
		end
	end
end

-- precise cleanup: everything inside a subtree that is about to be destroyed is
-- dropped from the registry, instead of being walked on every later theme change
local function pruneThemeSubtree(root)
	if not root then
		return
	end

	local registry = Lumen.State.ThemeRegistry
	local index = 1

	while index <= #registry do
		local entry = registry[index]
		local instance = entry and entry.Instance
		local inside = false

		if instance then
			if instance == root then
				inside = true
			else
				local ok, result = pcall(function()
					return instance:IsDescendantOf(root)
				end)
				inside = ok and result == true
			end
		end

		if inside then
			table.remove(registry, index)
		else
			index = index + 1
		end
	end
end

local function applyTheme()
	pruneThemeRegistry()

	for _, entry in next, Lumen.State.ThemeRegistry do
		pcall(function()
			entry.Instance[entry.Property] = Lumen.Theme[entry.Key]
		end)
	end

	for _, fn in next, Lumen.State.ThemeRefreshers do
		safe(fn)
	end
end

local function syncThemeUI()
	for _, entry in next, Lumen.State.ThemePickers or { } do
		if Lumen.Theme[entry.Key] then
			entry.Picker:Set(Lumen.Theme[entry.Key], nil, true)
		end
	end

	for _, dropdown in next, Lumen.State.ThemePresets or { } do
		dropdown:Set(Lumen.ThemeName, true)
	end
end

--// the special theme ("NZL"): the palette moves and the brand flies
-- one timer exists while that theme is on. it repaints the accent coloured instances
-- (a subset of the theme registry, rebuilt when the registry grows) and repaints the
-- brand / list header as a rainbow that bobs up and down. nothing runs otherwise.
local ANIMATED_KEYS = { Accent = true, AccentDim = true, Border = true }
local animatedSubset = { Size = -1, List = { } }
local animatedThread = nil
local flyingText = setmetatable({ }, { __mode = "k" })

-- every animated theme picks a character through its "Effect". "cycle" walks the whole
-- colour wheel, "wave" rocks between two hues; the particles can rise or fall, the
-- sheen can be a slow glass glare or a fast shimmer, and a scan line can sweep the
-- window like a crt. numbers are per second / per tick as noted.
local ANIMATED_STYLES = {
	rainbow = {
		HueMode = "cycle", HueSpeed = 0.13,
		Sat = 0.78, Val = 1, DimSat = 0.7, DimVal = 0.55, BorderSat = 0.45, BorderVal = 0.42,
		Particles = 18, ParticleSpeed = 0.065, ParticleSway = 0.006,
		SheenSpeed = 0.32, SheenWidth = 0.34, SheenCount = 2, BorderSpin = 26, GearSpin = 45,
		Fly = true, FlyBob = 3, FlySpeed = 2.2, TabPulse = 2.6, WatermarkSpread = 0.2,
	},
	aurora = {
		HueMode = "wave", HueFrom = 0.28, HueSpan = 0.38, HueSpeed = 0.045,
		Sat = 0.62, Val = 0.98, DimSat = 0.55, DimVal = 0.5, BorderSat = 0.42, BorderVal = 0.46,
		Particles = 26, ParticleSpeed = 0.03, ParticleSway = 0.02,
		SheenSpeed = 0.11, SheenWidth = 0.5, SheenCount = 2, BorderSpin = 10, GearSpin = 22,
		Fly = true, FlyBob = 2, FlySpeed = 1.4, TabPulse = 1.4, WatermarkSpread = 0.05,
	},
	cyber = {
		HueMode = "wave", HueFrom = 0.42, HueSpan = 0.2, HueSpeed = 0.55,
		Sat = 0.9, Val = 1, DimSat = 0.8, DimVal = 0.6, BorderSat = 0.7, BorderVal = 0.5,
		Particles = 22, ParticleSpeed = 0.14, ParticleSway = 0.004,
		SheenSpeed = 0.85, SheenWidth = 0.2, SheenCount = 2, BorderSpin = 60, GearSpin = 130,
		Fly = true, FlyBob = 4, FlySpeed = 3.4, TabPulse = 4.5, WatermarkSpread = 0.4,
		Scan = 0.5,
	},
	--// second batch: twelve more characters
	voltage = {
		HueMode = "wave", HueFrom = 0.12, HueSpan = 0.08, HueSpeed = 0.7,
		Sat = 0.9, Val = 1, DimSat = 0.8, DimVal = 0.55, BorderSat = 0.7, BorderVal = 0.5,
		Particles = 20, ParticleSpeed = 0.22, ParticleSway = 0.002,
		SheenSpeed = 0.9, SheenWidth = 0.16, SheenCount = 2, BorderSpin = 80, GearSpin = 150,
		Fly = true, FlyBob = 4.5, FlySpeed = 5, Twinkle = 5, TabPulse = 6,
		WatermarkSpread = 0.35, Scan = 0.55,
	},
	--// third batch: ten characters from other worlds (military, retro, paper, weather, sea, candy)
	storm = {
		HueMode = "wave", HueFrom = 0.58, HueSpan = 0.08, HueSpeed = 0.06,
		Sat = 0.35, Val = 0.9, DimSat = 0.4, DimVal = 0.5, BorderSat = 0.3, BorderVal = 0.45,
		Particles = 28, ParticleSpeed = 0.24, ParticleSway = 0.008,
		SheenSpeed = 0.1, SheenWidth = 0.8, SheenCount = 1, BorderSpin = 6, GearSpin = 14,
		Fly = true, Fall = true, Streak = true, FlyBob = 1.6, FlySpeed = 1.4,
		TabPulse = 1.5, WatermarkSpread = 0.12, Flash = 5.5,
	},
	void = {
		HueMode = "wave", HueFrom = 0.6, HueSpan = 0.03, HueSpeed = 0.015,
		Sat = 0.06, Val = 1, DimSat = 0.1, DimVal = 0.3, BorderSat = 0.05, BorderVal = 0.3,
		Particles = 6, ParticleSpeed = 0.022, ParticleSway = 0.002,
		SheenSpeed = 0.04, SheenWidth = 1, SheenCount = 1, BorderSpin = 0, GearSpin = 6,
		Fly = true, FlyBob = 0.8, FlySpeed = 0.6, FlySat = 0.06, TabPulse = 0.6,
		ValPulse = 0.06, WatermarkSpread = 0.05,
	},
	--// fourth batch: ten more worlds (neon motel, festival, waterfall, blueprint, coffee,
	-- royalty, red alert, iridescence, zen garden, winter)
	alarm = {
		HueMode = "wave", HueFrom = 0, HueSpan = 0.02, HueSpeed = 0.4,
		Sat = 1, Val = 1, DimSat = 0.9, DimVal = 0.5, BorderSat = 0.9, BorderVal = 0.5,
		Particles = 18, ParticleSpeed = 0.13, ParticleSway = 0.006,
		SheenSpeed = 0.9, SheenWidth = 0.2, SheenCount = 2, BorderSpin = 120, GearSpin = 180,
		Fly = true, FlyBob = 3.4, FlySpeed = 4, TabPulse = 5.5,
		WatermarkSpread = 0.4, Strobe = 1.4, Scan = 0.45,
	},
}

local currentStyle = ANIMATED_STYLES.rainbow

local function styleFor(theme)
	local name = theme and (theme.Effect or theme.effect)
	return ANIMATED_STYLES[name] or ANIMATED_STYLES.rainbow
end

local function animatedEntries()
	local registry = Lumen.State.ThemeRegistry

	if animatedSubset.Size ~= #registry then
		local list = { }
		for _, entry in next, registry do
			if ANIMATED_KEYS[entry.Key] then
				table.insert(list, entry)
			end
		end

		animatedSubset.Size = #registry
		animatedSubset.List = list
	end

	return animatedSubset.List
end

-- every character gets its own hue, so a single letter does not repaint the line
local function rainbowText(text, baseHue, spread, saturation)
	local length = math.max(utf8.len(text) or #text, 1)
	local pieces = { }
	local index = 0

	for _, code in utf8.codes(text) do
		local hue = (baseHue + index / length * spread) % 1
		table.insert(pieces, string.format('<font color="#%s">%s</font>',
			Color3.fromHSV(hue, saturation or 0.82, 1):ToHex(), utf8.char(code)))
		index = index + 1
	end

	return table.concat(pieces)
end

local function flyLabel(label, clock, hue, style)
	if not label or not label.Parent then
		return
	end

	local base = flyingText[label]
	if not base then
		base = {
			X = label.Position.X.Offset,
			Y = label.Position.Y.Offset,
			Text = label.Text,
		}
		flyingText[label] = base
	end

	label.RichText = true
	label.Text = rainbowText(base.Text, hue, style.FlySpread or 0.6, style.FlySat)
	label.Position = UDim2.fromOffset(base.X,
		base.Y + math.sin(clock * (style.FlySpeed or 2.2)) * (style.FlyBob or 3))
end

--// the decoration of an animated theme: ambient particles inside the window, a soft
-- light sweep, a scan line for the crt flavoured ones and a rotating gradient on the
-- window border. created when the theme starts, destroyed when it stops, so nothing
-- survives a theme switch or an unload.
local animatedParticles = nil
local animatedSheens = nil
local animatedScans = nil

-- stable pseudo random: the same theme gives the same drift in every run (and in tests)
local function sparkle(seed, index)
	local value = (seed * 97 + index * 37) % 1000
	return value / 1000
end

local function stopAnimatedDecor()
	for _, list in next, { animatedParticles, animatedSheens, animatedScans } do
		for _, item in next, list or { } do
			pcall(function()
				item.Frame:Destroy()
			end)
		end
	end

	animatedParticles = nil
	animatedSheens = nil
	animatedScans = nil
end

local function startAnimatedDecor(window, style)
	stopAnimatedDecor()

	local main = window and window.Items and window.Items.Main
	if not main then
		return
	end

	style = style or currentStyle

	animatedParticles = { }
	for index = 1, (style.Particles or 18) do
		local size = 2 + math.floor(sparkle(7, index) * 3)
		-- a "streak" character draws falling lines of rain instead of round motes
		local frameSize = style.Streak and UDim2.fromOffset(2, size * 4) or UDim2.fromOffset(size, size)
		local frame = new("Frame", {
			Parent = main,
			Name = "nzl_spark",
			Size = frameSize,
			Position = UDim2.fromScale(sparkle(3, index), sparkle(11, index)),
			BackgroundColor3 = Lumen.Theme.Accent,
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 12,
		})
		corner(frame, style.Streak and 2 or (math.floor(size / 2) + 1))

		table.insert(animatedParticles, {
			Frame = frame,
			Index = index,
			X = sparkle(3, index),
			Y = sparkle(11, index),
			-- a full trip across the window takes 4-18 seconds depending on the theme
			Speed = (style.ParticleSpeed or 0.065) * (0.7 + sparkle(23, index) * 1.1),
			Sway = (style.ParticleSway or 0.006) * (0.5 + sparkle(41, index) * 1.5),
			Phase = sparkle(53, index) * 6.28,
		})
	end

	-- the border carries a two colour gradient that is rotated from the tick: the
	-- outline of the window looks like it is breathing
	local borderGradient = nil
	local mainStroke = nil
	for _, child in next, main:GetChildren() do
		if child.ClassName == "UIStroke" then
			mainStroke = child
		end
	end

	if mainStroke and (style.BorderSpin or 0) > 0 then
		borderGradient = new("UIGradient", {
			Parent = mainStroke,
			Color = ColorSequence.new(Lumen.Theme.Accent, Lumen.Theme.Border),
			Rotation = 0,
		})
	end

	animatedSheens = { }
	-- three layers a glare can travel over: the glass of the window, the title bar and
	-- the page area. a character asks for one, two or three of them.
	local sheenTargets = {
		{ main, 13, 0.9 },
		{ window.Items.Header, 4, 0.93 },
		{ window.Items.Content, 2, 0.95 },
	}
	for index = 1, (style.SheenCount or 2) do
		local target = sheenTargets[index]
		if not target then
			break
		end

		local parent, zindex, transparency = target[1], target[2], target[3]
		local width = style.SheenWidth or 0.34
		local vertical = style.SheenVertical and true or false

		if parent then
			local frame = new("Frame", {
				Parent = parent,
				Name = "nzl_sheen",
				Size = vertical and UDim2.new(1, 0, width, 0) or UDim2.new(width, 0, 1, 0),
				Position = vertical and UDim2.fromScale(0, -width) or UDim2.fromScale(-width, 0),
				BackgroundColor3 = Lumen.Theme.Accent,
				BackgroundTransparency = transparency,
				BorderSizePixel = 0,
				Active = false,
				ZIndex = zindex,
			})
			new("UIGradient", {
				Parent = frame,
				Rotation = vertical and 110 or 20,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
			})

			table.insert(animatedSheens, {
				Frame = frame, Width = width, Vertical = vertical,
				Speed = index == 1 and 1 or 0.5,
			})
		end
	end

	-- crt flavoured themes get a line that walks down the window
	animatedScans = { }
	if style.Scan then
		local scan = new("Frame", {
			Parent = main,
			Name = "nzl_scan",
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.fromScale(0, 0),
			BackgroundColor3 = Lumen.Theme.Accent,
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			Active = false,
			ZIndex = 14,
		})

		table.insert(animatedScans, { Frame = scan })
	end

	if borderGradient then
		table.insert(animatedSheens, { Frame = borderGradient, Width = 0, Border = true })
	end
end

local function parkLabel(label)
	local base = flyingText[label]
	if not base then
		return
	end

	if label.Parent then
		label.Text = base.Text
		label.Position = UDim2.fromOffset(base.X, base.Y)
	end

	flyingText[label] = nil
end

local function stopAnimatedTheme()
	Lumen.State.AnimatedTheme = false

	for label in next, flyingText do
		parkLabel(label)
	end

	stopAnimatedDecor()

	local window = Lumen.State.Window
	local gear = window and window.Items and window.Items.BrandIcon
	if gear then
		gear.Rotation = 0
	end

	for _, page in next, (window and window.Pages) or { } do
		local accentBar = page.Items and page.Items.TabAccent
		if accentBar then
			accentBar.Size = UDim2.fromOffset(2, 14)
			accentBar.BackgroundTransparency = 0
		end
	end

	if animatedThread then
		pcall(task.cancel, animatedThread)
		animatedThread = nil
	end
end

local function accentFor(style, clock)
	local hue

	if style.HueMode == "cycle" then
		hue = (style.HueFrom or 0) + clock * style.HueSpeed
	else
		local wave = 0.5 + 0.5 * math.sin(clock * style.HueSpeed * math.pi * 2)
		hue = (style.HueFrom or 0) + style.HueSpan * wave
	end

	local value = style.Val - (style.ValPulse or 0) * (0.5 + 0.5 * math.sin(clock * 1.7))
	local saturation = style.Sat

	-- a storm flavoured character strikes every few seconds: for a fraction of the
	-- cycle the accent jumps to full brightness, the way a lightning bolt lights a room
	if style.Flash then
		if (clock % style.Flash) < 0.14 then
			value = 1
			saturation = math.min(1, saturation + 0.35)
		end
	end

	-- a broken-neon character instead drops almost to black for a moment: the sign
	-- flickers the way a dying tube does
	if style.Strobe then
		local cycle = clock % style.Strobe
		if cycle < style.Strobe * 0.22 or (cycle > style.Strobe * 0.32 and cycle < style.Strobe * 0.4) then
			value = value * 0.18
		end
	end

	return hue % 1, value, saturation
end

local function startAnimatedTheme()
	stopAnimatedTheme()

	local theme = Lumen.Themes[Lumen.ThemeName]
	local style = styleFor(theme)
	currentStyle = style

	Lumen.State.AnimatedTheme = true

	local state = Lumen.State
	local slice = 0

	animatedThread = task.spawn(function()
		local window = state.Window
		local main = window and window.Items and window.Items.Main
		if main then
			startAnimatedDecor(window, style)
		end

		while state.Running and state.AnimatedTheme do
			local clock = os.clock()
			local hue, value, saturation = accentFor(style, clock)

			Lumen.Theme.Accent = Color3.fromHSV(hue, saturation, value)
			Lumen.Theme.AccentDim = Color3.fromHSV(hue, style.DimSat, style.DimVal)
			Lumen.Theme.Border = Color3.fromHSV((hue + 0.08) % 1, style.BorderSat, style.BorderVal)

			-- a big hub has hundreds of accent coloured instances: after the first,
			-- full pass they are repainted in thirds, so a tick touches a third of
			-- them and the drift still reads as continuous (three ticks are 0.15 s).
			-- task.spawn runs the body right away, so that first pass is what makes
			-- the widgets match the palette the moment SetTheme returns.
			local entries = animatedEntries()
			local from, to = 1, #entries

			if slice > 0 then
				local per = math.max(1, math.ceil(#entries / 3))
				from = (slice - 1) * per + 1
				to = math.min(slice * per, #entries)
			end

			slice = slice % 3 + 1

			for index = from, to do
				local entry = entries[index]
				pcall(function()
					entry.Instance[entry.Property] = Lumen.Theme[entry.Key]
				end)
			end

			window = state.Window
			if window and window.Alive and window.Items then
				if style.Fly then
					flyLabel(window.Items.BrandTitle, clock, (clock * 0.3) % 1, style)
				end

				-- the brand gear turns, the particles drift, the light sweeps
				local gear = window.Items.BrandIcon
				if gear and style.GearSpin ~= 0 then
					gear.Rotation = (clock * style.GearSpin) % 360
				end

				-- the marker of the tab you are on breathes: a small reminder of which
				-- page is open without touching the text
				if style.TabPulse then
					local pulse = (math.sin(clock * style.TabPulse) + 1) * 0.5
					for _, page in next, window.Pages or { } do
						local accentBar = page.Items and page.Items.TabAccent
						if accentBar and page.Active then
							accentBar.Size = UDim2.fromOffset(2, math.floor(11 + pulse * 10))
							accentBar.BackgroundTransparency = 0.1 - pulse * 0.1
						end
					end
				end

				for _, particle in next, animatedParticles or { } do
					local frame = particle.Frame
					if frame and frame.Parent then
						local step = particle.Speed * 0.05

						if style.Fall then
							particle.Y = particle.Y + step
							if particle.Y > 1.05 then
								particle.Y = -0.05
							end
						else
							particle.Y = particle.Y - step
							if particle.Y < -0.05 then
								particle.Y = 1.05
							end
						end

						frame.Position = UDim2.fromScale(
							particle.X + math.sin(clock * 0.8 + particle.Phase) * particle.Sway,
							particle.Y
						)
						if style.ParticleHueShift then
							-- every mote sits on its own step of the wheel: confetti
							frame.BackgroundColor3 = Color3.fromHSV(
								(hue + particle.Index * style.ParticleHueShift) % 1, style.Sat, 1)
						else
							frame.BackgroundColor3 = Lumen.Theme.Accent
						end
						frame.BackgroundTransparency = 0.35
							+ math.abs(math.sin(clock * (style.Twinkle or 1.4) + particle.Phase)) * 0.4
					end
				end

				for _, sheen in next, animatedSheens or { } do
					if sheen.Border then
						sheen.Frame.Rotation = (clock * (style.BorderSpin or 26)) % 360
						sheen.Frame.Color = ColorSequence.new(Lumen.Theme.Accent, Lumen.Theme.Border)
					else
						local speed = (style.SheenSpeed or 0.32) * (sheen.Speed or 1)
						local progress = (clock * speed + (sheen.Speed == 0.5 and 0.4 or 0)) % 1
						local travel = -sheen.Width + progress * (1 + sheen.Width)

						if sheen.Vertical then
							sheen.Frame.Position = UDim2.fromScale(0, travel)
						else
							sheen.Frame.Position = UDim2.fromScale(travel, 0)
						end
						sheen.Frame.BackgroundColor3 = Lumen.Theme.Accent
					end
				end

				for _, scan in next, animatedScans or { } do
					local progress = (clock * (style.Scan or 0.3)) % 1
					scan.Frame.Position = UDim2.fromScale(0, progress)
					scan.Frame.BackgroundColor3 = Lumen.Theme.Accent
					scan.Frame.BackgroundTransparency = 0.35 + math.abs(progress - 0.5) * 0.6
				end
			end

			local list = state.KeybindsList
			if list and list.Items and style.Fly then
				flyLabel(list.Items.HeaderText, clock, (clock * 0.3 + 0.35) % 1, style)
			end

			-- the watermark keeps its text (the ping loop writes it), so it only
			-- changes colour here
			-- WatermarkSpread says how much of the animated colour the mark picks up:
			-- 0.04 (terminal, almost plain) .. 0.4 (cyber, loudly tinted)
			local mark = state.Watermark
			if mark and mark.Items and mark.Items.Label then
				local spread = style.WatermarkSpread or 0.14
				mark.Items.Label.TextColor3 = Color3.fromHSV(hue, math.clamp(0.4 + spread * 1.1, 0.05, 1), 1)
			end

			task.wait(0.05)
		end
	end)
end

function Lumen:GetAnimatedEffect()
	if not Lumen.State.AnimatedTheme then
		return nil
	end

	local theme = Lumen.Themes[Lumen.ThemeName]
	return theme and (theme.Effect or "rainbow") or nil
end

function Lumen:IsAnimatedTheme()
	return Lumen.State.AnimatedTheme == true
end

function Lumen:SetTheme(name)
	local theme = Lumen.Themes[name]
	if not theme then
		return false
	end

	-- parking the old animation before the new colours land, otherwise the last
	-- rainbow frame would be written over the freshly applied theme
	stopAnimatedTheme()

	Lumen.ThemeName = name
	Lumen.State.ThemePreset = name
	for key, value in next, theme do
		-- only colours are copied: a theme may carry flags (Animated) as well
		if typeof(value) == "Color3" then
			Lumen.Theme[key] = value
		end
	end

	applyTheme()
	syncThemeUI()

	if theme.Animated then
		startAnimatedTheme()
	end

	return true
end

local function syncThemeColor(key, color)
	for _, entry in next, Lumen.State.ThemePickers or { } do
		if entry.Key == key then
			entry.Picker:Set(color, nil, true)
		end
	end
end

function Lumen:SetColor(key, color)
	if Lumen.Theme[key] == nil or typeof(color) ~= "Color3" then
		return false
	end

	-- a hand picked colour beats the moving palette: the animation stops and the base
	-- colours of the preset come back, so the pick lands on a still theme instead of
	-- being overwritten by the next tick. a config being restored is not a hand pick,
	-- so it leaves the animation alone.
	if Lumen.State.AnimatedTheme and not Lumen.State.ApplyingConfig and not Lumen.State.Building then
		local base = Lumen.Themes[Lumen.ThemeName]
		stopAnimatedTheme()

		if base then
			for baseKey, value in next, base do
				if typeof(value) == "Color3" then
					Lumen.Theme[baseKey] = value
				end
			end
		end
	end

	Lumen.Theme[key] = color
	applyTheme()
	syncThemeColor(key, color)
	return true
end

function Lumen:SetAccent(color)
	if typeof(color) ~= "Color3" then
		return false
	end

	local hue, saturation, value = color:ToHSV()

	Lumen.Theme.Accent = color
	Lumen.Theme.AccentDim = Color3.fromHSV(hue, saturation, math.clamp(value - 0.25, 0.05, 1))

	applyTheme()
	return true
end

function Lumen:GetTheme()
	local copy = { }
	for key, value in next, Lumen.Theme do
		copy[key] = value
	end
	return copy
end

-- window transparency / toast duration (settings -> appearance)

function Lumen:SetWindowTransparency(value)
	value = math.clamp(tonumber(value) or 0, 0, 0.85)
	Lumen.WindowTransparency = value

	local window = Lumen.State.Window
	if window and window.SetTransparency then
		pcall(function()
			window:SetTransparency(value)
		end)
	end

	return value
end

function Lumen:GetWindowTransparency()
	return Lumen.WindowTransparency or 0
end

function Lumen:SetNotificationDuration(seconds)
	Lumen.NotificationDuration = math.clamp(tonumber(seconds) or 4, 1, 20)
	return Lumen.NotificationDuration
end
--#endregion

--#region folders / files
local function ensureFolders()
	for _, folder in next, { Lumen.Folder, Lumen.ConfigFolder, Lumen.ThemeFolder } do
		if not isfolder(folder) then
			pcall(makefolder, folder)
		end
	end
end

local function stripFolder(path, folder)
	local cleaned = tostring(path):gsub("\\", "/")
	cleaned = cleaned:match("([^/]+)$") or cleaned
	cleaned = cleaned:gsub("%.json$", "")
	return cleaned
end

-- bare config/theme name: drops any folder junk and the .json suffix
local function cleanName(name)
	local cleaned = tostring(name):gsub("\\", "/")
	cleaned = cleaned:match("([^/]+)$") or cleaned
	cleaned = cleaned:gsub("%.json$", "")
	return cleaned
end

-- safe readfile: never throws on missing files
local function readText(path)
	if not isfile(path) then
		return ""
	end
	local ok, content = pcall(readfile, path)
	return ok and tostring(content) or ""
end

-- locate a saved file across current and legacy folders
local function findSaved(base, folders)
	if base == "" then
		return nil
	end
	for _, folder in next, folders do
		local path = folder .. "/" .. base .. ".json"
		if isfile(path) then
			return path
		end
	end
	return nil
end

local function filesIn(folder)
	local result = { }
	local ok, files = pcall(listfiles, folder)
	if not ok or type(files) ~= "table" then
		return result
	end

	for _, path in next, files do
		table.insert(result, stripFolder(tostring(path), folder))
	end

	table.sort(result)
	return result
end
--#endregion

--#region root gui
function Lumen:EnsureRoot()
	if Lumen.State.Ready then
		return Lumen.State.Screen
	end

	ensureFolders()

	local screen = new("ScreenGui", {
		Name = "lumen_ui",
		Parent = guiParent(),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 9999,
		IgnoreGuiInset = true,
	})

	Lumen.State.Screen = screen

	-- floating popups (colorpickers, keybind menus, tooltips) live here so they are
	-- never clipped. they start hidden and are switched on by the window: while the
	-- menu is closed this frame stays invisible, which also mutes every mouse event
	-- for the popups inside it.
	local popups = new("Frame", {
		Parent = screen,
		Name = "Popups",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 50,
	})
	Lumen.State.Popups = popups

	-- notifications (top right)
	local notifications = new("Frame", {
		Parent = screen,
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 12),
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		ZIndex = 90,
	})

	list(notifications, {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, 8),
	})

	Lumen.State.Notifications = notifications
	Lumen.State.Ready = true

	return screen
end

local function attachTooltip(gui, text)
	if not text or text == "" or type(text) ~= "string" then
		return
	end

	local tip = nil
	local mover = nil

	connect(gui.MouseEnter, function()
		-- a tooltip may only exist over a menu that is actually on screen
		if tip or not canInteract() then
			return
		end

		tip = new("Frame", {
			Parent = Lumen.State.Popups,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = Lumen.Theme.Panel,
			BorderSizePixel = 0,
			ZIndex = 95,
		})
		themed(tip, "BackgroundColor3", "Panel")
		corner(tip, 5)
		local tipStroke = stroke(tip, Lumen.Theme.Border, 1, 0.3)
		themed(tipStroke, "Color", "Border")
		padding(tip, 5, 6, 8, 8)

		local label = new("TextLabel", {
			Parent = tip,
			Size = UDim2.fromOffset(220, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = text,
			TextWrapped = true,
			TextSize = 12,
			Font = Lumen.Font,
			RichText = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			ZIndex = 96,
		})
		themed(label, "TextColor3", "TextDim")

		mover = connectTransient(RunService.RenderStepped, function()
			if not tip or not tip.Parent then
				return
			end

			local mouse = UserInputService:GetMouseLocation()
			tip.Position = UDim2.fromOffset(mouse.X + 14, mouse.Y - 10)
		end)
	end)

	connect(gui.MouseLeave, function()
		if mover then
			disconnectTransient(mover)
			mover = nil
		end
		if tip then
			tip:Destroy()
			tip = nil
		end
	end)
end
--#endregion

--#region components
-- forward declarations (toggles/labels can host keybinds + colorpickers)
local CreateKeybindButton, CreateColorpickerSwatch

local function addSearchEntry(page, name, object, section)
	if not page or not page.Elements then
		return
	end

	if section and section.Content then
		page.Dividers = page.Dividers or { }

		local order = section.RowOrder or 0
		if order > 0 then
			local divider = new("Frame", {
				Parent = section.Content,
				LayoutOrder = order,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Lumen.Theme.Border,
				BackgroundTransparency = 0.55,
				BorderSizePixel = 0,
			})
			themed(divider, "BackgroundColor3", "Border")
			table.insert(page.Dividers, divider)
			order = order + 1
		end

		object.LayoutOrder = order
		section.RowOrder = order + 1
	end

	table.insert(page.Elements, {
		Name = name,
		Object = object,
		Section = section,
	})
end

--// toggle
local function CreateToggle(parent, data, ctx)
	data = data or { }

	local Toggle = {
		Type = "Toggle",
		Name = data.Name or data.name or "Toggle",
		Value = false,
		SubElements = { },
	}

	local Button = new("TextButton", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
	})

	local Label = new("TextLabel", {
		Parent = Button,
		Size = UDim2.new(1, -30, 1, 0),
		BackgroundTransparency = 1,
		Text = Toggle.Name,
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(Label, "TextColor3", "Text")
	Label.TextTransparency = 0.2

	local Sub = new("Frame", {
		Parent = Button,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(0, 20),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
	})

	list(Sub, {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
	})

	-- ios style pill: track + knob
	local Box = new("Frame", {
		Parent = Sub,
		LayoutOrder = 100,
		Size = UDim2.fromOffset(36, 20),
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
	})
	corner(Box, 10)

	local Fill = new("Frame", {
		Parent = Box,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
	})
	corner(Fill, 8)

	Toggle.Items = { Button = Button, Label = Label, Sub = Sub, Box = Box, Fill = Fill }

	function Toggle:Set(value, silent)
		value = value and true or false
		Toggle.Value = value

		if Toggle.Flag then
			writeFlag(Toggle.Flag, value)
		end

		if value then
			tween(Box, { BackgroundColor3 = Lumen.Theme.Accent }, 0.16)
			tween(Fill, { Position = UDim2.new(1, -18, 0.5, 0) }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			tween(Fill, { BackgroundColor3 = Lumen.Theme.Background }, 0.16)
			tween(Label, { TextTransparency = 0 }, 0.16)
		else
			tween(Box, { BackgroundColor3 = Lumen.Theme.Element }, 0.16)
			tween(Fill, { Position = UDim2.new(0, 2, 0.5, 0) }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			tween(Fill, { BackgroundColor3 = Lumen.Theme.TextDim }, 0.16)
			tween(Label, { TextTransparency = 0.35 }, 0.16)
		end

		if not silent and data.Callback then
			safe(data.Callback, value)
		end
	end

	function Toggle:Get()
		return Toggle.Value
	end

	function Toggle:SetText(text)
		Toggle.Name = text
		Label.Text = text
	end

	function Toggle:SetVisibility(visible)
		Button.Visible = visible and true or false
	end

	addThemeRefresher(function()
		Toggle:Set(Toggle.Value, true)
	end)

	connect(Button.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Toggle:Set(not Toggle.Value)
	end)

	connect(Button.MouseEnter, function()
		if not canInteract() or Toggle.Value then
			return
		end

		tween(Box, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
	end)

	connect(Button.MouseLeave, function()
		if not Toggle.Value then
			tween(Box, { BackgroundColor3 = Lumen.Theme.Element }, 0.14)
		end
	end)

	attachTooltip(Button, data.Tooltip or data.tooltip)

	registerOption(Toggle, data.Flag or data.flag)
	addSearchEntry(ctx and ctx.Page, Toggle.Name, Button, ctx and ctx.Section)

	if data.Default or data.default then
		Toggle:Set(data.Default or data.default, true)
		if data.Callback then
			safe(data.Callback, Toggle.Value)
		end
	end

	function Toggle:Keybind(keyData)
		local keybind = CreateKeybindButton(keyData or { }, ctx)
		keybind.Button.LayoutOrder = 10
		keybind.Button.Parent = Sub
		table.insert(Toggle.SubElements, keybind)
		return keybind
	end

	function Toggle:Colorpicker(colorData)
		local picker = CreateColorpickerSwatch(colorData or { }, ctx)
		picker.Swatch.LayoutOrder = 20
		picker.Swatch.Parent = Sub
		table.insert(Toggle.SubElements, picker)
		return picker
	end

	return Toggle
end

--// slider
local function CreateSlider(parent, data, ctx)
	data = data or { }

	local Slider = {
		Type = "Slider",
		Name = data.Name or data.name or "Slider",
		Min = tonumber(data.Min or data.min or 0) or 0,
		Max = tonumber(data.Max or data.max or 100) or 100,
		Decimals = tonumber(data.Decimals or data.decimals or 0) or 0,
		Suffix = tostring(data.Suffix or data.suffix or ""),
		Value = tonumber(data.Default or data.default or data.Min or data.min or 0) or 0,
	}

	-- a range no wider than one whole step (0..1, 10..10.5) would collapse to two
	-- positions with the default integer precision: give it decimals, unless the
	-- caller asked for a specific number of them (Decimals = 0 means "integers", not
	-- "whatever you think is best")
	Slider.AutoDecimals = data.Decimals == nil and data.decimals == nil
	if Slider.AutoDecimals and Slider.Decimals == 0 and (Slider.Max - Slider.Min) > 0 and (Slider.Max - Slider.Min) <= 1 then
		Slider.Decimals = 2
	end

	local Frame = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
	})

	local NameLabel = new("TextLabel", {
		Parent = Frame,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, -166, 1, 0),
		BackgroundTransparency = 1,
		Text = Slider.Name,
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(NameLabel, "TextColor3", "Text")
	NameLabel.TextTransparency = 0.15

	local ValueLabel = new("TextLabel", {
		Parent = Frame,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -2, 0.5, 0),
		Size = UDim2.fromOffset(50, 16),
		BackgroundTransparency = 1,
		Text = "",
		TextSize = Lumen.TextSize,
		Font = Lumen.FontMedium,
		TextXAlignment = Enum.TextXAlignment.Right,
	})
	themed(ValueLabel, "TextColor3", "Text")

	local Track = new("TextButton", {
		Parent = Frame,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -58, 0.5, 0),
		Size = UDim2.fromOffset(96, 8),
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
	})
	themed(Track, "BackgroundColor3", "Element")
	corner(Track, 3)

	local Fill = new("Frame", {
		Parent = Track,
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Lumen.Theme.Accent,
		BorderSizePixel = 0,
	})
	themed(Fill, "BackgroundColor3", "Accent")
	corner(Fill, 3)

	local Knob = new("Frame", {
		Parent = Track,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = Lumen.Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 2,
	})
	themed(Knob, "BackgroundColor3", "Accent")
	corner(Knob, 6)
	local KnobStroke = stroke(Knob, Lumen.Theme.Background, 1.5, 0.25)
	themed(KnobStroke, "Color", "Background")

	Slider.Items = { Frame = Frame, Track = Track, Fill = Fill, Knob = Knob, ValueLabel = ValueLabel }

	local function format(value)
		local text
		if Slider.Decimals > 0 then
			text = string.format("%." .. Slider.Decimals .. "f", value)
		else
			text = tostring(math.floor(value + 0.5))
		end
		return text .. Slider.Suffix
	end

	local function visualUpdate()
		local range = Slider.Max - Slider.Min
		local ratio = 0
		if range ~= 0 then
			ratio = math.clamp((Slider.Value - Slider.Min) / range, 0, 1)
		end

		Fill.Size = UDim2.new(ratio, 0, 1, 0)
		Knob.Position = UDim2.new(ratio, 0, 0.5, 0)
		ValueLabel.Text = format(Slider.Value)
	end

	function Slider:Set(value, silent)
		value = tonumber(value) or Slider.Min
		value = math.clamp(value, Slider.Min, Slider.Max)

		-- snap to the step first and clamp again: rounding a value that sat on the
		-- maximum used to push it past the maximum (10..10.5 could report 11)
		local multiplier = 10 ^ Slider.Decimals
		Slider.Value = math.clamp(math.floor(value * multiplier + 0.5) / multiplier, Slider.Min, Slider.Max)

		if Slider.Flag then
			writeFlag(Slider.Flag, Slider.Value)
		end

		visualUpdate()

		if not silent and data.Callback then
			safe(data.Callback, Slider.Value)
		end
	end

	function Slider:Get()
		return Slider.Value
	end

	function Slider:SetRange(min, max)
		Slider.Min = tonumber(min) or Slider.Min
		Slider.Max = tonumber(max) or Slider.Max

		-- the new range may need finer precision than the old one did
		if Slider.AutoDecimals and Slider.Decimals == 0
			and (Slider.Max - Slider.Min) > 0 and (Slider.Max - Slider.Min) <= 1 then
			Slider.Decimals = 2
		end

		Slider:Set(Slider.Value, true)
	end

	function Slider:SetVisibility(visible)
		Frame.Visible = visible and true or false
	end

	-- dragArea is already gated on canInteract, so a closed menu cannot move a slider
	dragArea(Track, function(x)
		Slider:Set(Slider.Min + (Slider.Max - Slider.Min) * x)
	end)

	-- the knob grows a little while the slider is hovered
	connect(Track.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(Knob, { Size = UDim2.fromOffset(14, 14) }, 0.14)
		tween(Track, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
	end)

	connect(Track.MouseLeave, function()
		tween(Knob, { Size = UDim2.fromOffset(12, 12) }, 0.14)
		tween(Track, { BackgroundColor3 = Lumen.Theme.Element }, 0.14)
	end)

	attachTooltip(Frame, data.Tooltip or data.tooltip)

	registerOption(Slider, data.Flag or data.flag)
	addSearchEntry(ctx and ctx.Page, Slider.Name, Frame, ctx and ctx.Section)

	Slider:Set(Slider.Value, true)
	if data.Callback then
		safe(data.Callback, Slider.Value)
	end

	return Slider
end

--// dropdown
local function CreateDropdown(parent, data, ctx)
	data = data or { }

	local Dropdown = {
		Type = "Dropdown",
		Name = data.Name or data.name or "Dropdown",
		Window = ctx and ctx.Window or nil,
		Multi = (data.Multi or data.multi) and true or false,
		Options = { },
		Order = { },
		IsOpen = false,
		OpenedAt = 0,
		Value = nil,
	}

	if Dropdown.Multi then
		Dropdown.Value = { }
	end

	local Frame = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})

	list(Frame, {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
	})

	local Row = new("Frame", {
		Parent = Frame,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
	})

	local NameLabel = new("TextLabel", {
		Parent = Row,
		Size = UDim2.new(1, -150, 1, 0),
		BackgroundTransparency = 1,
		Text = Dropdown.Name,
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(NameLabel, "TextColor3", "Text")
	NameLabel.TextTransparency = 0.15

	local Button = new("TextButton", {
		Parent = Row,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(132, 22),
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
	})
	themed(Button, "BackgroundColor3", "Element")
	corner(Button, 6)
	local ButtonStroke = stroke(Button, Lumen.Theme.Border, 1, 0.25)
	themed(ButtonStroke, "Color", "Border")

	local ValueLabel = new("TextLabel", {
		Parent = Button,
		Size = UDim2.new(1, -24, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		Text = "--",
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(ValueLabel, "TextColor3", "Text")

	-- chevron drawn from two thin bars, so no font glyph is needed
	local Chevron = new("Frame", {
		Parent = Button,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -9, 0.5, 0),
		Size = UDim2.fromOffset(10, 6),
		BackgroundTransparency = 1,
	})

	local ChevronLeft = new("Frame", {
		Parent = Chevron,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.26, 0.5),
		Size = UDim2.fromOffset(6, 1.5),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
		Rotation = 45,
	})
	corner(ChevronLeft, 1)

	local ChevronRight = new("Frame", {
		Parent = Chevron,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.74, 0.5),
		Size = UDim2.fromOffset(6, 1.5),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
		Rotation = -45,
	})
	corner(ChevronRight, 1)

	local ListFrame = new("Frame", {
		Parent = Frame,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
		ClipsDescendants = true,
	})

	list(ListFrame, {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
	})

	local SearchBox = new("TextBox", {
		Parent = ListFrame,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundColor3 = Lumen.Theme.Panel,
		BorderSizePixel = 0,
		PlaceholderText = "search...",
		PlaceholderColor3 = Lumen.Theme.TextDim,
		Text = "",
		TextSize = 12,
		Font = Lumen.Font,
		ClearTextOnFocus = false,
		Visible = false,
	})
	themed(SearchBox, "BackgroundColor3", "Panel")
	themed(SearchBox, "TextColor3", "Text")
	themed(SearchBox, "PlaceholderColor3", "TextDim")
	corner(SearchBox, 5)
	padding(SearchBox, 0, 0, 8, 8)

	local Scroller = new("ScrollingFrame", {
		Parent = ListFrame,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	})
	themed(Scroller, "ScrollBarImageColor3", "Border")
	list(Scroller, {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
	})

	Dropdown.Items = {
		Frame = Frame, Row = Row, Button = Button, ValueLabel = ValueLabel, Chevron = Chevron,
		ListFrame = ListFrame, Scroller = Scroller, SearchBox = SearchBox,
	}

	local function selectedText()
		if Dropdown.Multi then
			if #Dropdown.Value == 0 then
				return "--"
			end
			return table.concat(Dropdown.Value, ", ")
		end

		return Dropdown.Value or "--"
	end

	local function layoutList()
		local count = 0
		for _, option in next, Dropdown.Options do
			if option.Row.Visible then
				count = count + 1
			end
		end

		local searchable = SearchBox.Visible
		local height = math.min(count * 26, data.MaxSize or data.maxsize or 132)
		if count == 0 then
			height = 0
		end

		Scroller.Size = UDim2.new(1, 0, 0, height)
		SearchBox.Size = UDim2.new(1, 0, 0, searchable and 24 or 0)
		ListFrame.Size = UDim2.new(1, 0, 0, height + (searchable and 28 or 0))
	end

	function Dropdown:SetOpen(open)
		if Dropdown.IsOpen == open then
			return
		end

		Dropdown.IsOpen = open
		tween(ChevronLeft, { Rotation = open and -45 or 45 }, 0.14)
		tween(ChevronRight, { Rotation = open and 45 or -45 }, 0.14)

		if open then
			Dropdown.OpenedAt = os.clock()
			layoutList()
			local target = ListFrame.Size
			ListFrame.Size = UDim2.new(1, 0, 0, 0)
			ListFrame.Visible = true
			tween(ListFrame, { Size = target }, 0.18, Enum.EasingStyle.Quint)
		else
			SearchBox.Text = ""
			for _, option in next, Dropdown.Options do
				option.Row.Visible = true
			end
			layoutList()

			local target = ListFrame.Size
			tween(ListFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.14, Enum.EasingStyle.Quint)
			task.delay(0.16, function()
				if not Dropdown.IsOpen then
					ListFrame.Visible = false
					ListFrame.Size = target
				end
			end)
		end
	end

	function Dropdown:Add(option)
		if Dropdown.Options[option] then
			return Dropdown.Options[option]
		end

		local row = new("TextButton", {
			Parent = Scroller,
			Size = UDim2.new(1, -2, 0, 24),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
		})
		corner(row, 4)

		local box = new("Frame", {
			Parent = row,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 4, 0.5, 0),
			Size = UDim2.fromOffset(12, 12),
			BackgroundColor3 = Lumen.Theme.Element,
			BorderSizePixel = 0,
		})
		corner(box, 3)
		local boxStroke = stroke(box, Lumen.Theme.Border, 1, 0)
		themed(boxStroke, "Color", "Border")

		local text = new("TextLabel", {
			Parent = row,
			Position = UDim2.fromOffset(21, 0),
			Size = UDim2.new(1, -26, 1, 0),
			BackgroundTransparency = 1,
			Text = option,
			TextSize = 12,
			Font = Lumen.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
		themed(text, "TextColor3", "TextDim")

		local optionData = { Name = option, Row = row, Box = box, Text = text, Selected = false }

		function optionData:Update()
			if optionData.Selected then
				row.BackgroundTransparency = 0
				row.BackgroundColor3 = Lumen.Theme.Element
				box.BackgroundColor3 = Lumen.Theme.Accent
				text.TextColor3 = Lumen.Theme.Text
			else
				row.BackgroundTransparency = 1
				box.BackgroundColor3 = Lumen.Theme.Element
				text.TextColor3 = Lumen.Theme.TextDim
			end
		end

		connect(row.MouseButton1Down, function()
			if not canInteract() then
				return
			end

			if Dropdown.Multi then
				local index = table.find(Dropdown.Value, option)
				if index then
					table.remove(Dropdown.Value, index)
					optionData.Selected = false
				else
					table.insert(Dropdown.Value, option)
					optionData.Selected = true
				end
			else
				for _, other in next, Dropdown.Options do
					other.Selected = false
					other:Update()
				end

				optionData.Selected = true
				Dropdown.Value = option
			end

			optionData:Update()
			ValueLabel.Text = selectedText()

			if Dropdown.Flag then
				writeFlag(Dropdown.Flag, Dropdown.Value)
			end

			if data.Callback then
				safe(data.Callback, Dropdown.Value)
			end
		end)

		connect(row.MouseEnter, function()
			if not canInteract() or optionData.Selected then
				return
			end

			row.BackgroundTransparency = 0.6
			row.BackgroundColor3 = Lumen.Theme.ElementHover
		end)

		connect(row.MouseLeave, function()
			optionData:Update()
		end)

		Dropdown.Options[option] = optionData
		table.insert(Dropdown.Order, option)

		SearchBox.Visible = #Dropdown.Order > 10
		layoutList()

		return optionData
	end

	function Dropdown:Remove(option)
		local optionData = Dropdown.Options[option]
		if not optionData then
			return
		end

		optionData.Row:Destroy()
		Dropdown.Options[option] = nil

		for index, name in next, Dropdown.Order do
			if name == option then
				table.remove(Dropdown.Order, index)
				break
			end
		end

		if Dropdown.Multi then
			local index = table.find(Dropdown.Value, option)
			if index then
				table.remove(Dropdown.Value, index)
			end
		elseif Dropdown.Value == option then
			Dropdown.Value = nil
		end

		ValueLabel.Text = selectedText()
		layoutList()
	end

	function Dropdown:Refresh(items)
		-- a refresh must not throw the selection away: "refresh list" in the settings
		-- used to blank the config dropdown, and the same wiped the armed config right
		-- after it was picked
		local previous = Dropdown.Value
		if Dropdown.Multi and type(previous) == "table" then
			local copy = { }
			for index, name in next, previous do
				copy[index] = name
			end
			previous = copy
		end

		for _, option in next, table.clone(Dropdown.Order) do
			Dropdown:Remove(option)
		end

		if type(items) == "table" then
			for _, item in next, items do
				Dropdown:Add(tostring(item))
			end
		end

		if Dropdown.Multi and type(previous) == "table" then
			local kept = { }
			for _, name in next, previous do
				if Dropdown.Options[tostring(name)] then
					table.insert(kept, name)
				end
			end

			if #kept > 0 then
				Dropdown:Set(kept, true)
			end
		elseif previous ~= nil and Dropdown.Options[tostring(previous)] then
			Dropdown:Set(previous, true)
		end
	end

	function Dropdown:Set(value, silent)
		if Dropdown.Multi then
			if type(value) ~= "table" then
				return
			end

			Dropdown.Value = { }
			for _, option in next, Dropdown.Options do
				option.Selected = false
				option:Update()
			end

			for _, name in next, value do
				local option = Dropdown.Options[tostring(name)]
				if option then
					option.Selected = true
					option:Update()
					table.insert(Dropdown.Value, tostring(name))
				end
			end
		else
			local option = Dropdown.Options[tostring(value)]
			if not option then
				return
			end

			for _, other in next, Dropdown.Options do
				other.Selected = false
				other:Update()
			end

			option.Selected = true
			option:Update()
			Dropdown.Value = tostring(value)
		end

		ValueLabel.Text = selectedText()

		if Dropdown.Flag then
			writeFlag(Dropdown.Flag, Dropdown.Value)
		end

		if not silent and data.Callback then
			safe(data.Callback, Dropdown.Value)
		end
	end

	function Dropdown:Get()
		return Dropdown.Value
	end

	function Dropdown:SetVisibility(visible)
		Frame.Visible = visible and true or false
	end

	connect(Button.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Dropdown:SetOpen(not Dropdown.IsOpen)
	end)

	connect(Button.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(Button, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
	end)

	connect(Button.MouseLeave, function()
		tween(Button, { BackgroundColor3 = Lumen.Theme.Element }, 0.14)
	end)

	connect(SearchBox:GetPropertyChangedSignal("Text"), function()
		if not canInteract() then
			return
		end

		local needle = string.lower(SearchBox.Text)
		for _, option in next, Dropdown.Options do
			option.Row.Visible = needle == "" or string.find(string.lower(option.Name), needle, 1, true) ~= nil
		end
		layoutList()
	end)

	-- close when clicking anywhere else
	connect(UserInputService.InputBegan, function(input)
		if not Dropdown.IsOpen or not canInteract() then
			return
		end

		-- ignore the click that just opened the list, whatever the event order is
		if os.clock() - Dropdown.OpenedAt < 0.3 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local pos = UserInputService:GetMouseLocation()
		local listPos = ListFrame.AbsolutePosition
		local listSize = ListFrame.AbsoluteSize
		local buttonPos = Button.AbsolutePosition
		local buttonSize = Button.AbsoluteSize

		local overList = pos.X >= listPos.X and pos.X <= listPos.X + listSize.X
			and pos.Y >= listPos.Y and pos.Y <= listPos.Y + listSize.Y

		local overButton = pos.X >= buttonPos.X and pos.X <= buttonPos.X + buttonSize.X
			and pos.Y >= buttonPos.Y and pos.Y <= buttonPos.Y + buttonSize.Y

		if not overList and not overButton then
			Dropdown:SetOpen(false)
		end
	end)

	attachTooltip(Frame, data.Tooltip or data.tooltip)

	registerOption(Dropdown, data.Flag or data.flag)
	addSearchEntry(ctx and ctx.Page, Dropdown.Name, Frame, ctx and ctx.Section)

	-- registered so a closed menu can shut every open list in one call
	table.insert(Lumen.State.Dropdowns, Dropdown)

	local items = data.Items or data.items or { }
	for _, item in next, items do
		Dropdown:Add(tostring(item))
	end

	if data.Default or data.default then
		Dropdown:Set(data.Default or data.default, true)
		if data.Callback then
			safe(data.Callback, Dropdown.Value)
		end
	end

	return Dropdown
end

--// textbox
local function CreateTextbox(parent, data, ctx)
	data = data or { }

	local Textbox = {
		Type = "Textbox",
		Name = data.Name or data.name or "Textbox",
		Value = tostring(data.Default or data.default or ""),
	}

	local Frame = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
	})

	local NameLabel = new("TextLabel", {
		Parent = Frame,
		Size = UDim2.new(1, -158, 1, 0),
		BackgroundTransparency = 1,
		Text = Textbox.Name,
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(NameLabel, "TextColor3", "Text")
	NameLabel.TextTransparency = 0.15

	local Box = new("TextBox", {
		Parent = Frame,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(150, 22),
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
		Text = Textbox.Value,
		PlaceholderText = data.Placeholder or data.placeholder or "...",
		PlaceholderColor3 = Lumen.Theme.TextDim,
		TextColor3 = Lumen.Theme.Text,
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Right,
	})
	themed(Box, "BackgroundColor3", "Element")
	themed(Box, "TextColor3", "Text")
	themed(Box, "PlaceholderColor3", "TextDim")
	corner(Box, 6)
	local BoxStroke = stroke(Box, Lumen.Theme.Border, 1, 0.25)
	themed(BoxStroke, "Color", "Border")
	padding(Box, 0, 0, 8, 8)

	Textbox.Items = { Frame = Frame, Box = Box }

	function Textbox:Set(value, silent)
		-- tostring(nil) is the string "nil": an empty box is the honest reading of nil
		Textbox.Value = value == nil and "" or tostring(value)
		Box.Text = Textbox.Value

		if Textbox.Flag then
			writeFlag(Textbox.Flag, Textbox.Value)
		end

		if not silent and data.Callback then
			safe(data.Callback, Textbox.Value)
		end
	end

	function Textbox:Get()
		return Textbox.Value
	end

	function Textbox:SetVisibility(visible)
		Frame.Visible = visible and true or false
	end

	connect(Box.Focused, function()
		if not canInteract() then
			return
		end

		tween(Box, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
		BoxStroke.Color = Lumen.Theme.Accent
	end)

	connect(Box.FocusLost, function()
		tween(Box, { BackgroundColor3 = Lumen.Theme.Element }, 0.14)
		BoxStroke.Color = Lumen.Theme.Border
		Textbox:Set(Box.Text)
	end)

	attachTooltip(Frame, data.Tooltip or data.tooltip)

	registerOption(Textbox, data.Flag or data.flag)
	addSearchEntry(ctx and ctx.Page, Textbox.Name, Frame, ctx and ctx.Section)

	return Textbox
end

--// button
-- two buttons stacked straight on top of each other used to be glued together (four
-- 30px slabs with a one pixel seam read as one heavy block). when the row above is
-- another button, a small transparent spacer goes in first.
local BUTTON_GAP = 6

local function rowAboveIsButton(parent)
	local children = parent:GetChildren()

	for index = #children, 1, -1 do
		local child = children[index]

		if child.ClassName ~= "UIListLayout" and child.ClassName ~= "UIPadding" then
			-- the section draws a hairline between rows: look past those
			local size = child.Size
			local offsetY = size and size.Y and size.Y.Offset
			local hairline = child.ClassName == "Frame" and offsetY ~= nil and offsetY <= 1
				and child.BackgroundTransparency == 0.55

			if not hairline then
				return child.ClassName == "TextButton"
			end
		end
	end

	return false
end

local function CreateButton(parent, data, ctx)
	data = data or { }

	if rowAboveIsButton(parent) then
		new("Frame", {
			Parent = parent,
			Size = UDim2.new(1, 0, 0, BUTTON_GAP),
			BackgroundTransparency = 1,
		})
	end

	local Button = {
		Type = "Button",
		Name = data.Name or data.name or "Button",
		Confirm = (data.Confirm or data.confirm) and true or false,
	}

	local Frame = new("TextButton", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
	})
	themed(Frame, "BackgroundColor3", "Element")
	corner(Frame, 8)
	local FrameStroke = stroke(Frame, Lumen.Theme.Border, 1, 0.25)
	themed(FrameStroke, "Color", "Border")

	-- accent flash that runs under the text every time the button is pressed
	local Ripple = new("Frame", {
		Parent = Frame,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Lumen.Theme.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 1,
	})
	themed(Ripple, "BackgroundColor3", "Accent")
	corner(Ripple, 8)

	local Label = new("TextLabel", {
		Parent = Frame,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = Button.Name,
		TextSize = Lumen.TextSize,
		Font = Lumen.FontMedium,
		RichText = true,
		ZIndex = 2,
	})
	themed(Label, "TextColor3", "Text")

	Button.Items = { Frame = Frame, Label = Label, Ripple = Ripple }

	local armed = false

	function Button:Press()
		tween(Frame, { BackgroundColor3 = Lumen.Theme.Accent }, 0.08)
		Ripple.BackgroundTransparency = 0.7
		Ripple.Size = UDim2.fromScale(0.88, 1)
		tween(Ripple, { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }, 0.3)
		task.delay(0.12, function()
			if Frame.Parent then
				tween(Frame, { BackgroundColor3 = Lumen.Theme.Element }, 0.16)
			end
		end)

		safe(data.Callback or data.callback)
	end

	function Button:SetText(text)
		Button.Name = text
		Label.Text = text
	end

	function Button:SetVisibility(visible)
		Frame.Visible = visible and true or false
	end

	connect(Frame.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		if not Button.Confirm then
			Button:Press()
			return
		end

		if armed then
			armed = false
			Label.Text = Button.Name
			tween(FrameStroke, { Color = Lumen.Theme.Border }, 0.14)
			Button:Press()
		else
			armed = true
			Label.Text = "confirm?"
			tween(FrameStroke, { Color = Lumen.Theme.Accent }, 0.14)
			task.delay(3, function()
				if armed then
					armed = false
					Label.Text = Button.Name
					tween(FrameStroke, { Color = Lumen.Theme.Border }, 0.14)
				end
			end)
		end
	end)

	connect(Frame.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(Frame, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
	end)

	connect(Frame.MouseLeave, function()
		tween(Frame, { BackgroundColor3 = Lumen.Theme.Element }, 0.14)
	end)

	attachTooltip(Frame, data.Tooltip or data.tooltip)
	addSearchEntry(ctx and ctx.Page, Button.Name, Frame, ctx and ctx.Section)

	return Button
end

--// label
local function CreateLabel(parent, data, ctx)
	data = data or { }

	local Label = {
		Type = "Label",
		Name = data.Name or data.name or data.Text or data.text or "Label",
		SubElements = { },
	}

	local Frame = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})

	local Text = new("TextLabel", {
		Parent = Frame,
		Size = UDim2.new(1, -34, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = Label.Name,
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment[data.Alignment or data.alignment or "Left"] or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
	themed(Text, "TextColor3", "TextDim")

	local Sub = new("Frame", {
		Parent = Frame,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.fromOffset(0, 18),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
	})

	list(Sub, {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
	})

	Label.Items = { Frame = Frame, Text = Text, Sub = Sub }

	function Label:SetText(text)
		Label.Name = text
		Text.Text = text
	end

	function Label:SetVisibility(visible)
		Frame.Visible = visible and true or false
	end

	attachTooltip(Frame, data.Tooltip or data.tooltip)
	addSearchEntry(ctx and ctx.Page, Label.Name, Frame, ctx and ctx.Section)

	function Label:Keybind(keyData)
		local keybind = CreateKeybindButton(keyData or { }, ctx)
		keybind.Button.LayoutOrder = 10
		keybind.Button.Parent = Sub
		table.insert(Label.SubElements, keybind)
		return keybind
	end

	function Label:Colorpicker(colorData)
		local picker = CreateColorpickerSwatch(colorData or { }, ctx)
		picker.Swatch.LayoutOrder = 20
		picker.Swatch.Parent = Sub
		table.insert(Label.SubElements, picker)
		return picker
	end

	return Label
end

--// keybind (button + logic)
function CreateKeybindButton(data, ctx)
	data = data or { }

	local Keybind = {
		Type = "Keybind",
		Name = data.Name or data.name or "Keybind",
		-- owning window: lets Window:__destroy() drop the binds it created, so a
		-- replaced window cannot keep firing callbacks from the input router
		Window = ctx and ctx.Window or nil,
		Key = data.Default or data.default or nil,
		Mode = string.lower(tostring(data.Mode or data.mode or "toggle")),
		Toggled = false,
		Listening = false,
		Capture = nil,
		ShowInList = data.ShowInList == nil and true or (data.ShowInList and true or false),
	}

	local Button = new("TextButton", {
		Size = UDim2.fromOffset(0, 18),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
		Text = keyName(Keybind.Key),
		TextSize = 11,
		Font = Lumen.FontMedium,
		AutoButtonColor = false,
	})
	themed(Button, "BackgroundColor3", "Element")
	themed(Button, "TextColor3", "TextDim")
	corner(Button, 4)
	local ButtonStroke = stroke(Button, Lumen.Theme.Border, 1, 0.35)
	themed(ButtonStroke, "Color", "Border")
	padding(Button, 0, 0, 6, 6)

	Keybind.Button = Button

	local function refreshText()
		Button.Text = Keybind.Listening and "..." or keyName(Keybind.Key)
		Button.TextColor3 = Keybind.Toggled and Lumen.Theme.Accent or Lumen.Theme.TextDim
	end

	local function updateList()
		if not Lumen.State.KeybindsList then
			return
		end
		Lumen.State.KeybindsList:Refresh()
	end

	function Keybind:SetKey(input)
		if input == nil then
			Keybind.Key = nil
		elseif typeof(input) == "EnumItem" then
			if input.EnumType == Enum.KeyCode or input.EnumType == Enum.UserInputType then
				if input == Enum.KeyCode.Backspace or input == Enum.KeyCode.Escape then
					Keybind.Key = nil
				else
					Keybind.Key = input
				end
			end
		end

		refreshText()
		Keybind:SaveFlag()

		-- apply first so a list refresh error can never eat the new bind
		if data.OnSet then
			safe(data.OnSet, Keybind.Key)
		end

		safe(updateList)
	end

	-- stops a capture that is waiting for a key: used by the timeout below and by
	-- the library when the menu closes, so a hidden menu never holds a listener
	function Keybind:StopListening()
		if Keybind.Capture then
			disconnectTransient(Keybind.Capture)
			Keybind.Capture = nil
		end

		Keybind.Listening = false
		refreshText()
	end

	function Keybind:SetMode(mode)
		mode = string.lower(tostring(mode or "toggle"))
		if mode ~= "toggle" and mode ~= "hold" and mode ~= "always" then
			mode = "toggle"
		end

		Keybind.Mode = mode
		Keybind.Toggled = mode == "always"
		refreshText()
		Keybind:SaveFlag()
		updateList()

		if data.Callback then
			safe(data.Callback, Keybind.Toggled)
		end
	end

	function Keybind:SaveFlag()
		if not Keybind.Flag then
			return
		end

		writeFlag(Keybind.Flag, {
			Key = Keybind.Key and tostring(Keybind.Key) or "None",
			Mode = Keybind.Mode,
			Toggled = Keybind.Toggled,
			ShowInList = Keybind.ShowInList,
		})
	end

	function Keybind:Press(state)
		if Keybind.Mode == "toggle" then
			Keybind.Toggled = not Keybind.Toggled
		elseif Keybind.Mode == "hold" then
			Keybind.Toggled = state and true or false
		elseif Keybind.Mode == "always" then
			Keybind.Toggled = true
		end

		refreshText()
		Keybind:SaveFlag()
		updateList()

		if data.Callback then
			safe(data.Callback, Keybind.Toggled)
		end
	end

	function Keybind:Get()
		return Keybind.Toggled, Keybind.Key
	end

	function Keybind:Set(value)
		if type(value) == "table" then
			local key = value.Key
			if type(key) == "string" and key ~= "None" then
				local parts = string.split(key, ".")
				if #parts == 3 then
					local enumType = parts[2]
					local enumName = parts[3]
					local ok, enumItem = pcall(function()
						if enumType == "KeyCode" then
							return Enum.KeyCode[enumName]
						end
						return Enum.UserInputType[enumName]
					end)
					if ok and enumItem then
						Keybind.Key = enumItem
					end
				end
			elseif key == "None" then
				Keybind.Key = nil
			end

			if value.Mode then
				Keybind.Mode = string.lower(tostring(value.Mode))
			end

			if value.ShowInList ~= nil then
				Keybind.ShowInList = value.ShowInList and true or false
			end

			Keybind.Toggled = Keybind.Mode == "always"
			refreshText()
			Keybind:SaveFlag()
			updateList()

			if data.Callback then
				safe(data.Callback, Keybind.Toggled)
			end
			return
		end

		if typeof(value) == "EnumItem" then
			Keybind:SetKey(value)
		elseif type(value) == "string" then
			Keybind:SetMode(value)
		end
	end

	function Keybind:SetVisibility(visible)
		Button.Visible = visible and true or false
	end

	-- key capture. nothing starts while the menu is closed, and a capture that is
	-- running dies with the menu (see closeTransientUI).
	connect(Button.MouseButton1Down, function()
		if not canInteract() or Keybind.Listening then
			return
		end

		Keybind.Listening = true
		refreshText()

		local capture
		capture = connectTransient(UserInputService.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				Keybind:SetKey(input.KeyCode)
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				-- this is the click that started the capture
				return
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
				Keybind:StopListening()
				return
			else
				Keybind:SetKey(input.UserInputType)
			end

			Keybind:StopListening()
		end)

		Keybind.Capture = capture

		task.delay(15, function()
			if Keybind.Listening then
				Keybind:StopListening()
			end
		end)
	end)

	-- mode menu
	local menu = nil
	local menuOpenedAt = 0

	local function closeMenu()
		if menu then
			menu:Destroy()
			menu = nil
		end
	end

	local function openMenu()
		closeMenu()
		menuOpenedAt = os.clock()

		menu = new("Frame", {
			Parent = Lumen.State.Popups,
			Size = UDim2.fromOffset(140, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Lumen.Theme.Panel,
			BorderSizePixel = 0,
			ZIndex = 80,
		})
		themed(menu, "BackgroundColor3", "Panel")
		corner(menu, 6)
		local menuStroke = stroke(menu, Lumen.Theme.Border, 1, 0.25)
		themed(menuStroke, "Color", "Border")
		padding(menu, 6, 6, 6, 6)
		list(menu, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) })

		local function modeRow(name, mode, order)
			local row = new("TextButton", {
				Parent = menu,
				LayoutOrder = order,
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 81,
			})
			corner(row, 4)

			local text = new("TextLabel", {
				Parent = row,
				Size = UDim2.new(1, -22, 1, 0),
				Position = UDim2.fromOffset(6, 0),
				BackgroundTransparency = 1,
				Text = name,
				TextSize = 12,
				Font = Lumen.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 82,
			})
			themed(text, "TextColor3", Keybind.Mode == mode and "Accent" or "TextDim")

			local dot = new("Frame", {
				Parent = row,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -6, 0.5, 0),
				Size = UDim2.fromOffset(7, 7),
				BackgroundColor3 = Lumen.Theme.Accent,
				BorderSizePixel = 0,
				Visible = Keybind.Mode == mode,
				ZIndex = 82,
			})
			corner(dot, 4)
			themed(dot, "BackgroundColor3", "Accent")

			connect(row.MouseButton1Down, function()
				if not canInteract() then
					return
				end

				Keybind:SetMode(mode)
				closeMenu()
			end)

			connect(row.MouseEnter, function()
				if not canInteract() then
					return
				end

				row.BackgroundTransparency = 0.35
				row.BackgroundColor3 = Lumen.Theme.Element
			end)

			connect(row.MouseLeave, function()
				row.BackgroundTransparency = 1
			end)
		end

		modeRow("toggle", "toggle", 1)
		modeRow("hold", "hold", 2)
		modeRow("always", "always", 3)

		local clearRow = new("TextButton", {
			Parent = menu,
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 81,
		})
		corner(clearRow, 4)

		local clearText = new("TextLabel", {
			Parent = clearRow,
			Size = UDim2.new(1, -12, 1, 0),
			Position = UDim2.fromOffset(6, 0),
			BackgroundTransparency = 1,
			Text = "clear bind",
			TextSize = 12,
			Font = Lumen.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 82,
		})
		themed(clearText, "TextColor3", "TextDim")

		connect(clearRow.MouseButton1Down, function()
			if not canInteract() then
				return
			end

			Keybind:SetKey(nil)
			closeMenu()
		end)

		connect(clearRow.MouseEnter, function()
			if not canInteract() then
				return
			end

			clearRow.BackgroundTransparency = 0.35
			clearRow.BackgroundColor3 = Lumen.Theme.Element
			clearText.TextColor3 = Lumen.Theme.Error
		end)

		connect(clearRow.MouseLeave, function()
			clearRow.BackgroundTransparency = 1
			clearText.TextColor3 = Lumen.Theme.TextDim
		end)

		local listRow = new("TextButton", {
			Parent = menu,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 81,
		})
		corner(listRow, 4)

		local listText = new("TextLabel", {
			Parent = listRow,
			Size = UDim2.new(1, -22, 1, 0),
			Position = UDim2.fromOffset(6, 0),
			BackgroundTransparency = 1,
			Text = "show in list",
			TextSize = 12,
			Font = Lumen.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 82,
		})
		themed(listText, "TextColor3", "TextDim")

		local listDot = new("Frame", {
			Parent = listRow,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6, 0.5, 0),
			Size = UDim2.fromOffset(7, 7),
			BackgroundColor3 = Lumen.Theme.Accent,
			BorderSizePixel = 0,
			Visible = Keybind.ShowInList,
			ZIndex = 82,
		})
		corner(listDot, 4)
		themed(listDot, "BackgroundColor3", "Accent")

		connect(listRow.MouseButton1Down, function()
			if not canInteract() then
				return
			end

			Keybind.ShowInList = not Keybind.ShowInList
			listDot.Visible = Keybind.ShowInList
			Keybind:SaveFlag()
			updateList()
		end)

		connect(listRow.MouseEnter, function()
			if not canInteract() then
				return
			end

			listRow.BackgroundTransparency = 0.35
			listRow.BackgroundColor3 = Lumen.Theme.Element
		end)

		connect(listRow.MouseLeave, function()
			listRow.BackgroundTransparency = 1
		end)

		local position = Button.AbsolutePosition
		menu.Position = UDim2.fromOffset(position.X, position.Y + Button.AbsoluteSize.Y + 6)

		local viewport = viewportSize()
		if menu.AbsolutePosition.X + menu.AbsoluteSize.X > viewport.X then
			menu.Position = UDim2.fromOffset(viewport.X - menu.AbsoluteSize.X - 12, menu.Position.Y.Offset)
		end
	end

	-- right click opens the mode menu (toggle / hold / always, show in list, clear
	-- bind). the bind is no longer wiped by the same click.
	connect(Button.MouseButton2Down, function()
		if not canInteract() then
			return
		end

		if menu then
			closeMenu()
		else
			openMenu()
		end
	end)

	connect(UserInputService.InputBegan, function(input)
		if not menu then
			return
		end

		if not canInteract() then
			closeMenu()
			return
		end

		if os.clock() - menuOpenedAt < 0.3 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		local pos = UserInputService:GetMouseLocation()
		local menuPos = menu.AbsolutePosition
		local menuSize = menu.AbsoluteSize

		local inside = pos.X >= menuPos.X and pos.X <= menuPos.X + menuSize.X
			and pos.Y >= menuPos.Y and pos.Y <= menuPos.Y + menuSize.Y

		if not inside then
			closeMenu()
		end
	end)

	table.insert(Lumen.State.Keybinds, Keybind)
	registerOption(Keybind, data.Flag or data.flag)
	Keybind:SaveFlag()
	refreshText()

	if Lumen.State.KeybindsList then
		Lumen.State.KeybindsList:Refresh()
	end

	return Keybind
end

-- global input router for every keybind
local function ensureKeybindRouter()
	if Lumen.State.InputHandler then
		return
	end

	Lumen.State.InputHandler = true

	connect(UserInputService.InputBegan, function(input, gameProcessed)
		if gameProcessed then
			return
		end

		for _, keybind in next, Lumen.State.Keybinds do
			if not keybind.Listening and keybind.Key then
				if input.KeyCode == keybind.Key or input.UserInputType == keybind.Key then
					keybind:Press(true)
				end
			end
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		for _, keybind in next, Lumen.State.Keybinds do
			if keybind.Key and (input.KeyCode == keybind.Key or input.UserInputType == keybind.Key) then
				if keybind.Mode == "hold" then
					keybind:Press(false)
				end
			end
		end
	end)
end

--// colorpicker (swatch + floating window)
function CreateColorpickerSwatch(data, ctx)
	data = data or { }

	local defaultColor = data.Default or data.default
	if typeof(defaultColor) == "Color3" then
		-- keep as is
	elseif type(defaultColor) == "string" then
		local parsed = pcall(Color3.fromHex, defaultColor) and Color3.fromHex(defaultColor) or nil
		defaultColor = parsed or Color3.fromRGB(255, 255, 255)
	elseif type(defaultColor) == "table" then
		defaultColor = Color3.fromRGB(defaultColor[1] or 255, defaultColor[2] or 255, defaultColor[3] or 255)
	else
		defaultColor = Color3.fromRGB(255, 255, 255)
	end

	local Picker = {
		Type = "Colorpicker",
		Name = data.Name or data.name or "Colorpicker",
		H = 0, S = 1, V = 1,
		Alpha = tonumber(data.Alpha or data.alpha or 1) or 1,
		Color = defaultColor,
		IsOpen = false,
		OpenedAt = 0,
		Rainbow = false,
	}

	local h, s, v = defaultColor:ToHSV()
	Picker.H, Picker.S, Picker.V = h, s, v

	local Swatch = new("TextButton", {
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = Picker.Color,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
	})
	corner(Swatch, 5)
	local SwatchStroke = stroke(Swatch, Lumen.Theme.Border, 1, 0)
	themed(SwatchStroke, "Color", "Border")

	local SwatchInner = new("Frame", {
		Parent = Swatch,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = Picker.Color,
		BorderSizePixel = 0,
	})
	corner(SwatchInner, 3)

	Picker.Swatch = Swatch
	Picker.OwnerWindow = ctx and ctx.Window or nil

	-- floating window
	local Window = new("Frame", {
		Parent = Lumen.State.Popups,
		Size = UDim2.fromOffset(236, 224),
		BackgroundColor3 = Lumen.Theme.Background,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 70,
	})
	themed(Window, "BackgroundColor3", "Background")
	corner(Window, 8)
	local WindowStroke = stroke(Window, Lumen.Theme.Border, 1, 0.2)
	themed(WindowStroke, "Color", "Border")

	local Header = new("TextButton", {
		Parent = Window,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 71,
	})

	local Title = new("TextLabel", {
		Parent = Header,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		Text = Picker.Name or "color",
		TextSize = 12,
		Font = Lumen.FontMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 72,
	})
	themed(Title, "TextColor3", "TextDim")

	local CloseButton = new("TextButton", {
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundTransparency = 1,
		Text = "x",
		TextSize = 13,
		Font = Lumen.FontBold,
		AutoButtonColor = false,
		ZIndex = 72,
	})
	themed(CloseButton, "TextColor3", "TextDim")

	makeDraggable(Window, Header)

	-- saturation / value area
	local SV = new("TextButton", {
		Parent = Window,
		Position = UDim2.fromOffset(16, 34),
		Size = UDim2.fromOffset(204, 104),
		BackgroundColor3 = Color3.fromHSV(Picker.H, 1, 1),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 71,
	})
	corner(SV, 6)

	local SVGradient = new("UIGradient", {
		Parent = SV,
		Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromHSV(Picker.H, 1, 1)),
	})

	local SVDark = new("Frame", {
		Parent = SV,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 72,
	})
	corner(SVDark, 6)
	new("UIGradient", {
		Parent = SVDark,
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
	})

	local SVKnob = new("Frame", {
		Parent = SV,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(Picker.S, 1 - Picker.V),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 73,
	})
	corner(SVKnob, 6)
	stroke(SVKnob, Color3.fromRGB(0, 0, 0), 1.5, 0.4)

	-- hue bar
	local Hue = new("TextButton", {
		Parent = Window,
		Position = UDim2.fromOffset(16, 146),
		Size = UDim2.fromOffset(204, 12),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 71,
	})
	corner(Hue, 6)
	new("UIGradient", {
		Parent = Hue,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
		}),
	})

	local HueKnob = new("Frame", {
		Parent = Hue,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(Picker.H, 0, 0.5, 0),
		Size = UDim2.fromOffset(7, 16),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 72,
	})
	corner(HueKnob, 3)
	stroke(HueKnob, Color3.fromRGB(0, 0, 0), 1.5, 0.35)

	-- alpha bar
	local AlphaBar = new("TextButton", {
		Parent = Window,
		Position = UDim2.fromOffset(16, 164),
		Size = UDim2.fromOffset(204, 12),
		BackgroundColor3 = Color3.fromRGB(40, 42, 50),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 71,
	})
	corner(AlphaBar, 6)
	new("UIGradient", {
		Parent = AlphaBar,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(74, 77, 88)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(38, 40, 48)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(74, 77, 88)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(38, 40, 48)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(74, 77, 88)),
		}),
	})

	local AlphaFill = new("Frame", {
		Parent = AlphaBar,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Picker.Color,
		BackgroundTransparency = 1 - Picker.Alpha,
		BorderSizePixel = 0,
		ZIndex = 72,
	})
	corner(AlphaFill, 6)

	local AlphaKnob = new("Frame", {
		Parent = AlphaBar,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(Picker.Alpha, 0, 0.5, 0),
		Size = UDim2.fromOffset(7, 16),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 73,
	})
	corner(AlphaKnob, 3)
	stroke(AlphaKnob, Color3.fromRGB(0, 0, 0), 1.5, 0.35)

	-- bottom row: hex input + preview + rainbow
	local HexBox = new("TextBox", {
		Parent = Window,
		Position = UDim2.fromOffset(16, 184),
		Size = UDim2.fromOffset(120, 24),
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
		Text = Picker.Color:ToHex(),
		PlaceholderText = "hex",
		TextSize = 12,
		Font = Lumen.Font,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 71,
	})
	themed(HexBox, "BackgroundColor3", "Element")
	themed(HexBox, "TextColor3", "Text")
	themed(HexBox, "PlaceholderColor3", "TextDim")
	corner(HexBox, 5)
	padding(HexBox, 0, 0, 6, 6)

	local Preview = new("Frame", {
		Parent = Window,
		Position = UDim2.fromOffset(142, 184),
		Size = UDim2.fromOffset(24, 24),
		BackgroundColor3 = Picker.Color,
		BorderSizePixel = 0,
		ZIndex = 71,
	})
	corner(Preview, 5)
	local PreviewStroke = stroke(Preview, Lumen.Theme.Border, 1, 0)
	themed(PreviewStroke, "Color", "Border")

	local RainbowButton = new("TextButton", {
		Parent = Window,
		Position = UDim2.fromOffset(172, 184),
		Size = UDim2.fromOffset(48, 24),
		BackgroundColor3 = Lumen.Theme.Element,
		BorderSizePixel = 0,
		Text = "rbw",
		TextSize = 11,
		Font = Lumen.FontMedium,
		AutoButtonColor = false,
		ZIndex = 71,
	})
	themed(RainbowButton, "BackgroundColor3", "Element")
	themed(RainbowButton, "TextColor3", "TextDim")
	corner(RainbowButton, 5)
	local RainbowStroke = stroke(RainbowButton, Lumen.Theme.Border, 1, 0.3)
	themed(RainbowStroke, "Color", "Border")

	-- the floating window lives in the popup layer, not inside the menu, so it has to
	-- be torn down together with the window that owns it
	table.insert(Lumen.State.PopupWindows, { Owner = Picker.OwnerWindow, Instance = Window })

	Picker.Items = {
		Window = Window, SV = SV, SVKnob = SVKnob, Hue = Hue, HueKnob = HueKnob,
		AlphaBar = AlphaBar, AlphaFill = AlphaFill, AlphaKnob = AlphaKnob,
		HexBox = HexBox, Preview = Preview, Rainbow = RainbowButton,
	}

	function Picker:Update(silent)
		Picker.Color = Color3.fromHSV(Picker.H, Picker.S, Picker.V)

		Swatch.BackgroundColor3 = Picker.Color
		SwatchInner.BackgroundColor3 = Picker.Color
		Preview.BackgroundColor3 = Picker.Color
		AlphaFill.BackgroundColor3 = Picker.Color
		AlphaFill.BackgroundTransparency = 1 - Picker.Alpha

		SVGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromHSV(Picker.H, 1, 1))

		HexBox.Text = Picker.Color:ToHex()

		SVKnob.Position = UDim2.fromScale(Picker.S, 1 - Picker.V)
		HueKnob.Position = UDim2.new(Picker.H, 0, 0.5, 0)
		AlphaKnob.Position = UDim2.new(Picker.Alpha, 0, 0.5, 0)

		if Picker.Flag then
			writeFlag(Picker.Flag, { Color = Picker.Color:ToHex(), Alpha = Picker.Alpha })
		end

		if not silent and data.Callback then
			safe(data.Callback, Picker.Color, Picker.Alpha)
		end
	end

	function Picker:SetHSV(hue, saturation, value, alpha, silent)
		Picker.H = math.clamp(tonumber(hue) or Picker.H, 0, 1)
		Picker.S = math.clamp(tonumber(saturation) or Picker.S, 0, 1)
		Picker.V = math.clamp(tonumber(value) or Picker.V, 0, 1)
		Picker.Alpha = math.clamp(tonumber(alpha) or Picker.Alpha, 0, 1)
		Picker:Update(silent)
	end

	function Picker:Set(color, alpha, silent)
		if typeof(color) == "Color3" then
			-- already a color
		elseif type(color) == "string" then
			local parsed = pcall(Color3.fromHex, color) and Color3.fromHex(color) or nil
			if not parsed then
				return
			end
			color = parsed
		elseif type(color) == "table" then
			color = Color3.fromRGB(color[1] or 255, color[2] or 255, color[3] or 255)
		else
			return
		end

		local hue, saturation, value = color:ToHSV()
		Picker:SetHSV(hue, saturation, value, alpha or Picker.Alpha, silent)
	end

	function Picker:Get()
		return Picker.Color, Picker.Alpha
	end

	function Picker:SetOpen(open)
		if Picker.IsOpen == open then
			return
		end

		Picker.IsOpen = open
		Window.Visible = open

		if open then
			Picker.OpenedAt = os.clock()
			local position = Swatch.AbsolutePosition
			local size = Swatch.AbsoluteSize
			Window.Position = UDim2.fromOffset(position.X + size.X + 8, position.Y - 4)

			local viewport = viewportSize()
			if Window.Position.X.Offset + Window.AbsoluteSize.X > viewport.X - 8 then
				Window.Position = UDim2.fromOffset(position.X - Window.AbsoluteSize.X - 8, Window.Position.Y.Offset)
			end

			Window.Position = UDim2.fromOffset(
				math.clamp(Window.Position.X.Offset, 8, math.max(8, viewport.X - Window.AbsoluteSize.X - 8)),
				math.clamp(Window.Position.Y.Offset, 8, math.max(8, viewport.Y - Window.AbsoluteSize.Y - 8))
			)

			Window.BackgroundTransparency = 0.35
			tween(Window, { BackgroundTransparency = 0 }, 0.16)
			HexBox.Text = Picker.Color:ToHex()
		end
	end

	function Picker:SetRainbow(enabled)
		Picker.Rainbow = enabled and true or false
		RainbowButton.TextColor3 = Picker.Rainbow and Lumen.Theme.Accent or Lumen.Theme.TextDim
		RainbowStroke.Color = Picker.Rainbow and Lumen.Theme.Accent or Lumen.Theme.Border

		if not Picker.Rainbow then
			return
		end

		local state = Lumen.State

		task.spawn(function()
			while state.Running and Picker.Rainbow do
				local hue = (os.clock() * 0.18) % 1
				Picker:SetHSV(hue, math.max(Picker.S, 0.65), math.max(Picker.V, 0.75), Picker.Alpha)
				task.wait(0.06)
			end
		end)
	end

	function Picker:SetVisibility(visible)
		Swatch.Visible = visible and true or false
	end

	-- dragArea is gated on canInteract, so a closed menu cannot move a picker knob
	dragArea(SV, function(x, y)
		if Picker.Rainbow then
			Picker:SetRainbow(false)
		end
		Picker:SetHSV(Picker.H, x, 1 - y, Picker.Alpha)
	end)

	dragArea(Hue, function(x)
		if Picker.Rainbow then
			Picker:SetRainbow(false)
		end
		Picker:SetHSV(x, Picker.S, Picker.V, Picker.Alpha)
	end)

	dragArea(AlphaBar, function(x)
		Picker:SetHSV(Picker.H, Picker.S, Picker.V, x)
	end)

	connect(Swatch.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Picker:SetOpen(not Picker.IsOpen)
	end)

	connect(CloseButton.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Picker:SetOpen(false)
	end)

	connect(RainbowButton.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Picker:SetRainbow(not Picker.Rainbow)
	end)

	connect(HexBox.FocusLost, function()
		if not canInteract() then
			return
		end

		local text = string.gsub(HexBox.Text, "#", "")
		local parsed = pcall(Color3.fromHex, text) and Color3.fromHex(text) or nil
		if parsed then
			Picker:Set(parsed, Picker.Alpha)
		else
			HexBox.Text = Picker.Color:ToHex()
		end
	end)

	connect(UserInputService.InputBegan, function(input)
		if not Picker.IsOpen then
			return
		end

		if not canInteract() then
			Picker:SetOpen(false)
			return
		end

		-- ignore the click that just opened the picker (swatch click)
		if os.clock() - Picker.OpenedAt < 0.3 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local pos = UserInputService:GetMouseLocation()
		local windowPos = Window.AbsolutePosition
		local windowSize = Window.AbsoluteSize

		local inside = pos.X >= windowPos.X and pos.X <= windowPos.X + windowSize.X
			and pos.Y >= windowPos.Y and pos.Y <= windowPos.Y + windowSize.Y

		local swatchPos = Swatch.AbsolutePosition
		local swatchSize = Swatch.AbsoluteSize
		local overSwatch = pos.X >= swatchPos.X - 4 and pos.X <= swatchPos.X + swatchSize.X + 4
			and pos.Y >= swatchPos.Y - 4 and pos.Y <= swatchPos.Y + swatchSize.Y + 4

		if not inside and not overSwatch then
			Picker:SetOpen(false)
		end
	end)

	addThemeRefresher(function()
		Picker:Update(true)
	end)

	registerOption(Picker, data.Flag or data.flag)
	Picker:Update(true)

	if data.Callback then
		safe(data.Callback, Picker.Color, Picker.Alpha)
	end

	return Picker
end

--// keybind row (label + button)
local function CreateKeybindRow(parent, data, ctx)
	data = data or { }

	local Frame = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
	})

	local Label = new("TextLabel", {
		Parent = Frame,
		Size = UDim2.new(1, -60, 1, 0),
		BackgroundTransparency = 1,
		Text = data.Name or data.name or "Keybind",
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(Label, "TextColor3", "Text")
	Label.TextTransparency = 0.15

	local Keybind = CreateKeybindButton(data, ctx)
	Keybind.Button.AnchorPoint = Vector2.new(1, 0.5)
	Keybind.Button.Position = UDim2.new(1, 0, 0.5, 0)
	Keybind.Button.Parent = Frame

	addSearchEntry(ctx and ctx.Page, Label.Text, Frame, ctx and ctx.Section)

	Keybind.Row = Frame
	return Keybind
end

--// colorpicker row (label + swatch)
local function CreateColorpickerRow(parent, data, ctx)
	data = data or { }

	local Frame = new("Frame", {
		Parent = parent,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
	})

	local Label = new("TextLabel", {
		Parent = Frame,
		Size = UDim2.new(1, -30, 1, 0),
		BackgroundTransparency = 1,
		Text = data.Name or data.name or "Color",
		TextSize = Lumen.TextSize,
		Font = Lumen.Font,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(Label, "TextColor3", "TextDim")

	local Picker = CreateColorpickerSwatch(data, ctx)
	Picker.Swatch.AnchorPoint = Vector2.new(1, 0.5)
	Picker.Swatch.Position = UDim2.new(1, 0, 0.5, 0)
	Picker.Swatch.Parent = Frame

	addSearchEntry(ctx and ctx.Page, Label.Text, Frame, ctx and ctx.Section)

	Picker.Row = Frame
	return Picker
end
--#endregion

--#region section / page / window
local function CreateSection(column, data, ctx)
	data = data or { }

	local Section = {
		Type = "Section",
		Name = data.Name or data.name or "Section",
		Collapsed = false,
		Window = ctx.Window,
		Page = ctx.Page,
	}

	-- outer container: tiny uppercase label, panel below it (reference layout)
	local Frame = new("Frame", {
		Parent = column,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})

	local Header = new("TextButton", {
		Parent = Frame,
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
	})

	local Title = new("TextLabel", {
		Parent = Header,
		Position = UDim2.fromOffset(2, 0),
		Size = UDim2.new(1, -26, 1, 0),
		BackgroundTransparency = 1,
		Text = string.upper(Section.Name),
		TextSize = 10,
		Font = Lumen.FontBold,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	themed(Title, "TextColor3", "TextDim")
	Title.TextTransparency = 0.25

	local ToggleIcon = new("Frame", {
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -2, 0.5, 0),
		Size = UDim2.fromOffset(10, 6),
		BackgroundTransparency = 1,
	})

	local IconLeft = new("Frame", {
		Parent = ToggleIcon,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.26, 0.5),
		Size = UDim2.fromOffset(6, 1.5),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
		Rotation = -45,
	})
	corner(IconLeft, 1)
	themed(IconLeft, "BackgroundColor3", "TextDim")

	local IconRight = new("Frame", {
		Parent = ToggleIcon,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.74, 0.5),
		Size = UDim2.fromOffset(6, 1.5),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
		Rotation = 45,
	})
	corner(IconRight, 1)
	themed(IconRight, "BackgroundColor3", "TextDim")

	local Panel = new("Frame", {
		Parent = Frame,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Lumen.Theme.Panel,
		BorderSizePixel = 0,
	})
	themed(Panel, "BackgroundColor3", "Panel")
	corner(Panel, 8)
	local PanelStroke = stroke(Panel, Lumen.Theme.Border, 1, 0.65)
	themed(PanelStroke, "Color", "Border")

	local Content = new("Frame", {
		Parent = Panel,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	})
	padding(Content, 5, 5, 12, 12)
	list(Content, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 0) })

	list(Frame, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) })

	Section.Frame = Frame
	Section.Panel = Panel
	Section.Content = Content
	Section.Items = { Frame = Frame, Header = Header, Title = Title, Content = Content, Panel = Panel }

	function Section:SetText(text)
		Section.Name = tostring(text)
		Title.Text = string.upper(Section.Name)
	end

	function Section:SetCollapsed(collapsed)
		Section.Collapsed = collapsed and true or false
		Content.Visible = not Section.Collapsed
		tween(IconLeft, { Rotation = Section.Collapsed and 45 or -45 }, 0.14)
		tween(IconRight, { Rotation = Section.Collapsed and -45 or 45 }, 0.14)
	end

	-- the section title brightens on hover, so it is obvious that it collapses
	connect(Header.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(Title, { TextTransparency = 0.05 }, 0.14)
	end)

	connect(Header.MouseLeave, function()
		tween(Title, { TextTransparency = 0.25 }, 0.14)
	end)

	connect(Header.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Section:SetCollapsed(not Section.Collapsed)
	end)

	if ctx.Page and ctx.Page.Sections then
		ctx.Page.Sections[Section] = Frame
	end

	return Section
end

local function buildColumns(holder, count)
	count = math.clamp(tonumber(count) or 2, 1, 4)

	local columns = { }

	list(holder, {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
	})

	local pad = 10 * (count - 1) / count

	for index = 1, count do
		local column = new("ScrollingFrame", {
			Parent = holder,
			LayoutOrder = index,
			Size = UDim2.new(1 / count, -pad, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
		})
		themed(column, "ScrollBarImageColor3", "Border")

		list(column, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
		columns[index] = column
	end

	return columns
end

-- section element api (shared by Page/SubPage sections)
local function sectionElementMethods(Section, ctx)
	function Section:Toggle(data)
		return CreateToggle(Section.Content, data or { }, ctx)
	end

	function Section:Slider(data)
		return CreateSlider(Section.Content, data or { }, ctx)
	end

	function Section:Dropdown(data)
		return CreateDropdown(Section.Content, data or { }, ctx)
	end

	function Section:Textbox(data)
		return CreateTextbox(Section.Content, data or { }, ctx)
	end

	function Section:Button(data)
		return CreateButton(Section.Content, data or { }, ctx)
	end

	function Section:Label(text, alignment, tooltip)
		if type(text) == "table" then
			local data = text
			data.Alignment = data.Alignment or alignment
			return CreateLabel(Section.Content, data, ctx)
		end

		return CreateLabel(Section.Content, {
			Name = text,
			Alignment = alignment or "Left",
			Tooltip = tooltip,
		}, ctx)
	end

	function Section:Keybind(data)
		return CreateKeybindRow(Section.Content, data or { }, ctx)
	end

	function Section:Colorpicker(data)
		return CreateColorpickerRow(Section.Content, data or { }, ctx)
	end

	function Section:Divider()
		local frame = new("Frame", {
			Parent = Section.Content,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Lumen.Theme.Border,
			BorderSizePixel = 0,
		})
		themed(frame, "BackgroundColor3", "Border")
		return frame
	end

	return Section
end

function Lumen:Window(data)
	data = data or { }

	Lumen:EnsureRoot()
	ensureKeybindRouter()

	-- from here to the end of this function the settings page is built: none of that
	-- counts as a user change, so autosave stays quiet (see scheduleAutosave)
	Lumen.State.Building = true
	if autosaveThread then
		pcall(task.cancel, autosaveThread)
		autosaveThread = nil
	end

	-- only one window at a time: re-running the script must not stack menus
	if Lumen.State.Window and Lumen.State.Window.Alive then
		Lumen.State.Window:__destroy()
	end

	local Window = {
		Alive = true, IsOpen = false,
		Name = data.Name or data.name or Lumen.LibraryName,
		Version = data.Version or data.version or Lumen.Version,
		Footer = data.Footer or data.footer or ("user: " .. (LocalPlayer and LocalPlayer.Name or "unknown")),
		Keybind = data.Keybind or data.keybind or Enum.KeyCode.RightControl,
		DiscordInvite = data.DiscordInvite or data.discord or "https://discord.gg/c3kBtN9vXb",
		FadeSpeed = tonumber(data.FadeSpeed or data.fadespeed or 0.18) or 0.18,
		Size = data.Size or data.size or UDim2.fromOffset(isMobile and 540 or 760, isMobile and 420 or 520),
		MinSize = data.MinSize or data.minsize or Vector2.new(460, 320),
		Pages = { },
		CurrentPage = nil,
		IsOpen = false,
		IsMinimized = false,
		IsDragging = false,
	}

	-- from here on this window owns every widget that is built, including the settings
	-- page below: registerOption stores the owner and __destroy() clears its options
	Lumen.State.Window = Window

	if data.Font then
		Lumen.Font = data.Font
	end

	if data.Theme and Lumen.Themes[data.Theme] then
		Lumen:SetTheme(data.Theme)
	end

	local Screen = Lumen.State.Screen
	local viewport = viewportSize()
	if viewport.X < 200 or viewport.Y < 200 then
		viewport = Vector2.new(1280, 720)
	end

	Window.BaseSize = Window.Size

	local Main = new("Frame", {
		Parent = Screen,
		Name = "Main",
		Position = UDim2.fromOffset((viewport.X - Window.Size.X.Offset) / 2, (viewport.Y - Window.Size.Y.Offset) / 2),
		Size = Window.Size,
		BackgroundColor3 = Lumen.Theme.Background,
		BackgroundTransparency = Lumen.WindowTransparency or 0,
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 1,
	})
	themed(Main, "BackgroundColor3", "Background")
	corner(Main, 12)
	local MainStroke = stroke(Main, Lumen.Theme.Border, 1, 0.15)
	themed(MainStroke, "Color", "Border")

	-- one pixel of light along the top edge: reads as glass, costs a single frame
	local TopGlow = new("Frame", {
		Parent = Main,
		Position = UDim2.fromOffset(12, 1),
		Size = UDim2.new(1, -24, 0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		ZIndex = 42,
	})
	new("UIGradient", {
		Parent = TopGlow,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
	})

	-- fade overlay used for open/close animation
	local Fade = new("Frame", {
		Parent = Main,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Lumen.Theme.Background,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 40,
		Visible = false,
	})
	themed(Fade, "BackgroundColor3", "Background")
	corner(Fade, 12)

	-- sidebar
	local Sidebar = new("Frame", {
		Parent = Main,
		Size = UDim2.new(0, 168, 1, 0),
		BackgroundColor3 = Lumen.Theme.Sidebar,
		BorderSizePixel = 0,
		ZIndex = 2,
	})
	themed(Sidebar, "BackgroundColor3", "Sidebar")

	local Brand = new("Frame", {
		Parent = Sidebar,
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundTransparency = 1,
		ZIndex = 3,
	})

	local BrandIcon = new("Frame", {
		Parent = Brand,
		Position = UDim2.fromOffset(14, 19),
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		ZIndex = 4,
	})

	local GearRing = new("Frame", {
		Parent = BrandIcon,
		Position = UDim2.fromOffset(3, 3),
		Size = UDim2.fromOffset(10, 10),
		BackgroundTransparency = 1,
		ZIndex = 4,
	})
	corner(GearRing, 5)
	local GearStroke = stroke(GearRing, Lumen.Theme.Text, 2, 0)
	themed(GearStroke, "Color", "Text")

	local GearCore = new("Frame", {
		Parent = BrandIcon,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(3, 3),
		BackgroundColor3 = Lumen.Theme.Text,
		BorderSizePixel = 0,
		ZIndex = 4,
	})
	themed(GearCore, "BackgroundColor3", "Text")
	corner(GearCore, 1)

	for _, tooth in next, { { 6, 0, 4, 2 }, { 6, 14, 4, 2 }, { 0, 6, 2, 4 }, { 14, 6, 2, 4 } } do
		local bar = new("Frame", {
			Parent = BrandIcon,
			Position = UDim2.fromOffset(tooth[1], tooth[2]),
			Size = UDim2.fromOffset(tooth[3], tooth[4]),
			BackgroundColor3 = Lumen.Theme.Text,
			BorderSizePixel = 0,
			ZIndex = 4,
		})
		themed(bar, "BackgroundColor3", "Text")
		corner(bar, 1)
	end

	local BrandTitle = new("TextLabel", {
		Parent = Brand,
		Position = UDim2.fromOffset(36, 10),
		Size = UDim2.new(1, -42, 0, 18),
		BackgroundTransparency = 1,
		Text = Window.Name,
		TextSize = 15,
		Font = Lumen.FontBold,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4,
	})
	themed(BrandTitle, "TextColor3", "Text")

	local BrandVersion = new("TextLabel", {
		Parent = Brand,
		Position = UDim2.fromOffset(36, 29),
		Size = UDim2.new(1, -42, 0, 12),
		BackgroundTransparency = 1,
		Text = "v" .. Window.Version,
		TextSize = 10,
		Font = Lumen.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})
	themed(BrandVersion, "TextColor3", "TextDim")

	-- the pinned settings tab and the footer own the bottom strip of the sidebar,
	-- so the tab list stops right above them (no overlap, was the reported bug)
	local TabScroller = new("ScrollingFrame", {
		Parent = Sidebar,
		Position = UDim2.fromOffset(0, 62),
		Size = UDim2.new(1, 0, 1, -140),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ZIndex = 3,
	})
	padding(TabScroller, 0, 6, 8, 8)
	local TabList = list(TabScroller, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) })

	local Footer = new("TextLabel", {
		Parent = Sidebar,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 14, 1, -10),
		Size = UDim2.new(1, -28, 0, 26),
		BackgroundTransparency = 1,
		Text = Window.Footer,
		TextSize = 11,
		Font = Lumen.Font,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		ZIndex = 3,
	})
	themed(Footer, "TextColor3", "TextDim")

	-- hairline between sidebar and content, like the reference
	local SidebarLine = new("Frame", {
		Parent = Main,
		Position = UDim2.new(0, 168, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = Lumen.Theme.Border,
		BorderSizePixel = 0,
		ZIndex = 3,
	})
	themed(SidebarLine, "BackgroundColor3", "Border")

	-- content side
	local Content = new("Frame", {
		Parent = Main,
		Position = UDim2.new(0, 169, 0, 0),
		Size = UDim2.new(1, -169, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 2,
	})

	local Header = new("Frame", {
		Parent = Content,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundTransparency = 1,
		ZIndex = 3,
	})

	-- faint accent wash behind the top bar and a hairline that fades at both ends
	local HeaderWash = new("Frame", {
		Parent = Header,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Lumen.Theme.Accent,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		ZIndex = 3,
	})
	themed(HeaderWash, "BackgroundColor3", "Accent")
	new("UIGradient", {
		Parent = HeaderWash,
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
	})

	local HeaderLine = new("Frame", {
		Parent = Header,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = Lumen.Theme.Border,
		BorderSizePixel = 0,
		ZIndex = 4,
	})
	themed(HeaderLine, "BackgroundColor3", "Border")
	new("UIGradient", {
		Parent = HeaderLine,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.7),
			NumberSequenceKeypoint.new(0.5, 0.05),
			NumberSequenceKeypoint.new(1, 0.7),
		}),
	})

	-- kept for API compatibility, hidden by default (reference layout has no page title)
	local PageTitle = new("TextLabel", {
		Parent = Header,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(0, 200, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Text = "",
		TextSize = 15,
		Font = Lumen.FontBold,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4,
	})
	themed(PageTitle, "TextColor3", "Text")

	local SearchFrame = new("Frame", {
		Parent = Header,
		Position = UDim2.fromOffset(14, 9),
		Size = UDim2.fromOffset(170, 26),
		BackgroundColor3 = Lumen.Theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 4,
	})
	themed(SearchFrame, "BackgroundColor3", "Panel")
	corner(SearchFrame, 13)

	local SearchIcon = new("Frame", {
		Parent = SearchFrame,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.fromOffset(14, 26),
		BackgroundTransparency = 1,
		ZIndex = 5,
	})

	local LensRing = new("Frame", {
		Parent = SearchIcon,
		Position = UDim2.fromOffset(1, 8),
		Size = UDim2.fromOffset(8, 8),
		BackgroundTransparency = 1,
		ZIndex = 5,
	})
	corner(LensRing, 5)
	local LensStroke = stroke(LensRing, Lumen.Theme.TextDim, 1.4, 0.25)
	themed(LensStroke, "Color", "TextDim")

	local LensHandle = new("Frame", {
		Parent = SearchIcon,
		Position = UDim2.fromOffset(8, 15),
		Size = UDim2.fromOffset(5, 1.6),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
		Rotation = 45,
		ZIndex = 5,
	})
	corner(LensHandle, 1)
	themed(LensHandle, "BackgroundColor3", "TextDim")

	local SearchBox = new("TextBox", {
		Parent = SearchFrame,
		Position = UDim2.fromOffset(26, 0),
		Size = UDim2.new(1, -36, 1, 0),
		BackgroundTransparency = 1,
		PlaceholderText = "Search...",
		PlaceholderColor3 = Lumen.Theme.TextDim,
		Text = "",
		TextSize = 12,
		Font = Lumen.Font,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 5,
	})
	themed(SearchBox, "TextColor3", "Text")
	themed(SearchBox, "PlaceholderColor3", "TextDim")

	local DiscordButton = new("TextButton", {
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -68, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 5,
	})

	local DiscordBody = new("Frame", {
		Parent = DiscordButton,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(15, 11),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
		ZIndex = 6,
	})
	themed(DiscordBody, "BackgroundColor3", "TextDim")
	corner(DiscordBody, 5)

	for _, eyeX in next, { 4, 9 } do
		local eye = new("Frame", {
			Parent = DiscordBody,
			Position = UDim2.fromOffset(eyeX, 3),
			Size = UDim2.fromOffset(2.5, 4),
			BackgroundColor3 = Lumen.Theme.Background,
			BorderSizePixel = 0,
			ZIndex = 7,
		})
		themed(eye, "BackgroundColor3", "Background")
		corner(eye, 1)
	end

	connect(DiscordButton.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(DiscordBody, { BackgroundColor3 = Lumen.Theme.Text }, 0.12)
	end)
	connect(DiscordButton.MouseLeave, function()
		tween(DiscordBody, { BackgroundColor3 = Lumen.Theme.TextDim }, 0.12)
	end)
	attachTooltip(DiscordButton, data.DiscordTooltip or data.discordtooltip or "Join for more Information")

	connect(DiscordButton.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		local invite = Window.DiscordInvite
		if not invite or invite == "" then
			return
		end

		pcall(function()
			setclipboard(invite)
		end)

		Lumen:Notification({
			Name = "discord",
			Description = "invite copied to clipboard: " .. invite,
			Duration = 4,
			Color = Lumen.Theme.Accent,
		})
	end)

	-- soft round hover used by the window buttons
	local function hoverLayer(button, radius, zIndex)
		local hover = new("Frame", {
			Parent = button,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Lumen.Theme.Element,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = zIndex,
		})
		themed(hover, "BackgroundColor3", "Element")
		corner(hover, radius or 6)

		connect(button.MouseEnter, function()
			if not canInteract() then
				return
			end

			tween(hover, { BackgroundTransparency = 0.35 }, 0.14)
		end)

		connect(button.MouseLeave, function()
			tween(hover, { BackgroundTransparency = 1 }, 0.14)
		end)

		return hover
	end

	local MinimizeButton = new("TextButton", {
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -42, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		BackgroundTransparency = 1,
		Text = "-",
		TextSize = 16,
		Font = Lumen.FontBold,
		AutoButtonColor = false,
		ZIndex = 5,
	})
	themed(MinimizeButton, "TextColor3", "TextDim")

	local CloseButton = new("TextButton", {
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -14, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		BackgroundTransparency = 1,
		Text = "x",
		TextSize = 12,
		Font = Lumen.FontBold,
		AutoButtonColor = false,
		ZIndex = 5,
	})
	themed(CloseButton, "TextColor3", "TextDim")

	local PagesHolder = new("Frame", {
		Parent = Content,
		Position = UDim2.new(0, 14, 0, 48),
		Size = UDim2.new(1, -28, 1, -62),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 3,
	})

	-- resize handle
	local ResizeHandle = new("TextButton", {
		Parent = Main,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -2, 1, -2),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 20,
	})

	local HandleDot = new("Frame", {
		Parent = ResizeHandle,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -3, 1, -3),
		Size = UDim2.fromOffset(6, 6),
		BackgroundColor3 = Lumen.Theme.TextDim,
		BorderSizePixel = 0,
		ZIndex = 21,
	})
	themed(HandleDot, "BackgroundColor3", "TextDim")
	corner(HandleDot, 2)

	-- the resize dot lights up in the accent colour while it is hovered
	connect(ResizeHandle.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(HandleDot, { BackgroundColor3 = Lumen.Theme.Accent }, 0.14)
	end)

	connect(ResizeHandle.MouseLeave, function()
		tween(HandleDot, { BackgroundColor3 = Lumen.Theme.TextDim }, 0.14)
	end)

	-- minimized pill
	local MinimizedBar = new("TextButton", {
		Parent = Screen,
		Size = UDim2.fromOffset(190, 34),
		BackgroundColor3 = Lumen.Theme.Background,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Visible = false,
		ZIndex = 30,
	})
	themed(MinimizedBar, "BackgroundColor3", "Background")
	corner(MinimizedBar, 8)
	local MinimizedStroke = stroke(MinimizedBar, Lumen.Theme.Border, 1, 0.2)
	themed(MinimizedStroke, "Color", "Border")

	local MinimizedAccent = new("Frame", {
		Parent = MinimizedBar,
		Position = UDim2.fromOffset(0, 7),
		Size = UDim2.new(0, 2, 1, -14),
		BackgroundColor3 = Lumen.Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 31,
	})
	themed(MinimizedAccent, "BackgroundColor3", "Accent")
	corner(MinimizedAccent, 2)

	connect(MinimizedBar.MouseEnter, function()
		tween(MinimizedBar, { BackgroundColor3 = Lumen.Theme.Element, BackgroundTransparency = 0 }, 0.14)
	end)

	connect(MinimizedBar.MouseLeave, function()
		tween(MinimizedBar, { BackgroundColor3 = Lumen.Theme.Background, BackgroundTransparency = 0 }, 0.14)
	end)

	local MinimizedText = new("TextLabel", {
		Parent = MinimizedBar,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -20, 1, 0),
		BackgroundTransparency = 1,
		Text = Window.Name .. "  <font color=\"#8a8f9e\">(click to open)</font>",
		TextSize = 12,
		Font = Lumen.FontMedium,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 31,
	})
	themed(MinimizedText, "TextColor3", "Text")

	Window.Items = {
		Screen = Screen, Main = Main, Sidebar = Sidebar, Content = Content,
		PagesHolder = PagesHolder, TabScroller = TabScroller, TabList = TabList,
		PageTitle = PageTitle, SearchBox = SearchBox, Fade = Fade,
		MinimizedBar = MinimizedBar, Brand = Brand, Header = Header,
		BrandTitle = BrandTitle, BrandVersion = BrandVersion, BrandIcon = BrandIcon,
		MinimizeButton = MinimizeButton, CloseButton = CloseButton,
	}

	Lumen.State.Window = Window
	Lumen.State.MinimizedBar = MinimizedBar

	-- while the window is dragged the chrome steps back and a small drag hud takes
	-- over: accent brackets, the hub name, a bar that grows with the drag speed and
	-- guides that dock the window to the sides of the screen. every piece below is
	-- static geometry plus one shot tweens - the only per frame work is the short
	-- ghost loop, and it only runs while the mouse is held down.
	local DragLabel = new("TextLabel", {
		Parent = Main,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -60, 0, 64),
		BackgroundTransparency = 1,
		Text = Window.Name,
		TextSize = 44,
		Font = Lumen.FontBold,
		RichText = true,
		TextTransparency = 0.2,
		Rotation = -8,
		Visible = false,
		ZIndex = 45,
	})
	themed(DragLabel, "TextColor3", "Text")

	local DragBar = new("Frame", {
		Parent = Main,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, -36),
		Size = UDim2.fromOffset(56, 3),
		BackgroundColor3 = Lumen.Theme.Accent,
		BorderSizePixel = 0,
		Rotation = -8,
		Visible = false,
		ZIndex = 45,
	})
	themed(DragBar, "BackgroundColor3", "Accent")
	corner(DragBar, 2)
	new("UIGradient", {
		Parent = DragBar,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(0.55, 0.2),
			NumberSequenceKeypoint.new(1, 0.75),
		}),
	})

	local DragSub = new("TextLabel", {
		Parent = Main,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 28),
		Size = UDim2.new(1, -60, 0, 18),
		BackgroundTransparency = 1,
		Text = "v" .. tostring(Window.Version) .. "  |  lumen core  |  release to drop",
		TextSize = 12,
		Font = Lumen.FontMedium,
		RichText = true,
		TextTransparency = 0.3,
		Rotation = -8,
		Visible = false,
		ZIndex = 45,
	})
	themed(DragSub, "TextColor3", "TextDim")

	-- accent brackets that frame the window while it is being dragged
	local BracketHolder = new("Frame", {
		Parent = Main,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 44,
	})

	for _, cornerSpec in next, { { 0, 0 }, { 1, 0 }, { 0, 1 }, { 1, 1 } } do
		local cx, cy = cornerSpec[1], cornerSpec[2]
		local offsetX = (cx == 0) and 13 or -13
		local offsetY = (cy == 0) and 13 or -13

		for _, barSpec in next, { { 24, 2 }, { 2, 24 } } do
			local bracket = new("Frame", {
				Parent = BracketHolder,
				AnchorPoint = Vector2.new(cx, cy),
				Position = UDim2.new(cx, offsetX, cy, offsetY),
				Size = UDim2.fromOffset(barSpec[1], barSpec[2]),
				BackgroundColor3 = Lumen.Theme.Accent,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				ZIndex = 44,
			})
			themed(bracket, "BackgroundColor3", "Accent")
			corner(bracket, 2)
		end
	end

	-- soft shadow behind the window: three stacked layers, drawn once and only
	-- moved when the window moves (no per frame work)
	local Shadow = new("Frame", {
		Parent = Screen,
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 0,
	})

	for _, layerSpec in next, { { 9, 0.87 }, { 6, 0.91 }, { 3, 0.94 } } do
		local inset = layerSpec[1]
		local layer = new("Frame", {
			Parent = Shadow,
			Position = UDim2.fromOffset(inset, inset + 2),
			Size = UDim2.new(1, -inset * 2, 1, -inset * 2),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = layerSpec[2],
			BorderSizePixel = 0,
			ZIndex = 0,
		})
		corner(layer, 16)
	end

	local function syncShadow()
		local position, size = Main.Position, Main.Size
		Shadow.Position = UDim2.new(position.X.Scale, position.X.Offset - 9, position.Y.Scale, position.Y.Offset - 7)
		Shadow.Size = UDim2.new(size.X.Scale, size.X.Offset + 18, size.Y.Scale, size.Y.Offset + 14)
		Shadow.Visible = Main.Visible and Window.IsOpen and true or false
	end

	connect(Main:GetPropertyChangedSignal("Position"), syncShadow)
	connect(Main:GetPropertyChangedSignal("Size"), syncShadow)
	connect(Main:GetPropertyChangedSignal("Visible"), syncShadow)
	syncShadow()

	--===== drag fx: motion ghost, edge guides, drop ripple =====
	local DragFX = { Guides = { } }
	do
		-- translucent accent copy of the window that lags behind it while dragging
		local Ghost = new("Frame", {
			Parent = Screen,
			Position = Main.Position,
			Size = Main.Size,
			BackgroundColor3 = Lumen.Theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 0,
		})
		themed(Ghost, "BackgroundColor3", "Accent")
		corner(Ghost, 12)
		new("UIGradient", {
			Parent = Ghost,
			Rotation = 90,
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.2),
				NumberSequenceKeypoint.new(0.6, 0.65),
				NumberSequenceKeypoint.new(1, 0.95),
			}),
		})

		-- thin accent lines that appear when the window is close to a screen edge
		for _, guideSpec in next, {
			{ "left", UDim2.fromOffset(0, 0), UDim2.new(0, 2, 1, 0) },
			{ "right", UDim2.new(1, -2, 0, 0), UDim2.new(0, 2, 1, 0) },
			{ "top", UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 2) },
			{ "bottom", UDim2.new(0, 0, 1, -2), UDim2.new(1, 0, 0, 2) },
		} do
			local guide = new("Frame", {
				Parent = Screen,
				Position = guideSpec[2],
				Size = guideSpec[3],
				BackgroundColor3 = Lumen.Theme.Accent,
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 60,
			})
			themed(guide, "BackgroundColor3", "Accent")
			DragFX.Guides[guideSpec[1]] = guide
		end

		-- one shot ring that flashes out when the window is dropped
		local Ripple = new("Frame", {
			Parent = Screen,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 2,
		})
		corner(Ripple, 12)
		local RippleStroke = stroke(Ripple, Lumen.Theme.Accent, 2, 1)
		themed(RippleStroke, "Color", "Accent")

		DragFX.Ghost = Ghost
		DragFX.Ripple = Ripple
		DragFX.RippleStroke = RippleStroke
	end

	local dragSpeed = 0
	local dragTilt = 0
	local dragDock = nil
	local dragSnapX = nil
	local dragSnapY = nil
	local dragClock = 0
	local dragBarWidth = 56
	local ghostConnection = nil
	local ghostX, ghostY = 0, 0
	local ghostUntil = 0
	local lastX, lastY = 0, 0

	local function guideSet(key, visible)
		local guide = DragFX.Guides[key]
		if guide and guide.Visible ~= visible then
			guide.Visible = visible
		end
	end

	local function guidesHide()
		for key in next, DragFX.Guides do
			guideSet(key, false)
		end
	end

	local function dragHudReset()
		dragSpeed = 0
		dragTilt = 0
		dragBarWidth = 56
		DragBar.Size = UDim2.fromOffset(56, 3)
		DragLabel.Rotation = -8
		DragBar.Rotation = -8
		DragSub.Rotation = -8
		DragSub.Text = "v" .. tostring(Window.Version) .. "  |  lumen core  |  release to drop"
		DragLabel.TextColor3 = Lumen.Theme.Text
	end

	local function ghostStop()
		if ghostConnection then
			disconnectTransient(ghostConnection)
			ghostConnection = nil
		end
	end

	local function dragStep(deltaTime)
		local dt = tonumber(deltaTime) or 0
		if dt <= 0 or dt > 0.25 then
			dt = 0.016
		end

		local px = Main.Position.X.Offset
		local py = Main.Position.Y.Offset
		local dx = px - lastX
		local dy = py - lastY
		lastX, lastY = px, py

		-- speed / tilt are smoothed so the hud does not flicker
		local instant = math.sqrt(dx * dx + dy * dy) / dt
		dragSpeed = dragSpeed + (instant - dragSpeed) * 0.35
		dragTilt = dragTilt + (math.clamp((dx / dt) * 0.02, -6, 6) - dragTilt) * 0.3

		local ghost = DragFX.Ghost
		ghostX = ghostX + (px - ghostX) * 0.32
		ghostY = ghostY + (py - ghostY) * 0.32
		ghost.Position = UDim2.fromOffset(math.floor(ghostX + 0.5), math.floor(ghostY + 0.5))
		ghost.Size = Main.Size

		-- edge guides: near enough to a screen border, show the dock line
		local viewport = viewportSize()
		local width = Main.Size.X.Offset
		local height = Main.Size.Y.Offset
		local left = px
		local right = viewport.X - (px + width)
		local top = py
		local bottom = viewport.Y - (py + height)
		local threshold = 24

		local dockX, dockY = nil, nil
		if left <= threshold or right <= threshold then
			dockX = (left <= right) and "left" or "right"
		end
		if top <= threshold or bottom <= threshold then
			dockY = (top <= bottom) and "top" or "bottom"
		end

		local margin = 6
		dragSnapX = nil
		if dockX == "left" then
			dragSnapX = margin
		elseif dockX == "right" then
			dragSnapX = viewport.X - width - margin
		end

		dragSnapY = nil
		if dockY == "top" then
			dragSnapY = margin
		elseif dockY == "bottom" then
			dragSnapY = viewport.Y - height - margin
		end

		guideSet("left", dockX == "left")
		guideSet("right", dockX == "right")
		guideSet("top", dockY == "top")
		guideSet("bottom", dockY == "bottom")

		-- the dock string is only rebuilt when it actually changes (no churn)
		local dockText = nil
		if dockX and dockY then
			dockText = dockY .. " " .. dockX
		elseif dockX then
			dockText = dockX
		elseif dockY then
			dockText = dockY
		end

		if dockText ~= dragDock then
			dragDock = dockText
			Window.LastDock = dockText
		end

		Window.DockX = dragSnapX
		Window.DockY = dragSnapY

		-- hud: the bar grows with the speed, the name tilts into the movement
		local barWidth = math.clamp(56 + dragSpeed * 0.2, 56, 320)
		if math.abs(barWidth - dragBarWidth) > 5 then
			dragBarWidth = barWidth
			tween(DragBar, { Size = UDim2.fromOffset(math.floor(barWidth + 0.5), 3) }, 0.14)
		end

		DragLabel.Rotation = -8 + dragTilt
		DragSub.Rotation = -8 + dragTilt * 0.5

		dragClock = dragClock + dt
		if dragClock >= 0.08 then
			dragClock = 0
			local tail = dragDock and ("dock " .. dragDock) or "release to drop"
			DragSub.Text = "v" .. tostring(Window.Version) .. "  |  lumen core  |  "
				.. tostring(math.floor(dragSpeed + 0.5)) .. " px/s  |  " .. tail
		end

		-- the ghost catches up for a moment after the drop, then everything stops
		if not Window.IsDragging and os.clock() >= ghostUntil then
			ghost.Visible = false
			ghostStop()
		end
	end

	local dragHooks = {
		Begin = function()
			-- the handle can only be grabbed while the menu is on screen
			if not Window.IsOpen or Window.IsMinimized then
				return
			end

			Window.IsDragging = true
			Sidebar.Visible = false
			Content.Visible = false
			ResizeHandle.Visible = false
			DragLabel.Visible = true
			DragBar.Visible = true
			DragSub.Visible = true
			BracketHolder.Visible = true
			tween(Main, { BackgroundTransparency = math.min(0.6, (Lumen.WindowTransparency or 0) + 0.35) }, 0.15)
			tween(MainStroke, { Color = Lumen.Theme.Accent, Transparency = 0.05, Thickness = 1.6 }, 0.15)
			DragLabel.TextColor3 = Lumen.Theme.Accent

			-- a drag counts as "not interactive": tooltips / pickers step aside
			syncPopups()

			local px = Main.Position.X.Offset
			local py = Main.Position.Y.Offset
			ghostX, ghostY = px, py
			lastX, lastY = px, py
			dragSpeed = 0
			dragTilt = 0
			dragClock = 0
			dragDock = nil
			dragSnapX, dragSnapY = nil, nil

			local ghost = DragFX.Ghost
			ghost.Position = UDim2.fromOffset(px, py)
			ghost.Size = Main.Size
			ghost.BackgroundTransparency = 1
			ghost.Visible = true
			tween(ghost, { BackgroundTransparency = 0.72 }, 0.14)

			if not ghostConnection then
				ghostConnection = connectTransient(RunService.RenderStepped, dragStep)
			end
		end,
		End = function(moved)
			-- nothing to restore unless a drag was really in progress
			if not Window.IsDragging then
				return
			end

			Window.IsDragging = false

			Sidebar.Visible = true
			Content.Visible = true
			ResizeHandle.Visible = true
			DragLabel.Visible = false
			DragBar.Visible = false
			DragSub.Visible = false
			BracketHolder.Visible = false
			tween(Main, { BackgroundTransparency = Lumen.WindowTransparency or 0 }, 0.15)
			tween(MainStroke, { Color = Lumen.Theme.Border, Transparency = 0.15, Thickness = 1 }, 0.18)

			-- docking and the drop ring only make sense when the window really moved:
			-- a plain click on the title bar just restores the chrome and stops here
			if moved then
				-- dock: the guides that were showing decide where the window lands
				if dragSnapX or dragSnapY then
					tween(Main, {
						Position = UDim2.fromOffset(
							dragSnapX or Main.Position.X.Offset,
							dragSnapY or Main.Position.Y.Offset
						),
					}, 0.18, Enum.EasingStyle.Quart)
				end

				-- drop ring: one tween pair, then it parks itself again
				local ripple = DragFX.Ripple
				local rippleStroke = DragFX.RippleStroke
				local width = Main.Size.X.Offset
				local height = Main.Size.Y.Offset
				ripple.Position = UDim2.fromOffset(
					Main.Position.X.Offset + width / 2,
					Main.Position.Y.Offset + height / 2
				)
				ripple.Size = UDim2.fromOffset(width, height)
				ripple.Visible = true
				rippleStroke.Transparency = 0.2
				tween(ripple, { Size = UDim2.fromOffset(width + 20, height + 20) }, 0.34)
				tween(rippleStroke, { Transparency = 1 }, 0.34)
				task.delay(0.4, function()
					if ripple and ripple.Parent then
						ripple.Visible = false
					end
				end)

				-- the ghost keeps drifting towards the window for a moment
				ghostUntil = os.clock() + 0.3
				tween(DragFX.Ghost, { BackgroundTransparency = 1 }, 0.3)
			else
				-- no movement: park the trail right away (the step loop stops itself)
				ghostUntil = 0
				DragFX.Ghost.Visible = false
			end

			guidesHide()
			dragHudReset()

			-- back to a normal menu: popups may show and react again
			syncPopups()
		end,
	}

	Window.Items.DragLabel = DragLabel
	Window.Items.DragBar = DragBar
	Window.Items.DragSub = DragSub
	Window.Items.Brackets = BracketHolder
	Window.Items.DragGhost = DragFX.Ghost
	Window.Items.DragGuides = DragFX.Guides
	Window.Items.DragRipple = DragFX.Ripple
	Window.Items.Shadow = Shadow

	makeDraggable(Main, Header, dragHooks)
	makeDraggable(Main, Brand, dragHooks)
	makeResizable(Main, ResizeHandle, Window.MinSize)

	-- the minimized pill is draggable, but a plain click should restore the window
	do
		local barStart = nil
		local barMoved = false

		connect(MinimizedBar.InputBegan, function(input)
			if not Window.Alive then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				barStart = input.Position
				barMoved = false
			end
		end)

		connect(UserInputService.InputChanged, function(input)
			if not barStart then
				return
			end

			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			local delta = input.Position - barStart
			if delta.Magnitude > 4 then
				barMoved = true
			end

			if barMoved then
				MinimizedBar.Position = UDim2.fromOffset(
					MinimizedBar.Position.X.Offset + delta.X,
					MinimizedBar.Position.Y.Offset + delta.Y
				)
				barStart = input.Position
			end
		end)

		connect(UserInputService.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				barStart = nil
			end
		end)

		connect(MinimizedBar.MouseButton1Down, function()
			if not barMoved and Window.Alive then
				Window:SetMinimized(false)
			end
		end)
	end

	function Window:SwitchPage(page)
		for _, other in next, Window.Pages do
			other:Switch(other == page)
		end

		local target = page
		if page.SubPages then
			for _, sub in next, page.SubPageList do
				if sub.Active then
					target = sub
				end
			end
		end

		Window.CurrentPage = target

		if target == page then
			PageTitle.Text = page.Name
		else
			PageTitle.Text = page.Name .. "  <font size=\"12\" color=\"#8a8f9e\">/ " .. target.Name .. "</font>"
		end

		if SearchBox.Text ~= "" then
			SearchBox.Text = ""
		end
	end

	function Window:SetOpen(open, instant)
		open = open and true or false
		if Window.IsOpen == open then
			return
		end

		Window.IsOpen = open
		local speed = instant and 0 or Window.FadeSpeed

		-- a menu that leaves the screen must not leave anything behind: dropdown
		-- lists close, a keybind waiting for a key stops, and the floating popups
		-- (colorpickers, keybind menus, tooltips) are hidden, so a closed ui cannot
		-- be clicked, hovered or outlined
		closeTransientUI()

		if open then
			MinimizedBar.Visible = false
			MinimizedBar.Position = Main.Position
			Main.Visible = true

			if speed > 0 then
				local restPosition = Main.Position
				Main.Position = UDim2.new(
					restPosition.X.Scale, restPosition.X.Offset,
					restPosition.Y.Scale, restPosition.Y.Offset + 14
				)
				tween(Main, { Position = restPosition }, speed + 0.1, Enum.EasingStyle.Quint)
			end

			Fade.Visible = true
			Fade.BackgroundTransparency = 0
			tween(Fade, { BackgroundTransparency = 1 }, speed)
			task.delay(speed + 0.05, function()
				if Window.IsOpen then
					Fade.Visible = false
				end
			end)
		else
			Fade.Visible = true
			tween(Fade, { BackgroundTransparency = 0 }, speed)
			task.delay(speed + 0.02, function()
				if not Window.IsOpen then
					Main.Visible = false
					Fade.Visible = false
				end
			end)
		end

		-- a keybind list that is tied to the menu has to follow it, otherwise "show
		-- the list while the menu is open" turns into "the list shows up whenever"
		if Lumen.State.KeybindsList and Lumen.State.KeybindsList.SyncToWindow then
			Lumen.State.KeybindsList:SyncToWindow()
		end
	end

	function Window:SetMinimized(minimized)
		Window.IsMinimized = minimized and true or false

		if Window.IsMinimized then
			MinimizedBar.Position = UDim2.fromOffset(Main.AbsolutePosition.X, Main.AbsolutePosition.Y)
			Window:SetOpen(false, true)
			Main.Visible = false
			MinimizedBar.Visible = true
		else
			MinimizedBar.Visible = false
			Main.Position = UDim2.fromOffset(MinimizedBar.AbsolutePosition.X, MinimizedBar.AbsolutePosition.Y)
			Window:SetOpen(true, true)
		end

		if Lumen.State.KeybindsList and Lumen.State.KeybindsList.SyncToWindow then
			Lumen.State.KeybindsList:SyncToWindow()
		end
	end

	function Window:SetText(text)
		Window.Name = text
		BrandTitle.Text = text
		DragLabel.Text = text
	end

	function Window:SetTransparency(value)
		value = math.clamp(tonumber(value) or 0, 0, 0.85)
		Lumen.WindowTransparency = value
		pcall(function()
			Main.BackgroundTransparency = value
		end)
		return value
	end

	function Window:Unload()
		Lumen:Unload()
	end

	Window.Destroy = Window.Unload

	-- internal: tear this window down so a fresh one can take over
	function Window:__destroy()
	-- a destroyed menu must not keep answering: its options would be found by config
	-- loads and autoload restores and the values would land on invisible widgets
	for flag, option in next, Lumen.Options do
		if option.Window == Window then
			Lumen.Options[flag] = nil
			Lumen.Flags[flag] = nil
		end
	end

	do
		local kept = { }
		for _, entry in ipairs(Lumen.State.ThemePickers or { }) do
			if entry.Window ~= Window then
				table.insert(kept, entry)
			end
		end
		Lumen.State.ThemePickers = kept

		local keptPresets = { }
		for _, entry in ipairs(Lumen.State.ThemePresets or { }) do
			if entry.Window ~= Window then
				table.insert(keptPresets, entry)
			end
		end
		Lumen.State.ThemePresets = keptPresets
	end


		Window.Alive = false
		Window.IsOpen = false

		if Lumen.State.Window == Window then
			Lumen.State.Window = nil
		end

		if Lumen.State.MinimizedBar == MinimizedBar then
			Lumen.State.MinimizedBar = nil
		end

		pcall(function()
			MinimizedBar:Destroy()
		end)

		pcall(function()
			if Window.Items.FloatButton then
				Window.Items.FloatButton:Destroy()
			end
		end)

		-- widgets that belonged to this window stop listening right here: otherwise the
		-- input router would keep scanning them and their callbacks would still fire
		-- after the window was replaced
		for index = #Lumen.State.Keybinds, 1, -1 do
			if Lumen.State.Keybinds[index].Window == Window then
				table.remove(Lumen.State.Keybinds, index)
			end
		end

		for index = #Lumen.State.Dropdowns, 1, -1 do
			if Lumen.State.Dropdowns[index].Window == Window then
				table.remove(Lumen.State.Dropdowns, index)
			end
		end

		-- drop every theme entry that lives inside this window before it is destroyed:
		-- otherwise a replaced window keeps thousands of dead entries in the registry
		pruneThemeSubtree(Main)
		pruneThemeSubtree(MinimizedBar)
		pruneThemeSubtree(Brand)
		pruneThemeSubtree(Shadow)

		for index = #Lumen.State.PopupWindows, 1, -1 do
			local entry = Lumen.State.PopupWindows[index]
			if entry.Owner == Window then
				table.remove(Lumen.State.PopupWindows, index)
				pcall(function()
					entry.Instance:Destroy()
				end)
			end
		end

		pcall(function()
			Main:Destroy()
		end)

		-- the window is gone: no floating popup may stay on the screen
		syncPopups()

		if Lumen.State.KeybindsList then
			pcall(function()
				Lumen.State.KeybindsList:Refresh()
			end)
		end
	end

	-- page factory
	function Window:Page(pageData)
		pageData = pageData or { }

		local Page = {
			Type = "Page",
			Window = Window,
			Name = pageData.Name or pageData.name or "page",
			Columns = tonumber(pageData.Columns or pageData.columns or 2) or 2,
			SubPages = (pageData.SubPages or pageData.subpages) and true or false,
			Elements = { },
			Sections = { },
			SubPageList = { },
			Active = false,
		}

		local Holder = new("Frame", {
			Parent = PagesHolder,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = false,
			ZIndex = 4,
		})

		local ColumnsHolder = new("Frame", {
			Parent = Holder,
			Size = Page.SubPages and UDim2.new(1, 0, 1, -40) or UDim2.fromScale(1, 1),
			Position = Page.SubPages and UDim2.fromOffset(0, 40) or UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1,
			ZIndex = 4,
		})

		Page.Columns = buildColumns(ColumnsHolder, Page.Columns)

		-- optional group label above the tab, e.g. Page({ Group = "combat" })
		Window.TabOrder = (Window.TabOrder or 0) + 1
		local group = pageData.Group or pageData.group
		if group and group ~= Window.LastGroup then
			Window.LastGroup = group

			local GroupLabel = new("TextLabel", {
				Parent = TabScroller,
				LayoutOrder = Window.TabOrder,
				Position = UDim2.fromOffset(8, 4),
				Size = UDim2.new(1, -16, 0, 14),
				BackgroundTransparency = 1,
				Text = string.upper(tostring(group)),
				TextSize = 10,
				Font = Lumen.FontBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 4,
			})
			themed(GroupLabel, "TextColor3", "TextDim")
			GroupLabel.TextTransparency = 0.3

			Window.TabOrder = Window.TabOrder + 1
		end

		-- tab button (pill style)
		local Tab = new("TextButton", {
			Parent = TabScroller,
			LayoutOrder = Window.TabOrder,
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundColor3 = Lumen.Theme.Element,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 4,
		})
		corner(Tab, 8)
		themed(Tab, "BackgroundColor3", "Element")

		local TabText = new("TextLabel", {
			Parent = Tab,
			Position = UDim2.fromOffset(12, 0),
			Size = UDim2.new(1, -20, 1, 0),
			BackgroundTransparency = 1,
			Text = Page.Name,
			TextSize = 13,
			Font = Lumen.FontMedium,
			RichText = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 5,
		})
		themed(TabText, "TextColor3", "TextDim")

		-- little accent stripe that marks the active tab (doubles as a focus hint)
		local TabAccent = new("Frame", {
			Parent = Tab,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 5, 0.5, 0),
			Size = UDim2.fromOffset(2, 14),
			BackgroundColor3 = Lumen.Theme.Accent,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 6,
		})
		corner(TabAccent, 2)
		themed(TabAccent, "BackgroundColor3", "Accent")

		Page.Items = { Holder = Holder, Tab = Tab, TabText = TabText, TabAccent = TabAccent, ColumnsHolder = ColumnsHolder }

		function Page:Switch(active)
			Page.Active = active and true or false
			Holder.Visible = Page.Active

			Tab.BackgroundTransparency = Page.Active and 0 or 1
			TabAccent.Visible = Page.Active
			TabText.Position = Page.Active and UDim2.fromOffset(14, 0) or UDim2.fromOffset(12, 0)
			TabText.TextColor3 = Page.Active and Lumen.Theme.Text or Lumen.Theme.TextDim
			TabText.Font = Page.Active and Lumen.FontBold or Lumen.FontMedium

			-- the page slides in, so switching tabs reads as a transition
			if Page.Active then
				Holder.Position = UDim2.fromOffset(0, 10)
				tween(Holder, { Position = UDim2.fromOffset(0, 0) }, 0.22, Enum.EasingStyle.Quart)
			end
		end

		connect(Tab.MouseButton1Down, function()
			if not canInteract() then
				return
			end

			Window:SwitchPage(Page)
		end)

		connect(Tab.MouseEnter, function()
			if not canInteract() then
				return
			end

			tween(TabText, { Position = UDim2.fromOffset(15, 0) }, 0.12)
			tween(TabAccent, { Size = UDim2.fromOffset(2, 20), BackgroundTransparency = 0.2 }, 0.14)
			if not Page.Active then
				tween(Tab, { BackgroundTransparency = 0.55 }, 0.14)
			end
		end)

		connect(Tab.MouseLeave, function()
			tween(TabText, { Position = UDim2.fromOffset(12, 0) }, 0.12)
			tween(TabAccent, { Size = UDim2.fromOffset(2, 14), BackgroundTransparency = 0 }, 0.14)
			if not Page.Active then
				tween(Tab, { BackgroundTransparency = 1 }, 0.14)
			end
		end)

		function Page:Section(sectionData)
			sectionData = sectionData or { }
			local side = math.clamp(tonumber(sectionData.Side or sectionData.side or 1) or 1, 1, #Page.Columns)

			local ctx = { Window = Window, Page = Page, Section = nil }
			local section = CreateSection(Page.Columns[side], sectionData, ctx)
			ctx.Section = section

			sectionElementMethods(section, ctx)
			return section
		end

		function Page:SubPage(subData)
			subData = subData or { }

			if not Page.SubPages then
				warn("[lumen] page " .. Page.Name .. " was not created with SubPages = true")
			end

			local SubPage = {
				Type = "SubPage",
				Window = Window,
				Page = Page,
				Name = subData.Name or subData.name or "subpage",
				Columns = tonumber(subData.Columns or subData.columns or 2) or 2,
				Elements = { },
				Sections = { },
				Active = false,
			}

			if not Page.SubStrip then
				Page.SubStrip = new("Frame", {
					Parent = Holder,
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundTransparency = 1,
					ZIndex = 4,
				})
				list(Page.SubStrip, {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6),
				})
			end

			local SubHolder = new("Frame", {
				Parent = ColumnsHolder,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Visible = false,
				ZIndex = 4,
			})

			SubPage.Columns = buildColumns(SubHolder, SubPage.Columns)

			local SubTab = new("TextButton", {
				Parent = Page.SubStrip,
				LayoutOrder = #Page.SubPageList + 1,
				Size = UDim2.fromOffset(0, 26),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = SubPage.Name,
				TextSize = 12,
				Font = Lumen.FontMedium,
				AutoButtonColor = false,
				ZIndex = 5,
			})
			themed(SubTab, "TextColor3", "TextDim")
			corner(SubTab, 6)
			padding(SubTab, 0, 0, 10, 10)

			SubPage.Items = { Holder = SubHolder, Tab = SubTab }

			function SubPage:Switch(active)
				SubPage.Active = active and true or false
				SubHolder.Visible = SubPage.Active
				SubTab.BackgroundTransparency = SubPage.Active and 0.2 or 1
				SubTab.BackgroundColor3 = Lumen.Theme.Panel
				SubTab.TextColor3 = SubPage.Active and Lumen.Theme.Text or Lumen.Theme.TextDim
				SubTab.Font = SubPage.Active and Lumen.FontBold or Lumen.FontMedium

				if SubPage.Active then
					Window.CurrentPage = SubPage
					PageTitle.Text = Page.Name .. "  <font size=\"12\" color=\"#8a8f9e\">/ " .. SubPage.Name .. "</font>"
				end
			end

			connect(SubTab.MouseButton1Down, function()
				if not canInteract() then
					return
				end

				for _, other in next, Page.SubPageList do
					other:Switch(other == SubPage)
				end
			end)

			function SubPage:Section(sectionData)
				sectionData = sectionData or { }
				local side = math.clamp(tonumber(sectionData.Side or sectionData.side or 1) or 1, 1, #SubPage.Columns)

				local ctx = { Window = Window, Page = SubPage, Section = nil }
				local section = CreateSection(SubPage.Columns[side], sectionData, ctx)
				ctx.Section = section

				sectionElementMethods(section, ctx)
				return section
			end

			table.insert(Page.SubPageList, SubPage)

			if #Page.SubPageList == 1 then
				SubPage:Switch(true)
			end

			return SubPage
		end

		table.insert(Window.Pages, Page)

		if #Window.Pages == 1 then
			Window:SwitchPage(Page)
		end

		return Page
	end

	-- search
	connect(SearchBox:GetPropertyChangedSignal("Text"), function()
		if not canInteract() then
			return
		end

		local needle = string.lower(SearchBox.Text)
		local page = Window.CurrentPage

		if not page or not page.Elements then
			return
		end

		local visibleSections = { }

		for _, entry in next, page.Elements do
			local match = needle == "" or string.find(string.lower(entry.Name), needle, 1, true) ~= nil
			entry.Object.Visible = match

			if match and entry.Section then
				visibleSections[entry.Section] = true
			end
		end

		for section, frame in next, page.Sections do
			frame.Visible = needle == "" or visibleSections[section] == true
		end

		if page.Dividers then
			for _, divider in next, page.Dividers do
				divider.Visible = needle == ""
			end
		end
	end)

	connect(MinimizeButton.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Window:SetMinimized(true)
	end)

	connect(CloseButton.MouseButton1Down, function()
		if not canInteract() then
			return
		end

		Window:SetOpen(false)
	end)

	connect(MinimizeButton.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(MinimizeButton, { TextColor3 = Lumen.Theme.Text }, 0.12)
	end)
	connect(MinimizeButton.MouseLeave, function()
		tween(MinimizeButton, { TextColor3 = Lumen.Theme.TextDim }, 0.12)
	end)
	connect(CloseButton.MouseEnter, function()
		if not canInteract() then
			return
		end

		tween(CloseButton, { TextColor3 = Lumen.Theme.Error }, 0.12)
	end)
	connect(CloseButton.MouseLeave, function()
		tween(CloseButton, { TextColor3 = Lumen.Theme.TextDim }, 0.12)
	end)

	hoverLayer(MinimizeButton, 7, 4)
	hoverLayer(CloseButton, 7, 4)

	attachTooltip(MinimizeButton, "minimize  (the name pill can be dragged)")
	attachTooltip(CloseButton, "close the menu (the key or the settings button opens it again)")

	-- search field reacts to focus, like every other input
	connect(SearchBox.Focused, function()
		if not canInteract() then
			return
		end

		tween(SearchFrame, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
	end)
	connect(SearchBox.FocusLost, function()
		tween(SearchFrame, { BackgroundColor3 = Lumen.Theme.Panel }, 0.14)
	end)

	-- menu keybind
	connect(UserInputService.InputBegan, function(input, gameProcessed)
		if gameProcessed or not Window.Alive then
			return
		end

		local windowKey = Window.Keybind
		if typeof(windowKey) ~= "EnumItem" then
			return
		end

		if input.KeyCode == windowKey or input.UserInputType == windowKey then
			if Window.IsMinimized then
				Window:SetMinimized(false)
			else
				Window:SetOpen(not Window.IsOpen)
			end
		end
	end)

	-- mobile floating button
	if isMobile then
		local float = new("TextButton", {
			Parent = Screen,
			Position = UDim2.fromOffset(20, 120),
			Size = UDim2.fromOffset(46, 46),
			BackgroundColor3 = Lumen.Theme.Panel,
			BorderSizePixel = 0,
			Text = "L",
			TextSize = 18,
			Font = Lumen.FontBold,
			AutoButtonColor = false,
			ZIndex = 60,
		})
		themed(float, "BackgroundColor3", "Panel")
		themed(float, "TextColor3", "Accent")
		corner(float, 23)
		local floatStroke = stroke(float, Lumen.Theme.Accent, 1, 0.4)
		themed(floatStroke, "Color", "Accent")
		makeDraggable(float, float)

		connect(float.MouseButton1Down, function()
			Window:SetOpen(not Window.IsOpen)
		end)

		Window.Items.FloatButton = float
	end

	-- built-in settings page (disable with Window({ SettingsPage = false }))
	if data.SettingsPage ~= false and data.settingspage ~= false then
		local settingsPage = Window:Page({
			Name = data.SettingsName or data.settingsname or "settings",
			Columns = 2,
			Group = data.SettingsGroup or data.settingsgroup or nil,
		})

		-- pin the settings tab to the bottom of the sidebar, above the footer
		local settingsTab = settingsPage.Items.Tab
		settingsTab.Parent = Sidebar
		settingsTab.LayoutOrder = 1000
		settingsTab.AnchorPoint = Vector2.new(0, 1)
		settingsTab.Position = UDim2.new(0, 8, 1, -44)
		settingsTab.Size = UDim2.new(1, -16, 0, 26)

		-- a hairline + a soft edge, so the pinned button reads as its own block
		local settingsLine = new("Frame", {
			Parent = Sidebar,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 12, 1, -74),
			Size = UDim2.new(1, -24, 0, 1),
			BackgroundColor3 = Lumen.Theme.Border,
			BorderSizePixel = 0,
			ZIndex = 4,
		})
		themed(settingsLine, "BackgroundColor3", "Border")

		local settingsStroke = stroke(settingsTab, Lumen.Theme.Border, 1, 0.4)
		themed(settingsStroke, "Color", "Border")

		local menuSection = settingsPage:Section({ Name = "menu", Side = 1 })

		menuSection:Keybind({
			Name = "menu key",
			Flag = "lumen_menu_key",
			Default = Window.Keybind,
			Mode = "toggle",
			ShowInList = false,
			OnSet = function(key)
				Window.Keybind = key or Enum.KeyCode.RightControl
			end,
		})

		menuSection:Toggle({
			Name = "watermark",
			Flag = "lumen_watermark",
			Default = true,
			Callback = function(state)
				if Lumen.State.Watermark then
					Lumen.State.Watermark:SetVisibility(state)
				end
			end,
		})

		-- one plain switch, like the old menu: on shows the list, off hides it. the
		-- list itself is moved by dragging its header.
		menuSection:Toggle({
			Name = "keybind list",
			Flag = "lumen_keybind_list",
			Default = Lumen.State.KeybindsList == nil or Lumen.State.KeybindsList.Mode ~= "off",
			Tooltip = "show the keybind list on screen (drag its header to move it)",
			Callback = function(state)
				local list = Lumen.State.KeybindsList
				if list then
					list:SetVisibility(state)
				end
			end,
		})

		menuSection:Slider({
			Name = "fade speed",
			Min = 0,
			Max = 0.6,
			Decimals = 2,
			Default = Window.FadeSpeed,
			Suffix = "s",
			Flag = "lumen_fade_speed",
			Callback = function(value)
				Window.FadeSpeed = value
			end,
		})

		menuSection:Button({
			Name = "unload ui",
			Confirm = true,
			Callback = function()
				Lumen:Unload()
			end,
		})

		local appearance = settingsPage:Section({ Name = "appearance", Side = 2 })

		appearance:Slider({
			Name = "window transparency",
			Min = 0,
			Max = 0.6,
			Decimals = 2,
			Default = Lumen.WindowTransparency or 0,
			Flag = "lumen_window_transparency",
			Tooltip = "see the game behind the menu",
			Callback = function(value)
				Lumen:SetWindowTransparency(value)
			end,
		})

		appearance:Slider({
			Name = "notification time",
			Min = 1,
			Max = 10,
			Decimals = 0,
			Default = Lumen.NotificationDuration or 4,
			Suffix = "s",
			Flag = "lumen_notification_duration",
			Tooltip = "how long the toasts stay on screen",
			Callback = function(value)
				Lumen:SetNotificationDuration(value)
			end,
		})

		appearance:Button({
			Name = "test notification",
			Callback = function()
				Lumen:Notification({
					Name = Lumen.LibraryName,
					Description = "notification settings applied",
					Duration = Lumen.NotificationDuration,
					Color = Lumen.Theme.Success,
				})
			end,
		})

		Lumen:BuildConfigSection(settingsPage:Section({ Name = "configs", Side = 1 }))
		Lumen:BuildThemeSection(settingsPage:Section({ Name = "theme", Side = 2 }))
	end

	-- menu state is applied after the widgets exist, so the popup gate is correct
	Window:SetOpen(data.StartClosed and false or true, true)

	-- the theme may have been applied before the widgets existed (Window({ Theme = "NZL" })):
	-- the particles and sweeps need the finished window, so the decoration is rebuilt here
	if Lumen.State.AnimatedTheme then
		startAnimatedDecor(Window)
	end

	Lumen.State.Building = false

	return Window
end
--#endregion

--#region ping
-- the number in the corner should be the real round trip, not a guess:
--   1) Stats -> Network -> ServerStatsItem["Data Ping"]  -- the value the game's own
--      scoreboard shows, in milliseconds, refreshed roughly once per second
--   2) LocalPlayer:GetNetworkPing()                      -- older estimate, in seconds
-- both of them jump around, so samples are smoothed and a stale value is never shown:
-- when nothing could be read for a while the watermark prints "-- ms" instead of a
-- fake zero.
local PingState = { Value = nil, Raw = nil, At = nil, Source = nil }

local function readRawPing()
	if Stats then
		local ok, value = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)

		if ok and type(value) == "number" and value > 0 then
			return value, "stats"
		end
	end

	if LocalPlayer then
		local ok, value = pcall(function()
			return LocalPlayer:GetNetworkPing()
		end)

		if ok and type(value) == "number" and value > 0 then
			return value * 1000, "network"
		end
	end

	return nil, nil
end

-- reads a fresh sample (if there is one) and returns the smoothed value
local function samplePing()
	local raw, source = readRawPing()

	if raw then
		-- a sample that arrives after a silence is a new truth, not an update of the
		-- old one: smoothing against a value from a minute ago would show a lie
		local resumed = PingState.At ~= nil and (os.clock() - PingState.At) > 3

		PingState.Raw = raw
		PingState.Source = source
		PingState.At = os.clock()

		if not PingState.Value or resumed then
			PingState.Value = raw
		else
			-- exponential smoothing: one jumpy sample must not make the number dance
			PingState.Value = PingState.Value + (raw - PingState.Value) * 0.4
		end
	end

	return PingState.Value
end

local function pingText()
	local value = PingState.Value

	-- a sample that is older than three seconds is not a ping anymore
	if not value or not PingState.At or (os.clock() - PingState.At) > 3 then
		return "-- ms"
	end

	return string.format("%d ms", math.floor(value + 0.5))
end

-- ping in milliseconds (smoothed, 0 while nothing could be read yet)
function Lumen:GetPing()
	if not PingState.Value then
		samplePing()
	end

	return math.floor((PingState.Value or 0) + 0.5)
end

-- where the number comes from: "stats", "network" or nil
function Lumen:GetPingSource()
	return PingState.Source
end

-- raw, unsmoothed last sample in milliseconds (nil until one lands)
function Lumen:GetRawPing()
	return PingState.Raw
end
--#endregion

--#region watermark / keybinds list / notifications
function Lumen:Watermark(text, data)
	data = data or { }

	Lumen:EnsureRoot()

	if Lumen.State.Watermark and Lumen.State.Watermark.Items then
		pcall(function()
			Lumen.State.Watermark.Items.Frame:Destroy()
		end)
		Lumen.State.Watermark = nil
	end

	local Watermark = { Text = text or (Lumen.LibraryName .. " | " .. Lumen.Version) }

	local anchor, position
	if data.Position then
		anchor = Vector2.new(0, 0)
		position = UDim2.fromOffset(data.Position.X or 12, data.Position.Y or 12)
	else
		anchor = Vector2.new(0.5, 0)
		position = UDim2.new(0.5, 0, 0, 12)
	end

	local Frame = new("Frame", {
		Parent = Lumen.State.Screen,
		AnchorPoint = anchor,
		Position = position,
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Lumen.Theme.Background,
		BorderSizePixel = 0,
		ZIndex = 40,
	})
	themed(Frame, "BackgroundColor3", "Background")
	corner(Frame, 7)
	local FrameStroke = stroke(Frame, Lumen.Theme.Border, 1, 0.25)
	themed(FrameStroke, "Color", "Border")

	local AccentBar = new("Frame", {
		Parent = Frame,
		Position = UDim2.fromOffset(0, 6),
		Size = UDim2.fromOffset(2, 16),
		BackgroundColor3 = Lumen.Theme.Accent,
		BorderSizePixel = 0,
		ZIndex = 41,
	})
	corner(AccentBar, 2)
	themed(AccentBar, "BackgroundColor3", "Accent")

	local Label = new("TextLabel", {
		Parent = Frame,
		Position = UDim2.fromOffset(9, 0),
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text = Watermark.Text,
		TextSize = 12,
		Font = Lumen.FontMedium,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 41,
	})
	themed(Label, "TextColor3", "Text")
	padding(Label, 0, 0, 0, 10)

	-- the status bar is only movable while the menu is open, exactly like the keybind
	-- list: with the menu closed the whole ui is inert
	makeDraggable(Frame, Frame, nil, function()
		return canInteract()
	end)

	-- slides and fades in, so it does not just pop into the corner
	Frame.Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset - 8)
	Label.TextTransparency = 1
	tween(Frame, { Position = position }, 0.3, Enum.EasingStyle.Quart)
	tween(Label, { TextTransparency = 0 }, 0.36)

	Watermark.Items = { Frame = Frame, Label = Label, AccentBar = AccentBar }
	Lumen.State.Watermark = Watermark

	-- keep in sync with the auto settings page toggle
	if Lumen.Flags["lumen_watermark"] == false then
		Watermark:SetVisibility(false)
	else
		local settingsToggle = Lumen.Options["lumen_watermark"]
		if settingsToggle then
			settingsToggle:Set(true, true)
		end
	end

	function Watermark:SetText(newText)
		Watermark.Text = newText
		Label.Text = newText
	end

	function Watermark:SetVisibility(visible)
		Frame.Visible = visible and true or false
	end

	function Watermark:SetPosition(x, y)
		local viewport = viewportSize()
		local size = Frame.AbsoluteSize

		x = math.floor(tonumber(x) or 12)
		y = math.floor(tonumber(y) or 12)
		x = math.clamp(x, 0, math.max(0, viewport.X - (size and size.X or 0)))
		y = math.clamp(y, 0, math.max(0, viewport.Y - (size and size.Y or 0)))

		Frame.Position = UDim2.fromOffset(x, y)
		return x, y
	end

	function Watermark:GetPosition()
		local position = Frame.Position
		return math.floor(position.X.Offset), math.floor(position.Y.Offset)
	end

	if data.Stats then
		local frames = 0
		local lastUpdate = os.clock()
		local fps = 0
		local sampleClock = 0

		connect(RunService.RenderStepped, function()
			frames = frames + 1
			local now = os.clock()

			if now - lastUpdate >= 0.5 then
				fps = math.floor(frames / (now - lastUpdate))
				frames = 0
				lastUpdate = now
			end

			-- the source refreshes about once a second, so sampling it twice a second
			-- is enough and keeps the render step cheap
			if now - sampleClock >= 0.5 then
				sampleClock = now
				samplePing()
			end

			Label.Text = string.format("%s | <font color=\"#7ea8ff\">%d fps</font> | %s",
				Watermark.Text, fps, pingText())
		end)
	end

	return Watermark
end

function Lumen:KeybindsList(data)
	data = data or { }

	Lumen:EnsureRoot()

	if Lumen.State.KeybindsList and Lumen.State.KeybindsList.Items then
		pcall(function()
			Lumen.State.KeybindsList.Items.Frame:Destroy()
		end)
		Lumen.State.KeybindsList = nil
	end

	local KeybindsList = { }

	-- what a previous run / the settings section left behind: the list keeps its spot
	-- and its visibility rule when the script is re-executed
	local saved = Lumen.State.KeybindListLayout or { }
	local savedPosition = saved.Position or { }
	local legacyFlag = Lumen.Flags["lumen_keybind_list"]

	local startX = (data.Position and data.Position.X) or savedPosition.X or 12
	local startY = (data.Position and data.Position.Y) or savedPosition.Y or 100

	local function cleanMode(mode)
		mode = tostring(mode or ""):lower()
		if mode == "off" or mode == "menu" or mode == "always" then
			return mode
		end
		if mode == "with menu" or mode == "auto" or mode == "true" then
			return "menu"
		end
		return nil
	end

	-- "always" is the default again: the list sits on screen while you play, exactly
	-- like the old one, and the "keybind list" switch in the settings hides it
	local mode = cleanMode(data.Mode or data.mode) or cleanMode(saved.Mode)
	if not mode and legacyFlag == false then
		mode = "off"
	end
	mode = mode or "always"

	local Frame = new("Frame", {
		Parent = Lumen.State.Screen,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromOffset(startX, startY),
		Size = UDim2.fromOffset(180, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Lumen.Theme.Background,
		BorderSizePixel = 0,
		ZIndex = 40,
	})
	themed(Frame, "BackgroundColor3", "Background")
	corner(Frame, 7)
	local FrameStroke = stroke(Frame, Lumen.Theme.Border, 1, 0.25)
	themed(FrameStroke, "Color", "Border")

	local Header = new("Frame", {
		Parent = Frame,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = Lumen.Theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 41,
	})
	themed(Header, "BackgroundColor3", "Panel")
	corner(Header, 7)

	local HeaderText = new("TextLabel", {
		Parent = Header,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		Text = data.Title or data.title or "keybinds",
		TextSize = 12,
		Font = Lumen.FontBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 42,
	})
	themed(HeaderText, "TextColor3", "Accent")

	-- the rows scroll: a hub with 40 binds used to push the list off the bottom of
	-- the screen (41 rows x 19px = 813px on a 720px viewport)
	local Content = new("ScrollingFrame", {
		Parent = Frame,
		Position = UDim2.fromOffset(0, 26),
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ZIndex = 41,
	})
	themed(Content, "ScrollBarImageColor3", "Border")
	padding(Content, 6, 8, 8, 8)
	list(Content, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) })

	-- a second stroke that only shows up in "edit list position" mode, plus a hint with
	-- the live coordinates: the list announces that it can be moved instead of jumping
	-- somewhere when it is grabbed by accident
	local EditStroke = stroke(Frame, Lumen.Theme.Accent, 2, 1)
	themed(EditStroke, "Color", "Accent")

	local Hint = new("TextLabel", {
		Parent = Header,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -6, 0, 0),
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text = "",
		TextSize = 11,
		Font = Lumen.FontMedium,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 44,
	})
	themed(Hint, "TextColor3", "Accent")

	KeybindsList.Rows = { }
	KeybindsList.RowCount = 0
	KeybindsList.Mode = mode
	KeybindsList.EditMode = false

	-- the frame grows with its rows (header 26 + the content), and the mock (like a
	-- real client before layout runs) cannot be asked for AbsoluteSize yet
	local function listSize()
		return Vector2.new(Frame.Size.X.Offset, 26 + (Content.Size.Y.Offset or 0))
	end

	local function windowShows()
		local window = Lumen.State.Window
		if not window or not window.Alive then
			return false
		end

		return window.IsOpen == true and window.IsMinimized ~= true
	end

	local function wantedVisible()
		if KeybindsList.Mode == "off" or KeybindsList.RowCount <= 0 then
			return false
		end

		if KeybindsList.Mode == "always" then
			return true
		end

		return windowShows()
	end

	function KeybindsList:Update()
		Frame.Visible = wantedVisible()
		return Frame.Visible
	end

	-- called by the window when it opens, closes or minimizes
	function KeybindsList:SyncToWindow()
		return KeybindsList:Update()
	end

	function KeybindsList:IsVisible()
		return Frame.Visible == true
	end

	function KeybindsList:SetMode(newMode)
		local clean = cleanMode(newMode)
		if not clean then
			return false
		end

		KeybindsList.Mode = clean
		Lumen.State.KeybindListLayout = Lumen.State.KeybindListLayout or { }
		Lumen.State.KeybindListLayout.Mode = clean

		-- keep the settings switch honest when the mode was changed from code or
		-- restored from a config
		local toggle = Lumen.Options["lumen_keybind_list"]
		if toggle then
			toggle:Set(clean ~= "off", true)
		end

		return KeybindsList:Update()
	end

	-- old api: SetVisibility(true) shows the list, SetVisibility(false) hides it
	function KeybindsList:SetVisibility(visible)
		if visible then
			if KeybindsList.Mode == "off" then
				KeybindsList:SetMode("menu")
			end
		else
			KeybindsList:SetMode("off")
		end

		return KeybindsList:Update()
	end

	function KeybindsList:GetPosition()
		local position = Frame.Position
		return math.floor(position.X.Offset), math.floor(position.Y.Offset)
	end

	function KeybindsList:SetPosition(x, y, silent)
		local viewport = viewportSize()
		local size = listSize()

		x = math.floor(tonumber(x) or 12)
		y = math.floor(tonumber(y) or 100)
		x = math.clamp(x, 0, math.max(0, viewport.X - size.X))
		y = math.clamp(y, 0, math.max(0, viewport.Y - size.Y))

		Frame.Position = UDim2.fromOffset(x, y)
		Lumen.State.KeybindListLayout = Lumen.State.KeybindListLayout or { }
		Lumen.State.KeybindListLayout.Position = { X = x, Y = y }

		if KeybindsList.EditMode then
			Hint.Text = string.format("drag me  |  x %d  y %d", x, y)
		end

		if not silent then
			local dropdown = Lumen.Options["lumen_keybind_list_position"]
			if dropdown and dropdown:Get() ~= "custom" then
				dropdown:Set("custom", true)
			end
		end

		return x, y
	end

	function KeybindsList:SnapTo(preset)
		preset = tostring(preset or ""):lower()
		if preset == "custom" then
			return false
		end

		local viewport = viewportSize()
		local size = listSize()
		local margin = 12
		local x, y = 12, 100

		if preset == "top left" then
			x, y = margin, margin
		elseif preset == "top right" then
			x, y = viewport.X - size.X - margin, margin
		elseif preset == "bottom left" then
			x, y = margin, viewport.Y - size.Y - margin
		elseif preset == "bottom right" then
			x, y = viewport.X - size.X - margin, viewport.Y - size.Y - margin
		elseif preset == "reset" then
			x, y = 12, 100
		else
			return false
		end

		KeybindsList:SetPosition(x, y, true)

		local dropdown = Lumen.Options["lumen_keybind_list_position"]
		if dropdown then
			dropdown:Set(preset == "reset" and "custom" or preset, true)
		end

		return true
	end

	function KeybindsList:SetEditMode(on)
		KeybindsList.EditMode = on and true or false

		if KeybindsList.EditMode and KeybindsList.Mode == "off" then
			-- you cannot move what you cannot see
			KeybindsList:SetMode("menu")
		end

		EditStroke.Transparency = KeybindsList.EditMode and 0.1 or 1
		KeybindsList:Update()
		KeybindsList:Refresh()

		local x, y = KeybindsList:GetPosition()
		Hint.Text = KeybindsList.EditMode and string.format("drag me  |  x %d  y %d", x, y) or ""

		local toggle = Lumen.Options["lumen_keybind_list_edit"]
		if toggle then
			toggle:Set(KeybindsList.EditMode, true)
		end

		return KeybindsList.EditMode
	end

	-- the list sticks to a screen edge when it is dropped near one, so a half visible
	-- list can never be dragged off screen by accident
	local function snapToEdges()
		local viewport = viewportSize()
		local size = listSize()
		local x, y = KeybindsList:GetPosition()
		local near = 24
		local margin = 12

		if x <= near then
			x = margin
		elseif x + size.X >= viewport.X - near then
			x = viewport.X - size.X - margin
		end

		if y <= near then
			y = margin
		elseif y + size.Y >= viewport.Y - near then
			y = viewport.Y - size.Y - margin
		end

		KeybindsList:SetPosition(x, y)
	end

	-- drag by the header at any time, drag from anywhere while edit mode is on
	local function dragHooks()
		return {
			End = function(moved)
				if moved then
					snapToEdges()
				end
			end,
		}
	end

	makeDraggable(Frame, Header, dragHooks(), function()
		return canInteract()
	end)

	makeDraggable(Frame, Frame, dragHooks(), function()
		return canInteract() and KeybindsList.EditMode
	end)

	function KeybindsList:Refresh()
		-- hide everything first
		for keybind, row in next, KeybindsList.Rows do
			row.Frame.Visible = false
		end

		local order = 0
		for _, keybind in next, Lumen.State.Keybinds do
			if keybind.ShowInList and keybind.Key then
				order = order + 1

				local row = KeybindsList.Rows[keybind]
				if not row then
					row = { }

					row.Frame = new("Frame", {
						Parent = Content,
						Size = UDim2.new(1, 0, 0, 16),
						BackgroundTransparency = 1,
						ZIndex = 42,
					})

					row.NameLabel = new("TextLabel", {
						Parent = row.Frame,
						Size = UDim2.new(1, -60, 1, 0),
						BackgroundTransparency = 1,
						Text = keybind.Name,
						TextSize = 11,
						Font = Lumen.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						ZIndex = 43,
					})
					themed(row.NameLabel, "TextColor3", "TextDim")

					row.StateLabel = new("TextLabel", {
						Parent = row.Frame,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, 0, 0, 0),
						Size = UDim2.fromOffset(56, 16),
						BackgroundTransparency = 1,
						Text = "",
						TextSize = 11,
						Font = Lumen.FontMedium,
						TextXAlignment = Enum.TextXAlignment.Right,
						ZIndex = 43,
					})

					KeybindsList.Rows[keybind] = row
				end

				row.Frame.LayoutOrder = order
				row.Frame.Visible = true
				row.NameLabel.Text = keybind.Name
				row.NameLabel.TextColor3 = keybind.Toggled and Lumen.Theme.Text or Lumen.Theme.TextDim

				local stateText
				if keybind.Mode == "hold" then
					stateText = keybind.Toggled and "holding" or "[" .. keyName(keybind.Key) .. "]"
				elseif keybind.Mode == "always" then
					stateText = "always"
				else
					stateText = keybind.Toggled and "on" or "[" .. keyName(keybind.Key) .. "]"
				end

				row.StateLabel.Text = stateText
				row.StateLabel.TextColor3 = keybind.Toggled and Lumen.Theme.Accent or Lumen.Theme.TextDim
			end
		end

		-- the list grows with its rows, but never taller than the viewport
		local rowHeight = 19
		local viewport = viewportSize()
		local maxHeight = math.max(120, viewport.Y - (Frame.AbsolutePosition.Y or 0) - 48)
		Content.Size = UDim2.new(1, 0, 0, math.min(order * rowHeight + 14, maxHeight))

		KeybindsList.RowCount = order
		KeybindsList:Update()
	end

	-- the settings dropdown calls this, so the two never disagree
	function KeybindsList:SetVisibleMode(value)
		local clean = cleanMode(value) or (value and "menu" or "off")
		return KeybindsList:SetMode(clean)
	end

	KeybindsList.Items = {
		Frame = Frame, Header = Header, Content = Content, Hint = Hint, HeaderText = HeaderText,
	}

	KeybindsList:SetPosition(startX, startY, true)
	KeybindsList:Refresh()

	Lumen.State.KeybindsList = KeybindsList
	Lumen.State.KeybindListLayout = Lumen.State.KeybindListLayout or { }
	Lumen.State.KeybindListLayout.Mode = KeybindsList.Mode

	-- the settings widgets are built by Lumen:Window, which may not exist yet
	local modeDropdown = Lumen.Options["lumen_keybind_list_mode"]
	if modeDropdown then
		modeDropdown:Set(KeybindsList.Mode == "menu" and "with menu" or KeybindsList.Mode, true)
	end

	local editToggle = Lumen.Options["lumen_keybind_list_edit"]
	if editToggle then
		editToggle:Set(false, true)
	end

	return KeybindsList
end

local notificationOrder = 0
local activeNotifications = { }

function Lumen:Notification(data)
	if type(data) == "string" then
		data = { Text = data }
	end

	data = data or { }

	Lumen:EnsureRoot()

	local title = data.Name or data.name or data.Title or data.title or Lumen.LibraryName
	local text = data.Description or data.description or data.Text or data.text or ""
	local duration = tonumber(data.Duration or data.duration or Lumen.NotificationDuration) or 4
	local color = data.Color or data.color or data.IconColor or Lumen.Theme.Accent

	if typeof(color) ~= "Color3" then
		color = Lumen.Theme.Accent
	end

	notificationOrder = notificationOrder + 1

	local Frame = new("Frame", {
		Parent = Lumen.State.Notifications,
		LayoutOrder = notificationOrder,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Lumen.Theme.Panel,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 91,
	})
	themed(Frame, "BackgroundColor3", "Panel")
	corner(Frame, 7)
	local FrameStroke = stroke(Frame, Lumen.Theme.Border, 1, 0.15)
	themed(FrameStroke, "Color", "Border")
	padding(Frame, 8, 9, 0, 10)

	-- never let notifications stack forever
	table.insert(activeNotifications, Frame)
	if #activeNotifications > 4 then
		local oldest = table.remove(activeNotifications, 1)
		pcall(function()
			oldest:Destroy()
		end)
	end

	local Accent = new("Frame", {
		Parent = Frame,
		Position = UDim2.fromOffset(0, 8),
		Size = UDim2.new(0, 2, 1, -17),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		ZIndex = 92,
	})
	corner(Accent, 2)

	local Dot = new("Frame", {
		Parent = Frame,
		Position = UDim2.fromOffset(10, 5),
		Size = UDim2.fromOffset(6, 6),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		ZIndex = 92,
	})
	corner(Dot, 3)

	local Title = new("TextLabel", {
		Parent = Frame,
		Position = UDim2.fromOffset(21, 0),
		Size = UDim2.fromOffset(0, 15),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Text = title,
		TextSize = 13,
		Font = Lumen.FontBold,
		RichText = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 92,
	})
	themed(Title, "TextColor3", "Text")

	local Body = new("TextLabel", {
		Parent = Frame,
		Position = UDim2.fromOffset(21, 17),
		Size = UDim2.fromOffset(240, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = text,
		TextSize = 12,
		Font = Lumen.Font,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 92,
	})
	themed(Body, "TextColor3", "TextDim")

	-- measure, then animate in
	task.wait()

	local targetSize = Frame.AbsoluteSize
	Frame.AutomaticSize = Enum.AutomaticSize.None
	Frame.Size = UDim2.fromOffset(0, 0)

	-- thin line that drains over the lifetime of the toast. it hangs below the
	-- text block (+6), so it can never cross the description line
	local Progress = new("Frame", {
		Parent = Frame,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 6),
		Size = UDim2.new(1, 0, 0, 2),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		ZIndex = 93,
	})
	new("UIGradient", {
		Parent = Progress,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 0.5),
		}),
	})
	local progressTween = TweenService:Create(Progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 0, 2),
	})
	progressTween:Play()

	tween(Frame, { Size = UDim2.fromOffset(targetSize.X, targetSize.Y) }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	task.delay(duration, function()
		tween(Frame, { Size = UDim2.fromOffset(0, 0) }, 0.2)
		task.delay(0.25, function()
			for index, entry in next, activeNotifications do
				if entry == Frame then
					table.remove(activeNotifications, index)
					break
				end
			end

			if Frame and Frame.Parent then
				Frame:Destroy()
			end
		end)
	end)

	return { Title = title, Text = text, Duration = duration }
end

Lumen.Notify = Lumen.Notification
--#endregion

--#region layout / autosave
-- a restored setup is not just flags: the window position, the watermark spot and the
-- keybind list place are part of it. this is what "autoload" reads and writes.

function Lumen:GetLayout()
	local layout = { }

	local window = Lumen.State.Window
	if window and window.Items and window.Items.Main then
		local main = window.Items.Main
		layout.WindowPosition = { X = main.Position.X.Offset, Y = main.Position.Y.Offset }
		layout.WindowSize = { X = main.Size.X.Offset, Y = main.Size.Y.Offset }
		layout.WindowMinimized = window.IsMinimized and true or false
	end

	local watermark = Lumen.State.Watermark
	if watermark and watermark.Items and watermark.Items.Frame then
		local x, y = watermark:GetPosition()
		layout.WatermarkPosition = { X = x, Y = y }
		layout.WatermarkVisible = watermark.Items.Frame.Visible and true or false
	end

	local keybindList = Lumen.State.KeybindsList
	if keybindList then
		local x, y = keybindList:GetPosition()
		layout.KeybindListPosition = { X = x, Y = y }
		layout.KeybindListMode = keybindList.Mode
	end

	return layout
end

local function layoutNumber(value, fallback)
	value = tonumber(value)
	if value == nil then
		return fallback
	end

	return value
end

function Lumen:ApplyLayout(layout)
	if type(layout) ~= "table" then
		return false
	end

	local viewport = viewportSize()
	local applied = false

	local window = Lumen.State.Window
	local main = window and window.Items and window.Items.Main

	if main then
		if type(layout.WindowSize) == "table" then
			local width = layoutNumber(layout.WindowSize.X, main.Size.X.Offset)
			local height = layoutNumber(layout.WindowSize.Y, main.Size.Y.Offset)

			width = math.clamp(width, window.MinSize.X, math.max(window.MinSize.X, viewport.X))
			height = math.clamp(height, window.MinSize.Y, math.max(window.MinSize.Y, viewport.Y))

			main.Size = UDim2.fromOffset(width, height)
			window.Size = main.Size
			window.BaseSize = main.Size
			applied = true
		end

		if type(layout.WindowPosition) == "table" then
			local x = layoutNumber(layout.WindowPosition.X, nil)
			local y = layoutNumber(layout.WindowPosition.Y, nil)

			if x and y then
				local size = main.Size
				x = math.clamp(x, -size.X.Offset + 80, math.max(0, viewport.X - 80))
				y = math.clamp(y, 0, math.max(0, viewport.Y - 40))
				main.Position = UDim2.fromOffset(x, y)
				applied = true
			end
		end

		if layout.WindowMinimized ~= nil then
			local wantMinimized = layout.WindowMinimized and true or false
			if window.IsMinimized ~= wantMinimized then
				window:SetMinimized(wantMinimized)
			end
		end
	end

	local watermark = Lumen.State.Watermark
	if watermark then
		if type(layout.WatermarkPosition) == "table" then
			watermark:SetPosition(layout.WatermarkPosition.X, layout.WatermarkPosition.Y)
			applied = true
		end

		if layout.WatermarkVisible ~= nil then
			local visible = layout.WatermarkVisible and true or false
			watermark:SetVisibility(visible)

			local toggle = Lumen.Options["lumen_watermark"]
			if toggle then
				toggle:Set(visible, true)
			end
		end
	end

	local mode = layout.KeybindListMode
	local keybindList = Lumen.State.KeybindsList

	if (mode == "off" or mode == "menu" or mode == "always") and not keybindList and mode ~= "off" then
		keybindList = Lumen:KeybindsList({ Mode = mode })
	end

	if keybindList then
		if mode == "off" or mode == "menu" or mode == "always" then
			-- remember it, so a list the script builds later still lands in the right spot
			Lumen.State.KeybindListLayout = Lumen.State.KeybindListLayout or { }
			Lumen.State.KeybindListLayout.Mode = mode
			keybindList:SetMode(mode)
			applied = true
		end

		if type(layout.KeybindListPosition) == "table" then
			keybindList:SetPosition(layout.KeybindListPosition.X, layout.KeybindListPosition.Y, true)
			applied = true
		end
	end

	return applied
end

-- autosave: the setup is written a couple of seconds after the last change, so the
-- next execution of the script comes back exactly as it was left
local function autosavePath()
	return Lumen.Folder .. "/autosave_state.json"
end

-- there is no "autosave changes" switch any more: the menu remembers itself, the
-- file is written a moment after every change. a config that was armed through
-- "autoload this config" wins over the snapshot (and clears it), so the two systems
-- can never fight about what comes back on the next launch.
function Lumen:IsAutosave()
	if Lumen.State.Autosave == false then
		return false
	end

	if Lumen:GetAutoload() ~= "" then
		return false
	end

	return true
end

function Lumen:SaveAutosave()
	if not Lumen.State.Window then
		return false
	end

	ensureFolders()

	local ok, encoded = pcall(function()
		return Lumen:GetConfig()
	end)

	if not ok or type(encoded) ~= "string" then
		return false
	end

	pcall(writefile, autosavePath(), encoded)
	return isfile(autosavePath())
end

function Lumen:SetAutosave(enabled)
	ensureFolders()
	enabled = enabled and true or false

	-- the settings toggle reports its default once while the window is being built.
	-- rewriting the snapshot at that moment would replace the user's saved setup with
	-- the half built menu, so an unchanged state is simply left alone.
	local current = Lumen:IsAutosave()
	if current == enabled and Lumen.State.AutosaveSet == true then
		return enabled
	end

	Lumen.State.AutosaveSet = true
	Lumen.State.Autosave = enabled

	if enabled then
		-- the snapshot and a named autoload would both want the next launch: the
		-- one that was switched on last wins, and the user sees which one it is
		local armed = Lumen:GetAutoload()
		pcall(writefile, Lumen.Folder .. "/autoload.txt", "")
		Lumen.State.AutoloadName = ""
		Lumen.State.Autosave = true

		Lumen:SaveAutosave()

		Lumen:Notification({
			Name = "autosave on",
			Description = armed ~= ""
				and ("saved every change (the armed config '" .. armed .. "' was cleared)")
				or "changes are saved a moment after you make them",
			Duration = 4,
			Color = Lumen.Theme.Success,
		})
	else
		pcall(delfile, autosavePath())
		Lumen:Notification({
			Name = "autosave off",
			Description = "the saved snapshot was removed",
			Duration = 3,
		})
	end

	Lumen:SyncConfigUI()
	return enabled
end

-- what the autosave snapshot holds is what LoadConfig can apply
function Lumen:LoadAutosave()
	if not Lumen:IsAutosave() then
		return false
	end

	return Lumen:LoadConfigData(readText(autosavePath()), "autosave") ~= nil
end

--#endregion

--#region config system
local function serializeOptions()
	local output = { }

	for flag, option in next, Lumen.Options do
		-- settings-internal helpers must never be stored in configs:
		-- restoring them would silently flip autoload / wipe the name boxes
		-- settings-internal helpers must never be stored in configs:
		-- restoring them would silently flip autoload / autosave / edit mode or wipe
		-- the name boxes (an autosave toggle coming back as "false" would delete the
		-- snapshot the user asked for)
		local internal = flag:match("^lumen_config_autoload") ~= nil
			or flag:match("^lumen_theme_autoload") ~= nil
			or flag:match("^lumen_config_autosave") ~= nil
			or flag:match("^lumen_keybind_list_edit") ~= nil
			or flag:match("^lumen_config_name") ~= nil
			or flag:match("^lumen_theme_name") ~= nil
		if not internal then
		if option.Type == "Colorpicker" then
			output[flag] = { Color = option.Color:ToHex(), Alpha = option.Alpha }
		elseif option.Type == "Keybind" then
			output[flag] = {
				Key = option.Key and tostring(option.Key) or "None",
				Mode = option.Mode,
				ShowInList = option.ShowInList,
			}
		elseif option.Type == "Dropdown" and option.Multi then
			local copy = { }
			for index, value in next, option.Value or { } do
				copy[index] = value
			end
			output[flag] = copy
		elseif option.Type ~= "Button" and option.Type ~= "Label" and option.Type ~= "Section" then
			output[flag] = option.Value
		end
		end
	end

	-- where the movable pieces are: a restored setup that snaps back to the middle of
	-- the screen is not a restored setup
	output._layout = Lumen:GetLayout()

	return output
end

local function applyOption(option, value)
	if not option or not option.Set then
		return
	end

	if option.Type == "Colorpicker" and type(value) == "table" and value.Color then
		option:Set(value.Color, value.Alpha)
	elseif option.Type == "Keybind" and type(value) == "table" then
		option:Set(value)
	else
		option:Set(value)
	end
end

function Lumen:GetConfig()
	return HttpService:JSONEncode(serializeOptions())
end

function Lumen:GetConfigs()
	return filesIn(Lumen.ConfigFolder)
end

function Lumen:SaveConfig(name)
	if not name or name == "" then
		return false
	end

	ensureFolders()
	name = cleanName(name)
	if name == "" then
		return false
	end
	local path = Lumen.ConfigFolder .. "/" .. name .. ".json"

	local ok, encoded = pcall(function()
		return Lumen:GetConfig()
	end)

	if not ok or type(encoded) ~= "string" then
		Lumen:Notification({
			Name = "config error",
			Description = "serialize failed: " .. tostring(encoded),
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	pcall(writefile, path, encoded)

	if not isfile(path) then
		Lumen:Notification({
			Name = "config error",
			Description = "could not write " .. path,
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	-- the notification says what happened and the name, nothing else: the path only
	-- made the toast long ("nzl_studio/configs/1.json")
	Lumen:Notification({
		Name = "save config",
		Description = name,
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
end

function Lumen:ConfigExists(name)
	name = cleanName(name)
	if name == "" then
		return false
	end

	return findSaved(name, {
		Lumen.ConfigFolder,
		"NZL_Studio/configs",
		"lumen/configs",
	}) ~= nil
end

-- shared by LoadConfig (a named file) and LoadAutosave (the snapshot): decode, apply
-- every flag, then apply the layout block
function Lumen:LoadConfigData(json, label)
	if type(json) ~= "string" or json == "" then
		return nil
	end

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if not ok or type(decoded) ~= "table" then
		Lumen:Notification({
			Name = "config error",
			Description = "failed to parse " .. tostring(label),
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return nil
	end

	local loaded = 0

	local function applyFlag(flag, value)
		local option = Lumen.Options[flag]
		if option then
			pcall(applyOption, option, value)
			loaded = loaded + 1
		end
	end

	-- a preset wipes every colour, so it has to be applied before the individual
	-- colours that the same config stores. table order used to decide this, which is
	-- why hand picked colours "did not save": half the time the preset came last and
	-- repainted them with its defaults.
	-- widgets cannot tell a restore from a click: this flag keeps things like the
	-- animated theme's "a manual colour stops the animation" rule out of the way
	Lumen.State.ApplyingConfig = true

	for flag, value in next, decoded do
		if flag ~= "_layout" and flag:match("^lumen_theme_preset") then
			applyFlag(flag, value)
		end
	end

	for flag, value in next, decoded do
		if flag ~= "_layout" and not flag:match("^lumen_theme_preset") then
			applyFlag(flag, value)
		end
	end

	Lumen.State.ApplyingConfig = false

	pcall(function()
		Lumen:ApplyLayout(decoded._layout)
	end)

	decoded._applied = loaded
	return decoded
end

function Lumen:LoadConfig(name)
	if not name or name == "" then
		return false
	end

	name = cleanName(name)
	local path = findSaved(name, {
		Lumen.ConfigFolder,
		"NZL_Studio/configs",
		"lumen/configs",
	}) or (Lumen.ConfigFolder .. "/" .. name .. ".json")

	if not isfile(path) then
		Lumen:Notification({
			Name = "config error",
			Description = "could not find " .. path,
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	local decoded = Lumen:LoadConfigData(readText(path), name)
	if not decoded then
		return false
	end

	Lumen:Notification({
		Name = "config loaded",
		Description = name,
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
end

-- write the live state over a config that already exists. "save" is for making a new
-- one, this is for the second, third and hundredth time.
function Lumen:OverwriteConfig(name)
	if not name or name == "" then
		return false
	end

	name = cleanName(name)
	if name == "" or not Lumen:ConfigExists(name) then
		return false
	end

	return Lumen:SaveConfig(name)
end

function Lumen:DeleteConfig(name)
	if not name or name == "" then
		return false
	end

	name = cleanName(name)
	local path = findSaved(name, {
		Lumen.ConfigFolder,
		"NZL_Studio/configs",
		"lumen/configs",
	})

	if not path then
		Lumen:Notification({
			Name = "config error",
			Description = "could not find " .. Lumen.ConfigFolder .. "/" .. name .. ".json",
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	pcall(delfile, path)

	Lumen:Notification({
		Name = "config deleted",
		Description = name,
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
end

-- arming autoload on a name that has no file yet used to write the name and do
-- nothing at the next start: now the current setup is saved under that name first, so
-- "autoload this" always has something to load.
function Lumen:SetAutoload(name)
	ensureFolders()

	name = cleanName(name)

	-- arming the same name again (a settings widget reporting its default, a config
	-- load) must not overwrite the file with whatever is on screen at that second
	if name ~= "" and Lumen:GetAutoload() == name and Lumen:ConfigExists(name) then
		return true
	end

	if name ~= "" and not Lumen:ConfigExists(name) then
		Lumen:SaveConfig(name)
	end

	pcall(writefile, Lumen.Folder .. "/autoload.txt", name)
	Lumen.State.AutoloadName = name

	if name ~= "" then
		-- exactly one restore mechanism may be on: a named config and the autosave
		-- snapshot fighting over the next launch is how "autoload does not work" starts
		pcall(delfile, autosavePath())

		Lumen:Notification({
			Name = "autoload armed",
			Description = "next launch loads: " .. name,
			Duration = 4,
			Color = Lumen.Theme.Success,
		})
	end

	Lumen:SyncConfigUI()

	return name ~= ""
end

function Lumen:GetAutoload()
	-- read once: IsAutosave() asks on every change (a slider drag writes 30 values a
	-- second) and a file read per write is wasted work
	if Lumen.State.AutoloadName == nil then
		Lumen.State.AutoloadName = cleanName(readText(Lumen.Folder .. "/autoload.txt"))
	end

	return Lumen.State.AutoloadName
end

-- keeps the settings widgets in step with the files: the dropdown shows the armed
-- config, the toggle reflects it, and the same for themes and autosave
function Lumen:SyncConfigUI()
	local autoConfig = Lumen:GetAutoload()
	local autoTheme = Lumen:GetAutoloadTheme()
	local autosave = Lumen:IsAutosave()

	for flag, option in next, Lumen.Options do
		if flag:match("^lumen_config_select") and autoConfig ~= "" then
			option:Set(autoConfig, true)
		elseif flag:match("^lumen_config_name") and autoConfig ~= "" then
			-- the name box shows what is armed, so opening the menu after a restart
			-- says which config is coming back
			option:Set(autoConfig, true)
		elseif flag:match("^lumen_theme_name") and autoTheme ~= "" then
			option:Set(autoTheme, true)
		elseif flag:match("^lumen_config_autoload") then
			option:Set(autoConfig ~= "" and not autosave, true)
		elseif flag:match("^lumen_saved_theme") and autoTheme ~= "" then
			option:Set(autoTheme, true)
		elseif flag:match("^lumen_theme_autoload") then
			option:Set(autoTheme ~= "", true)
		elseif flag:match("^lumen_config_autosave") then
			option:Set(autosave, true)
		end
	end
end

-- themes
function Lumen:GetThemeConfigs()
	return filesIn(Lumen.ThemeFolder)
end

function Lumen:SaveTheme(name)
	if not name or name == "" then
		return false
	end

	ensureFolders()

	-- with the animated theme running the live table holds whatever frame the palette
	-- is on: a saved theme stores the base colours of the preset instead, so it looks
	-- the same every time it is loaded back
	local base = Lumen.State.AnimatedTheme and Lumen.Themes[Lumen.ThemeName] or nil

	local output = { }
	for key, value in next, Lumen.Theme do
		if typeof(value) == "Color3" then
			local settled = base and base[key]
			output[key] = (typeof(settled) == "Color3" and settled or value):ToHex()
		end
	end

	name = cleanName(name)
	if name == "" then
		return false
	end
	local path = Lumen.ThemeFolder .. "/" .. name .. ".json"
	pcall(writefile, path, HttpService:JSONEncode(output))

	if not isfile(path) then
		Lumen:Notification({
			Name = "theme error",
			Description = "could not write " .. path,
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	Lumen:Notification({
		Name = "theme saved",
		Description = name,
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
end

function Lumen:LoadTheme(name)
	if not name or name == "" then
		return false
	end

	name = cleanName(name)
	local path = findSaved(name, {
		Lumen.ThemeFolder,
		"NZL_Studio/themes",
		"lumen/themes",
	}) or (Lumen.ThemeFolder .. "/" .. name .. ".json")

	if not isfile(path) then
		Lumen:Notification({
			Name = "theme error",
			Description = "could not find " .. path,
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)

	if not ok or type(decoded) ~= "table" then
		return false
	end

	for key, hex in next, decoded do
		if Lumen.Theme[key] ~= nil and type(hex) == "string" then
			local parsed = pcall(function()
				return Color3.fromHex(hex)
			end)
			local color = parsed and Color3.fromHex(hex) or nil
			if color then
				Lumen.Theme[key] = color
			end
		end
	end

	applyTheme()
	Lumen.ThemeName = name

	Lumen:Notification({
		Name = "theme loaded",
		Description = name,
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
end

function Lumen:DeleteTheme(name)
	if not name or name == "" then
		return false
	end

	name = cleanName(name)
	local path = findSaved(name, {
		Lumen.ThemeFolder,
		"NZL_Studio/themes",
		"lumen/themes",
	}) or (Lumen.ThemeFolder .. "/" .. name .. ".json")

	if not isfile(path) then
		Lumen:Notification({
			Name = "theme error",
			Description = "could not find " .. path,
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	pcall(delfile, path)
	return true
end

function Lumen:SetAutoloadTheme(name)
	ensureFolders()

	name = cleanName(name)

	-- same rule as configs: arming a theme that was never saved would silently do
	-- nothing next launch, so save what the screen shows under that name
	if name ~= "" and not isfile(Lumen.ThemeFolder .. "/" .. name .. ".json") then
		Lumen:SaveTheme(name)
	end

	pcall(writefile, Lumen.Folder .. "/autoload_theme.txt", name)
	Lumen:SyncConfigUI()
	return name ~= ""
end

function Lumen:GetAutoloadTheme()
	return cleanName(readText(Lumen.Folder .. "/autoload_theme.txt"))
end

-- ready made config ui
function Lumen:BuildConfigSection(section)
	if not section then
		return
	end

	Lumen.State.ConfigUICount = (Lumen.State.ConfigUICount or 0) + 1
	local suffix = Lumen.State.ConfigUICount == 1 and "" or "_" .. Lumen.State.ConfigUICount

	local configDropdown = section:Dropdown({
		Name = "config",
		Items = Lumen:GetConfigs(),
		Flag = "lumen_config_select" .. suffix,
	})

	local nameBox = section:Textbox({
		Name = "config name",
		Placeholder = "my config",
		Flag = "lumen_config_name" .. suffix,
	})

	section:Button({
		Name = "save",
		Callback = function()
			local name = nameBox:Get()
			if name == "" then
				name = configDropdown:Get()
			end

			if not name or name == "" then
				Lumen:Notification({ Name = "config error", Description = "no name given", Duration = 3, Color = Lumen.Theme.Error })
				return
			end

			Lumen:SaveConfig(name)
			configDropdown:Refresh(Lumen:GetConfigs())
			configDropdown:Set(name)
		end,
	})

	section:Button({
		Name = "overwrite config",
		Tooltip = "save the current setup over the selected config",
		Callback = function()
			local name = configDropdown:Get()
			if not name or name == "" then
				name = nameBox:Get()
			end

			if not name or name == "" then
				Lumen:Notification({
					Name = "config error",
					Description = "pick a config in the list first",
					Duration = 3,
					Color = Lumen.Theme.Error,
				})
				return
			end

			if not Lumen:OverwriteConfig(name) then
				Lumen:Notification({
					Name = "config error",
					Description = "'" .. name .. "' is not saved yet",
					Duration = 3,
					Color = Lumen.Theme.Error,
				})
				return
			end

			configDropdown:Refresh(Lumen:GetConfigs())
			configDropdown:Set(name, true)
		end,
	})

	section:Button({
		Name = "load",
		Callback = function()
			local name = configDropdown:Get()
			if not name or name == "" then
				name = nameBox:Get()
			end
			if name and name ~= "" then
				Lumen:LoadConfig(name)
			else
				Lumen:Notification({
					Name = "config error",
					Description = "select a config or type its name first",
					Duration = 3,
					Color = Lumen.Theme.Error,
				})
			end
		end,
	})

	section:Button({
		Name = "delete",
		Confirm = true,
		Callback = function()
			local name = configDropdown:Get()
			if name and name ~= "" then
				Lumen:DeleteConfig(name)
				configDropdown:Refresh(Lumen:GetConfigs())
			else
				Lumen:Notification({
					Name = "config error",
					Description = "no config selected",
					Duration = 3,
					Color = Lumen.Theme.Error,
				})
			end
		end,
	})

	section:Button({
		Name = "refresh list",
		Callback = function()
			configDropdown:Refresh(Lumen:GetConfigs())
		end,
	})

	-- the state of this toggle always comes from the files (Lumen:SyncConfigUI), and
	-- turning it on never fails silently: the name comes from the dropdown or from the
	-- name box, and if there is no name at all the user is told
	section:Toggle({
		Name = "autoload this config",
		Flag = "lumen_config_autoload" .. suffix,
		Callback = function(enabled)
			if not enabled then
				Lumen:SetAutoload("")
				return
			end

			local name = configDropdown:Get()
			if not name or name == "" then
				name = nameBox:Get()
			end

			if not name or name == "" then
				Lumen:Notification({
					Name = "autoload",
					Description = "pick a config in the list or type a name first",
					Duration = 4,
					Color = Lumen.Theme.Error,
				})
				Lumen:SyncConfigUI()      -- puts the switch back to off
				return
			end

			Lumen:SetAutoload(name)
			configDropdown:Refresh(Lumen:GetConfigs())
		end,
	})

	-- show the truth right away: which config is armed, whether autosave is on
	Lumen:SyncConfigUI()

	return configDropdown, nameBox
end

-- ready made theme ui
function Lumen:BuildThemeSection(section)
	if not section then
		return
	end

	Lumen.State.ThemeUICount = (Lumen.State.ThemeUICount or 0) + 1
	local suffix = Lumen.State.ThemeUICount == 1 and "" or "_" .. Lumen.State.ThemeUICount

	-- the preset list carries every theme; the ones with a moving character come first so
	-- they are the first thing the dropdown offers (they are still plain names to SetTheme)
	local animatedPresets, plainPresets = { }, { }
	for name, theme in next, Lumen.Themes do
		table.insert(theme.Animated and animatedPresets or plainPresets, name)
	end
	table.sort(animatedPresets)
	table.sort(plainPresets)

	local presets = { }
	for _, name in next, animatedPresets do
		table.insert(presets, name)
	end
	for _, name in next, plainPresets do
		table.insert(presets, name)
	end

	local presetDropdown = section:Dropdown({
		Name = "preset",
		Items = presets,
		Default = Lumen.ThemeName,
		Flag = "lumen_theme_preset" .. suffix,
		Callback = function(value)
			Lumen.State.ThemePreset = value
			Lumen:SetTheme(value)
		end,
	})

	Lumen.State.ThemePresets = Lumen.State.ThemePresets or { }
	table.insert(Lumen.State.ThemePresets, presetDropdown)
	presetDropdown.Window = presetDropdown.Window or Lumen.State.Window

	local pickers = { }
	local order = { "Accent", "Background", "Sidebar", "Panel", "Element", "Border", "Text", "TextDim" }

	for _, key in next, order do
		pickers[key] = section:Colorpicker({
			Name = key,
			Default = Lumen.Theme[key],
			Flag = "lumen_theme_" .. string.lower(key) .. suffix,
			Callback = function(color)
				Lumen:SetColor(key, color)
			end,
		})
	end

	Lumen.State.ThemePickers = Lumen.State.ThemePickers or { }
	for key, picker in next, pickers do
		picker.Window = picker.Window or Lumen.State.Window
		table.insert(Lumen.State.ThemePickers, { Key = key, Picker = picker, Window = picker.Window })
	end

	local themeDropdown = section:Dropdown({ Name = "saved themes", Items = Lumen:GetThemeConfigs(), Flag = "lumen_saved_theme" .. suffix })
	local themeName = section:Textbox({ Name = "theme name", Placeholder = "my theme", Flag = "lumen_theme_name" .. suffix })

	-- the toggle below reads the file, so a theme that is already armed shows as armed
	Lumen:SyncConfigUI()

	section:Button({
		Name = "save theme",
		Callback = function()
			local name = themeName:Get()
			if name == "" then
				Lumen:Notification({ Name = "theme error", Description = "no name given", Duration = 3, Color = Lumen.Theme.Error })
				return
			end

			Lumen:SaveTheme(name)
			themeDropdown:Refresh(Lumen:GetThemeConfigs())
		end,
	})

	section:Button({
		Name = "load theme",
		Callback = function()
			local name = themeDropdown:Get()
			if name and name ~= "" then
				Lumen:LoadTheme(name)
			else
				Lumen:Notification({
					Name = "theme error",
					Description = "select a saved theme first",
					Duration = 3,
					Color = Lumen.Theme.Error,
				})
			end
		end,
	})

	section:Button({
		Name = "delete theme",
		Confirm = true,
		Callback = function()
			local name = themeDropdown:Get()
			if name and name ~= "" then
				Lumen:DeleteTheme(name)
				themeDropdown:Refresh(Lumen:GetThemeConfigs())
			else
				Lumen:Notification({
					Name = "theme error",
					Description = "no theme selected",
					Duration = 3,
					Color = Lumen.Theme.Error,
				})
			end
		end,
	})

	section:Button({
		Name = "reset theme",
		Callback = function()
			-- falls back to the library default (azure) when nothing else was picked
			local preset = Lumen.State.ThemePreset
			if not preset or not Lumen.Themes[preset] then
				preset = Lumen.DefaultTheme
			end
			Lumen:SetTheme(preset)
			Lumen:Notification({
				Name = "theme reset",
				Description = "restored " .. preset .. " defaults",
				Duration = 3,
				Color = Lumen.Theme.Success,
			})
		end,
	})

	section:Toggle({
		Name = "autoload this theme",
		Flag = "lumen_theme_autoload" .. suffix,
		Callback = function(enabled)
			if not enabled then
				Lumen:SetAutoloadTheme("")
				return
			end

			local name = themeDropdown:Get()
			if not name or name == "" then
				name = themeName:Get()
			end

			if not name or name == "" then
				Lumen:Notification({
					Name = "autoload",
					Description = "pick a saved theme or type its name first",
					Duration = 4,
					Color = Lumen.Theme.Error,
				})
				Lumen:SyncConfigUI()
				return
			end

			Lumen:SetAutoloadTheme(name)
			themeDropdown:Refresh(Lumen:GetThemeConfigs())
		end,
	})

	return pickers
end

-- called at the end of the script (after the window exists): puts the saved setup
-- back on screen. returns a report so a caller can log what happened.
function Lumen:Init()
	ensureFolders()

	local report = { Config = nil, Theme = nil, Autosave = false, Errors = { } }
	local autoConfig = Lumen:GetAutoload()
	local autoTheme = Lumen:GetAutoloadTheme()

	if autoConfig ~= "" then
		if Lumen:ConfigExists(autoConfig) then
			if Lumen:LoadConfig(autoConfig) then
				report.Config = autoConfig
			else
				table.insert(report.Errors, "config failed to load: " .. autoConfig)
			end
		else
			table.insert(report.Errors, "autoload config not found: " .. autoConfig)

			Lumen:Notification({
				Name = "autoload",
				Description = "config '" .. autoConfig .. "' is not on disk anymore",
				Duration = 6,
				Color = Lumen.Theme.Error,
			})
		end
	elseif Lumen:IsAutosave() then
		if Lumen:LoadAutosave() then
			report.Autosave = true
		else
			table.insert(report.Errors, "autosave snapshot failed to load")
		end
	end

	if autoTheme ~= "" then
		if isfile(Lumen.ThemeFolder .. "/" .. autoTheme .. ".json") then
			if Lumen:LoadTheme(autoTheme) then
				report.Theme = autoTheme
			else
				table.insert(report.Errors, "theme failed to load: " .. autoTheme)
			end
		else
			table.insert(report.Errors, "autoload theme not found: " .. autoTheme)
		end
	end

	-- the window opens before Init in the demo, so this is the first moment the
	-- settings widgets can show the truth about what was restored
	Lumen:SyncConfigUI()

	if report.Config then
		Lumen:Notification({
			Name = "config restored",
			Description = report.Config,
			Duration = 3,
			Color = Lumen.Theme.Success,
		})
	elseif report.Autosave then
		Lumen:Notification({
			Name = "setup restored",
			Description = "autosave",
			Duration = 3,
			Color = Lumen.Theme.Success,
		})
	end

	if report.Theme then
		Lumen:Notification({
			Name = "theme restored",
			Description = report.Theme,
			Duration = 3,
			Color = Lumen.Theme.Success,
		})
	end

	return report
end

-- full unload: after this call the ui is really gone - no widgets, no connections,
-- no background threads, no globals. Safe to call twice.
function Lumen:Unload()
	local state = Lumen.State

	-- 0) with autosave on, the state of the ui is written out before it is torn down:
	--    closing the menu is the moment the setup is "final". the pending debounce is
	--    dropped first, otherwise it would fire two seconds later, when the ui is
	--    already gone, and write a stale snapshot over this one.
	if autosaveThread then
		pcall(task.cancel, autosaveThread)
		autosaveThread = nil
	end

	if state.Running and Lumen:IsAutosave() then
		pcall(function()
			Lumen:SaveAutosave()
		end)
	end

	-- 1) stop the background threads (rainbow pickers, toast timers, tooltips, the
	--    animated theme) and put the flying brand back where it was
	state.Running = false
	stopAnimatedTheme()

	for _, option in next, Lumen.Options do
		if option.Type == "Colorpicker" and option.SetRainbow then
			pcall(function()
				option:SetRainbow(false)
			end)
		end
	end

	-- 2) every connection the ui opened, including the short lived ones
	for _, connection in next, Lumen.Connections do
		pcall(function()
			connection:Disconnect()
		end)
	end
	Lumen.Connections = { }

	for _, connection in next, Lumen.TransientConnections do
		pcall(function()
			connection:Disconnect()
		end)
	end
	Lumen.TransientConnections = { }

	-- 3) keybind buttons live inside the settings widgets, but they are stateful
	for _, keybind in next, state.Keybinds do
		keybind.Listening = false
		keybind.Toggled = false
		pcall(function()
			if keybind.Button and keybind.Button.Parent then
				keybind.Button:Destroy()
			end
		end)
	end
	state.Keybinds = { }

	-- 4) the floating widgets (they are children of the screen, but destroy them
	--    explicitly so a broken parent cannot keep them alive)
	local floating = {
		state.MinimizedBar,
		state.Watermark and state.Watermark.Items and state.Watermark.Items.Frame,
		state.KeybindsList and state.KeybindsList.Items and state.KeybindsList.Items.Frame,
	}
	for _, widget in next, floating do
		if widget then
			pcall(function()
				widget:Destroy()
			end)
		end
	end

	-- 5) the whole interface (window, popups, notifications, tooltips)
	if state.Screen then
		pcall(function()
			state.Screen:Destroy()
		end)
	end

	-- the blank selection template is unparented, so it would never be cleaned up
	-- by destroying the screen: one of these leaked for every execution before
	if state.BlankSelection then
		pcall(function()
			state.BlankSelection:Destroy()
		end)
		state.BlankSelection = nil
	end

	-- 6) defensive sweep: nothing called "lumen_ui" may survive an unload
	pcall(function()
		local roots = { }
		local ok, parent = pcall(guiParent)
		if ok then
			table.insert(roots, parent)
		end
		table.insert(roots, game:GetService("CoreGui"))
		if LocalPlayer then
			table.insert(roots, LocalPlayer:FindFirstChild("PlayerGui"))
		end

		for _, root in next, roots do
			local left = root and root:FindFirstChild("lumen_ui")
			if left then
				left:Destroy()
			end
		end
	end)

	-- 7) drop every reference to the destroyed widgets
	state.Window = nil
	state.Screen = nil
	state.Popups = nil
	state.Notifications = nil
	state.MinimizedBar = nil
	state.Watermark = nil
	state.KeybindsList = nil
	state.Dropdowns = { }
	state.PopupWindows = { }
	state.InputHandler = false
	state.ThemeRegistry = { }
	state.ThemeRefreshers = { }

	Lumen.Flags = { }
	Lumen.Options = { }
	Lumen.State = createState()
	Lumen.State.Running = false
	Lumen.State.Ready = false

	-- the shared "no selection outline" template goes away with the ui
	if BlankSelection and BlankSelection.Parent then
		pcall(function()
			BlankSelection:Destroy()
		end)
	end

	if getgenv then
		getgenv().CAMMainLumen = nil
	end

	pcall(function()
		UserInputService.MouseIconEnabled = true
	end)

	return true
end

-- quick check for scripts that keep a reference to the library
function Lumen:IsLoaded()
	return Lumen.State ~= nil and Lumen.State.Ready == true and Lumen.State.Window ~= nil
end
--#endregion

getgenv().CAMMainLumen = Lumen
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

local CAM_BOSS_NAMES = {
    ["Akazo"]=true,
    ["Datai"]=true,
    ["Domae"]=true,
    ["Enru"]=true,
    ["FlameTrainee"]=true,
    ["Giyen"]=true,
    ["Gyorei"]=true,
    ["Gyutai"]=true,
    ["HandDemon"]=true,
    ["Hoyuzo"]=true,
    ["InsectTrainee"]=true,
    ["MotherBear"]=true,
    ["Nezura"]=true,
    ["Obari"]=true,
    ["Reaper"]=true,
    ["ReaperTrainee"]=true,
    ["Rengu"]=true,
    ["Saneri"]=true,
    ["SerpentTrainee"]=true,
    ["Shinora"]=true,
    ["SmallYeti"]=true,
    ["SoryuTrainee"]=true,
    ["SoundTrainee"]=true,
    ["StoneTrainee"]=true,
    ["Sumari"]=true,
    ["TaiChiTrainee"]=true,
    ["Tengai"]=true,
    ["ThunderTrainee"]=true,
    ["WaterTrainee"]=true,
    ["WindTrainee"]=true,
    ["Yahari"]=true,
    ["YetiDemon"]=true,
    ["Zentaro"]=true,
}
local CAM_CATALOG = {["npcs"]={{["name"]="Bandit",["code"]="KaruVillageBandit",["position"]={-287.0,1223.0,-1107.0},["boss"]=false,["aliases"]={"Bandit","KaruVillageBandit"},["source"]="ReplicatedStorage.Ouwland.Content.Windy Peak.ActiveNpcs.Bandit"},{["name"]="Zuko",["code"]="Zuko",["position"]={-283.311,1224.2,-1032.39},["boss"]=true,["aliases"]={"Zuko"},["source"]="ReplicatedStorage.Ouwland.Content.Windy Peak.ActiveNpcs.Zuko"},{["name"]="Bear Cub",["code"]="BearCub",["position"]={540.5,1121.0,-1023.5},["boss"]=false,["aliases"]={"Bear Cub","BearCub"},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Bear Cub"},{["name"]="Hoyuzo Subordinate",["code"]="HoyuzoSub",["position"]={536.0,1001.0,-1389.0},["boss"]=false,["aliases"]={"Hoyuzo Subordinate","HoyuzoSub"},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Hoyuzo Subordinate"},{["name"]="Hoyuzo",["code"]="Hoyuzo",["position"]={746.875,1001.0,-1413.0},["boss"]=true,["aliases"]={"Hoyuzo"},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Hoyuzo"},{["name"]="Kaiden Subordinate",["code"]="KaidenSub",["position"]={601.3,1146.547,-1305.887},["boss"]=false,["aliases"]={"Kaiden Subordinate","KaidenSub"},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Kaiden Subordinate"},{["name"]="Kaiden",["code"]="Kaiden",["position"]={585.712,1146.547,-1314.887},["boss"]=true,["aliases"]={"Kaiden"},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Kaiden"},{["name"]="Mother Bear",["code"]="MotherBear",["position"]={540.5,1121.0,-1023.5},["boss"]=true,["aliases"]={"Mother Bear","MotherBear"},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.ActiveNpcs.Mother Bear"},{["name"]="Beast Born Demon",["code"]="BeastBornDemon_MistfallHarbor",["position"]={170.7,888.7,603.5},["boss"]=false,["aliases"]={"Beast Born Demon","BeastBornDemon_MistfallHarbor"},["source"]="ReplicatedStorage.Ouwland.Content.Mistfall Harbor.ActiveNpcs.Beast Born Demon"},{["name"]="Akazo",["code"]="Akazo",["position"]={-1131.975,1380.916,-1746.561},["boss"]=true,["aliases"]={"Akazo"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Akazo"},{["name"]="Datai",["code"]="Datai",["position"]={-165.5,1043.0,-1137.5},["boss"]=true,["aliases"]={"Datai"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Datai"},{["name"]="Domae",["code"]="Domae",["position"]={-296.472,1350.5,-3451.273},["boss"]=true,["aliases"]={"Domae"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Domae"},{["name"]="Enru",["code"]="Enru",["position"]={821.783,800.0,543.896},["boss"]=true,["aliases"]={"Enru"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Enru"},{["name"]="Flame Trainee",["code"]="FlameTrainee",["position"]={-1128.902,1029.049,994.42},["boss"]=true,["aliases"]={"Flame Trainee","FlameTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Flame Trainee"},{["name"]="Giyen",["code"]="Giyen",["position"]={388.866,1018.0,-85.056},["boss"]=true,["aliases"]={"Giyen"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Giyen"},{["name"]="Gyorei",["code"]="Gyorei",["position"]={2574.568,1089.0,-742.43},["boss"]=true,["aliases"]={"Gyorei"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Gyorei"},{["name"]="Gyutai",["code"]="Gyutai",["position"]={-266.118,1043.237,-1139.734},["boss"]=true,["aliases"]={"Gyutai"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Gyutai"},{["name"]="Insect Trainee",["code"]="InsectTrainee",["position"]={-1395.644,261.5,69.22},["boss"]=true,["aliases"]={"Insect Trainee","InsectTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Insect Trainee"},{["name"]="Nezura",["code"]="Nezura",["position"]={-1459.526,275.951,935.536},["boss"]=true,["aliases"]={"Nezura"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Nezura"},{["name"]="Obari",["code"]="Obari",["position"]={770.518,1121.0,-1047.036},["boss"]=true,["aliases"]={"Obari"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Obari"},{["name"]="Reaper Trainee Kuzan",["code"]="ReaperTrainee",["position"]={-1219.262,1373.625,-3034.386},["boss"]=true,["aliases"]={"Reaper Trainee Kuzan","ReaperTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Reaper Trainee"},{["name"]="Reaper",["code"]="Reaper",["position"]={98.468,1043.0,-573.911},["boss"]=true,["aliases"]={"Reaper"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Reaper"},{["name"]="Rengu",["code"]="Rengu",["position"]={-712.898,965.0,883.799},["boss"]=true,["aliases"]={"Rengu"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Rengu"},{["name"]="Saneri",["code"]="Saneri",["position"]={-379.108,1093.531,-422.421},["boss"]=true,["aliases"]={"Saneri"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Saneri"},{["name"]="Serpent Trainee",["code"]="SerpentTrainee",["position"]={-271.378,1292.0,-1535.713},["boss"]=true,["aliases"]={"Serpent Trainee","SerpentTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Serpent Trainee"},{["name"]="Shinora",["code"]="Shinora",["position"]={-452.647,964.498,2.124},["boss"]=true,["aliases"]={"Shinora"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Shinora"},{["name"]="Soryu Trainee Goki",["code"]="SoryuTrainee",["position"]={-426.985,288.809,543.272},["boss"]=true,["aliases"]={"Soryu Trainee Goki","SoryuTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Soryu Trainee"},{["name"]="Sound Trainee",["code"]="SoundTrainee",["position"]={192.5,1349.0,-2581.313},["boss"]=true,["aliases"]={"Sound Trainee","SoundTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Sound Trainee"},{["name"]="Stone Trainee",["code"]="StoneTrainee",["position"]={2685.184,1073.6,-568.754},["boss"]=true,["aliases"]={"Stone Trainee","StoneTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Stone Trainee"},{["name"]="Sumari",["code"]="Sumari",["position"]={396.444,1018.0,-620.403},["boss"]=true,["aliases"]={"Sumari"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Sumari"},{["name"]="Tai Chi Trainee Suzume",["code"]="TaiChiTrainee",["position"]={2360.47,601.991,-642.309},["boss"]=true,["aliases"]={"Tai Chi Trainee Suzume","TaiChiTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Tai Chi Trainee"},{["name"]="Tengai",["code"]="Tengai",["position"]={-133.509,1349.0,-2631.336},["boss"]=true,["aliases"]={"Tengai"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Tengai"},{["name"]="Thunder Trainee",["code"]="ThunderTrainee",["position"]={2425.506,1073.631,-556.788},["boss"]=true,["aliases"]={"Thunder Trainee","ThunderTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Thunder Trainee"},{["name"]="Water Trainee Sabito",["code"]="WaterTrainee",["position"]={815.348,1018.884,101.599},["boss"]=true,["aliases"]={"Water Trainee Sabito","WaterTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Water Trainee"},{["name"]="Wind Trainee",["code"]="WindTrainee",["position"]={-941.573,1381.0,-2635.568},["boss"]=true,["aliases"]={"Wind Trainee","WindTrainee"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Wind Trainee"},{["name"]="Yahari",["code"]="Yahari",["position"]={825.678,1019.2,-641.335},["boss"]=true,["aliases"]={"Yahari"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Yahari"},{["name"]="Zentaro",["code"]="Zentaro",["position"]={1332.091,821.5,-1017.637},["boss"]=true,["aliases"]={"Zentaro"},["source"]="ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs.Zentaro"},{["name"]="Fire Profound Demon",["code"]="FireProfoundDemon",["position"]={-1171.125,1382.074,-2443.031},["boss"]=false,["aliases"]={"Fire Profound Demon","FireProfoundDemon"},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.Fire Profound Demon"},{["name"]="High Demon",["code"]="HighDemon",["position"]={518.066,1222.043,-1785.63},["boss"]=false,["aliases"]={"High Demon","HighDemon"},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.High Demon"},{["name"]="Ice Profound Demon",["code"]="IceProfoundDemon",["position"]={-1076.229,1380.5,-2598.538},["boss"]=false,["aliases"]={"Ice Profound Demon","IceProfoundDemon"},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.Ice Profound Demon"},{["name"]="Kanoe Demon Slayer",["code"]="KanoeDemonSlayer",["position"]={359.65,1350.0,-2297.082},["boss"]=false,["aliases"]={"Kanoe Demon Slayer","KanoeDemonSlayer","Mizunoto"},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.ActiveNpcs.Kanoe Demon Slayer"},{["name"]="Fujiko",["code"]="Fujiko",["position"]={-2459.527,37.868,1119.002},["boss"]=true,["aliases"]={"Fujiko"},["source"]="ReplicatedStorage.Ouwland.Content.Final Selection Plains.ActiveNpcs.Fujiko"},{["name"]="Blood Hounded Demon",["code"]="BloodHoundedDemon_MistfallHarbor",["position"]={700.316,823.5,1027.131},["boss"]=false,["aliases"]={"Blood Hounded Demon","BloodHoundedDemon_MistfallHarbor"},["source"]="ReplicatedStorage.Ouwland.Content.Mistfall Harbor.ActiveNpcs.Dreamfall Hollow.Blood Hounded Demon"},{["name"]="Mizunoto",["code"]="Mizunoto_MistfallHarbor",["position"]={-887.885,964.0,-25.963},["boss"]=false,["aliases"]={"Mizunoto","Mizunoto_MistfallHarbor"},["source"]="ReplicatedStorage.Ouwland.Content.Mistfall Harbor.ActiveNpcs.Seasons Crossing.Mizunoto"},{["name"]="Greater Demon",["code"]="GreaterDemon_ButterflyEstate",["position"]={-400.699,287.24,512.891},["boss"]=false,["aliases"]={"Greater Demon","GreaterDemon_ButterflyEstate"},["source"]="ReplicatedStorage.Ouwland.Content.Butterfly Estate.ActiveNpcs.Veilfall Cavern.Greater Demon"},{["name"]="Lesser Demon",["code"]="LesserDemon_ButterflyEstate",["position"]={-715.64,219.39,456.22},["boss"]=false,["aliases"]={"Lesser Demon","LesserDemon_ButterflyEstate"},["source"]="ReplicatedStorage.Ouwland.Content.Butterfly Estate.ActiveNpcs.Veilfall Cavern.Lesser Demon"},{["name"]="Mizunoe Demon Slayer",["code"]="MizunoeDemonSlayer",["position"]={-1898.827,29.032,487.142},["boss"]=false,["aliases"]={"Mizunoe Demon Slayer","MizunoeDemonSlayer","Mizunoto"},["source"]="ReplicatedStorage.Ouwland.Content.Final Selection Plains.ActiveNpcs.The White Terror Lair.Mizunoe Demon Slayer"}},["quests"]={{["key"]="Ill take 3 bandits",["title"]="Defeat 3 bandits",["npc"]="Krue",["npcPosition"]={-425.491821,1243.50012,-952.493408},["code"]="KaruVillageBandit",["count"]=3,["level"]=0,["region"]="Windy Peak",["targetPosition"]={-287.0,1223.0,-1107.0},["source"]="ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.Krue"},{["key"]="Ill take the bandit boss(Lv 7)",["title"]="Defeat The Bandit Boss",["npc"]="Krue",["npcPosition"]={-425.491821,1243.50012,-952.493408},["code"]="Zuko",["count"]=1,["level"]=7,["region"]="Windy Peak",["targetPosition"]={-283.311,1224.2,-1032.39},["source"]="ReplicatedStorage.Ouwland.Content.Windy Peak.NpcContents.Dialogues.Quests.Krue"},{["key"]="Ill drive the bears back(Lv 10)",["title"]="Hunt the Bears",["npc"]="Tom",["npcPosition"]={507.230621,1121.41968,-970.192566},["code"]="BearCub",["count"]=4,["level"]=10,["region"]="Bamboo Grove",["targetPosition"]={540.5,1121.0,-1023.5},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Tom"},{["key"]="Ill fell the Mother Bear(Lv 18)",["title"]="Fell the Mother Bear",["npc"]="Tom",["npcPosition"]={507.230621,1121.41968,-970.192566},["code"]="MotherBear",["count"]=1,["level"]=18,["region"]="Bamboo Grove",["targetPosition"]={540.5,1121.0,-1023.5},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Tom"},{["key"]="Ill clear out his subordinates(Lv 26)",["title"]="Clear Kaiden's Subordinates",["npc"]="Chaka",["npcPosition"]={471.0,1146.0,-1260.0},["code"]="KaidenSub",["count"]=4,["level"]=26,["region"]="Bamboo Grove",["targetPosition"]={601.3,1146.547,-1305.887},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Chaka"},{["key"]="Ill deal with Kaiden(Lv 34)",["title"]="Defeat Kaiden",["npc"]="Chaka",["npcPosition"]={471.0,1146.0,-1260.0},["code"]="Kaiden",["count"]=1,["level"]=34,["region"]="Bamboo Grove",["targetPosition"]={585.712,1146.547,-1314.887},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Chaka"},{["key"]="I will clear out his guards(Lv 40)",["title"]="Clear Hoyuzo's Guard",["npc"]="Wagwan",["npcPosition"]={723.761536,1019.19946,-801.984009},["code"]="HoyuzoSub",["count"]=4,["level"]=40,["region"]="Bamboo Grove",["targetPosition"]={536.0,1001.0,-1389.0},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Wagwan"},{["key"]="Ill drive them off(Lv 47)",["title"]="Hold the Night",["npc"]="Rin",["npcPosition"]={432.25,1018.0,73.1},["code"]="BeastBornDemon_MistfallHarbor",["count"]=5,["level"]=47,["region"]="Mistfall Harbor",["targetPosition"]={170.7,888.7,603.5},["source"]="ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Rin"},{["key"]="I will take care of Hoyuzo(Lv 50)",["title"]="Defeat Hoyuzo",["npc"]="Wagwan",["npcPosition"]={723.761536,1019.19946,-801.984009},["code"]="Hoyuzo",["count"]=1,["level"]=50,["region"]="Bamboo Grove",["targetPosition"]={746.875,1001.0,-1413.0},["source"]="ReplicatedStorage.Ouwland.Content.Bamboo Grove.NpcContents.Dialogues.Quests.Wagwan"},{["key"]="Ill clear the cave(Lv 62)",["title"]="Purge Dreamfall Hollow",["npc"]="Jugg",["npcPosition"]={487.702,874.066,1007.795},["code"]="BloodHoundedDemon_MistfallHarbor",["count"]=7,["level"]=62,["region"]="Mistfall Harbor",["targetPosition"]={700.316,823.5,1027.131},["source"]="ReplicatedStorage.Ouwland.Content.Mistfall Harbor.NpcContents.Dialogues.Quests.Dreamfall Hollow.Jugg"},{["key"]="Ill break their watch(Lv 75)",["title"]="Break the Cave Watch",["npc"]="Demon Mokuro",["npcPosition"]={-1948.429,28.374,374.307},["code"]="MizunoeDemonSlayer",["count"]=6,["level"]=75,["region"]="Final Selection Plains",["targetPosition"]={-1898.827,29.032,487.142},["source"]="ReplicatedStorage.Ouwland.Content.Final Selection Plains.NpcContents.Dialogues.Quests.The White Terror Lair.Demon Mokuro"},{["key"]="Ill thin them out(Lv 75)",["title"]="Thin the Cavern Floor",["npc"]="Demon Slayer Goro",["npcPosition"]={-871.97,234.75,318.469},["code"]="LesserDemon_ButterflyEstate",["count"]=6,["level"]=75,["region"]="Butterfly Estate",["targetPosition"]={-715.64,219.39,456.22},["source"]="ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Quests.Veilfall Cavern.Demon Slayer Goro"},{["key"]="Ill go up after the greater ones(Lv 83)",["title"]="Hunt the Greater Demons",["npc"]="Demon Slayer Goro",["npcPosition"]={-871.97,234.75,318.469},["code"]="GreaterDemon_ButterflyEstate",["count"]=7,["level"]=83,["region"]="Butterfly Estate",["targetPosition"]={-400.699,287.24,512.891},["source"]="ReplicatedStorage.Ouwland.Content.Butterfly Estate.NpcContents.Dialogues.Quests.Veilfall Cavern.Demon Slayer Goro"},{["key"]="Ill help you defeat them(Lv 90)",["title"]="Drive Off the High Demons",["npc"]="Wounded Slayer Tomoi",["npcPosition"]={485.340332,1222.61743,-1812.99634},["code"]="HighDemon",["count"]=8,["level"]=90,["region"]="Iceveil Valley",["targetPosition"]={518.066,1222.043,-1785.63},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Wounded Slayer Tomoi"},{["key"]="Theyre not welcome here(Lv 90)",["title"]="Thin the Kanoe Ranks",["npc"]="Demon Delroy",["npcPosition"]={139.614,1254.197,-1911.295},["code"]="KanoeDemonSlayer",["count"]=8,["level"]=90,["region"]="Iceveil Valley",["targetPosition"]={359.65,1350.0,-2297.082},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Demon Delroy"},{["key"]="Ill drive back the frost(Lv 105)",["title"]="Drive Back the Frost",["npc"]="Demon Slayer Mitsu",["npcPosition"]={-824.3,1381.5,-2537.849},["code"]="IceProfoundDemon",["count"]=9,["level"]=105,["region"]="Iceveil Valley",["targetPosition"]={-1076.229,1380.5,-2598.538},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Demon Slayer Mitsu"},{["key"]="Ill put out the blaze(Lv 115)",["title"]="Put Out the Blaze",["npc"]="Demon Slayer Mitsu",["npcPosition"]={-824.3,1381.5,-2537.849},["code"]="FireProfoundDemon",["count"]=8,["level"]=115,["region"]="Iceveil Valley",["targetPosition"]={-1171.125,1382.074,-2443.031},["source"]="ReplicatedStorage.Ouwland.Content.Iceveil Valley.NpcContents.Dialogues.Quests.Demon Slayer Mitsu"}},["expPerLevel"]=60,["note"]="Conservative static extraction from supplied decompiled content. Only single kill-task, no-cost, repeatable Combat routes with known NPC/spawn positions."}
-- CAM Main Hub 3.2.4 | source-backed client integration for place 136406881576517.
-- No downloaded code, hooks, decompilation, arbitrary remotes, purchases or webhooks.
local function StartCAMHub(Lumen)
    local Env = (getgenv and getgenv()) or _G
    if Env.CAMMainHub and Env.CAMMainHub.Stop then pcall(Env.CAMMainHub.Stop) end
    local Players=game:GetService("Players")
    local RS=game:GetService("ReplicatedStorage")
    local Run=game:GetService("RunService")
    local Input=game:GetService("UserInputService")
    local CS=game:GetService("CollectionService")
    local Http=game:GetService("HttpService")
    local LP=Players.LocalPlayer
    assert(LP,"Client required")
    local S={alive=true, autoLevel=false, farm=false, attack=false, skills=false, autoHunt=false,
        loot=false,chest=false,fly=false,noclip=false,speed=false,jump=false,run=false,shift=false,instant=false,
        esp=false,players=false,mobs=false,bosses=false,npcs=false,chests=false,drops=false,muzan=false,lily=false,levers=false,horses=false,
        box=false,fill=false,box3d=false,names=false,distance=false,health=false,hpbar=false,tracer=false,
        notifyBoss=false,notifyMuzan=false,notifyHunts=false,
        targetName="",targetKind="Mob",searchRange=350,hitRange=7,standOff=4,skillRange=35,
        targetMode="Selected mob",mobCode="KaruVillageBandit",bossCode="Zuko",
        positionMode="Above",farmDistance=2,farmHeight=3,travelMode="Tween",travelSpeed=80,orbitSpeed=1,
        lookMode="Horizontal",inputMode="Auto (live punch / native input)",weapon="Auto combat tool",
        questPolicy="Highest eligible",questStage="OFF",questName="-",questProgress="-",equipment="-",noDamageTimeout=20,
        attackDelay=0.5,skillDelay=3,skillHold=0.2,healthStop=25,farmNoclip=true,autoPotion=false,potionHp=35,potionDelay=6,potionChoice="Auto (strongest heal)",baitName="",
        walkSpeed=26,jumpHeight=12,flySpeed=45,espRange=600,espLimit=40,
        priority="Combat first",destinationType="Zone",destination="",huntId="",status="Ready - automation OFF",
        skillSlots={},epoch=0,
        autoParry=false,parryRange=14,parryHold=0.35,parryCooldown=0.9,
        autoTraining=false,trainingMode="Instant (win signal)",trainDelay=0.5,
        buyName="",buyAmount=1,loadoutName="",loadoutText="",rankedKey="",
        autoFish=false,fishDelay=1.0,fishNudge=8,wurfansClue="1",treeNode="Max Health",
        infStamina=false,noCd=false,fastM1=false,
        killAura=false,killAuraRange=12,noDebuffs=false,infJump=false,
        instaKill=false,instaKillPct=10,fastAttack=false,
        autoFarm=false,autoBoss=false,farmMobText="",farmStyle="Behind",farmDist=6,farmHeight=7,farmNoclip=true,farmSpeed=120,searchRange=300,m1Mode="Fast Attack (Combat_Service)",
        fullbright=false,noFog=false,fpsCapText="",
        autoSkills=false,autoSkillText="Breathing Boost",autoBreath=false}
    local C={connections={},toggles={},logs={},modules={},loading={},loaderTasks={},owned={},tickets={},
        collision=setmetatable({}, {__mode="k"}),holds=setmetatable({}, {__mode="k"}),
        humanoids={},humanoidOwners=setmetatable({}, {__mode="k"}),objects={},prompts={},esp={},cooldowns={},huntSent={},huntSeen={},
        skillIndex=0,seen=setmetatable({}, {__mode="k"}),count=0,indexing=true,visualClock=0,
        parryWatched=setmetatable({}, {__mode="k"}),parryPath="input",parryConfirmed=false,lastParry=0,
        parryAttempts=0,parryBlocked=0,parryPerfect=0,parryUnacked=0,
        blockWatchDone=false,trainWatchDone=false,trainSession=nil,sliderSamples={},trainClicks=0,trainWins=0,
        fish={casts=0,bites=0,wins=0,awaitingBite=false,last=0,portalDone=false},fastM1={},fatk={combo=1,next=0,last=0}}
    local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts,endTravel
    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel,fishLabel,treeLabel
    local targetDrop,destinationDrop,huntDrop
    local bossNames=CAM_BOSS_NAMES
    local function short(x,n) local s=tostring(x);return #s>(n or 160) and s:sub(1,n or 160).."..." or s end
    local function log(kind,text)
        C.logs[#C.logs+1]={time=os.date("!%H:%M:%S"),kind=kind,text=short(text,1000)}
        if #C.logs>120 then table.remove(C.logs,1) end
    end
    local function note(text)
        log("notice",text)
        if S.alive then pcall(function() Lumen:Notification({Name="CAM Main",Description=short(text,220),Duration=5}) end) end
    end
    local function at(root,path)
        for _,name in ipairs(path) do if not root then return nil end;root=root:FindFirstChild(name) end
        return root
    end
    local function live(o) return o and o.Parent and o:IsDescendantOf(workspace) end
    local function char()
        local c=LP.Character
        return c,c and c:FindFirstChildOfClass("Humanoid"),c and c:FindFirstChild("HumanoidRootPart")
    end
    local function part(o)
        if not o then return nil end
        if o:IsA("BasePart") then return o end
        if o:IsA("Attachment") then return part(o.Parent) end
        if o:IsA("Model") then return o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart",true) end
        return nil
    end
    local function position(o)
        local p=part(o);return p and p.Position
    end
    local function focused() return Input:GetFocusedTextBox()~=nil end
    local function menuOpen()
        local m=LP:FindFirstChild("MenuDestination")
        return m and m:IsA("StringValue") and m.Value~=""
    end
    local function usable()
        if not S.alive or game.PlaceId~=136406881576517 then return false,"Unsupported place (read-only)" end
        local _,h,r=char()
        if not h or not r or h.Health<=0 then return false,"Character unavailable" end
        if focused() or menuOpen() then return false,"Paused: text entry / native menu" end
        return true
    end
    local function flag(key,value)
        S[key]=value
        if C.toggles[key] then C.toggles[key]:Set(value,true) end
    end
    local function connect(signal,fn,label)
        local con=signal:Connect(function(...)
            if not S.alive then return end
            local ok,err=pcall(fn,...)
            if not ok then log("callback error",(label or "Callback")..": "..tostring(err));if stopAll then stopAll("Callback failed; see diagnostics") end end
        end)
        C.connections[#C.connections+1]=con;return con
    end
    local function data()
        local base=at(RS,{"Player_Service","Data",LP.Name})
        if not base then return nil end
        local slot=base:FindFirstChild("slotEquipped")
        return slot and at(base,{"slots","Slot"..tostring(slot.Value)})
    end
    local function values() return at(RS,{"Player_Service","Values",LP.Name}) end
    -- Only these specific live game modules may be required, after an explicit UI click.
    local modulePaths={
        Input={"CAM","Client","Components","Client","InputHandler"},
        Run={"CAM","Client","Modules","GamePlay","Run_Handler"},
        Recommended={"CAM","Client","Modules","RecommendedQuest"},
        Quests={"CAM","Global","Subsets","Gameplay","Quests"},
        HuntRules={"CAM","Global","Subsets","Gameplay","Quests","BossHunts"},
        Signal={"Communication","ServerAndClient","Signals","SignalEvent"},
        Regions={"Regions"},
        Info={"CAM","Global","Character_info_provider"},
        Items={"CAM","Global","Collectibles","Items"},
        Requirements={"CAM","Global","Collectibles","ItemRequirements"},
        Restrictions={"CAM","Global","Subsets","Gameplay","ToolbarItemRestrictions"},
        SignalF={"Communication","ServerAndClient","Signals","SignalFunction"},
        PlayerProfile={"CAM","Global","PlayerProfile"},
        ManageCD={"CAM","Global","Subsets","Gameplay","manage_cd"},
        CombatPresets={"CAM","Global","Combat_presets"},
    }
    local function loadNative()
        if game.PlaceId~=136406881576517 then note("Wrong place; native controls disabled") return end
        local epoch=S.epoch
        for key,path in pairs(modulePaths) do
            if not C.modules[key] and not C.loading[key] then
                local obj=at(RS,path)
                if not obj or not obj:IsA("ModuleScript") then
                    C.loading[key]="missing";log("module",key..": missing")
                else
                    C.loading[key]="loading"
                    local thread=task.spawn(function()
                        local ok,result=pcall(require,obj)
                        if not S.alive or epoch~=S.epoch then return end
                        C.loading[key]=(ok and type(result)=="table") and "ready" or "failed"
                        if ok and type(result)=="table" then C.modules[key]=result else log("module",key..": "..short(result)) end
                    end)
                    C.loaderTasks[key]=thread
                    task.delay(10,function()
                        if S.alive and epoch==S.epoch and C.loading[key]=="loading" then
                            C.loading[key]="timeout";if thread then pcall(task.cancel,thread) end
                            log("module",key..": timeout (10s)")
                        end
                    end)
                end
            end
        end
        -- Live layout fact (working script): Signals/SignalEvent is a FOLDER with the
        -- RemoteEvent child "Event"; requiring the folder fails, so resolve it directly.
        if not C.modules.Signal then
            local evt=at(RS,{"Communication","ServerAndClient","Signals","SignalEvent","Event"})
            if evt and (evt:IsA("RemoteEvent") or evt:IsA("UnreliableRemoteEvent")) then
                C.modules.Signal={ToServer=function(...) return evt:FireServer(...) end}
                C.loading.Signal="ready";log("module","Signal: live RemoteEvent resolved directly")
            end
        end
        local ready,total=0,0
        for key in pairs(modulePaths) do total=total+1;if C.modules[key] then ready=ready+1 end end
        note(ready==total and "Native controls ready. Enabled modes continue automatically." or
            ("Connecting native controls: "..ready.."/"..total.." ready. See dashboard for progress."))
    end
    local function release(action)
        C.tickets[action]=nil
        if C.owned[action] then
            C.owned[action]=nil
            local m=C.modules.Input
            if m and type(m.VirtualRelease)=="function" then pcall(m.VirtualRelease,action) end
        end
    end
    local function releaseAll()
        local actions={};for action in pairs(C.owned) do actions[#actions+1]=action end
        for _,action in ipairs(actions) do release(action) end
    end
    local function press(action,duration)
        local ok,why=usable();if not ok then return false,why end
        local m=C.modules.Input
        if not m or type(m.VirtualPress)~="function" or type(m.VirtualRelease)~="function" or type(m.IsDown)~="function" then return false,"Connect native controls first" end
        if C.owned[action] or m.IsDown(action) then return false,"Input already held" end
        C.count=C.count+1;local ticket=C.count;C.owned[action]=true;C.tickets[action]=ticket
        local success,err=pcall(m.VirtualPress,action)
        if not success then release(action);return false,short(err) end
        if duration then
            task.delay(duration,function() if C.tickets[action]==ticket then release(action) end end)
        end
        log("input",action.." (native checks still apply)")
        return true,"Native input: "..action
    end
    local function restoreMovement()
        for p,value in pairs(C.collision) do if p.Parent then pcall(function() p.CanCollide=value end) end;C.collision[p]=nil end
        if C.speedHum then pcall(function() C.speedHum.WalkSpeed=C.oldSpeed end);C.speedHum=nil end
        if C.jumpHum then pcall(function() C.jumpHum.JumpPower=C.oldJumpPower;C.jumpHum.JumpHeight=C.oldJumpHeight end);C.jumpHum=nil end
    end
    local function endFly()
        if C.flyVelocity then C.flyVelocity:Destroy();C.flyVelocity=nil end
        if C.flyAlign then C.flyAlign:Destroy();C.flyAlign=nil end
        if C.flyAttach then C.flyAttach:Destroy();C.flyAttach=nil end
        if C.flyHum then
            pcall(function() C.flyHum.PlatformStand=C.flyStand;C.flyHum.AutoRotate=C.flyRotate end)
            C.flyHum=nil
        end
        C.flyRoot=nil
    end
    local function restoreShift()
        if C.oldShift~=nil then
            local m=C.modules.Run
            if m and type(m.SetShiftLock)=="function" then pcall(m.SetShiftLock,C.oldShift) end
            C.oldShift=nil
        end
    end
    local function endPrompt()
        local p=C.activePrompt;C.activePrompt=nil
        if p then pcall(function() p:InputHoldEnd() end) end
    end
    local function restorePrompts()
        endPrompt()
        for p,duration in pairs(C.holds) do if p.Parent then pcall(function() p.HoldDuration=duration end) end;C.holds[p]=nil end
    end
    local function stopWalk()
        if C.walking then
            local _,h,r=char();if h and r then h:MoveTo(r.Position);h:Move(Vector3.zero) end
            C.walking=false
        end
        C.walkStart=nil;C.walkPos=nil
    end
    stopAll=function(reason)
        local _,h=char();local v=values();local stamina=v and v:FindFirstChild("Stamina")
        C.lastStop={reason=reason or "Stopped",timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),
            autoLevelWasOn=S.autoLevel,farmWasOn=S.farm,questStage=S.questStage,questName=S.questName,
            hp=h and h.Health or nil,maxHp=h and h.MaxHealth or nil,stamina=stamina and stamina.Value or nil,
            backend=C.inputBackend or "not used"}
        S.epoch=S.epoch+1
        for key in pairs(C.toggles) do flag(key,false) end
        for key,thread in pairs(C.loaderTasks) do
            if C.loading[key]=="loading" then if thread then pcall(task.cancel,thread) end;C.loading[key]=nil end
        end
        pcall(actions.m1Up)
        releaseAll();endFly();stopWalk();if endTravel then endTravel() end;restoreMovement();restorePrompts();restoreShift()
        C.questActive=nil;C.questRoute=nil;C.questSentAt=nil;C.questAttempts=0;C.damageWatch=nil;C.punch=nil;C.equipAttempts=0;C.equipmentWait=nil;S.questStage="OFF"
        S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil;C.potion=nil;C.potionLock=nil;C.potionNext=nil
        if clearESP then clearESP() end
        C.parryWatched=setmetatable({},{__mode="k"});C.blockWatchDone=false;C.trainWatchDone=false;C.trainSession=nil;C.sliderSamples={};C.parryUnacked=0
        S.status=reason or "Stopped";log("stop",S.status)
    end
    -- Source-derived catalog; no untrusted decompiled source is executed.
    local npcByCode,npcByName,npcAlias,routeByKey={},{},{},{}
    for _,row in ipairs(CAM_CATALOG.npcs) do
        npcByCode[row.code]=row;npcByName[row.name]=row
        for _,alias in ipairs(row.aliases) do
            if npcAlias[alias]==nil then npcAlias[alias]=row elseif npcAlias[alias]~=row then npcAlias[alias]=false end
        end
    end
    for _,row in ipairs(CAM_CATALOG.quests) do routeByKey[row.key]=row end
    local function vec(a) return Vector3.new(a[1],a[2],a[3]) end
    local function level()
        local goal=at(data(),{"Exp","Goal"})
        return goal and math.floor(goal.Value/CAM_CATALOG.expPerLevel) or nil
    end
    local function isPlayer(m) return m==LP.Character or Players:GetPlayerFromCharacter(m)~=nil end
    local function npcDefinition(m)
        if not m or isPlayer(m) then return nil end
        local code=m:GetAttribute("NpcCode")
        local child=m:FindFirstChild("NpcCode")
        if not code and child and child:IsA("ValueBase") then code=child.Value end
        if code~=nil and tostring(code)~="" then return npcByCode[code] end
        return npcByName[m.Name] or npcAlias[m.Name] or nil
    end
    local function kindOfNPC(m)
        if isPlayer(m) then return "Player" end
        if CS:HasTag(m,"GauntletStatue") or CS:HasTag(m,"Dialogue") or CS:HasTag(m,"HiddenNpc") then return "NPC" end
        local row=npcDefinition(m)
        if row then return row.boss and "Boss" or "Mob" end
        return "NPC" -- Unknown humanoids are NOT presumed hostile.
    end
    local function validTarget(m,kind,code)
        if not live(m) or isPlayer(m) then return false end
        local h=m:FindFirstChildOfClass("Humanoid");local row=npcDefinition(m)
        if not row or not h or h.Health<=0 or not part(m) then return false end
        local k=kindOfNPC(m)
        if k~="Mob" and k~="Boss" then return false end
        return (not kind or kind==k) and (not code or code==row.code)
    end
    local function selectedCode()
        if S.autoLevel then return C.questRoute and C.questRoute.code end
        if S.targetMode=="Nearest hostile" then return nil end
        return S.targetMode=="Selected boss" and S.bossCode or S.mobCode
    end
    local function target()
        local _,_,r=char();if not r then return nil end
        local code=selectedCode()
        if not code and S.targetMode~="Nearest hostile" then S.target=nil;return nil end
        if S.autoLevel and not C.questActive then S.target=nil;return nil end
        local kind=not S.autoLevel and (S.targetMode=="Selected boss" and "Boss" or S.targetMode=="Selected mob" and "Mob" or nil) or nil
        if S.target and validTarget(S.target,kind,code) and (part(S.target).Position-r.Position).Magnitude<=S.searchRange then
            return S.target,(part(S.target).Position-r.Position).Magnitude
        end
        local best,dist=nil,S.searchRange
        for m in pairs(C.humanoids) do
            if validTarget(m,kind,code) then
                local d=(part(m).Position-r.Position).Magnitude
                if d<dist then best=m;dist=d end
            end
        end
        S.target=best;return best,dist
    end
    local function face(m)
        if S.lookMode=="Off" then return end
        local _,_,r=char();local p=part(m)
        if r and p then
            local goal=S.lookMode=="Full 3D" and p.Position or Vector3.new(p.Position.X,r.Position.Y,p.Position.Z)
            if (goal-r.Position).Magnitude>0.1 then r.CFrame=CFrame.lookAt(r.Position,goal) end
        end
    end
    local function farmPoint(m)
        local p=part(m);local cf=p.CFrame;local d=S.farmDistance;local y=S.farmHeight
        local offset
        if S.positionMode=="Above" then offset=Vector3.new(0,y,d)
        elseif S.positionMode=="Below" then offset=Vector3.new(0,-y,d)
        elseif S.positionMode=="Behind" then offset=-cf.LookVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="In front" then offset=cf.LookVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="Left" then offset=-cf.RightVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="Right" then offset=cf.RightVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="Orbit" then local a=os.clock()*S.orbitSpeed;offset=Vector3.new(math.cos(a)*d,y,math.sin(a)*d)
        else local _,_,r=char();local away=r.Position-p.Position;away=Vector3.new(away.X,0,away.Z);offset=(away.Magnitude>0.1 and away.Unit or Vector3.new(0,0,1))*d end
        return p.Position+offset
    end
    local function releaseFarmHold()
        if C.farmVelocity then C.farmVelocity:Destroy();C.farmVelocity=nil end
        if C.farmAttachment then C.farmAttachment:Destroy();C.farmAttachment=nil end
        if C.farmHum then pcall(function() C.farmHum.AutoRotate=C.farmRotate end);C.farmHum=nil end
        C.farmRoot=nil
    end
    endTravel=function()
        C.goal=nil;C.goalTarget=nil;C.moveWatch=nil;C.lastDesired=nil
        releaseFarmHold();stopWalk()
    end
    local function goTo(pos,m)
        C.goal=pos;C.goalTarget=m
    end
    local function farmMove(dt)
        if not C.goal or not (S.autoLevel or S.farm) or S.fly then releaseFarmHold();return end
        local ok=usable();local _,h,r=char()
        if not ok or h.Health/math.max(h.MaxHealth,1)*100<=S.healthStop then endTravel();return end
        if C.goalTarget then
            if not validTarget(C.goalTarget,nil,selectedCode()) then endTravel();return end
            C.goal=farmPoint(C.goalTarget)
        end
        local delta=C.goal-r.Position
        if S.travelMode=="Walk" then
            releaseFarmHold();h:MoveTo(C.goal);C.walking=true
        else
            if C.farmRoot~=r then
                releaseFarmHold();C.farmRoot=r;C.farmHum=h;C.farmRotate=h.AutoRotate;h.AutoRotate=false
                C.farmAttachment=Instance.new("Attachment");C.farmAttachment.Name="CAM_FarmHold";C.farmAttachment.Parent=r
                C.farmVelocity=Instance.new("LinearVelocity");C.farmVelocity.Name="CAM_FarmHold"
                C.farmVelocity.Attachment0=C.farmAttachment;C.farmVelocity.RelativeTo=Enum.ActuatorRelativeTo.World
                C.farmVelocity.MaxForce=100000;C.farmVelocity.VectorVelocity=Vector3.zero;C.farmVelocity.Parent=r
            end
            local step=S.travelMode=="Instant" and delta or delta*(math.min(1,S.travelSpeed*math.min(dt,0.1)/math.max(delta.Magnitude,0.001)))
            local pos=r.Position+step
            r.CFrame=CFrame.new(pos)*r.CFrame.Rotation
            r.AssemblyLinearVelocity=Vector3.zero
        end
        if C.goalTarget then face(C.goalTarget) end
        if delta.Magnitude>12 then
            local now=os.clock()
            if not C.moveWatch then C.moveWatch={time=now,position=r.Position} end
            if now-C.moveWatch.time>=8 then
                if (r.Position-C.moveWatch.position).Magnitude<3 then stopAll("Movement blocked/corrected for 8s; stopped") return end
                C.moveWatch={time=now,position=r.Position}
            end
        else C.moveWatch=nil end
    end
    local toolbarNames={"One","Two","Three","Four","Five"}
    local function ensureEquipment()
        local d=data();local info=C.modules.Info;local items=C.modules.Items;local rules=C.modules.Restrictions;local req=C.modules.Requirements
        local equipped=at(LP,{"Items_Config","Equipped"});local toolbar=at(d,{"Inventory","Toolbar"})
        if not d or not equipped or not toolbar or not info or not items or not rules or not req then return false,"Waiting: equipment data/native modules" end
        local function combatItem(index)
            local slot=toolbar:FindFirstChild(toolbarNames[index] or "")
            if not slot or slot.Value==0 then return nil end
            local item=info.GetItemFromId(LP,slot.Value);local def=item and items[item.Name]
            if not def or not (def.HasCombat or def.CombatPreset or item.Name=="Combat") then return nil end
            local limits=rules.GetCurrentRestrictions(LP,toolbarNames[index])
            if limits.Locked or limits.ActionsDisabled or not req.SatisfiesEquip(d,item.Name) then return nil end
            return item
        end
        local desired
        if S.weapon=="Keep equipped" then desired=equipped.Value
        elseif S.weapon=="Auto combat tool" then
            if combatItem(equipped.Value) then desired=equipped.Value else
                for _,i in ipairs({3,1,2,4,5}) do if combatItem(i) then desired=i;break end end
            end
        else desired=tonumber(S.weapon:match("(%d+)")) end
        local item=desired and combatItem(desired)
        if not item then
            -- working script path: slot empty / weapon lives in Inventory, not on the toolbar -> push it first
            if C.modules.Signal then
                local invRoot=data() and at(data(),{"Inventory","Inventory"})
                if invRoot then
                    for _,it in ipairs(invRoot:GetChildren()) do
                        local def=items[it.Name]
                        if def and (def.HasCombat or def.CombatPreset or it.Name=="Combat") then
                            local id=it:FindFirstChild("Id")
                            local idv=(id and id:IsA("ValueBase")) and id.Value or it:GetAttribute("Id")
                            if idv~=nil then
                                if (C.toolbarEquipAt or 0)>os.clock() then return false,"Pushing weapon to toolbar (Toolbar_Equip)" end
                                C.toolbarEquipAt=os.clock()+1
                                pcall(C.modules.Signal.ToServer,"Toolbar_Equip",it.Name,idv)
                                log("equipment","Toolbar_Equip pushed: "..it.Name)
                                return false,"Pushing weapon to toolbar: "..it.Name
                            end
                        end
                    end
                end
            end
            return false,"No usable combat weapon in selected toolbar slot"
        end
        if equipped.Value~=desired then
            if (C.equipAt or 0)>os.clock() then return false,"Waiting for equipment acknowledgement" end
            C.equipAt=os.clock()+2;C.equipAttempts=(C.equipAttempts or 0)+1
            if C.equipAttempts>3 then stopAll("Equipment rejected 3 times; equip weapon manually") return false,S.status end
            -- working script order: set the slot AND send Item_Equip directly (HUD Changed listener is not relied on)
            equipped.Value=desired
            if C.modules.Signal then pcall(C.modules.Signal.ToServer,"Item_Equip",desired) end
            log("equipment","Selected native toolbar slot "..desired.." / "..item.Name)
            return false,"Preparing weapon: "..item.Name
        end
        local actual=info.Get_equipped_tool(LP)
        if actual and actual.Name==item.Name then C.equipAttempts=0;S.equipment=item.Name;return true end
        if (C.equipAt or 0)>0 and os.clock()-C.equipAt>1.5 then
            log("equipment","equip ack timeout; attacking anyway ("..item.Name..")")
            return true,"Equip ack missing - attacking anyway"
        end
        return false,"Preparing weapon: "..item.Name
    end
    local function baitScan()
        C.baitItems={};local names={}
        local d=data();local inv=d and at(d,{"Inventory","Inventory"})
        if inv then
            for _,item in ipairs(inv:GetChildren()) do
                local id=item:FindFirstChild("Id")
                if id and id:IsA("ValueBase") and item.Name:lower():find("bait",1,true) then
                    local label=item.Name.." #"..tostring(id.Value)
                    names[#names+1]=label;C.baitItems[label]=id.Value
                end
            end
        end
        table.sort(names);return names
    end
    local function equippedBait()
        local d=data();local v=d and at(d,{"Misc","EquippedBaitId"})
        return (v and v:IsA("ValueBase")) and v.Value or 0
    end
    local function baitRequest(id)
        local signal=C.modules.Signal
        if not signal or type(signal.ToServer)~="function" then return false,"Connect native controls first" end
        local ok,err=pcall(signal.ToServer,"EquipBait",id)
        if not ok then return false,short(err) end
        C.baitRequests=(C.baitRequests or 0)+1;C.baitWatch={id=id,deadline=os.clock()+3}
        log("bait","EquipBait "..tostring(id).." requested")
        return true,"Bait request sent; watching Misc/EquippedBaitId"
    end
    local directPotions={["Health Elixir"]=60,["Health Potion"]=25}
    local potionPriority={"Health Elixir","Health Potion","Health Regen Elixir","Health Regen Potion"}
    local function potionSlot()
        local d=data();local info=C.modules.Info;local toolbar=d and at(d,{"Inventory","Toolbar"})
        if not toolbar or not info or type(info.GetItemFromId)~="function" then return nil,"Waiting: inventory data / native modules" end
        local names=S.potionChoice=="Auto (strongest heal)" and potionPriority or {S.potionChoice}
        for _,wanted in ipairs(names) do
            for index=1,5 do
                local slot=toolbar:FindFirstChild(toolbarNames[index])
                if slot and slot.Value~=0 then
                    local item=info.GetItemFromId(LP,slot.Value)
                    if item and item.Name==wanted then return index,wanted end
                end
            end
        end
        return nil,"No selected healing potion on toolbar slots 1-5"
    end
    local function finishPotion(success,observedBy)
        local cycle=C.potion;C.potion=nil
        if not cycle then return end
        if success then
            C.potionAcks=(C.potionAcks or 0)+1;C.potionFailures=0;C.potionLock=os.clock()+1
            log("potion",cycle.name.." acknowledged by "..observedBy)
        else
            C.potionFailures=(C.potionFailures or 0)+1;C.potionNext=os.clock()+S.potionDelay+2;C.potionLock=nil
            if (C.potionFailures or 0)>=3 and S.autoPotion then
                flag("autoPotion",false)
                note("Auto Potion paused: 3 uses without observed healing. Check potion/slot, then re-enable.")
            end
        end
        -- When idle, restore the toolbar slot the player had before the drink.
        -- While farming, ensureEquipment re-equips the weapon itself after the lock expires.
        if not (S.autoLevel or S.farm) and S.alive then
            local eq=at(LP,{"Items_Config","Equipped"})
            if eq and eq.Value==cycle.slot then eq.Value=cycle.previousSlot end
        end
    end
    local function stepPotion(h)
        local cycle=C.potion;if not cycle then return end
        local signal=C.modules.Signal;local info=C.modules.Info;local now=os.clock()
        if cycle.stage=="equip" then
            local tool=info and info.Get_equipped_tool(LP)
            if tool and tool.Name==cycle.name then
                if not signal or type(signal.ToServer)~="function" then log("potion","Signal module unavailable for native click");finishPotion(false);return end
                cycle.before=h.Health
                local d=data();local inv=d and at(d,{"Inventory","Inventory"});local owned=inv and inv:FindFirstChild(cycle.name)
                local amount=owned and owned:FindFirstChild("Amount")
                cycle.amount=amount;cycle.amountBefore=amount and amount.Value
                local _,_,root=char()
                local ok=pcall(signal.ToServer,"Tool_Mouse","Down",root and root.Position)
                if not ok then log("potion","Native click request failed");finishPotion(false);return end
                cycle.stage="release";cycle.at=now+0.15
            elseif now>cycle.deadline then
                log("potion","Potion equip not acknowledged by native toolbar");finishPotion(false)
            end
        elseif cycle.stage=="release" then
            if now>=cycle.at then
                local _,_,root=char()
                pcall(signal.ToServer,"Tool_Mouse","Up",root and root.Position)
                cycle.stage="observe";cycle.deadline=now+4.5
            end
        elseif cycle.stage=="observe" then
            local _,hum=char()
            if hum and hum.Health>cycle.before+1 then finishPotion(true,"HP increase") return end
            if cycle.amount and cycle.amount.Parent and cycle.amountBefore and cycle.amount.Value<cycle.amountBefore then finishPotion(true,"item consumption") return end
            if now>cycle.deadline then log("potion","No healing / consumption observed after native click");finishPotion(false) end
        end
    end
    local function usePotion(h)
        -- Exactly the native toolbar flow: set the potion slot (native Toolbar validates + sends
        -- Item_Equip), wait for the equip ack, then Tool_Mouse Down/Up like a player click.
        if C.potion then stepPotion(h) return C.potion~=nil,"Potion in progress" end
        if (C.potionNext or 0)>os.clock() then return false,"Potion recheck cooldown" end
        if C.combatBusy then return false,"Waiting for native combat call before potion" end
        if h.Health>=h.MaxHealth*S.potionHp/100 then return false,"HP above potion threshold" end
        if directPotions[S.potionChoice] and h.MaxHealth-h.Health<15 then return false,"Deficit too small for a direct potion" end
        local slot,name=potionSlot()
        if not slot then
            if not C.potionTip then C.potionTip=true;log("potion","No selected healing potion on toolbar slots 1-5") end
            return false,"Potion: none on toolbar slots 1-5"
        end
        C.potionTip=nil
        local equipped=at(LP,{"Items_Config","Equipped"})
        if not equipped or not C.modules.Info or not C.modules.Signal then return false,"Connect native controls first" end
        C.potionRequests=(C.potionRequests or 0)+1
        C.potionLock=os.clock()+8
        C.potion={stage="equip",slot=slot,name=name,previousSlot=equipped.Value,deadline=os.clock()+2}
        equipped.Value=slot
        log("potion","Toolbar slot "..slot.." / "..name.." at "..math.floor(h.Health).." HP (native equip + click)")
        stepPotion(h)
        return true,"Potion: native equip + click requested"
    end
    local function findPunch()
        local scriptObject=at(LP,{"PlayerScripts","CU","Combat"})
        if C.punchScript==scriptObject and C.punch then return C.punch end
        C.punch=nil;C.punchScript=nil
        local api=getsenv or Env.getsenv
        if type(api)~="function" or not scriptObject or not scriptObject:IsA("LocalScript") then return nil end
        local ok,e=pcall(api,scriptObject)
        if ok and type(e)=="table" and type(e.punch)=="function" then
            C.punch=e.punch;C.punchScript=scriptObject;return C.punch
        end
        return nil
    end
    local function comboTime()
        local t=at(values(),{"ComboTrackerClient","Time"});return t and t.Value or 0
    end
    local function observeCombo()
        local current=comboTime()
        if C.lastComboObserved==nil then C.lastComboObserved=current;return false end
        if current>C.lastComboObserved then
            C.lastComboObserved=current;C.comboAcks=(C.comboAcks or 0)+1;return true
        end
        return false
    end
    local function attackOnce()
        local ok,why=usable();if not ok then return false,why end
        if C.potion or (C.potionLock or 0)>os.clock() then return false,"Potion in progress" end
        local observedCombo=observeCombo()
        local m,d=target();if not m then return false,"No matching loaded hostile NPC" end
        if d>S.hitRange then return false,"Travelling: target outside M1 range" end
        local ready,msg=ensureEquipment()
        if not ready then
            C.equipmentWait=C.equipmentWait or os.clock()
            if os.clock()-C.equipmentWait>15 then stopAll("Equipment unavailable for 15s: "..msg);return false,S.status end
            return false,msg
        end
        C.equipmentWait=nil
        if C.combatBusy then
            if os.clock()-(C.combatStart or os.clock())>10 then stopAll("Native combat call has not returned for 10s");return false,S.status end
            return false,"Native combat running"
        end
        if (C.attackAt or 0)>os.clock() then return false,C.lastCombatResult or "M1 cooldown" end
        face(m);C.attackAt=os.clock()+S.attackDelay
        C.attackRequests=(C.attackRequests or 0)+1
        local h=m:FindFirstChildOfClass("Humanoid")
        if not C.damageWatch or C.damageWatch.target~=m then C.damageWatch={target=m,hp=h.Health,time=os.clock(),combo=comboTime()} end
        local watch=C.damageWatch
        if h.Health<watch.hp then C.damageEvents=(C.damageEvents or 0)+1;watch.time=os.clock();watch.hp=h.Health end
        if os.clock()-watch.time>S.noDamageTimeout then
            stopAll(comboTime()<=watch.combo and "No native combo / damage: input or equipment unavailable" or "No target HP decrease: reduce height/distance or check target immunity")
            return false,S.status
        end
        local punch=S.inputMode~="Native input only" and findPunch() or nil
        if punch then
            C.combatBusy=true;C.combatStart=os.clock();C.inputBackend="Live Combat.punch";local epoch=S.epoch;local before=comboTime()
            task.spawn(function()
                if not S.alive or epoch~=S.epoch then C.combatBusy=false;return end
                local success,result=pcall(punch);C.combatBusy=false
                if not S.alive or epoch~=S.epoch then return end
                if not success then C.punch=nil;C.lastCombatResult="Native punch error: "..short(result);stopAll(C.lastCombatResult);return end
                if type(result)=="number" then C.attackAt=os.clock()+math.max(S.attackDelay,math.min(result,5)) end
                if comboTime()>before then observeCombo();C.lastCombatResult="Native combo observed; server damage not guaranteed"
                else C.lastCombatResult="Native combat blocked/cooling down; waiting" end
            end)
            return true,C.lastCombatResult or "Native combat requested"
        end
        C.inputBackend="InputHandler (unconfirmed until combo changes)"
        local sent,err=press("Combat",0.12)
        return sent,sent and (observedCombo and "Native combo observed; M1 input repeated" or "M1 input sent; waiting for native combo / target HP") or err
    end
    local function safeDefinition(route)
        local q=C.modules.Quests;local def=q and q.Holder and q.Holder[route.key]
        if not def then return nil,"Quest definitions not loaded (Regions)" end
        if def.Category~="Combat" or def.WenCostOnAccept or def.ItemCostOnAccept or def.NextQuest or def.LogCompletion or def.TaskSpecs or def.NoSave or def.Event then return nil,"Route no longer a free repeatable kill quest" end
        if not def.QuestInstance or def.QuestInstance.Name~=route.title then return nil,"Quest definition changed" end
        local tasks=def.QuestInstance:FindFirstChild("Tasks");local list=tasks and tasks:GetChildren() or {}
        if #list~=1 then return nil,"Quest task structure changed" end
        local code=list[1]:FindFirstChild("Code");local max=list[1]:FindFirstChild("Max")
        if not code or code.Value~=route.code or not max or max.Value~=route.count then return nil,"Quest task contract changed" end
        return def
    end
    local function chooseRoute()
        local lv=level();if not lv then return nil,"Waiting for Exp.Goal" end
        local req=C.modules.Requirements;local q=C.modules.Quests
        if not req or not q or not C.modules.Regions then return nil,"Waiting for Quests / Regions / Requirements modules" end
        local selected,reason=nil,"No source-backed route meets native requirements"
        for _,route in ipairs(CAM_CATALOG.quests) do
            if route.level<=lv and (S.questPolicy~="Mobs only" or not npcByCode[route.code].boss) then
                local def,err=safeDefinition(route)
                if def then
                    local npcReq=C.modules.Regions.NpcRequirements and C.modules.Regions.NpcRequirements[route.npc]
                    if (not def.Requirements or req.Passes(data(),def.Requirements)) and (not npcReq or req.Passes(data(),npcReq)) then
                        if not selected or route.level>selected.level then selected=route end
                    end
                else reason=err end
            end
        end
        return selected,reason
    end
    local function activeRoute()
        local holder=at(data(),{"Quests","Holder"});if not holder then return nil,nil end
        for _,instance in ipairs(holder:GetChildren()) do
            local key=instance:FindFirstChild("QuestString");local route=key and routeByKey[key.Value]
            if not route then for _,r in ipairs(CAM_CATALOG.quests) do if r.title==instance.Name then route=r;break end end end
            if route then return route,instance end
        end
        return nil,nil
    end
    local function taskProgress(instance)
        local tasks=instance and instance:FindFirstChild("Tasks");local done,total=0,0
        if tasks then for _,t in ipairs(tasks:GetChildren()) do
            local v=t:FindFirstChild("Value");local max=t:FindFirstChild("Max")
            if v and max then done=done+math.min(v.Value,max.Value);total=total+max.Value end
        end end
        return done,total
    end
    local function questStep()
        local route,active=activeRoute();local now=os.clock()
        if active then
            if not safeDefinition(route) then endTravel();return false,"Active quest does not match safe route contract" end
            if C.questActive~=active then
                C.questActive=active;C.questRoute=route;C.questAttempts=0;C.questSentAt=nil;C.completeWait=nil
                C.questBaseline={exp=(at(data(),{"Exp","Current"}) or {}).Value,goal=(at(data(),{"Exp","Goal"}) or {}).Value}
                log("quest acknowledged",route.key)
            end
            local done,total=taskProgress(active);S.questProgress=done.."/"..total
            S.questName=route.title
            if total==0 then endTravel();return false,"Waiting for replicated quest tasks" end
            if done>=total then
                endTravel();release("Combat");C.completeWait=C.completeWait or now;S.questStage="Await server completion"
                if now-C.completeWait>15 then stopAll("Quest tasks complete but server has not closed quest; no invented turn-in remote") end
                return false,S.status=="Quest tasks complete but server has not closed quest; no invented turn-in remote" and S.status or "Tasks complete; waiting for server completion/reward"
            end
            C.completeWait=nil;S.questStage="Farm";return true
        end
        if C.questActive then
            log("quest removed","Server holder entry disappeared: "..C.questRoute.title.."; reward not independently proven")
            C.questActive=nil;C.questRoute=nil;C.questSentAt=nil;C.questAttempts=0;C.completeWait=nil;C.questReselectAt=now+1
            S.target=nil;endTravel()
        end
        if (C.questReselectAt or 0)>now then return false,"Quest closed; refreshing level" end
        local chosen,why=chooseRoute()
        if not chosen then endTravel();S.questStage="Waiting";return false,why end
        if not C.questRoute or C.questRoute.key~=chosen.key then C.questRoute=chosen;C.questAttempts=0;C.questSentAt=nil end
        route=C.questRoute;S.questName=route.title;S.questProgress="0/"..route.count
        local _,_,r=char();local npcPos=vec(route.npcPosition);local regions=C.modules.Regions
        if regions and type(regions.GetNpcSpawn)=="function" then
            local ok,pos=pcall(regions.GetNpcSpawn,route.npc)
            if ok and typeof(pos)=="CFrame" then npcPos=pos.Position elseif ok and typeof(pos)=="Vector3" then npcPos=pos end
        end
        if (r.Position-npcPos).Magnitude>12 then
            S.questStage="Travel to NPC";goTo(npcPos+Vector3.new(0,3,4));return false,"Lv "..level()..": travelling to "..route.npc
        end
        endTravel()
        if C.questSentAt then
            S.questStage="Await acceptance"
            if now-C.questSentAt<8 then return false,"AddQuest sent; waiting for Data.Quests.Holder" end
            C.questSentAt=nil
            if C.questAttempts>=3 then stopAll("Quest not acknowledged after 3 requests: "..route.key);return false,S.status end
        end
        local q,signal=C.modules.Quests,C.modules.Signal
        if not signal or type(signal.ToServer)~="function" then return false,"Waiting for native Signal module" end
        local allowed,reason=q.CanAddQuest(route.key)
        if allowed~=true then S.questStage="Cooldown / eligibility";return false,"Native CanAddQuest denied: "..tostring(reason).." (cooldown or active category)" end
        if not safeDefinition(route) then return false,"Quest contract changed before acceptance" end
        C.questAttempts=(C.questAttempts or 0)+1;C.questSentAt=now;S.questStage="Await acceptance"
        signal.ToServer("AddQuest",route.key);log("quest request",route.key)
        return false,"Requested "..route.title.."; waiting for server data"
    end
    local function farmStep()
        local m,dist=target()
        if not m then
            release("Combat");C.damageWatch=nil
            local row=npcByCode[selectedCode()]
            if row and (S.farm or S.autoLevel) then
                local pos=vec(row.position);local regions=C.modules.Regions
                if regions and type(regions.GetNpcSpawn)=="function" then
                    local ok,current=pcall(regions.GetNpcSpawn,row.name)
                    if ok and typeof(current)=="Vector3" then pos=current elseif ok and typeof(current)=="CFrame" then pos=current.Position end
                end
                pos=pos+Vector3.new(0,4,0);goTo(pos)
                local _,_,r=char()
                return false,(r.Position-pos).Magnitude>20 and "Travelling to spawn: "..row.name or "Waiting for spawn / streaming: "..row.name
            end
            endTravel();return false,"No source-whitelisted hostile in range"
        end
        if S.farm or S.autoLevel then goTo(farmPoint(m),m) else endTravel() end
        if S.autoLevel or S.farm or S.attack then
            local sent,msg=attackOnce()
            return sent,(S.autoLevel and (S.questProgress.." | ") or "")..msg
        end
        return true,"Target selected"
    end

    local skillActions={"Skills_1st","Skills_2nd","Skills_3rd","Skills_4th","Skills_5th","Skills_6th","Skills_7th","Skills_8th","Skills_9th","Skills_10th"}
    local function skillOnce()
        local m,d=target();if not m or d>S.skillRange then return false,"No selected target in skill range" end
        if C.skillAt and os.clock()-C.skillAt<S.skillDelay then return false,"Skill pacing" end
        for _=1,10 do
            C.skillIndex=C.skillIndex%10+1
            if S.skillSlots[C.skillIndex] then
                C.skillAt=os.clock();return press(skillActions[C.skillIndex],S.skillHold)
            end
        end
        return false,"Select at least one skill input slot"
    end
    local function classify(o)
        if not live(o) then return nil end
        if not (o:IsA("Model") or o:IsA("BasePart")) then return nil end
        if o.Name=="MuzanLairModel" or o.Name=="Muzan" then return "Muzan" end
        if o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") then return kindOfNPC(o) end
        local par=o.Parent
        local chest=workspace:FindFirstChild("Chests")
        local drops=workspace:FindFirstChild("LootDrops")
        if par==chest or o:GetAttribute("ChestGuid")~=nil then return "Chest" end
        if par==drops or CS:HasTag(o,"LootDrop") then return "Loot" end
        if CS:HasTag(o,"SicklesLever") then return "Lever" end
        if o.Name=="Spider Lily" then return "Spider Lily" end
        if o.Name=="MuzanLairModel" or o.Name=="Muzan" then return "Muzan" end
        if o.Name=="Wild Horse" then return "Wild Horse" end
        if par and par.Name=="Regions" and (par.Parent==workspace:FindFirstChild("Map") or par.Parent==workspace:FindFirstChild("Debree")) then return "Zone" end
        if par==workspace:FindFirstChild("Training") then return "Training" end
        return nil
    end
    local actions={}
    -- v2.3.0 Auto Parry (beta). Protocol facts from server values + decompiled 012_Skill_Controller:
    -- block = native Skills_1st hold; server ack = Values/<player>/Blocking node (value 9),
    -- perfect = the same node with Perfect / PerfectNpc children (server-decided, so this is an honest ack).
    actions.watchBlockingValues=function()
        if C.blockWatchDone then return end
        local vf=values();if not (vf and vf.ChildAdded) then return end
        C.blockWatchDone=true
        connect(vf.ChildAdded,function(o)
            if o.Name=="Blocking" then
                C.parryBlocked=C.parryBlocked+1;C.parryUnacked=0
                if not C.parryConfirmed then C.parryConfirmed=true;C.parryPath="input";log("parry","server ack: Blocking value observed") end
                if o.ChildAdded then connect(o.ChildAdded,function(kid)
                    if kid.Name=="Perfect" or kid.Name=="PerfectNpc" then C.parryPerfect=C.parryPerfect+1 end
                end,"Perfect parry watcher") end
            end
        end,"Blocking ack watcher")
    end
    actions.blockTap=function(hold)
        hold=hold or S.parryHold
        if C.parryPath=="signal" then
            local signal=C.modules.Signal
            if not (signal and type(signal.ToServer)=="function") then return false end
            pcall(signal.ToServer,"server_skill_controller_signaler","Blocking","Hold",Vector3.new(0,0,0))
            task.delay(hold,function()
                pcall(signal.ToServer,"server_skill_controller_signaler","Blocking","UnHold",Vector3.new(0,0,0))
            end)
            log("parry","block tap via signal channel")
            return true
        end
        return press("Skills_1st",hold)
    end
    actions.onHostileAnim=function(model,track)
        if not S.autoParry or not S.alive then return end
        if track==nil then return end
        local okP,prio=pcall(function() return track.Priority end)
        local okE,actionVal=pcall(function() return Enum.AnimationPriority.Action.Value end)
        if okP and prio~=nil and prio.Value~=nil and okE and actionVal~=nil and prio.Value<actionVal then return end
        local now=os.clock()
        if now-C.lastParry<S.parryCooldown then return end
        local _,_,r=char();if not r then return end
        local root=model and model:FindFirstChild("HumanoidRootPart")
        if not live(root) then return end
        if (root.Position-r.Position).Magnitude>S.parryRange then return end
        local vel=root.AssemblyLinearVelocity
        if vel and Vector3.new(vel.X,0,vel.Z).Magnitude>3 then return end
        actions.watchBlockingValues()
        C.lastParry=now;C.parryAttempts=C.parryAttempts+1
        local ok=actions.blockTap(S.parryHold)
        if ok then
            C.parryUnacked=C.parryUnacked+1
            if C.parryPath=="input" and C.parryUnacked>=3 and C.parryBlocked==0 then
                C.parryPath="signal";C.parryUnacked=0
                log("parry","input taps without ack; switched to direct signal")
                note("Auto Parry: no server ack from input taps; switched to direct signal")
            elseif C.parryPath=="signal" and C.parryUnacked>=3 and C.parryBlocked==0 then
                flag("autoParry",false)
                log("parry","auto-pause: no ack from input or signal")
                note("Auto Parry: no server ack from either method; paused for safety")
            end
        end
    end
    actions.watchParryModel=function(m)
        if not m or C.parryWatched[m] then return end
        local k=kindOfNPC(m)
        if k~="Mob" and k~="Boss" then return end
        local h=m:FindFirstChildOfClass("Humanoid")
        local a=h and h:FindFirstChildOfClass("Animator")
        if not (a and a.AnimationPlayed) then return end
        C.parryWatched[m]=true
        connect(a.AnimationPlayed,function(t) actions.onHostileAnim(m,t) end,"Auto Parry anim watcher")
    end
    -- v2.3.0 Auto Training (beta). From decompiled 137_Client: client-side success reports
    -- training_signaler "StateChanged" then "Stop", true. Instant mode sends exactly that.
    -- Default mode auto-plays the slider UI instead (clicks only inside the target zone).
    actions.trainingSignal=function(action,boolArg)
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false end
        if boolArg~=nil then pcall(signal.ToServer,"training_signaler",action,boolArg==true)
        else pcall(signal.ToServer,"training_signaler",action) end
        log("training",action..(boolArg~=nil and " | win=true" or ""))
        return true
    end
    actions.autoPlaySlider=function(session)
        local pg=LP:FindFirstChildOfClass("PlayerGui");local misc=pg and pg:FindFirstChild("Misc")
        if not misc then return false,"Misc UI not open" end
        local deadline=os.clock()+6
        local clicked=false
        while os.clock()<deadline and C.trainSession==session and S.autoTraining and S.trainingMode~="Instant (win signal)" do
            local knob;local bestArea=1/0
            for _,o in pairs(misc:GetDescendants()) do
                if o:IsA("GuiObject") and o.Visible and o.AbsoluteSize.X<=40 and o.AbsoluteSize.Y<=40 then
                    local id=tostring(o);local pos=o.AbsolutePosition
                    local prev=C.sliderSamples[id]
                    if prev and (math.abs(prev.X-pos.X)>2 or math.abs(prev.Y-pos.Y)>2) then
                        local area=o.AbsoluteSize.X*o.AbsoluteSize.Y
                        if area<bestArea then bestArea=area;knob=o end
                    end
                    C.sliderSamples[id]={X=pos.X,Y=pos.Y}
                end
            end
            if knob then
                local track=knob.Parent
                if track and track:IsA("GuiObject") then
                    local zone
                    for _,o in pairs(track:GetChildren()) do
                        if o:IsA("GuiObject") and o~=knob and o.Visible then
                            local w=o.AbsoluteSize.X
                            if w>track.AbsoluteSize.X*0.08 and w<track.AbsoluteSize.X*0.6 then zone=o;break end
                        end
                    end
                    local zx
                    if zone then zx=zone.AbsolutePosition.X;zw=zone.AbsoluteSize.X
                    else zx=track.AbsolutePosition.X+track.AbsoluteSize.X*0.33;zw=track.AbsoluteSize.X*0.34 end
                    local kx=knob.AbsolutePosition.X+knob.AbsoluteSize.X/2
                    if kx>=zx and kx<=zx+zw then
                        local cy=track.AbsolutePosition.Y+track.AbsoluteSize.Y/2
                        local okClick=pcall(function()
                            local VIM=game:GetService("VirtualInputManager")
                            VIM:SendMouseButtonEvent(kx,cy,0,true,game,0)
                            VIM:SendMouseButtonEvent(kx,cy,0,false,game,0)
                        end)
                        if okClick then clicked=true;C.trainClicks=C.trainClicks+1 end
                    end
                end
            end
            task.wait(0.05)
        end
        return clicked,clicked and nil or "slider UI not recognized in time"
    end
    actions.startTrainingSession=function(trigger)
        if C.trainSession then return end
        local session=os.clock();C.trainSession=session
        log("training","session start: "..tostring(trigger))
        task.spawn(function()
            if S.trainingMode=="Instant (win signal)" then
                task.wait(S.trainDelay or 0.5)
                if C.trainSession~=session or not S.autoTraining then return end
                actions.trainingSignal("StateChanged")
                task.wait(0.35)
                if C.trainSession~=session or not S.autoTraining then return end
                if actions.trainingSignal("Stop",true) then C.trainWins=C.trainWins+1 end
            else
                local okP,res,why=pcall(autoPlaySlider,session)
                if not okP then log("training","slider error: "..tostring(res));note("Auto Training slider error: "..short(res))
                elseif not res then log("training","slider: "..tostring(why));note("Auto Training slider: "..tostring(why)) end
            end
            task.delay(4,function() if C.trainSession==session then C.trainSession=nil end end)
        end)
    end
    actions.watchTrainingValues=function()
        if C.trainWatchDone then return end
        local vf=values();if not (vf and vf.ChildAdded) then return end
        C.trainWatchDone=true
        connect(vf.ChildAdded,function(o)
            if not S.autoTraining then return end
            if o.Name=="pause_gameplay" or o.Name=="skill_stand_still" or o.Name=="Training" then actions.startTrainingSession(o.Name) end
        end,"Auto Training trigger")
        connect(vf.ChildRemoved,function(o)
            if o.Name=="pause_gameplay" or o.Name=="Training" then C.trainSession=nil end
        end,"Auto Training end")
    end
    -- v2.3.1 Auto Fishing. From decompiled 1_584 (client) + 002_ServerClientPortal:
    -- bites arrive via portal Event:FireClient("FishingRod","Bite",id); success answer = FireServer("FishingRod", id, true).
    -- Cast = native Tool activation of a *Fishing Rod; reward/cast validation stays server-side.
    actions.fishPortal=function()
        return at(RS,{"CAM","Global","ServerClientPortal","Event"})
    end
    actions.watchFishPortal=function()
        if C.fish.portalDone then return end
        local portal=actions.fishPortal()
        if not (portal and portal.OnClientEvent) then return end
        C.fish.portalDone=true
        connect(portal.OnClientEvent,function(name,kind,id)
            if name~="FishingRod" or kind~="Bite" then return end
            C.fish.bites=C.fish.bites+1
            if not S.autoFish or not S.alive then return end
            task.delay(S.fishDelay or 1,function()
                if not S.autoFish or not S.alive then return end
                pcall(function() portal:FireServer("FishingRod",id,true) end)
                C.fish.wins=C.fish.wins+1;C.fish.awaitingBite=false
                log("fishing","bite id "..tostring(id).." answered success")
            end)
        end,"Fishing bite watcher")
    end
    actions.findRod=function()
        local packs={LP.Character,LP:FindFirstChild("Backpack")}
        for _,pack in ipairs(packs) do
            if pack then
                for _,t in ipairs(pack:GetChildren()) do
                    if t:IsA("Tool") and t.Name:find("Fishing Rod",1,true) then return t end
                end
            end
        end
        return nil
    end
    actions.castRod=function()
        local rod=actions.findRod()
        if not rod then return false,"No *Fishing Rod tool found in backpack/character" end
        local _,h=char()
        if rod.Parent~=LP.Character and h and type(h.EquipTool)=="function" then pcall(function() h:EquipTool(rod) end) end
        if type(rod.Activate)=="function" then
            local ok,err=pcall(function() rod:Activate() end)
            if not ok then return false,"Tool activation failed: "..short(err) end
        end
        C.fish.casts=C.fish.casts+1;C.fish.last=os.clock();C.fish.awaitingBite=true
        actions.watchFishPortal()
        log("fishing","cast #"..C.fish.casts)
        return true
    end
    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)    -- v3.1.0 direct farm core, ported from the working script:
    -- workspace.Humanoids.Regions scan -> defending skip (NpcCounter/Blocking) -> getFarmTargetCFrame(stepped) -> raw Combat_Service
    actions.hostileScan=function()
        local h0=workspace:FindFirstChild("Humanoids");local regions=h0 and h0:FindFirstChild("Regions")
        local out={}
        for _,m in ipairs((regions or workspace):GetDescendants()) do
            if type(m)=="table" or type(m)=="userdata" then pcall(function()
                if m:IsA("Model") then
                    local h=m:FindFirstChildOfClass("Humanoid");local r=h and m:FindFirstChild("HumanoidRootPart")
                    if r and h.Health>0 then
                        local isPlayer=false
                        if Players and Players.GetPlayerFromCharacter then local ok,rp=pcall(Players.GetPlayerFromCharacter,Players,m);isPlayer=ok and rp~=nil end
                        if not isPlayer then out[#out+1]={m=m,h=h,r=r} end
                    end
                end
            end) end
        end
        return out
    end
    actions.isFarmDefending=function(m)
        local nc;local okA=pcall(function() nc=m:GetAttribute("NpcCounter") end)
        if okA and (nc==1 or nc==2) then return true end
        local okB,t=pcall(function() return m:FindFirstChild("NpcCounterTriggered") end)
        if okB and t then return true end
        local okC,bl=pcall(function() return m:FindFirstChild("Blocking") end)
        local okD,pb=pcall(function() return m:FindFirstChild("PierceBlock") end)
        return okC and bl~=nil and not (okD and pb~=nil)
    end
    actions.pickFarmTarget=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local filters={}
        for raw in string.gmatch(","..S.farmMobText..",","([^,]+)") do filters[(raw:gsub("^%s+",""):gsub("%s+$","")):lower()]=true end
        local best,bd
        for _,e in ipairs(actions.hostileScan() or {}) do
            local boss=(type(CAM_BOSS_NAMES)=="table" and CAM_BOSS_NAMES[e.m.Name]==true) or false
            if ((S.autoBoss and boss) or (S.autoFarm and not boss)) then
                local nm=tostring(e.m.Name):lower()
                if next(filters)==nil or filters[nm] then
                    local d=(e.r.Position-hrp.Position).Magnitude
                    if d<=S.searchRange and (bd==nil or d<bd) then best,bd=e,d end
                end
            end
        end
        return best
    end
    actions.farmGoalCF=function(tr)
        local st=S.farmStyle;local off
        if st=="Above" then off=CFrame.new(0,S.farmHeight,0)
        elseif st=="Front" then off=CFrame.new(0,0,-S.farmDist)
        elseif st=="Below" then off=CFrame.new(0,-S.farmHeight,0)
        else off=CFrame.new(0,0,S.farmDist) end
        local desired=(tr.CFrame*off).Position
        local up=Vector3.new(0,1,0)
        if st=="Above" or st=="Below" then up=Vector3.new(0,0,-1) end
        return CFrame.lookAt(desired,tr.Position,up)
    end
    actions.farmTick=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then C.farmTarget=nil;pcall(actions.m1Up);return false,"No character" end
        local t=actions.pickFarmTarget()
        C.farmTarget=t
        if not t then pcall(actions.m1Up);return false,"No farm target in range" end
        local eqOk,eqMsg=ensureEquipment()
        if not eqOk then pcall(actions.m1Up);return false,eqMsg end
        if S.farmNoclip then pcall(function()
            for _,part in ipairs(ch:GetDescendants()) do
                if part.IsA and part:IsA("BasePart") and part.CanCollide then part.CanCollide=false end
            end
        end) end
        local defending=actions.isFarmDefending(t.m)
        local inRange=(t.r.Position-hrp.Position).Magnitude<=math.max(S.farmDist+8,10)
        if S.m1Mode=="Fast Attack (Combat_Service)" then
            if not defending then pcall(actions.fastAttackTick) end
            pcall(actions.m1Up)
        else
            if not defending and inRange then pcall(actions.m1Down) else pcall(actions.m1Up) end
        end
        local now=os.clock()
        local dt=math.min(math.max(now-(C.moveT or 0),0),0.2)
        C.moveT=now
        local goal=actions.farmGoalCF(t.r)
        local delta=goal.Position-hrp.Position;local d=delta.Magnitude
        pcall(function() hrp.AssemblyLinearVelocity=Vector3.new();hrp.AssemblyAngularVelocity=Vector3.new() end)
        if d<=1 or S.farmSpeed<=0 then
            hrp.CFrame=goal
        else
            -- small steps every heartbeat keep the server sync'd; no big rubber-band jumps
            local step=math.min(d,math.max(S.farmSpeed*dt,S.farmSpeed*0.016))
            local up=(S.farmStyle=="Above" or S.farmStyle=="Below") and Vector3.new(0,0,-1) or Vector3.new(0,1,0)
            hrp.CFrame=CFrame.lookAt(hrp.Position+delta.Unit*step,goal.Position,up)
        end
        -- stall watchdog: if the server still drags us back (walls/colliders), snap to the goal once per second
        if d>2 then
            if not C.stallPos then C.stallPos=hrp.Position;C.stallAt=now
            elseif (hrp.Position-C.stallPos).Magnitude<0.6 and now-C.stallAt>0.75 then
                hrp.CFrame=goal;C.stallPos=hrp.Position;C.stallAt=now;log("farm","movement stall: snapped to target position")
            elseif (hrp.Position-C.stallPos).Magnitude>=0.6 then C.stallPos=hrp.Position;C.stallAt=now end
        else C.stallPos=nil;C.stallAt=nil end
        return true,"Farming "..tostring(t.m.Name)
    end
    -- v2.5.0 instant kill + instant attack: recipes ported from a WORKING third-party script for THIS game
    -- (uploaded by the user): kill via Health=0 on network-owned mobs; attack via raw FireServer Combat_Service
    -- with preset-computed hit delay, combo cycling and combo-duration reset - the game's own client protocol.
    actions.instaKillTick=function()
        local hum=workspace:FindFirstChild("Humanoids");local regions=hum and hum:FindFirstChild("Regions")
        if not regions then return false,"workspace.Humanoids.Regions not found" end
        local chk=rawget(_G,"isnetworkowner")
        if type(chk)~="function" and type(getfenv)=="function" then local ok,f=pcall(getfenv,2);if ok then chk=rawget(f,"isnetworkowner") end end
        if type(chk)~="function" then return false,"isnetworkowner() API missing (executor)" end
        local killed=0
        for _,m in ipairs(regions:GetDescendants()) do
            if type(m)=="table" or type(m)=="userdata" then pcall(function()
                if m:IsA("Model") then
                    local h=m:FindFirstChildOfClass("Humanoid");local rp=h and m:FindFirstChild("HumanoidRootPart")
                    if rp and h.Health>0 and h.MaxHealth>0 and (h.Health/h.MaxHealth*100)<=S.instaKillPct then
                        if not rp.Anchored then
                            local ok,own=pcall(chk,rp)
                            if ok and own==true then
                                h.Health=0;pcall(function() h:ChangeState(Enum.HumanoidStateType.Dead) end);killed=killed+1
                            end
                        end
                    end
                end
            end) end
        end
        return killed
    end
    actions.curPower=function()
        local v=at(RS,{"CAM","Client","Controllers","Skills_Provider","CurPower"})
        return v and v.Value or ""
    end
    actions.m1Down=function()
        if C.m1Held then return true end
        C.m1Held=os.clock()
        local ok=pcall(function()
            local sig=C.modules.Signal;local _,_,root=char()
            if type(sig)=="table" and root then
                -- the game's own click channel (working script: Tool_Mouse Down/Up with the root position)
                sig.ToServer("Tool_Mouse","Down",root.Position)
            elseif type(mouse1press)=="function" then mouse1press()
            else
                local okV,vim=pcall(function() return game:GetService("VirtualInputManager") end)
                if not okV or not vim then error("VirtualInputManager unavailable") end
                vim:SendMouseButtonEvent(0,0,0,true,game,0)
            end
        end)
        if not ok then C.m1Held=nil end
        return ok
    end
    actions.m1Up=function()
        if not C.m1Held then return true end
        C.m1Held=nil
        local ok=pcall(function()
            local sig=C.modules.Signal;local _,_,root=char()
            if type(sig)=="table" and root then
                sig.ToServer("Tool_Mouse","Up",root.Position)
            elseif type(mouse1release)=="function" then mouse1release()
            else
                local okV,vim=pcall(function() return game:GetService("VirtualInputManager") end)
                if okV and vim then vim:SendMouseButtonEvent(0,0,0,false,game,0) end
            end
        end)
        return ok
    end
    actions.fastAttackTick=function()
        local sig=C.modules.Signal;local cp=C.modules.CombatPresets;local ci=C.modules.Info;local items=C.modules.Items
        if type(sig)~="table" or type(cp)~="table" or type(cp.Presets)~="table" then return false,"Native modules not loaded" end
        local combatName;local tool=type(ci)=="table" and type(ci.Get_equipped_tool)=="function" and ci.Get_equipped_tool(LP) or nil
        local eq=tool and type(items)=="table" and items[tool.Name] or nil
        if eq and eq.CombatPreset and eq.CombatPreset~="Combat" then combatName=tool.Name
        else
            for powerName in string.gmatch(actions.curPower() or "","([^,]+)") do
                local pn=powerName:gsub("^%s+",""):gsub("%s+$","")
                if at(RS,{"Assets","Animations",pn.."_Combat_Anims"}) then combatName=pn;break end
            end
        end
        combatName=combatName or "Combat"
        local overrideName;local preset=cp.Presets[combatName]
        if not preset and combatName~="Combat" and type(items)=="table" and items[combatName] then
            local it=items[combatName]
            if it.Breathing~=nil or it.HasCombat or it.CombatPreset~=nil then
                overrideName=combatName;combatName=it.CombatPreset or "Regular Katana";preset=cp.Presets[combatName]
            end
        end
        if not preset then combatName="Combat";overrideName=nil;preset=cp.Presets.Combat end
        if type(preset)~="table" then return false,"No preset for "..tostring(combatName) end
        local okspd,aspd=pcall(type(cp.attackSpeedMult)=="function" and cp.attackSpeedMult or function() return 1 end,LP)
        if not okspd or type(aspd)~="number" or aspd<=0 then aspd=1 end
        if os.clock()-(C.fatk.last or 0)>(cp.combo_duration or 1)/aspd then C.fatk.combo=1 end
        local combo=C.fatk.combo
        local function pick(field,fallback)
            local t=preset[field];local v=type(t)=="table" and t[combo] or nil
            return v or fallback
        end
        local swingDelay=pick("delay_before_swing",preset.default_before_swing or cp.Default_Swing_Wait or 0)
        local hitDelay=pick("delay_before_hit",preset.default_before_hit or swingDelay)
        local serverHitDelay=math.max((hitDelay-swingDelay)/aspd,0)
        local interval=pick("customDelay",preset.default or 0.25)
        local maxc=preset.Max or 5
        if combo==maxc and type(preset.final)=="number" then interval=math.max(interval,preset.final) end
        interval=math.max(interval/aspd,0.12)
        if os.clock()<(C.fatk.next or 0) then return true end
        C.fatk.next=os.clock()+interval*0.92
        pcall(function()
            local anims=at(RS,{"Assets","Animations"})
            local folder=(overrideName and anims and anims:FindFirstChild(overrideName.."_Combat_Anims"))
                or (anims and anims:FindFirstChild((combatName or "Combat").."_Combat_Anims"))
                or (anims and anims:FindFirstChild("Combat_Combat_Anims"))
            local anim=folder and folder:FindFirstChild("Swing_"..combo)
            local _,hum=char();local animator=hum and hum:FindFirstChildOfClass("Animator")
            if anim and animator then
                local track=animator:LoadAnimation(anim)
                track:Play()
                if type(preset.AnimSpeed)=="table" then track:AdjustSpeed((preset.AnimSpeed[combo] or preset.AnimSpeed.Default or 1)*aspd) end
            end
        end)
        pcall(sig.ToServer,"Combat_Service",combatName,combo,false,serverHitDelay,false,overrideName)
        C.fatk.combo=(combo>=maxc) and 1 or (combo+1)
        C.fatk.last=os.clock()
        return true
    end
    -- v2.4.0 combat assist (client-side, honest scope):
    -- stamina drain + regen live client-side (007_Skills_Module, 014_StaminaComponent); stamina server check exists ONLY in BreathingBoost/Hundred-Legged.
    -- skill cooldowns managed client-side via PlayerProfile.skill_info[name].lastUsed (004_manage_cd); dash server (296) runs no cooldown/stamina gate.
    actions.infStaminaTick=function()
        local v=values();local st=v and v:FindFirstChild("Stamina")
        if st and type(st.Value)=="number" then
            local mx=st.MaxValue or ((st.MaxValue==nil) and 100)
            if st.Value<mx then st.Value=mx end
        end
    end
    -- v2.4.1 rapid M1: swing pacing (Presets.Normal.default=.26 etc) + combo stamps live in the global client module Combat_presets
    -- (core 003; gates read Last_Punched/Last_Combo from the SAME table - core 002 Checker line 215).
    actions.fastM1Apply=function()
        local cp=C.modules.CombatPresets
        if type(cp)~="table" then return false,"Native Combat_presets not loaded" end
        C.fastM1.saved=C.fastM1.saved or {}
        if type(cp.Presets)=="table" then
            for name,t in pairs(cp.Presets) do
                if type(t)=="table" then
                    C.fastM1.saved[name]={default=t.default,before_hit=t.default_before_hit,before_swing=t.default_before_swing}
                    if type(t.default)=="number" then t.default=0.05 end
                    if type(t.default_before_hit)=="number" then t.default_before_hit=0 end
                    if type(t.default_before_swing)=="number" then t.default_before_swing=0 end
                end
            end
        end
        return true
    end
    actions.fastM1Restore=function()
        local cp=C.modules.CombatPresets
        if type(cp)~="table" or type(C.fastM1.saved)~="table" then return end
        for name,t in pairs(C.fastM1.saved) do
            local cur=cp.Presets and cp.Presets[name]
            if type(cur)=="table" then
                if t.default~=nil then cur.default=t.default end
                if t.before_hit~=nil then cur.default_before_hit=t.before_hit end
                if t.before_swing~=nil then cur.default_before_swing=t.before_swing end
            end
        end
        C.fastM1.saved={}
    end
    actions.wipeCooldowns=function()
        local pp=C.modules.PlayerProfile
        if type(pp)~="table" or type(pp.skill_info)~="table" then return false,"Native PlayerProfile module not loaded" end
        for _,info in pairs(pp.skill_info) do
            if type(info)=="table" and type(info.lastUsed)=="number" and info.lastUsed>-9000 then info.lastUsed=-9999 end
        end
        local ch=LP.Character;local shc=ch and (ch:FindFirstChild("SHC") or ch:FindFirstChild("SHCS"))
        local mcd=C.modules.ManageCD
        if shc and type(mcd)=="table" and type(mcd.filter_cd_name)=="function" then
            for _,skill in ipairs({"Dash","Double Jump"}) do
                local ok,cdName=pcall(mcd.filter_cd_name,LP,skill)
                local cd=ok and type(cdName)=="string" and shc:FindFirstChild(cdName) or nil
                if cd then local par=cd.Parent;pcall(function() cd:Destroy() end);pcall(function()
                    if par and type(par.children)=="table" then for i,x in ipairs(par.children) do if x==cd then table.remove(par.children,i) break end end end
                end) end
            end
        end
        return true
    end
    -- v2.5.0 wave: kill aura (reuses the native punch pipeline), client-side debuff purge (Stun/CombatStun/Strict_Stun values gate ONLY via client Checker line 175-178), infinite jump, world visuals, fps cap, auto skills / auto breathing via the exact signaler protocol (010_Skill_Controller: Hold+Cancel with Platform_Handler.mousepos).
    actions.killAuraTick=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return false,"No character" end
        if os.clock()-(C.auraScanT or 0)>0.75 then
            C.auraScanT=os.clock();C.auraCache={}
            for _,m in ipairs(workspace:GetDescendants()) do
                local mt=type(m)
                if mt=="userdata" or mt=="table" then pcall(function()
                    local h=m:FindFirstChildOfClass("Humanoid");local r=h and m:FindFirstChild("HumanoidRootPart")
                    local isPlayer=false
                    if Players and Players.GetPlayerFromCharacter then local ok,rp=pcall(Players.GetPlayerFromCharacter,Players,m);isPlayer=ok and rp~=nil end
                    if r and h.Health and h.Health>0 and not isPlayer then
                        C.auraCache[#C.auraCache+1]={n=m,r=r,h=h}
                    end
                end) end
            end
        end
        local best,bd
        for _,e in ipairs(C.auraCache or {}) do
            local r,h=e.r,e.h
            if r.Parent and h.Health>0 then
                local d=(r.Position-hrp.Position).Magnitude
                if d<=S.killAuraRange+(type(S.hitRange)=="number" and S.hitRange or 7) and (bd==nil or d<bd) then best,bd=e,d end
            end
        end
        if not best then return false,"No mob in aura range" end
        local punch=(S.inputMode~="Native input only") and findPunch() or nil
        if punch then local ok,err=pcall(punch);if not ok then C.punch=nil;return false,"aura punch err: "..short(err) end
        else press("Combat",0.12) end
        return true,"Aura hit "..tostring(best.n.Name).." @"..math.floor(bd)
    end
    actions.purgeDebuffs=function()
        local purged=0
        local v=values();local ch=LP.Character
        for _,holder in ipairs({v,ch}) do
            if holder then
                for _,n in ipairs({"Stun","CombatStun","Strict_Stun","Ragdoll"}) do
                    local o=holder:FindFirstChild(n)
                    if o then purged=purged+1
                        local p=o.Parent
                        pcall(function() o:Destroy() end)
                        pcall(function()
                            if p and type(p.children)=="table" then for i,x in ipairs(p.children) do if x==o then table.remove(p.children,i) break end end end
                            o.Parent=nil
                        end)
                    end
                end
            end
        end
        return purged
    end
    actions.setLight=function(on)
        local L;pcall(function() L=game:GetService("Lighting") end)
        if type(L)~="table" and type(L)~="userdata" then return end
        if on then
            if not C.lightSaved then C.lightSaved={}for _,f in ipairs({"Brightness","Ambient","OutdoorAmbient","ClockTime","GlobalShadows","FogEnd","FogStart"})do C.lightSaved[f]=pcall(function()return L[f]end)end end
            if S.fullbright then pcall(function()L.Brightness=2;L.Ambient=Color3.fromRGB(178,178,178);L.OutdoorAmbient=Color3.fromRGB(178,178,178);L.ClockTime=12 end) end
            if S.noFog then pcall(function()L.FogEnd=100000;L.GlobalShadows=false end) end
        elseif C.lightSaved then for f,val in pairs(C.lightSaved) do pcall(function()L[f]=val end) end;C.lightSaved=nil end
    end
    actions.autoSkillTick=function()
        if not C.modules.Signal then return false,"Native SignalEvent module not loaded" end
        local now=os.clock()
        if S.autoBreath and now-(C.breathAt or 0)>2.5 then
            C.breathAt=now
            local st=values() and values():FindFirstChild("Stamina")
            if st and st.Value and st.Value>(tonumber(st.MaxValue) or 100)*0.25 then
                pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler","Breathing Boost","Hold",Vector3.new())
                task.delay(0.6,function() pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler","Breathing Boost","Cancel",Vector3.new()) end)
            end
        end
        if S.autoSkills and now-(C.skillCycleAt or 0)>1.4 then
            C.skillCycleAt=now
            for raw in string.gmatch(S.autoSkillText,"([^,]+)") do
                local name=raw:gsub("^%s+",""):gsub("%s+$","")
                if name~="" and name~="Breathing Boost" then
                    local ok,cerr=pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler",name,"Hold",Vector3.new())
                    if not ok then return false,"skill signaler error: "..short(cerr) end
                    task.delay(1.0,function() pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler",name,"Cancel",Vector3.new()) end)
                end
            end
        end
        return true
    end
    -- v2.3.2 skill tree spend (protocol captured live by probe 1.1 on 2026-09-26).
    -- Manual single clicks only: spending real currency never runs in a loop here.
    actions.treeRank=function(name)
        local d=data();if not d then return nil,nil end
        local points=d:FindFirstChild("SkillPoints")
        local rank=d:FindFirstChild("SkillTreeUnlockedList")
        if rank then rank=rank:FindFirstChild(name) end
        return (points and points.Value), (rank and type(rank.Value)=="number" and rank.Value or 0)
    end
    actions.unlockTreeNode=function()
        local name=S.treeNode
        if not name or name=="" then return false,"Type the exact node name first (e.g. Max Health)" end
        local sf=C.modules.SignalF
        if not (sf and type(sf.ToServer)=="function") then return false,"Connect native controls first" end
        local beforePoints,beforeRank=actions.treeRank(name)
        local ok,res=pcall(sf.ToServer,"UnlockSkillTreeNode",name)
        log("tree","UnlockSkillTreeNode "..name.." | sent="..tostring(ok).." | ret="..short(res))
        if not ok then return false,"Rejected: "..short(res) end
        if res==false then return false,"Server refused (no points / previous node missing / maxed)" end
        task.delay(0.4,function()
            local points,rank=actions.treeRank(name)
            if points and beforePoints and points<beforePoints then
                note("Skill tree: accepted. Points "..beforePoints.." -> "..points..(rank and rank~=beforeRank and (", rank "..tostring(beforeRank).." -> "..tostring(rank)) or ""))
            else
                note("Unlock request sent; values unchanged yet (server-side check runs first)")
            end
        end)
        return true,"UnlockSkillTreeNode sent: "..name
    end
    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)
    actions.buyShop=function(withOre)
        if S.buyName=="" then return false,"Type the exact shop item name first" end
        local sf=C.modules.SignalF
        if not (sf and type(sf.ToServer)=="function") then return false,"Connect native controls first" end
        local amount=math.max(1,math.floor(S.buyAmount or 1))
        local ok,res
        if withOre then ok,res=pcall(sf.ToServer,"PurchaseFromShopWithOre",S.buyName)
        else ok,res=pcall(sf.ToServer,"PurchaseFromShop",S.buyName,amount) end
        log("shop",(withOre and "WithOre " or "")..S.buyName.." x"..tostring(withOre and 1 or amount).." | sent="..tostring(ok).." | "..short(res))
        if ok then return true,"Purchase request sent (server confirmation not observable client-side)" end
        return false,"Rejected: "..short(res)
    end
    actions.startMuzanQuest=function()
        local q=C.modules.Quests;local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        if q and type(q.GetPlayerQuestState)=="function" then
            local okQ,st=pcall(q.GetPlayerQuestState,LP,"Muzan Quest")
            if okQ and st=="Doing" then return false,"Muzan Quest already in progress" end
        end
        signal.ToServer("MuzanLairAssign")
        log("muzan","MuzanLairAssign requested")
        return true,"Muzan quest request sent; you must be standing at the lair"
    end
    actions.rankedRequest=function(action)
        if S.rankedKey=="" then return false,"Type the ranked board/mode key first" end
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer("RankedRequest",{action=action,key=S.rankedKey})
        log("ranked",action.." | "..S.rankedKey)
        return true,action.." request sent"
    end
    actions.loadoutAction=function(n,text)
        if S.loadoutName=="" then return false,"Type the loadout name first" end
        if n==3 then
            local sf=C.modules.SignalF
            if not (sf and type(sf.ToServer)=="function") then return false,"Connect native controls first" end
            if (text or "")=="" then return false,"Type the new rename text first" end
            local ok,res=pcall(sf.ToServer,"HandleLoadoutActions",S.loadoutName,3,text)
            log("loadout",S.loadoutName.." rename -> "..tostring(res))
            if ok then return true,"Rename requested" end
            return false,"Rejected: "..short(res)
        end
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer("HandleLoadoutActions",S.loadoutName,n)
        log("loadout",S.loadoutName.." action "..tostring(n))
        return true,(n==1 and "Save" or "Load").." requested"
    end
    local function add(o)
        if not live(o) then return end
        local owner=o.Parent
        if o:IsA("Humanoid") and owner and owner:IsA("Model") then
            -- Cache ownership before removal: Parent may already be nil when destruction is observed.
            C.humanoids[owner]=o;C.humanoidOwners[o]=owner;C.objects[owner]=kindOfNPC(owner)
            local m=owner;local k=C.objects[m]
            if not C.indexing and not C.seen[m] and S.notifyBoss and k=="Boss" then note("Boss streamed in: "..m.Name) end
            C.seen[m]=true
            actions.watchParryModel(m)
        end
        if o:IsA("ProximityPrompt") then C.prompts[o]=true end
        local k=classify(o)
        if k then
            C.objects[o]=k
            if not C.indexing and not C.seen[o] then
                if S.notifyMuzan and k=="Muzan" then note("Muzan object streamed in") end
                if S.notifyBoss and k=="Boss" then note("Boss streamed in: "..o.Name) end
            end
            C.seen[o]=true
        end
    end
    local function remove(o)
        if not o then return end
        local removedModel
        if o:IsA("Humanoid") then
            local owner=C.humanoidOwners[o] or o.Parent
            C.humanoidOwners[o]=nil
            -- A late callback for an old Humanoid must not erase a newly indexed replacement.
            if owner and C.humanoids[owner]==o then
                C.humanoids[owner]=nil;C.objects[owner]=nil;C.seen[owner]=nil;C.cooldowns[owner]=nil
                removedModel=owner
            end
        elseif o:IsA("Model") then
            local humanoid=C.humanoids[o]
            if humanoid then C.humanoidOwners[humanoid]=nil end
            C.humanoids[o]=nil;removedModel=o
        end
        C.objects[o]=nil;C.prompts[o]=nil;C.seen[o]=nil;C.cooldowns[o]=nil
        if removedModel then
            if S.target==removedModel then S.target=nil;C.damageWatch=nil;release("Combat") end
            if C.goalTarget==removedModel and endTravel then endTravel() end
        end
        if C.activePrompt==o then endPrompt() end
    end
    local function promptKind(p)
        local obj=p.Parent
        while obj and obj~=workspace do
            if obj:GetAttribute("ChestState")=="Locked" then return nil,"Sealed chest: locked" end
            local k=classify(obj)
            if k=="Chest" or k=="Loot" then return k end
            obj=obj.Parent
        end
        return nil
    end
    local function withinPrompt(p)
        if not live(p) or not p.Enabled then return false end
        local _,_,r=char();local pp=part(p.Parent)
        if not r or not pp then return false end
        local d=(pp.Position-r.Position).Magnitude
        if d>p.MaxActivationDistance then return false end
        if p.RequiresLineOfSight then
            local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={LP.Character}
            local hit=workspace:Raycast(r.Position,pp.Position-r.Position,params)
            if hit and hit.Instance~=pp and not hit.Instance:IsDescendantOf(pp.Parent) then return false end
        end
        return true,d
    end
    local function startPrompt(p)
        local ok,why=usable();if not ok then return false,why end
        if C.activePrompt then return false,"A prompt is already active" end
        if not withinPrompt(p) then return false,"Prompt disabled, occluded or too far" end
        local now=os.clock();if (C.cooldowns[p] or 0)>now then return false,"Prompt pacing" end
        C.cooldowns[p]=now+math.max(2,p.HoldDuration+1)
        if S.instant then
            if C.holds[p]==nil then C.holds[p]=p.HoldDuration end
            p.HoldDuration=0
        end
        C.activePrompt=p;local epoch=S.epoch
        p:InputHoldBegin()
        task.delay(math.max(0.08,p.HoldDuration+0.05),function()
            if C.activePrompt==p and S.epoch==epoch then endPrompt() end
        end)
        log("prompt",p:GetFullName());return true,"Native prompt held (not proof of reward)"
    end
    local function nearbyLoot()
        local best,distance=nil,math.huge
        for p in pairs(C.prompts) do
            local k=promptKind(p)
            if (k=="Loot" and S.loot or k=="Chest" and S.chest) and (C.cooldowns[p] or 0)<=os.clock() then
                local ok,d=withinPrompt(p)
                if ok and d<distance then best=p;distance=d end
            end
        end
        if best then release("Combat");return startPrompt(best) end
        return false,"No eligible nearby loot/chest prompt"
    end
    local function huntRows()
        local rows={};local root=RS:FindFirstChild("BossHunts");if not root then return rows end
        local d=data();local race=d and d:FindFirstChild("Race");race=race and race.Value
        for _,o in ipairs(root:GetChildren()) do
            local q=o:GetAttribute("Quest");local side=o:GetAttribute("Side");local expires=o:GetAttribute("ExpiresAt")
            local allowed=(side=="Crow" and (race=="Slayer" or race=="Hybrid")) or (side=="Muzan" and (race=="Demon" or race=="Hybrid"))
            if type(q)=="string" and allowed and (type(expires)~="number" or expires>workspace:GetServerTimeNow()) then rows[o.Name]={obj=o,quest=q,boss=o:GetAttribute("Boss"),expires=expires} end
        end
        return rows
    end
    local function claimHunt()
        local ok,why=usable();if not ok then return false,why end
        local rows=huntRows();local row=rows[S.huntId]
        if not row then return false,"Select a current hunt for your race" end
        if C.huntSent[S.huntId] then return false,"Already requested this hunt; waiting for server state" end
        local q=C.modules.Quests;local signal=C.modules.Signal
        if not q or type(q.CanAddQuest)~="function" or not signal or type(signal.ToServer)~="function" then return false,"Connect native controls first" end
        local allowed,reason=q.CanAddQuest(LP,row.quest)
        if allowed~=true then return false,"Quest denied: "..short(reason) end
        C.huntSent[S.huntId]=true
        signal.ToServer("BossHuntsRequest",{action="Claim",id=S.huntId})
        log("request","BossHuntsRequest Claim "..S.huntId)
        return true,"Hunt request sent; not confirmation of acceptance"
    end
    local function ownership(o)
        local p=part(o);local fn=isnetworkowner or Env.isnetworkowner
        if not p or type(fn)~="function" then return "unknown (API unavailable)" end
        local ok,v=pcall(fn,p);return ok and (v and "local client" or "not local client") or "unavailable"
    end
    local function teleportCF(cf)
        local ok,why=usable();if not ok then note(why) return end
        flag("farm",false);flag("autoLevel",false);endTravel();flag("attack",false);flag("skills",false);flag("fly",false)
        releaseAll();stopWalk();endFly();endPrompt()
        local c,_,r=char();if not c or not r then return end
        r.CFrame=cf;r.AssemblyLinearVelocity=Vector3.zero
        log("teleport","Local position changed; server may correct")
        local epoch=S.epoch
        task.delay(1,function()
            if not S.alive or epoch~=S.epoch then return end
            local _,_,r2=char();if r2 and (r2.Position-cf.Position).Magnitude>25 then note("Movement corrected or destination changed; no retry") end
        end)
    end
    local function teleportObject(o)
        if not live(o) then note("Destination is not currently streamed in") return end
        local p=part(o);if not p then note("Destination has no loaded BasePart") return end
        teleportCF(CFrame.new(p.Position+Vector3.new(0,3,5)))
    end
    local function recommended()
        local m=C.modules.Recommended
        if not m or type(m.Get)~="function" then return nil,"Connect native controls first" end
        local r=m.Get();return r,r and r.Name or "No recommendation (Book of Guidance / eligibility required)"
    end
    -- World-anchored ESP: Highlight + BillboardGui live on the streamed objects.
    -- Scan runs on a slow clock; only tracer line positions update at render rate.
    local gui=Instance.new("ScreenGui");gui.Name="CAM_Main_Overlay";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=40;gui.Parent=LP:WaitForChild("PlayerGui")
    local colors={Player=Color3.fromRGB(90,174,255),Mob=Color3.fromRGB(255,120,90),Boss=Color3.fromRGB(255,80,110),NPC=Color3.fromRGB(200,180,255),Chest=Color3.fromRGB(255,218,95),Loot=Color3.fromRGB(95,240,160),Muzan=Color3.fromRGB(230,70,220),["Spider Lily"]=Color3.fromRGB(255,120,200),Lever=Color3.fromRGB(90,220,220),["Wild Horse"]=Color3.fromRGB(220,190,140)}
    local espFlags={Player="players",Mob="mobs",Boss="bosses",NPC="npcs",Chest="chests",Loot="drops",Muzan="muzan",["Spider Lily"]="lily",Lever="levers",["Wild Horse"]="horses"}
    local function make(class,props,parent)
        local o=Instance.new(class);for k,v in pairs(props or {}) do o[k]=v end;o.Parent=parent;return o
    end
    local function line(frame,a,b)
        local dx,dy=b.X-a.X,b.Y-a.Y
        frame.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
        frame.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy),1)
        frame.Rotation=math.deg(math.atan2(dy,dx));frame.Visible=true
    end
    local function clearVisual(v)
        if v.hl then v.hl:Destroy() end
        if v.bb then v.bb:Destroy() end
        if v.tracer then v.tracer:Destroy() end
    end
    clearESP=function() for o,v in pairs(C.esp) do clearVisual(v);C.esp[o]=nil end end
    local function visual(o,k)
        local color=colors[k] or Color3.fromRGB(130,240,220)
        local v={color=color}
        v.hl=make("Highlight",{Name="CAM_ESP",FillColor=color,OutlineColor=color,FillTransparency=0.8,OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop},o)
        local anchor=o:IsA("BasePart") and o or (o:FindFirstChild("HumanoidRootPart") or part(o))
        if anchor then
            v.bb=make("BillboardGui",{Name="CAM_ESP",Size=UDim2.fromOffset(180,44),StudsOffsetWorldSpace=Vector3.new(0,3,0),AlwaysOnTop=true},anchor)
            v.label=make("TextLabel",{Size=UDim2.fromScale(1,0.62),BackgroundTransparency=1,TextColor3=color,TextStrokeTransparency=0.3,TextSize=12,Font=Enum.Font.GothamBold,Text=""},v.bb)
            v.bar=make("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.fromScale(0.5,0.74),Size=UDim2.new(0.8,0,0.14,0),BackgroundColor3=Color3.fromRGB(25,26,32),BorderSizePixel=0,Visible=false},v.bb)
            v.hp=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(85,225,125),BorderSizePixel=0},v.bar)
        end
        C.esp[o]=v;return v
    end
    local function refreshText(v,o,d)
        if not v.bb then return end
        local h=o:IsA("Model") and o:FindFirstChildOfClass("Humanoid")
        v.label.Text=S.names and (o.Name..(h and ("  "..math.floor(h.Health).."/"..math.floor(h.MaxHealth)) or "").."\n"..math.floor(d).." st") or ""
        v.bar.Visible=S.hpbar and h~=nil
        if h then v.hp.Size=UDim2.fromScale(math.max(0,math.min(1,h.Health/math.max(h.MaxHealth,1))),1) end
    end
    local function renderESP()
        if not S.esp then if next(C.esp) then clearESP() end return end
        local _,_,r=char();if not r then return end
        local candidates={}
        for o,k in pairs(C.objects) do
            if live(o) and o~=LP.Character then
                if (k=="Mob" or k=="Boss" or k=="NPC" or k=="Player") and o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") then k=kindOfNPC(o) end
                if espFlags[k] and S[espFlags[k]] then
                    local p=part(o)
                    if p then local d=(p.Position-r.Position).Magnitude;if d<=S.espRange then candidates[#candidates+1]={o=o,k=k,d=d,p=p} end end
                end
            end
        end
        table.sort(candidates,function(a,b) return a.d<b.d end)
        local kept={}
        for i=1,math.min(#candidates,S.espLimit) do
            local item=candidates[i];local o=item.o
            local v=C.esp[o] or visual(o,item.k);kept[o]=true
            refreshText(v,o,item.d)
        end
        for o,v in pairs(C.esp) do if not kept[o] then clearVisual(v);C.esp[o]=nil end end
    end
    local function tracerStep()
        if not (S.esp and S.tracer) then
            for _,v in pairs(C.esp) do if v.tracer then v.tracer.Visible=false end end
            return
        end
        local camera=workspace.CurrentCamera;local vp=camera and camera.ViewportSize
        if not vp then return end
        for o,v in pairs(C.esp) do
            local p=live(o) and part(o)
            local s=p and camera:WorldToViewportPoint(p.Position)
            if p and s.Z>0 and s.X>=0 and s.Y>=0 and s.X<=vp.X and s.Y<=vp.Y then
                if not v.tracer then v.tracer=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=v.color,BorderSizePixel=0},gui) end
                line(v.tracer,Vector2.new(vp.X/2,vp.Y),Vector2.new(s.X,s.Y))
            elseif v.tracer then v.tracer.Visible=false end
        end
    end
    local function moveStep()
        local c,h,r=char()
        if not h or not r or h.Health<=0 then
            if C.flyHum then endFly() end
            return
        end
        local autoClip=S.farmNoclip and C.goal~=nil and (S.autoLevel or S.farm) and S.travelMode~="Walk" and not S.fly
        if S.noclip or autoClip then
            for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then if C.collision[p]==nil then C.collision[p]=p.CanCollide end;p.CanCollide=false end end
        elseif next(C.collision) then
            for p,v in pairs(C.collision) do if p.Parent then p.CanCollide=v end;C.collision[p]=nil end
        end
        if S.speed then
            if C.speedHum~=h then if C.speedHum then pcall(function() C.speedHum.WalkSpeed=C.oldSpeed end) end;C.speedHum=h;C.oldSpeed=h.WalkSpeed end
            h.WalkSpeed=S.walkSpeed
        elseif C.speedHum then C.speedHum.WalkSpeed=C.oldSpeed;C.speedHum=nil end
        if S.jump then
            if C.jumpHum~=h then C.jumpHum=h;C.oldJumpPower=h.JumpPower;C.oldJumpHeight=h.JumpHeight end
            if h.UseJumpPower then h.JumpPower=math.sqrt(2*workspace.Gravity*S.jumpHeight) else h.JumpHeight=S.jumpHeight end
        elseif C.jumpHum then C.jumpHum.JumpPower=C.oldJumpPower;C.jumpHum.JumpHeight=C.oldJumpHeight;C.jumpHum=nil end
        if S.shift then
            local m=C.modules.Run
            if m and type(m.SetShiftLock)=="function" then if C.oldShift==nil then C.oldShift=m.Shift_lock end;m.SetShiftLock(0) end
        elseif C.oldShift~=nil then restoreShift() end
        if not S.fly then if C.flyHum then endFly() end return end
        if C.flyRoot~=r then
            endFly();C.flyHum=h;C.flyRoot=r;C.flyStand=h.PlatformStand;C.flyRotate=h.AutoRotate
            C.flyAttach=make("Attachment",{Name="CAM_Fly_Attachment"},r)
            C.flyVelocity=make("LinearVelocity",{Attachment0=C.flyAttach,RelativeTo=Enum.ActuatorRelativeTo.World,MaxForce=100000,VectorVelocity=Vector3.zero},r)
            C.flyAlign=make("AlignOrientation",{Attachment0=C.flyAttach,Mode=Enum.OrientationAlignmentMode.OneAttachment,MaxTorque=100000,Responsiveness=18},r)
            h.PlatformStand=true;h.AutoRotate=false
        end
        local camera=workspace.CurrentCamera;if not camera then return end
        local vector=Vector3.zero
        if not focused() and not menuOpen() then
            local cf=camera.CFrame
            if Input.KeyboardEnabled then
                if Input:IsKeyDown(Enum.KeyCode.W) then vector=vector+cf.LookVector end
                if Input:IsKeyDown(Enum.KeyCode.S) then vector=vector-cf.LookVector end
                if Input:IsKeyDown(Enum.KeyCode.D) then vector=vector+cf.RightVector end
                if Input:IsKeyDown(Enum.KeyCode.A) then vector=vector-cf.RightVector end
            else vector=h.MoveDirection end
            if Input:IsKeyDown(Enum.KeyCode.Space) or C.flyUp then vector=vector+Vector3.new(0,1,0) end
            if Input:IsKeyDown(Enum.KeyCode.LeftControl) or C.flyDown then vector=vector-Vector3.new(0,1,0) end
        end
        C.flyVelocity.VectorVelocity=vector.Magnitude>0 and vector.Unit*S.flySpeed or Vector3.zero
        C.flyAlign.CFrame=camera.CFrame.Rotation
    end
    local function scheduler()
        local ok,why=usable()
        if not ok then releaseAll();endPrompt();endTravel();S.status=why;return end
        local _,h=char()
        if h.Health/math.max(h.MaxHealth,1)*100<=S.healthStop then
            if S.autoLevel or S.farm or S.attack or S.skills or S.loot or S.chest or S.autoHunt or S.run or S.fly then stopAll("Low HP: stopped, no automatic restart") end
            return
        end
        if S.fly then releaseAll();endTravel();S.status="Fly has movement priority";return end
        if S.run then if not C.owned.Run then press("Run") end else release("Run") end
        if S.autoPotion then usePotion(h) end
        if C.baitWatch then
            local d=data();local v=d and at(d,{"Misc","EquippedBaitId"})
            local cur=v and v:IsA("ValueBase") and v.Value
            if cur~=nil and cur==C.baitWatch.id then
                C.baitAcks=(C.baitAcks or 0)+1;log("bait","Misc/EquippedBaitId = "..tostring(cur).." acknowledged");C.baitWatch=nil
            elseif os.clock()>C.baitWatch.deadline then
                log("bait","No EquippedBaitId acknowledgement; server may have declined");C.baitWatch=nil
            end
        end
        if C.activePrompt then
            if not withinPrompt(C.activePrompt) then endPrompt() else release("Combat");endTravel();S.status="Holding native prompt";return end
        end
        if S.priority=="Loot first" and (S.loot or S.chest) then local done,msg=nearbyLoot();if done then S.status=msg;endTravel();return end end
        if S.autoLevel then
            local fight,msg=questStep()
            if not fight then release("Combat");S.status=msg;return end
        end
        if S.autoLevel or S.farm or S.attack or S.skills then
            local _,msg=farmStep();S.status=msg
            if not S.alive then return end
            if S.skills then local sent,skillMsg=skillOnce();if sent then S.status=msg.." | "..skillMsg end end
        else release("Combat");endTravel() end
        if (S.loot or S.chest) and not S.target then local _,msg=nearbyLoot();S.status=msg end
        if S.autoHunt and not C.activePrompt and not (S.autoLevel or S.farm or S.attack or S.skills) and (C.huntCheck or 0)<=os.clock() then
            C.huntCheck=os.clock()+5;local _,msg=claimHunt();S.status=msg
        end
    end
    local function snapshot()
        local state={};for k,v in pairs(S) do if type(v)=="number" or type(v)=="string" or type(v)=="boolean" then state[k]=v end end
        local modules={};for k in pairs(modulePaths) do modules[k]=C.modules[k] and "ready" or C.loading[k] or "not connected" end
        local m=S.target
        local loaded={};local _,_,root=char()
        for model in pairs(C.humanoids) do
            if #loaded>=60 then break end
            if live(model) and not isPlayer(model) then
                local p=part(model);local h=model:FindFirstChildOfClass("Humanoid");local def=npcDefinition(model)
                loaded[#loaded+1]={name=model.Name,kind=kindOfNPC(model),code=def and def.code or "unmatched",attributeCode=tostring(model:GetAttribute("NpcCode")),
                    hp=h and h.Health or 0,distance=root and p and (root.Position-p.Position).Magnitude or -1}
            end
        end
        C.snapshotHostiles=loaded
        -- Freeze this snapshot's log; later messages must not rewrite a recorder's runtimeBefore.
        local frozenLog={}
        for _,entry in ipairs(C.logs) do frozenLog[#frozenLog+1]={time=entry.time,kind=entry.kind,text=entry.text} end
        return {format="CAM Main Hub 3.2.4",timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),placeId=game.PlaceId,placeVersion=game.PlaceVersion,
            state=state,modules=modules,log=frozenLog,lastStop=C.lastStop,
            farm={backend=C.inputBackend or "not used",requests=C.attackRequests or 0,comboAcks=C.comboAcks or 0,damageObservations=C.damageEvents or 0,potionRequests=C.potionRequests or 0,potionAcks=C.potionAcks or 0,potionFailures=C.potionFailures or 0,baitRequests=C.baitRequests or 0,baitAcks=C.baitAcks or 0,
                quest=C.questRoute and C.questRoute.key or "none",questRequestAttempts=C.questAttempts or 0,level=level(),
                catalogNpcs=#CAM_CATALOG.npcs,catalogQuests=#CAM_CATALOG.quests,loadedHumanoids=C.snapshotHostiles,combatBusy=C.combatBusy==true},target=m and m:GetFullName() or "none",ownership=ownership(m),
            note="Client actions / requests are not proof of server acceptance. No private credentials or webhook URLs are collected."}
    end
    local function report()
        local d=snapshot();local ok,text=pcall(function() return Http:JSONEncode(d) end)
        if ok then return text end
        return PortableJSON(d,{error=tostring(text)})
    end
    local function manualReport(text)
        if C.reportFrame then C.reportFrame:Destroy() end
        local f=make("Frame",{Size=UDim2.fromScale(0.75,0.7),Position=UDim2.fromScale(0.125,0.15),BackgroundColor3=Color3.fromRGB(20,23,29),ZIndex=300},gui);C.reportFrame=f
        local b=make("TextBox",{Size=UDim2.new(1,-20,1,-60),Position=UDim2.fromOffset(10,10),MultiLine=true,ClearTextOnFocus=false,Text=text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(28,32,38),ZIndex=301},f)
        local select=make("TextButton",{Size=UDim2.fromOffset(180,30),Position=UDim2.new(0,10,1,-40),Text="Select all / Ctrl+C",ZIndex=301},f)
        select.Activated:Connect(function() b:CaptureFocus();b.CursorPosition=#b.Text+1;b.SelectionStart=1 end)
        local close=make("TextButton",{Size=UDim2.fromOffset(80,30),Position=UDim2.new(1,-90,1,-40),Text="Close",ZIndex=301},f)
        close.Activated:Connect(function() f:Destroy();C.reportFrame=nil end)
    end
    local function unload()
        if not S.alive then return end
        S.alive=false
        pcall(function() stopAll("Unloaded") end)
        for _,con in ipairs(C.connections) do pcall(function() con:Disconnect() end) end
        pcall(function() actions.fastM1Restore() end)
        pcall(function() actions.setLight(false) end)
        pcall(function() gui:Destroy() end)
        if Env.CAMMainHub and Env.CAMMainHub.State==S then Env.CAMMainHub=nil end
    end
    local oldUnload=Lumen.Unload
    function Lumen:Unload()
        local ok,err=pcall(unload)
        if not ok then pcall(function() warn("[CAM Main] unload cleanup error: "..tostring(err)) end) end
        return oldUnload(self)
    end
    Env.CAMMainHub={State=S,Stop=function() Lumen:Unload() end,StopAll=function() stopAll("Diagnostics STOP") end,Snapshot=snapshot,Version="3.2.4"}
    Lumen.Folder="cam_main_hub";Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM MAIN | Quest & Farm",Version="3.2.4 / + combat_service default, speed 300",Footer="RightCtrl menu | unload: settings | honest limits",Size=UDim2.fromOffset(900,660),Keybind=Enum.KeyCode.RightControl})
    -- hide the window drop shadow entirely (user request: no shadow behind the menu, ever)
    local winShadow=window.Items and window.Items.Shadow
    local function killShadow()
        if not winShadow then return end
        pcall(function()
            winShadow.Visible=false
            winShadow.BackgroundTransparency=1
            winShadow.Size=UDim2.new(0,0,0,0)
            for _,d in ipairs(winShadow:GetDescendants()) do pcall(function() d.BackgroundTransparency=1;d.ImageTransparency=1 end) end
        end)
    end
    killShadow()
    if winShadow then connect(winShadow:GetPropertyChangedSignal("Visible"),function() if winShadow.Visible then killShadow() end end,"shadow suppression") end
    pcall(function() Lumen:Init() end)
    local function page(name,group) return window:Page({Name=name,Columns=2,Group=group}) end
    local function section(p,name,side) return p:Section({Name=name,Side=side or 1}) end
    local function button(sec,name,fn,confirm)
        return sec:Button({Name=name,Confirm=confirm or false,Callback=function()
            local ok,err=pcall(fn);if not ok then log("button error",err);note("Action failed: "..short(err));stopAll("Action failed") end
        end})
    end
    local function toggle(sec,name,key,fn,visualOnly)
        local ref=sec:Toggle({Name=name,Flag="cam_"..key,Default=false,Callback=function(v)
            if v and not visualOnly and game.PlaceId~=136406881576517 then flag(key,false);note("Unsupported place") return end
            S[key]=v==true;if fn then fn(S[key]) end
        end});C.toggles[key]=ref;return ref
    end
    local function slider(sec,name,key,min,max)
        sec:Slider({Name=name,Flag="cam_"..key,Min=min,Max=max,Default=S[key],Decimals=(max<=10 and 2 or 0),Callback=function(v) S[key]=v end})
    end
    local function tell(ok,msg) note(msg or (ok and "Requested" or "Not available")) end
    local farmPage=page("farm","main")
    local hubSec=section(farmPage,"hub",2)
    button(hubSec,"Connect native controls",function() for k,v in pairs(C.loading) do if v~="loading" then C.loading[k]=nil end end;loadNative() end)
    hubSec:Label("Unload hub: settings tab (button at the bottom) -> menu -> unload ui.")
    hubSec:Label("Every feature toggles off the same way it was toggled on.")
    local farmSec=section(farmPage,"auto farm (direct)")
    toggle(farmSec,"Auto Farm (mob names below / nearest)","autoFarm",function(v) if v then loadNative() else C.farmTarget=nil;actions.m1Up() end end)
    toggle(farmSec,"Auto Boss (source-backed boss names)","autoBoss",function(v) if v then loadNative() else C.farmTarget=nil;actions.m1Up() end end)
    farmSec:Textbox({Name="Mob names, CSV (empty = any)",Placeholder="e.g. Bandit, Demon",Default=S.farmMobText,Flag="cam_farmmob",Callback=function(v) S.farmMobText=v end})
    farmSec:Dropdown({Name="Position",Items={"Behind","Above","Front","Below"},Default=S.farmStyle,Flag="cam_farmstyle",Callback=function(v) S.farmStyle=v end})
    slider(farmSec,"Distance","farmDist",2,14)
    slider(farmSec,"Farm height","farmHeight",0,20)
    slider(farmSec,"Farm speed (studs/s)","farmSpeed",20,300)
    slider(farmSec,"Search range","searchRange",50,2000)
    toggle(farmSec,"Farm noclip","farmNoclip")
    farmSec:Dropdown({Name="Attack mode",Items={"Fast Attack (Combat_Service)","Hold M1 (native)"},Default=S.m1Mode,Flag="cam_m1mode",Callback=function(v) S.m1Mode=v end})
    farmSec:Dropdown({Name="Weapon",Items={"Auto combat tool","Keep equipped","Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},Default=S.weapon,Flag="cam_weapon",Callback=function(v) S.weapon=v end})
    farmSec:Label("Regions scan -> stepped approach; attacks run inside the game's own input path (hold M1) or raw Combat_Service.")
    farmSec:Label("Defending targets (NpcCounter / Blocking) are skipped this pass.")
    local ps=section(farmPage,"auto potion (native toolbar)",2)
    toggle(ps,"Auto Potion - consumes toolbar potion at low HP","autoPotion",function(v) if v then loadNative() else C.potion=nil;C.potionLock=nil end end)
    ps:Dropdown({Name="Potion choice",Items={"Auto (strongest heal)","Health Elixir","Health Potion","Health Regen Elixir","Health Regen Potion"},Default=S.potionChoice,Flag="cam_potion_choice",Callback=function(v) S.potionChoice=v end})
    slider(ps,"Use below HP percent","potionHp",10,80)
    slider(ps,"Potion recheck seconds","potionDelay",3,15)
    ps:Label("Potion must sit on toolbar slot 1-5; drinking consumes the item.")
    ps:Label("HP threshold must stay above the STOP threshold or it never fires.")
    ps:Dropdown({Name="Action priority",Items={"Combat first","Loot first"},Default=S.priority,Flag="cam_priority",Callback=function(v) S.priority=v end})
    local cfSec=section(farmPage,"classic engage (native input path)",2)
    cfSec:Dropdown({Name="Target mode",Items={"Selected mob","Selected boss","Nearest hostile"},Default=S.targetMode,Flag="cam_tmode",Callback=function(v) S.targetMode=v;S.target=nil;endTravel();release("Combat") end})
    local mobNames,bossList,mobMap,bossMap={},{},{},{}
    for _,row in ipairs(CAM_CATALOG.npcs) do
        local list,map=row.boss and bossList or mobNames,row.boss and bossMap or mobMap
        list[#list+1]=row.name;map[row.name]=row.code
    end
    table.sort(mobNames);table.sort(bossList)
    cfSec:Dropdown({Name="Selected mob",Items=mobNames,Default="Bandit",Flag="cam_mobsel",Callback=function(v) S.mobCode=mobMap[v];S.target=nil;endTravel() end})
    cfSec:Dropdown({Name="Selected boss",Items=bossList,Default="Zuko",Flag="cam_bosssel",Callback=function(v) S.bossCode=bossMap[v];S.target=nil;endTravel() end})
    refreshTargets=function()
        local n=0;for m in pairs(C.humanoids) do if validTarget(m) then n=n+1 end end;return n
    end
    button(cfSec,"Count loaded hostile targets",function() note("Loaded source-matched hostiles: "..refreshTargets()) end)
    toggle(cfSec,"Auto Farm - selected / nearest (classic)","farm",function(v)
        endTravel();release("Combat");C.damageWatch=nil
        if v then flag("autoLevel",false);S.questStage="OFF";flag("fly",false);endFly();loadNative() end
    end)
    toggle(cfSec,"Auto M1 (no movement)","attack",function(v) if v then loadNative() elseif not S.farm and not S.autoLevel then release("Combat") end end)
    button(cfSec,"M1 once",function() tell(attackOnce()) end)
    local cfPos=section(farmPage,"classic position / movement")
    cfPos:Dropdown({Name="Farm position",Items={"Above","Below","Behind","In front","Left","Right","Orbit","Ground"},Default=S.positionMode,Flag="cam_posmode",Callback=function(v) S.positionMode=v;endTravel() end})
    cfPos:Dropdown({Name="Travel method",Items={"Tween","Instant","Walk"},Default=S.travelMode,Flag="cam_travel",Callback=function(v) S.travelMode=v;endTravel() end})
    cfPos:Dropdown({Name="Look at target",Items={"Horizontal","Full 3D","Off"},Default=S.lookMode,Flag="cam_lookmode",Callback=function(v) S.lookMode=v end})
    slider(cfPos,"Classic distance","farmDistance",1,15)
    slider(cfPos,"Tween speed (studs/sec)","travelSpeed",10,400)
    slider(cfPos,"Orbit speed","orbitSpeed",0.1,4)
    slider(cfPos,"M1 range","hitRange",3,10)
    slider(cfPos,"M1 interval (seconds)","attackDelay",0.25,3)
    slider(cfPos,"STOP at HP percent","healthStop",5,80)
    slider(cfPos,"STOP after no target damage (seconds)","noDamageTimeout",10,60)
    cfPos:Dropdown({Name="M1 input backend",Items={"Auto (live punch / native input)","Native input only"},Default=S.inputMode,Flag="cam_inputmode",Callback=function(v) S.inputMode=v;release("Combat");C.damageWatch=nil end})
    local autoPage=page("auto level","gameplay")
    local al=section(autoPage,"level-aware quest cycle")
    toggle(al,"Auto Level - accept / farm / repeat","autoLevel",function(v)
        endTravel();release("Combat");S.target=nil;C.questRoute=nil;C.questActive=nil;C.questSentAt=nil;C.questAttempts=0
        if v then flag("farm",false);flag("fly",false);endFly();loadNative();S.status="Loading native modules for Auto Level"
        else S.questStage="OFF";S.status="Auto Level OFF" end
    end)
    al:Dropdown({Name="Quest policy",Items={"Highest eligible","Mobs only"},Default=S.questPolicy,Flag="cam_quest_policy",Callback=function(v) S.questPolicy=v end})
    al:Label("17 repeatable kill routes by level; active quest finishes before switching.")
    al:Label("NPC -> AddQuest -> holder -> kills -> native closure. No fake CompleteQuest.")
    local routeSec=section(autoPage,"source-backed progression",2)
    for _,route in ipairs(CAM_CATALOG.quests) do routeSec:Label("Lv "..math.max(1,route.level).." | "..route.npc.." | "..npcByCode[route.code].name) end
    routeSec:Label("Race-specific routes may be skipped. No paid training.")
    local qpage=page("quests / boss hunts","gameplay")
    local qs=section(qpage,"native recommendations")
    button(qs,"Show recommended quest",function() local r,msg=recommended();note(msg);if r then log("quest",r.Name.." | NPC "..tostring(r.Npc)) end end)
    button(qs,"Teleport to recommended NPC position",function()
        local r,msg=recommended();if not r then note(msg) return end
        if typeof(r.Position)~="Vector3" then note("No native NPC position") return end
        teleportCF(CFrame.new(r.Position+Vector3.new(0,3,0)))
    end,true)
    qs:Label("Recommendation is not acceptance; the loop lives on the Auto Level page.")
    local hs=section(qpage,"boss hunt claim",2)
    huntDrop=hs:Dropdown({Name="Live hunt ID",Items={"Refresh hunts"},Default="Refresh hunts",Flag="cam_hunt",Callback=function(v) S.huntId=v end})
    refreshHunts=function()
        local rows=huntRows();local items={}
        for id,row in pairs(rows) do items[#items+1]=id;log("hunt",id.." | "..row.quest.." | "..tostring(row.boss)) end
        table.sort(items);huntDrop:Refresh(#items>0 and items or {"No eligible live hunts"})
        if rows[S.huntId] then huntDrop:Set(S.huntId,true) else S.huntId="" end
        return #items
    end
    button(hs,"Refresh hunts + write names to log",function() note("Eligible live hunts: "..refreshHunts()..". See diagnostics for names.") end)
    button(hs,"Claim selected hunt once",function() tell(claimHunt()) end,true)
    toggle(hs,"Auto claim selected hunt (once per ID)","autoHunt")
    hs:Label("Claims the selected ID once; race/expiry checked; completion stays server-side.")
    local lootpage=page("loot / interaction","gameplay")
    local ls=section(lootpage,"nearby native prompts")
    toggle(ls,"Auto Loot - prompts only","loot",function(v) if not v and not S.chest then endPrompt() end end)
    toggle(ls,"Auto Chest - unlocked prompts only","chest",function(v) if not v and not S.loot then endPrompt() end end)
    toggle(ls,"Instant ProximityPrompt (local hold duration)","instant",function(v) if not v then restorePrompts() end end)
    button(ls,"Use nearest visible prompt once",function()
        local best,dist=nil,math.huge
        for p in pairs(C.prompts) do local ok,d=withinPrompt(p);if ok and d<dist then best=p;dist=d end end
        if best then tell(startPrompt(best)) else note("No enabled prompt in native range / line of sight") end
    end,true)
    ls:Label("No prompt = no supported automatic interaction; no payload guesses.")
    ls:Label("Locked caches are skipped; no guard instant kill.")
    local inv=section(lootpage,"native toolbar",2)
    for i=1,5 do
        local slot=i
        button(inv,"Equip existing toolbar slot "..i,function()
            local ok,why=usable();if not ok then note(why) return end
            local equipped=at(LP,{"Items_Config","Equipped"})
            if not equipped or not equipped:IsA("IntValue") then note("Native toolbar unavailable") return end
            equipped.Value=slot;note("Native toolbar slot selected: "..slot)
        end)
    end
    inv:Label("Equips existing toolbar slots only; no invented best-gear scoring.")
    local bs=section(lootpage,"fishing bait (native signal)",2)
    local baitDrop=bs:Dropdown({Name="Bait from inventory",Items={"Refresh bait list"},Default="Refresh bait list",Flag="cam_bait",Callback=function(v) S.baitName=v end})
    button(bs,"Refresh bait list",function() local names=baitScan();baitDrop:Refresh(#names>0 and names or {"No bait-named items found"});note("Bait items found: "..#names) end)
    button(bs,"Equip selected bait",function()
        local id=C.baitItems and C.baitItems[S.baitName]
        if not id then note("Refresh the bait list and select an item first") return end
        if equippedBait()==id then note("Already equipped; use Unequip to toggle off") return end
        tell(baitRequest(id))
    end,true)
    button(bs,"Unequip bait",function() if equippedBait()==0 then note("No bait equipped") return end tell(baitRequest(0)) end,true)
    bs:Label("EquipBait native signal; ack via EquippedBaitId. Casting below.")
    local mp=page("movement / teleports","utilities")
    local ms=section(mp,"client movement")
    toggle(ms,"Fly (WASD / Space / LeftCtrl)","fly",function(v) if v then flag("farm",false);flag("autoLevel",false);S.questStage="OFF";endTravel();releaseAll();endPrompt() else endFly() end end)
    slider(ms,"Fly speed","flySpeed",10,120)
    button(ms,"Fly UP pulse (mobile)",function() C.flyUp=true;task.delay(0.5,function() C.flyUp=false end) end)
    button(ms,"Fly DOWN pulse (mobile)",function() C.flyDown=true;task.delay(0.5,function() C.flyDown=false end) end)
    toggle(ms,"Noclip","noclip")
    local farmNoclipRef=toggle(ms,"Noclip while farming/travelling (auto)","farmNoclip")
    farmNoclipRef:Set(S.farmNoclip,true)
    ms:Label("Auto noclip only while travelling to / holding a target (not Walk mode).")
    toggle(ms,"Speed override","speed");slider(ms,"Walk speed","walkSpeed",16,80)
    toggle(ms,"High Jump","jump");slider(ms,"Jump height (studs)","jumpHeight",7,40)
    toggle(ms,"Always Run - hold native Run input","run",function(v) if not v then release("Run") end end)
    toggle(ms,"Disable Shift Lock (native setting)","shift",function(v) if not v then restoreShift() end end)
    ms:Label("Local movement can be corrected by the server.")
    local ts=section(mp,"streamed destinations",2)
    ts:Dropdown({Name="Destination type",Items={"Zone","NPC","Mob","Boss","Muzan","Chest","Loot","Spider Lily","Lever","Wild Horse","Training"},Default="Zone",Flag="cam_dest_type",Callback=function(v) S.destinationType=v;S.destination="";if refreshDestinations then refreshDestinations() end end})
    destinationDrop=ts:Dropdown({Name="Destination path",Items={"Refresh destinations"},Default="Refresh destinations",Flag="cam_dest",Callback=function(v) S.destination=v end})
    refreshDestinations=function()
        C.destinations={};local names={}
        for o,k in pairs(C.objects) do
            if live(o) then
                if (k=="Mob" or k=="Boss" or k=="NPC" or k=="Player") and o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") then k=kindOfNPC(o) end
                if k==S.destinationType and part(o) then
                    local name=o:GetFullName();if not C.destinations[name] and #names<200 then names[#names+1]=name;C.destinations[name]=o end
                end
            end
        end
        table.sort(names);destinationDrop:Refresh(#names>0 and names or {"No loaded destinations"})
        if C.destinations[S.destination] then destinationDrop:Set(S.destination,true) else S.destination="" end
        return #names
    end
    button(ts,"Refresh destinations",function() note("Loaded destinations: "..refreshDestinations()) end)
    button(ts,"Teleport to selected loaded object",function() teleportObject(C.destinations and C.destinations[S.destination]) end,true)
    button(ts,"Teleport to selected farm target",function() teleportObject(target()) end,true)
    button(ts,"Teleport to loaded Muzan",function() for o,k in pairs(C.objects) do if k=="Muzan" and live(o) then teleportObject(o) return end end;note("Muzan is not streamed in") end,true)
    button(ts,"Save current position",function() local _,_,r=char();if r then C.savedPosition=r.CFrame;note("Position saved for this session") end end)
    button(ts,"Return to saved position",function() if C.savedPosition then teleportCF(C.savedPosition) else note("Save a position first") end end,true)
    button(ts,"Ownership of selected target",function() note("Network ownership: "..ownership(target())) end)
    ts:Label("No fabricated coordinates / cross-world teleport.")
    local ep=page("ESP / notifications","visuals")
    local es=section(ep,"categories")
    toggle(es,"Enable ESP (Highlight chams)","esp",function(v) if not v then clearESP() end end,true)
    for _,row in ipairs({{"Player ESP","players"},{"Mob ESP","mobs"},{"Boss ESP","bosses"},{"NPC ESP","npcs"},{"Chest ESP","chests"},{"Loot ESP","drops"},{"Muzan ESP","muzan"},{"Spider Lily ESP","lily"},{"Lever ESP","levers"},{"Wild Horse ESP","horses"}}) do toggle(es,row[1],row[2],nil,true) end
    button(es,"Enable basic mob / boss ESP",function()
        for _,key in ipairs({"esp","mobs","bosses","names","hpbar"}) do flag(key,true) end
    end)
    slider(es,"ESP range","espRange",50,2000);slider(es,"Max objects drawn","espLimit",5,80)
    local ev=section(ep,"styles / notifications",2)
    toggle(ev,"Text: name / HP / distance","names",nil,true)
    toggle(ev,"Health bar","hpbar",nil,true)
    toggle(ev,"Tracers (screen lines)","tracer",nil,true)
    toggle(ev,"Boss streamed-in notification","notifyBoss",nil,true)
    toggle(ev,"Muzan streamed-in notification","notifyMuzan",nil,true)
    toggle(ev,"New eligible Boss Hunt notification","notifyHunts",nil,true)
    ev:Label("World-highlight ESP; streamed objects only (not a server-wide proof).")
    local dp=page("diagnostics / limits","system")
    local liveSec=section(dp,"live status")
    statusLabel=liveSec:Label("Ready; all automation OFF")
    nativeLabel=liveSec:Label("Native controls: not connected")
    targetLabel=liveSec:Label("Target: none")
    resourceLabel=liveSec:Label("HP / stamina: -")
    questLabel=liveSec:Label("Quest: -")
    indexLabel=liveSec:Label("Indexing loaded world...")
    local ds=section(dp,"local report")
    button(ds,"ONE CLICK - save + copy main diagnostics",function()
        local text=report();local name="CAM_Main_"..os.date("!%Y%m%d_%H%M%S")..".json";local saved,copied=false,false
        if type(writefile)=="function" then saved=pcall(writefile,name,text) end
        local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then copied=pcall(fn,text) end
        note((saved and "Saved "..name or "File save unavailable").." | "..(copied and "Clipboard API accepted text" or "Clipboard unavailable"))
        if not saved and not copied then manualReport(text) end
    end)
    button(ds,"COPY diagnostic report",function()
        local text=report();local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then local ok=pcall(fn,text);if ok then note("Report sent to clipboard") return end end
        manualReport(text)
    end)
    button(ds,"Save diagnostic JSON",function()
        if type(writefile)~="function" then manualReport(report());return end
        local name="CAM_Main_"..os.date("!%Y%m%d_%H%M%S")..".json";writefile(name,report());note("Saved: "..name)
    end)
    button(ds,"Show report on screen",function() manualReport(report()) end)
    button(ds,"Clear log",function() C.logs={} end)
    ds:Label("Send this one-click report when a native integration misbehaves.")
    -- v2.3.1 quest advance: honest deliver/collect nudge from decompiled 029/030/031:
    -- only QuestProgress(questKey, taskId) for specs whose RequiredItem is in the live inventory; server validates.
    actions.advanceQuest=function()
        local q=C.modules.Quests;local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        if type(q)~="table" or type(q.Holder)~="table" then return false,"Quest module specs offline" end
        local d=data();local holder=d and at(d,{"Quests","Holder"})
        local inv=d and at(d,{"Inventory","Inventory"})
        if not (holder and inv) then return false,"Quest/inventory data not streamed" end
        local sent=0
        for _,inst in ipairs(holder:GetChildren()) do
            local spec=q.Holder[inst.Name]
            if type(spec)=="table" and type(spec.TaskSpecs)=="table" then
                for tid,ts in pairs(spec.TaskSpecs) do
                    local need=type(ts)=="table" and ts.RequiredItem or nil
                    if need then
                        local entry=inv:FindFirstChild(need)
                        local amount=entry and (entry:FindFirstChild("Amount"))
                        local have=entry and ((amount and amount.Value) or 1) or 0
                        if have>=1 then
                            signal.ToServer("QuestProgress",inst.Name,tid)
                            sent=sent+1;log("quest","QuestProgress "..inst.Name.." | "..tostring(tid))
                        end
                    end
                end
            end
        end
        if sent==0 then return false,"No deliverable/collect quest has its RequiredItem in your inventory" end
        return true,sent.." QuestProgress nudges sent (server validates proximity/items)"
    end
    -- v2.3.1 NPC actions: parameterless interaction remotes from decompiled oneclick/world actions.
    actions.npcAction=function(name,...)
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer(name,...)
        log("npc",name)
        return true,name.." requested (stand near the NPC; server validates)"
    end
    -- v2.3.1 nearest world prompt (queues/levers/portals/join nodes are prompt-driven, no hidden remotes)
    actions.activateNearestPrompt=function()
        local _,_,r=char();if not r then return false,"No character" end
        local best,bd=nil,math.huge
        for p in pairs(C.prompts) do
            if live(p) and p.Enabled then
                local okC,elig=pcall(withinPrompt,p)
                if okC and elig then
                    local pp=part(p.Parent);local d=pp and (pp.Position-r.Position).Magnitude or math.huge
                    if d<bd then best=p;bd=d end
                end
            end
        end
        if not best then return false,"No eligible prompt within range" end
        return startPrompt(best)
    end
    local cpage=page("combat","action")
    local spage=page("skills","action")
    local tr=section(spage,"skill tree (manual spend)",1)
    tr:Textbox({Name="Skill tree node (exact name)",Placeholder="e.g. Max Health",Default=S.treeNode,Callback=function(v) S.treeNode=v end})
    button(tr,"Unlock / level up node (UnlockSkillTreeNode)",function() loadNative();tell(actions.unlockTreeNode()) end,true)
    treeLabel=tr:Label("Skill points: - | node rank: -")
    tr:Label("Clicks only; real spend. Ack: points decrease + rank bump ~0.4s.")
    tr:Label("Protocol: ToServer UnlockSkillTreeNode(name) -> true on accept.")
    local pc=section(cpage,"defense - auto parry (beta)",2)
    toggle(pc,"Auto Parry - block hostile attack anims","autoParry",function(v)
        if v then loadNative();actions.watchBlockingValues();for m in pairs(C.humanoids) do actions.watchParryModel(m) end
        else release("Skills_1st") end
    end)
    slider(pc,"Parry range (studs)", "parryRange",4,30)
    slider(pc,"Block hold (s)","parryHold",0.15,1)
    slider(pc,"Parry cooldown (s)","parryCooldown",0.3,3)
    parryLabel=pc:Label("Parry: idle")
    pc:Label("Trigger: nearby action anims; ack via Values/Blocking (+Perfect).")
    pc:Label("Input first; falls back to direct signal; auto-pauses without ack.")
    local ts=section(cpage,"auto training (beta)",1)
    toggle(ts,"Auto Training - complete minigames","autoTraining",function(v)
        if v then loadNative();actions.watchTrainingValues() end
    end)
    ts:Dropdown({Name="Mode",Items={"Instant (win signal)","Default (auto-play slider)"},Default=S.trainingMode,Callback=function(v) S.trainingMode=v end})
    slider(ts,"Instant: delay before StateChanged (s)","trainDelay",0.1,3)
    trainLabel=ts:Label("Training: idle")
    ts:Label("Instant sends StateChanged + Stop,true exactly like a real win.")
    ts:Label("Clicks slider inside target zone only; skips unknown bars.")
    local sh=section(spage,"shop / loadout (explicit clicks only)",1)
    sh:Textbox({Name="Shop item name (exact)",Placeholder="e.g. Blood Bait",Default=S.buyName,Callback=function(v) S.buyName=v end})
    slider(sh,"Buy amount","buyAmount",1,25)
    button(sh,"Buy item (PurchaseFromShop)",function() loadNative();tell(actions.buyShop(false)) end,true)
    button(sh,"Buy item with ore (WithOre)",function() loadNative();tell(actions.buyShop(true)) end,true)
    sh:Textbox({Name="Loadout name",Placeholder="existing loadout",Default=S.loadoutName,Callback=function(v) S.loadoutName=v end})
    sh:Textbox({Name="Loadout rename text",Placeholder="new name",Default=S.loadoutText,Callback=function(v) S.loadoutText=v end})
    button(sh,"Save loadout (current build)",function() loadNative();tell(actions.loadoutAction(1,nil)) end,true)
    button(sh,"Load loadout",function() loadNative();tell(actions.loadoutAction(2,nil)) end)
    button(sh,"Rename loadout",function() loadNative();tell(actions.loadoutAction(3,S.loadoutText)) end)
    local skn=section(spage,"auto skills / native scheduler",2)
    toggle(skn,"Auto Skills (selected input slots)","skills",function(v) if v then loadNative() else for _,a in ipairs(skillActions) do release(a) end end end)
    for i=1,10 do
        local slot=i;local key="skillSlot"..i
        toggle(skn,"Use skill input slot "..i,key,function(v) S.skillSlots[slot]=v;if not v then release(skillActions[slot]) end end)
    end
    slider(skn,"Skill use interval (seconds)","skillDelay",0.25,5)
    slider(skn,"Skill hold (seconds, 0 = tap)","skillHold",0.01,1)
    slider(skn,"Skill range (studs)","skillRange",10,200)
    skn:Label("Native aim; slot 1 may be block - choose slots deliberately.")
    local rq=section(qpage,"muzan / ranked requests",1)
    button(rq,"Start Muzan Quest (Demon race)",function() loadNative();tell(actions.startMuzanQuest()) end,true)
    rq:Label("Stand at the Muzan lair; starts quest only when not already Doing.")
    rq:Textbox({Name="Ranked key (board/mode)",Placeholder="from ranked UI",Default=S.rankedKey,Callback=function(v) S.rankedKey=v end})
    button(rq,"Ranked: refresh board",function() loadNative();tell(actions.rankedRequest("Board")) end)
    button(rq,"Ranked: claim reward",function() loadNative();tell(actions.rankedRequest("Claim")) end,true)
    sh:Label("Protocols from sources 072/074/075/081. No auto-spend loops.")
    local cb=section(cpage,"combat assist (client-side)",1)
    toggle(cb,"Inf Stamina (client replica)","infStamina")
    cb:Label("Server stamina gates only in Boost/Zigzag; client pool pinned to MaxValue.")
    toggle(cb,"Inf Dash + no skill cooldowns (client)","noCd",function(v)
        if v then loadNative() end
    end)
    cb:Label("lastUsed reset every 0.3s; dash server has no gate (296). Silent caps may apply.")
    toggle(cb,"Rapid M1 pace (client swing unlock)","fastM1",function(v)
        if v then loadNative();local ok,msg=actions.fastM1Apply();if not ok then notify("Rapid M1",msg,4) end
        else actions.fastM1Restore() end
    end)
    cb:Label("Client swing gate unlocked: presets zeroed, stamps reset each frame. Restored on off.")
    toggle(cb,"Kill Aura (nearest mob in range)","killAura")
    cb:Slider({Name="Kill Aura extra range (studs)",Min=2,Max=60,Default=S.killAuraRange,Callback=function(v) S.killAuraRange=v end})
    cb:Label("Punches nearest living mob in range every 0.33s via native punch.")
    toggle(cb,"Instant Kill (network-owned mobs, HP <= threshold)","instaKill")
    cb:Slider({Name="Instant Kill HP threshold %",Min=1,Max=50,Default=S.instaKillPct,Callback=function(v) S.instaKillPct=v end})
    cb:Label("Kills owned mobs below threshold (ownership = the kill replicates).")
    toggle(cb,"Fast Attack (direct Combat_Service)","fastAttack",function(v) if v then loadNative() end end)
    cb:Label("Raw Combat_Service per client protocol (combo 1..Max, preset hit-delay).")
    toggle(cb,"No Stun / No Ragdoll (client values purge)","noDebuffs")
    cb:Label("Purges Stun/CombatStun/Strict_Stun/Ragdoll from client objects every 0.2s.")
    local qs=section(spage,"auto skills / breathing",2)
    toggle(qs,"Infinite Jump (JumpRequest)","infJump")
    toggle(qs,"Fullbright (local lighting)","fullbright",function(v) actions.setLight(v or S.noFog) end)
    toggle(qs,"No Fog + no global shadows","noFog",function(v) actions.setLight(v or S.fullbright);if not (v or S.fullbright) then actions.setLight(false) end end)
    qs:Textbox({Name="FPS cap (0 = default, applies via setfpscap)",Placeholder="e.g. 240",Default=S.fpsCapText,Callback=function(v) S.fpsCapText=v;local n=tonumber(v);if n and setfpscap then pcall(setfpscap,n>0 and n or 60) end end})
    toggle(qs,"Auto Skills (list below) - server signaler","autoSkills",function(v) if v then loadNative() end end)
    qs:Textbox({Name="Skills (comma separated, e.g. Water Surface Slash, Total Concentration)",Placeholder="skill, skill, skill",Default=S.autoSkillText,Callback=function(v) S.autoSkillText=v end})
    qs:Label("Signaler Hold(+Cancel 1s) each 1.4s; aim = zero vector. Stack with Inf Stamina no-CD.")
    toggle(qs,"Auto Breathing Boost (when Stamina >25%)","autoBreath",function(v) if v then loadNative() end end)
    qs:Label("Holds Breathing Boost 0.6s per 2.5s while client Stamina > 25%.")
    qs:Label("SIG_RE / CAM_RE: not in this game's dumps (0 matches). Real equivalents shipped above.")
    local fb=section(lootpage,"auto fishing",1)
    toggle(fb,"Auto Fishing - cast, catch, win","autoFish",function(v)
        if v then loadNative();actions.watchFishPortal() else C.fish.awaitingBite=false end
    end)
    slider(fb,"Answer delay after bite (s)","fishDelay",0.3,3)
    slider(fb,"Recast if no bite (s)","fishNudge",5,30)
    fishLabel=fb:Label("Fishing: idle")
    button(fb,"Cast now (single)",function() loadNative();tell(actions.castRod()) end)
    fb:Label("Needs a *Fishing Rod; cast = native Tool activation near water.")
    local qs=section(qpage,"quest / prompt helpers",2)
    button(qs,"Advance delivery/collect quest (inventory-verified)",function() loadNative();tell(actions.advanceQuest()) end)
    button(qs,"Activate nearest world prompt (queue/lever/portal)",function() tell(actions.activateNearestPrompt()) end)
    qs:Label("Queues/waves/trainers are prompt-driven; no dedicated remotes in dumps.")
    local npcq=section(qpage,"npc interactions (stand near the NPC)",1)
    button(npcq,"Gauntlet statues: begin",function() loadNative();tell(actions.npcAction("GauntletStatuesBegin")) end)
    button(npcq,"Gauntlet statue: give schematic",function() loadNative();tell(actions.npcAction("GauntletGiveSchematic")) end,true)
    button(npcq,"Wagasa: give schematic",function() loadNative();tell(actions.npcAction("WagasaGiveSchematic")) end,true)
    button(npcq,"Muzan: give bell",function() loadNative();tell(actions.npcAction("MuzanGiveBell")) end,true)
    button(npcq,"Take Foxfire",function() loadNative();tell(actions.npcAction("FoxfireTake")) end)
    button(npcq,"Retsu: tell Foxfire",function() loadNative();tell(actions.npcAction("RetsuTellFoxfire")) end)
    button(npcq,"Isao: take toll",function() loadNative();tell(actions.npcAction("IsaoTakeToll")) end,true)
    button(npcq,"Sofen: pull ledger",function() loadNative();tell(actions.npcAction("SofenPullLedger")) end)
    button(npcq,"Liv: gamble",function() loadNative();tell(actions.npcAction("LivGamble")) end,true)
    button(npcq,"Dismiss crow",function() loadNative();tell(actions.npcAction("CrowDismiss")) end)
    button(npcq,"Cleaver duel",function() loadNative();tell(actions.npcAction("CleaverDuel")) end,true)
    npcq:Dropdown({Name="WarFans clue #",Items={"1","2","3","4"},Default=S.wurfansClue,Callback=function(v) S.wurfansClue=v end})
    button(npcq,"WarFans: submit clue",function() loadNative();tell(actions.npcAction("WarFansClue",tonumber(S.wurfansClue))) end,true)
    local pending=section(dp,"NOT IMPLEMENTED - no fake switches",2)
    pending:Label("Still not wired: code redeem UI (no code remote exists in any dump), internal queue/wave scoring, gear scoring. VERDICT: instant kill IS possible via network ownership (Health=0 on your-owned mobs) - shipped in 2.5.0 ported from the working script. Damage remote still does not exist; this is why ownership is the only working path.")
    -- Lifecycle / streaming. No game state-changing action runs at startup.
    connect(workspace.DescendantAdded,add,"Workspace.DescendantAdded")
    connect(workspace.DescendantRemoving,remove,"Workspace.DescendantRemoving")
    -- respawn-safe: features persist through death; only target-selection state clears
    connect(LP.CharacterRemoving,function() S.target=nil;C.target=nil;C.farmTarget=nil;C.auraCache=nil;C.scanList=nil;C.cdWipeT=nil end)
    connect(LP.CharacterAdded,function() C.fatk.combo=1;C.fatk.next=0 end)
    connect(LP:GetPropertyChangedSignal("Team"),function() stopAll("Team changed") end)
    connect(Input.InputBegan,function(key)

    end)
    local tick,elapsed,uiTime=0,0,0
    connect(Run.Heartbeat,function(dt)
        if S.autoParry and not C.blockWatchDone then pcall(watchBlockingValues) end
        if S.autoTraining and not C.trainWatchDone then pcall(watchTrainingValues) end
        if S.infStamina then pcall(actions.infStaminaTick) end
        if S.noCd and os.clock()-(C.cdWipeT or 0)>0.3 then C.cdWipeT=os.clock();pcall(actions.wipeCooldowns) end
        if S.fastM1 then local cp=C.modules.CombatPresets;if type(cp)=="table" then cp.Last_Punched=-1000000;cp.Last_Punched_Jump=-1000000;cp.Last_Combo=0 end end
        if S.killAura and os.clock()-(C.auraT or 0)>0.33 then C.auraT=os.clock();pcall(actions.killAuraTick) end
        if S.noDebuffs and os.clock()-(C.purgeT or 0)>0.2 then C.purgeT=os.clock();pcall(actions.purgeDebuffs) end
        if (S.autoSkills or S.autoBreath) then pcall(actions.autoSkillTick) end
        if winShadow then pcall(function() if winShadow.Visible then killShadow() end end) end
        if S.autoFarm or S.autoBoss then pcall(actions.farmTick) end
        if S.instaKill and os.clock()-(C.ikT or 0)>0.1 then C.ikT=os.clock();pcall(actions.instaKillTick) end
        if S.fastAttack then pcall(actions.fastAttackTick) end
        if S.autoFish and os.clock()-C.fish.last>0.5 then
            if C.fish.awaitingBite and os.clock()-C.fish.last<=(S.fishNudge or 8) then
            else pcall(function() actions.castRod() end) end
        end
        local current,h=char()
        if h and h.Health<=0 and C.deadCharacter~=current then C.deadCharacter=current;stopAll("Death: all toggles OFF") end
        if h and h.Health>0 then C.deadCharacter=nil end
        moveStep();farmMove(dt)
        elapsed=elapsed+dt;uiTime=uiTime+dt;C.visualClock=C.visualClock+dt;C.espClock=(C.espClock or 0)+dt
        if C.visualClock>=0.08 then C.visualClock=0;tracerStep() end
        if C.espClock>=0.45 then C.espClock=0;renderESP() end
        if elapsed>=0.2 then elapsed=0;scheduler() end
        if uiTime>=1 then
            uiTime=0;tick=tick+1
            local _,h=char();local m=S.target;local n=0;for _ in pairs(C.objects) do n=n+1 end
            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")
            if parryLabel and parryLabel.SetText then parryLabel:SetText("Parry: "..C.parryAttempts.." taps / "..C.parryBlocked.." blocks / "..C.parryPerfect.." perfect | method "..C.parryPath..(C.parryConfirmed and " (server-confirmed)" or " (unconfirmed)")) end
            if trainLabel and trainLabel.SetText then trainLabel:SetText("Training: "..C.trainWins.." win signals / "..C.trainClicks.." slider clicks") end
            if fishLabel and fishLabel.SetText then fishLabel:SetText("Fishing: "..C.fish.casts.." casts / "..C.fish.bites.." bites / "..C.fish.wins.." wins") end
            if treeLabel and treeLabel.SetText then
                local pts,rank=actions.treeRank(S.treeNode)
                treeLabel:SetText("Skill points: "..tostring(pts).." | '"..tostring(S.treeNode).."' rank: "..tostring(rank))
            end
            local ready,total=0,0;for k in pairs(modulePaths) do total=total+1;if C.modules[k] then ready=ready+1 end end
            nativeLabel:SetText("Native modules ready: "..ready.."/"..total.." | "..(C.inputBackend or "input not used"))
            targetLabel:SetText(m and "Target: "..m.Name or "Target: none")
            local v=values();local stamina=v and v:FindFirstChild("Stamina")
            resourceLabel:SetText("HP "..(h and math.floor(h.Health) or "-").." | Stamina "..(stamina and tostring(stamina.Value) or "-"))
            local d=data();local holder=d and at(d,{"Quests","Holder"});local names={}
            if holder then for _,q in ipairs(holder:GetChildren()) do names[#names+1]=q.Name end end
            questLabel:SetText("Lv "..tostring(level() or "?").." | "..S.questStage.." | "..S.questProgress.." | "..short(S.questName,45))
            if tick%5==0 then
                local new={}
                for id,row in pairs(huntRows()) do
                    if C.huntsInitialized and S.notifyHunts and not C.huntSeen[id] then note("New eligible hunt: "..row.quest) end
                    new[id]=true
                end
                C.huntSeen=new;C.huntsInitialized=true
            end
        end
    end)
    task.spawn(function()
        local all=workspace:GetDescendants()
        for i,o in ipairs(all) do
            if not S.alive then return end
            local ok,err=pcall(add,o);if not ok then log("index",err) end
            if i%400==0 then task.wait() end
        end
        C.indexing=false
    end)
    note("CAM Main 3.2.4 ready. Auto Level or Auto Farm connects native controls automatically. All automation OFF. End: STOP.")
end
StartCAMHub(Lumen)
