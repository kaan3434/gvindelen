

var current_lng = 'ru';


////////////////////////////////////////////////////////////////////////////////////////////////////
// Task object is the way of functions execution in the right context
////////////////////////////////////////////////////////////////////////////////////////////////////

function Task (owner, method)
{
	Task.prototype.execute = function ()
	{
		try
		{
			return method.apply(owner, arguments);
		}
		catch (err)
		{
			return function(){};
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Class AJAX
// -------------------------------------------------------------------------------------------------
// Purpose: perform communications with the server via XMLHttpRequest object
// -------------------------------------------------------------------------------------------------
// Interface:
// 		AJAX(fileName, onLoadFunction, onSubmitFunction);
//		submit(queryString)
////////////////////////////////////////////////////////////////////////////////////////////////////

function AJAX( scriptPath, onSubmitFunction )
{
		///////////////////////////////////////////////////////////////////////////////////////////
		// creates and returns the XMLHttpRequest object, according to the browser type
		///////////////////////////////////////////////////////////////////////////////////////////
		this._createXMLHttpRequest = function()
		{
			if (window.XMLHttpRequest){
				return new XMLHttpRequest();
			}
			// branch for IE/Windows ActiveX version
			else if (window.ActiveXObject)
			{
				return new ActiveXObject("Microsoft.XMLHTTP");
			}
			return null;
		};

		///////////////////////////////////////////////////////////////////////////////////////////
		// this is an event handler for finished data loading to the XMLHttpRequest object
		///////////////////////////////////////////////////////////////////////////////////////////
		this._notifyStateChanged = function ()
		{
			if (this._req.readyState != 4)
				return true;

			if (this._req.status == 200)
			{
				this._onSubmitFunction.apply( window, new Array( this._getResponseText( this._req.responseXML ) ) );
			}
			else
			{
				alert("Connection to server has been lost!");
				return false;
			}
			return true;
		};

		this._getResponseText = function ( xml )
		{
			xml = xml.documentElement;
			if (xml == null)
				return false;

			var responseText = xml.childNodes[0].nodeValue;

			return responseText;
		}


	// =============================================================================================
	// public fields for internal class use
	// =============================================================================================
		this._req = null;
		this._saveScript = scriptPath;
		this._onSubmitFunction = onSubmitFunction;
}

// =============================================================================================
// public methods (class interface methods)
// =============================================================================================

	///////////////////////////////////////////////////////////////////////////////////////////
	// starts submit of the MIB data to server via XMLHttpRequest
	///////////////////////////////////////////////////////////////////////////////////////////
	AJAX.prototype.submit = function(postParams)
	{
		//document.getElementById("progress_image").style.visibility = "visible";
		var tsk = new Task(this, this._notifyStateChanged)
		this._req = this._createXMLHttpRequest();
		if ( this._req )
		{
			this._req.open("POST",  this._saveScript, true);
			this._req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

			this._req.onreadystatechange = tsk.execute;
			this._req.send(postParams);
		}
	};

function full_escape(string)
{
    return encodeURIComponent( string );

	string = string.replace(/\r\n/g,"\n");
	var utftext = "";
	var len = string.length;
	for (var n = 0; n < len; n++)
	{
		var c = string.charCodeAt(n);

		if (c < 128)
		{
			utftext += String.fromCharCode(c);
		}
		else if ( (c > 127) && (c < 2048) )
		{
			utftext += String.fromCharCode((c >> 6) | 192);
			utftext += String.fromCharCode((c & 63) | 128);
		}
		else
		{
			utftext += String.fromCharCode((c >> 12) | 224);
			utftext += String.fromCharCode(((c >> 6) & 63) | 128);
			utftext += String.fromCharCode((c & 63) | 128);
		}
	}

	utftext = escape( utftext );
    utftext = utftext.replace(/\//g,"%2F");
    utftext = utftext.replace(/\?/g,"%3F");
    utftext = utftext.replace(/\+/g,"%2B");
    utftext = utftext.replace(/=/g,"%3D");
    utftext = utftext.replace(/&/g,"%26");
    utftext = utftext.replace(/@/g,"%40");
    return utftext;
}

String.prototype.trim = function ()
{
	return this.replace(/^\s*|\s*$/g,"");
}

String.prototype.toFloat = function ()
{
	var str = this.replace(/\<(.*?)\>/g, "");
	str = str.replace(/[^0-9\.\,]*/g,"");
	str = str.replace(/\,/g, ".");
	return parseFloat( str );
}

function getContainerParams( container )
{
	var additional_params = new Array();

	var fields;
	if ( container )
	{
		var fieldTypes = new Array("select", "input");
		var j;
		var param = "";
		for (var i = 0; i < fieldTypes.length; i++ )
		{
			fields =  container.getElementsByTagName( fieldTypes[i] );

			j = fields.length;
			while (j-- > 0)
			{
				if ( fields[j].type != "hidden" && fields[j].type != "image")
				{
					switch ( fields[j].type )
					{
						case "select-multiple" :
						case "select-one" : param = fields[j].selectedIndex;
						break;
						case "radio" :
						case "checkbox" :
							if ( fields[j].checked )
								param = "on";
							else
								continue;
						break;
						default : param = escape( fields[j].value );
					}

					param = fields[j].name + "##" + fields[j].id + "##" + fields[j].type + "##" + param;

					additional_params.push ( param );
				}
			}
		}
	}
	return additional_params;
}


function createProductCatalogList()
{
	document.getElementById('loading_catalogs').style.visibility = "hidden";

	eval(arguments[0]);

	createSelectBox( "catalog_path", result );
}

function getProductLinks( productId )
{
	document.getElementById('openCatalogButton').style.visibility = "hidden";
	document.getElementById('catalog_path').options.length = 0;

	// gerd20070911
	if ( productId == '0' )
	{
		document.getElementById("catalog_path").options.add(new Option(catalog_path_def_title, "0") );
	}
	// /gerd20070911

	if ( productId == '0' )
		return;

	document.getElementById('loading_catalogs').style.visibility = "visible";


	var post_request = new AJAX("/getProductCatalogList.php", createProductCatalogList);
	post_request.submit( "productId=" + productId );
}

function createSectionList()
{
	document.getElementById('loading_products').style.visibility = "hidden";

	eval(arguments[0]);
	document.getElementById("catalog_products").options.add(new Option("", "0") );
	createSelectBox( "catalog_products", result );

	//if ( document.getElementById("catalog_products").options.length )
		//getProductLinks( document.getElementById("catalog_products").value );
}

function createSelectBox( id, option_list2 )
{
	var obj = document.getElementById(id);

	for (d in option_list2)
	{
		if (d == 'toJSONString')
			continue;

		obj.options.add(new Option(d, option_list2[d]) );
	}
	if ( document.getElementById('catalog_path').options.length )
		document.getElementById('openCatalogButton').style.visibility = "visible";

	// gerd20070911
	if (document.getElementById('catalog_products').options.length == 0)
		document.getElementById("catalog_products").options.add(new Option(catalog_products_def_title, "0") );

	if (document.getElementById('catalog_products').options[0].text == '')
		document.getElementById("catalog_products").options[0].text = catalog_products_def_title;

	if (document.getElementById('catalog_path').options.length == 0)
		document.getElementById("catalog_path").options.add(new Option(catalog_path_def_title, "0") );

	if (document.getElementById('catalog_path').options[0].text == '')
		document.getElementById("catalog_path").options[0].text = catalog_path_def_title;
	// /gerd20070911

}

function getSectionList( sectionId )
{
	document.getElementById('openCatalogButton').style.visibility = "hidden";
	document.getElementById('catalog_products').options.length = 0;
	document.getElementById('catalog_path').options.length = 0;

	// gerd20070911
	if ( sectionId == '0' )
	{
		document.getElementById("catalog_products").options.add(new Option(catalog_products_def_title, "0") );
		document.getElementById("catalog_path").options.add(new Option(catalog_path_def_title, "0") );
	}
	// /gerd20070911

	if ( sectionId == '0' )
		return;

	document.getElementById('loading_products').style.visibility = "visible";

	var post_request = new AJAX("/getSectionList.php", createSectionList);
	post_request.submit( "sectionId=" + sectionId );
}

function openCatalogProduct()
{
	if ( document.getElementById('catalog_section').value == "0" )
	{
		alert('Select section first');
		return;
	}

	var obj = document.getElementById('catalog_path');

	set_cookie ( "mclub_section", document.getElementById('catalog_section').value );
	set_cookie ( "mclub_product", document.getElementById('catalog_products').value );
	set_cookie ( "mclub_catalog", obj.options[obj.selectedIndex].text );

	var redirection = obj.value;
	switch ( obj.options[obj.selectedIndex].text )
	{
		case "Bader" :
		case "Neckermann" :
		case "Heine" :
				redirection += "&catalog_redirection=1";
		break;
	}
	top.document.location = redirection;

}

function logout_user()
{
	var post_request = new AJAX("/get_auth.php", authResult);
	post_request.submit( "action=logout" );
}

function auth_user()
{
	var post_request = new AJAX("/get_auth.php", authResult);
	post_request.submit( "auth_login=" + document.getElementById("auth_login").value + "&auth_pass=" + document.getElementById("auth_pass").value );
}

function authResult()
{
	document.getElementById("log").innerHTML = arguments[0];
	if (document.getElementById("login_error").innerHTML != "")
		alert(document.getElementById("login_error").innerHTML);
}

//Setting cookies
function set_cookie ( name, value )
{
	var cookie_string = name + "=" + escape ( value );
	cookie_string += "; domain=otto.my";
	cookie_string += "; path=/";
	document.cookie = cookie_string;
}

function get_cookie ( cookie_name )
{
	var results = document.cookie.match ( cookie_name + '=(.*?)(;|$)' );
  	if ( results )
  		return ( unescape ( results[1] ) );
  	else
    	return null;
}

function validate_email( email )
{
	var filter  = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	if ( !filter.test( email ) )
	{
//		alert(alert_incorrect_email);
		return false;
	}
	return true;
}

function alertCartAddedSuccess()
{
	lang_short = get_cookie('lang_short');
	switch (lang_short)
	{
		case 'en':
			alert('Product has been added to basket');
			break;
		case 'ru':
			alert('Товар добавлен в корзину');
			break;
		case 'ua':
			alert('Товар доданий в корзину');
			break;
		default:
			alert('Product has been added to basket');
	}
}

function alertNeedRegistrationAlert()
{
	lang_short = get_cookie('lang_short');
	switch (lang_short)
	{
		case 'en':
			alert("Possibility to carry out orders is accessibleм for authorized users only. \n\nRegister on a site please!");
			break;
		case 'ru':
			alert("Возможность осуществлять заказы доступна только зарегистрированным пользователям. \n\nЗарегистрируйтесь на сайте пожалуйста!");
			break;
		case 'ua':
			alert("Можливість здійснювати замовлення доступна лише зареєстрованим користувачам. \n\nРеєструйтеся на сайті будь ласка!");
			break;
		default:
			alert("Possibility to carry out orders is accessibleм for authorized users only. \n\nRegister on a site please!");
	}
}

function checkTitle( title )
{
    if ( title != '' )
        return title;
    var lang_short = get_cookie('lang_short');
    var message;
	switch (lang_short)
	{
		case 'en':
			message = "The system couldn't extract product title.\nPlease, enter it here!";
			break;
		case 'ru':
			message = "Система не может извлечь название товара. \nПожалуйста, введите его здесь!";
			break;
		case 'ua':
			message = "Система не может извлечь название товара. \nПожалуйста, введите его здесь!";
			break;
		default:
			message = "The system couldn't extract product title.\nPlease, enter it here!";
	}

    var user_title = prompt(message, "" );
    if ( user_title != null && user_title != "")
        return user_title;
    return false;
}

function checkOpera()
{
    if (navigator.appName != 'Opera')
        return true;

    var lang_short = get_cookie('lang_short');
    var message;
	switch (lang_short)
	{
		case 'en':
			message = "К сожалению, данный каталог не позволяет заказать товар с помощью этого броузера";
			break;
		case 'ru':
			message = "К сожалению, данный каталог не позволяет заказать товар с помощью этого броузера";
			break;
		case 'ua':
			message = "К сожалению, данный каталог не позволяет заказать товар с помощью этого броузера";
			break;
		default:
			message = "К сожалению, данный каталог не позволяет заказать товар с помощью этого броузера";
	}
	alert( message );
    return false;
}



function processOnlineCatalogMenu( id ) {
    $("#online_cat_" + id).toggleClass('current');
    $("#online_cat_el_" + id).toggle("normal");
}

var currentMenuTab = null;
var openedMenuTab = null;
var menuTimeout = null;

$(function(){
	/* pop up "service" */
	$('#h_service').hover(
		function(){ $('#h_service > div').css('display','block');},
		function(){ $('#h_service > div').css('display','none');}
	);

	/* pop up "about" */
	$('#h_about').hover(
		function(){ $('#h_about > div').css('display','block');},
		function(){ $('#h_about > div').css('display','none');}
	);


	$('.select_sort').hover(
		function(){ $('.select_sort > div').css('display','block');},
		function(){ $('.select_sort > div').css('display','none');}
	);


	/* glob menu */
	$('div.glob_menu > ul > li > a').hover(
		function(){
			var temp = $(this).attr('id');
			temp = temp.replace('a_', '');
            currentMenuTab = temp;
            clearTimeout(menuTimeout);
            menuTimeout = setTimeout('menu_open(' + temp + ')', 400);
//			menu_open(temp);
		},
		function(){
		    clearTimeout(menuTimeout);
			var temp = $(this).attr('id');
			temp = temp.replace('a_', '');
			menu_close(temp);
		}
	);

	$('div.glob_menu > div').hover(
		function(){
			var temp = $(this).attr('lang');
			currentMenuTab = temp;
			menu_open(temp);
		},
		function(){
			var temp =  $(this).attr('lang');
			menu_close(temp);
		}
	);



	/* sort by */
//	$('.sort_by').hover(
//		function(){$(this).children('div').css('display','block');},
//		function(){$(this).children('div').css('display','none');}
//	);

/*
	// TABS BOX
	if($('.tbox_body').length !== 0){
		var w_tabs = $('.tbox_body').width();
		var n_tabs = $('.tbox_bar ul li').length;
		$('.tbox_body_tabs').width(w_tabs+'px').css('float','left');
		$('.tbox_scrolbody').width((w_tabs*n_tabs+20)+'px');
		$('.tbox_bar ul li').eq(1).addClass('current');
		$('.tbox_bar ul li').click(function(){
			  var index = $('.tbox_bar ul li').index(this);
			  var h_tabsbody = $('.tbox_body_tabs').eq(index).height();

			  $('.tbox_bar ul li').removeClass('current');
			  $('.tbox_bar ul li').eq(index).addClass('current');
			  $('.tbox_scrolbody').animate( { left:'-'+(index*w_tabs)+'px'}, 400);
			  $('.tbox_body').animate( { height:h_tabsbody+'px'}, 400);
		});
	}
*/

	// BAYAN
	if($('.bayan_title').length !== 0){
		$('.bayan_body').hide(300);
		if (!$('.bayan_body').eq(0).hasClass('non_show')) {
    		$('.bayan_body').eq(0).show(300);
    		$('.bayan_title').eq(0).addClass('bayan_title_curret');
		}
		$('.bayan_title').click(function(){
			$(this).toggleClass('bayan_title_curret');
			var x = $('.bayan_title').index(this);
			$('.bayan_body').eq(x).toggle(300);
		});
	}
});

function menu_open(t){
//    if ( t != currentMenuTab ) {
//        menu_close(currentMenuTab);
//    }
	var temp = t;
	$('.a_'+temp).parent('li').addClass('bg_color_'+temp);
	$('#a_'+temp).addClass('current');
	$('li.a_'+(temp-1)).addClass('bg_color_'+temp);
	$('li.a_'+temp).addClass('bg_color_'+temp);
	$('.m_up_'+temp).css('display','block');
}
function menu_close(t){
	var temp = t;
	$('.a_'+temp).parent('li').removeClass('bg_color_'+temp);
	$('#a_'+temp).removeClass('current');
	$('li.a_'+(temp-1)).removeClass('bg_color_'+temp);
	$('li.a_'+temp).removeClass('bg_color_'+temp);
	$('.m_up_'+temp).css('display','none');
}

// auth functionality
function main_login()
{
	var post_request = new AJAX("/get_auth.php", authMainResult);
	post_request.submit( "auth_login=" + document.getElementById("auth_login").value + "&auth_pass=" + document.getElementById("auth_pass").value );
	main_log_text("<? echo $PHR[$lng]['auth_login']; ?>");
}
function main_logout()
{
	var post_request = new AJAX("/get_auth.php", authMainResultLogOut);
	post_request.submit( "action=logout" );
	//main_log_text("<? echo $PHR[$lng]['auth_logout']; ?>");
}

function main_log_text( action )
{
	var loading = '<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td>' + action +'... <img src="/images/loading.gif" border="0" align="absmiddle"></td></tr></table>';
	document.getElementById("login_form").innerHTML = loading;
}

function authMainResult()
{
	document.getElementById("login_form").innerHTML = arguments[0];
	if (document.getElementById("login_error") && document.getElementById("login_error").innerHTML != "") {
		alert(document.getElementById("login_error").innerHTML);
	}
	else {
	   location.reload(true);
	}
}

function authMainResultLogOut()
{
	location.reload(true);
}
// end auth

 $(function () {
$('.popup_tips').each(function () {
        var distance = 10;
        var time = 250;
        var hideDelay = 500;

        var hideDelayTimer = null;

        var beingShown = false;
        var shown = false;
        var trigger = $('.btn_question', this);
        var info = $('.popup', this).css('opacity', 0);

        $([trigger.get(0), info.get(0)]).mouseover(function () {
//            alert('mouseover');
            if (hideDelayTimer) clearTimeout(hideDelayTimer);
            if (beingShown || shown) {
                // don't trigger the animation again
                return;
            } else {
                // reset position of info box
                beingShown = true;

                info.css({
                    top: -40,
                    left: 0,
                    display: 'block'
                }).animate({
                    left: '+=' + distance + 'px',
                    opacity: 1
                }, time, 'swing', function() {
                    beingShown = false;
                    shown = true;
                });
            }

            return false;
        }).mouseout(function () {
            if (hideDelayTimer) clearTimeout(hideDelayTimer);
            hideDelayTimer = setTimeout(function () {
                hideDelayTimer = null;
                info.animate({
                    left: '-=' + distance + 'px',
                    opacity: 0
                }, time, 'swing', function () {
                    shown = false;
                    info.css('display', 'none');
                });

            }, hideDelay);

            return false;
        });
    });
});
