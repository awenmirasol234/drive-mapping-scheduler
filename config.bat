@echo off
REM Central configuration for drive mapping and scheduler scripts.
REM Edit this file instead of editing the individual scripts.

REM NAS server hostname
set "NAS_SERVER=NAS01"

REM Active Directory security group names
set "STUDENT_GROUP=BSIT_Students"
set "FACULTY_GROUP=Faculty"
set "ADMIN_GROUP=IT_Admins"

REM SMB share names on the NAS
set "STUDENT_SHARE=Students"
set "FACULTY_SHARE=Faculty"
set "ADMIN_SHARE=Admin"

REM Network drive letters
set "STUDENT_DRIVE=S:"
set "FACULTY_DRIVE=F:"
set "ADMIN_DRIVE=A:"

REM Scheduled task settings
set "TASK_NAME=DriveMappingScheduler"
set "TASK_DELAY=0001:00"
set "XML_FILE=scheduler.xml"
