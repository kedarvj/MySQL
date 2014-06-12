##Give_Me_Dates_Days.sql

DELIMITER $$
DROP function IF EXISTS `Give_Me_Dates_Days` $$
CREATE function `Give_Me_Dates_Days` (in_day int, in_date1 timestamp, in_date2 timestamp) returns varchar(4000) deterministic
BEGIN
    DECLARE tot_dates int;
    DECLARE proc_date timestamp;
    DECLARE dates varchar(4000) default '';
    #1= sunday
    #drop temporary table if exists selecteddates;
    #create temporary table selecteddates ( dates timestamp );
      set proc_date=in_date1;
      while proc_date < in_date2
      do
        if (dayofweek(proc_date)=in_day) then
          set dates=concat(dates,date(proc_date),',');
          #insert into selecteddates values (proc_date);
        end if;
        set proc_date=date_add(proc_date, interval 1 day);
      end while;
      return trim(trailing ',' from dates);
END $$
DELIMITER ;
