# Default Loadout Replacer
A mod meant to replace the default pilot/titan loadouts used when joining/creating a server without masterserver auth.

## Usage
Loadouts are replaced by providing the values for loadout properties via ConVars. You can get these loadout properties by re-selecting them in-game and reading the game console to find out what that property is and what it changed to.

### Pilot loadouts
There are 2 ConVars for each pilot loadout, one for properties for the pilot theirself, and another for the pilot's weapons.

#### Examples
```
dlr_loadout_10_pilot "Custom Pilot 10,geist,race_human_male,execution_neck_snap,pas_fast_health_regen,pas_wallhang,0,0"
dlr_loadout_10_weapons "0,mp_weapon_smr, , , , ,mp_weapon_autopistol, , , ,mp_weapon_defender, , , ,mp_weapon_grenade_emp,0,0,0"
```

#### ConVar Values
The properties for the `_pilot` ConVars are layed out as follows:

`name, race, execution, passive1, passive2, passive3, camoIndex`

This ConVar can't have spaces for the properties.

The properties for the `_weapons` ConVars are layed out as follows:

`primary, primaryAttachment, primaryMod1, primaryMod2, primaryMod3, secondary, secondaryMod1, secondaryMod2, secondaryMod3, weapon3, weapon3Mod1, weapon3Mod2, weapon3Mod3, ordnance, primaryCamoIndex, secondaryCamoIndex, weapon3CamoIndex`

Note that the weapon mod properties can be just a space if not desired for a weapon.

#### Boosts
Boosts are not covered by this mod, since there is no good way to tell if the boost a loadout has is the default/changed from the default, as far as I know.

### Titan loadouts
The loadouts of each titan are also covered by this mod. The titan loadout properties are all in 1 ConVar.

#### Example
```
dlr_loadout_scorch "pas_enhanced_titan_ai,pas_scorch_weapon,pas_bubbleshield,execution_random_1,0,0,0,0,0,0,0,0,0,0"
```

#### ConVar Values
The properties for the titan loadouts are layed out as follows:

`passive1, passive2, passive3, titanExecution, camoIndex, skinIndex, decalIndex, primaryCamoIndex, isPrime, primeCamoIndex, primeSkinIndex, primeDecalIndex, showArmBadge`

This ConVar can't have spaces for the properties.

#### Monarch Upgrades
Monarch upgrades are in a separate ConVar, `dlr_loadout_monarch_upgrades`. For example:

`dlr_loadout_monarch_upgrades "pas_vanguard_core1,pas_vanguard_core4,pas_vanguard_core7"`

The properties are: `passive4, passive5, passive6`
