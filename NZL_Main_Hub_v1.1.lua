-- NZL MAIN HUB 1.1 | Standalone Lumen UI | place 122287678911982
-- Based on user-supplied client dump, place version 2812; NOT live tested here.
-- Entire file is required. All automation OFF. RightControl: menu. End: STOP.
-- No HTTP, currency/level/admin calls, hooks, decompile or external modules.
-- Local movement can be corrected by server; requests do not guarantee success.
if game.PlaceId ~= 122287678911982 then
    warn("[NZL Main] Wrong place. This build is for PlaceId 122287678911982 only.")
    return
end
local Lumen = (function()
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
		Lumen:SaveConfig(name) / LoadConfig / DeleteConfig / GetConfigs
		Lumen:BuildConfigSection(section) / Lumen:BuildThemeSection(section)
		Lumen:Unload()

	HOW TO RUN:
		executor:  paste this whole file as one script and execute.
		studio:    LocalScript in StarterPlayerScripts, paste there.
		then in the SAME script (or another one) use:
			local Lumen = getgenv().Lumen
			local Window = Lumen:Window({ Name = "my hub" })
		lumen_demo.lua in this folder is this file with the example
		already uncommented - paste it if you just want to see the menu.

	FULL EXAMPLE AT THE VERY BOTTOM OF THIS FILE.
]]

--#region bootstrap
if getgenv and getgenv().Lumen and getgenv().Lumen.Unload then
	pcall(function() getgenv().Lumen:Unload() end)
end

local Lumen = { }

Lumen.LibraryName = "NZL Studio"
Lumen.Version = "1.0.0"

-- services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

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
    -- PlayerGui also works in Studio without CoreGui permissions.
    local player = Players.LocalPlayer
    assert(player, "Game Debug Collector must run on the client")
    return player:WaitForChild("PlayerGui")
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
		ThemeRegistry = { },
		ThemeRefreshers = { },
		InputHandler = false,
		FlagCount = 0,
	}
end

Lumen.State = createState()
--#endregion

--#region utility
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

local function nextFlag()
	Lumen.State.FlagCount = Lumen.State.FlagCount + 1
	return string.format("lumen_unnamed_%d", Lumen.State.FlagCount)
end

local function registerOption(element, flag)
	flag = flag or nextFlag()
	element.Flag = flag
	Lumen.Options[flag] = element
	Lumen.Flags[flag] = element.Value
	return flag
end

local function addThemeRefresher(fn)
	table.insert(Lumen.State.ThemeRefreshers, fn)
end

-- drag / resize / drag-sliders
local function makeDraggable(gui, handle, hooks)
	handle = handle or gui

	local dragging = false
	local dragStart = nil
	local startPos = nil

	connect(handle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
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

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end)

	connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false

			if hooks and hooks.End then
				hooks.End()
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

	local function handle(position)
		local pos = gui.AbsolutePosition
		local size = gui.AbsoluteSize

		local x = math.clamp((position.X - pos.X) / math.max(size.X, 1), 0, 1)
		local y = math.clamp((position.Y - pos.Y) / math.max(size.Y, 1), 0, 1)

		callback(x, y)
	end

	connect(gui.InputBegan, function(input)
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
			active = false
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
	["Shinri"] = {
		Accent = Color3.fromRGB(242, 242, 244),
		AccentDim = Color3.fromRGB(122, 122, 128),
		Background = Color3.fromRGB(12, 12, 14),
		Sidebar = Color3.fromRGB(12, 12, 14),
		Panel = Color3.fromRGB(21, 21, 25),
		Element = Color3.fromRGB(31, 31, 36),
		ElementHover = Color3.fromRGB(42, 42, 48),
		Border = Color3.fromRGB(35, 35, 40),
		Text = Color3.fromRGB(240, 240, 242),
		TextDim = Color3.fromRGB(139, 139, 146),
		Success = Color3.fromRGB(110, 230, 170),
		Error = Color3.fromRGB(255, 110, 110),
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

Lumen.ThemeName = "Shinri"
Lumen.Theme = { }

for key, value in next, Lumen.Themes.Shinri do
	Lumen.Theme[key] = value
end

local function themed(instance, property, key)
	instance[property] = Lumen.Theme[key]
	table.insert(Lumen.State.ThemeRegistry, { Instance = instance, Property = property, Key = key })
	return instance
end

local function applyTheme()
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

function Lumen:SetTheme(name)
	local theme = Lumen.Themes[name]
	if not theme then
		return false
	end

	Lumen.ThemeName = name
	for key, value in next, theme do
		Lumen.Theme[key] = value
	end

	applyTheme()
	syncThemeUI()
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

	-- floating popups (colorpickers, keybind menus, tooltips) live here so they are never clipped
	local popups = new("Frame", {
		Parent = screen,
		Name = "Popups",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
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
		if tip then
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

		mover = RunService.RenderStepped:Connect(function()
			if not tip or not tip.Parent then
				return
			end
			local mouse = UserInputService:GetMouseLocation()
			tip.Position = UDim2.fromOffset(mouse.X + 14, mouse.Y - 10)
		end)
	end)

	connect(gui.MouseLeave, function()
		if mover then
			mover:Disconnect()
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
			Lumen.Flags[Toggle.Flag] = value
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
		Toggle:Set(not Toggle.Value)
	end)

	connect(Button.MouseEnter, function()
		if not Toggle.Value then
			tween(Box, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
		end
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

		local multiplier = 10 ^ Slider.Decimals
		Slider.Value = math.floor(value * multiplier + 0.5) / multiplier

		if Slider.Flag then
			Lumen.Flags[Slider.Flag] = Slider.Value
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
		Slider:Set(Slider.Value, true)
	end

	function Slider:SetVisibility(visible)
		Frame.Visible = visible and true or false
	end

	dragArea(Track, function(x)
		Slider:Set(Slider.Min + (Slider.Max - Slider.Min) * x)
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
				Lumen.Flags[Dropdown.Flag] = Dropdown.Value
			end

			if data.Callback then
				safe(data.Callback, Dropdown.Value)
			end
		end)

		connect(row.MouseEnter, function()
			if not optionData.Selected then
				row.BackgroundTransparency = 0.6
				row.BackgroundColor3 = Lumen.Theme.ElementHover
			end
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
		for _, option in next, table.clone(Dropdown.Order) do
			Dropdown:Remove(option)
		end

		if type(items) == "table" then
			for _, item in next, items do
				Dropdown:Add(tostring(item))
			end
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
			Lumen.Flags[Dropdown.Flag] = Dropdown.Value
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
		Dropdown:SetOpen(not Dropdown.IsOpen)
	end)

	connect(Button.MouseEnter, function()
		tween(Button, { BackgroundColor3 = Lumen.Theme.ElementHover }, 0.14)
	end)

	connect(Button.MouseLeave, function()
		tween(Button, { BackgroundColor3 = Lumen.Theme.Element }, 0.14)
	end)

	connect(SearchBox:GetPropertyChangedSignal("Text"), function()
		local needle = string.lower(SearchBox.Text)
		for _, option in next, Dropdown.Options do
			option.Row.Visible = needle == "" or string.find(string.lower(option.Name), needle, 1, true) ~= nil
		end
		layoutList()
	end)

	-- close when clicking anywhere else
	connect(UserInputService.InputBegan, function(input)
		if not Dropdown.IsOpen then
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
		Textbox.Value = tostring(value)
		Box.Text = Textbox.Value

		if Textbox.Flag then
			Lumen.Flags[Textbox.Flag] = Textbox.Value
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
local function CreateButton(parent, data, ctx)
	data = data or { }

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

	local Label = new("TextLabel", {
		Parent = Frame,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = Button.Name,
		TextSize = Lumen.TextSize,
		Font = Lumen.FontMedium,
		RichText = true,
	})
	themed(Label, "TextColor3", "Text")

	Button.Items = { Frame = Frame, Label = Label }

	local armed = false

	function Button:Press()
		tween(Frame, { BackgroundColor3 = Lumen.Theme.Accent }, 0.08)
		task.delay(0.12, function()
			tween(Frame, { BackgroundColor3 = Lumen.Theme.Element }, 0.16)
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
		if not Button.Confirm then
			Button:Press()
			return
		end

		if armed then
			armed = false
			Label.Text = Button.Name
			Button:Press()
		else
			armed = true
			Label.Text = "confirm?"
			task.delay(3, function()
				if armed then
					armed = false
					Label.Text = Button.Name
				end
			end)
		end
	end)

	connect(Frame.MouseEnter, function()
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
		Key = data.Default or data.default or nil,
		Mode = string.lower(tostring(data.Mode or data.mode or "toggle")),
		Toggled = false,
		Listening = false,
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

		Lumen.Flags[Keybind.Flag] = {
			Key = Keybind.Key and tostring(Keybind.Key) or "None",
			Mode = Keybind.Mode,
			Toggled = Keybind.Toggled,
			ShowInList = Keybind.ShowInList,
		}
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

	-- right click clears the bound key
	connect(Button.MouseButton2Down, function()
		Keybind:SetKey(nil)
	end)

	-- key capture
	connect(Button.MouseButton1Down, function()
		if Keybind.Listening then
			return
		end

		Keybind.Listening = true
		refreshText()

		local capture = nil
		capture = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				Keybind:SetKey(input.KeyCode)
			elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
				return
			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
				return
			else
				Keybind:SetKey(input.UserInputType)
			end

			Keybind.Listening = false
			refreshText()

			if capture then
				capture:Disconnect()
				capture = nil
			end
		end)

		task.delay(15, function()
			if Keybind.Listening then
				Keybind.Listening = false
				refreshText()
				if capture then
					capture:Disconnect()
					capture = nil
				end
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
				Keybind:SetMode(mode)
				closeMenu()
			end)

			connect(row.MouseEnter, function()
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
			Keybind:SetKey(nil)
			closeMenu()
		end)

		connect(clearRow.MouseEnter, function()
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
			Keybind.ShowInList = not Keybind.ShowInList
			listDot.Visible = Keybind.ShowInList
			Keybind:SaveFlag()
			updateList()
		end)

		connect(listRow.MouseEnter, function()
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

	connect(Button.MouseButton2Down, function()
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
			Lumen.Flags[Picker.Flag] = { Color = Picker.Color:ToHex(), Alpha = Picker.Alpha }
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
		Picker:SetOpen(not Picker.IsOpen)
	end)

	connect(CloseButton.MouseButton1Down, function()
		Picker:SetOpen(false)
	end)

	connect(RainbowButton.MouseButton1Down, function()
		Picker:SetRainbow(not Picker.Rainbow)
	end)

	connect(HexBox.FocusLost, function()
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

	connect(Header.MouseButton1Down, function()
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

	-- only one window at a time: re-running the script must not stack menus
	if Lumen.State.Window and Lumen.State.Window.Alive then
		Lumen.State.Window:__destroy()
	end

	local Window = {
		Alive = true,
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
	}

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

	local Main = new("Frame", {
		Parent = Screen,
		Name = "Main",
		Position = UDim2.fromOffset((viewport.X - Window.Size.X.Offset) / 2, (viewport.Y - Window.Size.Y.Offset) / 2),
		Size = Window.Size,
		BackgroundColor3 = Lumen.Theme.Background,
		BorderSizePixel = 0,
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 1,
	})
	themed(Main, "BackgroundColor3", "Background")
	corner(Main, 12)
	local MainStroke = stroke(Main, Lumen.Theme.Border, 1, 0.15)
	themed(MainStroke, "Color", "Border")

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

	local TabScroller = new("ScrollingFrame", {
		Parent = Sidebar,
		Position = UDim2.fromOffset(0, 62),
		Size = UDim2.new(1, 0, 1, -132),
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
		tween(DiscordBody, { BackgroundColor3 = Lumen.Theme.Text }, 0.12)
	end)
	connect(DiscordButton.MouseLeave, function()
		tween(DiscordBody, { BackgroundColor3 = Lumen.Theme.TextDim }, 0.12)
	end)
	attachTooltip(DiscordButton, data.DiscordTooltip or data.discordtooltip or "Join for more Information")

	connect(DiscordButton.MouseButton1Down, function()
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
	}

	Lumen.State.Window = Window
	Lumen.State.MinimizedBar = MinimizedBar

	-- while dragging, the chrome fades out and the hub name shows (nzl style)
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

	local DragSub = new("TextLabel", {
		Parent = Main,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 28),
		Size = UDim2.new(1, -60, 0, 18),
		BackgroundTransparency = 1,
		Text = "v" .. Window.Version .. "  |  lumen core  |  release to drop",
		TextSize = 12,
		Font = Lumen.FontMedium,
		RichText = true,
		TextTransparency = 0.3,
		Rotation = -8,
		Visible = false,
		ZIndex = 45,
	})
	themed(DragSub, "TextColor3", "TextDim")

	local dragHooks = {
		Begin = function()
			if not Window.IsOpen then
				return
			end

			Sidebar.Visible = false
			Content.Visible = false
			ResizeHandle.Visible = false
			DragLabel.Visible = true
			DragBar.Visible = true
			DragSub.Visible = true
			tween(Main, { BackgroundTransparency = 0.35 }, 0.15)
		end,
		End = function()
			Sidebar.Visible = true
			Content.Visible = true
			ResizeHandle.Visible = true
			DragLabel.Visible = false
			DragBar.Visible = false
			DragSub.Visible = false
			tween(Main, { BackgroundTransparency = 0 }, 0.15)
		end,
	}

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
	end

	function Window:SetText(text)
		Window.Name = text
		BrandTitle.Text = text
		DragLabel.Text = text
	end

	function Window:Unload()
		Lumen:Unload()
	end

	Window.Destroy = Window.Unload

	-- internal: tear this window down so a fresh one can take over
	function Window:__destroy()
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

		pcall(function()
			Main:Destroy()
		end)
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

		Page.Items = { Holder = Holder, Tab = Tab, TabText = TabText, ColumnsHolder = ColumnsHolder }

		function Page:Switch(active)
			Page.Active = active and true or false
			Holder.Visible = Page.Active

			Tab.BackgroundTransparency = Page.Active and 0 or 1
			TabText.TextColor3 = Page.Active and Lumen.Theme.Text or Lumen.Theme.TextDim
			TabText.Font = Page.Active and Lumen.FontBold or Lumen.FontMedium
		end

		connect(Tab.MouseButton1Down, function()
			Window:SwitchPage(Page)
		end)

		connect(Tab.MouseEnter, function()
			if not Page.Active then
				Tab.BackgroundTransparency = 0.55
			end
			tween(TabText, { Position = UDim2.fromOffset(15, 0) }, 0.12)
		end)

		connect(Tab.MouseLeave, function()
			if not Page.Active then
				Tab.BackgroundTransparency = 1
			end
			tween(TabText, { Position = UDim2.fromOffset(12, 0) }, 0.12)
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
		Window:SetMinimized(true)
	end)

	connect(CloseButton.MouseButton1Down, function()
		Window:SetOpen(false)
	end)

	connect(MinimizeButton.MouseEnter, function()
		tween(MinimizeButton, { TextColor3 = Lumen.Theme.Text }, 0.12)
	end)
	connect(MinimizeButton.MouseLeave, function()
		tween(MinimizeButton, { TextColor3 = Lumen.Theme.TextDim }, 0.12)
	end)
	connect(CloseButton.MouseEnter, function()
		tween(CloseButton, { TextColor3 = Lumen.Theme.Error }, 0.12)
	end)
	connect(CloseButton.MouseLeave, function()
		tween(CloseButton, { TextColor3 = Lumen.Theme.TextDim }, 0.12)
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
		settingsTab.Position = UDim2.new(0, 8, 1, -66)
		settingsTab.Size = UDim2.new(1, -16, 0, 26)

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

		menuSection:Toggle({
			Name = "keybind list",
			Flag = "lumen_keybind_list",
			Default = false,
			Callback = function(state)
				if state then
					if not Lumen.State.KeybindsList then
						Lumen:KeybindsList()
					else
						Lumen.State.KeybindsList:SetVisibility(true)
					end
				elseif Lumen.State.KeybindsList then
					Lumen.State.KeybindsList:SetVisibility(false)
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

		Lumen:BuildConfigSection(settingsPage:Section({ Name = "configs", Side = 1 }))
		Lumen:BuildThemeSection(settingsPage:Section({ Name = "theme", Side = 2 }))
	end

	Window:SetOpen(data.StartClosed and false or true, true)

	return Window
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

	makeDraggable(Frame, Frame)

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

	if data.Stats then
		local frames = 0
		local lastUpdate = os.clock()
		local fps = 0

		connect(RunService.RenderStepped, function()
			frames = frames + 1
			local now = os.clock()
			if now - lastUpdate >= 0.5 then
				fps = math.floor(frames / (now - lastUpdate))
				frames = 0
				lastUpdate = now
			end

			local ping = 0
			pcall(function()
				ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
			end)

			Label.Text = string.format("%s | <font color=\"#7ea8ff\">%d fps</font> | %d ms", Watermark.Text, fps, ping)
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

	local startX = (data.Position and data.Position.X) or 12
	local startY = (data.Position and data.Position.Y) or 100

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

	local Content = new("Frame", {
		Parent = Frame,
		Position = UDim2.fromOffset(0, 26),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 41,
	})
	padding(Content, 6, 8, 8, 8)
	list(Content, { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3) })

	makeDraggable(Frame, Header)

	KeybindsList.Rows = { }

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

		Frame.Visible = order > 0 and KeybindsList.Enabled ~= false
	end

	function KeybindsList:SetVisibility(visible)
		KeybindsList.Enabled = visible and true or false
		Frame.Visible = visible and true or false
		if visible then
			KeybindsList:Refresh()
		end
	end

	KeybindsList.Items = { Frame = Frame }
	Lumen.State.KeybindsList = KeybindsList
	KeybindsList:Refresh()

	local settingsToggle = Lumen.Options["lumen_keybind_list"]
	if settingsToggle then
		settingsToggle:Set(true, true)
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
	local duration = tonumber(data.Duration or data.duration or 4) or 4
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

--#region config system
local function serializeOptions()
	local output = { }

	for flag, option in next, Lumen.Options do
		-- settings-internal helpers must never be stored in configs:
		-- restoring them would silently flip autoload / wipe the name boxes
		local internal = flag:match("^lumen_config_autoload") ~= nil
			or flag:match("^lumen_theme_autoload") ~= nil
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

	Lumen:Notification({
		Name = "config saved",
		Description = path,
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
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

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(readfile(path))
	end)

	if not ok or type(decoded) ~= "table" then
		Lumen:Notification({
			Name = "config error",
			Description = "failed to parse " .. tostring(name),
			Duration = 4,
			Color = Lumen.Theme.Error,
		})
		return false
	end

	for flag, value in next, decoded do
		local option = Lumen.Options[flag]
		if option then
			pcall(applyOption, option, value)
		end
	end

	Lumen:Notification({
		Name = "config loaded",
		Description = name,
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
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
		Description = name .. ".json",
		Duration = 3,
		Color = Lumen.Theme.Success,
	})

	return true
end

function Lumen:SetAutoload(name)
	ensureFolders()
	pcall(writefile, Lumen.Folder .. "/autoload.txt", tostring(name or ""))
end

function Lumen:GetAutoload()
	return readText(Lumen.Folder .. "/autoload.txt")
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

	local output = { }
	for key, value in next, Lumen.Theme do
		if typeof(value) == "Color3" then
			output[key] = value:ToHex()
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
		Description = path,
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
	pcall(writefile, Lumen.Folder .. "/autoload_theme.txt", tostring(name or ""))
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

	section:Toggle({
		Name = "autoload this config",
		Flag = "lumen_config_autoload" .. suffix,
		Callback = function(enabled)
			if enabled then
				local name = configDropdown:Get()
				if name and name ~= "" then
					Lumen:SetAutoload(name)
				end
			else
				Lumen:SetAutoload("")
			end
		end,
	})

	return configDropdown, nameBox
end

-- ready made theme ui
function Lumen:BuildThemeSection(section)
	if not section then
		return
	end

	Lumen.State.ThemeUICount = (Lumen.State.ThemeUICount or 0) + 1
	local suffix = Lumen.State.ThemeUICount == 1 and "" or "_" .. Lumen.State.ThemeUICount

	local presets = { }
	for name in next, Lumen.Themes do
		table.insert(presets, name)
	end
	table.sort(presets)

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
		table.insert(Lumen.State.ThemePickers, { Key = key, Picker = picker })
	end

	local themeDropdown = section:Dropdown({ Name = "saved themes", Items = Lumen:GetThemeConfigs(), Flag = "lumen_saved_theme" .. suffix })
	local themeName = section:Textbox({ Name = "theme name", Placeholder = "my theme", Flag = "lumen_theme_name" .. suffix })

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
			local preset = Lumen.State.ThemePreset
			if not preset or not Lumen.Themes[preset] then
				preset = "Shinri"
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
			Lumen:SetAutoloadTheme(enabled and themeDropdown:Get() or "")
		end,
	})

	return pickers
end

function Lumen:Init()
	ensureFolders()

	local autoConfig = readText(Lumen.Folder .. "/autoload.txt")
	if autoConfig ~= "" then
		Lumen:LoadConfig(autoConfig)
	end

	local autoTheme = readText(Lumen.Folder .. "/autoload_theme.txt")
	if autoTheme ~= "" then
		Lumen:LoadTheme(autoTheme)
	end
end

function Lumen:Unload()
	Lumen.State.Running = false

	for _, option in next, Lumen.Options do
		if option.Type == "Colorpicker" and option.SetRainbow then
			pcall(function()
				option:SetRainbow(false)
			end)
		end
	end

	for _, connection in next, Lumen.Connections do
		pcall(function()
			connection:Disconnect()
		end)
	end

	Lumen.Connections = { }

	for _, keybind in next, Lumen.State.Keybinds do
		pcall(function()
			if keybind.Button and keybind.Button.Parent then
				keybind.Button:Destroy()
			end
		end)
	end

	if Lumen.State.Screen then
		pcall(function()
			Lumen.State.Screen:Destroy()
		end)
	end

	Lumen.Flags = { }
	Lumen.Options = { }
	Lumen.State = createState()
	Lumen.State.Ready = false

	if getgenv then
		getgenv().Lumen = nil
	end

	pcall(function()
		UserInputService.MouseIconEnabled = true
	end)
end
--#endregion

getgenv().Lumen = Lumen


return Lumen
end)()

-- NZL Main Hub 1.1 | client-side integration for place version 2812.
-- Payloads traced to the user's dump. Server acceptance is NOT guaranteed.
-- All automation is OFF at startup. No HTTP, admin remotes, hooks or decompilation.
local function StartMainHub(Lumen)
    local Env = (getgenv and getgenv()) or _G
    if Env.NZLMainHub and Env.NZLMainHub.Stop then pcall(Env.NZLMainHub.Stop) end
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local Run = game:GetService("RunService")
    local Input = game:GetService("UserInputService")
    local Tween = game:GetService("TweenService")
    local Http = game:GetService("HttpService")
    local LP = Players.LocalPlayer
    assert(LP, "Run this script on the client")
    local S = {
        alive = true, autoM1 = false, autoWalk = false, autoSkill = false,
        autoFarm = false, hover = false, autoQuest = false, executorPrompts = false,
        hoverHeight = 4, hoverBack = 2, hoverSpeed = 40, restHeight = 12,
        staminaLow = 20, staminaResume = 45, healthLow = 25, healthResume = 60,
        stallTimeout = 20, questMode = "Hunter hunt",
        autoPaper = false, autoOffer = false, espNPC = false, espPlayers = false,
        noclip = false, speed = false, fly = false, infJump = false,
        allowPlayers = false, faceTarget = false, attackDelay = 0.65,
        searchRange = 120, hitRange = 7, walkSpeed = 28, flySpeed = 45,
        travelSpeed = 45, espRange = 500, targetGroup = "Hunters",
        targetName = "", vampireSkill = "BloodDrink", target = nil,
        lastAction = "Idle", lastReply = "No server replies yet", status = "Ready",
        selectedLandmark = "Quest NPC", selectedShop = "", token = 0,
    }
    local C = { connections = {}, logs = {}, toggleRefs = {}, npcs = {}, prompts = {},
        esp = {}, cooldowns = {}, remoteTimes = {}, watched = {}, shopCards = {},
        collision = setmetatable({}, {__mode = "k"}), stopCount = 0,
        avoid = setmetatable({}, {__mode = "k"}), hunts = {}, questFarming = false }
    local statusLabel, targetLabel, resourceLabel, actionLabel, questLabel, questDetailLabel, replyLabel, skillLabel
    local stopAll, unload, cancelTravel, stopFly, clearESP, releaseHover, questStep, syncToggles
    local function short(x, n)
        local s=tostring(x);n=n or 350
        if #s<=n then return s end
        while n>0 do local b=s:byte(n+1);if not b or b<128 or b>=192 then break end;n=n-1 end
        return s:sub(1,n).."..."
    end
    local function log(kind, text)
        C.logs[#C.logs+1] = {time=os.date("!%H:%M:%S"),kind=kind,text=short(text,1500)}
        if #C.logs > 150 then table.remove(C.logs,1) end
    end
    local function note(text)
        log("notice",text)
        if S.alive then pcall(function() Lumen:Notification({Name="NZL Main",Description=short(text,250),Duration=5}) end) end
    end
    local function connect(signal, fn)
        local c = signal:Connect(function(...)
            if not S.alive then return end
            local ok, err = pcall(fn,...)
            if not ok then log("callback error",err) end
        end)
        C.connections[#C.connections+1] = c
        return c
    end
    local function at(root, names)
        local o = root
        for _, name in ipairs(names) do if not o then return nil end o = o:FindFirstChild(name) end
        return o
    end
    local function char()
        local c = LP.Character
        return c, c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
    end
    local function part(o)
        if not o then return nil end
        if o:IsA("BasePart") then return o end
        if o:IsA("Attachment") then return o.Parent and o.Parent:IsA("BasePart") and o.Parent or nil end
        if o:IsA("Model") then return o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart",true) end
        return nil
    end
    local function team() return LP.Team and LP.Team.Name or "None" end
    local function years() return tonumber(LP:GetAttribute("Years")) or 0 end
    local function vampire() return team()=="Vampires" or team()=="Cannibal Raised" end
    local function usable()
        local c,h,r = char()
        if not c or not h or not r or h.Health<=0 then return false,"Character unavailable" end
        for _, key in ipairs({"ActionLocked","Hibernating","Ragdolled","BeingCarried","ToolEquipLocked","BatFormTransforming","BatFormActive"}) do
            if c:GetAttribute(key)==true then return false,key end
        end
        return true
    end
    local routes = {
        Block={"ArczisCombat","Remotes","BlockEvent"},
        Quest={"QuestRemotes","QuestRemote"}, HunterQuest={"HunterQuestRemotes","HunterQuestRemote"},
        Quest2={"Quest2Remotes","Quest2Remote"},
        HumanSideQuest={"Funções","Eventos","HumanSideQuestRemote"},
        Shop={"Funções","Eventos","ShopRemote"}, Broom={"Funções","Eventos","BroomRemote"},
        Sleep={"Funções","Eventos","CeilingSleepRemote"},
        Track={"Funções","Eventos","VampiricTrackerRemote"},
        PainStop={"Funções","Eventos","WitchPainInflictionRemote"},
        StrengthCast={"Funções","Eventos","StrengthRemote"},
        HypnosisEnd={"Network","Combat","HypnosisRequest"},
    }
    for _, key in ipairs({"BreakNeck","BloodDrink","HeartRipping","Infect","Hypnosis","WitchLifeDrain","WitchBreakNeck","WitchHeartRipping","WitchPetrification","WitchPainInfliction","WitchInvisible","Strength","Incendia"}) do
        routes[key] = {"Network","Combat",key.."Request"}
    end
    local function send(key, ...)
        if not S.alive then return false,"Hub unloaded" end
        if game.PlaceId~=122287678911982 then return false,"Wrong place" end
        local path = routes[key]
        if not path then return false,"Unknown route: "..tostring(key) end
        local remote = at(RS,path)
        if not remote or not remote:IsA("RemoteEvent") then return false,"Missing RemoteEvent: "..table.concat(path,"/") end
        local now = os.clock()
        -- Local rate guard, not a server bypass. A two-message ability uses the same route.
        if now - (C.remoteTimes[key] or -100) < 0.025 then return false,"Local request throttle" end
        C.remoteTimes[key] = now
        local args = table.pack(...)
        local ok, err = pcall(function() remote:FireServer(table.unpack(args,1,args.n)) end)
        if not ok then log("remote error",key..": "..tostring(err)) return false,short(err) end
        S.lastAction = "Sent "..key.." / "..short(args[1] or "request",70)
        log("request",S.lastAction)
        return true
    end
    local function tell(ok, reason)
        note(ok and "Request sent; server result is not guaranteed." or (reason or "Action unavailable"))
    end
    local function boolState(c,name)
        local v = c and c:FindFirstChild(name)
        return v and v:IsA("BoolValue") and v.Value==true
    end
    local function farmActive()
        if S.autoQuest then return C.questFarming==true end
        return S.autoFarm
    end
    local function recovery()
        local _,h=char()
        local st=tonumber(LP:GetAttribute("Stamina"))
        local maxSt=tonumber(LP:GetAttribute("MaxStamina")) or 100
        local low=math.max(15, math.min(S.staminaLow,maxSt))
        local resume=math.max(15, math.min(math.max(S.staminaResume,low+5),maxSt))
        if st and st<low then C.staminaRest=true end
        if C.staminaRest then
            if st and st>=resume and os.clock()>=(C.restUntil or 0) then C.staminaRest=false
            else return true,"Stamina recovery: "..tostring(st or "?").." / "..resume end
        end
        if h and h.MaxHealth>0 then
            local pct=h.Health/h.MaxHealth*100
            if pct<=S.healthLow then C.healthRest=true end
            if C.healthRest then
                local want=math.max(S.healthResume,S.healthLow+5)
                if pct>=want then C.healthRest=false
                else return true,"Health recovery: "..math.floor(pct).."% / "..want.."%" end
            end
        end
        return false
    end
    local function isTarget(m)
        local c,_,r = char()
        if not m or not m.Parent or not m:IsA("Model") or m==c or not r then return false end
        local h,p = m:FindFirstChildOfClass("Humanoid"),part(m)
        if not h or h.Health<=0 or not p then return false end
        if (C.avoid[m] or 0)>os.clock() then return false end
        if m:GetAttribute("Invulnerable")==true or m:GetAttribute("QuestNPC")==true then return false end
        local player = Players:GetPlayerFromCharacter(m)
        if player then return not (S.autoFarm or S.autoQuest or S.hover) and S.allowPlayers and player~=LP end
        if m.Name=="NPCQuest" or m.Name=="NPCQuest2" then return false end
        return true
    end
    local function groupMatches(m)
        if S.autoQuest and C.questFarming then
            if S.questMode=="Human hunt" then return m.Name=="Human" and m:GetAttribute("TargetCity")=="CIDADE2" end
            return m.Name=="Hunter"
        end
        if Players:GetPlayerFromCharacter(m) then return S.allowPlayers end
        if S.targetGroup=="All NPCs" then return true end
        if S.targetGroup=="Humans" then return m.Name=="Human" end
        if S.targetGroup=="Hunters" then return m.Name=="Hunter" end
        if S.targetGroup=="Guards" then return m:GetAttribute("GuardNPC")==true or m.Name:lower():find("guard",1,true)~=nil end
        return false
    end
    local function findTarget()
        local _,_,r = char()
        if not r then return nil end
        local best,dist = nil,S.searchRange
        local function consider(m)
            if isTarget(m) and groupMatches(m) and (S.targetName=="" or m.Name:lower():find(S.targetName:lower(),1,true)) then
                local d=(part(m).Position-r.Position).Magnitude
                if d<dist then best,dist=m,d end
            end
        end
        for m in pairs(C.npcs) do if m.Parent then consider(m) else C.npcs[m]=nil end end
        if S.allowPlayers then for _,p in ipairs(Players:GetPlayers()) do consider(p.Character) end end
        return best
    end
    local function target()
        if isTarget(S.target) and groupMatches(S.target) then
            local _,_,r=char()
            if (part(S.target).Position-r.Position).Magnitude<=S.searchRange then return S.target end
        end
        S.target=findTarget()
        return S.target
    end
    local function face(m)
        local _,_,r=char();local p=part(m)
        if r and p then
            local to=Vector3.new(p.Position.X,r.Position.Y,p.Position.Z)
            if (to-r.Position).Magnitude>0.01 then r.CFrame=CFrame.lookAt(r.Position,to) end
        end
    end
    local function inRange(m,range)
        local _,_,r=char();local p=part(m)
        return r and p and (r.Position-p.Position).Magnitude<=range
    end
    local function equipFists()
        local c,h=char()
        if not c or not h then return false,"No character" end
        local tool=c:FindFirstChild("Fists") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Fists"))
        if not tool or not tool:IsA("Tool") then return false,"Fists tool not found" end
        if tool.Parent~=c then h:EquipTool(tool) return true,"Equipping; wait for animation" end
        return true
    end
    local function punch()
        local resting,why=recovery();if resting then return false,why end
        local ok,reason=usable();if not ok then return false,reason end
        local m=target();if not m or not inRange(m,S.hitRange) then return false,"No target in hit range" end
        local c=LP.Character
        for _,n in ipairs({"IsBlocking","IsStunned","IsGuardBroken","IsAttacking","IsInClash"}) do if boolState(c,n) then return false,n end end
        if (tonumber(LP:GetAttribute("Stamina")) or 0)<15 then return false,"Stamina below 15" end
        if os.clock()-(C.lastPunch or -100)<S.attackDelay then return false,"Attack interval" end
        local t=c:FindFirstChild("Fists")
        if not t then equipFists() return false,"Equip Fists first" end
        if not t:IsA("Tool") or not t.Enabled then return false,"Tool unavailable" end
        if S.faceTarget then face(m) end
        C.lastPunch=os.clock()
        -- Existing ArczisCombatController binds Fists.Activated, preserving its checks/animations.
        t:Activate()
        S.lastAction="Fists:Activate (native client controller)"
        return true
    end

    local vampireSkills = {
        BloodDrink={action="Bite",range=8,years=0,cd=8},
        BreakNeck={action="Break",range=8,years=5,cd=15},
        Infect={action="Infect",range=14,years=150,cd=8},
        HeartRipping={action="Attack",range=10,years=150,cd=90},
        Hypnosis={action="Select",range=10,years=20,cd=20},
    }
    local function castVampire(name)
        local d=vampireSkills[name];if not d then return false,"Unknown ability" end
        if not vampire() then return false,"Vampire team required" end
        if years()<d.years then return false,"Requires Years "..d.years end
        local ok,reason=usable();if not ok then return false,reason end
        if (C.cooldowns[name] or 0)>os.clock() then return false,"Local cooldown" end
        local m=target();if not m or not inRange(m,d.range) then return false,"Target must be within "..d.range.." studs" end
        if m:GetAttribute("ActionLocked") or m:GetAttribute("Hibernating") or m:GetAttribute("BreakNeckRecovering") then return false,"Target is locked" end
        if S.faceTarget then face(m) end
        local accepted,err=send(name,"Begin","UI")
        if not accepted then return false,err end
        C.cooldowns[name]=os.clock()+d.cd
        local token=S.token
        task.delay(0.06,function()
            if S.alive and S.token==token and isTarget(m) and inRange(m,d.range) then
                local sent,why=send(name,d.action,m,"UI")
                if not sent then log("ability error",why) end
            end
        end)
        return true
    end
    local witchSkills={
        WitchLifeDrain={years=0,cd=38},WitchBreakNeck={years=25,cd=15,mana=80},
        WitchHeartRipping={years=100,cd=90,mana=100},WitchPetrification={years=15,cd=25,mana=45},
        WitchInvisible={years=25,cd=25,action="Activate"},
    }
    local function castWitch(name)
        local d=witchSkills[name]
        if not d then return false,"Unknown witch ability" end
        if team()~="Witches" then return false,"Witches team required" end
        if years()<d.years then return false,"Requires Years "..d.years end
        local ok,reason=usable();if not ok then return false,reason end
        if (C.cooldowns[name] or 0)>os.clock() then return false,"Local cooldown" end
        local mana=tonumber(LP:GetAttribute("Mana"))
        if d.mana and mana and mana<d.mana then return false,"Not enough Mana" end
        local sent,err
        if d.action then sent,err=send(name,d.action) else sent,err=send(name) end
        if sent then C.cooldowns[name]=os.clock()+d.cd end
        return sent,err
    end
    local function pain()
        if team()~="Witches" or years()<140 then return false,"Witches / Years 140 required" end
        local ok,why=usable();if not ok then return false,why end
        if (C.cooldowns.Pain or 0)>os.clock() then return false,"Local cooldown" end
        local m=target();if not m or not inRange(m,40) then return false,"Target farther than 40 studs" end
        local sent,err=send("WitchPainInfliction","Begin",m)
        if sent then C.painOwned=true C.cooldowns.Pain=os.clock()+35 end
        return sent,err
    end
    local function stopPain()
        if C.painOwned then send("PainStop","Stop") C.painOwned=false end
    end
    local function toggleSleep()
        local c,_,r=char()
        if not c or not r then return false,"No character" end
        if c:GetAttribute("CeilingSleeping")==true then
            local ok,why=send("Sleep","Detach")
            if ok then C.sleepOwned=false end
            return ok,why
        end
        if not vampire() or years()<100 then return false,"Vampire / Years 100 required" end
        local ok,why=usable();if not ok then return false,why end
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={c}
        local hit=workspace:Raycast(r.Position,Vector3.new(0,14,0),params)
        if not hit or hit.Normal.Y>-0.55 then return false,"No suitable ceiling within 14 studs" end
        local sent,err=send("Sleep","Toggle",r.Position)
        if sent then C.sleepOwned=true end
        return sent,err
    end

    local function questBusy()
        return LP:GetAttribute("QuestActive")==true or LP:GetAttribute("Quest2Active")==true or LP:GetAttribute("HumanSideQuestActive")==true
    end
    local function nearestPaper()
        local _,_,r=char();if not r then return nil end
        local root=workspace:FindFirstChild("Quest2");if not root then return nil end
        local best,dist
        for _,o in ipairs(root:GetDescendants()) do
            if o:IsA("BasePart") and o:GetAttribute("Quest2Enabled")==true then
                local d=(o.Position-r.Position).Magnitude
                if not dist or d<dist then best,dist=o,d end
            end
        end
        return best,dist
    end
    local function acceptPaper()
        if questBusy() then return false,"Another quest is already active" end
        local o,d=nearestPaper();if not o then return false,"No loaded Quest2 offer" end
        if d>(tonumber(o:GetAttribute("Quest2Range")) or 11) then return false,"Move closer to the offer" end
        if years()<(tonumber(o:GetAttribute("Quest2MinLevel")) or 0) then return false,"Quest minimum level not reached" end
        local id=tostring(o:GetAttribute("Quest2OfferId") or "")
        if id=="" then return false,"Quest2OfferId missing" end
        if os.clock()-(C.lastPaper or -100)<5 then return false,"Waiting for quest state (5s)" end
        C.lastPaper=os.clock()
        return send("Quest2","Accept",o,id)
    end
    local function nearestPrompt()
        local _,_,r=char();if not r then return nil end
        local best,dist
        for p in pairs(C.prompts) do
            if not p.Parent then C.prompts[p]=nil
            elseif p.Enabled then
                local pt=part(p.Parent)
                if pt then local d=(pt.Position-r.Position).Magnitude if not dist or d<dist then best,dist=p,d end end
            end
        end
        return best,dist
    end
    local function activatePrompt(p)
        local _,_,r=char();local pt=p and part(p.Parent)
        if not p or not p.Parent or not p.Enabled or not r or not pt then return false,"No enabled prompt found" end
        local d=(r.Position-pt.Position).Magnitude
        if d>p.MaxActivationDistance then return false,"Move within prompt activation range" end
        if C.holdingPrompt then return false,"A prompt is already held" end
        local token=S.token
        -- Preserve the prompt hold duration. No distance or Enabled modifications.
        local helper=S.executorPrompts and type(fireproximityprompt)=="function"
        if not helper then p:InputHoldBegin() end
        C.holdingPrompt=p
        task.delay(p.HoldDuration+0.1,function()
            if helper then
                local _,_,root=char();local point=p.Parent and part(p.Parent)
                if S.alive and S.token==token and p.Enabled and point and root and (point.Position-root.Position).Magnitude<=p.MaxActivationDistance then
                    local ok,why=pcall(fireproximityprompt,p)
                    if not ok then log("prompt error",why) end
                end
            else pcall(function() p:InputHoldEnd() end) end
            if C.holdingPrompt==p then C.holdingPrompt=nil end
            if S.alive and S.token==token then log("prompt","Input hold ended: "..p.Name) end
        end)
        return true
    end
    local function usePrompt() return activatePrompt(nearestPrompt()) end
    local function huntRoute()
        return S.questMode=="Human hunt" and "Quest" or "HunterQuest"
    end
    questStep=function()
        C.questGoal=nil;C.questFarming=false
        if not S.autoQuest then return end
        if LP:GetAttribute("Quest2Active")==true or LP:GetAttribute("HumanSideQuestActive")==true then
            S.status="Auto Quest paused: finish the other active quest";return
        end
        local q=C.hunts[huntRoute()]
        if q and q.active and not q.turnIn then
            C.questFarming=true
            S.status="Hunt "..tostring(q.progress).." / "..tostring(q.required)
            return
        end
        local npc=workspace:FindFirstChild(S.questMode=="Human hunt" and "NPCQuest" or "NPCQuest2",true)
        local p=part(npc);local _,_,root=char()
        if not p or not root then S.status="Auto Quest: NPC is not streamed; move closer manually";return end
        if (p.Position-root.Position).Magnitude>5000 then S.status="Auto Quest: NPC beyond travel limit";return end
        C.questGoal=p.Position+Vector3.new(0,0,5)
        local prompt=npc:FindFirstChild("QuestPrompt",true) or npc:FindFirstChildWhichIsA("ProximityPrompt",true)
        if not prompt then S.status="Auto Quest: no quest prompt on NPC";return end
        S.status=q and q.turnIn and "Returning to NPC for turn-in" or "Approaching NPC / waiting for quest dialogue"
        if os.clock()-(C.lastQuestPrompt or -100)>=5 then
            local ok=activatePrompt(prompt)
            if ok then C.lastQuestPrompt=os.clock() end
        end
    end

    cancelTravel=function()
        if C.travel then pcall(function() C.travel:Cancel() end) C.travel=nil end
    end
    local function travelTo(p)
        local ok,why=usable();if not ok then note(why) return end
        if typeof(p)~="Vector3" then note("Destination unavailable / not streamed") return end
        local _,_,r=char();cancelTravel();S.autoWalk=false
        S.autoFarm=false;S.hover=false;S.autoQuest=false;S.token=S.token+1;C.questGoal=nil;C.questFarming=false
        releaseHover();syncToggles()
        if C.toggleRefs.autoWalk then C.toggleRefs.autoWalk:Set(false,true) end
        local distance=(r.Position-p).Magnitude
        if distance>5000 then note("Destination too far for local tween; travel normally first") return end
        C.travel=Tween:Create(r,TweenInfo.new(math.max(distance/S.travelSpeed,0.15),Enum.EasingStyle.Linear),{CFrame=CFrame.new(p)})
        local active=C.travel
        local finished
        finished=active.Completed:Connect(function()
            if C.travel==active then C.travel=nil end
            if finished then finished:Disconnect() end
        end)
        C.connections[#C.connections+1]=finished
        active:Play();S.lastAction="Local travel tween (server may correct position)"
    end
    local landmarks={
        ["Quest NPC"]={"NPCQuest"},["Quest NPC 2"]={"NPCQuest2"},
        ["Delivery point"]={"Interativos","DeliveryPoint"},["Quest papers"]={"Quest2"},
        ["Hunter area"]={"HUNTERAREA"},["Humans"]={"Humans"},["Lockpick"]={"LOCKPICK"},
    }
    local function landmarkPart()
        if S.selectedLandmark=="Current target" then return part(target()) end
        if S.selectedLandmark=="Nearest prompt" then local p=nearestPrompt() return p and part(p.Parent) end
        if S.selectedLandmark=="Nearest quest paper" then return nearestPaper() end
        local o=at(workspace,landmarks[S.selectedLandmark] or {})
        return part(o) or (o and o:FindFirstChildWhichIsA("BasePart",true))
    end
    local function restoreCollision()
        for p,v in pairs(C.collision) do pcall(function() p.CanCollide=v end) C.collision[p]=nil end
    end
    local function restoreSpeed()
        if C.speedHum and C.speedHum.Parent then pcall(function() C.speedHum.WalkSpeed=C.originalSpeed end) end
        C.speedHum=nil;C.originalSpeed=nil
    end
    stopFly=function()
        if C.flight then
            pcall(function() C.flight.vel:Destroy() C.flight.gyro:Destroy() end)
            pcall(function() C.flight.hum.PlatformStand=C.flight.platform end)
            C.flight=nil
        end
    end
    releaseHover=function()
        if C.hoverVelocity then pcall(function() C.hoverVelocity:Destroy() end) C.hoverVelocity=nil end
        C.hoverRoot=nil;C.hoverActive=false
        if not S.noclip then restoreCollision() end
    end
    local function hoverStep(dt)
        local seeking=S.autoQuest and C.questGoal~=nil
        local hovering=(S.hover or farmActive()) and (not S.autoQuest or C.questFarming)
        if S.fly or C.travel or not (seeking or hovering) then releaseHover() return end
        local good=usable();local _,h,r=char()
        if not good or not h or not r or h.Health<=0 then releaseHover() return end
        local m=hovering and target() or nil
        local p=m and part(m)
        local goal=C.questGoal
        if not seeking then
            if not p then releaseHover() return end
            local resting=recovery()
            local y=resting and math.max(S.restHeight,S.hoverHeight) or S.hoverHeight
            goal=p.Position+Vector3.new(0,y,S.hoverBack)
        end
        if not goal or (goal-r.Position).Magnitude>5000 then releaseHover() return end
        if C.hoverRoot~=r then
            releaseHover()
            local v=Instance.new("BodyVelocity");v.Name="NZL_HoverHold";v.MaxForce=Vector3.new(1e6,1e6,1e6);v.Velocity=Vector3.zero;v.Parent=r
            C.hoverVelocity=v;C.hoverRoot=r
        end
        C.hoverActive=true
        local delta=goal-r.Position
        local step=math.min(delta.Magnitude,S.hoverSpeed*math.min(dt,0.1))
        local pos=delta.Magnitude>0.01 and r.Position+delta.Unit*step or goal
        local to=p and Vector3.new(p.Position.X,pos.Y,p.Position.Z) or nil
        r.CFrame=to and (to-pos).Magnitude>0.01 and CFrame.lookAt(pos,to) or CFrame.new(pos)
        r.AssemblyLinearVelocity=Vector3.zero
    end
    local function flightStep()
        if not S.fly then stopFly() return end
        local _,h,r=char()
        if not h or not r or h.Health<=0 then stopFly() return end
        if not C.flight or C.flight.root~=r then
            stopFly();cancelTravel()
            local vel=Instance.new("BodyVelocity");vel.MaxForce=Vector3.new(1e6,1e6,1e6);vel.Velocity=Vector3.zero;vel.Parent=r
            local gyro=Instance.new("BodyGyro");gyro.MaxTorque=Vector3.new(1e6,1e6,1e6);gyro.P=20000;gyro.CFrame=r.CFrame;gyro.Parent=r
            C.flight={root=r,hum=h,vel=vel,gyro=gyro,platform=h.PlatformStand};h.PlatformStand=true
        end
        local cam=workspace.CurrentCamera;if not cam then return end
        local move=Vector3.zero
        if not Input:GetFocusedTextBox() then
            local function held(k) return Input:IsKeyDown(k) and 1 or 0 end
            local forward=held(Enum.KeyCode.W)-held(Enum.KeyCode.S)
            local right=held(Enum.KeyCode.D)-held(Enum.KeyCode.A)
            local up=held(Enum.KeyCode.Space)-held(Enum.KeyCode.LeftShift)
            move=cam.CFrame.LookVector*forward+cam.CFrame.RightVector*right+Vector3.new(0,up,0)
            if not Input.KeyboardEnabled then move=h.MoveDirection end
        end
        C.flight.vel.Velocity=move.Magnitude>0 and move.Unit*S.flySpeed or Vector3.zero
        C.flight.gyro.CFrame=cam.CFrame
    end
    local espFolder=Instance.new("Folder");espFolder.Name="NZL_Main_LocalVisuals";espFolder.Parent=workspace
    clearESP=function()
        for _,e in pairs(C.esp) do pcall(function() e.hl:Destroy() e.gui:Destroy() end) end
        C.esp={}
    end
    local function refreshESP()
        if not S.espNPC and not S.espPlayers then clearESP() return end
        local _,_,r=char();if not r then clearESP() return end
        local candidates={}
        local function add(m,color)
            local p=part(m);local h=m and m:FindFirstChildOfClass("Humanoid")
            if p and h and h.Health>0 then
                local d=(p.Position-r.Position).Magnitude
                if d<=S.espRange then candidates[#candidates+1]={model=m,root=p,hum=h,dist=d,color=color} end
            end
        end
        if S.espNPC then for m in pairs(C.npcs) do if m.Parent and not Players:GetPlayerFromCharacter(m) then add(m,Color3.fromRGB(255,195,100)) end end end
        if S.espPlayers then for _,p in ipairs(Players:GetPlayers()) do if p~=LP then add(p.Character,p.TeamColor.Color) end end end
        table.sort(candidates,function(a,b) return a.dist<b.dist end)
        local keep={}
        for i=1,math.min(28,#candidates) do
            local row=candidates[i];local m=row.model;keep[m]=true
            local e=C.esp[m]
            if not e then
                local hl=Instance.new("Highlight");hl.Adornee=m;hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.FillTransparency=0.8;hl.Parent=espFolder
                local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(200,45);gui.StudsOffset=Vector3.new(0,3,0);gui.AlwaysOnTop=true;gui.Parent=espFolder
                local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.Font=Enum.Font.Gotham;text.TextSize=12;text.TextStrokeTransparency=0.4;text.Parent=gui
                e={hl=hl,gui=gui,text=text};C.esp[m]=e
            end
            e.hl.FillColor=row.color;e.hl.OutlineColor=row.color;e.gui.Adornee=row.root;e.text.TextColor3=row.color
            e.text.Text=string.format("%s | %d studs\nHP %d / %d",m.Name,row.dist,row.hum.Health,row.hum.MaxHealth)
        end
        for m,e in pairs(C.esp) do if not keep[m] then e.hl:Destroy();e.gui:Destroy();C.esp[m]=nil end end
    end
    local function register(o)
        if o:IsA("Humanoid") and o.Parent and o.Parent:IsA("Model") then C.npcs[o.Parent]=true end
        if o:IsA("ProximityPrompt") then C.prompts[o]=true end
    end
    connect(workspace.DescendantAdded,register)
    connect(workspace.DescendantRemoving,function(o)
        if o:IsA("Model") then C.npcs[o]=nil end
        if o:IsA("ProximityPrompt") then C.prompts[o]=nil end
    end)
    task.spawn(function()
        for i,o in ipairs(workspace:GetDescendants()) do
            if not S.alive then break end
            register(o)
            if i%400==0 then task.wait() end
        end
    end)

    local shopDropdown
    local function refreshShop()
        C.shopCards={}
        local gui=LP:FindFirstChild("PlayerGui")
        local shop=gui and gui:FindFirstChild("DarkHazardItemShop")
        local items={}
        if shop then
            for _,o in ipairs(shop:GetDescendants()) do
                local name=o:GetAttribute("ShopItemName")
                if o:IsA("GuiObject") and type(name)=="string" and o:FindFirstChild("BuyButton") then
                    if not C.shopCards[name] then items[#items+1]=name C.shopCards[name]=o end
                end
            end
        end
        table.sort(items)
        if #items==0 then items={"No loaded shop cards"} end
        if shopDropdown then shopDropdown:Refresh(items);shopDropdown:Set(items[1],true) end
        S.selectedShop=items[1]
        return #items
    end
    local function purchase()
        local card=C.shopCards[S.selectedShop]
        if not card or not card.Parent then return false,"Refresh shop items first" end
        local button=card:FindFirstChild("BuyButton")
        if not button or button:GetAttribute("ShopAvailable")~=true then return false,"Native shop marks item unavailable" end
        local kind=card:GetAttribute("ShopKind")
        if kind=="Broom" then return send("Broom","Purchase") end
        if kind=="Hat" then return send("Shop","PurchaseHat") end
        if kind=="Cape" then return send("Shop","PurchaseCape") end
        return send("Shop","Purchase",card:GetAttribute("ShopItemName"))
    end
    local function watchRemotes()
        local function attach(remote)
            if not remote or not remote:IsA("RemoteEvent") or C.watched[remote] then return end
            C.watched[remote]=true
            connect(remote.OnClientEvent,function(...)
                local args=table.pack(...);local bits={}
                for i=1,math.min(args.n,4) do bits[#bits+1]=short(args[i],120) end
                S.lastReply=remote.Name..": "..table.concat(bits," | ");log("server reply",S.lastReply)
                if (remote.Name=="CombatEvent" or remote.Name=="BlockEvent") and args[1]=="NoStamina" then
                    C.staminaRest=true;C.restUntil=os.clock()+2
                end
                local qr=remote.Name=="QuestRemote" and "Quest" or (remote.Name=="HunterQuestRemote" and "HunterQuest" or nil)
                if qr and args[1]=="Tracker" then
                    C.hunts[qr]={active=args[2]==true,progress=args[3],required=args[4],turnIn=args[5]==true}
                    S.target=nil;C.progress=nil
                end
                if qr and args[1]=="MissionChoice" and S.autoQuest and qr==huntRoute() and not questBusy() and os.clock()-(C.lastQuestChoose or -100)>=5 then
                    C.lastQuestChoose=os.clock();local token=S.token
                    task.delay(0.25,function()
                        if S.alive and S.autoQuest and S.token==token and qr==huntRoute() and not questBusy() then send(qr,"ChooseKill") end
                    end)
                end
                if remote.Name=="HumanSideQuestRemote" and args[1]=="Offer" and S.autoOffer and team()=="Humans" and not questBusy() then
                    local token=S.token
                    task.delay(0.2,function() if S.alive and S.autoOffer and S.token==token and not questBusy() then send("HumanSideQuest","AcceptOffer") end end)
                end
            end)
        end
        attach(at(RS,{"ArczisCombat","Remotes","CombatEvent"}))
        for _,p in pairs(routes) do attach(at(RS,p)) end
        local events=at(RS,{"Funções","Eventos"})
        if events then
            for _,name in ipairs({"BreakNeckRemote","BloodDrinkRemote","InfectRemote","HeartRippingRemote","HypnosisRemote","WitchLifeDrainRemote","WitchBreakNeckRemote","WitchHeartRippingRemote","WitchPetrificationRemote","WitchInvisibleRemote","IncendiaRemote","MoneyRewardPopupRemote"}) do attach(events:FindFirstChild(name)) end
        end
    end
    syncToggles=function()
        for key,obj in pairs(C.toggleRefs) do pcall(function() obj:Set(S[key],true) end) end
    end
    stopAll=function(reason)
        S.token=S.token+1
        for _,key in ipairs({"autoM1","autoWalk","autoSkill","autoFarm","hover","autoQuest","autoPaper","autoOffer","espNPC","espPlayers","noclip","speed","fly","infJump","faceTarget"}) do S[key]=false end
        C.questGoal=nil;C.questFarming=false;C.progress=nil
        cancelTravel();stopFly();releaseHover();restoreCollision();restoreSpeed();clearESP();stopPain()
        if C.blockOwned then C.remoteTimes.Block=nil;send("Block",false);C.blockOwned=false end
        if C.sleepOwned then C.remoteTimes.Sleep=nil;send("Sleep","Detach");C.sleepOwned=false end
        if C.holdingPrompt then pcall(function() C.holdingPrompt:InputHoldEnd() end) C.holdingPrompt=nil end
        local _,h,r=char();if h and r then pcall(function() h:MoveTo(r.Position) end) end
        S.target=nil;S.status="Stopped: "..(reason or "user");S.lastAction=S.status
        syncToggles();log("stop",S.status);C.stopCount=C.stopCount+1
    end
    unload=function()
        if not S.alive then return end
        stopAll("unload");S.alive=false
        for _,c in ipairs(C.connections) do pcall(function() c:Disconnect() end) end
        pcall(function() espFolder:Destroy() end)
        if Env.NZLMainHub and Env.NZLMainHub.State==S then Env.NZLMainHub=nil end
    end
    Env.NZLMainHub={Stop=unload,State=S}
    local oldUnload=Lumen.Unload
    function Lumen:Unload() unload() return oldUnload(self) end
    connect(LP.CharacterRemoving,function() stopAll("respawn") end)
    connect(LP:GetPropertyChangedSignal("Team"),function() stopAll("team change") end)
    connect(Input.InputBegan,function(input,processed)
        if not processed and input.KeyCode==Enum.KeyCode.End then stopAll("End key") note("All hub actions stopped") end
    end)
    connect(Input.JumpRequest,function()
        if S.infJump then local _,h=char();if h and h.Health>0 then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    end)
    local accumulator=0
    connect(Run.Heartbeat,function(dt)
        flightStep()
        hoverStep(dt)
        accumulator=accumulator+dt;if accumulator<0.1 then return end;accumulator=0
        local c,h=char()
        if (S.noclip or C.hoverActive) and c then
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then if C.collision[p]==nil then C.collision[p]=p.CanCollide end p.CanCollide=false end
            end
        elseif next(C.collision) then restoreCollision() end
        if S.speed and h then
            if C.speedHum~=h then restoreSpeed();C.speedHum=h;C.originalSpeed=h.WalkSpeed end
            h.WalkSpeed=S.walkSpeed
        elseif C.speedHum then restoreSpeed() end
    end)

    local function attrs(o)
        local t={};if not o then return t end
        for k,v in pairs(o:GetAttributes()) do t[k]=(type(v)=="string" or type(v)=="number" or type(v)=="boolean") and v or tostring(v) end
        return t
    end
    local function report()
        local c=LP.Character;local available={}
        for k,p in pairs(routes) do local o=at(RS,p);available[k]=o and o.ClassName or "missing" end
        local flags={};for k,v in pairs(S) do if type(v)=="boolean" or type(v)=="number" or type(v)=="string" then flags[k]=v end end
        return Http:JSONEncode({format="NZL Main Hub 1.1",placeId=game.PlaceId,placeVersion=game.PlaceVersion,
            timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),team=team(),playerAttributes=attrs(LP),characterAttributes=attrs(c),
            target=S.target and S.target:GetFullName() or "none",routes=available,state=flags,log=C.logs,
            hunts=C.hunts,recovery={stamina=C.staminaRest==true,health=C.healthRest==true},
            warning="Local report. Requests sent do not imply server acceptance. Review before sharing."})
    end
    local copyFrame
    local function manualCopy(text)
        if copyFrame then copyFrame:Destroy() end
        local f=Instance.new("Frame");copyFrame=f;f.Size=UDim2.fromScale(0.85,0.65);f.Position=UDim2.fromScale(0.075,0.15);f.BackgroundColor3=Color3.fromRGB(20,22,28);f.ZIndex=300;f.Parent=Lumen.State.Screen
        local b=Instance.new("TextBox");b.Size=UDim2.new(1,-20,1,-60);b.Position=UDim2.fromOffset(10,10);b.Text=text;b.ClearTextOnFocus=false;b.MultiLine=true;b.TextSize=12;b.Font=Enum.Font.Code;b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(12,14,18);b.TextXAlignment=Enum.TextXAlignment.Left;b.TextYAlignment=Enum.TextYAlignment.Top;b.ZIndex=301;b.Parent=f
        local close=Instance.new("TextButton");close.Size=UDim2.fromOffset(130,30);close.Position=UDim2.new(1,-140,1,-40);close.Text="Close";close.ZIndex=301;close.Parent=f
        connect(close.Activated,function() f:Destroy();copyFrame=nil end)
        local select=Instance.new("TextButton");select.Size=UDim2.fromOffset(180,30);select.Position=UDim2.new(0,10,1,-40);select.Text="Select all, then Ctrl+C";select.ZIndex=301;select.Parent=f
        connect(select.Activated,function() b:CaptureFocus();b.CursorPosition=#b.Text+1;b.SelectionStart=1 end)
    end
    local function copyReport()
        local text=report();local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then local ok=pcall(fn,text);if ok then note("Diagnostic report sent to clipboard") return end end
        manualCopy(text)
    end

    Lumen.Folder="nzl_main_hub";Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="NZL Main | Dark Hazard",Version="1.1 / farm + hover",Footer="RightCtrl menu | End STOP | all automation OFF",Size=UDim2.fromOffset(840,610),Keybind=Enum.KeyCode.RightControl,SettingsPage=false})
    local function page(name,group) return window:Page({Name=name,Columns=2,Group=group}) end
    local function sec(p,name,side) return p:Section({Name=name,Side=side or 1}) end
    local function button(s,name,fn,confirm)
        return s:Button({Name=name,Confirm=confirm or false,Callback=function()
            local ok,err=pcall(fn);if not ok then log("button error",err);note("Action error: "..short(err,160)) end
        end})
    end
    local function toggle(s,name,key,callback)
        local obj=s:Toggle({Name=name,Flag="dh_"..key,Default=false,Callback=function(v)
            S[key]=v==true
            if callback then callback(S[key]) end
        end})
        C.toggleRefs[key]=obj;return obj
    end
    local function slider(s,name,key,min,max,default,decimals)
        s:Slider({Name=name,Flag="dh_"..key,Min=min,Max=max,Default=default,Decimals=decimals or 0,Callback=function(v) S[key]=v end})
    end
    local home=page("dashboard","main")
    local stateSec=sec(home,"live status")
    statusLabel=stateSec:Label("Ready; reading game state...")
    resourceLabel=stateSec:Label("Resources: -")
    targetLabel=stateSec:Label("Target: none")
    actionLabel=stateSec:Label("Last action: idle")
    replyLabel=stateSec:Label("Server: no reply")
    button(stateSec,"STOP ALL (End)",function() stopAll("button");note("All hub actions stopped") end)
    button(stateSec,"Unload hub",function() Lumen:Unload() end,true)
    local info=sec(home,"read first",2)
    info:Label("For place 122287678911982, dump version 2812.")
    info:Label("All loops start OFF. No config autoload.")
    info:Label("M1 uses the native Fists tool controller.")
    info:Label("Requests are NOT proof of server acceptance.")
    info:Label("Move/flight may be corrected by the server.")
    info:Label("Respawn or team change stops all automation.")
    info:Label("No admin, currency or level remotes used.")

    local combat=page("combat / farm","main")
    local targeting=sec(combat,"target selection")
    targeting:Dropdown({Name="NPC group",Items={"Hunters","Humans","Guards","All NPCs"},Default="Hunters",Flag="dh_group",Callback=function(v) S.targetGroup=v;S.target=nil end})
    targeting:Textbox({Name="Name contains",Default="",Flag="dh_name",Callback=function(v) S.targetName=tostring(v);S.target=nil end})
    slider(targeting,"Search radius", "searchRange",10,1000,120)
    toggle(targeting,"Include player targets (opt-in)","allowPlayers",function() S.target=nil end)
    button(targeting,"Select nearest valid target",function() S.target=findTarget();note(S.target and ("Target: "..S.target.Name) or "No loaded target in range") end)
    toggle(targeting,"Face target when attacking","faceTarget")
    local farm=sec(combat,"native combat",2)
    button(farm,"Equip Fists",function() local ok,why=equipFists();note(ok and (why or "Fists equipped") or why) end)
    button(farm,"M1 once",function() local ok,why=punch();note(ok and "Fists activated" or why) end)
    toggle(farm,"Auto M1","autoM1")
    toggle(farm,"Walk toward current target","autoWalk",function(v)
        if v then
            S.autoFarm=false;S.hover=false;S.autoQuest=false;C.questGoal=nil;C.questFarming=false
            S.token=S.token+1;releaseHover();cancelTravel();syncToggles()
        end
    end)
    slider(farm,"Attack interval (seconds)","attackDelay",0.6,2,0.65,2)
    slider(farm,"M1 activation distance","hitRange",3,8,7)
    button(farm,"Block ON",function() local ok,why=send("Block",true);if ok then C.blockOwned=true end tell(ok,why) end)
    button(farm,"Block OFF",function() C.blockOwned=false;tell(send("Block",false)) end)
    farm:Label("Walking is MoveTo, not obstacle pathfinding.")
    farm:Label("Native cooldown/stamina/state checks still apply.")

    local auto=page("auto farm / hover","main")
    local af=sec(auto,"NPC farming")
    toggle(af,"AUTO FARM NPC + HOVER","autoFarm",function(v)
        S.target=nil;C.progress=nil;C.avoid=setmetatable({}, {__mode="k"})
        if v then
            S.token=S.token+1;S.autoQuest=false;S.hover=false;C.questGoal=nil;C.questFarming=false
            S.fly=false;stopFly();cancelTravel();S.autoWalk=false;S.faceTarget=true
            S.allowPlayers=false;S.autoM1=false
            note("NPC farm armed. Choose group on combat page. Hover is NOT invulnerability.")
        elseif not S.hover and not S.autoQuest then releaseHover() end
        syncToggles()
    end)
    toggle(af,"Hover selected NPC (without auto M1)","hover",function(v)
        if v then
            S.token=S.token+1;S.autoQuest=false;S.autoFarm=false;S.autoM1=false
            C.questGoal=nil;C.questFarming=false
            S.fly=false;stopFly();cancelTravel();S.autoWalk=false
        elseif not farmActive() then releaseHover() end
        syncToggles()
    end)
    slider(af,"Hover height (studs)","hoverHeight",2,20,4,1)
    slider(af,"Horizontal offset (studs)","hoverBack",0,6,2,1)
    slider(af,"Approach / hover speed","hoverSpeed",10,100,40)
    slider(af,"Recovery height","restHeight",5,30,12)
    slider(af,"Skip no-damage target after (s)","stallTimeout",8,60,20)
    af:Label("High hover can put M1 outside its hitbox.")
    af:Label("Farm never selects players; next NPC is automatic.")
    local regen=sec(auto,"stamina / health recovery",2)
    slider(regen,"Pause below stamina","staminaLow",15,60,20)
    slider(regen,"Resume at stamina","staminaResume",20,100,45)
    slider(regen,"Retreat at HP %","healthLow",5,45,25)
    slider(regen,"Resume at HP %","healthResume",50,95,60)
    regen:Label("Stamina/HP are READ, never forged or refilled.")
    regen:Label("Recovery pauses attacks and raises hover height.")
    regen:Label("Hover does not block server damage.")
    regen:Label("If no regen occurs, recovery keeps waiting.")
    button(regen,"STOP FARM / QUEST / MOVEMENT",function() stopAll("farm stop") end)

    local powers=page("abilities","main")
    local vamp=sec(powers,"vampire")
    vamp:Dropdown({Name="Ability",Items={"BloodDrink","BreakNeck","Infect","HeartRipping","Hypnosis"},Default="BloodDrink",Flag="dh_skill",Callback=function(v) S.vampireSkill=v end})
    skillLabel=vamp:Label("Ability ready (local cooldown estimate)")
    button(vamp,"Cast selected on current target",function() tell(castVampire(S.vampireSkill)) end)
    toggle(vamp,"Auto selected ability","autoSkill")
    button(vamp,"Track (native request)",function()
        if not vampire() then note("Vampire team required") return end
        if (C.cooldowns.Track or 0)>os.clock() then note("Local cooldown") return end
        local ok,why=send("Track","UI");if ok then C.cooldowns.Track=os.clock()+23 end;tell(ok,why)
    end)
    button(vamp,"Ceiling sleep / detach",function() tell(toggleSleep()) end)
    button(vamp,"End hypnosis control",function() tell(send("HypnosisEnd","EndControl")) end)
    vamp:Label("BatForm omitted: Enabled=false in dumped config.")
    vamp:Label("Hypnosis selection uses the game's command UI.")
    local witch=sec(powers,"witch (native targeting)",2)
    for _,entry in ipairs({{"Life Drain","WitchLifeDrain"},{"Break Neck","WitchBreakNeck"},{"Heart Ripping","WitchHeartRipping"},{"Petrification","WitchPetrification"},{"Invisibility","WitchInvisible"}}) do
        local key=entry[2];button(witch,entry[1],function() tell(castWitch(key)) end)
    end
    button(witch,"Pain Infliction on current target",function() tell(pain()) end)
    button(witch,"Stop Pain Infliction",function() stopPain();note("Stop requested if started by hub") end)
    button(witch,"Strength: begin native selection",function()
        if team()~="Witches" or years()<25 then note("Witches / Years 25 required") return end
        local ok,why=usable();if not ok then note(why) return end
        tell(send("Strength","Begin"))
    end)
    witch:Label("Strength: select target in native UI afterwards.")
    witch:Label("Incendia: use native aim UI; no guessed payload.")

    local quests=page("quests","main")
    local aq=sec(quests,"auto hunt quest loop")
    aq:Dropdown({Name="Hunt quest",Items={"Hunter hunt","Human hunt"},Default="Hunter hunt",Flag="dh_auto_quest_mode",Callback=function(v)
        S.questMode=v;S.target=nil;C.questFarming=false;C.questGoal=nil;S.token=S.token+1
    end})
    toggle(aq,"AUTO QUEST + NPC FARM","autoQuest",function(v)
        S.token=S.token+1;S.target=nil;C.progress=nil;C.questGoal=nil;C.questFarming=false
        if v then
            S.autoFarm=false;S.hover=false
            S.fly=false;stopFly();cancelTravel();S.autoWalk=false;S.autoM1=false
            S.allowPlayers=false;S.autoPaper=false;S.autoOffer=false;S.faceTarget=true
            note("Hunt loop: NPC dialogue -> ChooseKill -> Tracker -> farm -> return to NPC.")
        elseif not (S.autoFarm or S.hover) then releaseHover() end
        syncToggles()
    end)
    toggle(aq,"Use executor prompt helper","executorPrompts")
    aq:Label("Hunter hunt: NPCQuest2 / Hunter models.")
    aq:Label("Human hunt: NPCQuest / Humans in CIDADE2.")
    aq:Label("Completion comes from SERVER Tracker events.")
    local q=sec(quests,"quest state / interaction")
    questLabel=q:Label("Quest state: -");questDetailLabel=q:Label("Progress: -")
    button(q,"Activate nearest enabled prompt",function() tell(usePrompt()) end)
    button(q,"Accept nearest Quest2 offer",function() tell(acceptPaper()) end)
    toggle(q,"Auto accept nearby Quest2 offer","autoPaper")
    toggle(q,"Auto accept incoming Human offer","autoOffer")
    q:Label("Offers must be loaded and in native range.")
    q:Label("No fake progress or reward-completion requests.")
    local dialog=sec(quests,"native dialogue choices",2)
    button(dialog,"Quest: choose kill",function() tell(send("Quest","ChooseKill")) end)
    button(dialog,"Quest: choose delivery",function() tell(send("Quest","ChooseDelivery")) end)
    button(dialog,"Hunter: choose kill",function() tell(send("HunterQuest","ChooseKill")) end)
    button(dialog,"Hunter: choose delivery",function() tell(send("HunterQuest","ChooseDelivery")) end)
    button(dialog,"Human: accept offer",function() tell(send("HumanSideQuest","AcceptOffer")) end)
    button(dialog,"Human: decline offer",function() tell(send("HumanSideQuest","DeclineOffer")) end)
    dialog:Label("Talk to the corresponding NPC first.")
    dialog:Label("Delivery/flowers still use game interactions.")

    local visual=page("ESP","utilities")
    local vs=sec(visual,"local visuals")
    toggle(vs,"NPC ESP","espNPC")
    toggle(vs,"Player ESP","espPlayers")
    slider(vs,"ESP distance","espRange",50,3000,500)
    button(vs,"Clear ESP",function() S.espNPC=false;S.espPlayers=false;syncToggles();clearESP() end)
    local vi=sec(visual,"limits",2)
    vi:Label("Highlight + name / HP / distance.")
    vi:Label("28 nearest entities, refreshed every second.")
    vi:Label("Only streamed, client-visible entities exist.")
    vi:Label("No CoreGui/Drawing dependency.")

    local movement=page("movement","utilities")
    local ms=sec(movement,"local movement")
    toggle(ms,"WalkSpeed override","speed",function(v) if not v then restoreSpeed() end end)
    slider(ms,"WalkSpeed","walkSpeed",16,100,28)
    toggle(ms,"Noclip","noclip",function(v) if not v and not C.hoverActive then restoreCollision() end end)
    toggle(ms,"Infinite jump","infJump")
    toggle(ms,"Fly (WASD / Space / Shift)","fly",function(v) if not v then stopFly() else
        S.autoFarm=false;S.hover=false;S.autoQuest=false;C.questGoal=nil;C.questFarming=false
        S.token=S.token+1;releaseHover();cancelTravel();syncToggles()
    end end)
    slider(ms,"Fly speed","flySpeed",10,150,45)
    ms:Label("Mobile fly uses the movement stick; no vertical UI.")
    local travel=sec(movement,"loaded landmarks",2)
    travel:Dropdown({Name="Destination",Items={"Quest NPC","Quest NPC 2","Delivery point","Quest papers","Hunter area","Humans","Lockpick","Current target","Nearest prompt","Nearest quest paper"},Default="Quest NPC",Flag="dh_landmark",Callback=function(v) S.selectedLandmark=v end})
    slider(travel,"Tween travel speed","travelSpeed",10,150,45)
    button(travel,"Travel (local tween, experimental)",function()
        if S.fly then note("Disable Fly first") return end
        local p=landmarkPart();if not p then note("Destination not loaded") return end
        travelTo(p.Position+Vector3.new(0,3,4))
    end)
    button(travel,"Cancel travel",cancelTravel)
    travel:Label("No fixed-map coordinates are fabricated.")
    travel:Label("Server may reject or correct movement.")

    local shop=page("shop / inventory","utilities")
    local ss=sec(shop,"native shop cards")
    shopDropdown=ss:Dropdown({Name="Item",Items={"Refresh items first"},Default="Refresh items first",Flag="dh_shop",Callback=function(v) S.selectedShop=v end})
    button(ss,"Refresh loaded shop items",function() refreshShop();note("Loaded native shop cards refreshed") end)
    button(ss,"BUY selected (spends game currency)",function() tell(purchase()) end,true)
    ss:Label("Requires ShopAvailable=true in native UI.")
    ss:Label("No automatic purchases; no guessed prices.")
    local inv=sec(shop,"inventory",2)
    button(inv,"List current tools",function()
        local names={};local c=LP.Character
        for _,root in pairs({backpack=LP:FindFirstChild("Backpack"),character=c}) do
            if root then for _,o in ipairs(root:GetChildren()) do if o:IsA("Tool") then names[#names+1]=o.Name end end end
        end
        note(#names>0 and table.concat(names,", ") or "No tools loaded")
    end)
    button(inv,"Unequip tools",function() local _,h=char();if h then h:UnequipTools() end end)
    inv:Label("Purchases may need NPC proximity / money.")
    inv:Label("Sent is not the same as purchased.")

    local debugPage=page("diagnostics","system")
    local ds=sec(debugPage,"report / lifecycle")
    button(ds,"COPY diagnostic report",copyReport)
    button(ds,"Save diagnostic JSON",function()
        if type(writefile)~="function" then note("writefile unavailable; use Copy") return end
        local name="NZL_Main_"..os.date("!%Y%m%d_%H%M%S")..".json"
        writefile(name,report());note("Saved: "..name)
    end)
    button(ds,"Clear log",function() C.logs={};note("Log cleared") end)
    button(ds,"Refresh remote listeners",function() watchRemotes();note("Available remotes checked") end)
    button(ds,"STOP ALL",function() stopAll("diagnostic stop") end)
    local limits=sec(debugPage,"known limits",2)
    limits:Label("Integration based on dump, not live-tested here.")
    limits:Label("Cooldown estimates are local and conservative.")
    limits:Label("No server code or server bypass is included.")
    limits:Label("Two witch UI dumps had decompiler errors.")
    limits:Label("No module require / external download used.")
    limits:Label("Reports may contain private attributes/logs.")

    task.spawn(function()
        local tick=0
        while S.alive do
            task.wait(0.2)
            if not S.alive then break end
            local ok,err=pcall(function()
                tick=tick+1
                if S.autoQuest then questStep() else C.questGoal=nil;C.questFarming=false end
                local farmNow=farmActive()
                local combatAllowed=not S.autoQuest or C.questFarming
                if combatAllowed and (S.autoM1 or S.autoWalk or S.autoSkill or farmNow) then
                    local m=target()
                    if m then
                        if S.autoWalk and not S.fly and not C.travel and not C.hoverActive then
                            local good=usable();local _,h,r=char();local p=part(m)
                            if good and h and r and p and (p.Position-r.Position).Magnitude>4.5 and tick%3==0 then
                                local away=r.Position-p.Position
                                local goal=p.Position+(away.Magnitude>0 and away.Unit*4 or Vector3.new(0,0,4))
                                h:MoveTo(goal)
                            end
                        end
                        local resting,restReason=recovery()
                        if resting then
                            S.status=restReason;C.progress=nil
                        else
                            if S.autoM1 or farmNow then
                                local sent,why=punch();S.status=sent and "M1 activated" or why
                                local h=m:FindFirstChildOfClass("Humanoid")
                                if farmNow and h and inRange(m,S.hitRange) then
                                    if not C.progress or C.progress.target~=m or h.Health<C.progress.hp then
                                        C.progress={target=m,hp=h.Health,at=os.clock()}
                                    elseif os.clock()-C.progress.at>S.stallTimeout then
                                        C.avoid[m]=os.clock()+30;S.target=nil;C.progress=nil
                                        S.status="Skipped no-damage NPC for 30s; check hover height"
                                        log("farm",S.status)
                                    end
                                else C.progress=nil end
                            end
                            if S.autoSkill and tick%5==0 then local sent,why=castVampire(S.vampireSkill);S.status=sent and "Ability requested" or why end
                        end
                    else S.status="No loaded target matching filters" end
                end
                if S.autoPaper and not S.autoQuest and tick%10==0 then local sent,why=acceptPaper();S.status=sent and "Quest acceptance requested" or why end
                if tick%5==0 then
                    refreshESP()
                    local c,h,r=char();local m=S.target;local p=part(m)
                    statusLabel:SetText("Team: "..team().." | Years: "..years().." | "..short(S.status,45))
                    resourceLabel:SetText("HP "..(h and math.floor(h.Health) or "-").." | Stamina "..tostring(LP:GetAttribute("Stamina") or "-").." | Mana "..tostring(LP:GetAttribute("Mana") or "-").." | Blood "..tostring(LP:GetAttribute("BloodThirst") or "-"))
                    targetLabel:SetText(m and p and r and ("Target: "..m.Name.." | "..math.floor((p.Position-r.Position).Magnitude).." studs") or "Target: none")
                    actionLabel:SetText(short(S.lastAction,85));replyLabel:SetText(short(S.lastReply,85))
                    questLabel:SetText("Quest: "..tostring(LP:GetAttribute("QuestActive") or false).." | Quest2: "..tostring(LP:GetAttribute("Quest2Active") or false).." | Human: "..tostring(LP:GetAttribute("HumanSideQuestActive") or false))
                    local hunt=C.hunts[huntRoute()]
                    if S.autoQuest and hunt then
                        questDetailLabel:SetText(S.questMode.." | "..tostring(hunt.progress or "-").."/"..tostring(hunt.required or "-")..(hunt.turnIn and " | RETURN TO NPC" or ""))
                    else
                        questDetailLabel:SetText(short(LP:GetAttribute("Quest2Title") or LP:GetAttribute("HumanSideQuestStage") or "No Quest2/Human state",45).." | "..tostring(LP:GetAttribute("Quest2Progress") or "-").."/"..tostring(LP:GetAttribute("Quest2Required") or "-"))
                    end
                    skillLabel:SetText(S.vampireSkill.." | local cooldown "..math.ceil(math.max(0,(C.cooldowns[S.vampireSkill] or 0)-os.clock())).."s")
                end
                if tick%25==0 then watchRemotes() end
            end)
            if not ok then
                log("loop error",err);stopAll("loop error");note("Automation stopped; copy diagnostics: "..short(err,120))
            end
        end
    end)
    watchRemotes()
    note("Main Hub ready. All automation OFF. RightCtrl: menu. End: STOP.")
end
StartMainHub(Lumen)
