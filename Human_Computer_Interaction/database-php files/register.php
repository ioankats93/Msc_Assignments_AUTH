<?php
                $name = $_GET['name'];
                $longitude = $_GET['longitude'];
                $latitude = $_GET['latitude'];
                $type = $_GET['type'];
                //$address = $_GET['address'];
                $formattedDate = date("Y-m-d H.i.s");

                $address= getaddress($latitude,$longitude);
                if($address)
                {
                  echo $address;
                }
                else
                {
                  echo "Posted without address";
                }

                // Require Name

                if($name == ''
                        ){
                        echo 'please fill Name';
                }else{
                        require_once('dm1002ConfigDB.php');
                        $sql = "SELECT * FROM markers WHERE longitude='$longitude' OR latitude='$latitude'";

                        $check = mysqli_fetch_array(mysqli_query($connDB,$sql));

                        if(isset($check)){
                                echo 'This Pothole is registered';
                        }else{
                                $sql = "INSERT INTO markers(name, timestamp, address, longitude, latitude, type) 
                                            VALUES('$name', '$formattedDate', '$address','$longitude','$latitude','$type')";
                                if(mysqli_query($connDB,$sql)){
                                        echo ' successfully registered';
                                }else{
                                        echo ' oops! Please try again!';
                                }
                        }
                        mysqli_close($connDB);
                }

?>

<?php
  function getaddress($latitude,$longitude)
  {
     $url = 'http://maps.googleapis.com/maps/api/geocode/json?latlng='.trim($latitude).','.trim($longitude).'&sensor=false';
     $json = @file_get_contents($url);
     $data=json_decode($json);
     $status = $data->status;
     if($status=="OK")
     {
       return $data->results[0]->formatted_address;
     }
     else
     {
       return false;
     }
  }
?>