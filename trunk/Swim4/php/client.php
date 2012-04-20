<?php

  $client = new SoapClient("http://localhost:8080/soap/Scan.wsdl"); 
  print($client->getBookers()); 
?>
