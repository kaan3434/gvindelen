<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $Booker = 'bwin';

  
  
  $debug = $_GET['debug'];
  $Sport = $_GET['Sport'];
  $CategoryId = $_GET['CategoryId'];
  $CurrentPage = $_GET['CurrentPage'];

  $Leagues = "lines/$Booker/$Sport.";
  $Lines = "lines/$Booker/$Sport.$CategoryId.";
  if (file_exists('proxy.txt')) $Proxy = file_get_contents('proxy.txt');

  // Удаляем старые файлы c турнирами
  if (!$debug) {
    $FileName = $Leagues . 'league.html';
    if (file_exists($FileName)) {
      $CurDtTm = getdate();
      $Seconds = $CurDtTm['0']-filectime($FileName);
      if ($Seconds > 5*60) {
        unlink($Leagues . "league.html");
        // Удаляем старые файлы cо ставками
       for ($i=1; $i<40; $i++) {
         $FileName = $Lines . "$i.bets.html";
         if (file_exists($FileName)) unlink($FileName);
        }
      }
    }
  }

function extract_league($Html) {
  $Html = extract_tags($Html, '<a href="betsnew.aspx?leagueids=', '>', "\r\n");
  preg_match_all('/(\d+)/m', $Html, $Matches);
  $Html = implode(",", $Matches[1]);
  return $Html;  
}

  // Получаем перечень турниров
  if ($debug) {
    $FileName = $Leagues . "league.html";
    if (!file_exists($FileName)) {
      $Html = download_curl("https://www.bwin.com/$Sport?ShowDays=168", "GET", $Proxy);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download("https://www.bwin.com/$Sport?ShowDays=168", "GET", $Proxy);
  }
  $LeagueList = extract_league(utf8_to_ansi_ru(utf8_to_ansi_ce($Html)));
  if ($debug) file_put_contents($Leagues . "league.txt", $LeagueList);



function extract_bet($Html) {
  $Html = delete_all($Html, "(at ", ")");
  $Html = delete_all($Html, "(score: ", ")");
  $Html = str_ireplace('<wbr/>', '', $Html);
  $Html = str_replace("-.--", " ", $Html);
  $Html = kill_tag($Html, "h1|script");
  $Html = kill_space($Html);
  $Html = kill_comment($Html);
  $Html = numbering_tag($Html, 'div');
  $Html = extract_numbered_tags($Html, 'div', "", "bet-list");
  $Html = extract_numbered_tags($Html, 'div', "", "dsBodyContent");
  $Html = kill_property($Html, 'TagNo');
  $Html = kill_property($Html, "onmouseover|onmouseout|onclick|bgcolor|border|cellpadding|leaguename|id|width|cellspacing|regionname");
  $Html = kill_property_value($Html, "colspan", "1");
  $Html = kill_tag_bound($Html, "form|input|a|nobr|img|tbody|span");
  $Html = delete_all($Html, ' class="unselected ', '"');
  $Html = delete_all($Html, ' class=\'unselected ', '\'');
  $Html = replace_all_contain($Html, '<div', '</div>', '', 
          'isFavourite|'.
          'isNoFavourite');
  $Html = replace_all_contain($Html, '<tr', '</tr>', '', 
          'sizer|'.
          'bottomline');
  $Html = kill_property_value_exclude($Html, "class", "controlHeaderNoShadow|topbar|normal|def|alt|ControlContent");
  $Html = str_ireplace('<td></td>', '<td/>', $Html);
  $Html = kill_unclassed_tag($Html, 'div');
  $Html = kill_apostrof($Html, 'colspan');
  
  // !-- Приводим Totalы к нормальному виду -->
  $Html = replace_all($Html, "<h5>Сумма набранных очков ", '</h5>', '<h5>Total</h5>');
  $Html = replace_all($Html, "<h5>Тотал ", '</h5>', '<h5>Total</h5>');
  $Html = replace_all($Html, "<h5>Сколько будет забито голов?", '</h5>', '<h5>Total</h5>');
  $Html = replace_all($Html, "<h5>Сколько голов будет забито?", '</h5>', '<h5>Total</h5>');
  $Html = replace_all($Html, "<h5>Сколько геймов будет сыграно в матче?", '</h5>', '<h5>Total</h5>');
  $Html = replace_all($Html, "<h5>Кто выиграет больше геймов в матче? (гандикап игрока)", '</h5>', '<h5>Fora</h5>');
  $Html = replace_all($Html, "<h5>Двойной шанс", '</h5>', '<h5>1X_12_X2</h5>');
  
  $Html = str_ireplace('<tr class="alt"', "\r\n".'<tr class="alt"', $Html);
  $Html = str_ireplace('<tr class="def"', "\r\n".'<tr class="alt"', $Html);
  $Tags = explode("\r\n", $Html);
  foreach ($Tags as $tag) {
    if (copy_be($tag, '>', '<', ' - ', ' - ', ':')) {
      $Html = str_ireplace("\r\n".$tag, str_ireplace('="alt"', '="evn"', $tag), $Html);
    }
  }
  $Tags = explode("\r\n", $Html);
  foreach ($Tags as $tag) {
    if (strpos($tag, '"alt"')) {
      $newtag = numbering_tag($tag, 'tr');
      $trAlt = extract_numbered_tags($newtag, 'tr', '', 'alt');
      $h5 = delete_all($trAlt, '<', '>');
      if (strpos($h5, ' ')) {
        $newtag = str_replace($trAlt, '', $newtag);
        $Normals = explode("\r\n", extract_numbered_tags($newtag, 'tr', "\r\n", 'normal'));
        foreach ($Normals as $normal) {
          $newtag = str_replace($normal, '', $newtag);
        }
        $newtag = kill_property($newtag, 'TagNo');
        $Html = str_replace($tag, $newtag, $Html);
      }
    }
  }
  $Html = str_ireplace("\r\n", '', $Html);  
  $Html = str_ireplace('<tr class="evn"', "\r\n".'<tr class="evn"', $Html);
  $Tags = explode("\r\n", $Html);
  foreach ($Tags as $tag) {
   if (strpos($tag, '"evn"')) {
      $newtag = numbering_tag($tag, 'tr');
      $trEvn = extract_numbered_tags($newtag, 'tr', '', 'evn');
      if (strpos($newtag, '="normal"') == 0) {
        $newtag = str_replace($trEvn, '', $newtag);
      }
      $newtag = kill_property($newtag, 'TagNo');
      $Html = str_replace($tag, $newtag, $Html);
    }
  }
  
  $Html = str_ireplace("\r\n", '', $Html);  
  return $Html;
}

  
  // Получаем перечень ставок
  $PostData = array();
  $PostData['leagueIDs'] = $LeagueList;
  $PostData['sorting'] = "dateleague";
  $PostData['categoryIDs'] = $CategoryId;
  $PostData['currentPage'] = $CurrentPage;
  if ($debug) {
   $FileName = $Lines . "$CurrentPage.bets.html";
    if (!file_exists($FileName)) {
      $Html = download("https://www.bwin.com/betviewiframe.aspx", "GET", "https://www.bwin.com/$Sport?ShowDays=168", $PostData);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    }
  } else {
    $Html = download("https://www.bwin.com/betviewiframe.aspx", "GET", "https://www.bwin.com/$Sport?ShowDays=168", $PostData);
  }
  $Result = extract_bet(utf8_to_ansi_ru(utf8_to_ansi_ce($Html)));
  
  if (stripos($Html, '"pagingGotoNextItem"') == 0) {
    $Result .= '"LastPage=True"';
  } else {
    $Result .= '"LastPage=False"';
  }
  if ($debug) file_put_contents($Lines . 'bets.txt.html', $Result);
  print ($Result);
?>
