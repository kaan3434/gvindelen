var serviceNavigation = {
	bg_aktiv : shop.imageBaseUrl + 'header/dropdown_meinotto_aktiv_v2.gif',
	bg_inaktiv : shop.imageBaseUrl + 'header/dropdown_meinotto_inaktiv_v2.gif',
	timer : '',
	
	activate_dropdown : function (obj) {
		var menu = obj.children('a#menubar')[0];
		var layer = obj.children('ul#dropdownlayer')[0];

	    if(this.timer){
	    	clearTimeout(this.timer);
	    }
		$(menu).css("background", "url("+this.bg_aktiv+") no-repeat 0px 0px");
		$(layer).css('display', 'block');
	},
	
	deactivate_dropdown : function (obj) {
		var menu = obj.children('a#menubar')[0];
		var layer = obj.children('ul#dropdownlayer')[0];
		
		$(menu).css("background", "url("+this.bg_inaktiv+") no-repeat 0px 0px");
		// $(layer).css('display', 'none');
		this.timer = window.setTimeout(function(){$(layer).css('display', 'none');},50);
	}
}

var meinottodropdown = {
  img_over : function(obj, img_element, img_src) {
    obj.css("cursor","pointer");
    img_element.attr("src", img_src);
  },

  img_out : function(obj, img_element, img_src) {
    img_element.attr("src",img_src);
  },

  meinotto_text_over : function(obj) {
    obj.css("cursor","pointer");
    $('#meinotto_text_link').css("textDecoration","underline");
  },

  meinotto_text_out : function(obj) {
    $('#meinotto_text_link').css("textDecoration","none");
  }
};


$(document).ready(function(){
	var serviceLayer = $('.meinotto_top #serviceLayer > li');
	serviceLayer.bind('mouseover', function() {
		serviceNavigation.activate_dropdown($(this));
	});
	serviceLayer.bind('mouseout', function() {
		serviceNavigation.deactivate_dropdown($(this));
	});
	
	var headerElement = $('#header');
	
	var basket_img = $('#basket_picture', headerElement);
	$('.basket', headerElement).hover(
			function(){ meinottodropdown.img_over($(this), basket_img, shop.imageBaseUrl + "header/basket_active.gif")},
			function(){ meinottodropdown.img_out($(this), basket_img, shop.imageBaseUrl + "header/basket_inactive.gif")}
	);
	var basket_img_blue = $('#basket_picture_blue', headerElement);
	$('.basket', headerElement).hover(
			function(){ meinottodropdown.img_over($(this), basket_img_blue, shop.imageBaseUrl + "header/basket_blue_active.gif")},
			function(){ meinottodropdown.img_out($(this), basket_img_blue, shop.imageBaseUrl + "header/basket_blue_inactive.gif")}
	);
	var basket_img_filled = $('#basket_picture_filled', headerElement);
	$('.basket', headerElement).hover(
			function(){ meinottodropdown.img_over($(this), basket_img_filled, shop.imageBaseUrl + "header/basket_blue_active.gif")},
			function(){ meinottodropdown.img_out($(this), basket_img_filled, shop.imageBaseUrl + "header/basket_inactive.gif")}
	);
	
	var my_otto_img = $('#meinotto_picture', headerElement);
	$('#meinotto', headerElement).hover(
			function(){ meinottodropdown.img_over($(this), my_otto_img, shop.imageBaseUrl + "header/meinotto_aktiv.gif")},
			function(){ meinottodropdown.img_out($(this), my_otto_img, shop.imageBaseUrl + "header/meinotto_inaktiv.gif")}
	);

	var my_otto_img_red = $('#meinotto_picture_red', headerElement);
	$('#meinotto', headerElement).hover(
			function(){ meinottodropdown.img_over($(this), my_otto_img_red, shop.imageBaseUrl + "header/meinotto_aktiv_rot.gif")},
			function(){ meinottodropdown.img_out($(this), my_otto_img_red, shop.imageBaseUrl + "header/meinotto_inaktiv_rot.gif")}
	);

	$('#header #meinotto_text', headerElement).hover(
			function(){ meinottodropdown.meinotto_text_over($(this))},
			function(){ meinottodropdown.meinotto_text_out($(this))}
	);
});
