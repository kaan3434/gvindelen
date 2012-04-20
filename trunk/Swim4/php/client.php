<?php

  $client = new SoapClient("http://localhost:8080/soap/swim4.wsdl"); 
  print($client->getBookers()); 
?>
