<?php

session_start();

include ('dm1002ConfigDB.php');

$formUsername = $_POST['username'];
$formPassword = $_POST['password'];

$query = "SELECT * FROM users WHERE userName = '$formUsername'"; 

$result = mysqli_query($connDB, $query);
$num = mysqli_num_rows($result); 

	if ($num !=0) { 
		$users = mysqli_fetch_row($result);
    	$id = $users[0];
    	$userName = $users[1];
    	$passWord = $users[2];
    	$name = $users[3];  

		if ($formUsername != $userName) { 
			header('Content-Type: text/html; charset=utf-8');
		
			echo '<script language="javascript">alert("Λάθος όνομα χρήστη!"); 
				document.location=" '.$_SESSION['uri'].' "</script>';
			exit();
		} 
		elseif($formPassword != $passWord){
			header('Content-Type: text/html; charset=utf-8');
		
			echo '<script language="javascript">alert("Ο κωδικός που πληκτρολογήσατε είναι λανθασμένος!"); 
				document.location=" '.$_SESSION['uri'].' "</script>';
			exit();	
		}
		else {        
            $_SESSION['id'] = $id;
            $_SESSION['userName'] = $userName;
			$_SESSION['passWord'] = $passWord;
			$_SESSION['name'] = $name;

			$uri = $_SESSION['uri'];
			header("Location:" .$_SESSION['uri']. "");

		}
	}  
	else{
		header('Content-Type: text/html; charset=utf-8');
		
		echo '<script language="javascript">alert("Δεν υπάρχει ο χρήσης στη βάση δεδομένων!"); 
				document.location=" '.$_SESSION['uri'].' "</script>';

		exit();
	}

mysqli_close($connDB);

?>