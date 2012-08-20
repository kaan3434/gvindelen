<div class="maincontent" id="ordercontent">
  <div id="headline_item">
    <div class="text">
      <h1 class="content_headline">Заявка на доставку товаров по каталогам OTTO</h1>
    </div>
  </div>

<?php  
  require_once "libs/GvXmlUtils.php";
  $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><ORDER/>');
  $client_node = $xml->addChild('CLIENT');
  $adress_node = $client_node->addChild('ADRESS');
  $place_node = $adress_node->addChild('PLACE');
  $product_node = $xml->addChild('PRODUCT');
  Hash2Attrs($client_node, $_POST, 'LAST_NAME=LastName;FIRST_NAME=FirstName;MID_NAME=MidName;EMAIL=Email;PHONE_NUMBER=Phone;MOBILE_PHONE=MobPhone');
  Hash2Attrs($adress_node, $_POST, 'POSTINDEX=PostIndex;STREETTYPE_ID=StreetTypeId;STREET_NAME=Street;HOUSE=House;BUILDING=Corpus;FLAT=Flat');
  Hash2Attrs($place_node, $_POST, 'PLACETYPE_ID=CityTypeId;PLACE_NAME=City;AREA_NAME=Area;REGION_NAME=Region');
  Hash2Attrs($product_node, $_POST, 'PARTNER_NUMBER=PayForm');
  $streettypes = file('references/streettypes.txt');
  $placetypes = file('references/placetypes.txt');
?>

  <div class="content" id="terms">
    <div class="container">
      <h3 class="head head-hidden">Заявка <? echo $order_name;?></h3>
      <div class="box">
        <div class="pad">
          <font color='blue'><strong>Ваша заявка автоматически отправлена в офис по обслуживанию клиентов Представительства ЗАО «Балт-пост»: Минск, Козлова 3, Дворец искусств, 1 этаж, правый торец здания</stong></font><br>
          <h4 class="head">Адрес доставки</h4>
             <table cellspacing="2" cellpadding="0" border="0" class="catalog_tbl"><tbody>
               <tr> 
                 <td width="40%">Фамилия</td>
                 <td width="60%"><? echo $_POST['LastName'];?></td>
               </tr> 
               <tr> 
                 <td width="40%">Имя</td> 
                 <td width="60%"><? echo $_POST['FirstName'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Отчество</td> 
                 <td width="60%"><? echo $_POST['MidName'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Email</td> 
                 <td width="60%"><? echo $_POST['Email'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Улица</td> 
                 <td width="60%"><? echo $streettypes[$_POST['StreetTypeId']];?> <? echo $_POST['Street'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">№&nbsp;дома</td> 
                 <td width="60%"><? echo $_POST['House'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Корпус</td> 
                 <td width="60%"><? echo $_POST['Corpus'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Квартира</td> 
                 <td width="60%"><? echo $_POST['Flat'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Индекс</td> 
                 <td width="60%"><? echo $_POST['PostIndex'];?></td>
               </tr> 
               <tr> 
                 <td width="40%">Город</td> 
                 <td width="60%"><? echo $placetypes[$_POST['CityTypeId']];?> <? echo $_POST['City'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Район</td> 
                 <td width="60%"><? echo $_POST['Region'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Область</td> 
                 <td width="60%"><? echo $_POST['Area'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Контактный&nbsp;тел.<font size="2">(Домашн/Рабочий)</font></td> 
                 <td width="60%"><? echo $_POST['Phone'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Контактный&nbsp;тел.<font size="2">(Мобилъный тел.)</font></td> 
                 <td width="60%"><? echo $_POST['MobPhone'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Форма оплаты</td> 
                 <td width="60%"><? if ($_POST['PayForm'] == 73105061) {echo "Предоплата";} else {echo "Наложенный платеж";}?></td> 
               </tr> 
             </tbody></table>
             <h4 class="head">Состав заказа</h4>
             <table cellspacing="2" cellpadding="0" border="1" class="catalog_tbl">
               <thead>
               <tr align="center" valign="middle">
                 <th><font size="1">Артикул<br/>ЛАТИНСКИМ</font></th>
                 <th><font size="1">Разм</font></th>
                 <th><font size="1">Цена<br/>EUR</th>
                 <th><font size="1">Русское<br/>название товара</font></th>
                 <th><font size="1">Признак товара</font></th>
               </tr> 
               </thead>
               <tbody>
<?php 
  $orderitems_node = $xml->addChild('ORDERITEMS');
           
for($i=1;$i<=12; $i++) { 
   if ($_POST["Articul$i"]) {
     $_POST["Price$i"] = str_replace(',', '.', $_POST["Price$i"]);
     $orderitem_node = $orderitems_node->addChild('ORDERITEM');
     Hash2Attrs($orderitem_node, $_POST, "ARTICLE_CODE=Articul$i;DIMENSION=Size$i;PRICE_EUR=Price$i;NAME_RUS=RusName$i;KIND_RUS=RusInfo$i");
?>     
               <tr align="center">
                 <td width="40"><? echo $_POST["Articul$i"];?>&nbsp;</td>
                 <td width="30"><? echo $_POST["Size$i"];?>&nbsp;</td>
                 <td width="41"><? echo $_POST["Price$i"];?>&nbsp;</td>
                 <td width="48"><? echo $_POST["RusName$i"];?>&nbsp;</td>
                 <td width="66"><? echo $_POST["RusInfo$i"];?>&nbsp;</td>
               </tr>
<?php 
  }
}?>
          </tbody></table>
<?php
  if ($orderitems_node->children()) {
    // получаем номер файла
    $file_counter = 'cache/orders.'.date('Ydm').'.cnt';
    $handle = fopen($file_counter, 'a+');
    fputs($handle, "\r\n".session_id());
    fclose($handle);
    $sessions = explode("\r\n", file_get_contents($file_counter));
    
    $idx = array_search(session_id(), $sessions);
    
    $order_name = date('Ymd').'_'.str_pad($idx, 3, '0', STR_PAD_LEFT);
    $order_filename = "orders/$order_name.xml"; 
    $xml->asXML($order_filename);
?>
           <font color='blue'>С условиями оформления заявки по интернету и с условиями получения международной посылки с товаром по каталогам OTTO ознакомилась / ознакомился.</font><br>
           <br>
           <font color='blue'>Ваш предварительный <strong>номер</strong> интернет-заявки: </font><font color="red"><strong><? echo $order_name; ?></strong></font><br>
           <br>
           Окончательный пятизначный номер заказа  Вы получите <font color='blue'><b>в течение 1-2 рабочих дней</b></font> по Е-майлу.<br>
           Это позволит Вам самостоятельно проследить за процессом выполнения и доставки Вашего заказа на странице <a href="?path=order/check">«слежение за прохождением заявки»</a> нашего сайта<br>
           <br>
<?php
    $mail = init_mail_4zakaz();
    $mail->From     = $_POST["Email"]; // укажите от кого письмо   $mail = new PHPMailer();
    $mail->FromName = $_POST["FirstName"]." ".$_POST["LastName"];   // от кого
  //  $mail->IsHTML(true);        // выставляем фомат письма HTML
    $mail->Subject = "заказ-интернет $order_name";  // тема письма   
    $mail->Body = "";
    $mail->AddAttachment($order_filename, $order_name);
    // отправляем наше письмо
    if ($mail->Send()) {
      $mail_status = '<font color="blue"> и отправлена</font>'; 
    } else {
      $mail_status = '<font color="red">, но не отправлена</font>'; 
    }
  }
?>
          Ваша заявка зарегистрирована<strong><? echo $mail_status;?></strong>.
        </div>
      </div>
    </div>
  </div>
</div>
