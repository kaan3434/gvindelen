<?php 
function db_connect() {
  $hostname = "localhost";
  $username = "root";
  $password = "graf";
  $dblink = mysql_connect($hostname, $username, $password) or die("База данных недоступна");
  $dbname = "otto";
  mysql_select_db($dbname, $dblink);
  mysql_query ('SET CHARACTER SET UTF8');
  mysql_query("SET NAMES UTF8");
  return $dblink;  
}
  
?>