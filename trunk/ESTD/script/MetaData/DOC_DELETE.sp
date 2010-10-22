CREATE OR ALTER PROCEDURE DOC_DELETE (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
begin
  select obj_id
    from objects
    where obj_label = :i_document_label
    into :v_document_id;

  if (row_count = 0) then
    exit;

  delete from docopers
    where document_id = :v_document_id;

  delete from docsets
    where document_id = :v_document_id;

  delete from objects
    where obj_id in (select detail_id from details)
      and obj_id not in (select detail_id from operdets)
      and obj_id not in (select detail_id from detinset);

  delete from objects
    where obj_id in (select half_id from halfs)
      and obj_id not in (select half_id from operhalfs);

  delete from objects
    where obj_id in (select equip_id from equipments)
      and obj_id not in (select equip_id from operequips);

  delete from professions
    where prof_id not in (select prof_id from operprofs);

  delete from objects o
    where obj_id in (select material_id from materials)
      and not exists (select material_id from opermats where o.obj_id = material_id);

  delete from objects o
    where obj_id in (select instr_id from instruments)
      and not exists (select instr_id from operinstrs where o.obj_id = instr_id);

  delete from objects o
    where obj_id in (select document_id from documents)
      and not exists (select * from operdocs where o.obj_id = document_id)
      and not exists (select * from documents where o.obj_id = refdoc_id);

  delete from objects o
    where obj_id in (select document_id from documents)
      and not exists (select * from operdocs where o.obj_id = document_id)
      and not exists (select * from documents where o.obj_id = refdoc_id);

end