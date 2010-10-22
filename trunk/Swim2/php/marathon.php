<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  $Booker = 'marathon';
  $Lines = "lines/$Booker/";

  // Удаляем старые файлы
  if ($debug) {
    $FileName = $Lines . 'bets.html';
    if (file_exists($FileName)) {
      $CurDtTm = getdate();
      $Seconds = $CurDtTm['0']-filectime($FileName);
      if ($Seconds > 5*60) {
        unlink($Lines . "bets.html");
      }
    }
  }
  
    
function extract_bet($Html) {
  //  Разбираемся с концами строк 
  $Html = str_ireplace("\n", '<br>', $Html);
  $Html = str_ireplace("\r", '<br>', $Html);
  $Html = copy_be($Html, '<form name=f1>', '</form>');  
  $Html = str_ireplace('&nbsp;', ' ', $Html);
  $Html = kill_tag_bound($Html, 'input|itemevent|a|b');
  $Html = str_ireplace(' noshade', '', $Html);
  $Html = kill_property($Html, 'time|color');
  $Html = replace_all($Html, '<sup>', '</sup>', ' ');
  $Html = kill_tag($Html, 'big');
  $Html = str_ireplace('<endpreview/>', '', $Html);
  $Html = str_ireplace('<hr><br>', '<hr>', $Html);

  $Html = str_ireplace('<br>Оглавление<', '<', $Html);
  $Html = str_ireplace('<br>Оглавление<', '<', $Html);
  $Html = replace_all($Html, '<u>', '</form>', '</form>');
  $Html = kill_tag_bound($Html, 'u|form');
  $Html = delete_all($Html, '<span ', '</span>', 'maxcap');

  return $Html;
}

  // Получаем перечень ставок
  if ($debug) {
    $FileName = $Lines . "bets.html";
    if (!file_exists($FileName)) {
      $Html = download_page("http://odds.marathonbet.com/odds-view.phtml?h=0&r0=0&r0=0", "GET", '', '');
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download_page("http://odds.marathonbet.com/odds-view.phtml?h=0&r0=0&r0=0", "GET", '', '');
  }
  $Result = extract_bet($Html);
  if ($debug) file_put_contents($Lines . 'bets.txt', $Result);

  print $Result;
?>
