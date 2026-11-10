# Drive Mapping and Task Scheduler - Validation Report

Member 2 validation and documentation report.

## 1. Purpose

This report records the testing, validation, and final configuration for the Drive Mapping and Task Scheduler setup.

## 2. Test Environment

| Item | Value |
|---|---|
| Client OS | Windows (domain-joined) |
| Domain | |
| NAS server | NAS01 |
| Task name | DriveMappingScheduler |
| Mapping script | map-drives.bat |
| Installer | install-scheduler.bat |

## 3. Configuration Under Test

| Setting | Value |
|---|---|
| Student group | BSIT_Students |
| Faculty group | Faculty |
| Admin group | IT_Admins |
| Student drive | S: |
| Faculty drive | F: |
| Admin drive | A: |
| Student share | \\NAS01\Students |
| Faculty share | \\NAS01\Faculty |
| Admin share | \\NAS01\Admin |
| Task trigger | At log on |
| Task delay | 1 minute |

## 4. Test Accounts and Group Membership

Record each account used for testing.

| Test account | Domain | Security groups | Expected drive(s) |
|---|---|---|---|
| | | | |
| | | | |
| | | | |

Commands used:

```bat
whoami
whoami /groups
```

## 5. Drive Mapping Test Results

| Test account | Group matched | Drive letter | Share mapped | Result | Screenshot |
|---|---|---|---|---|---|
| | | | | Pass / Fail | |
| | | | | Pass / Fail | |

Commands used:

```bat
map-drives.bat
net use
```

## 6. Access Validation Results

| Test account | Resource | Expected access | Actual access | Result | Screenshot |
|---|---|---|---|---|---|
| Student | \\NAS01\Students | Allow | | Pass / Fail | |
| Student | \\NAS01\Faculty | Deny | | Pass / Fail | |
| Student | \\NAS01\Admin | Deny | | Pass / Fail | |
| Faculty | \\NAS01\Faculty | Allow | | Pass / Fail | |
| Faculty | \\NAS01\Students | Deny | | Pass / Fail | |
| Faculty | \\NAS01\Admin | Deny | | Pass / Fail | |
| Admin | \\NAS01\Admin | Allow | | Pass / Fail | |
| Admin | \\NAS01\Students | Deny | | Pass / Fail | |
| Admin | \\NAS01\Faculty | Deny | | Pass / Fail | |

Access restrictions are enforced by NAS share and NTFS permissions.

## 7. Task Scheduler Trigger Tests

### 7.1 Reboot Test Procedure

1. Restart the Windows client.
2. Sign in using a domain account.
3. Wait one minute.
4. Run `net use`.
5. Repeat using different domain accounts.

### 7.2 Trigger Results

| Trigger | Test account | Reboot tested | Drive appeared after delay | Result | Notes |
|---|---|---|---|---|---|
| At log on | | Yes / No | Yes / No | Pass / Fail | |
| At startup | | Yes / No | Yes / No | Pass / Fail | |

Manual task run command:

```bat
schtasks /run /tn DriveMappingScheduler
```

Task query command:

```bat
schtasks /query /tn DriveMappingScheduler /v /fo list
```

## 8. Startup Failure Investigation

### 8.1 Observed Behavior

The At startup trigger may fail to map drives for the signed-in user.

### 8.2 Likely Causes

- The task can start before the network, DNS, or NAS is ready.
- The task may run before Active Directory group information is available.
- At startup tasks often run before or outside the interactive user session.
- Drives mapped in that context may not appear in the user's session.

### 8.3 Conclusion

At log on with a 1-minute delay is more suitable because:

- It runs in the signed-in domain user's context.
- The delay gives network connectivity and domain services time to become available.
- Mapped drives are created in the user's own session.

Recommendation: Keep the final configuration using At log on with a 1-minute delay.

## 9. Final Task Scheduler Configuration

| Setting | Value |
|---|---|
| Task name | DriveMappingScheduler |
| Trigger | At log on |
| Delay | 1 minute |
| Action | Execute map-drives.bat |
| Execution context | Signed-in domain user |
| XML export | scheduler.xml |

## 10. Screenshots

Store screenshots in `docs/screenshots/` and list them here.

| File name | Description |
|---|---|
| | |

## 11. Findings Summary

- Drive mapping depends on Active Directory group membership.
- Drive letters are assigned by group.
- Access control depends on NAS permissions.
- The At startup trigger is less reliable than At log on with delay.

## 12. Remaining Risks

- Test results must be completed on the actual domain and NAS environment.
- NAS permissions must be verified separately from the mapping script.
- Task execution depends on the client network being available at logon.