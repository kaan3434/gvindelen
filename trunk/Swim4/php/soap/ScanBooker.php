<?php
  require_once "libs/GvStrings.php";
  require_once "booker_xml.php";
  require_once "bwin_xml.php";
  require_once "olymp_xml.php";
  require_once "marathon_xml.php";
  
define("DEFAULT_LOG","/afs/ir/default.log");
  

function write_log($message, $logfile='') {
  // Determine log file
  if($logfile == '') {
    // checking if the constant for the log file is defined
    if (defined(DEFAULT_LOG) == TRUE) {
        $logfile = DEFAULT_LOG;
    }
    // the constant is not defined and there is no log file given as input
    else {
        error_log('No log file defined!',0);
        return array(status => false, message => 'No log file defined!');
    }
  }
 
  // Get time of request
  if( ($time = $_SERVER['REQUEST_TIME']) == '') {
    $time = time();
  }
 
  // Get IP address
  if( ($remote_addr = $_SERVER['REMOTE_ADDR']) == '') {
    $remote_addr = "REMOTE_ADDR_UNKNOWN";
  }
 
  // Get requested script
  if( ($request_uri = $_SERVER['REQUEST_URI']) == '') {
    $request_uri = "REQUEST_URI_UNKNOWN";
  }
 
  // Format the date and time
  $date = date("Y-m-d H:i:s", $time);
 
  // Append to the log file
  if($fd = @fopen($logfile, "a")) {
    $result = fputcsv($fd, array($date, $remote_addr, $request_uri, $message));
    fclose($fd);
 
    if($result > 0)
      return array(status => true);  
    else
      return array(status => false, message => 'Unable to write to '.$logfile.'!');
  }
  else {
    return array(status => false, message => 'Unable to open log '.$logfile.'!');
  }
}  
  
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
    
function getTournirs($booker_sign, $sport_id) {
  if ($booker_sign == 'bwin') {
    $booker = new bwin_booker();
  } elseif ($booker_sign == 'olymp') {
    $booker = new olymp_booker();
  } elseif ($booker_sign == 'marathon') {
    $booker = new marathon_booker();
  }
  $xml = $booker->getTournirs($sport_id);
  $out = xml2array($xml);
  return $out;
}

function getEvents($booker_sign, $sport_id, $tournir_id) {
  if ($booker_sign == 'bwin') {
    $booker = new bwin_booker();
  } elseif ($booker_sign == 'olymp') {
    $booker = new olymp_booker();
  } elseif ($booker_sign == 'marathon') {
    $booker = new marathon_booker();
  }
  $xml = $booker->getEvents($sport_id, $tournir_id, null);
  $out = xml2array($xml);
  return $out;
}
  
  
  //getBookers('123');
  //getSports('bwin');
//  getTournirs('olymp', 'tennis');
//  getEvents('bwin', 10, '12899');
  //getEvents('olymp', 20, '29.68c6824d4a82dee51ee4e5fc228dbb92');
  
  //exit;

//  write_log(file_get_contents('php://input'), 'requests.log');
  ini_set("soap.wsdl_cache_enabled", "0");
  header("Content-Type: text/xml");
  $server = new SoapServer('wsdl/'.$_SERVER['SERVER_NAME']."/Scan.wsdl");
  $server->addFunction("getBookers");
  $server->addFunction("getSports");
  $server->addFunction("getTournirs");
  $server->addFunction("getEvents");
  $server->handle();
  
?>
