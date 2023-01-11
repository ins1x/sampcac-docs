/*
 * SA-MP Clientside Anticheat (SAMPCAC)
 * Version:         v0.10.0
 * Author:          0xCAC
 * Compatible with: SA-MP 0.3.7 Server
 * Site:            https://SAMPCAC.xyz
 * Documentation:   https://SAMPCAC.xyz/docs
 *
 *
 * Usage:           Kick all players not having SAMPCAC loaded.
 */

#define FILTERSCRIPT

#include <a_samp>
#include <sampcac>

public OnFilterScriptInit()
{
    for(new i, j = GetPlayerPoolSize(); i <= j; ++i)
    {
        if(IsPlayerConnected(i))
        {
            OnPlayerConnect(i);
        }
    }
    printf("  SAMPCAC ONLY filterscript loaded.");
    return 1;
}

public OnPlayerConnect(playerid)
{
    if(!CAC_GetStatus(playerid))
    {
        // Att-Def specific:
        //    - Att-Def gamemode clears players chat at OnPlayerConnect(), so the kick message might not be seen by the new connected player.
        //    - Dirty fix: delay the kick process 1 second.
        SetTimerEx("ATTDEF_OnPlayerConnect", 1000, false, "i", playerid);
    }
    return 1;
}

forward ATTDEF_OnPlayerConnect(playerid);
public ATTDEF_OnPlayerConnect(playerid)
{
    new string[128], playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    format(string, sizeof(string), "SAMPCAC: {FFFFFF}%s has been kicked. Reason: SAMPCAC ({EE5555}sampcac_client.asi{FFFFFF}) is not installed.", playerName);
    SendClientMessageToAll(0xEE5555FF, string);
    
    SendClientMessage(playerid, 0xEE5555FF, "SAMPCAC: {FFFFFF}This server uses {EE5555}SA-MP Clientside AntiCheat{FFFFFF}. (SAMPCAC)");        
    SendClientMessage(playerid, 0xEE5555FF, "SAMPCAC: {FFFFFF}Download it from: {EE5555}www.SAMPCAC.xyz");      
    
    SetTimerEx("CAC_KickFix", 1000, false, "i", playerid);
}

forward CAC_KickFix(player_id);
public CAC_KickFix(player_id) { Kick(player_id); }
