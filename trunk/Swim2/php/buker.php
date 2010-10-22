<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  $debug = $_GET['debug'];
  $Booker = 'buker';
  $Lines = "lines/$Booker/";

function extract_league($Html) {
  $Html = extract_tags($Html, '<input', '>', "\r\n", 'catm[]'); 
  $Html = delete_all($Html, '<', 'name=');
  $Html = delete_all($Html, '"', '>');
  $Html = replace_all($Html, '[]', '"', '[]=');
  return $Html;  
}
  
  // Получаем перечень турниров
  $PostData = Array();
  $PostData[] = 'task=matches1';
  $PostData[] = 'futb=on';
  $PostData[] = 'basket=on';
  $PostData[] = 'voley=on';
  $PostData[] = 'tenis=on';
  $PostData[] = 'others=on';
  if ($debug) {
    $FileName = $Lines . 'league.html';
    if (!file_exists($FileName)) {
      $Html = download_page('http://www.buker.ru/dostaken.php', "POST", "http://www.buker.ru/", implode('&', $PostData));
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    } 
  } else {
    $Html = download_page('http://www.buker.ru/dostaken.php', "POST", "http://www.buker.ru/", implode('&', $PostData));
  }
  $Leagues = extract_league($Html);
  if ($debug) file_put_contents($Lines . 'league.txt', $Leagues);

function extract_bet($Html) {
  $Html = extract_tags($Html, '<table ', '</table>', '', 'Дома');
  $Html = kill_space($Html);
  $Html = str_ireplace('=>', '|', $Html);
  $Html = kill_comment($Html);
  $Html = kill_tag($Html, 'script');
  $Html = kill_tag_bound($Html, 'input|b|a|img|strong');
  $Html = str_ireplace('<br>', '|', $Html);
  $Html = str_ireplace('>-<', '><', $Html);
  $Html = str_ireplace(' bgcolor="#66FFFF"', ' league="#66FFFF"', $Html);
  $Html = kill_property($Html, 'bgcolor|align|valign|width|border|class');
  $Html = replace_all_contain($Html, '<tr', '</tr>', '', 
          'угл |'.
          'ж.к ');
  return $Html;
}
  
  // Получаем перечень ставок
  if ($Leagues != '') {
    $PostData = explode("\r\n", $Leagues);
    $PostData[] = 'xtime=0';
    $PostData[] = 'task=matches';
    $PostData[] = 'sendm=sendm';
    if ($debug) {
      $FileName = $Lines . "bets.html";
      if (!file_exists($FileName)) {
        $Html = download_page("http://www.buker.ru/dostaken.php", "POST", "http://www.buker.ru/dostaken.php", implode('&', $PostData));
        file_put_contents($FileName, $Html);
      } else {
        $Html = file_get_contents($FileName);
      }
    } else {
      $Html = download_page("http://www.buker.ru/dostaken.php", "POST", "http://www.buker.ru/dostaken.php", implode('&', $PostData));
    }
    $Result = extract_bet($Html);
    if ($debug) file_put_contents($Lines . 'bets.txt', $Result);
  }
  print ($Result);
?>
