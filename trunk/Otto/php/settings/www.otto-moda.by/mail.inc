<?php
require "class.phpmailer.php";

function init_mail () {
  $mail = new PHPMailer();
  $mail->CharSet = 'UTF-8';
  $mail->IsSMTP();                          // отсылать используя SMTP
  $mail->Host     = 'localhost';             // SMTP сервер
  $mail->SMTPAuth = false;                  // включить SMTP аутентификацию
//  $mail->Username = 'mail@php-mail.ru';   // пропишите Ваш почтовый адрес
//  $mail->Password = '******';             // введите пароль на указанный ящик
  return $mail;  
}

function init_mail_4zakaz() {
  $mail = new PHPMailer();
  $mail->CharSet = 'UTF-8';
  $mail->IsSMTP();                          // отсылать используя SMTP
  $mail->Host     = 'localhost';             // SMTP сервер
  $mail->SMTPAuth = false;                  // включить SMTP аутентификацию
  $mail->AddAddress('orders@otto-moda.by', 'Имя'); // кому - адрес, Имя
//  $mail->AddAddress('zajavka@koruda.com', 'Имя'); // кому - адрес, Имя
  $mail->AddAddress('gvin99@mail.ru', 'Имя'); // кому - адрес, Имя
  return $mail;
}

function init_mail_4message () {
  $mail = new PHPMailer();
  $mail->CharSet = 'UTF-8';
  $mail->IsSMTP();                          // отсылать используя SMTP
  $mail->Host     = 'localhost';             // SMTP сервер
  $mail->SMTPAuth = false;                  // включить SMTP аутентификацию
  $mail->AddAddress('office@otto-moda.by', 'Имя'); // кому - адрес, Имя
  $mail->AddAddress('gvin99@mail.ru', 'Имя'); // кому - адрес, Имя
  $mail->AddAddress('olivin@zebra.lt', 'Имя'); // кому - адрес, Имя
  return $mail;
}
?>
