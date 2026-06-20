@echo off
REM Hermes WebUI Management Script for Windows

set WEBUI_DIR=D:\Coding\hermes-webui
set PID_FILE=%USERPROFILE%\.hermes\webui.pid

if "%1"=="start" goto start
if "%1"=="stop" goto stop
if "%1"=="status" goto status
if "%1"=="restart" goto restart

echo Usage: webui-ctl.bat [start^|stop^|status^|restart]
exit /b 1

:start
echo Starting Hermes WebUI...
cd /d %WEBUI_DIR%
start /b python server.py > %USERPROFILE%\.hermes\webui.log 2>&1
echo Hermes WebUI started. Access at: http://127.0.0.1:8787
echo Log file: %USERPROFILE%\.hermes\webui.log
goto end

:stop
echo Stopping Hermes WebUI...
taskkill /f /im python.exe /fi "WINDOWTITLE eq python server.py*" 2>nul
echo Hermes WebUI stopped.
goto end

:status
echo Checking Hermes WebUI status...
curl -s http://127.0.0.1:8787/health > nul 2>&1
if %errorlevel%==0 (
    echo Status: RUNNING - http://127.0.0.1:8787
    curl -s http://127.0.0.1:8787/health | python -m json.tool
) else (
    echo Status: STOPPED
)
goto end

:restart
call :stop
timeout /t 2 > nul
call :start
goto end

:end