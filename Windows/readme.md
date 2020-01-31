# Render Farm - PowerShell in Windows

In this example the source and target machine for source videos to encode and the destination for the encoded videos. The IP for that server is `192.168.0.144` and there is a `_TODO` and `_DONE` share on that computer. The computer has
Windows 10 Professional and I use my "Microsoft ID" to connect to the shares.



## Installation

- Download [FFmpeg](https://FFmpeg.zeranoe.com/builds/) and extract it somewhere; personally I prefer to `C:\DOS` so binaries and other software executables end up in the `C:\DOS\bin` folder.
- Put `ff.cmd` and `ff.ps1` in the same folder somewhere; `C:\Users\yourname` ??
- Make a "work" folder somewhere
- Edit `ff.cmd` and `ff.ps1` to fit the folders and shares in your environment.

## Starting

Directories and mount points need to be created for the source and target because the command prompt version of FFmpeg does not recognize network UNC names. This must also be performed outside of PowerShell.
The easiest way to do this and clean up afterwards is through a command prompt script `ff.cmd`

```DOS bat
NET USE S: "\\192.168.0.144\_TODO" /P:NO
NET USE T: "\\192.168.0.144\_DONE" /P:NO
NET USE 
PowerShell.exe ff.ps1
NET USE S: /DELETE
NET USE T: /DELETE
```

## Post Encode

If you used the `$doneDir = "T:\"` variable there is nothing left to do. If you did not, you will need to get the encoded files to their final destination.