<?php

include ('dm1002ConfigDB.php');

$slcRepaired = $_POST['slcRepaired'];
$repairedDate = date("Y-m-d H.i.s");;

if($slcRepaired != ''){
    foreach($slcRepaired as $key=>$repaired){  
        if($repaired=="ΝΑΙ"){
             $updateRepaired = "UPDATE markers SET repaired = '$repaired', repairedDate = '$repairedDate' WHERE id = '$key'"; 
        }
        $result = mysqli_query($connDB,$updateRepaired);
    }
        
        if (mysqli_query($connDB, $updateRepaired)) {
            header('Content-Type: text/html; charset=utf-8');
            echo '<script language="javascript">alert("Η επισκευή προστέθηκε με επιτυχία!"); 
            document.location="dm1002Administrator.php"</script>';
        }   
}

mysqli_close($connDB);
?> 