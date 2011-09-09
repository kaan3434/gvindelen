<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Get Article</title>
  </head>
<body>
<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $debug = $_GET['debug'];
  $cache = 'cache';
  $Host = 'http://www.otto.de';
  
  $PostHash['ArticleNo'] = $_GET['ArticleNo'];
  $PostHash['ArticleSize'] = $_GET['ArticleSize'];

  if ($debug) {
    $FileName = "$cache/main.html";
    if (!file_exists($FileName)) {
      $Html = download("$Host/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewDeliveryInfo-IncludeDelivery", "POST", '', $PostHash);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    } 
  } else {
    $Html = download("$Host/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewDeliveryInfo-IncludeDelivery", "POST", '', $PostHash);
  }
  exit;
  
  $FormSearch = copy_be($Html, '<form ', '</form>', 'topSearch');
  $PostHash = extract_form_hash($FormSearch);
  $PostHash['fh_search'] = $_GET['article_code'];

  $Html = copy_be($FormSearch, '<form ', '>');
  $url_1 = extract_property_values($Html, 'action', "\r\n");
  $Html = download($url_1, 'GET', "$Host", $PostHash);
  
  if ($debug) file_put_contents("$cache/page.1.html", $Html);
  
  $FormSearch = copy_be($Html, '<form ', '</form>', 'searchform');
  $PostHash = extract_form_hash($FormSearch);

  $Html = copy_be($FormSearch, '<form ', '>');
  $url_2 = extract_property_values($Html, 'action', "\r\n");
  $Html = download($url_2, 'GET', $url_1, $PostHash);
  
  if ($debug) file_put_contents("$cache/page.2.html", $Html);
  $Html = copy_be($Html, '<script>', '</script>', 'goon');
  $Html = str_ireplace(" '", " <'", $Html);
  $Html = str_ireplace("+'", "+<'", $Html);
  $Html = str_ireplace("'+", "'>+", $Html);
  $Html = str_ireplace("';", "'>;", $Html);
  $url_3 = extract_tags($Html, "<'", "'>", '');
  $url_3 = str_replace("<'", '', $url_3);
  $url_3 = str_replace("'>", '', $url_3);
  $Html = download($url_3, 'GET', $url_2);
  if ($debug) file_put_contents("$cache/page.3.html", $Html);
  // вырезаем информацию об артикуле
  $Html = copy_be($Html, '<script>', '</script>', 'sku');
  $Html = copy_be($Html, " {", "\n");
  if ($debug) file_put_contents("$cache/page.4.html", $Html);

  $Html = file_get_contents("$cache/article_".$_GET['article_code'].".txt");
  $Html = copy_be($Html, '<body>', '</body>');
  $Html = kill_tag_bound($Html, 'body');
  $Html = kill_space($Html);

function extract_property_text($Html, $PropertyName) {
  $prop_name = '"'.$PropertyName.'":"';
  $pos = stripos($Html, $prop_name);
  if ($pos !== false)
    return copy_front_withotkey($Html, $pos+strlen($prop_name), '"');
  else
    return null;
}
function set_attr_value_text($Html, $PropertyName, &$Hash) {
  if ($prop_value = extract_property_text($Html, $PropertyName))
    $Hash[$PropertyName] = $prop_value;
}

function extract_property_num($Html, $PropertyName) {
  $prop_name = '"'.$PropertyName.'":';
  $pos = stripos($Html, $prop_name);
  if ($pos !== false)
    return copy_front_withotkey($Html, $pos+strlen($prop_name), ',< ');
  else
    return null;
}

function set_attr_value_num($Html, $PropertyName, &$Hash) {
  if ($prop_value = extract_property_num($Html, $PropertyName))
    $Hash[$PropertyName] = $prop_value;
}

function recognize_Article($Html, $level) {
  $Props = array();
  set_attr_value_text($Html, 'dim2', $Props);
  set_attr_value_num($Html, 'price', $Props);
  set_attr_value_num($Html, 'oldPrice', $Props);
  set_attr_value_num($Html, 'available', $Props);
  set_attr_value_text($Html, 'availabilityCode', $Props);
  set_attr_value_text($Html, 'artNr', $Props);
  set_attr_value_text($Html, 'availabilityText', $Props);
  return str_pad('', $level*2, ' ', STR_PAD_LEFT) . '<Article ' . implode_hash(' ', $Props, '"') . '/>'; 
}
  
function Str2XmlDate($st) {
  list($d, $m, $y) = explode('.', $st);
  return date('Y-m-d\TH:i:s', mktime(0, 0, 0, $m, $d, $y));
}

$today = date('h-i-s, j-m-y, it is w Day z ');   
function recognize_ArticleMod($Html, $level, $tag_count) {
  for ($i=1; $i<=$tag_count; $i++) {
    $tag = extract_numbered_tag($Html, 'item', $i);
    if (stripos($tag, '"price"') !== false) {
      $Articels[] = recognize_Article($tag, $level + 1);
      $Html = str_replace($tag, '', $Html);
    }
  }
  $Props = array();
  set_attr_value_text($Html, 'artNr', $Props);
  set_attr_value_num($Html, 'available', $Props);
  set_attr_value_text($Html, 'dim1', $Props);
  $campaign = extract_property_text($Html, 'campaign');
  list($fromDate, $toDate, $a) = explode('|', $campaign);
  if ($toDate) $Props['validDate'] =  Str2XmlDate($toDate);
  set_attr_value_text($Html, 'imageLink', $Props);
  set_attr_value_text($Html, 'shortDesc', $Props);
  set_attr_value_text($Html, 'name', $Props);
  set_attr_value_text($Html, 'manufacturer', $Props);
  return str_pad('', $level*2, ' ', STR_PAD_LEFT) . '<ArticleMod ' . implode_hash(' ', $Props, '"') . '>'."\r\n".
    implode("\r\n", $Articels)."\r\n".
    str_pad('', $level*2, ' ', STR_PAD_LEFT).'</ArticleMod>'; 
}

function recognize_ArticleSign($Html, $tag_count) {
  for ($i=1; $i<=$tag_count; $i++) {
    $tag = extract_numbered_tag($Html, 'item', $i);
    if (stripos($tag, '"variations"') !== false) {
      $ArticelMods[] = recognize_ArticleMod($tag, 1, $tag_count);
      $Html = str_replace($tag, '', $Html);
    }
  }
  $Props = array();
  set_attr_value_text($Html, 'sku', $Props);
  return '<ArticleSign ' . implode_hash(' ', $Props, '"') . '>'."\r\n".
    implode("\r\n", $ArticelMods)."\r\n".
    '</ArticleSign>'; 
  return  $Html;
}
  // создаем xml_tag
  
  $Html = str_replace('{', '<item>', $Html);
  $Html = str_replace('}', '</item>', $Html);
  $Html = numbering_tag_count($Html, 'item', $item_count);
  // Извлекаем articuls
  $xml = recognize_ArticleSign($Html, $item_count);
  if ($debug) file_put_contents("$cache/Article.xml", $xml);
  echo $xml;
?>
</body>
</html>
