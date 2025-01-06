/*
 * Improved TimeParser implementation
 * Original by ampere (2020)
 */

#if defined _timeparser_v2_included
#endinput
#endif
#define _timeparser_v2_included

#define TIMEPARSER_VERSION 2.0

#define MAX_INTEGER_VALUE 2147483647
#define YEAR_TO_SECONDS 31536000
#define WEEK_TO_SECONDS 604800
#define DAY_TO_SECONDS 86400
#define HOUR_TO_SECONDS 3600
#define MINUTE_TO_SECONDS 60

#include <sourcemod>

enum struct TimeUnit {
    char symbol;
    int multiplier;
}

static TimeUnit g_TimeUnits[] = {
    {'y', YEAR_TO_SECONDS},
    {'w', WEEK_TO_SECONDS},
    {'d', DAY_TO_SECONDS},
    {'h', HOUR_TO_SECONDS},
    {'m', MINUTE_TO_SECONDS},
    {'s', 1}
};

/**
 * Error codes for time parsing
 */
enum TimeParseResult {
    TIME_PARSE_SUCCESS = 0,
    TIME_PARSE_INVALID_INPUT = -1,
    TIME_PARSE_OVERFLOW = -2,
    TIME_PARSE_NO_VALID_UNITS = -3
}

/**
 * Parses a time string into seconds.
 * Examples: "3d12h", "2y90d", "10m"
 *
 * Accepted units:
 * y - years
 * w - weeks
 * d - days
 * h - hours
 * m - minutes
 * s - seconds
 *
 * @param time          Time string to parse
 * @param currentTime   Optional base time (default: GetTime())
 * @return             Unix timestamp or error code from TimeParseError
 */
stock int ParseTime2(const char[] time, int currentTime = 0) {
    if (time[0] == '\0') {
        return TIME_PARSE_INVALID_INPUT;
    }

    if (currentTime == 0) {
        currentTime = GetTime();
    }

    int totalTime = 0;
    int currentNumber = 0;
    bool foundValidUnit = false;
    bool parsingNumber = false;

    for (int i = 0; i < strlen(time); i++) {
        // Parse numbers
        if (IsCharNumeric(time[i])) {
            if (currentNumber > MAX_INTEGER_VALUE / 10) {
                return TIME_PARSE_OVERFLOW;
            }
            currentNumber = (currentNumber * 10) + (time[i] - '0');
            parsingNumber = true;
            continue;
        }

        // Parse time units
        if (parsingNumber) {
            bool validUnit = false;
            for (int j = 0; j < sizeof(g_TimeUnits); j++) {
                if (time[i] == g_TimeUnits[j].symbol) {
                    // Check for overflow before multiplying
                    if (currentNumber > MAX_INTEGER_VALUE / g_TimeUnits[j].multiplier) {
                        return TIME_PARSE_OVERFLOW;
                    }

                    int timeToAdd = currentNumber * g_TimeUnits[j].multiplier;
                    if (totalTime > MAX_INTEGER_VALUE - timeToAdd) {
                        return TIME_PARSE_OVERFLOW;
                    }

                    totalTime += timeToAdd;
                    currentNumber = 0;
                    foundValidUnit = true;
                    validUnit = true;
                    break;
                }
            }

            if (!validUnit) {
                return TIME_PARSE_INVALID_INPUT;
            }
            parsingNumber = false;
        } else {
            // Found a unit without a number, or two units in a row
            return TIME_PARSE_INVALID_INPUT;
        }
    }

    // If we ended with a number but no unit
    if (parsingNumber) {
        return TIME_PARSE_INVALID_INPUT;
    }

    if (!foundValidUnit) {
        return TIME_PARSE_NO_VALID_UNITS;
    }

    // Check for overflow when adding current time
    if (totalTime > MAX_INTEGER_VALUE - currentTime) {
        return TIME_PARSE_OVERFLOW;
    }

    return totalTime + currentTime;
}