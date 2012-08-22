<?php
  require_once "libs/GvXmlUtils.php";
  $file_counter = 'cache/orders.'.date('Ydm').'.cnt';
  $sessions = array();
  if (file_exists($file_counter)) $sessions = explode("\r\n", file_get_contents($file_counter));
  $idx = array_search(session_id(), $sessions);
  if ($idx) {
    $order_name = 'order-'.date('Ymd').'-'.str_pad($idx, 3, '0', STR_PAD_LEFT);
    $order_filename = "orders/$order_name.xml"; 
    $xml=  simplexml_load_file($order_filename);
    $client_node = $xml->CLIENT;
    $adress_node = $xml->ADRESS;
    $place_node = $adress_node->PLACE;
    $product_node = $xml->PRODUCT;
    $orderitems_node = $xml->ORDERITEMS;

    Attrs2Hash($_POST, $client_node, 'LastName=LAST_NAME;FirstName=FIRST_NAME;MidName=MID_NAME;Email=EMAIL;Phone=STATIC_PHONE;MobPhone=MOBILE_PHONE');
    Attrs2Hash($_POST, $adress_node, 'PostIndex=POSTINDEX;StreetTypeId=STREETTYPE_CODE;Street=STREET_NAME;House=HOUSE;Corpus=BUILDING;Flat=FLAT');
    Attrs2Hash($_POST, $place_node, 'CityTypeId=PLACETYPE_CODE;City=PLACE_NAME;Area=AREA_NAME;Region=REGION_NAME');
    Attrs2Hash($_POST, $product_node, 'PayForm=PARTNER_NUMBER');
    $i = 1;
    foreach ($orderitems_node->children() as $orderitem_node) {
      Attrs2Hash($_POST, $orderitem_node, "Articul$i=ARTICLE_CODE;Size$i=DIMENSION;Price$i=PRICE_EUR;RusName$i=NAME_RUS;RusInfo$i=KIND_RUS");
      $i++;
    }
  } else {
    $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><ORDER/>');
  }
?>
<div class="maincontent" id="ordercontent">
  <div id="headline_item">
    <div class="text">
      <h1 class="content_headline">Заказ товаров по каталогам OTTO</h1>
    </div>
  </div>
  <div class="content" id="terms">
    <div class="container">
      <h3 class="head head-visible">Форма Заявки</h3>
      <div class="box">
        <div class="pad">
          <form method="post" action="?path=order/zakaz" enctype="multipart/form-data" name="myform">
          <h4 class="head">Адрес доставки</h4>
             <table cellspacing="2" cellpadding="0" border="0" class="catalog_tbl"><tbody>
               <tr> 
                 <td width="30%"><font color="red">Фамилия</font></td>
                 <td width="30%"><input type="text" size="35" name="LastName" class="cat_tables_form" value="<? echo $_POST['LastName'];?>"></td>
                 <td width="40%"><font color="red"><? echo $_POST['LastName_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Имя</font></td> 
                 <td width="30%"><input type="text" size="35" name="FirstName" class="cat_tables_form" value="<? echo $_POST['FirstName'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['FirstName_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Отчество</font></td> 
                 <td width="30%"><input type="text" size="35" name="MidName" class="cat_tables_form" value="<? echo $_POST['MidName'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['MidName_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Email</font></td> 
                 <td width="30%"><input type="text" size="35" name="Email" class="cat_tables_form" value="<? echo $_POST['Email'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['Email_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Улица</font></td> 
                 <td width="30%"><select size="1" name="StreetTypeId" class="cat_tables_form"> 
                                   <option value="1" <? if ($_POST['StreetTypeId'] == "1") echo "selected"; ?>>улица</option>
                                   <option value="2"<? if ($_POST['StreetTypeId'] == "2") echo "selected"; ?>>проспект</option>
                                   <option value="3"<? if ($_POST['StreetTypeId'] == "3") echo "selected"; ?>>переулок</option>
                                   <option value="4"<? if ($_POST['StreetTypeId'] == "4") echo "selected"; ?>>проезд</option>
                                   <option value="5"<? if ($_POST['StreetTypeId'] == "5") echo "selected"; ?>>микрорайон</option>
                                   <option value="6"<? if ($_POST['StreetTypeId'] == "6") echo "selected"; ?>>тракт</option>
                                   <option value="7"<? if ($_POST['StreetTypeId'] == "7") echo "selected"; ?>>площадь</option>
                                   <option value="8"<? if ($_POST['StreetTypeId'] == "8") echo "selected"; ?>>бульвар</option>
                                   <option value="9"<? if ($_POST['StreetTypeId'] == "9") echo "selected"; ?>>шоссе</option>
                                   <option value="10"<? if ($_POST['StreetTypeId'] == "10") echo "selected"; ?>>павильон</option>
                                   <option value="11"<? if ($_POST['StreetTypeId'] == "11") echo "selected"; ?>>квартал</option>
                                   <option value="12"<? if ($_POST['StreetTypeId'] == "12") echo "selected"; ?>>мжк</option>
                                   <option value="13"<? if ($_POST['StreetTypeId'] == "13") echo "selected"; ?>>станция</option>
                                 </select>&nbsp;<input type="text" size="18" name="Street" class="cat_tables_form" value="<? echo $_POST['Street'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['Street_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">№&nbsp;дома</font></td> 
                 <td width="30%"><input type="text" size="35" name="House" class="cat_tables_form" value="<? echo $_POST['House'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['House_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%">Корпус</td> 
                 <td width="30%"><input type="text" size="35" name="Corpus" class="cat_tables_form" value="<? echo $_POST['Corpus'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['Corpus_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Квартира</font></td> 
                 <td width="30%"><input type="text" size="35" name="Flat" class="cat_tables_form" value="<? echo $_POST['Flat'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['Flat_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Индекс</font></td> 
                 <td width="30%"><input type="text" size="35" name="PostIndex" class="cat_tables_form" value="<? echo $_POST['PostIndex'];?>"></td>
                 <td width="40%"><font color="red"><? echo $_POST['PostIndex_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Город <font size="2">(гп пос дер)</font></font></td> 
                 <td width="30%"><select size="1" name="CityTypeId" class="cat_tables_form"> 
                                   <option value="4"<? if ($_POST['CityTypeId'] == "4") echo "selected"; ?>>город</option>
                                   <option value="5"<? if ($_POST['CityTypeId'] == "5") echo "selected"; ?>>городской поселок</option>
                                   <option value="6"<? if ($_POST['CityTypeId'] == "6") echo "selected"; ?>>поселок</option>
                                   <option value="7"<? if ($_POST['CityTypeId'] == "7") echo "selected"; ?>>деревня</option>
                                   <option value="8"<? if ($_POST['CityTypeId'] == "8") echo "selected"; ?>>военная часть</option>
                                   <option value="9"<? if ($_POST['CityTypeId'] == "9") echo "selected"; ?>>военный городок</option>
                                 </select> <input type="text" size="12" name="City" class="cat_tables_form" value="<? echo $_POST['City'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['City_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%">Район<font size="2">(обязательно укажите, если местожительство гп, поселок или деревня)</font></td> 
                 <td width="30%"><input type="text" size="35" name="Region" value="" class="cat_tables_form" value="<? echo $_POST['Region'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['Region_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%">Область<font size="2">(обязательно укажите, если местожительство гп, поселок или деревня)</font></td> 
                 <td width="30%"><input type="text" size="35" name="Area" value="" class="cat_tables_form" value="<? echo $_POST['Area'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['Area_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Контактный&nbsp;тел.</font><font size="2">(Домашн/Рабочий)</font></td> 
                 <td width="30%"><input type="text" maxlength="28" size="35" name="Phone" class="cat_tables_form" value="<? echo $_POST['Phone'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['Phone_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Контактный&nbsp;тел.</font><font size="2">(Мобилъный тел.)</font></td> 
                 <td width="30%"><input type="text" maxlength="28" size="35" name="MobPhone" class="cat_tables_form" value="<? echo $_POST['MobPhone'];?>"></td> 
                 <td width="40%"><font color="red"><? echo $_POST['MobPhone_Error'];?></font></td>
               </tr> 
               <tr> 
                 <td width="30%"><font color="red">Форма оплаты</font></td> 
                 <td width="30%"><select size="1" name="PayForm" class="cat_tables_form"> 
                                    <option value="73105061" <? if ($_POST['PayForm'] == "73105061") echo "selected"; ?>>Предоплата</option>
                                    <option value="73105050" <? if ($_POST['PayForm'] == "73105050") echo "selected"; ?>>Наложенным платежом</option>
                                  </select></td> 
               </tr> 
             </tbody></table>
             <h4 class="head">Состав заказа</h4>
             <table cellspacing="2" cellpadding="0" border="0" class="catalog_tbl" align="center">
               <thead>
               <tr align="center" valign="middle">
                 <th><font color="red" size="1">Артикул<br/>ЛАТИНСКИМ</font></th>
                 <th><font color="red" size="1">Разм</font></th>
                 <th><font color="red" size="1">Цена<br/>EUR</th>
                 <th><font color="red" size="1">Русское<br/>название товара</font></th>
                 <th><font color="red" size="1">Признак товара</font></th>
               </tr> 
               </thead>
               <tbody>
<?php for($i=1;$i<=12; $i++) { ?>
               <tr align="center">
                 <td width="40"><input type="text" maxlength="8" size="10" name="Articul<?echo $i;?>" value="<?echo $_POST["Articul$i"];?>" class="cat_tables_form"></td>
                 <td width="30"><input type="text" maxlength="3" size="3" name="Size<?php echo $i;?>" value="<?echo $_POST["Size$i"];?>" class="cat_tables_form"></td>
                 <td width="40"><input type="text" maxlength="6" size="10" name="Price<?php echo $i;?>" value="<?echo $_POST["Price$i"];?>" class="cat_tables_form"></td>
                 <td width="48"><input type="text" maxlength="20" size="20" name="RusName<?php echo $i;?>" value="<?echo $_POST["RusName$i"];?>" class="cat_tables_form"></td>
                 <td width="66"><input type="text" maxlength="24" size="24" name="RusInfo<?php echo $i;?>" value="<?echo $_POST["RusInfo$i"];?>" class="cat_tables_form"></td>
               </tr>
               
               <tr>
<? if ($_POST["Article$i"."_Error"]) {?>               
                 <td colspan="7"><font color="red"><? echo $_POST["Article$i"."_Error"];?></font></td>
<? } ?>                 
               </tr>  
<?php } ?>
             </tbody></table>
             <center>
               <input type="checkbox" onclick="if (this.checked){this.form.tr.disabled=0}else{this.form.tr.disabled=1}">
               <font color="red"><strong>С условиями оформления заявки<br>по интернету и с условиями получения международной посылки<br>с товаром по каталогам "Отто" ознакомилась / ознакомился.</strong></font><br/>
               <input type="submit" class="button" value="       Заказать       " name="tr" disabled="1">&nbsp;
               <input type="reset" class="button" value="       Очистить       ">
            </center>
          </form>
        </div>
      </div>
    </div>
    
    <div class="container">
      <h3 class="head head-hidden">РЕКОМЕНДАЦИИ ПО ЗАПОЛНЕНИЮ "АДРЕСА ДОСТАВКИ"</h3>
      <div class="box">
        <div class="pad">
          <p><font color="red">Фамилия</font> - Пишите полностью русскими буквами, начиная с заглавной.<br/>
             <strong>Например:</strong> Иванова<br>
          <br></p>
          <p><font color="red">Имя</font> - Пишите полностью русскими буквами, начиная с заглавной.<br/>
             <strong>Например:</strong> Мария<br>
          <br></p>
          <p><font color="red">Отчество</font> - Пишите полностью русскими буквами, начиная с заглавной.<br/>
             <strong>Например:</strong> Петровна<br>
          <br></p>
          <p><font color="red">Email</font> - Не пишите перед адресом буквы www.<br/>Например неправильный адрес:<br/>
             <font color="red"><strong>www.nata54@mail.ru</strong></font>, правильный <font color='blue'><strong>nata54@mail.ru</strong></font><br/>
             Дописывайте правильно домены, не забывайте указывать @<br>
          <br></p>
          <p><font color="red">Улица</font> - Пишите полностью русскими буквами, начиная с заглавной.<br/>
             Если адрес не улица, обязательно выберите из справочника нужный вариант (проспект, переулок и т.д.)<br/>
             Желательно писать только фамилии деятелей (без имен), в честь которых названы улицы.<br/>
             Например, правильно: Коласа, Чайкиной, Орды и т.д.<br>
          <br></p>
          <p><font color="red">№ дома</font> - Если номер дома отсутствует, ставьте прочерк (-).<br/>
             Будьте внимательны, проверьте, правильно ли вы указали свой номер.<br/>
          <br></p>
          <p><font color="red">Корпус</font> - Если корпус отсутствует, оставьте это поле пустым.<br>
          <br></p>
          <p><font color="red">Квартира</font> - Если квартира отсутствует (частный дом), ставьте прочерк ("-").<br/>
          <br></p>
          <p><font color="red">Индекс</font> - 6-и значный почтовый индекс<br/>
             Если вы не уверены, что точно знаете свой индекс, посмотрите на сайте <font color='#0000FF'><u>www.belpost.by</u></font> или спросите в вашем отделении связи.<br/>
             <font color='red'><strong>Внимание!</strong></font> Правильно указывайте почтовый адрес! В противном случае посылка вернется назад в Германию.<br>
          <br></p>
          <p><font color="red">Город</font> - Пишите полностью русскими буквами, начиная с заглавной.<br/>
             Если Вы проживаете не в городе, обязательно выберите из справочника тип Вашего населенного пункта.<br>
          <br></p>
          <p><font color="red">Район</font> - Название района указывается, если населенный пункт, в котором Вы проживаете, не является городом.<br/> 
            Если вы живете в районном городе название района указывать ненадо.<br>
            Слово «р-н» писать не надо.<br>
            <strong>Например:</strong> Смолевичский<br>
          <br></p>
          <p><font color="red">Область</font> - Название области указывается, если населенный пункт, в котором Вы проживаете, не является городом.<br/> 
            Если вы живете в областном городе название области указывать ненадо.<br>
            Слова «обл» писать не надо.<br/>
            <strong>Например:</strong> Минская<br/>
          <br></p>
          <p><font color="red">Контактный&nbsp;тел. (Домашн/Рабочий)</font> - Пишите с кодом города.<br>
             <strong>Например:</strong> 0163-123456<br/>
          <br></p>
          <p><font color="red">Контактный&nbsp;тел. (Мобилъный тел.)</font> - Пишите без пробелов, выбрав из справочника правильный код мобильного оператора.<br>
             <strong>Например:</strong> 1234567<br/>
          <br></p>
        </div>
        <div class="clear_both"></div>
      </div>
    </div>
    
    <div class="container">
      <h3 class="head head-hidden">Рекомеендации по заполнению "Состава Заявки"</h3>
      <div class="box">
        <div class="pad">
          <p><font color="red">Каталог</font> - Наименование каталога, из которого выбран актикул.<br/>
             <font color='red'><strong>Внимание!</strong></font> На один и тот же артикул цена в каталоге и Интернете может отличаться.<br>
             В Интернете цена может быть больше, чем в каталоге. Поэтому если артикул вы выбрали в каталоге, обязательно укажите его название, страницу и позицию, это поможет получить товар по меньшей цене и исправить ваши ошибки, если они будут допущены.<br/>
          <br></p>
          <p><font color="red">Стр</font> - № страницы печатного каталога.<br/>
             Заполняется, если артикул выбран из печатного каталога, если артикул выбран из Интернета, поставьте прочерк ("-").<br>
          <br></p>
          <p><font color="red">№ поз. (лота)</font> - Номер позиции (лота)– это номер картинки на странице каталога.<br>
             Заполняется, если артикул выбран из печатного каталога, если артикул выбран из Интернета, поставьте прочерк ("-").<br>
          <br></p>
          <p><font color="red">Артикул</font> - буквенно-цифровой закодированный номер товара, состоящий из 7-8 знаков .<br/>
             Последний знак может быть не цифра, а буква, которая обязательно набирается <font color="red">латинским</font> шрифтом.
             <font color='red'><strong>Внимание!</strong></font> Внимательно сверяйте код атрикула. Если неправильно указан хоть один знак артикула – Вы получите отказ, или в посылке поступит другая вещь или по другой цене.<br>
             <font color='red'><strong>Внимание!</strong></font> Последний знак артикула имеет отношение к цене. Поэтому будьте внимательны при копировании артикула с немецких сайтов. Последний знак может меняться, на картинке, например, стоит U, при проверке наличия на складе может поменяться на Y, соответственно и цена поступившего артикула может быть не той, на которую вы рассчитывали.<br>
          <br></p>
          <p><font color="red">Размер</font> - В этом поле указывается размер в полном соответствии с тем, как он указан в каталоге или на сайте.<br>
              В случае, если размер указан дробью (например: <strong>36/38</strong>, <strong>40/42</strong>), пишите обязательно первый размер независимо от того, что вам больше подходит второй.<br> 
              Если в размере присутсвуют сиволы (например: <strong>М</strong>(48/50)), обязательно укажите этот символ <strong>М</strong>.<br>
              Если заказываются товары, не имеющие размера (очки, сумки, постельное белье и т.д.) в графе размер ставится <strong>0</strong>.<br>
              <font color='red'><strong>Внимание!</strong></font> Разница между белорусскими и немецкими <font color="red">женскими размерами</font> одежды составляет 8 единиц. Если белорусский размер 48, следует заказывать 40 и т.д. При определении размера по таблице рекомендуем выбирать ближайший <strong>меньший</strong> размер.<br/>
              Немецкие размеры <font color='red'>мужской одежды и обуви</font> совпадают с белорусскими.<br/>
              <font color='red'>Детские</font> размеры определяются по росту ребенка.<br/>
              Размеры обуви совпадают.<br>
              <font color='red'><strong>Внимание!</strong></font> Данные рекомендации не могут являться основанием для выставления претензий в случае ошибки. Необходимо учитывать особенности фигуры.<br>
          <br></p>
          <p><font color="red">Цена</font> - Указывается цена позиции в евро (без округлений)<br>
             <strong>Например:</strong> 16.99 или 16,99.<br>
          <br></p>
          <p><font color="red">Русское название товара</font> - Эта информация заполняется для оформления таможенной декларации.<br>
             Писать нужно просто – кофта, майка, туфли, пальто, ковер. <br>
          <br></p>
          <p><font color="red">Признак товара</font> - Укажите сокращенно и без точек и запятых какой либо из признаков товара, по которому можно будет идентифицировать и различать заказанные вещи: <br>
             -&nbsp;Цвет - красн, зел, черн, в полоску, в клетку, цветная, в рисунок;<br>
             -&nbsp;Фирму изготовителя - Аризона, Том Тейлор, Адидас и т.д., можно на русском, можно скопировать из сайта;<br>
             -&nbsp;Особенность фасона – с кор рукав, без рукавов, с манжетами, с пряжкой, и т.д.;<br>
             -&nbsp;Для кого предназначена - жен, муж, дет;<br>
             <br>
             Можно указать один или несколько признаков, если поместятся в поле таблички, напр:<br>
             <br>
             <table class="pad" border='1'>
               <tr>
                 <th>Русское<br> название<br>товара</th><th>Признак товара</th>
               </tr>
               <tr>
                 <td>Кофта</td><td>Красн гольф</td>
               </tr>
               <tr>
                 <td>Кофта</td><td>Бел полос</td>
               </tr>
               <tr>
                 <td>Туфли</td><td>Черн н/кабл</td>
               </tr>
               <tr>
                 <td>Куртка</td><td>Бел дет</td>
               </tr>
               <tr>
                 <td>джинсы</td><td>Аризона чер</td>
               </tr>
               <tr>
                 <td>Костюм</td><td>Адидас син</td>
               </tr>
               <tr>
                 <td>Трусы</td><td>разноцветн</td>
               </tr>
             </table><br>
          <br></p>
        </div>  
        <div class="clear_both"></div>
      </div>
    </div>

  </div>
</div>
