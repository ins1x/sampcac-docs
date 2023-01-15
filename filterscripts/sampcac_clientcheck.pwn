/*
 * SA-MP Clientside Anticheat (SAMPCAC) v0.10.0
 * Filterscript Author: 1NS
 * Compatible with: SA-MP 0.3.7 Server
 *
 * Usage: Checks the client version and displays messages about the need to update or install AC them.
 */

#define FILTERSCRIPT

#include <a_samp>
#include <sampcac>
#tryinclude <foreach>

// Some SA-MP natives which are not defined by default
#if !defined _inc_fixes
	native gpci(playerid,serial[],maxlen);
#endif

#define KickPlayerEx(%0) SetTimerEx("KickPlayer", 500, 0, "d", %0)

public OnPlayerConnect(playerid)
{
	new 
		string[128], ip[16], serial[41],
		nickname[MAX_PLAYER_NAME],
		hwid[CAC__MAX_HARDWARE_ID],
		major, minor, patch,
		ClientVersion[24]
	;
	
	GetPlayerVersion(playerid, ClientVersion, sizeof(ClientVersion));
	CAC_GetClientVersion(playerid, major, minor, patch);
	GetPlayerName(playerid,nickname,sizeof(nickname));
	GetPlayerIp(playerid, ip, sizeof ip);
	
	if(CAC_GetStatus(playerid) == 0)
	{
		SendClientMessage(playerid, 0xFF8C00AA,	"Download it from: www.bitly.com/sampcac10");
		#if defined foreach
		foreach(new p : Player)
		#else
		for(new p = 0; p < MAX_PLAYERS; p++)
		#endif
		{
			if(IsPlayerAdmin(playerid))
			{
				format(string, sizeof(string),
				"%s(%d) has joined the server without SAMPCAC ( IP: %s %s)", 
				nickname, playerid, ip);
			} else {
				format(string, sizeof(string),
				"%s(%d) has joined the server without SAMPCAC",
				nickname, playerid);
			}
			SendClientMessage(p, 0xFF8C00AA, string);
		}
		gpci(playerid, serial, sizeof(serial));
		printf("%s hardware ID (serial): %s", nickname, serial);
	} else { 
		if(minor != 10)
		{
			SendClientMessage(playerid, 0xFF8C00AA,
			"SAMPCAC outdated version installed! Please install the current version of the SAMPCAC anti-cheat");
			format(string, sizeof(string),
			"%s(%d) was kicked. Reason: Outdated SAMPCAC", nickname, playerid);
			SendClientMessageToAll(0xFF8C00AA, string);
			KickPlayerEx(playerid);
		} else {
			#if defined foreach
			foreach(new p : Player)
			#else
			for(new p = 0; p < MAX_PLAYERS; p++)
			#endif
			{
				if(IsPlayerAdmin(playerid))
				{
					format(string, sizeof(string),
					"%s(%d) has joined the server with SAMPCAC ( IP: %s )",
					nickname, playerid, ip);
				} else {
					format(string, sizeof(string),
					"%s(%d) has joined the server with SAMPCAC",
					nickname, playerid);
				}
				SendClientMessage(p, 0xa9c4e4, string);
			}
		}
		CAC_GetHardwareID(playerid, hwid, sizeof(hwid));
		printf("%s hardware ID (hwid): %s", nickname, hwid);
	}

	// if the player uses a fake client, send warning to everyone
	if(strfind(ClientVersion, "0.3.7") == -1 && strfind(ClientVersion, "DL") == -1)
	{
		SendClientMessage(playerid, 0xFF8C00AA,
		"You are using an incorrect sa-mp client version, install version 0.3.7");
		format(string, sizeof(string),
		"%s(%d) has joined the server with incorrect version SA-MP %s\t",
		nickname, playerid, ClientVersion);
		SendClientMessageToAll(0xFF8C00AA, string);
	}
	return 1;
}