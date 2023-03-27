-- by Dinkledork
-- Run the Following SQL Query:
-- DELETE FROM `creature_template` WHERE `entry`=50000;
-- INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES (50000, 0, 0, 0, 0, 0, 28195, 0,-- remove the "--"
-- .npc add 50000 somewhere in game

RegisterPlayerEvent(3, OnPlayerLogin)


local npcId = 50000
local mainMenu = "Set Individual Progression"
local options = {
  "|TInterface\\icons\\achievement_boss_ragnaros:40|t |cff8b0000Tier 1 - Molten Core (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_onyxia:40|t |cff8b0000Tier 2 - Onyxia (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_nefarion:40|t |cff8b0000Tier 3 - Blackwing Lair (Level 60)|r",
  "|TInterface\\icons\\achievement_zone_silithus_01:40|t |cff8b0000Tier 4 - Pre-AQ (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_cthun:40|t |cff8b0000Tier 5 - Anh'qiraj (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_kelthuzad_01:40|t |cff8b0000Tier 6 - Naxxramas (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_princemalchezaar_02:40|t |cff006400Tier 7 - Karazhan, Gruul's Lair, Magtheridon's Lair (Level 70)|r",
  "|TInterface\\icons\\achievement_character_bloodelf_male:40|t |cff006400Tier 8 - Serpentshrine Cavern, Tempest Keep (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_illidan:40|t |cff006400Tier 9 - Hyjal Summit and Black Temple (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_zuljin:40|t |cff006400Tier 10 - Zul'Aman (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_kiljaedan:40|t |cff006400Tier 11 - Sunwell Plateau (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_kelthuzad_01:40|t |cff00008bTier 12 - Naxxramas WotLK, Eye of Eternity, Obsidian Sanctum (Level 80)|r",
  "|TInterface\\icons\\achievement_boss_algalon_01:40|t |cff00008bTier 13 - Ulduar (Level 80)|r",
  "|TInterface\\icons\\achievement_reputation_argentcrusader:40|t |cff00008bTier 14 - Trial of the Crusader|r",
  "|TInterface\\icons\\achievement_boss_lichking:40|t |cff00008bTier 15 - Icecrown Citadel (Level 80)|r",
  "|TInterface\\icons\\spell_shadow_twilight:40|t |cff00008bTier 16 - Ruby Sanctum (Level 80)"
}

function OnGossipHello(event, player, object)
  player:GossipMenuAddItem(0, mainMenu, 0, 1)
  player:GossipSendMenu(1, object)
  object:SetEquipmentSlots(32262, 33755, 0)
end

local PlayerTierKey = 1000 

function OnGossipSelect(event, player, object, sender, intid, code)
  if intid == 1 then
    for i, option in ipairs(options) do
      player:GossipMenuAddItem(0, option, 0, i + 1)
    end
    player:GossipSendMenu(1, object)
  else
    local tier = intid - 2
    if tier >= 0 then
      player:SetUInt32Value(PlayerTierKey, tier)
      player:GossipComplete()
      player:SendBroadcastMessage("Your individual progression will be set to " .. options[intid - 1] .. " upon logout.")
    end
  end
end

RegisterCreatureGossipEvent(npcId, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcId, 2, OnGossipSelect)

function OnPlayerLogout(event, player)
  local tier = player:GetUInt32Value(PlayerTierKey)
  if tier >= 0 then
    local guid = player:GetGUIDLow()
    CharDBExecute("UPDATE character_settings SET data = " .. tier .. " WHERE guid = " .. guid)
    player:SetUInt32Value(PlayerTierKey, 0) -- Reset the value to 0
  end
end

RegisterPlayerEvent(4, OnPlayerLogout)

function OnCreatureSpawn(event, creature)
  creature:SetEquipmentSlots(32262, 33755, 0)
end


RegisterCreatureEvent(npcId, 5, OnCreatureSpawn)

