<?php 
require "dm1002ConfigDB.php";
$id = $_POST["id"];
$name = $_POST["name"];
$address = $_POST["address"];
$lat = $_POST["lat"];
$lng = $_POST["lng"];
$type = $_POST["type"];

$queryDB = "INSERT INTO 'markers' ('id', 'name', 'address', 'lat', 'lng', 'type') 
                VALUES ('$id', '$name', '$address', '$lat', '$lng', '$type');";

if($connDB -> query($queryDB) === TRUE) {
echo "Επιτυχής Αποστολή";
}
else {
echo "Σφάλμα :" . $mysql_qry ."<br>" . $connDB -> error;
}
$connDB -> close();
?>