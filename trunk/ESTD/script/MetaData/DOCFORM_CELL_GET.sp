CREATE OR ALTER PROCEDURE DOCFORM_CELL_GET (
    I_DOCFORM TYPE OF SIGN_DOCFORM NOT NULL,
    I_DOCUMENT_ID TYPE OF ID_OBJECT NOT NULL)
RETURNS (
    O_CELL_SIGN TYPE OF SIGN_CELL,
    O_CELL_VALUE TYPE OF VALUE_ATTR)
AS
declare variable V_PARAMTYPE type of SIGN_PARAMTYPE;
declare variable V_PARAM_VALUE type of VALUE_ATTR;
begin
  for select trim(dfp.param_name), trim(dfp.param_type), dfp.param_value
        from docform_params dfp
        where dfp.docform = :i_docform
        into :o_cell_sign, :v_paramtype, :o_cell_value do
  begin
    if (:v_paramtype = 'Q') then
    begin
      o_cell_value = replace(:o_cell_value, ':document_id', :i_document_id);
      execute statement :o_cell_value into :o_cell_value;
    end
    else
    if (:v_paramtype = 'A') then
      select o_attr_value
        from doc_attr_get(:i_document_id, :o_cell_value)
        into :o_cell_value;
    else
    if (:v_paramtype = 'P') then
      select o_param_value
        from param_get(:o_cell_value)
        into :o_cell_value;
    if (:o_cell_value is not null) then
      suspend;
  end
end