<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  $Booker = 'betcity';
  $Lines = "lines/$Booker/";

function extract_league($Html) {
  $Html = copy_be($Html, '<form id="fbets"', '</form>');
  $Html = replace_all($Html, 'долгосрочные ставки', '</form>', '</form>');
  $Html = extract_tags($Html, '<input', '>', "\r\n", 'name=', 'value='); 
  $Html = delete_all($Html, '<input', 'name=');
  $Html = str_ireplace(' value="', '=', $Html);
  $Html = str_ireplace('">', '', $Html);
  return $Html;  
}

  // Получаем перечень турниров
  if ($debug) {
    $FileName = $Lines . "league.html";
    if (!file_exists($FileName)) {
      $Html = download_page("http://betcity.ru/bets.php?line_id[]=$Sport", "GET", "http://betcity.ru/center.php");
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download_page("http://betcity.ru/bets.php?line_id[]=$Sport", "GET", "http://betcity.ru/center.php");
  }
  $Leagues = extract_league($Html);
  if ($debug) file_put_contents($Lines . "league.txt", $Leagues);

  
function extract_bet($Html) {
  $Html = extract_tags($Html, '<table cellSpacing=2 cellPadding=1', '</table>', "\r\n");
  $Html = kill_space($Html);
  $Html = kill_tag_bound($Html, 'b|a|br|font|img');
  $Html = str_ireplace(' nowrap', '', $Html);
  $Html = kill_property($Html, 'onmouseover|onclick|align|id|style|width|cellspacing');
  
  //  Убираем строки без ставок 
  $Html = delete_all($Html, '<tr>', '</tr>', 'class="t_comment"');
  $Html = delete_all($Html, '<tr>', '</tr>', 'class="t_comment1"');
  $Html = str_ireplace(' class=date', ' @lass=date', $Html);
  $Html = kill_property($Html, 'class');
  $Html = str_ireplace(' @lass=date', ' class=date', $Html);
  return $Html;
}

  
  // Получаем перечень турниров
  $FileName = $Lines . "league.html";
  if (!file_exists($FileName)) {
    $PostData = explode("\r\n", file_get_contents($Lines . "sport.txt"));
    $Html = download_page("http://www.betcity.ru/bets.php", "POST", "http://www.betcity.ru/main2.php", implode('&', $PostData));
    file_put_contents($FileName, $Html);
  }else{
    $Html = file_get_contents($FileName);
  }
  $FileName = $Lines . "league.txt";
  file_put_contents($FileName, extract_league($Html));

  // Получаем перечень ставок
  $FileName = $Lines . "bets.html";
  if (!file_exists($FileName)) {
    $PostData = explode("\r\n", file_get_contents($Lines . 'league.txt'));
    $Html = download_page("http://www.betcity.ru/bets2.php", "POST", "http://www.betcity.ru/bets.php", implode('&', $PostData));
    file_put_contents($FileName, $Html);
  }else{
    $Html = file_get_contents($FileName);
  }
  $FileName = $Lines . 'bets.txt';
  file_put_contents($FileName, extract_bet($Html));

  print file_get_contents($FileName);
?>

