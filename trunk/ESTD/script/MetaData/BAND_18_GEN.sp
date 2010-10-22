CREATE OR ALTER PROCEDURE BAND_18_GEN (
    I_BLOCK_ID TYPE OF ID_BLOCK,
    I_BAND_SIGN TYPE OF SIGN_BAND)
RETURNS (
    O_BAND_ID TYPE OF ID_BAND)
AS
declare variable V_LINE_ID type of ID_LINE;
declare variable V_DET_NAME type of NAME_OBJECT;
declare variable V_DET_LABELS type of VALUE_ATTR;
declare variable V_DET_NAME_HEAD type of NAME_OBJECT;
declare variable V_DET_LABELS_HEAD type of VALUE_ATTR;
declare variable V_DOCSET_ID type of ID_DOCSET;
begin
  execute procedure param_get('DocSet_Id') returning_values :v_docset_id;
  execute procedure band_new(:i_block_id, :i_band_sign) returning_values :o_band_id;

  select first 1 o.obj_name
    from detinset dis
      inner join objects o on (o.obj_id = dis.detail_id)
    where dis.docset_id = :v_docset_id
    into :v_det_name;

  select list(o.obj_label, '; ')
    from detinset dis
      inner join objects o on (o.obj_id = dis.detail_id)
    where dis.docset_id = :v_docset_id
    group by o.OBJTYPE, o.obj_label
    into :v_det_labels;

  while (1=1) do
  begin
    execute procedure splitstring_cell(:v_det_name, ' ', '18_2')
      returning_values :v_det_name_head, :v_det_name;

    execute procedure splitstring_cell(:v_det_labels, ' ', '18_3')
      returning_values :v_det_labels_head, :v_det_labels;


    execute procedure line_new(:i_block_id, :o_band_id)
      returning_values :v_line_id;

    insert into band_18(line_id, det_name, det_labels)
      values(:v_line_id, :v_det_name_head, :v_det_labels_head);

    if (:v_det_labels is null) then
      break;
  end
end