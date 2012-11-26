<?php
  require_once "libs/Download.php";
  require_once "libs/GvStrings.php";
  require_once "libs/GvHtmlSrv.php";
  require_once "libs/utf2win.php";
  require_once "booker_xml.php";
  
class booker extends booker_xml {
  
  private $header;
  private $year_no;
  private $month_no;
  private $day_no;
  
  function __construct() { 
    $this->booker = 'plusminus'; 
    $this->host = 'http://plusminus1.com';
    parent::__construct();
  }
  
  private function extract_league(&$tournirs_node, $html) {
//    $html = copy_be($html, '<table ', '</table>', 'class="bt"');
    $html = delete_all($html, '<a', '>', 'chSport');
    $tournirs = extract_all_tags($html, '<tr>', '</tr>', 'events[]');
    foreach($tournirs as $tournir) {
      $tournir = kill_space($tournir);
      $tournir_name = copy_be($tournir, '<a', '</a>');
      $tournir_name = copy_between($tournir_name, '>', '</');
      $tournir_node = $tournirs_node->addChild('Tournir');
      $tournir_id = copy_be($tournir, '<input', '>');
      $league = copy_between($tournir_id, 'value=\'', '\'');
      $tournir_node->addAttribute('Id', $league);
      $tournir_node->addAttribute('Region', 'World');
      $tournir_node->addAttribute('Title',  $tournir_name);
    }
  }

  public function getTournirs($sport_id) {
    // Зачитываем настройку конторы
    $xml = parent::getTournirs($sport_id);
    $tournirs_node = $xml->addChild('Tournirs');
    
    // получаем перечень турниров
    $file_name = $this->league_path."league";
    $url = $this->host.$this->sport_node['Url'];
    $html = download_or_load($this->debug, $file_name.".html", $url, "GET");
    $this->extract_league($tournirs_node, win1251_to_utf8($html));
    if ($this->debug) file_put_contents($file_name.".xml", $xml->asXML());
    return $xml;
  }

  private function decode_date($str) {
    if (preg_match('/(\d{1,2})\.(\d{1,2})\.(\d{4})/i', $str, $matches)) { //MMM DD, YYYY
      $day_no = $matches[1];
      $month_no = $matches[2];
      $year_no = $matches[3];
    }
    return array($day_no, $month_no, $year_no);
  }

  private function decode_time($str) {
    preg_match('/(\d{1,2}):(\d\d)/i', $str, $matches);
    $hour = $matches[1];
    $minute = $matches[2];
    return array($hour, $minute);
  }

  private function event_find(&$tournir_node, $event_id) {
     foreach($tournir_node as $event_node) {
       if ((string)$event_node['Id'] == $event_id)
         return $event_node;
     }
     return false;
  }

  private function extract_label_koef($html) {
    $label = delete_all(copy_be($html, '<li', '<b>'), '<', '>');
    $koef = delete_all(copy_be($html, '<b', '</li>'), '<', '>');
    return array($label, $koef);
  }

  private function event_create(&$tournir_node, $event_id, $datetime, $gamer1_name, $gamer2_name) {
     $event_node = $tournir_node->addChild('Event');
     $event_node->addAttribute('Id', $event_id);
     $event_node->addAttribute('DateTime', date('Y-m-d\TH:i:s', $datetime));
     $event_node->addAttribute('Gamer1_Name', $gamer1_name);
     $event_node->addAttribute('Gamer2_Name', $gamer2_name);
     return $event_node;
  }

  private function extract_header($sport_sign, $thead) {
    $thead = replace_once('фора', 'HCap1V', $thead);
    $thead = replace_once('фора', 'HCap2V', $thead);
    $thead = replace_once('кф', 'HCap1', $thead);
    $thead = replace_once('кф', 'HCap2', $thead);
    $cols = extract_all_tags($thead, '<td', '</td>');
    foreach ($cols as $col) {
      $col = delete_all($col, '<', '>');
      $phrase_node = $this->findPhrase($sport_sign, 'Header', $col);
      $this->header[] = (string) $phrase_node['BetKind'];
    }
  }
  
  private function extract_main_bets_tennis(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $html = str_ireplace('<tr', '<tr', $html);
    $html = str_ireplace('</tr', '</tr', $html);
    $html = copy_be($html, '<tr ', '</tr>', 'class=', 'tc');
    $event_id = copy_between($html, 'shdop(\'', '\'');
    $html = kill_tag_bound($html, 'b|a');
    $cells = extract_all_tags($html, '<td>', '</td>');
    $i = 0;
    foreach($cells as $cell) $cells[$i++] = delete_all($cell, '<', '>');
    list($hour, $minute) = $this->decode_time($cells[0]);
    $gamer1_name = $cells[1];
    $gamer2_name = $cells[4];
    $event_node = $this->event_create($tournir_node, $event_id, mktime($hour, $minute, 0, $this->month_no, $this->day_no, $this->year_no), $gamer1_name, $gamer2_name);
    if ($cells[3] <> '') $this->addBet($event_node, $this->header[3].';Value='.$cells[2].';Koef='.$cells[3]);
    if ($cells[6] <> '') $this->addBet($event_node, $this->header[6].';Value='.$cells[5].';Koef='.$cells[6]);
    if ($cells[8] <> '') $this->addBet($event_node, $this->header[8].';Value='.$cells[7].';Koef='.$cells[8]);
    if ($cells[9] <> '') $this->addBet($event_node, $this->header[9].';Value='.$cells[7].';Koef='.$cells[9]);
    if ($cells[10] <> '') $this->addBet($event_node, $this->header[10].';Koef='.$cells[10]);
    if ($cells[11] <> '') $this->addBet($event_node, $this->header[11].';Koef='.$cells[11]);
  }

  private function extract_main_bets_soccer(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $html = str_ireplace('<tr', '<tr', $html);
    $html = str_ireplace('</tr', '</tr', $html);
    $html = copy_be($html, '<tr ', '</tr>', 'class=', 'tc');
    $event_id = copy_between($html, 'shdop(\'', '\'');
    $html = kill_tag_bound($html, 'b|a');
    $cells = extract_all_tags($html, '<td>', '</td>');
    $i = 0;
    foreach($cells as $cell) $cells[$i++] = delete_all($cell, '<', '>');
    list($hour, $minute) = $this->decode_time($cells[0]);
    $gamer1_name = $cells[1];
    $gamer2_name = $cells[4];
    $event_node = $this->event_create($tournir_node, $event_id, mktime($hour, $minute, 0, $this->month_no, $this->day_no, $this->year_no), $gamer1_name, $gamer2_name);
    if ($cells[3] <> '') $this->addBet($event_node, $this->header[3].';Value='.$cells[2].';Koef='.$cells[3]);
    if ($cells[6] <> '') $this->addBet($event_node, $this->header[6].';Value='.$cells[5].';Koef='.$cells[6]);
    
    if ($cells[7] <> '') $this->addBet($event_node, $this->header[7].';Koef='.$cells[7]);
    if ($cells[8] <> '') $this->addBet($event_node, $this->header[8].';Koef='.$cells[8]);
    if ($cells[9] <> '') $this->addBet($event_node, $this->header[9].';Koef='.$cells[9]);
    if ($cells[10] <> '') $this->addBet($event_node, $this->header[10].';Koef='.$cells[10]);
    if ($cells[11] <> '') $this->addBet($event_node, $this->header[11].';Koef='.$cells[11]);
    if ($cells[12] <> '') $this->addBet($event_node, $this->header[12].';Koef='.$cells[12]);
    
    if ($cells[14] <> '') $this->addBet($event_node, $this->header[14].';Value='.$cells[13].';Koef='.$cells[14]);
    if ($cells[15] <> '') $this->addBet($event_node, $this->header[15].';Value='.$cells[13].';Koef='.$cells[15]);
  }
  
  private function extract_extra_bets(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $html = str_ireplace('<li><h2>', '<li class="extra"><h2>', $html);
    $html = numbering_tag($html, 'li');
    $table_rows = extract_all_numbered_tags($html, 'li', 'extra');
    foreach($table_rows as $row) {
      $row = kill_property($row, 'TagNo');
      $event_id = extract_property_values(copy_be($html, '<ul', '>', 'rel'), 'rel', '');
      $event_node = $this->event_find($tournir_node, $event_id);
      $phrase = copy_be($row, '<h2', '</h2>');
      $phrase = copy_between($phrase, '>', '<');
      $section_node = $this->findSection($sport_sign, $phrase);
      if (!(string)$section_node['Ignore']) {
        $bets = extract_all_tags($row, '<li', '</li>', 'rel');
        foreach($bets as $bet) {
          list($label, $koef) = $this->extract_label_koef($bet);
          $label = str_ireplace((string)$event_node['Gamer1_Name'], 'Gamer1', $label);
          $label = str_ireplace((string)$event_node['Gamer2_Name'], 'Gamer2', $label);
          $phrase_node = $this->findPhrase($sport_sign, $phrase, $label);
          if (!$phrase_node['Ignore']) {
            $this->addBet($event_node, (string)$phrase_node['BetKind'].';Koef='.$koef);
          }
        }
      }
    }
  }
    
  private function extract_events(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $html = copy_be($html, '<table', '</table>', 'class=date');
    $html = kill_space($html);
    $tbodies = extract_all_tags($html, '<tbody', '</tbody>');
    foreach($tbodies as $tbody) {
      $tbody_class = copy_be($tbody, '<', '>');
      $tbody_class = str_ireplace('id=', 'class=', $tbody_class);
      $tbody_class = extract_property_values($tbody_class, 'class', '');
      if ($tbody_class == 'date') {
        list($this->day_no, $this->month_no, $this->year_no)  = $this->decode_date($tbody);
      } elseif ($tbody_class == 'chead') {
        $this->extract_header($sport_sign, $tbody);
      } elseif ($tbody_class == 'line') {
        if ($sport_sign == 'tennis') {
          $this->extract_main_bets_tennis($tournir_node, $tbody, $sport_sign, $tournir_id);
        } elseif ($sport_sign == 'soccer') {
          $this->extract_main_bets_soccer($tournir_node, $tbody, $sport_sign, $tournir_id);
        }
      }
    }
  }

  public function getEvents($sport_id, $tournir_id, $tournir_url) {
    $xml = parent::getEvents($sport_id, $tournir_id, $tournir_url);
    $tournir_node = $xml->addChild('Events');
    $file_name = $this->league_path.$tournir_id;
    $rnd = rand(1000000000, 2000000000);
    $url = $this->host."/bets/bets2.php?rnd=$rnd";
    $referer = $this->host.(string)$this->sport_node['Url'];
    $post_hash['time'] = 1;
    $post_hash['gcheck'] = 9;
    $post_hash['line_id[]'] = $tournir_id;
    
    $html = download_or_load($this->debug, $file_name.".html", $url, "POST", $referer, $post_hash);
    $this->extract_events($tournir_node, win1251_to_utf8($html), (string)$this->sport_node['Sign'], $tournir_id);

    if ($this->debug) file_put_contents($file_name.".xml", $xml->asXML());
    return $xml;
  }

}  
?>
