# Render Farm FF Workbook

The FF workbook is used to help automate the process of creating the values to be placed in the [ffmpeg.todo](ffmpeg.todo.md). It contains three worksheets:

-  Configuration
-  Movies
-  TV

Please note: this uses Office 365 and functions available only in the Office 365 version of Excel. I use this version at home and it seems to be the direction Microsoft is heading. 
I also saved the workbook in Open Document Format if somebody would like to attempt to make it work that would be just super.

## Configuration

### Video Base Encoding Lookup Table

This named range of cells is used to store a tag and associated video filters and video CODEC information to standardize most reencoding processes. Both the Movies and the TV worksheets use this named range of cells as a base 
for most encoding. Personally, I do not encode in 1080 Blu-ray or higher but feel free to add them to your copy of the workbook if you do.

### Audio Base Encoding Lookup Table

This named range of cells is used story tag and associated audio filters and audio CODEC information to standardize most values used for either copying or converting audio tracks to a different format. I do not have any tags for encoding 
or reencoding DTS due to lack of support for most of the devices I use at home to play the converted videos. Obviously if you wish to change this feel free to do so on your own copy of the workbook.

### Additional Video Filter Builder

The filter builder is a simplistic attempt to provide commonly used filters and their commonly used values tell simplify the addition of them into the standard data used for the encoding to do file. I also tried to keep the filters in 
order of use from left to right.

Values in the orange cells are used to build the filter. Values in the light red cells are computed values. Values in the light blue cells need to be valued by you to determine the results placed into the light red cells. Very light blue 
cells contain values that could be typed or equated to those in the orange cells. The following filters are available:

-  denoise: `atadenoise` is the only one I have found useful
-  scale: enter the width and height
-  crop: enter the left and top crop points then the width and height of the final output
-  flip: rarely seen but I have used both before
-  fade: enter the length of the entire video then the seconds to fade in and/or the number of seconds to fadeout

## Movies

Blue cells are required. Light blue cells are optional and may have defaults or may simply be omitted from the encoded video. Light orange cells contain calculated values. Light green cells can be copied and pasted 
into the [ffmpeg.todo](ffmpeg.todo.md) file. Explanation for cells:

**Input file** is the name of the source file. If you omit a file extension a .mkv extension will be added for you assuming you used a source to MKV  program create the source videos.

The following items are metadata placed into the metadata of the encoded video file but are also used to create the name of the encoded output file:

-  title: the title of the movie
-  year: the year of the movie
-  genre: one or more genres for the movie delimited by commas
-  description: a short description of the movie
-  author: can be the director, the writers, etc.
-  comment: can indicate a special edition of the source or the movie tagline
-  synopsis: a full description of the movie

The following items control how the source video and audio are encoded:

-  **Video** must be one of the tags from the Configuration Video Base Encoding Lookup Table
-  **audio 0** defaults to AAC for audio stream 0 but may also contain the source stream number followed by a from the Configuration Audio Base Encoding Lookup Table
-  **audio 1-5** are optional but if valued must contain the source stream number followed by a from the Configuration Audio Base Encoding Lookup Table

The cell above **Override Video** can be used to override the value generated from the tag above. A copy and paste values can be used to template before adding additional filters to the final result.

## TV

This worksheet can be used to create text inserted into the [ffmpeg.todo](ffmpeg.todo.md) file for one or more episodes of a television series.

Blue cells are required. Light blue cells are optional and may have defaults or may simply be omitted from the encoded video. Light orange cells contain calculated values. Light green cells can be copied and pasted 
into the [ffmpeg.todo](ffmpeg.todo.md) file. Explanation for cells:

-  **Title** is the title of the series followed by titles of the individual episodes being encoded and are required for both metadata and for generation of the output filename
-  **Season** if left blank on the episode level then season number must be in the series season cell
-  **E**: the episode number and if blank defaults to the sequential number from the top
-  **Input File**: name of the source file; if you omit a file extension a .mkv extension will be added for you assuming you used a source to MKV program create the source videos
-  **Video**: must be one of the tags from the Configuration Video Base Encoding Lookup Table
-  **Audio 0**: defaults to AAC for audio stream 0 but may also contain the source stream number followed by a tag from the Configuration Audio Base Encoding Lookup Table
-  **Audio 1**: optional but if valued must contain the source stream number followed by tag a from the Configuration Audio Base Encoding Lookup Table
-  **description**: a short description of the episode
-  **comment**: can indicate a special edition of the episode or commentary or review of the episode
