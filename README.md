# Drive Mapping and Scheduler

Automatically map network drives for domain users based on their Active Directory security group membership using Windows Batch scripts and Task Scheduler.

## Features

- Map NAS shared folders to network drives.
- Check Active Directory group membership.
- Run drive mapping automatically after user logon.
- Apply a 1-minute scheduled task delay.
- Export Task Scheduler configuration to XML.
- Support manual deployment or Group Policy deployment.

## Directory Structure

```text
drive-mapping/
├── map-drives.bat
├── install-scheduler.bat
├── remove-scheduler.bat
├── scheduler.xml
└── README.md