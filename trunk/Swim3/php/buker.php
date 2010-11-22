<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Buker</title>
  </head>
<body>
<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
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
  $PostHash = array();
  $PostHash['task'] = 'matches1';
  $PostHash['futb'] = 'on';
  $PostHash['basket'] = 'on';
  $PostHash['voley'] = 'on';
  $PostHash['tenis'] = 'on';
  $PostHash['others'] = 'on';
  if ($debug) {
    $FileName = $Lines . 'league.html';
    if (!file_exists($FileName)) {
      $Html = download('http://www.buker.ru/dostaken.php', "POST", "http://www.buker.ru/", $PostHash);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    } 
  } else {
    $Html = download('http://www.buker.ru/dostaken.php', "POST", "http://www.buker.ru/", $PostHash);
  }
  $Leagues = extract_league($Html);
  if ($debug) file_put_contents($Lines . 'league.txt', $Leagues);
  
function process_login($Html) {
  $PostHash = extract_form_hash($Html);
  $PostHash['username'] = 'Gvindelen';
  $PostHash['passwd'] = 'grafdevalery';
  $Html = copy_be($Html, '<form ', '>');
  $Tags = extract_property_values($Html, 'action', "\r\n");
  $Html = download($Tags, 'POST', 'http://www.buker.ru/dostaken.php', $PostHash);
  return $Html;
}
  if ($debug) {
    $FileName = $Lines . 'login.html';
    if (file_exists($FileName)) $Html = file_get_contents($FileName);
  }
  $LoginForm = copy_be($Html, '<form ', '</form>', 'login'); 
  if ($LoginForm) {
    $Html = process_login($LoginForm);
    if ($debug) file_put_contents($Lines . 'login.html', $Html);
  }
  
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
    $Result = extract_bet(convert_to_utf8($Html));
    if ($debug) file_put_contents($Lines . 'bets.txt', $Result);
  }
  print ($Result);
?>
</body>
</html>
