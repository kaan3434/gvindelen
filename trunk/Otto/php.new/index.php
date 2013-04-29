<?php
  session_start();
  require "libs/Download.php";
  require "libs/GvStrings.php";
  require "libs/GvHtmlSrv.php";
  require "libs/utf2win.php";
  $server_name = $_SERVER['SERVER_NAME'];
  require "settings/$server_name/mail.inc";
  require "settings/$server_name/mysql.inc";
  $ext = '.tphp';
  $template_path = 'template/';
  if (file_exists('default.php')) unlink('default.php');
  

function detect_scheme() {
  $month_no = date('m');
  
  if ($month_no == '01') {
    $scheme = 1;
  } elseif ($month_no == '02') {
    $scheme = 2;
  } elseif ($month_no == '03') {
    $scheme = 2;
  } elseif ($month_no == '04') {
    $scheme = 2;
  } elseif ($month_no == '05') {
    $scheme = 3;
  } elseif ($month_no == '06') {
    $scheme = 3;
  } elseif ($month_no == '07') {
    $scheme = 3;
  } elseif ($month_no == '08') {
    $scheme = 4;
  } elseif ($month_no == '09') {
    $scheme = 4;
  } elseif ($month_no == '10') {
    $scheme = 4;
  } elseif ($month_no == '11') {
    $scheme = 1;
  } elseif ($month_no == '12') {
    $scheme = 1;
  }
  return $scheme;
}
  $scheme = detect_scheme();

function detect_caption($scheme) {
  if ($scheme == 1) {
    return 'Зима с OTTO';
  } elseif ($scheme == 2) {
    return 'Весна с OTTO';
  } elseif ($scheme == 3) {
    return 'Лето с OTTO';
  } elseif ($scheme == 4) {
    return 'Осень с OTTO';
  }
}
 
function extract_searches($template_path, $path) {
  $path_arr = explode("/", $path);
  if ($path_arr[0] == null) $path_arr[0] = 'start';
  $searches = array();
  $c = count($path_arr);
  $path = $template_path;
  $searches[] = $path;
  for ($i=0; $i<$c; $i++) {
    $path = $path . $path_arr[$i] . '/';
    $searches[] = $path;
  }
  return $searches;
}
  $path = $_GET['path'];      
//  if (!$path and $_SERVER['QUERY_STRING']) {
//    echo 'page_not_found';
//    exit; 
//  }

  // проверяем перенаправление страницы
  $event_fname = $template_path . $path .'/'.'on_redirect_path' . '.php';
  if (file_exists($event_fname)) {
    include $event_fname;
    $path = on_redirect_path($path);
  }
  $searches = extract_searches($template_path, $path);
  
  
  function include_template($html, $searches, $template) {
    global $ext;
    $template_name = str_replace('<!--#', '', $template);
    $template_name = str_replace('#-->', $ext, $template_name);
    $template_name = str_ireplace('$_SERVER[SERVER_NAME]', $_SERVER['SERVER_NAME'], $template_name);
    $c = count($searches);  
    for ($i=$c-1; $i>=0; $i--) {
      $file_name = $searches[$i] . $template_name;
      if (file_exists($file_name)) {
        $block = file_get_contents($file_name);
        return str_replace($template, $block, $html);
      }  
    }
    return str_replace($template, '', $html);
  }
  
  $html = file_get_contents('template/html'.$ext);
  $templates = explode("\r\n", extract_tags($html, '<!--#', '#-->', "\r\n"));
  while ($templates[0]) {
    foreach ($templates as $template_name) {
      $html = include_template($html, $searches, $template_name);
    }
    $templates = extract_all_tags($html, '<!--#', '#-->');
  };
  
  $fname = 'cache/'.session_id().'.php';
  file_put_contents($fname, $html);
  include $fname;
//  unlink($fname);
 
?>