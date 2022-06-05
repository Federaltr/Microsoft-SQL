/* 
bu 
bir 
yorum satýrýdýr.

*/

--çeþitli hatýrlama komutlarý

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

/*SESSÝON 3 FUNCTÝONS */

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

SELECT EOMONTH(GETDATE())  --içinde bulunduðumuz ayýn son tarihi.

SELECT EOMONTH(GETDATE(), 2) --2 ay sonrasýnýn son tarihi.




--Teslimat tarihi ile kargolama/teslimat tarihi arasýndaki gün farkýný bulunuz.

SELECT *, DATEDIFF(DAY, order_date, shipped_date) diff_of_day  --tabloya yeni bir sütun olarak ekledik.
FROM sale.orders

--2 günden fazla zaman geçen sipariþleri bulalým

SELECT *, DATEDIFF(DAY, order_date, shipped_date) diff_of_day 
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

SELECT *            --bu þekilde yazarsak da diff_of_day sütunu gelmez ama condition yine de çalýþýr.
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2




---STRÝNG Functions

--LEN, CHARINDEX, PATINDEX
 
SELECT LEN ('CHARACTER')

SELECT LEN (' CHARACTER') --baþtaki boþluðu karakter olarak algýlýyor. 

SELECT LEN ('CHARACTER ') --sondaki boþluðu karakter olarak algýlamýyor. 

----

SELECT CHARINDEX('R', 'CHARACTER')  --R harfi 'CHARACTER' içerisinde kaçýncý sýrada.

SELECT CHARINDEX('R', 'CHARACTER', 5) --R harfi 'CHARACTER' içerisinde 5.harften sonra kaçýncý sýrada

SELECT CHARINDEX('RA', 'CHARACTER') 

----

--R ile biten stringler.

SELECT PATINDEX('%r', 'CHARACTER')  --büyük/küçük harf duyarlýlýðý yok.

----

SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER', 4)

----

--LEFT, RÝGHT, SUBSTRÝNG

SELECT LEFT('CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)

SELECT SUBSTRING('CHARACTER', 3, 5) --3.karakterden baþla 5 karakter al

SELECT SUBSTRING('CHARACTER', 4, 9)  --4'ten baþla 9 karakter al.

----

--LOWER, UPPER, STRING_SPLIT

SELECT LOWER('CHARACTER')

SELECT UPPER('character')

SELECT *
FROM string_split('jack,martin,alain,owen', ',')

SELECT value as name
FROM string_split('jack,martin,alain,owen', ',')

----

--'character' kelimesinin ilk harfini büyüten bir script yazýnýz.

SELECT UPPER(LEFT('character', 1))
SELECT SUBSTRING('character', 2, 9)  

SELECT UPPER(LEFT('character', 1)) + SUBSTRING('character', 2, 9)  


--tüm sütunlara uygulandýðýnda böyle yapmak daha doðru.
SELECT UPPER(LEFT('character', 1)) + LOWER(SUBSTRING('character', 2, LEN('caharacter')))

SELECT CONCAT (UPPER(LEFT('character', 1)), LOWER(SUBSTRING('character', 2, LEN('character'))))































