/* Globale Funktionen */

/* removes broken images */
function brokenImg(imgSrc) {
  imgSrc.src = shop.imageBaseUrl + 'global/blind.gif';
  imgSrc.onerror = "";
  return true;
}

/* replaces pds image */
function brokenImgPds(imgSrc) {
  var imageSource = ''+imgSrc.src;
  var placeHolderAppendix= "artikel/placeholder.jpg";
  //Sichergehen, dass der Placeholder selbst nicht broken ist, sonst Endlosschleife
  if (imageSource.indexOf(placeHolderAppendix) == -1) {
    var placeHolderBaseUrl = shop.imageBaseUrl;
    imgSrc.src = placeHolderBaseUrl + placeHolderAppendix;
  }
  return true;
}


function setCookie(name, value, path, expiredays)
{
  var expires = new Date();
  expires.setDate( expires.getDate() + expiredays );
  document.cookie = 
    name + "=" + escape(value) +
    ";path=" + ((path == null) ? "/" : path) +
    ";expires=" + ((expiredays == null) ? "" : expires.toGMTString());
}