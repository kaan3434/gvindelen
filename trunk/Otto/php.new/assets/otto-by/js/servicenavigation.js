$(document).ready( function() {
	// Wir muesse die Funktion an den Link binden, da 
	// die Listen untereinander verschachtelt sind
	$('#servicenav li > a').bind('mouseover', function() {
		$(this).parent("li").each(function(i) {
			$(this).addClass("activemo");
		});	
	});
	
	$('#servicenav li > a').bind('mouseout', function() {
		$(this).parent("li.activemo").each(function(i){
            $(this).removeClass("activemo");
        });
	});
});