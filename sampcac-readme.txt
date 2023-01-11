/*
 * SA-MP Clientside Anticheat (SAMPCAC)
 * Version:         v0.10.0
 * Author:          0xCAC
 * Compatible with: SA-MP 0.3.7 Server
 * Site:            https://SAMPCAC.xyz
 * Documentation:   https://SAMPCAC.xyz/docs
 */


Original gamemode: 
    Att-Def v1.21: https://github.com/beijind/SAMPAttackDefend

Adapted to SAMPCAC


== v0.10.0 ==

**Added new detections for:**
* no-recoil (#3)
* aimbot (#5 and #6)
* various actions that will mark the client as `untrusted`. **Note**: a clean SA-MP installation would NEVER get marked as `untrusted`, so it is safe to assume that such a client is malicious.

**Other changes:**
* `CAC__MAX_HARDWARE_ID` was increased to 64
* in case `CAC_ReadMemory` fails clientside (eg: non-readable memory), `CAC_OnMemoryRead` will get called with parameter `size = 0`
* plugin will print a warning message if the version of `sampcac.inc` doesn't match plugin version
* fixed a bug that lead to incorrect cheat detections
* fixed a crash that would occur due to excessive keybinder usage
* minor improvements to sample scripts

**For server owners:**
* if you wrote your own detection scripts, recompile them with the new `sampcac.inc` and make sure that new `cheat ids` are properly handled
* if you use the default filterscripts, replace them and their configuration files with the ones provided in the server package
* if you use Att-Def server from SAMPCAC.xyz, redownload the entire package