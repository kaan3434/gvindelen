$(function () {
    if($('#isa_navigation li.active').length) {
		var activeLi = $('#isa_navigation li.active');
		var originalA = $('#isa_navigation li.active>a');
		var originalImg = originalA.children('img');
		var activeA = $('<a style="position:absolute;" href="' + originalA.attr('href') + '"><img class="' + activeLi.attr('id') + '" src="' + originalImg.attr('src').replace(/\.jpg/g, '_aktiv.jpg') + '" /></a>');
		activeA.css({
			left: activeLi.offset().left - (activeLi.css('left') == '0px' ? 0 : 10) + 'px',
			top: activeLi.offset().top + 1 + 'px'
		});
		activeA.mouseenter(function () {
			$(this).hide();
		});
		$('body').append(activeA);
	}
    var openEntryId = null;
    var openEntryTimer = null;

    $('#isa_navigation li.link').hover(function () {
        if (openEntryId != null) {
            clearTimeout(openEntryTimer);
            closeOpenEntry();
        }

        var li = $(this);
        var img = li.find('img');
        var markedImglink = $('<a style="position:absolute;" class="' + li.attr('id') + '" href="' + img.parent('a').attr('href') + '"><img class="' + li.attr('id') + '" src="' + img.attr('src').replace(/\.jpg/g, '_over.jpg') + '" /></a>');
        markedImglink.mouseout(function () {
            openEntryTimer = window.setTimeout(closeOpenEntry, 300);
        });
        markedImglink.css({
            left: li.offset().left - (li.css('left') == '0px' ? 0 : 10) + 'px',
            top: li.offset().top + 1 + 'px'
        });
        $('body').append(markedImglink);

        var ul = li.parent();
        var mainDiv = ul.parent();
        var div = li.find('div.isa_submenue');
        div.css('background-color', li.next('li.point').children('div').css('background-color'));
        div.css({
            left: ul.offset().left + 'px',
            top: ul.offset().top + mainDiv.height() - 1 + 'px'
        });
        $('body').append(div);
        div.show();
        div.hover(function () {
            clearTimeout(openEntryTimer);
        }, function () {
            openEntryTimer = window.setTimeout(closeOpenEntry, 300);
        });
        openEntryId = li.attr('id');
    }, function () {
        if($('#isa_navigation li.active').length)
			activeA.show();
    });

    function closeOpenEntry() {
        $('a.' + openEntryId).remove();
        var div = $('body').children('div.isa_submenue');
        div.hide();
        $('#' + openEntryId).append(div);
        openEntryId = null;
        clearTimeout(openEntryTimer);
    }
});