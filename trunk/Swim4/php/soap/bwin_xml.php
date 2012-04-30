<?php
  require_once"libs/Download.php";
  require_once"libs/GvStrings.php";
  require_once"libs/GvHtmlSrv.php";
  require_once"libs/utf2win.php";
  require_once"booker_xml.php";
  
class bwin_booker extends booker_xml {
  
  function __construct() { 
    $this->booker = 'bwin'; 
    $this->host = 'https://www.bwin.com';
    $this->debug = 1;
  }
  
  private function extract_league(&$sport_node, $html) {
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
        if (!preg_match('/(- live)/', $tournir_name)) {
          $tournir_node = $sport_node->addChild('Tournir');
          $league = copy_be($tournir, '<a', '>', 'leagueids');
          $league_id = copy_between($league, 'leagueids=', "'");
          $tournir_node->addAttribute('Id', $league_id);
          $tournir_node->addAttribute('Region_Name', $region_name);
          $tournir_node->addAttribute('Name',  $tournir_name);
        }
      }
    }
  }
  
  public function getTournirs(&$sport_node, $sport_sign) {
    if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
    $league_path = $this->getLeaguePath($sport_sign);
  
    // получаем перечень турниров
    $file_name = $league_path."league.html";
    $html = download_or_load($this->debug, $file_name, "{$this->host}/$sport_sign?ShowDays=168", "GET", $proxy, "");
    $this->extract_league($sport_node, $html);
    if ($this->debug) file_put_contents($league_path."league.xml", $sport_node->asXML());
  }

  private function decode_date($str) {
    if (preg_match('/(\w+) (\d{1,2}), (\d{4})/i', $str, $matches)) { //MMM DD, YYYY
      $month_no = decode_month_name($matches[1]);
      $year_no = $matches[3];
      $day_no = $matches[2];
    }
    return array($day_no, $month_no, $year_no);
  }

  private function decode_time($str) {
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

  private function extract_label_koef($html) {
    $html = kill_tag_bound($html, 'div|tr');
    $label = delete_all(copy_be($html, '<td', '</td>', 'label'), '<', '>');
    $koef = delete_all(copy_be($html, '<td', '</td>', '\'odd\''), '<', '>');
    return array($label, $koef);
  }

  private function event_find_or_create(&$tournir_node, $datetime, $gamer1_name, $gamer2_name) {
     foreach($tournir_node as $event_node) {
       if (((string)$event_node['Gamer1_Name'] == $gamer1_name) and ((string)$event_node['Gamer1_Name'] == $gamer1_name))
         return $event_node;
     }
     $event_node = $tournir_node->addChild('Event');
     $event_node->addAttribute('DateTime', date('Y-m-d\TH:i:s', $datetime));
     $event_node->addAttribute('Gamer1_Name', $gamer1_name);
     $event_node->addAttribute('Gamer2_Name', $gamer2_name);
     return $event_node;
  }

  private function extract_bets_1x2(&$tournir_node, $html, $sport_sign, $tournir_id, $category_id) {
    $tournir_id = (string)$tournir_node['Id'];
    $html = kill_space($html);
    $html = numbering_tag($html, 'tr');
    $table_rows = extract_all_numbered_tags($html, 'tr', 'class');
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
        list($day_no, $month_no, $year_no) = $this->decode_date($row);
      } elseif ($row_class_name == 'normal') { // основная ставка
        // берем время из первой ячейки
        $time = copy_be($row, '<td', '</td>', 'leftcell minwidth');
        $time = copy_between($time, '>', '<');
        list($hour, $minute) = $this->decode_time($time);
        $tables = extract_all_tags($row, '<table', '</table>');

        foreach($tables as $table) {
          list($label, $koef) = $this->extract_label_koef($table);
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
        $event_node = $this->event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
        if ($win1_koef) {
          $this->addBet($event_node, "Period=Match;Gamer=1;Kind=Win;Koef=$win1_koef");
        }  
        if ($draw_koef) {
          $this->addBet($event_node, "Period=Match;Kind=Total;Kind=Draw;Koef=$draw_koef");
        }  
        if ($win2_koef) {
          $this->addBet($event_node, "Period=Match;Gamer=2;Kind=Win;Koef=$win2_koef");
        }
      }
    }
  }

  private function extract_bets_noannotated(&$tournir_node, $html, $sport_sign, $tournir_id, $category_id) {
    $phrases_headers = $this->getPhrasesHeaders($sport_sign);
    $phrases_labels = $this->getPhrasesLabels($sport_sign);
    $html = kill_space($html);
    $html = numbering_tag($html, 'tr');
    $table_rows = extract_all_numbered_tags($html, 'tr', 'class');
    foreach($table_rows as $row) {
      $row = kill_property($row, 'TagNo');
      $header = copy_be($row, '<tr', '>');
      $row_class_name = extract_property_values($header, 'class', null);
      if ($row_class_name == 'topbar') { // разбираем дату
        $row = copy_between($row, '<h3>', '</h3>');
        list($day_no, $month_no, $year_no) = $this->decode_date($row);
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
            list($label, $koef) = $this->extract_label_koef($table);
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
          $event_node = $this->event_find_or_create($tournir_node, mktime(0, 0, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
          if ($win1_koef) {
            $this->addBet($event_node, implode_hash(';', $bettype).";Gamer=1;Koef=$win1_koef");
          }  
          if ($draw_koef) {
            $this->addBet($event_node, implode_hash(';', $bettype).";Kind=Draw;Koef=$draw_koef");
          }  
          if ($win2_koef) {
            if ($bettype['Kind'] = 'Handicap') $bettype['Value'] = -$bettype['Value'];
            $this->addBet($event_node, implode_hash(';', $bettype).";Gamer=2;Koef=$win2_koef");
          }
        }
      }
      $i++;
    }
    // отбираем новые и складываем их в новый файл
    if ($phrases_headers_modified) $this->putNewPhrasesHeaders($phrases_headers, $sport_sign);
    if ($phrases_labels_modified) $this->putNewPhrasesLabels($phrases_labels, $sport_sign);
  }

  private function extract_bets_foratotal(&$tournir_node, $html, $sport_sign, $tournir_id, $category_id) {
    $i = 0;
    $phrases_headers = $this->getPhrasesHeaders($sport_sign);
    $phrases_labels = $this->getPhrasesLabels($sport_sign);
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
        list($day_no, $month_no, $year_no) = $this->decode_date($row);
      } elseif (in_array($row_class_name, array('def', 'alt'))) {// игроки + время
        if (preg_match('/<td.*>(<h4>)*?(.+) - (.+) - (\d{1,2}:\d\d (PM|AM))(.*?)(<\/h4>)*?</Ui', $row, $matches)) {
          $gamer1_name = utf8_to_ansi_ce($matches[2]);
          $gamer2_name = utf8_to_ansi_ce($matches[3]);
          list($hour, $minute) = $this->decode_time($matches[4]);
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
            list($label, $koef) = $this->extract_label_koef($table);
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
              $event_node = $this->event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
              $this->addBet($event_node, implode_hash(';', $bettype).";Koef=$koef");
            }                
            unset($bettype['Modifier']);
          }  
        }
      }
      $i++;
    }
    // отбираем новые и складываем их в новый файл
    if ($phrases_headers_modified) $this->putNewPhrasesHeaders($phrases_headers, $sport_sign);
    if ($phrases_labels_modified) $this->putNewPhrasesLabels($phrases_labels, $sport_sign);
  }
  
  private function extract_bets(&$tournir_node, $html, $sport_sign, $tournir_id, $category_id) {
    $html = str_ireplace('<wbr/>', '', $html);
    $html = numbering_tag($html, 'div');
    $html = extract_numbered_tags($html, 'div', "", "bet-list");
    $html = extract_numbered_tags($html, 'div', "", "dsBodyContent");
    $html = extract_numbered_tags($html, 'div', "", "ControlContent");
      
    if (in_array($category_id, array(33,25))) {
      if ($html <> '') $this->extract_bets_1x2($tournir_node, $html, $sport_sign, $tournir_id, $category_id);
    } elseif (in_array($category_id, array(28,30))) {
      if ($html <> '') $this->extract_bets_noannotated($tournir_node, $html, $sport_sign, $tournir_id, $category_id);  
    } elseif (in_array($category_id, array(35,36,524, 31,190,266,271,1228))) {
      if ($html <> '') $this->extract_bets_foratotal($tournir_node, $html, $sport_sign, $tournir_id, $category_id);
    }
  }

  private function to_be_continue($html, $next_page) {
    $html = copy_be($html, '<a', '>', 'pagingGotoItem', "currentPage=$next_page");
    return $html <> '';
  }
    
  private function getBets(&$tournir_node, $sport_sign, $tournir_id, $categories) {
    if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
    $league_path = $this->getLeaguePath($sport_sign);
    
    foreach($categories as $category_id) {
      $current_page = 0;
      do {
        $current_page++;
        $file_name = $league_path."$tournir_id.$category_id.$current_page.html";
        $url= "{$this->host}/betviewiframe.aspx?sorting=leaguedate&categoryIDs=$category_id&bv=bb&leagueIDs=$tournir_id";
        $html = download_or_load($this->debug, $file_name, $url, "GET", $proxy, "{$this->host}/$sport_sign?ShowDays=168");
        $this->extract_bets($tournir_node, $html, $sport_sign, $tournir_id, $category_id);
      } while ($this->to_be_continue($html, $current_page+1));
    }
    
    if ($this->debug) file_put_contents($league_path."$tournir_id.xml", $tournir_node->asXML());
  }

  function getEvents(&$tournir_node, $sport_sign, $tournir_id) {
    if ($sport_sign == 'tennis') {
      $categories = array(  33 //2Way - Who will win? 
                         ,  35 //Set related bets
                         ,  36 //Number of games
                         , 524 //Tie breaks
                         );
    } elseif ($sport_sign == 'football') {
      $categories = array(  25 //3Way
                         // annodated
                         , 190 //Double chance
                         ,  31 //Number of goals?
                         , 266 //Corners
                         , 271 //Yellow/Red cards
                         ,1228 //Odd/Even
                         // noannotated
                         ,  28 //3Way Handicap
                         ,  30 //Halftime result
                         );
    } 
    $this->getBets($tournir_node, $sport_sign, $tournir_id, $categories);
  }

}
?>
