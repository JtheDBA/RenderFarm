# Render Farm - Linux

In this example the source and target machine for source videos to encode and the destination for the encoded videos. The IP for that server is `192.168.0.144` and there is a `_TODO` and `_DONE` share on that computer. The computer has
Windows 10 Professional and I use my "Microsoft ID" to connect to the shares. The Linux slaves are running Ubuntu 18.04 LTS mini.

## Installation

- Ubuntu, Debian, i.e. apt based: `sudo apt install -y ffmpeg` 
- Fedora [Try HERE](https://computingforgeeks.com/how-to-install-ffmpeg-on-fedora/)
- CentOS [Try HERE](https://computingforgeeks.com/how-to-install-ffmpeg-on-centos-rhel-8/)
- Arch ( if you are using this, like, you really do not need my help and probably already pacman'ed everything and then some before reaching the end of this sentence )

Copy the files to your home directory. Edit them to point to your directory.

Directories and mount points need to be created for the source and target

```
mkdir -p ~/{_TODO,_DONE,_WORK}
sudo vi /etc/fstab

//192.168.0.144/_TODO    /home/joel/_TODO      cifs username=joelmathias@live.com,noauto,rw,users,vers=3.0 0 0
//192.168.0.144/_DONE    /home/joel/_DONE      cifs username=joelmathias@live.com,noauto,rw,users,vers=3.0 0 0
:x
sudo chmod 644 /etc/fstab
```

## Starting

From a shell prompt at the console simple do a `. ff` and wait until the computer is done and shuts itself down.

## Post Encode

Nothing to do here.

## File Details

`ff` - main encoding script

- the mounts are required to connect the mapped drives
- while there is stuff in `ffmpeg.todo` do stuff
- the three `sed` commands were, unfortunately the cleanest way to remove a line from `ffmpeg.todo` between `tail`, `sed -i`, etc.
- `awk` is used to format the main execution step and also print timestamps

Interesting note: when you mount a share on `~/_TODO` for example none of the test commands or FFmpeg work - if you know why, please explain ! This is why `/home/joel/_TODO` is used...

```
mount.cifs //192.168.0.144/_TODO    /home/joel/_TODO
mount.cifs //192.168.0.144/_DONE    /home/joel/_DONE
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
shutdown -h 1; exit
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
 WORK="/home/joel/_WORK/"
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