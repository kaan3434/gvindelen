<?php
  $client = new SoapClient("swim4.wsdl"); 
  print($client->getLine("bwin1")); 
?>
