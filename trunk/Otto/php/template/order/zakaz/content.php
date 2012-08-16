<div class="maincontent" id="ordercontent">
  <div id="headline_item">
    <div class="text">
      <h1 class="content_headline">Заявка на доставку товаров по каталогам OTTO</h1>
    </div>
  </div>

<?php  
    $order_name = "zakaz-".date("Y")."-".date("m")."-".date("d")."-".date("H").date("i").date("s");
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
                 <td width="60%"><? echo $_POST['StreetType'];?> <? echo $_POST['Street'];?></td> 
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
                 <td width="60%"><? echo $_POST['CityType'];?> <? echo $_POST['City'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Район</td> 
                 <td width="60%"><? echo $_POST['Area'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Район</td> 
                 <td width="60%"><? echo $_POST['Region'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Контактный&nbsp;тел.<font size="2">(Домашн/Рабочий)</font></td> 
                 <td width="60%"><? echo $_POST['Phone'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Контактный&nbsp;тел.<font size="2">(Мобилъный тел.)</font></td> 
                 <td width="60%">(8-<? echo $_POST['MobPrefix'];?>)-<? echo $_POST['MobPhone'];?></td> 
               </tr> 
               <tr> 
                 <td width="40%">Форма оплаты</td> 
                 <td width="60%"><? echo $_POST['PayForm'];?></td> 
               </tr> 
             </tbody></table>
             <h4 class="head">Состав заказа</h4>
             <table cellspacing="2" cellpadding="0" border="1" class="catalog_tbl">
               <thead>
               <tr align="center" valign="middle">
                 <th><font size="1">Каталог</font></th>
                 <th><font size="1">Tип</font></th>
                 <th><font size="1">Стр.</font></th>
                 <th><font size="1">№<br/>поз.</font></th>
                 <th><font size="1">Артикул<br/>ЛАТИНСКИМ</font></th>
                 <th><font size="1">Разм</font></th>
                 <th><font size="1">Цена<br/>EUR</th>
                 <th><font size="1">Русское<br/>название товара</font></th>
                 <th><font size="1">Признак товара</font></th>
               </tr> 
               </thead>
               <tbody>
<?php 
  $header = $_POST['LastName'].";".$_POST['FirstName'].";".$_POST['MidName'].";". // Фамилия / Имя / Отчество
           $_POST['Email'].";".  //Email
           trim($_POST['StreetType']." ".$_POST['Street']).";". // Улица
           $_POST['House'].";".$_POST['Corpus'].";".$_POST['Flat'].";". // Дом / Корпус / Квартира
           $_POST['PostIndex'].";". // Индекс
           trim($_POST['CityType']." ".$_POST['City']).";".// Населеный пункт
           trim($_POST['Area']." ".$_POST['Region']).";".   // Район, область
           $_POST['Phone'].";".$_POST['MobPhone'].";".$_POST['MobPrefix'].";". // телефоны
           $_POST['PayForm'].";"; // тип оплаты
           
for($i=1;$i<=12; $i++) { 
   if ($_POST["Articul$i"]) {
     $_POST["Price$i"] = str_replace(',', '.', $_POST["Price$i"]);
     $order_items[] = $_POST["Catalog$i"].";".$_POST["CatalogPage$i"].";".$_POST["ItemPos$i"].";".$_POST["Articul$i"].";".$_POST["Size$i"].";".$_POST["Price$i"].";".$_POST["RusName$i"]." ".$_POST["RusInfo$i"];?>
               <tr align="center">
                 <td width="54"><? echo $_POST["Catalog$i"];?>&nbsp;</td>
                 <td width="25"><? echo $_POST["CatalogType$i"];?>&nbsp;</td>
                 <td width="25"><? echo $_POST["CatalogPage$i"];?>&nbsp;</td>
                 <td width="25"><? echo $_POST["ItemPos$i"];?>&nbsp;</td>
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
  if (count($order_items) > 0) {
    $attach = $header . "\r\n" . implode("\r\n", $order_items);
    if ($_POST['PayForm'] == 'Предоплата') {
      $partner_code = '73105061';
    } else {
      $partner_code = '73105050';
    }
    $order_filename = "orders/$partner_code/$order_name.dat";
    file_put_contents($order_filename, utf8_to_ansi_ru($attach));
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
    $mail->Body = "$attach";
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
