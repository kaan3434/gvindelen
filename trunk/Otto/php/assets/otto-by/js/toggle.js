var toggle = {
	toggleopen : null,

	/* Fenster ein-/ausklappen */
	toggleView : function(obj,only_once)
	{
		if (obj.attr("class").substr(0,4)=='head')
			if(obj.next().css("display") == 'none')
			{
				if (only_once&&toggle.toggleopen)
				{
					toggle.toggleopen.next().css("display","none");
					toggle.toggleopen.attr("class","head head-hidden");
				}

				obj.next().css("display","block");
				obj.attr("class","head head-visible");
				if (only_once) toggle.toggleopen=obj;
			}
			else
			{
				obj.next().css("display","none");
				obj.attr("class","head head-hidden");
				if (only_once) toggle.toggleopen=null;
			}
	},

	/* Toggle Container mit onClick Events versehen */
	toggleBind : function(id_name,only_once,openitem) {
		if ($(id_name).attr('nodeType')) {
			$(id_name).contents().each(function (i) {
				if ($(this).children().eq(0).attr('nodeName')=='H3')
					if (only_once) {
						$(this).children().eq(0).bind('click',function(){toggle.toggleView($(this),1)});
						if (openitem==1)
							toggle.toggleView($(this).children().eq(0),1);
						if (openitem>=1)
							openitem--;
					}	else
						$(this).children().eq(0).bind('click',function(){toggle.toggleView($(this),0)});
			});
		}
	}
};

$(document).ready(function() {
	toggle.toggleBind('#delivery, #payment',1,1);
	toggle.toggleBind('#intertech, #shouldknow',1,1);
	toggle.toggleBind('#sitemap #content',1,1);
	toggle.toggleBind('#faq #content',1,1);
	toggle.toggleBind('#mnogoru #content',1,1);
	toggle.toggleBind('#service',0,0);
	toggle.toggleBind('#bodyindex #content',0,0);
	toggle.toggleBind('#emailhelp',0,0);
	toggle.toggleBind('#terms',1,1);
  /*
		0 = can all open
		1 = can only one open
	*/
});
