IndividualProgression = {}

IndividualProgression.npcId = 50000
IndividualProgression.PlayerChangedTierKey = 1001
IndividualProgression.mainMenu = "|TInterface\\icons\\inv_helmet_74:45:45:-40|t|cff00008bSet Individual Progression |r"
IndividualProgression.options = {
  "|TInterface\\icons\\achievement_boss_ragnaros:45:45:-40|t|cff8b0000Tier 1 - Molten Core (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_onyxia:45:45:-40|t|cff8b0000Tier 2 - Onyxia (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_nefarion:45:45:-40|t|cff8b0000Tier 3 - Blackwing Lair (Level 60)|r",
  "|TInterface\\icons\\achievement_zone_silithus_01:45:45:-40|t|cff8b0000Tier 4 - Pre-AQ (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_cthun:45:45:-40|t|cff8b0000Tier 5 - Anh'qiraj (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_kelthuzad_01:45:45:-40|t|cff8b0000Tier 6 - Naxxramas (Level 60)|r",
  "|TInterface\\icons\\achievement_boss_princemalchezaar_02:45:45:-40|t|cff006400Tier 7 - Karazhan, Gruul's Lair, Magtheridon's Lair (Level 70)|r",
  "|TInterface\\icons\\achievement_character_bloodelf_male:45:45:-40|t|cff006400Tier 8 - Serpentshrine Cavern, Tempest Keep (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_illidan:45:45:-40|t|cff006400Tier 9 - Hyjal Summit and Black Temple (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_zuljin:45:45:-40|t|cff006400Tier 10 - Zul'Aman (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_kiljaedan:45:45:-40|t|cff006400Tier 11 - Sunwell Plateau (Level 70)|r",
  "|TInterface\\icons\\achievement_boss_kelthuzad_01:45:45:-40|t|cff00008bTier 12 - Naxxramas WotLK, Eye of Eternity, Obsidian Sanctum (Level 80)|r",
  "|TInterface\\icons\\achievement_boss_algalon_01:45:45:-40|t|cff00008bTier 13 - Ulduar (Level 80)|r",
  "|TInterface\\icons\\achievement_reputation_argentcrusader:45:45:-40|t|cff00008bTier 14 - Trial of the Crusader|r",
  "|TInterface\\icons\\achievement_boss_lichking:45:45:-40|t|cff00008bTier 15 - Icecrown Citadel (Level 80)|r",
  "|TInterface\\icons\\spell_shadow_twilight:45:45:-40|t|cff00008bTier 16 - Ruby Sanctum (Level 80)"
}

IndividualProgression.optionsWithoutIcon = {
  "Tier 1 - Molten Core (Level 60)",
  "Tier 2 - Onyxia (Level 60)",
  "Tier 3 - Blackwing Lair (Level 60)",
  "Tier 4 - Pre-AQ (Level 60)",
  "Tier 5 - Anh'qiraj (Level 60)",
  "Tier 6 - Naxxramas (Level 60)",
  "Tier 7 - Karazhan, Gruul's Lair, Magtheridon's Lair (Level 70)",
  "Tier 8 - Serpentshrine Cavern, Tempest Keep (Level 70)",
  "Tier 9 - Hyjal Summit and Black Temple (Level 70)",
  "Tier 10 - Zul'Aman (Level 70)",
  "Tier 11 - Sunwell Plateau (Level 70)",
  "Tier 12 - Naxxramas WotLK, Eye of Eternity, Obsidian Sanctum (Level 80)",
  "Tier 13 - Ulduar (Level 80)",
  "Tier 14 - Trial of the Crusader",
  "Tier 15 - Icecrown Citadel (Level 80)",
  "Tier 16 - Ruby Sanctum (Level 80)"
}

function IndividualProgression.getTextWithoutIcon(option)
  local textStart = option:find("|r") + 2
  return option:sub(textStart)
end

function IndividualProgression.OnGossipHello(event, player, object)
  player:GossipMenuAddItem(0, IndividualProgression.mainMenu, 0, 1)
  player:GossipMenuAddItem(0, "|TInterface\\icons\\inv_scroll_03:45:45:-40|t |cff00008bWhat is Individual Progression?|r", 0, 200)
  player:GossipSendMenu(1, object)
  object:SetEquipmentSlots(32262, 33755, 0)
  object:SendUnitSay("Speaking with me will allow you to artificially set what stage of the game you'd like to be in, thereby bypassing any normal progression.", 0)

  local guid = player:GetGUIDLow()

  local query = CharDBQuery("SELECT data FROM character_settings WHERE guid = " .. guid .. " AND source = 'mod-individual-progression'")
  CharDBExecute("UPDATE character_settings SET data = TRIM(data) WHERE source = 'mod-individual-progression'")
  if query then
    local playerProgressionTier = tonumber(query:GetString(0)) -- Update this line
    local playerProgressionInfo = IndividualProgression.options[playerProgressionTier + 1]

    object:SendUnitWhisper("Your current progression level is: " .. IndividualProgression.optionsWithoutIcon[playerProgressionTier + 1], 0, player)
  else
    CharDBExecute("INSERT INTO character_settings (guid, source, data) VALUES (" .. guid .. ", 'mod-individual-progression', '0')") -- Update this line
    object:SendUnitWhisper("You have not set any individual progression. Contact a GM for help.", 0, player)
  end
end

function IndividualProgression.ShowIndividualProgressionExplanation(player, object)
  player:GossipMenuAddItem(0, "Individual Progression is meant to simulate 'progress through expansions and expansion tiers' for individual players. Players must complete each tier in order to access content for the next tier. \n\nEach tier is designed to simulate experience of being within that tier and expansion, within reason of the WotLK client. This means Vanilla content is like Vanilla WoW, TBC is like TBC, and so on. \n\nThe goal of this feature is to focus on journey of the player. All catch-up mechanisms have been removed. \n\nThere is no need for 'fresh' servers because each new character is a fresh server. Note that this feature either requires many players working together on a server for each tier, or adjustments for smaller raid sizes to allow individual groups to progress (or more bots). Please see the auto-balance module and NPC Bot Settings in world.conf for some adjustments that improve this process on a less populated servers.", 0, 201)
  player:GossipMenuAddItem(0, "|TInterface\\icons\\achievement_guildperk_massresurrection:45:45:-40|t Back", 0, 100)
  player:GossipSendMenu(1, object)
end

IndividualProgression.PlayerTierKey = 1000 

function IndividualProgression.OnGossipSelect(event, player, object, sender, intid, code)
  if intid == 1 then
    for i, option in ipairs(IndividualProgression.options) do
      player:GossipMenuAddItem(0, option, 0, i + 1)
    end
    player:GossipMenuAddItem(0, "|TInterface\\icons\\achievement_guildperk_massresurrection:45:45:-40|t Back", 0, 100)
    player:GossipSendMenu(1, object)
  elseif intid == 100 then
    player:GossipMenuAddItem(0, IndividualProgression.mainMenu, 0, 1)
    player:GossipMenuAddItem(0, "|TInterface\\icons\\inv_scroll_03:45:45:-40|t What's Individual Progression?", 0, 200) 
    player:GossipSendMenu(1, object)
  elseif intid == 200 then
    IndividualProgression.ShowIndividualProgressionExplanation(player, object) 
  else
    local tier = intid - 2
    if tier >= 0 then
      player:SetUInt32Value(IndividualProgression.PlayerTierKey, tier)
      player:SetUInt32Value(IndividualProgression.PlayerChangedTierKey, 1) -- Set the flag to indicate that the player has changed their progression
      player:GossipComplete()
      player:SendBroadcastMessage("Your individual progression will be set to " .. IndividualProgression.optionsWithoutIcon[intid - 1] .. " upon logout.")
    end
  end
end

function IndividualProgression.DelayedDatabaseUpdate(eventId, delay, repeats, playerData)
    print("Debug: DelayedDatabaseUpdate triggered")  

    if playerData.tier >= 0 and playerData.tierChanged == 1 then
        local deleteSQL = "DELETE FROM character_settings WHERE guid = " .. playerData.guid .. " AND source = 'mod-individual-progression'"
        print("Debug: DELETE SQL Query: " .. deleteSQL)  
        CharDBExecute(deleteSQL)
        local dataString = string.format("%u", playerData.tier)
        local insertSQL = "INSERT INTO character_settings (guid, source, data) VALUES (" .. playerData.guid .. ", 'mod-individual-progression', '" .. dataString .. "')"
        print("Debug: INSERT SQL Query: " .. insertSQL)  
        CharDBExecute(insertSQL)
    end
end

function IndividualProgression.Individual_OnPlayerLogout(event, player)
    print("Debug: Individual_OnPlayerLogout triggered") 
    local tier = player:GetUInt32Value(IndividualProgression.PlayerTierKey)
    local tierChanged = player:GetUInt32Value(IndividualProgression.PlayerChangedTierKey)
    local guid = player:GetGUIDLow()
    local playerData = {
        tier = tier,
        tierChanged = tierChanged,
        guid = guid
    }
    CreateLuaEvent(function(eventId, delay, repeats) IndividualProgression.DelayedDatabaseUpdate(eventId, delay, repeats, playerData) end, 1000, 1)
end

RegisterCreatureGossipEvent(IndividualProgression.npcId, 1, IndividualProgression.OnGossipHello)
RegisterCreatureGossipEvent(IndividualProgression.npcId, 2, IndividualProgression.OnGossipSelect)
RegisterPlayerEvent(4, IndividualProgression.Individual_OnPlayerLogout)
