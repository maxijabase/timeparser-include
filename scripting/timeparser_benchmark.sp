#include <sourcemod>
#include <profiler>

// Include both versions of the parser
#include "include/timeparser_v1"
#include "include/timeparser_v2"

#pragma semicolon 1
#pragma newdecls required

#define TEST_ITERATIONS 50000
#define NUM_TEST_CASES 10

public Plugin myinfo = {
    name = "Time Parser Benchmark",
    author = "Assistant",
    description = "Benchmark tool for comparing TimeParser v1 and v2",
    version = "1.0",
    url = ""
};

// Test cases representing different patterns
char g_TestCases[NUM_TEST_CASES][] = {
    "1y",           // Simple single unit
    "1y2m3d",      // Multiple units
    "52w",         // Weeks only
    "365d",        // Large number
    "24h60m60s",   // All small units
    "5y104w730d",  // Overlapping units
    "1d",          // Minimal input
    "8760h",       // Hour equivalent of a year
    "525600m",     // Minute equivalent of a year
    "2y3w4d5h6m7s" // Complex mixed input
};

public void OnPluginStart() {
    RegAdminCmd("sm_benchmark_parser", CMD_BenchmarkParser, ADMFLAG_ROOT, "Run parser benchmark tests");
}

public Action CMD_BenchmarkParser(int client, int args) {
    Handle profiler = CreateProfiler();
    float timeV1, timeV2;
    int resultsV1[NUM_TEST_CASES];
    int resultsV2[NUM_TEST_CASES];
    
    // Test V1
    StartProfiling(profiler);
    for (int test = 0; test < NUM_TEST_CASES; test++) {
        for (int i = 0; i < TEST_ITERATIONS; i++) {
            resultsV1[test] = ParseTime1(g_TestCases[test]); // V1 parser
        }
    }
    StopProfiling(profiler);
    timeV1 = GetProfilerTime(profiler);
    
    // Test V2
    StartProfiling(profiler);
    for (int test = 0; test < NUM_TEST_CASES; test++) {
        for (int i = 0; i < TEST_ITERATIONS; i++) {
            resultsV2[test] = ParseTime2(g_TestCases[test]); // V2 parser
        }
    }
    StopProfiling(profiler);
    timeV2 = GetProfilerTime(profiler);
    
    // Report results
    ReplyToCommand(client, "=== Time Parser Benchmark Results ===");
    ReplyToCommand(client, "Iterations per test case: %d", TEST_ITERATIONS);
    ReplyToCommand(client, "Total test cases: %d", NUM_TEST_CASES);
    ReplyToCommand(client, "");
    ReplyToCommand(client, "Version 1 total time: %.6f seconds", timeV1);
    ReplyToCommand(client, "Version 2 total time: %.6f seconds", timeV2);
    ReplyToCommand(client, "");
    ReplyToCommand(client, "Performance difference: %.2f%%", (timeV1 - timeV2) / timeV1 * 100.0);
    ReplyToCommand(client, "");
    ReplyToCommand(client, "=== Individual Test Cases ===");
    
    for (int i = 0; i < NUM_TEST_CASES; i++) {
        ReplyToCommand(client, "Test case '%s':", g_TestCases[i]);
        ReplyToCommand(client, "  V1 result: %d", resultsV1[i]);
        ReplyToCommand(client, "  V2 result: %d", resultsV2[i]);
        ReplyToCommand(client, "  Match: %s", (resultsV1[i] == resultsV2[i]) ? "Yes" : "No");
        ReplyToCommand(client, "");
    }
    
    delete profiler;
    return Plugin_Handled;
}

// Helper function to validate results match between versions
bool ValidateResults(const int[] v1Results, const int[] v2Results) {
    for (int i = 0; i < NUM_TEST_CASES; i++) {
        if (v1Results[i] != v2Results[i]) {
            return false;
        }
    }
    return true;
}