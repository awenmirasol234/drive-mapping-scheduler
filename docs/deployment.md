# Deploy Drive Mapping to All Computers

## Prerequisites

- Domain-joined Windows clients.
- NAS reachable from clients.
- AD groups and shares configured in `map-drives.bat`.
- `map-drives.bat` stored in a trusted share, for example:
  `\\DOMAIN\NETLOGON\DriveMapping\map-drives.bat`
- Domain Users have Read and Execute permission on that share.

## Option 1: GPO Logon Script

Best for simple and immediate mapping at logon.

1. Open Group Policy Management.
2. Create and link a GPO to the user OU.
3. Edit: User Configuration > Policies > Windows Settings > Scripts (Logon/Logoff) > Logon.
4. Add `\\DOMAIN\NETLOGON\DriveMapping\map-drives.bat`.
5. Run `gpupdate /force` on a client.
6. Sign out and sign in with a test user.
7. Check File Explorer or run `net use`.

Notes:

- Runs in the signed-in user session.
- No scheduled task is needed.
- If the network is slow at logon, mapping may fail.

## Option 2: GPO Scheduled Task

Best when you want the 1-minute delay.

1. Copy `map-drives.bat` to clients, for example:
   `C:\ProgramData\DriveMapping\map-drives.bat`
   Use Computer Configuration > Preferences > Windows Settings > Files.
2. Create a scheduled task with User Configuration > Preferences > Control Panel Settings > Scheduled Tasks.
3. Name: `DriveMappingScheduler`
4. Trigger: At logon, delay 1 minute.
5. Action: `cmd.exe /c "C:\ProgramData\DriveMapping\map-drives.bat"`
6. Run as: signed-in user.
7. Update policy and test with a domain user.

## Option 3: SCCM or Intune

Best for larger or mixed environments.

1. Package `map-drives.bat`.
2. Deploy it to target computers or users.
3. Run it as a logon script, scheduled task, or startup item.
4. Use SCCM or Intune reporting to confirm success.

## Option 4: PowerShell Remoting

Best for quick testing or small environments.

```powershell
$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
foreach ($computer in $computers) {
    Copy-Item map-drives.bat "\\$computer\C$\ProgramData\DriveMapping\" -Force
}
```

Then create the scheduled task with PowerShell or Group Policy.

## Verification

- Run `map-drives.bat` manually.
- Run `net use`.
- Check Task Scheduler for `DriveMappingScheduler`.
- Check Event Viewer under TaskScheduler for task history.
- Test with users from each AD group.

## Troubleshooting

- Drive missing: check AD group membership with `whoami /groups`.
- Access denied: check NAS share and folder permissions.
- Script did not run: check GPO application with `gpresult /r`.
- Task missing: run `install-scheduler.bat` locally or deploy it.
- Network delay: use the 1-minute scheduled task instead of a direct logon script.
