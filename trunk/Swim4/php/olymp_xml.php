<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  
function extract_league(&$sport_node, $html) {
  $html = copy_be($html, '<td', '</td>', '<h4 ');
  $html = kill_space($html);
  $html = numbering_tag($html, 'div');
  $tournirs = extract_all_numbered_tags($html, 'div', 'rel');
  foreach($tournirs as $tournir) {
    $tournir_name = copy_be($tournir, '<h4', '</h4>');
    $tournir_name = copy_between($tournir_name, '>', '</');
    list($region_name, $tournir_name) = explode('. ', $tournir_name, 2);
    $tournir_node = $sport_node->addChild('Tournir', $tournir_name);
    $league = copy_between($tournir, 'rel="', '"');
    $tournir_node->addAttribute('Id', $league);
    $tournir_node->addAttribute('Region_Name', $region_name);
  }
  file_put_contents("lines/olymp/league.html", $html);
}

function olymp_get_tournirs(&$sport_node, $sport_sign, $debug=null) {
  $host = 'https://olympbet.com';
  $booker = 'olymp';
  if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
  $league_path = "lines/$booker/$sport_sign.";
  
  // получаем перечень турниров
  $file_name = $league_path."league.html";
  $html = download_or_load($debug, $file_name, "$host/$sport_sign-odds.html", "GET", $proxy, "");
  extract_league($sport_node, $html);
  if ($debug) file_put_contents($league_path."league.xml", $sport_node->asXML());
}







function decode_datetime($str) {
  preg_match('/(\d{1,2})\/(\d{2}) (\d{1,2}):(\d\d)/i', $str, $matches);
  $day_no = $matches[1];
  $month_no = $matches[2];
  $hour = $matches[3];
  $minute = $matches[4];
  $year_no = date('Y');
  if (mktime($hour, $minute, 0, $month_no, $day_no, $year_no) < time()-2*100*24*3600) $year_no++;
  return array($day_no, $month_no, $year_no, $hour, $minute);
}

function event_find(&$tournir_node, $event_id) {
   foreach($tournir_node as $event_node) {
     if ((string)$event_node['Id'] == $event_id)
       return $event_node;
   }
   return false;
}

function event_create(&$tournir_node, $event_id, $datetime, $gamer1_name, $gamer2_name) {
   $event_node = $tournir_node->addChild('Event', $event_id);
   $event_node->addAttribute('DateTime', date('Y-m-d\TH:i:s', $datetime));
   $event_node->addAttribute('Gamer1_Name', $gamer1_name);
   $event_node->addAttribute('Gamer2_Name', $gamer2_name);
   return $event_node;
}

function add_bet(&$event_node, $attrs) {
  $bet_node = $event_node->addChild('Bet');
  foreach(explode(';', $attrs) as $bet_pair) {
    list($key, $value) = explode('=', $bet_pair);
    $bet_node->addAttribute($key, strtr($value, ',', '.'));
  }
}

function extract_main_bets(&$tournir_node, $html, $sport_sign, $tournir_id) {
  $subjects_file = "phrases/olymp/$sport_sign.subjects.txt";
  $subjects = file_get_hash($subjects_file);
  $event_id = extract_property_values(copy_be($html, '<ul', '>', 'rel'), 'rel', '');
  $html = kill_tag_bound($html, 'u');
  $cells = extract_all_tags($html, '<li', '</li>');
  $i = 0;
  foreach($cells as $cell) $cells[$i++] = delete_all($cell, '<', '>', 'li');
  list($day_no, $month_no, $year_no, $hour, $minute) = decode_datetime(str_ireplace('<br>', ' ', $cells[0]));
  list($gamer1_name, $gamer2_name) = explode('<br/>', $cells[2]);
  $event_node = event_create($tournir_node, $event_id, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
  if ($cells[3] <> '') add_bet($event_node, 'Period=Match;Gamer=1;Modifier=Win;Koef='.$cells[3]);
  if ($cells[4] <> '') add_bet($event_node, 'Period=Match;Modifier=Draw;Koef='.$cells[4]);
  if ($cells[5] <> '') add_bet($event_node, 'Period=Match;Gamer=2;Modifier=Win;Koef='.$cells[5]);
  if ($cells[6] <> '') add_bet($event_node, 'Period=Match;Kind=DoubleChance;Modifier=NoLose;Gamer=1;Koef='.$cells[6]);
  if ($cells[7] <> '') add_bet($event_node, 'Period=Match;Kind=DoubleChance;Modifier=NoDraw;Koef='.$cells[7]);
  if ($cells[8] <> '') add_bet($event_node, 'Period=Match;Kind=DoubleChance;Modifier=NoLose;Gamer=2;Koef='.$cells[8]);

  if ($cells[9] <> '') {
    preg_match('/\(([\+\-]*?)(.+?)\)<br\/>(.+?)/iU', $cells[9], $matches);
    if ($matches[1] == '') $matches[1] = '+';
    add_bet($event_node, 'Period=Match;Kind=Fora;Value='.$matches[1].$matches[2].';Modifier=Win;Gamer=1;Koef='.$matches[3]);
  }
  if ($cells[10] <> '') {
    preg_match('/\(([\+\-]*?)(.+?)\)<br\/>(.+?)/iU', $cells[10], $matches);
    if ($matches[1] == '') $matches[1] = '+';
    add_bet($event_node, 'Period=Match;Kind=Fora;Value='.$matches[1].$matches[2].';Modifier=Win;Gamer=2;Koef='.$matches[3]);
  }
  if ($cells[12] <> '') {
    $value = $cells[11];
    if (!strpos($value, '.')) $value = $value+0.5;
    add_bet($event_node, 'Period=Match;'.$subjects['MatchTotal'].';Kind=Total;Value='.$value.';Modifier=Under;Koef='.$cells[12]);
  }
  if ($cells[13] <> '') { 
    $value = $cells[11];
    if (!strpos($value, '.')) $value = $value-0.5;
    add_bet($event_node, 'Period=Match;'.$subjects['MatchTotal'].';Kind=Total;Value='.$value.';Modifier=Over;Koef='.$cells[13]);
  }
}

function extract_bets_noannotated(&$tournir_node, $html, $sport_sign, $tournir_id, $category_id) {
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
    $header = copy_be($row, '<tr', '>');
    $row_class_name = extract_property_values($header, 'class', null);
    if ($row_class_name == 'topbar') { // разбираем дату
      $row = copy_between($row, '<h3>', '</h3>');
      list($day_no, $month_no, $year_no) = decode_date($row);
    } elseif (in_array($row_class_name, array('def', 'alt'))) {// заголовок
      if (preg_match('/<td.*>(<h5>)*?(.+)(<\/h5>)*?</iU', $row, $matches)){
        $phrase = $matches[2];
        unset($bettype);
        $bettype_str = $phrases_headers[$phrase];
        if ($bettype_str) {
          foreach(explode(';', $bettype_str) as $bet_pair) {
            list($key, $value) = explode('=', $bet_pair);
            $bettype[$key] = $value;
          }
        } else {    
          $bettype['Modifier'] = 'Unknown';
          $phrases_headers[$phrase] = 'Modifier=Unknown';
          $phrases_headers_modified = true;
        }
      }
    } elseif (($row_class_name == 'normal') and ($bettype)) {  // основная ставка
      if (!in_array($bettype['Modifier'], array('Ignore', 'Unknown'))) {
        $tables = extract_all_tags($row, '<table', '</table>');
        $gamer1_name = null;
        $gamer2_name = null;
        foreach($tables as $table) {
          list($label, $koef) = extract_label_koef($table);
          if ($label == 'X') {
            $draw_koef = $koef;
          } elseif (!$gamer1_name) {
            $gamer1_name = utf8_to_ansi_ce($label);
            $win1_koef = $koef; 
          } else {
            $gamer2_name = utf8_to_ansi_ce($label);
            $win2_koef = $koef;
          }
        }
        $event_node = event_find_or_create($tournir_node, mktime(0, 0, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
        if ($win1_koef) {
          $bet_node = $event_node->addChild('Bet');
          foreach($bettype as $key=>$value) {
            $bet_node->addAttribute($key, $value);
          }
          $bet_node->addAttribute('Modifier', 'Win');
          $bet_node->addAttribute('Gamer', 1);
          $bet_node->addAttribute('Koef', $win1_koef);
        }  
        if ($draw_koef) {
          $bet_node = $event_node->addChild('Bet');
          foreach($bettype as $key=>$value) $bet_node->addAttribute($key, $value);
          $bet_node->addAttribute('Modifier', 'Draw');
          $bet_node->addAttribute('Koef', $draw_koef);
        }  
        if ($win2_koef) {
          $bet_node = $event_node->addChild('Bet');
          if ($bettype['Kind'] = 'Handicap') $bettype['Value'] = -$bettype['Value'];
          foreach($bettype as $key=>$value) $bet_node->addAttribute($key, $value);
          $bet_node->addAttribute('Modifier', 'Win');
          $bet_node->addAttribute('Gamer', 2);
          $bet_node->addAttribute('Koef', $win2_koef);
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

function extract_bets_foratotal(&$tournir_node, $html, $sport_sign, $tournir_id, $category_id) {
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
    $header = copy_be($row, '<tr', '>');
    $row_class_name = extract_property_values($header, 'class', null);
    if ($row_class_name == 'topbar') { // разбираем дату
      $row = copy_between($row, '<h3>', '</h3>');
      list($day_no, $month_no, $year_no) = decode_date($row);
    } elseif (in_array($row_class_name, array('def', 'alt'))) {// игроки + время
      if (preg_match('/<td.*>(<h4>)*?(.+) - (.+) - (\d{1,2}:\d\d (PM|AM))(.*?)(<\/h4>)*?</Ui', $row, $matches)) {
        $gamer1_name = utf8_to_ansi_ce($matches[2]);
        $gamer2_name = utf8_to_ansi_ce($matches[3]);
        list($hour, $minute) = decode_time($matches[4]);
      } elseif (preg_match('/<td.*>(<h5>)*?(.+)(<\/h5>)*?</iU', $row, $matches)){
        $phrase = utf8_to_ansi_ce($matches[2]);
        unset($bettype);
        $phrase = str_ireplace($gamer1_name, 'Gamer1', $phrase);
        $phrase = str_ireplace($gamer2_name, 'Gamer2', $phrase);
        $bettype_str = $phrases_headers[$phrase];
        if ($bettype_str) {
          foreach(explode(';', $bettype_str) as $bet_pair) {
            list($key, $value) = explode('=', $bet_pair);
            $bettype[$key] = $value;
          }
        } else {    
          $bettype['Modifier'] = 'Unknown';
          $phrases_headers[$phrase] = 'Modifier=Unknown';
          $phrases_headers_modified = true;
        }
      }
    } elseif (($row_class_name == 'normal') and ($bettype)) {  // основная ставка
      if (!in_array($bettype['Modifier'], array('Ignore', 'Unknown'))) {
        $tables = extract_all_tags($row, '<table', '</table>');
        foreach($tables as $table) {
          list($label, $koef) = extract_label_koef($table);
          $label = str_ireplace($gamer1_name, 'Gamer1', $label);
          $label = str_ireplace($gamer2_name, 'Gamer2', $label);
          // подбираем формат фразы метки
          $modifier = $phrases_labels[$label];
          if ($modifier) {
            foreach(explode(';', $modifier) as $bet_pair) {
              list($key, $value) = explode('=', $bet_pair);
              $bettype[$key] = $value;
            }
          } else {    
            $bettype['Modifier'] = 'Unknown';
            $phrases_labels[$label] = 'Modifier=Unknown';
            $phrases_labels_modified = true;
          }
          if (!in_array($bettype['Modifier'], array('Ignore', 'Unknown'))) {
            $event_node = event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
            $bet_node = $event_node->addChild('Bet');
            foreach($bettype as $key=>$value) $bet_node->addAttribute($key, $value);
            $bet_node->addAttribute('Koef', $koef);
          }                
          unset($bettype['Modifier']);
          
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
  
function extract_bets(&$tournir_node, $html, $sport_sign, $tournir_id) {
  $html = kill_space($html);
  $html = numbering_tag($html, 'ul');
  $events = extract_all_numbered_tags($html, 'ul', 'e-td');
  foreach($events as $event) {
    extract_main_bets(&$tournir_node, $event, $sport_sign, $tournir_id);
  }
//  file_put_contents("lines/bwin/$sport_sign.$tournir_id.$category_id.html", $html);  
}

function olymp_get_bets(&$tournir_node, $sport_sign, $tournir_id, $debug = null) {
  $booker = 'olymp';
  $host = 'https://www.olympbet.com';
  if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
  $league_path = "lines/$booker/$sport_sign.";
  
  $file_name = $league_path."$tournir_id.html";
  $url="$host/engine.php?act=co&co=$tournir_id";
  $html = download_or_load($debug, $file_name, $url, "GET", $proxy, "$host/$sport_sign-odds.html");
  extract_bets($tournir_node, $html, $sport_sign, $tournir_id);

  if ($debug) file_put_contents($league_path."$tournir_id.xml", $tournir_node->asXML());
}

?>
<?php
function olymp_load_sport($sport_sign) {
  $booker = 'olymp';
  $host = 'https://olympbet.com';
  $debug = 1;
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Scan/>');
  $sport_node = $xml->addChild("Sport", $sport_sign);
  olymp_get_tournirs($sport_node, $sport_sign, $debug);
  foreach($sport_node as $tournir_node) olymp_get_bets($tournir_node, $sport_sign, $tournir_node['Id'], $debug);
  file_put_contents("lines/$booker/$sport_sign.xml", $xml->asXML());
  print $xml->asXML();
  unset($xml);
}
    
  olymp_load_sport('tennis');
//  bwin_load_sport('football');
?>