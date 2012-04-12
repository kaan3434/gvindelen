<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $Booker = 'bwin';
  $Host = 'https://www.bwin.com';
  
  
  $debug = $_GET['debug'];
  $Sport = $_GET['Sport'];
  $CategoryId = $_GET['CategoryId'];
  $CurrentPage = $_GET['CurrentPage'];
  $ScanId = $_GET['ScanId'];

  $Leagues = "lines/$Booker/$Sport.";
  $Lines = "lines/$Booker/$Sport.$CategoryId.";
  if (file_exists('proxy.txt')) $Proxy = file_get_contents('proxy.txt');

  $xml = new SimpleXMLElement("<Scan/>");
  $xml->addAttribute('id', $ScanId);
  
  
function extract_league($Html) {
  global $xml;
  $Html = extract_tags($Html, '<a href=\'betsnew.aspx?leagueids=', '>', "\r\n");
  preg_match_all('/(\d+)/m', $Html, $Matches);
  foreach($Matches[1] as $league_id) {
    $xml->addChild('Tournir', $league_id);
  }
}
  
  // Получаем перечень турниров
  if ($debug) {
    $FileName = $Leagues . "league.html";
    if (!file_exists($FileName)) {
      $Html = download_curl("$Host/$Sport?ShowDays=168", "GET", $Proxy);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download("$Host/$Sport?ShowDays=168", "GET", $Proxy);
  }
  extract_league($Html, $xml);
  if ($debug) file_put_contents($Leagues . "league.xml", $xml->asXML());

  foreach($xml->Scan->League as $league) {}

  
  
  file_put_contents($Leagues . "league.xml", $xml->asXML());
  print $xml->asXML()
?>
