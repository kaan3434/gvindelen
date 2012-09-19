<?php
  require_once "libs/Download.php";
  require_once "marathon_xml.php";
  
  $html = download_or_load(0, 'lines/marathon/1.html', 'http://www.marathonbet.com/en/', "GET", "");
  print $html;
//  file_put_contents()
  
//  $booker = new marathon_booker();
//  $booker->debug = 1;
  
//  $sports = $booker->getSports();
  
//  $tournirs = $booker->getTournirs(10);
//  foreach($tournirs->Tournirs->children() as $element_name=>$child) {
//    $tournir_id = (string) $child['Id'];
//    $events = $booker->getEvents(10, $tournir_id, '');
//  }
//    $tournir_id = '749786';
//    $events = $booker->getEvents(10, $tournir_id, '');
//  print '<xmp>'.$sports->asXml().'</xmp>';
//  print '<xmp>'.$tournirs->asXml().'</xmp>';
?>
