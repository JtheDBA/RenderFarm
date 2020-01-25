# ffmpeg.todo

The `ffmpeg.todo` file is a simple text file used to control the rendering farm encoding process using one line for each source video and each line containing tab delimited values used to tell the FFMPEG encoder what to do.

I have used the [Rokoding](http://rokoding.com) site for years as the standard for what I would do in HandBrake and used the [FFmpeg Wiki](https://trac.ffmpeg.org/wiki) or [FFmpeg Full Documentation](https://ffmpeg.org/documentation.html) to convert to the `FFmpeg` equivalents.

## Format of the Control File

Everything is tab delimited and some have a default value
-  the full name of the source video file
-  any mapping operands, defaults to mapping the first video and audio stream in the file
-  any video filters or CODEC operands, defaults to copy but can also default to a standard for encoding a source DVD or Blu-ray disc
-  metadata to pass, defaults to setting the language to English and nothing else
-  any audio filters or CODEC operands, defaults to copy but can also default to a standard similar to video
-  the full name of the output video file without the extension

## Source Video File

This is full filename without the path but with the extension of the source video file to encode. Example: `Dexter S01E02.mkv`

## Stream Mapping

Any mapping operands, defaults to the `FFmpeg` default of *"the "highest quality" (single) video input stream and "highest quality" (single) audio input stream"* or if only one video and audio exist map those. Examples of other mappings:

-  `-map 0:v -map 0:a:0 -map 0:a:0` maps the first audio stream twice to encode one using AAC but copy the (assuming) AC3 stream as well
-  `-map 0:v -map 0:a:0 -map 0:a:0 -map 0:a:2 -map 0:a:3` like above, but also two more streams that are commentary

See [Map](https://trac.ffmpeg.org/wiki/Map) for additional information

## Video Processing

Any video filters or CODEC operands, defaults to copy but can also default to a standard for encoding a source DVD or Blu-ray disc. Appends the `-movflags +faststart` to the end to set the MOOV atom to front of video for Internet streaming 
to make Plex and other streaming software happy.


### Filters

If the source video file contains interlaced frames it is either a fully interlaced video (usually a direct to video movie) or it is a film that has been telicined to convert the frame rate of films to NTSC which is a standard for television. 
To remove the interlaced content requires either deinterlacing or inverse telecine/pullup.

If all the frames look interlaced use the [yadif](https://ffmpeg.org/ffmpeg-all.html#yadif-1) filter to remove the interlacing. There are some hybrid formats were only deinterlacing will work, use the [yadif](https://ffmpeg.org/ffmpeg-all.html#yadif-1) filter on those.

If only some of the frames look interlaced use the [pullup](https://ffmpeg.org/ffmpeg-all.html#pullup-1) pulldown reversal (inverse telecine) filter, capable of handling mixed hard-telecine, 24000/1001 fps progressive, and 30000/1001 fps 
progressive content. To produce content with an even framerate, insert the [fps](https://ffmpeg.org/ffmpeg-all.html#fps-1) filter after pullup, use fps=24000/1001 if the input frame rate is 29.97fps, fps=24 for 30fps and the (rare) telecined 25fps input.

The [scale](https://ffmpeg.org/ffmpeg-all.html#scale-1) filter is used to scale (resize) the input video.

The [crop](https://ffmpeg.org/ffmpeg-all.html#crop) filter will crop the input video to given dimensions.

### CODEC

I use AVC exclusively for compatibility for all video encoding until one of the three competing new formats wins out and then I will begin using the winner. Almost all of my video reencoding is Blu-ray to 720p HD or DVD as a source. The same CODEC parameters are used for all reencoding. There are only two parameters that may change:

- The Constant Rate quality Factor, `-crf`, can be adjusted to preference. Values of 20 to 18 are recommended for DVD source and 23 to 20 for 720p HD output.
- The `-tune` value is usually `film` but can also be `animation` if you are, for example, encoding your collection of Anime or The Simpsons.
- The `-level` value of 3.1 I (and others agree) is most compatible for 720p HD and lower resolutions. Some disagree and will use 4.0 or 4.1 for additional compression of the output file. Check what is supported by your devices and use the lowest level supported.

Example: `-c:v libx264 -preset veryslow -crf 18 -tune film -profile:v high -level 3.1`

### Examples

- `-vf pullup,fps=24000/1001,crop=x=0:y=6:w=852:h=462 -c:v libx264 -preset veryslow -crf 18 -tune film -profile:v high -level 3.1` 
- `-vf yadif,crop=x=0:y=6:w=852:h=462 -c:v libx264 -preset veryslow -crf 18 -tune film -profile:v high -level 3.1` 
- `-vf scale=1280:720 -c:v libx264 -preset veryslow -crf 21 -tune film -profile:v high -level 3.1` 
- `-vf scale=1280:720,crop=y=6:h=462 -c:v libx264 -preset veryslow -crf 21 -tune film -profile:v high -level 3.1` 

## Metadata

Metadata to pass, defaults to setting the language to English and nothing else.

Read [FFmpeg Metadata](https://wiki.multimedia.cx/index.php/FFmpeg_Metadata#QuickTime.2FMOV.2FMP4.2FM4A.2Fet_al.) on the [MultimediaWiki](https://wiki.multimedia.cx/index.php/Main_Page) for supported metadata. I usually include the following:

-  `title`
-  `author` - director and writer(s)
-  `year`
-  `comment` - "tagline" for movies or special notes for TV
-  `genre` - comma separated values i.e. Horror, Comedy (does anyone know what actually should go here i.e. only singular values or ; separated values ???)
-  `synopsis` - depends; is usual the text at the top of IMDB and same as description or if there is a detailed synopsis of the content place the short version in description and long one here
-  `description` - see above
-  `show` - TV value or blank for movies
-  `episode_id` - ""
-  `network` - ""

## Audio Processing

Any audio filters or CODEC operands, defaults to copy but can also default to a standard similar to video.

I use a single stereo audio track encoded with the AAC CODEC at a bit rate of 160k. 
If the source video a favorite and/or has a very good soundtrack/audio quality I will usually include the extra AC3 track so I can get the full range of audiophile goodness on devices that support it. 
I find that tablets, phones and other devices will automatically convert the AC3 track to AAC instead of picking the AAC track but that can be configured on both the client and server I believe.

### Filters

The only filter I use is [dynaudnorm](https://ffmpeg.org/ffmpeg-all.html#dynaudnorm) when encoding the AAC track to "even out" the volume of quiet and loud sections, in the sense that the volume of each section is brought to the same target level.

According to [Rokoding](http://rokoding.com) the gain on the AAC track should be set to 2 for AC3 and 3 for DTS input tracks, which would require the [volume](https://ffmpeg.org/ffmpeg-all.html#volume) filter i.e. `volume=volume=2dB:precision=fixed`.

### CODEC

Instead of going through the various audio CODECs and what to do, cannot do, which one is better than the other, etc. might be best to simply provide explanations for the examples provided below:

-  my default AAC audio, simple and minimal
-  same as above with not one but two commentary tracks added
-  my default adjusted for [Rokoding](http://rokoding.com) assuming gain for an AC3 source audio track
-  same as above but for a DTS source audio track
-  default AAC audio plus an AC3 track as is from the source
-  default AAC audio plus an AC3 track reencoded to a 384k bit rate for smaller size but still good minimal quality 
-  default AAC audio plus an AC3 track converted from DTS with recommended 640k bit rate
-  default AAC audio plus an AC3 track converted from DTS with 384k bit rate for smaller size but still good minimal quality

### Examples

```
-ac 2 -filter:a dynaudnorm -c:a aac -b:a 160k -metadata:s:a:0 title="Stereo"
-ac 2 -c:a aac -filter:a:0 dynaudnorm -b:a:0 160k -metadata:s:a:0 title="Stereo" -b:a:1 128k -metadata:s:a:1 title="Commentary" -b:a:2 128k -metadata:s:a:2 title="Additional Commentary"
-ac 2 -filter:a volume=volume=2dB:precision=fixed,dynaudnorm -c:a aac -b:a 160k -metadata:s:a:0 title="Stereo"
-ac 2 -filter:a volume=volume=3dB:precision=fixed,dynaudnorm -c:a aac -b:a 160k -metadata:s:a:0 title="Stereo"
-ac:a:0 2 -filter:a:0 dynaudnorm -c:a:0 aac -b:a:0 160k -metadata:s:a:0 title="Stereo" -c:a:1 copy -metadata:s:a:1 title="Dolby Digital 5.1"
-ac:a:0 2 -filter:a:0 dynaudnorm -c:a:0 aac -b:a:0 160k -metadata:s:a:0 title="Stereo" -c:a:1 ac3 -b:a:1 384k -metadata:s:a:1 title="Dolby Digital 5.1"
-ac:a:0 2 -filter:a:0 dynaudnorm -c:a:0 aac -b:a:0 160k -metadata:s:a:0 title="Stereo" -c:a:1 ac3 -b:a:1 640k -metadata:s:a:1 title="Dolby Digital 5.1"
-ac:a:0 2 -filter:a:0 dynaudnorm -c:a:0 aac -b:a:0 160k -metadata:s:a:0 title="Stereo" -c:a:1 ac3 -b:a:1 384k -metadata:s:a:1 title="Dolby Digital 5.1"
```

## Output Video File
The full name of the output video file without the extension; example `Dexter - S01E01 - Dexter`

# Resources

- [Rokoding](http://rokoding.com)
- [FFmpeg Wiki](https://trac.ffmpeg.org/wiki)
- [FFmpeg Full Documentation](https://ffmpeg.org/documentation.html)
- [MultimediaWiki](https://wiki.multimedia.cx/index.php/Main_Page)

Video

- [H.264 Video Encoding Guide](https://trac.ffmpeg.org/wiki/Encode/H.264)

Audio

- [AAC CODEC](https://trac.ffmpeg.org/wiki/Encode/AAC)
- [Guidelines for high quality lossy audio encoding](https://trac.ffmpeg.org/wiki/Encode/HighQualityAudio)
- [Manipulating audio channels](https://trac.ffmpeg.org/wiki/AudioChannelManipulation)
- [Audio Volume Manipulation](https://trac.ffmpeg.org/wiki/AudioVolume)
