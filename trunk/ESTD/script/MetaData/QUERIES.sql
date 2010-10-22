INSERT INTO QUERIES (QUERY_SIGN, QUERY_TEXT) VALUES ('ALL_OBJECTS_BY_DOCUMENT', 'select
  objects.obj_id,
  objects.objtype,
  objects.kei,
  objects.obj_label,
  objects.obj_code,
  objects.obj_name,
  objects.obj_gost
from
  objects 
where 
  objects.obj_id = :document_id 
or
  objects.obj_id in (
  select documents.refdoc_id
    from documents
  union
  select detinset.detail_id 
    from detinset
      inner join docsets on (detinset.docset_id = docsets.docset_id)
    where docsets.document_id = :document_id
  union
  select operdocs.document_id
    from operdocs
        inner join opers on (operdocs.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
  union
  select operdets.detail_id
    from operdets
        inner join opers on (operdets.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
  union
  select operhalfs.half_id
    from operhalfs
        inner join opers on (operhalfs.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
  union
  select opermats.material_id
    from opermats
        inner join opers on (opermats.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
  union
  select operequips.equip_id
    from operequips
        inner join opers on (operequips.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
  union
  select operinstrs.instr_id
    from operinstrs
        inner join opers on (operinstrs.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
)');
REINSERT ('ALL_DOCUMENTS_BY_DOCUMENT', 'select
  documents.document_id,
  documents.refdoc_id
from
  documents
where
  documents.document_id = :document_id or
  documents.document_id in (
  select documents.refdoc_id
    from documents
  union
  select operdocs.document_id
    from operdocs
        inner join opers on (operdocs.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
)');
REINSERT ('ALL_DETAILS_BY_DOCUMENT', 'select
  details.detail_id
from
  details
where 
  details.detail_id in (
  select detinset.detail_id 
    from detinset
      inner join docsets on (detinset.docset_id = docsets.docset_id)
    where docsets.document_id = :document_id
  union
  select operdets.detail_id
    from operdets
        inner join opers on (operdets.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
)');
REINSERT ('ALL_DOCOPERS_BY_DOCUMENT', 'select
  docopers.docoper_id, 
  docopers.document_id, 
  docopers.oper_num, 
  docopers.oper_name
from 
  docopers 
where 
  docopers.document_id = :document_id');
REINSERT ('ALL_DOCSETS_BY_DOCUMENT', 'select
  docsets.docset_id,
  docsets.document_id,
  docsets.docset_name
from 
  docsets
where 
  docsets.document_id = :document_id');
REINSERT ('LITERA_13_BY_DOCUMENT', 'select
  documents.document_id,
  docopers.oper_num,
  docsets.docset_id,
  opermats.material_id,
  cast(om1.attr_value as numeric(5)) opp,
  coalesce(om2.kei, objects.kei) kei,
  cast(om3.attr_value as numeric(5)) ednor,
  cast(om2.attr_value as numeric(10, 5)) nrash
from
  documents
    inner join docopers on (docopers.document_id = documents.document_id)
    inner join opers on (opers.docoper_id = docopers.docoper_id)
    inner join docsets on (docsets.docset_id = opers.docset_id)
    inner join opermats on (opermats.oper_id = opers.oper_id)
    inner join objects on (objects.obj_id = opermats.material_id)
    left join opermatattrs om1 on (om1.opermat_id = opermats.opermat_id and om1.attr_code=''STORAGE'')
    left join opermatattrs om2 on (om2.opermat_id = opermats.opermat_id and om2.attr_code=''CONSUMPTION_RATE'')
    left join opermatattrs om3 on (om3.opermat_id = opermats.opermat_id and om3.attr_code=''UNITS_RATE'')
where
  documents.document_id = :document_id
order by
  docsets.docset_id, 
  docopers.oper_num, 
  objects.obj_label');
REINSERT ('ALL_MATERIALS_BY_DOCUMENT', 'select
  materials.material_id
from
  materials
where 
  materials.material_id in (
  select opermats.material_id
    from opermats
        inner join opers on (opermats.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
)');
REINSERT ('ALL_EQUIPMENTS_BY_DOCUMENT', 'select
  equipments.equip_id,
  equipments.orgunit_id
from
  equipments
where 
  equipments.equip_id in (
  select operequips.equip_id
    from operequips
        inner join opers on (operequips.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
)');
REINSERT ('ALL_INSTRUMENTS_BY_DOCUMENT', 'select
  instruments.instr_id
from
  instruments
where 
  instruments.instr_id in (
  select operinstrs.instr_id
    from operinstrs
        inner join opers on (operinstrs.oper_id = opers.oper_id)
        inner join docopers on (opers.docoper_id = docopers.docoper_id)
    where docopers.document_id = :document_id
)');
REINSERT ('LITERA_11_BY_DOCUMENT', 'select
  documents.document_id,
  docopers.oper_num,
  docsets.docset_id,
  operdets.detail_id,
  cast(od1.attr_value as numeric(5)) opp,
  coalesce(od2.kei, objects.kei) kei,
  cast(od3.attr_value as numeric(5)) ednor,
  cast(od2.attr_value as numeric(5)) ki
from
  documents
    inner join docopers on (docopers.document_id = documents.document_id)
    inner join opers on (opers.docoper_id = docopers.docoper_id)
    inner join docsets on (docsets.docset_id = opers.docset_id)
    inner join operdets on (operdets.oper_id = opers.oper_id)
    inner join objects on (objects.obj_id = operdets.detail_id)
    left join operdetattrs od1 on (od1.operdet_id = operdets.operdet_id and od1.attr_code=''STORAGE'')
    left join operdetattrs od2 on (od2.operdet_id = operdets.operdet_id and od2.attr_code=''COUNT'')
    left join operdetattrs od3 on (od3.operdet_id = operdets.operdet_id and od3.attr_code=''UNITS_RATE'')
where
  documents.document_id = :document_id
order by
  docsets.docset_id,
  docopers.oper_num,
  objects.obj_label');
REINSERT ('LITERA_34_BY_DOCUMENT', 'select
  documents.document_id,
  docopers.oper_num,
  docsets.docset_id,
  operhalfs.half_id,
  cast(oh1.attr_value as numeric(5)) opp,
  coalesce(oh2.kei, objects.kei) kei,
  cast(oh3.attr_value as numeric(5)) ednor,
  cast(oh2.attr_value as numeric(5)) ki
from
  documents
    inner join docopers on (docopers.document_id = documents.document_id)
    inner join opers on (opers.docoper_id = docopers.docoper_id)
    inner join docsets on (docsets.docset_id = opers.docset_id)
    inner join operhalfs on (operhalfs.oper_id = opers.oper_id)
    inner join objects on (objects.obj_id = operhalfs.half_id)
    left join operhalfattrs oh1 on (oh1.operhalf_id = operhalfs.operhalf_id and oh1.attr_code=''STORAGE'')
    left join operhalfattrs oh2 on (oh2.operhalf_id = operhalfs.operhalf_id and oh2.attr_code=''COUNT'')
    left join operhalfattrs oh3 on (oh3.operhalf_id = operhalfs.operhalf_id and oh3.attr_code=''UNITS_RATE'')
where
  documents.document_id = :document_id
order by
  docsets.docset_id,
  docopers.oper_num,
  objects.obj_label');
REINSERT ('ALL_DETINSETS_BY_DOCUMENT', 'select
  detinset.docset_id,
  detinset.detail_id
from
  detinset
where 
  detinset.docset_id in (
  select docsets.docset_id
    from docsets
    where docsets.document_id = :document_id
)');

COMMIT WORK;

