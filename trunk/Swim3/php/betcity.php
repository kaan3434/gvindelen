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
  $Booker = 'betcity';
  $Lines = "lines/$Booker/";
  $Host = 'http://betcity.ru';

  // Получаем перечень турниров
  if ($debug) {
    $FileName = $Lines . "league.html";
    if (!file_exists($FileName)) {                                                                                                                         
      $Html = download("$Host/bets.php?line_id[]=$Sport", "GET", "$Host/center.php");
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download_page("$Host/bets.php?line_id[]=$Sport", "GET", "$Host/center.php");
  }

function extract_league($Html) {
  $Html = replace_all($Html, '<table', '</table>', '', 'долгосрочные ставки');
  return extract_form_hash($Html);
}

  $Form = copy_be(win1251_to_utf8($Html), '<form id="fbets"', '</form>');
  if ($debug) file_put_contents($Lines . "form.txt", $Form);
  $PostHash = extract_league($Form);
  $FormAction = extract_form_action($Form);
  if ($debug) file_put_contents($Lines . "league.txt", implode_hash("\r\n", $PostHash));

  // Получаем перечень турниров
  $PostHash['simple'] = 'on';
  if ($debug) {
    $FileName = $Lines . "bets.html";
    if (!file_exists($FileName)) {
      $Html = download("$Host/$FormAction", "POST", "$Host/bets.php?line_id[]=$Sport", $PostHash);
      file_put_contents($FileName, $Html);
    } else {          
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download("$Host/$FormAction", "POST", "$Host/bets.php?line_id[]=$Sport", $PostHash);
  }

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

  $Result = extract_bet(convert_to_utf8($Html));
  if ($debug) file_put_contents($Lines . 'bets.txt', $Result);
  if ($debug) file_put_contents($Lines . 'bets.txt.html', $Result);
  if ($debug) file_put_contents($FileName, extract_league($Html));

  print $Result;
?>
</body>
</html>

