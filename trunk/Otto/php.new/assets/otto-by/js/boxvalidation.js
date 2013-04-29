function showError(objID) {
	var obj = $('input[id="'+ objID +'"]');
	if(obj.length == 1) obj.addClass('float-left');
	obj.addClass('error')
	   .parents('div.formfield').addClass('error')
	   .find('div.note').show();
}

function hideError(objID) {
	var obj = $('input[id="'+ objID +'"]');
	obj.removeClass('error float-left')
	   .parents('div.formfield').removeClass('error')
	   .find('div.note').hide();
}