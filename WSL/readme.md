# Render Farm - Windows Subsystem for Linux

**NOTE: I recommend using the PowerShell version** but I still provide this here if needed.

In this example the source and target machine for source videos to encode and the destination for the encoded videos. The IP for that server is `192.168.0.144` and there is a `_TODO` and `_DONE` share on that computer. The computer has
Windows 10 Professional and I use my "Microsoft ID" to connect to the shares.

## Installation

```
sudo apt install -y ffmpeg` 
mkdir -p ~/{_TODO,_DONE}
```

## Starting

From a shell prompt simply do a `. ff` and wait until the computer is done and exits the shell.

## Post Encode


## File Details

`ff.cmd` - Command Prompt wrapper

- map drives; the DOS FFmpeg does not recognize Windows UNC paths so drives must be mapped then deleted
- start WSL and run
- shutdown when done; optional, of course

```DOS bat
NET USE S: "\\192.168.0.144\_TODO" /P:NO
NET USE T: "\\192.168.0.144\_DONE" /P:NO
bash -c "cd;. ff"
NET USE S: /DELETE
NET USE T: /DELETE
SHUTDOWN /S /T 0 /D P:00:00 /C "Done encoding stuff"
```

`ff` - main encoding script

- the mounts are required to connect the mapped drives, not automatically mapped with the current WSL, to the Linux box
- while there is stuff in `ffmpeg.todo` do stuff
- the three `sed` commands were, unfortunately the cleanest way to remove a line from `ffmpeg.todo` between `tail`, `sed -e` (which produces strange errors creating temp files in WSL), etc.
- `awk` is used to format the main execution step and also print timestamps
- exit when done (although `bash -c` automatically exits, add just in case ???)

Interesting note: when you mount a share on `~/_TODO` for example none of the test commands or FFmpeg work - if you know why, please explain ! This is why `/home/joel/_TODO` is used...

```
sudo mount -t drvfs '//192.168.0.144/_TODO' /home/joel/_TODO
sudo mount -t drvfs '//192.168.0.144/_DONE' /home/joel/_DONE
while [ -s /home/joel/_TODO/ffmpeg.todo ]
do
sed -e 's/\r//' /home/joel/_TODO/ffmpeg.todo > ffmpeg.temp
sed -e '1d' ffmpeg.temp > /home/joel/_TODO/ffmpeg.todo
sed -i -e '2,$d' ffmpeg.temp
awk '{print strftime("%m%d-%H%M%S") "\t" $0}' ffmpeg.temp >> ffmpeg.history
awk -f ffmpeg.awk ffmpeg.temp > ffmpeg.todo
. ffmpeg.todo
awk '{print strftime("%m%d-%H%M%S") "\tDone..."}' ffmpeg.temp >> ffmpeg.history
done
exit
```

`ffmpeg.awk` - awk program script

- define in/out characters and directories
- define variables
- set defaults and add other FFmpeg operations
- print the commands to be used to run things

```
BEGIN {
 FS="\t"; OFS=" "
 TODO="/home/joel/_TODO/"
 WORK="/mnt/c/Users/Joel/Videos/"
 DONE="/home/joel/_DONE/"
}
{
 SRC=TODO $1
 $6 = $6 ".mp4"
 WRK=WORK $6
 TRG=DONE $6
 $1 = "ffmpeg -i \"" SRC "\" -f mp4"
 if (! length($2)) $2 = "-map 0:v -map 0:a"
 if (! length($3)) $3 = "-c:v copy"; $3 = $3 " -movflags +faststart"
 if (length($4)) $4 = $4 " "; $4 = $4 "-metadata language=eng"
 if (! length($5)) $5 = "-c:a copy"
 $6 = "\"" WRK "\""
 print "if [ -f \"" SRC "\" ]; then"
 print
 print "fi"
 print "if [ -f \"" WRK "\" ]; then"
 print "mv \"" WRK "\" \"" TRG "\""
 print "fi"
}
```
