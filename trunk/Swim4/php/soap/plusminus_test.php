<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>PlusMinus <?php print "Sport:$Sport";?></title>
  </head>
<body>
<?php
  require_once "libs/Download.php";
  require_once "plusminus_xml.php";
  
  $booker = new booker();
  $booker->debug = 1;
  
  $sports = $booker->getSports();
  
  $tournirs = $booker->getTournirs(10);
//  foreach($tournirs->Tournirs->children() as $element_name=>$child) {
//    $tournir_id = (string) $child['Id'];
//    $events = $booker->getEvents(10, $tournir_id, '');
//  }
//    $tournir_id = '24';
//    $events = $booker->getEvents(20, $tournir_id, '');
  print '<xmp>'.$sports->asXml().'</xmp>';
  print '<xmp>'.$tournirs->asXml().'</xmp>';
?>
</body>
</html>
