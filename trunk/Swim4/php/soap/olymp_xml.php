<?php
  require_once "libs/Download.php";
  require_once "libs/GvStrings.php";
  require_once "libs/GvHtmlSrv.php";
  require_once "libs/utf2win.php";
  require_once "booker_xml.php";
  
class booker extends booker_xml {
  
  private $header;
  
  function __construct() { 
    $this->booker = 'olymp'; 
    $this->host = 'https://olympbet.com';
    parent::__construct();
  }
  
  private function extract_league(&$tournirs_node, $html) {
    $html = copy_be($html, '<td', '</td>', '<h4 ');
    $html = kill_space($html);
    $html = numbering_tag($html, 'div');
    $tournirs = extract_all_numbered_tags($html, 'div', 'rel');
    foreach($tournirs as $tournir) {
      $tournir_name = copy_be($tournir, '<h4', '</h4>');
      $tournir_name = copy_between($tournir_name, '>', '</');
      if ($sport_node['Regionable'] == 1) {
        list($region_name, $tournir_name) = explode('. ', $tournir_name, 2);
      } else {
        $region_name = 'World';
      }
      $tournir_node = $tournirs_node->addChild('Tournir');
      $league = copy_between($tournir, 'rel="', '"');
      $tournir_node->addAttribute('Id', $league);
      $tournir_node->addAttribute('Region', $region_name);
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
    $html = download_or_load($this->debug, $file_name.".html", $url, "GET", "");
    $this->extract_league($tournirs_node, $html);
    if ($this->debug) file_put_contents($file_name.".xml", $xml->asXML());
    return $xml;
  }

  private function decode_datetime($str) {
    preg_match('/(\d{1,2})\/(\d{2}) (\d{1,2}):(\d\d)/i', $str, $matches);
    $day_no = $matches[1];
    $month_no = $matches[2];
    $hour = $matches[3];
    $minute = $matches[4];
    $year_no = date('Y');
    if (mktime($hour, $minute, 0, $month_no, $day_no, $year_no) < time()-2*100*24*3600) $year_no++;
    return array($day_no, $month_no, $year_no, $hour, $minute);
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

  private function extract_header($sport_sign) {
    $phrase_node = $this->findPhrase($sport_sign, 'Header', '1');
    $this->header[3] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', 'X');
    $this->header[4] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', '2');
    $this->header[5] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', '1X');
    $this->header[6] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', '12');
    $this->header[7] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', 'X2');
    $this->header[8] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', 'HCap1');
    $this->header[9] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', 'HCap2');
    $this->header[10] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', 'TotalUnder');
    $this->header[12] = (string) $phrase_node['BetKind'];
    $phrase_node = $this->findPhrase($sport_sign, 'Header', 'TotalOver');
    $this->header[13] = (string) $phrase_node['BetKind'];
  }
  
  
  private function extract_main_bets(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $event_id = extract_property_values(copy_be($html, '<ul', '>', 'rel'), 'rel', '');
    $html = kill_tag_bound($html, 'u');
    $cells = extract_all_tags($html, '<li', '</li>');
    $i = 0;
    foreach($cells as $cell) $cells[$i++] = delete_all($cell, '<', '>', 'li');
    list($day_no, $month_no, $year_no, $hour, $minute) = $this->decode_datetime(str_ireplace('<br>', ' ', $cells[0]));
    list($gamer1_name, $gamer2_name) = explode('<br/>', $cells[2]);
    $event_node = $this->event_create($tournir_node, $event_id, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
    if ($cells[3] <> '') $this->addBet($event_node, $this->header[3].';Koef='.$cells[3]);
    if ($cells[4] <> '') $this->addBet($event_node, $this->header[4].';Koef='.$cells[4]);
    if ($cells[5] <> '') $this->addBet($event_node, $this->header[5].';Koef='.$cells[5]);
    if ($cells[6] <> '') $this->addBet($event_node, $this->header[6].';Koef='.$cells[6]);
    if ($cells[7] <> '') $this->addBet($event_node, $this->header[7].';Koef='.$cells[7]);
    if ($cells[8] <> '') $this->addBet($event_node, $this->header[8].';Koef='.$cells[8]);

    if ($cells[9] <> '') {
      preg_match('/\(([\+\-]*?)(.+?)\)<br\/>(.+?)/iU', $cells[9], $matches);
      if (($matches[1] == '') and ($matches[2] <> '0')) $matches[1] = '+';
      $this->addBet($event_node, $this->header[9].';Value='.$matches[1].$matches[2].';Koef='.$matches[3]);
    }
    if ($cells[10] <> '') {
      preg_match('/\(([\+\-]*?)(.+?)\)<br\/>(.+?)/iU', $cells[10], $matches);
      if (($matches[1] == '') and ($matches[2] <> '0')) $matches[1] = '+';
      $this->addBet($event_node, $this->header[10].';Value='.$matches[1].$matches[2].';Koef='.$matches[3]);
    }
    if ($cells[12] <> '') {
      $value = $cells[11];
      if (!strpos($value, '.')) $value = $value-0.5;
      $this->addBet($event_node, $this->header[12].';Value='.$value.';Koef='.$cells[12]);
    }
    if ($cells[13] <> '') { 
      $value = $cells[11];
      if (!strpos($value, '.')) $value = $value+0.5;
      $this->addBet($event_node, $this->header[13].';Value='.$value.';Koef='.$cells[13]);
    }
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
    
  private function extract_bets(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $this->extract_header($sport_sign);
    $html = kill_space($html);
    $html = numbering_tag($html, 'ul');
    $events = extract_all_numbered_tags($html, 'ul', 'e-td ');
    foreach($events as $event) $this->extract_main_bets(&$tournir_node, $event, $sport_sign, $tournir_id);
    $events = extract_all_numbered_tags($html, 'ul', 'e-r ');
    foreach($events as $event) $this->extract_extra_bets(&$tournir_node, $event, $sport_sign, $tournir_id);
  }

  public function getEvents($sport_id, $tournir_id, $tournir_url) {
    $xml = parent::getEvents($sport_id, $tournir_id, $tournir_url);
    $tournir_node = $xml->addChild('Events');
    
    $file_name = $this->league_path.$tournir_id;
    $url = $this->host."/engine.php?act=co&co=$tournir_id";
    $referer = $this->host.(string)$this->sport_node['Url'];
    $html = download_or_load($this->debug, $file_name.".html", $url, "GET", $referer);
    $this->extract_bets($tournir_node, $html, (string)$this->sport_node['Sign'], $tournir_id);

    if ($this->debug) file_put_contents($file_name.".xml", $xml->asXML());
    return $xml;
  }

}  
?>
