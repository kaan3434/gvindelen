CREATE OR ALTER PROCEDURE DOC_ATTR_SET (
    I_DOC_ID TYPE OF ID_OBJECT,
    I_ATTR_CODE TYPE OF SIGN_ATTR,
    I_ATTR_VALUE TYPE OF VALUE_ATTR)
AS
declare variable V_KEI type of CODE_KEI;
BEGIN
  select k.master_kei
    from docattr_ref a inner join kei_okp k on (a.kei = k.kei)
    where attr_code = :i_attr_code
    into :v_kei;

  update or insert into docattrs(document_id, attr_code, kei, attr_value)
    values(:i_doc_id, :i_attr_code, :v_kei, :i_attr_value)
    matching(document_id, attr_code);
END