DELIMITER $$

DROP PROCEDURE IF EXISTS `InsGen` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsGen`(in_db varchar(20),in_table varchar(20),in_file varchar(100))
BEGIN

declare Whrs varchar(500);
declare Sels varchar(500);
declare Inserts varchar(2000);
declare tablename varchar(20);

set tablename=in_table;

# Comma separated column names - used for Select
select group_concat(concat('concat(\'"\',','ifnull(',column_name,','''')',',\'"\')')) INTO @Sels from information_schema.columns where table_schema=in_db and table_name=tablename;

# Comma separated column names - used for Group By
select group_concat('`',column_name,'`') INTO @Whrs from information_schema.columns where table_schema=in_db and table_name=tablename;

#Main Select Statement for fetching comma separated table values
set @Inserts=concat("select concat('insert into ", in_db,".",tablename," values(',concat_ws(',',",@Sels,"),');') from ", in_db,".",tablename," group by ",@Whrs, " INTO OUTFILE '", in_file ,"'");

PREPARE Inserts FROM @Inserts;
EXECUTE Inserts;

END $$

DELIMITER ;