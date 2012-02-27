update orderitem_attrs oia
set oia.attr_value = replace(oia.attr_value, '&amp;', '&')
where oia.attr_value like '%&amp;%';

