<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $Booker = 'favorit';
  $Sport = $_GET['Sport'];
  $debug = $_GET['debug'];

  $Lines = "lines/$Booker/$Sport.";

  // Удаляем старые файлы c видам спорта
  if (!$debug) {
    $FileName = $Lines . 'sport.html';
    if (file_exists($FileName)) {
      $CurDtTm = getdate();
      $Seconds = $CurDtTm['0']-filectime($FileName);
      if ($Seconds > 5*60) {
        unlink($Lines . "sport.html");
      }
    }
  }
  
  
function extract_sport($Html, $Sport) {
  $Html = copy_be($Html, '<ul ', '</ul>', 'bets_list');
  $Html = copy_be($Html, '<a ', '</a>', $Sport);
  $Html = extract_property_values($Html, 'href', '');
  preg_match('@/(\d+)/@', $Html, $Matches);
  if (count($Matches) > 0) {
    return ($Matches[1]); 
  } else {
    return null;
  }
}
  
  // Получаем перечень видов спорта
  if ($debug) {
    $FileName = $Lines . "sport.html";
    if (!file_exists($FileName)) {
      $Html = download("http://favoritbet.com/", "GET");
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download("http://favoritbet.com/", "GET");
  }
  
  $SportId = extract_sport(utf8_to_ansi_ru($Html), $Sport);
  if ($debug) file_put_contents($Lines . "sport.txt", $SportId);
  if ($SportId == '') exit;

function extract_league($Html) {
  $Html = copy_be($Html, '<form name="hform"', '</form>');
  $Html = implode("\r\n", extract_form_data($Html)); 
  $Html = str_ireplace("showrosp=1\r\n", '', $Html);
  return $Html;  
}

  // Получаем перечень турниров
  if ($debug) {
    $FileName = $Lines . "league.html";
    if (!file_exists($FileName)) {
      $Html = download("http://favoritbet.com/ru/bet/$SportId/", "GET");
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download("http://favoritbet.com/ru/bet/$SportId/", "GET");
  }

  $Leagues = extract_league(utf8_to_ansi_ru($Html));
  if ($debug) file_put_contents($Lines . "league.txt", $Leagues);
  if ($Leagues == '') exit;

function extract_bet($Html) {
  $Html = kill_space($Html);
  $Html = numbering_tag($Html, 'table');
  $Html = extract_numbered_tags($Html, 'table', '', 'content');
  $Tags = explode("\r\n", extract_tags($Html, '<table', 'height="22"',"\r\n"));
  foreach ($Tags as $tag) {
    $TagNo = extract_tagno($tag, 'table');
    $Table = extract_numbered_tag($Html, 'table', $TagNo);
    if (stripos($Table, 'поб.1') > 0) {
      $Result .= $Table;
    }
  }
  $Html = $Result;
  $Html = str_ireplace('>-<', '><', $Html);
  $Html = kill_comment($Html);
  $Html = kill_tag($Html, 'script');
  $Html = kill_tag_bound($Html, 'a|b|img|strong');
  $Html = kill_property($Html, 'tagno|bgcolor|align|valign|width|cellspacing|border|cellpadding');
  $Html = replace_all_contain($Html, '<tr', '</tr>', '', 
          ' тайм)|'.
          ' тайм:|'.
          ' четверть:|'.
          '-й сет:|'.
          'Дополнительные тоталы:|'.
          'colspan="17"|'.
          'Первый матч|'.
          'Второй матч|'.
          'Хозяева|'.
          'Счет серии');

  return ($Html);
}

  // Получаем перечень ставок
  $PostData = explode("\r\n", $Leagues);
  if ($debug) {
    $FileName = $Lines . "bets.html";
    if (!file_exists($FileName)) {
      $Html = download_page("http://favoritbet.com/index.php", "POST", "http://favoritbet.com/ru/bet/$SportId/", implode('&', $PostData));
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download_page("http://favoritbet.com/index.php", "POST", "http://favoritbet.com/ru/bet/$SportId/", implode('&', $PostData));
  }
  $Result = extract_bet(utf8_to_ansi_ru($Html));
  if ($debug) file_put_contents($Lines . "bets.txt", $Result);

  print ($Result);
?>

