/*
 * SA-MP Clientside Anticheat (SAMPCAC) v0.10.0
 * Filterscript Author: 1NS
 * Compatible with: SA-MP 0.3.7 Server
 *
 * Warning:         DON'T USE THIS FILTERSCRIPT ON A LIVE SERVER!
 *
 * Note that all offsets thus posted have been confirmed for GTA San Andreas (GTA_SA.EXE) version 1.0.
 * This is not for function addresses, for these look into Function Memory Addresses (SA).
 * Note: None of the memory addresses below will work for GTA: San Andreas v2.0 or 3.0(steam).
 * All addresses in v2.0 and above have been changed or moved. Thus inaccessible.
 *
 * Useful links:
 * https://gtamods.com/wiki/Memory_Addresses_(SA)
 * https://gtaforums.com/topic/194199-documenting-gta-sa-memory-addresses/page/1/#comments
 */

#define FILTERSCRIPT

#include <a_samp>
#include <sampcac>

#define KickPlayerEx(%0) SetTimerEx("KickPlayer", 500, 0, "d", %0)

public OnFilterScriptInit()
{
    printf("SAMPCAC memory read test filterscript loaded.");
    return 1;
}

/*
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
*/

public CAC_OnMemoryRead(player_id, address, size, const content[])
{
	new string[128];
	new nickname[MAX_PLAYER_NAME]; 
	GetPlayerName(player_id, nickname, sizeof(nickname));
	
	// REAL aiming mode offset, not menu. 0 = joypad 1 = mouse + keys
	// address 0xBA6818 menu joypad
	if(address == 0xB6EC2E && size == 1) 
	{
		if(content[0] == 0) 
		{
			format(string, sizeof(string),
			"%s(%d) was kicked. Reason: mobile player", nickname, player_id);
			SendClientMessageToAll(0xFF8C00AA, string);
			KickPlayerEx(player_id);
		}
	}
	
	// HUD Test. If recieve 0 this usually happens when player using custom HUD
	if(address == 0xA444A0 && size == 1) 
	{
		if(content[0] == 0)
		{
			format(string, sizeof(string),
			"Player %s(%d) has a custom HUD", nickname, player_id);
			SendClientMessageToAll(0xFF8C00AA, string);
		}
	}
	
	if(address == 0x96916D && size == 1) 
	{
		if(content[0] > 0)
		{
			format(string, sizeof(string),
			"%s(%d) was kicked. Reason: bulletproof", nickname, player_id);
			SendClientMessageToAll(0xFF8C00AA, string);
			KickPlayerEx(player_id);
		}
	}
	
	/*if(address == 0xB7CEE4 && size == 1) 
	{
		if(content[0] > 0)
		{
			format(string, sizeof(string),
			"%s(%d) was kicked. Reason: infinity run (2)", nickname, player_id);
			SendClientMessageToAll(0xFF8C00AA, string);
			KickPlayerEx(player_id);
		}
	}*/
	
	/*if(address == 0xB7CB49 && size == 1)
	{
		if(content[0] == 0x1) SetPlayerChatBubble(player_id, "..ESC menu..", COLOR_GREY, 50.0, 5000);
	}*/
	
	// Anti aliasing
	if(address == 0xBA6814 && size == 1)
	{
		if(content[0] == 0x1) SendClientMessage(player_id, -1, "Anti aliasing 0x (off)");
		else if(content[0] == 0x2) SendClientMessage(player_id, -1, "Anti aliasing 1x (off)");
		else if(content[0] == 0x3) SendClientMessage(player_id, -1, "Anti aliasing 2x (off)");
		else if(content[0] == 0x4) SendClientMessage(player_id, -1, "Anti aliasing 3x (off)");
		
	}
	
	// 0xB6EC1C – [float] Mouse sensitivity CAC_ReadMemory(i, 0xB6EC1C, 4); 
	// if(address == 0xB6EC1C && size == 4) printf("Mouse %d", content[0]);
	
	// Weather id
	if(address == 0xC81320 && size == 2) {
		format(string, sizeof(string),
		"Player %s(%d) weather id: %d", nickname, player_id, content[0]);
		SendClientMessage(player_id, -1, string);
	}
	
	// default fpslimiter
	//if(address == 0xBA6794 && size == 1)
	//{
	//	if(content[0] == 0x1) SetPVarInt(player_id, "DefaultFPSLimiterON", 1);
	//}
	
	// Defalut Frame Limit for Frame Limiter
	// 38 = 30fps
	// 46 = 35fps
	// 55 = 40fps
	// 65 = 45fps
	// 76 = 50fps
	// 88 = 55fps
	// 105 = 60fps
	// 200 = 100fps 
	//if(address == 0xC1704C && size == 1) printf("Default FPS %d", content[0]);
	
    return 1;
}

public OnPlayerConnect(playerid)
{
	#if defined _sampcac_included
		//ESC MENU
		//if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) CAC_ReadMemory(playerid, 0xB7CB49, 1); 
		//CAC_ReadMemory(playerid, 0xC1704C, 1); // FPS Limit
		CAC_ReadMemory(playerid, 0xA444A0, 1); // HUD		
		CAC_ReadMemory(playerid, 0xB6EC2E, 1); // Mobile player	
		CAC_ReadMemory(playerid, 0x96916D, 1); // Bulletproof		
		CAC_ReadMemory(playerid, 0xB7CEE4, 1); // Infinity run 2
		CAC_ReadMemory(playerid, 0xC81320, 1); // Weather
		CAC_ReadMemory(playerid, 0xBA6814, 1); // Anti aliasing
	#endif
	return 1;
}