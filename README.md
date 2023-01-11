# Disclaimer
This is an **unofficial SA-MP Clientside Anticheat (SAMPCAC) documentation** repository. All rights belong to the author **0xCAC** and are provided here for informational purposes only. The official https://SAMPCAC.xyz/docs site has been unavailable for a long time and this repository was created to help you with development. **There is no source code here, only binaries and documentation!** 

## About
### SA-MP Clientside AntiCheat 
Brand new clientside anticheat for SA-MP, designed to detect and report cheaters to the server they are connected to. SAMPCAC is aiming to be a replacement for old heavy, unstable anticheat softwares.

![](https://github.com/ins1x/sampcac-docs/blob/main/scriptfiles/img/server-console.png)  

### Features
**NO CRASHES Crashes are annoying, aren't they?**  
That's why our software is carefully tested before it gets released, so our users won't (or shouldn't) experience any issues.   

**LIGHTWEIGHT AND FAST**  
We know how important is that 90+ FPS in top corner for you, so SAMPCAC developers are constantly trying their best to keep that number unchanged.  

**COMMUNITY-DRIVEN**  
SAMPCAC is a mod by players for ehm... players AND servers. We listen to all our users' suggestions and we are open to discussions.  

**MODULAR ANTICHEAT**  
SAMPCAC is pretty much fully toggleable from serverside. See sampcac.inc for a list of detected cheats. 

![](https://github.com/ins1x/sampcac-docs/blob/main/scriptfiles/img/sampcac_test.jpg)  

* You don't want your players use macros? Enable macro reporting!
* You don't want your players abuse C-Bug or see radar blips? Disable them!
* You don't want your players use m0d_s0beit_sa? Well, this mod is disabled by default and can't be enabled :(
* Not enough protections? Detect many more specific cheats using CAC_ReadMemory.
* Require all players have SAMPCAC installed? Load sampcac_only.amx.
* Configure cheat detection? (MUST BE LOADED) Load sampcac_base.amx and edit sampcac_base.ini.
* Disable certain glitches? (eg: C-Bug) Load sampcac_glitch.amx and edit sampcac_glitch.ini.
* Toggle game options? (eg: inf. sprint or manual gun reloading) Load and configure sampcac_gameoption.amx.
* Monitor modded resources? (eg: skins or transparent textures) Load and configure sampcac_gameresource.amx.

> Note for server owners: SAMPCAC won't take any action against cheaters by itself, you have to explicitly script these actions. Fortunately, server package comes with 6 filterscripts ready to take care of it for yourself. See above. For further information, check out SAMPCAC documentation here!

# Welcome to SAMPCAC documentation
This repo contains all information needed to set up and run a SAMPCAC protected server.

### Setting up a basic server

1. Download the [latest SAMPCAC server package](https://github.com/ins1x/sampcac-docs/releases/tag/release);
2. Copy its full content in the root of SA-MP server, respecting the directory layout;
3. Open [server.cfg](https://www.open.mp/docs/server/server.cfg) and append to plugins line:
    - sampcac_server.so (for Linux servers);
    - sampcac_server.dll (for Windows servers);
4. Now, add the following filterscripts:
    - [sampcac_base](https://github.com/ins1x/sampcac-docs/blob/main/filterscripts/sampcac_base.pwn) (WARNING: SAMPCAC won't take any action against cheaters without this filterscripts loaded!);
    - [sampcac_glitch](https://github.com/ins1x/sampcac-docs/blob/main/filterscripts/sampcac_glitch.pwn) (allows you to disable certain GTA:SA glitches (like C-Bug));
    - [sampcac_gameoption](https://github.com/ins1x/sampcac-docs/blob/main/filterscripts/sampcac_gameoption.pwn) (allows you to toggle certain options (like vehicle blips on radar));
    - [sampcac_gameresource](https://github.com/ins1x/sampcac-docs/blob/main/filterscripts/sampcac_gameresource.pwn) (allows you to detect game modifications (like modified skins));
    - [sampcac_only](https://github.com/ins1x/sampcac-docs/blob/main/filterscripts/sampcac_only.pwn) (only clients with SAMPCAC installed can join your server);
    - [sampcac_versioncheck](https://github.com/ins1x/sampcac-docs/blob/main/filterscripts/sampcac_versioncheck.pwn) (warn players that they're using an outdated version of SAMPCAC client before kicking them);
(for more information regarding filterscripts, see filterscripts article);
5. Head to scriptfiles and edit sampcac_base.ini, sampcac_glitch.ini, sampcac_gameoption.ini and sampcac_gameresource.ini according to your needs;
6. Start the server!

### Further assistance
Check out [sample filterscripts](https://github.com/ins1x/sampcac-docs/tree/main/filterscripts) and [sampcac.inc](https://github.com/ins1x/sampcac-docs/blob/main/pawno/include/sampcac.inc) source code for more implementation details.  

# Filterscripts
### sampcac_base.pwn

This filterscript is responsible for handling cheat reports coming from SAMPCAC plugin.  

> IMPORTANT: MUST BE LOADED! unless you write your own cheat handler  
```
Configuration: scriptfiles/sampcac_base.ini
[aimbot_1]        # cheat name as defined in "sampcac_base.pwn"
status=on         # detection status: [on/off]
action=kick       # action to be taked on detection: [warning/kick/ban]

[screenshot]      # cheat name as defined in "sampcac_base.pwn"
status=on         # should players get punished for taking too many screenshots?
max_screenshots=1 # how many screenshots may a player take
reset_time=1000   # players can take screenshots again after this time (in ms) has passed 
action=warning    # action to be taked on screenshot spam: [warning/kick/ban]

[macro_key_detection] # enable/disable certain macro key detections (see sampcac_base.ini for more information) 
```
Edit without restart: All you have to do is edit scriptfiles/sampcac_base.ini and use /rcon reloadfs sampcac_base while logged in as RCON.  

### sampcac_glitch.pwn
![](https://github.com/ins1x/sampcac-docs/blob/main/scriptfiles/img/toggle-glitch.png)  
This filterscript is responsible for disabling certain GTA:SA glitches.  

Configuration: scriptfiles/sampcac_glitch.ini
```
NOTE: Default configuration disables C-Bug, Fast Sprint and Fast Fire.
NOTE: For further documentation, see GTA:SA glitch natives.

[glitch]          # this is the default configuration
quick_reload=on   # I guess it's pretty straight-forward and doesn't need any explanation
fast_fire=off
fast_move=on
c_bug=off
fast_sprint=off
quick_stand=on
```
Edit without restart: All you have to do is edit scriptfiles/sampcac_glitch.ini and use /rcon reloadfs sampcac_glitch while logged in as RCON.  

### sampcac_gameoption.pwn
This filterscript is responsible for toggling certain game options.  

Configuration: scriptfiles/sampcac_gameoption.ini
```
NOTE: See sampcac.inc for a full list of toggleable game options.
NOTE: For further documentation, see game option natives.

[gameoption]         # this is the default configuration
vehicle_blips=on     # I guess it's pretty straight-forward and doesn't need any explanation 
manual_reloading=on
drive_on_water=off
fireproof=on
sprint=all_surfaces
infinite_sprint=on
infinite_oxygen=on
infinite_ammo=off
night_vision=off
thermal_vision=off
```
Edit without restart: All you have to do is edit scriptfiles/sampcac_gameoption.ini and use /rcon reloadfs sampcac_gameoption while logged in as RCON.  

### sampcac_gameresource.pwn
This filterscript is responsible for detecting game modifications.  

Configuration: scriptfiles/sampcac_gameresource.ini
```
NOTE: Currently, only peds, vehicles, weapons, object models and ped.ifp modifications are detectable.
NOTE: For further documentation, see game resource checks natives.

[gamemodels]
# disabled       = no reports regarding modded game models
# only_if_modded = will notify the server only once if player got modded game models (good for saving bandwidth)
# full           = detailed report about the mod: model id, component (dff, txd, anim or ped.ifp) and modded file checksum (not recommended when players have a lot of mods)
type=full

# possible values: warning kick ban
action=warning

# adjust following options in order to enable/disable specific game models reports
skins=on
vehicles=off
weapons=off
# "others" means everything else that is not stated above (eg: buildings, fences, streets etc)
others=on
ped_ifp=on
```
Edit without restart: All you have to do is edit scriptfiles/sampcac_gameresource.ini and use /rcon reloadfs sampcac_gameresource while logged in as RCON.

### sampcac_only.pwn
![](https://github.com/ins1x/sampcac-docs/blob/main/scriptfiles/img/sampcac-only.png)  
Only clients with SAMPCAC installed can join your server.  

> Configuration: no configuration needed  

Disable without restart: Use /rcon unloadfs sampcac_only while logged in as RCON.

### sampcac_versioncheck.pwn
Warn players that they're using an outdated version of SAMPCAC client before kicking them.  

> Configuration: no configuration needed  

Disable without restart: Use /rcon unloadfs sampcac_versioncheck while logged in as RCON.

## Extra
SA-MP Clientside Anticheat cannot run under a Virtual Machine. [How to Disable Hyper-V](https://www.eightforums.com/tutorials/42041-hyper-v-enable-disable-windows-8-a.html)  

Working examples of using the memory read function.
Filterscript: [sampcac_memread_example](https://github.com/ins1x/sampcac-docs/blob/main/filterscripts/sampcac_memread_example.pwn)  

---

### This is an unofficial SA-MP Clientside Anticheat (SAMPCAC) documentation repository.