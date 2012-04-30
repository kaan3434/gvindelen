<?php
class booker_xml {
  protected $booker;
  protected $host;
  protected $debug;
  
  public function getTournirs(SimpleXMLElement $xml, string $sport_sign) {
    return $xml;
  }
  
  public function getEvents(SimpleXMLElement $xml, string $sport_sign, string $tournir_id) {
    return $xml;
  }
  
  public function addBet(&$event_node, $attrs) {
    $bet_node = $event_node->addChild('Bet');
    foreach(explode(';', $attrs) as $bet_pair) {
      list($key, $value) = explode('=', $bet_pair);
      $bet_node->addAttribute($key, strtr($value, ',', '.'));
    }
  }
  
  public function getLeaguePath(string $sport_sign) {
    return "lines/{$this->booker}/$sport_sign.";
  }
  
  public function getPhrasesHeaders($sport_sign) {
    $filename = "phrases/{$this->booker}/$sport_sign.headers.txt";
    return file_get_hash($filename);
  }
  
  public function getPhrasesLabels($sport_sign) {
    $filename = "phrases/{$this->booker}/$sport_sign.labels.txt";
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
