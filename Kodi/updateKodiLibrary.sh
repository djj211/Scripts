#!/bin/sh
runTime=$(date)
server="192.168.1.205"
tvDir="/media/HardDrive/Videos/Television/"
movieDir="/media/HardDrive/Videos/Movies/"

echo "----Running updateKodiLibrary.sh Version 1----" >> /home/stud/Scripts/logs/updateLog.log
echo "Starting Update Script at " $runTime >> /home/stud/Scripts/logs/updateLog.log
echo "Updating TV Directory " $tvDir "on " $server >> /home/stud/Scripts/logs/updateLog.log

result=`curl -v -H "Accept: application/json" -H "Content-type: application/json" -d '{"id":5,"jsonrpc":"2.0","method":"VideoLibrary.Scan","params":{"directory":"/media/HardDrive/Videos/Television/"}}' http://$server:8080/jsonrpc`

if [ ! -z "$result" -a "$result" != " " ]; then
        echo "TV Update Results: " $result >> /home/stud/Scripts/logs/updateLog.log
	echo "TV Update Successful" >> /home/stud/Scripts/logs/updateLog.log
else
	echo "TV update Results: Failure" >> /home/stud/Scripts/logs/updateLog.log
	echo "TV update Failure" >> /home/stud/Scripts/logs/updateLog.log
fi

sleep 30

echo "Updating Movie Directory " $movieDir "on" $server >> /home/stud/Scripts/logs/updateLog.log

result=`curl -v -H "Accept: application/json" -H "Content-type: application/json" -d '{"id":5,"jsonrpc":"2.0","method":"VideoLibrary.Scan","params":{"directory":"/media/HardDrive/Videos/Movies/"}}' http://$server:8080/jsonrpc`

if [ ! -z "$result" -a "$result" != " " ]; then
        echo "Movie Update Results: " $result >> /home/stud/Scripts/logs/updateLog.log
        echo "Movie Update Successful" >> /home/stud/Scripts/logs/updateLog.log
else
        echo "Movie update Results: Failure" >> /home/stud/Scripts/logs/updateLog.log
        echo "Movie update Failure" >> /home/stud/Scripts/logs/updateLog.log
fi

endTime=$(date)

echo "Script Complete at" $endTime >> /home/stud/Scripts/logs/updateLog.log
