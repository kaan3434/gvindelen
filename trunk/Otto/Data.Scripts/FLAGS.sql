INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('PERMANENT', '������ �������', 2);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('DELETEABLE', '����� �������', 2);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('DELETED', '� ��������', 2);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('ACTIVE', '�����������', 0);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('PASSIVE', '�� �����������', 0);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('APPROVED', '��������', 1);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('NEW', '�� ��������', 1);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('EDITABLE', '����� ��������', 2);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('AVAILABLE', '��������', 10);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('DELAY', '��������', 11);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('FINISHED', '�����������', 10);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('DEBIT', '�� ������', 12);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('CREDIT', '��� ������', 12);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('BALANCE', '����� �� ������', 12);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('BUSY', '��������������', 14);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('ERROR', '������ ��� ���������', 14);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('SUCCESS', '������� ���������', 14);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('READONLY', '������ �� ������', NULL);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('SENT', '���������', NULL);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('FREE', '���������', 12);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('DRAFT', '��������', NULL);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('INPROCESS', '��������������', NULL);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('PAYED', '��������', NULL);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('APPENDABLE', '�����������', NULL);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('CANCELABLE', '�������� ������ �� ��������', NULL);
INSERT INTO FLAGS (FLAG_SIGN, FLAG_NAME, GROUP_NO) VALUES ('BALANCEABLE', '����� �������������', NULL);

COMMIT WORK;

