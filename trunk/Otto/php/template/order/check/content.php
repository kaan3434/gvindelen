<div class="maincontent" id="ordercontent">
  <div id="headline_item">
    <div class="text">
      <h1 class="content_headline">Проверить заявку</h1>
    </div>
  </div>

  <div class="content" id="aboutotto">
    <div id="head">
      <img class="row-left" alt="" src="/assets/otto-by/images/check/check.jpg">
      <div class="row-right">
        <h2>Информация о состоянии заявки</h2>
        <p>На данной странице вы можете:<br>
           - Распечатать извещение на оплату<br>
           - Распечатать комплект заполненных бланков для возврата товара почтой отправителю</p>
      </div>
      <div class="clear_both"></div>
    </div>
  
    <div class="container">
      <h3 class="head head-hidden">Отслеживание статуса заявки по номеру</h3>
      <div class="box">
        <div class="pad">
          <p><strong>Введите шестизначный номер заявки:</strong></p>
             <form method="post" action="?path=order/check2">
               <table border=0>
                 <tr>
                   <td>Номер заявки:</td>
                   <td><input name="OrderNum" type="text" id="OrderNum" size="6" maxlength="6" <? echo 'value="'.$_POST['OrderNum'].'"'; ?>></td>
                   <td><font color="red"><? echo $_POST['OrderNum_Error']; ?></font></td>
                 </tr>
                 <tr>
                   <td>Фамилия (например: <strong>Иванов</strong>):</td>
                   <td><input name="LastName" type="text" id="LastName" size="35" maxlength="20" <? echo 'value="'.$_POST['LastName'].'"'; ?>></td>
                   <td><font color="red"><? echo $_POST['LastName_Error']; ?></font></td>
                 </tr>
                 <tr>
                   <td colspan="2"><input type="submit" name="button" id="button" value="ИСКАТЬ"></td>
                 </tr>
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

    <div class="container">
      <h3 class="head head-hidden">Поиск заявки</h3>
      <div class="box">
        <div class="pad">
          <p>Забыли номер заявки? (или не был сообщен).<br/> Отправьте запрос.</strong></p>
            <form method="post" action="sendeail2.php">
              <table border=0>
                <tr>
                  <td>Полные ФИО </strong>(например: Иванов Петр Фомич)</td>
                  <td><input type="text" name="fio" size="35" id="fio"></td>
                </tr>
                <tr>
                  <td>E-Mail (например: nata_svir@mail.ru)</td>
                  <td><input type="text" name="email" size="35" id="email"></td>
                </tr>
                 <tr>
                   <td colspan="2"><input type="submit" value="ОТПРАВИТЬ ЗАПРОС"></td>
                 </tr>
              </table>
            </form>
        </div>
      </div>
    </div>
  </div>
</div>
