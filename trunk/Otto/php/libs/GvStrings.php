<?php
  
function coalesce($Value1, $Value2, $Value3=null, $Value4=null) {
  if ($Value1 !== null) {return ($Value1);}
  elseif ($Value2 !== null) {return ($Value2);}
  elseif ($Value3 !== null) {return ($Value3);}
  else {return ($Value4);}
}  

function filter_cyrillic($str) {
  return win1251_to_utf8(preg_replace("#[^\xC0-\xFF]#", "", utf8_to_ansi_ru($str)));
}

function filter_email($str) {
  return win1251_to_utf8(preg_replace("#[^a-z0-1@\.-]#", "", utf8_to_ansi_ru($str)));
}

function prepare_ereg_param($str) {
  if ($str) {
    $str = str_ireplace('[', '\[', $str);
    $str = str_ireplace(']', '\]', $str);
    $str = str_ireplace('(', '\(', $str);
    $str = str_ireplace(')', '\)', $str);
    $str = str_ireplace('?', '\?', $str);
  }
  return ($str);
}

function prepare_preg_param($str) {
  if ($str) {
    $str = str_ireplace('"', '\"', $str);
    $str = str_ireplace('/', '\/', $str);
    $str = str_ireplace('-', '\-', $str);
    $str = str_ireplace(':', '\:', $str);
    $str = str_ireplace('?', '\?', $str);
    $str = str_ireplace('*', '\*', $str);
    $str = str_ireplace('.', '\.', $str);
    $str = str_ireplace('[', '\[', $str);
    $str = str_ireplace(']', '\]', $str);
    $str = str_ireplace('(', '\(', $str);
    $str = str_ireplace(')', '\)', $str);
  }
  return ($str);
}

function copy_front_withotkey($Html, $FromPos, $KeyChars) {
  $Html = substr($Html, $FromPos);
  $len = 0;
  while (strpos($KeyChars, $Html[$len]) === false) $len++;
  return substr($Html, 0, $len);
}

function copy_be($Html, $Begin, $End, $Contain1=null, $Contain2=null, $Contain3=null) {
  $Begin = prepare_ereg_param($Begin);
  $BArr = spliti($Begin, $Html);
  for ($i=1, $m=count($BArr); $i<$m; $i++) {
    $s = $BArr[$i];
    $PSE = stripos($s, $End);
    if ($PSE === false) continue;
    $RSt = substr($s, 0, $PSE);
    if ($Contain1) {
      $PSC1 = stripos($RSt, $Contain1);
      if ($PSC1 === false) continue;
      if ($Contain2) {
        $PSC2 = stripos($RSt, $Contain2, $PSC1+strlen($Contain1));
        if ($PSC2 === false) continue;
        if ($Contain3) {
          $PSC3 = stripos($RSt, $Contain3, $PSC2+strlen($Contain2));
          if ($PSC3 === false) continue;
        }
      }
    }
    return ($Begin.$RSt.$End);
  }
  return (null);
}

function replace_all_contain($Html, $Begin, $End, $New, $Contain) {
  $Result = array();  
  $Begin = prepare_ereg_param($Begin);
  $Contain = prepare_preg_param($Contain);
  $BArr = spliti($Begin, $Html);
  $i = -1;
  foreach ($BArr as $s) {
    $i++;
    if ($i == 0) {
      $Result[] = $s;
      continue;
    }
    $PSE = stripos($s, $End);
    if ($PSE === false) {
      $Result[] = $Begin.$s;
      continue;
    } 
    $RSt = substr($s, 0, $PSE);
    if (!preg_match("/$Contain/ims", $RSt)) {
      $Result[] = $Begin.$s;
      continue;
      }
    $Result[] = $New . substr($s, $PSE+strlen($End));
  }
  if (count($Result) > 0) {
    return (implode('', $Result));
  } else {
    return (null);
  }
}

function replace_all($Html, $Begin, $End, $New='', $Contain1=null, $Contain2=null, $Contain3=null) {
  $Result = array();  
  $Begin = prepare_ereg_param($Begin);
  $BArr = spliti($Begin, $Html);
  $i = -1;
  foreach ($BArr as $s) {
    $i++;
    if ($i == 0) {
      $Result[] = $s;
      continue;
    }
    $PSE = stripos($s, $End);
    if ($PSE === false) {
      $Result[] = $Begin.$s;
      continue;
    } 
    $RSt = substr($s, 0, $PSE);
    if ($Contain1) {
      $PSC1 = stripos($RSt, $Contain1);
      if ($PSC1 === false) {
        $Result[] = $Begin.$s;
        continue;
      }
      if ($Contain2) {
        $PSC2 = stripos($RSt, $Contain2, $PSC1+strlen($Contain1));
        if ($PSC2 === false) {
          $Result[] = $Begin.$s;
          continue;
        }
          if ($Contain3) {
            $PSC3 = stripos($RSt, $Contain3, $PSC2+strlen($Contain2));
            if ($PSC3 === false) {
              $Result[] = $Begin.$s;
              continue;
            }
          }
        }
      }
    $Result[] = $New . substr($s, $PSE+strlen($End));
  }
  if (count($Result) > 0) {
    return (implode('', $Result));
  } else {
    return (null);
  }
}
  
function delete_all($Html, $Begin, $End, $Contain1=null, $Contain2=null, $Contain3=null) {
   return replace_all($Html, $Begin, $End, '', $Contain1, $Contain2, $Contain3);
}

function extract_tags($Html, $Begin, $End, $Separator='', $Contain1=null, $Contain2=null, $Contain3=null) {
  $Result = array();
  $Begin = prepare_ereg_param($Begin);
  $BArr = spliti($Begin, $Html);
  $i = 0;
  foreach ($BArr as $s) {
    if ($i > 0) {
      $PSE = stripos($s, $End);
      if ($PSE === false) continue;
      $RSt = substr($s, 0, $PSE);
      if ($Contain1) {
        $PSC1 = stripos($RSt, $Contain1);
        if ($PSC1 === false) continue;
        if ($Contain2) {
          $PSC2 = stripos($RSt, $Contain2, $PSC1+strlen($Contain1));
          if ($PSC2 === false) continue;
          if ($Contain3) {
            $PSC3 = stripos($RSt, $Contain3, $PSC2+strlen($Contain2));
            if ($PSC3 === false) continue;
          }
        }
      }
      $Result[] = $Begin.$RSt.$End;
    }
    $i++;
  }
  if (count($Result) > 0) {
    return (implode($Separator, $Result));
  } else {
    return (null);
  }
}

function index_of($needle, $haystack) {                // conversion of JavaScripts most awesome
  for ($i=0, $c=count($haystack); $i<$c; $i++) {       // indexOf function.  Searches an array for
    if ($haystack[$i] == $needle) {                    // a value and returns the index of the *first*
      return $i;                                       // occurance
    }
  }
  return false;
}

function implode_hash($glue, $Hash, $c = null) {
  $DataArr = array();
  if ($Hash) {
    foreach ($Hash as $name => $value) $DataArr[] = $name.'='.$c.$value.$c;
  }
  return implode($glue, $DataArr);
}

?>
