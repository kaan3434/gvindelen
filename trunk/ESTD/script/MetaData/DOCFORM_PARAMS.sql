INSERT INTO DOCFORM_PARAMS (DOCFORM, PARAM_NAME, PARAM_TYPE, PARAM_VALUE) VALUES ('L150', 'mB2F1_1_1', 'V', 'Разраб.');
REINSERT ('L150', 'mB2F1_2_1', 'V', 'Проверил');
REINSERT ('L150', 'mB2F1_3_1', 'V', 'Нормировал');
REINSERT ('L150', 'mB2F1_4_1', 'V', 'Утвердил');
REINSERT ('L150', 'mB2F1_5_1', 'V', 'Н.контр.');
REINSERT ('L150', 'mB2F1_1_2', 'A', 'DEVELOPER');
REINSERT ('L150', 'mB2F1_2_2', 'A', 'INSPECTOR');
REINSERT ('L150', 'mB1F1_2_2', 'Q', 'select o.obj_name from objects o where o.obj_id = :document_id');
REINSERT ('L144', 'mB2F1_1_1', 'V', 'Разраб.');
REINSERT ('L144', 'mB2F1_2_1', 'V', 'Проверил');
REINSERT ('L144', 'mB2F1_3_1', 'V', 'Нормировал');
REINSERT ('L150', 'mB1F1_1_4', 'Q', 'select o.obj_label from objects o where o.obj_id = :document_id');
REINSERT ('L144', 'mB2F1_4_1', 'V', 'Утвердил');
REINSERT ('L144', 'mB2F1_5_1', 'V', 'Н.контр.');
REINSERT ('L144', 'mB2F1_1_2', 'A', 'DEVELOPER');
REINSERT ('L144', 'mB2F1_2_2', 'A', 'INSPECTOR');
REINSERT ('L144', 'mB1F1_2_2', 'Q', 'select o.obj_name from objects o where o.obj_id = :document_id');
REINSERT ('L144', 'mB1F1_1_4', 'Q', 'select o.obj_label from objects o where o.obj_id = :document_id');

COMMIT WORK;

