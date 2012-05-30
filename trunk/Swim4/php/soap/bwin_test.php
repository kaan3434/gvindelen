<?php
  include "bwin_xml.php";
  require_once"booker_xml.php";
  
  $booker = new bwin_booker();
  
//  $sports = $booker->getSports();

//  $tournirs = $booker->getTournirs(20);
  
//  foreach($tournirs->Tournirs->children() as $element_name=>$child) {
//    $tournir_id = (string) $child['Id'];
//    $events = $booker->getEvents(20, $tournir_id, '');
//  }

    $tournir_id = '251';
    $events = $booker->getEvents(20, $tournir_id, '');
  
?>
