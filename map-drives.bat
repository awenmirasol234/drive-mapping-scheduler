@echo off
setlocal EnableExtensions

REM ==================================================
REM                  LOAD CONFIGURATION
REM ==================================================

if not exist "%~dp0config.bat" (
    echo [ERROR] config.bat was not found.
    exit /b 1
)

call "%~dp0config.bat"

REM ==================================================
REM                   INITIALIZATION
REM ==================================================

echo.
echo ==========================================
echo           NETWORK DRIVE MAPPING
echo ==========================================
echo Domain: %USERDOMAIN%
echo User:   %USERNAME%
echo NAS:    %NAS_SERVER%
echo.

set "MAP_FAILED=0"

REM ==================================================
REM          REMOVE PREVIOUS MANAGED MAPPINGS
REM ==================================================

echo [INFO] Removing previous managed mappings...

net use "%STUDENT_DRIVE%" /delete /y >nul 2>&1
net use "%FACULTY_DRIVE%" /delete /y >nul 2>&1
net use "%ADMIN_DRIVE%" /delete /y >nul 2>&1

REM ==================================================
REM      CHECK ACTIVE DIRECTORY GROUP MEMBERSHIP
REM ==================================================

echo [INFO] Checking security group membership...
echo.

call :CHECK_GROUP "%STUDENT_GROUP%" "%STUDENT_DRIVE%" "\\%NAS_SERVER%\Students"

call :CHECK_GROUP "%FACULTY_GROUP%" "%FACULTY_DRIVE%" "\\%NAS_SERVER%\Faculty"

call :CHECK_GROUP "%ADMIN_GROUP%" "%ADMIN_DRIVE%" "\\%NAS_SERVER%\Admin"

REM ==================================================
REM                    FINAL RESULT
REM ==================================================

echo.
echo ==========================================

if "%MAP_FAILED%"=="1" (
    echo [WARNING] Some drives could not be mapped.
) else (
    echo [SUCCESS] Drive mapping process completed.
)

echo ==========================================
echo.

net use

exit /b %MAP_FAILED%


REM ==================================================
REM             CHECK GROUP AND MAP DRIVE
REM ==================================================

:CHECK_GROUP

set "GROUP_NAME=%~1"
set "DRIVE=%~2"
set "SHARE=%~3"

echo Checking group: %GROUP_NAME%

whoami /groups /fo list | findstr /i /l /c:"%USERDOMAIN%\%GROUP_NAME%" >nul

if errorlevel 1 (
    echo [SKIP] User is not a member of %GROUP_NAME%.
    echo.
    exit /b 0
)

echo [MATCH] User belongs to %GROUP_NAME%.
echo [INFO] Mapping %DRIVE% to %SHARE%...

net use "%DRIVE%" "%SHARE%" /persistent:yes

if errorlevel 1 (
    echo [FAILED] Could not map %DRIVE%.
    set "MAP_FAILED=1"
) else (
    echo [SUCCESS] %DRIVE% mapped successfully.
)

echo.
exit /b 0