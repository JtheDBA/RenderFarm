# Render Farm - Linux

In this example the source and target machine for source videos to encode and the destination for the encoded videos. The IP for that server is `192.168.0.144` and there is a `_TODO` and `_DONE` share on that computer. The computer has
Windows 10 Professional and I use my "Microsoft ID" to connect to the shares.

## Installation

- Ubuntu, Debian, i.e. apt based: `sudo apt install -y ffmpeg` 
- Fedora
- CentOS
- Arch ( if you are using this, like, you really do not need my help and probably pacman'ed everything and then some before reaching the end of this sentence )

Directories and mount points need to be created for the source and target

```
sudo mkdir /mnt/{_TODO _DONE}
sudo vi /etc/fstab

//192.168.0.144/_TODO    /home/joel/_TODO      cifs username=joelmathias@live.com,noauto,rw,users,vers=3.0 0 0
//192.168.0.144/_DONE    /home/joel/_DONE      cifs username=joelmathias@live.com,noauto,rw,users,vers=3.0 0 0
:x

```

## Starting

From a shell prompt at the console simple do a `. ff` and wait until the computer is done and shuts itself down.

## Post Encode

From a shell prompt do a `. moov`, enter the password and wait until the cursor returns.



