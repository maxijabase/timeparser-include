# timeparser-include
A SourcePawn include to parse readable time inputs to UNIX timestamps

It's designed to parse time inputs in the following syntax:
[amount][unit]<br>
Following the usable test plugin command example that comes in the repo: <br>
*sm_timeparse 3d12h* | *2y* | *5m* | *120d*<br>
<br>
This function turns into seconds all valid time inputs and sums it up with the current UNIX timestamp, returning the future date (as a timestamp).<br>
<br>
### Supported time units
* Years (y)
* Weeks (w)
* Days (d)
* Hours (h)
* Minutes (m)
* Seconds (s)
<br>

### Example tests

```
sm_timeparse 3d12h
The parser returned timestamp 1602663143
CURRENT TIME: 2020-10-10 17:12:23
PARSED TIME: 2020-10-14 05:12:23
```
```
sm_timeparse 12w60d
The parser returned timestamp 1614803647
CURRENT TIME: 2020-10-10 17:34:07
PARSED TIME: 2021-03-03 17:34:07
```
```
sm_timeparse 1m30s
The parser returned timestamp 1602362192
CURRENT TIME: 2020-10-10 17:35:02
PARSED TIME: 2020-10-10 17:36:32
```
