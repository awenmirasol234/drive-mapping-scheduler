@echo off
setlocal

REM ==================================================
REM              SCHEDULER CONFIGURATION
REM ==================================================

set "TASK_NAME=DriveMapping"

echo.
echo ==========================================
echo         REMOVE DRIVE MAPPING TASK
echo ==========================================
echo.

REM ==================================================
REM              REMOVE SCHEDULED TASK
REM ==================================================

schtasks /delete /tn "%TASK_NAME%" /f

if errorlevel 1 (
    echo [ERROR] Failed to remove scheduled task.
    exit /b 1
)

echo.
echo [SUCCESS] Scheduled task removed.
echo.

pause
endlocal
exit /b 0