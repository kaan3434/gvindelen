<?php
  require_once "libs/GvStrings.php";

  class ScanBooker {
    function getBookers () {
      $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Bookers/>');
      $fpath = 'data/bookers'; 
      $files = scandir($fpath, 0);
      foreach($files as $f) {
        if (substr($f, -4) == '.txt') {
          $booker = file_get_hash("$fpath/$f");
          $booker_node = $xml->addChild('Booker');
          foreach($booker as $key=>$value) $booker_node->addAttribute($key, $value);
        }
      }
      return $xml->asXML();
    }
    function getSports ($booker_sign) {
      $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Booker/>');
      $xml->addAttribute('Sign', $booker_sign);
      $fpath = 'data/sports'; 
      $sports = file_get_hash("$fpath/$booker_sign.txt");
      foreach($sports as $key=>$value) {
        $sport_node = $xml->addChild('Sport');
        $sport_node->addAttribute('Sign', $key);
        $sport_node->addAttribute('Name', $value);
      }
      return $xml->asXML();
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
  }  
  
  
//  print(getBookers());
//  print(getSports('bwin'));
//  exit;

  ini_set("soap.wsdl_cache_enabled", "0");
  $server = new SoapServer("swim4.wsdl");
  $server->setClass("ScanBooker");
  $server->handle;
?>
