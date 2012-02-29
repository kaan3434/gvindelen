update orderitem_attrs oia
set oia.attr_value = replace(oia.attr_value, '&amp;', '&')
where oia.attr_value like '%&amp;%';

update orderitems 
set magazine_id = 1
where magazine_id is null;