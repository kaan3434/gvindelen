var delivery_address = {
	
	toggle_box : function(display){
		box = $('#delivery_address #alternate_box');
		box.css("display",display);
	}
};

$(document).ready(function(){
	$('#delivery_address #choose #default .radio input').bind('click', function(){ delivery_address.toggle_box("none")});
	$('#delivery_address #choose #alternate .radio input').bind('click', function(){ delivery_address.toggle_box("block")});
});