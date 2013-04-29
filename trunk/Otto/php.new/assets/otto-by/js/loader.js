var loader = {
	div_id: null,

	load : function(file,div_id,script)
	{
		if ($('#'+div_id))
		{
			//window.setTimeout("$.ajax({type: 'GET',url: '"+ file+"',dataType: 'html', success: function(msg){loader.done(msg,'"+file+"','"+div_id+"','"+script+"')}});",1);
			$('#'+div_id).load(file, '', function(msg){loader.done(div_id ,script);});
		}
	},

	done : function(div_id, script)
	{
		loader.div_id=div_id;
		if (script) eval(script);
	},

	show : function()
	{
		if($('#'+loader.div_id))
		{
			$('#'+loader.div_id).css('display','block');
		}
	},


	center : function()
	{
		if($('#'+loader.div_id))
		{
			var layer=$('#'+loader.div_id);
			block=layer.css('display');
			layer.css('display','block');
			obj_height=Math.round(($(window).height()-layer.height())/2)+$(window).scrollTop();
			if (obj_height<0) obj_height=0;
			obj_width=Math.round((995-layer.width())/2)+$(window).scrollLeft();

			if (obj_width<0) obj_width=0;
			layer.css('top',obj_height+'px');
			layer.css('left',obj_width+'px');
			// IE6 select form element z-index issue
			layer.bgiframe();
			layer.css('display',block);
		}
	},

	close : function()
	{
		$('#layer').css('display','none');
	}
}

function urlparam( name ) {
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}

function showLayer(name) {
  var previewValue = urlparam("preview");
  var preview = previewValue ? '&preview=' + previewValue : '';

  loader.load(shop.baseUrl + 'layer/container@cn=' + name + preview, 'layer','loader.show();loader.center()');
}

function showLayerView(name) {
  loader.load(shop.baseUrl + 'layer/view@vn=' + name, 'layer','loader.show();loader.center()');
}

function showZoomView(productId, tab) {
  loader.load(shop.baseUrl + 'layer/zoom@productid=' + productId + '&tab='+ tab +"&itemId="+$("#itemId").val(), 'layer','loader.show();loader.center()');
}

function updateCart(id, index, redirect, simpleCheckout) {
	loader.load(shop.baseUrl + 'updatecart@id='+id+'&index='+index+'&redirect='+redirect+'&simpleCheckout='+simpleCheckout, 'layer','loader.show();loader.center()');
}
function showTab(name, pid, color) {
  $.ajax({
  url: shop.baseUrl + 'producttab' ,
  data: ({productId : pid, colorSchemaName : color}),
  success: function (data) {

  $('#customerRating').html(data);
  }
  });
  }