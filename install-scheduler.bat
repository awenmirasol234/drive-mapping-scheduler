@echo off
setlocal EnableExtensions

REM ==================================================
REM              SCHEDULER CONFIGURATION
REM ==================================================

set "TASK_NAME=DriveMapping"
set "SCRIPT_PATH=%~dp0map-drives.bat"
set "XML_PATH=%~dp0scheduler.xml"

echo.
echo ==========================================
echo          DRIVE MAPPING SCHEDULER
echo ==========================================
echo.

REM ==================================================
REM                    CHECK SCRIPT
REM ==================================================

if not exist "%SCRIPT_PATH%" (
    echo [ERROR] map-drives.bat was not found.
    exit /b 1
)

REM ==================================================
REM               CREATE SCHEDULED TASK
REM ==================================================

echo [INFO] Creating scheduled task...

schtasks /create ^
    /tn "%TASK_NAME%" ^
    /sc ONLOGON ^
    /delay 0001:00 ^
    /tr "cmd.exe /c ""%SCRIPT_PATH%""" ^
    /f

if errorlevel 1 (
    echo [ERROR] Failed to create scheduled task.
    exit /b 1
)

echo [SUCCESS] Scheduled task created.

REM ==================================================
REM             EXPORT TASK CONFIGURATION
REM ==================================================

echo.
echo [INFO] Exporting scheduler configuration...

schtasks /query /tn "%TASK_NAME%" /xml > "%XML_PATH%"

if errorlevel 1 (
    echo [ERROR] Failed to export scheduler XML.
    exit /b 1
)

echo [SUCCESS] scheduler.xml exported.

REM ==================================================
REM COMPLETE
REM ==================================================

echo.
echo ==========================================
echo [SUCCESS] INSTALLATION COMPLETED
echo ==========================================
echo Task Name: %TASK_NAME%
echo Trigger:   User Logon
echo Delay:     1 Minute
echo Action:    map-drives.bat
echo XML:       %XML_PATH%
echo.

pause
endlocal
exit /b 0