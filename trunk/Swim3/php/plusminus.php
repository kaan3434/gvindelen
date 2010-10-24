<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>PlusMinus</title>
  </head>
<body>
<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $Sport = $_GET['Sport'];
  $debug = $_GET['debug'];
  $Booker = 'plusminus';
  $Lines = "lines/$Booker/$Sport.";

function extract_line_value($Html) {
  $Html = extract_tags($Html, '<input', '>', "\r\n", 'hidden', 'line');  
  $Html = delete_all($Html, '<input ', 'value=\'');
  $Html = str_replace('>', '', $Html);
  return ($Html);
}
  
function extract_league($Html) {
  $Html = copy_be($Html, '<form ', '</form>', 'name="f1"');
  $LineValue = extract_line_value($Html);
  $Html = extract_tags($Html, '<input ', '>', "\r\n", 'checkbox', 'events[]');
  $Html = delete_all($Html, '<input ', "name='");
  $Html = str_replace("'>", '', $Html);
  $Html = str_ireplace("' value='", "=", $Html);
  return ($Html);
}

  // Получаем перечень турниров
  if ($debug) {
    $FileName = $Lines . "league.html";
    if (!file_exists($FileName)) {
      $Html = download_page("http://plusminus1.com/bet.php?events=$Sport", "GET");
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download_page("http://plusminus1.com/bet.php?events=$Sport", "GET");
  }
  $Leagues = extract_league($Html);
  if ($debug) file_put_contents($Lines . "league.txt", $Leagues);

function extract_bet($Html) {
  $Html = copy_be($Html, '<form ', '</form>', 'betform');
  $Html = kill_tag($Html, 'script|div');
  $Html = kill_space($Html);
  $Html = kill_tag_bound($Html, 'b|span|br|i|a|input|font|img');
  $Html = delete_all($Html, '<tr', '</tr>', 'line3'); 
  
  
  $Html = kill_property($Html, 'width|height|valign|align|bgcolor|style|class');

  //  Убираем "левые" данные 
  $Html = replace_all_contain($Html, '<tr', '</tr>', '', 
          'Хозяева|'.
          'Гости|'.
          'Индив.тотал:|'.
          '-я четверть|'.
          '-я партия|'.
          ' тайм|'.
          '-й сет');
  return ($Html);
}

  // Получаем перечень ставок
  if ($Leagues != '') {
    $PostData = explode("\r\n", $Leagues);
    $PostData[] = 'filter=all';
    $PostData[] = 'rospis=on';
    if ($debug) {
      $FileName = $Lines . "bets.html";
      if (!file_exists($FileName)) {
        $Html = download_page("http://plusminus1.com/bet.php?events=$Sport", "POST", "http://plusminus1.com/bet.php?view=on", implode('&', $PostData));
        file_put_contents($FileName, $Html);
      } else {
        $Html = file_get_contents($FileName);
      }
    } else {
      $Html = download_page("http://plusminus1.com/bet.php?events=$Sport", "POST", "http://plusminus1.com/bet.php?view=on", implode('&', $PostData));
    }
    $Result = extract_bet(convert_to_utf8($Html));
    if ($debug) file_put_contents($Lines . 'bets.txt', $Result);
    if ($debug) file_put_contents($Lines . 'bets.txt.html', $Result);
  }

  print ($Result);
?>
</body>
</html>
