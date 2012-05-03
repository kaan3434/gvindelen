<?php
  include "bwin_xml.php";
  require_once "olymp_xml.php";
  
  $booker = new olymp_booker();
  
  $sports = $booker->getSports();
  
//  print $sports->asXML();

  $tournirs = $booker->getTournirs(10);
  
//  print $tournirs->asXML();
  
  $tournir_id = (string) $tournirs->Tournirs->Tournir[0]['Id'];
  $events = $booker->getEvents(10, $tournir_id, null);
  
//  print $events->asXML();
  
?>
