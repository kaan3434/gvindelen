<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>BetCity<?php print "Sport:$Sport";?></title>
  </head>
<body>
<?php
  require_once "libs/Download.php";
  require_once "bwin_xml.php";
  
  $booker = new booker();
  $booker->debug = 1;
  
//  $sports = $booker->getSports();

  $tournirs = $booker->getTournirs(20);
  
//  foreach($tournirs->Tournirs->children() as $element_name=>$child) {
//    $tournir_url = (string) $child['Url'];
//    $events = $booker->getEvents(20, '', $tournir_url);
//  }

    $tournir_id = '43';
    $events = $booker->getEvents(20, $tournir_id, '');
  
?>
