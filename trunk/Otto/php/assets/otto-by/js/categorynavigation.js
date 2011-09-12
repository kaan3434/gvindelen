$(document).ready( function() {
	// Wir muesse die Funktion an den Link binden, da 
	// die Listen untereinander verschachtelt sind
	$('#categorynav li li > a').bind('mouseover', function() {
		$(this).parent("li").each(function(i) {
			$(this).addClass("activemo");
		});	
	});
	
	$('#categorynav li li > a').bind('mouseout', function() {
		$(this).parent("li.activemo").each(function(i){
            $(this).removeClass("activemo");
        });
	});
	
	// Navigation account
	$('#accountnav li > a').bind('mouseover', function() {
		$(this).parent("li").each(function(i) {
			$(this).addClass("activemo");
		});	
	});
	
	$('#accountnav li > a').bind('mouseout', function() {
		$(this).parent("li.activemo").each(function(i){
            $(this).removeClass("activemo");
        });
	});
});