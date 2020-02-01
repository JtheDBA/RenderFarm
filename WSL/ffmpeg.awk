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