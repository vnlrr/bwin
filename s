local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

Bwin = {}
local UI = Bwin

local Theme = {
    Accent = Color3.fromRGB(96, 205, 255),
    WindowBg = Color3.fromRGB(36, 36, 36),
    WindowBorder = Color3.fromRGB(0, 0, 0),
    TitleBarLine = Color3.fromRGB(75, 75, 75),
    RailLine = Color3.fromRGB(60, 60, 60),
    Title = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(170, 170, 170),
    TabText = Color3.fromRGB(150, 150, 150),
    TabTextActive = Color3.fromRGB(240, 240, 240),
    TabHighlight = Color3.fromRGB(130, 130, 130),
    Element = Color3.fromRGB(130, 130, 130),
    ElementBorder = Color3.fromRGB(20, 20, 20),
    Text = Color3.fromRGB(240, 240, 240),
    ToggleSlider = Color3.fromRGB(120, 120, 120),
    ToggleKnobOn = Color3.fromRGB(10, 10, 10),
    Control = Color3.fromRGB(66, 66, 66),
    OverlayBg = Color3.fromRGB(42, 42, 42),
    OverlayBorder = Color3.fromRGB(20, 20, 20),
}

local OP = {
    Window = 0.99,
    Border = 0.40,
    Element = 0.16,
    ElementHover = 0.26,
    Rail = 0.5,
    TabActive = 0.16,
    TabHover = 0.09,
    Control = 0.85,
    Overlay = 0.99,
}

local Palettes = {
    Dark = {},
    Darker = { WindowBg = Color3.fromRGB(24, 24, 24), OverlayBg = Color3.fromRGB(30, 30, 30), Control = Color3.fromRGB(50, 50, 50) },
    Aqua = { Accent = Color3.fromRGB(38, 200, 200) },
    Amethyst = { Accent = Color3.fromRGB(170, 120, 255) },
    Rose = { Accent = Color3.fromRGB(255, 120, 165) },
    Ocean = { Accent = Color3.fromRGB(80, 150, 255), WindowBg = Color3.fromRGB(28, 32, 40), OverlayBg = Color3.fromRGB(34, 39, 48) },
    ["Adapta Nokto"] = {
        Accent = Color3.fromRGB(236, 106, 63), WindowBg = Color3.fromRGB(49, 49, 46), WindowBorder = Color3.fromRGB(64, 63, 58), TitleBarLine = Color3.fromRGB(64, 63, 58), RailLine = Color3.fromRGB(64, 63, 58),
        Title = Color3.fromRGB(221, 221, 221), SubText = Color3.fromRGB(116, 124, 132), TabText = Color3.fromRGB(221, 221, 221), TabTextActive = Color3.fromRGB(221, 221, 221), TabHighlight = Color3.fromRGB(64, 63, 58),
        Element = Color3.fromRGB(55, 54, 51), ElementBorder = Color3.fromRGB(64, 63, 58), Text = Color3.fromRGB(221, 221, 221), ToggleSlider = Color3.fromRGB(236, 106, 63), ToggleKnobOn = Color3.fromRGB(49, 49, 46),
        Control = Color3.fromRGB(55, 54, 51), OverlayBg = Color3.fromRGB(55, 54, 51), OverlayBorder = Color3.fromRGB(64, 63, 58),
    },
    ["Ambiance"] = {
        Accent = Color3.fromRGB(0, 188, 212), WindowBg = Color3.fromRGB(41, 53, 59), WindowBorder = Color3.fromRGB(34, 45, 50), TitleBarLine = Color3.fromRGB(34, 45, 50), RailLine = Color3.fromRGB(34, 45, 50),
        Title = Color3.fromRGB(238, 255, 255), SubText = Color3.fromRGB(84, 110, 122), TabText = Color3.fromRGB(238, 255, 255), TabTextActive = Color3.fromRGB(238, 255, 255), TabHighlight = Color3.fromRGB(45, 59, 66),
        Element = Color3.fromRGB(36, 48, 53), ElementBorder = Color3.fromRGB(34, 45, 50), Text = Color3.fromRGB(238, 255, 255), ToggleSlider = Color3.fromRGB(0, 188, 212), ToggleKnobOn = Color3.fromRGB(41, 53, 59),
        Control = Color3.fromRGB(36, 48, 53), OverlayBg = Color3.fromRGB(36, 48, 53), OverlayBorder = Color3.fromRGB(34, 45, 50),
    },
    ["Amethyst Dark"] = {
        Accent = Color3.fromRGB(177, 51, 255), WindowBg = Color3.fromRGB(18, 0, 36), WindowBorder = Color3.fromRGB(77, 5, 123), TitleBarLine = Color3.fromRGB(77, 5, 123), RailLine = Color3.fromRGB(77, 5, 123),
        Title = Color3.fromRGB(233, 217, 242), SubText = Color3.fromRGB(158, 133, 173), TabText = Color3.fromRGB(233, 217, 242), TabTextActive = Color3.fromRGB(233, 217, 242), TabHighlight = Color3.fromRGB(77, 5, 123),
        Element = Color3.fromRGB(37, 1, 60), ElementBorder = Color3.fromRGB(77, 5, 123), Text = Color3.fromRGB(233, 217, 242), ToggleSlider = Color3.fromRGB(125, 22, 191), ToggleKnobOn = Color3.fromRGB(18, 0, 36),
        Control = Color3.fromRGB(37, 1, 60), OverlayBg = Color3.fromRGB(37, 1, 60), OverlayBorder = Color3.fromRGB(77, 5, 123),
    },
    ["Arc Dark"] = {
        Accent = Color3.fromRGB(82, 148, 226), WindowBg = Color3.fromRGB(56, 60, 74), WindowBorder = Color3.fromRGB(64, 79, 125), TitleBarLine = Color3.fromRGB(64, 79, 125), RailLine = Color3.fromRGB(64, 79, 125),
        Title = Color3.fromRGB(162, 162, 162), SubText = Color3.fromRGB(114, 133, 183), TabText = Color3.fromRGB(162, 162, 162), TabTextActive = Color3.fromRGB(162, 162, 162), TabHighlight = Color3.fromRGB(75, 81, 98),
        Element = Color3.fromRGB(75, 81, 98), ElementBorder = Color3.fromRGB(64, 79, 125), Text = Color3.fromRGB(162, 162, 162), ToggleSlider = Color3.fromRGB(82, 148, 226), ToggleKnobOn = Color3.fromRGB(56, 60, 74),
        Control = Color3.fromRGB(75, 81, 98), OverlayBg = Color3.fromRGB(75, 81, 98), OverlayBorder = Color3.fromRGB(64, 79, 125),
    },
    ["DuoTone Dark Earth"] = {
        Accent = Color3.fromRGB(254, 203, 82), WindowBg = Color3.fromRGB(44, 40, 38), WindowBorder = Color3.fromRGB(72, 65, 61), TitleBarLine = Color3.fromRGB(72, 65, 61), RailLine = Color3.fromRGB(72, 65, 61),
        Title = Color3.fromRGB(189, 152, 127), SubText = Color3.fromRGB(86, 75, 67), TabText = Color3.fromRGB(189, 152, 127), TabTextActive = Color3.fromRGB(189, 152, 127), TabHighlight = Color3.fromRGB(77, 70, 66),
        Element = Color3.fromRGB(53, 48, 45), ElementBorder = Color3.fromRGB(72, 65, 61), Text = Color3.fromRGB(189, 152, 127), ToggleSlider = Color3.fromRGB(254, 203, 82), ToggleKnobOn = Color3.fromRGB(44, 40, 38),
        Control = Color3.fromRGB(53, 48, 45), OverlayBg = Color3.fromRGB(53, 48, 45), OverlayBorder = Color3.fromRGB(72, 65, 61),
    },
    ["DuoTone Dark Forest"] = {
        Accent = Color3.fromRGB(231, 249, 139), WindowBg = Color3.fromRGB(42, 45, 42), WindowBorder = Color3.fromRGB(66, 72, 66), TitleBarLine = Color3.fromRGB(66, 72, 66), RailLine = Color3.fromRGB(66, 72, 66),
        Title = Color3.fromRGB(169, 188, 169), SubText = Color3.fromRGB(88, 95, 88), TabText = Color3.fromRGB(169, 188, 169), TabTextActive = Color3.fromRGB(169, 188, 169), TabHighlight = Color3.fromRGB(71, 77, 71),
        Element = Color3.fromRGB(49, 53, 49), ElementBorder = Color3.fromRGB(66, 72, 66), Text = Color3.fromRGB(169, 188, 169), ToggleSlider = Color3.fromRGB(231, 249, 139), ToggleKnobOn = Color3.fromRGB(42, 45, 42),
        Control = Color3.fromRGB(49, 53, 49), OverlayBg = Color3.fromRGB(49, 53, 49), OverlayBorder = Color3.fromRGB(66, 72, 66),
    },
    ["DuoTone Dark Sea"] = {
        Accent = Color3.fromRGB(52, 254, 187), WindowBg = Color3.fromRGB(29, 38, 47), WindowBorder = Color3.fromRGB(48, 63, 79), TitleBarLine = Color3.fromRGB(48, 63, 79), RailLine = Color3.fromRGB(48, 63, 79),
        Title = Color3.fromRGB(136, 180, 231), SubText = Color3.fromRGB(68, 76, 85), TabText = Color3.fromRGB(136, 180, 231), TabTextActive = Color3.fromRGB(136, 180, 231), TabHighlight = Color3.fromRGB(53, 68, 84),
        Element = Color3.fromRGB(35, 45, 56), ElementBorder = Color3.fromRGB(48, 63, 79), Text = Color3.fromRGB(136, 180, 231), ToggleSlider = Color3.fromRGB(52, 254, 187), ToggleKnobOn = Color3.fromRGB(29, 38, 47),
        Control = Color3.fromRGB(35, 45, 56), OverlayBg = Color3.fromRGB(35, 45, 56), OverlayBorder = Color3.fromRGB(48, 63, 79),
    },
    ["DuoTone Dark Sky"] = {
        Accent = Color3.fromRGB(254, 195, 143), WindowBg = Color3.fromRGB(44, 39, 52), WindowBorder = Color3.fromRGB(68, 61, 81), TitleBarLine = Color3.fromRGB(68, 61, 81), RailLine = Color3.fromRGB(68, 61, 81),
        Title = Color3.fromRGB(202, 178, 250), SubText = Color3.fromRGB(84, 77, 96), TabText = Color3.fromRGB(202, 178, 250), TabTextActive = Color3.fromRGB(202, 178, 250), TabHighlight = Color3.fromRGB(73, 66, 86),
        Element = Color3.fromRGB(52, 46, 61), ElementBorder = Color3.fromRGB(68, 61, 81), Text = Color3.fromRGB(202, 178, 250), ToggleSlider = Color3.fromRGB(254, 195, 143), ToggleKnobOn = Color3.fromRGB(44, 39, 52),
        Control = Color3.fromRGB(52, 46, 61), OverlayBg = Color3.fromRGB(52, 46, 61), OverlayBorder = Color3.fromRGB(68, 61, 81),
    },
    ["DuoTone Dark Space"] = {
        Accent = Color3.fromRGB(254, 119, 52), WindowBg = Color3.fromRGB(36, 36, 46), WindowBorder = Color3.fromRGB(58, 58, 74), TitleBarLine = Color3.fromRGB(58, 58, 74), RailLine = Color3.fromRGB(58, 58, 74),
        Title = Color3.fromRGB(134, 134, 203), SubText = Color3.fromRGB(73, 73, 90), TabText = Color3.fromRGB(134, 134, 203), TabTextActive = Color3.fromRGB(134, 134, 203), TabHighlight = Color3.fromRGB(63, 63, 79),
        Element = Color3.fromRGB(43, 43, 54), ElementBorder = Color3.fromRGB(58, 58, 74), Text = Color3.fromRGB(134, 134, 203), ToggleSlider = Color3.fromRGB(254, 119, 52), ToggleKnobOn = Color3.fromRGB(36, 36, 46),
        Control = Color3.fromRGB(43, 43, 54), OverlayBg = Color3.fromRGB(43, 43, 54), OverlayBorder = Color3.fromRGB(58, 58, 74),
    },
    ["Elementary"] = {
        Accent = Color3.fromRGB(203, 82, 38), WindowBg = Color3.fromRGB(239, 240, 241), WindowBorder = Color3.fromRGB(233, 209, 141), TitleBarLine = Color3.fromRGB(233, 209, 141), RailLine = Color3.fromRGB(233, 209, 141),
        Title = Color3.fromRGB(94, 94, 94), SubText = Color3.fromRGB(147, 161, 161), TabText = Color3.fromRGB(94, 94, 94), TabTextActive = Color3.fromRGB(94, 94, 94), TabHighlight = Color3.fromRGB(214, 214, 214),
        Element = Color3.fromRGB(253, 246, 227), ElementBorder = Color3.fromRGB(233, 209, 141), Text = Color3.fromRGB(94, 94, 94), ToggleSlider = Color3.fromRGB(203, 82, 38), ToggleKnobOn = Color3.fromRGB(253, 246, 227),
        Control = Color3.fromRGB(251, 239, 206), OverlayBg = Color3.fromRGB(251, 239, 206), OverlayBorder = Color3.fromRGB(233, 209, 141),
    },
    ["GitHub Dark Colorblind"] = {
        Accent = Color3.fromRGB(31, 111, 235), WindowBg = Color3.fromRGB(1, 4, 9), WindowBorder = Color3.fromRGB(48, 54, 61), TitleBarLine = Color3.fromRGB(48, 54, 61), RailLine = Color3.fromRGB(48, 54, 61),
        Title = Color3.fromRGB(201, 209, 217), SubText = Color3.fromRGB(139, 148, 158), TabText = Color3.fromRGB(201, 209, 217), TabTextActive = Color3.fromRGB(201, 209, 217), TabHighlight = Color3.fromRGB(110, 118, 129),
        Element = Color3.fromRGB(22, 27, 34), ElementBorder = Color3.fromRGB(48, 54, 61), Text = Color3.fromRGB(201, 209, 217), ToggleSlider = Color3.fromRGB(31, 111, 235), ToggleKnobOn = Color3.fromRGB(13, 17, 23),
        Control = Color3.fromRGB(22, 27, 34), OverlayBg = Color3.fromRGB(22, 27, 34), OverlayBorder = Color3.fromRGB(48, 54, 61),
    },
    ["GitHub Dark Default"] = {
        Accent = Color3.fromRGB(31, 111, 235), WindowBg = Color3.fromRGB(1, 4, 9), WindowBorder = Color3.fromRGB(48, 54, 61), TitleBarLine = Color3.fromRGB(48, 54, 61), RailLine = Color3.fromRGB(48, 54, 61),
        Title = Color3.fromRGB(230, 237, 243), SubText = Color3.fromRGB(125, 133, 144), TabText = Color3.fromRGB(230, 237, 243), TabTextActive = Color3.fromRGB(230, 237, 243), TabHighlight = Color3.fromRGB(110, 118, 129),
        Element = Color3.fromRGB(22, 27, 34), ElementBorder = Color3.fromRGB(48, 54, 61), Text = Color3.fromRGB(230, 237, 243), ToggleSlider = Color3.fromRGB(31, 111, 235), ToggleKnobOn = Color3.fromRGB(13, 17, 23),
        Control = Color3.fromRGB(22, 27, 34), OverlayBg = Color3.fromRGB(22, 27, 34), OverlayBorder = Color3.fromRGB(48, 54, 61),
    },
    ["GitHub Dark Dimmed"] = {
        Accent = Color3.fromRGB(49, 109, 202), WindowBg = Color3.fromRGB(28, 33, 40), WindowBorder = Color3.fromRGB(68, 76, 86), TitleBarLine = Color3.fromRGB(68, 76, 86), RailLine = Color3.fromRGB(68, 76, 86),
        Title = Color3.fromRGB(173, 186, 199), SubText = Color3.fromRGB(118, 131, 144), TabText = Color3.fromRGB(173, 186, 199), TabTextActive = Color3.fromRGB(173, 186, 199), TabHighlight = Color3.fromRGB(99, 110, 123),
        Element = Color3.fromRGB(45, 51, 59), ElementBorder = Color3.fromRGB(68, 76, 86), Text = Color3.fromRGB(173, 186, 199), ToggleSlider = Color3.fromRGB(49, 109, 202), ToggleKnobOn = Color3.fromRGB(34, 39, 46),
        Control = Color3.fromRGB(45, 51, 59), OverlayBg = Color3.fromRGB(45, 51, 59), OverlayBorder = Color3.fromRGB(68, 76, 86),
    },
    ["GitHub Dark High Contrast"] = {
        Accent = Color3.fromRGB(64, 158, 255), WindowBg = Color3.fromRGB(1, 4, 9), WindowBorder = Color3.fromRGB(122, 130, 142), TitleBarLine = Color3.fromRGB(122, 130, 142), RailLine = Color3.fromRGB(122, 130, 142),
        Title = Color3.fromRGB(240, 243, 246), SubText = Color3.fromRGB(240, 243, 246), TabText = Color3.fromRGB(240, 243, 246), TabTextActive = Color3.fromRGB(240, 243, 246), TabHighlight = Color3.fromRGB(158, 167, 179),
        Element = Color3.fromRGB(39, 43, 51), ElementBorder = Color3.fromRGB(122, 130, 142), Text = Color3.fromRGB(240, 243, 246), ToggleSlider = Color3.fromRGB(64, 158, 255), ToggleKnobOn = Color3.fromRGB(10, 12, 16),
        Control = Color3.fromRGB(39, 43, 51), OverlayBg = Color3.fromRGB(39, 43, 51), OverlayBorder = Color3.fromRGB(122, 130, 142),
    },
    ["GitHub Dark"] = {
        Accent = Color3.fromRGB(0, 92, 197), WindowBg = Color3.fromRGB(31, 36, 40), WindowBorder = Color3.fromRGB(27, 31, 35), TitleBarLine = Color3.fromRGB(27, 31, 35), RailLine = Color3.fromRGB(27, 31, 35),
        Title = Color3.fromRGB(209, 213, 218), SubText = Color3.fromRGB(149, 157, 165), TabText = Color3.fromRGB(225, 228, 232), TabTextActive = Color3.fromRGB(209, 213, 218), TabHighlight = Color3.fromRGB(40, 46, 52),
        Element = Color3.fromRGB(47, 54, 61), ElementBorder = Color3.fromRGB(27, 31, 35), Text = Color3.fromRGB(209, 213, 218), ToggleSlider = Color3.fromRGB(0, 92, 197), ToggleKnobOn = Color3.fromRGB(47, 54, 61),
        Control = Color3.fromRGB(47, 54, 61), OverlayBg = Color3.fromRGB(47, 54, 61), OverlayBorder = Color3.fromRGB(27, 31, 35),
    },
    ["GitHub Light Colorblind"] = {
        Accent = Color3.fromRGB(9, 105, 218), WindowBg = Color3.fromRGB(246, 248, 250), WindowBorder = Color3.fromRGB(208, 215, 222), TitleBarLine = Color3.fromRGB(208, 215, 222), RailLine = Color3.fromRGB(208, 215, 222),
        Title = Color3.fromRGB(36, 41, 47), SubText = Color3.fromRGB(87, 96, 106), TabText = Color3.fromRGB(36, 41, 47), TabTextActive = Color3.fromRGB(36, 41, 47), TabHighlight = Color3.fromRGB(234, 238, 242),
        Element = Color3.fromRGB(255, 255, 255), ElementBorder = Color3.fromRGB(208, 215, 222), Text = Color3.fromRGB(36, 41, 47), ToggleSlider = Color3.fromRGB(9, 105, 218), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(208, 215, 222),
    },
    ["GitHub Light Default"] = {
        Accent = Color3.fromRGB(9, 105, 218), WindowBg = Color3.fromRGB(246, 248, 250), WindowBorder = Color3.fromRGB(208, 215, 222), TitleBarLine = Color3.fromRGB(208, 215, 222), RailLine = Color3.fromRGB(208, 215, 222),
        Title = Color3.fromRGB(31, 35, 40), SubText = Color3.fromRGB(101, 109, 118), TabText = Color3.fromRGB(31, 35, 40), TabTextActive = Color3.fromRGB(31, 35, 40), TabHighlight = Color3.fromRGB(234, 238, 242),
        Element = Color3.fromRGB(255, 255, 255), ElementBorder = Color3.fromRGB(208, 215, 222), Text = Color3.fromRGB(31, 35, 40), ToggleSlider = Color3.fromRGB(9, 105, 218), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(208, 215, 222),
    },
    ["GitHub Light High Contrast"] = {
        Accent = Color3.fromRGB(3, 73, 180), WindowBg = Color3.fromRGB(255, 255, 255), WindowBorder = Color3.fromRGB(32, 37, 44), TitleBarLine = Color3.fromRGB(32, 37, 44), RailLine = Color3.fromRGB(32, 37, 44),
        Title = Color3.fromRGB(14, 17, 22), SubText = Color3.fromRGB(102, 112, 123), TabText = Color3.fromRGB(14, 17, 22), TabTextActive = Color3.fromRGB(14, 17, 22), TabHighlight = Color3.fromRGB(231, 236, 240),
        Element = Color3.fromRGB(255, 255, 255), ElementBorder = Color3.fromRGB(32, 37, 44), Text = Color3.fromRGB(14, 17, 22), ToggleSlider = Color3.fromRGB(3, 73, 180), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(32, 37, 44),
    },
    ["GitHub Light"] = {
        Accent = Color3.fromRGB(33, 136, 255), WindowBg = Color3.fromRGB(246, 248, 250), WindowBorder = Color3.fromRGB(225, 228, 232), TitleBarLine = Color3.fromRGB(225, 228, 232), RailLine = Color3.fromRGB(225, 228, 232),
        Title = Color3.fromRGB(36, 41, 46), SubText = Color3.fromRGB(106, 115, 125), TabText = Color3.fromRGB(47, 54, 61), TabTextActive = Color3.fromRGB(36, 41, 46), TabHighlight = Color3.fromRGB(235, 240, 244),
        Element = Color3.fromRGB(250, 251, 252), ElementBorder = Color3.fromRGB(225, 228, 232), Text = Color3.fromRGB(36, 41, 46), ToggleSlider = Color3.fromRGB(33, 136, 255), ToggleKnobOn = Color3.fromRGB(250, 251, 252),
        Control = Color3.fromRGB(250, 251, 252), OverlayBg = Color3.fromRGB(250, 251, 252), OverlayBorder = Color3.fromRGB(225, 228, 232),
    },
    ["Kimbie Dark"] = {
        Accent = Color3.fromRGB(165, 122, 76), WindowBg = Color3.fromRGB(34, 26, 15), WindowBorder = Color3.fromRGB(94, 69, 43), TitleBarLine = Color3.fromRGB(81, 65, 44), RailLine = Color3.fromRGB(81, 65, 44),
        Title = Color3.fromRGB(211, 175, 134), SubText = Color3.fromRGB(165, 122, 76), TabText = Color3.fromRGB(211, 175, 134), TabTextActive = Color3.fromRGB(211, 175, 134), TabHighlight = Color3.fromRGB(124, 80, 33),
        Element = Color3.fromRGB(81, 65, 44), ElementBorder = Color3.fromRGB(94, 69, 43), Text = Color3.fromRGB(211, 175, 134), ToggleSlider = Color3.fromRGB(165, 122, 76), ToggleKnobOn = Color3.fromRGB(81, 65, 44),
        Control = Color3.fromRGB(81, 65, 44), OverlayBg = Color3.fromRGB(81, 65, 44), OverlayBorder = Color3.fromRGB(94, 69, 43),
    },
    ["Monokai Classic"] = {
        Accent = Color3.fromRGB(117, 113, 94), WindowBg = Color3.fromRGB(39, 40, 34), WindowBorder = Color3.fromRGB(30, 31, 28), TitleBarLine = Color3.fromRGB(30, 31, 28), RailLine = Color3.fromRGB(30, 31, 28),
        Title = Color3.fromRGB(248, 248, 242), SubText = Color3.fromRGB(136, 132, 111), TabText = Color3.fromRGB(248, 248, 242), TabTextActive = Color3.fromRGB(248, 248, 242), TabHighlight = Color3.fromRGB(62, 61, 50),
        Element = Color3.fromRGB(65, 67, 57), ElementBorder = Color3.fromRGB(117, 113, 94), Text = Color3.fromRGB(248, 248, 242), ToggleSlider = Color3.fromRGB(117, 113, 94), ToggleKnobOn = Color3.fromRGB(39, 40, 34),
        Control = Color3.fromRGB(65, 67, 57), OverlayBg = Color3.fromRGB(30, 31, 28), OverlayBorder = Color3.fromRGB(117, 113, 94),
    },
    ["Monokai Dimmed"] = {
        Accent = Color3.fromRGB(54, 85, 181), WindowBg = Color3.fromRGB(30, 30, 30), WindowBorder = Color3.fromRGB(48, 48, 48), TitleBarLine = Color3.fromRGB(48, 48, 48), RailLine = Color3.fromRGB(48, 48, 48),
        Title = Color3.fromRGB(197, 200, 198), SubText = Color3.fromRGB(154, 155, 153), TabText = Color3.fromRGB(216, 216, 216), TabTextActive = Color3.fromRGB(197, 200, 198), TabHighlight = Color3.fromRGB(68, 68, 68),
        Element = Color3.fromRGB(82, 82, 82), ElementBorder = Color3.fromRGB(80, 80, 80), Text = Color3.fromRGB(197, 200, 198), ToggleSlider = Color3.fromRGB(54, 85, 181), ToggleKnobOn = Color3.fromRGB(82, 82, 82),
        Control = Color3.fromRGB(82, 82, 82), OverlayBg = Color3.fromRGB(82, 82, 82), OverlayBorder = Color3.fromRGB(80, 80, 80),
    },
    ["Monokai Vibrant"] = {
        Accent = Color3.fromRGB(82, 139, 255), WindowBg = Color3.fromRGB(22, 23, 29), WindowBorder = Color3.fromRGB(24, 26, 31), TitleBarLine = Color3.fromRGB(24, 26, 31), RailLine = Color3.fromRGB(24, 26, 31),
        Title = Color3.fromRGB(248, 248, 240), SubText = Color3.fromRGB(92, 99, 112), TabText = Color3.fromRGB(248, 248, 240), TabTextActive = Color3.fromRGB(248, 248, 240), TabHighlight = Color3.fromRGB(41, 45, 53),
        Element = Color3.fromRGB(29, 31, 35), ElementBorder = Color3.fromRGB(24, 26, 17), Text = Color3.fromRGB(248, 248, 240), ToggleSlider = Color3.fromRGB(82, 139, 255), ToggleKnobOn = Color3.fromRGB(22, 23, 29),
        Control = Color3.fromRGB(29, 31, 35), OverlayBg = Color3.fromRGB(33, 37, 43), OverlayBorder = Color3.fromRGB(24, 26, 17),
    },
    ["Monokai"] = {
        Accent = Color3.fromRGB(249, 38, 114), WindowBg = Color3.fromRGB(39, 40, 34), WindowBorder = Color3.fromRGB(65, 67, 57), TitleBarLine = Color3.fromRGB(65, 67, 57), RailLine = Color3.fromRGB(65, 67, 57),
        Title = Color3.fromRGB(248, 248, 242), SubText = Color3.fromRGB(136, 132, 111), TabText = Color3.fromRGB(248, 248, 242), TabTextActive = Color3.fromRGB(248, 248, 242), TabHighlight = Color3.fromRGB(62, 61, 50),
        Element = Color3.fromRGB(65, 67, 57), ElementBorder = Color3.fromRGB(117, 113, 94), Text = Color3.fromRGB(248, 248, 242), ToggleSlider = Color3.fromRGB(249, 38, 114), ToggleKnobOn = Color3.fromRGB(65, 67, 57),
        Control = Color3.fromRGB(65, 67, 57), OverlayBg = Color3.fromRGB(30, 31, 28), OverlayBorder = Color3.fromRGB(117, 113, 94),
    },
    ["Quiet Light"] = {
        Accent = Color3.fromRGB(151, 105, 220), WindowBg = Color3.fromRGB(245, 245, 245), WindowBorder = Color3.fromRGB(196, 183, 215), TitleBarLine = Color3.fromRGB(196, 183, 215), RailLine = Color3.fromRGB(196, 183, 215),
        Title = Color3.fromRGB(51, 51, 51), SubText = Color3.fromRGB(109, 112, 91), TabText = Color3.fromRGB(112, 86, 151), TabTextActive = Color3.fromRGB(51, 51, 51), TabHighlight = Color3.fromRGB(224, 224, 224),
        Element = Color3.fromRGB(242, 242, 242), ElementBorder = Color3.fromRGB(173, 175, 183), Text = Color3.fromRGB(51, 51, 51), ToggleSlider = Color3.fromRGB(112, 86, 151), ToggleKnobOn = Color3.fromRGB(245, 245, 245),
        Control = Color3.fromRGB(245, 245, 245), OverlayBg = Color3.fromRGB(245, 245, 245), OverlayBorder = Color3.fromRGB(173, 175, 183),
    },
    ["Solarized Dark"] = {
        Accent = Color3.fromRGB(42, 161, 152), WindowBg = Color3.fromRGB(0, 43, 54), WindowBorder = Color3.fromRGB(7, 54, 66), TitleBarLine = Color3.fromRGB(42, 161, 152), RailLine = Color3.fromRGB(42, 161, 152),
        Title = Color3.fromRGB(131, 148, 150), SubText = Color3.fromRGB(88, 110, 117), TabText = Color3.fromRGB(131, 148, 150), TabTextActive = Color3.fromRGB(131, 148, 150), TabHighlight = Color3.fromRGB(0, 68, 84),
        Element = Color3.fromRGB(0, 56, 71), ElementBorder = Color3.fromRGB(42, 161, 152), Text = Color3.fromRGB(131, 148, 150), ToggleSlider = Color3.fromRGB(42, 161, 152), ToggleKnobOn = Color3.fromRGB(0, 43, 54),
        Control = Color3.fromRGB(0, 33, 43), OverlayBg = Color3.fromRGB(0, 33, 43), OverlayBorder = Color3.fromRGB(42, 161, 152),
    },
    ["Solarized Light"] = {
        Accent = Color3.fromRGB(181, 137, 0), WindowBg = Color3.fromRGB(253, 246, 227), WindowBorder = Color3.fromRGB(221, 214, 193), TitleBarLine = Color3.fromRGB(221, 214, 193), RailLine = Color3.fromRGB(221, 214, 193),
        Title = Color3.fromRGB(101, 123, 131), SubText = Color3.fromRGB(147, 161, 161), TabText = Color3.fromRGB(101, 123, 131), TabTextActive = Color3.fromRGB(101, 123, 131), TabHighlight = Color3.fromRGB(223, 202, 136),
        Element = Color3.fromRGB(238, 232, 213), ElementBorder = Color3.fromRGB(211, 175, 134), Text = Color3.fromRGB(101, 123, 131), ToggleSlider = Color3.fromRGB(181, 137, 0), ToggleKnobOn = Color3.fromRGB(253, 246, 227),
        Control = Color3.fromRGB(238, 232, 213), OverlayBg = Color3.fromRGB(238, 232, 213), OverlayBorder = Color3.fromRGB(211, 175, 134),
    },
    ["Tomorrow Night Blue"] = {
        Accent = Color3.fromRGB(187, 218, 255), WindowBg = Color3.fromRGB(0, 36, 81), WindowBorder = Color3.fromRGB(64, 79, 125), TitleBarLine = Color3.fromRGB(64, 79, 125), RailLine = Color3.fromRGB(64, 79, 125),
        Title = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(114, 133, 183), TabText = Color3.fromRGB(255, 255, 255), TabTextActive = Color3.fromRGB(255, 255, 255), TabHighlight = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(0, 23, 51), ElementBorder = Color3.fromRGB(64, 79, 125), Text = Color3.fromRGB(255, 255, 255), ToggleSlider = Color3.fromRGB(187, 218, 255), ToggleKnobOn = Color3.fromRGB(0, 23, 51),
        Control = Color3.fromRGB(0, 23, 51), OverlayBg = Color3.fromRGB(0, 23, 51), OverlayBorder = Color3.fromRGB(64, 79, 125),
    },
    ["United GNOME"] = {
        Accent = Color3.fromRGB(72, 178, 88), WindowBg = Color3.fromRGB(30, 30, 30), WindowBorder = Color3.fromRGB(68, 68, 68), TitleBarLine = Color3.fromRGB(68, 68, 68), RailLine = Color3.fromRGB(68, 68, 68),
        Title = Color3.fromRGB(221, 221, 221), SubText = Color3.fromRGB(128, 128, 128), TabText = Color3.fromRGB(221, 221, 221), TabTextActive = Color3.fromRGB(221, 221, 221), TabHighlight = Color3.fromRGB(42, 45, 46),
        Element = Color3.fromRGB(36, 36, 36), ElementBorder = Color3.fromRGB(64, 64, 64), Text = Color3.fromRGB(221, 221, 221), ToggleSlider = Color3.fromRGB(72, 178, 88), ToggleKnobOn = Color3.fromRGB(30, 30, 30),
        Control = Color3.fromRGB(36, 36, 36), OverlayBg = Color3.fromRGB(36, 36, 36), OverlayBorder = Color3.fromRGB(64, 64, 64),
    },
    ["United Ubuntu"] = {
        Accent = Color3.fromRGB(72, 178, 88), WindowBg = Color3.fromRGB(30, 30, 30), WindowBorder = Color3.fromRGB(68, 68, 68), TitleBarLine = Color3.fromRGB(68, 68, 68), RailLine = Color3.fromRGB(68, 68, 68),
        Title = Color3.fromRGB(221, 221, 221), SubText = Color3.fromRGB(128, 128, 128), TabText = Color3.fromRGB(221, 221, 221), TabTextActive = Color3.fromRGB(221, 221, 221), TabHighlight = Color3.fromRGB(42, 45, 46),
        Element = Color3.fromRGB(36, 36, 36), ElementBorder = Color3.fromRGB(64, 64, 64), Text = Color3.fromRGB(221, 221, 221), ToggleSlider = Color3.fromRGB(72, 178, 88), ToggleKnobOn = Color3.fromRGB(30, 30, 30),
        Control = Color3.fromRGB(36, 36, 36), OverlayBg = Color3.fromRGB(36, 36, 36), OverlayBorder = Color3.fromRGB(64, 64, 64),
    },
    ["VS Dark"] = {
        Accent = Color3.fromRGB(0, 122, 204), WindowBg = Color3.fromRGB(30, 30, 30), WindowBorder = Color3.fromRGB(48, 48, 49), TitleBarLine = Color3.fromRGB(48, 48, 49), RailLine = Color3.fromRGB(48, 48, 49),
        Title = Color3.fromRGB(212, 212, 212), SubText = Color3.fromRGB(187, 187, 187), TabText = Color3.fromRGB(255, 255, 255), TabTextActive = Color3.fromRGB(212, 212, 212), TabHighlight = Color3.fromRGB(56, 59, 61),
        Element = Color3.fromRGB(34, 34, 34), ElementBorder = Color3.fromRGB(107, 107, 107), Text = Color3.fromRGB(212, 212, 212), ToggleSlider = Color3.fromRGB(0, 122, 204), ToggleKnobOn = Color3.fromRGB(34, 34, 34),
        Control = Color3.fromRGB(37, 37, 38), OverlayBg = Color3.fromRGB(37, 37, 38), OverlayBorder = Color3.fromRGB(69, 69, 69),
    },
    ["VS Light"] = {
        Accent = Color3.fromRGB(0, 122, 204), WindowBg = Color3.fromRGB(255, 255, 255), WindowBorder = Color3.fromRGB(145, 145, 145), TitleBarLine = Color3.fromRGB(212, 212, 212), RailLine = Color3.fromRGB(212, 212, 212),
        Title = Color3.fromRGB(0, 0, 0), SubText = Color3.fromRGB(111, 111, 111), TabText = Color3.fromRGB(51, 51, 51), TabTextActive = Color3.fromRGB(0, 0, 0), TabHighlight = Color3.fromRGB(232, 232, 232),
        Element = Color3.fromRGB(243, 243, 243), ElementBorder = Color3.fromRGB(206, 206, 206), Text = Color3.fromRGB(0, 0, 0), ToggleSlider = Color3.fromRGB(0, 122, 204), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(206, 206, 206),
    },
    ["VSC Dark High Contrast"] = {
        Accent = Color3.fromRGB(86, 156, 214), WindowBg = Color3.fromRGB(0, 0, 0), WindowBorder = Color3.fromRGB(255, 255, 255), TitleBarLine = Color3.fromRGB(255, 255, 255), RailLine = Color3.fromRGB(255, 255, 255),
        Title = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(157, 157, 157), TabText = Color3.fromRGB(255, 255, 255), TabTextActive = Color3.fromRGB(255, 255, 255), TabHighlight = Color3.fromRGB(56, 58, 73),
        Element = Color3.fromRGB(0, 0, 0), ElementBorder = Color3.fromRGB(255, 255, 255), Text = Color3.fromRGB(255, 255, 255), ToggleSlider = Color3.fromRGB(86, 156, 214), ToggleKnobOn = Color3.fromRGB(0, 0, 0),
        Control = Color3.fromRGB(0, 0, 0), OverlayBg = Color3.fromRGB(0, 0, 0), OverlayBorder = Color3.fromRGB(255, 255, 255),
    },
    ["VSC Dark Modern"] = {
        Accent = Color3.fromRGB(0, 120, 212), WindowBg = Color3.fromRGB(24, 24, 24), WindowBorder = Color3.fromRGB(43, 43, 43), TitleBarLine = Color3.fromRGB(43, 43, 43), RailLine = Color3.fromRGB(43, 43, 43),
        Title = Color3.fromRGB(204, 204, 204), SubText = Color3.fromRGB(157, 157, 157), TabText = Color3.fromRGB(255, 255, 255), TabTextActive = Color3.fromRGB(204, 204, 204), TabHighlight = Color3.fromRGB(60, 60, 60),
        Element = Color3.fromRGB(49, 49, 49), ElementBorder = Color3.fromRGB(60, 60, 60), Text = Color3.fromRGB(204, 204, 204), ToggleSlider = Color3.fromRGB(0, 120, 212), ToggleKnobOn = Color3.fromRGB(49, 49, 49),
        Control = Color3.fromRGB(49, 49, 49), OverlayBg = Color3.fromRGB(49, 49, 49), OverlayBorder = Color3.fromRGB(60, 60, 60),
    },
    ["VSC Dark+"] = {
        Accent = Color3.fromRGB(220, 220, 170), WindowBg = Color3.fromRGB(30, 30, 30), WindowBorder = Color3.fromRGB(68, 68, 68), TitleBarLine = Color3.fromRGB(68, 68, 68), RailLine = Color3.fromRGB(68, 68, 68),
        Title = Color3.fromRGB(212, 212, 212), SubText = Color3.fromRGB(128, 128, 128), TabText = Color3.fromRGB(204, 204, 204), TabTextActive = Color3.fromRGB(212, 212, 212), TabHighlight = Color3.fromRGB(42, 45, 46),
        Element = Color3.fromRGB(45, 45, 45), ElementBorder = Color3.fromRGB(64, 64, 64), Text = Color3.fromRGB(212, 212, 212), ToggleSlider = Color3.fromRGB(78, 201, 176), ToggleKnobOn = Color3.fromRGB(30, 30, 30),
        Control = Color3.fromRGB(45, 45, 45), OverlayBg = Color3.fromRGB(37, 37, 38), OverlayBorder = Color3.fromRGB(64, 64, 64),
    },
    ["VSC Light High Contrast"] = {
        Accent = Color3.fromRGB(94, 44, 188), WindowBg = Color3.fromRGB(255, 255, 255), WindowBorder = Color3.fromRGB(41, 41, 41), TitleBarLine = Color3.fromRGB(41, 41, 41), RailLine = Color3.fromRGB(41, 41, 41),
        Title = Color3.fromRGB(41, 41, 41), SubText = Color3.fromRGB(81, 81, 81), TabText = Color3.fromRGB(0, 0, 0), TabTextActive = Color3.fromRGB(41, 41, 41), TabHighlight = Color3.fromRGB(221, 221, 221),
        Element = Color3.fromRGB(255, 255, 255), ElementBorder = Color3.fromRGB(81, 81, 81), Text = Color3.fromRGB(41, 41, 41), ToggleSlider = Color3.fromRGB(15, 74, 133), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(81, 81, 81),
    },
    ["VSC Light Modern"] = {
        Accent = Color3.fromRGB(0, 95, 184), WindowBg = Color3.fromRGB(248, 248, 248), WindowBorder = Color3.fromRGB(229, 229, 229), TitleBarLine = Color3.fromRGB(229, 229, 229), RailLine = Color3.fromRGB(229, 229, 229),
        Title = Color3.fromRGB(59, 59, 59), SubText = Color3.fromRGB(97, 97, 97), TabText = Color3.fromRGB(31, 31, 31), TabTextActive = Color3.fromRGB(59, 59, 59), TabHighlight = Color3.fromRGB(242, 242, 242),
        Element = Color3.fromRGB(229, 229, 229), ElementBorder = Color3.fromRGB(206, 206, 206), Text = Color3.fromRGB(59, 59, 59), ToggleSlider = Color3.fromRGB(0, 95, 184), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(206, 206, 206),
    },
    ["VSC Light+"] = {
        Accent = Color3.fromRGB(121, 94, 38), WindowBg = Color3.fromRGB(255, 255, 255), WindowBorder = Color3.fromRGB(212, 212, 212), TitleBarLine = Color3.fromRGB(212, 212, 212), RailLine = Color3.fromRGB(212, 212, 212),
        Title = Color3.fromRGB(0, 0, 0), SubText = Color3.fromRGB(111, 111, 111), TabText = Color3.fromRGB(0, 0, 0), TabTextActive = Color3.fromRGB(0, 0, 0), TabHighlight = Color3.fromRGB(232, 232, 232),
        Element = Color3.fromRGB(243, 243, 243), ElementBorder = Color3.fromRGB(206, 206, 206), Text = Color3.fromRGB(0, 0, 0), ToggleSlider = Color3.fromRGB(121, 94, 38), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(206, 206, 206),
    },
    ["VSC Red"] = {
        Accent = Color3.fromRGB(204, 51, 51), WindowBg = Color3.fromRGB(88, 0, 0), WindowBorder = Color3.fromRGB(255, 102, 102), TitleBarLine = Color3.fromRGB(119, 34, 34), RailLine = Color3.fromRGB(119, 34, 34),
        Title = Color3.fromRGB(248, 248, 248), SubText = Color3.fromRGB(231, 192, 192), TabText = Color3.fromRGB(248, 248, 248), TabTextActive = Color3.fromRGB(248, 248, 248), TabHighlight = Color3.fromRGB(128, 0, 0),
        Element = Color3.fromRGB(88, 0, 0), ElementBorder = Color3.fromRGB(255, 102, 102), Text = Color3.fromRGB(248, 248, 248), ToggleSlider = Color3.fromRGB(204, 51, 51), ToggleKnobOn = Color3.fromRGB(48, 0, 0),
        Control = Color3.fromRGB(88, 0, 0), OverlayBg = Color3.fromRGB(88, 0, 0), OverlayBorder = Color3.fromRGB(34, 0, 0),
    },
    ["Viow Arabian Mix"] = {
        Accent = Color3.fromRGB(123, 54, 226), WindowBg = Color3.fromRGB(17, 14, 26), WindowBorder = Color3.fromRGB(68, 68, 68), TitleBarLine = Color3.fromRGB(68, 68, 68), RailLine = Color3.fromRGB(68, 68, 68),
        Title = Color3.fromRGB(164, 151, 181), SubText = Color3.fromRGB(96, 87, 111), TabText = Color3.fromRGB(204, 204, 204), TabTextActive = Color3.fromRGB(164, 151, 181), TabHighlight = Color3.fromRGB(42, 45, 46),
        Element = Color3.fromRGB(45, 45, 45), ElementBorder = Color3.fromRGB(64, 64, 64), Text = Color3.fromRGB(164, 151, 181), ToggleSlider = Color3.fromRGB(123, 54, 226), ToggleKnobOn = Color3.fromRGB(17, 14, 26),
        Control = Color3.fromRGB(45, 45, 45), OverlayBg = Color3.fromRGB(37, 37, 38), OverlayBorder = Color3.fromRGB(64, 64, 64),
    },
    ["Viow Arabian"] = {
        Accent = Color3.fromRGB(123, 54, 226), WindowBg = Color3.fromRGB(17, 14, 26), WindowBorder = Color3.fromRGB(68, 68, 68), TitleBarLine = Color3.fromRGB(68, 68, 68), RailLine = Color3.fromRGB(68, 68, 68),
        Title = Color3.fromRGB(164, 151, 181), SubText = Color3.fromRGB(96, 87, 111), TabText = Color3.fromRGB(204, 204, 204), TabTextActive = Color3.fromRGB(164, 151, 181), TabHighlight = Color3.fromRGB(42, 45, 46),
        Element = Color3.fromRGB(45, 45, 45), ElementBorder = Color3.fromRGB(64, 64, 64), Text = Color3.fromRGB(164, 151, 181), ToggleSlider = Color3.fromRGB(123, 54, 226), ToggleKnobOn = Color3.fromRGB(17, 14, 26),
        Control = Color3.fromRGB(45, 45, 45), OverlayBg = Color3.fromRGB(37, 37, 38), OverlayBorder = Color3.fromRGB(64, 64, 64),
    },
    ["Viow Darker"] = {
        Accent = Color3.fromRGB(22, 95, 179), WindowBg = Color3.fromRGB(33, 37, 43), WindowBorder = Color3.fromRGB(56, 56, 56), TitleBarLine = Color3.fromRGB(56, 56, 56), RailLine = Color3.fromRGB(56, 56, 56),
        Title = Color3.fromRGB(211, 208, 200), SubText = Color3.fromRGB(116, 115, 105), TabText = Color3.fromRGB(211, 208, 200), TabTextActive = Color3.fromRGB(211, 208, 200), TabHighlight = Color3.fromRGB(56, 56, 56),
        Element = Color3.fromRGB(45, 51, 60), ElementBorder = Color3.fromRGB(56, 56, 56), Text = Color3.fromRGB(211, 208, 200), ToggleSlider = Color3.fromRGB(22, 95, 179), ToggleKnobOn = Color3.fromRGB(33, 37, 43),
        Control = Color3.fromRGB(45, 51, 60), OverlayBg = Color3.fromRGB(30, 34, 40), OverlayBorder = Color3.fromRGB(56, 56, 56),
    },
    ["Viow Flat"] = {
        Accent = Color3.fromRGB(22, 95, 179), WindowBg = Color3.fromRGB(25, 28, 40), WindowBorder = Color3.fromRGB(25, 28, 40), TitleBarLine = Color3.fromRGB(25, 28, 40), RailLine = Color3.fromRGB(25, 28, 40),
        Title = Color3.fromRGB(211, 208, 200), SubText = Color3.fromRGB(116, 115, 105), TabText = Color3.fromRGB(211, 208, 200), TabTextActive = Color3.fromRGB(211, 208, 200), TabHighlight = Color3.fromRGB(70, 72, 112),
        Element = Color3.fromRGB(25, 28, 40), ElementBorder = Color3.fromRGB(25, 28, 40), Text = Color3.fromRGB(211, 208, 200), ToggleSlider = Color3.fromRGB(22, 95, 179), ToggleKnobOn = Color3.fromRGB(25, 28, 40),
        Control = Color3.fromRGB(25, 28, 40), OverlayBg = Color3.fromRGB(25, 28, 40), OverlayBorder = Color3.fromRGB(25, 28, 40),
    },
    ["Viow Light"] = {
        Accent = Color3.fromRGB(15, 150, 255), WindowBg = Color3.fromRGB(255, 255, 255), WindowBorder = Color3.fromRGB(212, 212, 212), TitleBarLine = Color3.fromRGB(212, 212, 212), RailLine = Color3.fromRGB(212, 212, 212),
        Title = Color3.fromRGB(87, 96, 108), SubText = Color3.fromRGB(111, 111, 111), TabText = Color3.fromRGB(142, 142, 142), TabTextActive = Color3.fromRGB(87, 96, 108), TabHighlight = Color3.fromRGB(232, 232, 232),
        Element = Color3.fromRGB(243, 243, 243), ElementBorder = Color3.fromRGB(206, 206, 206), Text = Color3.fromRGB(87, 96, 108), ToggleSlider = Color3.fromRGB(15, 150, 255), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(206, 206, 206),
    },
    ["Viow Mars"] = {
        Accent = Color3.fromRGB(227, 43, 0), WindowBg = Color3.fromRGB(19, 12, 15), WindowBorder = Color3.fromRGB(40, 25, 29), TitleBarLine = Color3.fromRGB(40, 25, 29), RailLine = Color3.fromRGB(40, 25, 29),
        Title = Color3.fromRGB(211, 208, 200), SubText = Color3.fromRGB(116, 115, 105), TabText = Color3.fromRGB(211, 208, 200), TabTextActive = Color3.fromRGB(211, 208, 200), TabHighlight = Color3.fromRGB(92, 27, 51),
        Element = Color3.fromRGB(50, 31, 39), ElementBorder = Color3.fromRGB(90, 13, 41), Text = Color3.fromRGB(211, 208, 200), ToggleSlider = Color3.fromRGB(227, 43, 0), ToggleKnobOn = Color3.fromRGB(19, 12, 15),
        Control = Color3.fromRGB(50, 31, 39), OverlayBg = Color3.fromRGB(39, 30, 34), OverlayBorder = Color3.fromRGB(90, 13, 41),
    },
    ["Viow Neon"] = {
        Accent = Color3.fromRGB(21, 145, 255), WindowBg = Color3.fromRGB(32, 36, 50), WindowBorder = Color3.fromRGB(25, 28, 40), TitleBarLine = Color3.fromRGB(25, 28, 40), RailLine = Color3.fromRGB(25, 28, 40),
        Title = Color3.fromRGB(211, 208, 200), SubText = Color3.fromRGB(116, 115, 105), TabText = Color3.fromRGB(211, 208, 200), TabTextActive = Color3.fromRGB(211, 208, 200), TabHighlight = Color3.fromRGB(27, 55, 92),
        Element = Color3.fromRGB(32, 36, 50), ElementBorder = Color3.fromRGB(13, 44, 90), Text = Color3.fromRGB(211, 208, 200), ToggleSlider = Color3.fromRGB(21, 145, 255), ToggleKnobOn = Color3.fromRGB(32, 36, 50),
        Control = Color3.fromRGB(32, 36, 50), OverlayBg = Color3.fromRGB(30, 34, 40), OverlayBorder = Color3.fromRGB(13, 44, 90),
    },
    ["Yaru Dark"] = {
        Accent = Color3.fromRGB(233, 84, 32), WindowBg = Color3.fromRGB(56, 56, 56), WindowBorder = Color3.fromRGB(68, 68, 68), TitleBarLine = Color3.fromRGB(68, 68, 68), RailLine = Color3.fromRGB(68, 68, 68),
        Title = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(128, 128, 128), TabText = Color3.fromRGB(255, 255, 255), TabTextActive = Color3.fromRGB(255, 255, 255), TabHighlight = Color3.fromRGB(87, 87, 87),
        Element = Color3.fromRGB(72, 72, 72), ElementBorder = Color3.fromRGB(64, 64, 64), Text = Color3.fromRGB(255, 255, 255), ToggleSlider = Color3.fromRGB(233, 84, 32), ToggleKnobOn = Color3.fromRGB(47, 47, 47),
        Control = Color3.fromRGB(72, 72, 72), OverlayBg = Color3.fromRGB(72, 72, 72), OverlayBorder = Color3.fromRGB(64, 64, 64),
    },
    ["Yaru"] = {
        Accent = Color3.fromRGB(233, 84, 32), WindowBg = Color3.fromRGB(237, 238, 240), WindowBorder = Color3.fromRGB(212, 212, 212), TitleBarLine = Color3.fromRGB(212, 212, 212), RailLine = Color3.fromRGB(212, 212, 212),
        Title = Color3.fromRGB(17, 17, 17), SubText = Color3.fromRGB(111, 111, 111), TabText = Color3.fromRGB(17, 17, 17), TabTextActive = Color3.fromRGB(17, 17, 17), TabHighlight = Color3.fromRGB(232, 232, 232),
        Element = Color3.fromRGB(255, 255, 255), ElementBorder = Color3.fromRGB(206, 206, 206), Text = Color3.fromRGB(17, 17, 17), ToggleSlider = Color3.fromRGB(233, 84, 32), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(255, 255, 255), OverlayBorder = Color3.fromRGB(206, 206, 206),
    },
    Light = {
        WindowBg = Color3.fromRGB(243, 243, 243), WindowBorder = Color3.fromRGB(200, 200, 200),
        TitleBarLine = Color3.fromRGB(205, 205, 205), RailLine = Color3.fromRGB(215, 215, 215),
        Title = Color3.fromRGB(25, 25, 25), Text = Color3.fromRGB(25, 25, 25), SubText = Color3.fromRGB(110, 110, 110),
        TabText = Color3.fromRGB(110, 110, 110), TabTextActive = Color3.fromRGB(20, 20, 20), TabHighlight = Color3.fromRGB(0, 0, 0),
        Element = Color3.fromRGB(0, 0, 0), ElementBorder = Color3.fromRGB(170, 170, 170),
        ToggleSlider = Color3.fromRGB(140, 140, 140), ToggleKnobOn = Color3.fromRGB(255, 255, 255),
        Control = Color3.fromRGB(255, 255, 255), OverlayBg = Color3.fromRGB(250, 250, 250), OverlayBorder = Color3.fromRGB(190, 190, 190),
    },
}
for k, v in pairs(Theme) do Palettes.Dark[k] = v end
Bwin.Themes = {}
for k in pairs(Palettes) do Bwin.Themes[#Bwin.Themes + 1] = k end
table.sort(Bwin.Themes)

local TITLE_H = 42
local RAIL_W = 160

local function clamp(v, lo, hi) if v < lo then return lo elseif v > hi then return hi end return v end
local function lerp(a, b, t) return a + (b - a) * t end
local function lerpColor(a, b, t) return Color3.new(lerp(a.R, b.R, t), lerp(a.G, b.G, t), lerp(a.B, b.B, t)) end
local function rgbToHsv(c)
    local r, g, b = c.R, c.G, c.B
    local mx, mn = math.max(r, g, b), math.min(r, g, b)
    local d = mx - mn
    local h, s, v = 0, (mx == 0 and 0 or d / mx), mx
    if d ~= 0 then
        if mx == r then h = ((g - b) / d) % 6
        elseif mx == g then h = (b - r) / d + 2
        else h = (r - g) / d + 4 end
        h = h / 6
    end
    return h, s, v
end

local KeyName = {
    [0x41]="A",[0x42]="B",[0x43]="C",[0x44]="D",[0x45]="E",[0x46]="F",[0x47]="G",[0x48]="H",[0x49]="I",[0x4A]="J",
    [0x4B]="K",[0x4C]="L",[0x4D]="M",[0x4E]="N",[0x4F]="O",[0x50]="P",[0x51]="Q",[0x52]="R",[0x53]="S",[0x54]="T",
    [0x55]="U",[0x56]="V",[0x57]="W",[0x58]="X",[0x59]="Y",[0x5A]="Z",
    [0x30]="0",[0x31]="1",[0x32]="2",[0x33]="3",[0x34]="4",[0x35]="5",[0x36]="6",[0x37]="7",[0x38]="8",[0x39]="9",
    [0x70]="F1",[0x71]="F2",[0x72]="F3",[0x73]="F4",[0x74]="F5",[0x75]="F6",[0x76]="F7",[0x77]="F8",[0x78]="F9",[0x79]="F10",[0x7A]="F11",[0x7B]="F12",
    [0x10]="Shift",[0x11]="Ctrl",[0x12]="Alt",[0x20]="Space",[0x09]="Tab",[0x1B]="Esc",
    [0x23]="End",[0x24]="Home",[0x2D]="Insert",[0x2E]="Delete",
    [0x25]="Left",[0x26]="Up",[0x27]="Right",[0x28]="Down",
    [0x01]="MB1",[0x02]="MB2",[0x05]="Mouse4",[0x06]="Mouse5",
}
local KeyAlias = {
    LeftControl = 0x11, RightControl = 0x11, Control = 0x11, Ctrl = 0x11,
    LeftShift = 0x10, RightShift = 0x10, Shift = 0x10,
    LeftAlt = 0x12, RightAlt = 0x12, Alt = 0x12,
    MB1 = 0x01, MB2 = 0x02, Mouse1 = 0x01, Mouse2 = 0x02,
    Return = 0x0D, Enter = 0x0D, Escape = 0x1B, Backspace = 0x08, Spacebar = 0x20,
}
local function resolveKey(v)
    if type(v) == "number" then return v, KeyName[v] or tostring(v) end
    if type(v) == "string" then
        if KeyAlias[v] then return KeyAlias[v], KeyName[KeyAlias[v]] or v end
        for vk, name in pairs(KeyName) do if name == v then return vk, name end end
    end
    return nil, "None"
end
local ScanList = {}
for vk in pairs(KeyName) do ScanList[#ScanList + 1] = vk end

local CharMap = {}
for vk = 0x41, 0x5A do CharMap[vk] = { string.char(vk + 32), string.char(vk) } end
do
    local d = { [0x30]={"0",")"},[0x31]={"1","!"},[0x32]={"2","@"},[0x33]={"3","#"},[0x34]={"4","$"},
                [0x35]={"5","%"},[0x36]={"6","^"},[0x37]={"7","&"},[0x38]={"8","*"},[0x39]={"9","("} }
    for vk, m in pairs(d) do CharMap[vk] = m end
    CharMap[0x20]={" "," "}; CharMap[0xBA]={";",":"}; CharMap[0xBB]={"=","+"}; CharMap[0xBC]={",","<"}
    CharMap[0xBD]={"-","_"}; CharMap[0xBE]={".",">"}; CharMap[0xBF]={"/","?"}; CharMap[0xC0]={"`","~"}
    CharMap[0xDB]={"[","{"}; CharMap[0xDC]={"\\","|"}; CharMap[0xDD]={"]","}"}; CharMap[0xDE]={"'","\""}
end
local CharScanList = {}
for vk in pairs(CharMap) do CharScanList[#CharScanList + 1] = vk end

local Cache, Visible, CurTick = {}, {}, 0

local function eq(a, b)
    if a == b then return true end
    local ta = typeof(a)
    if ta ~= typeof(b) then return false end
    if ta == "Color3" then return a.R == b.R and a.G == b.G and a.B == b.B end
    if ta == "Vector2" then return a.X == b.X and a.Y == b.Y end
    return false
end

local function Draw(id, dtype, props)
    local c = Cache[id]
    if not c then c = { Obj = Drawing.new(dtype), P = {} }; Cache[id] = c end
    local obj, P = c.Obj, c.P
    local vis = props.Visible
    if vis == nil then vis = true end
    if P.Visible ~= vis then obj.Visible = vis; P.Visible = vis end
    if vis then
        for k, v in pairs(props) do
            if k ~= "Visible" and not eq(P[k], v) then obj[k] = v; P[k] = v end
        end
        Visible[id] = true
    else
        Visible[id] = nil
    end
    c.Tick = CurTick
    return obj
end

local function cleanup()
    for id in pairs(Visible) do
        local c = Cache[id]
        if c and c.Tick ~= CurTick and c.P.Visible then
            c.Obj.Visible = false; c.P.Visible = false; Visible[id] = nil
        end
    end
end

local function rect(id, x, y, w, h, color, op, z, corner)
    Draw(id, "Square", { Filled = true, Color = color, Transparency = op or 1, ZIndex = z or 1,
        Position = Vector2.new(x, y), Size = Vector2.new(w, h), Corner = corner or 0 })
end
local function outline(id, x, y, w, h, color, op, z, corner)
    Draw(id, "Square", { Filled = false, Color = color, Transparency = op or 1, ZIndex = z or 1,
        Position = Vector2.new(x, y), Size = Vector2.new(w, h), Corner = corner or 0 })
end
local function text(id, str, x, y, size, color, z, center, op)
    Draw(id, "Text", { Text = str, Size = size, Font = 1, Color = color, Center = center or false,
        Transparency = op or 1, ZIndex = z or 1, Position = Vector2.new(x, y), Outline = false })
end
local function circle(id, cx, cy, r, color, op, z)
    Draw(id, "Circle", { Filled = true, Color = color, Transparency = op or 1, ZIndex = z or 1,
        Position = Vector2.new(cx, cy), Radius = r, NumSides = 32 })
end
local function line(id, x1, y1, x2, y2, color, op, z)
    Draw(id, "Line", { Color = color, Transparency = op or 1, ZIndex = z or 1,
        From = Vector2.new(x1, y1), To = Vector2.new(x2, y2), Thickness = 1 })
end
local function image(id, data, x, y, w, h, op, z, rounding)
    Draw(id, "Image", { Data = data, Size = Vector2.new(w, h), Position = Vector2.new(x, y),
        Transparency = op or 1, ZIndex = z or 1, Rounding = rounding or 0 })
end

local function textW(str, size) return #tostring(str) * size * 0.52 end

local function newSpring(v, speed) return { v = v, goal = v, speed = speed or 16 } end
local function springStep(s, dt)
    s.v = s.v + (s.goal - s.v) * (1 - math.exp(-s.speed * dt))
    return s.v
end

local Input = { mx = 0, my = 0, down = false, prevDown = false, clicked = false, keys = {} }
local function inBounds(x, y, w, h)
    return Input.mx >= x and Input.mx <= x + w and Input.my >= y and Input.my <= y + h
end
local function pollInput()
    Input.mx, Input.my = Mouse.X, Mouse.Y
    Input.down = ismouse1pressed()
    Input.clicked = Input.down and not Input.prevDown
end
local function keyEdge(vk)
    local k = Input.keys[vk]
    if not k then k = { held = false }; Input.keys[vk] = k end
    local p = iskeypressed(vk)
    local click = p and not k.held
    k.held = p
    return click
end

local State = {
    Win = { x = 100, y = 100, w = 580, h = 460 },
    Drag = false, DragOff = Vector2.new(0, 0),
    ActiveTab = 1,
    MenuKey = 0x23, MenuKeyName = "End",
    Minimized = false, Resizing = false, MinW = 470, MinH = 380,
    BubblePos = { x = 60, y = 60 }, BubbleDrag = false, BubbleOff = Vector2.new(0, 0), BubbleMoved = false,
    MinNotified = false,
    Overlay = nil,
    KBListening = nil,
    Focused = nil,
    Dialog = nil,
    Vw = 1920, Vh = 1080,
    LastTime = nil,
    Running = false, Token = nil,
}
local Tabs = {}
local AllKeybinds = {}
State.TabCurtain = newSpring(0, 16)
State.IndOff = newSpring(0, 18)
State.IndInit = false

local function center()
    local w, h = State.Win.w, State.Win.h
    pcall(function()
        local vp = game:GetService("Workspace").CurrentCamera.ViewportSize
        State.Win.x = math.floor((vp.X - w) / 2)
        State.Win.y = math.floor((vp.Y - h) / 2)
    end)
end

local function getViewport()
    local vw, vh = 1920, 1080
    pcall(function()
        local v = game:GetService("Workspace").CurrentCamera.ViewportSize
        vw, vh = v.X, v.Y
    end)
    return vw, vh
end

local Notifs = {}
local NotifId = 0
local Options = {}

local IconCache = {}
local PhosphorWeights = { thin = true, light = true, bold = true, fill = true, duotone = true }
local function iconUrl(name)
    if name:sub(1, 9) == "phosphor-" then
        local n = name:sub(10)
        local weight = n:match("%-([a-z]+)$")
        if not (weight and PhosphorWeights[weight]) then weight = "regular" end
        return "https://images.weserv.nl/?url=cdn.jsdelivr.net/npm/@phosphor-icons/core/assets/" .. weight .. "/" .. n .. ".svg&w=48&h=48&output=png&filt=negate"
    end
    return "https://images.weserv.nl/?url=cdn.jsdelivr.net/npm/lucide-static@latest/icons/" .. name .. ".svg&w=48&h=48&output=png&filt=negate"
end
local function loadIcon(name, cb)
    if not name or name == "" then return end
    local cached = IconCache[name]
    if type(cached) == "string" then cb(cached); return end
    task.spawn(function()
        local ok, data = pcall(function() return game:HttpGet(iconUrl(name)) end)
        if ok and type(data) == "string" and #data > 0 then
            IconCache[name] = data
            cb(data)
        end
    end)
end

local function paragraphLines(content)
    local lines = {}
    for ln in (tostring(content or "") .. "\n"):gmatch("(.-)\n") do table.insert(lines, ln) end
    if #lines > 0 and lines[#lines] == "" then table.remove(lines) end
    return lines
end
local function alignOf(a)
    a = tostring(a or ""):lower()
    if a:find("center") or a:find("middle") then return "center" end
    if a:find("right") then return "right" end
    return "left"
end
local function safe(fn, ...)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Bwin] callback error: " .. tostring(err))
        pcall(function() UI:Notify({ Title = "Callback error", Content = tostring(err):gsub("^.-:%d+: ", ""):sub(1, 140), Duration = 6 }) end)
    end
end

local function exposeValue(el, getter, setter)
    function el:Get() return getter(el) end
    return setmetatable(el, {
        __index = function(_, k) if k == "Value" then return getter(el) end end,
        __newindex = function(t, k, v)
            if k == "Value" then if setter then setter(el, v) end else rawset(t, k, v) end
        end,
    })
end

local function mkParagraph(c)
    local el = { kind = "paragraph", title = c.Title or "Paragraph", hover = newSpring(0, 14),
        titleAlign = alignOf(c.TitleAlignment), contentAlign = alignOf(c.ContentAlignment), callback = c.Callback }
    el.value = tostring(c.Content or "")
    el.lines = paragraphLines(el.value)
    function el:SetContent(content)
        el.value = tostring(content or "")
        el.lines = paragraphLines(el.value)
        safe(el.callback, el.value)
        safe(el.changed, el.value)
        return el
    end
    el.SetValue = el.SetContent
    function el:OnChanged(fn) el.changed = fn; safe(fn, el.value); return el end
    return exposeValue(el, function() return el.value end, function(_, v) el:SetContent(v) end)
end

local function mkButton(c)
    return { kind = "button", title = c.Title or "Button", desc = c.Description,
        callback = c.Callback, hover = newSpring(0, 14) }
end

local function mkToggle(c)
    local el = { kind = "toggle", title = c.Title or c.Text or "Toggle", desc = c.Description,
        value = c.Default and true or false, callback = c.Callback,
        hover = newSpring(0, 14), anim = newSpring(c.Default and 1 or 0, 18) }
    function el:OnChanged(fn) el.changed = fn; safe(fn, el.value); return el end
    function el:SetValue(v)
        el.value = not not v
        el.anim.goal = el.value and 1 or 0
        safe(el.callback, el.value)
        safe(el.changed, el.value)
    end
    return exposeValue(el, function() return el.value end, function(_, v) el:SetValue(v) end)
end

local function mkSlider(c)
    local el = { kind = "slider", title = c.Title or "Slider", desc = c.Description,
        min = c.Min or 0, max = c.Max or 100, value = c.Default or c.Min or 0,
        rounding = c.Rounding or 0, callback = c.Callback, hover = newSpring(0, 14) }
    local span = math.max(1e-6, el.max - el.min)
    el.frac = newSpring((el.value - el.min) / span, 20)
    function el:OnChanged(fn) el.changed = fn; safe(fn, el.value); return el end
    function el:SetValue(v)
        local old = el.value
        el.value = clamp(v, el.min, el.max)
        el.frac.goal = (el.value - el.min) / span
        safe(el.callback, el.value, old)
        safe(el.changed, el.value, old)
    end
    return exposeValue(el, function() return el.value end, function(_, v) el:SetValue(v) end)
end

local function mkDropdown(c)
    local el = { kind = "dropdown", title = c.Title or "Dropdown", desc = c.Description,
        options = c.Options or c.Values or { "None" }, multi = c.Multi or false, callback = c.Callback,
        hover = newSpring(0, 14), maxItems = c.MaxItems or 6, scroll = 0,
        displayer = c.Displayer, allowNull = c.AllowNull or false,
        searchable = c.Searchable or false, searchText = "", searchPlaceholder = c.SearchPlaceholder or "Search..." }
    if el.multi then
        el.value = {}
        if type(c.Default) == "table" then for _, v in ipairs(c.Default) do el.value[v] = true end end
    else
        local d = c.Default
        if type(d) == "number" and el.options[d] ~= nil then el.value = el.options[d]
        elseif d ~= nil then el.value = d
        else el.value = el.options[1] end
    end
    function el:OnChanged(fn) el.changed = fn; safe(fn, el.value); return el end
    function el:SetValue(v)
        el.value = v
        safe(el.callback, v)
        safe(el.changed, v)
    end
    function el:SetValues(list)
        el.options = list or el.options
        el.scroll = 0
        if not el.multi then
            local ok = false
            for _, o in ipairs(el.options) do if o == el.value then ok = true; break end end
            if not ok and not el.allowNull then el.value = el.options[1] end
        end
        return el
    end
    return exposeValue(el, function() return el.value end, function(_, v) el:SetValue(v) end)
end

local function normMode(m)
    m = tostring(m or "Toggle"):lower()
    if m == "always" then return "Always" end
    if m == "hold" then return "Hold" end
    return "Toggle"
end
local function keyHeld(vk)
    if not vk then return false end
    local k = Input.keys[vk]
    return (k and k.held) or false
end
local function mkKeybind(c)
    local el = { kind = "keybind", title = c.Title or "Keybind", desc = c.Description,
        key = nil, keyName = "None", mode = normMode(c.Mode), toggled = false,
        callback = c.Callback, changedCallback = c.ChangedCallback, hover = newSpring(0, 14) }
    el.key, el.keyName = resolveKey(c.Default or c.Value)
    function el:OnChanged(fn) el.changed = fn; safe(fn, el.keyName); return el end
    function el:OnClick(fn) el.clicked = fn; return el end
    function el:GetState()
        if State.Focused and el.mode ~= "Always" then return false end
        if el.mode == "Always" then return true end
        if el.mode == "Toggle" then return el.toggled end
        return keyHeld(el.key)
    end
    function el:DoClick()
        if el.mode == "Toggle" then el.toggled = not el.toggled end
        if el.callback then el.callback(el.toggled) end
        if el.clicked then el.clicked(el.toggled) end
    end
    function el:SetValue(key, mode)
        el.key, el.keyName = resolveKey(key)
        if mode then el.mode = normMode(mode) end
        if el.changedCallback then el.changedCallback(el.keyName) end
        if el.changed then el.changed(el.keyName) end
    end
    table.insert(AllKeybinds, el)
    return exposeValue(el, function() return el.keyName end, function(_, v) el:SetValue(v) end)
end

local function mkColorpicker(c)
    local el = { kind = "colorpicker", title = c.Title or "Color", desc = c.Description,
        value = c.Default or Color3.fromRGB(255, 255, 255), callback = c.Callback, hover = newSpring(0, 14) }
    el.h, el.s, el.v = rgbToHsv(el.value)
    el.hasAlpha = c.Transparency ~= nil or c.Alpha ~= nil
    el.alpha = c.Alpha or (c.Transparency ~= nil and (1 - c.Transparency)) or 1
    function el:OnChanged(fn) el.changed = fn; safe(fn, el.value); return el end
    function el:SetValue(col)
        el.value = col; el.h, el.s, el.v = rgbToHsv(col)
        safe(el.callback, col)
        safe(el.changed, col)
    end
    function el:SetValueRGB(col, transparency)
        if transparency ~= nil then el.alpha = clamp(1 - transparency, 0, 1) end
        el:SetValue(col)
    end
    return exposeValue(el, function() return el.value end, function(_, v) el:SetValue(v) end)
end

local function mkInput(c)
    local el = { kind = "input", title = c.Title or "Input", desc = c.Description,
        text = c.Default or "", placeholder = c.Placeholder or "", numeric = c.Numeric or false,
        finished = c.Finished or false, callback = c.Callback, hover = newSpring(0, 14),
        maxLength = c.MaxLength, clearOnFocusLost = c.ClearOnFocusLost or false }
    if el.maxLength and #el.text > el.maxLength then el.text = el.text:sub(1, el.maxLength) end
    function el:OnChanged(fn) el.changed = fn; safe(fn, el.text); return el end
    function el:SetValue(v)
        v = tostring(v)
        if el.maxLength and #v > el.maxLength then v = v:sub(1, el.maxLength) end
        el.text = v
        safe(el.callback, el.text)
        safe(el.changed, el.text)
    end
    return exposeValue(el, function() return el.text end, function(_, v) el:SetValue(v) end)
end

local function ddDisplay(el)
    local function disp(v) if el.displayer then return tostring(el.displayer(v)) end return tostring(v) end
    if el.multi then
        local parts = {}
        for _, opt in ipairs(el.options) do if el.value[opt] then parts[#parts + 1] = disp(opt) end end
        if #parts == 0 then return "None" end
        if #parts <= 2 then return table.concat(parts, ", ") end
        return #parts .. " selected"
    end
    if el.value == nil then return "None" end
    return disp(el.value)
end

local function blurField()
    local f = State.Focused
    if f and f.onCommit then f.onCommit(f.buf) end
    State.Focused = nil
end

local function cardHeight(el)
    if el.kind == "paragraph" then return 24 + 18 + #el.lines * 15 end
    if el.kind == "slider" then return el.desc and 66 or 50 end
    if el.kind == "dropdown" then return el.desc and 60 or 44 end
    return el.desc and 54 or 38
end

local function processEl(el, idp, x, y, w, h, dt, z, block)
    local hovered = inBounds(x, y, w, h) and not State.Drag and not block
    local interactive = el.kind ~= "paragraph"

    if interactive then el.hover.goal = hovered and 1 or 0 end
    springStep(el.hover, dt)
    rect(idp .. ".bg", x, y, w, h, Theme.Element, lerp(OP.Element, OP.ElementHover, el.hover.v), z, 5)
    outline(idp .. ".bd", x, y, w, h, Theme.ElementBorder, OP.Border, z + 1, 5)

    if el.kind == "paragraph" then
        local function alignedX(align, s, size)
            if align == "center" then return x + math.floor(w / 2), true end
            if align == "right" then return x + w - 14 - textW(s, size), false end
            return x + 14, false
        end
        local tx, tc = alignedX(el.titleAlign, el.title, 13)
        text(idp .. ".t", el.title, tx, y + 12, 13, Theme.Text, z + 2, tc)
        local ly = y + 32
        for i, ln in ipairs(el.lines) do
            local lx, lc = alignedX(el.contentAlign, ln, 12)
            text(idp .. ".l" .. i, ln, lx, ly, 12, Theme.SubText, z + 2, lc)
            ly = ly + 15
        end
        return
    end

    local titleY = (el.desc or el.kind == "slider") and (y + 11) or (y + math.floor((h - 14) / 2))
    local titleX = x + 14
    if el.icon then
        if el.iconData then image(idp .. ".ic", el.iconData, x + 14, y + math.floor((h - 16) / 2), 16, 16, 0.85, z + 2) end
        titleX = x + 38
    end
    text(idp .. ".t", el.title, titleX, titleY, 13, Theme.Text, z + 2)
    if el.desc then text(idp .. ".d", el.desc, titleX, titleY + 16, 12, Theme.SubText, z + 2) end

    if el.kind == "button" then
        if hovered and Input.clicked then safe(el.callback) end

    elseif el.kind == "toggle" then
        local pillW, pillH = 36, 18
        local px = x + w - 12 - pillW
        local py = y + math.floor((h - pillH) / 2)
        local chipHit = false
        if el.keybind then
            local kb = el.keybind
            local listening = (State.KBListening == kb)
            local chW, chH = 48, 20
            local chX = px - 10 - chW
            local chY = y + math.floor((h - chH) / 2)
            chipHit = not block and inBounds(chX, chY, chW, chH)
            rect(idp .. ".tkb", chX, chY, chW, chH, Theme.Control, chipHit and 0.95 or OP.Control, z + 2, 5)
            outline(idp .. ".tkbd", chX, chY, chW, chH, listening and Theme.Accent or Theme.ElementBorder, 0.6, z + 3, 5)
            local kt = listening and "..." or ("[" .. (kb.keyName or "None") .. "]")
            text(idp .. ".tkt", kt, chX + chW / 2, chY + chH / 2, 11, listening and Theme.Accent or Theme.Text, z + 3, true)
            if chipHit and Input.clicked then State.KBListening = kb end
        end
        if hovered and Input.clicked and not chipHit then
            el.value = not el.value
            el.anim.goal = el.value and 1 or 0
            safe(el.callback, el.value)
            safe(el.changed, el.value)
        end
        springStep(el.anim, dt)
        local t = el.anim.v
        rect(idp .. ".pill", px, py, pillW, pillH, Theme.Accent, t, z + 2, 9)
        outline(idp .. ".pilb", px, py, pillW, pillH, lerpColor(Theme.ToggleSlider, Theme.Accent, t), 0.55, z + 3, 9)
        circle(idp .. ".knob", px + lerp(9, 27, t), py + pillH / 2, 6, lerpColor(Theme.ToggleSlider, Theme.ToggleKnobOn, t), lerp(0.6, 1, t), z + 4)

    elseif el.kind == "slider" then
        local tx, tw = x + 14, w - 28
        local ty = y + (el.desc and 50 or 34)
        local editing = State.Focused and State.Focused.owner == el
        local vs = (el.rounding and el.rounding > 0) and string.format("%." .. el.rounding .. "f", el.value) or tostring(math.floor(el.value + 0.5))
        local shownV = vs
        if editing then
            local caret = (math.floor(tick() * 2) % 2 == 0) and "|" or ""
            shownV = State.Focused.buf .. caret
        end
        local vwid = textW(shownV, 12)
        local vx = x + w - 14 - vwid
        local vHover = not block and inBounds(vx - 6, y + 8, vwid + 12, 18)
        text(idp .. ".v", shownV, vx, y + 11, 12, editing and Theme.Accent or Theme.SubText, z + 2)
        if not editing and Input.down and not block and (el.dragging or (Input.clicked and not vHover and inBounds(tx - 6, ty - 8, tw + 12, 18))) then
            el.dragging = true
            local f = clamp((Input.mx - tx) / tw, 0, 1)
            local raw = el.min + f * (el.max - el.min)
            local v = (el.rounding and el.rounding > 0) and tonumber(string.format("%." .. el.rounding .. "f", raw)) or math.floor(raw + 0.5)
            if v ~= el.value then
                local old = el.value
                el.value = v
                el.frac.goal = (el.value - el.min) / math.max(1e-6, el.max - el.min)
                safe(el.callback, v, old)
                safe(el.changed, v, old)
            end
        elseif not Input.down then
            el.dragging = false
        end
        if not editing and vHover and Input.clicked then
            State.KBListening = nil; State.Overlay = nil; el.dragging = false
            State.Focused = { owner = el, id = "value", buf = vs, numeric = true, live = false,
                onCommit = function(buf) local n = tonumber(buf); if n then el:SetValue(n) end end }
        elseif editing and Input.clicked and not vHover then
            blurField()
        end
        springStep(el.frac, dt)
        local f = clamp(el.frac.v, 0, 1)
        rect(idp .. ".trk", tx, ty, tw, 4, Theme.ToggleSlider, 0.30, z + 2, 2)
        rect(idp .. ".fil", tx, ty, math.max(0, tw * f), 4, Theme.Accent, 1, z + 3, 2)
        circle(idp .. ".knb", tx + tw * f, ty + 2, 6, Theme.Text, 1, z + 4)

    elseif el.kind == "dropdown" then
        local boxH = 26
        local boxW = math.min(160, math.floor(w * 0.46))
        local bx = x + w - 12 - boxW
        local by = el.desc and (y + 28) or (y + math.floor((h - boxH) / 2))
        local bHover = not block and inBounds(bx, by, boxW, boxH)
        rect(idp .. ".db", bx, by, boxW, boxH, Theme.Control, bHover and 0.95 or OP.Control, z + 2, 5)
        outline(idp .. ".dbd", bx, by, boxW, boxH, Theme.ElementBorder, 0.5, z + 3, 5)
        text(idp .. ".dt", ddDisplay(el), bx + 8, by + 6, 12, Theme.Text, z + 3)
        text(idp .. ".dc", "v", bx + boxW - 13, by + 6, 12, Theme.SubText, z + 3)
        if bHover and Input.clicked then
            el.searchText = ""; el.scroll = 0
            State.Overlay = { kind = "dropdown", el = el, x = bx, y = by + boxH + 4, w = boxW }
        end

    elseif el.kind == "keybind" then
        local boxH, boxW = 26, 84
        local bx = x + w - 12 - boxW
        local by = y + math.floor((h - boxH) / 2)
        local listening = (State.KBListening == el)
        local bHover = not block and inBounds(bx, by, boxW, boxH)
        rect(idp .. ".kb", bx, by, boxW, boxH, Theme.Control, bHover and 0.95 or OP.Control, z + 2, 5)
        outline(idp .. ".kbd", bx, by, boxW, boxH, listening and Theme.Accent or Theme.ElementBorder, 0.6, z + 3, 5)
        local txt = listening and "..." or ("[" .. (el.keyName or "None") .. "]")
        text(idp .. ".kt", txt, bx + boxW / 2, by + boxH / 2, 12, listening and Theme.Accent or Theme.Text, z + 3, true)
        if bHover and Input.clicked then State.KBListening = el end

    elseif el.kind == "colorpicker" then
        local sw, swh = 32, 20
        local bx = x + w - 12 - sw
        local by = y + math.floor((h - swh) / 2)
        local bHover = not block and inBounds(bx, by, sw, swh)
        if el.hasAlpha then rect(idp .. ".cwbk", bx, by, sw, swh, Color3.fromRGB(55, 55, 55), 1, z + 2, 5) end
        rect(idp .. ".cw", bx, by, sw, swh, el.value, el.hasAlpha and el.alpha or 1, z + 3, 5)
        outline(idp .. ".cwd", bx, by, sw, swh, Theme.ElementBorder, 0.6, z + 4, 5)
        if bHover and Input.clicked then
            State.Overlay = { kind = "colorpicker", el = el, ax = bx + sw, ay = by + swh + 4,
                origH = el.h, origS = el.s, origV = el.v, origAlpha = el.alpha }
        end

    elseif el.kind == "input" then
        local boxH = 26
        local boxW = math.min(170, math.floor(w * 0.5))
        local bx = x + w - 12 - boxW
        local by = y + math.floor((h - boxH) / 2)
        local focused = State.Focused and State.Focused.owner == el
        local bHover = not block and inBounds(bx, by, boxW, boxH)
        rect(idp .. ".ib", bx, by, boxW, boxH, Theme.Control, focused and 0.95 or OP.Control, z + 2, 5)
        outline(idp .. ".ibd", bx, by, boxW, boxH, focused and Theme.Accent or Theme.ElementBorder, 0.6, z + 3, 5)
        local raw = (focused and State.Focused.buf) or el.text or ""
        local maxc = math.max(1, math.floor((boxW - 18) / 6.5))
        local body = (#raw > maxc) and raw:sub(#raw - maxc + 1) or raw
        local caret = (focused and math.floor(tick() * 2) % 2 == 0) and "|" or ""
        local shown = (raw ~= "" and (body .. caret)) or (caret ~= "" and caret) or (el.placeholder or "")
        text(idp .. ".it", shown, bx + 8, by + 6, 12, raw ~= "" and Theme.Text or Theme.SubText, z + 3)
        if bHover and Input.clicked then
            State.KBListening = nil; State.Overlay = nil
            State.Focused = { owner = el, id = "text", buf = el.text or "", numeric = el.numeric, maxLength = el.maxLength,
                live = not el.finished,
                onType = function(buf) el.text = buf; safe(el.callback, el.text); safe(el.changed, el.text) end,
                onCommit = function(buf)
                    if el.finished then el.text = buf; safe(el.callback, el.text); safe(el.changed, el.text) else el.text = buf end
                    if el.clearOnFocusLost then el.text = "" end
                end }
        elseif focused and Input.clicked and not bHover then
            blurField()
        end
    end
end

local function renderOverlay(dt)
    local ov = State.Overlay
    if not ov then return false end
    local Z = 120

    if ov.kind == "dropdown" then
        local el = ov.el
        local function disp(v) if el.displayer then return tostring(el.displayer(v)) end return tostring(v) end
        local opts = el.options
        local filtered = opts
        if el.searchable and el.searchText ~= "" then
            filtered = {}
            local q = el.searchText:lower()
            for _, o in ipairs(opts) do if disp(o):lower():find(q, 1, true) then filtered[#filtered + 1] = o end end
        end
        local rowH = 28
        local pad = 4
        local searchH = el.searchable and 28 or 0
        local visN = math.min(#filtered, el.maxItems or 6)
        local needBar = #filtered > visN
        local barW = needBar and 6 or 0
        local listH = math.max(rowH, visN * rowH)
        local panelW = ov.w
        local panelH = pad * 2 + searchH + listH
        local maxScroll = math.max(0, #filtered - visN)
        el.scroll = clamp(el.scroll or 0, 0, maxScroll)

        ov.anim = ov.anim or newSpring(0, 24)
        ov.rowHover = ov.rowHover or {}
        ov.anim.goal = ov.closing and 0 or 1
        local a = springStep(ov.anim, dt)
        if ov.closing and a < 0.04 then
            if State.Focused and State.Focused.owner == el then State.Focused = nil end
            State.Overlay = nil; return true
        end

        rect("ov.bg", ov.x, ov.y, panelW, panelH, Theme.OverlayBg, OP.Overlay * a, Z, 5)
        outline("ov.bd", ov.x, ov.y, panelW, panelH, Theme.OverlayBorder, 0.7 * a, Z + 1, 5)

        if el.searchable then
            local sbx, sby, sbw, sbh = ov.x + 4, ov.y + 4, panelW - 8, 22
            local searching = State.Focused and State.Focused.owner == el
            rect("ov.sb", sbx, sby, sbw, sbh, Theme.Control, searching and 0.95 or OP.Control, Z + 2, 4)
            outline("ov.sbd", sbx, sby, sbw, sbh, searching and Theme.Accent or Theme.ElementBorder, 0.6 * a, Z + 3, 4)
            local stext = el.searchText
            local caret = (searching and math.floor(tick() * 2) % 2 == 0) and "|" or ""
            local shownS = (stext ~= "" and (stext .. caret)) or (caret ~= "" and caret) or el.searchPlaceholder
            text("ov.sbt", shownS, sbx + 8, sby + 4, 12, stext ~= "" and Theme.Text or Theme.SubText, Z + 4, false, a)
            if not ov.closing and Input.clicked and inBounds(sbx, sby, sbw, sbh) then
                State.Focused = { owner = el, id = "search", buf = el.searchText, numeric = false, live = true,
                    onType = function(buf) el.searchText = buf; el.scroll = 0 end,
                    onCommit = function(buf) el.searchText = buf; el.scroll = 0 end }
            end
        end

        local listTop = ov.y + pad + searchH
        for i = 1, visN do
            local opt = filtered[i + el.scroll]
            if opt ~= nil then
                local ry = listTop + (i - 1) * rowH
                local rHover = inBounds(ov.x, ry, panelW - barW, rowH) and not ov.closing
                local selected = el.multi and el.value[opt] or (not el.multi and el.value == opt)
                ov.rowHover[i] = ov.rowHover[i] or newSpring(0, 18)
                ov.rowHover[i].goal = rHover and 1 or 0
                local rh = springStep(ov.rowHover[i], dt)
                rect("ov.r" .. i, ov.x + 2, ry, panelW - 4 - barW, rowH - 2, Theme.TabHighlight, 0.14 * rh * a, Z + 2, 4)
                text("ov.t" .. i, disp(opt), ov.x + 10, ry + 7, 12, selected and Theme.Accent or Theme.Text, Z + 3, false, a)
                if selected then text("ov.m" .. i, "*", ov.x + panelW - barW - 16, ry + 6, 13, Theme.Accent, Z + 3, false, a) end
                if rHover and Input.clicked then
                    if el.multi then
                        el.value[opt] = (not el.value[opt]) or nil
                        safe(el.callback, el.value); safe(el.changed, el.value)
                    else
                        if el.allowNull and el.value == opt then el.value = nil else el.value = opt end
                        safe(el.callback, el.value); safe(el.changed, el.value)
                        ov.closing = true
                    end
                end
            end
        end
        if visN == 0 then
            text("ov.t1", "No results", ov.x + 10, listTop + 7, 12, Theme.SubText, Z + 3, false, a)
        end

        if needBar then
            local trackX = ov.x + panelW - barW
            local thumbH = math.max(20, listH * visN / #filtered)
            local thumbY = listTop + (el.scroll / math.max(1, maxScroll)) * (listH - thumbH)
            rect("ov.sbtk", trackX, listTop, barW, listH, Theme.OverlayBorder, 0.5 * a, Z + 2, 2)
            rect("ov.sbth", trackX, thumbY, barW, thumbH, Theme.TabHighlight, 0.6 * a, Z + 3, 2)
            if Input.down and (ov.dragBar or (Input.clicked and inBounds(trackX, listTop, barW, listH))) then
                ov.dragBar = true
                local f = clamp((Input.my - listTop - thumbH / 2) / math.max(1, listH - thumbH), 0, 1)
                el.scroll = math.floor(f * maxScroll + 0.5)
            elseif not Input.down then
                ov.dragBar = false
            end
        end

        if Input.clicked and not ov.closing and not inBounds(ov.x, ov.y, panelW, panelH) then ov.closing = true end
        return true

    elseif ov.kind == "colorpicker" then
        local el = ov.el
        local pad, sv, hueW, svN = 10, 120, 14, 50
        local hasA = el.hasAlpha
        local alphaW = 14
        local fieldH = 22
        local panelW = pad + sv + 8 + hueW + (hasA and (8 + alphaW) or 0) + pad
        local innerW = panelW - pad * 2
        local panelH = pad + sv + 8 + fieldH + 6 + fieldH + 8 + 26 + pad
        local _, vh = getViewport()
        local px = clamp(ov.ax - panelW, State.Win.x + 4, State.Win.x + State.Win.w - panelW - 4)
        local py = clamp(ov.ay, 8, math.max(8, vh - panelH - 8))
        local svx, svy = px + pad, py + pad
        local hx = svx + sv + 8
        local axx = hx + hueW + 8
        local fieldsY = svy + sv + 8
        local rgbY = fieldsY + fieldH + 6
        local btnY = rgbY + fieldH + 8

        rect("ov.bg", px, py, panelW, panelH, Theme.OverlayBg, OP.Overlay, Z, 5)
        outline("ov.bd", px, py, panelW, panelH, Theme.OverlayBorder, 0.7, Z + 1, 5)

        if Input.down then
            if Input.clicked and inBounds(svx, svy, sv, sv) then ov.drag = "sv"
            elseif Input.clicked and inBounds(hx, svy, hueW, sv) then ov.drag = "hue"
            elseif hasA and Input.clicked and inBounds(axx, svy, alphaW, sv) then ov.drag = "alpha" end
        else
            ov.drag = nil
        end
        if ov.drag and State.Focused and State.Focused.owner == el then State.Focused = nil end
        if ov.drag == "sv" then
            el.s = clamp((Input.mx - svx) / sv, 0, 1)
            el.v = 1 - clamp((Input.my - svy) / sv, 0, 1)
        elseif ov.drag == "hue" then
            el.h = 1 - clamp((Input.my - svy) / sv, 0, 1)
        elseif ov.drag == "alpha" then
            el.alpha = 1 - clamp((Input.my - svy) / sv, 0, 1)
        end
        if ov.drag then
            el.value = Color3.fromHSV(el.h, el.s, el.v)
            safe(el.callback, el.value); safe(el.changed, el.value)
        end

        local cell = sv / svN
        local k = 0
        for gx = 0, svN - 1 do
            for gy = 0, svN - 1 do
                k = k + 1
                rect("ov.sv" .. k, math.floor(svx + gx * cell), math.floor(svy + gy * cell), math.ceil(cell), math.ceil(cell),
                    Color3.fromHSV(el.h, (gx + 0.5) / svN, 1 - (gy + 0.5) / svN), 1, Z + 2, 0)
            end
        end
        local hcN = 100
        local hcell = sv / hcN
        for i = 0, hcN - 1 do
            rect("ov.hu" .. i, hx, math.floor(svy + i * hcell), hueW, math.ceil(hcell), Color3.fromHSV(1 - i / hcN, 1, 1), 1, Z + 2, 0)
        end
        outline("ov.svc", svx + el.s * sv - 3, svy + (1 - el.v) * sv - 3, 6, 6, Color3.fromRGB(255, 255, 255), 1, Z + 3, 0)
        rect("ov.huc", hx - 2, svy + (1 - el.h) * sv - 1, hueW + 4, 2, Color3.fromRGB(255, 255, 255), 1, Z + 3, 0)
        if hasA then
            local aN = 100
            local acell = sv / aN
            local aBack = Color3.fromRGB(48, 48, 48)
            for i = 0, aN - 1 do
                local av = 1 - i / (aN - 1)
                rect("ov.a" .. i, axx, math.floor(svy + i * acell), alphaW, math.ceil(acell) + 1, lerpColor(aBack, el.value, av), 1, Z + 2, 0)
            end
            rect("ov.ac", axx - 2, svy + (1 - el.alpha) * sv - 1, alphaW + 4, 2, Color3.fromRGB(255, 255, 255), 1, Z + 4, 0)
        end

        local c = el.value
        local cr, cg, cb = math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)
        local hexStr = string.format("#%02X%02X%02X", cr, cg, cb)
        local function fieldFocused(id) return State.Focused and State.Focused.owner == el and State.Focused.id == id end
        local function focusField(id, seed, onCommit)
            if State.Focused and State.Focused.owner == el and State.Focused.onCommit then State.Focused.onCommit(State.Focused.buf) end
            State.Focused = { owner = el, id = id, buf = seed, numeric = (id ~= "hex"), live = false, onCommit = onCommit }
        end
        local function drawField(fx, fy, fw, id, valStr, onCommit)
            local foc = fieldFocused(id)
            rect("ov.f_" .. id, fx, fy, fw, fieldH, Theme.Control, foc and 0.95 or OP.Control, Z + 3, 4)
            outline("ov.fd_" .. id, fx, fy, fw, fieldH, foc and Theme.Accent or Theme.ElementBorder, 0.6, Z + 4, 4)
            local shownF = valStr
            if foc then
                local caret = (math.floor(tick() * 2) % 2 == 0) and "|" or ""
                shownF = State.Focused.buf .. caret
            end
            text("ov.ft_" .. id, shownF, fx + 6, fy + 4, 12, Theme.Text, Z + 5)
            if not foc and Input.clicked and inBounds(fx, fy, fw, fieldH) then focusField(id, valStr, onCommit) end
        end

        drawField(px + pad, fieldsY, innerW, "hex", hexStr, function(buf)
            local ok, col = pcall(Color3.fromHex, (buf:gsub("%s", "")))
            if ok and col then el.value = col; el.h, el.s, el.v = rgbToHsv(col); safe(el.callback, el.value); safe(el.changed, el.value) end
        end)
        local nF = hasA and 4 or 3
        local fw = math.floor((innerW - (nF - 1) * 6) / nF)
        local fx0 = px + pad
        drawField(fx0, rgbY, fw, "r", tostring(cr), function(buf) local n = tonumber(buf); if n then n = clamp(math.floor(n), 0, 255); local col = Color3.fromRGB(n, cg, cb); el.value = col; el.h, el.s, el.v = rgbToHsv(col); safe(el.callback, el.value); safe(el.changed, el.value) end end)
        drawField(fx0 + (fw + 6), rgbY, fw, "g", tostring(cg), function(buf) local n = tonumber(buf); if n then n = clamp(math.floor(n), 0, 255); local col = Color3.fromRGB(cr, n, cb); el.value = col; el.h, el.s, el.v = rgbToHsv(col); safe(el.callback, el.value); safe(el.changed, el.value) end end)
        drawField(fx0 + (fw + 6) * 2, rgbY, fw, "b", tostring(cb), function(buf) local n = tonumber(buf); if n then n = clamp(math.floor(n), 0, 255); local col = Color3.fromRGB(cr, cg, n); el.value = col; el.h, el.s, el.v = rgbToHsv(col); safe(el.callback, el.value); safe(el.changed, el.value) end end)
        if hasA then
            drawField(fx0 + (fw + 6) * 3, rgbY, fw, "a", tostring(math.floor(el.alpha * 100 + 0.5)), function(buf) local n = tonumber(buf); if n then el.alpha = clamp(n / 100, 0, 1) end end)
        end

        local function closePicker() if State.Focused and State.Focused.owner == el then State.Focused = nil end; State.Overlay = nil end
        local halfW = math.floor((innerW - 8) / 2)
        local cancelHover = inBounds(px + pad, btnY, halfW, 26)
        rect("ov.cancel", px + pad, btnY, halfW, 26, Theme.Control, cancelHover and 0.95 or 0.9, Z + 3, 5)
        outline("ov.canceld", px + pad, btnY, halfW, 26, Theme.OverlayBorder, 0.6, Z + 4, 5)
        text("ov.cancelt", "Cancel", px + pad + halfW / 2 - textW("Cancel", 12) / 2, btnY + 7, 12, Theme.Text, Z + 5)
        local doneX = px + pad + halfW + 8
        local doneHover = inBounds(doneX, btnY, halfW, 26)
        rect("ov.done", doneX, btnY, halfW, 26, Theme.Accent, 1, Z + 3, 5)
        outline("ov.doned", doneX, btnY, halfW, 26, Theme.Accent, 0.6, Z + 4, 5)
        text("ov.donet", "Done", doneX + halfW / 2 - textW("Done", 12) / 2, btnY + 7, 12, Color3.fromRGB(15, 15, 15), Z + 5)
        if Input.clicked then
            if cancelHover then
                el.h, el.s, el.v, el.alpha = ov.origH, ov.origS, ov.origV, ov.origAlpha
                el.value = Color3.fromHSV(el.h, el.s, el.v)
                safe(el.callback, el.value); safe(el.changed, el.value)
                closePicker(); return true
            elseif doneHover then
                closePicker(); return true
            end
        end

        if Input.clicked and not ov.drag and not inBounds(px, py, panelW, panelH) then closePicker() end
        return true
    end

    return false
end

local function pollKeybinds(ck)
    if State.KBListening then
        local el = State.KBListening
        for _, vk in ipairs(ScanList) do
            if vk ~= 0x01 and ck(vk) then
                if vk == 0x1B then
                    State.KBListening = nil
                elseif vk == 0x2E then
                    el.key = nil; el.keyName = "None"; State.KBListening = nil
                    if el.changedCallback then el.changedCallback(nil) end
                    if el.changed then el.changed("None") end
                else
                    el.key = vk; el.keyName = KeyName[vk] or tostring(vk); State.KBListening = nil
                    if el.changedCallback then el.changedCallback(el.keyName) end
                    if el.changed then el.changed(el.keyName) end
                end
                break
            end
        end
        return
    end
    for _, el in ipairs(AllKeybinds) do
        if el.key and ck(el.key) then
            if el.mode == "Toggle" then el:DoClick()
            elseif el.mode == "Hold" and el.callback then el.callback(true) end
        end
    end
end

local function pollTextInput(ck)
    local f = State.Focused
    if not f then return end
    if ck(0x0D) then
        if f.onCommit then f.onCommit(f.buf) end
        State.Focused = nil
        return
    end
    if ck(0x1B) then State.Focused = nil; return end
    local changed = false
    if ck(0x08) then if #f.buf > 0 then f.buf = f.buf:sub(1, -2); changed = true end end
    local shift = iskeypressed(0x10) or iskeypressed(0xA0) or iskeypressed(0xA1)
    for _, vk in ipairs(CharScanList) do
        if ck(vk) then
            local m = CharMap[vk]
            local chr = m and (shift and m[2] or m[1])
            if chr and (not f.numeric or chr:match("[%d%.%-]")) then
                if not f.maxLength or #f.buf < f.maxLength then
                    f.buf = f.buf .. chr
                    changed = true
                end
            end
        end
    end
    if changed and f.live and f.onType then f.onType(f.buf) end
end

local function renderWindow(dt)
    local win = State.Win

    local gripN = 14
    local gx, gy = win.x + win.w - gripN, win.y + win.h - gripN
    if Input.down then
        if not State.Drag and not State.Resizing and not State.Overlay then
            if inBounds(gx, gy, gripN, gripN) then
                State.Resizing = true
            elseif inBounds(win.x, win.y, win.w - 84, TITLE_H) then
                if State.Maximized then UI:Maximize(false) end
                State.Drag = true
                State.DragOff = Vector2.new(clamp(Input.mx - win.x, 0, win.w - 40), Input.my - win.y)
            end
        end
    else
        State.Drag = false
        State.Resizing = false
    end
    if State.Drag then
        win.x = math.floor(Input.mx - State.DragOff.X)
        win.y = math.floor(Input.my - State.DragOff.Y)
    elseif State.Resizing then
        local vw, vh = getViewport()
        win.w = clamp(math.floor(Input.mx - win.x), State.MinW, vw - win.x - 4)
        win.h = clamp(math.floor(Input.my - win.y), State.MinH, vh - win.y - 4)
        gx, gy = win.x + win.w - gripN, win.y + win.h - gripN
    end
    local gripHover = State.Resizing or inBounds(gx, gy, gripN, gripN)
    line("win.grip1", gx + 5, win.y + win.h - 3, win.x + win.w - 3, gy + 5, Theme.SubText, gripHover and 0.9 or 0.45, 62)
    line("win.grip2", gx + 9, win.y + win.h - 3, win.x + win.w - 3, gy + 9, Theme.SubText, gripHover and 0.9 or 0.45, 62)

    outline("win.bd", win.x - 1, win.y - 1, win.w + 2, win.h + 2, Theme.WindowBorder, OP.Border, 10, 9)
    rect("win.bg", win.x, win.y, win.w, win.h, Theme.WindowBg, OP.Window, 11, 8)

    local block = renderOverlay(dt)
    if State.Dialog then block = true end

    local cvy = win.y + TITLE_H + 1
    local cvh = win.h - TITLE_H - 1
    local viewBottom = cvy + cvh
    local tab = Tabs[State.ActiveTab]
    if tab then
        local topPad, gap = 14, 8
        local totalH = topPad * 2
        for _, g in ipairs(tab.groups) do
            if g.title then totalH = totalH + 30 + gap end
            for _, el in ipairs(g.elements) do totalH = totalH + cardHeight(el) + gap end
        end
        totalH = totalH - gap
        local maxScroll = math.max(0, totalH - cvh)
        tab.scroll = clamp(tab.scroll or 0, 0, maxScroll)

        local barW = 0
        if maxScroll > 0 then
            barW = 6
            local barX = win.x + win.w - 8
            local trackY, trackH = cvy + 4, cvh - 8
            local thumbH = math.max(24, trackH * cvh / totalH)
            if Input.down and not block and not State.Resizing and (State.BarDrag or (Input.clicked and inBounds(barX - 3, cvy, 14, cvh))) then
                State.BarDrag = true
                local f = clamp((Input.my - trackY - thumbH / 2) / math.max(1, trackH - thumbH), 0, 1)
                tab.scroll = f * maxScroll
            elseif not Input.down then
                State.BarDrag = false
            end
            tab.scroll = clamp(tab.scroll, 0, maxScroll)
            local thumbY = trackY + (tab.scroll / maxScroll) * (trackH - thumbH)
            rect("win.sbtk", barX, trackY, barW, trackH, Theme.OverlayBorder, 0.4, 20, 2)
            rect("win.sbth", barX, thumbY, barW, thumbH, Theme.TabHighlight, 0.5, 21, 2)
        end

        local cx = win.x + RAIL_W + 14
        local cw = win.w - RAIL_W - 28 - (barW > 0 and 8 or 0)
        local cy = cvy + topPad - tab.scroll
        local mouseInView = Input.mx > win.x + RAIL_W and Input.my > cvy and Input.my < viewBottom
        local idx = 0
        for _, g in ipairs(tab.groups) do
            if g.title then
                idx = idx + 1
                local hh = 30
                if cy + hh > cvy and (cy < cvy or cy + hh <= viewBottom + 1) then
                    text("t" .. State.ActiveTab .. "g" .. idx, g.title, cx + 2, cy + 10, 15, Theme.Text, 22)
                end
                cy = cy + hh + gap
            end
            for _, el in ipairs(g.elements) do
                idx = idx + 1
                local hh = cardHeight(el)
                local top, bot = cy, cy + hh
                if bot > cvy and (top < cvy or bot <= viewBottom + 1) then
                    processEl(el, "t" .. State.ActiveTab .. "e" .. idx, cx, cy, cw, hh, dt, 20, block or not mouseInView)
                end
                cy = cy + hh + gap
            end
        end
    end

    springStep(State.TabCurtain, dt)
    if State.TabCurtain.v > 0.01 then
        rect("win.curtain", win.x + RAIL_W + 1, cvy, win.w - RAIL_W - 1, cvh, Theme.WindowBg, math.min(1, State.TabCurtain.v), 50, 0)
    end

    rect("win.tbmask", win.x, win.y, win.w, TITLE_H, Theme.WindowBg, OP.Window, 58, 8)
    text("win.title", UI.Title or "Wabi", win.x + 18, win.y + 13, 18, Theme.Title, 62)
    if UI.SubTitle and UI.SubTitle ~= "" then
        text("win.sub", UI.SubTitle, win.x + 18 + textW(UI.Title or "Wabi", 18) + 10, win.y + 18, 13, Theme.SubText, 62)
    end
    local mbW, mbH = 28, 22
    local mbX, mbY = win.x + win.w - 16 - mbW, win.y + 11
    local mbHover = not block and inBounds(mbX, mbY, mbW, mbH)
    rect("win.minbg", mbX, mbY, mbW, mbH, Theme.Control, mbHover and 0.6 or 0, 60, 5)
    line("win.min", mbX + 9, mbY + math.floor(mbH / 2), mbX + mbW - 9, mbY + math.floor(mbH / 2), Theme.Text, 0.9, 61)
    if mbHover and Input.clicked then UI:Minimize() end
    local mxW = 28
    local mxX, mxY = mbX - 6 - mxW, win.y + 11
    local mxHover = not block and inBounds(mxX, mxY, mxW, mbH)
    rect("win.maxbg", mxX, mxY, mxW, mbH, Theme.Control, mxHover and 0.6 or 0, 60, 5)
    outline("win.max", mxX + 9, mxY + 6, mxW - 18, mbH - 12, Theme.Text, 0.9, 61, 2)
    if mxHover and Input.clicked then UI:Maximize() end
    line("win.tline", win.x, win.y + TITLE_H, win.x + win.w, win.y + TITLE_H, Theme.TitleBarLine, 0.5, 59)
    line("win.rline", win.x + RAIL_W, win.y + TITLE_H, win.x + RAIL_W, win.y + win.h, Theme.RailLine, OP.Rail, 59)
    local tabY0 = win.y + TITLE_H + 10
    for i, t in ipairs(Tabs) do
        local ty = tabY0 + (i - 1) * 36
        local tx = win.x + 8
        local tw = RAIL_W - 16
        local active = (i == State.ActiveTab)
        local hovered = inBounds(tx, ty, tw, 30) and not block
        if hovered and Input.clicked and not active then
            State.ActiveTab = i; State.Overlay = nil; State.Focused = nil; State.TabCurtain.v = 1
        end
        rect("tab.hl" .. i, tx, ty, tw, 30, Theme.TabHighlight, active and OP.TabActive or (hovered and OP.TabHover or 0), 60, 6)
        local textX = tx + 14
        if t.icon then
            textX = tx + 36
            if t.iconData then image("tab.ic" .. i, t.iconData, tx + 12, ty + 7, 16, 16, active and 1 or 0.5, 61) end
        end
        text("tab.tx" .. i, t.name, textX, ty + 8, 13, active and Theme.TabTextActive or Theme.TabText, 61)
    end
    State.IndOff.goal = (State.ActiveTab - 1) * 36
    if not State.IndInit then State.IndOff.v = State.IndOff.goal; State.IndInit = true end
    springStep(State.IndOff, dt)
    rect("tab.ind", win.x + 8, tabY0 + State.IndOff.v + 7, 3, 16, Theme.Accent, 1, 61, 2)
end

local function renderNotifs(dt)
    if #Notifs == 0 then return end
    local vw, vh = State.Vw, State.Vh
    local margin, w, Z = 16, 300, 200
    local now = tick()
    local y = vh - margin
    for idx = #Notifs, 1, -1 do
        local n = Notifs[idx]
        if n.duration and not n.dying and (now - n.born) > n.duration then
            n.dying = true; n.diedAt = now; n.slide.goal = 1; n.alpha.goal = 0
        end
        if n.dying and (now - (n.diedAt or now)) > 0.4 then
            table.remove(Notifs, idx)
        else
            springStep(n.slide, dt); springStep(n.alpha, dt)
            local hh = 14 + 18 + #n.lines * 15 + (n.sub and 16 or 0) + 12
            y = y - hh
            local x = vw - margin - w + n.slide.v * (w + margin + 8)
            local a = n.alpha.v
            rect("nf.bg" .. n.id, x, y, w, hh, Theme.OverlayBg, OP.Overlay * a, Z, 6)
            outline("nf.bd" .. n.id, x, y, w, hh, Theme.Accent, 0.5 * a, Z + 1, 6)
            text("nf.t" .. n.id, n.title, x + 14, y + 12, 13, Theme.Text, Z + 2, false, a)
            local cx, cy = x + w - 22, y + 11
            text("nf.x" .. n.id, "x", cx, cy, 14, Theme.SubText, Z + 3, false, a)
            if not n.dying and Input.clicked and inBounds(cx - 5, cy - 3, 20, 20) then
                n.dying = true; n.diedAt = now; n.slide.goal = 1; n.alpha.goal = 0
            end
            local ly = y + 32
            for li, ln in ipairs(n.lines) do
                text("nf.c" .. n.id .. "_" .. li, ln, x + 14, ly, 12, Theme.SubText, Z + 2, false, a)
                ly = ly + 15
            end
            if n.sub then text("nf.s" .. n.id, n.sub, x + 14, ly, 11, Color3.fromRGB(120, 120, 120), Z + 2, false, a) end
            y = y - 10
        end
    end
end

local function renderDialog(dt)
    local d = State.Dialog
    if not d then return end
    local vw, vh = State.Vw, State.Vh
    d.anim = d.anim or newSpring(0, 20)
    d.anim.goal = d.closing and 0 or 1
    local a = springStep(d.anim, dt)
    if d.closing and a < 0.04 then State.Dialog = nil; return end
    rect("dlg.bk", 0, 0, vw, vh, Color3.fromRGB(0, 0, 0), 0.5 * a, 145, 0)
    local bw = 340
    local bh = 16 + 24 + #d.lines * 16 + 18 + 36
    local bx = math.floor((vw - bw) / 2)
    local by = math.floor((vh - bh) / 2) + math.floor((1 - a) * 12)
    rect("dlg.bg", bx, by, bw, bh, Theme.OverlayBg, a, 150, 8)
    outline("dlg.bd", bx, by, bw, bh, Theme.OverlayBorder, 0.8 * a, 151, 8)
    text("dlg.t", d.title, bx + 18, by + 15, 15, Theme.Text, 152, false, a)
    local ly = by + 44
    for li, ln in ipairs(d.lines) do text("dlg.c" .. li, ln, bx + 18, ly, 12, Theme.SubText, 152, false, a); ly = ly + 16 end
    local nb = #d.buttons
    local pad = 18
    local btnW = math.floor((bw - pad * 2 - (nb - 1) * 10) / math.max(1, nb))
    local btnY = by + bh - pad - 28
    for i, b in ipairs(d.buttons) do
        local btnX = bx + pad + (i - 1) * (btnW + 10)
        local accent = (i == 1)
        local bHover = inBounds(btnX, btnY, btnW, 28)
        rect("dlg.btn" .. i, btnX, btnY, btnW, 28, accent and Theme.Accent or Theme.Control, (accent and 1 or (bHover and 0.95 or 0.9)) * a, 152, 5)
        outline("dlg.btb" .. i, btnX, btnY, btnW, 28, accent and Theme.Accent or Theme.OverlayBorder, 0.6 * a, 153, 5)
        local label = b.Title or "OK"
        text("dlg.btx" .. i, label, btnX + btnW / 2 - textW(label, 12) / 2, btnY + 8, 12, accent and Color3.fromRGB(15, 15, 15) or Theme.Text, 153, false, a)
        if bHover and Input.clicked and not d.closing then
            d.closing = true
            safe(b.Callback)
        end
    end
end

local function renderBubble(dt)
    local bp = State.BubblePos
    local label = UI.Title or "Wabi"
    if UI.SubTitle and UI.SubTitle ~= "" then label = label .. "  " .. UI.SubTitle end
    local pw = math.floor(46 + textW(label, 13))
    local ph = 32
    local hovered = inBounds(bp.x, bp.y, pw, ph)
    if Input.down then
        if not State.BubbleDrag and hovered then
            State.BubbleDrag = true; State.BubbleMoved = false
            State.BubbleOff = Vector2.new(Input.mx - bp.x, Input.my - bp.y)
        end
        if State.BubbleDrag then
            local nx, ny = math.floor(Input.mx - State.BubbleOff.X), math.floor(Input.my - State.BubbleOff.Y)
            if math.abs(nx - bp.x) > 2 or math.abs(ny - bp.y) > 2 then State.BubbleMoved = true end
            bp.x, bp.y = nx, ny
        end
    else
        if State.BubbleDrag and not State.BubbleMoved then UI:Minimize() end
        State.BubbleDrag = false
    end
    rect("bub.bg", bp.x, bp.y, pw, ph, Theme.WindowBg, OP.Window, 120, 9)
    outline("bub.bd", bp.x, bp.y, pw, ph, hovered and Theme.Accent or Theme.WindowBorder, hovered and 0.7 or OP.Border, 121, 9)
    circle("bub.dot", bp.x + 18, bp.y + ph / 2, 5, Theme.Accent, 1, 122)
    text("bub.tx", label, bp.x + 32, bp.y + 9, 13, Theme.Title, 122)
end

local function step()
    if not isrbxactive() then return end
    State.InStep = true
    CurTick = CurTick + 1
    local now = tick()
    local dt = State.LastTime and (now - State.LastTime) or 0.016
    if dt > 0.1 then dt = 0.1 elseif dt < 0 then dt = 0.016 end
    State.LastTime = now

    pollInput()
    local clicks = {}
    local function ck(vk) local c = clicks[vk]; if c == nil then c = keyEdge(vk); clicks[vk] = c end return c end

    local busy = State.KBListening ~= nil or State.Focused ~= nil
    pollKeybinds(ck)
    pollTextInput(ck)
    if not busy and ck(State.MenuKey) then UI:Minimize() end

    if #Notifs > 0 or State.Dialog then State.Vw, State.Vh = getViewport() end
    if State.Minimized then renderBubble(dt) else renderWindow(dt) end
    renderDialog(dt)
    renderNotifs(dt)
    cleanup()
    State.InStep = false
end

function UI:_RemoveAll()
    for _, c in pairs(Cache) do
        if c.Obj and c.Obj.Remove then pcall(function() c.Obj:Remove() end) end
    end
    Cache = {}; Visible = {}
end

UI.Version = "1.0.0"
UI.Unloaded = false
UI.Loaded = false

function UI:Start()
    local prev = _G.__Bwin
    if prev and prev ~= UI and prev._RemoveAll then pcall(function() prev:_RemoveAll() end) end
    _G.__Bwin = UI
    if State.Running then _G.__BwinToken = State.Token; return end
    local token = {}
    _G.__BwinToken = token; State.Token = token; State.Running = true
    UI.Loaded = true; UI.Unloaded = false
    task.spawn(function()
        while _G.__BwinToken == token do
            local ok, err = pcall(step)
            if not ok then warn("[Bwin] " .. tostring(err)) end
            State.InStep = false
            Input.prevDown = Input.down
            task.wait()
        end
        State.Running = false
        UI.Loaded = false
        pcall(function() UI:_RemoveAll() end)
    end)
end

function UI:Stop()
    if _G.__BwinToken == State.Token then _G.__BwinToken = nil end
    State.Running = false
    UI:_RemoveAll()
end

function UI:Destroy()
    UI.Unloaded = true
    UI.Loaded = false
    UI:Stop()
end

function UI:Notify(cfg)
    cfg = cfg or {}
    NotifId = NotifId + 1
    local lines = {}
    for ln in (tostring(cfg.Content or "") .. "\n"):gmatch("(.-)\n") do table.insert(lines, ln) end
    if #lines > 0 and lines[#lines] == "" then table.remove(lines) end
    local n = {
        id = NotifId, title = cfg.Title or "Notification", lines = lines, sub = cfg.SubContent,
        duration = cfg.Duration, born = tick(),
        slide = newSpring(1, 13), alpha = newSpring(0, 13), dying = false,
    }
    n.slide.goal = 0; n.alpha.goal = 1
    table.insert(Notifs, n)
    return n
end

function UI:Minimize()
    State.Minimized = not State.Minimized
    State.Overlay = nil; State.KBListening = nil; State.Focused = nil
    if State.Minimized then
        State.BubblePos.x = State.Win.x
        State.BubblePos.y = State.Win.y
        State.Drag = false
        if not State.MinNotified then
            State.MinNotified = true
            UI:Notify({ Title = "Bwin", Content = "Press " .. (State.MenuKeyName or "End") .. " or click the bubble to restore.", Duration = 6 })
        end
    end
end

function UI:Maximize(on)
    local win = State.Win
    if on == nil then on = not State.Maximized end
    if on and not State.Maximized then
        State.PreMax = { x = win.x, y = win.y, w = win.w, h = win.h }
        local vw, vh = getViewport()
        win.x, win.y, win.w, win.h = 0, 0, vw, vh
        State.Maximized = true
        State.Drag = false
    elseif not on and State.Maximized then
        local p = State.PreMax
        if p then win.x, win.y, win.w, win.h = p.x, p.y, p.w, p.h end
        State.Maximized = false
    end
end

function UI:SafeCallback(fn, ...)
    return safe(fn, ...)
end

UI.Options = Options

local function serializeEl(el)
    local k = el.kind
    if k == "toggle" then return { t = "b", v = el.value }
    elseif k == "slider" then return { t = "n", v = el.value }
    elseif k == "input" then return { t = "s", v = el.text }
    elseif k == "dropdown" then
        if el.multi then
            local arr = {}
            for opt, on in pairs(el.value) do if on then arr[#arr + 1] = opt end end
            return { t = "dm", v = arr }
        end
        return { t = "d", v = el.value }
    elseif k == "colorpicker" then local c = el.value; return { t = "c", r = c.R, g = c.G, b = c.B }
    elseif k == "keybind" then return { t = "k", key = el.key, name = el.keyName } end
end

local function deserializeEl(el, d)
    if not d then return end
    local k = el.kind
    if k == "toggle" then el:SetValue(d.v and true or false)
    elseif k == "slider" then if d.v then el:SetValue(d.v) end
    elseif k == "input" then el:SetValue(tostring(d.v or ""))
    elseif k == "dropdown" then
        if el.multi then
            local m = {}
            if type(d.v) == "table" then for _, o in ipairs(d.v) do m[o] = true end end
            el:SetValue(m)
        elseif d.v then el:SetValue(d.v) end
    elseif k == "colorpicker" then el:SetValue(Color3.new(d.r or 0, d.g or 0, d.b or 0))
    elseif k == "keybind" then
        el.key = d.key; el.keyName = d.name or "None"
        if el.changed then el.changed(el.keyName) end
    end
end

function UI:SaveConfig(name)
    name = name or UI.ConfigName or "default"
    local data = {}
    for id, el in pairs(Options) do
        local s = serializeEl(el)
        if s then data[id] = s end
    end
    pcall(function() makefolder("Bwin") end)
    local ok, json = pcall(function() return game:GetService("HttpService"):JSONEncode(data) end)
    if ok and json then pcall(function() writefile("Bwin/" .. name .. ".json", json) end) end
    return ok == true
end

function UI:LoadConfig(name)
    name = name or UI.ConfigName or "default"
    local ok, content = pcall(function() return readfile("Bwin/" .. name .. ".json") end)
    if not ok or not content then return false end
    local dok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
    if not dok or type(data) ~= "table" then return false end
    for id, d in pairs(data) do
        local el = Options[id]
        if el then deserializeEl(el, d) end
    end
    return true
end

function UI:SetTheme(name)
    local p = Palettes[name]
    if not p then return end
    for k, v in pairs(Palettes.Dark) do Theme[k] = v end
    for k, v in pairs(p) do Theme[k] = v end
    UI.ThemeName = name
end

function UI:SetTranslucent(on)
    OP.Window = (on == false) and 1 or 0.99
end

function UI:GetConfigs()
    local out = {}
    pcall(function()
        for _, path in ipairs(listfiles("Bwin")) do
            local name = tostring(path):match("([^/\\]+)%.json$")
            if name and name ~= "interface" then out[#out + 1] = name end
        end
    end)
    table.sort(out)
    return out
end

function UI:SetAutoload(name)
    pcall(function() makefolder("Bwin") end)
    pcall(function() writefile("Bwin/autoload.txt", tostring(name)) end)
end

function UI:GetAutoload()
    local ok, content = pcall(function() return readfile("Bwin/autoload.txt") end)
    if ok and content and content ~= "" then return content end
    return nil
end

function UI:LoadAutoloadConfig()
    local name = UI:GetAutoload()
    if name then return UI:LoadConfig(name) end
    return false
end

function UI:SaveInterfaceSettings()
    local data = { Theme = UI.ThemeName, Translucent = OP.Window < 1, MenuKey = State.MenuKey, MenuKeyName = State.MenuKeyName }
    pcall(function() makefolder("Bwin") end)
    local ok, json = pcall(function() return game:GetService("HttpService"):JSONEncode(data) end)
    if ok and json then pcall(function() writefile("Bwin/interface.json", json) end) end
end

function UI:LoadInterfaceSettings()
    local ok, content = pcall(function() return readfile("Bwin/interface.json") end)
    if not ok or not content then return nil end
    local dok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
    if dok and type(data) == "table" then return data end
    return nil
end

function UI:CreateWindow(cfg)
    cfg = cfg or {}
    State.Win.w = (cfg.Size and cfg.Size.X) or 580
    State.Win.h = (cfg.Size and cfg.Size.Y) or 460
    if cfg.MinSize then State.MinW = cfg.MinSize.X or State.MinW; State.MinH = cfg.MinSize.Y or State.MinH end
    if cfg.Resize then
        local vw, vh = getViewport()
        local scale = math.min(1, vw / 1920, vh / 1080)
        State.Win.w = math.max(State.MinW, math.floor(State.Win.w * scale))
        State.Win.h = math.max(State.MinH, math.floor(State.Win.h * scale))
    end
    UI.Title = cfg.Title or "Wabi"
    UI.SubTitle = cfg.SubTitle or ""
    UI.ConfigName = cfg.ConfigName
    if cfg.Translucent ~= nil then UI:SetTranslucent(cfg.Translucent) end
    if cfg.Theme then UI:SetTheme(cfg.Theme) end
    if cfg.MinimizeKey ~= nil then
        local vk, name = resolveKey(cfg.MinimizeKey)
        if vk then State.MenuKey = vk; State.MenuKeyName = name end
    end
    center()

    local Window = {}
    function Window:AddTab(arg)
        local name, icon
        if type(arg) == "table" then name = arg.Title or arg.Name or "Tab"; icon = arg.Icon else name = arg or "Tab" end
        local loose = { title = nil, elements = {} }
        local tab = { name = name, groups = { loose }, current = loose, icon = icon }
        table.insert(Tabs, tab)
        if icon then loadIcon(icon, function(data) tab.iconData = data end) end
        local function addTo(group, c, e)
            e.id = c.Id or c.Flag
            e.icon = c.Icon
            if e.kind == "toggle" and c.Keybind then
                e.keybind = mkKeybind({ Default = c.Keybind, Mode = "Toggle", Callback = function() e:SetValue(not e.value) end })
            end
            table.insert(group.elements, e)
            if e.id then Options[e.id] = e end
            if e.icon then loadIcon(e.icon, function(data) e.iconData = data end) end
            return e
        end
        local function bindAdders(I, getGroup)
            function I:AddParagraph(c) return addTo(getGroup(), c, mkParagraph(c)) end
            function I:AddButton(c) return addTo(getGroup(), c, mkButton(c)) end
            function I:AddToggle(c) return addTo(getGroup(), c, mkToggle(c)) end
            function I:AddSlider(c) return addTo(getGroup(), c, mkSlider(c)) end
            function I:AddDropdown(c) return addTo(getGroup(), c, mkDropdown(c)) end
            function I:AddKeybind(c) return addTo(getGroup(), c, mkKeybind(c)) end
            function I:AddColorpicker(c) return addTo(getGroup(), c, mkColorpicker(c)) end
            function I:AddInput(c) return addTo(getGroup(), c, mkInput(c)) end
            return I
        end
        local TI = bindAdders({}, function() return tab.current end)
        function TI:AddSection(title)
            local g = { title = title or "Section", elements = {} }
            table.insert(tab.groups, g)
            tab.current = g
            return bindAdders({}, function() return g end)
        end
        return TI
    end
    function Window:SelectTab(i) State.ActiveTab = i end
    function Window:Dialog(dcfg)
        dcfg = dcfg or {}
        local lines = {}
        for ln in (tostring(dcfg.Content or "") .. "\n"):gmatch("(.-)\n") do table.insert(lines, ln) end
        if #lines > 0 and lines[#lines] == "" then table.remove(lines) end
        State.Dialog = { title = dcfg.Title or "Dialog", lines = lines, buttons = dcfg.Buttons or { { Title = "OK" } } }
        if dcfg.Yield and not State.InStep then
            while State.Dialog do task.wait() end
        end
    end
    function Window:BuildConfigSection(tab)
        local section = tab:AddSection("Configuration")
        local nameInput = section:AddInput({ Title = "Config name", Placeholder = "name..." })
        local list = section:AddDropdown({ Title = "Config list", Options = UI:GetConfigs() })
        section:AddButton({ Title = "Create config", Callback = function()
            local name = nameInput.text
            if not name or name:gsub("%s", "") == "" then return UI:Notify({ Title = "Config", Content = "Invalid config name", Duration = 4 }) end
            UI:SaveConfig(name)
            list:SetValues(UI:GetConfigs())
            UI:Notify({ Title = "Config", Content = "Created '" .. name .. "'", Duration = 3 })
        end })
        section:AddButton({ Title = "Load config", Callback = function()
            local name = list.value
            if not name then return UI:Notify({ Title = "Config", Content = "No config selected", Duration = 4 }) end
            if UI:LoadConfig(name) then UI:Notify({ Title = "Config", Content = "Loaded '" .. name .. "'", Duration = 3 })
            else UI:Notify({ Title = "Config", Content = "Failed to load '" .. name .. "'", Duration = 4 }) end
        end })
        section:AddButton({ Title = "Overwrite config", Callback = function()
            local name = list.value
            if not name then return UI:Notify({ Title = "Config", Content = "No config selected", Duration = 4 }) end
            UI:SaveConfig(name)
            UI:Notify({ Title = "Config", Content = "Overwrote '" .. name .. "'", Duration = 3 })
        end })
        section:AddButton({ Title = "Refresh list", Callback = function()
            list:SetValues(UI:GetConfigs())
        end })
        local autoBtn
        autoBtn = section:AddButton({ Title = "Set as autoload", Description = "Autoload: " .. (UI:GetAutoload() or "none"), Callback = function()
            local name = list.value
            if not name then return UI:Notify({ Title = "Config", Content = "No config selected", Duration = 4 }) end
            UI:SetAutoload(name)
            autoBtn.desc = "Autoload: " .. name
            UI:Notify({ Title = "Config", Content = "'" .. name .. "' will autoload", Duration = 3 })
        end })
        return section
    end
    function Window:BuildInterfaceSection(tab)
        local s = UI:LoadInterfaceSettings() or {}
        if s.Theme then UI:SetTheme(s.Theme) end
        if s.Translucent ~= nil then UI:SetTranslucent(s.Translucent) end
        if s.MenuKey then State.MenuKey = s.MenuKey; State.MenuKeyName = s.MenuKeyName or KeyName[s.MenuKey] or "?" end
        local section = tab:AddSection("Interface")
        section:AddDropdown({ Title = "Theme", Description = "Changes the interface theme", Options = UI.Themes, Default = UI.ThemeName or "Dark", Callback = function(v)
            UI:SetTheme(v); UI:SaveInterfaceSettings()
        end })
        section:AddToggle({ Title = "Translucent", Description = "Subtle translucency vs solid", Default = OP.Window < 1, Callback = function(v)
            UI:SetTranslucent(v); UI:SaveInterfaceSettings()
        end })
        local kb = section:AddKeybind({ Title = "Minimize bind", Default = State.MenuKeyName })
        kb:OnChanged(function()
            State.MenuKey = kb.key or State.MenuKey
            State.MenuKeyName = kb.keyName or State.MenuKeyName
            UI:SaveInterfaceSettings()
        end)
        return section
    end

    if cfg.AutoStep ~= false then UI:Start() end
    return Window
end

return Bwin
--a
