DELIMITER $$

DROP PROCEDURE IF EXISTS `selectAllButOne` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `selectAllButOne`(in_db_nm varchar(20),in_tbl_nm varchar(20),in_colm_nm varchar(20))
BEGIN

SET @stmnt= CONCAT('SELECT ',(SELECT GROUP_CONCAT(column_name) FROM information_schema.columns WHERE table_name=in_tbl_nm AND table_schema=in_db_nm AND column_name<>in_colm_nm), ' FROM ',in_db_nm,'.',in_tbl_nm,';');
PREPARE stmnt FROM @stmnt;
EXECUTE stmnt;
END $$

DELIMITER ;