<?php

function Hash2Attrs(&$xml_node, $hash, $mapping) {
  foreach(explode(';', $mapping) as $map_pair) {
    list($dest_key, $src_key) = explode('=', $map_pair);
    if (!$src_key) $src_key = $dest_key;
    if ($hash[$src_key] <> '')
      $xml_node->addAttribute($dest_key, $hash[$src_key]);
  }
}

function Attrs2Hash(&$hash, $xml_node, $mapping) {
  foreach(explode(';', $mapping) as $map_pair) {
    list($dest_key, $src_key) = explode('=', $map_pair);
    if (!$src_key) $src_key = $dest_key;
    $hash[$dest_key] = (string)$xml_node[$src_key];
  }
}

?>
