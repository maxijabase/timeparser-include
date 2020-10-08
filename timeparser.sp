#include <sourcemod>
#include <timeparser>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =  {
	name = "Time Parser Test", 
	author = "ampere", 
	description = "Time Parser Test", 
	version = "1.0", 
	url = "https://github.com/ratawar"
};

public void OnPluginStart() {
	
	RegConsoleCmd("sm_timeparse", CMD_Timeparse);
	
}

public Action CMD_Timeparse(int client, int args) {
	
	if (!args) {
		
		return Plugin_Handled;
		
	}
	
	char argTime[256];
	GetCmdArg(1, argTime, sizeof(argTime));
	
	int parsedTime = ParseTime(argTime);
	
	ReplyToCommand(client, "The parser returned timestamp %i", parsedTime);
	
	char bufTimestamp1[128];
	FormatTime(bufTimestamp1, sizeof(bufTimestamp1), "%F %T");
	
	char bufTimestamp2[128];
	FormatTime(bufTimestamp2, sizeof(bufTimestamp2), "%F %T", parsedTime);
	
	ReplyToCommand(client, "CURRENT TIME: %s\nPARSED TIME: %s", bufTimestamp1, bufTimestamp2);
	
	return Plugin_Handled;
	
}