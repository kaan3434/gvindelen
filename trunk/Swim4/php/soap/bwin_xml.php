<?php
  require_once "libs/Download.php";
  require_once "libs/GvStrings.php";
  require_once "libs/GvHtmlSrv.php";
  require_once "libs/utf2win.php";
  require_once "booker_xml.php";
  
class booker extends booker_xml {
  
  private $categories;
  
  function __construct() { 
    $this->booker = 'bwin'; 
    $this->host = 'https://sports.bwin.com';
    parent::__construct();
  }
  
  public function extract_league(&$tournirs_node, $html) {
    $html = kill_space($html);
    $html = numbering_tag($html, 'ul');
    $html = numbering_tag($html, 'li');
    $groups = extract_all_numbered_tags($html, 'ul', 'nav-');
    foreach($groups as $group) {
      // получаем название региона
      $regions = extract_all_numbered_tags($group, 'li', 'nav-toggle');
      foreach($regions as $region) {
        $tournirs = extract_all_numbered_tags($region, 'li', 'nav-league');
        $region = kill_property($region, 'TagNo');
        $region = delete_all($region, '<ul', '</ul>');
        $region_name = delete_all($region, '<', '>');
        foreach($tournirs as $tournir) {
          $tournir = copy_be($tournir, '<a', '</a>');
          $tournir_name = copy_between($tournir, '>', '</a');
          preg_match('/(.+) \((\d+)\)$/m', $tournir_name, $matches);
          $tournir_name = $matches[1];
          if (!preg_match('/(- live)/', $tournir_name)) {
            $tournir_url = extract_property_values($tournir, 'href', '');
            preg_match('|/(\d+)/betting|m', $tournir_url, $matches);
            $tournir_node = $tournirs_node->addChild('Tournir');
            $tournir_node->addAttribute('Id', $matches[1]);
            $tournir_node->addAttribute('Region', $region_name);
            $tournir_node->addAttribute('Title',  $tournir_name);
            $tournir_node->addAttribute('Url',  $tournir_url);
          }
        }
      }
    }
  }
  
  public function getTournirs($sport_id) {
    // Зачитываем настройку конторы
    $xml = parent::getTournirs($sport_id);
    $tournirs_node = $xml->addChild('Tournirs');

    // получаем перечень турниров
    $file_name = $this->league_path."league";
    $url = $this->host.$this->sport_node['Url'];
    //copy("cookies.etalon/www.bwin.com.txt", "cookies/www.bwin.com.txt");
    $html = download_or_load($this->debug, $file_name.".html", $url, "GET", "");
    $this->extract_league($tournirs_node, $html);
    if ($this->debug) file_put_contents($file_name.".xml", $xml->asXML());
    return $xml;
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
    $label = html_to_utf8($label);
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

  private function extract_new_event(&$tournir_node, $html, $sport_sign, $phrase, $event_dtm) {
    $tables = extract_all_tags($html, '<table', '</table>');
    $gamer1_name = null;
    $gamer2_name = null;
    foreach($tables as $table) {
      list($label, $koef) = $this->extract_label_koef($table);
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
    $event_node = $this->event_find_or_create($tournir_node, $event_dtm, $gamer1_name, $gamer2_name);
    if ($win1_koef) {
      $phrase_node = $this->findPhrase($sport_sign, $phrase, 'Gamer1');
      if (!$phrase_node['Ignore'])
        $this->addBet($event_node, (string)$phrase_node['BetKind'].';Koef='.$win1_koef);
    }  
    if ($draw_koef) {
      $phrase_node = $this->findPhrase($sport_sign, $phrase, 'X');
      if (!$phrase_node['Ignore'])
        $this->addBet($event_node, (string)$phrase_node['BetKind'].';Koef='.$draw_koef);
    }  
    if ($win2_koef) {
      $phrase_node = $this->findPhrase($sport_sign, $phrase, 'Gamer2');
      if (!$phrase_node['Ignore'])
        $this->addBet($event_node, (string)$phrase_node['BetKind'].';Koef='.$win2_koef);
    }
  }
  
  private function extract_bets_1x2(&$tournir_node, $html, $sport_sign) {
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
        $this->extract_new_event($tournir_node, $row, $sport_sign, '1x2', mktime($hour, $minute, 0, $month_no, $day_no, $year_no));
      }
    }
  }

  private function extract_bets_noannotated(&$tournir_node, $html, $sport_sign) {
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
          $section_node = $this->findSection($sport_sign, $phrase);
        }
      } elseif ($row_class_name == 'normal') {  // основная ставка  
        if (!$section_node['Ignore'])
          $this->extract_new_event($tournir_node, $row, $sport_sign, $phrase, mktime(0, 0, 0, $month_no, $day_no, $year_no)); 
      }
    }
  }

  private function extract_bets_foratotal(&$tournir_node, $html, $sport_sign) {
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
      } elseif (in_array($row_class_name, array('def', 'alt'))) {// игроки + время
        if (preg_match('/<td.*>(<h4>)*?(.+)? - (.+)?( \(Neutral Venue\))? - (\d{1,2}:\d\d (PM|AM))(.*?)(<\/h4>)*?</Ui', $row, $matches)) {
          $gamer1_name = $matches[2];
          $gamer2_name = $matches[3];
          list($hour, $minute) = $this->decode_time($matches[4]);
        } elseif (preg_match('/<td.*>(<h[45]>)*?(.+)(<\/h[45]>)*?</iU', $row, $matches)){
          $phrase = $matches[2];
          $phrase = str_ireplace($gamer1_name, 'Gamer1', $phrase);
          $phrase = str_ireplace($gamer2_name, 'Gamer2', $phrase);
          $section_node = $this->findSection($sport_sign, $phrase);
        }
      } elseif (($row_class_name == 'normal') and (!$section_node['Ignore'])) {  // основная ставка
        if ($section_node['NewEvent']) {
          $this->extract_new_event($tournir_node, $row, $sport_sign, $phrase, mktime($hour, $minute, 0, $month_no, $day_no, $year_no));
        } else {
          $tables = extract_all_tags($row, '<table', '</table>');
          foreach($tables as $table) {
            list($label, $koef) = $this->extract_label_koef($table);
            $label = str_ireplace($gamer1_name, 'Gamer1', $label);
            $label = str_ireplace($gamer2_name, 'Gamer2', $label);
            // подбираем формат фразы метки
            $phrase_node = $this->findPhrase($sport_sign, $phrase, $label);
            if (!$phrase_node['Ignore']) {
                $event_node = $this->event_find_or_create($tournir_node, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
                $this->addBet($event_node, (string)$phrase_node['BetKind'].';Koef='.$koef);
            }
          }  
        }
      }
    }
  }
  
  private function extract_bets(&$tournir_node, $html, $sport_sign, $tournir_id, $parse) {
    $html = kill_space($html);
    $html = numbering_tag($html, 'div');
    $div_heads = extract_all_tags($html, '<div', '>', 'ui-widget-content-body');
    $inner_tagno = 0;
    $inner_div = '';
    foreach ($div_heads as $div_head) {
      $tag_no = extract_tagno($div_head, 'div');
      $div = extract_numbered_tag($html, 'div', $tag_no);
      if ($inner_tagno < $tag_no) {
//        file_put_contents('content.html', $div);
        if (strpos($div, 'betslip')) {
          $inner_div = $div;
          $inner_tagno = $tag_no;
        }
      }
    }
    $html = $inner_div;
//    file_put_contents('content.html', $html);
      
    if ($parse == '1x2') {
      if ($html <> '') $this->extract_bets_1x2($tournir_node, $html, $sport_sign);
    } elseif ($parse == 'NoAnnotated') {
      if ($html <> '') $this->extract_bets_noannotated($tournir_node, $html, $sport_sign);  
    } elseif ($parse == 'Annotated') {
      if ($html <> '') $this->extract_bets_foratotal($tournir_node, $html, $sport_sign);
    }
  }

  private function to_be_continue($html, $next_page) {
    $html = copy_be($html, '<a', '>', 'pagingGotoItem', "currentPage=$next_page");
    return ($html);
  }
    
  private function extract_categories($html) {
    $html = copy_be($html, '<ul', '</ul>', 'cat-filter-list');
    $categories = extract_all_tags($html, '<input', '>', 'checkbox', 'categoryIds');
    foreach($categories as $category) {
      $this->categories[copy_between($category, 'value="', '"')] = 1;
    }
  } 
    
  private function getBets(&$tournir_node, $sport_id, $tournir_id, $tournir_url) {
    foreach($this->sport_node as $category_node) {
      $category_id = (string) $category_node['Id'];
      $parse = (string) $category_node['Parse'];
      $current_page = 0;
      do {
        $file_name = $this->league_path."$tournir_id.$category_id.$current_page.html";
        $url= $this->host."/en/sports/indexmultileague";
        $referer = $this->host.(string)$this->sport_node['Url'];
        $post_hash['sportId'] = (string) $this->sport_node['SportId'];
        $post_hash['leagueIds'] = $tournir_id;
        $post_hash['categoryIds'] = $category_id;
        $post_hash['page'] = $current_page;
        $html = download_or_load($this->debug, $file_name, $url, "POST", $referer, $post_hash);
        if (!$this->categories) 
          $this->extract_categories($html);
        if ($this->categories[$category_id])
          $this->extract_bets($tournir_node, $html, (string) $this->sport_node['Sign'], $tournir_id, $parse);
        $current_page++;
      } while ($this->to_be_continue($html, $current_page+1));
    }
    
  }

  function getEvents($sport_id, $tournir_id, $tournir_url) {
    $xml = parent::getEvents($sport_id, $tournir_id, $tournir_url);
    $tournir_node = $xml->addChild('Events');
    $this->getBets($tournir_node, $sport_id, $tournir_id, $tournir_url);
    if ($this->debug) file_put_contents($this->league_path."$tournir_id.xml", $xml->asXML());
    return $xml;
  }

}
?>
