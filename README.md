# SourceMod Time Parser

A lightweight utility that converts human-readable time strings into UNIX timestamps in SourceMod.

## Usage

### Include in your plugin

```sourcepawn
#include <timeparser>
```

### Basic Examples

```sourcepawn
// Simple time string parsing
int timestamp = ParseTime("1y");         // 1 year from now
int timestamp = ParseTime("2w3d");       // 2 weeks and 3 days from now
int timestamp = ParseTime("24h30m");     // 24 hours and 30 minutes from now
int timestamp = ParseTime("1y6m10d");    // 1 year, 6 months, and 10 days from now

// Error handling
int result = ParseTime("invalid");
if (result == -1) {
    PrintToServer("Invalid time format");
}
```

### Supported Units

- `y` - Years
- `w` - Weeks
- `d` - Days
- `h` - Hours
- `m` - Minutes
- `s` - Seconds

### Error Codes

- `-1` - Invalid input or no valid time units found
- Other positive integers - Valid UNIX timestamp

### Example Plugin

```sourcepawn
#include <sourcemod>
#include "timeparser"

public Plugin myinfo = {
    name = "Time Parser Example",
    author = "Your Name",
    description = "Example usage of Time Parser",
    version = "1.0",
    url = ""
};

public void OnPluginStart() {
    RegConsoleCmd("sm_bantime", Command_BanTime);
}

public Action Command_BanTime(int client, int args) {
    if (!args) {
        ReplyToCommand(client, "Usage: sm_bantime <time>");
        ReplyToCommand(client, "Example: sm_bantime 1w2d");
        return Plugin_Handled;
    }
    
    char argTime[32];
    GetCmdArg(1, argTime, sizeof(argTime));
    
    int banTime = ParseTime(argTime);
    if (banTime == -1) {
        ReplyToCommand(client, "Invalid time format!");
        return Plugin_Handled;
    }
    
    ReplyToCommand(client, "Ban would expire at: %d", banTime);
    return Plugin_Handled;
}
```

## License

MIT License - Feel free to use and modify as needed.
