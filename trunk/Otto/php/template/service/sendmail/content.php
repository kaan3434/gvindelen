<div class="maincontent" id="ordercontent">
  <div id="headline_item">
    <div class="text">
      <h1 class="content_headline">Сообщение</h1>
    </div>
  </div>
  <div class="content" id="terms">
    <div class="container">
      <table><tbody>
        <tr>
          <td>Ваше имя:</td>
          <td><? echo $_POST["visitor"]; ?></td>
        </tr>
        <tr>
          <td>Ваш e-mail:</td>
          <td><? echo $_POST["visitormail"]; ?></td>
        </tr>
        <tr>
          <td>Ваше сообщение:</td>
          <td><? echo $_POST["notes"]; ?></td>
        </tr>
        <tr>
          <td>Статус</td>
          <td>
<?php 
  $mail = init_mail_4message();
  $mail->From     = $_POST["visitormail"]; // укажите от кого письмо   $mail = new PHPMailer();
  $mail->FromName = $_POST["visitor"];   // от кого
//  $mail->IsHTML(true);        // выставляем формат письма HTML
  $mail->Subject = 'http message';  // тема письма   
  $mail->Body = $_POST["notes"];
  // отправляем наше письмо
  if ($mail->Send()) {
    echo "отправлено"; 
  } else {
    echo "не отправлено"; 
  }
?>
          </td>
        </tr>
      </tbody></table>
    </div>
  </div>
</div>