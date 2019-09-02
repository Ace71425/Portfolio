<?php

		$servername = "mysql.hostinger.com";
		$username = "u714229577_busa";		
		$password = "PFOAccess12#";
		$dbName = "u714229577_busa";
		
	
	//Make Connection
	$db = new mysqli($servername, $username, $password, $dbName);
	//Check Connection
	if(!$db){
		die("Connection Failed. " . mysqli_connect_error());
	}
	
	$nouser = "userNIS";
	
	$name = mysqli_real_escape_string($db, $_GET['name']);
	$hash = $_GET['hash'];
	$secretKey="noHackMe71425";
	
	$real_hash = md5($name . $secretKey);
	
	if($real_hash == $hash) { 

	$query = "SELECT * FROM `Stats` WHERE User_ID = '$name'";
	$result = mysqli_query($db, $query) or die('Query failed: ' . mysqli_error());
 
    $num_results = mysqli_num_rows($result);  
	
	if ($num_results == 0)
	{
		echo $nouser;
	}	
 
    for($i = 0; $i < $num_results; $i++)
    {
         $row = mysqli_fetch_array($result);
		 echo $row['Wins'] . " ";
		 echo $row['Losses'] . " ";		
		 echo $row['PF'] . " ";			 
         echo $row['PA'];	
	}	
	
	}
	
?>