<?php
    $url = 'ppz2orders/'.$_POST['OrderNum'].'.xml';       
    $xml= simplexml_load_file($url);       
?>
<div class="maincontent" id="ordercontent">
  <div id="headline_item">
    <div class="text">
      <h1 class="content_headline">Проверить заявку</h1>
    </div>
  </div>

  <div class="content" id="aboutotto">
    <div id="head">
      <img class="row-left" alt="" src="/assets/otto-by/images/order/check2.jpg">
      <div class="row-right">
        <h2>Информация о состоянии заявки</h2>
        <p>На данной странице вы можете:<br>
           - Распечатать извещение на оплату<br>- Распечатать комплект заполненных бланков для возврата товара почтой отправителю</p>
      </div>
      <div class="clear_both"></div>
    </div>
  
    <div class="container">
      <h3 class="head head-hidden">Отслеживание статуса заявки по номеру</h3>
      <div class="box">
        <div class="pad">
          
          <p>Заявка № <strong><? echo $xml->ORDER['ORDER_CODE'];?></strong> от <strong><? echo $xml->ORDER['CREATE_DTM'];?></strong> г на имя <strong><? echo $xml->ORDER['CLIENT_FIO'];?></strong></p>
          <p>E-майл: <? echo $xml->ORDER->CLIENT['EMAIL'];?> | Kурс евро: <strong><? echo $xml->ORDER['BYR2EUR'];?></strong> | Вес посылки: <strong><? echo $xml->ORDER['WEIGHT'];?> г.</strong></p>
          <p>Сумма к оплатe: <strong><? echo $row['SUMRUN']-$row['SUMPAY'];?> BYR</strong></p>
          <p>Номер посылки: <a href="http://belpost.by"><? echo $xml->ORDER['BARCODE']; ?></a></p>
          <p>Форма оплаты: <strong><? echo $xml->ORDER['PRODUCT_NAME']; ?></strong></p>
          <p>Статус заявки: <strong><? echo $xml->ORDER['STATUS_NAME']; ?></strong><br/><br/></p>
          <table border=1 cellpadding="4">
            <thead>
              <tr>
                <th>№</th>
                <th>Наименование</th>
                <th>Aртикул</th>
                <th>Размер</th>
                <th>Цена в евро</th>
                <th>Статус</th>
                <th>Дата изм. статуса</th>
              </tr>
            </thead>
            <tbody>
<?php 
  $row_num = 1;
  foreach ($xml->ORDER->ORDERITEMS->ORDERITEM as $orderitem) {
  ?>
              <tr>
                <td><? echo $row_num++;?></td>
                <td><? echo $orderitem['NAME_RUS'].' '.$orderitem['KIND_RUS'];?></td>
                <td><? echo $orderitem['ARTICLE_CODE'];?></td>
                <td><? echo $orderitem['DIMENSION'];?></td>
                <td><? echo $orderitem['COST_EUR'];?></td>
                <td><? echo $orderitem['STATUS_NAME'].' '.$orderitem['STATE_NAME'];?></td>
                <td><? echo $orderitem['STATUS_DTM'];?></td>
              </tr>
<?php }; 
  foreach ($xml->ORDER->ORDERTAXS->ORDERTAX as $ordertax) {
?>
              <tr>
                <td><? echo $row_num++;?></td>
                <td colspan="3"><? echo $ordertax['TAXSERV_NAME'];?></td>
                <td><? echo $ordertax['COST_EUR'];?></td>
                <td><? echo $ordertax['STATUS_NAME'];?></td>
                <td><? echo $ordertax['STATUS_DTM'];?></td>
              </tr>
<?php }; 
  foreach ($xml->ORDER->ORDERMONEYS->ORDERMONEY as $ordermoney) {
?>
              <tr>
                <td><? echo $row_num++;?></td>
                <td colspan="3"><? if ($ordermoney['AMOUNT_EUR'] > 0) {echo "Поступившая оплата";} else {echo "Задолженность";} ?></td>
                <td><? echo $ordermoney['AMOUNT_EUR'];?></td>
                <td><? echo $ordermoney['STATUS_NAME'];?></td>
                <td><? echo $ordermoney['STATUS_DTM'];?></td>
              </tr>
<?php }; 
?>
            </tbody>
          </table>
          </form>
        </div>
      </div>
    </div>
      
    <div class="container">
      <h3 class="head head-hidden">Бланки для возврата товара</h3>
      <div class="box">
        <div class="pad">
          <p><a href="blanks/return_blank.pdf">&gt;&gt; Бланк заявления для возвратa посылки</a></p>
        </div>
      </div>
    </div>
    
<?php if ($xml->ORDER['PRODUCT_ID'] == '1') {?>
    <div class="container">
      <h3 class="head head-hidden">Извещение на оплату заявки</h3>
      <div class="box">
        <div class="pad">
<?php if (file_exists('invoices/inv_'.$_POST['OrderNum'].'.pdf')) { ?>
          <p><a href="invoices/inv_<? echo $_POST['OrderNum']; ?>.pdf">Извещение на оплату заявки</a></p>
<? } else { ?>
          <p>Извините, но извещение на оплату заявки еще сформировано, или не опубликовано.</p>
<? } ?>
        </div>
      </div>
    </div>
<?php    };
?>    
    
  </div>
</div>



