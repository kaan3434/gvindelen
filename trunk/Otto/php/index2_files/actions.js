var shopAction = {
     
    hasCookiesEnabled : function() {
      document.cookie = "cookiecheck";
      return document.cookie.indexOf("cookiecheck") != -1;
    }/*,

    show : function(id) {
      $("#"+id).removeClass("hidden");
    },

    hide : function(id) {
      $("#"+id).addClass("hidden");
    }*/

};

function cookiesEnabled(func) {
  if (shopAction.hasCookiesEnabled())
    return eval(func);
  else
    showLayerView("layer.cookiesDisabled");
}

function formCookiesEnabled(formId) {
  if (shopAction.hasCookiesEnabled())
    $('#'+formId).submit();
  else
    showLayerView("layer.cookiesDisabled");
}