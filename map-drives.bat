@echo off
setlocal EnableExtensions

REM ==================================================
REM                  CONFIGURATION
REM ==================================================
REM Edit these settings in this file.

REM NAS server hostname
set "NAS_SERVER=NAS01"

REM Number of mappings in the list below.
set "MAP_COUNT=3"

REM Format for each mapping: Group|Drive|Share
REM Share may be a share name or a full UNC path.
set "MAP_1=BSIT_Students|S:|Students"
set "MAP_2=Faculty|F:|Faculty"
set "MAP_3=IT_Admins|A:|Admin"

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
REM      REMOVE OLD MAPPINGS AND MAP NEW DRIVES
REM ==================================================

echo [INFO] Removing previous managed mappings...
echo [INFO] Checking security group membership...
echo.

for /l %%I in (1,1,%MAP_COUNT%) do (
    call :GET_ENTRY %%I
    if not "%ENTRY%"=="" (
        for /f "tokens=1-3 delims=|" %%G in ("%ENTRY%") do (
            if not "%%H"=="" net use "%%H" /delete /y >nul 2>&1
            if not "%%G"=="" if not "%%H"=="" if not "%%I"=="" call :CHECK_GROUP "%%G" "%%H" "%%I"
        )
    )
)

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
REM                   HELPER ROUTINES
REM ==================================================

REM Read MAP_n into ENTRY.
:GET_ENTRY
set "ENTRY="
call set "ENTRY=%%MAP_%~1%%"
exit /b 0


REM Check group membership and map the drive.
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

REM Convert a share name to a full UNC path.
if not "%SHARE:~0,2%"=="\\" set "SHARE=\\%NAS_SERVER%\%SHARE%"

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
