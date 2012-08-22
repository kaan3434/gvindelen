<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Get Article</title>
  </head>
<body>
<availability 
<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $debug = $_GET['debug'];
  $cache = 'cache';
  $Host = 'http://www.otto.de';
  
  $PostHash['ArticleNo'] = $_GET['ArticleNo'];
  $PostHash['ArticleSize'] = $_GET['ArticleSize'];

  if ($debug) {
    $FileName = "$cache/main.html";
    if (!file_exists($FileName)) {
      $Html = download("$Host/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewDeliveryInfo-IncludeDelivery", "POST", '', $PostHash);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    } 
  } else {
    $Html = download("$Host/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewDeliveryInfo-IncludeDelivery", "POST", '', $PostHash);
  }
  $Html = copy_be($Html, '<span ', '</span>', 'availability');
  $availablility_class = extract_property_values($Html, 'class', "\r\n");

  if ($availablility_class == 'availability_red') {
    echo 'available="0" ';
    echo 'availability_code="'.delete_all($Html, '<', '>').'"';
  } elseif ($availablility_class == 'availability_green') {
    echo 'available="1" ';
    echo 'availability_code="'.delete_all($Html, '<', '>').'"';
  } elseif ($availablility_class == 'availability_orange') {
    $availablily_code = delete_all($Html, '<', '>');
    if ($availablily_code == 'lieferbar in 3 Wochen') {
      echo 'available="21" ';
    } else {
      echo 'available="2" ';
    }  
    echo 'availability_code="'.$availablily_code.'"';
  };
;
?>
/>
</body>
</html>
