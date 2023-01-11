/*
 * SA-MP Clientside Anticheat (SAMPCAC)
 * Version:         v0.10.0
 * Author:          0xCAC
 * Compatible with: SA-MP 0.3.7 Server
 * Site:            https://SAMPCAC.xyz
 * Documentation:   https://SAMPCAC.xyz/docs
 *
 *
 * Usage:           Warn players that they're using an outdated version of SAMPCAC client before kicking them.
 */

#define FILTERSCRIPT

#include <a_samp>
#include <sampcac>

enum E_VERSION
{
	MAJOR,
	MINOR,
	PATCH
}

public CAC_OnPlayerKick(player_id, reason_id)
{
    if(reason_id == CAC_KICKREASON__VERSION_NOT_COMPATIBLE)
    {
		new clientVersion[E_VERSION], serverVersion[E_VERSION], string[144+1], playerName[MAX_PLAYER_NAME] = "[not connected yet]";
		
		CAC_GetClientVersion(player_id, clientVersion[MAJOR], clientVersion[MINOR], clientVersion[PATCH]);
		CAC_GetServerVersion(serverVersion[MAJOR], serverVersion[MINOR], serverVersion[PATCH]);

		if(IsPlayerConnected(player_id))
			GetPlayerName(player_id, playerName, sizeof(playerName));
		
		format(string, sizeof(string), "SAMPCAC: {FFFFFF}%s has been kicked. Reason: SAMPCAC version is not compatible. ({EE5555}v%i.%02i.%i{FFFFFF})", playerName, clientVersion[MAJOR], clientVersion[MINOR], clientVersion[PATCH]);
		SendClientMessageToAll(0xEE5555FF, string);
		
		format(string, sizeof(string), "SAMPCAC: {FFFFFF}You're using {EE5555}v%i.%02i{FFFFFF}, while the server is using {EE5555}v%i.%02i{FFFFFF}.", clientVersion[MAJOR], clientVersion[MINOR], serverVersion[MAJOR], serverVersion[MINOR]);
		SendClientMessage(player_id, 0xEE5555FF, string);        
		SendClientMessage(player_id, 0xEE5555FF, "SAMPCAC: {FFFFFF}Update your client from: {EE5555}www.SAMPCAC.xyz");      
    }
    return 1;
}