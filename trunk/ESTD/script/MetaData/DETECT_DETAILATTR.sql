INSERT INTO DETECT_DETAILATTR (OBJTYPE, ATTR_CODE, LABEL_MASK, VALUE_MASK) VALUES ('3', 'MAJOR_VERSION', '_ВЩ___.___', '00');
REINSERT ('3', 'MINOR_VERSION', '_ВЩ___.___', '00');
REINSERT ('3', 'MAJOR_VERSION', '_ВЩ___.___.__', '[12][13]');
REINSERT ('3', 'MINOR_VERSION', '_ВЩ___.___.__', '00');
REINSERT ('3', 'MAJOR_VERSION', '_ВЩ___.___.__.__', '[12][13]');
REINSERT ('3', 'MINOR_VERSION', '_ВЩ___.___.__.__', '[15][16]');
REINSERT ('3', 'MAIN_PART', '_ВЩ___.___', '[1][2][3][4][5][6][7][8][9][10]');
REINSERT ('3', 'MAIN_PART', '_ВЩ___.___.__', '[1][2][3][4][5][6][7][8][9][10]');
REINSERT ('3', 'MAIN_PART', '_ВЩ___.___.__.__', '[1][2][3][4][5][6][7][8][9][10]');
REINSERT ('3', 'MAIN_PART', '_ВЩ___.___.__-__', '[1][2][3][4][5][6][7][8][9][10]');
REINSERT ('3', 'MAJOR_VERSION', '_ВЩ___.___.__-__', '[12][13]');
REINSERT ('3', 'MINOR_VERSION', '_ВЩ___.___.__-__', '00');
REINSERT ('3', 'MAJOR_VERSION_RANGE_START', '_ВЩ___.___;__', '[12][13]');
REINSERT ('3', 'MAJOR_VERSION_RANGE_END', '_ВЩ___.___;__', '[12][13]');
REINSERT ('3', 'MAJOR_VERSION_RANGE_START', '_ВЩ___.___.__;__', '[15][16]');
REINSERT ('3', 'MAJOR_VERSION_RANGE_END', '_ВЩ___.___.__;__', '[15][16]');
REINSERT ('3', 'MAJOR_VERSION_RANGE_START', '_ВЩ___.___;__-__', '[12][13]');
REINSERT ('3', 'MAJOR_VERSION_RANGE_END', '_ВЩ___.___;__-__', '[15][16]');
REINSERT ('3', 'MAJOR_VERSION_RANGE_START', '_ВЩ___.___.__-__', '[12][13]');
REINSERT ('3', 'MAJOR_VERSION_RANGE_END', '_ВЩ___.___.__-__', '[15][16]');

COMMIT WORK;

