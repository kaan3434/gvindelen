<?php

function on_redirect_path ($path) {
  $_POST['LastName'] = str_replace(" ", "", $_POST['LastName']);

  // проеряем обязетельность заполения фамилии
  if ($_POST['LastName'] == null) {
    $_POST['LastName_Error'] = 'Отсутствует Фамилия';
    return 'order/check';
  }
  // проеряем обязетельность заполения номера заказа
  if ($_POST['OrderNum'] == null) {
    $_POST['OrderNum_Error'] = 'Отсутствует Номер заявки';
    return 'order/check';
  }
  if (strlen($_POST['OrderNum']) < 5) {
    $_POST['OrderNum_Error'] = 'Длина кода заявки 5-6 знаков только цифры';
    return 'order/check';
  }
  
  try {
    $url = 'ppz2orders/'.$_POST['OrderNum'].'.xml';       //адрес XML документа
//    $data = file_get_contents($url);
 
    $xml= simplexml_load_file($url);       //Интерпретирует XML-документ в объект
 
  } catch (exception $e) {
    $_POST['Check_Error'] = 'Заявка не найдена';
  }

  if ($xml->ORDER->CLIENT['LAST_NAME'] <> $_POST['LastName']) {
    $_POST['LastName_Error'] = 'Фамилия не соотвтесвует заявке';
    return 'order/check';
  }
  return $path;
}
?>
