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
          
<?php
   $dblink = db_connect();
   $query = mysql_query('select * from sendinet i left join status s on (s.status_name = i.statusname) where coalesce(s.status_code, 0) >= 0 and i.articul not like \'*%\' and NUMZAK="'.$_POST['OrderNum'].'"', $dblink);
   $row = mysql_fetch_assoc($query);
   $row1 = $row;
?>
          <p>Заявка № <strong><? echo $_POST['OrderNum'];?></strong> от <strong><? echo $row['DATE0'];?></strong> г на имя <strong><? echo $row['FAMILY'];?></strong></p>
          <p>E-майл: <? echo $row['EMAIL'];?> | Kурс евро: <strong><? echo $row['VALUEEUR'];?></strong> | Вес посылки: <strong><? echo $row['WEIGHT'];?> кг.</strong></p>
          <p>Сумма к оплатe: <strong><? echo $row['SUMRUN']-$row['SUMPAY'];?> BYR</strong><br/><br/></p>
          <table border=1 cellpadding="4">
            <thead>
              <tr>
                <th>№</th>
                <th>Наименование</th>
                <th>Aртикул</th>
                <th>Размер</th>
                <th>Цена в евро</th>
                <th>Цена в бел руб</th>
                <th>Статус</th>
                <th>Состояние на cкладе отправителя</th>
                <th>Полный номер посылки</th>
                <!--th>Bозврат</th-->
              </tr>
            </thead>
            <tbody>
<?php 
  $row_num = 0;
  do { 
    $row_num += 1;                
  ?>
              <tr>
                <td><? echo $row_num;?></td>
                <td><? echo $row['NAMEZAK'];?></td>
                <td><? echo $row['ARTICUL'];?></td>
                <td><? echo $row['SIZE'];?></td>
                <td><? echo $row['SUMEUR'];?></td>
                <td><? echo $row['SUMRUB'];?></td>
                <td><? echo $row['STATUSNAME'];?></td>
                <td><? echo $row['DATEPI3'];?></td>
                <td><? echo $row['SENDING'];?></td>
                <!--td><input type="checkbox" name="grazinimas<?echo $row_num;?>" value="<? echo $_POST['OrderNum'].$row_num.$row['ARTICUL'];?>"></td-->
              </tr>
<?php } while ($row = mysql_fetch_assoc($query)); 
  $query = mysql_query('select * from sendinet i left join status s on (s.status_name = i.statusname) where i.articul like \'*%\' and NUMZAK="'.$_POST['OrderNum'].'"', $dblink);
  while ($rowserv = mysql_fetch_assoc($query)) { 
    $row_num += 1;
?>
              <tr>
                <td><? echo $row_num;?></td>
                <td colspan="3"><? echo $rowserv['NAMEZAK'];?></td>
                <td><? echo $rowserv['SUMEUR'];?></td>
                <td><? echo $rowserv['SUMRUB'];?></td>
                <td><? echo $rowserv['STATUSNAME'];?></td>
                <td><? echo $rowserv['DATEPI3'];?></td>
              </tr>
<?php } while ($row = mysql_fetch_assoc($query)); 
?>
            </tbody>
         
<?php
   $query = mysql_query('select * from sendinet i left join status s on (s.status_name = i.statusname) where coalesce(s.status_code, 0) < 0 and NUMZAK="'.$_POST['OrderNum'].'"', $dblink);
   
   if ($rowcancel = mysql_fetch_assoc($query)) {;
?>
          <tr>
            <td colspan="9" align="center"><h3>Анулированные позиции</h3></td>
          </tr>
            <!--thead>
              <tr>
                <th>№</th>
                <th>Наименование</th>
                <th>Aртикул</th>
                <th>Размер</th>
                <th>Цена в евро</th>
                <th>Цена в бел руб</th>
                <th>Статус</th>
              </tr>
            </thead-->
            <tbody>
<?php 
  do { 
    $row_num += 1;
  ?>
              <tr>
                <td><? echo $row_num;?></td>
                <td><? echo $rowcancel['NAMEZAK'];?></td>
                <td><? echo $rowcancel['ARTICUL'];?></td>
                <td><? echo $rowcancel['SIZE'];?></td>
                <td><? echo $rowcancel['SUMEUR'];?></td>
                <td><? echo $rowcancel['SUMRUB'];?></td>
                <td><? echo $rowcancel['STATUSNAME'];?></td>
              </tr>
<?php } while ($rowcancel = mysql_fetch_assoc($query)); 
}?>
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
          <p><a href="blanks/blank1.pdf">&gt;&gt; Бланк заявления для возвратa посылки</a></p>
          <p><a href="blanks/blank2.pdf">&gt;&gt; Образец заполнения почтовых бланков возврата</a></p>
        </div>
      </div>
    </div>

  </div>
</div>



