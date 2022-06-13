
 
--- SUBQUERIES(NESTED QUERIES) ---

-- In SELECT Clause

SELECT order_id,
	   list_price,
	   (
	   SELECT AVG(list_price)  -- tüm satýrlar için ayný deðer döndü.
	   FROM product.product
	   ) AS avg_price
FROM sale.order_item
;

-- In WHERE Clause

SELECT order_id, order_date
FROM sale.orders
WHERE order_date IN (
	                 SELECT TOP 5 order_date
					 FROM sale.orders
					 ORDER BY order_date DESC
                    )
;

SELECT TOP 5 order_id, order_date  --yukardaki kodla ayný sonuç
FROM sale.orders
ORDER BY order_date  DESC

-- In FROM Clause

SELECT order_id, order_date
FROM	(
		 SELECT TOP 5 *
		 FROM sale.orders
		 ORDER BY order_date DESC
		) A  --Alias olmadan çalýþmýyor eðer tablo tanýmlarsak.
;

----

--Write query that returnsthe total list price by each order ids.

SELECT order_id, SUM(list_price) AS total_price
FROM sale.order_item
GROUP BY order_id
;

--with subquery

SELECT so.order_id,
	   (
	   SELECT SUM(list_price)
	   FROM sale.order_item
	   WHERE order_id = so.order_id
	   ) AS sum_price
FROM sale.order_item so
GROUP BY so.order_id

---

-- Davis Thomas'nýn çalýþtýðý maðazadaki tüm personelleri listeleyin.

SELECT *
FROM sale.staff
WHERE store_id = (
				  SELECT store_id
				  FROM sale.staff
				  WHERE first_name = 'Davis' and last_name = 'Thomas'
				 )
;

----

-- Charles	Cussona 'ýn yöneticisi olduðu personelleri listeleyin.

SELECT *
FROM sale.staff
WHERE first_name = 'Charles' AND last_name = 'Cussona' 

SELECT *
FROM sale.staff 
WHERE manager_id = (
					SELECT staff_id
					FROM sale.staff
					WHERE first_name = 'Charles' AND last_name = 'Cussona' 
					)
;

----

-- 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
-- Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr. 

SELECT *
FROM product.product
WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'


SELECT product_id, product_name, model_year, list_price
FROM product.product
WHERE list_price > (
					SELECT list_price
					FROM product.product
					WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
					)
;

----

--List all customers who orders on the same date as Laurel Goldammer.

SELECT 
FROM sale.orders A
JOIN sale.customer B
ON A.customer_id = B.customer_id
WHERE first_name = 'Laurel' AND last_name = 'Goldammer'

SELECT B.first_name, B.last_name, A.order_date
FROM sale.orders A
JOIN sale.customer B
ON A.customer_id = B.customer_id
WHERE order_date IN
				   (
                    SELECT A.order_date
					FROM sale.orders A
					JOIN sale.customer B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Laurel' AND last_name = 'Goldammer'
				   )
;

----

--List products made in 2021 and their categories other than Game, GPS, or Home Theater.

SELECT A.product_name, A.list_price
FROM product.product A, product.category B
WHERE A.category_id = B.category_id
AND A.model_year = 2021
AND B.category_name NOT IN ('Game', 'GPS', 'Home Theater')

----

-- Model yýlý 2020 olan ve Receivers Amplifiers kategorisindeki en pahalý üründen daha pahalý ürünleri listeleyin.
-- Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.

SELECT TOP 1 *  
FROM product.product A, product.category B
WHERE A.category_id = B.category_id 
	  AND B.category_name = 'Receivers Amplifiers' 
ORDER BY A.list_price DESC

SELECT product_name, model_year, list_price
FROM product.product 
WHERE model_year = 2020
	  AND list_price > (  --Single row subquery
						SELECT TOP 1 A.list_price
						FROM product.product A, product.category B
						WHERE A.category_id = B.category_id 
							  AND B.category_name = 'Receivers Amplifiers' 
						ORDER BY A.list_price DESC
					    )
ORDER BY list_price DESC
;

--Another Solution(Multiple row subquery-(ALL))

select	product_name, model_year, list_price
from	product.product
where	model_year = 2020 and
		list_price > ALL (    --ALL kullandýðýmýzda birden çok satýr döndüren nested ifadedeki her satýrý kontrol eder.
			select	B.list_price
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			         )
order by 3 DESC
;

----

-- Model yýlý 2020 olan ve Receivers Amplifiers kategorisindeki herhangi bir üründen daha pahalý ürünleri listeleyin.
-- Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.

SELECT TOP 1 *
FROM product.product A, product.category B
WHERE A.category_id = B.category_id 
	  AND B.category_name = 'Receivers Amplifiers' 
ORDER BY A.list_price 

SELECT product_name, model_year, list_price
FROM product.product 
WHERE model_year = 2020
	  AND list_price > (  --Single row subquery
						SELECT TOP 1 A.list_price
						FROM product.product A, product.category B
						WHERE A.category_id = B.category_id 
							  AND B.category_name = 'Receivers Amplifiers' 
						ORDER BY A.list_price 
					    )
ORDER BY list_price DESC
;

-- Another Solution(Multiple row subquery-(ANY))

select	product_name, model_year, list_price
from	product.product
where	model_year = 2020 and
		list_price > ANY ( 
			select	B.list_price
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' 
					and	A.category_id = B.category_id
					)
order by 3 DESC
;


--- CTE's (Common Table Expressions) ---








