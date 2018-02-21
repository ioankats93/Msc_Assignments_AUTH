<?php

error_reporting(E_ALL ^ E_DEPRECATED ^ E_NOTICE ^ E_STRICT);
   $server = 'webpagesdb.it.auth.gr';
   //$server = 'localhost';
   $userName = 'dm1002User';
   $passWord = 'dm1002User!!';
   $dbname = 'dm1002Prj';

$connDB = mysqli_connect($server, $userName, $passWord, $dbname);

if(! $connDB ) {
    die("connection failed!!! " . $connDB->connect_error);
}

mysqli_set_charset($connDB,"utf8");
?>