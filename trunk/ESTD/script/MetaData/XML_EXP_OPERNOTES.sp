CREATE OR ALTER PROCEDURE XML_EXP_OPERNOTES (
    ND_OPER TYPE OF ID_ELEM,
    I_OPER_ID TYPE OF ID_OPER)
AS
declare variable V_NOTE blob sub_type 1 segment size 32000;
begin
  for select o.note
   from opernotes o
   where oper_id = :i_oper_id
   into :v_note do
  begin
    execute procedure xml_create_node
      :nd_oper, 'Description', :v_note;
  end
end