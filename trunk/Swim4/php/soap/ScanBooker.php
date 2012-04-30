<?php
  require_once "libs/GvStrings.php";
  require_once "booker_xml.php";

function xml2array($xml) {
  $result = array();
  $child_count = count($xml);
  foreach($xml->children() as $element_name => $child) {
    if ($child_count > 1) {
      $result[$element_name][] = xml2array($child);
    } else {
      $result[$element_name] = xml2array($child);
    }
  }
  // если есть значение, то не может быть атрибутов
  if ($xml['0']) {
    $result['0'] = (string) $xml['0'];
  } //else {
    foreach($xml->attributes() as $attr_name => $attr_value) {
     $result[$attr_name] = (string) $attr_value;
    }
  //}
  return $result;
}

function getBookers ($user_sign) {
  $xml = simplexml_load_file("data/bookers.xml");
  $out = xml2array($xml);
//  $booker1 = array('Id'=>'123123');
//  $booker2 = array('Id'=>'124124');
//  $bookers = array('Booker'=>array(0=>$booker1, 1=>$booker2), 'UserSign'=>'123');
//  $out2 = array('Bookers'=>$bookers);
  return $out;
}

function getSports ($booker_sign) {
  $xml = simplexml_load_file("data/sports/$booker_sign.xml");
  return xml2array($xml);
}
    
function getTournirs($booker_sign, $sport_sign) {
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Root/>');
  $tournirs_node = $xml->addChild('Tournirs');
  if ($booker_sign == 'bwin') {
    require_once "bwin_xml.php";
    $booker = new bwin_booker();
  } elseif ($booker_sign == 'olymp') {
    require_once "olymp_xml.php";
    $booker = new olymp_booker();
  }
  $booker->getTournirs($tournirs_node, $sport_sign);
  $out = xml2array($xml);
  return $out;
}

function getEvents($booker_sign, $sport_sign, $tournir_id) {
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Root/>');
  $events_node = $xml->addChild('Events');
  if ($booker_sign == 'bwin') {
    require_once "bwin_xml.php";
    $booker = new bwin_booker();
  } elseif ($booker_sign == 'olymp') {
    require_once "olymp_xml.php";
    $booker = new olymp_booker();
  }
  $booker->getEvents($events_node , $sport_sign, $tournir_id);
  $out = xml2array($xml);
  return $out;
}
  
  
  //getBookers('123');
  //getSports('bwin');
//  getTournirs('olymp', 'tennis');
  //getEvents('olymp', 'tennis', '26.79cdd5dea2126f7cd6c6ba41df72a4c0');
  
  //exit;


  ini_set("soap.wsdl_cache_enabled", "0");
  $server = new SoapServer("Scan.wsdl");
  $server->addFunction("getBookers");
  $server->addFunction("getSports");
  $server->addFunction("getTournirs");
  $server->addFunction("getEvents");
  $server->handle();
?>
