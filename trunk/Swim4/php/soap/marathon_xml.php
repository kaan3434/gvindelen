<?php
  require_once "libs/Download.php";
  require_once "libs/GvStrings.php";
  require_once "libs/GvHtmlSrv.php";
  require_once "libs/utf2win.php";
  require_once "booker_xml.php";
  
class booker extends booker_xml {
  
  private $header;
  
  function __construct() { 
    $this->booker = 'marathon'; 
    $this->host = 'http://marathonbet.com';
    parent::__construct();
  }
  
  private function extract_league(&$tournirs_node, $html, $sport_sign) {
    //$html = kill_space($html);
    $sport = copy_be($html, '<div', '</div>', 'main-sport-category', '&nbsp;'.(string)$this->sport_node['BookerSign']);
    $sport = copy_be($sport, '<input ', '>');
    $tournirs = explode(',', copy_between($sport, '[',']'));
    foreach ($tournirs as $tournir_id) {
      $tournir = copy_be($html, '<a ', '</a>', 'displayCategoryData', $tournir_id);
      $tournir = kill_space($tournir);
      $tournir_name = copy_between($tournir, '>', '</a');
      $tournir_node = $tournirs_node->addChild('Tournir');
      $tournir_node->addAttribute('Title',  $tournir_name);
      $tournir_node->addAttribute('Id', $tournir_id);
    }
  }
  
  public function getTournirs($sport_id) {
    $xml = parent::getTournirs($sport_id);
    $tournirs_node = $xml->addChild('Tournirs');
    
    // получаем перечень турниров
    $file_name = $this->league_path."league";
    $url = $this->host.$this->sport_node['Url'];
    $html = download_or_load($this->debug, $file_name.".html", $url, "GET", "");
    $this->extract_league($tournirs_node, $html, $this->sport_node['Sign']);
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

  private function decode_datetime($str) {
    preg_match('/(\d{1,2})?\s?(\w+)?\s?(\d{1,2}):(\d\d)/iU', $str, $matches);
    $day_no = $matches[1];
    if (!$day_no) $day_no = date('d');
    if ($matches[2]) {
      $month_no = decode_month_name($matches[2]);
    } else {
      $month_no = date('n');
    }
    $hour = $matches[3];
    $minute = $matches[4];
    $year_no = date('Y');
    if (mktime($hour, $minute, 0, $month_no, $day_no, $year_no) < time()-2*100*24*3600) $year_no++;
    return array($day_no, $month_no, $year_no, $hour, $minute);
  }
  
  
  private function event_create(&$tournir_node, $event_id, $datetime, $gamer1_name, $gamer2_name) {
     $event_node = $tournir_node->addChild('Event');
     $event_node->addAttribute('Id', $event_id);
     $event_node->addAttribute('DateTime', date('Y-m-d\TH:i:s', $datetime));
     $event_node->addAttribute('Gamer1_Name', $gamer1_name);
     $event_node->addAttribute('Gamer2_Name', $gamer2_name);
     return $event_node;
  }
  

  private function extract_header($html, $sport_sign) {
    $html = copy_be($html, '<tr', '</tr>', '</th>');
    $coupons = extract_all_tags($html, '<th', '</th>', 'coupone');
    $i = 0;
    foreach ($coupons as $coupon) {
      $i++;
      $phrase = delete_all(copy_be($coupon, '<a', '</a>'), '<', '>');
      if (!$phrase) $phrase = delete_all($coupon, '<', '>');
      $phrase_node = $this->findPhrase($sport_sign, 'Header', $phrase);
      $this->header[$i] = (string)$phrase_node['BetKind'];
    }
  }
  
  private function parse_extra_table(&$event_node, $html) {
    $header= delete_all(copy_be($html, '<th', '</th>'), '<', '>');
  }
  
  private function extract_extra_bets(&$event_node, $tournir_id, $event_id) {
    $file_name = $this->league_path."$tournir_id.$event_id";
    $url = $this->host."/en/markets.htm?isHotPrice=false&treeId=$event_id";
    $referer = $this->host.(string)$this->sport_node['Url'];
    $html = download_or_load($this->debug, $file_name.".html", $url, "GET", $referer);
    $html = copy_between($html, '"HTML":"', '","COUNT"');
    $html = str_replace('\t', ' ', $html);
    $html = str_replace('\n', ' ', $html);
    $html = str_replace('\r', ' ', $html);
    $html = str_replace('\"', '"', $html);
    $html = str_replace('\/', '/', $html);
    $html = kill_space($html);
    if ($this->debug) file_put_contents($file_name.'.htm', $html);
    $phrases_headers = $this->getPhrasesHeaders($sport_sign);
    $phrases_labels = $this->getPhrasesLabels($sport_sign);
    // выдираем все коэффициенты
    $bets = extract_all_tags($html, '<a', '</a>', 'getBetslip');
    foreach($bets as $bet) {
      preg_match('/add\(\'(\d+?),(.+?),(.+?)\'/imsU', $bet, $matches);
      $header = $matches[2];
      $label = $matches[3];
      $bettype_str= $phrases_headers[$header];
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
            $bet_node = $event_node->addChild('Bet');
            foreach($bettype as $key=>$value) $bet_node->addAttribute($key, $value);
            $bet_node->addAttribute('Koef', $koef);
          }                
          unset($bettype['Modifier']);
    }
    // отбираем новые и складываем их в новый файл
    if ($phrases_headers_modified) $this->putNewPhrasesHeaders($phrases_headers, $sport_sign);
    if ($phrases_labels_modified) $this->putNewPhrasesLabels($phrases_labels, $sport_sign);
  }
    
  
  private function extract_main_bets(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $html = kill_property($html, 'TagNo');
    $html = numbering_tag($html, 'tr');
    $events = extract_all_numbered_tags($html, 'tr', 'event-header');
    foreach ($events as $event) {
      // получаем 
      $event_info= take_be($event, '<table', '</table>');
      file_put_contents("Event.html", $event_info);
      preg_match_all('/<div class="(.*)?member-name(.*)?">(.*)?<\/div>/imsU', $event_info, $matches);
      $gamer1_name= $matches[3][0];
      $gamer2_name= $matches[3][1];
      $datetime_str= delete_all(copy_be($event_info, '<td', '</td>', '"date"'), '<', '>');
      list($day_no, $month_no, $year_no, $hour, $minute) = $this->decode_datetime($datetime_str);
      $extrabet = copy_be($event_info, '<a', '</a>', 'treeid');
      $event_id = extract_property_values($extrabet, 'treeid', '');
      $extrabet = delete_all($extrabet, '<', '>');
      $event_node= $this->event_create($tournir_node, $event_id, mktime($hour, $minute, 0, $month_no, $day_no, $year_no), $gamer1_name, $gamer2_name);
      $cells = extract_all_tags(replace_all($event, '<td', '>', '<td>'), '<td>', '</td>');
      $i = 0;
      foreach ($cells as $cell) {
        $cell = trim(copy_between($cell, '<td>', '</td>'));
        if ($cell) {
          $cell = kill_tag_bound($cell, 'a');
          unset($bettype);
          $bettype_str = $this->header[$i];
          foreach(explode(';', $bettype_str) as $bet_pair) {
            list($key, $value) = explode('=', $bet_pair);
            $bettype[$key] = $value;
          }
          if ($bettype['Kind'] == 'Total') {
            preg_match('/\((.+?)\)<br\/>(.+?)/iU', $cell, $matches);
            if ($matches[2]) {
              $matches[2] = delete_all($matches[2], '<', '>');
              $this->addBet($event_node, $bettype_str.';Value='.$matches[1].';Koef='.$matches[2]);
            }
          } elseif ($bettype['Kind'] == 'Fora') {
            preg_match('/\(([\+\-]*?)(.+?)\)<br\/>(.+?)/iU', $cell, $matches);
            if ($matches[3]) {
              $matches[3] = delete_all($matches[3], '<', '>');
              $this->addBet($event_node, $bettype_str.';Value='.$matches[1].$matches[2].';Koef='.$matches[3]);
            }
          } else {
            $cell = delete_all($cell, '<', '>');
            $this->addBet($event_node, $bettype_str.';Koef='.$cell);
          }
        }
        $i++;
      }
      //if ($extrabet > 0) $this->extract_extra_bets($event_node, $tournir_id, $event_id);
    }
  }

  private function extract_bets(&$tournir_node, $html, $sport_sign, $tournir_id) {
    $html = kill_space($html);
    $html = numbering_tag($html, 'table');
    $tables = extract_all_numbered_tags($html, 'table', "foot-market");
    foreach ($tables as $table) {
      $this->extract_header($table, $sport_sign);
      $this->extract_main_bets($tournir_node, $table, $sport_sign, $tournir_id);
    }
  }
    
  public function getEvents($sport_id, $tournir_id, $tournir_url) {
    $xml = parent::getEvents($sport_id, $tournir_id, $tournir_url);
    $tournir_node = $xml->addChild('Events');

    $file_name = $this->league_path.$tournir_id;
    $url= $this->host."/en/ajaxevents.htm?id=$tournir_id";
    $referer = $this->host.(string)$this->sport_node['Url'];
    $html = download_or_load($this->debug, $file_name.".html", $url, "GET", $referer);
    $this->extract_bets($tournir_node, $html, (string)$this->sport_node['Sign'], $tournir_id);
    if ($this->debug) file_put_contents($file_name.".xml", $xml->asXML());
//    $this->putPhrases();
    return $xml;
  }

}
?>
