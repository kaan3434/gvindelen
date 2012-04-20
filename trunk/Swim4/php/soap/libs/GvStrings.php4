<?php

function prepare_ereg_param($str) {
  if ($str) {
    $str = str_replace('[', '\[', $str);
    $str = str_replace(']', '\]', $str);
    $str = str_replace('(', '\(', $str);
    $str = str_replace(')', '\)', $str);
    $str = str_replace('?', '\?', $str);
  }
  return ($str);
}

function extract_tags($Html, $Begin, $End, $Separator='', $Contain1=null, $Contain2=null, $Contain3=null) {
  $Result = array();
  $Begin = prepare_ereg_param($Begin);
  $BArr = spliti($Begin, $Html);
  $i = 0;
  foreach ($BArr as $s) {
    if ($i > 0) {
      $PSE = strpos($s, $End);
      if ($PSE === false) continue;
      $RSt = substr($s, 0, $PSE);
      if ($Contain1) {
        $PSC1 = strpos($RSt, $Contain1);
        if ($PSC1 === false) continue;
        if ($Contain2) {
          $PSC2 = strpos($RSt, $Contain2, $PSC1+strlen($Contain1));
          if ($PSC2 === false) continue;
          if ($Contain3) {
            $PSC3 = strpos($RSt, $Contain3, $PSC2+strlen($Contain2));
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

function file_put_contents($fname, $content) {
  $f = fopen($fname, "w+");
  fwrite($f, $content);
  fclose($f);
}

?>
