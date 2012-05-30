<?php
  include "bwin_xml.php";
  require_once "marathon_xml.php";
  
  $booker = new marathon_booker();
  
//  $sports = $booker->getSports();
  
//  $tournirs = $booker->getTournirs(20);
//  foreach($tournirs->Tournirs->children() as $element_name=>$child) {
//    $tournir_id = (string) $child['Id'];
//    $events = $booker->getEvents(20, $tournir_id, '');
//  }
    $tournir_id = '386243';
    $events = $booker->getEvents(10, $tournir_id, '');
  
?>
