@echo off
setlocal

REM ==================================================
REM              SCHEDULER CONFIGURATION
REM ==================================================

if not exist "%~dp0config.bat" (
    echo [ERROR] config.bat was not found.
    exit /b 1
)

call "%~dp0config.bat"

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