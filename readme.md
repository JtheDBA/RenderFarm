# Simple "FFmpeg" Rendering Farm

Hi there.

If you found this by accident: this is a complete (incomplete?) work in progress from some aging nerd with aging technology (that is still good for some things) in his basement attempting to stay current with some things while providing
services for one additional human being and three cats in our meager four level dwelling in the Midwest United States. I'm also 1) curious what you were searching for or how you found this and 2) welcome, hope you find something useful.

If you were given this repository by me, hi there. Hopefully you find something here that is usable and might save you time and frustration. Feel free to contribute, laugh at me, buy me a beer or six or just nerd up with me.

## Standard Disclaimers

*Do not assume I know what I am doing or anything should be used outside of personal experimentation and learning. All comments are my own and do not reflect the thoughts or direction of my employer, family, friends,
favorite television and radio station or anything else.*

*This is always work in progress. Learn first, copy and paste second.*

*This project should be used to convert videos one format to another for purposes of archival and storage, convenience or for personal media distribution and is not intended for mass piracy or other illegitimate uses - this should be good enough for you lawyer folks right*

## Concept

Almost every nerd I know of has at least one or more computers sitting in their basement realistically doing nothing so why not take that older technology, install a free operating system that will boot from hard disk or a thumb drive, and write a set
of standard Linux scripts to process videos one at a time reencoding them from their source format to a format used on a Plex or Emby server until there are no videos left to encode then simply shut down.

The scripts rely on two things:
-  a file share for the source video files and the text file used control the entire process
-  simple text file with tab delimited items to tell the video encoder what to do

# Hardware

Simply listing my hardware here as an example:

## Source

The primary purpose of the source device is the store video source files and the one control file used to control the process. The source device could be a computer or network storage device. The source computer can also be used for copying 
or "ripping" files from an encrypted source like a DVD or Blu-ray disc two the source device for encoding. I will not provide a tutorial on how to do this as there are hundreds of them on the Internet but it is a requirement if you are 
backing up and/or converting your collection to a smaller more accessible local network distributable format.

- AMD FX-8320E 65W 8 core CPU, Windows 10, with separate disks for
  -  **source files, control file**
  -  **target files**
  -  final destination for movies, television and home videos
 
## Slaves

The slave devices will likely be computers; the old ones you have laying around probably doing nothing. Or they can be dedicated gaming machines you have for your kids that can also be used to convert all of those cartoons they want to watch 
over and over and over and over and over and over and over again without having to find the disk and loaded somewhere. I use Ubuntu 18.04 Mini and have found this is easiest of the minimal Linux servers to install and use for this purpose 
and as a base for other purposes. There are hundreds of others available.

- AMD FX Vishera 65W 8 core CPU, Ubuntu Server
- AMD FX Vishera 65W 6 core CPU, Ubuntu Server
- Intel i3 Haswell 4th gen 2 core x 2 threads, Windows 10 Home
- Intel i5 Haswell 4th gen 4 core CPU, Ubuntu Server
- (if needed) AMD Kaveri APU 4 core, Windows
- (if needed) AMD Trinity APU 4 core
- (if needed) 3 core Hyper-V VM, Ubuntu Mini (Server 2016 / limit cores due to passive cooling on CPU and heat issues)

## Destination

The destination device can be the same as a source if you are using a server to play videos on your local network or can be another computer or a storage device that also performs the same function in addition to the other functions and performs.

- AMD FX-8320E 65W 8 core CPU, Windows 10, with separate disks for
- Synology DS-218+ running Plex

# Software

## Video

-  [Make MKV]() Used to decrypt DVD and Blu-ray contents to. MKV files to be used as source files to encode for backup or for your online collection
-  [Builds - Zeranoe FFmpeg](https://FFmpeg.zeranoe.com/builds/) The wind is billed for the video encoder
-  [HandBrake](https://HandBrake.fr/) HandBrake; a very good video encoder with a GUI that helps determine cropping and formatting were to do the actual videoing code
-  [MediaInfo](https://mediaarea.net/en/MediaInfo) a good utility that integrates with the Windows Explorer and will document all components in all video streams
-  [VLC Media Player](https://www.videolan.org/vlc/download-windows.html) a very commonly used player for Windows
-  [SubtitleEdit](https://github.com/SubtitleEdit/subtitleedit/releases) if you like to do subtitles yourself, uses software
-  [MKVToolNix](https://www.fosshub.com/MKVToolNix.html) these utilities come in handy sometimes

## FFmpeg vs HandBrake

The primary reason am not using HandBrake is in my opinion the HandBrake batch command line system is changing too frequently and only the most current builds of Linux contain code that will match and potentially work with the same code
available under Windows. Where FFmpeg simply works wherever you have it installed. When comparing HandBrake to FFmpeg for encoding performance, convenience, and final encoding size and results the GUI for Windows is very good.
In fact if I am only encoding a few videos I will usually use HandBrake to do the encoding than use the scripts to copy the files using FFmpeg to their final location.

## Linux

- [Ubuntu 18.04 Installation/Minimal CD](https://help.ubuntu.com/community/Installation/MinimalCD) - found this just works...

# Resources

https://FFmpeg.org/documentation.html



