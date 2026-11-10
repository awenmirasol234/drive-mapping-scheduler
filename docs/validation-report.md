# Drive Mapping and Task Scheduler - Test Report

This is the test report for Member 2.

## 1. Purpose

This report shows the test results and final setup for drive mapping and task scheduling.

## 2. Test Place

| Item | Value |
|---|---|
| Computer system | Windows (joined to domain) |
| Domain | |
| NAS server | NAS01 |
| Task name | DriveMappingScheduler |
| Mapping script | map-drives.bat |
| Install script | install-scheduler.bat |

## 3. Setup Under Test

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

## 4. Test Accounts and Groups

Write down each test account here.

| Test account | Domain | Security groups | Expected drive(s) |
|---|---|---|---|
| | | | |
| | | | |
| | | | |

Use these commands:

```bat
whoami
whoami /groups
```

## 5. Drive Mapping Test Results

| Test account | Group matched | Drive letter | Share mapped | Result | Screenshot |
|---|---|---|---|---|---|
| | | | | Pass / Fail | |
| | | | | Pass / Fail | |

Use these commands:

```bat
map-drives.bat
net use
```

## 6. Access Test Results

| Test account | Resource | Should allow? | Did allow? | Result | Screenshot |
|---|---|---|---|---|---|
| Student | \\NAS01\Students | Yes | | Pass / Fail | |
| Student | \\NAS01\Faculty | No | | Pass / Fail | |
| Student | \\NAS01\Admin | No | | Pass / Fail | |
| Faculty | \\NAS01\Faculty | Yes | | Pass / Fail | |
| Faculty | \\NAS01\Students | No | | Pass / Fail | |
| Faculty | \\NAS01\Admin | No | | Pass / Fail | |
| Admin | \\NAS01\Admin | Yes | | Pass / Fail | |
| Admin | \\NAS01\Students | No | | Pass / Fail | |
| Admin | \\NAS01\Faculty | No | | Pass / Fail | |

The NAS controls access by share and folder permissions.

## 7. Task Scheduler Trigger Tests

### 7.1 Reboot Test Steps

1. Restart the Windows computer.
2. Sign in with a domain account.
3. Wait one minute.
4. Run `net use`.
5. Repeat with other domain accounts.

### 7.2 Trigger Results

| Trigger | Test account | Reboot tested? | Drive appeared after delay? | Result | Notes |
|---|---|---|---|---|---|
| At log on | | Yes / No | Yes / No | Pass / Fail | |
| At startup | | Yes / No | Yes / No | Pass / Fail | |

Manual task run command:

```bat
schtasks /run /tn DriveMappingScheduler
```

Task check command:

```bat
schtasks /query /tn DriveMappingScheduler /v /fo list
```

## 8. Startup Failure Check

### 8.1 What We Saw

The At startup trigger may fail to map drives for the user.

### 8.2 Why It May Fail

- The task may run before the network is ready.
- The task may run before DNS is ready.
- The task may run before the NAS is ready.
- The task may run before Active Directory group data is ready.
- The task may run outside the user session.

### 8.3 Conclusion

At log on with a 1-minute delay is better because:

- It runs as the signed-in domain user.
- The delay gives the network time to connect.
- The delay gives domain services time to load.
- The drives map inside the user session.

Keep the final setup as At log on with a 1-minute delay.

## 9. Final Task Scheduler Setup

| Setting | Value |
|---|---|
| Task name | DriveMappingScheduler |
| Trigger | At log on |
| Delay | 1 minute |
| Action | Run map-drives.bat |
| Run as | Signed-in domain user |
| XML file | scheduler.xml |

## 10. Screenshots

Put screenshots in `docs/screenshots/`. List them here.

| File name | What it shows |
|---|---|
| | |

## 11. Summary

- Drive mapping uses Active Directory group membership.
- Each group gets its own drive letter.
- Access is controlled by NAS permissions.
- At startup is less reliable than At log on with delay.

## 12. Remaining Risks

- Test results must be filled in on the real domain and NAS.
- NAS permissions must be checked on their own.
- The task needs network access at logon.