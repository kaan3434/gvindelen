CREATE OR ALTER PROCEDURE FORM_NEW (
    I_DOCFORM TYPE OF SIGN_DOCFORM,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_FORM_ID TYPE OF ID_FORM)
AS
declare variable V_FORM_SIZE type of NUM_POSITION;
declare variable V_PAGE_NO type of NUM_POSITION;
begin
  select first 1 f.page_no+1
    from forms f
    where f.document_id = :i_document_id
    order by f.page_no desc
    into :v_page_no;

  if (row_count = 0) then
    v_page_no = 1;

  select f.form_size
    from form_ref f
    where f.docform = :i_docform
      and :v_page_no between f.page_start and f.page_end
    into :v_form_size;

  insert into forms(document_id, page_no, form_size)
    values(:i_document_id, :v_page_no, :v_form_size)
    returning form_id
    into :o_form_id;

  suspend;
end