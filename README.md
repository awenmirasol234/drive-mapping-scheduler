# Drive Mapping and Scheduler

Automatically map network drives for domain users based on their Active Directory security group membership using Windows Batch scripts and Task Scheduler.

## Overview

- Map NAS shared folders to network drives.
- Check Active Directory group membership.
- Run drive mapping automatically after user logon.
- Apply a 1-minute scheduled task delay.
- Export Task Scheduler configuration to XML.
- Support manual deployment or Group Policy deployment.

## Requirements

- Windows domain-joined client.
- Accessible NAS server.
- Configured SMB shared folders.
- Active Directory security groups.
- Appropriate NAS share permissions.
- Windows Task Scheduler.

## Directory Structure

```text
drive-mapping-scheduler/
├── map-drives.bat
├── install-scheduler.bat
├── remove-scheduler.bat
├── scheduler.xml
└── README.md
```

## Configuration

Before deployment, update these settings in `map-drives.bat`:

| Setting | Description |
|---|---|
| `NAS_SERVER` | NAS server hostname |
| `STUDENT_GROUP` | Student security group |
| `FACULTY_GROUP` | Faculty security group |
| `ADMIN_GROUP` | Administrator security group |
| `STUDENT_DRIVE` | Student network drive letter |
| `FACULTY_DRIVE` | Faculty network drive letter |
| `ADMIN_DRIVE` | Administrator network drive letter |

Ensure that the configured SMB share names match the actual NAS configuration.

## Installation

### 1. Configure Drive Mapping

Update the NAS hostname, shared folder paths, drive letters, and Active Directory security group names in `map-drives.bat`.

### 2. Test Drive Mapping

Run the mapping script manually:

```bat
map-drives.bat
```

Verify the mapped drives:

```bat
net use
```

### 3. Install Task Scheduler

Run:

```bat
install-scheduler.bat
```

The installer creates a scheduled task with this configuration:

| Setting | Value |
|---|---|
| Task Name | `DriveMapping` |
| Trigger | At log on |
| Delay | 1 minute |
| Action | Execute `map-drives.bat` |
| Execution Context | Signed-in domain user |

### 4. Verify Scheduled Task

```bat
schtasks /query /tn DriveMapping /v /fo list
```

### 5. Export Task Configuration

The installer automatically exports the scheduled task configuration to:

```text
scheduler.xml
```

## Testing and Validation

Check user information:

```bat
whoami
```

Check security group membership:

```bat
whoami /groups
```

Check mapped drives:

```bat
net use
```

Run the scheduled task manually:

```bat
schtasks /run /tn DriveMapping
```

Test across reboots:

1. Restart the Windows client.
2. Sign in using a domain account.
3. Wait one minute.
4. Verify that the expected network drives appear.
5. Repeat using different domain accounts and security groups.
6. Test the At startup trigger separately and record its behavior.

Validate access permissions. Verify that:

- Student accounts can access authorized student folders.
- Faculty accounts can access authorized faculty folders.
- Admin accounts can access authorized administrative folders.
- Unauthorized users cannot access restricted departmental folders.

Access restrictions must be enforced by NAS permissions, not solely by the mapping script.

## Task Removal

To remove the scheduled task, run:

```bat
remove-scheduler.bat
```

This removes the scheduled task without deleting the mapping scripts or exported XML configuration.

## Deliverables

- [x] Network drive mapping batch script.
- [x] Task Scheduler installation script.
- [ ] Task Scheduler removal script.
- [ ] Task Scheduler XML export.
- [ ] Reboot test results.
- [ ] Trigger behavior documentation.
- [ ] Access validation results.

## Notes

- The scheduled task runs in the signed-in user's context.
- The one-minute delay allows additional time for network connectivity and domain services to become available.
- Test both startup and logon triggers across reboots.
- Document the observed reason for any startup-trigger failure.
- Ensure NAS permissions enforce the intended security group access.
