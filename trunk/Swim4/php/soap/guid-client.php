<?php
  ini_set('soap.wsdl_cache_enabled', 'Off');
  $soap = new SoapClient('guid.wsdl');
  echo $soap->getGuid('PHP_');  
?>
