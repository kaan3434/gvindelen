<?php
  include "bwin_xml.php";
  require_once"booker_xml.php";
  
  $booker = new bwin_booker();
  
  $sports = $booker->getSports();
  
  print $sports->asXML();

  $tournirs = $booker->getTournirs(10);
  
  print $tournirs->asXML();
  
  $tournir_id = (string) $tournirs->Tournirs->Tournir[0]['Id'];
  $events = $booker->getEvents(10, $tournir_id, null);
  
  print $events->asXML();
  
?>
