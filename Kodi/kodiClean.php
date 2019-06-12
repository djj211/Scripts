#!/usr/bin/php5
<?php
$logFile = fopen("/home/stud/Scripts/logs/cleanLogs.log","a"); 
fwrite($logFile,"----Running KodiClean----\n");
$success = "Success";

$date = date('Y/m/d H:i:s');

fwrite($logFile,"Starting Script at " . $date . "\n");

$servername = "localhost";
$username = "root";
$password = "Studm@n1!";
$dbname = "MyVideos99";

fwrite($logFile,"Connecting to Kodi Database...\n");
// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    fwrite($logFile,"Failed to connect to Kodi database: " . $conn->connect_error . "\n");
    fwrite($logFile, "Script Failure\n"); 
    die("Connection failed: " . $conn->connect_error);
} 

fwrite($logFile, "Kodi Database Connection Sucessful!\n");

fwrite($logFile, "Getting Delete Files...\n");

$sql = "SELECT c18, idEpisode FROM episode_view a WHERE DATE_SUB(CURDATE(),INTERVAL 30 DAY) >= a.lastplayed AND playCount > 0";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
	$episodeFile = $row[c18];
	$episodeId = $row[idEpisode];
if (is_dir($episodeFile)) {
        fwrite($logFile, "This is a directory. Delete Directory: " . $episodeFile . " From Drive\n");
        $deltedDirectory = deleteDirectory($episodeFile);
	if ($deltedDirectory != 0)
        {
          fwrite($logFile, "Error Deleting Directory: " . $episodeFile . "\n");
          fwrite($logFile, "Error: " . print_r(error_get_last()) . "\n");
          $success = "Failure";
        }
        else
        {
          fwrite($logFile, "Episode Delete Successful!\n");
          $success = "Success";
        }  
}
else {
	fwrite($logFile, "Deleting File: " . $episodeFile . " From Drive\n");
	if (!unlink($episodeFile))
	{
  	  fwrite($logFile, "Error Deleting File: " . $episodeFile . "\n");
	  fwrite($logFile, "Error: " . print_r(error_get_last()) . "\n");
	  $success = "Failure";
	}
	else
  	{
	  fwrite($logFile, "File Delete Successful!\n");
	  $success = "Success";
    	}  
   }
   }
}

fwrite($logFile, "Cleaning Kodi Library\Database on 192.168.1.205...\n");

$cmd="curl --data-binary '{ \"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.Clean\", \"id\": \"mybash\"}' -H 'content-type: application/json;' http://192.168.1.205:8080/jsonrpc";
exec($cmd,$result);

fwrite($logFile, "HTTP Request Complete\n");
fwrite($logFile, "Result: " . $result[0] . "\n");

$conn->close();

$date = date('Y/m/d H:i:s');

fwrite($logFile, "Script Complete at " . $date . "\n");
fwrite($logFile, "Script " . $success . "\n");

function deleteDirectory($dir) {
    echo system('rm -rf ' . escapeshellarg($dir), $retval);
    return $retval; // UNIX commands return zero on success
}
?>
