<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  
function extract_league(&$sport_node, $html) {
  $html = kill_space($html);
  $html = extract_tags($html, '<noscript>', '</noscript>', '', 'sportNavigationRegionExpandedNew');
  $html = str_ireplace('<div class="leftnav">', '@@@<div class="leftnav">', $html);
  $html = numbering_tag($html, 'div');
  $regions = explode('@@@', $html);
  unset($regions[0]);
  foreach($regions as $region) {
    // получаем название региона
    $region_name = copy_be($region, '<a', '</a>', 'sportsNavigationArrowButtonNew');
    $region_name = copy_between($region_name, '>', '</a');
    $tournirs = extract_all_tags($region, '<a href=\'betsnew.aspx?leagueids=', '</a>');
    foreach($tournirs as $tournir) {
      $tournir_name = copy_between($tournir, '>', '</a');
      preg_match('/(.+) \((\d+)\)$/m', $tournir_name, $matches);
      $tournir_name = $matches[1];
      // бракуем турниры
      $tournir_node = $sport_node->addChild('Tournir', $tournir_name);
      $league = copy_be($tournir, '<a', '>', 'leagueids');
      $league_id = copy_between($league, 'leagueids=', "'");
      $tournir_node->addAttribute('Id', $league_id);
      $tournir_node->addAttribute('Region_Name', $region_name);
    }
  }
}

function bwin_get_tournirs(&$sport_node, $sport_sign, $debug=null) {
  $host = 'https://www.bwin.com';
  $booker = 'bwin';
  if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
  $league_path = "lines/$booker/$sport_sign.";
  
  // получаем перечень турниров
  $file_name = $league_path."league.html";
  $html = download_or_load($debug, $file_name, "$host/$sport_sign?ShowDays=168", "GET", $proxy, "");
  extract_league($sport_node, $html);
  if ($debug) file_put_contents($league_path."league.xml", $sport_node->asXML());
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

function extract_bets_1x2(&$tournir_node, $html, $sport_sign, $tournir_id) {
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
      if ($win1_koef) $event_node->addChild('Match_Win_Gamer1', $win1_koef);
      if ($draw_koef) $event_node->addChild('Match_Draw', $draw_koef);
      if ($win2_koef) $event_node->addChild('Match_Win_Gamer2', $win2_koef);
    }
  }
}

function extract_bets_foratotal(&$tournir_node, $html, $sport_sign, $tournir_id) {
  $i = 0;
  $filename_headers = "phrases/bwin/$sport_sign.headers.txt";
  $filename_labels = "phrases/bwin/$sport_sign.labels.txt";
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
  // отбираем новые и складываем их в новый файл
  if ($phrases_headers_modified) {
    $file_hash = file_get_hash($filename_headers);
    foreach($file_hash as $key=>$value) unset($phrases_headers[$key]);
    file_put_hash($filename_headers.'.new', $phrases_headers+file_get_hash($filename_headers.'.new'));
  }
  if ($phrases_labels_modified) {
    $file_hash = file_get_hash($filename_labels);
    foreach($file_hash as $key=>$value) unset($phrases_labels[$key]);
    file_put_hash($filename_labels.'.new', $phrases_labels+file_get_hash($filename_labels.'.new'));
  }
}
  
function extract_bets(&$tournir_node, $html, $sport_sign, $tournir_id, $category_id) {
  $html = str_ireplace('<wbr/>', '', $html);
  $html = numbering_tag($html, 'div');
  $html = extract_numbered_tags($html, 'div', "", "bet-list");
  $html = extract_numbered_tags($html, 'div', "", "dsBodyContent");
  $html = extract_numbered_tags($html, 'div', "", "ControlContent");
    
  if (in_array($category_id, array(33,25))) {
    if ($html <> '') extract_bets_1x2($tournir_node, $html, $sport_sign, $tournir_id);
  } elseif (in_array($category_id, array(35,36,524))) {
    if ($html <> '') extract_bets_foratotal($tournir_node, $html, $sport_sign, $tournir_id);
  }
  file_put_contents("lines/bwin/$sport_sign.$tournir_id.$category_id.html", $html);  
}

function to_be_continue($html) {
  return false;
}
  
function bwin_get_bets(&$tournir_node, $sport_sign, $tournir_id, $categories, $debug = null) {
  $booker = 'bwin';
  $host = 'https://www.bwin.com';
  if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
  $league_path = "lines/$booker/$sport_sign.";
  
  foreach($categories as $category_id) {
    $current_page = 0;
    do {
      $current_page++;
      $file_name = $league_path."$tournir_id.$category_id.$current_page.html";
      $url= "$host/betviewiframe.aspx?sorting=leaguedate&categoryIDs=$category_id&bv=bb&leagueIDs=$tournir_id";
      $html = download_or_load($debug, $file_name, $url, "GET", $proxy, "$host/$sport_sign?ShowDays=168");
      extract_bets($tournir_node, $html, $sport_sign, $tournir_id, $category_id);
    } while (to_be_continue($html));
  }
  
  if ($debug) file_put_contents($league_path."$tournir_id.xml", $tournir_node->asXML());
}

function bwin_get_events(&$tournir_node, $sport_sign, $tournir_id, $debug) {
  if ($sport_sign == 'tennis') {
    $categories = array(  33 //2Way - Who will win? 
                       ,  35 //Set related bets
                       ,  36 //Number of games
                       , 524 //Tie breaks
                       );
  } elseif ($sport_sign == 'football') {
    $categories = array(  25 //3Way
                       ,  28 //3Way Handicap
                       ,  30 //Halftime result
                       ,  31 //Number of goals?
                       , 190 //Double chance
                       , 266 //Corners
                       , 271 //Yellow/Red cards
                       ,1228 //Odd/Even
                       );
  } 
  bwin_get_bets($tournir_node, $sport_sign, $tournir_id, $categories, $debug);
}


?>
<?php
function bwin_load_sport($sport_sign) {
  $booker = 'bwin';
  $host = 'https://www.bwin.com';
  $debug = 1;
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Scan/>');
  $sport_node = $xml->addChild("Sport", $sport_sign);
  bwin_get_tournirs($sport_node, $sport_sign, $debug);
  foreach($sport_node as $tournir_node) bwin_get_events($tournir_node, $sport_sign, $tournir_node['Id'], $debug);
  file_put_contents("lines/$booker/$sport_sign.xml", $xml->asXML());
  print $xml->asXML();
  unset($xml);
}
    
//  bwin_load_sport('tennis');
  bwin_load_sport('football');
?>