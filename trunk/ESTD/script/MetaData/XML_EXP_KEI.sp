CREATE OR ALTER PROCEDURE XML_EXP_KEI (
    ND_ROOT TYPE OF ID_ELEM NOT NULL,
    I_KEI TYPE OF CODE_KEI NOT NULL)
AS
declare variable V_GROUPKEI_CODE type of CODE_GRPKEI;
declare variable V_KEI_NAME type of NAME_OKP;
declare variable V_KEI_SHORT type of NAME_ATTR;
declare variable V_KEI type of CODE_KEI;
declare variable ND_KEI type of ID_ELEM;
declare variable V_IS_NEW type of VALUE_BOOLEAN;
begin
  for select kei, groupkei_code, kei_name, kei_short
    from kei_okp
    where master_kei = :i_kei
    into :v_kei, :v_groupkei_code, :v_kei_name, :v_kei_short do
  begin
    execute procedure xml_create_elem
      :nd_root, 'KeiList/Kei["'||:v_kei||'"]', :v_kei
      returning_values :nd_kei, :v_is_new;
    if (v_is_new = 1) then
    begin
      execute procedure xml_create_node(:nd_kei, 'Name', :v_kei_name);
      execute procedure xml_create_node(:nd_kei, 'ShortName', :v_kei_short);
      execute procedure xml_create_node(:nd_kei, 'MasterKei', :i_kei);
      execute procedure xml_create_node(:nd_kei, 'GroupKei', :v_groupkei_code);
    end
  end
  execute procedure xml_exp_keigroups(:nd_root, :v_groupkei_code);
end