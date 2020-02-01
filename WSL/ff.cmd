NET USE S: "\\192.168.0.144\_TODO" /P:NO
NET USE T: "\\192.168.0.144\_DONE" /P:NO
bash -c "cd;. ff"
NET USE S: /DELETE
NET USE T: /DELETE
SHUTDOWN /S /T 0 /D P:00:00 /C "Done encoding stuff"