#==============================================================================
# 
# ◆ Karanum's Crystal Engine - Debug Build Manager
# -- Last Updated: 2015.05.21
# -- Level: Easy
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["Karanum_DebugBuild"] = true

#==============================================================================
# ◆ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2015.05.11 - Initial script release.
# 
#==============================================================================
# ◆ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Originally created to combat the limitations of the Steam Workshop, this
# script lets you set whether the game should start in playtest mode,
# regardless of how it is run.
#
# Additionally, this script also adds a fancy playtest timer in-game and 
# debug + copyright messages for the title screen.
#
#==============================================================================
# ◆ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open the script editor and paste this script into an
# empty slot below Materials and above Main.
# 
# Simply fill out the configuration below and you're good to go.
#
#==============================================================================
# ◆ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script does not override any existing methods. There should be no
# compatibility issues.
#
#==============================================================================
# ◆ Terms of Use
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script may be used freely for non-commercial purposes only. Explicit 
# permission must be granted for commercial use. You can contact 
# "eposofcrystal@gmail.com" to request permission. In all cases, commercial 
# or non-commercial, proper credit needs to be given to Karanum. 
#
# Redistribution outside of RPG Maker games is not allowed; please link to 
# "https://github.com/Karanum/RGSS-Scripts" instead.
#==============================================================================

module Karanum
  module DebugBuild
    
    #Debug mode toggle. Set this to 'false' when releasing publicly.
    DEBUG = true
    
    #Show playtime window when in debug mode?
    DEBUG_TIMER = false
    
    #Messages to be displayed on the title screen
    DEBUG_WARNING = "Debug Build - Not for distribution!"
    COPYRIGHT_MSG = "©2015 (enter name)"
  
  end
end

#==============================================================================
# >> WARNING << - Editing anything past this point may result in the script 
# crashing your game or doing unexpected things. Don't edit it unless you know
# what you're doing and/or you're going to take responsibility for your mess.
#==============================================================================


#==============================================================================
# Scene_Title
#==============================================================================
class Scene_Title < Scene_Base
  
  #--------------------------------------------------------------------------
  # aliased method: start
  #--------------------------------------------------------------------------
  alias karanum_debug_start start
  def start
    $TEST = Karanum::DebugBuild::DEBUG
    karanum_debug_start
  end
  
  #--------------------------------------------------------------------------
  # aliased method: create_foreground
  #--------------------------------------------------------------------------
  alias karanum_debug_foreground create_foreground
  def create_foreground
    karanum_debug_foreground
    draw_debug if Karanum::DebugBuild::DEBUG
    draw_copyright
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_debug
  #--------------------------------------------------------------------------
  def draw_debug
    @foreground_sprite.bitmap.font.size = 20
    @foreground_sprite.bitmap.font.color = Color.new(255, 70, 70)
    rect = Rect.new(0, 0, Graphics.width, 24)
    @foreground_sprite.bitmap.draw_text(rect, Karanum::DebugBuild::DEBUG_WARNING, 2)
  end
  
  #--------------------------------------------------------------------------
  # new method: draw_copyright
  #--------------------------------------------------------------------------
  def draw_copyright
    @foreground_sprite.bitmap.font.size = 20
    @foreground_sprite.bitmap.font.color = Color.new(255, 255, 255)
    rect = Rect.new(0, Graphics.height - 24, Graphics.width, 24)
    @foreground_sprite.bitmap.draw_text(rect, Karanum::DebugBuild::COPYRIGHT_MSG, 2)
  end
  
end


#==============================================================================
# Window_DebugPlaytime
#==============================================================================
class Window_DebugPlaytime < Window_Base
  
  #--------------------------------------------------------------------------
  # extended method: initialize
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, fitting_height(1))
    refresh
  end
  
  #--------------------------------------------------------------------------
  # extended method: window_width
  #--------------------------------------------------------------------------
  def window_width
    return 128
  end

  #--------------------------------------------------------------------------
  # extended method: refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    playtime = $game_system.playtime_s
    draw_text(4, 0, contents_width - 8, line_height, playtime, 2)
  end

  #--------------------------------------------------------------------------
  # extended method: open
  #--------------------------------------------------------------------------
  def open
    refresh
    super
  end
  
  #--------------------------------------------------------------------------
  # extended method: update
  #--------------------------------------------------------------------------
  def update
    refresh
    super
  end
  
end


#==============================================================================
# Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  
  #--------------------------------------------------------------------------
  # aliased method: start
  #--------------------------------------------------------------------------
  alias karanum_debug_scenemap_start start
  def start
    karanum_debug_scenemap_start
    if Karanum::DebugBuild::DEBUG and Karanum::DebugBuild::DEBUG_TIMER
      create_playtime_window 
    end
  end
  
  #--------------------------------------------------------------------------
  # new method: create_playtime_window
  #--------------------------------------------------------------------------
  def create_playtime_window
    @playtime_window = Window_DebugPlaytime.new
    @playtime_window.x = Graphics.width - 128
  end
  
end


#==============================================================================
# ◆ End of Script
#==============================================================================