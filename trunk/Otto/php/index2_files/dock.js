var dock = {

	pageWidth 	: 965,			//Seitenbreite, um den Mittelpunkt fuer das Dock zu berechnen
	speedUp			:	6,				//Gewschwindigkeit des Docks nach oben
	speedLeft		: 6,				//Gewschwindigkeit des Docks nach links
	waitForUp		:	600,			//Wartezeit, bevor das Dock nach oben faehrt
	waitForLeft	: 200,			//Wartezeit, bevor das Dock nach links faehrt
	waitForStart	: 1000,			//Wartezeit, bevor das Dock startet

	/* Animation starten */
	run_dock : function(){
	  window.setTimeout("dock.run_dock_now()",dock.waitForStart);
	},

	run_dock_now : function(){
	  var layer=$('#dock_animation');
	  if (layer.attr('innerHTML')!='')
	  {
		  layer.css("display","block");
		  layer.css("marginTop",dock.getUpDist());
		  layer.css("marginLeft", dock.getLeftDist(layer));
		  dock.move_up(layer,0);
		}
	},

	close : function(){
	  var layer=$('#dock_animation');
	  if (layer.attr('innerHTML')!='')
	  {
		  layer.css("display","none");
		}
	},

	/* Abstand nach oben */
	getUpDist : function(){
		return $(window).scrollTop() + $(window).height();
	},

	/* Abstand nach links */
	getLeftDist : function(layer){
		return Math.round(dock.pageWidth/2)-Math.round(layer.width()/2);
	},

	/* Nach oben bewegen */
	move_up : function(layer,mTop){
		if (layer)
		{
			if (layer.css("display")=='block')
			{
				layer.css("marginLeft",0);
				timeout = 1;
				/*Erster Durchlauf, 600ms warten*/
				if(mTop==0) {
					mTop = dock.getUpDist();
					//timeout = dock.waitForUp;
				}

				/*Wert setzen und fuer naechsten Durchlauf berechnen*/
				layer.css("marginTop",dock.getUpDist()-layer.height());
				//layer.css("marginTop",mTop);
				//layer.children().css("marginTop",mTop);

				toppos=layer.children().children().css("marginTop").replace('px','');
				toppos-=dock.speedUp;
				if (toppos<0) toppos=0;
				layer.children().children().css("marginTop",toppos+'px');

				if(mTop > 0)
				{

					mTop = mTop - dock.speedUp;
				}

				/*Das Dock wurde weit genug bewegt*/
				if(mTop <= dock.getUpDist()-layer.height()){
					dock.move_left(layer,-10000);
				}
				/*Ansonsten weiterbewegen*/
				else{
	  			window.setTimeout(function(){dock.move_up(layer,mTop);},timeout);
				}
			}
		}
	},

	/* Nach links bewegen */
	move_left : function(layer,mLeft)
	{
		if (layer)
		{
			if (layer.css("display")=='block')
			{
				timeout = 1;
				/*Erster Durchlauf, 200ms warten*/
				if(mLeft==-10000) {
					mLeft = dock.getLeftDist(layer);
					timeout = dock.waitForLeft;
					mLeft = 0;
				}

				/*Wert setzen und fuer naechsten Durchlauf berechnen*/
				layer.css("marginLeft",mLeft);
				if(mLeft > 0){
					mLeft = mLeft - dock.speedLeft;
				}
				/*Dock befindet sich ganz links*/
				else{
					mLeft=0;
	  		}
	  		/*Position des Docks beim Scrollen anpassen*/
	  		layer.css("marginTop",dock.getUpDist()-layer.height());
	  		window.setTimeout(function(){dock.move_left(layer,mLeft);},timeout);
			}
		}
	},

	show_layer : function()
	{
	  loader.show();
	  loader.center();
	}
};


$(document).ready(function(){
	$("body").ready(function(){
		/* Warte 'dock.waitForup' ms, IE kriegt sonst Probleme mit Berechnung der Scrollhoehe*/
		//window.setTimeout("dock.run_dock()",dock.waitForUp);
	});
});