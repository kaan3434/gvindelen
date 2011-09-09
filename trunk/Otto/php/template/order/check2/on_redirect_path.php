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
  if (strlen(utf8_to_ansi_ru($_POST['OrderNum'])) <> 6) {
    $_POST['OrderNum_Error'] = 'Длина кода заявки 6 знаков';
    return 'order/check';
  }
  
  try {
    $dblink = db_connect();
    $sql = 'select * from sendinet where numzak = "'.$_POST['OrderNum'].'" and upper(family) like upper("'.$_POST['LastName'].' %") limit 1';
    $query = mysql_query($sql, $dblink);
    $order_founded = mysql_num_rows($query) > 0;
    mysql_close($dblink);
  } catch (exception $e) {
    $_POST['Check_Error'] = 'Не могу открыть БД';
  }

  if (!$order_founded) {
    $_POST['Check_Error'] = 'Информация о заявке отсутствует:<br/>a) Фамилия или номер введены с ошибками<br/>б) Заявка отсутствует в поисковике, повторите попытку позже<br/>';
    return 'order/check';
  }
  
  return $path;
}
?>
