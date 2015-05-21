#==============================================================================
# 
# ◆ Karanum's Crystal Engine - State Force Equip
# -- Last Updated: 2015.05.21
# -- Level: Easy
# -- Requires: n/a
# 
#==============================================================================

$imported = {} if $imported.nil?
$imported["KCE_StateForceEquip"] = true

#==============================================================================
# ◆ Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2015.05.11 - Initial script release.
# 
#==============================================================================
# ◆ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script lets you force pieces of equipment on characters if they get
# afflicted with a certain state, and restores the original equipment once the
# state ends. This can for example be used to make shapeshifter characters
# who get a special weapon when they are transformed.
# 
#==============================================================================
# ◆ Instructions
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# To install this script, open the script editor and paste this script into an
# empty slot below Materials and above Main.
# 
# Simply fill out the configuration below and you're good to go.
#
# PLEASE NOTE: This script will not work properly with characters that can
# dual wield. If you want to have dual wielding fixed for this script, feel 
# free to contact me and I will see what I can do.
#
#==============================================================================
# ◆ Compatibility
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script adds several methods from Game_BattlerBase into the Game_Actor
# class. If any of your scripts also does this, things will most likely go
# haywire. Contact me if you need a compatibility fix.
#
# The following methods are affected by this:
# -> add_state
# -> remove_state
# -> equip_type_fixed?
# -> equippable?
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
  module StateAutoEquip
    
    # The state that triggers the equipment change.
    STATE_ID = 2
    
    # The settings below let you change what equipment will be changed.
    # Setting it to -1 will make the script ignore that equipment type.
    # Setting it to 0 means it will unequip that equipment type.
    # Otherwise, it will equip the weapon/armor with that ID.
    WEAPON_ID     = -1
    SHIELD_ID     = -1
    HELMET_ID     = -1
    ARMOR_ID      = -1
    ACCESSORY_ID  = -1
    
  end
end

#==============================================================================
# >> WARNING << - Editing anything past this point may result in the script 
# crashing your game or doing unexpected things. Don't edit it unless you know
# what you're doing and/or you're going to take responsibility for your mess.
#==============================================================================


#==============================================================================
# Game_Actor
#==============================================================================
class Game_Actor < Game_Battler 
  
  #--------------------------------------------------------------------------
  # overridden method: add_state
  #--------------------------------------------------------------------------
  def add_state(state_id)
    super(state_id)
    if state?(state_id) 
      if state_id == Karanum::StateAutoEquip::STATE_ID and @sae_real_equips.nil?
        @sae_real_equips = [-1, -1, -1, -1, -1]
        for i in 0..4
          item = sae_get_item_for_slot(i)
          next unless item
          @sae_real_equips[i] = @equips[i].object ? @equips[i].object : nil
          @equips[i].object = item
        end
        refresh
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # overridden method: remove_state
  #--------------------------------------------------------------------------
  def remove_state(state_id)
    super(state_id)
    if state_id == Karanum::StateAutoEquip::STATE_ID and @sae_real_equips
      for i in 0..4
        next if @sae_real_equips[i] == -1
        @equips[i].object = @sae_real_equips[i]
      end
      @sae_real_equips = nil
      refresh
    end
  end
  
  #--------------------------------------------------------------------------
  # overridden method: equip_type_fixed?
  #--------------------------------------------------------------------------
  def equip_type_fixed?(etype_id)
    if @sae_real_equips
      for i in 0..4
        next unless equip_slots[i] == etype_id
        return true unless @sae_real_equips[i] == -1
      end
    end
    super(etype_id)
  end
  
  #--------------------------------------------------------------------------
  # overridden method: equippable?
  #--------------------------------------------------------------------------
  def equippable?(item)
    return false unless item.is_a?(RPG::EquipItem)
    return true if equip_type_fixed?(item.etype_id)
    super(item)
  end
  
  #--------------------------------------------------------------------------
  # new method: sae_get_item_for_slot
  #--------------------------------------------------------------------------
  def sae_get_item_for_slot(slot_id)
    case equip_slots[slot_id]
    when 0
      return nil if Karanum::StateAutoEquip::WEAPON_ID == -1
      return $data_weapons[Karanum::StateAutoEquip::WEAPON_ID]
    when 1
      return nil if Karanum::StateAutoEquip::SHIELD_ID == -1
      return $data_armors[Karanum::StateAutoEquip::SHIELD_ID]
    when 2
      return nil if Karanum::StateAutoEquip::SHIELD_ID == -1
      return $data_armors[Karanum::StateAutoEquip::HELMET_ID]
    when 3
      return nil if Karanum::StateAutoEquip::ARMOR_ID == -1
      return $data_armors[Karanum::StateAutoEquip::ARMOR_ID]
    when 4
      return nil if Karanum::StateAutoEquip::ACCESSORY_ID == -1
      return $data_armors[Karanum::StateAutoEquip::ACCESSORY_ID]
    end
  end
end

#==============================================================================
# ◆ End of Script
#==============================================================================