<?php
  require_once "libs/GvStrings.php";
//  require "easywsdl2php.php";


function simpleXMLToArray(SimpleXMLElement $xml,$attributesKey=null,$childrenKey=null,$valueKey=null){

    if($childrenKey && !is_string($childrenKey)){$childrenKey = '@children';}
    if($attributesKey && !is_string($attributesKey)){$attributesKey = '@attributes';}
    if($valueKey && !is_string($valueKey)){$valueKey = '@values';}

    $return = array();
    $name = $xml->getName();
    $_value = trim((string)$xml);
    if(!strlen($_value)){$_value = null;};

    if($_value!==null){
        if($valueKey){$return[$valueKey] = $_value;}
        else{$return = $_value;}
    }

    $children = array();
    $first = true;
    foreach($xml->children() as $elementName => $child){
        $value = simpleXMLToArray($child,$attributesKey, $childrenKey,$valueKey);
        if(isset($children[$elementName])){
            if(is_array($children[$elementName])){
                if($first){
                    $temp = $children[$elementName];
                    unset($children[$elementName]);
                    $children[$elementName][] = $temp;
                    $first=false;
                }
                $children[$elementName][] = $value;
            }else{
                $children[$elementName] = array($children[$elementName],$value);
            }
        }
        else{
            $children[$elementName] = $value;
        }
    }
    if($children){
        if($childrenKey){$return[$childrenKey] = $children;}
        else{$return = array_merge($return,$children);}
    }

    $attributes = array();
    foreach($xml->attributes() as $name=>$value){
        $attributes[$name] = trim($value);
    }
    if($attributes){
        if($attributesKey){$return[$attributesKey] = $attributes;}
        else{$return = array_merge($return, $attributes);}
    }

    return $return;
} 

function getBookers ($user_sign) {
  $xml = new SimpleXMLElement('<Bookers/>');
  $xml->addAttribute('UserSign', $user_sign);
  $booker_node = $xml->addChild('Booker');
  $fpath = 'data/bookers'; 
  $files = scandir($fpath, 0);
  foreach($files as $f) {
    if (substr($f, -4) == '.txt') {
      //$booker_hash = file_get_hash("$fpath/$f");
      $booker_node = $xml->addChild('Booker');
      //foreach($booker_hash as $key=>$value) $booker_node->addAttribute($key, $value);
    }
  }
  $out = simpleXMLToArray($xml);
  //$dom = new DOMDocument();
  //$dom->loadXML($xml->asXML());

  //if (!$dom->schemaValidate('getBookers.xsd')) {
//    print '<b>DOMDocument::schemaValidate() Generated Errors!</b>';
//    libxml_display_errors();
//  } else { 
    //echo "validated";   
  //}
  $out2 = array(new stdClass());
  $out2->UserSign = "1235";
  $out2->Booker = new stdClass();
  $out2->Booker->Id = '123';
  return $out2;
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
  
  
  getBookers('123');
//  print(getSports('bwin'));
//  exit;


  ini_set("soap.wsdl_cache_enabled", "0");
  $server = new SoapServer("scan.wsdl");
  $server->addFunction("getBookers");
  //$server->addFunction("getSports");
  //$server->addFunction("getTournirs");
  //$server->addFunction("getSports");
  $server->handle();
?>
