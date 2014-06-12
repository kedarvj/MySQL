DELIMITER $$

DROP FUNCTION IF EXISTS `date_to_words` $$
CREATE FUNCTION `date_to_words` (mydate DATE) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN

/* Converts date into words */

DECLARE yr INT;
DECLARE dateval INT;
DECLARE thousand INT;
DECLARE hundred INT;
DECLARE tens INT;

DECLARE tensword VARCHAR(10);
DECLARE onesword VARCHAR(10);
DECLARE thousandsword VARCHAR(20);
DECLARE hundredsword VARCHAR(20);
DECLARE datevalsword VARCHAR(20);

SET yr=year(mydate);
SET dateval=day(mydate);


/* DAY TO WORDS */

SELECT CASE dateval
 WHEN  1 THEN 'First'
 WHEN  2 THEN 'Second'
 WHEN  3 THEN 'Third'
 WHEN  4 THEN 'Fourth'
 WHEN  5 THEN 'Fifth'         
 WHEN  6 THEN 'Sixth'         
 WHEN  7 THEN 'Seventh'
 WHEN  8 THEN 'Eighth'
 WHEN  9 THEN 'Ninth'
 WHEN  10 THEN 'Tenth'
 WHEN  11 THEN 'Eleventh'
 WHEN  12 THEN 'Twelfth'       
 WHEN  13 THEN 'Thirteenth'
 WHEN  14 THEN 'Fourteenth'
 WHEN  15 THEN 'Fifteenth'     
 WHEN  16 THEN 'Sixteenth'     
 WHEN  17 THEN 'Seventeenth'   
 WHEN  18 THEN 'Eighteenth'
 WHEN  19 THEN 'Nineteenth'
 WHEN  20 THEN 'Twentieth'
 WHEN  21 THEN 'Twenty-first'  
 WHEN  22 THEN 'Twenty-second'
 WHEN  23 THEN 'Twenty-third'
 WHEN  24 THEN 'Twenty-fourth' 
 WHEN  25 THEN 'Twenty-fifth'
 WHEN  26 THEN 'Twenty-sixth'
 WHEN  27 THEN 'Twenty-seventh'
 WHEN  28 THEN 'Twenty-eighth'
 WHEN  29 THEN 'Twenty-ninth'
 WHEN  30 THEN 'Thirtieth'
 WHEN  31 THEN 'Thirty-first'
END into datevalsword;


/* YEAR  TO  WORDS */
set thousand=floor(yr/1000) ;
set yr = yr - thousand * 1000;
set hundred = floor(yr / 100);
set yr = yr - hundred * 100;

IF (yr > 19) THEN
set tens = floor(yr / 10);
set yr = yr mod 10;
ELSE
set tens=0;
END IF;

SELECT CASE thousand
 WHEN  1 THEN 'One'
 WHEN  2 THEN 'Two'
 WHEN  3 THEN 'Three'
 WHEN  4 THEN 'Four'
 WHEN  5 THEN 'Five'
 WHEN  6 THEN 'Six'
 WHEN  7 THEN 'Seven'
 WHEN  8 THEN 'Eight'
 WHEN  9 THEN 'Nine'
END INTO thousandsword;
SET thousandsword=concat(thousandsword,' Thousand ');

SELECT CASE hundred
 WHEN 0 then ''
 WHEN  1 THEN 'One'
 WHEN  2 THEN 'Two'
 WHEN  3 THEN 'Three'
 WHEN  4 THEN 'Four'
 WHEN  5 THEN 'Five'
 WHEN  6 THEN 'Six'
 WHEN  7 THEN 'Seven'
 WHEN  8 THEN 'Eight'
 WHEN  9 THEN 'Nine'
END INTO hundredsword;
if (hundredsword<>'') then
SET hundredsword=concat(hundredsword,' Hundred ') ;
else
set hundredsword='';
end if;

/*TENS To WORDS*/
SELECT CASE tens
WHEN 2 THEN 'Twenty'
WHEN 3 THEN 'Thirty'
WHEN 4 THEN 'Fourty'
WHEN 5 THEN 'Fifty'
WHEN 6 THEN 'Sixty'
WHEN 7 THEN 'Seventy'
WHEN 8 THEN 'Eigthy'
WHEN 9 THEN 'Ninety'
ELSE ''
END INTO tensword;


/*ONES To WORDS*/
SELECT CASE yr
 WHEN 0 THEN ''
 WHEN  1 THEN 'One'
 WHEN  2 THEN 'Two'
 WHEN  3 THEN 'Three'
 WHEN  4 THEN 'Four'
 WHEN  5 THEN 'Five'
 WHEN  6 THEN 'Six'
 WHEN  7 THEN 'Seven'
 WHEN  8 THEN 'Eight'
 WHEN  9 THEN 'Nine'
 WHEN  10 THEN 'Ten'
 WHEN  11 THEN 'Eleven'
 WHEN  12 THEN 'Twelve'
 WHEN  13 THEN 'Thirteen'
 WHEN  14 THEN 'Fourteen'
 WHEN  15 THEN 'Fifteen'
 WHEN  16 THEN 'Sixteen'
 WHEN  17 THEN 'Seventeen'
 WHEN  18 THEN 'Eighteen'
 WHEN  19 THEN 'Nineteen'
END into onesword;


return concat(datevalsword, ' Day of ', date_format(mydate,'%M'),' ',thousandsword,hundredsword, tensword,' ',onesword);
END $$

DELIMITER ;