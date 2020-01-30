BEGIN {
 FS="\t"; OFS=" ";
}
{
 $1 = "ffmpeg -i \"/mnt/_TODO/" $1 "\" -f mp4";
 if (! length($2)) $2 = "-map 0:v -map 0:a";
 if (! length($3)) $3 = "-c:v copy"; $3 = $3 " -movflags +faststart"
 if (length($4)) $4 = $4 " "; $4 = $4 "-metadata language=eng"
 if (! length($5)) $5 = "-c:a copy";
 $6 = "\"/srv/DONE/" $6 ".mp4\"";
 print
}
