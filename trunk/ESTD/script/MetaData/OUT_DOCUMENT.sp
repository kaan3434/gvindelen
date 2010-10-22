CREATE OR ALTER PROCEDURE OUT_DOCUMENT (
    I_DOCUMENT_LABEL TYPE OF LABEL_OBJECT NOT NULL,
    I_ORIENTATION TYPE OF SIGN_ORIENTATION NOT NULL = 'L')
RETURNS (
    O_LINES INTEGER)
AS
declare variable V_DOCUMENT_ID type of ID_OBJECT;
declare variable V_DOCFORM type of SIGN_DOCFORM;
begin
  select obj_id, df.docform
    from objects o
      inner join docform_ref df on (df.objtype = o.objtype)
    where o.obj_label = :i_document_label
      and df.orientation = :i_orientation
    into :v_document_id, :v_docform;

  if (row_count = 0) then
    exception unknown_doctype;

  if (:v_docform like '_144') then
    execute procedure out_144(:v_docform, :v_document_id);
  else
  if (:v_docform like '_150') then
    execute procedure out_150(:v_docform, :v_document_id);
  else
    exception unknown_docform(:v_docform);

  execute procedure line_set_group(:v_document_id);

  execute procedure doc_render(:v_docform, :v_document_id);
  execute procedure doc_justify(:v_document_id);

  select count(*)
    from lines
    where document_id = :v_document_id
    into :o_lines;
  suspend;
--    execute statement 'execute procedure out_'||:v_OBJTYPE||'('||v_OBJTYPE||','||v_document_id||')';
end