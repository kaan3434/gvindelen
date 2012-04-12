<?php
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $booker = 'bwin';
  $host = 'https://www.bwin.com';
  
function extract_league(&$sport_node, $html) {
  $html = kill_space($html);
  $html = extract_tags($html, '<a href=\'betsnew.aspx?leagueids=', '</a>', "\r\n");
  $tournirs = explode("\r\n", $html);
  foreach($tournirs as $tournir) {
    $tournir_name = copy_between($tournir, '>', '</a');
    preg_match('/(.+) \((\d+)\)$/m', $tournir_name, $matches);
    $tournir_name = $matches[1];
    // бракуем турниры
    if (!similar_to($tournir_name, '.+ - live$')) {
      $tournir_node = $sport_node->addChild('Tournir', $tournir_name);

      $league = copy_be($tournir, '<a', '>', 'leagueids');
      $league_id = copy_between($league, 'leagueids=', "'");
      $tournir_node->addAttribute('Id', $league_id);
    }
  }
}
  
function scan_line_bwin(&$sport_node, $category_id, $debug = null) {
  global $host, $booker;
  if (file_exists('proxy.txt')) $proxy = file_get_contents('proxy.txt');
  $league_path = "lines/$booker/$sport_node.";
  
  // получаем перечень турниров
  $html = download_or_load($debug, $league_path."league.html", "$host/$sport_node?ShowDays=168", "GET", $proxy, "");
  extract_league($sport_node, $html);
  
  foreach($sport_node as $tournir_node) {
    $post_hash = array();
    $post_hash['leagueIDs'] = $tournir_node->attributes['Id'];
    $post_hash['sorting'] = "dateleague";
    $post_hash['categoryIDs'] = $category_id;
  }
  
  
  
  if ($debug) file_put_contents($league_path."league.xml", $sport_node->asXML());
}
?>
