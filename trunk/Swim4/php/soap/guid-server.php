<?php
  ini_set('soap.wsdl_cache_enabled',  'Off');
 
function getGuid($prefix)
{
    return uniqid($prefix);
}
 
$soap = new SoapServer('guid.wsdl');
 
$soap->addFunction('getGuid');
 
$soap->handle();
?>
