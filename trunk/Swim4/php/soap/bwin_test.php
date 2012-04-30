<?php
  include "bwin_xml.php";
  require_once"booker_xml.php";
  
  $booker = new bwin_booker();
  
  $filename = $booker->getLeaguePath('tennis');
  file_put_contents("$filename.test", 'test');
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Root/>');
  $tournirs_node = $xml->addChild('Tournirs');
  $booker->getTournirs($tournirs_node, 'tennis');
  
  print $xml->asXML();
?>
