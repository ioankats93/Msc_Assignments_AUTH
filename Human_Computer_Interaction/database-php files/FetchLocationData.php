<?php

$sql = "SELECT * FROM markers";

require_once('dm1002ConfigDB.php');

$r = mysqli_query($connDB,$sql);

$result = array();

while($row = mysqli_fetch_array($r)){
  array_push($result, array(
    'name'=>$row['name'],
    'longitude' =>$row['longitude'],
    'latitude'=>$row['latitude'],
    'type'=>$row['type']
  ));
}

echo json_encode(array('result'=>$result));

mysqli_close($connDB);

?>