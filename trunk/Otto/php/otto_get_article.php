<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $debug = $_GET['debug'];
  $article = $_GET['article_code'];
  $cache = 'cache';
  $Host = 'http://www.otto.de/';

  if ($debug) {
    $FileName = "$cache/main.html";
    if (!file_exists($FileName)) {
      $Html = download("$Host", "GET");
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    } 
  } else {
    $Html = download("$Host", "GET");
  }
  echo "Main page 1 downloaded\r\n";
  $FormSearch = copy_be($Html, '<form ', '</form>', 'topSearch');
  $PostHash = extract_form_hash($FormSearch);
  $PostHash['fh_search'] = $_GET['article_code'];
  
  $Html = copy_be($FormSearch, '<form ', '>');
  $url_1 = extract_property_values($Html, 'action', "\r\n");
  $Html = download($url_1, 'GET', "$Host", $PostHash);
  echo "Search page 2 downloaded\r\n";
      
//  if ($debug) file_put_contents("$cache/page.1.html", $Html);
      
  $FormSearch = copy_be($Html, '<form ', '</form>', 'searchform');
  $PostHash = extract_form_hash($FormSearch);

  $Html = copy_be($FormSearch, '<form ', '>');
  $url_2 = extract_property_values($Html, 'action', "\r\n");
  $Html = download($url_2, 'GET', $url_1, $PostHash);
  echo "Search page 3 downloaded\r\n";
     
//  if ($debug) file_put_contents("$cache/page.2.html", $Html);
  $Html = copy_be($Html, '<script>', '</script>', 'goon');
  $Html = str_ireplace(" '", " <'", $Html);
  $Html = str_ireplace("+'", "+<'", $Html);
  $Html = str_ireplace("'+", "'>+", $Html);
  $Html = str_ireplace("';", "'>;", $Html);
  $url_3 = extract_tags($Html, "<'", "'>", '');
  $url_3 = str_replace("<'", '', $url_3);
  $url_3 = str_replace("'>", '', $url_3);
  $Html = download($url_3, 'GET', $url_2);
//  if ($debug) file_put_contents("$cache/page.3.html", $Html);
      // вырезаем информацию об артикуле
  $Html = copy_be($Html, '<script>', '</script>', 'sku');
  $Html = copy_be($Html, " {", "\n");
  if ($debug) file_put_contents("$cache/article_$article.html", $Html);
  echo "All loaded\r\n";

function extract_property_text($Html, $PropertyName) {
  $prop_name = '"'.$PropertyName.'":"';
  $pos = stripos($Html, $prop_name);
  if ($pos !== false)
    return copy_front_withotkey($Html, $pos+strlen($prop_name), '"');
  else
    return null;
}
function set_attr_value_text($Html, $SrcPropertyName, $NewPropertyName, &$Hash) {
  if ($prop_value = extract_property_text($Html, $SrcPropertyName))
    $Hash[$NewPropertyName] = $prop_value;
}

function extract_property_num($Html, $PropertyName) {
  $prop_name = '"'.$PropertyName.'":';
  $pos = stripos($Html, $prop_name);
  if ($pos !== false)
    return copy_front_withotkey($Html, $pos+strlen($prop_name), ',< ');
  else
    return null;
}

function check_availability(&$Props) {
  global $url_3, $debug;
  $PostHash['ArticleNo'] = $Props['article_code'];
  $PostHash['ArticleSize'] = $Props['dimension'];

  if ($debug) {
    $FileName = "cache/avail_".$Props['article_code']."_".$Props['dimension'].".html";
    if (!file_exists($FileName)) {
      $Html = download("$Host/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewDeliveryInfo-IncludeDelivery", "POST", $url_3, $PostHash);
      file_put_contents($FileName, $Html);
    } else {
      $Html = file_get_contents($FileName);
    } 
  } else {
    $Html = download("$Host/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewDeliveryInfo-IncludeDelivery", "POST", $url_3, $PostHash);
  }
  $Html = copy_be($Html, '<span ', '</span>', 'availability');
  $availablility_class = extract_property_values($Html, 'class');
  if ($availablility_class = 'availability_red') {
    $Props['available'] = 'false';
  } else {
    $Props['available'] = 'true';
  }
  $Props['availability_code'] = delete_all($Html, '<', '>');
}

function set_attr_value_num($Html, $SrcPropertyName, $NewPropertyName, &$Hash) {
  if ($prop_value = extract_property_num($Html, $SrcPropertyName))
    $Hash[$NewPropertyName] = $prop_value;
}

function recognize_Article($Html, $level) {
  $Props = array();
  set_attr_value_text($Html, 'dim2', 'dimension', $Props);
  set_attr_value_num($Html, 'price', 'price_eur', $Props);
  set_attr_value_num($Html, 'oldPrice', 'oldprice_eur', $Props);
  set_attr_value_num($Html, 'available', 'available', $Props);
  set_attr_value_text($Html, 'artNr', 'articul_code', $Props);
  $availability = extract_property_text($Html, 'availabilityCode');
  if ($availability) {
    set_attr_value_text($Html, 'availabilityCode', 'availability_code', $Props);
    set_attr_value_text($Html, 'availabilityText', 'availability_text', $Props);
  } else {
    check_availability($Props);
  }
  return str_pad('', $level*2, ' ', STR_PAD_LEFT) . '<Article ' . implode_hash(' ', $Props, '"') . '/>'; 
}
  
function Str2XmlDate($st) {
  list($d, $m, $y) = explode('.', $st);
  return date('Y-m-d\TH:i:s', mktime(0, 0, 0, $m, $d, $y));
}

function recognize_ArticleCode($Html, $level, $tag_count) {
  for ($i=1; $i<=$tag_count; $i++) {
    $tag = extract_numbered_tag($Html, 'item', $i);
    if (stripos($tag, '"price"') !== false) {
      $Articels[] = recognize_Article($tag, $level + 1);
      $Html = str_replace($tag, '', $Html);
    }
  }
  $Props = array();
  set_attr_value_text($Html, 'artNr', 'article_code', $Props);
  set_attr_value_num($Html, 'available', 'available', $Props);
  set_attr_value_text($Html, 'dim1', 'dimension', $Props);
  $campaign = extract_property_text($Html, 'campaign');
  list($fromDate, $toDate, $a) = explode('|', $campaign);
  if ($toDate) $Props['valid_date'] =  Str2XmlDate($toDate);
  set_attr_value_text($Html, 'imageLink', 'image_link', $Props);
  set_attr_value_text($Html, 'shortDesc', 'short_desc', $Props);
  set_attr_value_text($Html, 'name', 'name', $Props);
  set_attr_value_text($Html, 'manufacturer', 'manufacturer', $Props);
  $result = str_pad('', $level*2, ' ', STR_PAD_LEFT) . '<ArticleCode ' . implode_hash(' ', $Props, '"') . '>'."\r\n".
    implode("\r\n", $Articels)."\r\n".
    str_pad('', $level*2, ' ', STR_PAD_LEFT).'</ArticleCode>'; 
  return $result;
}

function recognize_ArticleSign($Html, $tag_count) {
  for ($i=1; $i<=$tag_count; $i++) {
    $tag = extract_numbered_tag($Html, 'item', $i);
    if (stripos($tag, '"variations"') !== false) {
      $ArticleMods[] = recognize_ArticleCode($tag, 1, $tag_count);
      $Html = str_replace($tag, '', $Html);
    }
  }
  $Props = array();
  set_attr_value_text($Html, 'sku', 'sku', $Props);
  $result = '<ArticleSign ' . implode_hash(' ', $Props, '"') . '>'."\r\n".
    implode("\r\n", $ArticleMods)."\r\n".
    '</ArticleSign>'; 
  return $result;
}
  // создаем xml_tag
  $Html = str_replace('{', '<item>', $Html);
  $Html = str_replace('}', '</item>', $Html);
  $Html = numbering_tag_count($Html, 'item', $item_count);
  // Извлекаем articuls         
  $xml = recognize_ArticleSign($Html, $item_count);
  if ($debug) file_put_contents("$cache/Article.xml", $xml);
?>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Get Article</title>
  </head>
<body>
<? echo $xml ?>;
</body>
</html>
