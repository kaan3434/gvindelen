<?php
class booker_xml {
  protected $booker;
  protected $host;
  public $debug;
  protected $sport_node;
  protected $league_path;
  protected $phrases;
  
  function __construct() { 
    if ($_SERVER['HTTP_HOST'] == 'localhost:8080')
      $this->debug = 1;
    if (file_exists("data/phrases/{$this->booker}.xml")) {
      $this->phrases = simplexml_load_file("data/phrases/{$this->booker}.xml");
    } else {
      $this->phrases = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Root/>');
    }
  }
                 
  function __destruct() {
     $this->phrases->asXML("data/phrases/{$this->booker}.xml");
   }
  
  public function putPhrases() {
    $this->phrases->asXML("data/phrases/{$this->booker}.xml");
  }
  
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
  
  public function findSection($sport_sign, $section) {
    $sport_node = $this->phrases->$sport_sign;
    if (!$sport_node) $sport_node = $this->phrases->addChild($sport_sign);
    foreach($sport_node->children() as $element_name => $child) {
      if ($child['Caption'] == $section) return $child;
    }
    $section_node = $sport_node->addChild('Section');
    $section_node->addAttribute('Caption', $section);
    return $section_node;
  }
  
  public function findPhrase($sport_sign, $section, $caption) {
    $section_node = $this->findSection($sport_sign, $section);
    foreach($section_node->children() as $element_name => $child) {
      if ($child['Caption'] == $caption) return $child;
    }
    $phrase = $section_node->addChild('Phrase');
    $phrase->addAttribute('Caption', $caption);
    $phrase->addAttribute('BetKind', 'Modifier=Unknown');
    return $phrase;
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
      if ($key == 'Ignore') {
        $a=1;
      } else {
        $bet_attrs[$key] = $value;
      }
    }
    foreach ($bet_attrs as $key=>$value) $bet_node->addAttribute($key, strtr($value, ',', '.'));
  }
  
  public function getSubjects($sport_sign) {
    $filename = "phrases/{$this->booker}/subjects.txt";
    return file_get_hash($filename);
  }
  
}
?>
