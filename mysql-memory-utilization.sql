### MySQL Memory Calculator Procedure
### http://kedar.nitty-witty.com/blog/calculte-mysql-memory-usage-quick-stored-proc
### Kedar Vaijanapurkar
DELIMITER $$

DROP PROCEDURE IF EXISTS `my_memory` $$
CREATE PROCEDURE `my_memory` ()
BEGIN

DECLARE var VARCHAR(100);
DECLARE val VARCHAR(100);
DECLARE done INT;

#Variables for storing calculations
DECLARE GLOBAL_SUM DOUBLE;
DECLARE PER_THREAD_SUM DOUBLE;
DECLARE MAX_CONN DOUBLE;
DECLARE HEAP_TABLE DOUBLE;
DECLARE TEMP_TABLE DOUBLE;

#Cursor for Global Variables

#### For < MySQL 5.1 
#### DECLARE CUR_GBLVAR CURSOR FOR SHOW GLOBAL VARIABLES;

#### For MySQL 5.1+
DECLARE CUR_GBLVAR CURSOR FOR SELECT * FROM information_schema.GLOBAL_VARIABLES;
#### Ref: http://bugs.mysql.com/bug.php?id=49758

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;


SET GLOBAL_SUM=0;
SET PER_THREAD_SUM=0;
SET MAX_CONN=0;
SET HEAP_TABLE=0;
SET TEMP_TABLE=0;

OPEN CUR_GBLVAR;

mylp:LOOP
      FETCH CUR_GBLVAR INTO var,val;
  IF done=1 THEN
    LEAVE mylp;
  END IF;
    IF var in ('key_buffer_size','innodb_buffer_pool_size','innodb_additional_mem_pool_size','innodb_log_buffer_size','query_cache_size') THEN
    #Summing Up Global Memory Usage
      SET GLOBAL_SUM=GLOBAL_SUM+val;
    ELSEIF var in ('read_buffer_size','read_rnd_buffer_size','sort_buffer_size','join_buffer_size','thread_stack','max_allowed_packet','net_buffer_length') THEN
    #Summing Up Per Thread Memory Variables
      SET PER_THREAD_SUM=PER_THREAD_SUM+val;
    ELSEIF var in ('max_connections') THEN
    #Maximum allowed connections
      SET MAX_CONN=val;
    ELSEIF var in ('max_heap_table_size') THEN
    #Size of Max Heap tables created
      SET HEAP_TABLE=val;
    #Size of possible Temporary Table = Maximum of tmp_table_size / max_heap_table_size.
    ELSEIF var in ('tmp_table_size','max_heap_table_size') THEN
      SET TEMP_TABLE=if((TEMP_TABLE>val),TEMP_TABLE,val);
    END IF;

END LOOP;
CLOSE CUR_GBLVAR;
#Summerizing:
select "Global Buffers" as "Parameter",CONCAT(GLOBAL_SUM/(1024*1024),' M') as "Value" union
select "Per Thread",CONCAT(PER_THREAD_SUM/(1024*1024),' M')  union
select "Maximum Connections",MAX_CONN union
select "Total Memory Usage",CONCAT((GLOBAL_SUM + (MAX_CONN * PER_THREAD_SUM))/(1024*1024),' M') union
select "+ Per Heap Table",CONCAT(HEAP_TABLE / (1024*1024),' M') union
select "+ Per Temp Table",CONCAT(TEMP_TABLE / (1024*1024),' M') ;

END $$
DELIMITER ;
