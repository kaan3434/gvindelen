<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $Booker = 'betathome';
  $debug = $_GET['debug'];
  $Sport = $_GET['Sport'];
  $CategoryId = $_GET['CategoryId'];
  $CurrentPage = $_GET['CurrentPage']-1;

  
  $Leagues = "lines/$Booker/$Sport.";
  $Lines = "lines/$Booker/$Sport.$CategoryId.";
  
  if ($Sport <> 1) download("http://bet-at-home.com/odd.aspx?action=removeSport&SportID=1", "GET", "http://bet-at-home.com/tree.aspx");
  if ($Sport <> 2) download("http://bet-at-home.com/odd.aspx?action=removeSport&SportID=2", "GET", "http://bet-at-home.com/tree.aspx");
  if ($Sport <> 4) download("http://bet-at-home.com/odd.aspx?action=removeSport&SportID=4", "GET", "http://bet-at-home.com/tree.aspx");
  if ($Sport <> 15) download("http://bet-at-home.com/odd.aspx?action=removeSport&SportID=15", "GET", "http://bet-at-home.com/tree.aspx");
  if ($Sport <> 5) download("http://bet-at-home.com/odd.aspx?action=removeSport&SportID=5", "GET", "http://bet-at-home.com/tree.aspx");
  if ($Sport <> 30) download("http://bet-at-home.com/odd.aspx?action=removeSport&SportID=30", "GET", "http://bet-at-home.com/tree.aspx");

  // Удаляем старые файлы c турнирами
  if (!$debug) {
    $FileName = $Leagues . 'league.html';
    if (file_exists($FileName)) {
      $CurDtTm = getdate();
      $Seconds = $CurDtTm['0']-filectime($FileName);
      if ($Seconds > 1*60) {
        unlink($Leagues . "league.html");
        // Удаляем старые файлы cо ставками
        for ($i=1; $i<40; $i++) {
         $FileName = $Lines . "$i.bets.html";
         if (file_exists($FileName)) unlink($FileName);
        }
      }
    }
  }

function extract_league($Html, $Sport) {
  $Html = kill_space($Html);
  $Html = numbering_tag($Html, 'div');
  $Html = extract_numbered_tags($Html, 'div', "\r\n", "navElem");
  $TagNo = extract_tagno(copy_be($Html, "<div\t", "&SportID=$Sport\">"), 'div');
  $Html = extract_numbered_tag($Html, 'div', $TagNo);
  $Html = extract_tags($Html, 'EventGroupID=', "'", ',');
  $Html = str_ireplace('EventGroupID=', '', $Html);
  $Html = str_ireplace("'", '', $Html);
  return $Html;  
}

  // Получаем перечень турниров
  if ($debug) {
    $FileName = $Leagues . "league.html";
    if (!file_exists($FileName)) {
      $Html = download("http://bet-at-home.com/tree.aspx", "GET", "http://bet-at-home.com/start.aspx");
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download("http://bet-at-home.com/tree.aspx", "GET", "http://bet-at-home.com/start.aspx");
  }
  $LeagueList = extract_league(utf8_to_ansi_ce($Html), $Sport);
  if ($debug) file_put_contents($Leagues . "league.txt", $LeagueList);
  if ($LeagueList == '') exit;

  $Html = download("http://bet-at-home.com/odd.aspx?action=addSport&SportID=$Sport", "GET", "http://bet-at-home.com/tree.aspx");

function extract_bet($Html) {
  $Html = str_ireplace(' nowrap', ' ', $Html);
  $Html = kill_space($Html);
  $Html = kill_comment($Html);
  $Html = extract_tags($Html, '<table ', '</table>', "\r\n", 'class="OT"');
  $Html = kill_tag($Html, "script");
  $Html = kill_tag_bound($Html, "form|input|a|nobr|img|tbody|div");
  $Html = kill_property($Html, "onmouseover|onmouseout|onclick|bgcolor|border|cellpadding|cellspacing|width|id|class");
  return $Html;
}

  // Получаем перечень ставок
  if ($CurrentPage == 0) {
    $Referer = "http://bet-at-home.com/odd.aspx?action=addSport&SportID=$Sport";
    $Url = "http://bet-at-home.com/odd.aspx?action=betTypeSingle&id=$CategoryId";
  } else {
    $Referer = "http://bet-at-home.com/odd.aspx?action=addSport&SportID=$Sport";
    $Url = "http://bet-at-home.com/odd.aspx?action=betTypeSingle&page=$CurrentPage";
  }
  if ($debug) {
    $FileName = $Lines . "$CurrentPage.bets.html";
    if (!file_exists($FileName)) {
      $Html = download($Url, "GET", $Referer);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download($Url, "GET", $Referer);
  }
  
  $Result = extract_bet(utf8_to_ansi_ru(utf8_to_ansi_ce($Html)));
  if (stripos($Html, "DoPage('next')") == 0) {
    $Result .= '"LastPage=True"';
  } else {
    $Result .= '"LastPage=False"';
  }
  if ($debug) file_put_contents($Lines . 'bets.txt.html', $Result);
  
  print ($Result);
?>

