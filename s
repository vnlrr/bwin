-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Bwin v2 — Premium Drawing-Based GUI Library                    ║
-- ║  Ground-up rewrite. Immediate-mode pooled rendering.            ║
-- ╚══════════════════════════════════════════════════════════════════╝

local LIB_NAME = "Bwin"
local LIB_VER  = "2.0.0"

-- ═══════════════════════ ENVIRONMENT BOOTSTRAP ═══════════════════════
local env = nil
pcall(function() env = (getfenv and getfenv()) or _G end)
if type(env) ~= "table" then env = {} end

local shared = type(shared) == "table" and shared or {}

local function hostFn(name, fallback)
    local f = env[name]
    if type(f) ~= "function" then pcall(function() f = _G[name] end) end
    if type(f) ~= "function" then pcall(function() f = shared[name] end) end
    if type(f) ~= "function" then return fallback or function() end end
    return f
end

local iskeypressed   = hostFn("iskeypressed",    function() return false end)
local ismouse1       = hostFn("ismouse1pressed",  function() return false end)
local ismouse2       = hostFn("ismouse2pressed",  function() return false end)
local isrbxactive    = hostFn("isrbxactive",      function() return true end)
local setrobloxinput = hostFn("setrobloxinput",   function() end)
local setclipboard   = hostFn("setclipboard",     function() end)
local getclipboard   = hostFn("getclipboard")
local writefile      = hostFn("writefile")
local readfile       = hostFn("readfile")
local isfile         = hostFn("isfile",    function() return false end)
local isfolder       = hostFn("isfolder",  function() return false end)
local makefolder     = hostFn("makefolder")
local delfile        = hostFn("delfile")
local listfiles      = hostFn("listfiles", function() return {} end)

local clock = os and os.clock
if type(clock) ~= "function" then clock = hostFn("tick", function() return 0 end) end

local Color3  = Color3
local Vector2 = Vector2
local v2      = Vector2.new
local c3      = Color3.fromRGB
local hsv
pcall(function() hsv = Color3.fromHSV end)
if type(hsv) ~= "function" then hsv = function() return c3(255, 255, 255) end end

local HttpService
pcall(function() HttpService = game:GetService("HttpService") end)
local function jsonEncode(t) local ok, r = pcall(function() return HttpService:JSONEncode(t) end); return ok and r or nil end
local function jsonDecode(s) local ok, r = pcall(function() return HttpService:JSONDecode(s) end); return ok and r or nil end

local Players, LocalPlayer, Mouse
pcall(function() Players = game:GetService("Players") end)

-- ═══════════════════════ MATH / COLOR / TEXT UTILITIES ═══════════════════════
local floor, abs, min, max, sin, cos, sqrt, pi = math.floor, math.abs, math.min, math.max, math.sin, math.cos, math.sqrt, math.pi
local remove, concat, insert = table.remove, table.concat, table.insert

local function clamp(v, lo, hi) if v < lo then return lo elseif v > hi then return hi end return v end
local function lerp(a, b, t) return a + (b - a) * t end
local function lerpColor(a, b, t) return Color3.new(lerp(a.R, b.R, t), lerp(a.G, b.G, t), lerp(a.B, b.B, t)) end
local function boolv(v) return v == true end

local function approach(cur, tgt, speed, dt)
    if not cur then return tgt end
    dt = dt or (1/60)
    if dt <= 0 then dt = 1/60 end
    return cur + (tgt - cur) * (1 - math.exp(-(speed or 15) * dt))
end

local function rgbToHsv(c)
    local r, g, b = c.R, c.G, c.B
    local hi, lo = max(r, g, b), min(r, g, b)
    local d = hi - lo
    local h, s = 0, (hi > 0 and d / hi or 0)
    if d > 0 then
        if hi == r then h = ((g - b) / d) % 6
        elseif hi == g then h = ((b - r) / d) + 2
        else h = ((r - g) / d) + 4 end
        h = h / 6
    end
    return h, s, hi
end

local function toHex(color)
    local function b(v) return string.format("%02X", floor(clamp(v, 0, 1) * 255 + 0.5)) end
    return "#" .. b(color.R) .. b(color.G) .. b(color.B)
end

local function parseHex(str)
    str = string.gsub(tostring(str or ""), "[^0-9a-fA-F]", "")
    if #str == 3 then str = str:gsub("(.)", "%1%1") end
    if #str < 6 then return nil end
    local r = tonumber(string.sub(str, 1, 2), 16)
    local g = tonumber(string.sub(str, 3, 4), 16)
    local bl = tonumber(string.sub(str, 5, 6), 16)
    if not (r and g and bl) then return nil end
    return c3(r, g, bl)
end

local function copyArray(src)
    local out = {}
    if type(src) == "table" then for i = 1, #src do out[i] = src[i] end
    elseif src ~= nil then out[1] = src end
    return out
end

local function colorChanged(a, b)
    if not a or not b then return a ~= b end
    return abs(a.R - b.R) > 0.001 or abs(a.G - b.G) > 0.001 or abs(a.B - b.B) > 0.001
end

local KEY_ALIASES = {
    rightshift = "rshift", leftshift = "lshift", rightcontrol = "rctrl", leftcontrol = "lctrl",
    rightctrl = "rctrl", leftctrl = "lctrl", rightalt = "ralt", leftalt = "lalt",
    control = "ctrl", ["return"] = "enter", escape = "esc", del = "delete",
    backquote = "tilde", grave = "tilde", equals = "plus", equal = "plus",
    leftbracket = "lbracket", rightbracket = "rbracket",
    mousebutton3 = "mb3", middlemouse = "mb3", mmb = "mb3", m3 = "mb3",
    mousebutton4 = "mb4", mouse4 = "mb4", xbutton1 = "mb4", m4 = "mb4",
    mousebutton5 = "mb5", mouse5 = "mb5", xbutton2 = "mb5", m5 = "mb5",
}

local function normalizeKey(v)
    if v == nil then return nil end
    v = string.lower(tostring(v)):gsub("%s+", "")
    if v == "" or v == "-" or v == "none" or v == "nil" or v == "unbound" then return nil end
    return KEY_ALIASES[v] or v
end

local function normalizeMode(v)
    if v == "Toggle" or v == "Always" then return v end
    return "Hold"
end

local function parseCombo(str)
    if type(str) == "string" then
        local p = string.find(str, "+", 1, true)
        if p then return string.sub(str, 1, p - 1), string.sub(str, p + 1) end
        return nil, str
    end
    return nil, nil
end

-- ═══════════════════════ FONTS ═══════════════════════
local Fonts = (Drawing and Drawing.Fonts) or {}
local FontSystem = Fonts.System or 0
local FontBold   = Fonts.SystemBold or FontSystem
local FontUI     = Fonts.UI or FontSystem
local FontMono   = Fonts.Monospace or 0
local FontWidths = {
    [FontSystem] = 0.48, [FontBold] = 0.52, [FontUI] = 0.50, [FontMono] = 0.60,
}

local function textWidth(value, size, font)
    return #tostring(value or "") * ((size or 13) * (FontWidths[font] or 0.48))
end

local function trimText(value, maxW, size, font)
    value = tostring(value or "")
    local maxChars = floor(maxW / ((size or 13) * (FontWidths[font] or 0.48)))
    if #value <= maxChars then return value end
    if maxChars <= 2 then return "" end
    return string.sub(value, 1, maxChars - 2) .. ".."
end

local function wrapLines(value, maxW, size, font)
    value = tostring(value or "")
    local m = FontWidths[font] or 0.48
    local maxChars = max(1, floor(maxW / ((size or 13) * m)))
    local lines, cur = {}, ""
    for word in string.gmatch(value, "%S+") do
        local cand = (cur == "") and word or (cur .. " " .. word)
        if #cand <= maxChars then cur = cand
        else
            if cur ~= "" then lines[#lines + 1] = cur end
            if #word > maxChars then
                while #word > maxChars do lines[#lines + 1] = string.sub(word, 1, maxChars); word = string.sub(word, maxChars + 1) end
                cur = word
            else cur = word end
        end
    end
    if cur ~= "" then lines[#lines + 1] = cur end
    if #lines == 0 then lines[1] = "" end
    return lines
end

local function textTop(y, h, size) return floor(y + (h - (size or 13)) / 2 + 0.5) end

-- ═══════════════════════ INPUT SYSTEM ═══════════════════════
local Input, InputOrder = {}, {}

local function addInput(name, id, char, shifted)
    name = string.lower(tostring(name))
    if not Input[name] then InputOrder[#InputOrder + 1] = name end
    Input[name] = { id = id, held = false, click = false, released = false, char = char, shifted = shifted }
end

addInput("m1", 0x01); addInput("m2", 0x02)
addInput("mb3", 0x04); addInput("mb4", 0x05); addInput("mb5", 0x06)
addInput("backspace", 0x08); addInput("tab", 0x09); addInput("enter", 0x0D)
addInput("shift", 0x10); addInput("ctrl", 0x11); addInput("alt", 0x12)
addInput("esc", 0x1B); addInput("space", 0x20, " ", " ")
addInput("pageup", 0x21); addInput("pagedown", 0x22); addInput("end", 0x23); addInput("home", 0x24)
addInput("left", 0x25); addInput("up", 0x26); addInput("right", 0x27); addInput("down", 0x28)
addInput("insert", 0x2D); addInput("delete", 0x2E)

local shiftedDigits = {")", "!", "@", "#", "$", "%", "^", "&", "*", "("}
for i = 0, 9 do addInput(tostring(i), 0x30 + i, tostring(i), shiftedDigits[i + 1]) end
for i = 0, 25 do local ch = string.char(97 + i); addInput(ch, 0x41 + i, ch, string.upper(ch)) end
for i = 1, 12 do addInput("f" .. i, 0x6F + i) end

addInput("lshift", 0xA0); addInput("rshift", 0xA1)
addInput("lctrl", 0xA2); addInput("rctrl", 0xA3)
addInput("lalt", 0xA4); addInput("ralt", 0xA5)
addInput("semicolon", 0xBA, ";", ":"); addInput("plus", 0xBB, "=", "+")
addInput("comma", 0xBC, ",", "<"); addInput("minus", 0xBD, "-", "_")
addInput("period", 0xBE, ".", ">"); addInput("slash", 0xBF, "/", "?")
addInput("tilde", 0xC0, "`", "~"); addInput("lbracket", 0xDB, "[", "{")
addInput("backslash", 0xDC, "\\", "|"); addInput("rbracket", 0xDD, "]", "}")
addInput("quote", 0xDE, "'", "\"")

local mouseScroll = 0
pcall(function()
    local uis = game:GetService("UserInputService")
    if uis then
        pcall(function()
            uis.InputChanged:Connect(function(input)
                if input and string.find(tostring(input.UserInputType), "MouseWheel") then
                    mouseScroll = mouseScroll + (input.Position and input.Position.Z or 0)
                end
            end)
        end)
    end
end)

-- ═══════════════════════ DRAWING POOL ═══════════════════════
local Pool      = { sq = {}, tx = {}, ln = {}, ci = {}, tr = {}, im = {} }
local PoolIndex = { sq = 0, tx = 0, ln = 0, ci = 0, tr = 0, im = 0 }
local PoolHigh  = { sq = 0, tx = 0, ln = 0, ci = 0, tr = 0, im = 0 }
local TypeMap   = { sq = "Square", tx = "Text", ln = "Line", ci = "Circle", tr = "Triangle", im = "Image" }

local HAS_CORNER = false
pcall(function() local s = Drawing.new("Square"); s.Corner = 4; HAS_CORNER = true; s:Remove() end)

local drawSeq = 0
local function zord(z) drawSeq = drawSeq + 1; return (z or 1) * 10000 + (drawSeq < 10000 and drawSeq or 9999) end

local function resetPool()
    PoolIndex.sq = 0; PoolIndex.tx = 0; PoolIndex.ln = 0
    PoolIndex.ci = 0; PoolIndex.tr = 0; PoolIndex.im = 0
    drawSeq = 0
end

local function getDrawing(kind)
    local i = PoolIndex[kind] + 1; PoolIndex[kind] = i
    local list = Pool[kind]; local obj = list[i]
    if not obj then
        local ok, made = pcall(function() return Drawing.new(TypeMap[kind]) end)
        if not ok or not made then return nil end
        obj = made; list[i] = obj
    end
    if i > PoolHigh[kind] then PoolHigh[kind] = i end
    obj.Visible = true
    return obj
end

local function hideUnused()
    for kind, list in pairs(Pool) do
        local cur, hi = PoolIndex[kind], PoolHigh[kind]
        if cur < hi then for i = cur + 1, hi do local o = list[i]; if o then o.Visible = false end end end
        if cur > hi then PoolHigh[kind] = cur end
    end
end

local function hideAll()
    for _, list in pairs(Pool) do for i = 1, #list do local o = list[i]; if o then o.Visible = false end end end
end

local function removeAllDrawings()
    for _, list in pairs(Pool) do
        for i = 1, #list do
            local o = list[i]
            if o then pcall(function() o.Visible = false; o:Remove() end); list[i] = nil end
        end
    end
end

-- ═══════════════════════ DRAWING PRIMITIVES ═══════════════════════
local function rect(x, y, w, h, color, z, radius, alpha)
    if w <= 0 or h <= 0 then return end
    local d = getDrawing("sq"); if not d then return end
    d.Position = v2(x, y); d.Size = v2(w, h); d.Color = color; d.Filled = true
    if HAS_CORNER then d.Corner = radius or 0 end
    d.ZIndex = zord(z); d.Transparency = alpha or 1
end

local function strokeRect(x, y, w, h, color, z, radius, alpha)
    if w <= 0 or h <= 0 then return end
    local d = getDrawing("sq"); if not d then return end
    d.Position = v2(x, y); d.Size = v2(w, h); d.Color = color; d.Filled = false
    if HAS_CORNER then d.Corner = radius or 0 end
    d.ZIndex = zord(z); d.Transparency = alpha or 1
end

local function lineD(x1, y1, x2, y2, color, z, thick, alpha)
    local d = getDrawing("ln"); if not d then return end
    d.From = v2(x1, y1); d.To = v2(x2, y2); d.Color = color; d.Thickness = thick or 1
    d.ZIndex = zord(z); d.Transparency = alpha or 1
end

local function circ(x, y, r, color, z, filled, thick, sides, alpha)
    local d = getDrawing("ci"); if not d then return end
    d.Position = v2(x, y); d.Radius = r; d.Color = color
    d.Filled = filled ~= false; d.Thickness = thick or 1; d.NumSides = sides or 32
    d.ZIndex = zord(z); d.Transparency = alpha or 1
end

local function tri(a, b, c, color, z, filled, alpha)
    local d = getDrawing("tr"); if not d then return end
    d.PointA = a; d.PointB = b; d.PointC = c; d.Color = color
    d.Filled = filled ~= false; d.Thickness = 1; d.ZIndex = zord(z); d.Transparency = alpha or 1
end

local function txt(value, x, y, color, size, font, z, centered, outline, maxW, alpha)
    value = tostring(value or ""); if value == "" then return end
    if maxW then value = trimText(value, maxW, size, font); if value == "" then return end end
    local d = getDrawing("tx"); if not d then return end
    d.Text = value; d.Color = color; d.Font = font or FontSystem; d.Size = size or 13
    pcall(function() d.Outline = outline == true end)
    if centered then
        d.Position = v2(x - textWidth(value, size or 13, font or FontSystem) / 2, y)
        d.Center = false
    else d.Center = false; d.Position = v2(x, y) end
    d.ZIndex = zord((z or 1) + 10); d.Transparency = alpha or 1
end

local function gradRectH(x, y, w, h, c1, c2, z, alpha)
    if w <= 0 then return end
    local steps = 20; local sw = w / steps
    for i = 0, steps - 1 do
        local t = i / (steps - 1)
        rect(x + sw * i, y, sw + 1, h, lerpColor(c1, c2, t), z, 0, alpha)
    end
end

-- ═══════════════════════ VECTOR ICONS ═══════════════════════
local IT = 1.4
local Icons = {}

Icons["target"] = function(ix, iy, s, c, z, a)
    local cx, cy = ix + s/2, iy + s/2
    circ(cx, cy, s*0.44, c, z, false, IT, 26, a); circ(cx, cy, s*0.24, c, z, false, IT, 22, a)
    circ(cx, cy, s*0.06, c, z, true, 1, 12, a)
end

Icons["crosshair"] = function(ix, iy, s, c, z, a)
    local cx, cy = ix + s/2, iy + s/2
    circ(cx, cy, s*0.4, c, z, false, IT, 26, a)
    lineD(cx, iy, cx, iy+s*0.16, c, z, IT, a); lineD(cx, iy+s*0.84, cx, iy+s, c, z, IT, a)
    lineD(ix, cy, ix+s*0.16, cy, c, z, IT, a); lineD(ix+s*0.84, cy, ix+s, cy, c, z, IT, a)
end

Icons["user"] = function(ix, iy, s, c, z, a)
    circ(ix+s/2, iy+s*0.33, s*0.17, c, z, false, IT, 18, a)
    lineD(ix+s*0.22, iy+s*0.88, ix+s*0.32, iy+s*0.64, c, z, IT, a)
    lineD(ix+s*0.78, iy+s*0.88, ix+s*0.68, iy+s*0.64, c, z, IT, a)
    lineD(ix+s*0.32, iy+s*0.64, ix+s*0.68, iy+s*0.64, c, z, IT, a)
    lineD(ix+s*0.22, iy+s*0.88, ix+s*0.78, iy+s*0.88, c, z, IT, a)
end

Icons["eye"] = function(ix, iy, s, c, z, a)
    local cx, cy = ix+s/2, iy+s/2
    circ(cx, cy, s*0.15, c, z, false, IT, 16, a); circ(cx, cy, s*0.05, c, z, true, 1, 10, a)
    lineD(ix+s*0.12, cy, ix+s*0.32, iy+s*0.3, c, z, IT, a); lineD(ix+s*0.32, iy+s*0.3, ix+s*0.68, iy+s*0.3, c, z, IT, a)
    lineD(ix+s*0.68, iy+s*0.3, ix+s*0.88, cy, c, z, IT, a); lineD(ix+s*0.12, cy, ix+s*0.32, iy+s*0.7, c, z, IT, a)
    lineD(ix+s*0.32, iy+s*0.7, ix+s*0.68, iy+s*0.7, c, z, IT, a); lineD(ix+s*0.68, iy+s*0.7, ix+s*0.88, cy, c, z, IT, a)
end

Icons["settings"] = function(ix, iy, s, c, z, a)
    local cx, cy = ix+s/2, iy+s/2; circ(cx, cy, s*0.17, c, z, false, IT, 18, a)
    for i = 0, 5 do local ang = i*pi/3
        lineD(cx+cos(ang)*s*0.25, cy+sin(ang)*s*0.25, cx+cos(ang)*s*0.42, cy+sin(ang)*s*0.42, c, z, IT, a) end
end

Icons["folder"] = function(ix, iy, s, c, z, a)
    strokeRect(ix+s*0.1, iy+s*0.34, s*0.8, s*0.46, c, z, 2, a)
    lineD(ix+s*0.1, iy+s*0.34, ix+s*0.1, iy+s*0.24, c, z, IT, a)
    lineD(ix+s*0.1, iy+s*0.24, ix+s*0.42, iy+s*0.24, c, z, IT, a)
    lineD(ix+s*0.42, iy+s*0.24, ix+s*0.5, iy+s*0.34, c, z, IT, a)
end

Icons["code"] = function(ix, iy, s, c, z, a)
    local cy = iy+s/2
    lineD(ix+s*0.38, iy+s*0.26, ix+s*0.18, cy, c, z, IT, a); lineD(ix+s*0.18, cy, ix+s*0.38, iy+s*0.74, c, z, IT, a)
    lineD(ix+s*0.62, iy+s*0.26, ix+s*0.82, cy, c, z, IT, a); lineD(ix+s*0.82, cy, ix+s*0.62, iy+s*0.74, c, z, IT, a)
end

Icons["sliders"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.14, iy+s*0.33, ix+s*0.86, iy+s*0.33, c, z, IT, a)
    lineD(ix+s*0.14, iy+s*0.67, ix+s*0.86, iy+s*0.67, c, z, IT, a)
    circ(ix+s*0.66, iy+s*0.33, s*0.1, c, z, true, 1, 12, a)
    circ(ix+s*0.34, iy+s*0.67, s*0.1, c, z, true, 1, 12, a)
end

Icons["shield"] = function(ix, iy, s, c, z, a)
    local pts = {{0.5,0.12},{0.83,0.27},{0.71,0.78},{0.5,0.9},{0.29,0.78},{0.17,0.27},{0.5,0.12}}
    for i = 1, #pts-1 do lineD(ix+pts[i][1]*s, iy+pts[i][2]*s, ix+pts[i+1][1]*s, iy+pts[i+1][2]*s, c, z, IT, a) end
end

Icons["zap"] = function(ix, iy, s, c, z, a)
    local pts = {{0.55,0.1},{0.3,0.55},{0.5,0.55},{0.45,0.9},{0.7,0.45},{0.5,0.45},{0.55,0.1}}
    for i = 1, #pts-1 do lineD(ix+pts[i][1]*s, iy+pts[i][2]*s, ix+pts[i+1][1]*s, iy+pts[i+1][2]*s, c, z, IT, a) end
end

Icons["box"] = function(ix, iy, s, c, z, a)
    strokeRect(ix+s*0.18, iy+s*0.18, s*0.64, s*0.64, c, z, 2, a)
    lineD(ix+s*0.18, iy+s*0.4, ix+s*0.82, iy+s*0.4, c, z, IT, a)
end

Icons["home"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.5, iy+s*0.14, ix+s*0.15, iy+s*0.46, c, z, IT, a)
    lineD(ix+s*0.5, iy+s*0.14, ix+s*0.85, iy+s*0.46, c, z, IT, a)
    strokeRect(ix+s*0.27, iy+s*0.46, s*0.46, s*0.4, c, z, 1, a)
end

Icons["star"] = function(ix, iy, s, c, z, a)
    local cx, cy = ix+s/2, iy+s/2; local pts = {}
    for i = 0, 10 do local r = (i%2==0) and s*0.44 or s*0.18; local ang = -pi/2 + i*pi/5
        pts[#pts+1] = {cx+cos(ang)*r, cy+sin(ang)*r} end
    for i = 1, #pts-1 do lineD(pts[i][1], pts[i][2], pts[i+1][1], pts[i+1][2], c, z, IT, a) end
end

Icons["swords"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.2, iy+s*0.2, ix+s*0.7, iy+s*0.7, c, z, IT, a)
    lineD(ix+s*0.8, iy+s*0.2, ix+s*0.3, iy+s*0.7, c, z, IT, a)
    lineD(ix+s*0.15, iy+s*0.25, ix+s*0.25, iy+s*0.15, c, z, IT, a)
    lineD(ix+s*0.75, iy+s*0.15, ix+s*0.85, iy+s*0.25, c, z, IT, a)
    lineD(ix+s*0.25, iy+s*0.75, ix+s*0.4, iy+s*0.7, c, z, IT, a)
    lineD(ix+s*0.6, iy+s*0.7, ix+s*0.75, iy+s*0.75, c, z, IT, a)
end

Icons["search"] = function(ix, iy, s, c, z, a)
    circ(ix+s*0.42, iy+s*0.42, s*0.26, c, z, false, IT, 22, a)
    lineD(ix+s*0.6, iy+s*0.6, ix+s*0.85, iy+s*0.85, c, z, IT+0.5, a)
end

Icons["bell"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.5, iy+s*0.12, ix+s*0.5, iy+s*0.2, c, z, IT, a)
    lineD(ix+s*0.28, iy+s*0.5, ix+s*0.28, iy+s*0.7, c, z, IT, a)
    lineD(ix+s*0.72, iy+s*0.5, ix+s*0.72, iy+s*0.7, c, z, IT, a)
    lineD(ix+s*0.28, iy+s*0.5, ix+s*0.38, iy+s*0.3, c, z, IT, a)
    lineD(ix+s*0.72, iy+s*0.5, ix+s*0.62, iy+s*0.3, c, z, IT, a)
    lineD(ix+s*0.38, iy+s*0.3, ix+s*0.62, iy+s*0.3, c, z, IT, a)
    lineD(ix+s*0.2, iy+s*0.7, ix+s*0.8, iy+s*0.7, c, z, IT, a)
    circ(ix+s*0.5, iy+s*0.78, s*0.06, c, z, true, 1, 10, a)
end

Icons["lock"] = function(ix, iy, s, c, z, a)
    strokeRect(ix+s*0.25, iy+s*0.48, s*0.5, s*0.38, c, z, 2, a)
    lineD(ix+s*0.35, iy+s*0.48, ix+s*0.35, iy+s*0.32, c, z, IT, a)
    lineD(ix+s*0.35, iy+s*0.32, ix+s*0.65, iy+s*0.32, c, z, IT, a)
    lineD(ix+s*0.65, iy+s*0.32, ix+s*0.65, iy+s*0.48, c, z, IT, a)
end

Icons["flame"] = function(ix, iy, s, c, z, a)
    local pts = {{0.5,0.1},{0.35,0.4},{0.3,0.6},{0.35,0.8},{0.5,0.9},{0.65,0.8},{0.7,0.6},{0.65,0.4},{0.5,0.1}}
    for i = 1, #pts-1 do lineD(ix+pts[i][1]*s, iy+pts[i][2]*s, ix+pts[i+1][1]*s, iy+pts[i+1][2]*s, c, z, IT, a) end
end

Icons["brain"] = function(ix, iy, s, c, z, a)
    circ(ix+s*0.38, iy+s*0.4, s*0.2, c, z, false, IT, 16, a)
    circ(ix+s*0.62, iy+s*0.4, s*0.2, c, z, false, IT, 16, a)
    circ(ix+s*0.5, iy+s*0.6, s*0.18, c, z, false, IT, 16, a)
    lineD(ix+s*0.5, iy+s*0.22, ix+s*0.5, iy+s*0.78, c, z, IT, a)
end

Icons["gamepad"] = function(ix, iy, s, c, z, a)
    strokeRect(ix+s*0.15, iy+s*0.3, s*0.7, s*0.4, c, z, 4, a)
    lineD(ix+s*0.32, iy+s*0.42, ix+s*0.32, iy+s*0.58, c, z, IT, a)
    lineD(ix+s*0.25, iy+s*0.5, ix+s*0.39, iy+s*0.5, c, z, IT, a)
    circ(ix+s*0.62, iy+s*0.45, s*0.04, c, z, true, 1, 8, a)
    circ(ix+s*0.72, iy+s*0.55, s*0.04, c, z, true, 1, 8, a)
end

Icons["ghost"] = function(ix, iy, s, c, z, a)
    circ(ix+s*0.5, iy+s*0.4, s*0.28, c, z, false, IT, 18, a)
    lineD(ix+s*0.22, iy+s*0.4, ix+s*0.22, iy+s*0.82, c, z, IT, a)
    lineD(ix+s*0.78, iy+s*0.4, ix+s*0.78, iy+s*0.82, c, z, IT, a)
    lineD(ix+s*0.22, iy+s*0.82, ix+s*0.35, iy+s*0.72, c, z, IT, a)
    lineD(ix+s*0.35, iy+s*0.72, ix+s*0.5, iy+s*0.82, c, z, IT, a)
    lineD(ix+s*0.5, iy+s*0.82, ix+s*0.65, iy+s*0.72, c, z, IT, a)
    lineD(ix+s*0.65, iy+s*0.72, ix+s*0.78, iy+s*0.82, c, z, IT, a)
    circ(ix+s*0.4, iy+s*0.38, s*0.05, c, z, true, 1, 8, a)
    circ(ix+s*0.6, iy+s*0.38, s*0.05, c, z, true, 1, 8, a)
end

Icons["skull"] = function(ix, iy, s, c, z, a)
    circ(ix+s*0.5, iy+s*0.4, s*0.3, c, z, false, IT, 22, a)
    circ(ix+s*0.38, iy+s*0.38, s*0.08, c, z, true, 1, 10, a)
    circ(ix+s*0.62, iy+s*0.38, s*0.08, c, z, true, 1, 10, a)
    lineD(ix+s*0.5, iy+s*0.7, ix+s*0.5, iy+s*0.85, c, z, IT, a)
    lineD(ix+s*0.35, iy+s*0.7, ix+s*0.35, iy+s*0.82, c, z, IT, a)
    lineD(ix+s*0.65, iy+s*0.7, ix+s*0.65, iy+s*0.82, c, z, IT, a)
end

Icons["rocket"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.5, iy+s*0.1, ix+s*0.35, iy+s*0.6, c, z, IT, a)
    lineD(ix+s*0.5, iy+s*0.1, ix+s*0.65, iy+s*0.6, c, z, IT, a)
    lineD(ix+s*0.35, iy+s*0.6, ix+s*0.65, iy+s*0.6, c, z, IT, a)
    lineD(ix+s*0.25, iy+s*0.55, ix+s*0.35, iy+s*0.45, c, z, IT, a)
    lineD(ix+s*0.75, iy+s*0.55, ix+s*0.65, iy+s*0.45, c, z, IT, a)
    lineD(ix+s*0.42, iy+s*0.6, ix+s*0.38, iy+s*0.8, c, z, IT, a)
    lineD(ix+s*0.5, iy+s*0.6, ix+s*0.5, iy+s*0.85, c, z, IT, a)
    lineD(ix+s*0.58, iy+s*0.6, ix+s*0.62, iy+s*0.8, c, z, IT, a)
end

Icons["sparkles"] = function(ix, iy, s, c, z, a)
    local function star4(cx, cy, r)
        lineD(cx, cy-r, cx, cy+r, c, z, IT, a)
        lineD(cx-r, cy, cx+r, cy, c, z, IT, a)
        lineD(cx-r*0.5, cy-r*0.5, cx+r*0.5, cy+r*0.5, c, z, 1, a)
        lineD(cx+r*0.5, cy-r*0.5, cx-r*0.5, cy+r*0.5, c, z, 1, a)
    end
    star4(ix+s*0.35, iy+s*0.35, s*0.18)
    star4(ix+s*0.7, iy+s*0.3, s*0.1)
    star4(ix+s*0.6, iy+s*0.7, s*0.14)
end

Icons["crown"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.15, iy+s*0.7, ix+s*0.15, iy+s*0.4, c, z, IT, a)
    lineD(ix+s*0.15, iy+s*0.4, ix+s*0.32, iy+s*0.55, c, z, IT, a)
    lineD(ix+s*0.32, iy+s*0.55, ix+s*0.5, iy+s*0.3, c, z, IT, a)
    lineD(ix+s*0.5, iy+s*0.3, ix+s*0.68, iy+s*0.55, c, z, IT, a)
    lineD(ix+s*0.68, iy+s*0.55, ix+s*0.85, iy+s*0.4, c, z, IT, a)
    lineD(ix+s*0.85, iy+s*0.4, ix+s*0.85, iy+s*0.7, c, z, IT, a)
    lineD(ix+s*0.15, iy+s*0.7, ix+s*0.85, iy+s*0.7, c, z, IT, a)
end

Icons["leaf"] = function(ix, iy, s, c, z, a)
    local pts = {{0.7,0.15},{0.55,0.25},{0.35,0.45},{0.3,0.65},{0.35,0.8},{0.5,0.85}}
    for i = 1, #pts-1 do lineD(ix+pts[i][1]*s, iy+pts[i][2]*s, ix+pts[i+1][1]*s, iy+pts[i+1][2]*s, c, z, IT, a) end
    lineD(ix+s*0.7, iy+s*0.15, ix+s*0.8, iy+s*0.3, c, z, IT, a)
    lineD(ix+s*0.8, iy+s*0.3, ix+s*0.7, iy+s*0.45, c, z, IT, a)
    lineD(ix+s*0.7, iy+s*0.45, ix+s*0.5, iy+s*0.85, c, z, IT, a)
    lineD(ix+s*0.3, iy+s*0.85, ix+s*0.5, iy+s*0.85, c, z, 1, a)
end

Icons["layers"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.5, iy+s*0.2, ix+s*0.15, iy+s*0.4, c, z, IT, a)
    lineD(ix+s*0.5, iy+s*0.2, ix+s*0.85, iy+s*0.4, c, z, IT, a)
    lineD(ix+s*0.15, iy+s*0.4, ix+s*0.5, iy+s*0.6, c, z, IT, a)
    lineD(ix+s*0.85, iy+s*0.4, ix+s*0.5, iy+s*0.6, c, z, IT, a)
    lineD(ix+s*0.15, iy+s*0.55, ix+s*0.5, iy+s*0.75, c, z, IT, a)
    lineD(ix+s*0.85, iy+s*0.55, ix+s*0.5, iy+s*0.75, c, z, IT, a)
end

Icons["grid"] = function(ix, iy, s, c, z, a)
    for i = 0, 2 do for j = 0, 2 do
        rect(ix+s*(0.15+i*0.27), iy+s*(0.15+j*0.27), s*0.2, s*0.2, c, z, 1, a)
    end end
end

Icons["compass"] = function(ix, iy, s, c, z, a)
    local cx, cy = ix+s/2, iy+s/2
    circ(cx, cy, s*0.42, c, z, false, IT, 26, a)
    tri(v2(cx, cy-s*0.32), v2(cx-s*0.08, cy), v2(cx+s*0.08, cy), c, z, true, a)
    tri(v2(cx, cy+s*0.32), v2(cx-s*0.08, cy), v2(cx+s*0.08, cy), c, z, false, a)
end

Icons["activity"] = function(ix, iy, s, c, z, a)
    local cy = iy+s*0.5
    lineD(ix+s*0.1, cy, ix+s*0.3, cy, c, z, IT, a)
    lineD(ix+s*0.3, cy, ix+s*0.4, iy+s*0.2, c, z, IT, a)
    lineD(ix+s*0.4, iy+s*0.2, ix+s*0.5, iy+s*0.8, c, z, IT, a)
    lineD(ix+s*0.5, iy+s*0.8, ix+s*0.6, iy+s*0.35, c, z, IT, a)
    lineD(ix+s*0.6, iy+s*0.35, ix+s*0.7, cy, c, z, IT, a)
    lineD(ix+s*0.7, cy, ix+s*0.9, cy, c, z, IT, a)
end

Icons["wrench"] = function(ix, iy, s, c, z, a)
    circ(ix+s*0.65, iy+s*0.35, s*0.18, c, z, false, IT, 14, a)
    lineD(ix+s*0.52, iy+s*0.48, ix+s*0.2, iy+s*0.8, c, z, IT+1, a)
    lineD(ix+s*0.18, iy+s*0.78, ix+s*0.22, iy+s*0.82, c, z, IT, a)
end

Icons["globe"] = function(ix, iy, s, c, z, a)
    local cx, cy = ix+s/2, iy+s/2
    circ(cx, cy, s*0.4, c, z, false, IT, 26, a)
    circ(cx, cy, s*0.4, c, z, false, IT, 12, a)
    lineD(ix+s*0.1, cy, ix+s*0.9, cy, c, z, 1, a)
end

Icons["map"] = function(ix, iy, s, c, z, a)
    lineD(ix+s*0.15, iy+s*0.2, ix+s*0.15, iy+s*0.8, c, z, IT, a)
    lineD(ix+s*0.15, iy+s*0.2, ix+s*0.4, iy+s*0.3, c, z, IT, a)
    lineD(ix+s*0.4, iy+s*0.3, ix+s*0.4, iy+s*0.9, c, z, IT, a)
    lineD(ix+s*0.15, iy+s*0.8, ix+s*0.4, iy+s*0.9, c, z, IT, a)
    lineD(ix+s*0.4, iy+s*0.3, ix+s*0.6, iy+s*0.15, c, z, IT, a)
    lineD(ix+s*0.6, iy+s*0.15, ix+s*0.6, iy+s*0.75, c, z, IT, a)
    lineD(ix+s*0.4, iy+s*0.9, ix+s*0.6, iy+s*0.75, c, z, IT, a)
    lineD(ix+s*0.6, iy+s*0.15, ix+s*0.85, iy+s*0.25, c, z, IT, a)
    lineD(ix+s*0.85, iy+s*0.25, ix+s*0.85, iy+s*0.85, c, z, IT, a)
    lineD(ix+s*0.6, iy+s*0.75, ix+s*0.85, iy+s*0.85, c, z, IT, a)
end

local function drawIcon(name, ix, iy, sz, color, z, a)
    local f = Icons[name]; if f then f(ix, iy, sz, color, z, a) end
end

-- ═══════════════════════ THEME SYSTEM ═══════════════════════
local WHITE = c3(255, 255, 255)
local BLACK = c3(0, 0, 0)

local Theme = {
    bg       = c3(15, 15, 15),
    sidebar  = c3(15, 15, 15),
    surface  = c3(24, 24, 24),
    surface2 = c3(28, 28, 28),
    surface3 = c3(38, 38, 38),
    text     = WHITE,
    sub      = WHITE,
    accent   = WHITE,
    accentA  = c3(122, 134, 255),
    accentB  = c3(189, 130, 255),
    border   = c3(70, 70, 70),
    good     = c3(119, 174, 94),
    bad      = c3(250, 93, 86),
    unsafe   = c3(252, 190, 57),
    white    = WHITE,
    black    = BLACK,
    trackOff   = c3(61, 61, 61),
    trackOn    = c3(87, 86, 86),
    knobOff    = c3(91, 91, 91),
    sliderTrack= c3(87, 86, 86),
    tlRed    = c3(250, 93, 86),
    tlYellow = c3(252, 190, 57),
    tlGreen  = c3(119, 174, 94),
}

local ThemePresets = {
    Indigo    = { c3(122, 134, 255), c3(189, 130, 255) },
    Mono      = { WHITE, WHITE },
    Sunset    = { c3(255, 150, 90),  c3(255, 90, 140) },
    Mint      = { c3(110, 230, 180), c3(90, 200, 255) },
    Rose      = { c3(255, 120, 160), c3(200, 120, 255) },
    Gold      = { c3(255, 210, 120), c3(255, 150, 80) },
    Crimson   = { c3(255, 100, 100), c3(255, 60, 140) },
    Ocean     = { c3(90, 200, 255),  c3(120, 140, 255) },
    Toxic     = { c3(150, 255, 120), c3(60, 220, 160) },
    Lavender  = { c3(180, 160, 255), c3(220, 160, 255) },
    Aqua      = { c3(80, 230, 230),  c3(80, 180, 255) },
    Ember     = { c3(255, 120, 60),  c3(255, 70, 70) },
    Cyber     = { c3(0, 255, 200),   c3(120, 100, 255) },
    Bubblegum = { c3(255, 140, 220), c3(150, 180, 255) },
    Forest    = { c3(120, 220, 120), c3(180, 230, 90) },
    Slate     = { c3(150, 170, 200), c3(110, 130, 170) },
    Cherry    = { c3(255, 90, 120),  c3(255, 150, 110) },
    Aurora    = { c3(120, 255, 200), c3(160, 140, 255) },
    Sky       = { c3(120, 200, 255), c3(180, 210, 255) },
    Magma     = { c3(255, 80, 40),   c3(255, 180, 40) },
    Grape     = { c3(170, 110, 255), c3(255, 110, 200) },
    Neon      = { c3(0, 240, 255),   c3(180, 0, 255) },
    Waifu     = { c3(150, 205, 120), c3(195, 230, 130) },
    Lemon     = { c3(252, 211, 49),  c3(240, 165, 25) },
    Peach     = { c3(255, 180, 150), c3(255, 130, 160) },
    Steel     = { c3(120, 200, 220), c3(150, 160, 200) },
}

local function accentMid() return lerpColor(Theme.accentA, Theme.accentB, 0.5) end

-- ═══════════════════════ CALLBACKS ═══════════════════════
local function invoke(cb, ...)
    if type(cb) ~= "function" then return end
    local ok, r = pcall(cb, ...)
    if not ok then return end
    return r
end

-- ═══════════════════════ VIEWPORT ═══════════════════════
local function viewportSize()
    local x, y = 1920, 1080
    pcall(function() local cam = workspace.CurrentCamera; if cam then x = cam.ViewportSize.X; y = cam.ViewportSize.Y end end)
    return x, y
end

local function getMouse()
    if not Mouse then
        pcall(function() LocalPlayer = Players and Players.LocalPlayer end)
        pcall(function() Mouse = LocalPlayer and LocalPlayer:GetMouse() end)
    end
    if Mouse then return Mouse.X, Mouse.Y, true end
    return 0, 0, false
end

-- ═══════════════════════ WIDGET HELPERS ═══════════════════════
local function snapValue(raw, item)
    local lo, hi, step = item.min or 0, item.max or 100, item.step or 1
    if step <= 0 then step = 1 end
    local steps = floor(((raw - lo) / step) + 0.5 + 0.0001)
    local val = clamp(lo + steps * step, lo, hi)
    if item.float then return val end
    return floor(val + 0.5)
end

local function setDropdownValue(item, value, fire)
    local nv = copyArray(value)
    local changed = #nv ~= #item.value
    for i = 1, max(#item.value, #nv) do if item.value[i] ~= nv[i] then changed = true; break end end
    for i = #item.value, 1, -1 do item.value[i] = nil end
    for i = 1, #nv do item.value[i] = nv[i] end
    if changed and fire ~= false then invoke(item.callback, item.value) end
end

local function setItemValue(item, value, fire)
    if item.type == "dropdown" then setDropdownValue(item, value, fire); return end
    if item.type == "slider" then
        value = tonumber(value) or item.value or item.min or 0
        value = snapValue(value, item)
    elseif item.type == "textbox" then value = tostring(value or "")
    elseif item.type == "checkbox" then value = value == true end
    local changed = item.value ~= value; item.value = value
    if changed and fire ~= false then invoke(item.callback, value) end
end

local function isItemDisabled(item)
    local dep = item.dependsOn
    if dep and dep.item then
        if not dep.item.value or isItemDisabled(dep.item) then return true end
    end
    return false
end

-- ═══════════════════════ WIDGET HANDLE BUILDER ═══════════════════════
local keybindItems = {}

local function makeItem(section, item)
    section.items[#section.items + 1] = item
    item._secName = section.name
    if item.default == nil then
        if item.type == "slider" or item.type == "checkbox" then item.default = item.value
        elseif item.type == "dropdown" then item.default = copyArray(item.value) end
    end

    local handle = { item = item }

    function handle:Set(v) setItemValue(item, v, true); return self end
    function handle:Get() return item.value end
    function handle:DependsOn(parent) item.dependsOn = parent; return self end
    function handle:Tooltip(text) item.tooltip = tostring(text or ""); return self end
    function handle:SetText(t) item.label = tostring(t); return self end
    function handle:SetColor(c) item.color = c; return self end
    function handle:SetRisk(b) item.risk = b ~= false; return self end
    function handle:Reset() if item.default ~= nil then setItemValue(item, item.default, true) end; return self end

    if item.type == "checkbox" then
        function handle:AddKeybind(defaultKey, mode, callback)
            local kb = { value = normalizeKey(defaultKey), mode = normalizeMode(mode), callback = callback, listening = false }
            item.keybind = kb
            keybindItems[#keybindItems + 1] = item
            return handle
        end
        function handle:AddColorpicker(label, defaultColor, callback, defaultAlpha)
            item.colorpicker = { label = label or "color", value = defaultColor or accentMid(), alpha = defaultAlpha or 1, callback = callback }
            return handle
        end
    end

    if item.type == "dropdown" then
        function handle:UpdateChoices(newChoices) item.choices = copyArray(newChoices); return self end
        function handle:AddChoice(c)
            for i = 1, #item.choices do if item.choices[i] == c then return self end end
            item.choices[#item.choices + 1] = c; return self
        end
        function handle:RemoveChoice(c)
            for i = #item.choices, 1, -1 do if item.choices[i] == c then remove(item.choices, i) end end
            for i = #item.value, 1, -1 do if item.value[i] == c then remove(item.value, i) end end
            return self
        end
        function handle:SetSearchable(b) item.searchable = b == true; return self end
        function handle:SetMaxSelections(n) item.maxSelections = tonumber(n); return self end
        function handle:ClearChoices() item.choices = {}; item.value = {}; return self end
    end

    if item.type == "button" then
        function handle:AddButton(label, callback)
            item.buttons[#item.buttons + 1] = { label = tostring(label or "Button"), callback = callback }
            return self
        end
    end

    if item.type == "keybind" then keybindItems[#keybindItems + 1] = item end
    return handle
end

-- ═══════════════════════ SECTION & TAB BUILDERS ═══════════════════════
local function createSection(tab, cfg)
    local section = {
        name = tostring(cfg.name or "Section"),
        side = tostring(cfg.side or "Left"),
        items = {},
        collapsed = false,
        scrollOffset = 0,
        scrollTarget = 0,
        contentH = 0,
        _collapseAnim = 1,
    }
    tab.sections[#tab.sections + 1] = section

    local api = {}

    function api:Checkbox(c)
        return makeItem(section, { type = "checkbox", label = tostring(c.label or "Toggle"), value = c.default == true, callback = c.callback, tooltip = c.tooltip, risk = c.risk, _anim = c.default == true and 1 or 0 })
    end

    function api:Slider(c)
        local val = tonumber(c.default) or tonumber(c.min) or 0
        return makeItem(section, { type = "slider", label = tostring(c.label or "Slider"), value = val, min = c.min or 0, max = c.max or 100, step = c.step or 1, float = c.float, suffix = c.suffix or "", callback = c.callback, tooltip = c.tooltip })
    end

    function api:Dropdown(c)
        local val = copyArray(c.default)
        return makeItem(section, { type = "dropdown", label = tostring(c.label or "Dropdown"), value = val, choices = copyArray(c.choices or {}), multi = c.multi == true, searchable = c.searchable == true, maxSelections = c.maxSelections, callback = c.callback, tooltip = c.tooltip })
    end

    function api:Textbox(c)
        return makeItem(section, { type = "textbox", label = tostring(c.label or "Input"), value = tostring(c.default or ""), placeholder = c.placeholder or "", callback = c.callback, tooltip = c.tooltip })
    end

    function api:Button(c)
        return makeItem(section, { type = "button", label = tostring(c.label or "Button"), buttons = {{ label = tostring(c.label or "Button"), callback = c.callback }}, tooltip = c.tooltip })
    end

    function api:Keybind(c)
        return makeItem(section, { type = "keybind", label = tostring(c.label or "Keybind"), value = normalizeKey(c.default), mode = normalizeMode(c.mode), listening = false, callback = c.callback, tooltip = c.tooltip })
    end

    function api:Colorpicker(c)
        return makeItem(section, { type = "colorpicker", label = tostring(c.label or "Color"), value = c.default or accentMid(), alpha = c.alpha or 1, callback = c.callback, tooltip = c.tooltip })
    end

    function api:Label(c)
        return makeItem(section, { type = "label", label = tostring(c.label or ""), color = c.color or Theme.text, tooltip = c.tooltip })
    end

    function api:Separator(c)
        return makeItem(section, { type = "separator", label = c and c.label or nil })
    end

    return api
end

local function createTab(state, cfg)
    local tab = {
        name = tostring(cfg.name or "Tab"),
        icon = cfg.icon or "home",
        sections = {},
    }
    state.tabs[#state.tabs + 1] = tab
    if not state.activeTab then state.activeTab = tab; state.activeIndex = 1 end

    local tabApi = {}
    function tabApi:Section(c) return createSection(tab, c) end
    return tabApi
end

-- ═══════════════════════ CONFIG SYSTEM ═══════════════════════
local function ensureFolder(path)
    if type(makefolder) == "function" and type(isfolder) == "function" then
        pcall(function() if not isfolder(path) then makefolder(path) end end)
    end
end

local function saveConfig(state, name)
    name = name or "default"
    ensureFolder("Bwin"); ensureFolder("Bwin/" .. state.title)
    local data = {}
    for _, tab in ipairs(state.tabs) do
        for _, sec in ipairs(tab.sections) do
            for _, item in ipairs(sec.items) do
                local key = tab.name .. "." .. sec.name .. "." .. item.label
                if item.type == "checkbox" then data[key] = { v = item.value }
                elseif item.type == "slider" then data[key] = { v = item.value }
                elseif item.type == "dropdown" then data[key] = { v = item.value }
                elseif item.type == "textbox" then data[key] = { v = item.value }
                elseif item.type == "keybind" then data[key] = { v = item.value, m = item.mode }
                end
                if item.keybind then data[key .. ".kb"] = { v = item.keybind.value, m = item.keybind.mode } end
                if item.colorpicker then
                    data[key .. ".cp"] = { v = toHex(item.colorpicker.value), a = item.colorpicker.alpha }
                end
            end
        end
    end
    local json = jsonEncode(data)
    if json and type(writefile) == "function" then
        pcall(function() writefile("Bwin/" .. state.title .. "/" .. name .. ".json", json) end)
    end
end

local function loadConfig(state, name)
    name = name or "default"
    local path = "Bwin/" .. state.title .. "/" .. name .. ".json"
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    local ok, content = pcall(function() if isfile(path) then return readfile(path) end end)
    if not ok or not content then return end
    local data = jsonDecode(content)
    if type(data) ~= "table" then return end
    for _, tab in ipairs(state.tabs) do
        for _, sec in ipairs(tab.sections) do
            for _, item in ipairs(sec.items) do
                local key = tab.name .. "." .. sec.name .. "." .. item.label
                local d = data[key]
                if d then setItemValue(item, d.v, true)
                    if item.type == "keybind" and d.m then item.mode = normalizeMode(d.m) end
                end
                if item.keybind then
                    local kbd = data[key .. ".kb"]
                    if kbd then item.keybind.value = normalizeKey(kbd.v); if kbd.m then item.keybind.mode = normalizeMode(kbd.m) end end
                end
                if item.colorpicker then
                    local cpd = data[key .. ".cp"]
                    if cpd then
                        local parsed = parseHex(cpd.v)
                        if parsed then item.colorpicker.value = parsed end
                        if cpd.a then item.colorpicker.alpha = cpd.a end
                    end
                end
            end
        end
    end
end

-- ═══════════════════════ MAIN LIBRARY ═══════════════════════
local Bwin = {}
Bwin.__index = Bwin

function Bwin.new(cfg)
    cfg = cfg or {}

    local state = {
        alive = true, destroyed = false, open = false, rendering = false,
        x = 0, y = 0, w = 560, h = 460, minimized = false,
        title = tostring(cfg.title or "bwin"), subtitle = tostring(cfg.subtitle or ""),
        configName = "default",
        mouseX = 0, mouseY = 0, hasMouse = false, scroll = 0,
        lastFrame = clock() or 0, dt = 1/60,
        drawVisible = 0, contentFade = 1,
        tabs = {}, activeTab = nil, activeIndex = 1,
        notifications = {},
        drag = nil, resizeEdge = nil, sliderDrag = nil, scrollDrag = nil,
        dropdown = nil, colorpicker = nil, cpDrag = nil,
        focus = nil, keyMenu = nil,
        repeatKey = nil, repeatAt = 0,
        tooltipText = nil, tooltipX = 0, tooltipY = 0, tooltipAt = 0,
        hoverEffects = true, tooltipsEnabled = true,
        errorCount = 0,
        menuKey = normalizeKey(cfg.key) or "p",
        spotlightOpen = false, spotlightQuery = "", spotlightSelected = 1,
    }

    -- center window
    local vw, vh = viewportSize()
    state.x = floor((vw - state.w) / 2)
    state.y = floor((vh - state.h) / 2)

    -- apply accent
    if cfg.accentA then Theme.accentA = cfg.accentA end
    if cfg.accentB then Theme.accentB = cfg.accentB end
    if cfg.accent then
        local p = ThemePresets[cfg.accent]
        if p then Theme.accentA = p[1]; Theme.accentB = p[2] end
    end
    Theme.accent = accentMid()

    local self = setmetatable({ _state = state }, Bwin)

    -- start render loop
    pcall(function()
        task.spawn(function()
            -- fade in
            local fadeStart = clock()
            while state.alive and not state.destroyed do
                local now = clock()
                state.dt = clamp(now - state.lastFrame, 0.001, 0.1)
                state.lastFrame = now

                -- fade in animation
                local elapsed = now - fadeStart
                if elapsed < 0.5 then
                    state.drawVisible = clamp(elapsed / 0.4, 0, 1)
                    if not state.open and elapsed > 0.1 then state.open = true end
                else
                    state.drawVisible = 1
                    if not state.open then state.open = true end
                end

                -- poll input
                local mx, my, hasMouse = getMouse()
                state.mouseX = mx; state.mouseY = my; state.hasMouse = hasMouse

                local scrollDelta = mouseScroll; mouseScroll = 0; state.scroll = scrollDelta

                local focused = true
                pcall(function() focused = isrbxactive() end)

                if focused then
                    for _, name in ipairs(InputOrder) do
                        local inp = Input[name]
                        local wasHeld = inp.held
                        local nowHeld = false
                        if inp.id == 0x01 then pcall(function() nowHeld = ismouse1() end)
                        elseif inp.id == 0x02 then pcall(function() nowHeld = ismouse2() end)
                        else pcall(function() nowHeld = iskeypressed(inp.id) end) end
                        inp.click = nowHeld and not wasHeld
                        inp.released = not nowHeld and wasHeld
                        inp.held = nowHeld
                    end
                else
                    for _, name in ipairs(InputOrder) do
                        local inp = Input[name]; inp.click = false; inp.released = false; inp.held = false
                    end
                end

                -- toggle menu
                local mk = Input[state.menuKey]
                if mk and mk.click and not state.focus and not (state.dropdown or state.colorpicker) then
                    state.open = not state.open
                    if not state.open then
                        state.drag = nil; state.resizeEdge = nil; state.sliderDrag = nil
                        state.scrollDrag = nil; state.dropdown = nil; state.colorpicker = nil
                        state.cpDrag = nil; state.focus = nil; state.keyMenu = nil
                    end
                    pcall(setrobloxinput, not state.open)
                end

                -- spotlight toggle (ctrl+space)
                if Input["ctrl"] and Input["ctrl"].held and Input["space"] and Input["space"].click then
                    state.spotlightOpen = not state.spotlightOpen
                    state.spotlightQuery = ""; state.spotlightSelected = 1
                end

                -- render
                resetPool()

                if state.open and not state.minimized then
                    self:_render()
                end

                self:_renderNotifications()

                if state.spotlightOpen then
                    self:_renderSpotlight()
                end

                hideUnused()

                -- apply input state
                local shouldCapture = state.open and not state.minimized
                pcall(setrobloxinput, not shouldCapture)

                -- yield
                pcall(function() task.wait() end)
            end

            -- cleanup
            hideAll()
            removeAllDrawings()
        end)
    end)

    return self
end

function Bwin:Tab(cfg) return createTab(self._state, cfg) end

function Bwin:Notify(cfg)
    local s = self._state
    s.notifications[#s.notifications + 1] = {
        title = tostring(cfg.title or "notification"),
        description = tostring(cfg.description or ""),
        duration = cfg.duration or 4,
        elapsed = 0,
    }
end

function Bwin:SaveConfig(name) saveConfig(self._state, name) end
function Bwin:LoadConfig(name) loadConfig(self._state, name) end

function Bwin:SetAccent(nameOrA, b)
    if type(nameOrA) == "string" then
        local p = ThemePresets[nameOrA]
        if p then Theme.accentA = p[1]; Theme.accentB = p[2] end
    else
        Theme.accentA = nameOrA; Theme.accentB = b or nameOrA
    end
    Theme.accent = accentMid()
end

function Bwin:Destroy()
    local s = self._state
    s.alive = false; s.destroyed = true
    pcall(setrobloxinput, true)
end

-- ═══════════════════════ RENDERING ═══════════════════════
local TITLE_H = 38
local SIDEBAR_W = 160
local SHADOW_ALPHA = { 0.10, 0.07, 0.05, 0.03, 0.015 }

local function over(state, x, y, w, h)
    return state.hasMouse and state.mouseX >= x and state.mouseX <= x + w and state.mouseY >= y and state.mouseY <= y + h
end

function Bwin:_render()
    local s = self._state
    local vis = s.drawVisible
    local click = Input["m1"] and Input["m1"].click or false
    local held = Input["m1"] and Input["m1"].held or false
    local rclick = Input["m2"] and Input["m2"].click or false

    local wx, wy, ww, wh = s.x, s.y, s.w, s.h

    -- ── DRAGGING ──
    if s.drag then
        if held then
            wx = s.mouseX - s.drag.ox; wy = s.mouseY - s.drag.oy
            local vw, vh = viewportSize()
            wx = clamp(wx, 0, max(0, vw - 80)); wy = clamp(wy, 0, max(0, vh - 40))
            s.x = wx; s.y = wy
        else s.drag = nil end
    end

    -- ── RESIZING ──
    if s.resizeEdge then
        if held then
            if s.resizeEdge == "r" or s.resizeEdge == "br" then
                s.w = max(400, s.resizeEdge == "r" and (s.mouseX - s.x) or (s.mouseX - s.x))
            end
            if s.resizeEdge == "b" or s.resizeEdge == "br" then
                s.h = max(300, s.mouseY - s.y)
            end
            ww = s.w; wh = s.h
        else s.resizeEdge = nil end
    end

    -- ── SHADOW ──
    for i = 1, #SHADOW_ALPHA do
        rect(wx - i * 2, wy - i * 2, ww + i * 4, wh + i * 4, BLACK, 0, 8, SHADOW_ALPHA[i] * vis)
    end

    -- ── WINDOW BG ──
    rect(wx, wy, ww, wh, Theme.bg, 1, 6, vis)
    strokeRect(wx, wy, ww, wh, Theme.border, 2, 6, 0.3 * vis)

    -- ── TITLE BAR ──
    rect(wx, wy, ww, TITLE_H, Theme.bg, 2, 6, vis)
    lineD(wx + 8, wy + TITLE_H, wx + ww - 8, wy + TITLE_H, Theme.border, 2, 1, 0.4 * vis)

    -- traffic lights
    local tlY = wy + TITLE_H / 2
    local tlX = wx + 18
    local tlHover = over(s, tlX - 8, tlY - 8, 60, 16)
    circ(tlX, tlY, 5, Theme.tlRed, 3, true, 0, 16, vis)
    circ(tlX + 20, tlY, 5, Theme.tlYellow, 3, true, 0, 16, vis)
    circ(tlX + 40, tlY, 5, Theme.tlGreen, 3, true, 0, 16, vis)

    if click and tlHover then
        if over(s, tlX - 6, tlY - 6, 12, 12) then self:Destroy(); return
        elseif over(s, tlX + 14, tlY - 6, 12, 12) then s.minimized = not s.minimized
        elseif over(s, tlX + 34, tlY - 6, 12, 12) then s.w = 560; s.h = 460 end
        click = false
    end

    -- title text
    txt(s.title, wx + 80, textTop(wy, TITLE_H, 14), Theme.text, 14, FontBold, 3, false, false, nil, vis)
    if s.subtitle ~= "" then
        local tw = textWidth(s.title, 14, FontBold)
        txt(s.subtitle, wx + 84 + tw, textTop(wy, TITLE_H, 11), Theme.sub, 11, FontSystem, 3, false, false, nil, 0.5 * vis)
    end

    -- drag zone
    if click and not tlHover and over(s, wx, wy, ww, TITLE_H) and not s.drag then
        s.drag = { ox = s.mouseX - wx, oy = s.mouseY - wy }
        click = false
    end

    -- ── SIDEBAR ──
    local sideX = wx
    local sideY = wy + TITLE_H + 1
    local sideH = wh - TITLE_H - 1
    rect(sideX, sideY, SIDEBAR_W, sideH, Theme.sidebar, 2, 0, vis)
    lineD(sideX + SIDEBAR_W, sideY, sideX + SIDEBAR_W, sideY + sideH, Theme.border, 2, 1, 0.4 * vis)

    local tabH = 36
    for i, tab in ipairs(s.tabs) do
        local ty = sideY + (i - 1) * tabH + 8
        local isActive = (s.activeIndex == i)
        local isHover = over(s, sideX, ty, SIDEBAR_W, tabH)

        if isActive then
            rect(sideX + 4, ty + 2, SIDEBAR_W - 8, tabH - 4, Theme.surface2, 3, 6, 0.8 * vis)
            gradRectH(sideX + 2, ty + 2, 3, tabH - 4, Theme.accentA, Theme.accentB, 4, vis)
        elseif isHover and s.hoverEffects then
            rect(sideX + 4, ty + 2, SIDEBAR_W - 8, tabH - 4, Theme.surface, 3, 6, 0.4 * vis)
        end

        local iconColor = isActive and accentMid() or Theme.sub
        drawIcon(tab.icon, sideX + 16, ty + (tabH - 18) / 2, 18, iconColor, 4, vis)
        txt(tab.name, sideX + 42, textTop(ty, tabH, 12), isActive and Theme.text or Theme.sub, 12, isActive and FontBold or FontSystem, 4, false, false, SIDEBAR_W - 52, vis)

        if click and isHover and not isActive then
            s.activeTab = tab; s.activeIndex = i; s.contentFade = 0
            click = false
        end
    end

    -- settings gear at bottom
    local gearY = sideY + sideH - 40
    local gearHover = over(s, sideX + 8, gearY, SIDEBAR_W - 16, 32)
    if gearHover and s.hoverEffects then
        rect(sideX + 4, gearY, SIDEBAR_W - 8, 32, Theme.surface, 3, 6, 0.3 * vis)
    end
    drawIcon("settings", sideX + 16, gearY + 7, 18, gearHover and accentMid() or Theme.sub, 4, vis)
    txt("Settings", sideX + 42, textTop(gearY, 32, 12), gearHover and Theme.text or Theme.sub, 12, FontSystem, 4, false, false, nil, vis)

    -- ── CONTENT AREA ──
    s.contentFade = approach(s.contentFade, 1, 12, s.dt)
    local cAlpha = vis * s.contentFade

    local contentX = wx + SIDEBAR_W + 1
    local contentY = wy + TITLE_H + 1
    local contentW = ww - SIDEBAR_W - 1
    local contentH = wh - TITLE_H - 1

    local tab = s.activeTab
    if tab then
        local leftSections, rightSections = {}, {}
        for _, sec in ipairs(tab.sections) do
            if sec.side == "Right" then rightSections[#rightSections + 1] = sec
            else leftSections[#leftSections + 1] = sec end
        end

        local colW = floor((contentW - 24) / 2)
        local leftX = contentX + 8
        local rightX = contentX + colW + 16

        local function renderSections(sections, sx, sw)
            local cy = contentY + 8
            for _, sec in ipairs(sections) do
                -- section header
                local headerH = 28
                local secHover = over(s, sx, cy, sw, headerH)
                rect(sx, cy, sw, headerH, Theme.surface2, 3, 6, 0.7 * cAlpha)

                -- collapse chevron
                local chevX = sx + 8
                local chevY = cy + headerH / 2
                if sec.collapsed then
                    tri(v2(chevX, chevY - 4), v2(chevX, chevY + 4), v2(chevX + 5, chevY), Theme.sub, 4, true, cAlpha)
                else
                    tri(v2(chevX - 2, chevY - 2), v2(chevX + 6, chevY - 2), v2(chevX + 2, chevY + 3), Theme.sub, 4, true, cAlpha)
                end

                txt(string.upper(sec.name), sx + 20, textTop(cy, headerH, 10), Theme.sub, 10, FontBold, 4, false, false, sw - 30, cAlpha)

                if click and secHover then sec.collapsed = not sec.collapsed; click = false end

                cy = cy + headerH + 4

                -- section content
                if not sec.collapsed then
                    sec._collapseAnim = approach(sec._collapseAnim or 1, 1, 14, s.dt)
                    local itemY = cy
                    for _, item in ipairs(sec.items) do
                        local disabled = isItemDisabled(item)
                        local iAlpha = cAlpha * (disabled and 0.35 or 1) * (sec._collapseAnim or 1)

                        if item.type == "checkbox" then
                            local h = 28
                            local hovered = over(s, sx, itemY, sw, h) and not disabled

                            -- toggle track
                            local trackW, trackH = 32, 16
                            local trackX = sx + sw - trackW - 8
                            local trackY = itemY + (h - trackH) / 2

                            item._anim = approach(item._anim or 0, item.value and 1 or 0, 14, s.dt)
                            local trackColor = lerpColor(Theme.trackOff, accentMid(), item._anim)
                            rect(trackX, trackY, trackW, trackH, trackColor, 4, 8, iAlpha)

                            -- knob
                            local knobR = trackH / 2 - 2
                            local knobX = trackX + 2 + knobR + item._anim * (trackW - 2 * knobR - 4)
                            circ(knobX, trackY + trackH / 2, knobR, Theme.text, 5, true, 0, 16, iAlpha)

                            -- label
                            txt(item.label, sx + 8, textTop(itemY, h, 12), item.value and Theme.text or Theme.sub, 12, FontSystem, 4, false, false, sw - trackW - 24, iAlpha)

                            -- colorpicker swatch
                            if item.colorpicker then
                                local cpX = trackX - 20
                                rect(cpX, itemY + (h - 12) / 2, 12, 12, item.colorpicker.value, 5, 3, iAlpha)
                                strokeRect(cpX, itemY + (h - 12) / 2, 12, 12, Theme.border, 5, 3, 0.5 * iAlpha)
                                if click and over(s, cpX - 2, itemY + 2, 16, h - 4) and not disabled then
                                    s.colorpicker = { item = item.colorpicker, x = s.mouseX + 10, y = s.mouseY - 80 }
                                    click = false
                                end
                            end

                            -- keybind button
                            if item.keybind then
                                local kb = item.keybind
                                local kbLabel = kb.listening and "..." or (kb.value and string.upper(kb.value) or "-")
                                local kbW = max(28, textWidth(kbLabel, 10, FontMono) + 12)
                                local kbX = (item.colorpicker and trackX - 36 or trackX) - kbW - 4
                                local kbY = itemY + (h - 18) / 2
                                local kbHover = over(s, kbX, kbY, kbW, 18)
                                rect(kbX, kbY, kbW, 18, kbHover and Theme.surface3 or Theme.surface2, 4, 4, iAlpha)
                                strokeRect(kbX, kbY, kbW, 18, Theme.border, 5, 4, 0.5 * iAlpha)
                                txt(kbLabel, kbX + kbW / 2, textTop(kbY, 18, 10), Theme.sub, 10, FontMono, 5, true, false, nil, iAlpha)
                                if click and kbHover and not disabled then
                                    kb.listening = true
                                    click = false
                                end
                            end

                            if click and hovered then
                                item.value = not item.value; invoke(item.callback, item.value)
                                click = false
                            end

                            itemY = itemY + h

                        elseif item.type == "slider" then
                            local h = 36
                            txt(item.label, sx + 8, itemY + 2, Theme.text, 11, FontSystem, 4, false, false, sw * 0.5, iAlpha)
                            local valStr = tostring(item.value) .. (item.suffix or "")
                            txt(valStr, sx + sw - 8 - textWidth(valStr, 11, FontUI), itemY + 2, Theme.sub, 11, FontUI, 4, false, false, nil, iAlpha)

                            local barY = itemY + 20
                            local barX = sx + 8; local barW = sw - 16; local barH = 4
                            local pct = clamp((item.value - (item.min or 0)) / max(0.001, (item.max or 100) - (item.min or 0)), 0, 1)

                            rect(barX, barY, barW, barH, Theme.sliderTrack, 4, 2, iAlpha)
                            gradRectH(barX, barY, barW * pct, barH, Theme.accentA, Theme.accentB, 5, iAlpha)
                            circ(barX + barW * pct, barY + barH / 2, 5, Theme.text, 6, true, 0, 16, iAlpha)

                            local sliderHover = over(s, barX - 4, barY - 6, barW + 8, 16) and not disabled
                            if (click or held) and (sliderHover or s.sliderDrag == item) and not disabled then
                                s.sliderDrag = item
                                local raw = (item.min or 0) + clamp((s.mouseX - barX) / barW, 0, 1) * ((item.max or 100) - (item.min or 0))
                                local snapped = snapValue(raw, item)
                                if item.value ~= snapped then item.value = snapped; invoke(item.callback, snapped) end
                            end
                            if not held then s.sliderDrag = nil end

                            itemY = itemY + h

                        elseif item.type == "dropdown" then
                            local h = 44
                            txt(item.label, sx + 8, itemY + 2, Theme.text, 11, FontSystem, 4, false, false, sw * 0.6, iAlpha)

                            local boxY = itemY + 16; local boxH = 24; local boxW = sw - 16
                            local boxX = sx + 8
                            local boxHover = over(s, boxX, boxY, boxW, boxH) and not disabled

                            rect(boxX, boxY, boxW, boxH, boxHover and Theme.surface3 or Theme.surface2, 4, 4, iAlpha)
                            strokeRect(boxX, boxY, boxW, boxH, Theme.border, 5, 4, 0.4 * iAlpha)

                            local display = #item.value > 0 and concat(item.value, ", ") or "-"
                            txt(display, boxX + 8, textTop(boxY, boxH, 11), Theme.text, 11, FontSystem, 5, false, false, boxW - 24, iAlpha)
                            tri(v2(boxX + boxW - 16, boxY + boxH / 2 - 2), v2(boxX + boxW - 8, boxY + boxH / 2 - 2), v2(boxX + boxW - 12, boxY + boxH / 2 + 3), Theme.sub, 5, true, iAlpha)

                            if click and boxHover then
                                s.dropdown = {
                                    item = item, x = boxX, y = boxY + boxH + 2, w = boxW,
                                    choices = copyArray(item.choices), scrollOffset = 0, filterQ = "",
                                }
                                click = false
                            end

                            itemY = itemY + h

                        elseif item.type == "textbox" then
                            local h = 44
                            txt(item.label, sx + 8, itemY + 2, Theme.text, 11, FontSystem, 4, false, false, sw * 0.6, iAlpha)

                            local boxY = itemY + 16; local boxH = 24; local boxW = sw - 16
                            local boxX = sx + 8
                            local isFocused = (s.focus == item)
                            local boxHover = over(s, boxX, boxY, boxW, boxH) and not disabled

                            rect(boxX, boxY, boxW, boxH, Theme.surface2, 4, 4, iAlpha)
                            strokeRect(boxX, boxY, boxW, boxH, isFocused and accentMid() or Theme.border, 5, 4, (isFocused and 0.8 or 0.4) * iAlpha)

                            if item.value == "" and not isFocused then
                                txt(item.placeholder, boxX + 8, textTop(boxY, boxH, 11), Theme.sub, 11, FontSystem, 5, false, false, boxW - 16, 0.4 * iAlpha)
                            else
                                local display = item.value .. (isFocused and (floor(clock() * 2) % 2 == 0 and "|" or "") or "")
                                txt(display, boxX + 8, textTop(boxY, boxH, 11), Theme.text, 11, FontSystem, 5, false, false, boxW - 16, iAlpha)
                            end

                            if click and boxHover then s.focus = item; click = false
                            elseif click and isFocused and not boxHover then
                                s.focus = nil; invoke(item.callback, item.value)
                            end

                            -- text input
                            if isFocused then
                                if Input["backspace"] and Input["backspace"].click and #item.value > 0 then
                                    item.value = string.sub(item.value, 1, -2)
                                elseif Input["enter"] and Input["enter"].click then
                                    s.focus = nil; invoke(item.callback, item.value)
                                else
                                    local shift = (Input["shift"] and Input["shift"].held) or false
                                    for _, name in ipairs(InputOrder) do
                                        local inp = Input[name]
                                        if inp.click and inp.char then
                                            item.value = item.value .. (shift and inp.shifted or inp.char)
                                        end
                                    end
                                end
                            end

                            itemY = itemY + h

                        elseif item.type == "button" then
                            local btnH = 28
                            local btnCount = item.buttons and #item.buttons or 1
                            local gap = 6
                            local btnW = floor((sw - 16 - (btnCount - 1) * gap) / btnCount)
                            for bi, btn in ipairs(item.buttons or {}) do
                                local bx = sx + 8 + (bi - 1) * (btnW + gap)
                                local bHover = over(s, bx, itemY, btnW, btnH) and not disabled
                                rect(bx, itemY, btnW, btnH, bHover and Theme.surface3 or Theme.surface2, 4, 5, iAlpha)
                                strokeRect(bx, itemY, btnW, btnH, bHover and accentMid() or Theme.border, 5, 5, 0.5 * iAlpha)
                                txt(btn.label, bx + btnW / 2, textTop(itemY, btnH, 11), Theme.text, 11, FontSystem, 5, true, false, btnW - 12, iAlpha)
                                if click and bHover then invoke(btn.callback); click = false end
                            end
                            itemY = itemY + btnH + 4

                        elseif item.type == "keybind" then
                            local h = 28
                            txt(item.label, sx + 8, textTop(itemY, h, 11), Theme.text, 11, FontSystem, 4, false, false, sw * 0.5, iAlpha)

                            local kbLabel = item.listening and "..." or (item.value and string.upper(item.value) or "-")
                            local kbW = max(36, textWidth(kbLabel, 11, FontMono) + 16)
                            local kbX = sx + sw - 8 - kbW
                            local kbY = itemY + (h - 22) / 2
                            local kbHover = over(s, kbX, kbY, kbW, 22) and not disabled
                            rect(kbX, kbY, kbW, 22, kbHover and Theme.surface3 or Theme.surface2, 4, 5, iAlpha)
                            strokeRect(kbX, kbY, kbW, 22, Theme.border, 5, 5, 0.4 * iAlpha)
                            txt(kbLabel, kbX + kbW / 2, textTop(kbY, 22, 11), Theme.sub, 11, FontMono, 5, true, false, nil, iAlpha)

                            if click and kbHover and not disabled then item.listening = true; click = false end

                            itemY = itemY + h

                        elseif item.type == "colorpicker" then
                            local h = 28
                            txt(item.label, sx + 8, textTop(itemY, h, 11), Theme.text, 11, FontSystem, 4, false, false, sw * 0.6, iAlpha)
                            local cpX = sx + sw - 24
                            local cpY = itemY + (h - 14) / 2
                            rect(cpX, cpY, 14, 14, item.value, 5, 3, iAlpha)
                            strokeRect(cpX, cpY, 14, 14, Theme.border, 5, 3, 0.5 * iAlpha)
                            local cpHover = over(s, cpX - 2, cpY - 2, 18, 18) and not disabled
                            if cpHover then strokeRect(cpX - 1, cpY - 1, 16, 16, accentMid(), 6, 4, iAlpha) end
                            if click and cpHover then
                                s.colorpicker = { item = item, x = s.mouseX + 10, y = s.mouseY - 80 }
                                click = false
                            end
                            itemY = itemY + h

                        elseif item.type == "label" then
                            txt(item.label, sx + 8, itemY + 4, item.color or Theme.text, 11, FontSystem, 4, false, false, sw - 16, iAlpha)
                            itemY = itemY + 20

                        elseif item.type == "separator" then
                            local sepY = itemY + 8
                            if item.label and item.label ~= "" then
                                local tw = textWidth(item.label, 10, FontSystem)
                                local lineW = max(4, (sw - 16 - tw - 16) / 2)
                                lineD(sx + 8, sepY, sx + 8 + lineW, sepY, Theme.border, 4, 1, 0.5 * iAlpha)
                                txt(item.label, sx + 8 + lineW + 8, sepY - 5, Theme.sub, 10, FontSystem, 4, false, false, tw + 4, iAlpha)
                                lineD(sx + 8 + lineW + tw + 16, sepY, sx + sw - 8, sepY, Theme.border, 4, 1, 0.5 * iAlpha)
                            else
                                lineD(sx + 8, sepY, sx + sw - 8, sepY, Theme.border, 4, 1, 0.5 * iAlpha)
                            end
                            itemY = itemY + 16
                        end

                        -- tooltip
                        if item.tooltip and s.tooltipsEnabled and over(s, sx, itemY - 32, sw, 28) then
                            s.tooltipText = item.tooltip; s.tooltipX = s.mouseX + 12; s.tooltipY = s.mouseY + 16
                        end
                    end
                else
                    sec._collapseAnim = approach(sec._collapseAnim or 0, 0, 14, s.dt)
                end

                cy = cy + 4
            end
        end

        renderSections(leftSections, leftX, colW)
        renderSections(rightSections, rightX, colW)
    end

    -- ── RESIZE HANDLES ──
    if not s.drag and not s.resizeEdge then
        if over(s, wx + ww - 6, wy + wh - 6, 12, 12) then
            if click then s.resizeEdge = "br"; click = false end
        elseif over(s, wx + ww - 4, wy + TITLE_H, 8, wh - TITLE_H) then
            if click then s.resizeEdge = "r"; click = false end
        elseif over(s, wx, wy + wh - 4, ww, 8) then
            if click then s.resizeEdge = "b"; click = false end
        end
    end

    -- ── DROPDOWN POPUP ──
    if s.dropdown then
        local dd = s.dropdown
        local ddItem = dd.item
        local ddX, ddY, ddW = dd.x, dd.y, dd.w
        local choices = dd.choices
        local itemH = 24; local ddH = min(#choices * itemH + 8, 220)

        rect(ddX, ddY, ddW, ddH, Theme.surface, 10, 6, vis)
        strokeRect(ddX, ddY, ddW, ddH, Theme.border, 11, 6, 0.6 * vis)

        local ci = 0
        for idx = 1, #choices do
            local choice = choices[idx]
            local cy = ddY + 4 + ci * itemH
            if cy + itemH > ddY + ddH then break end

            local isSelected = false
            for _, v in ipairs(ddItem.value) do if v == choice then isSelected = true; break end end

            local rowHover = over(s, ddX + 2, cy, ddW - 4, itemH)
            if rowHover then rect(ddX + 2, cy, ddW - 4, itemH, Theme.surface3, 11, 4, vis) end
            if isSelected then
                rect(ddX + 4, cy + 2, 3, itemH - 4, accentMid(), 12, 2, vis)
            end

            txt(choice, ddX + 14, textTop(cy, itemH, 11), isSelected and Theme.text or Theme.sub, 11, FontSystem, 12, false, false, ddW - 28, vis)

            if click and rowHover then
                if ddItem.multi then
                    if isSelected then
                        for i = #ddItem.value, 1, -1 do if ddItem.value[i] == choice then remove(ddItem.value, i) end end
                    else
                        if not ddItem.maxSelections or #ddItem.value < ddItem.maxSelections then
                            ddItem.value[#ddItem.value + 1] = choice
                        end
                    end
                    invoke(ddItem.callback, ddItem.value)
                else
                    ddItem.value = { choice }; invoke(ddItem.callback, ddItem.value)
                    s.dropdown = nil
                end
                click = false
            end

            ci = ci + 1
        end

        -- close on click outside
        if click and not over(s, ddX, ddY, ddW, ddH) then s.dropdown = nil; click = false end
    end

    -- ── COLOR PICKER POPUP ──
    if s.colorpicker then
        local cp = s.colorpicker
        local cpItem = cp.item
        local cpX, cpY = cp.x, cp.y
        local cpW, cpH = 200, 220

        -- clamp to viewport
        local vw2, vh2 = viewportSize()
        cpX = clamp(cpX, 8, vw2 - cpW - 8); cpY = clamp(cpY, 8, vh2 - cpH - 8)
        cp.x = cpX; cp.y = cpY

        rect(cpX, cpY, cpW, cpH, Theme.surface, 20, 6, vis)
        strokeRect(cpX, cpY, cpW, cpH, Theme.border, 21, 6, 0.6 * vis)

        txt(cpItem.label or "Color", cpX + 8, cpY + 6, Theme.text, 11, FontBold, 22, false, false, cpW - 16, vis)

        -- HSV canvas
        local canvasX = cpX + 8; local canvasY = cpY + 24; local canvasW = cpW - 16; local canvasH = 120
        local h2, s2, v2val = rgbToHsv(cpItem.value)

        -- canvas bg (simplified: just show the color and a gradient overlay)
        local hueColor = hsv(h2, 1, 1)
        rect(canvasX, canvasY, canvasW, canvasH, hueColor, 22, 4, vis)
        -- white gradient left to right
        for gi = 0, 15 do
            local t = gi / 15
            rect(canvasX + canvasW * t, canvasY, canvasW / 15 + 1, canvasH, WHITE, 22, 0, (1 - t) * 0.8 * vis)
        end
        -- black gradient bottom to top
        for gi = 0, 15 do
            local t = gi / 15
            rect(canvasX, canvasY + canvasH * t, canvasW, canvasH / 15 + 1, BLACK, 23, 0, t * 0.9 * vis)
        end

        -- cursor on canvas
        local cursorX = canvasX + s2 * canvasW
        local cursorY = canvasY + (1 - v2val) * canvasH
        circ(cursorX, cursorY, 4, WHITE, 24, false, 1.5, 16, vis)
        circ(cursorX, cursorY, 3, cpItem.value, 24, true, 0, 16, vis)

        -- hue bar
        local hueBarY = canvasY + canvasH + 8; local hueBarH = 12
        for gi = 0, 19 do
            local t = gi / 19
            rect(canvasX + canvasW * t, hueBarY, canvasW / 19 + 1, hueBarH, hsv(t, 1, 1), 22, 0, vis)
        end
        local hueKnobX = canvasX + h2 * canvasW
        rect(hueKnobX - 2, hueBarY - 1, 4, hueBarH + 2, WHITE, 24, 2, vis)

        -- alpha bar
        local alphaBarY = hueBarY + hueBarH + 6; local alphaBarH = 12
        rect(canvasX, alphaBarY, canvasW, alphaBarH, Theme.surface3, 22, 0, vis)
        gradRectH(canvasX, alphaBarY, canvasW, alphaBarH, BLACK, cpItem.value, 23, vis)
        local alphaKnobX = canvasX + (cpItem.alpha or 1) * canvasW
        rect(alphaKnobX - 2, alphaBarY - 1, 4, alphaBarH + 2, WHITE, 24, 2, vis)

        -- hex display
        local hexY = alphaBarY + alphaBarH + 8
        txt(toHex(cpItem.value), canvasX, hexY, Theme.sub, 11, FontMono, 22, false, false, nil, vis)

        -- preview swatch
        rect(cpX + cpW - 32, hexY - 2, 24, 16, cpItem.value, 22, 4, vis)
        strokeRect(cpX + cpW - 32, hexY - 2, 24, 16, Theme.border, 23, 4, 0.5 * vis)

        -- interactions
        if held and over(s, canvasX - 4, canvasY - 4, canvasW + 8, canvasH + 8) then
            local ns = clamp((s.mouseX - canvasX) / canvasW, 0, 1)
            local nv = 1 - clamp((s.mouseY - canvasY) / canvasH, 0, 1)
            cpItem.value = hsv(h2, ns, nv)
            invoke(cpItem.callback, cpItem.value, cpItem.alpha)
        end
        if held and over(s, canvasX - 4, hueBarY - 4, canvasW + 8, hueBarH + 8) then
            local nh = clamp((s.mouseX - canvasX) / canvasW, 0, 1)
            cpItem.value = hsv(nh, s2, v2val)
            invoke(cpItem.callback, cpItem.value, cpItem.alpha)
        end
        if held and over(s, canvasX - 4, alphaBarY - 4, canvasW + 8, alphaBarH + 8) then
            cpItem.alpha = clamp((s.mouseX - canvasX) / canvasW, 0, 1)
            invoke(cpItem.callback, cpItem.value, cpItem.alpha)
        end

        -- close on click outside
        if click and not over(s, cpX, cpY, cpW, cpH) then s.colorpicker = nil; click = false end
    end

    -- ── KEYBIND LISTENING ──
    for _, kbItem in ipairs(keybindItems) do
        local kb = kbItem.keybind or kbItem
        if kb.listening then
            for _, name in ipairs(InputOrder) do
                local inp = Input[name]
                if inp.click and name ~= "m1" and name ~= "m2" and name ~= "esc" then
                    kb.value = name; kb.listening = false
                    invoke(kb.callback, name, kb.mode)
                    break
                end
            end
            if Input["esc"] and Input["esc"].click then
                kb.value = nil; kb.listening = false
            end
        end
    end

    -- ── KEYBIND PROCESSING ──
    for _, kbItem in ipairs(keybindItems) do
        local kb = kbItem.keybind or kbItem
        if kb and not kb.listening and kb.value then
            local mod, key = parseCombo(kb.value)
            local kIn = Input[key or kb.value]
            if kIn then
                local activated = false
                if mod then
                    local mIn = Input[mod]
                    activated = mIn and mIn.held and kIn.click
                else
                    activated = kIn.click
                end
                if activated then
                    if kbItem.type == "checkbox" then
                        if kb.mode == "Toggle" then
                            kbItem.value = not kbItem.value; invoke(kbItem.callback, kbItem.value)
                        end
                    end
                    invoke(kb.callback, kb.value, kb.mode)
                end
            end
        end
    end

    -- ── TOOLTIP ──
    if s.tooltipText then
        local tw = textWidth(s.tooltipText, 11, FontSystem) + 16
        local th = 22
        local tx = clamp(s.tooltipX, 4, select(1, viewportSize()) - tw - 4)
        local ty = s.tooltipY
        rect(tx, ty, tw, th, Theme.surface, 30, 4, 0.95 * vis)
        strokeRect(tx, ty, tw, th, Theme.border, 31, 4, 0.5 * vis)
        txt(s.tooltipText, tx + 8, textTop(ty, th, 11), Theme.text, 11, FontSystem, 31, false, false, tw - 16, vis)
        s.tooltipText = nil
    end

    -- release slider on mouse up
    if not held then s.sliderDrag = nil end
end

-- ═══════════════════════ NOTIFICATIONS ═══════════════════════
function Bwin:_renderNotifications()
    local s = self._state
    local vis = s.drawVisible
    local notifications = s.notifications
    while #notifications > 10 do remove(notifications, 1) end

    local width, height = 280, 52
    local i = 1
    while i <= #notifications do
        local n = notifications[i]
        n.elapsed = n.elapsed + s.dt
        if n.elapsed >= n.duration then remove(notifications, i)
        else
            local targetX = select(1, viewportSize()) - width - 16
            local targetY = select(2, viewportSize()) - 16 - i * (height + 8)
            n.cx = approach(n.cx or (targetX + 300), targetX, 12, s.dt)
            n.cy = approach(n.cy or targetY, targetY, 12, s.dt)

            local fadeAlpha = 1
            if n.elapsed < 0.25 then fadeAlpha = n.elapsed / 0.25
            elseif n.duration - n.elapsed < 0.35 then fadeAlpha = (n.duration - n.elapsed) / 0.35 end
            fadeAlpha = clamp(fadeAlpha, 0, 1) * vis

            rect(n.cx, n.cy, width, height, Theme.surface2, 40, 6, 0.9 * fadeAlpha)
            strokeRect(n.cx, n.cy, width, height, Theme.border, 41, 6, 0.5 * fadeAlpha)

            -- accent bar
            gradRectH(n.cx, n.cy, 3, height, Theme.accentA, Theme.accentB, 42, fadeAlpha)

            txt(n.title, n.cx + 14, n.cy + 10, accentMid(), 11, FontBold, 42, false, false, width - 28, fadeAlpha)
            txt(n.description, n.cx + 14, n.cy + 26, Theme.text, 11, FontSystem, 42, false, false, width - 28, 0.8 * fadeAlpha)

            -- progress bar
            local barY = n.cy + height - 4; local barW = width - 12
            local barFill = barW * clamp(1 - n.elapsed / n.duration, 0, 1)
            rect(n.cx + 6, barY, barW, 2, Theme.surface3, 42, 1, fadeAlpha)
            if barFill > 1 then gradRectH(n.cx + 6, barY, barFill, 2, Theme.accentA, Theme.accentB, 43, fadeAlpha) end

            i = i + 1
        end
    end
end

-- ═══════════════════════ SPOTLIGHT ═══════════════════════
function Bwin:_renderSpotlight()
    local s = self._state
    local vis = s.drawVisible
    local vw, vh = viewportSize()
    local spW, spH = 400, 44

    local spX = floor((vw - spW) / 2)
    local spY = floor(vh * 0.25)

    -- backdrop
    rect(0, 0, vw, vh, BLACK, 50, 0, 0.3 * vis)

    -- search box
    rect(spX, spY, spW, spH, Theme.surface, 51, 8, 0.95 * vis)
    strokeRect(spX, spY, spW, spH, accentMid(), 52, 8, 0.6 * vis)

    drawIcon("search", spX + 12, spY + (spH - 18) / 2, 18, Theme.sub, 52, vis)

    local display = s.spotlightQuery .. (floor(clock() * 2) % 2 == 0 and "|" or "")
    if s.spotlightQuery == "" then
        txt("Search widgets...", spX + 40, textTop(spY, spH, 13), Theme.sub, 13, FontSystem, 52, false, false, spW - 56, 0.4 * vis)
    else
        txt(display, spX + 40, textTop(spY, spH, 13), Theme.text, 13, FontSystem, 52, false, false, spW - 56, vis)
    end

    -- typing
    if Input["backspace"] and Input["backspace"].click and #s.spotlightQuery > 0 then
        s.spotlightQuery = string.sub(s.spotlightQuery, 1, -2)
    elseif Input["esc"] and Input["esc"].click then
        s.spotlightOpen = false; return
    else
        local shift = Input["shift"] and Input["shift"].held or false
        for _, name in ipairs(InputOrder) do
            local inp = Input[name]
            if inp.click and inp.char then
                s.spotlightQuery = s.spotlightQuery .. (shift and inp.shifted or inp.char)
            end
        end
    end

    -- results
    local results = {}
    local q = string.lower(s.spotlightQuery)
    if q ~= "" then
        for _, tab in ipairs(s.tabs) do
            for _, sec in ipairs(tab.sections) do
                for _, item in ipairs(sec.items) do
                    if item.label and string.find(string.lower(item.label), q, 1, true) then
                        results[#results + 1] = { tab = tab, label = item.label, tabName = tab.name }
                    end
                end
            end
        end
    end

    if #results > 0 then
        local resY = spY + spH + 4
        local resH = min(#results * 28 + 8, 200)
        rect(spX, resY, spW, resH, Theme.surface, 51, 6, 0.9 * vis)
        strokeRect(spX, resY, spW, resH, Theme.border, 52, 6, 0.4 * vis)

        s.spotlightSelected = clamp(s.spotlightSelected, 1, #results)
        if Input["up"] and Input["up"].click then s.spotlightSelected = max(1, s.spotlightSelected - 1) end
        if Input["down"] and Input["down"].click then s.spotlightSelected = min(#results, s.spotlightSelected + 1) end

        for ri = 1, min(#results, 7) do
            local r = results[ri]
            local ry = resY + 4 + (ri - 1) * 28
            local isSel = (ri == s.spotlightSelected)
            if isSel then rect(spX + 4, ry, spW - 8, 24, Theme.surface3, 52, 4, vis) end
            txt(r.label, spX + 14, textTop(ry, 24, 11), Theme.text, 11, FontSystem, 53, false, false, spW * 0.55, vis)
            txt(r.tabName, spX + spW - 14 - textWidth(r.tabName, 10, FontUI), textTop(ry, 24, 10), Theme.sub, 10, FontUI, 53, false, false, nil, 0.5 * vis)
        end

        if Input["enter"] and Input["enter"].click then
            local sel = results[s.spotlightSelected]
            if sel then
                for i, tab in ipairs(s.tabs) do
                    if tab == sel.tab then s.activeTab = tab; s.activeIndex = i; s.contentFade = 0; break end
                end
            end
            s.spotlightOpen = false
        end
    end
end

-- ═══════════════════════ EXPORT ═══════════════════════
Bwin.Themes = {}
for k in pairs(ThemePresets) do Bwin.Themes[#Bwin.Themes + 1] = k end
table.sort(Bwin.Themes)

-- write to global
pcall(function() _G.Bwin = Bwin end)
pcall(function() shared.Bwin = Bwin end)

return Bwin
--a
