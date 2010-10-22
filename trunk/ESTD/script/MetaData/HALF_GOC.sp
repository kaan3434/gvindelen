CREATE OR ALTER PROCEDURE HALF_GOC (
    I_DOCUMENT_ID TYPE OF ID_OBJECT,
    I_OPER_NUM TYPE OF NUM_POSITION)
RETURNS (
    O_HALF_ID TYPE OF ID_OBJECT)
AS
declare variable V_HALF_OPER_ID type of ID_OPER;
declare variable V_DOCOPER_ID type of ID_OPER;
declare variable V_DOC_LABEL type of LABEL_OBJECT;
begin
  select dop.docoper_id, o.obj_label
    from docopers dop
      inner join objects o on (dop.document_id = o.obj_id)
    where dop.document_id = :i_document_id
      and dop.oper_num = :i_oper_num
    into :v_docoper_id, :v_doc_label;
  if (row_count = 0) then
    exception docoper_not_found(:i_oper_num);

  select half_id
    from halfs
    where docoper_id = :v_docoper_id
    into :o_half_id;
  if (row_count = 0) then
    execute procedure half_new (v_doc_label||'('||lpad(:i_oper_num, 4, '0')||')',
      'Технологический узел', :v_docoper_id)
      returning_values :o_half_id;
  suspend;
end