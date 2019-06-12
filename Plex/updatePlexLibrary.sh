#!/bin/sh
runTime=$(date)
server="192.168.1.188"
tvDirId="1"
movieDirId="2"
plexToken="aFxpwvW3j6Zk3WkR22mb"

echo "----Running updatePlexLibrary.sh Version 1----" >> /home/dan/Scripts/logs/updateLog.log
echo "Starting Update Script at " $runTime >> /home/dan/Scripts/logs/updateLog.log
echo "Updating TV Directory " $tvDir "on " $server >> /home/dan/Scripts/logs/updateLog.log

result=`curl http://$server:32400/library/sections/$tvDirId/refresh?X-Plex-Token=$plexToken`

if [ ! -z "$result" -a "$result" != " " ]; then

        echo "TV update Results: Failure"  >> /home/dan/Scripts/logs/updateLog.log
        echo "TV update Failure" >> /home/dan/Scripts/logs/updateLog.log
else
        echo "TV Update Result: Success" >> /home/dan/Scripts/logs/updateLog.log
        echo "TV Update Successful" >> /home/dan/Scripts/logs/updateLog.log

fi

sleep 30

echo "Updating Movie Directory " $movieDir "on" $server >> /home/dan/Scripts/logs/updateLog.log

result=`curl http://$server:32400/library/sections/$movieDirId/refresh?force=1\&X-Plex-Token=$plexToken`

if [ ! -z "$result" -a "$result" != " " ]; then
        echo "Movie update Results: Failure" >> /home/dan/Scripts/logs/updateLog.log
        echo "Movie update Failure" >> /home/dan/Scripts/logs/updateLog.log

else
        echo "Movie Update Results: Success" >> /home/dan/Scripts/logs/updateLog.log
        echo "Movie Update Successful" >> /home/dan/Scripts/logs/updateLog.log
fi

endTime=$(date)

echo "Script Complete at" $endTime >> /home/dan/Scripts/logs/updateLog.log
