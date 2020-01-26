# Sample Two

This process is what I do and likely will not match what you do. It can however, be used as a template for a process.

## Objective

Reencode Blu-ray to 720p HD for "Evil Dead 2: Dead by Dawn" Anniversary Edition and "The Dead"; both found in the bargain bin at Walmart - cannot get any better than that! Also test my Excel workbook Movies worksheet...

## Steps

- [X] use MakeMKV to decrypt the source files on the disks to a location on the source video disc
- [X] use any file utilities to check the contents of the source it is to determine the type of video, the audio streams, and any subtitle files in formats
- [X] continue until all files have been copied from source to target, remove any extra files you have no need for or simply not needed
- [X] enter the data on the Excel spreadsheet
- [X] copy the data from the Excel spreadsheet to the [ffmpeg.todo](ffmpeg.todo.md) file in the to do directory on the source server
- [X] start of the slave machines and begin running the process
- [ ] when complete simply move the files from the slave machines to the target on the target machine ( which in my case is the same as the source )
