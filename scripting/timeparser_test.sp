#include <sourcemod>
#include "include/timeparser"

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name = "Time Parser Test",
    author = "ampere",
    description = "Time Parser Test",
    version = "2.0",
    url = "https://github.com/maxijabase"
};

public void OnPluginStart() {
    RegConsoleCmd("sm_timeparse", CMD_Timeparse, "Test the time parser with a time string");
    RegConsoleCmd("sm_timeparsehelp", CMD_TimeparseHelp, "Show help for time parser usage");
}

public Action CMD_Timeparse(int client, int args) {
    if (!args) {
        ReplyToCommand(client, "Usage: sm_timeparse <time string>");
        ReplyToCommand(client, "Example: sm_timeparse 1y2m3d");
        ReplyToCommand(client, "Type sm_timeparsehelp for more information");
        return Plugin_Handled;
    }
    
    char argTime[256];
    GetCmdArg(1, argTime, sizeof(argTime));
    
    int result = ParseTime(argTime);
    
    switch (result) {
        case TIME_PARSE_INVALID_INPUT: {
            ReplyToCommand(client, "Error: Invalid input format. Use numbers followed by units (y,w,d,h,m,s)");
            return Plugin_Handled;
        }
        case TIME_PARSE_OVERFLOW: {
            ReplyToCommand(client, "Error: Time value too large - integer overflow");
            return Plugin_Handled;
        }
        case TIME_PARSE_NO_VALID_UNITS: {
            ReplyToCommand(client, "Error: No valid time units found in input");
            return Plugin_Handled;
        }
    }
    
    // If we get here, parsing was successful
    char currentTime[128], parsedTime[128];
    FormatTime(currentTime, sizeof(currentTime), "%F %T");
    FormatTime(parsedTime, sizeof(parsedTime), "%F %T", result);
    
    ReplyToCommand(client, "\x01[\x04Time Parser\x01] Results for input: \x04%s", argTime);
    ReplyToCommand(client, "\x01[\x04Time Parser\x01] Current time: \x04%s", currentTime);
    ReplyToCommand(client, "\x01[\x04Time Parser\x01] Parsed time:  \x04%s", parsedTime);
    ReplyToCommand(client, "\x01[\x04Time Parser\x01] Unix timestamp: \x04%d", result);
    
    return Plugin_Handled;
}

public Action CMD_TimeparseHelp(int client, int args) {
    ReplyToCommand(client, "\x01[\x04Time Parser Help\x01]");
    ReplyToCommand(client, "Available time units:");
    ReplyToCommand(client, "y - Years");
    ReplyToCommand(client, "w - Weeks");
    ReplyToCommand(client, "d - Days");
    ReplyToCommand(client, "h - Hours");
    ReplyToCommand(client, "m - Minutes");
    ReplyToCommand(client, "s - Seconds");
    ReplyToCommand(client, "");
    ReplyToCommand(client, "Examples:");
    ReplyToCommand(client, "!timeparse 1y - One year from now");
    ReplyToCommand(client, "!timeparse 2w3d - 2 weeks and 3 days from now");
    ReplyToCommand(client, "!timeparse 24h30m - 24 hours and 30 minutes from now");
    return Plugin_Handled;
}