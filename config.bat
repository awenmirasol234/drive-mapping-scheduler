@echo off
REM Drive mapping configuration. Edit this file, not map-drives.bat.

REM NAS server hostname
set "NAS_SERVER=NAS01"

REM Active Directory security group names
REM Replace these with your actual AD group names.
set "STUDENT_GROUP=BSIT_Students"
set "FACULTY_GROUP=Faculty"
set "ADMIN_GROUP=IT_Admins"

REM Network drive letters
set "STUDENT_DRIVE=S:"
set "FACULTY_DRIVE=F:"
set "ADMIN_DRIVE=A:"
