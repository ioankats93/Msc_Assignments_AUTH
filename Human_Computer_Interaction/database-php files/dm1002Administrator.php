<?php
  	session_start();
    include ('dm1002ConfigDB.php');
?>

<!--Auto Refresh Page PHP-->
<?php
  $page = $_SERVER['PHP_SELF'];
  $sec = "120";
?>

<!DOCTYPE html>
<html>

<head>  
    <title>ΔΜ1002 Εργασία 2018</title>
    <!--Auto Refresh Page HTML-->
    <meta http-equiv="refresh" content="<?php echo $sec?>;URL='<?php echo $page?>'"> 
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="http://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="http://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>

    <script type="text/javascript" src="js/jvsFunctions.js"></script>

    <link href="css/styles.css" rel="stylesheet" type="text/css" />
    <link rel='shortcut icon' type='image/x-icon' href='images/favicon.ico'/>
</head>

<style>
      /* Always set the map height explicitly to define the size of the div
       * element that contains the map. */
      #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        position: relative; 
      }
  #section1 {padding-top:50px;padding-bottom:50px;height:600px;color: #000; background-color: #fff;}
  #section2 {padding-top:50px;height:500px;color: #000; background-color: #fff;}
  #section3 /*{padding-top:50px;height:500px;color: #000; background-color: #fff;}*/
  #section41 {padding-top:50px;height:500px;color: #fff; background-color: #00bcd4;}
  #section42 {padding-top:50px;height:500px;color: #fff; background-color: #009688;}
</style>
    
<body data-spy="scroll" data-target=".navbar" data-offset="50">
    
<div id="section3" class="container-fluid" style="background-color:#d1e3ea; color:#330033; height:140px;">
        <div class="row">
            <div class="col-sm-2 text-right">
            <br>
              <a href="#">  
                <img style="vertical-align: left;  max-height: auto; max-width: 55%;" src="images/logoAUTH.png">
              </a>  
            </div>
            
            <div class="col-sm-8 text-center">                      
                <h3><b>Αριστοτέλειο Πανεπιστήμιο Θεσσαλονίκης</b></h3>
                <h4><b>Διατμηματικό ΠΜΣ στα Προηγμένα Συστήματα Υπολογιστών και Επικοινωνιών</b></h4>
                <h4><b>Μάθημα</b></h4>
                <h4><b>Υπολογιστικά Συστήματα και Αλληλεπίδραση με το Χρήστη</b></h4>
            </div>
        </div>
</div>
    
<nav class="navbar navbar-inverse" data-spy="affix" data-offset-top="197">
  <div class="container-fluid">
    <ul class="nav navbar-nav navbar-right">
    <?php
            if (isset($_SESSION['userName'])){
              echo '<script type="text/javascript">',
              'fnHideShow();',
              '</script>';
              echo '<li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                    <span class="glyphicon glyphicon-user"></span>'.' '.$_SESSION['name'].' 
                    </a>
                    <ul class="dropdown-menu">
                      <li><a href="dm1002LogOut.php" onclick="fnHideShow()"><span class="glyphicon glyphicon-log-out"></span>'.' Αποσύνδεση</a></li>   
                    </ul>
                    </li>';          			
            }
            else
    				{
    				  echo '<li><a data-toggle="modal" href="#logInModal"><span class="glyphicon glyphicon-log-in"></span> Είσοδος</a></li>';
    				}
        ?>    
    </ul>
    <ul class="nav navbar-nav">
      <li><a href="index.php">Αρχική</a></li>
      <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Προβολή <span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="#section1">Χάρτης</a></li>
          <li><a href="#section2">Πίνακας Σημείων</a></li>
        </ul>
      </li>
      <?php
            if (isset($_SESSION['userName'])){
              echo '
              <li class="active"><a href="#section3"> Διαχείριση</a></li>';          			
            }
            else
    				{
    				  echo '';
    				}
        ?>    
    </ul>

  </div>
</nav>

<div id="section1" class="container-fluid">
  <h1>Ανασκόπηση Δήμου Θεσσαλονίκης</h1>
  
  <div id="map"></div>

<script>
  var customLabel = {
    Small_Pothole: {
      label: 'Μικρή Λακούβα'
    },
    Big_Pothole: {
      label: 'Μεγάλη Λακούβα'
    }
  };

    function initMap() {
    var map = new google.maps.Map(document.getElementById('map'), {
      center: new google.maps.LatLng(40.628163, 22.95836),
      zoom: 14
    });
    var infoWindow = new google.maps.InfoWindow;

      // Change this depending on the name of your PHP or XML file
      downloadUrl('dm1002XMLParser.php', function(data) {
        var xml = data.responseXML;
        var markers = xml.documentElement.getElementsByTagName('marker');
        Array.prototype.forEach.call(markers, function(markerElem) {
          var id = markerElem.getAttribute('id');
          var name = markerElem.getAttribute('name');
          var address = markerElem.getAttribute('address');
          var type = markerElem.getAttribute('type');
          var point = new google.maps.LatLng(
              parseFloat(markerElem.getAttribute('latitude')),
              parseFloat(markerElem.getAttribute('longitude')));

          var infowincontent = document.createElement('div');
          var strong = document.createElement('strong');
          strong.textContent = name
          infowincontent.appendChild(strong);
          infowincontent.appendChild(document.createElement('br'));

          var text = document.createElement('text');
          text.textContent = address
          infowincontent.appendChild(text);
          var icon = customLabel[type] || {};
          var marker = new google.maps.Marker({
            map: map,
            position: point,
            label: icon.label
          });
          marker.addListener('click', function() {
            infoWindow.setContent(infowincontent);
            infoWindow.open(map, marker);
          });
        });
      });
    }

  function downloadUrl(url, callback) {
    var request = window.ActiveXObject ?
        new ActiveXObject('Microsoft.XMLHTTP') :
        new XMLHttpRequest;

    request.onreadystatechange = function() {
      if (request.readyState == 4) {
        request.onreadystatechange = doNothing;
        callback(request, request.status);
      }
    };

    request.open('GET', url, true);
    request.send(null);
  }

  function doNothing() {}
</script>
<script async defer
src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVlQlLq2a19uu0dBL-8J-7feEmplYjRc0&callback=initMap">
</script>
<br><br>
</div>

<div id="section2" class="container-fluid">
  <h1>Πίνακας Σημείων</h1>

<div class="col-sm-12 text-center"> 
  <form name="repairedHoles" class="form-horizontal" action="dm1002AdminChangeLk.php" method="post">
    <div id="centerContainer">               
    <table id="grid" class="table table-striped">
      <thead>
        <tr>
          <th class="text-center" data-field="id">Α/Α</th>
          <th class="text-center">Ημερομηνία</th>
          <th class="text-center">Χρήστης</th>
          <th class="text-center">Διεύθυνση</th>
          <th class="text-center">Τύπος</th>
          <th class="text-center">Επισκευή</th>
        </tr>
      </thead>
      <tbody>
        <?php
          $query = "SELECT * from markers ORDER BY id DESC"; 
          $result = mysqli_query($connDB, $query);
          $num = mysqli_num_rows($result); 
  
            if ($num !=0){
              while($row = mysqli_fetch_array($result)){
                if($row['repaired']=="ΟΧΙ"){
                  echo '<tr data-item="action1">
                          <td> '. $row['id'] .' <a href="dm1002Administrator.php?id='.$row['id'].'"> </td>
                          <td class="text-Left"> '. $row['timestamp'] .' </td>
                          <td class="text-Left"> '. $row['name'] .' </td>
                          <td class="text-Left"> '. $row['address'] .' </td>
                          <td class="text-Left"> '. $row['type'] .' </td>
                          <td><select name="slcRepaired['.$row['id'].']" class="combobox form-control">';                          
                            echo '<option value="" selected="selected">Επισκευάστηκε;</option>';
                            echo '<option value="ΝΑΙ">ΝΑΙ</option>';
                            echo '<option value="ΟΧΙ">ΟΧΙ</option>';
                            echo '</select></td>';
                  echo '</tr>';                           
                }
              }
            }                       
        // Close connection
        mysqli_close($connDB);
        ?> 
      </tbody>
    </table>
    </div>
    <div class="form-group">
      <div class="col-sm-9"></div>              
        <div class="col-sm-3">
          <button type="submit" name="updateRepaires" class="btn btn-primary btn-lg">Καταχώρηση</button>
        </div>
    </div><br><br><br><br>
  </form>
</div>
</div>

<!-- ***********Log In*********** -->
  <!-- Log In Modal -->
  <div class="modal fade" id="logInModal">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header" style="padding:35px 50px;">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h3><span class="glyphicon glyphicon-lock"></span> Είσοδος</h3>
        </div>
        <div class="modal-body" style="padding:40px 50px;">
          <form name="loginForm" method="post" role="dialog" onsubmit="return checkLogInForm()" action="dm1002LogIn.php">
            <?php 
              $_SESSION['uri'] = $_SERVER['REQUEST_URI']; 
            ?>
            <div class="form-group">
              <label for="username"><span class="glyphicon glyphicon-user"></span> Όνομα Χρήστη</label>
              <input type="text" class="form-control" name="username" placeholder="Όνομα Χρήστη">
            </div>
            <div class="form-group">
              <label for="password"><span class="glyphicon glyphicon-eye-open"></span> Κωδικός</label>
              <input type="password" class="form-control" name="password" placeholder="Κωδικός Εισόδου">
            </div>

              <button type="submit" class="btn btn-success btn-block"><span class="glyphicon glyphicon-off"></span> Είσοδος</button>
          </form>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-danger btn-default pull-left" data-dismiss="modal"><span class="glyphicon glyphicon-remove"></span> Ακύρωση</button>
        </div>
      </div>
      
    </div>
  </div> 
</div>



<footer class="container-fluid text-center">
  <p><font color="red"><a data-toggle="modal" href="#myModal" style="text-decoration: none">
      Ομάδα εργασίας 1 &copy 2018</font></a></p>
</footer>

  <!-- Modal -->
<div id="myModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title"><span class="glyphicon glyphicon-education">
        Ομάδα Εργασίας 1</span></h4>
      </div>
      <div class="modal-body">
        <p><span class="glyphicon glyphicon-user">
        Παυσανίας Κακαρίνος
        </span></p>
        <p><span class="glyphicon glyphicon-user">
        Ιωάννης Κατσικαβέλας
        </span></p>
        <p><span class="glyphicon glyphicon-user">
        Νικόλαος Γάτσης
        </span></p>
        <p><span class="glyphicon glyphicon-user">
        Ζαχαρίας Τσουραλάκης
        </span></p>
       
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>

</body>

</html>

