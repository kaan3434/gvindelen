<?php
  include "bwin_xml.php";
  require_once "olymp_xml.php";
  
  $booker = new olymp_booker();
  
  $tournirs = $booker->getTournirs(20);
  
  foreach($tournirs->Tournirs->children() as $element_name=>$child) {
    $tournir_id = (string) $child['Id'];
    $events = $booker->getEvents(20, $tournir_id, '');
  }
  
?>
