<?php
  $xml = new SimpleXMLElement("<Scan/>");

function getLine($Booker) {
  global $xml;  
   if ($Booker == 'bwin') {
     include 'bwin_xml.php';
     $sport_node = $xml->addChild('Sport', 'Теннис');
     scan_bwin_line('tennis', 33); // 1_2
     scan_bwin_line('tennis', 36); // Total
   }
   
   
   return $xml->asXML();
}

  ini_set("soap.wsdl_cache_enabled", "0");
  $server_name = $_SERVER['SERVER_NAME'];
  $server = new SoapServer("swim4.wsdl");
  $server->addFunction("getLine");
  $server->handle;
?>
