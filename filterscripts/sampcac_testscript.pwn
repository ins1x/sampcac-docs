/*
 * SA-MP Clientside Anticheat (SAMPCAC)
 * Version:         v0.10.0
 * Author:          0xCAC
 * Compatible with: SA-MP 0.3.7 Server
 * Site:            https://SAMPCAC.xyz
 * Documentation:   https://SAMPCAC.xyz/docs
 *
 *
 * Warning:         DON'T USE THIS FILTERSCRIPT ON A LIVE SERVER!
 *                  No admin checks are done.
 * Requires:        sscanf2 plugin
 */

#define FILTERSCRIPT

#include <a_samp>
#include <sampcac>
#include <zcmd>
#include <sscanf2>

#define DIALOG_GLITCHSTATUS     0xCAC
#define DIALOG_GAMEOPTIONSTATUS 0xCAC+1

new const g_szGlitchNames     [][] = {"Quick reload", "Fast fire", "Fast move", "C-Bug", "Fast sprint", "Quick stand"};
new const g_szGameOptionNames [][] = {"Vehicle blips", "Manual reloading", "Drive on water", "Fireproof", "Sprint", "Infinite sprint", "Infinite oxygen", "Infinite ammo", "Night vision", "Thermal vision"};
new const g_szCheatNames      [][] = {"Aimbot (1)", "Aimbot (2)", "Triggerbot (1)", "Triggerbot (2)", "Nametag wallhack (1)", "ESP (1)", "Macro keybind (1)", "Fake ping (1)", "Weapon info (1)", "No recoil (1)", "No recoil (2)", "Aimbot (3)", "Aimbot (4)", "CLEO", "Aimbot (5)", "Aimbot (6)", "No recoil (3)", "Untrusted (1)", "Untrusted (2)", "Untrusted (3)", "Untrusted (4)"};
new const g_szKickReasons     [][] = {"Connection issue", "Version not compatible"};

#if (sizeof(g_szGlitchNames) != CAC_GLITCH__ALL) || (sizeof(g_szGameOptionNames) != CAC_GAMEOPTION__ALL) || (sizeof(g_szCheatNames) != CAC_CHEAT__ALL) || (sizeof(g_szKickReasons) != CAC_KICKREASON__ALL)
	#error Your version of sampcac.inc is not compatible with this filterscript. Redownload the server package from www.SAMPCAC.xyz
#endif

public OnFilterScriptInit()
{
    printf("  SAMPCAC test filterscript loaded.");
    return 1;
}

public CAC_OnCheatDetect(player_id, cheat_id, opt1, opt2)
{
	new string[144+1], playerName[MAX_PLAYER_NAME] = "[not connected yet]", cheatName[64];
    if(IsPlayerConnected(player_id))
        GetPlayerName(player_id, playerName, sizeof(playerName));
	if(IsValidCheatID(cheat_id))
		strcat(cheatName, g_szCheatNames[cheat_id]);
	else
		strcat(cheatName, "[invalid]");
	format(string, sizeof(string), "* {EE5555}Cheat detected: {FFFFFF}Player: %s [ID: %i] | Cheat: %s [ID: %i] | Opt1: 0x%x | Opt2: 0x%x", playerName, player_id, cheatName, cheat_id, opt1, opt2);
	SendClientMessageToAll(-1, string);
    print(string);
    return 1;
}

public CAC_OnPlayerKick(player_id, reason_id)
{
	new string[144+1], playerName[MAX_PLAYER_NAME] = "[not connected yet]", kickReasonName[64];
    if(IsPlayerConnected(player_id))
        GetPlayerName(player_id, playerName, sizeof(playerName));
	if(IsValidKickReasonID(reason_id))
		strcat(kickReasonName, g_szKickReasons[reason_id]);
	else
		strcat(kickReasonName, "[invalid]");
	format(string, sizeof(string), "* {EE5555}Player kicked: {FFFFFF}Player: %s [ID: %i] | Reason: %s [ID: %i]", playerName, player_id, kickReasonName, reason_id);
	SendClientMessageToAll(-1, string);
    print(string);
    return 1;
}

public CAC_OnMemoryRead(player_id, address, size, const content[])
{
	new string[256], playerName[MAX_PLAYER_NAME] = "[not connected yet]";
    if(IsPlayerConnected(player_id))
        GetPlayerName(player_id, playerName, sizeof(playerName));
	format(string, sizeof(string), "* {EE5555}Memory read: {FFFFFF}Player: %s [ID: %i] | Address: %x | Size: %d | Content: ", playerName, player_id, address, size);
    for(new i = 0; i < size; ++i)
    {
        format(string, sizeof(string), "%s%02x", string, content[i]);
    }
	SendClientMessageToAll(-1, string);
    print(string);
    return 1;
}

public CAC_OnGameResourceMismatch(player_id, model_id, component_type, checksum)
{
    new string[144+1], playerName[MAX_PLAYER_NAME] = "[not connected yet]";
    if(IsPlayerConnected(player_id))
        GetPlayerName(player_id, playerName, sizeof(playerName));
    if(model_id != CAC_GAMERESOURCE_MODELID__ONLY_IF_MODDED)
    {
		if(0 <= model_id <= 19999) // valid GTA:SA game models are 0-19999
		{
			new compName[8];
			switch(component_type)
			{
				case CAC_GAMERESOURCE_COMPONENTTYPE__DFF:
					strcat(compName, "DFF");
				case CAC_GAMERESOURCE_COMPONENTTYPE__TXD:
					strcat(compName, "TXD");
				case CAC_GAMERESOURCE_COMPONENTTYPE__ANIM:
					strcat(compName, "ANIM");			
				default:
					strcat(compName, "UNKNOWN");
			}
			format(string, sizeof(string), "* {EE5555}Game resource modded: {FFFFFF}Player: %s [ID: %i] | Model ID: %d [%s] | Checksum: %08x", playerName, player_id, model_id, compName, checksum);
		}
		else
		{
			new modName[8];
			switch(model_id)
			{
				case CAC_GAMERESOURCE_MODELID__PEDIFP:
					strcat(modName, "PED.IFP");
			}
			format(string, sizeof(string), "* {EE5555}Game resource modded: {FFFFFF}Player: %s [ID: %i] | Mod: %s | Checksum: %08x", playerName, player_id, modName, checksum);
		}
    }
    else
    {
        format(string, sizeof(string), "* {EE5555}Game resource modded: {FFFFFF}Player: %s [ID: %i]", playerName, player_id);
    }
    SendClientMessageToAll(-1, string);
    print(string);
    return 1;
}

public CAC_OnScreenshotTaken(player_id)
{
    new string[144+1], playerName[MAX_PLAYER_NAME] = "[not connected yet]";
    if(IsPlayerConnected(player_id))
        GetPlayerName(player_id, playerName, sizeof(playerName));
    
	format(string, sizeof(string), "* {EE5555}Screenshot: {FFFFFF}Player: %s [ID: %i] took a screenshot.", playerName, player_id);
    SendClientMessageToAll(-1, string);
    print(string);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_GLITCHSTATUS)
    {
        if(response)
        {
            new string[128];
            new newstatus = !CAC_GetGlitchStatus(listitem);
            
            CAC_SetGlitchStatus(listitem, newstatus);
            
            format(string, sizeof(string), "Glitch \"%s\" is now %s{FFFFFF}.", g_szGlitchNames[listitem], (newstatus != 0) ? ("{00BC00}allowed") : ("{EE5555}blocked"));
            SendClientMessage(playerid, -1, string);
        }
        return 1;
    }
	if(dialogid == DIALOG_GAMEOPTIONSTATUS)
    {
        if(response)
        {
            new string[128];
            new newstatus = CAC_GetGameOptionStatus(listitem)+1;
			new newstatusname[32];
			
			if(listitem != CAC_GAMEOPTION__SPRINT)
			{
				newstatus %= 2;
				if(newstatus == 0)
					strcat(newstatusname, "{EE5555}deactivated");
				else
					strcat(newstatusname, "{00BC00}activated");
			}
			else
			{
				newstatus %= 3;
				switch(newstatus)
				{
					case CAC_GAMEOPTION_STATUS__SPRINT_DEFAULT:
						strcat(newstatusname, "{00BC00}Default");
					case CAC_GAMEOPTION_STATUS__SPRINT_ALLSURFACES:
						strcat(newstatusname, "{00BC00}All surfaces");
					case CAC_GAMEOPTION_STATUS__SPRINT_DISABLED:
						strcat(newstatusname, "{EE5555}Disabled");
				}            
			}
            CAC_SetGameOptionStatus(listitem, newstatus);
            
            format(string, sizeof(string), "Game option \"%s\" is now %s{FFFFFF}.", g_szGameOptionNames[listitem], newstatusname);
            SendClientMessage(playerid, -1, string);
        }
        return 1;
    }
    return 0;
}

COMMAND:cac_commands(playerid, const params[])
{
    SendClientMessage(playerid, -1, "/cac_commands /cac_status /cac_hwid /cac_readmemory");
    SendClientMessage(playerid, -1, "/cac_glitchstatus /cac_glitchplayerset /cac_glitchtoggle");
    SendClientMessage(playerid, -1, "/cac_gameoptionstatus /cac_gameoptionplayerset /cac_gameoptiontoggle");
    SendClientMessage(playerid, -1, "/cac_gameresourcestatus /cac_gameresourcetype /cac_gameresourceplayerset");
    return 1;
}

COMMAND:cac_status(playerid, const params[])
{
	new target_id, string[128], major, minor, patch;
	if(sscanf(params, "u", target_id)) return SendClientMessage(playerid, -1, "* /cac_status [target id/name]");
	if(!IsPlayerConnected(target_id)) return SendClientMessage(playerid, -1, "* Player not connected.");
  
    CAC_GetClientVersion(target_id, major, minor, patch);
	format(string, sizeof(string), "* PlayerID: %i | AC Status: %i | Version: v%i.%02i.%i", target_id, CAC_GetStatus(target_id), major, minor, patch);
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_hwid(playerid, const params[])
{
	new target_id, string[128], hw_id[CAC__MAX_HARDWARE_ID];
	if(sscanf(params, "u", target_id)) return SendClientMessage(playerid, -1, "* /cac_hwid [target id/name]");
	if(!IsPlayerConnected(target_id)) return SendClientMessage(playerid, -1, "* Player not connected.");

    CAC_GetHardwareID(target_id, hw_id, CAC__MAX_HARDWARE_ID);
    format(string, sizeof(string), "* PlayerID: %i | HardwareID: %s", target_id, hw_id);
    SendClientMessage(playerid, -1, string);
    return 1;
}

COMMAND:cac_readmemory(playerid, const params[])
{
	new target_id, address, size, string[128];
	if(sscanf(params, "uxi", target_id, address, size)) return SendClientMessage(playerid, -1, "* /cac_readmemory [target id/name] [address (hex)] [size]");
	if(!IsPlayerConnected(target_id)) return SendClientMessage(playerid, -1, "* Player not connected.");
  
    CAC_ReadMemory(target_id, address, size);
	format(string, sizeof(string), "* PlayerID: %i | Address: %x | Size: %d | Waiting for response ...", target_id, address, size);
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_glitchstatus(playerid, const params[])
{
	new glitch_id, status, string[128];
	if(sscanf(params, "ii", glitch_id, status)) return SendClientMessage(playerid, -1, "* /cac_glitchstatus [glitch id] [status]");
	
	if(status < 0)
	{
		format(string, sizeof(string), "* GlitchID: %i | Status: %i", glitch_id, CAC_GetGlitchStatus(glitch_id));
	}
	else
	{
		CAC_SetGlitchStatus(glitch_id, status);
		format(string, sizeof(string), "* GlitchID: %i | Status set to: %i", glitch_id, status);
	}
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_glitchplayerset(playerid, const params[])
{
	new target_id, glitch_id, status, string[128];
	if(sscanf(params, "uii", target_id, glitch_id, status)) return SendClientMessage(playerid, -1, "* /cac_glitchplayerset [target id/name] [glitch id] [status]");
    if(!IsPlayerConnected(target_id)) return SendClientMessage(playerid, -1, "* Player not connected.");

    CAC_PlayerSetGlitchSettings(target_id, glitch_id, status);
    format(string, sizeof(string), "* PlayerID: %i | GlitchID: %i | Status: %i", target_id, glitch_id, status);
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_glitchtoggle(playerid, const params[])
{
    new string[512] = "Glitch\tStatus\n";
    for(new i = 0; i != CAC_GLITCH__ALL; ++i)
    {
        format(string, sizeof(string), "%s{FFFFFF}%s\t%s\n", string, g_szGlitchNames[i], (CAC_GetGlitchStatus(i) != 0) ? ("{00BC00}Allowed") : ("{EE5555}Blocked"));
    }
    ShowPlayerDialog(playerid, DIALOG_GLITCHSTATUS, DIALOG_STYLE_TABLIST_HEADERS, "Toggle glitch status", string, "Toggle", "Exit");
    return 1;
}

COMMAND:cac_gameoptionstatus(playerid, const params[])
{
	new option_id, status, string[128];
	if(sscanf(params, "ii", option_id, status)) return SendClientMessage(playerid, -1, "* /cac_gameoptionstatus [option id] [status]");
	
	if(status < 0)
	{
		format(string, sizeof(string), "* GameOptionID: %i | Status: %i", option_id, CAC_GetGameOptionStatus(option_id));
	}
	else
	{
		CAC_SetGameOptionStatus(option_id, status);
		format(string, sizeof(string), "* GameOptionID: %i | Status set to: %i", option_id, status);
	}
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_gameoptionplayerset(playerid, const params[])
{
	new target_id, option_id, status, string[128];
	if(sscanf(params, "uii", target_id, option_id, status)) return SendClientMessage(playerid, -1, "* /cac_gameoptionplayerset [target id/name] [option id] [status]");
    if(!IsPlayerConnected(target_id)) return SendClientMessage(playerid, -1, "* Player not connected.");

    CAC_PlayerSetGameOption(target_id, option_id, status);
    format(string, sizeof(string), "* PlayerID: %i | GameOptionID: %i | Status: %i", target_id, option_id, status);
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_gameoptiontoggle(playerid, const params[])
{
    new string[1024] = "Game option\tStatus\n";
    for(new i = 0; i != CAC_GAMEOPTION__ALL; ++i)
    {
		if(i != CAC_GAMEOPTION__SPRINT)
		{
			format(string, sizeof(string), "%s{FFFFFF}%s\t%s\n", string, g_szGameOptionNames[i], (CAC_GetGameOptionStatus(i) != 0) ? ("{00BC00}Activated") : ("{EE5555}Deactivated"));
		}
		else
		{
			new status[32];
			switch(CAC_GetGameOptionStatus(i))
			{
				case CAC_GAMEOPTION_STATUS__SPRINT_DEFAULT:
					strcat(status, "{00BC00}Default");
				case CAC_GAMEOPTION_STATUS__SPRINT_ALLSURFACES:
					strcat(status, "{00BC00}All surfaces");
				case CAC_GAMEOPTION_STATUS__SPRINT_DISABLED:
					strcat(status, "{EE5555}Disabled");
			}
			format(string, sizeof(string), "%s{FFFFFF}%s\t%s\n", string, g_szGameOptionNames[i], status);
		}
	}
    ShowPlayerDialog(playerid, DIALOG_GAMEOPTIONSTATUS, DIALOG_STYLE_TABLIST_HEADERS, "Toggle game option status", string, "Toggle", "Exit");
    return 1;
}

COMMAND:cac_gameresourcestatus(playerid, const params[])
{
	new flag, status, string[128];
	if(sscanf(params, "ii", flag, status)) return SendClientMessage(playerid, -1, "* /cac_gameresourcestatus [flag] [status]");
	
	if(status < 0)
	{
		format(string, sizeof(string), "* GameResource flag: 0x%x | Status: %i", flag, CAC_GetGameResourceReportStatus(flag));
	}
	else
	{
		CAC_SetGameResourceReportStatus(flag, status);
		format(string, sizeof(string), "* GameResource flag: 0x%x | Status set to: %i", flag, status);
	}
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_gameresourcetype(playerid, const params[])
{
	new type, string[128];
	if(sscanf(params, "i", type)) return SendClientMessage(playerid, -1, "* /cac_gameresourcetype [type]");
	
	if(type < 0)
	{
		format(string, sizeof(string), "* GameResource type: %i", CAC_GetGameResourceReportType());
	}
	else
	{
		CAC_SetGameResourceReportType(type);
		format(string, sizeof(string), "* GameResource type set to: %i", type);
	}
	SendClientMessage(playerid, -1, string);
	return 1;
}

COMMAND:cac_gameresourceplayerset(playerid, const params[])
{
	new target_id, flags, type, string[128];
	if(sscanf(params, "uii", target_id, flags, type)) return SendClientMessage(playerid, -1, "* /cac_gameresourceplayerset [target id/name] [flag(s)] [type]");
    if(!IsPlayerConnected(target_id)) return SendClientMessage(playerid, -1, "* Player not connected.");

    CAC_PlayerSetGameResource(target_id, flags, type);
    format(string, sizeof(string), "* PlayerID: %i | GameResource flag(s): 0x%x | Type: %i", target_id, flags, type);
	SendClientMessage(playerid, -1, string);
	return 1;
}

IsValidCheatID(cheat_id)
{
	return (0 <= cheat_id < CAC_CHEAT__ALL);
}

IsValidKickReasonID(kick_reason_id)
{
	return (0 <= kick_reason_id < CAC_KICKREASON__ALL);
}