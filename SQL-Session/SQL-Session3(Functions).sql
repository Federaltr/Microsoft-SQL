/* 
bu 
bir 
yorum sat�r�d�r.

*/

--�e�itli hat�rlama komutlar�

SELECT *
FROM product.brand


SELECT *
FROM product.brand
WHERE brand_name LIKE 'S%'


SELECT *
FROM product.product
ORDER BY brand_id



SELECT *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year DESC


SELECT TOP 1 *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year 



SELECT *
FROM product.product
WHERE category_id = 3 OR category_id = 4 OR category_id = 5


SELECT *
FROM product.product
WHERE category_id IN (3,4,5)



SELECT *
FROM product.product
WHERE category_id NOT IN (3,4,5)

SELECT *
FROM product.product
WHERE category_id <> 3 AND category_id != 4 AND category_id <> 5

--

SELECT *
FROM product.stock


--

/*SESS�ON 3 FUNCT�ONS */

---DATE Functions

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


SELECT * 
FROM t_date_time


SELECT GETDATE()

SELECT GETDATE() as get_date


INSERT t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())


INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )

SELECT * 
FROM t_date_time


--

--convert date to varchar

SELECT GETDATE()

SELECT CONVERT (VARCHAR(10), GETDATE(), 6)

--varchar to date

SELECT CONVERT(DATE, '04 Jun 22', 6)

SELECT CONVERT(DATETIME, '04 Jun 22', 6)



--Function for return date or time parts

SELECT  A_DATE
		,DAY(A_DATE) DAY_
		,MONTH(A_DATE) [MONTH]
		,DATENAME(DAYOFYEAR, A_DATE) DOY
		,DATEPART(WEEKDAY, A_DATE) WKD
		,DATENAME(MONTH, A_DATE) MON
FROM t_date_time



---DATEDIFF Function

SELECT DATEDIFF(DAY, '2022-05-10', GETDATE())

---DATEADD Function

SELECT DATEADD(DAY, 5,GETDATE())

SELECT DATEADD(MINUTE, 5,GETDATE())

---EOMONTH Function

SELECT EOMONTH(GETDATE())  --i�inde bulundu�umuz ay�n son tarihi.

SELECT EOMONTH(GETDATE(), 2) --2 ay sonras�n�n son tarihi.




--Teslimat tarihi ile kargolama/teslimat tarihi aras�ndaki g�n fark�n� bulunuz.

SELECT *, DATEDIFF(DAY, order_date, shipped_date) diff_of_day  --tabloya yeni bir s�tun olarak ekledik.
FROM sale.orders

--2 g�nden fazla zaman ge�en sipari�leri bulal�m

SELECT *, DATEDIFF(DAY, order_date, shipped_date) diff_of_day 
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

SELECT *            --bu �ekilde yazarsak da diff_of_day s�tunu gelmez ama condition yine de �al���r.
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2




---STR�NG Functions

--LEN, CHARINDEX, PATINDEX
 
SELECT LEN ('CHARACTER')

SELECT LEN (' CHARACTER') --ba�taki bo�lu�u karakter olarak alg�l�yor. 

SELECT LEN ('CHARACTER ') --sondaki bo�lu�u karakter olarak alg�lam�yor. 

----

SELECT CHARINDEX('R', 'CHARACTER')  --R harfi 'CHARACTER' i�erisinde ka��nc� s�rada.

SELECT CHARINDEX('R', 'CHARACTER', 5) --R harfi 'CHARACTER' i�erisinde 5.harften sonra ka��nc� s�rada

SELECT CHARINDEX('RA', 'CHARACTER') 

----

--R ile biten stringler.

SELECT PATINDEX('%r', 'CHARACTER')  --b�y�k/k���k harf duyarl�l��� yok.

----

SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER', 4)

----

--LEFT, R�GHT, SUBSTR�NG

SELECT LEFT('CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)

SELECT SUBSTRING('CHARACTER', 3, 5) --3.karakterden ba�la 5 karakter al

SELECT SUBSTRING('CHARACTER', 4, 9)  --4'ten ba�la 9 karakter al.

----

--LOWER, UPPER, STRING_SPLIT

SELECT LOWER('CHARACTER')

SELECT UPPER('character')

SELECT *
FROM string_split('jack,martin,alain,owen', ',')

SELECT value as name
FROM string_split('jack,martin,alain,owen', ',')

----

--'character' kelimesinin ilk harfini b�y�ten bir script yaz�n�z.

SELECT UPPER(LEFT('character', 1))
SELECT SUBSTRING('character', 2, 9)  

SELECT UPPER(LEFT('character', 1)) + SUBSTRING('character', 2, 9)  


--t�m s�tunlara uyguland���nda b�yle yapmak daha do�ru.
SELECT UPPER(LEFT('character', 1)) + LOWER(SUBSTRING('character', 2, LEN('caharacter')))

SELECT CONCAT (UPPER(LEFT('character', 1)), LOWER(SUBSTRING('character', 2, LEN('character'))))

----

--TRIM Function
--TRIM, LTRIM, RTRIM

SELECT TRIM('  CHARACTER  ')

SELECT LTRIM('  CHARACTER  ')

SELECT RTRIM('  CHARACTER  ')

SELECT TRIM( ' CHAR ACTER ')

SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')  --ba�ka bir �zelli�i de verilen string i�erisinden istenen bir de�eri kald�rabiliyor.
																	  --birden fazla de�er varsa bu �rnekteki gibi de�erlerin s�ras�na bakmadan soldan ve sa�dan de�erleri temizliyor.

SELECT TRIM('X' FROM 'ABCXXDE')   --Ama tek de�er varsa sa�dan ve soldan bu de�ere bak�yor. Yoksa text aynen kal�yor.

----

--REPLACE And STR Function

--REPLACE

SELECT REPLACE('CHAR ACT ER STRING', ' ', '/')  --bo�luk yerine / koyar.

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

--STR  (default olarak 10 karakter ��kt� veriyor.)

SELECT STR (5454)

SELECT STR (2135454654)

SELECT STR (133215.654645, 11, 3)  --11 karakter al virg�lden sonra 3 basamak olsun.

SELECT STR (1234567890123456)  --default 10 oldu�u i�in ��kt� vermedi.

----

--CAST,CONVERT, ROUND, ISNULL Function 

--CAST

SELECT CAST (12345 AS CHAR) 

SELECT CAST (123.65 AS INT)

--CONVERT

SELECT CONVERT(int, 30.60)

SELECT CONVERT(VARCHAR(10), '2020-10-10')

SELECT CONVERT(DATETIME, '2020-10-10' )

SELECT CONVERT(NVARCHAR, GETDATE(), 112 )  --112 de�eri i�in bak(https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16)

SELECT CAST('20201010' AS DATE)

SELECT CONVERT(NVARCHAR, CAST ('20201010' AS DATE), 103 )

--COALESCE,

SELECT NULLIF(10,10)

SELECT NULLIF(10,19)

--ROUND

SELECT ROUND(432.368, 2, 0)
SELECT ROUND(432.368, 2, 1)
SELECT ROUND(432.368, 2)  --Default 0

--ISNULL

SELECT ISNULL(NULL, 'ABC')

SELECT ISNULL('', 'ABC')

--ISNUMERIC

SELECT ISNUMERIC(123)  --parantez i�i numeric ise 1 yani TRUE de�ilse 0 d�nd�r�r.

SELECT ISNUMERIC('a123')

































