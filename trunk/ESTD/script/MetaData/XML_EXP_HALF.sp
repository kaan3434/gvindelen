CREATE OR ALTER PROCEDURE XML_EXP_HALF (
    ND_ROOT TYPE OF ID_ELEM,
    I_HALF_ID TYPE OF ID_OBJECT)
RETURNS (
    O_HALF_LABEL TYPE OF LABEL_OBJECT)
AS
declare variable ND_OBJECT type of ID_ELEM;
declare variable V_OPER_NUM type of NUM_POSITION;
begin
  execute procedure xml_exp_object(:nd_root, :i_half_id)
    returning_values :o_half_label, :nd_object;
  select dop.oper_num
    from halfs h
      inner join docopers dop on (dop.docoper_id = h.docoper_id)
    where h.half_id = :i_half_id
    into :v_oper_num;
  execute procedure xml_create_node(:nd_object, 'DocOper', :v_oper_num);
  suspend;
end