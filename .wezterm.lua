-- ============================================================================
-- WezTerm Configuration
-- ============================================================================

local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- ==========================================
-- 1. 默认启动终端 (强制 PowerShell)
-- ==========================================
-- 如果你用 Scoop 安装了新版 PowerShell 7，可以把 'powershell.exe' 改成 'pwsh.exe'
config.default_prog = { 'powershell.exe', '-NoLogo' }

-- ==========================================
-- 2. 字体设置 (修复 Fallback 报错)
-- ==========================================
config.font = wezterm.font_with_fallback {
  'SauceCodePro Nerd Font Mono',
  'SauceCodePro NFM',
  'Source Code Pro',
  'Consolas',
}
config.font_size = 11.0

-- ==========================================
-- 3. 窗口边框与留白 (Padding)
-- ==========================================
config.window_decorations = 'RESIZE'

-- 给四周留出 8 像素的空白，防止文字顶破圆角边缘，视觉上更有呼吸感
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- ==========================================
-- 4. 背景、色彩与毛玻璃特效
-- ==========================================
config.win32_system_backdrop = 'Acrylic'
config.window_background_opacity = 0.65 

config.colors = {
  background = '#282c47', 
  
  -- 修改 1: 字体和光标颜色，抛弃蓝色系，采用高对比度的暖色调
  foreground = '#F8F8F2', -- 柔和的奶白色，对比度极佳
  cursor_bg = '#ffdbe6',  -- 光标使用你那张壁纸里的“樱花粉”
  cursor_fg = '#282c47',  -- 光标内的字体颜色反转为背景色
  
  -- Tab Bar 样式配色
  tab_bar = {
    background = 'rgba(0, 0, 0, 0)',
    active_tab = {
      bg_color = '#ffdbe6', -- 激活的 Tab 也使用樱花粉，与光标呼应
      fg_color = '#282c47',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = 'rgba(255, 255, 255, 0.1)',
      fg_color = '#ffffff',
      intensity = 'Normal',
    },
  },
}

config.audible_bell = 'Disabled'

-- ==========================================
-- 5. 标签页栏样式 (Tab Bar Style)
-- ==========================================
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 25

-- ==========================================
-- 6. 快捷键映射
-- ==========================================
config.keys = {
  { key = '1', mods = 'CTRL', action = act.ActivateTab(0) },
  { key = '2', mods = 'CTRL', action = act.ActivateTab(1) },
  { key = '3', mods = 'CTRL', action = act.ActivateTab(2) },
  { key = '4', mods = 'CTRL', action = act.ActivateTab(3) },
  { key = '[', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CTRL', action = act.ActivateTabRelative(1) },

  { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'CTRL', action = act.CloseCurrentPane { confirm = false } },
  { key = 'w', mods = 'CTRL', action = act.DisableDefaultAssignment },

  { key = 'd', mods = 'CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  { key = 'LeftArrow',  mods = 'CTRL', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CTRL', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
}

return config
