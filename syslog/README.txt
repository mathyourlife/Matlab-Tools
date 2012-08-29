SYSLOG Utility with File Rotation

A basic logging function with log rotation that 
records the message along with system the time

=====================================================
Simple Use
=====================================================
Usage:
>> syslog('this happened now')

Writes the line:
2012_08_28_19_24_08 this happened now
to:
./syslog_2012_08_28_19.log


=====================================================
Log Rotation
=====================================================
Usage:
>> syslog('first hour')
>> pause(3600)
>> syslog('second hour')

Writes the line:
2012_08_28_19_24_08 first hour
to:
./syslog_2012_08_28_19.log
Then writes the line:
2012_08_28_20_24_08 second hour
to:
./syslog_2012_08_28_20.log


=====================================================
Split logging to content specific files
=====================================================
Usage:
>> syslog('a just doubled','a')
>> syslog('b just tripled','b')

Writes the line:
2012_08_28_20_24_08 a just doubled
to:
./a_2012_08_28_20.log
Then writes the line:
2012_08_28_20_24_08 b just tripled
to:
./b_2012_08_28_20.log

