CREATE OR ALTER PROCEDURE REFRESH_SEQ
AS
declare variable MAXID integer;
begin
  select max(attr_id) from detattrs into :maxid;
  maxid = gen_id(s_detattrs, :maxid - gen_id(s_detattrs, 0));

  select max(attr_id) from docattrs into :maxid;
  maxid = gen_id(s_docattrs, :maxid - gen_id(s_docattrs, 0));

  select max(attr_id) from matattrs into :maxid;
  maxid = gen_id(s_matattrs, :maxid - gen_id(s_matattrs, 0));

  select max(obj_id) from objects into :maxid;
  maxid = gen_id(s_objects, :maxid - gen_id(s_objects, 0));

  select max(attr_id) from operdetattrs into :maxid;
  maxid = gen_id(s_operdetattrs, :maxid - gen_id(s_operdetattrs, 0));

  select max(attr_id) from operdocattrs into :maxid;
  maxid = gen_id(s_operdocattrs, :maxid - gen_id(s_operdocattrs, 0));

  select max(attr_id) from operequipattrs into :maxid;
  maxid = gen_id(s_operequipattrs, :maxid - gen_id(s_operequipattrs, 0));

  select max(attr_id) from opermatattrs into :maxid;
  maxid = gen_id(s_opermatattrs, :maxid - gen_id(s_opermatattrs, 0));

  select max(attr_id) from operprofattrs into :maxid;
  maxid = gen_id(s_operprofattrs, :maxid - gen_id(s_operprofattrs, 0));

  select max(oper_id) from opers into :maxid;
  maxid = gen_id(s_opers, :maxid - gen_id(s_opers, 0));

  select max(orgunit_id) from orgunits into :maxid;
  maxid = gen_id(s_orgunits, :maxid - gen_id(s_orgunits, 0));

  select max(prof_id) from professions into :maxid;
  maxid = gen_id(s_professions, :maxid - gen_id(s_professions, 0));

  select max(docset_id) from docsets into :maxid;
  maxid = gen_id(s_docsets, :maxid - gen_id(s_docsets, 0));

  select max(docoper_id) from docopers into :maxid;
  maxid = gen_id(s_docopers, :maxid - gen_id(s_docopers, 0));
end