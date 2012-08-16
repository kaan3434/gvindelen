<?php

function utf8_ucfirst($str) {
  return win1251_to_utf8(ucfirst(strtolower(utf8_to_ansi_ru($str)))); 
}

function valid_mandatory($param_name, $param_caption) {
  if (($_POST[$param_name] == null) or ($_POST[$param_name] == '')) {
    $_POST[$param_name.'_Error'] = $param_caption.' отсутствует';
    return 1;
  }
  return 0;
}

function valid_filter($param_name, $param_caption, $filter) {
  $filter = "/[^$filter]/";
  $filtered = win1251_to_utf8(preg_replace($filter, "", utf8_to_ansi_ru($_POST[$param_name])));
  if ($filtered <> $_POST[$param_name]) {
    $_POST[$param_name.'_Error'] = $param_caption.' должна быть набрана на кириллице';
    return 1;
  }
  return 0;
}

function valid_email($param_name, $param_caption) {
  $filter = "/[^A-z\.\-@]/";
  $filtered = win1251_to_utf8(preg_replace($filter, "", utf8_to_ansi_ru($_POST[$param_name])));
  if ($filtered <> $_POST[$param_name]) {
    $_POST[$param_name.'_Error'] = $param_caption.' должен содержать символы [a-z][0-9]';
    return 1;
  }
  return 0;
}

function valid_length($param_name, $param_caption, $min, $max) {
  $filtered = trim($_POST[$param_name]);
  if (strlen($filtered) < $min)  {
    $_POST[$param_name.'_Error'] = $param_caption.' должен содержать не менее '.$min.' знаков';
    return 1;
  }
  if (strlen($filtered) > $max)  {
    $_POST[$param_name.'_Error'] = $param_caption.' должен содержать не более '.$max.' знаков';
    return 1;
  }
  return 0;
}


function on_redirect_path ($path) {
  $filter_cyr = "\xC0-\xFF";
  $filter_integer = "0-9";
  $filter_float = "0-9\-\.\,";
  $filter_lat = "A-Za-z";

  $valid = 0;
  // проеряем обязетельность заполения фамилии
  $_POST['LastName'] = utf8_ucfirst($_POST['LastName']); 
  $valid += valid_mandatory('LastName', 'Фамилия') + valid_filter('LastName', 'Фамилия', $filter_cyr);

  // проеряем обязетельность заполения имени
  $_POST['FirstName'] = utf8_ucfirst($_POST['FirstName']); 
  $valid += valid_mandatory('FirstName', 'Имя') + valid_filter('FirstName', 'Имя', $filter_cyr);

  // проеряем обязетельность заполения Отчество
  $_POST['MidName'] = utf8_ucfirst($_POST['MidName']); 
  $valid += valid_mandatory('MidName', 'Отчество') + valid_filter('MidName', 'Отчество', $filter_cyr);
  
  $_POST['Email'] = strtolower($_POST['Email']);
  $valid += valid_mandatory('Email', 'E-mail');// + valid_email('Email', 'E-mail');

  $_POST['Street'] = utf8_ucfirst($_POST['Street']); 
  $valid += valid_mandatory('Street', 'Улица') + valid_filter('Street', 'Улица', $filter_cyr.$filter_integer." \.\-");
  
  $valid += valid_mandatory('House', '№ дома') + valid_filter('House', '№ дома', $filter_cyr.$filter_integer."\-");
  
  $valid += valid_filter('Corpus', 'Корпус', $filter_integer);

  $valid += valid_mandatory('Flat', 'Квартира') + valid_filter('Flat', 'Квартира', $filter_cyr.$filter_integer."\-");

  $valid += valid_mandatory('PostIndex', 'Индекс') + valid_length('PostIndex', 'Индекс', 6, 6);

  $_POST['City'] = utf8_ucfirst($_POST['City']); 
  $valid += valid_mandatory('City', 'Город') + valid_filter('City', 'Город', $filter_cyr);

  if (($_POST['CityType'] == 'гп') or ($_POST['CityType'] == 'пос') or ($_POST['CityType'] == 'дер')) {
    $_POST['Region'] = utf8_ucfirst($_POST['Region']); 
    $valid += valid_mandatory('Region', 'Район') + valid_filter('Region', 'Район', $filter_cyr);

    $_POST['Area'] = utf8_ucfirst($_POST['Area']); 
    $valid += valid_mandatory('Area', 'Область') + valid_filter('Area', 'Область', $filter_cyr);
  }
  
  if ($valid > 0) {
    $_POST['Check_Error'] = 'Ошибки при оформлении заявки. Исправьте ошибки.';
    return 'order/form';
  }
  
  return $path;
}
?>
