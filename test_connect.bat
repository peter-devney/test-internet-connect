:: Windows batch script to check if the internet is working. This can be used
:: to record an internet connection that drops out once in a while.

@echo off
cls

:: settings
set "TAB=	"
set test_page=www.google.com
set ping_interval=4
set run_once=no
set display_change=yes
set display_pings=no
set change_file=change.log
set ping_file=state.log

set last_internet=2

:start_loop

call :get_date_time the_time seconds_past
call :ping_internet the_internet

set ping_display=%the_time%%TAB%%seconds_past%%TAB%%the_internet%
if %display_pings%==yes (echo %ping_display%)
echo %ping_display% >>%ping_file%

if %the_internet%==%last_internet% goto :exit_main_program

set last_internet=%the_internet%
if %the_internet%==1 (set internet_state=connected) else (set internet_state=not connected)

set change_display=It is now %the_time% and the internet is %internet_state%
if %display_change%==yes (echo %change_display%)
echo %change_display% >>%change_file%

:exit_main_program

if %run_once%==yes (goto :eof)

:: refresh
timeout /t %ping_interval% /nobreak >nul

goto :start_loop


:get_date_time
:: returns the date in two forms
:: 1st parameter - now in ISO 8601 - YYYY-MM-DDTHH24:MI:SS local time
:: 2nd parameter - number of seconds from the beginning of the year

set l_date=%date%

:::  get date and time
set l_dd=%l_date:~10,4%-%l_date:~4,2%-%l_date:~7,2%
set l_starttime=%time%
set l_hh=%l_starttime:~0,2%
set l_mm=%l_starttime:~3,2%
set l_ss=%l_starttime:~6,5%

:::  zeros for AM
set l_hh=00%l_hh: =%
set l_hh=%l_hh:~-2%

:: get number of days since start of year
call :get_days_since_year_start "%l_date%" l_days_past

:: convert strings, taking care that numbers are not interpreted as octal
set /a "ln_hh=1%l_hh% %% 100"
set /a "ln_mm=1%l_mm% %% 100"
set /a "ln_ss=1%l_ss:~0,2% %% 100"

set /a "l_secs_past=%l_days_past%*86400+%ln_hh%*3600+%ln_mm%*60+%ln_ss%"

set %~1=%l_dd%T%l_hh%:%l_mm%:%l_ss%
set %~2=%l_secs_past%

exit /B 0


:get_days_since_year_start
:: returns the number of days that have passed since the start of the year
:: calling sample call :get_days_since_year_start "%date%" days_past
:: It will return the number of days that have passed since start of the year
set l_sent_date=%~1

for /F "tokens=2-4 delims=/ " %%a in ("%l_sent_date%") do (
   set /A "l_mon=1%%a-100, l_day=1%%b-100, l_Ymod4=%%c%%4"
)
for /F "tokens=%l_mon%" %%m in ("0 31 59 90 120 151 181 212 243 273 304 334") do set /A Day=l_day+%%m
if %l_Ymod4% equ 0 if %l_mon% gtr 2 set /A Day+=1

set /A Day-=1
set %~2=%Day%

exit /B 0


:ping_internet
:: checks for connectivity returns 1 if we can connect 0 otherwise

ping %test_page% -n 1 -w 1000 >nul
if errorlevel 1 (set internet=0) else (set internet=1)
set %~1=%internet%

exit /B 0


:eof
