<?php
class booker_xml {
  protected $booker;
  protected $host;
  public $debug;
  protected $sport_node;
  protected $league_path;
  
  public function getSports() {
    $xml = simplexml_load_file("data/sports/{$this->booker}.xml");
    foreach($xml->xpath('Sports/Sport/*') as $child) {
     $domRef = dom_import_simplexml($child); 
     $domRef->parentNode->removeChild($domRef);
    }
    return $xml;
  }
  
  public function getSport($sport_id) {
    $sports_xml = simplexml_load_file("data/sports/{$this->booker}.xml");
    $nodes = $sports_xml->xpath("Sports/Sport[@Id=\"$sport_id\"]"); 
    if (count($nodes)>=1) $this->sport_node = $nodes[0];
    $sport_sign = (string)$this->sport_node['Sign'];
    $this->league_path = "lines/".$this->booker."/$sport_sign.";
    return $this->sport_node;
  }
  
  public function getTournirs($sport_id) {
    // Зачитываем настройку спорта конторы
    $this->sport_node = $this->getSport($sport_id);
    $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Root/>');
    return $xml;
  }
  
  public function getEvents($sport_id, $tournir_id, $tournir_url) {
    $this->sport_node = $this->getSport($sport_id);
    $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Root/>');
    return $xml;
  }
  
  public function addBet(&$event_node, $attrs) {
    $bet_node = $event_node->addChild('Bet');
    foreach(explode(';', $attrs) as $bet_pair) {
      list($key, $value) = explode('=', $bet_pair);
      $bet_attrs[$key] = $value;
    }
    foreach ($bet_attrs as $key=>$value) $bet_node->addAttribute($key, strtr($value, ',', '.'));
  }
  
  
  public function getPhrasesHeaders($sport_sign) {
    $filename = "phrases/{$this->booker}/$sport_sign.headers.txt";
    return file_get_hash($filename);
  }
  
  public function getPhrasesLabels($sport_sign) {
    $filename = "phrases/{$this->booker}/$sport_sign.labels.txt";
    return file_get_hash($filename);
  }

  public function getSubjects($sport_sign) {
    $filename = "phrases/{$this->booker}/subjects.txt";
    return file_get_hash($filename);
  }
  
  public function putNewPhrasesHeaders($phrases_headers, $sport_sign) {
    $filename = "phrases/{$this->booker}/$sport_sign.headers.txt";
    $file_hash = file_get_hash($filename);
    foreach($file_hash as $key=>$value) unset($phrases_headers[$key]);
    file_put_hash("$filename.new", $phrases_headers+file_get_hash("$filename.new"));
  }

  public function putNewPhrasesLabels($phrases_labels, $sport_sign) {
    $filename = "phrases/{$this->booker}/$sport_sign.labels.txt";
    $file_hash = file_get_hash($filename);
    foreach($file_hash as $key=>$value) unset($phrases_labels[$key]);
    file_put_hash("$filename.new", $phrases_labels+file_get_hash("$filename.new"));
  }

  
  
}
?>
