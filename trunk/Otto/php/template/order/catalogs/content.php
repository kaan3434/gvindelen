<style type="text/css"> 

.ratgeber a
{
color: #D88400 !important;
}
.imageWrapper {
height:192px;width:140px;
float:left;margin-right:15px;
}
.imageWrapper td{
background-color:#fff;
border: 1px solid #D88400;
vertical-align: middle; text-align: center;
}
.teaser {background-color:white;}

.dottedTop { background: url(/assets/otto-by/images/spacer/dotline_horizontal.gif) top left repeat-x transparent; }
.dottedBottom { background: url(/assets/otto-by/images/spacer/dotline_horizontal.gif) bottom left repeat-x transparent; }
.dotted { background: url(/assets/otto-by/images/spacer/dotline_horizontal.gif) top left repeat-x transparent !important; }
.popup .dotted { background: url(/assets/otto-by/images/spacer/dotline_horizontal.gif) top left repeat-x transparent !important; }

</style>

<div class="maincontent" id="servicecontent">
  <div id="headline_item">
    <div class="text">
      <h1 class="content_headline">В мире каталогов: Весна - Лето 2012 г.</h1>
    </div>
  </div>

  <div class="content" id="delivery">
    <div id="head">
      <img class="row-left" alt="" src="/assets/otto-by/images/service/delivery/delivery.jpg">
      <div class="row-right">
        <div class="categories">
          <p>Лучший способ выбрать товар – полистать каталог, лежа на диване или сидя в любимом кресле. 
             Для этого есть несколько способов:
             <p>-&nbsp;Приобрести каталог на <a href="oz.by">oz.by</a></p>
             <p>-&nbsp;Взять каталог на время, как в библиотеке, в наших офисах на..</p>
             <p>-&nbsp;Если у Вас есть свободное время, приходите к нам в офис полистать каталоги.</p>
          </p>
        </div>
      </div>
      <div class="clear_both"></div>
    </div>

    <div id="service" class="ratgeber">

<?php
  $fpath = $template_path . $_GET['path'] . '/';
  $files = scandir($fpath);
  $index = 1;
  foreach($files as $f) {
    if ((substr($f, 0, 4) == 'cat_') and (substr($f, -4) == '.inc')) {
      include $fpath . $f;
      $index++;
      if ($index % 2) {
        echo '<p class="dotted full">&nbsp;</p>';
      }
    }
  }
  ?>
    
      
      <!--div class="downloadBox">
        <table class="imageWrapper"><tbody>
          <tr>
            <td>
              <div class="content" style="background-color:#fff;margin:1px 0 0 1px;"> <a href="http://issuu.com/Aristhoteles/docs/apart_1_hw11_ru_sorte_2_opt_neu?mode=embed&amp;layout=http%3A//skin.issuu.com/v/light/layout.xml&amp;showFlipBtn=true" title="Apart" target="_blank"><img src="assets/otto-by/images/catalogs2011_07/apart_1_hw11_sorte2opt.jpg" alt="Apart" width="102" height="125" border="0"></a>
              </div>
            </td>
          </tr>
        </tbody></table>
        <div class="text">
          <div class="inner">
            <b>Apart 1</b>
            <p>Новый каталог APART осень-зима 2011 - Ваш незаменимый консультант в мире моды. Несомненно, 
               каждая женщина сможет найти в нём, то, что подходит именно ей.</p>
            <p>&nbsp;</p>
            <p>&nbsp;</p>
            <p><a href="http://issuu.com/Aristhoteles/docs/apart_1_hw11_ru_sorte_2_opt_neu?mode=embed&amp;layout=http%3A//skin.issuu.com/v/light/layout.xml&amp;showFlipBtn=true" target="_blank">Посмотреть</a>, <a href="">Заказать на oz.by</a>
          </div>
        </div>
      </div>
<div class="downloadBox">
<table class="imageWrapper">
<tbody><tr>
<td>
<div class="content" style="background-color:#fff;margin:1px 0 0 1px;"><a href="http://issuu.com/aristhoteles/docs/apart_2_hw11_s2?mode=embed&amp;layout=http%3A//skin.issuu.com/v/light/layout.xml&amp;showFlipBtn=true" target="_blank"><img src="assets/otto-by/images/catalogs2011_09/apart_2_2011.jpg" alt="Апарт 2" width="102" height="125"></a></div>
</td>
</tr>
</tbody></table>
<div class="text">
<div class="inner">
<p><b>Apart 2</b></p>
<p>Представлена первоклассная женская одежда. Девиз этого каталога: &quot;Я этого достойна!&quot; APART отражает последние тенденции европейской и мировой женской моды. Незаменим для всех, кто стремится обладать стильной и женственной одеждой. <br />
/108стр./</p>
<p>&nbsp;</p>
</br>
<a href="http://issuu.com/aristhoteles/docs/apart_2_hw11_s2?mode=embed&amp;layout=http%3A//skin.issuu.com/v/light/layout.xml&amp;showFlipBtn=true" title="Апарт 2" target="_blank">Посмотреть каталог</a><br />
<a href="http://www.otto-moda.lt/katalogu-uzsakymai" target="_blank">Заказать на сайте</a>, <a href="/?path=service/contact">в офисе</a>

</div>
</div>
</div>

<div class="downloadBox">
<table class="imageWrapper">
<tbody><tr>
<td>
<div class="content" style="background-color:#fff;margin:1px 0 0 1px;">
<a href="http://issuu.com/Aristhoteles/docs/3pagen_fs11_ru?mode=embed&amp;layout=http%3A%2F%2Fskin.issuu.com%2Fv%2Flight%2Flayout.xml&amp;showFlipBtn=true" target="_blank"><img src="assets/otto-by/images/catalogs2011_05/3Pagen_FS11_RU.jpg" alt="3 Pagen"></a>
</div>
</td>
</tr>
</tbody></table>
<div class="text">
<div class="inner">
<p><b>3 Pagen</b></p>
<p>&nbsp; </p>
<p>Незаменимый интерьерный каталог. Очень много небольших мелочей, которые всегда нужны дома.  Это и фонарики, брелки, сумки,  свечи, посуда и многое многое другое. <br />
/136стр./</p>
<br>

<a href="http://issuu.com/Aristhoteles/docs/3pagen_fs11_ru?mode=embed&amp;layout=http%3A%2F%2Fskin.issuu.com%2Fv%2Flight%2Flayout.xml&amp;showFlipBtn=true" target="_blank">Посмотреть каталог</a><br />
 <a href="http://www.otto-moda.lt/katalogu-uzsakymai" target="_blank">Заказать на сайте</a>, <a href="/?path=service/contact">в офисе</a>


</div>
</div>
</div>

<p class="dotted full">&nbsp;</p>



<p class="dotted full">&nbsp;</p>

<div class="downloadBox">
<table class="imageWrapper">
<tbody><tr>
<td>
<div class="content" style="background-color:#fff;margin:1px 0 0 1px;"><a href="http://issuu.com/Aristhoteles/docs/youman_fs2011_opt?mode=embed&amp;layout=http%3A%2F%2Fskin.issuu.com%2Fv%2Flight%2Flayout.xml&amp;showFlipBtn=true&quot; target=&quot;_blank" target="_blank"><img src="assets/otto-by/images/catalogs2011_05/YOUMAN.jpg" alt="Youman"></a>
</div>
</td>
</tr>
</tbody></table>
<div class="text">
<div class="inner">
<b>Youman</b>
<p>Каталог для настоящих мужчин! YOUMAN - это широкий выбор современной моды для каждого мужчины. вне зависимости от того, какой размер Вы носите - у нас есть все! Размеры с 48 по 70, богатый выбор, единая цена! <br />
/108 стр./ </p>

  <a href="http://issuu.com/Aristhoteles/docs/youman_fs2011_opt?mode=embed&amp;layout=http%3A%2F%2Fskin.issuu.com%2Fv%2Flight%2Flayout.xml&amp;showFlipBtn=true&quot; target=&quot;_blank" target="_blank">Посмотреть каталог</a><br />
 <a href="http://www.otto-moda.lt/katalogu-uzsakymai" target="_blank">Заказать на сайте</a>, <a href="/?path=service/contact">в офисе</a></div>
</div>
</div>






<p class="dotted full">&nbsp;</p>
<div class="downloadBox">
<table class="imageWrapper">
<tbody><tr>
<td>
<div class="content" style="background-color:#fff;margin:1px 0 0 1px;">
<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;ls=0&amp;BlaetterbarerKatalog=lascana_123#lmPromo=la,3,hk,sh13068491,fl,Z1_S1_TTMI_Special" target="_blank"><img src="assets/otto-by/images/catalogs2011_05/Lascana.jpg" alt="Lascana"></a>
</div>
</td>
</tr>
</tbody></table>
<div class="text">
<div class="inner">
<b>Lascana</b>
<p>Каталог нижнего женского белья и пляжных комплектов и аксессуаров из Германии текущего сезона. Изысканность и многообразие для любителей изящества и неповторимости. <br />
На немецком языке. <br />
/62 стр./</p>
<br>
<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;ls=0&amp;BlaetterbarerKatalog=lascana_123#lmPromo=la,3,hk,sh13068491,fl,Z1_S1_TTMI_Special" target="_blank">Посмотреть каталог</a>
<br>
</div>
</div>
</div>
<div class="downloadBox">
<table class="imageWrapper">
<tbody><tr>
<td>
<div class="content" style="background-color:#fff;margin:1px 0 0 1px;">
<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;CatalogPage=1&amp;ls=0&amp;BlaetterbarerKatalog=klitzeklein_123#lmPromo=la,3,hk,sh6549997,fl,Z1_S1_TTMI_Special" target="_blank"><img src="assets/otto-by/images/catalogs2011_05/klitzklein.jpg" alt="Klitzeklein"></a>
</div>
</td>
</tr>
</tbody></table>
<div class="text">
<div class="inner">
<b>Klitzeklein</b>
<p><br />
Вы ждете прибавления семейства? Или вы хотите, чтобы ваш малыш тоже был красиво и модно одет? Тогда этот каталог для Вас.<br />
На немецком языке<br />
/52 стр./
</p>
<br>
<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;CatalogPage=1&amp;ls=0&amp;BlaetterbarerKatalog=klitzeklein_123#lmPromo=la,3,hk,sh6549997,fl,Z1_S1_TTMI_Special" target="_blank">Посмотреть каталог</a>
<br>
</div>
</div>
</div>
<p class="dotted full">&nbsp;</p>
<div class="downloadBox">
<table class="imageWrapper">
<tbody><tr>
<td>
<div class="content" style="background-color:#fff;margin:1px 0 0 1px;">
<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;CatalogPage=1&amp;ls=0&amp;BlaetterbarerKatalog=maenner_123#lmPromo=la,3,hk,sh2991713,fl,Z1_S1_TTMI_Special" target="_blank"><img src="assets/otto-by/images/catalogs2011_05/manner.jpg" alt="Männer"></a>
</div>
</td>
</tr>
</tbody></table>
<div class="text">
<div class="inner">
<b>Männer</b>
<p>Дополнение к основному каталогу ОТТО, в него включены только мужские коллекции брендовых производителей мира таких как: s Oliver, Hilfiger, Tom Tailor, Esprit, Levis, Lee, Puma и многое другое, что нужно настоящему мужчине. <br />
На немецком языке. <br />
/100 стр./
</p>

<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;CatalogPage=1&amp;ls=0&amp;BlaetterbarerKatalog=maenner_123#lmPromo=la,3,hk,sh2991713,fl,Z1_S1_TTMI_Special" target="_blank">Посмотреть каталог </a>
<br>
</div>
</div>
</div>
<div class="downloadBox">
<table class="imageWrapper">
<tbody><tr>
<td>
<div class="content" style="background-color:#fff;margin:1px 0 0 1px;">
<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;CatalogPage=1&amp;ls=0&amp;BlaetterbarerKatalog=brandneu_123#lmPromo=la,3,hk,sh6547337,fl,Z1_S1_TTMI_Special" target="_blank"><img src="assets/otto-by/images/catalogs2011_05/Brandneu.jpg" alt="Brandneu"></a>
</div>
</td>
</tr>
</tbody></table>
<div class="text">
<div class="inner">
<b>Brandneu</b>
<p><br />
Новейшие тенденции и стильная, качественная молодежная мода известных марок и брендов от концерна ОТТО.<br />
На немецком языке.<br />
/94 стр./ </p>
<br>
<a href="http://www.otto.de/is-bin/INTERSHOP.enfinity/WFS/Otto-OttoDe-Site/de_DE/-/EUR/OV_ViewTemplate-View?Template=popups/blaetterbarer_katalog&amp;CatalogPage=1&amp;ls=0&amp;BlaetterbarerKatalog=brandneu_123#lmPromo=la,3,hk,sh6547337,fl,Z1_S1_TTMI_Special" target="_blank">Посмотреть каталог </a>
<br>
</div>
</div>
</div>

</div-->

      <div class="clear_both"></div>
    </div>
    
  </div>
</div>
