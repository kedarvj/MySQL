## http://kedar.nitty-witty.com/blog/stored-procedure-to-add-remove-prefix-by-rename-table-mysql
# How to use: 1. Execute / Create Stored procedure by downloading or copy pasting sql script. 
# 2. Execute: call prefix_all('DATABASE-NAME','PREFIX',0); 
# Where 0 will remove the prefix from mysql table name, while 1 will add prefix. 

DELIMITER $$

DROP PROCEDURE IF EXISTS `prefix_all` $$
CREATE PROCEDURE `prefix_all` (in_db varchar(20),in_prefix varchar(10),in_add_rem TINYINT(1))
BEGIN

DECLARE done INT default 0;
DECLARE tbl_nm VARCHAR(30);
DECLARE ren VARCHAR(200);

DECLARE table_cur CURSOR FOR select table_name from information_schema.tables where table_schema=in_db;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
OPEN table_cur;
  rename_loop:LOOP
    FETCH table_cur INTO tbl_nm;
    IF done=1 THEN
      LEAVE rename_loop;
    END IF;
    if in_add_rem=1 then #ADD
      SET @ren = concat("rename table ", in_db,'.',tbl_nm ," to ",in_db,'.',in_prefix,tbl_nm,";");
    else
      set @ren= concat("rename table ", in_db,'.',tbl_nm ," to ",in_db,'.',right(tbl_nm,length(tbl_nm)-length(in_prefix)),';');
    end if;
#    select @ren;
    prepare ren from @ren;
    execute ren;
  END LOOP;
CLOSE table_cur;
select table_name 'Tables' from information_schema.tables where table_schema=in_db;

END $$

DELIMITER ;