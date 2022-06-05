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































