NET USE S: "\\192.168.0.144\_TODO" /P:NO
NET USE T: "\\192.168.0.144\_DONE" /P:NO
NET USE 
PowerShell.exe ff.ps1
NET USE S: /DELETE
NET USE T: /DELETE