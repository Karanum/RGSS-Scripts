#==============================================================================
# 
# ◆ Karanum's Crystal Engine - Auto Apply State
# -- Last Updated: 2015.05.21
# -- Level: Easy
# -- Requires: n/a
# 
#==============================================================================
 
$imported = {} if $imported.nil?
$imported["KCE_AutoApplyState"] = true

#==============================================================================
# ◆ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2015.05.11 - Initial script release.
# 
#==============================================================================
# ◆ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Sometimes you need weapons that randomly inflict a status effect on its
# wielder, or an enemy that has a random chance of buffing itself each turn.
# This script allows you to inflict states at the start or the end of a turn 
# with a random chance, all through notetags.
# 
#==============================================================================
# ◆ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open the script editor and paste this script into an
# empty slot below Materials and above Main.
# 
# You can use the following notetags on Actors, Classes, Weapons, Armors and
# Enemies:
#
#   <turn start state: (state), (chance)%>
#   <turn end state: (state), (chance)%>
#
# Simply replace (state) with the id of the state you want to inflict and
# (chance) with the chance to inflict it in percentages, between 0 and 100.
#
#==============================================================================
# ◆ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script does not modify any existing methods. This script should be
# compatible with all other scripts.
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

#==============================================================================
# >> WARNING << - Editing anything past this point may result in the script 
# crashing your game or doing unexpected things. Don't edit it unless you know
# what you're doing and/or you're going to take responsibility for your mess.
#==============================================================================


module Karanum
  module RegExp
    TURN_END_STATE_TAG = /<turn[_ ]end[_ ]state:[ ]*(\d+)[ ]*,[ ]*(\d+)%?>/i
    TURN_START_STATE_TAG = /<turn[_ ]start[_ ]state:[ ]*(\d+)[ ]*,[ ]*(\d+)%?>/i
  end
end
 

#==============================================================================
# Scene_Battle
#==============================================================================
class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias method: turn_end
  #--------------------------------------------------------------------------
  alias kara_tstate_scbattle_turnend turn_end
  def turn_end
    check_turn_states(Karanum::RegExp::TURN_END_STATE_TAG)
    kara_tstate_scbattle_turnend
  end
  
  #--------------------------------------------------------------------------
  # alias method: turn_start
  #--------------------------------------------------------------------------
  alias kara_tstate_scbattle_turnstart turn_start
  def turn_start
    check_turn_states(Karanum::RegExp::TURN_START_STATE_TAG)
    kara_tstate_scbattle_turnstart
  end
 
  #--------------------------------------------------------------------------
  # new method: check_turn_states
  #--------------------------------------------------------------------------
  def check_turn_states(pattern)
    $game_party.members.each do |actor|
      check_item_turn_states(actor.actor, actor, pattern)
      check_item_turn_states(actor.class, actor, pattern)
      actor.equips.each do |equip|
        check_item_turn_states(equip, actor, pattern) unless equip.nil?
      end
      @log_window.display_added_states(actor)
    end
   
    $game_troop.members.each do |enemy|
      check_item_turn_states(enemy.enemy, enemy, pattern)
      @log_window.display_added_states(enemy)
    end
  end
 
  #--------------------------------------------------------------------------
  # new method: check_item_turn_states
  #--------------------------------------------------------------------------
  def check_item_turn_states(item, target, pattern)
    note = item.note
    note.split(/[\r\n]+/).each do |line|
      if line.match(pattern) then
        apply_turn_state(target, $1, $2)
      end
    end
  end
 
  #--------------------------------------------------------------------------
  # new method: apply_turn_state
  #--------------------------------------------------------------------------
  def apply_turn_state(target, state, chance)
    return if target.state?(state.to_i)
    if rand < (chance.to_f/100.0) then
      target.add_state(state.to_i)
    end
  end
end

#==============================================================================
# ◆ End of Script
#==============================================================================