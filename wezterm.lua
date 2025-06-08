-- to install this in windows, just copy this file to the same directory of the wezterm .exe

local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- config.color_scheme = 'Ibm 3270 (High Contrast) (Gogh)'
config.enable_tab_bar = false
config.font = wezterm.font 'Liberation Mono'
-- window_decorations = "NONE"
adjust_window_size_when_changing_font_size = false -- this needs to be disabled when using a tiling wm
config.font_size = 14.0
config.default_cursor_style = "SteadyBlock"
config.window_padding = 
{
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- you need to always get a new VsDevShell value for any new machine/vs installation. to do that, just go to the properties of the "Developer PowerShell for VS 2022" shortcut  

if wezterm.target_triple:match("windows") then
	config.default_prog = {'powershell.exe', '-NoLogo', '-NoProfile', '-noe', '-Command', '&{Import-Module "C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell ff8e5fa6 -SkipAutomaticLocation -DevCmdArguments "-arch=x64 -host_arch=x64"}'}
	config.default_cwd = "c:\\dev"
end

-- and finally, return the configuration to wezterm
return config
