<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $booker = 'bwin';
  $host = 'https://www.bwin.com';
  
function extract_league(&$sport_node, $html) {
  $html = kill_space($html);
  $html = extract_tags($html, '<a href=\'betsnew.aspx?leagueids=', '</a>', "\r\n");
  $tournirs = explode("\r\n", $html);
  foreach($tournirs as $tournir) {
    $tournir_name = copy_between($tournir, '>', '</a');
    preg_match('/(.+) \((\d+)\)$/m', $tournir_name, $matches);
    $tournir_name = $matches[1];
    // бракуем турниры
    if (!similar_to($tournir_name, '.+ - live$')) {
      $tournir_node = $sport_node->addChild('Tournir', $tournir_name);

      $league = copy_be($tournir, '<a', '>', 'leagueids');
      $league_id = copy_between($league, 'leagueids=', "'");
      $tournir_node->addAttribute('Id', $league_id);
    }
  }
}

function decode_date($str) {
  if (preg_match('/(\w+) (\d{1,2}), (\d{4})/i', $str, $matches)) { //MMM DD, YYYY
    $month_no = decode_month_name($matches[1]);
    $year_no = $matches[3];
    $day_no = $matches[2];
  }
  return array($day_no, $month_no, $year_no);
}

function decode_time($str) {
  preg_match('/(\d{1,2}):(\d\d) (PM|AM)/i', $str, $matches);
  $hour = $matches[1];
  $minute = $matches[2];
  $pmam = $matches[3];
  if (($pmap == 'AM') and ($hour == 12)) {
    $hour = 0;
  } elseif (($pmam == 'PM') and ($hour < 12)) {
    $hour = $hour + 12;
  }
  return array($hour, $minute);
}

function extract_gamer_koef($html) {
  $html = kill_tag_bound($html, 'div|wbr|tr');
  $gamer_name = delete_all(take_be($html, '<td', '</td>'), '<', '>');
  $koef = delete_all(copy_be($html, '<td', '</td>'), '<', '>');
  return array($gamer_name, $koef);
}

function event_find_or_create(&$tournir_node, $datetime, $gamer1_name, $gamer2_name) {
   foreach($tournir_node as $event_node) {
     if (((string)$event_node['Gamer1_Name'] == $gamer1_name) and ((string)$event_node['Gamer2_Name'] == $gamer2_name)) 
       return $event_node;
   }
   $event_node = $tournir_node->addChild('Event');
   $event_node->addAttribute('DateTime', date('Y-m-d\TH:i:s', $datetime));
   $event_node->addAttribute('Gamer1_Name', $gamer1_name);
   $event_node->addAttribute('Gamer2_Name', $gamer2_name);
   return $event_node;
}

function extract_bets_12(&$tournir_node, $html) {
  $tournir_id = (string)$tournir_node['Id'];
  $html = kill_space($html);
  $html = numbering_tag($html, 'tr');
  $html = extract_numbered_tags($html, 'tr', "\r\n", 'class');
  $html = kill_property($html, 'TagNo');
  $table_rows = explode("\r\n", $html);
//  file_put_contents("lines/bwin/$tournir_id.12.html", $html);  
  foreach($table_rows as $row) {
    $header = copy_be($row, '<tr', '>');
    $row_class_name = extract_property_values($header, 'class', null);
    if ($row_class_name == 'topbar') { // разбираем дату
      $row = copy_between($row, '<h3>', '</h3>');
      list($day_no, $month_no, $year_no) = decode_date($row);
    } elseif ($row_class_name == 'normal') { // основная ставка
      // берем время из первой ячейки
      $time = copy_be($row, '<td', '</td>', 'leftcell minwidth');
      $time = copy_between($time, '>', '<');
      list($hour, $minute) = decode_time($time);
      $event_datetime = mktime($hour, $minute, 0, $month_no, $day_no, $year_no);
      // берем первую табличку
      list($gamer1_name, $win1_koef) = extract_gamer_koef(take_be($row, '<table', '</table>'));
      list($gamer2_name, $win2_koef) = extract_gamer_koef(take_be($row, '<table', '</table>'));
      $event_node = event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
      $event_node->addChild('Win1', $win1_koef);
      $event_node->addChild('Win2', $win2_koef);
    }
  }
}

function extract_bets_total(&$tournir_node, $html) {
  $tournir_id = (string)$tournir_node['Id'];
  $html = kill_space($html);
  $html = numbering_tag($html, 'tr');
  $html = extract_numbered_tags($html, 'tr', "\r\n", 'class');
  $html = kill_property($html, 'TagNo');
  $table_rows = explode("\r\n", $html);
  file_put_contents("lines/bwin/$tournir_id.Total.html", $html);  
  foreach($table_rows as $row) {
    $header = copy_be($row, '<tr', '>');
    $row_class_name = extract_property_values($header, 'class', null);
    if ($row_class_name == 'topbar') { // разбираем дату
      $row = copy_between($row, '<h3>', '</h3>');
      list($day_no, $month_no, $year_no) = decode_date($row);
    } elseif ($row_class_name == 'def') {// игроки + время
      if (preg_match('/<h4>(.+) - (.+) - (\d{1,2}:\d\d (PM|AM))<\/h4>/i', $row, $matches)) {
        $gamer1_name = $matches[1];
        $gamer2_name = $matches[2];
        list($hour, $minute) = decode_time($matches[3]);
        $event_node = event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
      } elseif (preg_match('/<h5>(.+)<\/h5>/i', $row, $matches)){
          
      }
    } elseif ($row_class_name == 'normal') { // основная ставка
    }
  }
}
  
function extract_bets(&$tournir_node, $html, $category_id) {
  $tournir_id = (string)$tournir_node['Id'];
  $html = numbering_tag($html, 'div');
  $html = extract_numbered_tags($html, 'div', "", "bet-list");
  $html = extract_numbered_tags($html, 'div', "", "dsBodyContent");
  $html = extract_numbered_tags($html, 'div', "", "ControlContent");
  if ($category_id == 33) {
    extract_bets_12($tournir_node, $html);
  } elseif ($category_id == 36) {
    extract_bets_total($tournir_node, $html);
  }
  file_put_contents("lines/bwin/$tournir_id.$category_id.bet.html", $html);  
}

function to_be_continue($html) {
  return false;
}
  
function scan_line_bwin(&$sport_node, $categories, $debug = null) {
  global $host, $booker;
  if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
  $league_path = "lines/$booker/$sport_node.";
  
  // получаем перечень турниров
  $file_name = $league_path."league.html";
  $html = download_or_load($debug, $file_name, "$host/$sport_node?ShowDays=168", "GET", $proxy, "");
  extract_league($sport_node, $html);
  
  foreach($categories as $category_id) {
    foreach($sport_node as $tournir_node) {
      $tournir_id = (string)$tournir_node['Id'];
      $current_page = 0;
      do {
        $current_page++;
        $file_name = $league_path."$tournir_id.$category_id.$current_page.html";
        $url= "$host/betviewiframe.aspx?sorting=leaguedate&categoryIDs=$category_id&bv=bb&leagueIDs=$tournir_id";
        $html = download_or_load($debug, $file_name, $url, "GET", $proxy, "$host/$sport_node?ShowDays=168");
        extract_bets($tournir_node, $html, $category_id);
      } while (to_be_continue($html));
    }
  }
  
  if ($debug) file_put_contents($league_path."league.xml", $sport_node->asXML());
}
?>
<?php
//  $booker = 'bwin';
//  require "bwin_xml.php";
  $debug = 1;
  $sport_sign = 'tennis';
    
  $xml = new SimpleXMLElement("<Scan/>");
  $sport_node = $xml->addChild("Sport", $sport_sign);
    
  scan_line_bwin($sport_node, array(33,36), $debug);
  
  $league_path = "lines/$booker/$sport_node.";
  
  file_put_contents($league_path."league.xml", $xml->asXML());
  print $xml->asXML();
?>