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
  if (strlen($_POST['OrderNum']) <> 5) {
    $_POST['OrderNum_Error'] = 'Длина кода заявки 5 знаков только цифры';
    return 'order/check';
  }
  
  try {
    $url = 'ppz2order/'.$_POST['OrderNum'].'.xml';       //адрес XML документа
 
    $xml= simplexml_load_file($url);       //Интерпретирует XML-документ в объект
 
    //Выводим XML на печать
//foreach ($xml->channel->item as $item) {
//        echo $item->title;       //выводим на печать название книги 
//        echo $item->author;        //выводим на печать автора книги 
//        echo $item->pages;        //выводим на печать количество страниц
//        echo $item->isbnr;        //выводим на печать ISBN 
//        echo $item->year;        //выводим на печать год
//}
  } catch (exception $e) {
    $_POST['Check_Error'] = 'Заявка не найдена';
  }

  if ($xml->!$order_founded) {
    $_POST['Check_Error'] = 'Информация о заявке отсутствует:<br/>a) Фамилия или номер введены с ошибками<br/>б) Заявка отсутствует в поисковике, повторите попытку позже<br/>';
    return 'order/check';
  }
  
  return $path;
}
?>
