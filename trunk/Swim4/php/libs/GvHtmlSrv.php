<?php

function kill_comment($Html) {
  return replace_all($Html, '<!--', '-->');
}

function kill_tag ($Html, $Tag) {
  $Tags = explode('|', $Tag);
  foreach ($Tags as $t) {
    $Html = replace_all($Html, "<$t ", '>', "<$t>");
    $Html = delete_all($Html, "<$t>", "</$t>");
  }
  return ($Html);
}

function kill_table_row($Html, $Tag) {
  $Tags = explode('|', $Tag);
  foreach ($Tags as $t) {
    $Html= delete_all($Html, '<tr', '</tr>', $t);
  }
  return ($Html);
}

function kill_tag_bound($Html, $Tag) {
  $Tags = explode('|', $Tag);
  foreach ($Tags as $t) {
    $Html = str_ireplace("<$t>", '', $Html);
    $Html = str_ireplace("</$t>", '', $Html);
//    $Html = delete_all($Html, "<$t ", '>');
  }
  $Html = preg_replace("/<($Tag) [^>]*>/imsU", '', $Html);
  return $Html;
}

function kill_property($Html, $Property) {
  $Html = preg_replace("/[ \t]($Property)=(\'.*\'|\".*\"|(?-U:[#0-9a-z%_]+))/imsU", '', $Html);
  return ($Html);
}

function kill_property_value_exclude($Html, $Property, $ExclValues) {
  preg_match_all("/ ($Property)=(\'(.*)\'|\"(.*)\"|(?-U:([#0-9a-z%_]+)))/imsU", $Html, $Matches, PREG_SET_ORDER);
  $Values = array();
  foreach ($Matches as $match) {
    $Values[$match[3].$match[4].$match[5]] = $match[3].$match[4].$match[5];
  }
  $ExclValArr = explode("|", $ExclValues);
  foreach ($ExclValArr as $value) {
    unset($Values[$value]);
  }
  foreach ($Values as $value) {
    $Html = str_ireplace(" $Property=\"$value\"", '', $Html);
    $Html = str_ireplace(" $Property='$value'", '', $Html);
    $Html = str_ireplace(" $Property=$value", '', $Html);
  }
  return ($Html);
}

function kill_property_value($Html, $Property, $Values) {
  $ValueArr = explode("|", $Values);
  foreach ($ValueArr as $Value) {
    $Html = str_ireplace(" $Property=\"$Value\"", '', $Html);
    $Html = str_ireplace(" $Property='$Value'", '', $Html);
    $Html = str_ireplace(" $Property=$Value", '', $Html);
  }
  return ($Html);
}

function extract_property_values($Html, $Property, $Separator) {
  preg_match_all("/ ($Property)=(\'(.*)\'|\"(.*)\"|(?-U:([#0-9a-z%_]+)))/imsU", $Html, $Matches, PREG_SET_ORDER);
  $Result = array();
  foreach ($Matches as $match) {
    $Result[] = $match[3].$match[4].$match[5];
  }
  return (implode($Separator, $Result));
}

function extract_form_data($Html) {
  $Inputs = explode("\r\n", extract_tags($Html, '<input ', '>', "\r\n", "name"));
  foreach ($Inputs as $input) {
    preg_match("/ name=(\'(.*)\'|\"(.*)\"|(?-U:([#0-9a-z%_\[\]]+)))/imsU", $input, $match);
    $name = $match[2].$match[3].$match[4];
    preg_match("/ value=(\'(.*)\'|\"(.*)\"|(?-U:([#0-9a-z%_]+)))/imsU", $input, $match);
    $value = $match[2].$match[3].$match[4];
    if ($name) $PostData[] = $name.'='.$value;
  }
  return ($PostData);
}

function extract_form_hash($Html) {
  $NameHash = array();
  $Inputs = explode("\r\n", extract_tags($Html, '<input ', '>', "\r\n", "name"));
  foreach ($Inputs as $input) {
    preg_match("/ name=(\'(.*)\'|\"(.*)\"|(?-U:([#0-9a-z%_\[\]]+)))/imsU", $input, $match);
    $name = $match[2].$match[3].$match[4];
    preg_match("/ value=(\'(.*)\'|\"(.*)\"|(?-U:([#0-9a-z%_]+)))/imsU", $input, $match);
    $value = $match[2].$match[3].$match[4];
    if ($name) {
      if ($NameHash[$name]) {
        $NameHash[$name] = $NameHash[$name] + 1;
        $name = $name .'[{<' .$NameHash[$name].'>}]';
      } else {
        $NameHash[$name] = 1;
      }
      $PostHash[$name] = $value;
    }
  }
  return ($PostHash);
}

function extract_form_action($Form) {
  $Form = copy_be($Form, '<form ', '>');
  return (extract_property_values($Form, 'action', "\r\n"));
}

function kill_space($Html) {
  // Убираем пробелы 
  $Html = str_ireplace('&nbsp;', ' ', $Html);
  $Html = str_ireplace('&nbsp', ' ', $Html);
  $Html = str_replace(chr(13), ' ', $Html);
  $Html = str_replace(chr(10), ' ', $Html);
  $Html = str_replace(chr(9), ' ', $Html);
  $Html = str_replace('      ', ' ', $Html);
  $Html = str_replace('     ', ' ', $Html);
  $Html = str_replace('    ', ' ', $Html);
  $Html = str_replace('   ', ' ', $Html);
  $Html = str_replace('  ', ' ', $Html);
  $Html = str_replace("\xE2\x80\x93", '-', $Html);
  $Html = str_replace("\xE2\x80\x94", '-', $Html);
  $Html = str_replace(' <', '<', $Html);
  $Html = str_replace('> ', '>', $Html);
  $Html = str_replace(' >', '>', $Html);
  return $Html;
}

function extract_tagno($Html, $TagName) {
  preg_match("/TagNo=\"$TagName(\d+)\"/imsUu", $Html, $matches);
  return ($matches[1]);
}

function extract_numbered_tag($Html, $TagName, $TagNo) {
   return (copy_be($Html, "<$TagName\tTagNo=\"$TagName$TagNo\"", "</$TagName\tTagNo=\"$TagName$TagNo\">"));
}

function extract_numbered_tags($Html, $TagName, $Separator, $Contain1="", $Contain2="", $Contain3="") {
  $Tags = explode("\r\n", extract_tags($Html, "<$TagName\tTagNo=", ">", "\r\n", $Contain1, $Contain2, $Contain3));
  $Result= array();
  foreach ($Tags as $tag) {
    $TagNo = extract_tagno($tag, $TagName);
    $Result[] = extract_numbered_tag($Html, $TagName, $TagNo);
  }
  return (implode($Separator, $Result));
}

function numbering_tag_count($Html, $TagName, &$TagNo) {
  $TagNo = 0;
  $Begin = prepare_ereg_param("<$TagName");
  $End = prepare_ereg_param("</$TagName");
  do {
    $BArr = null;
    $BArr = spliti($Begin, $Html);
    if (count($BArr) == 1) break;
    for ($i=1, $m=count($BArr); $i<$m; $i++) {
      $s = $BArr[$i];
      if (($s[0] != ' ') and ($s[0] != '>')) continue;
      $PSE = stripos($s, $End);
      if ($PSE === false) continue;
      $TagNo++;
      $TagNoProp = "\tTagNo=\"$TagName$TagNo\"";
      $EArr = spliti("</$TagName", $s);
      if (count($EArr) > 1) $EArr[1] = $TagNoProp . $EArr[1];
      $BArr[$i] = $TagNoProp . implode($End, $EArr);
    }
    $Html = implode($Begin, $BArr);
    $Html = str_ireplace("<$TagName\t", "<|$TagName\t", $Html);
    $Html = str_ireplace("</$TagName\t", "<|/$TagName\t", $Html);
  } while (true);
  $Html = str_ireplace("<|$TagName\t", "<$TagName\t", $Html);
  $Html = str_ireplace("<|/$TagName\t", "</$TagName\t", $Html);
  return ($Html);
}

function numbering_tag($Html, $TagName) {
  return numbering_tag_count($Html, $TagName, $TagCount);
}

function kill_unclassed_tag($Html, $Tag) {
  $Html = numbering_tag_count($Html, $Tag, $TagCount);
  for ($i=1; $i<=$TagCount; $i++) {
    $count = 1;
    $Html = str_ireplace("<$Tag\tTagNo=\"$Tag$i\">", '', $Html, $count);
    if ($count == 1) $Html = str_ireplace("</$Tag\tTagNo=\"$Tag$i\">", '', $Html);
  }
  $Html = kill_property($Html, 'TagNo');
  return $Html;
}

function kill_apostrof($Html, $Property) {
  preg_match_all("/ ($Property)=(\'(.*)\'|\"(.*)\"|(?-U:([#0-9a-z%_]+)))/imsU", $Html, $Matches, PREG_SET_ORDER);
  $Values = array();
  foreach ($Matches as $match) {
    $Values[$match[3].$match[4].$match[5]] = $match[3].$match[4].$match[5];
  }
  foreach ($Values as $value) {
    $Html = str_ireplace(" $Property=\"$value\"", " $Property=$value", $Html);
    $Html = str_ireplace(" $Property='$value'", " $Property=$value", $Html);
  }
  return ($Html);
}

function convert_to_utf8($Html) {
  if (stripos($Html, 'charset=windows-1251') !== false) {
    $Html = win1251_to_utf8($Html);
    $Html = str_ireplace('charset=windows-1251', 'charset=utf-8', $Html);
  }
  return ($Html);
}

?>
