# test-internet-connect
Windows Batch Script to monitor and test an internet connection

This was created to test a home internet connection that would go down for a few hours and come back. After several service calls, rounds of ineffective advice, and blameshifting with the building manager and the connection provider (no names), I wanted to get actual stats on when the connection was up and when it was down.

This script will create two text files, which you can optionally display. One file is a tab-delimited file these fields

- Date and time in ISO 8601 format
- Number of seconds since the beginning of the year
- A number indicating whether the internet is up or down (1=up, 0=down)

The other file has lines with the time and current state. It is only written when the state changes from the last ping.

# Instructions
This runs on Windows. It doesn't assume any version of Powershell, Perl, Python, Ruby, or anything else, other than the ping command working.

- Edit the settings in test-connect.bat as desired.
- Open a command prompt and naviagate to the location of test-connect.bat.
- Type test-connect

The program will run until you kill the window.

# Licensing notes
I used the Unlicense for this, as this is largely cobbled together from 'how to' sites and blog posts. Do what you want with it.
