<?php
  include "bwin_xml.php";
  require_once "olymp_xml.php";
  
  $booker = new olymp_booker();
  $booker->debug = 1;
  
  //$sports = $booker->getSports();
  
//  print $sports->asXML();

  //$tournirs = $booker->getTournirs(10);
  
//  print $tournirs->asXML();
  
  $tournir_id = '29.68c6824d4a82dee51ee4e5fc228dbb92';
  $events = $booker->getEvents(20, $tournir_id, null);
  
//  print $events->asXML();
  
?>
