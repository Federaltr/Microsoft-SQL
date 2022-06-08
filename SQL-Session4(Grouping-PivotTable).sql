
/* VÝEW */

SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;

CREATE VIEW product_stock AS 
SELECT	A.product_id, A.product_name, B.store_id, B.quantity
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;

SELECT *   --üstteki create view komutu ile istenen tabloyu oluþturduk, alttaki sorguda da bu tablo görünümünü çaðýrdýk.
FROM dbo.product_stock
WHERE store_id = 1
;
--ORDER BY komutunu CREATE VÝEW adlý tabloda kabul etmiyor, dbo.product_stock kullandýðýmýz yukardaki sorgudan sonra ORDER BY kullanýlabilir.

----

-- Maðaza çalýþanlarýný çalýþtýklarý maðaza bilgileriyle birlikte listeleyin
-- Çalýþan adý, soyadý, maðaza adlarýný seçin

SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
ON	A.store_id = B.store_id
;

CREATE VIEW staff_names AS
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
ON	A.store_id = B.store_id
;

SELECT *
FROM dbo.staff_names
;

----

/* GROUP & AGGREGATION */


SELECT *
FROM product.brand
;

SELECT COUNT(*)
FROM product.brand
;

SELECT brand_id, COUNT(*) AS count_of_product  --COUNT(*) ile satýr sayýsýný saydýrabiliyoruz.
FROM product.product
GROUP BY brand_id
;

--Her bir kategorideki toplam ürün sayýsýný yazdýrýnýz.

SELECT category_id, COUNT(*) AS count_of_product
FROM product.product
GROUP BY category_id

--by category_name

SELECT A.category_id, B.category_name, COUNT(*) AS count_of_product
FROM product.product A
JOIN product.category B
ON A.category_id = B.category_id
GROUP BY A.category_id, b.category_name

----

/* HAVÝNG Clause */

--Model yýlý 2016'dan büyük olan ürünlerin liste fiyatlarýnýn ortalamasýnýn 1000'den fazla olanlarý listeleyiniz.

SELECT *
FROM product.product a, product.brand b  --inner join diðer gösterimi.(from --> where)
WHERE a.brand_id = b.brand_id


SELECT b.brand_name, AVG(a.list_price) AS avg_price
FROM product.product a, product.brand b 
WHERE a.brand_id = b.brand_id 
	  AND a.model_year > 2016 
GROUP BY b.brand_name
HAVING AVG(a.list_price) > 1000  --HAVING alias kabul etmiyor fakat
ORDER BY avg_price       --ORDER BY alias kabul ediyor.
;

--Write a query that checks if any product id is repeated in more than one row in the product table.

SELECT product_id, COUNT(product_id) count_of_raw
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1
;


--maximum list_price'ý 4000'in üzerinde olan veya minimum list_price'ý 500'ün altýnda olan category_id' leri getiriniz
--category_name'e gerek yok.

SELECT category_id, MAX(list_price), MIN(list_price)
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR
	   MIN(list_price) < 500
;


--bir sipariþin toplam net tutarýný getiriniz.(müþterinin sipariþ için ödediði tutar)
--discount'ý ve quantity'yi ihmal etmeyiniz.
 
SELECT order_id, SUM(quantity * list_price *(1 - discount)) AS net_price
FROM sale.order_item
GROUP BY order_id

----

/* GROUPING SETS */

--Herbir kategorideki toplam ürün sayýsý
--Herbir model yýlýndaki toplam ürün sayýsý
--Herbir kategorinin model yýlýndaki toplam ürün sayýsý

SELECT category_id, model_year, COUNT(*) count_of_prod
FROM product.product 
GROUP BY 
		GROUPING SETS(
					 (category_id),
					 (model_year),
					 (category_id, model_year)
					 )
--HAVING model_year is null
ORDER BY 1, 2
;

----

/* ROLL UP */

SELECT category_id, model_year, COUNT(*) count_of_prod
FROM product.product 
GROUP BY 
		ROLLUP(category_id, model_year)
;


SELECT category_id, brand_id, model_year, COUNT(*) count_of_prod
FROM product.product 
GROUP BY 
		ROLLUP(category_id,brand_id ,model_year)
;

----

/* CUBE */

SELECT category_id, model_year, COUNT(*) count_of_prod
FROM product.product 
GROUP BY 
		CUBE(category_id, model_year)
;

SELECT category_id, brand_id, model_year, COUNT(*) count_of_prod
FROM product.product 
GROUP BY 
		CUBE(category_id,brand_id ,model_year)
;

----

/* PIVOT */

SELECT model_year, COUNT(*) as total_prod
FROM product.product
GROUP BY model_year

--yukardaki tablonun pivot hali alttaki.
-- model yýllarýna göre toplam ürün sayýsý
SELECT *
FROM
			(
			SELECT product_id, Model_Year
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

--her bir kategorinin model yýllarýna göre toplam ürün sayýsý

SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

--

SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
UNION ALL           --union ve select ile yukardaki sorguya roll updaki gibi toplam deðerleri ekledik.
SELECT NULL, *      --category_id null diðer sütunlarýn toplamý geldi.
FROM
			(
			SELECT Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE






















