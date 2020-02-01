<##
 # ff.ps1 - Windows PowerShell version of the "Rendering Farm"
 #
 # @author  jmathias@cscc.edu (Joel Mathias)
 # @created 08/25/19
 # @updated 01/25/20 jmathias@cscc.edu - moved to GitHub and documented
 # @updated 01/31/20 jmathias@cscc.edu - finished
 #
 #>
$todoDir = "S:\"
$workDir = "C:\WORK\"
$todoFile = $todoDir + "ffmpeg.todo"

if (!((Test-Path $todoFile -PathType Leaf) -and (Test-Path $workDir -PathType Container))) {
    Write-Host "todo or work folders/files not found; aborted everything"
    exit
}
$doneDir = "T:\"

Write-Host "Starting..."
while (((Get-Item -Path $todoFile).Length) -gt 0) { 
    $todo =	Get-Content -Path $todoFile
#	^^^^^   Get-Content returns an array for more than one line but a non-array if only one line
    if ($todo -is [array]) {
        $l = ($todo[0]).Split("`t") # split line 1 by tabs into array
        $todo[1..($todo.Length-1)] | Out-File -FilePath $todoFile -Encoding ascii # -Confirm # write todo file back out minus line 1
    } else {
        $l = $todo.Split("`t")
        New-Item -Path $todoFile -Force -ItemType File > null
    }
    $l[0] = $todoDir+$l[0]
    if ((Test-Path $l[0] -PathType Leaf)) {

    # set defaults
        if ($l[1] -eq "") { $l[1] = "-map 0:v -map 0:a" } # default mapping of file 1 audio and video
        if ($l[2] -eq "") { $l[2] = "-c:v copy" } # default to copy video stream
        if ($l[3] -ne "") { $l[3] += ' ' } # if metadata provided, add a space for language setting
        if ($l[4] -eq "") { $l[4] = "-c:a copy" } # default to copy audio stream ? not needed ? ffmpeg default is to copy ?

    # augment parts of the command line
        Write-Host (Get-Date -Format 'MMdd HHmmss') $l[0] $l[5]
        $l[0] = ('-i "'+$l[0]+'" -f mp4') # create input file argument
        $l[2] += " -movflags +faststart" # set moov atom to front of video for internet streaming to make Plex happy
        $l[3] += "-metadata language=eng"
        $l[5] = '"'+$workDir+$l[5]+'.mp4"' # set output file argument

    # run FFmpeg
        Start-Process -FilePath 'C:\DOS\bin\ffmpeg.exe' -ArgumentList $l -Wait -WindowStyle Maximized;
        Write-Host (Get-Date -Format 'MMdd HHmmss')

    # if doneDir is available, move the file there
        if (($doneDir -ne "") -and (Test-Path $doneDir -PathType Container)) {
            $l[5] = $l[5].Replace('"','')
            if (Test-Path $l[5] -PathType Leaf) {
                Move-Item -Path $l[5] -Destination $doneDir -Force 
            }
        }

    } else {
        Write-Host $l[0] "not found; aborted encode"
    }
} 
Write-Host "Done..."
# Shutdown-Computer