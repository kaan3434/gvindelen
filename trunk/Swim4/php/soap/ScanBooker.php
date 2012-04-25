<?php
  require_once "libs/GvStrings.php";
//  require "easywsdl2php.php";

                 
function xml2array($xml) {
  $result = array();
  $child_count = count($xml);
  foreach($xml->children() as $element_name => $child) {
    if ($child_count > 1) {
      $result[] = array($element_name => xml2array($child));
    } else {
      $result[$element_name] = xml2array($child);
    }
  }
  foreach($xml->attributes() as $attr_name => $attr_value) {
    $result[$attr_name] = (string) $attr_value;
  }
  return $result;
}

function getBookers ($user_sign) {
//  $xml = simplexml_load_file("data/bookers.xml");
//  $out = xml2array($xml);
  $booker = array('Booker'=>'123123');
  //array('_'=>'8767', 'Id'=>"1", 'Sign'=>'bwin'));
  $bookers = array(0=>$booker);
  $out = array('Bookers'=>$bookers);
  return $out;
}

function getSports ($booker_sign) {
  $xml = new SimpleXMLElement('<SportsResponse/>');
  $sports_node = $xml->addChild('Sports');
  $fpath = 'data/sports'; 
  $sports = file_get_contents("$fpath/$booker_sign.txt");
  foreach(explode(';', $sport) as $attrs) {
    list($key, $value) = explode('=', $attrs);
    $bet_node->addAttribute($key, $value);
  }
  return xml2array($xml);
}
    
function getTournirs($booker_sign, $sport_sign) {
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Sport/>');
  $xml->addAttribute('Sign', $sport_sign);
  if ($booker_sign == 'bwin') {
    require_once "bwin_xml.php";
    bwin_get_tournirs($xml, $sport_sign);
  } elseif ($booker_sign == 'olymp') {
    require_once "olymp_xml.php";
    olymp_get_tournirs($xml, $sport_sign);
  }
  return $xml->asXML();
}

function getEvents($booker_sign, $sport_sign, $tournir_id) {
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Tournir/>');
  $xml->addAttribute('Id', $tournir_id);
  if ($booker_sign == 'bwin') {
    require_once "bwin_xml.php";
    bwin_get_events($xml, $sport_sign, $tournir_id);
  } elseif ($booker_sign == 'olymp') {
    require_once "olymp_xml.php";
    olymp_get_events($xml, $sport_sign, $tournir_id);
  }
  return $xml->asXML();
}
  
  
  getBookers('123');
//  print(getSports('bwin'));
//  exit;


  ini_set("soap.wsdl_cache_enabled", "0");
  $server = new SoapServer("scan.wsdl");
  $server->addFunction("getBookers");
  $server->addFunction("getSports");
  //$server->addFunction("getTournirs");
  //$server->addFunction("getSports");
  $server->handle();
?>
