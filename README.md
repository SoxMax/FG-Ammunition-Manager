[![Build FG-Usable File](https://github.com/SoxMax/FG-Ammunition-Manager/actions/workflows/create-ext.yml/badge.svg)](https://github.com/SoxMax/FG-Ammunition-Manager/actions/workflows/create-ext.yml) [![Luacheck](https://github.com/SoxMax/FG-Ammunition-Manager/actions/workflows/luacheck.yml/badge.svg)](https://github.com/SoxMax/FG-Ammunition-Manager/actions/workflows/luacheck.yml)

# Ammunition Manager for Starfinder
This extension aids in tracking whether some ranged weapons are loaded and assists in ammo tracking for all ranged weapons.

# Compatibility and Instructions
This extension has been tested with [FantasyGrounds Unity](https://www.fantasygrounds.com/home/FantasyGroundsUnity.php) v4.3.6 (2023-03-16) and the SFRPG ruleset.

# Features
* [REMOVE FOR STARFINDER?] Adds a checkbox to the left of the ammo label on the weapons section of the actions tab; this checkbox is only shown for some weapons. Loading these weapon will post a message to chat to help monitor the action-economy. Attacks attempted with these weapons without loading first will post a message to chat and the attack will not go through. If you want to disable this on a per-weapon basis, add the weapon property 'noload.'

* [REWRITE FOR STARFINDER] Opening the weapon details page from the actions tab will allow swapping between ammo types. When an ammo type is selected here it will hide the normal ammo tracker and use the inventory count directly.

* Attacking will mark-off ammunition automatically based on weapon usage. Messages will post to chat if there is no ammunition available or if the final ammunition is used.

* [DESCRIBE READLOADING]

* An "INFAMMO" effect negates the counting of ammunition usage.

* [REMOVE FOR STARFINDER?] Enabling the "Chat: Show weapon name in results" option will add the weapon name to attack results in chat such as "Attack [16] -> [at Goblin] with Shortsword [HIT]" instead of "Attack [16] -> [at Goblin] [HIT]".

* NOTE: Some modules contain entries like "Arrows (20)". If you have quantity 1 of "Arrows (20)" and select this as your weapon, it will reduce you to quantity 0 of "Arrows (20)". You should instead (in this example) change it to quantity 20 of "Arrow" and divide the weight by 20 as well. I'm not sure why the module authors often ignore this detail, but this is currently how to work around it.

# Video Demonstration - Starfinder (click for video)
[<img src="https://i.ytimg.com/vi_webp/b-zeWXdpPXM/hqdefault.webp">](https://www.youtube.com/watch?v=b-zeWXdpPXM)
