<?php

if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

if(isset($_SESSION['userName'])){
  unset($_SESSION['userName']);
}

mysqli_close($connDB);

header("Location: index.php");
?>