<?php
  $booker = 'bwin';
  require "bwin_xml.php";
  $debug = 1;
  $sport_sign = 'tennis';
    
  $xml = new SimpleXMLElement("<Scan/>");
  $sport_node = $xml->addChild("Sport", $sport_sign);
    
  scan_line_bwin($sport_node, 33, $debug);
  
  $league_path = "lines/$booker/$sport_node.";
  
  file_put_contents($league_path."league.xml", $xml->asXML());
  print $xml->asXML();
?>
