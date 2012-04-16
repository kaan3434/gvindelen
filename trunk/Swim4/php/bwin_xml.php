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

function extract_label_koef($html) {
  $html = kill_tag_bound($html, 'div|tr');
  $label = delete_all(copy_be($html, '<td', '</td>', 'label'), '<', '>');
  $koef = delete_all(copy_be($html, '<td', '</td>', 'odd'), '<', '>');
  return array($label, $koef);
}

function event_find_or_create(&$tournir_node, $datetime, $gamer1_name, $gamer2_name) {
   foreach($tournir_node as $event_node) {
     if (((string)$event_node['Gamer1_Name'] == $gamer1_name) and ((string)$event_node['Gamer1_Name'] == $gamer1_name))
       return $event_node;
   }
   $event_node = $tournir_node->addChild('Event', $event_id);
   $event_node->addAttribute('DateTime', date('Y-m-d\TH:i:s', $datetime));
   $event_node->addAttribute('Gamer1_Name', $gamer1_name);
   $event_node->addAttribute('Gamer2_Name', $gamer2_name);
   return $event_node;
}

function extract_bets_1x2(&$tournir_node, $html) {
  $tournir_id = (string)$tournir_node['Id'];
  $html = kill_space($html);
  $html = numbering_tag($html, 'tr');
  $table_rows = extract_all_numbered_tags($html, 'tr', 'class');
//  file_put_contents("lines/bwin/$tournir_id.12.html", $html);  
  foreach($table_rows as $row) {
    $row = kill_property($row, 'TagNo');
    $gamer1_name = null;
    $gamer2_name = null;
    $win1_koef = null;
    $win2_koef = null;
    $draw_koef = null;
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
      $tables = extract_all_tags($row, '<table', '</table>');
      foreach($tables as $table) {
        list($label, $koef) = extract_label_koef($table);
        if ($label == 'X') {
          $draw_koef = $koef;
        } elseif (!$gamer1_name) {
          $gamer1_name = $label;
          $win1_koef = $koef; 
        } else {
          $gamer2_name = $label;
          $win2_koef = $koef;
        }
      }
      $event_node = event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
      if ($win1_koef) $event_node->addChild('Match_Win1', $win1_koef);
      if ($draw_koef) $event_node->addChild('Match_Draw', $draw_koef);
      if ($win2_koef) $event_node->addChild('Match_Win2', $win2_koef);
    }
  }
}

function extract_bets_foratotal(&$tournir_node, $html) {
  $i = 0;
  $tournir_id = (string)$tournir_node['Id'];
  $filename_headers = "phrases/bwin/headers.txt";
  $filename_labels = "phrases/bwin/labels.txt";
  $phrases_headers = file_get_hash($filename_headers);
  $phrases_labels = file_get_hash($filename_labels);
  $html = kill_space($html);
  $html = numbering_tag($html, 'tr');
  $table_rows = extract_all_numbered_tags($html, 'tr', 'class');
//  file_put_contents("lines/bwin/$tournir_id.Total.html", $html);  
  foreach($table_rows as $row) {
    $row = kill_property($row, 'TagNo');
    $modifier = null;
    $header = copy_be($row, '<tr', '>');
    $row_class_name = extract_property_values($header, 'class', null);
    if ($row_class_name == 'topbar') { // разбираем дату
      $row = copy_between($row, '<h3>', '</h3>');
      list($day_no, $month_no, $year_no) = decode_date($row);
    } elseif (in_array($row_class_name, array('def', 'alt'))) {// игроки + время
      if (preg_match('/<td.*>(<h4>)*?(.+) - (.+) - (\d{1,2}:\d\d (PM|AM))(<\/h4>)*?</Ui', $row, $matches)) {
        $gamer1_name = $matches[2];
        $gamer2_name = $matches[3];
        list($hour, $minute) = decode_time($matches[4]);
      } elseif (preg_match('/<td.*>(<h5>)*?(.+)(<\/h5>)*?</iU', $row, $matches)){
        $phrase = $matches[2];
        $bettype = null;
        $phrase = str_ireplace($gamer1_name, '1', $phrase);
        $phrase = str_ireplace($gamer2_name, '2', $phrase);
        if (!$bettype = $phrases_headers[$phrase]) {
          $bettype = 'Unknown';
          $phrases_headers[$phrase] = $bettype;
          $phrases_headers_modified = true;
        }
      }
    } elseif (($row_class_name == 'normal') and ($bettype)) {  // основная ставка
      if (!in_array($bettype, array('Ignore', 'Unknown'))) { // игнорируемые типы?
        $tables = extract_all_tags($row, '<table', '</table>');
        foreach($tables as $table) {
          list($label, $koef) = extract_label_koef($table);
          $modifier = null;
          $label = str_ireplace($gamer1_name, '1', $label);
          $label = str_ireplace($gamer2_name, '2', $label);
          if (preg_match('/ ([\+\-]?\d+[\.\,]*\d*)/', $label, $matches)) $value = $matches[1];
          // подбираем формат фразы метки
          if (!$modifier = $phrases_labels[$label]) {
            $modifier = 'Unknown';
            $phrases_labels[$label] = $modifier;
            $phrases_labels_modified = true;
          }
          if (!in_array($modifier, array('Ignore', 'Unknown'))) { // игнорируемый лабел
            $event_node = event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
            $bet_node = $event_node->addChild($bettype.$modifier, $koef);
            if ($value) $bet_node->addAttribute('Value', strtr($value, ',', '.'));
          }
        }  
      }
    }
    $i++;
  }
  if ($phrases_headers_modified) file_put_hash($filename_headers, $phrases_headers);
  if ($phrases_labels_modified) file_put_hash($filename_labels, $phrases_labels);
}
  
function extract_bets(&$tournir_node, $html, $category_id) {
  $tournir_id = (string)$tournir_node['Id'];
  $html = str_ireplace('<wbr/>', '', $html);
  $html = numbering_tag($html, 'div');
  $html = extract_numbered_tags($html, 'div', "", "bet-list");
  $html = extract_numbered_tags($html, 'div', "", "dsBodyContent");
  $html = extract_numbered_tags($html, 'div', "", "ControlContent");
    
  if (in_array($category_id, array(33))) {
    if ($html <> '') extract_bets_1x2($tournir_node, $html);
  } elseif (in_array($category_id, array(36))) {
    if ($html <> '') extract_bets_foratotal($tournir_node, $html);
  }
  file_put_contents("lines/bwin/$tournir_id.$category_id.html", $html);  
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
    
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Scan/>');

  $sport_node = $xml->addChild("Sport", 'tennis');
  scan_line_bwin($sport_node, array(  33 //2Way - Who will win? 
                                   ,  35 //Set related bets
                                   ,  36 //Number of games
                                   , 524 //Tie breaks
                                   ), $debug);
  $sport_node = $xml->addChild("Sport", 'football');
  scan_line_bwin($sport_node, array(  25 //3Way
                                   ,  28 //3Way Handicap
                                   ,  30 //Halftime result
                                   ,  31 //Number of goals?
                                   , 190
                                   , 266
                                   , 271),$debug);
  
  
  $league_path = "lines/$booker/$sport_node.";
  
  file_put_contents($league_path."league.xml", $xml->asXML());

  print $xml->asXML();
?>