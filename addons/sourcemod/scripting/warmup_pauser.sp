#include <sourcemod>

// Plugin definitions
#define PLUGIN_VERSION "1.2.0"

new Handle:PluginEnabled = INVALID_HANDLE;
new Handle:CountBots = INVALID_HANDLE;
new Handle:PlayerCountStart = INVALID_HANDLE;
int playerCount;

public Plugin:myinfo =
{
	name = "[CS:GO] Warmup Pauser",
	author = "Gdk",
	version = PLUGIN_VERSION,
	description = "Keeps game in warmup untill specified number of players have joined",
	url = "https://TopSecretGaming.net"
};

public OnPluginStart()
{
	PluginEnabled = CreateConVar("sm_warmup_pauser_enabled", "1", "Whether the plugin is enabled");
	CountBots = CreateConVar("sm_warmup_pauser_count_bots", "0", "Whether the plugin should count bots in player count");
	PlayerCountStart = CreateConVar("sm_warmup_pauser_player_count_start", "2", "Number of players to end warmup");

	playerCount = GetConVarInt(PlayerCountStart);

	AutoExecConfig(true, "warmup_pauser");
}
 
public OnClientPutInServer(client)
{
	if(GetConVarBool(PluginEnabled))
	{
		if(GetConVarBool(CountBots))
		{
			if(GetClientCount(true) < playerCount)
			{
				ServerCommand("mp_do_warmup_period 1");
				ServerCommand("mp_warmuptime 25");
				ServerCommand("mp_warmup_start");
				ServerCommand("mp_warmup_pausetimer 1");
			}
			if(GetClientCount(true) >= playerCount)
				ServerCommand("mp_warmup_pausetimer 0");
		}
		else
		{
			if(GetClientCount(true) < playerCount)
			{
				ServerCommand("mp_do_warmup_period 1");
				ServerCommand("mp_warmuptime 25");
				ServerCommand("mp_warmup_start");
				ServerCommand("mp_warmup_pausetimer 1");
			}
			if(GetRealClientCount(true) >= playerCount)
				ServerCommand("mp_warmup_pausetimer 0");
		}
	}
}

stock GetRealClientCount( bool:inGameOnly = true ) 
{
	new clients = 0;
	for( new i = 1; i <= GetMaxClients(); i++ ) 
	{
		if( ( ( inGameOnly ) ? IsClientInGame( i ) : IsClientConnected( i ) ) && !IsFakeClient( i ) ) 
		{
			clients++;
		}
	}
	return clients;
}