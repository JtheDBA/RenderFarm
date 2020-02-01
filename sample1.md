# Sample One

This process is what I do and likely will not match what you do. It can however, be used as a template for a process.

## Objective

Reencode Dexter Season One from DVD to .mp4 for Plex servers. Season One is interlaced at 29.97 fps and will test the various deinterlace options. Also test my Excel workbook TV worksheet. 

## Steps

- [X] use MakeMKV to decrypt the source files on the Dexter DVDs to a location on the source video disc
- [X] use any file utilities to check the contents of the source it is to determine the type of video, the audio streams, and any subtitle files in formats
- [X] determine which file is which i.e. season one episode one, rename and move move the source files to the to do or working folder (note a complicated name is not needed so it could be DEX0101.mkv
- [X] continue until all files have been copied from source to target, remove any extra files you have no need for or simply not needed
- [X] enter the data on the Excel spreadsheet
- [X] copy the data from the Excel spreadsheet to the [ffmpeg.todo](ffmpeg.todo.md) file in the to do directory on the source server
- [X] start of the slave machines and begin running the process
- [X] start the process on the source machine as well
- [X] when complete simply move the files from the slave machines to the target on the target machine ( which in my case is the same as the source )
- [X] hmm, results look odd let's try different filters
- [X] find best filter combination for FFmpeg file size compared to Handbrake
- [X] find best filter combination for visual results FFmpeg compared to Handbrake
- [X] choose best filter combination for FFmpeg deinterlacing

## Results

| Output File | CPU | Time | Size MB | HandBrake
| ----------- | --- | ---- | ------: | --------:
| Dexter - S01E01 - Dexter | AMD FX 8 | 0:58:32 | 619 | 525
| Dexter - S01E02 - Crocodile | AMD FX 6 | 1:12:25 | 670 | 568
| Dexter - S01E03 - Popping Cherry | AMD FX 8 | 0:55:34 | 833 | 718
| Dexter - S01E04 - Let's Give the Boy a Hand | AMD FX 8 | 0:57:41 | 793 | 678
| Dexter - S01E05 - Love American Style | AMD FX 8 | 0:57:10 | 693 |
| Dexter - S01E06 - Return to Sender | AMD FX 6 | 1:10:49 | 645 |
| Dexter - S01E07 - Circle of Friends | AMD FX 8 | 0:52:33 | 654 |
| Dexter - S01E08 - Shrink Wrap | AMD FX 8 | 0:59:02 | 663 |
| Dexter - S01E09 - Father Knows Best | AMD FX 6 | 1:21:48 | 811 |
| Dexter - S01E10 - Seeing Red | AMD FX 8 | 1:03:00 | 790 |
| Dexter - S01E11 - Truth Be Told | AMD FX 8 | 1:02:11 | 728 |
| Dexter - S01E12 - Born Free | AMD FX 8 | 1:12:45 | 1088 |

There are couple of obvious results there. The eight core processors are faster than the six core processor; duh. What I found interesting, however, was a difference between the first four episodes that encoded with Handbrake versus FFmpeg.
The files encoded with Handbrake using the exact same options used with FFmpeg came out smaller using what looks like an older version of the encoded library.

| Value | FFmpeg | Handbrake
| :---  | ---: | ---:
| Bits/(Pixel*Frame) | 0.138         | 0.114
| Stream size        | 542 MiB (90%) | 449 MiB (87%)
| Writing library    | x264 core 159 | x264 core 157 r2935 545de2f

Handbrake added five additional properties to their output according to MediaInfo:

-  Original display aspect ratio - 16:9
-  Color range - Limited
-  Color primaries - BT.601 NTSC
-  Transfer characteristics - BT.601
-  Matrix coefficients - BT.601

I tried rerunning with different filters; results:

| Handbrake MB | yadif MB | diff MB | diff % | filter | new MB | HB diff % | yadif-f %
| ---: | ---: | ---: | ---: | :--- | ---: | ---: | ---:
| 512.92 | 605.05 | 92.13 | 1.1796 | vf yadif=1 | 603.47 | 1.176 | 0.997
| 555.47 | 654.55 | 99.08 | 1.1783 | vf yadif,atadenoise | 580.72 | 1.045 | 0.887
| 701.32 | 813.86 | 112.54 | 1.160 | vf yadif=1,atadenoise | 772.73 | 1.101 | 0.949
| 662.13 | 775.06 | 112.93 | 1.170 | vf kerndeint | 863.18 | 1.303 | 1.113

### Best Size

Handbrake still wins but deinterlace and denoise is definitely best. The kerndeint filter is excluded on size alone.

-  vf yadif
-  vf yadif=1
-  **vf yadif,atadenoise**
-  vf yadif=1,atadenoise

### Best Quality

There were no significant differences between any of the encoding processes. I attempted to study light and dark sections, still and high action sections and typical difficult encoding items like fire or water fountains
and if you look very closely frame by frame can see a slight difference and both HandBrake and the `vf yadif,atadenoise` filter seemed to be almost identical in quality so I guess the winner in this category same as the previous one.
-  vf yadif
-  vf yadif=1
-  **vf yadif,atadenoise**
-  vf yadif=1,atadenoise

## Verdict

Use filter `-vf yadif,atadenoise` on interlaced DVD source material.