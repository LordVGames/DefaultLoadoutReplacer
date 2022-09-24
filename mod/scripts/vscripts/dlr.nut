global function dlr_init

void function dlr_init() {
  AddCallback_LocalClientPlayerSpawned(OnPlayerSpawned)
}

void function OnPlayerSpawned(entity player) {
  thread CheckdefaultLoadouts(player)
}

void function CheckdefaultLoadouts(entity player)
{
  string curProperty

  //#region Pilot loadouts
  array<string>dlr_cvar_pilot
  array<string>dlr_cvar_weapons

  // Get how many default loadouts our player has by name, and add them to an array for later
  array<int> defaultLoadouts
  for (int i = 0; i < 10; i++)
  {
    string loadoutname = GetPersistentLoadoutValue(player, "pilot", i, "name")
    switch (loadoutname)
    {
      case "#DEFAULT_PILOT_1":
      case "#DEFAULT_PILOT_2":
      case "#DEFAULT_PILOT_3":
      case "#DEFAULT_PILOT_4":
      case "#DEFAULT_PILOT_5":
      case "#DEFAULT_PILOT_6":
      case "#DEFAULT_PILOT_7":
      case "#DEFAULT_PILOT_8":
      case "#DEFAULT_PILOT_9":
      case "#DEFAULT_PILOT_10":
      case "Custom Pilot 1":
      case "Custom Pilot 2":
      case "Custom Pilot 3":
      case "Custom Pilot 4":
      case "Custom Pilot 5":
      case "Custom Pilot 6":
      case "Custom Pilot 7":
      case "Custom Pilot 8":
      case "Custom Pilot 9":
      case "Custom Pilot 10":
        defaultLoadouts.append(i)
        //printt("LOADOUT ID " + i + " HAS BEEN ADDED TO THE LIST")
    }
  }

  int defaultLoadoutCount = defaultLoadouts.len()
  if (defaultLoadoutCount > 0)
  {
    string curLoadoutName
    for (int i = 0; i < defaultLoadoutCount; i++)
    {
      int curDefaultLoadoutID = defaultLoadouts[i]
      int curDefaultLoadoutNum = defaultLoadouts[i] + 1
      printt("Loadout " + curDefaultLoadoutNum + " was a default loadout!")

      // Get the new loadout's info from the corresponding cvars and split them into an array
      // Weapon and pilot stuff were made separate cvars because when combined, the cvar value was cut off
      dlr_cvar_pilot = split(GetConVarString("dlr_loadout_" + curDefaultLoadoutNum + "_pilot"), ",")
      dlr_cvar_weapons = split(GetConVarString("dlr_loadout_" + curDefaultLoadoutNum + "_weapons"), ",")
      curLoadoutName = dlr_cvar_pilot[0]

      // If the new loadout still has the default name
      if (curLoadoutName == ("Custom Pilot " + curDefaultLoadoutNum) || curLoadoutName == ("#DEFAULT_PILOT_" + curDefaultLoadoutNum))
      {
        printt("No action will be taken due to \"dlr_loadout_" + curDefaultLoadoutNum + "_pilot\" still being the default value.")
        continue
      }

      // Pilot-centric stuff first
      for (int j = 0; j < dlr_cvar_pilot.len(); j++)
      {
        //printt("DLR_CVAR_PILOT[" + j + "] IS " + dlr_cvar_pilot[j])

        switch (j)
        {
          case 0:
            curProperty = "name"
            break
          case 1:
            curProperty = "suit"
            break
          case 2:
            curProperty = "race"
            break
          case 3:
            curProperty = "execution"
            break
          case 4:
            curProperty = "passive1"
            break
          case 5:
            curProperty = "passive2"
            break
          case 6:
            curProperty = "camoIndex"
            break
        }

        if (dlr_cvar_pilot[j] != "" && dlr_cvar_pilot[j] != " ")
        {
          //printt("SETTING VALUE \"" + curProperty + "\" TO \"" + dlr_cvar_pilot[j] + "\"")

          player.ClientCommand("SetPersistentLoadoutValue pilot " + curDefaultLoadoutID + " " + curProperty + " " + dlr_cvar_pilot[j])
          // Skins only work properly when setting the skinIndex to 1 AFTER the camo index for some reason
          if (j == 6) player.ClientCommand("SetPersistentLoadoutValue pilot " + curDefaultLoadoutID + " skinIndex 1")
        }
        //else printt("VALUE \"" + dlr_cvar_pilot[j] + "\" WAS READ AS BLANK AND WILL NOT BE CHANGED FROM DEFAULT!")
      }



      // Then weapons
      for (int j = 0; j < dlr_cvar_weapons.len(); j++)
      {
        //printt("DLR_CVAR_WEAPONS[" + j + "] IS " + dlr_cvar_weapons[j])

        switch (j)
        {
          //case 0 is for swapping pistol (normally in slot 3) with anti-titan (normally in slot 2)
          case 1:
            curProperty = "primary"
            break
          case 2:
            curProperty = "primaryAttachment"
            break
          case 3:
            curProperty = "primaryMod1"
            break
          case 4:
            curProperty = "primaryMod2"
            break
          case 5:
            curProperty = "primaryMod3"
            break
          case 6:
            curProperty = "secondary"
            break
          case 7:
            curProperty = "secondaryMod1"
            break
          case 8:
            curProperty = "secondaryMod2"
            break
          case 9:
            curProperty = "secondaryMod3"
            break
          case 10:
            curProperty = "weapon3"
            break
          case 11:
            curProperty = "weapon3Mod1"
            break
          case 12:
            curProperty = "weapon3Mod2"
            break
          case 13:
            curProperty = "weapon3Mod3"
            break
          case 14:
            curProperty = "ordnance"
            break
          case 15:
            curProperty = "primaryCamoIndex"
            break
          case 16:
            curProperty = "secondaryCamoIndex"
            break
          case 17:
            curProperty = "weapon3CamoIndex"
            break
        }

        if (dlr_cvar_weapons[j] != "" && dlr_cvar_weapons[j] != " ")
        {
          if (j == 0 && dlr_cvar_weapons[j].tointeger() >= 1)
          {
            //print("SWAPPING SECONDARY AND WEAPON3")
            player.ClientCommand("SwapSecondaryAndWeapon3PersistentLoadoutData " + curDefaultLoadoutID)
          }
          else
          {
            //printt("SETTING VALUE \"" + curProperty + "\" TO \"" + dlr_cvar_weapons[j] + "\"")

            player.ClientCommand("SetPersistentLoadoutValue pilot " + curDefaultLoadoutID + " " + curProperty + " " + dlr_cvar_weapons[j])
            // skinIndex needs to be set AFTER camo index
            switch (j)
            {
              case 15:
                player.ClientCommand("SetPersistentLoadoutValue pilot " + curDefaultLoadoutID + " primarySkinIndex 1")
                break
              case 16:
                player.ClientCommand("SetPersistentLoadoutValue pilot " + curDefaultLoadoutID + " secondarySkinIndex 1")
                break
              case 17:
                player.ClientCommand("SetPersistentLoadoutValue pilot " + curDefaultLoadoutID + " weapon3SkinIndex 1")
                break
            }
          }
        }
      }


      printt("Default loadout " + curDefaultLoadoutNum + " should be changed. Change loadouts/re-spawn for it to take effect.\nNOTE: The loadout UI will not update until map change.")
      if ((defaultLoadoutCount - 1) != i)
        printt("Changing default loadout " + (curDefaultLoadoutNum + 1) + " in 2.5 seconds...")
      else print("Checking titan loadouts in 2.5 seconds...")
      wait 2.5 // Should keep us from getting disconnected for too many commands
    }
  }
  //#endregion

  //#region Titan Loadouts
  string curTitanClass
  string curTitanClass_proper
  array<string> dlr_cvar_titan
  array<string> dlr_cvar_monarch_upgrades
  bool isMonarch
  for (int i = 0; i < 7; i++)
  {
    isMonarch = (i == 6)

    // Check titan properties, and skip the loadout if one of the values aren't the default (it means the player has changed them, so we shouldn't mess with it)
    if (
      // Properties for all titans
      GetPersistentLoadoutValue(player, "titan", i, "passive1") != "pas_enhanced_titan_ai" ||
      GetPersistentLoadoutValue(player, "titan", i, "passive3") != "pas_bubbleshield" ||
      GetPersistentLoadoutValue(player, "titan", i, "skinIndex") != "0" ||
      GetPersistentLoadoutValue(player, "titan", i, "primarySkinIndex") != "0" ||
      GetPersistentLoadoutValue(player, "titan", i, "primeSkinIndex") != "0" ||
      GetPersistentLoadoutValue(player, "titan", i, "showArmBadge") != "0" ||
      GetPersistentLoadoutValue(player, "titan", i, "isPrime") != "titan_is_not_prime" ||
      // Monarch upgrades coverage
      (isMonarch && GetPersistentLoadoutValue(player, "titan", i, "passive4") != "pas_vanguard_core1") ||
      (isMonarch && GetPersistentLoadoutValue(player, "titan", i, "passive5") != "pas_vanguard_core4") ||
      (isMonarch && GetPersistentLoadoutValue(player, "titan", i, "passive6") != "pas_vanguard_core7")
    ) continue

    switch (i)
    {
      case 0:
        curTitanClass = "ion"
        break
      case 1:
        curTitanClass = "scorch"
        break
      case 2:
        curTitanClass = "northstar"
        break
      case 3:
        curTitanClass = "ronin"
        break
      case 4:
        curTitanClass = "tone"
        break
      case 5:
        curTitanClass = "legion"
        break
      case 6:
        curTitanClass = "monarch"
        break
    }
    curTitanClass_proper = UppercaseFirstLetterInString(curTitanClass)
    printt("Titan loadout for \"" + curTitanClass_proper + "\" is the default!")

    dlr_cvar_titan = split(GetConVarString("dlr_loadout_" + curTitanClass), ",")
    if (isMonarch) dlr_cvar_monarch_upgrades = split(GetConVarString("dlr_loadout_monarch_upgrades"), ",")

    // If the skin values in the cvar aren't 0
    if (
      dlr_cvar_titan[4] != "0" ||
      dlr_cvar_titan[5] != "0" ||
      dlr_cvar_titan[6] != "0" ||
      dlr_cvar_titan[7] != "0" ||
      dlr_cvar_titan[8] != "0"
    )
    {
      for (int j = 0; j < dlr_cvar_titan.len(); j++)
      {
        //printt("DLR_CVAR_TITAN[" + j + "] IS " + dlr_cvar_titan[j])
        switch (j)
        {
          case 0:
            curProperty = "passive1"
            break
          case 1:
            curProperty = "passive2"
            break
          case 2:
            curProperty = "passive3"
            break
          case 3:
            curProperty = "titanExecution"
            break
          case 4:
            curProperty = "camoIndex"
            break
          case 5:
            curProperty = "skinIndex"
            break
          case 6:
            curProperty = "decalIndex"
            break
          case 7:
            curProperty = "primaryCamoIndex"
            break
          case 8:
            curProperty = "isPrime"
            break
          case 9:
            curProperty = "primeCamoIndex"
            break
          case 10:
            curProperty = "primeSkinIndex"
            break
          case 11:
            curProperty = "primeDecalIndex"
            break
          case 12:
            curProperty = "showArmBadge"
            break
        }

        // Monarch doesn't have prime titan properties, so we skip checking/setting those values
        if (isMonarch && (j > 7 && j < 12)) continue
        if (GetPersistentLoadoutValue(player, "titan", i, curProperty) != dlr_cvar_titan[j])
        {
          //printt("SETTING \"" + curProperty + "\" TO \"" + dlr_cvar_titan[j] + "\"")

          player.ClientCommand("SetPersistentLoadoutValue titan " + i + " " + curProperty + " " + dlr_cvar_titan[j])
          // primarySkinIndex is always 1 if primaryCamoIndex isn't 0
          if (j == 7 && dlr_cvar_titan[j] != "0") player.ClientCommand("SetPersistentLoadoutValue titan " + i + " primarySkinIndex 1")
        }
        //else printt("PROPERTY " + curProperty + "IS THE SAME AS IN THE CVAR, SKIPPING")
      }

      // Monarch upgrades
      if (isMonarch)
      {
        for (int k = 0; k < dlr_cvar_monarch_upgrades.len(); k++)
        {
          switch (k)
          {
            case 0:
              curProperty = "passive4"
              break
            case 1:
              curProperty = "passive5"
              break
            case 2:
              curProperty = "passive6"
              break
          }
          if (GetPersistentLoadoutValue(player, "titan", i, curProperty) != dlr_cvar_monarch_upgrades[k])
          {
            //printt("SETTING \"" + curProperty + "\" TO \"" + dlr_cvar_monarch_upgrades[k] + "\"")
            player.ClientCommand("SetPersistentLoadoutValue titan " + i + " " + curProperty + " " + dlr_cvar_monarch_upgrades[k])
          }
          //else printt("PROPERTY " + curProperty + " IS THE SAME AS IN THE CVAR, SKIPPING")
        }
      }

      if (i + 1 != 7) // If we haven't reached the last titan loadout yet
      {
        printt("The titan loadout for \"" + curTitanClass_proper + "\" should be changed. Waiting 2.5 seconds before checking the next loadout...")
        wait 2.5
      }
    }
    else printt("Titan loadout CVar for \"" + curTitanClass_proper + "\" is also the default, no action will be taken.")
  }
  //#endregion
}

// I can't uppercase a single letter of a string like in other languages so i gotta do this
string function UppercaseFirstLetterInString(string text)
{
  string text_letter = text.slice(0,1)
  string text_latter = text.slice(1)
  text_letter = text_letter.toupper()
  return text_letter + text_latter
}