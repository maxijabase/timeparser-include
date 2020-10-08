/*

Written by ampere - October 5, 2020

*/

#if defined _timeparser_included
#endinput
#endif
#define _timeparser_included

#define TIMEPARSER_VERSION 1.0

#define MAX_INTEGER_VALUE 2147483647
#define YEAR_TO_SECONDS 31536000
#define WEEK_TO_SECONDS 604800
#define DAY_TO_SECONDS 86400
#define HOUR_TO_SECONDS 3600
#define MINUTE_TO_SECONDS 60

#include <sourcemod>
#include <regex>

/**
 * Returns parsed time as a UNIX timestamp.
 * Example input: 3d12h - 2y90d - 10m
 *
 * Units accepted:
 *	'y' - 'w' - 'd' - 'h' - 'm' - 's'
 *
 * If time input causes an integer overflow, the max amount of time will be returned.
 * If there's an invalid time unit input, it will not add up to the final return value.
 * If no valid time unit inputs were found, -1 will be returned as error
 * 
 * @param time    Time input.
 * @return        UNIX timestamp or -1 on error
 */
stock int ParseTime(const char[] time) {
	
	Regex numRegex = new Regex("^[0-9]+$");
	int totalTime;
	
	for (int i = 0; i < strlen(time); i++) {
		
		switch (time[i]) {
			
			case 'y', 'w', 'd', 'h', 'm', 's': {
				
				char buf1[8], buf2[8], buf3[8], buf4[8];
				
				for (int j = i - 1; j >= 0; j--) {
					
					Format(buf2, sizeof(buf2), "%c", time[j]);
					
					if (numRegex.Match(buf2) != 0) {
						
						StrCat(buf1, sizeof(buf1), buf2);
						
					} else {
						
						break;
						
					}
					
				}
				
				for (int k = strlen(buf1); k >= 0; k--) {
					
					Format(buf3, sizeof(buf3), "%c", buf1[k]);
					StrCat(buf4, sizeof(buf4), buf3);
					
				}
				
				switch (time[i]) {
					
					case 'y':totalTime += StringToInt(buf4) * YEAR_TO_SECONDS;
					case 'w':totalTime += StringToInt(buf4) * WEEK_TO_SECONDS;
					case 'd':totalTime += StringToInt(buf4) * DAY_TO_SECONDS;
					case 'h':totalTime += StringToInt(buf4) * HOUR_TO_SECONDS;
					case 'm':totalTime += StringToInt(buf4) * MINUTE_TO_SECONDS;
					case 's':totalTime += StringToInt(buf4);
					
				}
				
			}
			
		}
		
	}
	
	delete numRegex;
	return (totalTime == 0 ? -1 : (totalTime + GetTime() < 0) ? MAX_INTEGER_VALUE : totalTime + GetTime());
	
}