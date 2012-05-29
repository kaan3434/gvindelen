<?php
  include "bwin_xml.php";
  require_once "olymp_xml.php";
  
  $booker = new olymp_booker();
  
  //$sports = $booker->getSports();
  
//  print $sports->asXML();

  //$tournirs = $booker->getTournirs(10);
  
//  print $tournirs->asXML();
  
  $tournir_id = '26.69222ee6d2710d8885fca1de63b9804e';
  $events = $booker->getEvents(10, $tournir_id, null);
  
//  print $events->asXML();
  
?>
