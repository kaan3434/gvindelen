INSERT INTO BLOCK_RELATE (DOCFORM, BLOCK_PREV, BLOCK_NEXT, BLANK_BAND, IS_COMMON) VALUES ('L144', '18', '25', 0, 1);
REINSERT ('L144', '25', '11', 0, 1);
REINSERT ('L144', '11', '13', 1, 0);
REINSERT ('L144', '13', '25', 1, 0);
REINSERT ('L144', '11', '25', 1, 0);
REINSERT ('L144', '25', '18', 2, 0);
REINSERT ('L144', '25', '13', 1, 1);
REINSERT ('L150', '01', '02', 0, 1);
REINSERT ('L150', '02', '01', 2, 0);
REINSERT ('L150', '02', '15', 1, 0);
REINSERT ('L150', '01', '15', 0, 1);
REINSERT ('L150', '15', '01', 2, 0);
REINSERT ('L150', '15', '19', 1, 0);
REINSERT ('L150', '02', '19', 1, 0);
REINSERT ('L150', '01', '19', 0, 1);
REINSERT ('L150', '19', '01', 2, 0);
REINSERT ('L150', '01', '11', 0, 1);
REINSERT ('L150', '01', '13', 0, 1);
REINSERT ('L150', '11', '13', 1, 0);
REINSERT ('L150', '13', '15', 1, 0);
REINSERT ('L150', '11', '15', 1, 0);
REINSERT ('L150', '11', '19', 1, 0);
REINSERT ('L150', '13', '19', 1, 0);
REINSERT ('L150', '11', '01', 2, 0);
REINSERT ('L150', '02', '13', 1, 0);
REINSERT ('L150', '13', '01', 2, 0);

COMMIT WORK;

